require "multi_json"


module Rulers2
  module Model
    class FileModel
      def initialize(filename)
        @filename = filename
        basename = File.split(filename)[-1]
        @id = File.basename(basename, ".json").to_i
        obj = File.read(filename)
        @hash = MultiJson.load(obj)
      end

      def [](name)
        @hash[name.to_s]
      end

      def []=(name, value)
        @hash[name.to_s] = value
      end

      def self.find(id)
        begin
          FileModel.new("db/quotes/#{id}.json")
        rescue
          return nil
        end
      end

      def self.find_all_by_submitter(submitter)
        files = Dir["db/quotes/*.json"]
        quotes = files.map{|f| FileModel.new f}
        quotes.select{|q| q["submitter"] == submitter}
      end

      def self.all
        files = Dir["db/quotes/*.json"]
        files.map {|f| FileModel.new f }
      end

      def save
        File.open("db/quotes/#{@id}.json", "w") do |f|
          f.write <<-TEMPLATE
            {
            "submitter": "#{self["submitter"]}",
            "quote": "#{self["quote"]}",
            "attribution": "#{self["attribution"]}"
          }
          TEMPLATE
        end
      end

      def self.create(attrs)
        hash = {}
        hash["submitter"] = attrs["submitter"] || ""
        hash["quote"] = attrs["quote"] || ""
        hash["attribution"] = attrs["attribution"] || ""

        files = Dir["db/quotes/*.json"]
        names = files.map{|f| f.split("/")[-1]}
        highest = names.map{|b| b.to_i }.max
        id = highest + 1
        File.open("db/quotes/#{id}.json", "w") do |f|
          f.write <<-TEMPLATE
          {
            "submitter": "#{hash["submitter"]}",
            "quote": "#{hash["quote"]}",
            "attribution": "#{hash["attribution"]}"
          }
          TEMPLATE
        end

        FileModel.new "db/quotes/#{id}.json"
      end

    end
  end
end
