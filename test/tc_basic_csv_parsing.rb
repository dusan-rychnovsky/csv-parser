require_relative "../csv_parser"
require "test/unit"
require 'stringio'

class TestBasicCsvParsing < Test::Unit::TestCase

  def test_can_parse_basic_csv_file
  
	file = StringIO.new(
"firstname,lastname,age,sex
Andrej,Beles,25,male
Delia,Marin,20,female
Henry,Prashanth,33,male"
	)
	
	csvFile = CsvFile.new.parse file

	row = csvFile[0]
	assert_equal("Andrej", row.firstname)
	assert_equal("Beles", row.lastname)
	assert_equal("25", row.age)
	assert_equal("male", row.sex)

	row = csvFile[1]
	assert_equal("Delia", row.firstname)
	assert_equal("Marin", row.lastname)
	assert_equal("20", row.age)
	assert_equal("female", row.sex)

	row = csvFile[2]
	assert_equal("Henry", row.firstname)
	assert_equal("Prashanth", row.lastname)
	assert_equal("33", row.age)
	assert_equal("male", row.sex)
  end
end
