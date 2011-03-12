require "rjava"

# Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ClassFileAssemblerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
    }
  end
  
  class ClassFileAssembler 
    include_class_members ClassFileAssemblerImports
    include ClassFileConstants
    
    attr_accessor :vec
    alias_method :attr_vec, :vec
    undef_method :vec
    alias_method :attr_vec=, :vec=
    undef_method :vec=
    
    attr_accessor :cp_idx
    alias_method :attr_cp_idx, :cp_idx
    undef_method :cp_idx
    alias_method :attr_cp_idx=, :cp_idx=
    undef_method :cp_idx=
    
    typesig { [] }
    def initialize
      initialize__class_file_assembler(ByteVectorFactory.create)
    end
    
    typesig { [ByteVector] }
    def initialize(vec)
      @vec = nil
      @cp_idx = 0
      @stack = 0
      @max_stack = 0
      @max_locals = 0
      @vec = vec
    end
    
    typesig { [] }
    def get_data
      return @vec
    end
    
    typesig { [] }
    # Length in bytes
    def get_length
      return RJava.cast_to_short(@vec.get_length)
    end
    
    typesig { [] }
    def emit_magic_and_version
      emit_int(-0x35014542)
      emit_short(RJava.cast_to_short(0))
      emit_short(RJava.cast_to_short(49))
    end
    
    typesig { [::Java::Int] }
    def emit_int(val)
      emit_byte((val >> 24))
      emit_byte(((val >> 16) & 0xff))
      emit_byte(((val >> 8) & 0xff))
      emit_byte((val & 0xff))
    end
    
    typesig { [::Java::Short] }
    def emit_short(val)
      emit_byte(((val >> 8) & 0xff))
      emit_byte((val & 0xff))
    end
    
    typesig { [::Java::Short, ::Java::Short] }
    # Support for labels; package-private
    def emit_short(bci, val)
      @vec.put(bci, ((val >> 8) & 0xff))
      @vec.put(bci + 1, (val & 0xff))
    end
    
    typesig { [::Java::Byte] }
    def emit_byte(val)
      @vec.add(val)
    end
    
    typesig { [ClassFileAssembler] }
    def append(asm)
      append(asm.attr_vec)
    end
    
    typesig { [ByteVector] }
    def append(vec)
      i = 0
      while i < vec.get_length
        emit_byte(vec.get(i))
        i += 1
      end
    end
    
    typesig { [] }
    # Keeps track of the current (one-based) constant pool index;
    # incremented after emitting one of the following constant pool
    # entries. Can fetch the current constant pool index for use in
    # later entries.  Index points at the last valid constant pool
    # entry; initially invalid. It is illegal to fetch the constant
    # pool index before emitting at least one constant pool entry.
    def cpi
      if ((@cp_idx).equal?(0))
        raise RuntimeException.new("Illegal use of ClassFileAssembler")
      end
      return @cp_idx
    end
    
    typesig { [String] }
    def emit_constant_pool_utf8(str)
      # NOTE: can not use str.getBytes("UTF-8") here because of
      # bootstrapping issues with the character set converters.
      bytes = UTF8.encode(str)
      emit_byte(CONSTANT_Utf8)
      emit_short(RJava.cast_to_short(bytes.attr_length))
      i = 0
      while i < bytes.attr_length
        emit_byte(bytes[i])
        i += 1
      end
      @cp_idx += 1
    end
    
    typesig { [::Java::Short] }
    def emit_constant_pool_class(index)
      emit_byte(CONSTANT_Class)
      emit_short(index)
      @cp_idx += 1
    end
    
    typesig { [::Java::Short, ::Java::Short] }
    def emit_constant_pool_name_and_type(name_index, type_index)
      emit_byte(CONSTANT_NameAndType)
      emit_short(name_index)
      emit_short(type_index)
      @cp_idx += 1
    end
    
    typesig { [::Java::Short, ::Java::Short] }
    def emit_constant_pool_fieldref(class_index, name_and_type_index)
      emit_byte(CONSTANT_Fieldref)
      emit_short(class_index)
      emit_short(name_and_type_index)
      @cp_idx += 1
    end
    
    typesig { [::Java::Short, ::Java::Short] }
    def emit_constant_pool_methodref(class_index, name_and_type_index)
      emit_byte(CONSTANT_Methodref)
      emit_short(class_index)
      emit_short(name_and_type_index)
      @cp_idx += 1
    end
    
    typesig { [::Java::Short, ::Java::Short] }
    def emit_constant_pool_interface_methodref(class_index, name_and_type_index)
      emit_byte(CONSTANT_InterfaceMethodref)
      emit_short(class_index)
      emit_short(name_and_type_index)
      @cp_idx += 1
    end
    
    typesig { [::Java::Short] }
    def emit_constant_pool_string(utf8index)
      emit_byte(CONSTANT_String)
      emit_short(utf8index)
      @cp_idx += 1
    end
    
    # ----------------------------------------------------------------------
    # Opcodes. Keeps track of maximum stack and locals. Make a new
    # assembler for each piece of assembled code, then append the
    # result to the previous assembler's class file.
    # 
    attr_accessor :stack
    alias_method :attr_stack, :stack
    undef_method :stack
    alias_method :attr_stack=, :stack=
    undef_method :stack=
    
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
    
    typesig { [] }
    def inc_stack
      set_stack(@stack + 1)
    end
    
    typesig { [] }
    def dec_stack
      (@stack -= 1)
    end
    
    typesig { [] }
    def get_max_stack
      return RJava.cast_to_short(@max_stack)
    end
    
    typesig { [] }
    def get_max_locals
      return RJava.cast_to_short(@max_locals)
    end
    
    typesig { [::Java::Int] }
    # It's necessary to be able to specify the number of arguments at
    # the beginning of the method (which translates to the initial
    # value of max locals)
    def set_max_locals(max_locals)
      @max_locals = max_locals
    end
    
    typesig { [] }
    # Needed to do flow control. Returns current stack depth.
    def get_stack
      return @stack
    end
    
    typesig { [::Java::Int] }
    # Needed to do flow control.
    def set_stack(value)
      @stack = value
      if (@stack > @max_stack)
        @max_stack = @stack
      end
    end
    
    typesig { [] }
    # /////////////
    # Constants //
    # /////////////
    def opc_aconst_null
      emit_byte(self.attr_opc_aconst_null)
      inc_stack
    end
    
    typesig { [::Java::Short] }
    def opc_sipush(constant)
      emit_byte(self.attr_opc_sipush)
      emit_short(constant)
      inc_stack
    end
    
    typesig { [::Java::Byte] }
    def opc_ldc(cp_idx)
      emit_byte(self.attr_opc_ldc)
      emit_byte(cp_idx)
      inc_stack
    end
    
    typesig { [] }
    # ///////////////////////////////////
    # Local variable loads and stores //
    # ///////////////////////////////////
    def opc_iload_0
      emit_byte(self.attr_opc_iload_0)
      if (@max_locals < 1)
        @max_locals = 1
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_iload_1
      emit_byte(self.attr_opc_iload_1)
      if (@max_locals < 2)
        @max_locals = 2
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_iload_2
      emit_byte(self.attr_opc_iload_2)
      if (@max_locals < 3)
        @max_locals = 3
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_iload_3
      emit_byte(self.attr_opc_iload_3)
      if (@max_locals < 4)
        @max_locals = 4
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_lload_0
      emit_byte(self.attr_opc_lload_0)
      if (@max_locals < 2)
        @max_locals = 2
      end
      inc_stack
      inc_stack
    end
    
    typesig { [] }
    def opc_lload_1
      emit_byte(self.attr_opc_lload_1)
      if (@max_locals < 3)
        @max_locals = 3
      end
      inc_stack
      inc_stack
    end
    
    typesig { [] }
    def opc_lload_2
      emit_byte(self.attr_opc_lload_2)
      if (@max_locals < 4)
        @max_locals = 4
      end
      inc_stack
      inc_stack
    end
    
    typesig { [] }
    def opc_lload_3
      emit_byte(self.attr_opc_lload_3)
      if (@max_locals < 5)
        @max_locals = 5
      end
      inc_stack
      inc_stack
    end
    
    typesig { [] }
    def opc_fload_0
      emit_byte(self.attr_opc_fload_0)
      if (@max_locals < 1)
        @max_locals = 1
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_fload_1
      emit_byte(self.attr_opc_fload_1)
      if (@max_locals < 2)
        @max_locals = 2
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_fload_2
      emit_byte(self.attr_opc_fload_2)
      if (@max_locals < 3)
        @max_locals = 3
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_fload_3
      emit_byte(self.attr_opc_fload_3)
      if (@max_locals < 4)
        @max_locals = 4
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_dload_0
      emit_byte(self.attr_opc_dload_0)
      if (@max_locals < 2)
        @max_locals = 2
      end
      inc_stack
      inc_stack
    end
    
    typesig { [] }
    def opc_dload_1
      emit_byte(self.attr_opc_dload_1)
      if (@max_locals < 3)
        @max_locals = 3
      end
      inc_stack
      inc_stack
    end
    
    typesig { [] }
    def opc_dload_2
      emit_byte(self.attr_opc_dload_2)
      if (@max_locals < 4)
        @max_locals = 4
      end
      inc_stack
      inc_stack
    end
    
    typesig { [] }
    def opc_dload_3
      emit_byte(self.attr_opc_dload_3)
      if (@max_locals < 5)
        @max_locals = 5
      end
      inc_stack
      inc_stack
    end
    
    typesig { [] }
    def opc_aload_0
      emit_byte(self.attr_opc_aload_0)
      if (@max_locals < 1)
        @max_locals = 1
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_aload_1
      emit_byte(self.attr_opc_aload_1)
      if (@max_locals < 2)
        @max_locals = 2
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_aload_2
      emit_byte(self.attr_opc_aload_2)
      if (@max_locals < 3)
        @max_locals = 3
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_aload_3
      emit_byte(self.attr_opc_aload_3)
      if (@max_locals < 4)
        @max_locals = 4
      end
      inc_stack
    end
    
    typesig { [] }
    def opc_aaload
      emit_byte(self.attr_opc_aaload)
      dec_stack
    end
    
    typesig { [] }
    def opc_astore_0
      emit_byte(self.attr_opc_astore_0)
      if (@max_locals < 1)
        @max_locals = 1
      end
      dec_stack
    end
    
    typesig { [] }
    def opc_astore_1
      emit_byte(self.attr_opc_astore_1)
      if (@max_locals < 2)
        @max_locals = 2
      end
      dec_stack
    end
    
    typesig { [] }
    def opc_astore_2
      emit_byte(self.attr_opc_astore_2)
      if (@max_locals < 3)
        @max_locals = 3
      end
      dec_stack
    end
    
    typesig { [] }
    def opc_astore_3
      emit_byte(self.attr_opc_astore_3)
      if (@max_locals < 4)
        @max_locals = 4
      end
      dec_stack
    end
    
    typesig { [] }
    # //////////////////////
    # Stack manipulation //
    # //////////////////////
    def opc_pop
      emit_byte(self.attr_opc_pop)
      dec_stack
    end
    
    typesig { [] }
    def opc_dup
      emit_byte(self.attr_opc_dup)
      inc_stack
    end
    
    typesig { [] }
    def opc_dup_x1
      emit_byte(self.attr_opc_dup_x1)
      inc_stack
    end
    
    typesig { [] }
    def opc_swap
      emit_byte(self.attr_opc_swap)
    end
    
    typesig { [] }
    # /////////////////////////////
    # Widening conversions only //
    # /////////////////////////////
    def opc_i2l
      emit_byte(self.attr_opc_i2l)
    end
    
    typesig { [] }
    def opc_i2f
      emit_byte(self.attr_opc_i2f)
    end
    
    typesig { [] }
    def opc_i2d
      emit_byte(self.attr_opc_i2d)
    end
    
    typesig { [] }
    def opc_l2f
      emit_byte(self.attr_opc_l2f)
    end
    
    typesig { [] }
    def opc_l2d
      emit_byte(self.attr_opc_l2d)
    end
    
    typesig { [] }
    def opc_f2d
      emit_byte(self.attr_opc_f2d)
    end
    
    typesig { [::Java::Short] }
    # ////////////////
    # Control flow //
    # ////////////////
    def opc_ifeq(bci_offset)
      emit_byte(self.attr_opc_ifeq)
      emit_short(bci_offset)
      dec_stack
    end
    
    typesig { [Label] }
    # Control flow with forward-reference BCI. Stack assumes
    # straight-through control flow.
    def opc_ifeq(l)
      instr_bci = get_length
      emit_byte(self.attr_opc_ifeq)
      l.add(self, instr_bci, get_length, get_stack - 1)
      emit_short(RJava.cast_to_short(-1)) # Must be patched later
    end
    
    typesig { [::Java::Short] }
    def opc_if_icmpeq(bci_offset)
      emit_byte(self.attr_opc_if_icmpeq)
      emit_short(bci_offset)
      set_stack(get_stack - 2)
    end
    
    typesig { [Label] }
    # Control flow with forward-reference BCI. Stack assumes straight
    # control flow.
    def opc_if_icmpeq(l)
      instr_bci = get_length
      emit_byte(self.attr_opc_if_icmpeq)
      l.add(self, instr_bci, get_length, get_stack - 2)
      emit_short(RJava.cast_to_short(-1)) # Must be patched later
    end
    
    typesig { [::Java::Short] }
    def opc_goto(bci_offset)
      emit_byte(self.attr_opc_goto)
      emit_short(bci_offset)
    end
    
    typesig { [Label] }
    # Control flow with forward-reference BCI. Stack assumes straight
    # control flow.
    def opc_goto(l)
      instr_bci = get_length
      emit_byte(self.attr_opc_goto)
      l.add(self, instr_bci, get_length, get_stack)
      emit_short(RJava.cast_to_short(-1)) # Must be patched later
    end
    
    typesig { [::Java::Short] }
    def opc_ifnull(bci_offset)
      emit_byte(self.attr_opc_ifnull)
      emit_short(bci_offset)
      dec_stack
    end
    
    typesig { [Label] }
    # Control flow with forward-reference BCI. Stack assumes straight
    # control flow.
    def opc_ifnull(l)
      instr_bci = get_length
      emit_byte(self.attr_opc_ifnull)
      l.add(self, instr_bci, get_length, get_stack - 1)
      emit_short(RJava.cast_to_short(-1)) # Must be patched later
      dec_stack
    end
    
    typesig { [::Java::Short] }
    def opc_ifnonnull(bci_offset)
      emit_byte(self.attr_opc_ifnonnull)
      emit_short(bci_offset)
      dec_stack
    end
    
    typesig { [Label] }
    # Control flow with forward-reference BCI. Stack assumes straight
    # control flow.
    def opc_ifnonnull(l)
      instr_bci = get_length
      emit_byte(self.attr_opc_ifnonnull)
      l.add(self, instr_bci, get_length, get_stack - 1)
      emit_short(RJava.cast_to_short(-1)) # Must be patched later
      dec_stack
    end
    
    typesig { [] }
    # ///////////////////////
    # Return instructions //
    # ///////////////////////
    def opc_ireturn
      emit_byte(self.attr_opc_ireturn)
      set_stack(0)
    end
    
    typesig { [] }
    def opc_lreturn
      emit_byte(self.attr_opc_lreturn)
      set_stack(0)
    end
    
    typesig { [] }
    def opc_freturn
      emit_byte(self.attr_opc_freturn)
      set_stack(0)
    end
    
    typesig { [] }
    def opc_dreturn
      emit_byte(self.attr_opc_dreturn)
      set_stack(0)
    end
    
    typesig { [] }
    def opc_areturn
      emit_byte(self.attr_opc_areturn)
      set_stack(0)
    end
    
    typesig { [] }
    def opc_return
      emit_byte(self.attr_opc_return)
      set_stack(0)
    end
    
    typesig { [::Java::Short, ::Java::Int] }
    # ////////////////////
    # Field operations //
    # ////////////////////
    def opc_getstatic(field_index, field_size_in_stack_slots)
      emit_byte(self.attr_opc_getstatic)
      emit_short(field_index)
      set_stack(get_stack + field_size_in_stack_slots)
    end
    
    typesig { [::Java::Short, ::Java::Int] }
    def opc_putstatic(field_index, field_size_in_stack_slots)
      emit_byte(self.attr_opc_putstatic)
      emit_short(field_index)
      set_stack(get_stack - field_size_in_stack_slots)
    end
    
    typesig { [::Java::Short, ::Java::Int] }
    def opc_getfield(field_index, field_size_in_stack_slots)
      emit_byte(self.attr_opc_getfield)
      emit_short(field_index)
      set_stack(get_stack + field_size_in_stack_slots - 1)
    end
    
    typesig { [::Java::Short, ::Java::Int] }
    def opc_putfield(field_index, field_size_in_stack_slots)
      emit_byte(self.attr_opc_putfield)
      emit_short(field_index)
      set_stack(get_stack - field_size_in_stack_slots - 1)
    end
    
    typesig { [::Java::Short, ::Java::Int, ::Java::Int] }
    # //////////////////////
    # Method invocations //
    # //////////////////////
    # Long and double arguments and return types count as 2 arguments;
    # other values count as 1.
    def opc_invokevirtual(method_index, num_args, num_return_values)
      emit_byte(self.attr_opc_invokevirtual)
      emit_short(method_index)
      set_stack(get_stack - num_args - 1 + num_return_values)
    end
    
    typesig { [::Java::Short, ::Java::Int, ::Java::Int] }
    # Long and double arguments and return types count as 2 arguments;
    # other values count as 1.
    def opc_invokespecial(method_index, num_args, num_return_values)
      emit_byte(self.attr_opc_invokespecial)
      emit_short(method_index)
      set_stack(get_stack - num_args - 1 + num_return_values)
    end
    
    typesig { [::Java::Short, ::Java::Int, ::Java::Int] }
    # Long and double arguments and return types count as 2 arguments;
    # other values count as 1.
    def opc_invokestatic(method_index, num_args, num_return_values)
      emit_byte(self.attr_opc_invokestatic)
      emit_short(method_index)
      set_stack(get_stack - num_args + num_return_values)
    end
    
    typesig { [::Java::Short, ::Java::Int, ::Java::Byte, ::Java::Int] }
    # Long and double arguments and return types count as 2 arguments;
    # other values count as 1.
    def opc_invokeinterface(method_index, num_args, count, num_return_values)
      emit_byte(self.attr_opc_invokeinterface)
      emit_short(method_index)
      emit_byte(count)
      emit_byte(0)
      set_stack(get_stack - num_args - 1 + num_return_values)
    end
    
    typesig { [] }
    # ////////////////
    # Array length //
    # ////////////////
    def opc_arraylength
      emit_byte(self.attr_opc_arraylength)
    end
    
    typesig { [::Java::Short] }
    # ///////
    # New //
    # ///////
    def opc_new(class_index)
      emit_byte(self.attr_opc_new)
      emit_short(class_index)
      inc_stack
    end
    
    typesig { [] }
    # //////////
    # Athrow //
    # //////////
    def opc_athrow
      emit_byte(self.attr_opc_athrow)
      set_stack(1)
    end
    
    typesig { [::Java::Short] }
    # ////////////////////////////
    # Checkcast and instanceof //
    # ////////////////////////////
    # Assumes the checkcast succeeds
    def opc_checkcast(class_index)
      emit_byte(self.attr_opc_checkcast)
      emit_short(class_index)
    end
    
    typesig { [::Java::Short] }
    def opc_instanceof(class_index)
      emit_byte(self.attr_opc_instanceof)
      emit_short(class_index)
    end
    
    private
    alias_method :initialize__class_file_assembler, :initialize
  end
  
end
