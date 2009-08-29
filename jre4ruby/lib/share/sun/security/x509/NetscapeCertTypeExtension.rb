require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::X509
  module NetscapeCertTypeExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include ::Java::Util
      include ::Sun::Security::Util
    }
  end
  
  # Represents Netscape Certificate Type Extension.
  # The details are defined
  # <a href=http://www.netscape.com/eng/security/comm4-cert-exts.html>
  # here </a>.
  # 
  # <p>This extension, if present, defines both the purpose
  # (e.g., encipherment, signature, certificate signing) and the application
  # (e.g., SSL, S/Mime or Object Signing of the key contained in the
  # certificate. This extension has been superseded by IETF PKIX extensions
  # but is provided here for compatibility reasons.
  # 
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class NetscapeCertTypeExtension < NetscapeCertTypeExtensionImports.const_get :Extension
    include_class_members NetscapeCertTypeExtensionImports
    overload_protected {
      include CertAttrSet
    }
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.NetscapeCertType" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "NetscapeCertType" }
      const_attr_reader  :NAME
      
      const_set_lazy(:SSL_CLIENT) { "ssl_client" }
      const_attr_reader  :SSL_CLIENT
      
      const_set_lazy(:SSL_SERVER) { "ssl_server" }
      const_attr_reader  :SSL_SERVER
      
      const_set_lazy(:S_MIME) { "s_mime" }
      const_attr_reader  :S_MIME
      
      const_set_lazy(:OBJECT_SIGNING) { "object_signing" }
      const_attr_reader  :OBJECT_SIGNING
      
      const_set_lazy(:SSL_CA) { "ssl_ca" }
      const_attr_reader  :SSL_CA
      
      const_set_lazy(:S_MIME_CA) { "s_mime_ca" }
      const_attr_reader  :S_MIME_CA
      
      const_set_lazy(:OBJECT_SIGNING_CA) { "object_signing_ca" }
      const_attr_reader  :OBJECT_SIGNING_CA
      
      const_set_lazy(:CertType_data) { Array.typed(::Java::Int).new([2, 16, 840, 1, 113730, 1, 1]) }
      const_attr_reader  :CertType_data
      
      # Object identifier for the Netscape-Cert-Type extension.
      
      def netscape_cert_type_id
        defined?(@@netscape_cert_type_id) ? @@netscape_cert_type_id : @@netscape_cert_type_id= nil
      end
      alias_method :attr_netscape_cert_type_id, :netscape_cert_type_id
      
      def netscape_cert_type_id=(value)
        @@netscape_cert_type_id = value
      end
      alias_method :attr_netscape_cert_type_id=, :netscape_cert_type_id=
      
      when_class_loaded do
        begin
          self.attr_netscape_cert_type_id = ObjectIdentifier.new(CertType_data)
        rescue IOException => ioe
          # should not happen
        end
      end
    }
    
    attr_accessor :bit_string
    alias_method :attr_bit_string, :bit_string
    undef_method :bit_string
    alias_method :attr_bit_string=, :bit_string=
    undef_method :bit_string=
    
    class_module.module_eval {
      const_set_lazy(:MapEntry) { Class.new do
        include_class_members NetscapeCertTypeExtension
        
        attr_accessor :m_name
        alias_method :attr_m_name, :m_name
        undef_method :m_name
        alias_method :attr_m_name=, :m_name=
        undef_method :m_name=
        
        attr_accessor :m_position
        alias_method :attr_m_position, :m_position
        undef_method :m_position
        alias_method :attr_m_position=, :m_position=
        undef_method :m_position=
        
        typesig { [String, ::Java::Int] }
        def initialize(name, position)
          @m_name = nil
          @m_position = 0
          @m_name = name
          @m_position = position
        end
        
        private
        alias_method :initialize__map_entry, :initialize
      end }
      
      # note that bit 4 is reserved
      
      def m_map_data
        defined?(@@m_map_data) ? @@m_map_data : @@m_map_data= Array.typed(MapEntry).new([MapEntry.new(SSL_CLIENT, 0), MapEntry.new(SSL_SERVER, 1), MapEntry.new(S_MIME, 2), MapEntry.new(OBJECT_SIGNING, 3), MapEntry.new(SSL_CA, 5), MapEntry.new(S_MIME_CA, 6), MapEntry.new(OBJECT_SIGNING_CA, 7), ])
      end
      alias_method :attr_m_map_data, :m_map_data
      
      def m_map_data=(value)
        @@m_map_data = value
      end
      alias_method :attr_m_map_data=, :m_map_data=
      
      const_set_lazy(:M_AttributeNames) { Vector.new }
      const_attr_reader  :M_AttributeNames
      
      when_class_loaded do
        self.attr_m_map_data.each do |entry|
          M_AttributeNames.add(entry.attr_m_name)
        end
      end
      
      typesig { [String] }
      def get_position(name)
        i = 0
        while i < self.attr_m_map_data.attr_length
          if (name.equals_ignore_case(self.attr_m_map_data[i].attr_m_name))
            return self.attr_m_map_data[i].attr_m_position
          end
          i += 1
        end
        raise IOException.new("Attribute name [" + name + "] not recognized by CertAttrSet:NetscapeCertType.")
      end
    }
    
    typesig { [] }
    # Encode this extension value
    def encode_this
      os = DerOutputStream.new
      os.put_truncated_unaligned_bit_string(BitArray.new(@bit_string))
      self.attr_extension_value = os.to_byte_array
    end
    
    typesig { [::Java::Int] }
    # Check if bit is set.
    # 
    # @param position the position in the bit string to check.
    def is_set(position)
      return @bit_string[position]
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Set the bit at the specified position.
    def set(position, val)
      # enlarge bitString if necessary
      if (position >= @bit_string.attr_length)
        tmp = Array.typed(::Java::Boolean).new(position + 1) { false }
        System.arraycopy(@bit_string, 0, tmp, 0, @bit_string.attr_length)
        @bit_string = tmp
      end
      @bit_string[position] = val
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Create a NetscapeCertTypeExtension with the passed bit settings.
    # The criticality is set to true.
    # 
    # @param bitString the bits to be set for the extension.
    def initialize(bit_string)
      @bit_string = nil
      super()
      @bit_string = BitArray.new(bit_string.attr_length * 8, bit_string).to_boolean_array
      self.attr_extension_id = self.attr_netscape_cert_type_id
      self.attr_critical = true
      encode_this
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    # Create a NetscapeCertTypeExtension with the passed bit settings.
    # The criticality is set to true.
    # 
    # @param bitString the bits to be set for the extension.
    def initialize(bit_string)
      @bit_string = nil
      super()
      @bit_string = bit_string
      self.attr_extension_id = self.attr_netscape_cert_type_id
      self.attr_critical = true
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value of the same.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @bit_string = nil
      super()
      self.attr_extension_id = self.attr_netscape_cert_type_id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      @bit_string = val.get_unaligned_bit_string.to_boolean_array
    end
    
    typesig { [] }
    # Create a default key usage.
    def initialize
      @bit_string = nil
      super()
      self.attr_extension_id = self.attr_netscape_cert_type_id
      self.attr_critical = true
      @bit_string = Array.typed(::Java::Boolean).new(0) { false }
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(Boolean)))
        raise IOException.new("Attribute must be of type Boolean.")
      end
      val = (obj).boolean_value
      set(get_position(name), val)
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      return Boolean.value_of(is_set(get_position(name)))
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      set(get_position(name), false)
      encode_this
    end
    
    typesig { [] }
    # Returns a printable representation of the NetscapeCertType.
    def to_s
      s = RJava.cast_to_string(super) + "NetscapeCertType [\n"
      begin
        if (is_set(get_position(SSL_CLIENT)))
          s += "   SSL client\n"
        end
        if (is_set(get_position(SSL_SERVER)))
          s += "   SSL server\n"
        end
        if (is_set(get_position(S_MIME)))
          s += "   S/MIME\n"
        end
        if (is_set(get_position(OBJECT_SIGNING)))
          s += "   Object Signing\n"
        end
        if (is_set(get_position(SSL_CA)))
          s += "   SSL CA\n"
        end
        if (is_set(get_position(S_MIME_CA)))
          s += "   S/MIME CA\n"
        end
        if (is_set(get_position(OBJECT_SIGNING_CA)))
          s += "   Object Signing CA"
        end
      rescue JavaException => e
      end
      s += "]\n"
      return (s)
    end
    
    typesig { [OutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = self.attr_netscape_cert_type_id
        self.attr_critical = true
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      return M_AttributeNames.elements
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    typesig { [] }
    # Get a boolean array representing the bits of this extension,
    # as it maps to the KeyUsage extension.
    # @return the bit values of this extension mapped to the bit values
    # of the KeyUsage extension as an array of booleans.
    def get_key_usage_mapped_bits
      key_usage = KeyUsageExtension.new
      val = Boolean::TRUE
      begin
        if (is_set(get_position(SSL_CLIENT)) || is_set(get_position(S_MIME)) || is_set(get_position(OBJECT_SIGNING)))
          key_usage.set(key_usage.attr_digital_signature, val)
        end
        if (is_set(get_position(SSL_SERVER)))
          key_usage.set(key_usage.attr_key_encipherment, val)
        end
        if (is_set(get_position(SSL_CA)) || is_set(get_position(S_MIME_CA)) || is_set(get_position(OBJECT_SIGNING_CA)))
          key_usage.set(key_usage.attr_key_certsign, val)
        end
      rescue IOException => e
      end
      return key_usage.get_bits
    end
    
    private
    alias_method :initialize__netscape_cert_type_extension, :initialize
  end
  
end
