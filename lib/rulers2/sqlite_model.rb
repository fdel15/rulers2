require "sqlite3"
require "rulers2/util"

DB = SQLite3::Database.new("test.db")

module Rulers2
  module Model
    class SQLite

      def self.table
        Rulers2.to_underscore name
      end

      def self.schema
        return @schema if @schema
        @schema = {}
        DB.table_info(table) do |row|
          @schema[row["name"]] = row["type"]
        end
        @schema
      end
    end
  end
end
