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
  module LabelImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # Allows forward references in bytecode streams emitted by
  # ClassFileAssembler. Assumes that the start of the method body is
  # the first byte in the assembler's buffer. May be used at more than
  # one branch site.
  class Label 
    include_class_members LabelImports
    
    class_module.module_eval {
      const_set_lazy(:PatchInfo) { Class.new do
        include_class_members Label
        
        typesig { [ClassFileAssembler, ::Java::Short, ::Java::Short, ::Java::Int] }
        def initialize(asm, instr_bci, patch_bci, stack_depth)
          @asm = nil
          @instr_bci = 0
          @patch_bci = 0
          @stack_depth = 0
          @asm = asm
          @instr_bci = instr_bci
          @patch_bci = patch_bci
          @stack_depth = stack_depth
        end
        
        # This won't work for more than one assembler anyway, so this is
        # unnecessary
        attr_accessor :asm
        alias_method :attr_asm, :asm
        undef_method :asm
        alias_method :attr_asm=, :asm=
        undef_method :asm=
        
        attr_accessor :instr_bci
        alias_method :attr_instr_bci, :instr_bci
        undef_method :instr_bci
        alias_method :attr_instr_bci=, :instr_bci=
        undef_method :instr_bci=
        
        attr_accessor :patch_bci
        alias_method :attr_patch_bci, :patch_bci
        undef_method :patch_bci
        alias_method :attr_patch_bci=, :patch_bci=
        undef_method :patch_bci=
        
        attr_accessor :stack_depth
        alias_method :attr_stack_depth, :stack_depth
        undef_method :stack_depth
        alias_method :attr_stack_depth=, :stack_depth=
        undef_method :stack_depth=
        
        private
        alias_method :initialize__patch_info, :initialize
      end }
    }
    
    # <PatchInfo>
    attr_accessor :patches
    alias_method :attr_patches, :patches
    undef_method :patches
    alias_method :attr_patches=, :patches=
    undef_method :patches=
    
    typesig { [] }
    def initialize
      @patches = ArrayList.new
    end
    
    typesig { [ClassFileAssembler, ::Java::Short, ::Java::Short, ::Java::Int] }
    def add(asm, instr_bci, patch_bci, stack_depth)
      @patches.add(PatchInfo.new(asm, instr_bci, patch_bci, stack_depth))
    end
    
    typesig { [] }
    def bind
      iter = @patches.iterator
      while iter.has_next
        patch = iter.next
        cur_bci = patch.attr_asm.get_length
        offset = RJava.cast_to_short((cur_bci - patch.attr_instr_bci))
        patch.attr_asm.emit_short(patch.attr_patch_bci, offset)
        patch.attr_asm.set_stack(patch.attr_stack_depth)
      end
    end
    
    private
    alias_method :initialize__label, :initialize
  end
  
end
