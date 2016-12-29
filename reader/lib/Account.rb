class Account

	attr_reader :name
	attr_reader :category
	attr_accessor :elements

	def initialize name, category = nil, service = nil
		@name = name
		@category = category
		@elements = []
		@service = service
	end

	def to_s
		cat = @category.nil? ? "" : " [#{@category}]"
		"#{name}#{cat}: #{elements.size}"
	end

	def inspect
		to_s
	end

	def print
		"\n[#{@category}] #{@name}:"
	end

	def print_xls
		[@category, @name]
	end

	def check
		checked_elements = Array.new(@service.fields.size, nil)
		elements.each do |element|
			indexes = @service.match element.name
			unless indexes.empty?
				indexes.each do |i|
					if checked_elements[i].nil?
						checked_elements[i] = element
						break
					end
				end
				@elements = checked_elements
				#puts "ACC: #{@elements.size}/#{@service.fields.size} #{name}"
			else
				puts "\"#{element}\" not found in #{self}".red
				raise
			end
		end
	end
end