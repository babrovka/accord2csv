require 'csv'
require 'pdf_forms'

class Parser
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def fields
    pdftk.get_fields(path)
  end

  def to_csv
    CSV.open(output, "wb") do |csv|
      csv << ["Accord field name", "Question", "Type"]
      fields.each do |field|
        csv << [field.name, question(field.name_alt), type(field.name_alt) ]
      end
    end
  end

  def output
    ["output/", path.match(/\/(.*)\./)[1], ".csv"].join
  end

  def question(name_alt)
    return unless name_alt
    question = name_alt.split(": ")[1] rescue name_alt
  end

  def type(name_alt)
    return unless name_alt
    return "STRING" if name_alt.match?(/Enter text:/)
    return "NUMBER" if name_alt.match?(/Enter (number|amount|limit|rate|year):/)
    return "DATE" if name_alt.match?(/Enter date:/)
    return "CODE" if name_alt.match?(/Enter code:/)
    return "IDENTIFIER" if name_alt.match?(/Enter identifier:/)
    return "PERCENTAGE" if name_alt.match?(/Enter percentage:/)
    return "CHECKBOX" if name_alt.match?(/Check\s+the\s+box/)
    return "YES/NO" if name_alt.match?(/(Enter Y)|(Enter N)/)
    "NO MATCH FOR: #{name_alt}"
  end

  def pdftk
    @_pdftk ||= PdfForms.new('/usr/local/bin/pdftk')
  end
end
