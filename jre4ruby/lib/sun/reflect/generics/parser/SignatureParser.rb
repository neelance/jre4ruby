require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
# 
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.  Sun designates this
# particular file as subject to the "Classpath" exception as provided
# by Sun in the LICENSE file that accompanied this code.
# 
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
# 
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
# 
# Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
# CA 95054 USA or visit www.sun.com if you need additional information or
# have any questions.
module Sun::Reflect::Generics::Parser
  module SignatureParserImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Generics::Parser
      include_const ::Java::Lang::Reflect, :GenericSignatureFormatError
      include ::Java::Util
      include ::Sun::Reflect::Generics::Tree
    }
  end
  
  # Parser for type signatures, as defined in the Java Virtual
  # // Machine Specification (JVMS) chapter 4.
  # Converts the signatures into an abstract syntax tree (AST) representation.
  # // See the package sun.reflect.generics.tree for details of the AST.
  class SignatureParser 
    include_class_members SignatureParserImports
    
    # The input is conceptually a character stream (though currently it's
    # a string). This is slightly different than traditional parsers,
    # because there is no lexical scanner performing tokenization.
    # Having a separate tokenizer does not fit with the nature of the
    # input format.
    # Other than the absence of a tokenizer, this parser is a classic
    # recursive descent parser. Its structure corresponds as closely
    # as possible to the grammar in the JVMS.
    # 
    # A note on asserts vs. errors: The code contains assertions
    # in situations that should never occur. An assertion failure
    # indicates a failure of the parser logic. A common pattern
    # is an assertion that the current input is a particular
    # character. This is often paired with a separate check
    # that this is the case, which seems redundant. For example:
    # 
    # assert(current() != x);
    # if (current != x {error("expected an x");
    # 
    # where x is some character constant.
    # The assertion inidcates, that, as currently written,
    # the code should nver reach this point unless the input is an
    # x. On the other hand, the test is there to check the legality
    # of the input wrt to a given production. It may be that at a later
    # time the code might be called directly, and if the input is
    # invalid, the parser should flag an error in accordance
    # with its logic.
    attr_accessor :input
    alias_method :attr_input, :input
    undef_method :input
    alias_method :attr_input=, :input=
    undef_method :input=
    
    # the input signature
    attr_accessor :index
    alias_method :attr_index, :index
    undef_method :index
    alias_method :attr_index=, :index=
    undef_method :index=
    
    class_module.module_eval {
      # index into the input
      # used to mark end of input
      const_set_lazy(:EOI) { Character.new(?:.ord) }
      const_attr_reader  :EOI
      
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
    }
    
    typesig { [] }
    # private constructor - enforces use of static factory
    def initialize
      @input = nil
      @index = 0
    end
    
    typesig { [] }
    # Utility methods.
    # Most parsing routines use the following routines to access the
    # input stream, and advance it as necessary.
    # This makes it easy to adapt the parser to operate on streams
    # of various kinds as well as strings.
    # returns current element of the input and advances the input
    def get_next
      raise AssertError if not ((@index <= @input.attr_length))
      begin
        return @input[((@index += 1) - 1)]
      rescue ArrayIndexOutOfBoundsException => e
        return EOI
      end
    end
    
    typesig { [] }
    # returns current element of the input
    def current
      raise AssertError if not ((@index <= @input.attr_length))
      begin
        return @input[@index]
      rescue ArrayIndexOutOfBoundsException => e
        return EOI
      end
    end
    
    typesig { [] }
    # advance the input
    def advance
      raise AssertError if not ((@index <= @input.attr_length))
      ((@index += 1) - 1)
    end
    
    typesig { [::Java::Char, ::Java::Char] }
    # Match c against a "set" of characters
    def matches(c, *set)
      set.each do |e|
        if ((c).equal?(e))
          return true
        end
      end
      return false
    end
    
    typesig { [String] }
    # Error handling routine. Encapsulates error handling.
    # Takes a string error message as argument.
    # Currently throws a GenericSignatureFormatError.
    def error(error_msg)
      if (DEBUG)
        System.out.println("Parse error:" + error_msg)
      end
      return GenericSignatureFormatError.new
    end
    
    class_module.module_eval {
      typesig { [] }
      # Static factory method. Produces a parser instance.
      # @return an instance of <tt>SignatureParser</tt>
      def make
        return SignatureParser.new
      end
    }
    
    typesig { [String] }
    # Parses a class signature (as defined in the JVMS, chapter 4)
    # and produces an abstract syntax tree representing it.
    # @param s a string representing the input class signature
    # @return An abstract syntax tree for a class signature
    # corresponding to the input string
    # @throws GenericSignatureFormatError if the input is not a valid
    # class signature
    def parse_class_sig(s)
      if (DEBUG)
        System.out.println("Parsing class sig:" + s)
      end
      @input = s.to_char_array
      return parse_class_signature
    end
    
    typesig { [String] }
    # Parses a method signature (as defined in the JVMS, chapter 4)
    # and produces an abstract syntax tree representing it.
    # @param s a string representing the input method signature
    # @return An abstract syntax tree for a method signature
    # corresponding to the input string
    # @throws GenericSignatureFormatError if the input is not a valid
    # method signature
    def parse_method_sig(s)
      if (DEBUG)
        System.out.println("Parsing method sig:" + s)
      end
      @input = s.to_char_array
      return parse_method_type_signature
    end
    
    typesig { [String] }
    # Parses a type signature
    # and produces an abstract syntax tree representing it.
    # @param s a string representing the input type signature
    # @return An abstract syntax tree for a type signature
    # corresponding to the input string
    # @throws GenericSignatureFormatError if the input is not a valid
    # type signature
    def parse_type_sig(s)
      if (DEBUG)
        System.out.println("Parsing type sig:" + s)
      end
      @input = s.to_char_array
      return parse_type_signature
    end
    
    typesig { [] }
    # Parsing routines.
    # As a rule, the parsing routines access the input using the
    # utilities current(), getNext() and/or advance().
    # The convention is that when a parsing routine is invoked
    # it expects the current input to be the first character it should parse
    # and when it completes parsing, it leaves the input at the first
    # character after the input parses.
    # parse a class signature based on the implicit input.
    def parse_class_signature
      raise AssertError if not (((@index).equal?(0)))
      return ClassSignature.make(parse_zero_or_more_formal_type_parameters, parse_class_type_signature, parse_super_interfaces)
    end
    
    typesig { [] }
    def parse_zero_or_more_formal_type_parameters
      if ((current).equal?(Character.new(?<.ord)))
        return parse_formal_type_parameters
      else
        return Array.typed(FormalTypeParameter).new(0) { nil }
      end
    end
    
    typesig { [] }
    def parse_formal_type_parameters
      ftps = ArrayList.new(3)
      raise AssertError if not (((current).equal?(Character.new(?<.ord)))) # should not have been called at all
      if (!(current).equal?(Character.new(?<.ord)))
        raise error("expected <")
      end
      advance
      ftps.add(parse_formal_type_parameter)
      while (!(current).equal?(Character.new(?>.ord)))
        ftps.add(parse_formal_type_parameter)
      end
      advance
      ftpa = Array.typed(FormalTypeParameter).new(ftps.size) { nil }
      return ftps.to_array(ftpa)
    end
    
    typesig { [] }
    def parse_formal_type_parameter
      id = parse_identifier
      bs = parse_zero_or_more_bounds
      return FormalTypeParameter.make(id, bs)
    end
    
    typesig { [] }
    def parse_identifier
      result = StringBuilder.new
      while (!Character.is_whitespace(current))
        c = current
        case (c)
        when Character.new(?;.ord), Character.new(?..ord), Character.new(?/.ord), Character.new(?[.ord), Character.new(?:.ord), Character.new(?>.ord), Character.new(?<.ord)
          return result.to_s
        else
          result.append(c)
          advance
        end
      end
      return result.to_s
    end
    
    typesig { [] }
    def parse_field_type_signature
      case (current)
      when Character.new(?L.ord)
        return parse_class_type_signature
      when Character.new(?T.ord)
        return parse_type_variable_signature
      when Character.new(?[.ord)
        return parse_array_type_signature
      else
        raise error("Expected Field Type Signature")
      end
    end
    
    typesig { [] }
    def parse_class_type_signature
      raise AssertError if not (((current).equal?(Character.new(?L.ord))))
      if (!(current).equal?(Character.new(?L.ord)))
        raise error("expected a class type")
      end
      advance
      scts = ArrayList.new(5)
      scts.add(parse_simple_class_type_signature(false))
      parse_class_type_signature_suffix(scts)
      if (!(current).equal?(Character.new(?;.ord)))
        raise error("expected ';' got '" + (current).to_s + "'")
      end
      advance
      return ClassTypeSignature.make(scts)
    end
    
    typesig { [::Java::Boolean] }
    def parse_simple_class_type_signature(dollar)
      id = parse_identifier
      c = current
      case (c)
      when Character.new(?;.ord), Character.new(?/.ord)
        return SimpleClassTypeSignature.make(id, dollar, Array.typed(TypeArgument).new(0) { nil })
      when Character.new(?<.ord)
        return SimpleClassTypeSignature.make(id, dollar, parse_type_arguments)
      else
        raise error("expected < or ; or /")
      end
    end
    
    typesig { [JavaList] }
    def parse_class_type_signature_suffix(scts)
      while ((current).equal?(Character.new(?/.ord)) || (current).equal?(Character.new(?..ord)))
        dollar = ((current).equal?(Character.new(?..ord)))
        advance
        scts.add(parse_simple_class_type_signature(dollar))
      end
    end
    
    typesig { [] }
    def parse_type_arguments_opt
      if ((current).equal?(Character.new(?<.ord)))
        return parse_type_arguments
      else
        return Array.typed(TypeArgument).new(0) { nil }
      end
    end
    
    typesig { [] }
    def parse_type_arguments
      tas = ArrayList.new(3)
      raise AssertError if not (((current).equal?(Character.new(?<.ord))))
      if (!(current).equal?(Character.new(?<.ord)))
        raise error("expected <")
      end
      advance
      tas.add(parse_type_argument)
      while (!(current).equal?(Character.new(?>.ord)))
        # (matches(current(),  '+', '-', 'L', '[', 'T', '*')) {
        tas.add(parse_type_argument)
      end
      advance
      taa = Array.typed(TypeArgument).new(tas.size) { nil }
      return tas.to_array(taa)
    end
    
    typesig { [] }
    def parse_type_argument
      ub = nil
      lb = nil
      ub = Array.typed(FieldTypeSignature).new(1) { nil }
      lb = Array.typed(FieldTypeSignature).new(1) { nil }
      ta = Array.typed(TypeArgument).new(0) { nil }
      c = current
      case (c)
      when Character.new(?+.ord)
        advance
        ub[0] = parse_field_type_signature
        lb[0] = BottomSignature.make # bottom
        return Wildcard.make(ub, lb)
      when Character.new(?*.ord)
        advance
        ub[0] = SimpleClassTypeSignature.make("java.lang.Object", false, ta)
        lb[0] = BottomSignature.make # bottom
        return Wildcard.make(ub, lb)
      when Character.new(?-.ord)
        advance
        lb[0] = parse_field_type_signature
        ub[0] = SimpleClassTypeSignature.make("java.lang.Object", false, ta)
        return Wildcard.make(ub, lb)
      else
        return parse_field_type_signature
      end
    end
    
    typesig { [] }
    # TypeVariableSignature -> T identifier
    def parse_type_variable_signature
      raise AssertError if not (((current).equal?(Character.new(?T.ord))))
      if (!(current).equal?(Character.new(?T.ord)))
        raise error("expected a type variable usage")
      end
      advance
      ts = TypeVariableSignature.make(parse_identifier)
      if (!(current).equal?(Character.new(?;.ord)))
        raise error("; expected in signature of type variable named" + (ts.get_identifier).to_s)
      end
      advance
      return ts
    end
    
    typesig { [] }
    # ArrayTypeSignature -> [ TypeSignature
    def parse_array_type_signature
      if (!(current).equal?(Character.new(?[.ord)))
        raise error("expected array type signature")
      end
      advance
      return ArrayTypeSignature.make(parse_type_signature)
    end
    
    typesig { [] }
    # TypeSignature -> BaseType | FieldTypeSignature
    def parse_type_signature
      case (current)
      when Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?F.ord), Character.new(?I.ord), Character.new(?J.ord), Character.new(?S.ord), Character.new(?Z.ord)
        return parse_base_type
      else
        return parse_field_type_signature
      end
    end
    
    typesig { [] }
    def parse_base_type
      case (current)
      when Character.new(?B.ord)
        advance
        return ByteSignature.make
      when Character.new(?C.ord)
        advance
        return CharSignature.make
      when Character.new(?D.ord)
        advance
        return DoubleSignature.make
      when Character.new(?F.ord)
        advance
        return FloatSignature.make
      when Character.new(?I.ord)
        advance
        return IntSignature.make
      when Character.new(?J.ord)
        advance
        return LongSignature.make
      when Character.new(?S.ord)
        advance
        return ShortSignature.make
      when Character.new(?Z.ord)
        advance
        return BooleanSignature.make
      else
        raise AssertError if not ((false))
        raise error("expected primitive type")
      end
    end
    
    typesig { [] }
    def parse_zero_or_more_bounds
      fts = ArrayList.new(3)
      if ((current).equal?(Character.new(?:.ord)))
        advance
        case (current)
        when Character.new(?:.ord)
          # empty class bound
        else
          # parse class bound
          fts.add(parse_field_type_signature)
        end
        # zero or more interface bounds
        while ((current).equal?(Character.new(?:.ord)))
          advance
          fts.add(parse_field_type_signature)
        end
      end
      fta = Array.typed(FieldTypeSignature).new(fts.size) { nil }
      return fts.to_array(fta)
    end
    
    typesig { [] }
    def parse_super_interfaces
      cts = ArrayList.new(5)
      while ((current).equal?(Character.new(?L.ord)))
        cts.add(parse_class_type_signature)
      end
      cta = Array.typed(ClassTypeSignature).new(cts.size) { nil }
      return cts.to_array(cta)
    end
    
    typesig { [] }
    # parse a method signature based on the implicit input.
    def parse_method_type_signature
      ets = nil
      raise AssertError if not (((@index).equal?(0)))
      return MethodTypeSignature.make(parse_zero_or_more_formal_type_parameters, parse_formal_parameters, parse_return_type, parse_zero_or_more_throws_signatures)
    end
    
    typesig { [] }
    # (TypeSignature*)
    def parse_formal_parameters
      if (!(current).equal?(Character.new(?(.ord)))
        raise error("expected (")
      end
      advance
      pts = parse_zero_or_more_type_signatures
      if (!(current).equal?(Character.new(?).ord)))
        raise error("expected )")
      end
      advance
      return pts
    end
    
    typesig { [] }
    # TypeSignature*
    def parse_zero_or_more_type_signatures
      ts = ArrayList.new
      stop = false
      while (!stop)
        case (current)
        when Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?F.ord), Character.new(?I.ord), Character.new(?J.ord), Character.new(?S.ord), Character.new(?Z.ord), Character.new(?L.ord), Character.new(?T.ord), Character.new(?[.ord)
          ts.add(parse_type_signature)
        else
          stop = true
        end
      end
      # while( matches(current(),
      # 'B', 'C', 'D', 'F', 'I', 'J', 'S', 'Z', 'L', 'T', '[')
      # ) {
      # ts.add(parseTypeSignature());
      # }
      ta = Array.typed(TypeSignature).new(ts.size) { nil }
      return ts.to_array(ta)
    end
    
    typesig { [] }
    # ReturnType -> V | TypeSignature
    def parse_return_type
      if ((current).equal?(Character.new(?V.ord)))
        advance
        return VoidDescriptor.make
      else
        return parse_type_signature
      end
    end
    
    typesig { [] }
    # ThrowSignature*
    def parse_zero_or_more_throws_signatures
      ets = ArrayList.new(3)
      while ((current).equal?(Character.new(?^.ord)))
        ets.add(parse_throws_signature)
      end
      eta = Array.typed(FieldTypeSignature).new(ets.size) { nil }
      return ets.to_array(eta)
    end
    
    typesig { [] }
    # ThrowSignature -> ^ FieldTypeSignature
    def parse_throws_signature
      raise AssertError if not (((current).equal?(Character.new(?^.ord))))
      if (!(current).equal?(Character.new(?^.ord)))
        raise error("expected throws signature")
      end
      advance
      return parse_field_type_signature
    end
    
    private
    alias_method :initialize__signature_parser, :initialize
  end
  
end
