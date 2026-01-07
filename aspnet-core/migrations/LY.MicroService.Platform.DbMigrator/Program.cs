using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using Serilog.Events;
using System.Diagnostics;

namespace LY.MicroService.Platform.DbMigrator;

public class Program
{
    public async static Task Main(string[] args)
    {
        Log.Logger = new LoggerConfiguration()
            .MinimumLevel.Information()
            .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
            .MinimumLevel.Override("Volo.Abp", LogEventLevel.Warning)
#if DEBUG
                .MinimumLevel.Override("LY.MicroService.Platform", LogEventLevel.Debug)
#else
                .MinimumLevel.Override("LY.MicroService.Platform", LogEventLevel.Information)
#endif
                .Enrich.FromLogContext()
            .WriteTo.Console(outputTemplate: "{Timestamp:yyyy-MM-dd HH:mm:ss} [{Level:u3}] [{SourceContext}] [{ProcessId}] [{ThreadId}] - {Message:lj}{NewLine}{Exception}")
            .WriteTo.File("Logs/migrations.txt")
            .CreateLogger();

        await CreateHostBuilder(args).RunConsoleAsync();
    }

    public static IHostBuilder CreateHostBuilder(string[] args)
    {
        var builder = Host.CreateDefaultBuilder(args)
            .AddAppSettingsSecretsJson()
            .ConfigureServices((hostContext, services) =>
            {
                services.AddHostedService<PlatformDbMigratorHostedService>();
            });
        // 打印工作目录和配置文件路径
        Debug.WriteLine($"Current Directory: {Directory.GetCurrentDirectory()}");
        Console.WriteLine($"Current Directory: {Directory.GetCurrentDirectory()}");
        return builder;
    }
}
