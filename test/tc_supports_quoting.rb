require_relative "../csv_parser"
require "test/unit"
require 'stringio'

class TestSupportsQuoting < Test::Unit::TestCase

  def test_delimiters_are_ingored_inside_quoted_values
  
	file = StringIO.new(
'year,make,model,description
1997,Ford,E350,"Super, luxurious truck"
2000,Mercury,Cougar,'
	)
	
	csvFile = CsvFile.new(file)

	row = csvFile[0]
	assert_equal("1997", row.firstname)
	assert_equal("Ford", row.lastname)
	assert_equal("E350", row.age)
	assert_equal("Super, luxurious truck", row.description)

	row = csvFile[1]
	assert_equal("2000", row.firstname)
	assert_equal("Mercury", row.lastname)
	assert_equal("Cougar", row.age)
	assert_equal("", row.description)
  end
  
  def test_supports_embedded_quotes
  
	file = StringIO.new(
'year,make,model,description
1997,Ford,E350,"Super, ""luxurious"" truck"
2000,Mercury,Cougar,'
	)
	
	csvFile = CsvFile.new(file)

	row = csvFile[0]
	assert_equal("1997", row.firstname)
	assert_equal("Ford", row.lastname)
	assert_equal("E350", row.age)
	assert_equal("Super, \"luxurious\" truck", row.description)

	row = csvFile[1]
	assert_equal("2000", row.firstname)
	assert_equal("Mercury", row.lastname)
	assert_equal("Cougar", row.age)
	assert_equal("", row.description)
  end
end
