#!/usr/bin/env ruby
# 1 user '[{"_key":1, "name":"yappo","url":"http://blog.yappo.jp/"}]'

require 'mysql2'

mysql = Mysql2::Client.new(
    :host     => "localhost",
    :database => "madhand",
    :username => "root",
    :password => "",
)

type  = ARGV[0]
table = mysql.escape(ARGV[1])
json  = mysql.escape(ARGV[2])
if type == 'del'
    type = 2
else
    type = 1
end
puts "insert: type=#{type} table=#{table} json=#{json}"

current_at = Time.now.to_i

mysql.query("INSERT INTO madhand_binlog (log_type, table_name, log, created_at) VALUES(#{type}, '#{table}', '#{json}', #{current_at})")
