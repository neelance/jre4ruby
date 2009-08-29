require "rjava"

# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs12
  module MacDataImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs12
      include ::Java::Io
      include ::Java::Security
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::X509, :AlgorithmId
      include_const ::Sun::Security::Pkcs, :ParsingException
    }
  end
  
  # A MacData type, as defined in PKCS#12.
  # 
  # @author Sharon Liu
  class MacData 
    include_class_members MacDataImports
    
    attr_accessor :digest_algorithm_name
    alias_method :attr_digest_algorithm_name, :digest_algorithm_name
    undef_method :digest_algorithm_name
    alias_method :attr_digest_algorithm_name=, :digest_algorithm_name=
    undef_method :digest_algorithm_name=
    
    attr_accessor :digest_algorithm_params
    alias_method :attr_digest_algorithm_params, :digest_algorithm_params
    undef_method :digest_algorithm_params
    alias_method :attr_digest_algorithm_params=, :digest_algorithm_params=
    undef_method :digest_algorithm_params=
    
    attr_accessor :digest
    alias_method :attr_digest, :digest
    undef_method :digest
    alias_method :attr_digest=, :digest=
    undef_method :digest=
    
    attr_accessor :mac_salt
    alias_method :attr_mac_salt, :mac_salt
    undef_method :mac_salt
    alias_method :attr_mac_salt=, :mac_salt=
    undef_method :mac_salt=
    
    attr_accessor :iterations
    alias_method :attr_iterations, :iterations
    undef_method :iterations
    alias_method :attr_iterations=, :iterations=
    undef_method :iterations=
    
    # the ASN.1 encoded contents of this class
    attr_accessor :encoded
    alias_method :attr_encoded, :encoded
    undef_method :encoded
    alias_method :attr_encoded=, :encoded=
    undef_method :encoded=
    
    typesig { [DerInputStream] }
    # Parses a PKCS#12 MAC data.
    def initialize(derin)
      @digest_algorithm_name = nil
      @digest_algorithm_params = nil
      @digest = nil
      @mac_salt = nil
      @iterations = 0
      @encoded = nil
      mac_data = derin.get_sequence(2)
      # Parse the digest info
      digest_in = DerInputStream.new(mac_data[0].to_byte_array)
      digest_info = digest_in.get_sequence(2)
      # Parse the DigestAlgorithmIdentifier.
      digest_algorithm_id = AlgorithmId.parse(digest_info[0])
      @digest_algorithm_name = digest_algorithm_id.get_name
      @digest_algorithm_params = digest_algorithm_id.get_parameters
      # Get the digest.
      @digest = digest_info[1].get_octet_string
      # Get the salt.
      @mac_salt = mac_data[1].get_octet_string
      # Iterations is optional. The default value is 1.
      if (mac_data.attr_length > 2)
        @iterations = mac_data[2].get_integer
      else
        @iterations = 1
      end
    end
    
    typesig { [String, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def initialize(alg_name, digest, salt, iterations)
      @digest_algorithm_name = nil
      @digest_algorithm_params = nil
      @digest = nil
      @mac_salt = nil
      @iterations = 0
      @encoded = nil
      if ((alg_name).nil?)
        raise NullPointerException.new("the algName parameter " + "must be non-null")
      end
      algid = AlgorithmId.get(alg_name)
      @digest_algorithm_name = algid.get_name
      @digest_algorithm_params = algid.get_parameters
      if ((digest).nil?)
        raise NullPointerException.new("the digest " + "parameter must be non-null")
      else
        if ((digest.attr_length).equal?(0))
          raise IllegalArgumentException.new("the digest " + "parameter must not be empty")
        else
          @digest = digest.clone
        end
      end
      @mac_salt = salt
      @iterations = iterations
      # delay the generation of ASN.1 encoding until
      # getEncoded() is called
      @encoded = nil
    end
    
    typesig { [AlgorithmParameters, Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def initialize(alg_params, digest, salt, iterations)
      @digest_algorithm_name = nil
      @digest_algorithm_params = nil
      @digest = nil
      @mac_salt = nil
      @iterations = 0
      @encoded = nil
      if ((alg_params).nil?)
        raise NullPointerException.new("the algParams parameter " + "must be non-null")
      end
      algid = AlgorithmId.get(alg_params)
      @digest_algorithm_name = algid.get_name
      @digest_algorithm_params = algid.get_parameters
      if ((digest).nil?)
        raise NullPointerException.new("the digest " + "parameter must be non-null")
      else
        if ((digest.attr_length).equal?(0))
          raise IllegalArgumentException.new("the digest " + "parameter must not be empty")
        else
          @digest = digest.clone
        end
      end
      @mac_salt = salt
      @iterations = iterations
      # delay the generation of ASN.1 encoding until
      # getEncoded() is called
      @encoded = nil
    end
    
    typesig { [] }
    def get_digest_alg_name
      return @digest_algorithm_name
    end
    
    typesig { [] }
    def get_salt
      return @mac_salt
    end
    
    typesig { [] }
    def get_iterations
      return @iterations
    end
    
    typesig { [] }
    def get_digest
      return @digest
    end
    
    typesig { [] }
    # Returns the ASN.1 encoding of this object.
    # @return the ASN.1 encoding.
    # @exception IOException if error occurs when constructing its
    # ASN.1 encoding.
    def get_encoded
      if (!(@encoded).nil?)
        return @encoded.clone
      end
      out = DerOutputStream.new
      tmp = DerOutputStream.new
      tmp2 = DerOutputStream.new
      # encode encryption algorithm
      algid = AlgorithmId.get(@digest_algorithm_name)
      algid.encode(tmp2)
      # encode digest data
      tmp2.put_octet_string(@digest)
      tmp.write(DerValue.attr_tag_sequence, tmp2)
      # encode salt
      tmp.put_octet_string(@mac_salt)
      # encode iterations
      tmp.put_integer(@iterations)
      # wrap everything into a SEQUENCE
      out.write(DerValue.attr_tag_sequence, tmp)
      @encoded = out.to_byte_array
      return @encoded.clone
    end
    
    private
    alias_method :initialize__mac_data, :initialize
  end
  
end
