#!/usr/bin/env ruby
require 'rubygems'
require 'pdf/reader'
require 'fileutils'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

def get_pdf_raw medcare, plan
	cleaner = Cleaner.new
	cleaner.load "pdfs", "BD/RAW", "ghost/source.private"
	return cleaner.execute medcare, plan
end

=begin TEST
medcare = ARGV[0]
plan = ARGV[1]
puts get_pdf_raw medcare, plan
=end
