FROM ubuntu:latest

MAINTAINER Jim Winstead, jimw@trainedmonkey.com

ENV VERSION=3.1.1-612d99f
ENV URL="http://sphinxsearch.com/files/sphinx-${VERSION}-linux-amd64.tar.gz"

RUN set -ex \
        && apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
           libmysqlclient-dev wget \
        && rm -rf /var/lib/apt/lists/* \
        && wget -O sphinx.tar.gz ${URL} \
        && mkdir -p /app \
        && tar --extract --file sphinx.tar.gz \
               --directory /app --strip-components 1 \
        && rm sphinx.tar.gz

WORKDIR /app/etc

VOLUME /var/log
VOLUME /var/data

ENTRYPOINT ["/app/bin/searchd"]

EXPOSE 9306 9312

CMD ["--console"]
