# LINGYUN.Abp.Authentication.WeChat

微信公众号认证模块，集成微信公众号登录功能到ABP应用程序。

## 功能特性

* 微信公众号OAuth2.0认证
* 支持获取微信用户基本信息（昵称、性别、地区、头像等）
* 支持UnionId机制，打通公众号与小程序账号体系
* 支持微信服务器消息验证
* 支持与ABP身份系统集成

## 模块引用

```csharp
[DependsOn(typeof(AbpAuthenticationWeChatModule))]
public class YouProjectModule : AbpModule
{
  // other
}
```

## 配置项

```json
{
  "Authentication": {
    "WeChat": {
      "AppId": "你的微信公众号AppId",
      "AppSecret": "你的微信公众号AppSecret",
      "ClaimsIssuer": "WeChat", // 可选，默认为 WeChat
      "CallbackPath": "/signin-wechat", // 可选，默认为 /signin-wechat
      "Scope": ["snsapi_login", "snsapi_userinfo"], // 可选，默认包含 snsapi_login 和 snsapi_userinfo
      "QrConnect": {
        "Enabled": false, // 是否启用PC端扫码登录
        "Endpoint": "https://open.weixin.qq.com/connect/qrconnect" // PC端扫码登录地址
      }
    }
  }
}
```

## 基本用法

1. 配置微信公众号参数
   * 在微信公众平台申请公众号，获取AppId和AppSecret
   * 在appsettings.json中配置AppId和AppSecret

2. 添加微信登录
   ```csharp
   public override void ConfigureServices(ServiceConfigurationContext context)
   {
       context.Services.AddAuthentication()
           .AddWeChat(); // 添加微信登录支持
   }
   ```

3. 启用微信服务器消息验证（可选）
   ```csharp
   public void Configure(IApplicationBuilder app)
   {
       app.UseWeChatSignature(); // 启用微信服务器消息验证中间件
   }
   ```

## 获取的用户信息

* OpenId - 微信用户唯一标识
* UnionId - 微信开放平台唯一标识（需要绑定开放平台）
* NickName - 用户昵称
* Sex - 用户性别
* Country - 国家
* Province - 省份
* City - 城市
* AvatarUrl - 用户头像URL
* Privilege - 用户特权信息

## 更多信息

* [微信公众平台开发文档](https://developers.weixin.qq.com/doc/offiaccount/Getting_Started/Overview.html)
* [ABP认证文档](https://docs.abp.io/en/abp/latest/Authentication)

微信开放平台变动很大，例如可获取信息变少，可参考下面链接。
https://developers.weixin.qq.com/doc/service/guide/h5/auth.html

微信网页授权（微信客户端中访问第三方网页）
如果用户在微信客户端中访问第三方网页，服务号可以通过微信网页授权机制，来获取用户基本信息，进而实现业务逻辑。

（微信）网页授权仅支持已认证的服务号，其他类型的账号（公众号/小程序/网站应用/移动应用等除了已认证服务号之外的账号）均不支持使用微信网页授权登录功能。

总结：公众号原本包含订阅号和服务号，现已被拆分为独立的公众号（原订阅号）和服务号。
微信app内访问第三方网页，需要开通服务号并查看服务号相关的开发文档。

网站应用微信登录开发指南
准备工作
网站应用微信登录是基于OAuth2.0协议标准构建的微信OAuth2.0授权登录系统。 在进行微信OAuth2.0授权登录接入之前，在微信开放平台注册开发者账号，并拥有一个已审核通过的网站应用，并获得相应的AppID和AppSecret，申请微信登录且通过审核后，可开始接入流程。
https://developers.weixin.qq.com/doc/oplatform/Website_App/WeChat_Login/Wechat_Login.html

