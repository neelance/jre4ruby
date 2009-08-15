require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Annotation
  module RetentionPolicyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Annotation
    }
  end
  
  # Annotation retention policy.  The constants of this enumerated type
  # describe the various policies for retaining annotations.  They are used
  # in conjunction with the {@link Retention} meta-annotation type to specify
  # how long annotations are to be retained.
  # 
  # @author  Joshua Bloch
  # @since 1.5
  class RetentionPolicy 
    include_class_members RetentionPolicyImports
    
    class_module.module_eval {
      # Annotations are to be discarded by the compiler.
      const_set_lazy(:SOURCE) { RetentionPolicy.new.set_value_name("SOURCE") }
      const_attr_reader  :SOURCE
      
      # Annotations are to be recorded in the class file by the compiler
      # but need not be retained by the VM at run time.  This is the default
      # behavior.
      const_set_lazy(:CLASS) { RetentionPolicy.new.set_value_name("CLASS") }
      const_attr_reader  :CLASS
      
      # Annotations are to be recorded in the class file by the compiler and
      # retained by the VM at run time, so they may be read reflectively.
      # 
      # @see java.lang.reflect.AnnotatedElement
      const_set_lazy(:RUNTIME) { RetentionPolicy.new.set_value_name("RUNTIME") }
      const_attr_reader  :RUNTIME
    }
    
    typesig { [String] }
    def set_value_name(name)
      @value_name = name
      self
    end
    
    typesig { [] }
    def to_s
      @value_name
    end
    
    class_module.module_eval {
      typesig { [] }
      def values
        [SOURCE, CLASS, RUNTIME]
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__retention_policy, :initialize
  end
  
end
