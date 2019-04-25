module ActiveRecord
  module ConnectionAdapters
    module SQLServer
      module CoreExt

        module DataCompat

          attr_accessor :_sql_type

          def quoted
            _sql_type.quoted(self)
          end

          def to_s(*args)
            return super unless args.empty?
            _sql_type._formatted(self)
          end

        end

        # Create our own DateTime class so that we can format strings properly and still have a DateTime class
        # for the jdbc driver to work with
        class DateTime < ::DateTime

          include DataCompat

          def self._jd_with_sql_type(value, type)
            jd(value.jd).tap { |t|  t._sql_type = type }
          end

        end

        # Create our own Time class so that we can format strings properly and still have a Time class
        # for the jdbc driver to work with
        class Time < ::Time

          include DataCompat

          def self._at_with_sql_type(value, type)
            new(
                value.year,
                value.month,
                value.day,
                value.hour,
                value.min,
                value.sec + (Rational(value.nsec, 1000) / 1000000),
                value.gmt_offset
            ).tap { |t| t._sql_type = type }
          end

        end

      end
    end
  end
end
