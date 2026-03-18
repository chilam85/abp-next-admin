using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using System;
using System.Linq;
using System.Threading.Tasks;
using Volo.Abp;
using Volo.Abp.Authorization.Permissions;
using Volo.Abp.Data;
using Volo.Abp.DependencyInjection;
using Volo.Abp.MultiTenancy;
using Volo.Abp.PermissionManagement;

namespace LINGYUN.Abp.MicroService.AdminService;
public class AdminServiceDataSeeder : ITransientDependency
{
    protected ILogger<AdminServiceDataSeeder> Logger { get; }
    protected ICurrentTenant CurrentTenant { get; }
    protected IPermissionDefinitionManager PermissionDefinitionManager { get; }
    protected IPermissionDataSeeder PermissionDataSeeder { get; }

    private readonly IAbpApplication _abpApplication;

    public AdminServiceDataSeeder(
        IPermissionDefinitionManager permissionDefinitionManager,
        IPermissionDataSeeder permissionDataSeeder,
        ICurrentTenant currentTenant,
        IAbpApplication abpApplication
        )
    {
        PermissionDefinitionManager = permissionDefinitionManager;
        PermissionDataSeeder = permissionDataSeeder;
        CurrentTenant = currentTenant;

        Logger = NullLogger<AdminServiceDataSeeder>.Instance;
        _abpApplication = abpApplication;
    }

    public virtual async Task SeedAsync(DataSeedContext context)
    {
        using (CurrentTenant.Change(context.TenantId))
        {
            await SeedAdminRolePermissionsAsync(context);
        }
    }

    private async Task SeedAdminRolePermissionsAsync(DataSeedContext context)
    {
        Logger.LogInformation("Seeding the default role permissions...");

        //foreach (var module in _abpApplication.Modules)
        //{
        //    Console.WriteLine($"Loaded Module: {module.Type.FullName}");
        //    Console.WriteLine($"  Assembly: {module.Type.Assembly.GetName().Name}");
        //}
        Console.WriteLine($"Loaded Modules count: {_abpApplication.Modules.Count}");
        var multiTenancySide = CurrentTenant.GetMultiTenancySide();
        var permissions = await PermissionDefinitionManager.GetPermissionsAsync();
        var permissionNames = permissions//(await PermissionDefinitionManager.GetPermissionsAsync())
            .Where(p => p.MultiTenancySide.HasFlag(multiTenancySide))
            .Where(p => !p.Providers.Any() || p.Providers.Contains(RolePermissionValueProvider.ProviderName))
            .Select(p => p.Name)
            .ToArray();

        await PermissionDataSeeder.SeedAsync(
            RolePermissionValueProvider.ProviderName,
            "admin",
            permissionNames,
            context?.TenantId
        );

        Logger.LogInformation("Seed default role permissions completed.");
    }
}
