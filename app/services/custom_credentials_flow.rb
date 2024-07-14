module CustomCredentialsFlow
  class TokenRequest
    attr_accessor :server, :client_id, :client_secret, :jwt_token, :response

    def initialize(server, client_id, client_secret, jwt_token)
      @server = server
      @client_id = client_id
      @client_secret = client_secret
      @jwt_token = jwt_token
    end

    def authorize
      if find_client && valid_credentials? && create_token && override_token && save_user
        @response = Doorkeeper::OAuth::TokenResponse.new(@token)
      else
        @response = error_response
      end
    end

    def valid?
      response.present? && response.status == :ok
    end

    private

    def decoded_jwt_token
      @decoded_jwt_token ||= JwtManager.decode(jwt_token)
    end

    def find_client
      @client = Doorkeeper::Application.by_uid_and_secret(client_id, client_secret)
      @client.present?
    end

    def find_or_initialize_user
      @user ||= User.find_or_initialize_by(id: decoded_jwt_token["sub"]) do |user|
        user.email = decoded_jwt_token["email"]
        user.password = Devise.friendly_token
      end
    end

    def valid_credentials?
      verifier = RemoteTokenVerifier.new(@client, jwt_token)
      !!decoded_jwt_token && verifier.valid? && !!find_or_initialize_user
    end

    def create_token
      @token = Doorkeeper::AccessToken.create!(
        resource_owner_id: @user.id,
        application_id: @client.id,
        scopes: token_scopes,
        expires_in: Doorkeeper.configuration.access_token_expires_in,
        use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?
      )
    end

    def token_scopes
      @server.parameters[:scope] || Doorkeeper.configuration.default_scopes
    end

    def override_token
      @token.update!(token: jwt_token)
    end

    def save_user
      @user.save
    end

    def error_response
      Doorkeeper::OAuth::ErrorResponse.new(name: :invalid_grant)
    end
  end
end
