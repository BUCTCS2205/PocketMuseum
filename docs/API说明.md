# API说明

## 文物管理

|命令|URL|请求体|状态码|返回体|说明|
|:-|:-|:-|:-|:-|:-|
|GET|api/artifacts|-|200|[`Artifact`]|查询所有文物|
|GET|api/artifacts/`int`|-|200 \| 404|`Artifact`|根据ID查询文物|
|GET|api/artifacts/search?name=`string`|-|200|[`Artifact`]|根据标题模糊查询文物|
|POST|api/artifacts|`Artifact`|201|`Artifact`|插入新文物|
|PUT|api/artifacts/`int`|`Artifact`|204 \| 404|-|根据ID更新文物|
|DELETE|api/artifacts/`int`|-|204 \| 404|-|根据ID删除文物|

## 用户管理

|命令|URL|请求体|状态码|返回体|说明|
|:-|:-|:-|:-|:-|:-|
|GET|api/mobile_users|-|200|[`MobileUser`]|查询所有用户|
|GET|api/mobile_users/`int`|-|200 \| 404|`MobileUser`|根据ID查询用户|
|GET|api/mobile_users/name?name=`string`|-|200 \| 404|`MobileUser`|根据用户名查询用户|
|GET|api/mobile_users/email?email=`string`|-|200 \| 404|`MobileUser`|根据邮箱查询用户|
|POST|api/mobile_users|`MobileUser`|201 \| 409|`MobileUser`|插入新用户|
|PUT|api/mobile_users/`int`|`MobileUser`|200 \| 404 \| 409|`MobileUser`|根据ID更新用户|
|DELETE|api/mobile_users/`int`|-|204 \| 404|-|根据ID删除文物|

## 评论管理

|命令|URL|请求体|状态码|返回体|说明|
|:-|:-|:-|:-|:-|:-|
|GET|api/comments|-|200|[`Comment`]|查询所有评论|
|GET|api/comments/`int`|-|200 \| 404|`Comment`|根据ID查询评论|
|GET|api/comments/artifact/`int`|-|200|[`Comment`]|根据文物ID查询评论|
|GET|api/comments/mobile_user/`int`|-|200|[`Comment`]|根据用户ID查询评论|
|POST|api/comments|`Comment`|201|`Comment`|插入新评论|
|PUT|api/comments/`int`|`Comment`|200 \| 404|`Comment`|根据ID更新评论|
|DELETE|api/comments/`int`|-|204 \| 404|-|根据ID删除评论|

## 收藏管理

|命令|URL|请求体|状态码|返回体|说明|
|:-|:-|:-|:-|:-|:-|
|GET|api/loves|-|200|[`Love`]|查询所有收藏|
|GET|api/loves/artifact/`int`|-|200|[`Love`]|根据文物ID查询收藏|
|GET|api/loves/mobile_user/`int`|-|200|[`Love`]|根据用户ID查询收藏|
|POST|api/loves|`Love`|200|`Love`|插入新收藏|
|PUT|api/loves|`Love`|200 \| 404|`Love`|更新指定收藏|
|DELETE|api/loves|`Love`|204 \| 404|-|删除指定收藏|
