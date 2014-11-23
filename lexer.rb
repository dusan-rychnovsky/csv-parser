require_relative 'assertions'

class Lexer

  def initialize delimiter
    @delimiter = delimiter
  end
  
  def tokenize stream
    stream = stream.chars.to_a
    tokens = []
    while true
      tokens << next_token(stream)
      if tokens.last.is_a? EOFToken
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
        EOFToken.new
      when delimiter
        DelimiterToken.new delimiter
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
          return IdentifierToken.new lexem
        when eof
          return IdentifierToken.new lexem
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
          raise "Unexpected EOF within a quoted string."
        when quotes
          if stream.first == quotes
            lexem << quotes
            stream.shift
           else
             return IdentifierToken.new lexem
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

class Token
end

class EOFToken < Token
  def to_s
    "EOF"
  end
end

class DelimiterToken < Token
  attr_reader :lexem
  
  def initialize lexem
    @lexem = lexem
  end
  
  def to_s
    "DELIMITER(#{@lexem})"
  end
end

class IdentifierToken < Token
  attr_reader :lexem
  
  def initialize lexem
    @lexem = lexem
  end
  
  def to_s
    "IDENTIFIER(#{@lexem})"
  end
end
