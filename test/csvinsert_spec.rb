#!/usr/bin/env ruby
require '../src/csvimport.rb'
require 'logger'

RSpec.describe CSVImport do
	describe '#parse' do
		it "returns arrays of hash that has column:value pair" do 

			@csv = CSVImport.parse("./data/sample.csv")

			expect(@csv.size).to eq(2)
			expect(@csv[0].size).to be > 0
			expect(@csv[0].keys).to contain_exactly("cfg","foo","bar")
			expect(@csv[1]["cfg"]).to be_an_instance_of(Hash)
		end
	end

	describe '#insert' do
		before(:all) do
			@db = Sequel.connect('mock://db2')
			@db.loggers << Logger.new($stdout)
			@table_map = {"cfg" => "DUAL", "foo" => "T_FOO", "bar" => "T_BAR"}
			@csv = CSVImport.parse("./data/sample.csv")
		end  

		it "dry_run returns insert statement" do 
			rets = CSVImport.insert(@db, @csv, @table_map, true)	
			rets.each do |r|
				r.each do |r2|
					expect(r2).to match(/^INSERT/)
				end
			end
		end

		it "execute insert returns nothing" do
			rets = CSVImport.insert(@db, @csv, @table_map)
			puts rets.inspect
		end
	end
end