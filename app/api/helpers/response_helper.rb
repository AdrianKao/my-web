module Helpers
  module ResponseHelper
    # 成功响应
    def success(data = nil, message = "\u64CD\u4F5C\u6210\u529F")
      {
        code: 200,
        message: message,
        data: data
      }
    end

    # 失败响应
    def error(code = 400, message = "\u64CD\u4F5C\u5931\u8D25")
      {
        code: code,
        message: message,
        data: nil
      }
    end

    # 未授权响应
    def unauthorized(message = "\u672A\u6388\u6743")
      {
        code: 401,
        message: message,
        data: nil
      }
    end

    # 禁止访问响应
    def forbidden(message = "\u7981\u6B62\u8BBF\u95EE")
      {
        code: 403,
        message: message,
        data: nil
      }
    end

    # 资源不存在响应
    def not_found(message = "\u8D44\u6E90\u4E0D\u5B58\u5728")
      {
        code: 404,
        message: message,
        data: nil
      }
    end

    # 服务器错误响应
    def server_error(message = "\u670D\u52A1\u5668\u5185\u90E8\u9519\u8BEF")
      {
        code: 500,
        message: message,
        data: nil
      }
    end

    # 分页响应
    def paginated_success(data, pagination, message = "\u64CD\u4F5C\u6210\u529F")
      {
        code: 200,
        message: message,
        data: data,
        pagination: pagination
      }
    end
  end
end
