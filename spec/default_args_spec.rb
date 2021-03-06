require 'spec_helper'

describe Rubex do
  test_case = "default_args"

  context "Case: #{test_case}" do
    before do
      @path = path_str test_case
    end

    context ".ast" do
      it "generates a valid AST" do
        t = Rubex.ast(@path + '.rubex')
      end
    end

    context ".compile", now: true do
      it "compiles to valid C code" do
        t,c,e = Rubex.compile(@path + '.rubex', test: true)
        puts c
      end
    end

    context "Black Box testing", now: true do
      it "compiles and checks for valid output" do
        setup_and_teardown_compiled_files(test_case) do |dir|
          require_relative "#{dir}/#{test_case}.so"

          expect(default_method(1)).to be(nil)
          expect(default_method(1, true, {a: 33})).to eq(7)
          expect(default_method(1, nil, {a: 44})).to eq(5)
        end
      end
    end
  end
end
