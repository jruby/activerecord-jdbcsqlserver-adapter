#!/usr/bin/env bash

set -x
set -e

tag=1.4

docker pull metaskills/mssql-server-linux-rails:$tag

container=$(docker ps -a -q --filter ancestor=metaskills/mssql-server-linux-rails:$tag)
if [[ -z $container ]]; then
  docker run -p 1433:1433 -d metaskills/mssql-server-linux-rails:$tag && sleep 10
  docker ps -a

  container=$(docker ps -a -q --filter ancestor=metaskills/mssql-server-linux-rails:$tag)

  docker logs $container
  
  docker exec -it $container /opt/mssql-tools/bin/sqlcmd -U sa -P super01S3cUr3 -S localhost -Q "SELECT name FROM master.dbo.sysdatabases"
  docker exec -it $container /opt/mssql-tools/bin/sqlcmd -U sa -P super01S3cUr3 -S localhost -Q "SELECT loginname, dbname FROM syslogins"
  exit
fi

container=$(docker ps -q --filter ancestor=metaskills/mssql-server-linux-rails:$tag)
if [[ -z $container ]]; then
  docker start $container && sleep 10
fi

