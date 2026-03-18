using LINGYUN.Abp.DataProtection;
using LINGYUN.Abp.Demo.Permissions;
using LINGYUN.Abp.Exporter;
using Microsoft.Extensions.DependencyInjection;
using Volo.Abp.Application;
using Volo.Abp.Modularity;
//using Volo.Abp.PermissionManagement;

namespace LINGYUN.Abp.Demo;

[DependsOn(
    typeof(AbpDddApplicationModule),
    typeof(AbpDataProtectionModule),
    typeof(AbpDemoDomainModule),
    typeof(AbpExporterApplicationModule),
    typeof(AbpDemoApplicationContractsModule))]
public class AbpDemoApplicationModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        context.Services.AddMapperlyObjectMapper<AbpDemoApplicationModule>();
        //Configure<PermissionOptions>(options =>
        //{
        //    options.DefinitionProviders.Add<DemoPermissionDefinitionProvider>();
        //});
    }
}
