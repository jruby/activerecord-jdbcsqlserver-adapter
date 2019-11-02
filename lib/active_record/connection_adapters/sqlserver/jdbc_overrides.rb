module ActiveRecord
  module ConnectionAdapters
    module SQLServer
      module JDBCOverrides

        # @Override
        # Needed to reapply this since the jdbc abstract versions don't do the check and
        # end up overriding the sqlserver gem's version
        def exec_insert(sql, name, binds, pk = nil, _sequence_name = nil)
          if id_insert_table_name = exec_insert_requires_identity?(sql, pk, binds)
            with_identity_insert_enabled(id_insert_table_name) { super }
          else
            super
          end
        end

        # @Override
        # Needed to reapply this since the jdbc abstract versions don't do the check and
        # end up overriding the sqlserver gem's version
        def execute(sql, name = nil)
          if id_insert_table_name = query_requires_identity_insert?(sql)
            with_identity_insert_enabled(id_insert_table_name) { super }
          else
            super
          end
        end

        # TODO Move to java for potential perf boost
        def execute_procedure(proc_name, *variables, &block)
          vars = if variables.any? && variables.first.is_a?(Hash)
                   variables.first.map { |k, v| "@#{k} = #{quote(v)}" }
                 else
                   variables.map { |v| quote(v) }
                 end.join(', ')
          sql = "EXEC #{proc_name} #{vars}".strip
          log(sql, 'Execute Procedure') do
            result = @connection.execute(sql)

            return [] unless result

            if result.is_a?(Array)
              result.map! do |res|
                process_execute_procedure_result(res, &block)
              end
            else
              result = process_execute_procedure_result(result, &block)
            end

            result
          end
        end

        # @Override
        # MSSQL does not return query plans for prepared statements, so we have to unprepare them
        # SQLServer gem handles this by overridding exec_explain but that doesn't correctly unprepare them for our needs
        def explain(arel, binds = [])
          arel = ActiveRecord::Base.send(:replace_bind_variables, arel, binds.map(&:value_for_database))
          sql = to_sql(arel)
          result = with_showplan_on { execute(sql, 'EXPLAIN') }
          if result.is_a?(Array)
            # We got back multiple result sets but the printer expects them to all be in one
            main_result = result[0]
            result.each_with_index do |result_obj, i|
              next if i == 0
              main_result.rows.concat(result_obj.rows)
            end
            result = main_result
          end
          printer = showplan_printer.new(result)
          printer.pp
        end

        # @see ActiveRecord::ConnectionAdapters::JdbcAdapter#jdbc_connection_class
        def jdbc_connection_class(_spec)
          ::ActiveRecord::ConnectionAdapters::MSSQLJdbcConnection
        end

        # Override
        # Since we aren't passing dates/times around as strings we need to
        # process them here, just making sure they are a string
        def quoted_date(value)
          super.to_s
        end

        # @Override
        def reset!
          clear_cache!
          reset_transaction
          @connection.rollback # Have to deal with rollbacks differently than the SQLServer gem
          @connection.configure_connection
        end

        # @Overwrite
        # Had some special logic and skipped using gem's internal query methods
        def select_rows(sql, name = nil, binds = [])

          # In some cases the limit is converted to a `TOP(1)` but the bind parameter is still in the array
          if !binds.empty? && sql.include?('TOP(1)')
            binds = binds.delete_if {|b| b.name == 'LIMIT' }
          end

          exec_query(sql, name, binds).rows
        end

        # Have to reset this because the default arjdbc functionality is to return false unless a level is passed in
        def supports_transaction_isolation?
          true
        end

        protected

        # Called to set any connection specific settings that aren't defined ahead of time
        def configure_connection
          # For sql server 2008+ we want it to send an actual time otherwise comparisons with time columns don't work
          @connection.connection.setSendTimeAsDatetime(false)
        end

        # @Overwrite
        # Makes a connection before configuring it
        # @connection actually gets defined and then the connect method in the sqlserver gem overrides it
        # This can probably be fixed with a patch to the main gem
        def connect
          @spid = @connection.execute('SELECT @@SPID').first.values.first
          @version_year = version_year # Not sure if this is necessary but kept it this way because the gem has it this way
          configure_connection
        end

        # @Overwrite
        # This ends up as a no-op without the override
        def do_execute(sql, name = 'SQL')
          execute(sql, name)
        end

        # @Overwrite
        # Overriding this in case it gets used in places that we don't override by default
        def raw_connection_do(sql)
          @connection.execute(sql)
        ensure
          @update_sql = false
        end

        # @Overwrite
        def sp_executesql(sql, name, binds, _options = {})
          exec_query(sql, name, binds)
        end

        # @Overwrite
        # Prevents turning an insert statement into a query with results
        # Slightly adjusted since we know there should always be a table name in the sql
        def sql_for_insert(sql, pk, id_value, sequence_name, binds)
          pk = primary_key(get_table_name(sql)) if pk.nil?
          [sql, binds, pk, sequence_name]
        end

        # @Override
        def translate_exception(exception, message)
          return ActiveRecord::ValueTooLong.new(message) if exception.message.include?('java.sql.DataTruncation')
          super
        end

        # @Overwrite
        # Made it so we don't use the internal calls from the gem
        def version_year
          return @version_year if defined?(@version_year)
          @version_year = begin
            vstring = select_value('SELECT @@version').to_s
            return 2016 if vstring =~ /vNext/
            /SQL Server (\d+)/.match(vstring).to_a.last.to_s.to_i
          rescue Exception => e
            2016
          end
        end

        private

        def _quote(value)
          return value.quoted if value.is_a?(SQLServer::CoreExt::Time) || value.is_a?(SQLServer::CoreExt::DateTime)
          super
        end

        def process_execute_procedure_result(result)
          result.map do |row|
            obj = row.with_indifferent_access
            yield(obj) if block_given?
            obj
          end
        end

      end
    end
  end
end
