require_relative "MedCare.rb"
class Consalud < Medcare

	#GLOBAL_OFFSET = [10,0,0,0]
	TABLE_OFFSET = 50

	DIR = "Consalud"

	def dir
		DIR
	end

	SEP_DECIMAL = ','
	SEP_THOUSAND = '.'

	def regex(type)
		case type
		when Setup::Type::PERCENTAGE
			'(100|[1-9]?\d)(\,\d{1,3}){0,1}%(\(\*\))?'
		when Setup::Type::AMOUNT
			'[$]?([1-9][0-9]{2}|[0-9]{1,3}(?:'<<Regexp.escape(SEP_THOUSAND)<<'[0-9]{3})+('<<Regexp.escape(SEP_DECIMAL)<<'[0-9]{1,3})?|'<<SIN_TOPE<<'){1}'
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
									[Map::APENDICETOMIA, "APENDICECTOMIA"],
									[Map::COLECISTECTOMIA, "COLECISTECTOMIA POR VIDEOLAPAROSCOPIA"],
									[Map::HISTERECTOMIA, "HISTERECTOMIA TOTAL"],
									[Map::AMIGDALECTOMIA, "AMIGDALECTOMIA"],
									[Map::C_CARDIACA, "CIRUGIA CARDIACA DE COMPLEJIDAD MAYOR"],
									[Map::EXT_TUMOR, "EXTIRPACION TUMOR Y/O QUISTE ENCEFALICO"],
									[Map::DIAS_CAMA, "DIAS CAMA"],
									[Map::MEDICAMENTOS, "MEDICAMENTOS Y MATERIAL CLINICO : (B)"]]))
			@accounts.concat(get_accounts("AMBULATORIA", 
									[[Map::CONSULTAS, "CONSULTAS"],
									[Map::EXAMENES, "EXAMENES Y PROCEDIMIENTOS"],
									[Map::IMAGENOLOGIA, "IMAGENOLOGIA"],
									[Map::MED_FISICA, "MEDICINA FISICA"]]))
			@accounts.each.with_index do |account, i|
				#puts "\nACC: #{account.name}"
				bottom = @accounts.size == i+1 ? "Prestación sujeta al siguiente Tope Anual" : @accounts[i+1].name
				analyse_prices account, bottom
			end
		end

		def analyse_prices account, bottom
			Field.new("SELECCIÓN DE PRESTACIONES VALORIZADAS").execute @reader
			table_end = Field.new(bottom)
			headers = []
			headers << HeaderField.new("PRESTACIONES", headers.size, Setup::Type::LABEL, true, 4, Setup::Align::TOP)
			headers << HeaderField.new(["%","BONIFICACIÓN"], headers.size, Setup::Type::PERCENTAGE, false, 4)
			headers << HeaderField.new(["TOPE","$"], headers.size, Setup::Type::AMOUNT, false, 4)
			headers << HeaderField.new(["%","BONIFICACIÓN"], headers.size, Setup::Type::PERCENTAGE, false, 4)
			headers << HeaderField.new(["TOPE","$"], headers.size, Setup::Type::AMOUNT, false, 4)
			headers << HeaderField.new(["COPAGO(*)","$"], headers.size, Setup::Type::AMOUNT, false, 4)
			headers << HeaderField.new(["NÚMERO DEL","PRESTADOR(E)"], headers.size, Setup::Type::INTEGER, false, 4)
			offset = Field.new(account.name)
			get_table Table.new(headers, Field.new(bottom), offset), account
		end
end