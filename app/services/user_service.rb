# app/services/user_service.rb
class UserService
  def self.login(username, password)
    user = ::User.find_by(username: username)

    if user&.authenticate(password)
      token_data = generate_token(user.id)
      {
        success: true,
        message: "\u767B\u5F55\u6210\u529F",
        data: {
          token: token_data[:token],
          expires_at: token_data[:expires_at],
          user_id: user.id
        }
      }
    else
      { success: false, message: "\u7528\u6237\u540D\u6216\u5BC6\u7801\u9519\u8BEF" }
    end
  end

  def self.register(params)
    user = ::User.create_user(params)

    if user.persisted?
      token_data = generate_token(user.id)
      {
        success: true,
        message: "\u6CE8\u518C\u6210\u529F",
        data: {
          user_id: user.id,
          token: token_data[:token],
          expires_at: token_data[:expires_at]
        }
      }
    else
      { success: false, message: user.errors.full_messages.join(", ") }
    end
  end

  def self.get_user_info(user_id)
    user = ::User.find_by(id: user_id)
    if user
      { success: true, message: "\u83B7\u53D6\u7528\u6237\u4FE1\u606F\u6210\u529F", data: { id: user.id, name: user.username, email: user.email } }
    else
      { success: false, message: "\u7528\u6237\u4E0D\u5B58\u5728" }
    end
  end

  def self.generate_token(user_id)
    payload = {
      user_id: user_id,
      exp: JWT_EXPIRATION_TIME.to_i,
      iat: Time.now.to_i
    }

    token = JWT.encode(payload, JWT_SECRET, JWT_ALGORITHM)

    {
      token: token,
      expires_at: JWT_EXPIRATION_TIME
    }
  end

  def self.decode_token(token)
    begin
      decoded = JWT.decode(token, JWT_SECRET, true, algorithm: JWT_ALGORITHM)
      { success: true, payload: decoded[0] }
    rescue JWT::ExpiredSignature
      { success: false, message: "token\u5DF2\u8FC7\u671F" }
    rescue JWT::DecodeError
      { success: false, message: "\u65E0\u6548\u7684token" }
    end
  end
end
