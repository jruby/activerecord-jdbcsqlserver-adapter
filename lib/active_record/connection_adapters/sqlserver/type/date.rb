module ActiveRecord
  module ConnectionAdapters
    module SQLServer
      module Type
        class Date < ActiveRecord::Type::Date

          def sqlserver_type
            'date'.freeze
          end

          def serialize(value)
            return unless value.present?
            date = super(value).to_s(:_sqlserver_dateformat)
            Data.new date, self
          end

          if defined? JRUBY_VERSION

            # Currently only called by our custom DateTime type for formatting
            def _formatted(value)
              value.to_s(:_sqlserver_dateformat)
            end

            # @Override
            # We do not want the DateTime object to be turned into a string
            def serialize(value)
              value = super
              value.present? ? CoreExt::DateTime._jd_with_sql_type(value, self) : value
            end

          end

          def deserialize(value)
            value.is_a?(Data) ? super(value.value) : super
          end

          def type_cast_for_schema(value)
            serialize(value).quoted
          end

          def quoted(value)
            Utils.quote_string_single(value)
          end

          private

          def fast_string_to_date(string)
            ::Date.strptime(string, fast_string_to_date_format)
          rescue ArgumentError
            super
          end

          def fast_string_to_date_format
            ::Date::DATE_FORMATS[:_sqlserver_dateformat]
          end

        end
      end
    end
  end
end
