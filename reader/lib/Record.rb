class Record

	attr_reader :name
	attr_reader :cap_1
	attr_reader :bonif_1
	attr_reader :cap_2
	attr_reader :bonif_2

	def initialize (name, bonif_1, cap_1, bonif_2, cap_2)
		@name = name
		@bonif_1 = bonif_1
		@cap_1 = cap_1
		@bonif_2 = bonif_2 == 0 ? bonif_1 : bonif_2
		@cap_2 = cap_2 == 0 ? cap_1 : cap_2
	end

	def to_s
		"#{name}"
	end

	def inspect
		to_s
	end

	def print
		"\n#{@name};#{@bonif_1};#{@cap_1};#{@bonif_2};#{@cap_2}"
	end


	def print_xls
		[@name, @bonif_1, @cap_1, @bonif_2, @cap_2]
	end

end