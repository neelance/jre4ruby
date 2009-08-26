require "rjava"

# Copyright 2006-2008 Sun Microsystems, Inc.  All Rights Reserved.
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
  module HelloExtensionsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :PrintStream
      include ::Java::Util
      include_const ::Java::Security::Spec, :ECParameterSpec
      include_const ::Javax::Net::Ssl, :SSLProtocolException
    }
  end
  
  # This file contains all the classes relevant to TLS Extensions for the
  # ClientHello and ServerHello messages. The extension mechanism and
  # several extensions are defined in RFC 3546. Additional extensions are
  # defined in the ECC RFC 4492.
  # 
  # Currently, only the two ECC extensions are fully supported.
  # 
  # The classes contained in this file are:
  # . HelloExtensions: a List of extensions as used in the client hello
  # and server hello messages.
  # . ExtensionType: an enum style class for the extension type
  # . HelloExtension: abstract base class for all extensions. All subclasses
  # must be immutable.
  # 
  # . UnknownExtension: used to represent all parsed extensions that we do not
  # explicitly support.
  # . ServerNameExtension: partially implemented server_name extension.
  # . SupportedEllipticCurvesExtension: the ECC supported curves extension.
  # . SupportedEllipticPointFormatsExtension: the ECC supported point formats
  # (compressed/uncompressed) extension.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class HelloExtensions 
    include_class_members HelloExtensionsImports
    
    attr_accessor :extensions
    alias_method :attr_extensions, :extensions
    undef_method :extensions
    alias_method :attr_extensions=, :extensions=
    undef_method :extensions=
    
    attr_accessor :encoded_length
    alias_method :attr_encoded_length, :encoded_length
    undef_method :encoded_length
    alias_method :attr_encoded_length=, :encoded_length=
    undef_method :encoded_length=
    
    typesig { [] }
    def initialize
      @extensions = nil
      @encoded_length = 0
      @extensions = Collections.empty_list
    end
    
    typesig { [HandshakeInStream] }
    def initialize(s)
      @extensions = nil
      @encoded_length = 0
      len = s.get_int16
      @extensions = ArrayList.new
      @encoded_length = len + 2
      while (len > 0)
        type = s.get_int16
        extlen = s.get_int16
        ext_type = ExtensionType.get(type)
        extension = nil
        if ((ext_type).equal?(ExtensionType::EXT_SERVER_NAME))
          extension = ServerNameExtension.new(s, extlen)
        else
          if ((ext_type).equal?(ExtensionType::EXT_ELLIPTIC_CURVES))
            extension = SupportedEllipticCurvesExtension.new(s, extlen)
          else
            if ((ext_type).equal?(ExtensionType::EXT_EC_POINT_FORMATS))
              extension = SupportedEllipticPointFormatsExtension.new(s, extlen)
            else
              extension = UnknownExtension.new(s, extlen, ext_type)
            end
          end
        end
        @extensions.add(extension)
        len -= extlen + 4
      end
      if (!(len).equal?(0))
        raise SSLProtocolException.new("Error parsing extensions: extra data")
      end
    end
    
    typesig { [] }
    # Return the List of extensions. Must not be modified by the caller.
    def list
      return @extensions
    end
    
    typesig { [HelloExtension] }
    def add(ext)
      if (@extensions.is_empty)
        @extensions = ArrayList.new
      end
      @extensions.add(ext)
      @encoded_length = -1
    end
    
    typesig { [ExtensionType] }
    def get(type)
      @extensions.each do |ext|
        if ((ext.attr_type).equal?(type))
          return ext
        end
      end
      return nil
    end
    
    typesig { [] }
    def length
      if (@encoded_length >= 0)
        return @encoded_length
      end
      if (@extensions.is_empty)
        @encoded_length = 0
      else
        @encoded_length = 2
        @extensions.each do |ext|
          @encoded_length += ext.length
        end
      end
      return @encoded_length
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      length_ = length
      if ((length_).equal?(0))
        return
      end
      s.put_int16(length_ - 2)
      @extensions.each do |ext|
        ext.send(s)
      end
    end
    
    typesig { [PrintStream] }
    def print(s)
      @extensions.each do |ext|
        s.println(ext.to_s)
      end
    end
    
    private
    alias_method :initialize__hello_extensions, :initialize
  end
  
  class ExtensionType 
    include_class_members HelloExtensionsImports
    
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [::Java::Int, String] }
    def initialize(id, name)
      @id = 0
      @name = nil
      @id = id
      @name = name
    end
    
    typesig { [] }
    def to_s
      return @name
    end
    
    class_module.module_eval {
      
      def known_extensions
        defined?(@@known_extensions) ? @@known_extensions : @@known_extensions= ArrayList.new(8)
      end
      alias_method :attr_known_extensions, :known_extensions
      
      def known_extensions=(value)
        @@known_extensions = value
      end
      alias_method :attr_known_extensions=, :known_extensions=
      
      typesig { [::Java::Int] }
      def get(id)
        self.attr_known_extensions.each do |ext|
          if ((ext.attr_id).equal?(id))
            return ext
          end
        end
        return ExtensionType.new(id, "type_" + RJava.cast_to_string(id))
      end
      
      typesig { [::Java::Int, String] }
      def e(id, name)
        ext = ExtensionType.new(id, name)
        self.attr_known_extensions.add(ext)
        return ext
      end
      
      # extensions defined in RFC 3546
      const_set_lazy(:EXT_SERVER_NAME) { e(0, "server_name") }
      const_attr_reader  :EXT_SERVER_NAME
      
      const_set_lazy(:EXT_MAX_FRAGMENT_LENGTH) { e(1, "max_fragment_length") }
      const_attr_reader  :EXT_MAX_FRAGMENT_LENGTH
      
      const_set_lazy(:EXT_CLIENT_CERTIFICATE_URL) { e(2, "client_certificate_url") }
      const_attr_reader  :EXT_CLIENT_CERTIFICATE_URL
      
      const_set_lazy(:EXT_TRUSTED_CA_KEYS) { e(3, "trusted_ca_keys") }
      const_attr_reader  :EXT_TRUSTED_CA_KEYS
      
      const_set_lazy(:EXT_TRUNCATED_HMAC) { e(4, "truncated_hmac") }
      const_attr_reader  :EXT_TRUNCATED_HMAC
      
      const_set_lazy(:EXT_STATUS_REQUEST) { e(5, "status_request") }
      const_attr_reader  :EXT_STATUS_REQUEST
      
      # extensions defined in RFC 4492 (ECC)
      const_set_lazy(:EXT_ELLIPTIC_CURVES) { e(10, "elliptic_curves") }
      const_attr_reader  :EXT_ELLIPTIC_CURVES
      
      const_set_lazy(:EXT_EC_POINT_FORMATS) { e(11, "ec_point_formats") }
      const_attr_reader  :EXT_EC_POINT_FORMATS
    }
    
    private
    alias_method :initialize__extension_type, :initialize
  end
  
  class HelloExtension 
    include_class_members HelloExtensionsImports
    
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    typesig { [ExtensionType] }
    def initialize(type)
      @type = nil
      @type = type
    end
    
    typesig { [] }
    # Length of the encoded extension, including the type and length fields
    def length
      raise NotImplementedError
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      raise NotImplementedError
    end
    
    typesig { [] }
    def to_s
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__hello_extension, :initialize
  end
  
  class UnknownExtension < HelloExtensionsImports.const_get :HelloExtension
    include_class_members HelloExtensionsImports
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    typesig { [HandshakeInStream, ::Java::Int, ExtensionType] }
    def initialize(s, len, type)
      @data = nil
      super(type)
      @data = Array.typed(::Java::Byte).new(len) { 0 }
      # s.read() does not handle 0-length arrays.
      if (!(len).equal?(0))
        s.read(@data)
      end
    end
    
    typesig { [] }
    def length
      return 4 + @data.attr_length
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      s.put_int16(self.attr_type.attr_id)
      s.put_bytes16(@data)
    end
    
    typesig { [] }
    def to_s
      return "Unsupported extension " + RJava.cast_to_string(self.attr_type) + ", data: " + RJava.cast_to_string(Debug.to_s(@data))
    end
    
    private
    alias_method :initialize__unknown_extension, :initialize
  end
  
  # Support for the server_name extension is incomplete. Parsing is implemented
  # so that we get nicer debug output, but we neither send it nor do we do
  # act on it if we receive it.
  class ServerNameExtension < HelloExtensionsImports.const_get :HelloExtension
    include_class_members HelloExtensionsImports
    
    class_module.module_eval {
      const_set_lazy(:NAME_HOST_NAME) { 0 }
      const_attr_reader  :NAME_HOST_NAME
    }
    
    attr_accessor :names
    alias_method :attr_names, :names
    undef_method :names
    alias_method :attr_names=, :names=
    undef_method :names=
    
    typesig { [HandshakeInStream, ::Java::Int] }
    def initialize(s, len)
      @names = nil
      super(ExtensionType::EXT_SERVER_NAME)
      @names = ArrayList.new
      while (len > 0)
        name = ServerName.new(s)
        @names.add(name)
        len -= name.attr_length + 2
      end
      if (!(len).equal?(0))
        raise SSLProtocolException.new("Invalid server_name extension")
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:ServerName) { Class.new do
        include_class_members ServerNameExtension
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :data
        alias_method :attr_data, :data
        undef_method :data
        alias_method :attr_data=, :data=
        undef_method :data=
        
        attr_accessor :hostname
        alias_method :attr_hostname, :hostname
        undef_method :hostname
        alias_method :attr_hostname=, :hostname=
        undef_method :hostname=
        
        typesig { [self::HandshakeInStream] }
        def initialize(s)
          @length = 0
          @type = 0
          @data = nil
          @hostname = nil
          @length = s.get_int16
          @type = s.get_int8
          @data = s.get_bytes16
          if ((@type).equal?(NAME_HOST_NAME))
            @hostname = RJava.cast_to_string(String.new(@data, "UTF8"))
          else
            @hostname = RJava.cast_to_string(nil)
          end
        end
        
        typesig { [] }
        def to_s
          if ((@type).equal?(NAME_HOST_NAME))
            return "host_name: " + @hostname
          else
            return "unknown-" + RJava.cast_to_string(@type) + ": " + RJava.cast_to_string(Debug.to_s(@data))
          end
        end
        
        private
        alias_method :initialize__server_name, :initialize
      end }
    }
    
    typesig { [] }
    def length
      raise RuntimeException.new("not yet supported")
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      raise RuntimeException.new("not yet supported")
    end
    
    typesig { [] }
    def to_s
      return "Unsupported extension " + RJava.cast_to_string(self.attr_type) + ", " + RJava.cast_to_string(@names.to_s)
    end
    
    private
    alias_method :initialize__server_name_extension, :initialize
  end
  
  class SupportedEllipticCurvesExtension < HelloExtensionsImports.const_get :HelloExtension
    include_class_members HelloExtensionsImports
    
    class_module.module_eval {
      when_class_loaded do
        ids = nil
        const_set :Fips, SunJSSE.is_fips
        if ((Fips).equal?(false))
          # NIST curves first
          # prefer NIST P-256, rest in order of increasing key length
          # non-NIST curves
          ids = Array.typed(::Java::Int).new([23, 1, 3, 19, 21, 6, 7, 9, 10, 24, 11, 12, 25, 13, 14, 15, 16, 17, 2, 18, 4, 5, 20, 8, 22, ])
        else
          # same as above, but allow only NIST curves in FIPS mode
          ids = Array.typed(::Java::Int).new([23, 1, 3, 19, 21, 6, 7, 9, 10, 24, 11, 12, 25, 13, 14, ])
        end
        const_set :DEFAULT, SupportedEllipticCurvesExtension.new(ids)
      end
    }
    
    attr_accessor :curve_ids
    alias_method :attr_curve_ids, :curve_ids
    undef_method :curve_ids
    alias_method :attr_curve_ids=, :curve_ids=
    undef_method :curve_ids=
    
    typesig { [Array.typed(::Java::Int)] }
    def initialize(curve_ids)
      @curve_ids = nil
      super(ExtensionType::EXT_ELLIPTIC_CURVES)
      @curve_ids = curve_ids
    end
    
    typesig { [HandshakeInStream, ::Java::Int] }
    def initialize(s, len)
      @curve_ids = nil
      super(ExtensionType::EXT_ELLIPTIC_CURVES)
      k = s.get_int16
      if ((!((len & 1)).equal?(0)) || (!(k + 2).equal?(len)))
        raise SSLProtocolException.new("Invalid " + RJava.cast_to_string(self.attr_type) + " extension")
      end
      @curve_ids = Array.typed(::Java::Int).new(k >> 1) { 0 }
      i = 0
      while i < @curve_ids.attr_length
        @curve_ids[i] = s.get_int16
        i += 1
      end
    end
    
    typesig { [::Java::Int] }
    def contains(index)
      @curve_ids.each do |curveId|
        if ((index).equal?(curve_id))
          return true
        end
      end
      return false
    end
    
    typesig { [] }
    # Return a reference to the internal curveIds array.
    # The caller must NOT modify the contents.
    def curve_ids
      return @curve_ids
    end
    
    typesig { [] }
    def length
      return 6 + (@curve_ids.attr_length << 1)
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      s.put_int16(self.attr_type.attr_id)
      k = @curve_ids.attr_length << 1
      s.put_int16(k + 2)
      s.put_int16(k)
      @curve_ids.each do |curveId|
        s.put_int16(curve_id)
      end
    end
    
    typesig { [] }
    def to_s
      sb = StringBuilder.new
      sb.append("Extension " + RJava.cast_to_string(self.attr_type) + ", curve names: {")
      first = true
      @curve_ids.each do |curveId|
        if (first)
          first = false
        else
          sb.append(", ")
        end
        # first check if it is a known named curve, then try other cases.
        oid = get_curve_oid(curve_id)
        if (!(oid).nil?)
          spec = JsseJce.get_ecparameter_spec(oid)
          # this toString() output will look nice for the current
          # implementation of the ECParameterSpec class in the Sun
          # provider, but may not look good for other implementations.
          if (!(spec).nil?)
            sb.append(spec.to_s.split(Regexp.new(" "))[0])
          else
            sb.append(oid)
          end
        else
          if ((curve_id).equal?(ARBITRARY_PRIME))
            sb.append("arbitrary_explicit_prime_curves")
          else
            if ((curve_id).equal?(ARBITRARY_CHAR2))
              sb.append("arbitrary_explicit_char2_curves")
            else
              sb.append("unknown curve " + RJava.cast_to_string(curve_id))
            end
          end
        end
      end
      sb.append("}")
      return sb.to_s
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Test whether we support the curve with the given index.
      def is_supported(index)
        if ((index <= 0) || (index >= NAMED_CURVE_OID_TABLE.attr_length))
          return false
        end
        if ((Fips).equal?(false))
          # in non-FIPS mode, we support all valid indices
          return true
        end
        return DEFAULT.contains(index)
      end
      
      typesig { [ECParameterSpec] }
      def get_curve_index(params)
        oid = JsseJce.get_named_curve_oid(params)
        if ((oid).nil?)
          return -1
        end
        n = CurveIndices.get(oid)
        return ((n).nil?) ? -1 : n
      end
      
      typesig { [::Java::Int] }
      def get_curve_oid(index)
        if ((index > 0) && (index < NAMED_CURVE_OID_TABLE.attr_length))
          return NAMED_CURVE_OID_TABLE[index]
        end
        return nil
      end
      
      const_set_lazy(:ARBITRARY_PRIME) { 0xff01 }
      const_attr_reader  :ARBITRARY_PRIME
      
      const_set_lazy(:ARBITRARY_CHAR2) { 0xff02 }
      const_attr_reader  :ARBITRARY_CHAR2
      
      # See sun.security.ec.NamedCurve for the OIDs
      # (0) unused
      # (1) sect163k1, NIST K-163
      # (2) sect163r1
      # (3) sect163r2, NIST B-163
      # (4) sect193r1
      # (5) sect193r2
      # (6) sect233k1, NIST K-233
      # (7) sect233r1, NIST B-233
      # (8) sect239k1
      # (9) sect283k1, NIST K-283
      # (10) sect283r1, NIST B-283
      # (11) sect409k1, NIST K-409
      # (12) sect409r1, NIST B-409
      # (13) sect571k1, NIST K-571
      # (14) sect571r1, NIST B-571
      # (15) secp160k1
      # (16) secp160r1
      # (17) secp160r2
      # (18) secp192k1
      # (19) secp192r1, NIST P-192
      # (20) secp224k1
      # (21) secp224r1, NIST P-224
      # (22) secp256k1
      # (23) secp256r1, NIST P-256
      # (24) secp384r1, NIST P-384
      # (25) secp521r1, NIST P-521
      const_set_lazy(:NAMED_CURVE_OID_TABLE) { Array.typed(String).new([nil, "1.3.132.0.1", "1.3.132.0.2", "1.3.132.0.15", "1.3.132.0.24", "1.3.132.0.25", "1.3.132.0.26", "1.3.132.0.27", "1.3.132.0.3", "1.3.132.0.16", "1.3.132.0.17", "1.3.132.0.36", "1.3.132.0.37", "1.3.132.0.38", "1.3.132.0.39", "1.3.132.0.9", "1.3.132.0.8", "1.3.132.0.30", "1.3.132.0.31", "1.2.840.10045.3.1.1", "1.3.132.0.32", "1.3.132.0.33", "1.3.132.0.10", "1.2.840.10045.3.1.7", "1.3.132.0.34", "1.3.132.0.35", ]) }
      const_attr_reader  :NAMED_CURVE_OID_TABLE
      
      when_class_loaded do
        const_set :CurveIndices, HashMap.new
        i = 1
        while i < NAMED_CURVE_OID_TABLE.attr_length
          CurveIndices.put(NAMED_CURVE_OID_TABLE[i], i)
          i += 1
        end
      end
    }
    
    private
    alias_method :initialize__supported_elliptic_curves_extension, :initialize
  end
  
  class SupportedEllipticPointFormatsExtension < HelloExtensionsImports.const_get :HelloExtension
    include_class_members HelloExtensionsImports
    
    class_module.module_eval {
      const_set_lazy(:FMT_UNCOMPRESSED) { 0 }
      const_attr_reader  :FMT_UNCOMPRESSED
      
      const_set_lazy(:FMT_ANSIX962_COMPRESSED_PRIME) { 1 }
      const_attr_reader  :FMT_ANSIX962_COMPRESSED_PRIME
      
      const_set_lazy(:FMT_ANSIX962_COMPRESSED_CHAR2) { 2 }
      const_attr_reader  :FMT_ANSIX962_COMPRESSED_CHAR2
      
      const_set_lazy(:DEFAULT) { SupportedEllipticPointFormatsExtension.new(Array.typed(::Java::Byte).new([FMT_UNCOMPRESSED])) }
      const_attr_reader  :DEFAULT
    }
    
    attr_accessor :formats
    alias_method :attr_formats, :formats
    undef_method :formats
    alias_method :attr_formats=, :formats=
    undef_method :formats=
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(formats)
      @formats = nil
      super(ExtensionType::EXT_EC_POINT_FORMATS)
      @formats = formats
    end
    
    typesig { [HandshakeInStream, ::Java::Int] }
    def initialize(s, len)
      @formats = nil
      super(ExtensionType::EXT_EC_POINT_FORMATS)
      @formats = s.get_bytes8
      # RFC 4492 says uncompressed points must always be supported.
      # Check just to make sure.
      uncompressed = false
      @formats.each do |format|
        if ((format).equal?(FMT_UNCOMPRESSED))
          uncompressed = true
          break
        end
      end
      if ((uncompressed).equal?(false))
        raise SSLProtocolException.new("Peer does not support uncompressed points")
      end
    end
    
    typesig { [] }
    def length
      return 5 + @formats.attr_length
    end
    
    typesig { [HandshakeOutStream] }
    def send(s)
      s.put_int16(self.attr_type.attr_id)
      s.put_int16(@formats.attr_length + 1)
      s.put_bytes8(@formats)
    end
    
    class_module.module_eval {
      typesig { [::Java::Byte] }
      def to_s(format)
        f = format & 0xff
        case (f)
        when FMT_UNCOMPRESSED
          return "uncompressed"
        when FMT_ANSIX962_COMPRESSED_PRIME
          return "ansiX962_compressed_prime"
        when FMT_ANSIX962_COMPRESSED_CHAR2
          return "ansiX962_compressed_char2"
        else
          return "unknown-" + RJava.cast_to_string(f)
        end
      end
    }
    
    typesig { [] }
    def to_s
      list = ArrayList.new
      @formats.each do |format|
        list.add(to_s(format))
      end
      return "Extension " + RJava.cast_to_string(self.attr_type) + ", formats: " + RJava.cast_to_string(list)
    end
    
    private
    alias_method :initialize__supported_elliptic_point_formats_extension, :initialize
  end
  
end
