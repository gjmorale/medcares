#!/usr/bin/env ruby
require 'rubygems'

require File.dirname(__FILE__) + '/reader/pdf_reader.rb'
require File.dirname(__FILE__) + '/ghost/ghost.rb'

module Global

	DB_PATH = "BD"
	RAW_PATH = "BD/RAW"
	TEMPLATE = "Templates/analisis"
	CLIENTS_INPUT = "Input.xlsx"
	CLIENTS_OUTPUT = "BD/Clients"
	XLS_OUTPUT = "BD/XLSX"
	CSV_OUTPUT = "BD/CSV"

end

puts "Reading clients"
@clients = read_clients Global::CLIENTS_INPUT
puts "#{@clients.size} clients found\n"
@clients.each.with_index do |client,i|
	puts "[#{(i+1)*100/@clients.size}%] #{client.name} #{client.med_care}:#{client.plan}"
	get_pdf_raw(client.med_care, client.plan)
	save_client client if client.valid?
end
#@clients = [Client.new("Juanito Perez","12.345.678-9","COLMENA","ASP-CLC-3114"),
#			Client.new("Che Copete","12.345.678-9","CONSALUD","13-PRSD02-14-FULL")]