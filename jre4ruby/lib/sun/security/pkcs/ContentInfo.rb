require "rjava"

# 
# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs
  module ContentInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs
      include ::Java::Io
      include ::Sun::Security::Util
    }
  end
  
  # 
  # A ContentInfo type, as defined in PKCS#7.
  # 
  # @author Benjamin Renaud
  class ContentInfo 
    include_class_members ContentInfoImports
    
    class_module.module_eval {
      # pkcs7 pre-defined content types
      
      def pkcs7
        defined?(@@pkcs7) ? @@pkcs7 : @@pkcs7= Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 7])
      end
      alias_method :attr_pkcs7, :pkcs7
      
      def pkcs7=(value)
        @@pkcs7 = value
      end
      alias_method :attr_pkcs7=, :pkcs7=
      
      
      def data
        defined?(@@data) ? @@data : @@data= Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 7, 1])
      end
      alias_method :attr_data, :data
      
      def data=(value)
        @@data = value
      end
      alias_method :attr_data=, :data=
      
      
      def sdata
        defined?(@@sdata) ? @@sdata : @@sdata= Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 7, 2])
      end
      alias_method :attr_sdata, :sdata
      
      def sdata=(value)
        @@sdata = value
      end
      alias_method :attr_sdata=, :sdata=
      
      
      def edata
        defined?(@@edata) ? @@edata : @@edata= Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 7, 3])
      end
      alias_method :attr_edata, :edata
      
      def edata=(value)
        @@edata = value
      end
      alias_method :attr_edata=, :edata=
      
      
      def sedata
        defined?(@@sedata) ? @@sedata : @@sedata= Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 7, 4])
      end
      alias_method :attr_sedata, :sedata
      
      def sedata=(value)
        @@sedata = value
      end
      alias_method :attr_sedata=, :sedata=
      
      
      def ddata
        defined?(@@ddata) ? @@ddata : @@ddata= Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 7, 5])
      end
      alias_method :attr_ddata, :ddata
      
      def ddata=(value)
        @@ddata = value
      end
      alias_method :attr_ddata=, :ddata=
      
      
      def crdata
        defined?(@@crdata) ? @@crdata : @@crdata= Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 7, 6])
      end
      alias_method :attr_crdata, :crdata
      
      def crdata=(value)
        @@crdata = value
      end
      alias_method :attr_crdata=, :crdata=
      
      
      def nsdata
        defined?(@@nsdata) ? @@nsdata : @@nsdata= Array.typed(::Java::Int).new([2, 16, 840, 1, 113730, 2, 5])
      end
      alias_method :attr_nsdata, :nsdata
      
      def nsdata=(value)
        @@nsdata = value
      end
      alias_method :attr_nsdata=, :nsdata=
      
      # timestamp token (id-ct-TSTInfo) from RFC 3161
      
      def tst_info
        defined?(@@tst_info) ? @@tst_info : @@tst_info= Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 9, 16, 1, 4])
      end
      alias_method :attr_tst_info, :tst_info
      
      def tst_info=(value)
        @@tst_info = value
      end
      alias_method :attr_tst_info=, :tst_info=
      
      # this is for backwards-compatibility with JDK 1.1.x
      const_set_lazy(:OLD_SDATA) { Array.typed(::Java::Int).new([1, 2, 840, 1113549, 1, 7, 2]) }
      const_attr_reader  :OLD_SDATA
      
      const_set_lazy(:OLD_DATA) { Array.typed(::Java::Int).new([1, 2, 840, 1113549, 1, 7, 1]) }
      const_attr_reader  :OLD_DATA
      
      
      def pkcs7_oid
        defined?(@@pkcs7_oid) ? @@pkcs7_oid : @@pkcs7_oid= nil
      end
      alias_method :attr_pkcs7_oid, :pkcs7_oid
      
      def pkcs7_oid=(value)
        @@pkcs7_oid = value
      end
      alias_method :attr_pkcs7_oid=, :pkcs7_oid=
      
      
      def data_oid
        defined?(@@data_oid) ? @@data_oid : @@data_oid= nil
      end
      alias_method :attr_data_oid, :data_oid
      
      def data_oid=(value)
        @@data_oid = value
      end
      alias_method :attr_data_oid=, :data_oid=
      
      
      def signed_data_oid
        defined?(@@signed_data_oid) ? @@signed_data_oid : @@signed_data_oid= nil
      end
      alias_method :attr_signed_data_oid, :signed_data_oid
      
      def signed_data_oid=(value)
        @@signed_data_oid = value
      end
      alias_method :attr_signed_data_oid=, :signed_data_oid=
      
      
      def enveloped_data_oid
        defined?(@@enveloped_data_oid) ? @@enveloped_data_oid : @@enveloped_data_oid= nil
      end
      alias_method :attr_enveloped_data_oid, :enveloped_data_oid
      
      def enveloped_data_oid=(value)
        @@enveloped_data_oid = value
      end
      alias_method :attr_enveloped_data_oid=, :enveloped_data_oid=
      
      
      def signed_and_enveloped_data_oid
        defined?(@@signed_and_enveloped_data_oid) ? @@signed_and_enveloped_data_oid : @@signed_and_enveloped_data_oid= nil
      end
      alias_method :attr_signed_and_enveloped_data_oid, :signed_and_enveloped_data_oid
      
      def signed_and_enveloped_data_oid=(value)
        @@signed_and_enveloped_data_oid = value
      end
      alias_method :attr_signed_and_enveloped_data_oid=, :signed_and_enveloped_data_oid=
      
      
      def digested_data_oid
        defined?(@@digested_data_oid) ? @@digested_data_oid : @@digested_data_oid= nil
      end
      alias_method :attr_digested_data_oid, :digested_data_oid
      
      def digested_data_oid=(value)
        @@digested_data_oid = value
      end
      alias_method :attr_digested_data_oid=, :digested_data_oid=
      
      
      def encrypted_data_oid
        defined?(@@encrypted_data_oid) ? @@encrypted_data_oid : @@encrypted_data_oid= nil
      end
      alias_method :attr_encrypted_data_oid, :encrypted_data_oid
      
      def encrypted_data_oid=(value)
        @@encrypted_data_oid = value
      end
      alias_method :attr_encrypted_data_oid=, :encrypted_data_oid=
      
      
      def old_signed_data_oid
        defined?(@@old_signed_data_oid) ? @@old_signed_data_oid : @@old_signed_data_oid= nil
      end
      alias_method :attr_old_signed_data_oid, :old_signed_data_oid
      
      def old_signed_data_oid=(value)
        @@old_signed_data_oid = value
      end
      alias_method :attr_old_signed_data_oid=, :old_signed_data_oid=
      
      
      def old_data_oid
        defined?(@@old_data_oid) ? @@old_data_oid : @@old_data_oid= nil
      end
      alias_method :attr_old_data_oid, :old_data_oid
      
      def old_data_oid=(value)
        @@old_data_oid = value
      end
      alias_method :attr_old_data_oid=, :old_data_oid=
      
      
      def netscape_cert_sequence_oid
        defined?(@@netscape_cert_sequence_oid) ? @@netscape_cert_sequence_oid : @@netscape_cert_sequence_oid= nil
      end
      alias_method :attr_netscape_cert_sequence_oid, :netscape_cert_sequence_oid
      
      def netscape_cert_sequence_oid=(value)
        @@netscape_cert_sequence_oid = value
      end
      alias_method :attr_netscape_cert_sequence_oid=, :netscape_cert_sequence_oid=
      
      
      def timestamp_token_info_oid
        defined?(@@timestamp_token_info_oid) ? @@timestamp_token_info_oid : @@timestamp_token_info_oid= nil
      end
      alias_method :attr_timestamp_token_info_oid, :timestamp_token_info_oid
      
      def timestamp_token_info_oid=(value)
        @@timestamp_token_info_oid = value
      end
      alias_method :attr_timestamp_token_info_oid=, :timestamp_token_info_oid=
      
      when_class_loaded do
        self.attr_pkcs7_oid = ObjectIdentifier.new_internal(self.attr_pkcs7)
        self.attr_data_oid = ObjectIdentifier.new_internal(self.attr_data)
        self.attr_signed_data_oid = ObjectIdentifier.new_internal(self.attr_sdata)
        self.attr_enveloped_data_oid = ObjectIdentifier.new_internal(self.attr_edata)
        self.attr_signed_and_enveloped_data_oid = ObjectIdentifier.new_internal(self.attr_sedata)
        self.attr_digested_data_oid = ObjectIdentifier.new_internal(self.attr_ddata)
        self.attr_encrypted_data_oid = ObjectIdentifier.new_internal(self.attr_crdata)
        self.attr_old_signed_data_oid = ObjectIdentifier.new_internal(OLD_SDATA)
        self.attr_old_data_oid = ObjectIdentifier.new_internal(OLD_DATA)
        # 
        # The ASN.1 systax for the Netscape Certificate Sequence
        # data type is defined
        # <a href=http://wp.netscape.com/eng/security/comm4-cert-download.html>
        # here.</a>
        self.attr_netscape_cert_sequence_oid = ObjectIdentifier.new_internal(self.attr_nsdata)
        self.attr_timestamp_token_info_oid = ObjectIdentifier.new_internal(self.attr_tst_info)
      end
    }
    
    attr_accessor :content_type
    alias_method :attr_content_type, :content_type
    undef_method :content_type
    alias_method :attr_content_type=, :content_type=
    undef_method :content_type=
    
    attr_accessor :content
    alias_method :attr_content, :content
    undef_method :content
    alias_method :attr_content=, :content=
    undef_method :content=
    
    typesig { [ObjectIdentifier, DerValue] }
    # OPTIONAL
    def initialize(content_type, content)
      @content_type = nil
      @content = nil
      @content_type = content_type
      @content = content
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Make a contentInfo of type data.
    def initialize(bytes)
      @content_type = nil
      @content = nil
      octet_string = DerValue.new(DerValue.attr_tag_octet_string, bytes)
      @content_type = self.attr_data_oid
      @content = octet_string
    end
    
    typesig { [DerInputStream] }
    # 
    # Parses a PKCS#7 content info.
    def initialize(derin)
      initialize__content_info(derin, false)
    end
    
    typesig { [DerInputStream, ::Java::Boolean] }
    # 
    # Parses a PKCS#7 content info.
    # 
    # <p>This constructor is used only for backwards compatibility with
    # PKCS#7 blocks that were generated using JDK1.1.x.
    # 
    # @param derin the ASN.1 encoding of the content info.
    # @param oldStyle flag indicating whether or not the given content info
    # is encoded according to JDK1.1.x.
    def initialize(derin, old_style)
      @content_type = nil
      @content = nil
      dis_type = nil
      dis_tagged_content = nil
      type = nil
      tagged_content = nil
      type_and_content = nil
      contents = nil
      type_and_content = derin.get_sequence(2)
      # Parse the content type
      type = type_and_content[0]
      dis_type = DerInputStream.new(type.to_byte_array)
      @content_type = dis_type.get_oid
      if (old_style)
        # JDK1.1.x-style encoding
        @content = type_and_content[1]
      else
        # This is the correct, standards-compliant encoding.
        # Parse the content (OPTIONAL field).
        # Skip the [0] EXPLICIT tag by pretending that the content is the
        # one and only element in an implicitly tagged set
        if (type_and_content.attr_length > 1)
          # content is OPTIONAL
          tagged_content = type_and_content[1]
          dis_tagged_content = DerInputStream.new(tagged_content.to_byte_array)
          contents = dis_tagged_content.get_set(1, true)
          @content = contents[0]
        end
      end
    end
    
    typesig { [] }
    def get_content
      return @content
    end
    
    typesig { [] }
    def get_content_type
      return @content_type
    end
    
    typesig { [] }
    def get_data
      if ((@content_type == self.attr_data_oid) || (@content_type == self.attr_old_data_oid) || (@content_type == self.attr_timestamp_token_info_oid))
        if ((@content).nil?)
          return nil
        else
          return @content.get_octet_string
        end
      end
      raise IOException.new("content type is not DATA: " + (@content_type).to_s)
    end
    
    typesig { [DerOutputStream] }
    def encode(out)
      content_der_code = nil
      seq = nil
      seq = DerOutputStream.new
      seq.put_oid(@content_type)
      # content is optional, it could be external
      if (!(@content).nil?)
        tagged_content = nil
        content_der_code = DerOutputStream.new
        @content.encode(content_der_code)
        # Add the [0] EXPLICIT tag in front of the content encoding
        tagged_content = DerValue.new(0xa0, content_der_code.to_byte_array)
        seq.put_der_value(tagged_content)
      end
      out.write(DerValue.attr_tag_sequence, seq)
    end
    
    typesig { [] }
    # 
    # Returns a byte array representation of the data held in
    # the content field.
    def get_content_bytes
      if ((@content).nil?)
        return nil
      end
      dis = DerInputStream.new(@content.to_byte_array)
      return dis.get_octet_string
    end
    
    typesig { [] }
    def to_s
      out = ""
      out += "Content Info Sequence\n\tContent type: " + (@content_type).to_s + "\n"
      out += "\tContent: " + (@content).to_s
      return out
    end
    
    private
    alias_method :initialize__content_info, :initialize
  end
  
end
