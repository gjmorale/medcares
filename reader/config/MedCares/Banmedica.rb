require_relative "MedCare.rb"
class Banmedica < Medcare

	#GLOBAL_OFFSET = [7,0,0,0]
	#TABLE_OFFSET = 50
	HORIZONTAL_SEARCH_RANGE = 10
	TEXT_EXPAND = 0.18

	DIR = "Banmedica"

	def dir
		DIR
	end

	SIN_TOPE = 'Sin Tope'
	SEP_DECIMAL = ','
	SEP_THOUSAND = '.'

	def regex(type)
		case type
		when Setup::Type::PERCENTAGE
			'(\(E\))?(100|[1-9]\d?(\,\d{1,2})?%?)'
		when Setup::Type::AMOUNT
			'▯*([1-9][0-9]{2}|[0-9]{1,3}(?:'<<Regexp.escape(SEP_THOUSAND)<<'[0-9]{3})+('<<Regexp.escape(SEP_DECIMAL)<<'[0-9]{1,3})?|'<<SIN_TOPE<<'){1}'
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
									[Map::COLECISTECTOMIA, "COLECISTECTOMIA POR VIDEOLAPAROSCOPIA"],
									[Map::HISTERECTOMIA, "HISTEROCTOMIA TOTAL"],
									[Map::AMIGDALECTOMIA, "AMIGDALECTOMIA"],
									[Map::C_CARDIACA, "CIRUGIA CARDIACA DE COMPLEJIDAD MAYOR"],
									[Map::EXT_TUMOR, "EXTIRPACION DE TUMOR Y/O QUISTE ENCEFALICO Y DE HIPOFISIS"],
									[Map::DIAS_CAMA, "DIAS CAMA"],
									[Map::MEDICAMENTOS, "MEDICAMENTOS (B)"]]))
			@accounts.concat(get_accounts("AMBULATORIA", 
									[[Map::CONSULTAS, "CONSULTAS MEDICAS"],
									[Map::EXAMENES, "EXAMENES Y PROCEDIMIENTOS"],
									[Map::IMAGENOLOGIA, "IMAGENOLOGIA"],
									[Map::MED_FISICA, "MEDICINA FISICA"]]))
			@accounts.each.with_index do |account, i|
				#puts "\nACC: #{account.name}"
				bottom = @accounts.size == i+1 ? "Notas" : @accounts[i+1].name
				analyse_prices account, bottom
			end
		end

		def analyse_prices account, bottom
			Field.new("LIBRE ELECCIÓN").execute @reader
			headers = []
			headers << HeaderField.new(@accounts.first.name, headers.size, Setup::Type::LABEL, true, 4, Setup::Align::BOTTOM_LEFT)
			headers << HeaderField.new("%BONIFICACIÓN", headers.size, Setup::Type::PERCENTAGE, false)
			headers << HeaderField.new("TOPE $", headers.size, Setup::Type::AMOUNT, false)
			headers << HeaderField.new("%BONIFICACIÓN", headers.size, Setup::Type::PERCENTAGE, false)
			headers << HeaderField.new("TOPE $", headers.size, Setup::Type::AMOUNT, false)
			offset = Field.new(account.name)
			skips = [Regexp.escape("PRESTACIONES AMBULATORIAS"), Regexp.escape("MATERIALES CLINICOS (B)")]
			get_table Table.new(headers, Field.new(bottom), offset, skips), account
		end
end