module AuthenticateWithJwt
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_with_jwt
  end

  private

  def authenticate_with_jwt
    return render_unauthorized unless decoded_jwt_token

    user_id = decoded_jwt_token["sub"]
    @current_user = User.find_by(id: user_id) # later fix

  rescue ActiveRecord::RecordNotFound
    render_unauthorized
  end

  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def decoded_jwt_token
    @decoded_jwt_token ||= begin
      token = extract_jwt_token
      decoded_token = JwtManager.decode(token)
      return nil if !decoded_token || !JwtManager.valid_payload?(decoded_token)
      decoded_token
    end
  end

  def extract_jwt_token
    request.headers["Authorization"]&.split(" ")&.last
  end
end
