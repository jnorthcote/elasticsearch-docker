FROM docker.elastic.co/elasticsearch/elasticsearch:6.6.0
MAINTAINER yeung.herbert@gmail.com

# Export HTTP & Transport
EXPOSE 9200 9300

ENV ES_VERSION 6.6.0

# ENV DOWNLOAD_URL "https://artifacts.elastic.co/downloads/elasticsearch"
# ENV ES_TARBAL "${DOWNLOAD_URL}/elasticsearch-${ES_VERSION}.tar.gz"
# ENV ES_TARBALL_ASC "${DOWNLOAD_URL}/elasticsearch-${ES_VERSION}.tar.gz.asc"
# ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

# Install Elasticsearch.
# RUN apk add --no-cache --update bash ca-certificates su-exec util-linux curl
# RUN apk add --no-cache -t .build-deps gnupg openssl \
#   && cd /tmp \
#   && echo "===> Install Elasticsearch..." \
#   && curl -o elasticsearch.tar.gz -Lskj "$ES_TARBAL"; \
# 	if [ "$ES_TARBALL_ASC" ]; then \
# 		curl -o elasticsearch.tar.gz.asc -Lskj "$ES_TARBALL_ASC"; \
# 		export GNUPGHOME="$(mktemp -d)"; \
# 		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"; \
# 		gpg --batch --verify elasticsearch.tar.gz.asc elasticsearch.tar.gz; \
# 		rm -r "$GNUPGHOME" elasticsearch.tar.gz.asc; \
# 	fi; \
#   tar -xf elasticsearch.tar.gz \
#   && ls -lah \
#   && mv elasticsearch-$ES_VERSION /elasticsearch \
#   && adduser -DH -s /sbin/nologin elasticsearch \
#   && mkdir -p /elasticsearch/config/scripts /elasticsearch/plugins \
#   && chown -R elasticsearch:elasticsearch /elasticsearch \
#   && rm -rf /tmp/* \
#   && apk del --purge .build-deps

# ENV PATH /elasticsearch/bin:$PATH

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

WORKDIR /elasticsearch

# Copy configuration
COPY --chown=elasticsearch:elasticsearch elasticsearch.yml /usr/share/elasticsearch/config/
# COPY override.conf /etc/systemd/system/elasticsearch.service.d/
# COPY config /elasticsearch/config

# Copy run script
COPY run.sh /

# Set environment variables defaults
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"
ENV CLUSTER_NAME elasticsearch-default
ENV NODE_MASTER true
ENV NODE_DATA true
ENV NODE_INGEST true
# ENV NODE_LOCAL false
ENV HTTP_ENABLE true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV MAX_LOCAL_STORAGE_NODES 1
ENV SHARD_ALLOCATION_AWARENESS ""
ENV SHARD_ALLOCATION_AWARENESS_ATTR ""
ENV MEMORY_LOCK false
ENV REPO_LOCATIONS ""
ENV SERVICE "elasticsearch-cluster"
ENV PATH_DATA "/data"
# ENV NUMBER_OF_SHARDS 10
# ENV NUMBER_OF_REPLICAS 2
ENV XPACK_SECURITY_ENABLE false
ENV XPACK_SECURITY_AUDIT_ENABLE false
ENV XPACK_MONITORING_ENABLE true
ENV XPACK_ML_ENABLE true
ENV XPACK_WATCHER_ENABLE true
ENV XPACK_SECURE_URL_SLACK "https://hooks.slack.com/services/..."
ENV NAMESPACE ""
ENV DISCOVERY_SERVICE ""

# Volume for Elasticsearch data
VOLUME ["/data", "/tmp"]

CMD ["/run.sh"]
