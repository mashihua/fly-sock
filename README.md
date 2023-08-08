
## 免费的美区固定 IP 服务器

本教程教你部署一个免费的美区固定 IP 服务器。fly.io 支持白嫖 3 个免费服务器。

运行 ./run.sh <app> [password] 即可部署一台服务器应用。app 为你的应用名称，password 为你的服务器连接密码。默认为 Seattle, Washington (US)，你可以修改 run.sh 的第 16 行为你想要的 region

在开始部署前，你需要部署初始化设置。首先注册 [fly.io](fly.io) 账号，下载 fly 的命令行 [https://fly.io/docs/hands-on/install-flyctl/](https://fly.io/docs/hands-on/install-flyctl/) 。你也可以按照下面方式自己运行命令来部署。

####  登陆账号 
`fly auth login`

#### 创建一个应用

`fly apps create my-ss`

假设创建一个叫 `my-ss` 的应用

#### 查看有效的服务器 regions 
`fly platform regions`

应用部署在哪个地方

#### 设置应用的 regions 

`fly regions set hkg -a my-ss`

把设置应用在香港区

#### 设置应用的ip

`fly ips allocate-v4 -a my-ss`

#### 设置应用密码

`flyctl secrets set PASSWORD="my-password" -a my-ss`

#### 部署应用

`fly deploy -a my-ss`

#### 查看状态

`fly status -a my-ss`

#### 停止运行应用

`fly scale count 0 -a my-ss`

#### 赞助

赞助一杯咖啡☕️ [https://afdian.net/a/mashihua](爱发电)

#### 加入 AI 群聊

![加入 AI 群聊](wechat.jpg)