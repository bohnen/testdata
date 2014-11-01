#!/usr/bin/env ruby
# CSVでテストデータを作成して、DBに入れるスクリプト


# CSVImport名前空間
module CSVImport
	require 'csv'
	require 'sequel'

	# CSVを読み込んで、一連のHashを作成する
	# CSVは下記のような構成になっている
	# cfg.param1, cfg.param2, cfg.param3, a.column1, a.column2, b.column1, b.column3, ...
	# ここでcfgは固定の制御パラメータ（データとしてはDBに保存されない）、a, bはインスタンスの識別子である。
	# 同じテーブルに同時に複数行Insertしなければいけないケースもあるため、インスタンスを識別できるようにする。
	# 結果として、{:cfg => {:param1 => val1, :param2 => val2}, :a => {:column1 => val1, column2 => val2}...}
	# という、入れ子のHashを作成する
	def parseCSV(file)
		
	end
end