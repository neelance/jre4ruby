require "rjava"

# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net
  module NetPropertiesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include ::Java::Io
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :Properties
    }
  end
  
  # This class allows for centralized access to Networking properties.
  # Default values are loaded from the file jre/lib/net.properties
  # 
  # 
  # @author Jean-Christophe Collet
  class NetProperties 
    include_class_members NetPropertiesImports
    
    class_module.module_eval {
      
      def props
        defined?(@@props) ? @@props : @@props= Properties.new
      end
      alias_method :attr_props, :props
      
      def props=(value)
        @@props = value
      end
      alias_method :attr_props=, :props=
      
      when_class_loaded do
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          local_class_in NetProperties
          include_class_members NetProperties
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            load_default_properties
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [] }
      # Loads the default networking system properties
      # the file is in jre/lib/net.properties
      def load_default_properties
        fname = System.get_property("java.home")
        if ((fname).nil?)
          raise JavaError.new("Can't find java.home ??")
        end
        begin
          f = JavaFile.new(fname, "lib")
          f = JavaFile.new(f, "net.properties")
          fname = RJava.cast_to_string(f.get_canonical_path)
          in_ = FileInputStream.new(fname)
          bin = BufferedInputStream.new(in_)
          self.attr_props.load(bin)
          bin.close
        rescue JavaException => e
          # Do nothing. We couldn't find or access the file
          # so we won't have default properties...
        end
      end
      
      typesig { [String] }
      # Get a networking system property. If no system property was defined
      # returns the default value, if it exists, otherwise returns
      # <code>null</code>.
      # @param      key  the property name.
      # @throws  SecurityException  if a security manager exists and its
      # <code>checkPropertiesAccess</code> method doesn't allow access
      # to the system properties.
      # @return the <code>String</code> value for the property,
      # or <code>null</code>
      def get(key)
        def_ = self.attr_props.get_property(key)
        begin
          return System.get_property(key, def_)
        rescue IllegalArgumentException => e
        rescue NullPointerException => e
        end
        return nil
      end
      
      typesig { [String, ::Java::Int] }
      # Get an Integer networking system property. If no system property was
      # defined returns the default value, if it exists, otherwise returns
      # <code>null</code>.
      # @param   key     the property name.
      # @param   defval  the default value to use if the property is not found
      # @throws  SecurityException  if a security manager exists and its
      # <code>checkPropertiesAccess</code> method doesn't allow access
      # to the system properties.
      # @return the <code>Integer</code> value for the property,
      # or <code>null</code>
      def get_integer(key, defval)
        val = nil
        begin
          val = RJava.cast_to_string(System.get_property(key, self.attr_props.get_property(key)))
        rescue IllegalArgumentException => e
        rescue NullPointerException => e
        end
        if (!(val).nil?)
          begin
            return JavaInteger.decode(val)
          rescue NumberFormatException => ex
          end
        end
        return defval
      end
      
      typesig { [String] }
      # Get a Boolean networking system property. If no system property was
      # defined returns the default value, if it exists, otherwise returns
      # <code>null</code>.
      # @param   key     the property name.
      # @throws  SecurityException  if a security manager exists and its
      # <code>checkPropertiesAccess</code> method doesn't allow access
      # to the system properties.
      # @return the <code>Boolean</code> value for the property,
      # or <code>null</code>
      def get_boolean(key)
        val = nil
        begin
          val = RJava.cast_to_string(System.get_property(key, self.attr_props.get_property(key)))
        rescue IllegalArgumentException => e
        rescue NullPointerException => e
        end
        if (!(val).nil?)
          begin
            return Boolean.value_of(val)
          rescue NumberFormatException => ex
          end
        end
        return nil
      end
    }
    
    private
    alias_method :initialize__net_properties, :initialize
  end
  
end
