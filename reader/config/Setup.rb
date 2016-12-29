module Setup

	module Debug

		def self.overview
			return @debug_overview ||= false
		end
		
		def self.overview= value
			@debug_overview = value
		end

	end

	# Institutional document's formats must match ARGV[0]
	module Format
		COLMENA = "Colmena"
		CONSALUD = "Consalud"
		CRUZBLANCA = "Cruzblanca"
		MASVIDA = "Masvida"
		VIDATRES = "Vidatres"
		BANMEDICA = "Banmedica"
	end

	# Field text alignment
	# 8——1——2
	# | \|/ |
	# 7— + —3
	# | /|\ |
	# 6——5——4
	module Align
		TOP = 			1
		TOP_RIGHT = 	2
		RIGHT = 		3
		BOTTOM_RIGHT = 	4
		BOTTOM = 		5
		BOTTOM_LEFT = 	6
		LEFT = 			7
		TOP_LEFT = 		8
	end

	# Reading parameters taken from specific bank
	# or default. Folows ruby convention to store
	# constants.
	module Read

		def self.wildchar
			Setup.inst.class::WILDCHAR
		end

		def self.date_format
			Setup.inst.class::DATE_FORMAT
		end

		def self.horizontal_search_range
			Setup.inst.class::HORIZONTAL_SEARCH_RANGE
		end

		def self.vertical_search_range
			Setup.inst.class::VERTICAL_SEARCH_RANGE
		end

		def self.center_mass_limit
			Setup.inst.class::CENTER_MASS_LIMIT
		end

		def self.text_expand
			Setup.inst.class::TEXT_EXPAND
		end
	end

	# Table specific constants
	module Table

		def self.global_offset
			Setup.inst.class::GLOBAL_OFFSET
		end

		def self.offset
			Setup.inst.class::TABLE_OFFSET
		end

		def self.header_orientation
			Setup.inst.class::HEADER_ORIENTATION
		end
	end

	# General data types in documents
	module Type
		PERCENTAGE = 	1
		AMOUNT = 		2
		LABEL = 		3
		INTEGER = 		4
	end

	# Sets up the specific bank format to be loaded
	def self.set_enviroment(format, runner)
		case format
		when Format::COLMENA
			puts "Colmena selected"
			@@institution = Colmena.new
		when Format::CONSALUD
			puts "Consalud selected"
			@@institution = Consalud.new
		when Format::CRUZBLANCA
			puts "Cruz Blanca selected"
			@@institution = CruzBlanca.new
		when Format::MASVIDA
			puts "Más Vida selected"
			@@institution = MasVida.new
		when Format::VIDATRES
			puts "Vida Tres selected"
			@@institution = VidaTres.new
		when Format::BANMEDICA
			puts "Banmedica selected"
			@@institution = Banmedica.new
		else
			puts "Wrong input, try again or CTRL + C to exit"
			return false
		end
		@@institution.include_module runner
	end

	def self.inst
		@@institution
	end

end

# Abstract bank class never to be instantiated
class Institution

	def include_module runner
		extend runner
	end

	# FINE TUNNING parameters:
	# Override in sub-classes for bank specific
	GLOBAL_OFFSET = [0,0,0,0]
	TABLE_OFFSET = 6
	HEADER_ORIENTATION = 8
	VERTICAL_SEARCH_RANGE = 5
	HORIZONTAL_SEARCH_RANGE = 15
	CENTER_MASS_LIMIT = 0.40
	TEXT_EXPAND = 0.5
	WILDCHAR = '¶'
	DATE_FORMAT = '\d\d\/\d\d\/\d\d\d\d'

	# Regex format for a specific type.
	# bounded: if it should add start and end of text
	def get_regex(type, bounded = true)
		return Regexp.new('^'<<regex(type)<<'$') if bounded
		return Regexp.new(regex(type))
	end

	def to_arr(item, n)
		r = []
		n.times do |i|
			r << item
		end
		r
	end

	def clone_it field
		return nil if field.nil?
		if field.is_a? Array
			return field.map{|f| f.clone}
		else
			return field.clone
		end
	end

end