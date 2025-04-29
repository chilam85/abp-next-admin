using Microsoft.Extensions.Hosting;
using System.Threading;
using System.Threading.Tasks;
using Volo.Abp.Data;

namespace LY.MicroService.Applications.Single.EntityFrameworkCore.DataSeeder;

/// <summary>
/// LY.MicroService.Applications.Single.DbMigrator跑完还是没有在数据库中看到权限数据
/// LY.MicroService.Application.Single启动时调用了本类的ExecuteAsync生成了大量的权限数据。
/// abp文档说的是如果是abp cli创建的项目框架会自动收集所有的SedeContributor并执行其方法来完成数据初始化。
/// 理论上引用了Identity相关的dll,项目能自动生成相应的权限，那为何没有?是加载顺序导致自动处理时相应dll没有加载引发的？
/// 这里采用在EntityFrameworkCoreModule中注册work的方式解决问题到底是不是正常的做法，
/// DbMigrator是否引入任务模块，引入有点重?不引入DbMigrator不会执行work生成种子数据?
/// 如果是正常做法，为何运行DbMigrator不会执行work生成种子数据，要等到主项目运行才执行work
/// </summary>
public class ApplicationSingleDataSeederWorker : BackgroundService
{
    protected IDataSeeder DataSeeder { get; }

    public ApplicationSingleDataSeederWorker(IDataSeeder dataSeeder)
    {
        DataSeeder = dataSeeder;
    }

    protected async override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        await DataSeeder.SeedAsync();
    }
}
