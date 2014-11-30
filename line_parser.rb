require_relative 'lexer'

class ParseError < RuntimeError
end

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
    normalize(@lexer.tokenize(line)).select { |t| t.is_a? IdentifierToken }.map { |t| t.lexem }
  end
  
  private
  
  def normalize tokens
    raise ParseError, "Missing EOFToken." unless tokens.last.is_a? EOFToken
    normalize_rec tokens, 0
  end
  
  def normalize_rec tokens, pos
    unless tokens[pos].is_a? IdentifierToken
      tokens.insert(pos, IdentifierToken.new(""))
    end
    
    if tokens[pos+1].is_a? EOFToken
      return tokens
    end
    
    if tokens[pos+1].is_a? IdentifierToken
      raise ParseError, "Unexpected identifier [#{tokens[pos+1]}]- a delimiter was expected."
    end
    
    normalize_rec tokens, (pos + 2)
  end
end
