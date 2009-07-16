require "rjava"

# 
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
  module ClassFileConstantsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
    }
  end
  
  # Minimal set of class file constants for assembly of field and
  # method accessors.
  module ClassFileConstants
    include_class_members ClassFileConstantsImports
    
    class_module.module_eval {
      # Constants
      const_set_lazy(:Opc_aconst_null) { 0x1 }
      const_attr_reader  :Opc_aconst_null
      
      const_set_lazy(:Opc_sipush) { 0x11 }
      const_attr_reader  :Opc_sipush
      
      const_set_lazy(:Opc_ldc) { 0x12 }
      const_attr_reader  :Opc_ldc
      
      # Local variable loads and stores
      const_set_lazy(:Opc_iload_0) { 0x1a }
      const_attr_reader  :Opc_iload_0
      
      const_set_lazy(:Opc_iload_1) { 0x1b }
      const_attr_reader  :Opc_iload_1
      
      const_set_lazy(:Opc_iload_2) { 0x1c }
      const_attr_reader  :Opc_iload_2
      
      const_set_lazy(:Opc_iload_3) { 0x1d }
      const_attr_reader  :Opc_iload_3
      
      const_set_lazy(:Opc_lload_0) { 0x1e }
      const_attr_reader  :Opc_lload_0
      
      const_set_lazy(:Opc_lload_1) { 0x1f }
      const_attr_reader  :Opc_lload_1
      
      const_set_lazy(:Opc_lload_2) { 0x20 }
      const_attr_reader  :Opc_lload_2
      
      const_set_lazy(:Opc_lload_3) { 0x21 }
      const_attr_reader  :Opc_lload_3
      
      const_set_lazy(:Opc_fload_0) { 0x22 }
      const_attr_reader  :Opc_fload_0
      
      const_set_lazy(:Opc_fload_1) { 0x23 }
      const_attr_reader  :Opc_fload_1
      
      const_set_lazy(:Opc_fload_2) { 0x24 }
      const_attr_reader  :Opc_fload_2
      
      const_set_lazy(:Opc_fload_3) { 0x25 }
      const_attr_reader  :Opc_fload_3
      
      const_set_lazy(:Opc_dload_0) { 0x26 }
      const_attr_reader  :Opc_dload_0
      
      const_set_lazy(:Opc_dload_1) { 0x27 }
      const_attr_reader  :Opc_dload_1
      
      const_set_lazy(:Opc_dload_2) { 0x28 }
      const_attr_reader  :Opc_dload_2
      
      const_set_lazy(:Opc_dload_3) { 0x29 }
      const_attr_reader  :Opc_dload_3
      
      const_set_lazy(:Opc_aload_0) { 0x2a }
      const_attr_reader  :Opc_aload_0
      
      const_set_lazy(:Opc_aload_1) { 0x2b }
      const_attr_reader  :Opc_aload_1
      
      const_set_lazy(:Opc_aload_2) { 0x2c }
      const_attr_reader  :Opc_aload_2
      
      const_set_lazy(:Opc_aload_3) { 0x2d }
      const_attr_reader  :Opc_aload_3
      
      const_set_lazy(:Opc_aaload) { 0x32 }
      const_attr_reader  :Opc_aaload
      
      const_set_lazy(:Opc_astore_0) { 0x4b }
      const_attr_reader  :Opc_astore_0
      
      const_set_lazy(:Opc_astore_1) { 0x4c }
      const_attr_reader  :Opc_astore_1
      
      const_set_lazy(:Opc_astore_2) { 0x4d }
      const_attr_reader  :Opc_astore_2
      
      const_set_lazy(:Opc_astore_3) { 0x4e }
      const_attr_reader  :Opc_astore_3
      
      # Stack manipulation
      const_set_lazy(:Opc_pop) { 0x57 }
      const_attr_reader  :Opc_pop
      
      const_set_lazy(:Opc_dup) { 0x59 }
      const_attr_reader  :Opc_dup
      
      const_set_lazy(:Opc_dup_x1) { 0x5a }
      const_attr_reader  :Opc_dup_x1
      
      const_set_lazy(:Opc_swap) { 0x5f }
      const_attr_reader  :Opc_swap
      
      # Conversions
      const_set_lazy(:Opc_i2l) { 0x85 }
      const_attr_reader  :Opc_i2l
      
      const_set_lazy(:Opc_i2f) { 0x86 }
      const_attr_reader  :Opc_i2f
      
      const_set_lazy(:Opc_i2d) { 0x87 }
      const_attr_reader  :Opc_i2d
      
      const_set_lazy(:Opc_l2i) { 0x88 }
      const_attr_reader  :Opc_l2i
      
      const_set_lazy(:Opc_l2f) { 0x89 }
      const_attr_reader  :Opc_l2f
      
      const_set_lazy(:Opc_l2d) { 0x8a }
      const_attr_reader  :Opc_l2d
      
      const_set_lazy(:Opc_f2i) { 0x8b }
      const_attr_reader  :Opc_f2i
      
      const_set_lazy(:Opc_f2l) { 0x8c }
      const_attr_reader  :Opc_f2l
      
      const_set_lazy(:Opc_f2d) { 0x8d }
      const_attr_reader  :Opc_f2d
      
      const_set_lazy(:Opc_d2i) { 0x8e }
      const_attr_reader  :Opc_d2i
      
      const_set_lazy(:Opc_d2l) { 0x8f }
      const_attr_reader  :Opc_d2l
      
      const_set_lazy(:Opc_d2f) { 0x90 }
      const_attr_reader  :Opc_d2f
      
      const_set_lazy(:Opc_i2b) { 0x91 }
      const_attr_reader  :Opc_i2b
      
      const_set_lazy(:Opc_i2c) { 0x92 }
      const_attr_reader  :Opc_i2c
      
      const_set_lazy(:Opc_i2s) { 0x93 }
      const_attr_reader  :Opc_i2s
      
      # Control flow
      const_set_lazy(:Opc_ifeq) { 0x99 }
      const_attr_reader  :Opc_ifeq
      
      const_set_lazy(:Opc_if_icmpeq) { 0x9f }
      const_attr_reader  :Opc_if_icmpeq
      
      const_set_lazy(:Opc_goto) { 0xa7 }
      const_attr_reader  :Opc_goto
      
      # Return instructions
      const_set_lazy(:Opc_ireturn) { 0xac }
      const_attr_reader  :Opc_ireturn
      
      const_set_lazy(:Opc_lreturn) { 0xad }
      const_attr_reader  :Opc_lreturn
      
      const_set_lazy(:Opc_freturn) { 0xae }
      const_attr_reader  :Opc_freturn
      
      const_set_lazy(:Opc_dreturn) { 0xaf }
      const_attr_reader  :Opc_dreturn
      
      const_set_lazy(:Opc_areturn) { 0xb0 }
      const_attr_reader  :Opc_areturn
      
      const_set_lazy(:Opc_return) { 0xb1 }
      const_attr_reader  :Opc_return
      
      # Field operations
      const_set_lazy(:Opc_getstatic) { 0xb2 }
      const_attr_reader  :Opc_getstatic
      
      const_set_lazy(:Opc_putstatic) { 0xb3 }
      const_attr_reader  :Opc_putstatic
      
      const_set_lazy(:Opc_getfield) { 0xb4 }
      const_attr_reader  :Opc_getfield
      
      const_set_lazy(:Opc_putfield) { 0xb5 }
      const_attr_reader  :Opc_putfield
      
      # Method invocations
      const_set_lazy(:Opc_invokevirtual) { 0xb6 }
      const_attr_reader  :Opc_invokevirtual
      
      const_set_lazy(:Opc_invokespecial) { 0xb7 }
      const_attr_reader  :Opc_invokespecial
      
      const_set_lazy(:Opc_invokestatic) { 0xb8 }
      const_attr_reader  :Opc_invokestatic
      
      const_set_lazy(:Opc_invokeinterface) { 0xb9 }
      const_attr_reader  :Opc_invokeinterface
      
      # Array length
      const_set_lazy(:Opc_arraylength) { 0xbe }
      const_attr_reader  :Opc_arraylength
      
      # New
      const_set_lazy(:Opc_new) { 0xbb }
      const_attr_reader  :Opc_new
      
      # Athrow
      const_set_lazy(:Opc_athrow) { 0xbf }
      const_attr_reader  :Opc_athrow
      
      # Checkcast and instanceof
      const_set_lazy(:Opc_checkcast) { 0xc0 }
      const_attr_reader  :Opc_checkcast
      
      const_set_lazy(:Opc_instanceof) { 0xc1 }
      const_attr_reader  :Opc_instanceof
      
      # Ifnull and ifnonnull
      const_set_lazy(:Opc_ifnull) { 0xc6 }
      const_attr_reader  :Opc_ifnull
      
      const_set_lazy(:Opc_ifnonnull) { 0xc7 }
      const_attr_reader  :Opc_ifnonnull
      
      # Constant pool tags
      const_set_lazy(:CONSTANT_Class) { 7 }
      const_attr_reader  :CONSTANT_Class
      
      const_set_lazy(:CONSTANT_Fieldref) { 9 }
      const_attr_reader  :CONSTANT_Fieldref
      
      const_set_lazy(:CONSTANT_Methodref) { 10 }
      const_attr_reader  :CONSTANT_Methodref
      
      const_set_lazy(:CONSTANT_InterfaceMethodref) { 11 }
      const_attr_reader  :CONSTANT_InterfaceMethodref
      
      const_set_lazy(:CONSTANT_NameAndType) { 12 }
      const_attr_reader  :CONSTANT_NameAndType
      
      const_set_lazy(:CONSTANT_String) { 8 }
      const_attr_reader  :CONSTANT_String
      
      const_set_lazy(:CONSTANT_Utf8) { 1 }
      const_attr_reader  :CONSTANT_Utf8
      
      # Access flags
      const_set_lazy(:ACC_PUBLIC) { RJava.cast_to_short(0x1) }
      const_attr_reader  :ACC_PUBLIC
    }
  end
  
end
