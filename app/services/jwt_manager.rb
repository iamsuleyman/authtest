class JwtManager
  SECRET_KEY = ENV["SECRET_KEY"]

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" }).first
    HashWithIndifferentAccess.new(decoded_token)
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    nil
  end

  def self.valid_payload?(payload)
    !expired?(payload)
  end

  def self.expired?(payload)
    Time.at(payload["exp"]) < Time.now
  end

  def self.user_id_from_token(token)
    decoded_token = decode(token)
    decoded_token ? decoded_token[:user_id] : nil
  end
end
