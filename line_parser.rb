require_relative 'lexer'

# CSV line parser.
#
class LineParser

  # Initializes the parser with the given lexer instance.
  #
  def initialize lexer
    @lexer = lexer
  end
  
  # Parses the given CSV line into a collection of values.
  # 
  def parse line
    normalize(@lexer.tokenize(line)).select { |t| t.is_a? String }
  end
  
  private
  
  def normalize tokens
    raise "Missing EOFToken." unless tokens.last == :eof
    normalize_rec tokens, 0
  end
  
  def normalize_rec tokens, pos
    unless tokens[pos].is_a? String
      tokens.insert(pos, "")
    end
    
    if tokens[pos+1] == :eof
      return tokens
    end
    
    if tokens[pos+1].is_a? String
      raise "Unexpected identifier [#{tokens[pos+1]}]- a delimiter was expected."
    end
    
    normalize_rec tokens, (pos + 2)
  end
end
