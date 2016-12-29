#!/usr/bin/env ruby
require 'rubygems'
require 'spreadsheet'
require 'rubyXL'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
require File.dirname(__FILE__) + '/config/Setup.rb'
Dir[File.dirname(__FILE__) + '/config/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/config/**/*.rb'].each {|file| require file }

def read_clients input
	clients = []
	book = RubyXL::Parser.parse input
	count = book[0][0][11].value
	total = book[0][0][8].value
	offset = 3
	client = nil
	total.times.with_index do |i|
		row = book[0][offset+i]
		unless row[1].nil? or row[1].value.to_s.empty?
			name = 		row[2].value
			id = 		row[4].value
			med_care = 	row[7].value
			plan = 		row[17].value
			clients << (client = Client.new(name, id, med_care, plan))
			client.gender = row[3].nil? ? "" : row[3].value
			client.age = row[6].nil? ? "" : row[6].value
			client.monthly_fee = row[8].nil? ? "" : row[8].value
			client.plan_name = row[9].nil? ? "" : row[9].value
			client.valuation = row[10].nil? ? "" : row[10].value
			client.clinic = row[11].nil? ? "" : row[11].value
			client.company = row[13].nil? ? "" : row[13].value
			client.maturity = row[14].nil? ? "" : row[14].value
			client.conditions = row[15].nil? ? "" : row[15].value
			client.conditions_desc = row[16].nil? ? "" : row[16].value
		else
			client.dependants << [row[3].value, row[6].value] if client and client.valid?
		end
	end
	return clients
end

def save_client client
	Setup.set_enviroment client.med_care, RunnerXLSX
	Setup.inst.run(client.plan, "#{Global::CLIENTS_OUTPUT}/#{client.name}", Global::TEMPLATE, client)
end



=begin old execution and TEST
Dir[File.dirname(__FILE__) + '/config/MedCares/*.rb'].sort.each {|file| require file }

format = ARGV[0]
Setup.set_enviroment(format, RunnerXLSX)
file = nil
if ARGV.size > 1
	file = ARGV[1]
end

Setup.inst.run file



@clients = read_clients 'in/Clients/Input.xlsx'
@clients.each do |client|
	save_client client if client.valid?
end
#@clients = [Client.new("Juanito Perez","12.345.678-9","COLMENA","ASP-CLC-3114"),
#			Client.new("Che Copete","12.345.678-9","CONSALUD","13-PRSD02-14-FULL")]
=end
