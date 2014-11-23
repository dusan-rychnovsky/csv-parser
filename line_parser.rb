require_relative 'lexer'

class LineParser

  def initialize lexer
    @lexer = lexer
  end
  
  def parse line
    values = []
    last_seen_identifier = false
    tokens = @lexer.tokenize line
    tokens.each do |token|
      case token
        when EOFToken
          if not last_seen_identifier
            values << ""
          end
          break
        when DelimiterToken
          if not last_seen_identifier
            values << ""
            next
          else
            last_seen_identifier = false
          end
        when IdentifierToken
          if last_seen_identifier
            raise "Syntactic error - values must be delimited by commas."
          end
          last_seen_identifier = true
          values << token.lexem
      end
    end
    values
  end
end
