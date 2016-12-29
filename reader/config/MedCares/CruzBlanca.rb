require_relative "MedCare.rb"
class CruzBlanca < Medcare

	GLOBAL_OFFSET = [7,0,0,0]
	#TABLE_OFFSET = 50
	HORIZONTAL_SEARCH_RANGE = 30

	DIR = "Cruzblanca"

	def dir
		DIR
	end

	SIN_TOPE = 'Sin Tope'

	def regex(type)
		case type
		when Setup::Type::PERCENTAGE
			'(100|[1-9]?\d){1}'
		when Setup::Type::AMOUNT
			'[$]?([1-9][0-9]{2}|[0-9]{1,3}(?:'<<Regexp.escape(SEP_THOUSAND)<<'[0-9]{3})+('<<Regexp.escape(SEP_DECIMAL)<<'[0-9]{1,3})?|'<<SIN_TOPE<<'){1}'
		when Setup::Type::INTEGER
			'\d{1,2}H?'
		when Setup::Type::LABEL
			'.+'
		end
	end

	private  

		def analyse_position file
			#puts "ANALYSING #{file}"
			@reader = Reader.new(file)
			@accounts = []
			@accounts.concat(get_accounts("HOSPITALARIA", 
									[[Map::PARTO_NORMAL, "PARTO NORMAL"],
									[Map::PARTO_CESAREA, "PARTO POR CES¶REA"],
									[Map::APENDICETOMIA, "APENDICE¶TOM¶A"],
									[Map::COLECISTECTOMIA, "COLECISTECTOMIA POR VIDEOLAPAROSCOPIA"],
									[Map::HISTERECTOMIA, "HISTERECTOM¶A TOTAL"],
									[Map::AMIGDALECTOMIA, "AMIGDALECTOMIA"],
									[Map::C_CARDIACA, "CIRUG¶A CARDIACA DE COMPLEJIDAD MAYOR"],
									[Map::EXT_TUMOR, "EXTIRPACI¶N TUMOR Y/O QUISTE CEREBRAL"],
									[Map::DIAS_CAMA, "D¶AS CAMA"],
									[Map::MEDICAMENTOS, "MEDICAMENTOS ¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶: Para los siguientes eventos "]]))
			@accounts.concat(get_accounts("AMBULATORIA", 
									[[Map::CONSULTAS, "CONSULTAS"],
									[Map::EXAMENES, "EX¶MENES Y PROCEDIMIENTOS"],
									[Map::IMAGENOLOGIA, "IMAGENOLOGIA"],
									[Map::MED_FISICA, "MEDICINA F¶SICA"]]))
			@accounts.each.with_index do |account, i|
				#puts "\nACC: #{account.name}"
				bottom = @accounts.size == i+1 ? "con tope anual" : @accounts[i+1].name
				analyse_prices account, bottom
			end
		end

		def analyse_prices account, bottom
			table_end = Field.new(bottom)
			headers = []
			headers << HeaderField.new(@accounts.first.name, headers.size, Setup::Type::LABEL, true, 2, Setup::Align::BOTTOM_LEFT)
			headers << HeaderField.new("%¶Bonif", headers.size, Setup::Type::PERCENTAGE, false)
			headers << HeaderField.new([["x|"],["Tope¶$"]], headers.size, Setup::Type::AMOUNT, false)
			headers << HeaderField.new("%¶Bonif", headers.size, Setup::Type::PERCENTAGE, false)
			headers << HeaderField.new("Tope $", headers.size, Setup::Type::AMOUNT, false)
			skips = [Regexp.escape("MAT. CLÍNICOS: Para los siguientes eventos : (B)")]
			offset = Field.new(account.name)
			get_table Table.new(headers, Field.new(bottom), offset, skips), account
		end
end