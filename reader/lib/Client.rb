class Client

	attr_reader :name
	attr_reader :id
	attr_reader :med_care
	attr_reader :plan
	attr_accessor :company
	attr_accessor :gender
	attr_accessor :age
	attr_accessor :plan_name
	attr_accessor :monthly_fee
	attr_accessor :valuation
	attr_accessor :clinic
	attr_accessor :maturity
	attr_accessor :conditions
	attr_accessor :conditions_desc
	attr_accessor :dependants

	def initialize name, id, med_care, plan
		@name = name
		@id = id
		@med_care = med_care
		@plan = plan
		@dependants = []
	end 

	def valid?
		maturity.match(/Menor/i).nil?
	end


end