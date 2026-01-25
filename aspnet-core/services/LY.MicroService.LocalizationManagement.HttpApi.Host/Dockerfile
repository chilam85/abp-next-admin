FROM mcr.microsoft.com/dotnet/aspnet:9.0
LABEL maintainer="colin.in@foxmail.com"
WORKDIR /app

COPY . /app

EXPOSE 80/tcp
VOLUME [ "./app/Logs" ]
VOLUME [ "./app/Modules" ]

#RUN apt update
#RUN apt install wget -y

RUN echo "deb https://mirrors.aliyun.com/debian/ bookworm main" > /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main" >> /etc/apt/sources.list

RUN sed -i 's|https://|http://|g' /etc/apt/sources.list

RUN rm -f /etc/apt/sources.list.d/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# （可选）升级到 HTTPS 源（现在已有证书）
RUN sed -i 's|http://|https://|g' /etc/apt/sources.list

ENTRYPOINT ["dotnet", "LY.MicroService.LocalizationManagement.HttpApi.Host.dll"]