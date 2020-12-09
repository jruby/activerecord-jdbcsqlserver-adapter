module JdbcMssqlDriverLoader
  def self.check_and_maybe_load_driver
    driver_name = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
    if (Java::JavaClass.for_name(driver_name) rescue nil)
      driver = Java::ComMicrosoftSqlserverJdbc::SQLServerDriver.new
      which = driver
        .getClass().getClassLoader().loadClass(driver_name)
        .getProtectionDomain().getCodeSource().getLocation().to_s
      warn "You alreday required a mssql jdbc driver (#{which}), skipping gem jdbc-mssql"

      major_version = driver.major_version
      required_major_version = 8
      if major_version < required_major_version
        raise "MSSQL jdbc driver version is to old (given major version #{major_version} < required major version #{required_major_version})"
      end
    else
      require "jdbc/mssql"
    end
  end

  check_and_maybe_load_driver
end
