module Map
	
	module Category
		AMBULATORIA = "Ambulatoria"
		HOSPITALARIA = "Hospitalaria"
	end
	
	module Item
		DER_PABELLON = /recho.*Pab/i
		HONO_MEDICOS = /norarios.*m.dico/i
		HONO_MATRONA = /norarios.*Matro/i
		ATENCION_R_N = /enci.*n.*reci.*nacido/i
		VISITA_NEONA = /sita.*neo.*logo/i
		D_C_MEDICINA = /dicina/i
		DC_SALA_CUNA = /ala.*cuna/i
		UTI_ADULTO = /U+.*T+.*I+.*a+d+u+l+t+o+/i
		UTI_PEDIATRA = /U+.*T+.*I+.*p+e+d+i+a+t+r+/i
		UTI_NEONATAL = /U+.*T+.*I+.*n+e+o+n+a+t/i
		APENDICECTOM = /pendi.*to.*a/i
		H_P_NEUMONIA = /neumo/i
		CONSULTA_E_U = /sulta.*m.dica/i
		CONSULTA_ESP = /sulta.*especialidad/i
		CONSULTA_PSI = /sulta.*ps.*trica/i
		HEMOGRAMA = /mograma/i
		EST_LIPIDOS = /l.pido/i
		P_BIOQUIMICO = /bioqu.mico/i
		E_UROCULTIVO = /ocultivo/i
		ORINA_COMPLE = /rina.*comp/i
		DENSITOMETRI = /sitometr.a.*sea/i
		CITO_DIAGNOS = /todiagn.stico/i
		HISTOPATOLOG = /(histopatol.gico|hispatol.gico)/i
		VITREORETINA = /vitreo.*retina/i
		E_CARDIOGRAM = /tro.*cardio.*gram/i
		ECOCARDIGRAM = /co.*cardio.*gram.*dop/i
		DUODENOSCOPI = /duodeno/i
		HEMODIALISIS = /hemo.*di.lisis/i
		RODILLERA = /(dillera|rodillrea).*bota/i
		RADIOX_TORAX = /graf.a.*t.rax/i
		MAMOGRAFIA = /mograf.a.*(bilat|biltaeral)/i
		RADIOX_BRAZO = /diograf.a.*brazo/i
		TOMOGRAFIA_A = /(mograf.a.*axial|tac.*cerebro)/i
		ECO_ABDOMINA = /mograf.a.*abdom/i
		ECO_GINECOLO = /mograf.a.*gine/i
		EJ_RESPIRATO = /ejerc.*resp/i
		RE_ED_MOTRIZ = /educaci.n.*motr/i
	end
	
	class Service

		attr_reader :name
		attr_reader :category
		attr_reader :fields

		def initialize(category, name, fields)
			@category = category
			@name = name
			@fields = fields
		end

		def to_s
			"#{category}:#{name}"
		end

		def match element
			indexes = []
			@fields.each.with_index do |field,i|
				indexes << i if element.match field
			end
			return indexes
		end

	end

	PARTO_NORMAL = Service.new(Category::HOSPITALARIA,
	"PARTO NORMAL",[
		Item::DER_PABELLON,
		Item::HONO_MEDICOS,
		Item::HONO_MATRONA,
		Item::ATENCION_R_N,
		Item::VISITA_NEONA
		])
	PARTO_CESAREA = Service.new(Category::HOSPITALARIA,
	"PARTO POR CESÁREA",[
		Item::DER_PABELLON,
		Item::HONO_MEDICOS,
		Item::HONO_MATRONA,
		Item::ATENCION_R_N,
		Item::VISITA_NEONA
		])
	APENDICETOMIA = Service.new(Category::HOSPITALARIA,
	"APENDICETOMÍA",[
		Item::DER_PABELLON,
		Item::HONO_MEDICOS
		])
	COLECISTECTOMIA = Service.new(Category::HOSPITALARIA,
	"COLECISTECTOMÍA POR VIDEOLAPAROSCOPÍA",[
		Item::DER_PABELLON,
		Item::HONO_MEDICOS
		])
	HISTERECTOMIA = Service.new(Category::HOSPITALARIA,
	"HISTERECTOMÍA TOTAL",[
		Item::DER_PABELLON,
		Item::HONO_MEDICOS
		])
	AMIGDALECTOMIA = Service.new(Category::HOSPITALARIA,
	"AMIGDALECTOMÍA",[
		Item::DER_PABELLON,
		Item::HONO_MEDICOS
		])
	C_CARDIACA = Service.new(Category::HOSPITALARIA,
	"CIRUGÍA CARDIACA DE COMPLEJIDAD MAYOR",[
		Item::DER_PABELLON,
		Item::HONO_MEDICOS
		])
	EXT_TUMOR = Service.new(Category::HOSPITALARIA,
	"EXTIRPACIÓN TUMOR Y/O QUISTE ENCEFÁLICO",[
		Item::DER_PABELLON,
		Item::HONO_MEDICOS
		])
	DIAS_CAMA = Service.new(Category::HOSPITALARIA,
	"DÍAS CAMA",[
		Item::D_C_MEDICINA,
		Item::DC_SALA_CUNA,
		Item::UTI_ADULTO,
		Item::UTI_PEDIATRA,
		Item::UTI_NEONATAL
		])
	MEDICAMENTOS = Service.new(Category::HOSPITALARIA,
	"MEDICAMENTOS Y MATERIALES CLÍNICOS",[
		Item::APENDICECTOM,
		Item::H_P_NEUMONIA,
		Item::APENDICECTOM,
		Item::H_P_NEUMONIA
		])
	CONSULTAS = Service.new(Category::AMBULATORIA,
	"CONSULTAS MÉDICAS",[
		Item::CONSULTA_E_U,
		Item::CONSULTA_ESP,
		Item::CONSULTA_PSI
		])
	EXAMENES = Service.new(Category::AMBULATORIA,
	"EXÁMENES Y PROCEDIMIENTOS MÉDICOS",[
		Item::HEMOGRAMA,
		Item::EST_LIPIDOS,
		Item::P_BIOQUIMICO,
		Item::E_UROCULTIVO,
		Item::ORINA_COMPLE,
		Item::DENSITOMETRI,
		Item::CITO_DIAGNOS,
		Item::HISTOPATOLOG,
		Item::VITREORETINA,
		Item::E_CARDIOGRAM,
		Item::ECOCARDIGRAM,
		Item::DUODENOSCOPI,
		Item::HEMODIALISIS,
		Item::RODILLERA
		])
	IMAGENOLOGIA = Service.new(Category::AMBULATORIA,
	"IMAGENOLOGÍA",[
		Item::RADIOX_TORAX,
		Item::MAMOGRAFIA,
		Item::RADIOX_BRAZO,
		Item::TOMOGRAFIA_A,
		Item::ECO_ABDOMINA,
		Item::ECO_GINECOLO
		])
	MED_FISICA = Service.new(Category::AMBULATORIA,
	"MEDICINA FÍSICA",[
		Item::EJ_RESPIRATO,
		Item::RE_ED_MOTRIZ
		])
	

end
