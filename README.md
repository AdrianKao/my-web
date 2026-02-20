# My Web Application

## 项目概述

这是一个基于 Ruby on Rails 8.0.4 构建的Web API应用，类似文章类的应用，提供用户注册、登录、文章发布、评论、点赞等功能。

## 技术栈

### 核心技术
- **Ruby on Rails 8.0.4** - Web 应用框架
- **PostgreSQL** - 关系型数据库
- **Grape** - RESTful API 框架
- **Elasticsearch** - 全文搜索引擎
- **Redis** - 缓存和 Sidekiq 后端
- **Sidekiq** - 异步任务队列
- **JWT** - 无状态认证

### 依赖库
- **bcrypt** - 密码加密
- **jwt** - JWT 令牌生成和验证
- **elasticsearch-model** - Elasticsearch 模型集成
- **sidekiq** - 异步任务处理
- **kaminari** - 分页功能
- **grape-entity** - API 响应格式化

## 目录结构

```
app/
├── api/             # Grape API 框架实现
│   ├── helpers/     # API 辅助方法
│   └── v1/          # API 版本控制
├── models/          # 数据模型
├── services/        # 业务逻辑服务层
├── jobs/            # Sidekiq 异步任务
└── controllers/     # 传统控制器
lib/
└── elasticsearch_client.rb  # Elasticsearch 客户端配置
config/
└── initializers/    # 初始化配置
```

## 主要功能

### 1. 用户系统
- 注册/登录
- JWT 认证
- 密码加密
- Token 自动刷新

### 2. 文章系统
- 文章 CRUD
- 分类管理
- 评论系统
- 全文搜索（Elasticsearch）
- 审核日志

### 3. 话题系统
- 话题管理
- 话题评论

### 4. 互动系统
- 点赞功能
- 消息通知

### 5. 管理员系统
- 后台管理
- 内容审核

## 快速开始

### 前置要求
- Ruby 3.2+
- PostgreSQL 14+
- Redis 7+
- Elasticsearch 8+

### 安装

1. **克隆代码**
   ```bash
   git clone <repository-url>
   cd my-web
   ```

2. **安装依赖**
   ```bash
   bundle install
   ```

3. **配置环境变量**
   ```bash
   # 没有做配置文件抽离，后续可以增加
   # 数据库database.yml
   # sidekiq.yml
   # sidekiq.rb
   # jwt.rb
   # lib/elasticsearch_client.rb
   # util/redis_client.rb
  
   ```

4. **数据库迁移**
   ```bash
   rails db:migrate
   ```

5. **启动服务**
   ```bash
   # 启动 Rails 服务器
   rails s -b 0.0.0.0
   
   # 启动 Sidekiq（在另一个终端）
   sidekiq -C config/sidekiq.yml -e development # 加 -d 后台运行
   ```

6. **Elasticsearch 索引**
   ```bash
   # 创建索引
   rails runner "Article.__elasticsearch__.create_index!"
   
   # 索引所有文章，数据多需分批次
   rails runner "Article.__elasticsearch__.import"
   ```
7. 表关系
   - **用户（Users）**：存储用户信息，包括用户名、邮箱、密码等。
   - **文章（Articles）**：存储文章内容、标题、分类、作者等。
   - **评论（Comments）**：存储文章下的评论内容、作者、关联文章等。
   - **话题（Topics）**：存储话题内容、标题、作者等。
   - **话题评论（TopicComments）**：存储话题下的评论内容、作者、关联话题等。
   - **点赞（Likes）**：存储用户对文章和话题的点赞记录。
   - **分类（Categories）**：存储文章分类信息。
   - **审核日志（ReviewLogs）**：存储文章和话题的审核记录。
   - **文章评论（ArticleComments）**：存储文章下的评论内容、作者、关联文章等。
┌────────────┐       ┌────────────┐       ┌────────────┐
│   users    │───────│  articles  │───────│ categories │
└────────────┘ 1:N   └────────────┘   N:1 └────────────┘
       │                 │
       │                 │
       │ 1:N             │ 1:N
       ▼                 ▼
┌────────────┐       ┌────────────────┐       ┌────────────┐
│  topics    │───────│  review_logs   │───────│   users    │
└────────────┘ 1:N   └────────────────┘   N:1 └────────────┘
       │                        │
       │                        │
       │ 1:N                    │
       ▼                        │
┌────────────────┐       ┌────────────────┐
│ topic_comments │       │ article_comments│
└────────────────┘       └────────────────┘
       │                        │
       │                        │
       └──────────────┬─────────┘
                      │
                      │
                      ▼
              ┌──────────────┐
              │ like_records │
              └──────────────┘
   
  8. 登录jwt认证相关逻辑 
  
### 核心配置
- **JWT_SECRET**：密钥，优先从环境变量读取
- **JWT_ALGORITHM**：加密算法，使用 HS256
- **JWT_EXPIRATION_TIME**：过期时间，24小时
- **JWT_REFRESH_THRESHOLD**：刷新阈值，过期前10分钟

### 认证流程
1. **登录/注册**：验证成功后生成 JWT token
2. **请求认证**：从 Authorization 头提取 token 并验证
3. **Token 刷新**：当 token 快过期时自动刷新

### 关键实现
- **UserService.generate_token()**：生成 JWT token
- **AuthHelper.authenticate_request!()**：验证 token 有效性
- **Base.after** 钩子：处理 token 自动刷新

### 客户端使用
```bash
GET /api/v1/user
Authorization: Bearer <token>
```

### Token 刷新机制
- 当 token 剩余时间小于 10 分钟时
- 响应头会包含新 token：`X-New-Token`
- 客户端应自动更新存储的 token


## API 文档

### 认证

所有需要认证的接口都需要在请求头中添加：
```
Authorization: Bearer <token>
```

### 主要接口

#### 用户相关
- `POST /api/v1/user/login` - 用户登录
- `POST /api/v1/user/register` - 用户注册
- `POST /api/v1/user/logout` - 用户退出
- `GET /api/v1/user` - 获取用户信息
- `POST /api/v1/user/refresh_token` - 刷新 token

#### 文章相关
- `GET /api/v1/article` - 获取文章列表
- `GET /api/v1/article/:id` - 获取文章详情
- `POST /api/v1/article` - 创建文章
- `PUT /api/v1/article/:id` - 更新文章
- `DELETE /api/v1/article/:id` - 删除文章

#### 话题相关
- `GET /api/v1/topic` - 获取话题列表
- `GET /api/v1/topic/:id` - 获取话题详情
- `POST /api/v1/topic` - 创建话题

## 开发指南

### 代码风格
- 使用 RuboCop 进行代码风格检查
- 遵循 Rails 最佳实践


### 日志
- **API 日志**：`log/development.log`
- **Elasticsearch 查询日志**：`log/es_query.log`
- **Sidekiq 日志**：标准输出或配置的日志文件

## 安全特性

- 密码使用 bcrypt 加密
- JWT token 认证
- 参数验证
- 环境变量管理敏感信息

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
