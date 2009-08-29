require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect::Misc
  module ReflectUtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Misc
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Sun::Reflect, :Reflection
    }
  end
  
  class ReflectUtil 
    include_class_members ReflectUtilImports
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      def for_name(name)
        check_package_access(name)
        return Class.for_name(name)
      end
      
      typesig { [Class] }
      def new_instance(cls)
        check_package_access(cls)
        return cls.new_instance
      end
      
      typesig { [Class, Class, Object, ::Java::Int] }
      # Reflection.ensureMemberAccess is overly-restrictive
      # due to a bug. We awkwardly work around it for now.
      def ensure_member_access(current_class, member_class, target, modifiers)
        if ((target).nil? && Modifier.is_protected(modifiers))
          mods = modifiers
          mods = mods & (~Modifier::PROTECTED)
          mods = mods | Modifier::PUBLIC
          # See if we fail because of class modifiers
          Reflection.ensure_member_access(current_class, member_class, target, mods)
          begin
            # We're still here so class access was ok.
            # Now try with default field access.
            mods = mods & (~Modifier::PUBLIC)
            Reflection.ensure_member_access(current_class, member_class, target, mods)
            # We're still here so access is ok without
            # checking for protected.
            return
          rescue IllegalAccessException => e
            # Access failed but we're 'protected' so
            # if the test below succeeds then we're ok.
            if (is_subclass_of(current_class, member_class))
              return
            else
              raise e
            end
          end
        else
          Reflection.ensure_member_access(current_class, member_class, target, modifiers)
        end
      end
      
      typesig { [Class, Class] }
      def is_subclass_of(query_class, of_class)
        while (!(query_class).nil?)
          if ((query_class).equal?(of_class))
            return true
          end
          query_class = query_class.get_superclass
        end
        return false
      end
      
      typesig { [Class] }
      def check_package_access(clazz)
        check_package_access(clazz.get_name)
      end
      
      typesig { [String] }
      def check_package_access(name)
        s = System.get_security_manager
        if (!(s).nil?)
          cname = name.replace(Character.new(?/.ord), Character.new(?..ord))
          if (cname.starts_with("["))
            b = cname.last_index_of(Character.new(?[.ord)) + 2
            if (b > 1 && b < cname.length)
              cname = RJava.cast_to_string(cname.substring(b))
            end
          end
          i = cname.last_index_of(Character.new(?..ord))
          if (!(i).equal?(-1))
            s.check_package_access(cname.substring(0, i))
          end
        end
      end
      
      typesig { [Class] }
      def is_package_accessible(clazz)
        begin
          check_package_access(clazz)
        rescue SecurityException => e
          return false
        end
        return true
      end
    }
    
    private
    alias_method :initialize__reflect_util, :initialize
  end
  
end
