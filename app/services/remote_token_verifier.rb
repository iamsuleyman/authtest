class RemoteTokenVerifier
  require "net/http"

  def initialize(token)
    @token = token
    @uri = URI.parse("http://localhost:3000/oauth/token/info")
  end

  def valid?
    response.code == "200"
  end

  def user_info
    JSON.parse(response.body) if valid?
  end

  private

  def response
    @response ||= begin
      http = Net::HTTP.new(@uri.host, @uri.port)
      # http.use_ssl = @uri.scheme == "https"
      request = Net::HTTP::Get.new(@uri.request_uri)
      request["Authorization"] = "Bearer #{@token}"
      http.request(request)
    end
  end
end
