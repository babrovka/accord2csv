require 'pry'
require_relative 'lib/parser'

task :get_fields, [:path] do |task, args|
  Parser.new(args[:path]).to_csv
end
