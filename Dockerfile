FROM centos:7.5.1804

MAINTAINER RP

ENV BASE_DIR=/usr/local/src
ENV PATH /usr/local/nginx/sbin:$PATH

ADD https://nginx.org/download/nginx-1.7.11.tar.gz $BASE_DIR
ADD https://github.com/arut/nginx-rtmp-module/archive/master.zip $BASE_DIR/nginx-rtmp-module-master.zip
ADD https://github.com/yaoweibin/nginx_upstream_check_module/archive/master.zip $BASE_DIR/upstream_check.zip

RUN yum install gcc wget vim openssl openssl-devel pcre pcre-devel unzip patch -y && yum clean all && rm -rf /var/cache/yum

RUN cd $BASE_DIR && tar -xvf nginx-1.7.11.tar.gz && unzip nginx-rtmp-module-master.zip && unzip upstream_check.zip && sed -ie 's;(1024\*1024);\(200\*1024\*1024);g' $BASE_DIR/nginx-rtmp-module-master/hls/ngx_rtmp_hls_module.c && cd nginx-1.7.11/ && patch -p1 < ../nginx_upstream_check_module-master/check_1.7.5+.patch && ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master/ --add-module=../nginx_upstream_check_module-master && make && make install && rm -rf nginx-1.7.11.tar.gz && rm -rf nginx-rtmp-module-master.zip && rm -rf upstream_check.zip

COPY test.html /usr/local/nginx/html/

EXPOSE 80

CMD ["nginx","-g","daemon off;"]
