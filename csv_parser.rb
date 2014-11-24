#!/usr/local/bin/ruby -w

require_relative 'line_parser'

# An exception to report that the given delimiter is not supported.
#
class UnsupportedDelimiterException < Exception
  attr_reader :delimiter
  
  def initialize delimiter
    @delimiter = delimiter
  end
  
  def to_s
    "Unsupported delimiter [#{@delimiter}]."
  end
end

# CSV file parser.
#
# USAGE:
# CsvFile.new(';').parse('data.csv').each { |row| puts row.firstname }
#
class CsvFile

  SUPPORTED_DELIMITERS = [ ",", "|", ";", " ", "	"]
  DEFAULT_DELIMITER = ","
  
  # Initializes the parser.
  # 
  # * *Args*    :
  #   - +delimiter+ -> The character to be used as delimiter. Defaults to
  #	DEFAULT_DELIMITER. Must be one of SUPPORTED_DELIMITERS, otherwise
  #	an UnsupportedDelimiterException is raised.
  #
  def initialize delimiter = DEFAULT_DELIMITER
    if not SUPPORTED_DELIMITERS.include? delimiter
      raise UnsupportedDelimiterException.new delimiter
    end
    @line_parser = LineParser.new(Lexer.new delimiter)
  end
  
  # Parses the given CSV file and returns the result as an array of rows.
  #
  def parse file
    rows = []
    headers = @line_parser.parse file.gets.chomp
    file.each do |line|
      values = {}
      headers.zip(@line_parser.parse line.chomp).each do |key, value|
        values[key] = value
      end
      rows << CsvRow.new(values)
    end
    rows
  end
end

# CSV row.
#
class CsvRow

  # Creates a new CSV row with the given values.
  # 
  # * *Args*    :
  #   - +values+ -> a hash containing the column -> value mapping
  #
  def initialize values
    @values = values
  end

  # Returns the value in the column given as method name, or null if
  # no such value exists.
  #
  def method_missing name, *args  
    @values[name.to_s]
  end
end
