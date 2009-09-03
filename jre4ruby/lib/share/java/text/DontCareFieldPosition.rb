require "rjava"

# Copyright 2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Text
  module DontCareFieldPositionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
    }
  end
  
  # DontCareFieldPosition defines no-op FieldDelegate. Its
  # singleton is used for the format methods that don't take a
  # FieldPosition.
  class DontCareFieldPosition < DontCareFieldPositionImports.const_get :FieldPosition
    include_class_members DontCareFieldPositionImports
    
    class_module.module_eval {
      # The singleton of DontCareFieldPosition.
      const_set_lazy(:INSTANCE) { DontCareFieldPosition.new }
      const_attr_reader  :INSTANCE
    }
    
    attr_accessor :no_delegate
    alias_method :attr_no_delegate, :no_delegate
    undef_method :no_delegate
    alias_method :attr_no_delegate=, :no_delegate=
    undef_method :no_delegate=
    
    typesig { [] }
    def initialize
      @no_delegate = nil
      super(0)
      @no_delegate = Class.new(Format::FieldDelegate.class == Class ? Format::FieldDelegate : Object) do
        extend LocalClass
        include_class_members DontCareFieldPosition
        include Format::FieldDelegate if Format::FieldDelegate.class == Module
        
        typesig { [Format::Field, Object, ::Java::Int, ::Java::Int, StringBuffer] }
        define_method :formatted do |attr, value, start, end_, buffer|
        end
        
        typesig { [::Java::Int, Format::Field, Object, ::Java::Int, ::Java::Int, StringBuffer] }
        define_method :formatted do |field_id, attr, value, start, end_, buffer|
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    def get_field_delegate
      return @no_delegate
    end
    
    private
    alias_method :initialize__dont_care_field_position, :initialize
  end
  
end
