using LINGYUN.Abp.DataProtection.Models;
using LINGYUN.Abp.Demo.Permissions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Volo.Abp;
using Volo.Abp.Application.Dtos;
using Volo.Abp.AspNetCore.Mvc;
using Volo.Abp.Content;
using Volo.Abp.Authorization.Permissions;

namespace LINGYUN.Abp.Demo.Books;

[Controller]
//[Authorize(DemoPermissions.Books.Default)]
//[RequiresPermission(DemoPermissions.Books.Default)]
[RemoteService(Name = DemoRemoteServiceConsts.RemoteServiceName)]
[Area(DemoRemoteServiceConsts.ModuleName)]
[Route($"api/{DemoRemoteServiceConsts.ModuleName}/books")]
public class BookController : AbpControllerBase, IBookAppService
{
    private readonly IBookAppService _service;

    public BookController(IBookAppService service)
    {
        _service = service;
    }

    [HttpPost]
    [Authorize(DemoPermissions.Books.Create)]
    public virtual Task<BookDto> CreateAsync(CreateBookDto input)
    {
        return _service.CreateAsync(input);
    }

    [HttpDelete]
    [Route("{id}")]
    [Authorize(DemoPermissions.Books.Delete)]
    public virtual Task DeleteAsync(Guid id)
    {
        return _service.DeleteAsync(id);
    }

    [HttpPost]
    [Route("import")]
    public virtual Task ImportAsync([FromForm] BookImportInput input)
    {
        return _service.ImportAsync(input);
    }

    [HttpGet]
    [Route("export")]
    public virtual Task<IRemoteStreamContent> ExportAsync(BookExportListInput input)
    {
        return _service.ExportAsync(input);
    }

    [HttpGet]
    [Route("{id}")]
    public virtual Task<BookDto> GetAsync(Guid id)
    {
        return _service.GetAsync(id);
    }

    [HttpGet]
    [Route("lookup")]
    public virtual Task<ListResultDto<AuthorLookupDto>> GetAuthorLookupAsync()
    {
        return _service.GetAuthorLookupAsync();
    }

    [HttpGet]
    public virtual Task<PagedResultDto<BookDto>> GetListAsync(BookGetListInput input)
    {
        return _service.GetListAsync(input);
    }

    [HttpPut]
    [Route("{id}")]
    [Authorize(DemoPermissions.Books.Edit)]
    public virtual Task<BookDto> UpdateAsync(Guid id, UpdateBookDto input)
    {
        return _service.UpdateAsync(id, input);
    }

    [HttpGet]
    [Route("entity")]
    public virtual Task<EntityTypeInfoModel> GetEntityRuleAsync(EntityTypeInfoGetModel input)
    {
        return _service.GetEntityRuleAsync(input);
    }

    [HttpGet("debug/permissions")]
    [Authorize]
    public async Task<IActionResult> DebugPermissions()
    {
        var permissionChecker = LazyServiceProvider.LazyGetRequiredService<IPermissionChecker>();

        var permissions = new[]
        {
            "SettingManagement.Definition",
            "SettingManagement.Definition.Create",
            "Demo.Books",
            "Demo.Books.Create"
            // 添加更多需要检查的权限
        };

        var result = new Dictionary<string, bool>();
        foreach (var permission in permissions)
        {
            result[permission] = await permissionChecker.IsGrantedAsync(permission);
        }

        return Ok(new
        {
            User = User.Identity.Name,
            IsAuthenticated = User.Identity.IsAuthenticated,
            AuthenticationType = User.Identity.AuthenticationType,
            Claims = User.Claims.Select(c => new { c.Type, c.Value }),
            Permissions = result
        });
    }
}
