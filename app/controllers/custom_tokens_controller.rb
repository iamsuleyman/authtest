class CustomTokensController < Doorkeeper::TokensController
  include AuthenticateWithJwt

  def create
    case params[:grant_type]
    when "custom_credentials"
      token_request = custom_grant_flow_request
      token_request.authorize

      render json: token_request.response.body, status: token_request.response.status
    else
      super
    end
  end

  private

  def custom_grant_flow_request
    CustomCredentialsFlow::TokenRequest.new(
      server,
      params[:client_id],
      params[:client_secret],
      extract_jwt_token
    )
  end
end
