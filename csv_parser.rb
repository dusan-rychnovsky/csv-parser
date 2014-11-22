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

# TEST CASES
#

class AssertionError < RuntimeError
end

def assert &block
    raise AssertionError unless yield
end

require 'stringio'

file = StringIO.new(
"firstname,lastname,age,sex
Andrej,Beles,25,male
Delia,Marin,20,female
Henry,Prashanth,33,male"
)

csvFile = CsvFile.new(file)

row = csvFile[0]
assert { row.firstname == "Andrej" }
assert { row.lastname == "Beles" }
assert { row.age == "25" }
assert { row.sex == "male" }

row = csvFile[1]
assert { row.firstname == "Delia" }
assert { row.lastname == "Marin" }
assert { row.age == "20" }
assert { row.sex == "female" }

row = csvFile[2]
assert { row.firstname == "Henry" }
assert { row.lastname == "Prashanth" }
assert { row.age == "33" }
assert { row.sex == "male" }

puts "DONE."
