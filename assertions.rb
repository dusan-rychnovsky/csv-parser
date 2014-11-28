# An exception to represent assertion violations.
#
class AssertionError < RuntimeError
end

# Evaluates the given block as a boolean expression and throws an AssertionError
# in case it results to false.
#
def assert &block
  raise AssertionError unless yield
end
