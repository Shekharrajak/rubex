module Rubex
  class SymbolNotFoundError < StandardError;  end

  class ArrayLengthMismatchError < StandardError; end

  class TypeMismatchError < StandardError; end

  class SyntaxError < StandardError; end

  class NoMethodError < StandardError; end

  class TypeError < StandardError; end
end
