using LINGYUN.Abp.DataProtection;
using LINGYUN.Abp.Demo.Permissions;
using LINGYUN.Abp.Exporter;
using Volo.Abp.Application;
using Volo.Abp.Authorization;
using Volo.Abp.Modularity;
//using Volo.Abp.PermissionManagement; // 添加此 using 指令以修复 CS0246

namespace LINGYUN.Abp.Demo;

[DependsOn(
    //typeof(AbpAuthorizationModule),
    typeof(AbpDataProtectionAbstractionsModule),
    typeof(AbpExporterApplicationContractsModule),
    typeof(AbpAuthorizationAbstractionsModule),
    typeof(AbpDddApplicationContractsModule),
    typeof(AbpDemoDomainSharedModule))]
public class AbpDemoApplicationContractsModule : AbpModule
{
    //public override void ConfigureServices(ServiceConfigurationContext context)
    //{
    //    Configure<PermissionOptions>(options =>
    //    {
    //        options.DefinitionProviders.Add<DemoPermissionDefinitionProvider>();
    //    });
    //}
}
