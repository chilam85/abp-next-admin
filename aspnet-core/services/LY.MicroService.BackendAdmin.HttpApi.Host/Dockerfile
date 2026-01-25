FROM mcr.microsoft.com/dotnet/aspnet:9.0
LABEL maintainer="colin.in@foxmail.com"
WORKDIR /app

COPY . /app

EXPOSE 80/tcp
VOLUME [ "./app/Logs" ]
VOLUME [ "./app/Modules" ]

#如果不替换源，依赖外网的指令全都执行失败，这里要替换源
#docker配置的代理构建镜像时没用

# RUN apt update
# RUN apt install wget -y

# 确保 sources.list 存在（兼容所有子版本）
# RUN if [ ! -f /etc/apt/sources.list ]; then \
#         echo "deb http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list && \
#         echo "deb http://deb.debian.org/debian-security bookworm-security main" >> /etc/apt/sources.list && \
#         echo "deb http://deb.debian.org/debian bookworm-updates main" >> /etc/apt/sources.list; \
#     fi

# 全局替换所有 apt 源中的 deb.debian.org 为 mirrors.aliyun.com
# RUN find /etc/apt -name "*.list" -exec sed -i 's|http://deb.debian.org|https://mirrors.aliyun.com|g' {} \; && \
#     find /etc/apt -name "*.list" -exec sed -i 's|https://deb.debian.org|https://mirrors.aliyun.com|g' {} \;

# 方法：同时处理 .list 和 .sources 文件
# RUN sed -i 's|http://deb.debian.org|https://mirrors.aliyun.com|g' /etc/apt/sources.list && \
#     find /etc/apt/sources.list.d -type f   $  -name "*.list" -o -name "*.sources"  $   -exec sed -i 's|http://deb.debian.org|https://mirrors.aliyun.com|g' {} \; && \
#     find /etc/apt/sources.list.d -type f   $  -name "*.list" -o -name "*.sources"  $   -exec sed -i 's|https://deb.debian.org|https://mirrors.aliyun.com|g' {} \;

# 清空所有源，只用阿里云
RUN echo "deb http://mirrors.aliyun.com/debian/ bookworm main" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ bookworm-updates main" >> /etc/apt/sources.list

# 删除 sources.list.d 下所有文件（避免干扰）
RUN rm -f /etc/apt/sources.list.d/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# （可选）升级到 HTTPS 源（现在已有证书）
RUN sed -i 's|http://|https://|g' /etc/apt/sources.list

ENTRYPOINT ["dotnet", "LY.MicroService.BackendAdmin.HttpApi.Host.dll"]
