require "rjava"

# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module ProtocolListImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Util
    }
  end
  
  # A list of ProtocolVersions. Also maintains the list of supported protocols.
  # Instances of this class are immutable. Some member variables are final
  # and can be accessed directly without method accessors.
  # 
  # @author  Andreas Sterbenz
  # @since   1.4.1
  class ProtocolList 
    include_class_members ProtocolListImports
    
    attr_accessor :protocols
    alias_method :attr_protocols, :protocols
    undef_method :protocols
    alias_method :attr_protocols=, :protocols=
    undef_method :protocols=
    
    attr_accessor :protocol_names
    alias_method :attr_protocol_names, :protocol_names
    undef_method :protocol_names
    alias_method :attr_protocol_names=, :protocol_names=
    undef_method :protocol_names=
    
    # the minimum and maximum ProtocolVersions in this list
    attr_accessor :min
    alias_method :attr_min, :min
    undef_method :min
    alias_method :attr_min=, :min=
    undef_method :min=
    
    attr_accessor :max
    alias_method :attr_max, :max
    undef_method :max
    alias_method :attr_max=, :max=
    undef_method :max=
    
    # the format for the hello version to use
    attr_accessor :hello_version
    alias_method :attr_hello_version, :hello_version
    undef_method :hello_version
    alias_method :attr_hello_version=, :hello_version=
    undef_method :hello_version=
    
    typesig { [Array.typed(String)] }
    def initialize(names)
      @protocols = nil
      @protocol_names = nil
      @min = nil
      @max = nil
      @hello_version = nil
      if ((names).nil?)
        raise IllegalArgumentException.new("Protocols may not be null")
      end
      @protocols = ArrayList.new(3)
      i = 0
      while i < names.attr_length
        version = ProtocolVersion.value_of(names[i])
        if ((@protocols.contains(version)).equal?(false))
          @protocols.add(version)
        end
        i += 1
      end
      if (((@protocols.size).equal?(1)) && @protocols.contains(ProtocolVersion::SSL20Hello))
        raise IllegalArgumentException.new("SSLv2Hello" + "cannot be enabled unless TLSv1 or SSLv3 is also enabled")
      end
      @min = contains(ProtocolVersion::SSL30) ? ProtocolVersion::SSL30 : ProtocolVersion::TLS10
      @max = contains(ProtocolVersion::TLS10) ? ProtocolVersion::TLS10 : ProtocolVersion::SSL30
      if (@protocols.contains(ProtocolVersion::SSL20Hello))
        @hello_version = ProtocolVersion::SSL20Hello
      else
        @hello_version = @min
      end
    end
    
    typesig { [ProtocolVersion] }
    # Return whether this list contains the specified protocol version.
    # SSLv2Hello is not a real protocol version we support, we always
    # return false for it.
    def contains(protocol_version)
      if ((protocol_version).equal?(ProtocolVersion::SSL20Hello))
        return false
      end
      return @protocols.contains(protocol_version)
    end
    
    typesig { [] }
    # Return an array with the names of the ProtocolVersions in this list.
    def to_string_array
      synchronized(self) do
        if ((@protocol_names).nil?)
          @protocol_names = Array.typed(String).new(@protocols.size) { nil }
          i = 0
          @protocols.each do |version|
            @protocol_names[((i += 1) - 1)] = version.attr_name
          end
        end
        return @protocol_names.clone
      end
    end
    
    typesig { [] }
    def to_s
      return @protocols.to_s
    end
    
    class_module.module_eval {
      typesig { [] }
      # Return the list of default enabled protocols. Currently, this
      # is identical to the supported protocols.
      def get_default
        return SUPPORTED
      end
      
      typesig { [] }
      # Return the list of supported protocols.
      def get_supported
        return SUPPORTED
      end
      
      when_class_loaded do
        if (SunJSSE.is_fips)
          const_set :SUPPORTED, ProtocolList.new(Array.typed(String).new([ProtocolVersion::TLS10.attr_name]))
        else
          const_set :SUPPORTED, ProtocolList.new(Array.typed(String).new([ProtocolVersion::SSL20Hello.attr_name, ProtocolVersion::SSL30.attr_name, ProtocolVersion::TLS10.attr_name]))
        end
      end
    }
    
    private
    alias_method :initialize__protocol_list, :initialize
  end
  
end
