# ActiveRecord JDBC SQL Server Adapter. For SQL Server 2012 And Higher.

[![Gem Version](http://img.shields.io/gem/v/activerecord-jdbcsqlserver-adapter.svg)](https://rubygems.org/gems/activerecord-jdbcsqlserver-adapter) - Gem Version

## About The Adapter

The JDBC SQL Server adapter for ActiveRecord v5.2 using SQL Server 2012 or higher.

We currently support JRuby 9.2+. Older versions may work but they are not tested and there is a known date issue with JRuby 9.1.

For older versions see [activerecord-jdbcmssql-adapter](https://rubygems.org/gems/activerecord-jdbcmssql-adapter)


#### Schemas & Users

Depending on your user and schema setup, it may be needed to use a table name prefix of `dbo.`. So something like this in your initializer file for ActiveRecord or the adapter.

```ruby
ActiveRecord::Base.table_name_prefix = 'dbo.'
```

#### Explain Support (SHOWPLAN)

ActiveRecord's explain features are supported. In SQL Server, this is called the showplan. By default we use the `SHOWPLAN_ALL` option and format it using a simple table printer. So the following ruby would log the plan table below it.

```ruby
Car.where(id: 1).explain
```

```
EXPLAIN for: SELECT [cars].* FROM [cars] WHERE [cars].[id] = 1
+----------------------------------------------------+--------+--------+--------+----------------------+----------------------+----------------------------------------------------+----------------------------------------------------+--------------+---------------------+----------------------+------------+---------------------+----------------------------------------------------+----------+----------+----------+--------------------+
| StmtText                                           | StmtId | NodeId | Parent | PhysicalOp           | LogicalOp            | Argument                                           | DefinedValues                                      | EstimateRows | EstimateIO          | EstimateCPU          | AvgRowSize | TotalSubtreeCost    | OutputList                                         | Warnings | Type     | Parallel | EstimateExecutions |
+----------------------------------------------------+--------+--------+--------+----------------------+----------------------+----------------------------------------------------+----------------------------------------------------+--------------+---------------------+----------------------+------------+---------------------+----------------------------------------------------+----------+----------+----------+--------------------+
| SELECT [cars].* FROM [cars] WHERE [cars].[id] = 1  |      1 |      1 |      0 | NULL                 | NULL                 | 2                                                  | NULL                                               |          1.0 | NULL                | NULL                 | NULL       | 0.00328309996984899 | NULL                                               | NULL     | SELECT   | false    | NULL               |
|   |--Clustered Index Seek(OBJECT:([activerecord... |      1 |      2 |      1 | Clustered Index Seek | Clustered Index Seek | OBJECT:([activerecord_unittest].[dbo].[cars].[P... | [activerecord_unittest].[dbo].[cars].[id], [act... |          1.0 | 0.00312500004656613 | 0.000158099996042438 |        278 | 0.00328309996984899 | [activerecord_unittest].[dbo].[cars].[id], [act... | NULL     | PLAN_ROW | false    |                1.0 |
+----------------------------------------------------+--------+--------+--------+----------------------+----------------------+----------------------------------------------------+----------------------------------------------------+--------------+---------------------+----------------------+------------+---------------------+----------------------------------------------------+----------+----------+----------+--------------------+
```

## Installation

```ruby
gem 'activerecord-jdbcsqlserver-adapter'
```


## Contributing

If you would like to contribute a feature or bugfix, thanks! To make sure your fix/feature has a high chance of being added, please read the following guidelines. First, ask on the Gitter, or post a ticket on github issues. Second, make sure there are tests! We will not accept any patch that is not tested. Please read the [`RUNNING_UNIT_TESTS`](RUNNING_UNIT_TESTS.md) file for the details of how to run the unit tests.

This is a fork of the activerecord-sqlserver-adapter. If you find a bug in the base code, please submit patches to: http://github.com/rails-sqlserver/activerecord-sqlserver-adapter

If the bug/feature is JRuby or specific to this gem, please submit patches to: http://github.com/jruby/activerecord-jdbcsqlserver-adapter


## Credits & Contributions

Many many people have contributed. If you do not see your name here and it should be let us know. Also, many thanks go out to those that have pledged financial contributions.


## Contributors

Up-to-date list of contributors: http://github.com/rails-sqlserver/activerecord-sqlserver-adapter/contributors

Original Gem:
* metaskills (Ken Collins)
* Annaswims (Annaswims)
* wbond (Will Bond)
* Thirdshift (Garrett Hart)
* h-lame (Murray Steele)
* vegantech
* cjheath (Clifford Heath)
* fryguy (Jason Frey)
* jrafanie (Joe Rafaniello)
* nerdrew (Andrew Ryan)
* snowblink (Jonathan Lim)
* koppen (Jakob Skjerning)
* ebryn (Erik Bryn)
* adzap (Adam Meehan)
* neomindryan (Ryan Findley)
* jeremydurham (Jeremy Durham)

JDBC version of the gem:
* rdubya (Rob Widmer)


## License

Copyright © 2008-2019. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.

