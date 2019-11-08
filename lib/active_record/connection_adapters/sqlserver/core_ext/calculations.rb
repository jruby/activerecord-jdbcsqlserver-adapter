require 'active_record/relation'
require 'active_record/version'

module ActiveRecord
  module ConnectionAdapters
    module SQLServer
      module CoreExt
        module Calculations

          # @Override
          # If we are ordering a subquery for a count, we have to artificially add the offset bind parameter
          def bound_attributes
            attrs = super
            if @_setting_offset_for_count
              @_setting_offset_for_count = false
              attrs << Attribute.with_cast_value('OFFSET'.freeze, 0, ::ActiveRecord::Type.default_value)
            end
            attrs
          end

          private

          # @Override
          def build_count_subquery(relation, column_name, distinct)

            # For whatever reason, mssql requires an offset if an ORDER BY is included in a subquery
            if distinct && !has_limit_or_offset? && !relation.orders.empty?
              relation = relation.offset(0)

              # This is purely to appease activerecord/test/cases/calculations_test.rb @ line 258 CalculationsTest#test_distinct_count_all_with_custom_select_and_order
              # hopefully nobody tries to do anything too crazy in a literal...
              if relation.projections.length == 1 && relation.projections.first.is_a?(::Arel::Nodes::SqlLiteral)
                relation.projections[0] = ::Arel::Nodes::SqlLiteral.new(relation.projections.first + ' as some_name_that_hopefully_never_exists123')
              end

              @_setting_offset_for_count = true
            end

            super

          end
        end
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  if ActiveRecord::VERSION::MAJOR == 5 &&
     ActiveRecord::VERSION::MINOR == 1 &&
     ActiveRecord::VERSION::TINY >= 4
    mod = ActiveRecord::ConnectionAdapters::SQLServer::CoreExt::Calculations
    ActiveRecord::Relation.prepend(mod)
  end
end
