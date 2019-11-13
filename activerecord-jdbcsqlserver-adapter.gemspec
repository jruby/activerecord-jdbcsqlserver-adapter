# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_record/connection_adapters/sqlserver/version"

Gem::Specification.new do |spec|
  spec.name          = 'activerecord-jdbcsqlserver-adapter'
  spec.version       = ActiveRecord::ConnectionAdapters::SQLServer::Version::VERSION
  spec.license       = 'MIT'
  spec.authors       = ['Ken Collins', 'Anna Carey', 'Will Bond', 'Murray Steele', 'Shawn Balestracci', 'Joe Rafaniello', 'Tom Ward', 'Rob Widmer']
  spec.email         = ['ken@metaskills.net', 'will@wbond.net']
  spec.homepage      = 'http://github.com/jruby/activerecord-jdbcsqlserver-adapter'
  spec.summary       = 'ActiveRecord JDBC SQL Server Adapter.'
  spec.description   = 'This is a fork of ActiveRecord SQL Server Adapter for JRuby. SQL Server 2012 and upward.'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.add_dependency 'activerecord', '~> 5.2.0', '>= 5.2.3'
  spec.add_dependency 'activerecord-jdbc-adapter' , '~> 52.4'
  spec.add_dependency 'jdbc-mssql', '>= 0.6.0'
end
