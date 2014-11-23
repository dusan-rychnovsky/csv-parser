#!/usr/local/bin/ruby -w

# CSV file parser.
#
# USAGE:
# CsvFile.new('data.csv').each { |row| puts row.firstname }
#
class CsvFile

  DELIMITER = ","
  
  # Parses the given CSV file into a collection of rows.
  #
  def initialize file
    @rows = []
    headers = file.gets.chomp.split(DELIMITER)
    file.each do |line|
      values = {}
      headers.zip(line.chomp.split(DELIMITER)).each do |key, value|
        values[key] = value
      end
      @rows << CsvRow.new(values)
    end
  end

  # Iterates over all rows.
  #
  def each
    @rows.each { |row| yield(row) }
  end

  # Returns the index-th row, or null if no such row exists.
  #
  def [] index
    @rows[index]
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
