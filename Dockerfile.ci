ARG TARGET_VERSION=9.2-alpine

FROM jruby:${TARGET_VERSION}

ENV WORKDIR /activerecord-sqlserver-adapter
ENV JRUBY_OPTS '--debug -X+O -J-Xmx1G'

RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR

COPY . $WORKDIR

RUN apk add --no-cache git freetds

ARG TARGET_ARJDBC_BRANCH=50-stable
ENV ARJDBC_BRANCH $TARGET_ARJDBC_BRANCH

RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

CMD ["sh"]
