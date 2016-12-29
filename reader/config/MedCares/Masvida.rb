require_relative "MedCare.rb"
class MasVida < Medcare

	#GLOBAL_OFFSET = [7,0,0,0]
	#TABLE_OFFSET = 50
	#HORIZONTAL_SEARCH_RANGE = 30

	DIR = "Masvida"

	def dir
		DIR
	end

	def regex(type)
		case type
		when Setup::Type::PERCENTAGE
			'(100|[1-9]?\d(\.\d{1,2})?%?)'
		when Setup::Type::AMOUNT
			'([$]?[0-9]{1,3}(?:.[0-9]{3})*(\,[0-9]{1,3})?(\(\*{1,3}\))?|'<<SIN_TOPE<<'){1}'
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
									[Map::PARTO_CESAREA, "PARTO POR CESAREA"],
									[Map::APENDICETOMIA, "APENDICECTOMIA"],
									[Map::COLECISTECTOMIA, "COLECISTECTOMIA POR VIDEO LAPAROSCOPIA"],
									[Map::HISTERECTOMIA, "HISTERECTOMIA TOTAL"],
									[Map::AMIGDALECTOMIA, "AMIGDALECTOMIA"],
									[Map::C_CARDIACA, "CIRUGIA CARDIACA DE COMPLEJIDAD MAYOR"],
									[Map::EXT_TUMOR, "EXTIRPACION DE TUMOR Y/O QUISTE ENCEFALICO Y DE HIPOFISIS"],
									[Map::DIAS_CAMA, "DIAS CAMA"],
									[Map::MEDICAMENTOS, "MEDICAMENTOS (B)"]]))
			@accounts.concat(get_accounts("AMBULATORIA", 
									[[Map::CONSULTAS, "CONSULTAS"],
									[Map::EXAMENES, "EXAMENES Y PROCEDIMIENTOS"],
									[Map::IMAGENOLOGIA, "IMAGENOLOGIA"],
									[Map::MED_FISICA, "MEDICINA FISICA"]]))
			@accounts.each.with_index do |account, i|
				#puts "\nACC: #{account.name}"
				bottom = @accounts.size == i+1 ? "NOTAS" : @accounts[i+1].name
				analyse_prices account, bottom
			end
		end

		def analyse_prices account, bottom
			Field.new("LIBRE ELECCIÓN").execute @reader
			table_end = Field.new(bottom)
			headers = []
			headers << HeaderField.new("PRESTACIONES", headers.size, Setup::Type::LABEL, true, 2, Setup::Align::BOTTOM_LEFT)
			headers << HeaderField.new("(%) BONIF.", headers.size, Setup::Type::PERCENTAGE, false)
			headers << HeaderField.new("TOPE ($)", headers.size, Setup::Type::AMOUNT, false)
			headers << HeaderField.new("(%) BONIF.", headers.size, Setup::Type::PERCENTAGE, false)
			headers << HeaderField.new("TOPE ($)", headers.size, Setup::Type::AMOUNT, false)
			skips = [Regexp.escape("PRESTACIONES AMBULATORIAS")]
			offset = Field.new(account.name)
			get_table Table.new(headers, Field.new(bottom), offset, skips), account
		end
end