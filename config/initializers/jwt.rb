# JWT 密钥：优先从环境变量读取，若未设置则使用默认值（仅用于开发环境）
JWT_SECRET = ENV.fetch("JWT_SECRET") { "your-secret-key-change-in-production" }

# JWT 加密算法
JWT_ALGORITHM = "HS256"

# JWT 过期时间：签发后 24 小时失效
JWT_EXPIRATION_TIME = 24.hours.from_now

# JWT 刷新阈值：在过期前 10 分钟内触发刷新机制
JWT_REFRESH_THRESHOLD = 10.minutes
