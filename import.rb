#!/usr/bin/env ruby
require 'rubygems'
require 'pdf/reader'
require 'fileutils'
Dir[File.dirname(__FILE__) + '/ghost/lib/*.rb'].each {|file| require file }

cleaner = Cleaner.new
cleaner.load "pdfs", "BD/RAW", "ghost/source.private"
cleaner.execute