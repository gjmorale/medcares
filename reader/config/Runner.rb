
module XLS

	DATA_SHEET = ['Cartilla Universal',3,4]
	INFO_SHEET = ['Datos Cliente',0,0]

	def xls y, x, content, page = DATA_SHEET
		y += page[1]
		x += page[2]
		sheet = @book[page[0]]
		unless sheet
			sheet = @book.add_worksheet(page[0])
		end
		#puts "book: #{@book.nil?}, sheet: #{@book['Cartola Universal'].nil?}, row: #{@book['Cartola Universal'][y].nil?}"
		row = sheet[y]
		unless row
			row = sheet.insert_row(y)
		end
		cell = row[x]
		if cell
			#puts "[#{x},#{y}]: |#{cell.value}| <= |#{content}|"
			cell.change_contents(content)
		else
			sheet.add_cell(y,x,content)
		end
	end
end

module RunnerCSV

	def run
		files = Dir["#{Global::RAW_PATH}/#{dir}/*"]
		files.each.with_index do |file, i|
			dir_path = File.dirname(file)
			dir_name = dir_path[dir_path.rindex('/')+1..-1]
			file_name = file[file.rindex('/')+1..-1]
			puts "\n***************************************** - [#{i+1}/#{files.size}] #{file_name}\n"
			puts "Analyzing"
			analyse_position file
			puts "Printing"
			print_results_csv dir_name, file_name
			puts "Done"
		end
		puts "\n*****************************************\n"
	end

	def print_results_csv dir_name, file_name
		unless File.exist? "#{Global::CSV_OUTPUT}/#{dir_name}"
			Dir.mkdir("#{Global::CSV_OUTPUT}/#{dir_name}")
		end
		out = File.open("#{Global::CSV_OUTPUT}/#{dir_name}/#{file_name}.csv",'w')
		print_results out
	end
end

module RunnerXLS
	include XLS

	def run
		files = Dir["#{Global::RAW_PATH}/#{dir}/*"]
		setup_results_xls dir
		files.each.with_index do |file, i|
			dir_path = File.dirname(file)
			dir_name = dir_path[dir_path.rindex('/')+1..-1]
			file_name = file[file.rindex('/')+1..-1]
			puts "\n***************************************** - [#{i+1}/#{files.size}] #{file_name}\n"
			puts "Analyzing"
			analyse_position file
			puts "Printing"
			record_results_xls file_name
			puts "Done"
		end
		write_results_xls dir
		puts "\n*****************************************\n"
	end

	def setup_results_xls dir_name
		unless File.exist? "#{Global::XLS_OUTPUT}/#{dir_name}"
			Dir.mkdir("#{Global::XLS_OUTPUT}/#{dir_name}")
		end
		@book = Spreadsheet::Workbook.new
		@sheet = @book.create_worksheet
		@sheet.name = dir_name
		row = @sheet.row(0)
		row[0] = "Cartillas para #{dir}"
		@row_n = 2
		row = @sheet.row(@row_n)
		row[0] = "Nombre Cartilla"
	end

	def record_results_xls file_name
		@row_n += 1
		row = @sheet.row(@row_n)
		row[0] = file_name
		print_results_xls @book, file_name
	end

	def write_results_xls dir_name
		@book.write "#{Global::XLS_OUTPUT}/#{dir_name}/#{dir_name}.xls"
	end

end

module RunnerXLSX
	include XLS

	def run file_input, file_output, file_template, client
		file = "#{Global::RAW_PATH}/#{dir}/#{file_input}"
		setup_results_xlsx file_template
		dir_path = File.dirname(file)
		dir_name = dir_path[dir_path.rindex('/')+1..-1]
		file_name = file[file.rindex('/')+1..-1]
		puts "Analyzing"
		#puts File.open(file,'r').read
		analyse_position file
		puts "Printing"
		record_results_xlsx
		record_client_xlsx client
		puts "Done"
		write_results_xlsx file_output
		puts "*****************************************\n\n"
	end

	def setup_results_xlsx template
		@book = RubyXL::Parser.parse "#{template}.xlsx"
	end

	def record_results_xlsx
		print_results_xlsx
	end

	def record_client_xlsx client
			xls(2, 2, client.company, INFO_SHEET)
			xls(3, 2, client.name, INFO_SHEET)
			xls(4, 2, "#{client.age} Años", INFO_SHEET)
			#G3 Blanco
			#G4 Isapre
			xls(3,6, client.med_care, INFO_SHEET)
			#G5 Plan Nombre
			xls(4,6, client.plan_name, INFO_SHEET)
			#G6 Costo Mensual
			xls(5,6, client.monthly_fee, INFO_SHEET)
			#G7 Convenio orestador
			xls(6,6, client.valuation, INFO_SHEET)
			#G8 Clnca Pref
			xls(7,6, client.clinic, INFO_SHEET)
			#G9 Ant en meses
			xls(8,6, client.maturity, INFO_SHEET)
			#G10 Preexistencias boolean
			xls(9,6, client.conditions, INFO_SHEET)
			#G11 Detalle
			xls(10,6, client.conditions_desc, INFO_SHEET)
			#Cargas C9:D9 Sexo:Edad
			xls(8,2, client.gender, INFO_SHEET)
			xls(8,3, client.age, INFO_SHEET)
			offset = 9
			client.dependants.each.with_index do |dep,i|
				xls(offset+i,2, dep[0], INFO_SHEET)
				xls(offset+i,3, dep[1], INFO_SHEET)
			end
	end

	def write_results_xlsx output
		@book.write "#{output}.xlsx"
	end
end