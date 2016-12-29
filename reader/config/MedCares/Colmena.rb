require_relative "MedCare.rb"
class Colmena < Medcare

	GLOBAL_OFFSET = [10,0,0,0]
	VERTICAL_SEARCH_RANGE = 15

	DIR = "Colmena"

	def dir
		DIR
	end

	SEP_DECIMAL = ','
	SEP_THOUSAND = '.'

	def regex(type)
		case type
		when Setup::Type::PERCENTAGE
			'(100|[1-9]\d?)(\,\d{1,3})?\ ?%(\(\*\))?'
		when Setup::Type::AMOUNT
			'([$]?[1-9][0-9]{0,2}(?:'<<Regexp.escape(SEP_THOUSAND)<<'?[0-9]{3})*('<<Regexp.escape(SEP_DECIMAL)<<'[0-9]{1,3})?|'<<SIN_TOPE<<'){1}'
		when Setup::Type::INTEGER
			'\(?\d{1,2}\)?'
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
									[Map::APENDICETOMIA, "APENDICE¶TOMIA"],
									[Map::COLECISTECTOMIA, "COLECISTECTOMIA POR VIDEOLAPAROSCOPIA"],
									[Map::HISTERECTOMIA, "HISTERECTOMIA TOTAL"],
									[Map::AMIGDALECTOMIA, "AMIGDALECTOMIA"],
									[Map::C_CARDIACA, "CIRUGIA CARDIACA DE COMPLEJIDAD MAYOR"],
									[Map::EXT_TUMOR, "EXTIRPACION¶¶¶ TUMOR Y/O QUISTE ENCEFALICO"],
									[Map::DIAS_CAMA, "DIAS CAMA"],
									[Map::MEDICAMENTOS, "MEDICAMENTOS Y MAT. CLINICOS¶ Para los siguientes eventos:"]]))
			@accounts.concat(get_accounts("AMBULATORIA", 
									[[Map::CONSULTAS, "CONSULTAS"],
									[Map::EXAMENES, "EXAMENES Y PROCEDIMIENTOS"],
									[Map::IMAGENOLOGIA, "IMAGENOLOGIA"],
									[Map::MED_FISICA, "MEDICINA FISICA"]]))
			@accounts.each.with_index do |account, i|
				#puts "\nACC: #{account.name}"
				bottom = @accounts.size == i+1 ? "etas al siguiente tope anual" : @accounts[i+1].name
				analyse_prices account, bottom
			end
		end

		def analyse_prices account, bottom
			table_end = Field.new(bottom)
			headers = []
			headers << HeaderField.new(@accounts.first.name, headers.size, Setup::Type::LABEL, false, 6, Setup::Align::BOTTOM_LEFT)
			headers << HeaderField.new([["% BONIFIC."],["% DE BONIFICACIÓN"]], headers.size, Setup::Type::PERCENTAGE, true)
			headers << HeaderField.new([["TOPE $ "],["TOPE"]], headers.size, Setup::Type::AMOUNT, false)
			headers << HeaderField.new([["%¶BONIFIC."],["% DE BONIFICACIÓN"]], headers.size, Setup::Type::PERCENTAGE, false)
			headers << HeaderField.new([["TOPE $ "],["TOPE"]], headers.size, Setup::Type::AMOUNT, false)
			headers << HeaderField.new([["COPAGO $"],["COPAGO"]], headers.size, Setup::Type::PERCENTAGE, false)
			headers << HeaderField.new([["Nº CONVENIO"],["Nº DEL CONV."]], headers.size, Setup::Type::INTEGER, false)
			offset = Field.new(account.name)
			get_table Table.new(headers, Field.new(bottom), offset), account
		end
end
