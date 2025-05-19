# PocketMuseum

## 软件工程课程设计：掌上博物馆

![os](https://img.shields.io/badge/OS-Harmony-blue)
![language](https://img.shields.io/badge/Language-ArkTS-orange)
[![license](https://img.shields.io/badge/License-MIT-green)](LICENSE)

### 功能简介

手机端鸿蒙App，主要支持文物展示、用户交互等功能。爬取博物馆网站的信息作为本程序的展示内容，例如瓷器、玉器、青铜器或中国画等。主要包括以下功能：

1. **文物浏览**：显示文物的基本信息和图片，可以进行按照关键字搜索的简单搜索。
2. **用户交互**：用户可以对单个文物点赞、留言评论功能，保存最近的浏览记录。
3. **以图搜图**：可以上传图片或直接拍摄一个照片，根据上传图片特征搜索相关文物。
4. **用户个人信息管理**：用户可以注册登录该系统，设置用户名、密码和头像等个人信息。

### 项目结构

* `BackendService`目录为部署在云端服务器上的Web API服务程序项目，由ASP.NET Core构建。服务程序和数据库部署在同一个服务器上，[表结构](docs/表结构说明.md)、[实体类](docs/实体类说明.md)和[API](docs/API说明.md)等说明详见`docs`目录。

* `PocketMuseum`目录为面向Harmony OS的移动端掌上博物馆应用，使用ArkTS语言和ArkUI组件开发。
