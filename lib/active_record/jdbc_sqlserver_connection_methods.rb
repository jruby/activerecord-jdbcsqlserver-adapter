module ActiveRecord
  module ConnectionHandling

    def sqlserver_connection(config)
      config[:adapter_spec] ||= ::ArJdbc::MSSQL
      config[:mode] ||= :jdbc

      unless jndi_config?(config)

        config[:host] ||= 'localhost'
        config[:driver] ||= 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
        config[:connection_alive_sql] ||= 'SELECT 1'

        config[:url] ||= begin
          url = ["jdbc:sqlserver://#{config[:host]}"]
          url << (config[:port] ? ":#{config[:port]};" : ';')
          url << "databaseName=#{config[:database]};" if config[:database]
          url << "instanceName=#{config[:instance]};" if config[:instance]
          app = config[:appname] || config[:application]
          url << "applicationName=#{app};" if app
          isc = config[:integrated_security] # Win only - needs sqljdbc_auth.dll
          url << "integratedSecurity=#{isc};" unless isc.nil?
          url.join('')
        end
      end

      ConnectionAdapters::SQLServerAdapter.new(nil, nil, config)
    end

  end
end
