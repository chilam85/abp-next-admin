FROM mcr.microsoft.com/dotnet/aspnet:9.0
LABEL maintainer="colin.in@foxmail.com"
WORKDIR /app

COPY . /app

## 有些定时作业可能需要建立独立的数据库连接, 可能跨不同的数据库, 配置一下MSSQL
## 解决连接SqlServer TLS版本过高问题
RUN sed -i 's/\[openssl_init\]/# \[openssl_init\]/g' /etc/ssl/openssl.cnf
RUN sed -i '$a\[openssl_init]' /etc/ssl/openssl.cnf
RUN sed -i '$a\providers = provider_sect' /etc/ssl/openssl.cnf
RUN sed -i '$a\ssl_conf = ssl_sect' /etc/ssl/openssl.cnf
 
RUN sed -i '$a\[provider_sect]' /etc/ssl/openssl.cnf
RUN sed -i '$a\default = default_sect' /etc/ssl/openssl.cnf
RUN sed -i '$a\legacy = legacy_sect' /etc/ssl/openssl.cnf
 
RUN sed -i '$a\[default_sect]' /etc/ssl/openssl.cnf
RUN sed -i '$a\activate = 1' /etc/ssl/openssl.cnf
 
RUN sed -i '$a\[legacy_sect]' /etc/ssl/openssl.cnf
RUN sed -i '$a\activate = 1' /etc/ssl/openssl.cnf
 
RUN sed -i '$a\[ssl_sect]' /etc/ssl/openssl.cnf
RUN sed -i '$a\system_default = system_default_sect' /etc/ssl/openssl.cnf
 
RUN sed -i '$a\[system_default_sect]' /etc/ssl/openssl.cnf
RUN sed -i '$a\CipherString = DEFAULT:@SECLEVEL=0' /etc/ssl/openssl.cnf

EXPOSE 80/tcp
VOLUME [ "./app/Logs" ]
VOLUME [ "./app/Modules" ]

#RUN apt update
#RUN apt install wget -y

# 清空所有源，只用阿里云
RUN echo "deb https://mirrors.aliyun.com/debian/ bookworm main" > /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main" >> /etc/apt/sources.list

RUN sed -i 's|https://|http://|g' /etc/apt/sources.list

# 删除 sources.list.d 下所有文件（避免干扰）
RUN rm -f /etc/apt/sources.list.d/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# （可选）升级到 HTTPS 源（现在已有证书）
RUN sed -i 's|http://|https://|g' /etc/apt/sources.list

ENTRYPOINT ["dotnet", "LY.MicroService.TaskManagement.HttpApi.Host.dll"]
