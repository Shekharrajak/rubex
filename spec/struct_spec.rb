require 'spec_helper'

describe Rubex do
  test_case = "struct"

  context "Case: #{test_case}" do
    before do
      @path = path_str test_case
    end

    context ".ast" do
      it "generates a valid AST" do
        t = Rubex.ast(@path + '.rubex')
      end
    end

    context ".compile", focus: true do
      it "compiles to valid C code" do
        t,c,e = Rubex.compile(@path + '.rubex', test: true)
      end
    end

    context "Black Box testing", focus: true do
      it "compiles and checks for valid output" do
        setup_and_teardown_compiled_files(test_case) do |dir|
          require_relative "#{dir}/#{test_case}.so"

          expect(structure("aa",2,3)).to eq(666)
        end
      end
    end
  end
end
