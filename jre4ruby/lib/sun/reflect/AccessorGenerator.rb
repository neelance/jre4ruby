require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module AccessorGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include ::Java::Lang::Reflect
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # Shared functionality for all accessor generators
  class AccessorGenerator 
    include_class_members AccessorGeneratorImports
    include ClassFileConstants
    
    class_module.module_eval {
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      # Constants because there's no way to say "short integer constant",
      # i.e., "1S"
      const_set_lazy(:S0) { RJava.cast_to_short(0) }
      const_attr_reader  :S0
      
      const_set_lazy(:S1) { RJava.cast_to_short(1) }
      const_attr_reader  :S1
      
      const_set_lazy(:S2) { RJava.cast_to_short(2) }
      const_attr_reader  :S2
      
      const_set_lazy(:S3) { RJava.cast_to_short(3) }
      const_attr_reader  :S3
      
      const_set_lazy(:S4) { RJava.cast_to_short(4) }
      const_attr_reader  :S4
      
      const_set_lazy(:S5) { RJava.cast_to_short(5) }
      const_attr_reader  :S5
      
      const_set_lazy(:S6) { RJava.cast_to_short(6) }
      const_attr_reader  :S6
    }
    
    # Instance variables for shared functionality between
    # FieldAccessorGenerator and MethodAccessorGenerator
    attr_accessor :asm
    alias_method :attr_asm, :asm
    undef_method :asm
    alias_method :attr_asm=, :asm=
    undef_method :asm=
    
    attr_accessor :modifiers
    alias_method :attr_modifiers, :modifiers
    undef_method :modifiers
    alias_method :attr_modifiers=, :modifiers=
    undef_method :modifiers=
    
    attr_accessor :this_class
    alias_method :attr_this_class, :this_class
    undef_method :this_class
    alias_method :attr_this_class=, :this_class=
    undef_method :this_class=
    
    attr_accessor :super_class
    alias_method :attr_super_class, :super_class
    undef_method :super_class
    alias_method :attr_super_class=, :super_class=
    undef_method :super_class=
    
    attr_accessor :target_class
    alias_method :attr_target_class, :target_class
    undef_method :target_class
    alias_method :attr_target_class=, :target_class=
    undef_method :target_class=
    
    # Common constant pool entries to FieldAccessor and MethodAccessor
    attr_accessor :throwable_class
    alias_method :attr_throwable_class, :throwable_class
    undef_method :throwable_class
    alias_method :attr_throwable_class=, :throwable_class=
    undef_method :throwable_class=
    
    attr_accessor :class_cast_class
    alias_method :attr_class_cast_class, :class_cast_class
    undef_method :class_cast_class
    alias_method :attr_class_cast_class=, :class_cast_class=
    undef_method :class_cast_class=
    
    attr_accessor :null_pointer_class
    alias_method :attr_null_pointer_class, :null_pointer_class
    undef_method :null_pointer_class
    alias_method :attr_null_pointer_class=, :null_pointer_class=
    undef_method :null_pointer_class=
    
    attr_accessor :illegal_argument_class
    alias_method :attr_illegal_argument_class, :illegal_argument_class
    undef_method :illegal_argument_class
    alias_method :attr_illegal_argument_class=, :illegal_argument_class=
    undef_method :illegal_argument_class=
    
    attr_accessor :invocation_target_class
    alias_method :attr_invocation_target_class, :invocation_target_class
    undef_method :invocation_target_class
    alias_method :attr_invocation_target_class=, :invocation_target_class=
    undef_method :invocation_target_class=
    
    attr_accessor :init_idx
    alias_method :attr_init_idx, :init_idx
    undef_method :init_idx
    alias_method :attr_init_idx=, :init_idx=
    undef_method :init_idx=
    
    attr_accessor :init_name_and_type_idx
    alias_method :attr_init_name_and_type_idx, :init_name_and_type_idx
    undef_method :init_name_and_type_idx
    alias_method :attr_init_name_and_type_idx=, :init_name_and_type_idx=
    undef_method :init_name_and_type_idx=
    
    attr_accessor :init_string_name_and_type_idx
    alias_method :attr_init_string_name_and_type_idx, :init_string_name_and_type_idx
    undef_method :init_string_name_and_type_idx
    alias_method :attr_init_string_name_and_type_idx=, :init_string_name_and_type_idx=
    undef_method :init_string_name_and_type_idx=
    
    attr_accessor :null_pointer_ctor_idx
    alias_method :attr_null_pointer_ctor_idx, :null_pointer_ctor_idx
    undef_method :null_pointer_ctor_idx
    alias_method :attr_null_pointer_ctor_idx=, :null_pointer_ctor_idx=
    undef_method :null_pointer_ctor_idx=
    
    attr_accessor :illegal_argument_ctor_idx
    alias_method :attr_illegal_argument_ctor_idx, :illegal_argument_ctor_idx
    undef_method :illegal_argument_ctor_idx
    alias_method :attr_illegal_argument_ctor_idx=, :illegal_argument_ctor_idx=
    undef_method :illegal_argument_ctor_idx=
    
    attr_accessor :illegal_argument_string_ctor_idx
    alias_method :attr_illegal_argument_string_ctor_idx, :illegal_argument_string_ctor_idx
    undef_method :illegal_argument_string_ctor_idx
    alias_method :attr_illegal_argument_string_ctor_idx=, :illegal_argument_string_ctor_idx=
    undef_method :illegal_argument_string_ctor_idx=
    
    attr_accessor :invocation_target_ctor_idx
    alias_method :attr_invocation_target_ctor_idx, :invocation_target_ctor_idx
    undef_method :invocation_target_ctor_idx
    alias_method :attr_invocation_target_ctor_idx=, :invocation_target_ctor_idx=
    undef_method :invocation_target_ctor_idx=
    
    attr_accessor :super_ctor_idx
    alias_method :attr_super_ctor_idx, :super_ctor_idx
    undef_method :super_ctor_idx
    alias_method :attr_super_ctor_idx=, :super_ctor_idx=
    undef_method :super_ctor_idx=
    
    attr_accessor :object_class
    alias_method :attr_object_class, :object_class
    undef_method :object_class
    alias_method :attr_object_class=, :object_class=
    undef_method :object_class=
    
    attr_accessor :to_string_idx
    alias_method :attr_to_string_idx, :to_string_idx
    undef_method :to_string_idx
    alias_method :attr_to_string_idx=, :to_string_idx=
    undef_method :to_string_idx=
    
    attr_accessor :code_idx
    alias_method :attr_code_idx, :code_idx
    undef_method :code_idx
    alias_method :attr_code_idx=, :code_idx=
    undef_method :code_idx=
    
    attr_accessor :exceptions_idx
    alias_method :attr_exceptions_idx, :exceptions_idx
    undef_method :exceptions_idx
    alias_method :attr_exceptions_idx=, :exceptions_idx=
    undef_method :exceptions_idx=
    
    # Boxing
    attr_accessor :boolean_idx
    alias_method :attr_boolean_idx, :boolean_idx
    undef_method :boolean_idx
    alias_method :attr_boolean_idx=, :boolean_idx=
    undef_method :boolean_idx=
    
    attr_accessor :boolean_ctor_idx
    alias_method :attr_boolean_ctor_idx, :boolean_ctor_idx
    undef_method :boolean_ctor_idx
    alias_method :attr_boolean_ctor_idx=, :boolean_ctor_idx=
    undef_method :boolean_ctor_idx=
    
    attr_accessor :boolean_unbox_idx
    alias_method :attr_boolean_unbox_idx, :boolean_unbox_idx
    undef_method :boolean_unbox_idx
    alias_method :attr_boolean_unbox_idx=, :boolean_unbox_idx=
    undef_method :boolean_unbox_idx=
    
    attr_accessor :byte_idx
    alias_method :attr_byte_idx, :byte_idx
    undef_method :byte_idx
    alias_method :attr_byte_idx=, :byte_idx=
    undef_method :byte_idx=
    
    attr_accessor :byte_ctor_idx
    alias_method :attr_byte_ctor_idx, :byte_ctor_idx
    undef_method :byte_ctor_idx
    alias_method :attr_byte_ctor_idx=, :byte_ctor_idx=
    undef_method :byte_ctor_idx=
    
    attr_accessor :byte_unbox_idx
    alias_method :attr_byte_unbox_idx, :byte_unbox_idx
    undef_method :byte_unbox_idx
    alias_method :attr_byte_unbox_idx=, :byte_unbox_idx=
    undef_method :byte_unbox_idx=
    
    attr_accessor :character_idx
    alias_method :attr_character_idx, :character_idx
    undef_method :character_idx
    alias_method :attr_character_idx=, :character_idx=
    undef_method :character_idx=
    
    attr_accessor :character_ctor_idx
    alias_method :attr_character_ctor_idx, :character_ctor_idx
    undef_method :character_ctor_idx
    alias_method :attr_character_ctor_idx=, :character_ctor_idx=
    undef_method :character_ctor_idx=
    
    attr_accessor :character_unbox_idx
    alias_method :attr_character_unbox_idx, :character_unbox_idx
    undef_method :character_unbox_idx
    alias_method :attr_character_unbox_idx=, :character_unbox_idx=
    undef_method :character_unbox_idx=
    
    attr_accessor :double_idx
    alias_method :attr_double_idx, :double_idx
    undef_method :double_idx
    alias_method :attr_double_idx=, :double_idx=
    undef_method :double_idx=
    
    attr_accessor :double_ctor_idx
    alias_method :attr_double_ctor_idx, :double_ctor_idx
    undef_method :double_ctor_idx
    alias_method :attr_double_ctor_idx=, :double_ctor_idx=
    undef_method :double_ctor_idx=
    
    attr_accessor :double_unbox_idx
    alias_method :attr_double_unbox_idx, :double_unbox_idx
    undef_method :double_unbox_idx
    alias_method :attr_double_unbox_idx=, :double_unbox_idx=
    undef_method :double_unbox_idx=
    
    attr_accessor :float_idx
    alias_method :attr_float_idx, :float_idx
    undef_method :float_idx
    alias_method :attr_float_idx=, :float_idx=
    undef_method :float_idx=
    
    attr_accessor :float_ctor_idx
    alias_method :attr_float_ctor_idx, :float_ctor_idx
    undef_method :float_ctor_idx
    alias_method :attr_float_ctor_idx=, :float_ctor_idx=
    undef_method :float_ctor_idx=
    
    attr_accessor :float_unbox_idx
    alias_method :attr_float_unbox_idx, :float_unbox_idx
    undef_method :float_unbox_idx
    alias_method :attr_float_unbox_idx=, :float_unbox_idx=
    undef_method :float_unbox_idx=
    
    attr_accessor :integer_idx
    alias_method :attr_integer_idx, :integer_idx
    undef_method :integer_idx
    alias_method :attr_integer_idx=, :integer_idx=
    undef_method :integer_idx=
    
    attr_accessor :integer_ctor_idx
    alias_method :attr_integer_ctor_idx, :integer_ctor_idx
    undef_method :integer_ctor_idx
    alias_method :attr_integer_ctor_idx=, :integer_ctor_idx=
    undef_method :integer_ctor_idx=
    
    attr_accessor :integer_unbox_idx
    alias_method :attr_integer_unbox_idx, :integer_unbox_idx
    undef_method :integer_unbox_idx
    alias_method :attr_integer_unbox_idx=, :integer_unbox_idx=
    undef_method :integer_unbox_idx=
    
    attr_accessor :long_idx
    alias_method :attr_long_idx, :long_idx
    undef_method :long_idx
    alias_method :attr_long_idx=, :long_idx=
    undef_method :long_idx=
    
    attr_accessor :long_ctor_idx
    alias_method :attr_long_ctor_idx, :long_ctor_idx
    undef_method :long_ctor_idx
    alias_method :attr_long_ctor_idx=, :long_ctor_idx=
    undef_method :long_ctor_idx=
    
    attr_accessor :long_unbox_idx
    alias_method :attr_long_unbox_idx, :long_unbox_idx
    undef_method :long_unbox_idx
    alias_method :attr_long_unbox_idx=, :long_unbox_idx=
    undef_method :long_unbox_idx=
    
    attr_accessor :short_idx
    alias_method :attr_short_idx, :short_idx
    undef_method :short_idx
    alias_method :attr_short_idx=, :short_idx=
    undef_method :short_idx=
    
    attr_accessor :short_ctor_idx
    alias_method :attr_short_ctor_idx, :short_ctor_idx
    undef_method :short_ctor_idx
    alias_method :attr_short_ctor_idx=, :short_ctor_idx=
    undef_method :short_ctor_idx=
    
    attr_accessor :short_unbox_idx
    alias_method :attr_short_unbox_idx, :short_unbox_idx
    undef_method :short_unbox_idx
    alias_method :attr_short_unbox_idx=, :short_unbox_idx=
    undef_method :short_unbox_idx=
    
    attr_accessor :num_common_cpool_entries
    alias_method :attr_num_common_cpool_entries, :num_common_cpool_entries
    undef_method :num_common_cpool_entries
    alias_method :attr_num_common_cpool_entries=, :num_common_cpool_entries=
    undef_method :num_common_cpool_entries=
    
    attr_accessor :num_boxing_cpool_entries
    alias_method :attr_num_boxing_cpool_entries, :num_boxing_cpool_entries
    undef_method :num_boxing_cpool_entries
    alias_method :attr_num_boxing_cpool_entries=, :num_boxing_cpool_entries=
    undef_method :num_boxing_cpool_entries=
    
    typesig { [] }
    # Requires that superClass has been set up
    def emit_common_constant_pool_entries
      # +   [UTF-8] "java/lang/Throwable"
      # +   [CONSTANT_Class_info] for above
      # +   [UTF-8] "java/lang/ClassCastException"
      # +   [CONSTANT_Class_info] for above
      # +   [UTF-8] "java/lang/NullPointerException"
      # +   [CONSTANT_Class_info] for above
      # +   [UTF-8] "java/lang/IllegalArgumentException"
      # +   [CONSTANT_Class_info] for above
      # +   [UTF-8] "java/lang/InvocationTargetException"
      # +   [CONSTANT_Class_info] for above
      # +   [UTF-8] "<init>"
      # +   [UTF-8] "()V"
      # +   [CONSTANT_NameAndType_info] for above
      # +   [CONSTANT_Methodref_info] for NullPointerException's constructor
      # +   [CONSTANT_Methodref_info] for IllegalArgumentException's constructor
      # +   [UTF-8] "(Ljava/lang/String;)V"
      # +   [CONSTANT_NameAndType_info] for "<init>(Ljava/lang/String;)V"
      # +   [CONSTANT_Methodref_info] for IllegalArgumentException's constructor taking a String
      # +   [UTF-8] "(Ljava/lang/Throwable;)V"
      # +   [CONSTANT_NameAndType_info] for "<init>(Ljava/lang/Throwable;)V"
      # +   [CONSTANT_Methodref_info] for InvocationTargetException's constructor
      # +   [CONSTANT_Methodref_info] for "super()"
      # +   [UTF-8] "java/lang/Object"
      # +   [CONSTANT_Class_info] for above
      # +   [UTF-8] "toString"
      # +   [UTF-8] "()Ljava/lang/String;"
      # +   [CONSTANT_NameAndType_info] for "toString()Ljava/lang/String;"
      # +   [CONSTANT_Methodref_info] for Object's toString method
      # +   [UTF-8] "Code"
      # +   [UTF-8] "Exceptions"
      @asm.emit_constant_pool_utf8("java/lang/Throwable")
      @asm.emit_constant_pool_class(@asm.cpi)
      @throwable_class = @asm.cpi
      @asm.emit_constant_pool_utf8("java/lang/ClassCastException")
      @asm.emit_constant_pool_class(@asm.cpi)
      @class_cast_class = @asm.cpi
      @asm.emit_constant_pool_utf8("java/lang/NullPointerException")
      @asm.emit_constant_pool_class(@asm.cpi)
      @null_pointer_class = @asm.cpi
      @asm.emit_constant_pool_utf8("java/lang/IllegalArgumentException")
      @asm.emit_constant_pool_class(@asm.cpi)
      @illegal_argument_class = @asm.cpi
      @asm.emit_constant_pool_utf8("java/lang/reflect/InvocationTargetException")
      @asm.emit_constant_pool_class(@asm.cpi)
      @invocation_target_class = @asm.cpi
      @asm.emit_constant_pool_utf8("<init>")
      @init_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("()V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @init_name_and_type_idx = @asm.cpi
      @asm.emit_constant_pool_methodref(@null_pointer_class, @init_name_and_type_idx)
      @null_pointer_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_methodref(@illegal_argument_class, @init_name_and_type_idx)
      @illegal_argument_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(Ljava/lang/String;)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @init_string_name_and_type_idx = @asm.cpi
      @asm.emit_constant_pool_methodref(@illegal_argument_class, @init_string_name_and_type_idx)
      @illegal_argument_string_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(Ljava/lang/Throwable;)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(@invocation_target_class, @asm.cpi)
      @invocation_target_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_methodref(@super_class, @init_name_and_type_idx)
      @super_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("java/lang/Object")
      @asm.emit_constant_pool_class(@asm.cpi)
      @object_class = @asm.cpi
      @asm.emit_constant_pool_utf8("toString")
      @asm.emit_constant_pool_utf8("()Ljava/lang/String;")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(@object_class, @asm.cpi)
      @to_string_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("Code")
      @code_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("Exceptions")
      @exceptions_idx = @asm.cpi
    end
    
    typesig { [] }
    # Constant pool entries required to be able to box/unbox primitive
    # types. Note that we don't emit these if we don't need them.
    def emit_boxing_contant_pool_entries
      # *  [UTF-8] "java/lang/Boolean"
      # *  [CONSTANT_Class_info] for above
      # *  [UTF-8] "(Z)V"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "booleanValue"
      # *  [UTF-8] "()Z"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "java/lang/Byte"
      # *  [CONSTANT_Class_info] for above
      # *  [UTF-8] "(B)V"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "byteValue"
      # *  [UTF-8] "()B"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "java/lang/Character"
      # *  [CONSTANT_Class_info] for above
      # *  [UTF-8] "(C)V"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "charValue"
      # *  [UTF-8] "()C"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "java/lang/Double"
      # *  [CONSTANT_Class_info] for above
      # *  [UTF-8] "(D)V"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "doubleValue"
      # *  [UTF-8] "()D"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "java/lang/Float"
      # *  [CONSTANT_Class_info] for above
      # *  [UTF-8] "(F)V"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "floatValue"
      # *  [UTF-8] "()F"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "java/lang/Integer"
      # *  [CONSTANT_Class_info] for above
      # *  [UTF-8] "(I)V"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "intValue"
      # *  [UTF-8] "()I"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "java/lang/Long"
      # *  [CONSTANT_Class_info] for above
      # *  [UTF-8] "(J)V"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "longValue"
      # *  [UTF-8] "()J"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "java/lang/Short"
      # *  [CONSTANT_Class_info] for above
      # *  [UTF-8] "(S)V"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # *  [UTF-8] "shortValue"
      # *  [UTF-8] "()S"
      # *  [CONSTANT_NameAndType_info] for above
      # *  [CONSTANT_Methodref_info] for above
      # Boolean
      @asm.emit_constant_pool_utf8("java/lang/Boolean")
      @asm.emit_constant_pool_class(@asm.cpi)
      @boolean_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(Z)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S2), @asm.cpi)
      @boolean_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("booleanValue")
      @asm.emit_constant_pool_utf8("()Z")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S6), @asm.cpi)
      @boolean_unbox_idx = @asm.cpi
      # Byte
      @asm.emit_constant_pool_utf8("java/lang/Byte")
      @asm.emit_constant_pool_class(@asm.cpi)
      @byte_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(B)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S2), @asm.cpi)
      @byte_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("byteValue")
      @asm.emit_constant_pool_utf8("()B")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S6), @asm.cpi)
      @byte_unbox_idx = @asm.cpi
      # Character
      @asm.emit_constant_pool_utf8("java/lang/Character")
      @asm.emit_constant_pool_class(@asm.cpi)
      @character_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(C)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S2), @asm.cpi)
      @character_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("charValue")
      @asm.emit_constant_pool_utf8("()C")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S6), @asm.cpi)
      @character_unbox_idx = @asm.cpi
      # Double
      @asm.emit_constant_pool_utf8("java/lang/Double")
      @asm.emit_constant_pool_class(@asm.cpi)
      @double_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(D)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S2), @asm.cpi)
      @double_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("doubleValue")
      @asm.emit_constant_pool_utf8("()D")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S6), @asm.cpi)
      @double_unbox_idx = @asm.cpi
      # Float
      @asm.emit_constant_pool_utf8("java/lang/Float")
      @asm.emit_constant_pool_class(@asm.cpi)
      @float_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(F)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S2), @asm.cpi)
      @float_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("floatValue")
      @asm.emit_constant_pool_utf8("()F")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S6), @asm.cpi)
      @float_unbox_idx = @asm.cpi
      # Integer
      @asm.emit_constant_pool_utf8("java/lang/Integer")
      @asm.emit_constant_pool_class(@asm.cpi)
      @integer_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(I)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S2), @asm.cpi)
      @integer_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("intValue")
      @asm.emit_constant_pool_utf8("()I")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S6), @asm.cpi)
      @integer_unbox_idx = @asm.cpi
      # Long
      @asm.emit_constant_pool_utf8("java/lang/Long")
      @asm.emit_constant_pool_class(@asm.cpi)
      @long_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(J)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S2), @asm.cpi)
      @long_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("longValue")
      @asm.emit_constant_pool_utf8("()J")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S6), @asm.cpi)
      @long_unbox_idx = @asm.cpi
      # Short
      @asm.emit_constant_pool_utf8("java/lang/Short")
      @asm.emit_constant_pool_class(@asm.cpi)
      @short_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("(S)V")
      @asm.emit_constant_pool_name_and_type(@init_idx, @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S2), @asm.cpi)
      @short_ctor_idx = @asm.cpi
      @asm.emit_constant_pool_utf8("shortValue")
      @asm.emit_constant_pool_utf8("()S")
      @asm.emit_constant_pool_name_and_type(sub(@asm.cpi, S1), @asm.cpi)
      @asm.emit_constant_pool_methodref(sub(@asm.cpi, S6), @asm.cpi)
      @short_unbox_idx = @asm.cpi
    end
    
    class_module.module_eval {
      typesig { [::Java::Short, ::Java::Short] }
      # Necessary because of Java's annoying promotion rules
      def add(s1, s2)
        return RJava.cast_to_short((s1 + s2))
      end
      
      typesig { [::Java::Short, ::Java::Short] }
      def sub(s1, s2)
        return RJava.cast_to_short((s1 - s2))
      end
    }
    
    typesig { [] }
    def is_static
      return Modifier.is_static(@modifiers)
    end
    
    class_module.module_eval {
      typesig { [Class, ::Java::Boolean] }
      # Returns class name in "internal" form (i.e., '/' separators
      # instead of '.')
      def get_class_name(c, add_prefix_and_suffix_for_non_primitive_types)
        if (c.is_primitive)
          if ((c).equal?(Boolean::TYPE))
            return "Z"
          else
            if ((c).equal?(Byte::TYPE))
              return "B"
            else
              if ((c).equal?(Character::TYPE))
                return "C"
              else
                if ((c).equal?(Double::TYPE))
                  return "D"
                else
                  if ((c).equal?(Float::TYPE))
                    return "F"
                  else
                    if ((c).equal?(JavaInteger::TYPE))
                      return "I"
                    else
                      if ((c).equal?(Long::TYPE))
                        return "J"
                      else
                        if ((c).equal?(Short::TYPE))
                          return "S"
                        else
                          if ((c).equal?(Void::TYPE))
                            return "V"
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          raise InternalError.new("Should have found primitive type")
        else
          if (c.is_array)
            return "[" + (get_class_name(c.get_component_type, true)).to_s
          else
            if (add_prefix_and_suffix_for_non_primitive_types)
              return internalize("L" + (c.get_name).to_s + ";")
            else
              return internalize(c.get_name)
            end
          end
        end
      end
      
      typesig { [String] }
      def internalize(class_name)
        return class_name.replace(Character.new(?..ord), Character.new(?/.ord))
      end
    }
    
    typesig { [] }
    def emit_constructor
      # Generate code into fresh code buffer
      cb = ClassFileAssembler.new
      # 0 incoming arguments
      cb.set_max_locals(1)
      cb.opc_aload_0
      cb.opc_invokespecial(@super_ctor_idx, 0, 0)
      cb.opc_return
      # Emit method
      emit_method(@init_idx, cb.get_max_locals, cb, nil, nil)
    end
    
    typesig { [::Java::Short, ::Java::Int, ClassFileAssembler, ClassFileAssembler, Array.typed(::Java::Short)] }
    # The descriptor's index in the constant pool must be (1 +
    # nameIdx). "numArgs" must indicate ALL arguments, including the
    # implicit "this" argument; double and long arguments each count
    # as 2 in this count. The code buffer must NOT contain the code
    # length. The exception table may be null, but if non-null must
    # NOT contain the exception table's length. The checked exception
    # indices may be null.
    def emit_method(name_idx, num_args, code, exception_table, checked_exception_indices)
      code_len = code.get_length
      exc_len = 0
      if (!(exception_table).nil?)
        exc_len = exception_table.get_length
        if (!((exc_len % 8)).equal?(0))
          raise IllegalArgumentException.new("Illegal exception table")
        end
      end
      attr_len = 12 + code_len + exc_len
      exc_len = exc_len / 8 # No-op if no exception table
      @asm.emit_short(ACC_PUBLIC)
      @asm.emit_short(name_idx)
      @asm.emit_short(add(name_idx, S1))
      if ((checked_exception_indices).nil?)
        # Code attribute only
        @asm.emit_short(S1)
      else
        # Code and Exceptions attributes
        @asm.emit_short(S2)
      end
      # Code attribute
      @asm.emit_short(@code_idx)
      @asm.emit_int(attr_len)
      @asm.emit_short(code.get_max_stack)
      @asm.emit_short(RJava.cast_to_short(Math.max(num_args, code.get_max_locals)))
      @asm.emit_int(code_len)
      @asm.append(code)
      @asm.emit_short(RJava.cast_to_short(exc_len))
      if (!(exception_table).nil?)
        @asm.append(exception_table)
      end
      @asm.emit_short(S0) # No additional attributes for Code attribute
      if (!(checked_exception_indices).nil?)
        # Exceptions attribute
        @asm.emit_short(@exceptions_idx)
        @asm.emit_int(2 + 2 * checked_exception_indices.attr_length)
        @asm.emit_short(RJava.cast_to_short(checked_exception_indices.attr_length))
        i = 0
        while i < checked_exception_indices.attr_length
          @asm.emit_short(checked_exception_indices[i])
          i += 1
        end
      end
    end
    
    typesig { [Class] }
    def index_for_primitive_type(type)
      if ((type).equal?(Boolean::TYPE))
        return @boolean_idx
      else
        if ((type).equal?(Byte::TYPE))
          return @byte_idx
        else
          if ((type).equal?(Character::TYPE))
            return @character_idx
          else
            if ((type).equal?(Double::TYPE))
              return @double_idx
            else
              if ((type).equal?(Float::TYPE))
                return @float_idx
              else
                if ((type).equal?(JavaInteger::TYPE))
                  return @integer_idx
                else
                  if ((type).equal?(Long::TYPE))
                    return @long_idx
                  else
                    if ((type).equal?(Short::TYPE))
                      return @short_idx
                    end
                  end
                end
              end
            end
          end
        end
      end
      raise InternalError.new("Should have found primitive type")
    end
    
    typesig { [Class] }
    def ctor_index_for_primitive_type(type)
      if ((type).equal?(Boolean::TYPE))
        return @boolean_ctor_idx
      else
        if ((type).equal?(Byte::TYPE))
          return @byte_ctor_idx
        else
          if ((type).equal?(Character::TYPE))
            return @character_ctor_idx
          else
            if ((type).equal?(Double::TYPE))
              return @double_ctor_idx
            else
              if ((type).equal?(Float::TYPE))
                return @float_ctor_idx
              else
                if ((type).equal?(JavaInteger::TYPE))
                  return @integer_ctor_idx
                else
                  if ((type).equal?(Long::TYPE))
                    return @long_ctor_idx
                  else
                    if ((type).equal?(Short::TYPE))
                      return @short_ctor_idx
                    end
                  end
                end
              end
            end
          end
        end
      end
      raise InternalError.new("Should have found primitive type")
    end
    
    class_module.module_eval {
      typesig { [Class, Class] }
      # Returns true for widening or identity conversions for primitive
      # types only
      def can_widen_to(type, other_type)
        if (!type.is_primitive)
          return false
        end
        # Widening conversions (from JVM spec):
        # byte to short, int, long, float, or double
        # short to int, long, float, or double
        # char to int, long, float, or double
        # int to long, float, or double
        # long to float or double
        # float to double
        if ((type).equal?(Boolean::TYPE))
          if ((other_type).equal?(Boolean::TYPE))
            return true
          end
        else
          if ((type).equal?(Byte::TYPE))
            if ((other_type).equal?(Byte::TYPE) || (other_type).equal?(Short::TYPE) || (other_type).equal?(JavaInteger::TYPE) || (other_type).equal?(Long::TYPE) || (other_type).equal?(Float::TYPE) || (other_type).equal?(Double::TYPE))
              return true
            end
          else
            if ((type).equal?(Short::TYPE))
              if ((other_type).equal?(Short::TYPE) || (other_type).equal?(JavaInteger::TYPE) || (other_type).equal?(Long::TYPE) || (other_type).equal?(Float::TYPE) || (other_type).equal?(Double::TYPE))
                return true
              end
            else
              if ((type).equal?(Character::TYPE))
                if ((other_type).equal?(Character::TYPE) || (other_type).equal?(JavaInteger::TYPE) || (other_type).equal?(Long::TYPE) || (other_type).equal?(Float::TYPE) || (other_type).equal?(Double::TYPE))
                  return true
                end
              else
                if ((type).equal?(JavaInteger::TYPE))
                  if ((other_type).equal?(JavaInteger::TYPE) || (other_type).equal?(Long::TYPE) || (other_type).equal?(Float::TYPE) || (other_type).equal?(Double::TYPE))
                    return true
                  end
                else
                  if ((type).equal?(Long::TYPE))
                    if ((other_type).equal?(Long::TYPE) || (other_type).equal?(Float::TYPE) || (other_type).equal?(Double::TYPE))
                      return true
                    end
                  else
                    if ((type).equal?(Float::TYPE))
                      if ((other_type).equal?(Float::TYPE) || (other_type).equal?(Double::TYPE))
                        return true
                      end
                    else
                      if ((type).equal?(Double::TYPE))
                        if ((other_type).equal?(Double::TYPE))
                          return true
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        return false
      end
      
      typesig { [ClassFileAssembler, Class, Class] }
      # Emits the widening bytecode for the given primitive conversion
      # (or none if the identity conversion). Requires that a primitive
      # conversion exists; i.e., canWidenTo must have already been
      # called and returned true.
      def emit_widening_bytecode_for_primitive_conversion(cb, from_type, to_type)
        # Note that widening conversions for integral types (i.e., "b2s",
        # "s2i") are no-ops since values on the Java stack are
        # sign-extended.
        # Widening conversions (from JVM spec):
        # byte to short, int, long, float, or double
        # short to int, long, float, or double
        # char to int, long, float, or double
        # int to long, float, or double
        # long to float or double
        # float to double
        if ((from_type).equal?(Byte::TYPE) || (from_type).equal?(Short::TYPE) || (from_type).equal?(Character::TYPE) || (from_type).equal?(JavaInteger::TYPE))
          if ((to_type).equal?(Long::TYPE))
            cb.opc_i2l
          else
            if ((to_type).equal?(Float::TYPE))
              cb.opc_i2f
            else
              if ((to_type).equal?(Double::TYPE))
                cb.opc_i2d
              end
            end
          end
        else
          if ((from_type).equal?(Long::TYPE))
            if ((to_type).equal?(Float::TYPE))
              cb.opc_l2f
            else
              if ((to_type).equal?(Double::TYPE))
                cb.opc_l2d
              end
            end
          else
            if ((from_type).equal?(Float::TYPE))
              if ((to_type).equal?(Double::TYPE))
                cb.opc_f2d
              end
            end
          end
        end
        # Otherwise, was identity or no-op conversion. Fall through.
      end
    }
    
    typesig { [Class] }
    def unboxing_method_for_primitive_type(prim_type)
      if ((prim_type).equal?(Boolean::TYPE))
        return @boolean_unbox_idx
      else
        if ((prim_type).equal?(Byte::TYPE))
          return @byte_unbox_idx
        else
          if ((prim_type).equal?(Character::TYPE))
            return @character_unbox_idx
          else
            if ((prim_type).equal?(Short::TYPE))
              return @short_unbox_idx
            else
              if ((prim_type).equal?(JavaInteger::TYPE))
                return @integer_unbox_idx
              else
                if ((prim_type).equal?(Long::TYPE))
                  return @long_unbox_idx
                else
                  if ((prim_type).equal?(Float::TYPE))
                    return @float_unbox_idx
                  else
                    if ((prim_type).equal?(Double::TYPE))
                      return @double_unbox_idx
                    end
                  end
                end
              end
            end
          end
        end
      end
      raise InternalError.new("Illegal primitive type " + (prim_type.get_name).to_s)
    end
    
    class_module.module_eval {
      const_set_lazy(:PrimitiveTypes) { Array.typed(Class).new([Boolean::TYPE, Byte::TYPE, Character::TYPE, Short::TYPE, JavaInteger::TYPE, Long::TYPE, Float::TYPE, Double::TYPE]) }
      const_attr_reader  :PrimitiveTypes
      
      typesig { [Class] }
      # We don't consider "Void" to be a primitive type
      def is_primitive(c)
        return (c.is_primitive && !(c).equal?(Void::TYPE))
      end
    }
    
    typesig { [Class] }
    def type_size_in_stack_slots(c)
      if ((c).equal?(Void::TYPE))
        return 0
      end
      if ((c).equal?(Long::TYPE) || (c).equal?(Double::TYPE))
        return 2
      end
      return 1
    end
    
    attr_accessor :illegal_argument_code_buffer
    alias_method :attr_illegal_argument_code_buffer, :illegal_argument_code_buffer
    undef_method :illegal_argument_code_buffer
    alias_method :attr_illegal_argument_code_buffer=, :illegal_argument_code_buffer=
    undef_method :illegal_argument_code_buffer=
    
    typesig { [] }
    def illegal_argument_code_buffer
      if ((@illegal_argument_code_buffer).nil?)
        @illegal_argument_code_buffer = ClassFileAssembler.new
        @illegal_argument_code_buffer.opc_new(@illegal_argument_class)
        @illegal_argument_code_buffer.opc_dup
        @illegal_argument_code_buffer.opc_invokespecial(@illegal_argument_ctor_idx, 0, 0)
        @illegal_argument_code_buffer.opc_athrow
      end
      return @illegal_argument_code_buffer
    end
    
    typesig { [] }
    def initialize
      @asm = nil
      @modifiers = 0
      @this_class = 0
      @super_class = 0
      @target_class = 0
      @throwable_class = 0
      @class_cast_class = 0
      @null_pointer_class = 0
      @illegal_argument_class = 0
      @invocation_target_class = 0
      @init_idx = 0
      @init_name_and_type_idx = 0
      @init_string_name_and_type_idx = 0
      @null_pointer_ctor_idx = 0
      @illegal_argument_ctor_idx = 0
      @illegal_argument_string_ctor_idx = 0
      @invocation_target_ctor_idx = 0
      @super_ctor_idx = 0
      @object_class = 0
      @to_string_idx = 0
      @code_idx = 0
      @exceptions_idx = 0
      @boolean_idx = 0
      @boolean_ctor_idx = 0
      @boolean_unbox_idx = 0
      @byte_idx = 0
      @byte_ctor_idx = 0
      @byte_unbox_idx = 0
      @character_idx = 0
      @character_ctor_idx = 0
      @character_unbox_idx = 0
      @double_idx = 0
      @double_ctor_idx = 0
      @double_unbox_idx = 0
      @float_idx = 0
      @float_ctor_idx = 0
      @float_unbox_idx = 0
      @integer_idx = 0
      @integer_ctor_idx = 0
      @integer_unbox_idx = 0
      @long_idx = 0
      @long_ctor_idx = 0
      @long_unbox_idx = 0
      @short_idx = 0
      @short_ctor_idx = 0
      @short_unbox_idx = 0
      @num_common_cpool_entries = RJava.cast_to_short(30)
      @num_boxing_cpool_entries = RJava.cast_to_short(72)
      @illegal_argument_code_buffer = nil
    end
    
    private
    alias_method :initialize__accessor_generator, :initialize
  end
  
end
