using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;

namespace LY.MicroService.Applications.Single.DbMigrator;

public class Program
{
    public async static Task Main(string[] args)
    {
        Log.Logger = new LoggerConfiguration()
            .MinimumLevel.Information()
            .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
            .MinimumLevel.Override("Volo.Abp", LogEventLevel.Warning)
#if DEBUG
                .MinimumLevel.Override("LY.MicroService.Applications.Single.DbMigrator", LogEventLevel.Debug)
#else
                .MinimumLevel.Override("LY.MicroService.Applications.Single.DbMigrator", LogEventLevel.Information)
#endif
                .Enrich.FromLogContext()
            .WriteTo.Console()
            .WriteTo.File("Logs/migrations.txt")
            .CreateLogger();
        await CreateHostBuilder(args).RunConsoleAsync();
    }

    public static IHostBuilder CreateHostBuilder(string[] args)
    {
        return Host.CreateDefaultBuilder(args)
             .AddAppSettingsSecretsJson()
             .ConfigureAppConfiguration((context, builder) =>
             {
                 // 先手动加载基础配置文件（必须在读取前加！）
                 var env = context.HostingEnvironment;
                 builder.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
                 builder.AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true, reloadOnChange: true);

                 // 需要“重新构建”一次 IConfiguration 才能读取刚加的值
                 var tempConfig = builder.Build();
                 var dbProvider = tempConfig["AppVariables:DataBaseProvider"];
                 if (!string.IsNullOrEmpty(dbProvider))
                 {
                     builder.AddJsonFile($"appsettings.{dbProvider}.json", optional: true, reloadOnChange: true);
                 }
             })
            .ConfigureLogging((context, logging) => logging.ClearProviders())
            .ConfigureServices((hostContext, services) =>
            {
                services.AddHostedService<SingleDbMigratorHostedService>();
            });
    }
}
