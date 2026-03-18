using LINGYUN.Abp.MicroService.ServiceDefaults;
using LINGYUN.Abp.MicroService.TaskService;
using LINGYUN.Abp.Serilog.Enrichers.Application;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Serilog;
using System;
using System.IO;
using Volo.Abp.IO;
using Volo.Abp.Modularity.PlugIns;

try
{
    Log.Information("Starting TaskService Host...");

    var builder = WebApplication.CreateBuilder(args);
    builder.Host.AddAppSettingsSecretsJson()
        .UseAutofac()
        .ConfigureAppConfiguration((context, config) =>
        {
            if (context.Configuration.GetValue("AgileConfig:IsEnabled", false))
            {
                config.AddAgileConfig(new AgileConfig.Client.ConfigClient(context.Configuration));
            }
        })
        .UseSerilog((context, provider, config) =>
        {
            config.ReadFrom.Configuration(context.Configuration);
        });

    //在构建阶段（service registration）添加一组“默认服务配置”。
    //这通常包含日志、认证、默认的健康检查配置等——它是注册服务/中间件的地方，不直接创建 HTTP 路由。
    //具体行为取决于该扩展方法的实现。
    builder.AddServiceDefaults();
    //明确在 DI/HealthChecks 系统中注册一个自定义的健康检查实现（这里是 ServiceHealthCheck），
    //并给它一个名字 "Service"。这是“注册检查项”，不负责映射 URL。
    builder.AddCustomHealthChecks<ServiceHealthCheck>("Service");
    
    await builder.AddApplicationAsync<TaskServiceModule>(options =>
    {
        var applicationName = Environment.GetEnvironmentVariable("APPLICATION_NAME") ?? "TaskService";
        AbpSerilogEnrichersConsts.ApplicationName = applicationName;
        options.ApplicationName = applicationName;

        var pluginFolder = Path.Combine(Directory.GetCurrentDirectory(), "Modules");
        DirectoryHelper.CreateIfNotExists(pluginFolder);
        options.PlugInSources.AddFolder(pluginFolder, SearchOption.AllDirectories);
    });

    var app = builder.Build();

    await app.InitializeApplicationAsync();

    //在应用启动阶段（endpoint mapping）把一组默认的端点路由映射到 HTTP（例如默认的 health、metrics、swagger 路由等），
    //是把已注册的功能暴露为 URL。具体哪些端点会被映射取决于该扩展方法实现。
    app.MapDefaultEndpoints();
    //将自定义健康检查映射到指定路径（/health/service），
    //也就是把之前在 AddCustomHealthChecks<THealthCheck>(this IHostApplicationBuilder, string, string) 注册的检查暴露为 HTTP 端点。
    app.MapCustomHealthChecks("/health/service");

    app.UseForwardedHeaders();
    app.UseAbpRequestLocalization();
    app.MapAbpStaticAssets();
    app.UseCorrelationId();
    app.UseRouting();
    app.UseCors();
    app.UseAuthentication();
    app.UseJwtTokenMiddleware();
    app.UseMultiTenancy();
    app.UseDynamicClaims();
    app.UseAuthorization();
    app.UseSwagger();
    app.UseAbpSwaggerUI(options =>
    {
        options.SwaggerEndpoint("/swagger/v1/swagger.json", "Support Task Service API");

        var configuration = app.Configuration;
        options.OAuthClientId(configuration["AuthServer:SwaggerClientId"]);
        options.OAuthScopes(configuration["AuthServer:Audience"]);
    });
    app.UseAuditing();
    app.UseAbpSerilogEnrichers();
    app.UseConfiguredEndpoints();

    await app.RunAsync();
}
catch (Exception ex)
{
    if (ex is HostAbortedException)
    {
        throw;
    }

    Log.Fatal(ex, "Host terminated unexpectedly!");
}
finally
{
    await Log.CloseAndFlushAsync();
}