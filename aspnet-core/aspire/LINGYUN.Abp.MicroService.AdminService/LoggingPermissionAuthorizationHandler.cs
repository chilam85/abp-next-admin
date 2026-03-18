using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authorization.Infrastructure;
using Microsoft.Extensions.Logging;
using System.Reflection;
using Volo.Abp.Authorization.Permissions;

namespace LINGYUN.Abp.MicroService.AdminService;

public class LoggingPermissionAuthorizationHandler : AuthorizationHandler<OperationAuthorizationRequirement>
{
    private readonly ILogger<LoggingPermissionAuthorizationHandler> _logger;
    private readonly IPermissionChecker _permissionChecker;

    public LoggingPermissionAuthorizationHandler(
        ILogger<LoggingPermissionAuthorizationHandler> logger,
        IPermissionChecker permissionChecker)
    {
        _logger = logger;
        _permissionChecker = permissionChecker;
    }

    protected override async Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        OperationAuthorizationRequirement requirement)
    {
        // 只处理看起来像权限名的 requirement.Name（如 "Demo.Books"）
        if (string.IsNullOrEmpty(requirement.Name) || !requirement.Name.Contains('.'))
        {
            return; // 不是权限名，交给其他 handler
        }

        _logger.LogWarning(">>> [AUTHZ] Handling permission requirement: {PermissionName}", requirement.Name);

        var hasPermission = await _permissionChecker.IsGrantedAsync(requirement.Name);
        _logger.LogWarning(">>> [AUTHZ] User has permission '{PermissionName}': {HasPermission}",
            requirement.Name, hasPermission);

        if (hasPermission)
        {
            context.Succeed(requirement);
        }
        // 如果失败，不调用 Fail()，让其他 handler 处理或最终 403
    }
}
