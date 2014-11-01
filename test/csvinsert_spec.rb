#!/usr/bin/env ruby
require '../src/csvimport.rb'

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
end