# Our core date/time overrides to support prepared statements
require 'active_record/connection_adapters/sqlserver/core_ext/date_time'

# Load the jar file for the jdbc driver
require 'jdbc/mssql'

# Standadard arjdbc functionality
require 'arjdbc/abstract/connection_management'
require 'arjdbc/abstract/core'
require 'arjdbc/abstract/database_statements'
require 'arjdbc/abstract/statement_cache'
require 'arjdbc/abstract/transaction_support'
require 'arjdbc/util/quoted_cache'

# A module for prepending functionality
require 'active_record/connection_adapters/sqlserver/jdbc_overrides'

# Load the actual adapter
require_relative './activerecord-sqlserver-adapter'

# Load overrides and java specifics
require 'arjdbc'
ArJdbc.load_java_part :MSSQL
require 'active_record/jdbc_sqlserver_connection_methods'
