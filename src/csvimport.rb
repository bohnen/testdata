#!/usr/bin/env ruby
#
# CSVでテストデータを作成して、DBに入れるスクリプト
# gem install sequel が必要。JDBCを利用する場合は、jrubyで実行する必要がある
#


# CSVImport名前空間
module CSVImport
	require 'csv'
	require 'sequel'

	# CSVを読み込んで、一連のHashを作成する
	#
	# CSVは下記のような構成になっている
	# cfg.param1, cfg.param2, cfg.param3, a.column1, a.column2, b.column1, b.column3, ...
	# ここでcfgは固定の制御パラメータ（データとしてはDBに保存されない）、a, bはインスタンスの識別子である。
	# 同じテーブルに同時に複数行Insertしなければいけないケースもあるため、インスタンスを識別できるようにする。
	# 結果として、{:cfg => {:param1 => val1, :param2 => val2}, :a => {:column1 => val1, column2 => val2}...}
	# という、入れ子のHashを作成する
	#
	# @param file CSVファイルのパス 
	def parse(file)
		records = [] 
		csv = CSV.read(file, headers:true)
		csv.each do |row|
			r = {}
			csv.headers.map{|k| k.split(".")[0]}.uniq.each do |obj|
				r[obj] = {}
			end

			row.each do |key, val|
				obj, atr = key.split(".")
				r[obj][atr] = val
			end
			records << r
		end
		records
	end

	# テーブルにデータをinsertする
	#
	# records のそれぞれの行のHashに入っている順にinsertを行う
	# トランザクショナルにしたければこのメソッドを DB.transaction do - end で囲うこと。
	#
	# @param db [Sequel::Database] 接続するDB。初期化済みのこと
	# @param records [Array] insertするデータ。parseで作成した形式
	# @param table_map [Hash] objとtable名の対応。
	# @param dry_run [Boolean] 実行せずinsert文を返す
	def insert(db, records=[], table_map={}, dry_run=false)
		records.map do |r|
			r.map do |key, val|
				table_name = table_map[key].to_sym || key.to_sym
				if dry_run then
					db[table_name].insert_sql(val)
				else
					db[table_name].insert(val)
				end
			end
		end
	end

	module_function :parse, :insert
end
