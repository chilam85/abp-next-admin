docker run -d --name nuget-server -p 5555:80 \
  --env-file /var/baget/baget.env \
  -v /var/baget/baget-data:/var/baget \
  -v/var/baget/appsettings.json:/app/appsettings.json \
  --restart=unless-stopped \
  -e ASPNETCORE_ENVIRONMENT=Production \
  loicsharma/baget:latest

docker cp 028821a4f1a0:/app/appsettings.json /var/baget

docker cp /var/baget/appsettings.json 028821a4f1a0:/app/appsettings.json 

<add key="chilam" value="http://117.72.187.145:5555/v3/index.json" allowInsecureConnections="True" />

dotnet nuget push -s http://117.72.187.145:5555/v3/index.json -k 1q2w3E* LINGYUN.Abp.Claims.Mapping.9.3.6.nupkg
dotnet nuget push -s http://117.72.187.145:5555/v3/index.json -k 1q2w3E* LINGYUN.Abp.Claims.Mapping.9.3.6.snupkg

dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json AlibabaCloud.OpenApiClient 0.2.0 -k 1q2w3E*

dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json AutoMapper 15.1.0 -k 1q2w3E*

dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json Darabonba 1.0.0 -k 1q2w3E*
dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json Microsoft.IdentityModel.Abstractions 8.14.0 -k 1q2w3E*
dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json Microsoft.IdentityModel.JsonWebTokens 8.14.0 -k 1q2w3E*
dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json Microsoft.IdentityModel.Logging 8.14.0 -k 1q2w3E*
dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json Microsoft.IdentityModel.Tokens 8.14.0 -k 1q2w3E*

dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json SixLabors.ImageSharp 3.1.12 -k 1q2w3E*

dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json TencentCloudSDK.Common 3.0.1341 -k 1q2w3E*

dotnet nuget delete -s http://117.72.187.145:5555/v3/index.json TencentCloudSDK.Ocr 3.0.1341 -k 1q2w3E*

find /var/baget/baget-data/packages/packages -type d -empty -delete


https://github.com/chilam85/abp-next-admin/blob/feat/chilam/
aspnet-core/framework/security/LINGYUN.Abp.Claims.Mapping/LINGYUN/Abp/Claims/Mapping/JwtClaimTypesMapping.cs
https://raw.githubusercontent.com/chilam85/abp-next-admin/5bc9ebd004bdc4052f810cb54a7e7680d78eabfd/
aspnet-core/framework/security/LINGYUN.Abp.Claims.Mapping/LINGYUN/Abp/Claims/Mapping/JwtClaimTypesMapping.cs


使用命令 dotnet nuget list source --verbosity detailed 查看当前生效的包源列表。
使用 dotnet restore --verbosity detailed 查看包解析过程，确认包是否按预期从指定源下载。


<?xml version="1.0" encoding="utf-8"?>
<configuration>
	<packageSources>
		<clear />
		<add key="chilam" value="http://117.72.187.145:5555/v3/index.json" allowInsecureConnections="True" />
		<add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
		<!--<add key="elsa2x" value="https://f.feedz.io/elsa-workflows/elsa-2/nuget/index.json" protocolVersion="3" />-->
	</packageSources>
	<packageSourceMapping>
		<packageSource key="chilam">
			<package pattern="LINGYUN.*" />
		</packageSource>
		<!--<packageSource key="elsa2x">
			<package pattern="Elsa" />
			<package pattern="Elsa.*" />
		</packageSource>-->
		<packageSource key="nuget.org">
			<package pattern="*" />
		</packageSource>
	</packageSourceMapping>
</configuration>


C:\Users\Administrator\.nuget\packages\lingyun.abp.claims.mapping\9.3.6
5e6aab10ddb47c3fc54402c46cf3b5a55192f036