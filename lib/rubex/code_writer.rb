module Rubex
  class CodeWriter
    attr_reader :code

    def initialize target_name
      @code = "/* C extension for #{target_name}.\n"\
                 "This file in generated by Rubex. Do not change!\n"\
               "*/\n"
      @indent = 0
    end

    # type - Return type of the method.
    # c_name - C Name.
    # args - Array of Arrays containing data type and variable name.
    def write_func_declaration type, c_name, args=[]
      write_func_prototype type, c_name, args
      @code << ";"
      new_line
    end

    def write_c_method_header type: , c_name: , args: []
      write_func_prototype type, c_name, args
    end

    def write_ruby_method_header type, c_name
      args = [["int", "argc"], ["VALUE*", "argv"], 
        ["VALUE", "#{Rubex::ARG_PREFIX + "self"}"]]
      write_func_prototype type, c_name, args
    end

    def write_location location
      new_line
      self << "/* Rubex file location: #{location} */"
      new_line
    end

    def declare_variable type:, c_name:
      @code << " "*@indent + "#{type} #{c_name};"
      new_line
    end

    def declare_carray type:, c_name:, dimension:, value: nil
      stmt = "#{type} #{c_name}[#{dimension}]"
      stmt << " = {" + value.join(',') + "}" if value
      stmt << ";"
      self << stmt
      nl
    end

    def init_variable lhs: , rhs:
      stat = " "*@indent + "#{lhs} = #{rhs};"
      @code << stat
      new_line
    end

    def << str
      str.each_line do |s|
        @code << " "*@indent
        @code << s
      end
    end

    def new_line
      @code << "\n"
    end
    alias :nl :new_line

    def indent
      @indent += 2
    end

    def dedent
      raise "Cannot dedent, already 0." if @indent == 0
      @indent -= 2
    end

    def define_instance_method klass: , method_name: , method_c_name:
      @code << " "*@indent + "rb_define_method(" + klass + " ,\"" +
        method_name + "\", " + method_c_name + ", -1);"
      new_line
    end

    def to_s
      @code
    end

    def lbrace
      @code << (" "*@indent + "{")
    end

    def rbrace
      @code << (" "*@indent + "}")
    end

    def block str="", &block
      new_line
      lbrace
      indent
      new_line
      block.call
      dedent
      rbrace
      @code << str
      new_line
    end

  private

    def write_func_prototype return_type, c_name, args
      @code << "#{return_type} #{c_name} "
      @code << "("
      @code << args.map { |type_arg| type_arg.join(" ") }.join(",")
      @code << ")"
    end
  end
end
