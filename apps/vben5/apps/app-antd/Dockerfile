FROM nginx:latest
LABEL maintainer="colin.in@foxmail.com"

# 将vue构建后的dist目录中的内容复制到docker容器中nginx默认配置的部署目录
COPY ./dist /usr/share/nginx/html
 
# 将docker容器中默认的配置替换为本地配置
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# 端口映射
EXPOSE 80

#RUN apt update
#RUN apt install wget -y

# 清空所有源，只用阿里云
RUN echo "deb https://mirrors.aliyun.com/debian/ bookworm main" > /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian-security/ bookworm-security main" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/debian/ bookworm-updates main" >> /etc/apt/sources.list

# 删除 sources.list.d 下所有文件（避免干扰）
RUN rm -f /etc/apt/sources.list.d/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
