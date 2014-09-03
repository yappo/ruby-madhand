#!/usr/bin/env ruby
require 'json'
require 'mysql2'
require 'httpclient'

groonga_endpoint = "http://127.0.0.1:10041/d/"

mysql = Mysql2::Client.new(
    :host     => "localhost",
    :database => "madhand",
    :username => "root",
    :password => "",
)

http = HTTPClient.new()
status = JSON.parse(http.get("#{groonga_endpoint}select", {
    "table" => "madhand_status",
    "query" => "_key:1",
}).content)

pos = status[1][0][2][2]
p "current slave log position #{pos}"

mysql.query("SELECT id, log_type, table_name, log FROM madhand_binlog WHERE id > #{pos} ORDER BY id ASC").each do |row|
    id       = row["id"]
    log_type = row["log_type"]
    table    = row["table_name"]
    log      = row["log"]
    if log_type == 1
        p "load pos id #{id}"
        http.get("#{groonga_endpoint}load", {
            "table"      => table,
            "input_type" => "json",
            "values"     => log,
        })
    else
        p "delete pos id #{id} (this is not impliment)"
    end

    pos_json = JSON.generate([{ "_key" => 1, "pos" => id }])
    http.get("#{groonga_endpoint}load", {
        "table"      => "madhand_status",
        "input_type" => "json",
        "values"     => pos_json,
    })
end
