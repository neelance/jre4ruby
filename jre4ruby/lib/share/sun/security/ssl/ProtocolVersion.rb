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
  module ProtocolVersionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
    }
  end
  
  # Type safe enum for an SSL/TLS protocol version. Instances are obtained
  # using the static factory methods or by referencing the static members
  # in this class. Member variables are final and can be accessed without
  # accessor methods.
  # 
  # There is only ever one instance per supported protocol version, this
  # means == can be used for comparision instead of equals() if desired.
  # 
  # Checks for a particular version number should generally take this form:
  # 
  # if (protocolVersion.v >= ProtocolVersion.TLS10) {
  # // TLS 1.0 code goes here
  # } else {
  # // SSL 3.0 code here
  # }
  # 
  # @author  Andreas Sterbenz
  # @since   1.4.1
  class ProtocolVersion 
    include_class_members ProtocolVersionImports
    
    class_module.module_eval {
      # dummy protocol version value for invalid SSLSession
      const_set_lazy(:NONE) { ProtocolVersion.new(-1, "NONE") }
      const_attr_reader  :NONE
      
      # If enabled, send/ accept SSLv2 hello messages
      const_set_lazy(:SSL20Hello) { ProtocolVersion.new(0x2, "SSLv2Hello") }
      const_attr_reader  :SSL20Hello
      
      # SSL 3.0
      const_set_lazy(:SSL30) { ProtocolVersion.new(0x300, "SSLv3") }
      const_attr_reader  :SSL30
      
      # TLS 1.0
      const_set_lazy(:TLS10) { ProtocolVersion.new(0x301, "TLSv1") }
      const_attr_reader  :TLS10
      
      # TLS 1.1
      # not supported yet, but added for better readability of the debug trace
      const_set_lazy(:TLS11) { ProtocolVersion.new(0x302, "TLSv1.1") }
      const_attr_reader  :TLS11
      
      const_set_lazy(:FIPS) { SunJSSE.is_fips }
      const_attr_reader  :FIPS
      
      # minimum version we implement (SSL 3.0)
      const_set_lazy(:MIN) { FIPS ? TLS10 : SSL30 }
      const_attr_reader  :MIN
      
      # maximum version we implement (TLS 1.0)
      const_set_lazy(:MAX) { TLS10 }
      const_attr_reader  :MAX
      
      # ProtocolVersion to use by default (TLS 1.0)
      const_set_lazy(:DEFAULT) { TLS10 }
      const_attr_reader  :DEFAULT
      
      # Default version for hello messages (SSLv2Hello)
      const_set_lazy(:DEFAULT_HELLO) { FIPS ? TLS10 : SSL20Hello }
      const_attr_reader  :DEFAULT_HELLO
    }
    
    # version in 16 bit MSB format as it appears in records and
    # messages, i.e. 0x0301 for TLS 1.0
    attr_accessor :v
    alias_method :attr_v, :v
    undef_method :v
    alias_method :attr_v=, :v=
    undef_method :v=
    
    # major and minor version
    attr_accessor :major
    alias_method :attr_major, :major
    undef_method :major
    alias_method :attr_major=, :major=
    undef_method :major=
    
    attr_accessor :minor
    alias_method :attr_minor, :minor
    undef_method :minor
    alias_method :attr_minor=, :minor=
    undef_method :minor=
    
    # name used in JSSE (e.g. TLSv1 for TLS 1.0)
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [::Java::Int, String] }
    # private
    def initialize(v, name)
      @v = 0
      @major = 0
      @minor = 0
      @name = nil
      @v = v
      @name = name
      @major = (v >> 8)
      @minor = (v & 0xff)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # private
      def value_of(v)
        if ((v).equal?(SSL30.attr_v))
          return SSL30
        else
          if ((v).equal?(TLS10.attr_v))
            return TLS10
          else
            if ((v).equal?(TLS11.attr_v))
              return TLS11
            else
              if ((v).equal?(SSL20Hello.attr_v))
                return SSL20Hello
              else
                major = (v >> 8) & 0xff
                minor = v & 0xff
                return ProtocolVersion.new(v, "Unknown-" + RJava.cast_to_string(major) + "." + RJava.cast_to_string(minor))
              end
            end
          end
        end
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Return a ProtocolVersion with the specified major and minor version
      # numbers. Never throws exceptions.
      def value_of(major, minor)
        major &= 0xff
        minor &= 0xff
        v = (major << 8) | minor
        return value_of(v)
      end
      
      typesig { [String] }
      # Return a ProtocolVersion for the given name.
      # 
      # @exception IllegalArgumentException if name is null or does not
      # identify a supported protocol
      def value_of(name)
        if ((name).nil?)
          raise IllegalArgumentException.new("Protocol cannot be null")
        end
        if (FIPS)
          if ((name == TLS10.attr_name))
            return TLS10
          else
            raise IllegalArgumentException.new("Only TLS 1.0 allowed in FIPS mode")
          end
        end
        if ((name == SSL30.attr_name))
          return SSL30
        else
          if ((name == TLS10.attr_name))
            return TLS10
          else
            if ((name == SSL20Hello.attr_name))
              return SSL20Hello
            else
              raise IllegalArgumentException.new(name)
            end
          end
        end
      end
    }
    
    typesig { [] }
    def to_s
      return @name
    end
    
    private
    alias_method :initialize__protocol_version, :initialize
  end
  
end
