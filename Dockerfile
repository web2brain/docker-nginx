FROM debian:jessie
MAINTAINER David Personette <dperson@dperson.com>

# Install nginx
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-key adv --keyserver pgp.mit.edu --recv-keys \
                573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
    echo -n "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> \
                /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends apache2-utils openssl nginx &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
# Forward request and error logs to docker log collector

COPY default.conf /etc/nginx/conf.d/
COPY nginx.sh /usr/bin/

VOLUME ["/srv/www", "/etc/nginx"]

EXPOSE 80 443

ENTRYPOINT ["nginx.sh"]
