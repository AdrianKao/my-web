module Helpers
  module AuthHelper
    def authenticate_request!
      token = extract_token
      if !token
        error!("\u7F3A\u5C11\u8BA4\u8BC1token", 401)
      end

      begin
        decoded = JWT.decode(token, JWT_SECRET, true, algorithm: JWT_ALGORITHM)
        @current_user_id = decoded[0]["user_id"]
        @token_payload = decoded[0]
      rescue JWT::ExpiredSignature
        error!("token\u5DF2\u8FC7\u671F", 401)
      rescue JWT::DecodeError
        error!("\u65E0\u6548\u7684token", 401)
      end
    end

    def current_user
      @current_user ||= User.find_by(id: @current_user_id)
    end

    def token_needs_refresh?
      return false unless @token_payload
      exp = Time.at(@token_payload["exp"])
      exp < Time.now + JWT_REFRESH_THRESHOLD
    end

    def generate_new_token
      UserService.generate_token(@current_user_id)
    end

    private

    def extract_token
      header = headers["Authorization"]
      return nil unless header
      header.split(" ").last
    end
  end
end
