require 'spec_helper'

describe Rubex do
  test_case = "ruby_symbols"

  context "Case: #{test_case}" do
    before do
      @path = path_str test_case
    end

    context ".ast" do
      it "generates the AST" do
        t = Rubex.ast(@path + '.rubex')
      end
    end

    context ".compile", focus: true do
      it "compiles to valid C file" do
        t,c,e = Rubex.compile(@path + '.rubex', test: true)
      end
    end

    context "Black box testing", focus: true do
      it "compiles and checks for valid output" do
        setup_and_teardown_compiled_files(test_case) do |dir|
          require_relative "#{dir}/#{test_case}.so"
          answer = {
            first: "a",
            second: :f,
            third: [3,3]
          }
          expect(RubySymbols.new.symbol_support("a", :f)).to eq(answer)
        end
      end
    end
  end
end
