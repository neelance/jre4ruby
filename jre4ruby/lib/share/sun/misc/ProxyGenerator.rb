require "rjava"

# Copyright 1999-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module ProxyGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :DataOutputStream
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Lang::Reflect, :Array
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :Map
      include_const ::Sun::Security::Action, :GetBooleanAction
    }
  end
  
  # ProxyGenerator contains the code to generate a dynamic proxy class
  # for the java.lang.reflect.Proxy API.
  # 
  # The external interfaces to ProxyGenerator is the static
  # "generateProxyClass" method.
  # 
  # @author      Peter Jones
  # @since       1.3
  class ProxyGenerator 
    include_class_members ProxyGeneratorImports
    
    class_module.module_eval {
      # In the comments below, "JVMS" refers to The Java Virtual Machine
      # Specification Second Edition and "JLS" refers to the original
      # version of The Java Language Specification, unless otherwise
      # specified.
      # 
      # generate 1.5-era class file version
      const_set_lazy(:CLASSFILE_MAJOR_VERSION) { 49 }
      const_attr_reader  :CLASSFILE_MAJOR_VERSION
      
      const_set_lazy(:CLASSFILE_MINOR_VERSION) { 0 }
      const_attr_reader  :CLASSFILE_MINOR_VERSION
      
      # beginning of constants copied from
      # sun.tools.java.RuntimeConstants (which no longer exists):
      # 
      # constant pool tags
      const_set_lazy(:CONSTANT_UTF8) { 1 }
      const_attr_reader  :CONSTANT_UTF8
      
      const_set_lazy(:CONSTANT_UNICODE) { 2 }
      const_attr_reader  :CONSTANT_UNICODE
      
      const_set_lazy(:CONSTANT_INTEGER) { 3 }
      const_attr_reader  :CONSTANT_INTEGER
      
      const_set_lazy(:CONSTANT_FLOAT) { 4 }
      const_attr_reader  :CONSTANT_FLOAT
      
      const_set_lazy(:CONSTANT_LONG) { 5 }
      const_attr_reader  :CONSTANT_LONG
      
      const_set_lazy(:CONSTANT_DOUBLE) { 6 }
      const_attr_reader  :CONSTANT_DOUBLE
      
      const_set_lazy(:CONSTANT_CLASS) { 7 }
      const_attr_reader  :CONSTANT_CLASS
      
      const_set_lazy(:CONSTANT_STRING) { 8 }
      const_attr_reader  :CONSTANT_STRING
      
      const_set_lazy(:CONSTANT_FIELD) { 9 }
      const_attr_reader  :CONSTANT_FIELD
      
      const_set_lazy(:CONSTANT_METHOD) { 10 }
      const_attr_reader  :CONSTANT_METHOD
      
      const_set_lazy(:CONSTANT_INTERFACEMETHOD) { 11 }
      const_attr_reader  :CONSTANT_INTERFACEMETHOD
      
      const_set_lazy(:CONSTANT_NAMEANDTYPE) { 12 }
      const_attr_reader  :CONSTANT_NAMEANDTYPE
      
      # access and modifier flags
      const_set_lazy(:ACC_PUBLIC) { 0x1 }
      const_attr_reader  :ACC_PUBLIC
      
      const_set_lazy(:ACC_PRIVATE) { 0x2 }
      const_attr_reader  :ACC_PRIVATE
      
      # private static final int ACC_PROTECTED              = 0x00000004;
      const_set_lazy(:ACC_STATIC) { 0x8 }
      const_attr_reader  :ACC_STATIC
      
      const_set_lazy(:ACC_FINAL) { 0x10 }
      const_attr_reader  :ACC_FINAL
      
      # private static final int ACC_SYNCHRONIZED           = 0x00000020;
      # private static final int ACC_VOLATILE               = 0x00000040;
      # private static final int ACC_TRANSIENT              = 0x00000080;
      # private static final int ACC_NATIVE                 = 0x00000100;
      # private static final int ACC_INTERFACE              = 0x00000200;
      # private static final int ACC_ABSTRACT               = 0x00000400;
      const_set_lazy(:ACC_SUPER) { 0x20 }
      const_attr_reader  :ACC_SUPER
      
      # private static final int ACC_STRICT                 = 0x00000800;
      # opcodes
      # private static final int opc_nop                    = 0;
      const_set_lazy(:Opc_aconst_null) { 1 }
      const_attr_reader  :Opc_aconst_null
      
      # private static final int opc_iconst_m1              = 2;
      const_set_lazy(:Opc_iconst_0) { 3 }
      const_attr_reader  :Opc_iconst_0
      
      # private static final int opc_iconst_1               = 4;
      # private static final int opc_iconst_2               = 5;
      # private static final int opc_iconst_3               = 6;
      # private static final int opc_iconst_4               = 7;
      # private static final int opc_iconst_5               = 8;
      # private static final int opc_lconst_0               = 9;
      # private static final int opc_lconst_1               = 10;
      # private static final int opc_fconst_0               = 11;
      # private static final int opc_fconst_1               = 12;
      # private static final int opc_fconst_2               = 13;
      # private static final int opc_dconst_0               = 14;
      # private static final int opc_dconst_1               = 15;
      const_set_lazy(:Opc_bipush) { 16 }
      const_attr_reader  :Opc_bipush
      
      const_set_lazy(:Opc_sipush) { 17 }
      const_attr_reader  :Opc_sipush
      
      const_set_lazy(:Opc_ldc) { 18 }
      const_attr_reader  :Opc_ldc
      
      const_set_lazy(:Opc_ldc_w) { 19 }
      const_attr_reader  :Opc_ldc_w
      
      # private static final int opc_ldc2_w                 = 20;
      const_set_lazy(:Opc_iload) { 21 }
      const_attr_reader  :Opc_iload
      
      const_set_lazy(:Opc_lload) { 22 }
      const_attr_reader  :Opc_lload
      
      const_set_lazy(:Opc_fload) { 23 }
      const_attr_reader  :Opc_fload
      
      const_set_lazy(:Opc_dload) { 24 }
      const_attr_reader  :Opc_dload
      
      const_set_lazy(:Opc_aload) { 25 }
      const_attr_reader  :Opc_aload
      
      const_set_lazy(:Opc_iload_0) { 26 }
      const_attr_reader  :Opc_iload_0
      
      # private static final int opc_iload_1                = 27;
      # private static final int opc_iload_2                = 28;
      # private static final int opc_iload_3                = 29;
      const_set_lazy(:Opc_lload_0) { 30 }
      const_attr_reader  :Opc_lload_0
      
      # private static final int opc_lload_1                = 31;
      # private static final int opc_lload_2                = 32;
      # private static final int opc_lload_3                = 33;
      const_set_lazy(:Opc_fload_0) { 34 }
      const_attr_reader  :Opc_fload_0
      
      # private static final int opc_fload_1                = 35;
      # private static final int opc_fload_2                = 36;
      # private static final int opc_fload_3                = 37;
      const_set_lazy(:Opc_dload_0) { 38 }
      const_attr_reader  :Opc_dload_0
      
      # private static final int opc_dload_1                = 39;
      # private static final int opc_dload_2                = 40;
      # private static final int opc_dload_3                = 41;
      const_set_lazy(:Opc_aload_0) { 42 }
      const_attr_reader  :Opc_aload_0
      
      # private static final int opc_aload_1                = 43;
      # private static final int opc_aload_2                = 44;
      # private static final int opc_aload_3                = 45;
      # private static final int opc_iaload                 = 46;
      # private static final int opc_laload                 = 47;
      # private static final int opc_faload                 = 48;
      # private static final int opc_daload                 = 49;
      # private static final int opc_aaload                 = 50;
      # private static final int opc_baload                 = 51;
      # private static final int opc_caload                 = 52;
      # private static final int opc_saload                 = 53;
      # private static final int opc_istore                 = 54;
      # private static final int opc_lstore                 = 55;
      # private static final int opc_fstore                 = 56;
      # private static final int opc_dstore                 = 57;
      const_set_lazy(:Opc_astore) { 58 }
      const_attr_reader  :Opc_astore
      
      # private static final int opc_istore_0               = 59;
      # private static final int opc_istore_1               = 60;
      # private static final int opc_istore_2               = 61;
      # private static final int opc_istore_3               = 62;
      # private static final int opc_lstore_0               = 63;
      # private static final int opc_lstore_1               = 64;
      # private static final int opc_lstore_2               = 65;
      # private static final int opc_lstore_3               = 66;
      # private static final int opc_fstore_0               = 67;
      # private static final int opc_fstore_1               = 68;
      # private static final int opc_fstore_2               = 69;
      # private static final int opc_fstore_3               = 70;
      # private static final int opc_dstore_0               = 71;
      # private static final int opc_dstore_1               = 72;
      # private static final int opc_dstore_2               = 73;
      # private static final int opc_dstore_3               = 74;
      const_set_lazy(:Opc_astore_0) { 75 }
      const_attr_reader  :Opc_astore_0
      
      # private static final int opc_astore_1               = 76;
      # private static final int opc_astore_2               = 77;
      # private static final int opc_astore_3               = 78;
      # private static final int opc_iastore                = 79;
      # private static final int opc_lastore                = 80;
      # private static final int opc_fastore                = 81;
      # private static final int opc_dastore                = 82;
      const_set_lazy(:Opc_aastore) { 83 }
      const_attr_reader  :Opc_aastore
      
      # private static final int opc_bastore                = 84;
      # private static final int opc_castore                = 85;
      # private static final int opc_sastore                = 86;
      const_set_lazy(:Opc_pop) { 87 }
      const_attr_reader  :Opc_pop
      
      # private static final int opc_pop2                   = 88;
      const_set_lazy(:Opc_dup) { 89 }
      const_attr_reader  :Opc_dup
      
      # private static final int opc_dup_x1                 = 90;
      # private static final int opc_dup_x2                 = 91;
      # private static final int opc_dup2                   = 92;
      # private static final int opc_dup2_x1                = 93;
      # private static final int opc_dup2_x2                = 94;
      # private static final int opc_swap                   = 95;
      # private static final int opc_iadd                   = 96;
      # private static final int opc_ladd                   = 97;
      # private static final int opc_fadd                   = 98;
      # private static final int opc_dadd                   = 99;
      # private static final int opc_isub                   = 100;
      # private static final int opc_lsub                   = 101;
      # private static final int opc_fsub                   = 102;
      # private static final int opc_dsub                   = 103;
      # private static final int opc_imul                   = 104;
      # private static final int opc_lmul                   = 105;
      # private static final int opc_fmul                   = 106;
      # private static final int opc_dmul                   = 107;
      # private static final int opc_idiv                   = 108;
      # private static final int opc_ldiv                   = 109;
      # private static final int opc_fdiv                   = 110;
      # private static final int opc_ddiv                   = 111;
      # private static final int opc_irem                   = 112;
      # private static final int opc_lrem                   = 113;
      # private static final int opc_frem                   = 114;
      # private static final int opc_drem                   = 115;
      # private static final int opc_ineg                   = 116;
      # private static final int opc_lneg                   = 117;
      # private static final int opc_fneg                   = 118;
      # private static final int opc_dneg                   = 119;
      # private static final int opc_ishl                   = 120;
      # private static final int opc_lshl                   = 121;
      # private static final int opc_ishr                   = 122;
      # private static final int opc_lshr                   = 123;
      # private static final int opc_iushr                  = 124;
      # private static final int opc_lushr                  = 125;
      # private static final int opc_iand                   = 126;
      # private static final int opc_land                   = 127;
      # private static final int opc_ior                    = 128;
      # private static final int opc_lor                    = 129;
      # private static final int opc_ixor                   = 130;
      # private static final int opc_lxor                   = 131;
      # private static final int opc_iinc                   = 132;
      # private static final int opc_i2l                    = 133;
      # private static final int opc_i2f                    = 134;
      # private static final int opc_i2d                    = 135;
      # private static final int opc_l2i                    = 136;
      # private static final int opc_l2f                    = 137;
      # private static final int opc_l2d                    = 138;
      # private static final int opc_f2i                    = 139;
      # private static final int opc_f2l                    = 140;
      # private static final int opc_f2d                    = 141;
      # private static final int opc_d2i                    = 142;
      # private static final int opc_d2l                    = 143;
      # private static final int opc_d2f                    = 144;
      # private static final int opc_i2b                    = 145;
      # private static final int opc_i2c                    = 146;
      # private static final int opc_i2s                    = 147;
      # private static final int opc_lcmp                   = 148;
      # private static final int opc_fcmpl                  = 149;
      # private static final int opc_fcmpg                  = 150;
      # private static final int opc_dcmpl                  = 151;
      # private static final int opc_dcmpg                  = 152;
      # private static final int opc_ifeq                   = 153;
      # private static final int opc_ifne                   = 154;
      # private static final int opc_iflt                   = 155;
      # private static final int opc_ifge                   = 156;
      # private static final int opc_ifgt                   = 157;
      # private static final int opc_ifle                   = 158;
      # private static final int opc_if_icmpeq              = 159;
      # private static final int opc_if_icmpne              = 160;
      # private static final int opc_if_icmplt              = 161;
      # private static final int opc_if_icmpge              = 162;
      # private static final int opc_if_icmpgt              = 163;
      # private static final int opc_if_icmple              = 164;
      # private static final int opc_if_acmpeq              = 165;
      # private static final int opc_if_acmpne              = 166;
      # private static final int opc_goto                   = 167;
      # private static final int opc_jsr                    = 168;
      # private static final int opc_ret                    = 169;
      # private static final int opc_tableswitch            = 170;
      # private static final int opc_lookupswitch           = 171;
      const_set_lazy(:Opc_ireturn) { 172 }
      const_attr_reader  :Opc_ireturn
      
      const_set_lazy(:Opc_lreturn) { 173 }
      const_attr_reader  :Opc_lreturn
      
      const_set_lazy(:Opc_freturn) { 174 }
      const_attr_reader  :Opc_freturn
      
      const_set_lazy(:Opc_dreturn) { 175 }
      const_attr_reader  :Opc_dreturn
      
      const_set_lazy(:Opc_areturn) { 176 }
      const_attr_reader  :Opc_areturn
      
      const_set_lazy(:Opc_return) { 177 }
      const_attr_reader  :Opc_return
      
      const_set_lazy(:Opc_getstatic) { 178 }
      const_attr_reader  :Opc_getstatic
      
      const_set_lazy(:Opc_putstatic) { 179 }
      const_attr_reader  :Opc_putstatic
      
      const_set_lazy(:Opc_getfield) { 180 }
      const_attr_reader  :Opc_getfield
      
      # private static final int opc_putfield               = 181;
      const_set_lazy(:Opc_invokevirtual) { 182 }
      const_attr_reader  :Opc_invokevirtual
      
      const_set_lazy(:Opc_invokespecial) { 183 }
      const_attr_reader  :Opc_invokespecial
      
      const_set_lazy(:Opc_invokestatic) { 184 }
      const_attr_reader  :Opc_invokestatic
      
      const_set_lazy(:Opc_invokeinterface) { 185 }
      const_attr_reader  :Opc_invokeinterface
      
      const_set_lazy(:Opc_new) { 187 }
      const_attr_reader  :Opc_new
      
      # private static final int opc_newarray               = 188;
      const_set_lazy(:Opc_anewarray) { 189 }
      const_attr_reader  :Opc_anewarray
      
      # private static final int opc_arraylength            = 190;
      const_set_lazy(:Opc_athrow) { 191 }
      const_attr_reader  :Opc_athrow
      
      const_set_lazy(:Opc_checkcast) { 192 }
      const_attr_reader  :Opc_checkcast
      
      # private static final int opc_instanceof             = 193;
      # private static final int opc_monitorenter           = 194;
      # private static final int opc_monitorexit            = 195;
      const_set_lazy(:Opc_wide) { 196 }
      const_attr_reader  :Opc_wide
      
      # private static final int opc_multianewarray         = 197;
      # private static final int opc_ifnull                 = 198;
      # private static final int opc_ifnonnull              = 199;
      # private static final int opc_goto_w                 = 200;
      # private static final int opc_jsr_w                  = 201;
      # end of constants copied from sun.tools.java.RuntimeConstants
      # name of the superclass of proxy classes
      const_set_lazy(:SuperclassName) { "java/lang/reflect/Proxy" }
      const_attr_reader  :SuperclassName
      
      # name of field for storing a proxy instance's invocation handler
      const_set_lazy(:HandlerFieldName) { "h" }
      const_attr_reader  :HandlerFieldName
      
      # debugging flag for saving generated class files
      const_set_lazy(:SaveGeneratedFiles) { Java::Security::AccessController.do_privileged(GetBooleanAction.new("sun.misc.ProxyGenerator.saveGeneratedFiles")).boolean_value }
      const_attr_reader  :SaveGeneratedFiles
      
      typesig { [String, Array.typed(Class)] }
      # Generate a proxy class given a name and a list of proxy interfaces.
      def generate_proxy_class(name, interfaces)
        gen = ProxyGenerator.new(name, interfaces)
        class_file = gen.generate_class_file
        if (SaveGeneratedFiles)
          Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members ProxyGenerator
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              begin
                file = FileOutputStream.new(RJava.cast_to_string(dot_to_slash(name)) + ".class")
                file.write(class_file)
                file.close
                return nil
              rescue IOException => e
                raise InternalError.new("I/O exception saving generated file: " + RJava.cast_to_string(e))
              end
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        return class_file
      end
      
      # preloaded Method objects for methods in java.lang.Object
      
      def hash_code_method
        defined?(@@hash_code_method) ? @@hash_code_method : @@hash_code_method= nil
      end
      alias_method :attr_hash_code_method, :hash_code_method
      
      def hash_code_method=(value)
        @@hash_code_method = value
      end
      alias_method :attr_hash_code_method=, :hash_code_method=
      
      
      def equals_method
        defined?(@@equals_method) ? @@equals_method : @@equals_method= nil
      end
      alias_method :attr_equals_method, :equals_method
      
      def equals_method=(value)
        @@equals_method = value
      end
      alias_method :attr_equals_method=, :equals_method=
      
      
      def to_string_method
        defined?(@@to_string_method) ? @@to_string_method : @@to_string_method= nil
      end
      alias_method :attr_to_string_method, :to_string_method
      
      def to_string_method=(value)
        @@to_string_method = value
      end
      alias_method :attr_to_string_method=, :to_string_method=
      
      when_class_loaded do
        begin
          self.attr_hash_code_method = Object.get_method("hashCode")
          self.attr_equals_method = Object.get_method("equals", Array.typed(Class).new([Object]))
          self.attr_to_string_method = Object.get_method("toString")
        rescue NoSuchMethodException => e
          raise NoSuchMethodError.new(e.get_message)
        end
      end
    }
    
    # name of proxy class
    attr_accessor :class_name
    alias_method :attr_class_name, :class_name
    undef_method :class_name
    alias_method :attr_class_name=, :class_name=
    undef_method :class_name=
    
    # proxy interfaces
    attr_accessor :interfaces
    alias_method :attr_interfaces, :interfaces
    undef_method :interfaces
    alias_method :attr_interfaces=, :interfaces=
    undef_method :interfaces=
    
    # constant pool of class being generated
    attr_accessor :cp
    alias_method :attr_cp, :cp
    undef_method :cp
    alias_method :attr_cp=, :cp=
    undef_method :cp=
    
    # FieldInfo struct for each field of generated class
    attr_accessor :fields
    alias_method :attr_fields, :fields
    undef_method :fields
    alias_method :attr_fields=, :fields=
    undef_method :fields=
    
    # MethodInfo struct for each method of generated class
    attr_accessor :methods
    alias_method :attr_methods, :methods
    undef_method :methods
    alias_method :attr_methods=, :methods=
    undef_method :methods=
    
    # maps method signature string to list of ProxyMethod objects for
    # proxy methods with that signature
    attr_accessor :proxy_methods
    alias_method :attr_proxy_methods, :proxy_methods
    undef_method :proxy_methods
    alias_method :attr_proxy_methods=, :proxy_methods=
    undef_method :proxy_methods=
    
    # count of ProxyMethod objects added to proxyMethods
    attr_accessor :proxy_method_count
    alias_method :attr_proxy_method_count, :proxy_method_count
    undef_method :proxy_method_count
    alias_method :attr_proxy_method_count=, :proxy_method_count=
    undef_method :proxy_method_count=
    
    typesig { [String, Array.typed(Class)] }
    # Construct a ProxyGenerator to generate a proxy class with the
    # specified name and for the given interfaces.
    # 
    # A ProxyGenerator object contains the state for the ongoing
    # generation of a particular proxy class.
    def initialize(class_name, interfaces)
      @class_name = nil
      @interfaces = nil
      @cp = ConstantPool.new
      @fields = ArrayList.new
      @methods = ArrayList.new
      @proxy_methods = HashMap.new
      @proxy_method_count = 0
      @class_name = class_name
      @interfaces = interfaces
    end
    
    typesig { [] }
    # Generate a class file for the proxy class.  This method drives the
    # class file generation process.
    def generate_class_file
      # ============================================================
      # Step 1: Assemble ProxyMethod objects for all methods to
      # generate proxy dispatching code for.
      # 
      # 
      # Record that proxy methods are needed for the hashCode, equals,
      # and toString methods of java.lang.Object.  This is done before
      # the methods from the proxy interfaces so that the methods from
      # java.lang.Object take precedence over duplicate methods in the
      # proxy interfaces.
      add_proxy_method(self.attr_hash_code_method, Object)
      add_proxy_method(self.attr_equals_method, Object)
      add_proxy_method(self.attr_to_string_method, Object)
      # Now record all of the methods from the proxy interfaces, giving
      # earlier interfaces precedence over later ones with duplicate
      # methods.
      i = 0
      while i < @interfaces.attr_length
        methods = @interfaces[i].get_methods
        j = 0
        while j < methods.attr_length
          add_proxy_method(methods[j], @interfaces[i])
          j += 1
        end
        i += 1
      end
      # For each set of proxy methods with the same signature,
      # verify that the methods' return types are compatible.
      @proxy_methods.values.each do |sigmethods|
        check_return_types(sigmethods)
      end
      # ============================================================
      # Step 2: Assemble FieldInfo and MethodInfo structs for all of
      # fields and methods in the class we are generating.
      begin
        @methods.add(generate_constructor)
        @proxy_methods.values.each do |sigmethods|
          sigmethods.each do |pm|
            # add static field for method's Method object
            @fields.add(FieldInfo.new_local(self, pm.attr_method_field_name, "Ljava/lang/reflect/Method;", ACC_PRIVATE | ACC_STATIC))
            # generate code for proxy method and add it
            @methods.add(pm.generate_method)
          end
        end
        @methods.add(generate_static_initializer)
      rescue IOException => e
        raise InternalError.new("unexpected I/O Exception")
      end
      if (@methods.size > 65535)
        raise IllegalArgumentException.new("method limit exceeded")
      end
      if (@fields.size > 65535)
        raise IllegalArgumentException.new("field limit exceeded")
      end
      # ============================================================
      # Step 3: Write the final class file.
      # 
      # 
      # Make sure that constant pool indexes are reserved for the
      # following items before starting to write the final class file.
      @cp.get_class(dot_to_slash(@class_name))
      @cp.get_class(SuperclassName)
      i_ = 0
      while i_ < @interfaces.attr_length
        @cp.get_class(dot_to_slash(@interfaces[i_].get_name))
        i_ += 1
      end
      # Disallow new constant pool additions beyond this point, since
      # we are about to write the final constant pool table.
      @cp.set_read_only
      bout = ByteArrayOutputStream.new
      dout = DataOutputStream.new(bout)
      begin
        # Write all the items of the "ClassFile" structure.
        # See JVMS section 4.1.
        # 
        # u4 magic;
        dout.write_int(-0x35014542)
        # u2 minor_version;
        dout.write_short(CLASSFILE_MINOR_VERSION)
        # u2 major_version;
        dout.write_short(CLASSFILE_MAJOR_VERSION)
        @cp.write(dout) # (write constant pool)
        # u2 access_flags;
        dout.write_short(ACC_PUBLIC | ACC_FINAL | ACC_SUPER)
        # u2 this_class;
        dout.write_short(@cp.get_class(dot_to_slash(@class_name)))
        # u2 super_class;
        dout.write_short(@cp.get_class(SuperclassName))
        # u2 interfaces_count;
        dout.write_short(@interfaces.attr_length)
        # u2 interfaces[interfaces_count];
        i__ = 0
        while i__ < @interfaces.attr_length
          dout.write_short(@cp.get_class(dot_to_slash(@interfaces[i__].get_name)))
          i__ += 1
        end
        # u2 fields_count;
        dout.write_short(@fields.size)
        # field_info fields[fields_count];
        @fields.each do |f|
          f.write(dout)
        end
        # u2 methods_count;
        dout.write_short(@methods.size)
        # method_info methods[methods_count];
        @methods.each do |m|
          m.write(dout)
        end
        # u2 attributes_count;
        dout.write_short(0) # (no ClassFile attributes for proxy classes)
      rescue IOException => e
        raise InternalError.new("unexpected I/O Exception")
      end
      return bout.to_byte_array
    end
    
    typesig { [Method, Class] }
    # Add another method to be proxied, either by creating a new
    # ProxyMethod object or augmenting an old one for a duplicate
    # method.
    # 
    # "fromClass" indicates the proxy interface that the method was
    # found through, which may be different from (a subinterface of)
    # the method's "declaring class".  Note that the first Method
    # object passed for a given name and descriptor identifies the
    # Method object (and thus the declaring class) that will be
    # passed to the invocation handler's "invoke" method for a given
    # set of duplicate methods.
    def add_proxy_method(m, from_class)
      name = m.get_name
      parameter_types = m.get_parameter_types
      return_type = m.get_return_type
      exception_types = m.get_exception_types
      sig = name + RJava.cast_to_string(get_parameter_descriptors(parameter_types))
      sigmethods = @proxy_methods.get(sig)
      if (!(sigmethods).nil?)
        sigmethods.each do |pm|
          if ((return_type).equal?(pm.attr_return_type))
            # Found a match: reduce exception types to the
            # greatest set of exceptions that can thrown
            # compatibly with the throws clauses of both
            # overridden methods.
            legal_exceptions = ArrayList.new
            collect_compatible_types(exception_types, pm.attr_exception_types, legal_exceptions)
            collect_compatible_types(pm.attr_exception_types, exception_types, legal_exceptions)
            pm.attr_exception_types = Array.typed(Class).new(legal_exceptions.size) { nil }
            pm.attr_exception_types = legal_exceptions.to_array(pm.attr_exception_types)
            return
          end
        end
      else
        sigmethods = ArrayList.new(3)
        @proxy_methods.put(sig, sigmethods)
      end
      sigmethods.add(ProxyMethod.new_local(self, name, parameter_types, return_type, exception_types, from_class))
    end
    
    class_module.module_eval {
      typesig { [JavaList] }
      # For a given set of proxy methods with the same signature, check
      # that their return types are compatible according to the Proxy
      # specification.
      # 
      # Specifically, if there is more than one such method, then all
      # of the return types must be reference types, and there must be
      # one return type that is assignable to each of the rest of them.
      def check_return_types(methods)
        # If there is only one method with a given signature, there
        # cannot be a conflict.  This is the only case in which a
        # primitive (or void) return type is allowed.
        if (methods.size < 2)
          return
        end
        # List of return types that are not yet known to be
        # assignable from ("covered" by) any of the others.
        uncovered_return_types = LinkedList.new
        methods.each do |pm|
          catch(:next_next_new_return_type) do
            new_return_type = pm.attr_return_type
            if (new_return_type.is_primitive)
              raise IllegalArgumentException.new("methods with same signature " + RJava.cast_to_string(get_friendly_method_signature(pm.attr_method_name, pm.attr_parameter_types)) + " but incompatible return types: " + RJava.cast_to_string(new_return_type.get_name) + " and others")
            end
            added = false
            # Compare the new return type to the existing uncovered
            # return types.
            liter = uncovered_return_types.list_iterator
            while (liter.has_next)
              uncovered_return_type = liter.next_
              # If an existing uncovered return type is assignable
              # to this new one, then we can forget the new one.
              if (new_return_type.is_assignable_from(uncovered_return_type))
                raise AssertError if not (!added)
                throw :next_next_new_return_type, :thrown
              end
              # If the new return type is assignable to an existing
              # uncovered one, then should replace the existing one
              # with the new one (or just forget the existing one,
              # if the new one has already be put in the list).
              if (uncovered_return_type.is_assignable_from(new_return_type))
                # (we can assume that each return type is unique)
                if (!added)
                  liter.set(new_return_type)
                  added = true
                else
                  liter.remove
                end
              end
            end
            # If we got through the list of existing uncovered return
            # types without an assignability relationship, then add
            # the new return type to the list of uncovered ones.
            if (!added)
              uncovered_return_types.add(new_return_type)
            end
          end
        end
        # We shouldn't end up with more than one return type that is
        # not assignable from any of the others.
        if (uncovered_return_types.size > 1)
          pm = methods.get(0)
          raise IllegalArgumentException.new("methods with same signature " + RJava.cast_to_string(get_friendly_method_signature(pm.attr_method_name, pm.attr_parameter_types)) + " but incompatible return types: " + RJava.cast_to_string(uncovered_return_types))
        end
      end
      
      # A FieldInfo object contains information about a particular field
      # in the class being generated.  The class mirrors the data items of
      # the "field_info" structure of the class file format (see JVMS 4.5).
      const_set_lazy(:FieldInfo) { Class.new do
        extend LocalClass
        include_class_members ProxyGenerator
        
        attr_accessor :access_flags
        alias_method :attr_access_flags, :access_flags
        undef_method :access_flags
        alias_method :attr_access_flags=, :access_flags=
        undef_method :access_flags=
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :descriptor
        alias_method :attr_descriptor, :descriptor
        undef_method :descriptor
        alias_method :attr_descriptor=, :descriptor=
        undef_method :descriptor=
        
        typesig { [String, String, ::Java::Int] }
        def initialize(name, descriptor, access_flags)
          @access_flags = 0
          @name = nil
          @descriptor = nil
          @name = name
          @descriptor = descriptor
          @access_flags = access_flags
          # Make sure that constant pool indexes are reserved for the
          # following items before starting to write the final class file.
          self.attr_cp.get_utf8(name)
          self.attr_cp.get_utf8(descriptor)
        end
        
        typesig { [DataOutputStream] }
        def write(out)
          # Write all the items of the "field_info" structure.
          # See JVMS section 4.5.
          # 
          # u2 access_flags;
          out.write_short(@access_flags)
          # u2 name_index;
          out.write_short(self.attr_cp.get_utf8(@name))
          # u2 descriptor_index;
          out.write_short(self.attr_cp.get_utf8(@descriptor))
          # u2 attributes_count;
          out.write_short(0) # (no field_info attributes for proxy classes)
        end
        
        private
        alias_method :initialize__field_info, :initialize
      end }
      
      # An ExceptionTableEntry object holds values for the data items of
      # an entry in the "exception_table" item of the "Code" attribute of
      # "method_info" structures (see JVMS 4.7.3).
      const_set_lazy(:ExceptionTableEntry) { Class.new do
        include_class_members ProxyGenerator
        
        attr_accessor :start_pc
        alias_method :attr_start_pc, :start_pc
        undef_method :start_pc
        alias_method :attr_start_pc=, :start_pc=
        undef_method :start_pc=
        
        attr_accessor :end_pc
        alias_method :attr_end_pc, :end_pc
        undef_method :end_pc
        alias_method :attr_end_pc=, :end_pc=
        undef_method :end_pc=
        
        attr_accessor :handler_pc
        alias_method :attr_handler_pc, :handler_pc
        undef_method :handler_pc
        alias_method :attr_handler_pc=, :handler_pc=
        undef_method :handler_pc=
        
        attr_accessor :catch_type
        alias_method :attr_catch_type, :catch_type
        undef_method :catch_type
        alias_method :attr_catch_type=, :catch_type=
        undef_method :catch_type=
        
        typesig { [::Java::Short, ::Java::Short, ::Java::Short, ::Java::Short] }
        def initialize(start_pc, end_pc, handler_pc, catch_type)
          @start_pc = 0
          @end_pc = 0
          @handler_pc = 0
          @catch_type = 0
          @start_pc = start_pc
          @end_pc = end_pc
          @handler_pc = handler_pc
          @catch_type = catch_type
        end
        
        private
        alias_method :initialize__exception_table_entry, :initialize
      end }
      
      # A MethodInfo object contains information about a particular method
      # in the class being generated.  This class mirrors the data items of
      # the "method_info" structure of the class file format (see JVMS 4.6).
      const_set_lazy(:MethodInfo) { Class.new do
        extend LocalClass
        include_class_members ProxyGenerator
        
        attr_accessor :access_flags
        alias_method :attr_access_flags, :access_flags
        undef_method :access_flags
        alias_method :attr_access_flags=, :access_flags=
        undef_method :access_flags=
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :descriptor
        alias_method :attr_descriptor, :descriptor
        undef_method :descriptor
        alias_method :attr_descriptor=, :descriptor=
        undef_method :descriptor=
        
        attr_accessor :max_stack
        alias_method :attr_max_stack, :max_stack
        undef_method :max_stack
        alias_method :attr_max_stack=, :max_stack=
        undef_method :max_stack=
        
        attr_accessor :max_locals
        alias_method :attr_max_locals, :max_locals
        undef_method :max_locals
        alias_method :attr_max_locals=, :max_locals=
        undef_method :max_locals=
        
        attr_accessor :code
        alias_method :attr_code, :code
        undef_method :code
        alias_method :attr_code=, :code=
        undef_method :code=
        
        attr_accessor :exception_table
        alias_method :attr_exception_table, :exception_table
        undef_method :exception_table
        alias_method :attr_exception_table=, :exception_table=
        undef_method :exception_table=
        
        attr_accessor :declared_exceptions
        alias_method :attr_declared_exceptions, :declared_exceptions
        undef_method :declared_exceptions
        alias_method :attr_declared_exceptions=, :declared_exceptions=
        undef_method :declared_exceptions=
        
        typesig { [String, String, ::Java::Int] }
        def initialize(name, descriptor, access_flags)
          @access_flags = 0
          @name = nil
          @descriptor = nil
          @max_stack = 0
          @max_locals = 0
          @code = ByteArrayOutputStream.new
          @exception_table = ArrayList.new
          @declared_exceptions = nil
          @name = name
          @descriptor = descriptor
          @access_flags = access_flags
          # Make sure that constant pool indexes are reserved for the
          # following items before starting to write the final class file.
          self.attr_cp.get_utf8(name)
          self.attr_cp.get_utf8(descriptor)
          self.attr_cp.get_utf8("Code")
          self.attr_cp.get_utf8("Exceptions")
        end
        
        typesig { [DataOutputStream] }
        def write(out)
          # Write all the items of the "method_info" structure.
          # See JVMS section 4.6.
          # 
          # u2 access_flags;
          out.write_short(@access_flags)
          # u2 name_index;
          out.write_short(self.attr_cp.get_utf8(@name))
          # u2 descriptor_index;
          out.write_short(self.attr_cp.get_utf8(@descriptor))
          # u2 attributes_count;
          out.write_short(2) # (two method_info attributes:)
          # Write "Code" attribute. See JVMS section 4.7.3.
          # u2 attribute_name_index;
          out.write_short(self.attr_cp.get_utf8("Code"))
          # u4 attribute_length;
          out.write_int(12 + @code.size + 8 * @exception_table.size)
          # u2 max_stack;
          out.write_short(@max_stack)
          # u2 max_locals;
          out.write_short(@max_locals)
          # u2 code_length;
          out.write_int(@code.size)
          # u1 code[code_length];
          @code.write_to(out)
          # u2 exception_table_length;
          out.write_short(@exception_table.size)
          @exception_table.each do |e|
            # u2 start_pc;
            out.write_short(e.attr_start_pc)
            # u2 end_pc;
            out.write_short(e.attr_end_pc)
            # u2 handler_pc;
            out.write_short(e.attr_handler_pc)
            # u2 catch_type;
            out.write_short(e.attr_catch_type)
          end
          # u2 attributes_count;
          out.write_short(0)
          # write "Exceptions" attribute.  See JVMS section 4.7.4.
          # u2 attribute_name_index;
          out.write_short(self.attr_cp.get_utf8("Exceptions"))
          # u4 attributes_length;
          out.write_int(2 + 2 * @declared_exceptions.attr_length)
          # u2 number_of_exceptions;
          out.write_short(@declared_exceptions.attr_length)
          # u2 exception_index_table[number_of_exceptions];
          i = 0
          while i < @declared_exceptions.attr_length
            out.write_short(@declared_exceptions[i])
            i += 1
          end
        end
        
        private
        alias_method :initialize__method_info, :initialize
      end }
      
      # A ProxyMethod object represents a proxy method in the proxy class
      # being generated: a method whose implementation will encode and
      # dispatch invocations to the proxy instance's invocation handler.
      const_set_lazy(:ProxyMethod) { Class.new do
        extend LocalClass
        include_class_members ProxyGenerator
        
        attr_accessor :method_name
        alias_method :attr_method_name, :method_name
        undef_method :method_name
        alias_method :attr_method_name=, :method_name=
        undef_method :method_name=
        
        attr_accessor :parameter_types
        alias_method :attr_parameter_types, :parameter_types
        undef_method :parameter_types
        alias_method :attr_parameter_types=, :parameter_types=
        undef_method :parameter_types=
        
        attr_accessor :return_type
        alias_method :attr_return_type, :return_type
        undef_method :return_type
        alias_method :attr_return_type=, :return_type=
        undef_method :return_type=
        
        attr_accessor :exception_types
        alias_method :attr_exception_types, :exception_types
        undef_method :exception_types
        alias_method :attr_exception_types=, :exception_types=
        undef_method :exception_types=
        
        attr_accessor :from_class
        alias_method :attr_from_class, :from_class
        undef_method :from_class
        alias_method :attr_from_class=, :from_class=
        undef_method :from_class=
        
        attr_accessor :method_field_name
        alias_method :attr_method_field_name, :method_field_name
        undef_method :method_field_name
        alias_method :attr_method_field_name=, :method_field_name=
        undef_method :method_field_name=
        
        typesig { [String, Array.typed(Class), Class, Array.typed(Class), Class] }
        def initialize(method_name, parameter_types, return_type, exception_types, from_class)
          @method_name = nil
          @parameter_types = nil
          @return_type = nil
          @exception_types = nil
          @from_class = nil
          @method_field_name = nil
          @method_name = method_name
          @parameter_types = parameter_types
          @return_type = return_type
          @exception_types = exception_types
          @from_class = from_class
          @method_field_name = "m" + RJava.cast_to_string(((self.attr_proxy_method_count += 1) - 1))
        end
        
        typesig { [] }
        # Return a MethodInfo object for this method, including generating
        # the code and exception table entry.
        def generate_method
          desc = get_method_descriptor(@parameter_types, @return_type)
          minfo = MethodInfo.new(@method_name, desc, ACC_PUBLIC | ACC_FINAL)
          parameter_slot = Array.typed(::Java::Int).new(@parameter_types.attr_length) { 0 }
          next_slot = 1
          i = 0
          while i < parameter_slot.attr_length
            parameter_slot[i] = next_slot
            next_slot += get_words_per_type(@parameter_types[i])
            i += 1
          end
          local_slot0 = next_slot
          pc = 0
          try_begin = 0
          try_end = 0
          out = DataOutputStream.new(minfo.attr_code)
          code_aload(0, out)
          out.write_byte(Opc_getfield)
          out.write_short(self.attr_cp.get_field_ref(SuperclassName, HandlerFieldName, "Ljava/lang/reflect/InvocationHandler;"))
          code_aload(0, out)
          out.write_byte(Opc_getstatic)
          out.write_short(self.attr_cp.get_field_ref(dot_to_slash(self.attr_class_name), @method_field_name, "Ljava/lang/reflect/Method;"))
          if (@parameter_types.attr_length > 0)
            code_ipush(@parameter_types.attr_length, out)
            out.write_byte(Opc_anewarray)
            out.write_short(self.attr_cp.get_class("java/lang/Object"))
            i_ = 0
            while i_ < @parameter_types.attr_length
              out.write_byte(Opc_dup)
              code_ipush(i_, out)
              code_wrap_argument(@parameter_types[i_], parameter_slot[i_], out)
              out.write_byte(Opc_aastore)
              i_ += 1
            end
          else
            out.write_byte(Opc_aconst_null)
          end
          out.write_byte(Opc_invokeinterface)
          out.write_short(self.attr_cp.get_interface_method_ref("java/lang/reflect/InvocationHandler", "invoke", "(Ljava/lang/Object;Ljava/lang/reflect/Method;" + "[Ljava/lang/Object;)Ljava/lang/Object;"))
          out.write_byte(4)
          out.write_byte(0)
          if ((@return_type).equal?(self.attr_void.attr_class))
            out.write_byte(Opc_pop)
            out.write_byte(Opc_return)
          else
            code_unwrap_return_value(@return_type, out)
          end
          try_end = pc = RJava.cast_to_short(minfo.attr_code.size)
          catch_list = compute_unique_catch_list(@exception_types)
          if (catch_list.size > 0)
            catch_list.each do |ex|
              minfo.attr_exception_table.add(ExceptionTableEntry.new(try_begin, try_end, pc, self.attr_cp.get_class(dot_to_slash(ex.get_name))))
            end
            out.write_byte(Opc_athrow)
            pc = RJava.cast_to_short(minfo.attr_code.size)
            minfo.attr_exception_table.add(ExceptionTableEntry.new(try_begin, try_end, pc, self.attr_cp.get_class("java/lang/Throwable")))
            code_astore(local_slot0, out)
            out.write_byte(Opc_new)
            out.write_short(self.attr_cp.get_class("java/lang/reflect/UndeclaredThrowableException"))
            out.write_byte(Opc_dup)
            code_aload(local_slot0, out)
            out.write_byte(Opc_invokespecial)
            out.write_short(self.attr_cp.get_method_ref("java/lang/reflect/UndeclaredThrowableException", "<init>", "(Ljava/lang/Throwable;)V"))
            out.write_byte(Opc_athrow)
          end
          if (minfo.attr_code.size > 65535)
            raise IllegalArgumentException.new("code size limit exceeded")
          end
          minfo.attr_max_stack = 10
          minfo.attr_max_locals = RJava.cast_to_short((local_slot0 + 1))
          minfo.attr_declared_exceptions = Array.typed(::Java::Short).new(@exception_types.attr_length) { 0 }
          i_ = 0
          while i_ < @exception_types.attr_length
            minfo.attr_declared_exceptions[i_] = self.attr_cp.get_class(dot_to_slash(@exception_types[i_].get_name))
            i_ += 1
          end
          return minfo
        end
        
        typesig { [Class, ::Java::Int, DataOutputStream] }
        # Generate code for wrapping an argument of the given type
        # whose value can be found at the specified local variable
        # index, in order for it to be passed (as an Object) to the
        # invocation handler's "invoke" method.  The code is written
        # to the supplied stream.
        def code_wrap_argument(type, slot, out)
          if (type.is_primitive)
            prim = PrimitiveTypeInfo.get(type)
            if ((type).equal?(Array) || (type).equal?(Array) || (type).equal?(Array) || (type).equal?(Array) || (type).equal?(Array))
              code_iload(slot, out)
            else
              if ((type).equal?(Array))
                code_lload(slot, out)
              else
                if ((type).equal?(Array))
                  code_fload(slot, out)
                else
                  if ((type).equal?(Array))
                    code_dload(slot, out)
                  else
                    raise AssertionError.new
                  end
                end
              end
            end
            out.write_byte(Opc_invokestatic)
            out.write_short(self.attr_cp.get_method_ref(prim.attr_wrapper_class_name, "valueOf", prim.attr_wrapper_value_of_desc))
          else
            code_aload(slot, out)
          end
        end
        
        typesig { [Class, DataOutputStream] }
        # Generate code for unwrapping a return value of the given
        # type from the invocation handler's "invoke" method (as type
        # Object) to its correct type.  The code is written to the
        # supplied stream.
        def code_unwrap_return_value(type, out)
          if (type.is_primitive)
            prim = PrimitiveTypeInfo.get(type)
            out.write_byte(Opc_checkcast)
            out.write_short(self.attr_cp.get_class(prim.attr_wrapper_class_name))
            out.write_byte(Opc_invokevirtual)
            out.write_short(self.attr_cp.get_method_ref(prim.attr_wrapper_class_name, prim.attr_unwrap_method_name, prim.attr_unwrap_method_desc))
            if ((type).equal?(Array) || (type).equal?(Array) || (type).equal?(Array) || (type).equal?(Array) || (type).equal?(Array))
              out.write_byte(Opc_ireturn)
            else
              if ((type).equal?(Array))
                out.write_byte(Opc_lreturn)
              else
                if ((type).equal?(Array))
                  out.write_byte(Opc_freturn)
                else
                  if ((type).equal?(Array))
                    out.write_byte(Opc_dreturn)
                  else
                    raise AssertionError.new
                  end
                end
              end
            end
          else
            out.write_byte(Opc_checkcast)
            out.write_short(self.attr_cp.get_class(dot_to_slash(type.get_name)))
            out.write_byte(Opc_areturn)
          end
        end
        
        typesig { [DataOutputStream] }
        # Generate code for initializing the static field that stores
        # the Method object for this proxy method.  The code is written
        # to the supplied stream.
        def code_field_initialization(out)
          code_class_for_name(@from_class, out)
          code_ldc(self.attr_cp.get_string(@method_name), out)
          code_ipush(@parameter_types.attr_length, out)
          out.write_byte(Opc_anewarray)
          out.write_short(self.attr_cp.get_class("java/lang/Class"))
          i = 0
          while i < @parameter_types.attr_length
            out.write_byte(Opc_dup)
            code_ipush(i, out)
            if (@parameter_types[i].is_primitive)
              prim = PrimitiveTypeInfo.get(@parameter_types[i])
              out.write_byte(Opc_getstatic)
              out.write_short(self.attr_cp.get_field_ref(prim.attr_wrapper_class_name, "TYPE", "Ljava/lang/Class;"))
            else
              code_class_for_name(@parameter_types[i], out)
            end
            out.write_byte(Opc_aastore)
            i += 1
          end
          out.write_byte(Opc_invokevirtual)
          out.write_short(self.attr_cp.get_method_ref("java/lang/Class", "getMethod", "(Ljava/lang/String;[Ljava/lang/Class;)" + "Ljava/lang/reflect/Method;"))
          out.write_byte(Opc_putstatic)
          out.write_short(self.attr_cp.get_field_ref(dot_to_slash(self.attr_class_name), @method_field_name, "Ljava/lang/reflect/Method;"))
        end
        
        private
        alias_method :initialize__proxy_method, :initialize
      end }
    }
    
    typesig { [] }
    # Generate the constructor method for the proxy class.
    def generate_constructor
      minfo = MethodInfo.new_local(self, "<init>", "(Ljava/lang/reflect/InvocationHandler;)V", ACC_PUBLIC)
      out = DataOutputStream.new(minfo.attr_code)
      code_aload(0, out)
      code_aload(1, out)
      out.write_byte(Opc_invokespecial)
      out.write_short(@cp.get_method_ref(SuperclassName, "<init>", "(Ljava/lang/reflect/InvocationHandler;)V"))
      out.write_byte(Opc_return)
      minfo.attr_max_stack = 10
      minfo.attr_max_locals = 2
      minfo.attr_declared_exceptions = Array.typed(::Java::Short).new(0) { 0 }
      return minfo
    end
    
    typesig { [] }
    # Generate the static initializer method for the proxy class.
    def generate_static_initializer
      minfo = MethodInfo.new_local(self, "<clinit>", "()V", ACC_STATIC)
      local_slot0 = 1
      pc = 0
      try_begin = 0
      try_end = 0
      out = DataOutputStream.new(minfo.attr_code)
      @proxy_methods.values.each do |sigmethods|
        sigmethods.each do |pm|
          pm.code_field_initialization(out)
        end
      end
      out.write_byte(Opc_return)
      try_end = pc = RJava.cast_to_short(minfo.attr_code.size)
      minfo.attr_exception_table.add(ExceptionTableEntry.new(try_begin, try_end, pc, @cp.get_class("java/lang/NoSuchMethodException")))
      code_astore(local_slot0, out)
      out.write_byte(Opc_new)
      out.write_short(@cp.get_class("java/lang/NoSuchMethodError"))
      out.write_byte(Opc_dup)
      code_aload(local_slot0, out)
      out.write_byte(Opc_invokevirtual)
      out.write_short(@cp.get_method_ref("java/lang/Throwable", "getMessage", "()Ljava/lang/String;"))
      out.write_byte(Opc_invokespecial)
      out.write_short(@cp.get_method_ref("java/lang/NoSuchMethodError", "<init>", "(Ljava/lang/String;)V"))
      out.write_byte(Opc_athrow)
      pc = RJava.cast_to_short(minfo.attr_code.size)
      minfo.attr_exception_table.add(ExceptionTableEntry.new(try_begin, try_end, pc, @cp.get_class("java/lang/ClassNotFoundException")))
      code_astore(local_slot0, out)
      out.write_byte(Opc_new)
      out.write_short(@cp.get_class("java/lang/NoClassDefFoundError"))
      out.write_byte(Opc_dup)
      code_aload(local_slot0, out)
      out.write_byte(Opc_invokevirtual)
      out.write_short(@cp.get_method_ref("java/lang/Throwable", "getMessage", "()Ljava/lang/String;"))
      out.write_byte(Opc_invokespecial)
      out.write_short(@cp.get_method_ref("java/lang/NoClassDefFoundError", "<init>", "(Ljava/lang/String;)V"))
      out.write_byte(Opc_athrow)
      if (minfo.attr_code.size > 65535)
        raise IllegalArgumentException.new("code size limit exceeded")
      end
      minfo.attr_max_stack = 10
      minfo.attr_max_locals = RJava.cast_to_short((local_slot0 + 1))
      minfo.attr_declared_exceptions = Array.typed(::Java::Short).new(0) { 0 }
      return minfo
    end
    
    typesig { [::Java::Int, DataOutputStream] }
    # =============== Code Generation Utility Methods ===============
    # 
    # 
    # The following methods generate code for the load or store operation
    # indicated by their name for the given local variable.  The code is
    # written to the supplied stream.
    def code_iload(lvar, out)
      code_local_load_store(lvar, Opc_iload, Opc_iload_0, out)
    end
    
    typesig { [::Java::Int, DataOutputStream] }
    def code_lload(lvar, out)
      code_local_load_store(lvar, Opc_lload, Opc_lload_0, out)
    end
    
    typesig { [::Java::Int, DataOutputStream] }
    def code_fload(lvar, out)
      code_local_load_store(lvar, Opc_fload, Opc_fload_0, out)
    end
    
    typesig { [::Java::Int, DataOutputStream] }
    def code_dload(lvar, out)
      code_local_load_store(lvar, Opc_dload, Opc_dload_0, out)
    end
    
    typesig { [::Java::Int, DataOutputStream] }
    def code_aload(lvar, out)
      code_local_load_store(lvar, Opc_aload, Opc_aload_0, out)
    end
    
    typesig { [::Java::Int, DataOutputStream] }
    # private void code_istore(int lvar, DataOutputStream out)
    # throws IOException
    # {
    # codeLocalLoadStore(lvar, opc_istore, opc_istore_0, out);
    # }
    # private void code_lstore(int lvar, DataOutputStream out)
    # throws IOException
    # {
    # codeLocalLoadStore(lvar, opc_lstore, opc_lstore_0, out);
    # }
    # private void code_fstore(int lvar, DataOutputStream out)
    # throws IOException
    # {
    # codeLocalLoadStore(lvar, opc_fstore, opc_fstore_0, out);
    # }
    # private void code_dstore(int lvar, DataOutputStream out)
    # throws IOException
    # {
    # codeLocalLoadStore(lvar, opc_dstore, opc_dstore_0, out);
    # }
    def code_astore(lvar, out)
      code_local_load_store(lvar, Opc_astore, Opc_astore_0, out)
    end
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, DataOutputStream] }
    # Generate code for a load or store instruction for the given local
    # variable.  The code is written to the supplied stream.
    # 
    # "opcode" indicates the opcode form of the desired load or store
    # instruction that takes an explicit local variable index, and
    # "opcode_0" indicates the corresponding form of the instruction
    # with the implicit index 0.
    def code_local_load_store(lvar, opcode, opcode_0, out)
      raise AssertError if not (lvar >= 0 && lvar <= 0xffff)
      if (lvar <= 3)
        out.write_byte(opcode_0 + lvar)
      else
        if (lvar <= 0xff)
          out.write_byte(opcode)
          out.write_byte(lvar & 0xff)
        else
          # Use the "wide" instruction modifier for local variable
          # indexes that do not fit into an unsigned byte.
          out.write_byte(Opc_wide)
          out.write_byte(opcode)
          out.write_short(lvar & 0xffff)
        end
      end
    end
    
    typesig { [::Java::Int, DataOutputStream] }
    # Generate code for an "ldc" instruction for the given constant pool
    # index (the "ldc_w" instruction is used if the index does not fit
    # into an unsigned byte).  The code is written to the supplied stream.
    def code_ldc(index, out)
      raise AssertError if not (index >= 0 && index <= 0xffff)
      if (index <= 0xff)
        out.write_byte(Opc_ldc)
        out.write_byte(index & 0xff)
      else
        out.write_byte(Opc_ldc_w)
        out.write_short(index & 0xffff)
      end
    end
    
    typesig { [::Java::Int, DataOutputStream] }
    # Generate code to push a constant integer value on to the operand
    # stack, using the "iconst_<i>", "bipush", or "sipush" instructions
    # depending on the size of the value.  The code is written to the
    # supplied stream.
    def code_ipush(value, out)
      if (value >= -1 && value <= 5)
        out.write_byte(Opc_iconst_0 + value)
      else
        if (value >= Byte::MIN_VALUE && value <= Byte::MAX_VALUE)
          out.write_byte(Opc_bipush)
          out.write_byte(value & 0xff)
        else
          if (value >= Short::MIN_VALUE && value <= Short::MAX_VALUE)
            out.write_byte(Opc_sipush)
            out.write_short(value & 0xffff)
          else
            raise AssertionError.new
          end
        end
      end
    end
    
    typesig { [Class, DataOutputStream] }
    # Generate code to invoke the Class.forName with the name of the given
    # class to get its Class object at runtime.  The code is written to
    # the supplied stream.  Note that the code generated by this method
    # may caused the checked ClassNotFoundException to be thrown.
    def code_class_for_name(cl, out)
      code_ldc(@cp.get_string(cl.get_name), out)
      out.write_byte(Opc_invokestatic)
      out.write_short(@cp.get_method_ref("java/lang/Class", "forName", "(Ljava/lang/String;)Ljava/lang/Class;"))
    end
    
    class_module.module_eval {
      typesig { [String] }
      # ==================== General Utility Methods ====================
      # 
      # 
      # Convert a fully qualified class name that uses '.' as the package
      # separator, the external representation used by the Java language
      # and APIs, to a fully qualified class name that uses '/' as the
      # package separator, the representation used in the class file
      # format (see JVMS section 4.2).
      def dot_to_slash(name)
        return name.replace(Character.new(?..ord), Character.new(?/.ord))
      end
      
      typesig { [Array.typed(Class), Class] }
      # Return the "method descriptor" string for a method with the given
      # parameter types and return type.  See JVMS section 4.3.3.
      def get_method_descriptor(parameter_types, return_type)
        return get_parameter_descriptors(parameter_types) + (((return_type).equal?(self.attr_void.attr_class)) ? "V" : get_field_type(return_type))
      end
      
      typesig { [Array.typed(Class)] }
      # Return the list of "parameter descriptor" strings enclosed in
      # parentheses corresponding to the given parameter types (in other
      # words, a method descriptor without a return descriptor).  This
      # string is useful for constructing string keys for methods without
      # regard to their return type.
      def get_parameter_descriptors(parameter_types)
        desc = StringBuilder.new("(")
        i = 0
        while i < parameter_types.attr_length
          desc.append(get_field_type(parameter_types[i]))
          i += 1
        end
        desc.append(Character.new(?).ord))
        return desc.to_s
      end
      
      typesig { [Class] }
      # Return the "field type" string for the given type, appropriate for
      # a field descriptor, a parameter descriptor, or a return descriptor
      # other than "void".  See JVMS section 4.3.2.
      def get_field_type(type)
        if (type.is_primitive)
          return PrimitiveTypeInfo.get(type).attr_base_type_string
        else
          if (type.is_array)
            # According to JLS 20.3.2, the getName() method on Class does
            # return the VM type descriptor format for array classes (only);
            # using that should be quicker than the otherwise obvious code:
            # 
            # return "[" + getTypeDescriptor(type.getComponentType());
            return type.get_name.replace(Character.new(?..ord), Character.new(?/.ord))
          else
            return "L" + RJava.cast_to_string(dot_to_slash(type.get_name)) + ";"
          end
        end
      end
      
      typesig { [String, Array.typed(Class)] }
      # Returns a human-readable string representing the signature of a
      # method with the given name and parameter types.
      def get_friendly_method_signature(name, parameter_types)
        sig = StringBuilder.new(name)
        sig.append(Character.new(?(.ord))
        i = 0
        while i < parameter_types.attr_length
          if (i > 0)
            sig.append(Character.new(?,.ord))
          end
          parameter_type = parameter_types[i]
          dimensions = 0
          while (parameter_type.is_array)
            parameter_type = parameter_type.get_component_type
            dimensions += 1
          end
          sig.append(parameter_type.get_name)
          while (((dimensions -= 1) + 1) > 0)
            sig.append("[]")
          end
          i += 1
        end
        sig.append(Character.new(?).ord))
        return sig.to_s
      end
      
      typesig { [Class] }
      # Return the number of abstract "words", or consecutive local variable
      # indexes, required to contain a value of the given type.  See JVMS
      # section 3.6.1.
      # 
      # Note that the original version of the JVMS contained a definition of
      # this abstract notion of a "word" in section 3.4, but that definition
      # was removed for the second edition.
      def get_words_per_type(type)
        if ((type).equal?(Array) || (type).equal?(Array))
          return 2
        else
          return 1
        end
      end
      
      typesig { [Array.typed(Class), Array.typed(Class), JavaList] }
      # Add to the given list all of the types in the "from" array that
      # are not already contained in the list and are assignable to at
      # least one of the types in the "with" array.
      # 
      # This method is useful for computing the greatest common set of
      # declared exceptions from duplicate methods inherited from
      # different interfaces.
      def collect_compatible_types(from, with, list)
        i = 0
        while i < from.attr_length
          if (!list.contains(from[i]))
            j = 0
            while j < with.attr_length
              if (with[j].is_assignable_from(from[i]))
                list.add(from[i])
                break
              end
              j += 1
            end
          end
          i += 1
        end
      end
      
      typesig { [Array.typed(Class)] }
      # Given the exceptions declared in the throws clause of a proxy method,
      # compute the exceptions that need to be caught from the invocation
      # handler's invoke method and rethrown intact in the method's
      # implementation before catching other Throwables and wrapping them
      # in UndeclaredThrowableExceptions.
      # 
      # The exceptions to be caught are returned in a List object.  Each
      # exception in the returned list is guaranteed to not be a subclass of
      # any of the other exceptions in the list, so the catch blocks for
      # these exceptions may be generated in any order relative to each other.
      # 
      # Error and RuntimeException are each always contained by the returned
      # list (if none of their superclasses are contained), since those
      # unchecked exceptions should always be rethrown intact, and thus their
      # subclasses will never appear in the returned list.
      # 
      # The returned List will be empty if java.lang.Throwable is in the
      # given list of declared exceptions, indicating that no exceptions
      # need to be caught.
      def compute_unique_catch_list(exceptions)
        unique_list = ArrayList.new
        # unique exceptions to catch
        unique_list.add(JavaError) # always catch/rethrow these
        unique_list.add(RuntimeException)
        i = 0
        while i < exceptions.attr_length
          catch(:next_next_exception) do
            ex = exceptions[i]
            if (ex.is_assignable_from(JavaThrowable))
              # If Throwable is declared to be thrown by the proxy method,
              # then no catch blocks are necessary, because the invoke
              # can, at most, throw Throwable anyway.
              unique_list.clear
              break
            else
              if (!JavaThrowable.is_assignable_from(ex))
                # Ignore types that cannot be thrown by the invoke method.
                i += 1
                next
              end
            end
            # Compare this exception against the current list of
            # exceptions that need to be caught:
            j = 0
            while j < unique_list.size
              ex2 = unique_list.get(j)
              if (ex2.is_assignable_from(ex))
                # if a superclass of this exception is already on
                # the list to catch, then ignore this one and continue;
                throw :next_next_exception, :thrown
              else
                if (ex.is_assignable_from(ex2))
                  # if a subclass of this exception is on the list
                  # to catch, then remove it;
                  unique_list.remove(j)
                else
                  j += 1 # else continue comparing.
                end
              end
            end
            # This exception is unique (so far): add it to the list to catch.
            unique_list.add(ex)
          end
          i += 1
        end
        return unique_list
      end
      
      # A PrimitiveTypeInfo object contains assorted information about
      # a primitive type in its public fields.  The struct for a particular
      # primitive type can be obtained using the static "get" method.
      const_set_lazy(:PrimitiveTypeInfo) { Class.new do
        include_class_members ProxyGenerator
        
        # "base type" used in various descriptors (see JVMS section 4.3.2)
        attr_accessor :base_type_string
        alias_method :attr_base_type_string, :base_type_string
        undef_method :base_type_string
        alias_method :attr_base_type_string=, :base_type_string=
        undef_method :base_type_string=
        
        # name of corresponding wrapper class
        attr_accessor :wrapper_class_name
        alias_method :attr_wrapper_class_name, :wrapper_class_name
        undef_method :wrapper_class_name
        alias_method :attr_wrapper_class_name=, :wrapper_class_name=
        undef_method :wrapper_class_name=
        
        # method descriptor for wrapper class "valueOf" factory method
        attr_accessor :wrapper_value_of_desc
        alias_method :attr_wrapper_value_of_desc, :wrapper_value_of_desc
        undef_method :wrapper_value_of_desc
        alias_method :attr_wrapper_value_of_desc=, :wrapper_value_of_desc=
        undef_method :wrapper_value_of_desc=
        
        # name of wrapper class method for retrieving primitive value
        attr_accessor :unwrap_method_name
        alias_method :attr_unwrap_method_name, :unwrap_method_name
        undef_method :unwrap_method_name
        alias_method :attr_unwrap_method_name=, :unwrap_method_name=
        undef_method :unwrap_method_name=
        
        # descriptor of same method
        attr_accessor :unwrap_method_desc
        alias_method :attr_unwrap_method_desc, :unwrap_method_desc
        undef_method :unwrap_method_desc
        alias_method :attr_unwrap_method_desc=, :unwrap_method_desc=
        undef_method :unwrap_method_desc=
        
        class_module.module_eval {
          
          def table
            defined?(@@table) ? @@table : @@table= HashMap.new
          end
          alias_method :attr_table, :table
          
          def table=(value)
            @@table = value
          end
          alias_method :attr_table=, :table=
          
          when_class_loaded do
            add(Array, Byte)
            add(Array, Character)
            add(Array, Double)
            add(Array, Float)
            add(Array, JavaInteger)
            add(Array, Long)
            add(Array, Short)
            add(Array, Boolean)
          end
          
          typesig { [Class, Class] }
          def add(primitive_class, wrapper_class)
            self.attr_table.put(primitive_class, PrimitiveTypeInfo.new(primitive_class, wrapper_class))
          end
        }
        
        typesig { [Class, Class] }
        def initialize(primitive_class, wrapper_class)
          @base_type_string = nil
          @wrapper_class_name = nil
          @wrapper_value_of_desc = nil
          @unwrap_method_name = nil
          @unwrap_method_desc = nil
          raise AssertError if not (primitive_class.is_primitive)
          @base_type_string = RJava.cast_to_string(Array.new_instance(primitive_class, 0).get_class.get_name.substring(1))
          @wrapper_class_name = RJava.cast_to_string(dot_to_slash(wrapper_class.get_name))
          @wrapper_value_of_desc = "(" + @base_type_string + ")L" + @wrapper_class_name + ";"
          @unwrap_method_name = RJava.cast_to_string(primitive_class.get_name) + "Value"
          @unwrap_method_desc = "()" + @base_type_string
        end
        
        class_module.module_eval {
          typesig { [Class] }
          def get(cl)
            return self.attr_table.get(cl)
          end
        }
        
        private
        alias_method :initialize__primitive_type_info, :initialize
      end }
      
      # A ConstantPool object represents the constant pool of a class file
      # being generated.  This representation of a constant pool is designed
      # specifically for use by ProxyGenerator; in particular, it assumes
      # that constant pool entries will not need to be resorted (for example,
      # by their type, as the Java compiler does), so that the final index
      # value can be assigned and used when an entry is first created.
      # 
      # Note that new entries cannot be created after the constant pool has
      # been written to a class file.  To prevent such logic errors, a
      # ConstantPool instance can be marked "read only", so that further
      # attempts to add new entries will fail with a runtime exception.
      # 
      # See JVMS section 4.4 for more information about the constant pool
      # of a class file.
      const_set_lazy(:ConstantPool) { Class.new do
        include_class_members ProxyGenerator
        
        # list of constant pool entries, in constant pool index order.
        # 
        # This list is used when writing the constant pool to a stream
        # and for assigning the next index value.  Note that element 0
        # of this list corresponds to constant pool index 1.
        attr_accessor :pool
        alias_method :attr_pool, :pool
        undef_method :pool
        alias_method :attr_pool=, :pool=
        undef_method :pool=
        
        # maps constant pool data of all types to constant pool indexes.
        # 
        # This map is used to look up the index of an existing entry for
        # values of all types.
        attr_accessor :map
        alias_method :attr_map, :map
        undef_method :map
        alias_method :attr_map=, :map=
        undef_method :map=
        
        # true if no new constant pool entries may be added
        attr_accessor :read_only
        alias_method :attr_read_only, :read_only
        undef_method :read_only
        alias_method :attr_read_only=, :read_only=
        undef_method :read_only=
        
        typesig { [String] }
        # Get or assign the index for a CONSTANT_Utf8 entry.
        def get_utf8(s)
          if ((s).nil?)
            raise NullPointerException.new
          end
          return get_value(s)
        end
        
        typesig { [::Java::Int] }
        # Get or assign the index for a CONSTANT_Integer entry.
        def get_integer(i)
          return get_value(i)
        end
        
        typesig { [::Java::Float] }
        # Get or assign the index for a CONSTANT_Float entry.
        def get_float(f)
          return get_value(Float.new(f))
        end
        
        typesig { [String] }
        # Get or assign the index for a CONSTANT_Class entry.
        def get_class(name)
          utf8index = get_utf8(name)
          return get_indirect(IndirectEntry.new(CONSTANT_CLASS, utf8index))
        end
        
        typesig { [String] }
        # Get or assign the index for a CONSTANT_String entry.
        def get_string(s)
          utf8index = get_utf8(s)
          return get_indirect(IndirectEntry.new(CONSTANT_STRING, utf8index))
        end
        
        typesig { [String, String, String] }
        # Get or assign the index for a CONSTANT_FieldRef entry.
        def get_field_ref(class_name, name, descriptor)
          class_index = get_class(class_name)
          name_and_type_index = get_name_and_type(name, descriptor)
          return get_indirect(IndirectEntry.new(CONSTANT_FIELD, class_index, name_and_type_index))
        end
        
        typesig { [String, String, String] }
        # Get or assign the index for a CONSTANT_MethodRef entry.
        def get_method_ref(class_name, name, descriptor)
          class_index = get_class(class_name)
          name_and_type_index = get_name_and_type(name, descriptor)
          return get_indirect(IndirectEntry.new(CONSTANT_METHOD, class_index, name_and_type_index))
        end
        
        typesig { [String, String, String] }
        # Get or assign the index for a CONSTANT_InterfaceMethodRef entry.
        def get_interface_method_ref(class_name, name, descriptor)
          class_index = get_class(class_name)
          name_and_type_index = get_name_and_type(name, descriptor)
          return get_indirect(IndirectEntry.new(CONSTANT_INTERFACEMETHOD, class_index, name_and_type_index))
        end
        
        typesig { [String, String] }
        # Get or assign the index for a CONSTANT_NameAndType entry.
        def get_name_and_type(name, descriptor)
          name_index = get_utf8(name)
          descriptor_index = get_utf8(descriptor)
          return get_indirect(IndirectEntry.new(CONSTANT_NAMEANDTYPE, name_index, descriptor_index))
        end
        
        typesig { [] }
        # Set this ConstantPool instance to be "read only".
        # 
        # After this method has been called, further requests to get
        # an index for a non-existent entry will cause an InternalError
        # to be thrown instead of creating of the entry.
        def set_read_only
          @read_only = true
        end
        
        typesig { [OutputStream] }
        # Write this constant pool to a stream as part of
        # the class file format.
        # 
        # This consists of writing the "constant_pool_count" and
        # "constant_pool[]" items of the "ClassFile" structure, as
        # described in JVMS section 4.1.
        def write(out)
          data_out = DataOutputStream.new(out)
          # constant_pool_count: number of entries plus one
          data_out.write_short(@pool.size + 1)
          @pool.each do |e|
            e.write(data_out)
          end
        end
        
        typesig { [Entry] }
        # Add a new constant pool entry and return its index.
        def add_entry(entry)
          @pool.add(entry)
          # Note that this way of determining the index of the
          # added entry is wrong if this pool supports
          # CONSTANT_Long or CONSTANT_Double entries.
          if (@pool.size >= 65535)
            raise IllegalArgumentException.new("constant pool size limit exceeded")
          end
          return RJava.cast_to_short(@pool.size)
        end
        
        typesig { [Object] }
        # Get or assign the index for an entry of a type that contains
        # a direct value.  The type of the given object determines the
        # type of the desired entry as follows:
        # 
        # java.lang.String        CONSTANT_Utf8
        # java.lang.Integer       CONSTANT_Integer
        # java.lang.Float         CONSTANT_Float
        # java.lang.Long          CONSTANT_Long
        # java.lang.Double        CONSTANT_DOUBLE
        def get_value(key)
          index = @map.get(key)
          if (!(index).nil?)
            return index.short_value
          else
            if (@read_only)
              raise InternalError.new("late constant pool addition: " + RJava.cast_to_string(key))
            end
            i = add_entry(ValueEntry.new(key))
            @map.put(key, Short.new(i))
            return i
          end
        end
        
        typesig { [IndirectEntry] }
        # Get or assign the index for an entry of a type that contains
        # references to other constant pool entries.
        def get_indirect(e)
          index = @map.get(e)
          if (!(index).nil?)
            return index.short_value
          else
            if (@read_only)
              raise InternalError.new("late constant pool addition")
            end
            i = add_entry(e)
            @map.put(e, Short.new(i))
            return i
          end
        end
        
        class_module.module_eval {
          # Entry is the abstact superclass of all constant pool entry types
          # that can be stored in the "pool" list; its purpose is to define a
          # common method for writing constant pool entries to a class file.
          const_set_lazy(:Entry) { Class.new do
            include_class_members ConstantPool
            
            typesig { [DataOutputStream] }
            def write(out)
              raise NotImplementedError
            end
            
            typesig { [] }
            def initialize
            end
            
            private
            alias_method :initialize__entry, :initialize
          end }
          
          # ValueEntry represents a constant pool entry of a type that
          # contains a direct value (see the comments for the "getValue"
          # method for a list of such types).
          # 
          # ValueEntry objects are not used as keys for their entries in the
          # Map "map", so no useful hashCode or equals methods are defined.
          const_set_lazy(:ValueEntry) { Class.new(Entry) do
            include_class_members ConstantPool
            
            attr_accessor :value
            alias_method :attr_value, :value
            undef_method :value
            alias_method :attr_value=, :value=
            undef_method :value=
            
            typesig { [Object] }
            def initialize(value)
              @value = nil
              super()
              @value = value
            end
            
            typesig { [DataOutputStream] }
            def write(out)
              if (@value.is_a?(String))
                out.write_byte(CONSTANT_UTF8)
                out.write_utf(@value)
              else
                if (@value.is_a?(JavaInteger))
                  out.write_byte(CONSTANT_INTEGER)
                  out.write_int((@value).int_value)
                else
                  if (@value.is_a?(Float))
                    out.write_byte(CONSTANT_FLOAT)
                    out.write_float((@value).float_value)
                  else
                    if (@value.is_a?(Long))
                      out.write_byte(CONSTANT_LONG)
                      out.write_long((@value).long_value)
                    else
                      if (@value.is_a?(Double))
                        out.write_double(CONSTANT_DOUBLE)
                        out.write_double((@value).double_value)
                      else
                        raise InternalError.new("bogus value entry: " + RJava.cast_to_string(@value))
                      end
                    end
                  end
                end
              end
            end
            
            private
            alias_method :initialize__value_entry, :initialize
          end }
          
          # IndirectEntry represents a constant pool entry of a type that
          # references other constant pool entries, i.e., the following types:
          # 
          # CONSTANT_Class, CONSTANT_String, CONSTANT_Fieldref,
          # CONSTANT_Methodref, CONSTANT_InterfaceMethodref, and
          # CONSTANT_NameAndType.
          # 
          # Each of these entry types contains either one or two indexes of
          # other constant pool entries.
          # 
          # IndirectEntry objects are used as the keys for their entries in
          # the Map "map", so the hashCode and equals methods are overridden
          # to allow matching.
          const_set_lazy(:IndirectEntry) { Class.new(Entry) do
            include_class_members ConstantPool
            
            attr_accessor :tag
            alias_method :attr_tag, :tag
            undef_method :tag
            alias_method :attr_tag=, :tag=
            undef_method :tag=
            
            attr_accessor :index0
            alias_method :attr_index0, :index0
            undef_method :index0
            alias_method :attr_index0=, :index0=
            undef_method :index0=
            
            attr_accessor :index1
            alias_method :attr_index1, :index1
            undef_method :index1
            alias_method :attr_index1=, :index1=
            undef_method :index1=
            
            typesig { [::Java::Int, ::Java::Short] }
            # Construct an IndirectEntry for a constant pool entry type
            # that contains one index of another entry.
            def initialize(tag, index)
              @tag = 0
              @index0 = 0
              @index1 = 0
              super()
              @tag = tag
              @index0 = index
              @index1 = 0
            end
            
            typesig { [::Java::Int, ::Java::Short, ::Java::Short] }
            # Construct an IndirectEntry for a constant pool entry type
            # that contains two indexes for other entries.
            def initialize(tag, index0, index1)
              @tag = 0
              @index0 = 0
              @index1 = 0
              super()
              @tag = tag
              @index0 = index0
              @index1 = index1
            end
            
            typesig { [DataOutputStream] }
            def write(out)
              out.write_byte(@tag)
              out.write_short(@index0)
              # If this entry type contains two indexes, write
              # out the second, too.
              if ((@tag).equal?(CONSTANT_FIELD) || (@tag).equal?(CONSTANT_METHOD) || (@tag).equal?(CONSTANT_INTERFACEMETHOD) || (@tag).equal?(CONSTANT_NAMEANDTYPE))
                out.write_short(@index1)
              end
            end
            
            typesig { [] }
            def hash_code
              return @tag + @index0 + @index1
            end
            
            typesig { [Object] }
            def ==(obj)
              if (obj.is_a?(IndirectEntry))
                other = obj
                if ((@tag).equal?(other.attr_tag) && (@index0).equal?(other.attr_index0) && (@index1).equal?(other.attr_index1))
                  return true
                end
              end
              return false
            end
            
            private
            alias_method :initialize__indirect_entry, :initialize
          end }
        }
        
        typesig { [] }
        def initialize
          @pool = ArrayList.new(32)
          @map = HashMap.new(16)
          @read_only = false
        end
        
        private
        alias_method :initialize__constant_pool, :initialize
      end }
    }
    
    private
    alias_method :initialize__proxy_generator, :initialize
  end
  
end
