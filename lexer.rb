require_relative 'assertions'

class LexicalError < RuntimeError
end

# CSV line lexical analyzer.
#
class Lexer

  # Initialzes the lexer.
  # 
  # * *Args*    :
  #   - +delimiter+ -> The character to be used as delimiter.
  #
  def initialize delimiter
    @delimiter = delimiter
  end
  
  # Breaks the given CSV line into a sequence of tokens.
  #
  def tokenize stream
    stream = stream.chars.to_a
    tokens = []
    while true
      tokens << next_token(stream)
      if tokens.last == :eof
        break
      end
    end
    tokens
  end
  
  private
  
  def next_token stream
    char = stream.shift
    case char    
      when eof
        :eof
      when delimiter
        :delimiter
      when quotes
        stream.unshift char
        get_quoted_identifier stream
      else
        stream.unshift char
        get_unquoted_identifier stream
    end
  end
  
  def get_unquoted_identifier stream
    lexem = ""
    while true do
      char = stream.shift
      case char
        when delimiter
          stream.unshift char
          return lexem
        when eof
          return lexem
        else
          lexem << char
      end
    end
  end
  
  def get_quoted_identifier stream
    char = stream.shift
    assert { char == quotes }
    lexem = ""
    while true do
      char = stream.shift
      case char
        when eof
          raise LexicalError, "Unexpected EOF within a quoted string."
        when quotes
          if stream.first == quotes
            lexem << quotes
            stream.shift
           else
             return lexem
           end
        else
          lexem << char
      end
    end
  end
  
  def eof
    nil
  end
  
  def delimiter
    @delimiter
  end
  
  def quotes
    '"'
  end
end
