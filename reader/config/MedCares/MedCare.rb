# Abstract bank class never to be instantiated
class Medcare < Institution

	HEADERS = ["CATEGORÍA",
			"PRESTACIÓN",
			"% DE BONIFICACIÓN LIBRE",
			"TOPE LIBRE",
			"% DE BONIFICACIÓN PREFERENTE",
			"TOPE PREFERENTE"]

	SIN_TOPE = 'SIN TOPE'
	SEP_DECIMAL = '.'
	SEP_THOUSAND = ','

	def print_results  file
		heading = ""
		HEADERS.each.with_index do |h, i|
			heading << h
			heading << ';' unless i == HEADERS.size-1
		end
		file.write(heading)
		@accounts.each do |account|
			file.write(account.print)
			account.elements.reverse_each do |record|
				file.write(record.print)
			end
		end
	end

	def print_results_xls  book, file
		sheet = book.create_worksheet
		sheet.name = file
		row = sheet.row(0)
		row.concat HEADERS
		row_counter = 1
		@accounts.each do |account|
			acc_info = account.print_xls
			account.elements.reverse!
			account.check
			account.elements.each do |record|
				row = sheet.row(row_counter)
				row_counter += 1
				row.concat acc_info
				row.concat record.print_xls
				#puts record.print_xls
			end
		end
	end

	def print_results_xlsx
		counter = 0
		@accounts.each do |account|
			account.elements.reverse!
			account.check
			account.elements.each do |record|
				#puts "#{counter}:#{record.name if record}"
				special_print counter, record
				counter += 1
			end
		end
	end

	private

		def clean number
			number = strip number
			if number.nil? or number.empty?
				return 0
			elsif number.match self.class::SIN_TOPE
				return "SINTOPE"
			else
				#puts "#{number} - 1#{self.class::SEP_THOUSAND}123#{self.class::SEP_DECIMAL}4"
				number = number.delete(self.class::SEP_THOUSAND)
				number = number.gsub(self.class::SEP_DECIMAL, ',')
				return number.to_f
			end
		end

		def strip result
			result = "#{result}"
			result.nil? ? nil : result.delete("\n").strip
		end

		def clear_not_found results
			clear = results.map{|r| r == Result::NOT_FOUND ? "" : r}
			clear = clear.map{|r| r.delete('▯')}
			clear = clear.map{|r| r.gsub('(E)','')}
		end

		def get_accounts category, titles
			accounts = []
			titles.each.with_index do |title, i|
				accounts << Account.new(title[1], category, title[0])
			end
			accounts
		end

		def get_table table, account
			table.execute @reader
			#table.print_results
			
			@reader.go_to 1
			table.rows.each.with_index do |row, i|
				results = table.headers.map{|h| h.results[i].result}
				results = clear_not_found results
				unless strip(results[0]).empty?
					account.elements << Record.new(strip(results[0]), clean(results[1]), clean(results[2]), clean(results[3]), clean(results[4]))
				end
			end
		end

		def special_print i, record
			if record
				xls(i, 0, record.name)
				xls(i, 1, record.bonif_1)
				xls(i, 2, record.cap_1)
				xls(i, 3, record.bonif_2)
				xls(i, 4, record.cap_2)
			else
				xls(i, 0, "NO ENCONTRADO")
				xls(i, 1, "-")
				xls(i, 2, "-")
				xls(i, 3, "-")
				xls(i, 4, "-")
			end
		end

end