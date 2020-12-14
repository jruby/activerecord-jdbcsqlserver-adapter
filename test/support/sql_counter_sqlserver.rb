module ARTest
  module SQLServer

    module SqlCounterSqlserver

      # Only return the log vs. log_all
      def capture_sql_ss
        ActiveRecord::SQLCounter.clear_log
        yield
        ActiveRecord::SQLCounter.log.dup
      end

    end

    ignored_sql = [
      /INFORMATION_SCHEMA\.(TABLES|VIEWS|COLUMNS)/im,
      /SELECT @@version/,
      /SELECT @@TRANCOUNT/,
      /(BEGIN|COMMIT|ROLLBACK|SAVE) TRANSACTION/,
      /SELECT CAST\(.* AS .*\) AS value/,
      /SELECT DATABASEPROPERTYEX/im
    ]

    ActiveRecord::SQLCounter.ignored_sql.concat(ignored_sql)

  end
end
