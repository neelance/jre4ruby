require "rjava"

# 
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
module Sun::Misc
  module VMSupportImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Properties
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util::Jar, :JarFile
      include_const ::Java::Util::Jar, :Manifest
      include_const ::Java::Util::Jar, :Attributes
    }
  end
  
  # 
  # Support class used by JVMTI and VM attach mechanism.
  class VMSupport 
    include_class_members VMSupportImports
    
    class_module.module_eval {
      
      def agent_props
        defined?(@@agent_props) ? @@agent_props : @@agent_props= nil
      end
      alias_method :attr_agent_props, :agent_props
      
      def agent_props=(value)
        @@agent_props = value
      end
      alias_method :attr_agent_props=, :agent_props=
      
      typesig { [] }
      # 
      # Returns the agent properties.
      def get_agent_properties
        synchronized(self) do
          if ((self.attr_agent_props).nil?)
            self.attr_agent_props = Properties.new
            init_agent_properties(self.attr_agent_props)
          end
          return self.attr_agent_props
        end
      end
      
      JNI.native_method :Java_sun_misc_VMSupport_initAgentProperties, [:pointer, :long, :long], :long
      typesig { [Properties] }
      def init_agent_properties(props)
        JNI.__send__(:Java_sun_misc_VMSupport_initAgentProperties, JNI.env, self.jni_id, props.jni_id)
      end
      
      typesig { [Properties] }
      # 
      # Write the given properties list to a byte array and return it. Properties with
      # a key or value that is not a String is filtered out. The stream written to the byte
      # array is ISO 8859-1 encoded.
      def serialize_properties_to_byte_array(p)
        out = ByteArrayOutputStream.new(4096)
        props = Properties.new
        # stringPropertyNames() returns a snapshot of the property keys
        keyset = p.string_property_names
        keyset.each do |key|
          value = p.get_property(key)
          props.put(key, value)
        end
        props.store(out, nil)
        return out.to_byte_array
      end
      
      typesig { [] }
      def serialize_properties_to_byte_array
        return serialize_properties_to_byte_array(System.get_properties)
      end
      
      typesig { [] }
      def serialize_agent_properties_to_byte_array
        return serialize_properties_to_byte_array(get_agent_properties)
      end
      
      typesig { [String] }
      # 
      # Returns true if the given JAR file has the Class-Path attribute in the
      # main section of the JAR manifest. Throws RuntimeException if the given
      # path is not a JAR file or some other error occurs.
      def is_class_path_attribute_present(path)
        begin
          man = (JarFile.new(path)).get_manifest
          if (!(man).nil?)
            if (!(man.get_main_attributes.get_value(Attributes::Name::CLASS_PATH)).nil?)
              return true
            end
          end
          return false
        rescue IOException => ioe
          raise RuntimeException.new(ioe.get_message)
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__vmsupport, :initialize
  end
  
end
