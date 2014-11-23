require_relative "../csv_parser"
require "test/unit"
require 'stringio'

class TestSupportsVariousDelimiters < Test::Unit::TestCase

  def test_comma_is_used_as_the_delmiter_by_default
  
	file = StringIO.new(
"year,make,model
1997,Ford,E350
2000,Mercury,Cougar"
	)
	
	csvFile = CsvFile.new(file)

	row = csvFile[0]
	assert_equal("1997", row.year)
	assert_equal("Ford", row.make)
	assert_equal("E350", row.model)

	row = csvFile[1]
	assert_equal("2000", row.year)
	assert_equal("Mercury", row.make)
	assert_equal("Cougar", row.model)
  end
  
  def test_supports_pipe_as_the_delimiter
  
	file = StringIO.new(
"year|make|model
1997|Ford|E350
2000|Mercury|Cougar"
	)
	
	csvFile = CsvFile.new(file, "|")

	row = csvFile[0]
	assert_equal("1997", row.year)
	assert_equal("Ford", row.make)
	assert_equal("E350", row.model)

	row = csvFile[1]
	assert_equal("2000", row.year)
	assert_equal("Mercury", row.make)
	assert_equal("Cougar", row.model)
  end
  
  def test_supports_semicolon_as_the_delimiter
  
	file = StringIO.new(
"year;make;model
1997;Ford;E350
2000;Mercury;Cougar"
	)
	
	csvFile = CsvFile.new(file, ";")

	row = csvFile[0]
	assert_equal("1997", row.year)
	assert_equal("Ford", row.make)
	assert_equal("E350", row.model)

	row = csvFile[1]
	assert_equal("2000", row.year)
	assert_equal("Mercury", row.make)
	assert_equal("Cougar", row.model)
  end
  
  def test_supports_space_as_the_delimiter
  
	file = StringIO.new(
"year make model
1997 Ford E350
2000 Mercury Cougar"
	)
	
	csvFile = CsvFile.new(file, " ")

	row = csvFile[0]
	assert_equal("1997", row.year)
	assert_equal("Ford", row.make)
	assert_equal("E350", row.model)

	row = csvFile[1]
	assert_equal("2000", row.year)
	assert_equal("Mercury", row.make)
	assert_equal("Cougar", row.model)
  end
  
  
  def test_supports_tab_as_the_delimiter
  
	file = StringIO.new(
"year	make	model
1997	Ford	E350
2000	Mercury	Cougar"
	)
	
	csvFile = CsvFile.new(file, "	")

	row = csvFile[0]
	assert_equal("1997", row.year)
	assert_equal("Ford", row.make)
	assert_equal("E350", row.model)

	row = csvFile[1]
	assert_equal("2000", row.year)
	assert_equal("Mercury", row.make)
	assert_equal("Cougar", row.model)
  end
  
  def test_does_not_support_dash_as_the_delimiter
  
  file = StringIO.new(
"year-make-model
1997-Ford-E350
2000-Mercury-Cougar"
	)
	
	assert_raise(UnsupportedDelimiterException) { CsvFile.new(file, "-") }
  end
end
