require "rjava"

# 
# Copyright 1996-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AlgIdDSAImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include_const ::Java::Security::Interfaces, :DSAParams
      include ::Sun::Security::Util
    }
  end
  
  # 
  # This class identifies DSS/DSA Algorithm variants, which are distinguished
  # by using different algorithm parameters <em>P, Q, G</em>.  It uses the
  # NIST/IETF standard DER encoding.  These are used to implement the Digital
  # Signature Standard (DSS), FIPS 186.
  # 
  # <P><em><b>NOTE:</b>  DSS/DSA Algorithm IDs may be created without these
  # parameters.  Use of DSS/DSA in modes where parameters are
  # either implicit (e.g. a default applicable to a site or a larger scope),
  # or are derived from some Certificate Authority's DSS certificate, is
  # not supported directly.  The application is responsible for creating a key
  # containing the required parameters prior to using the key in cryptographic
  # operations.  The follwoing is an example of how this may be done assuming
  # that we have a certificate called <code>currentCert</code> which doesn't
  # contain DSS/DSA parameters and we need to derive DSS/DSA parameters
  # from a CA's certificate called <code>caCert</code>.
  # <p>
  # <code><pre>
  # // key containing parameters to use
  # DSAPublicKey cAKey = (DSAPublicKey)(caCert.getPublicKey());
  # // key without parameters
  # DSAPublicKey nullParamsKey = (DSAPublicKey)(currentCert.getPublicKey());
  # 
  # DSAParams cAKeyParams = cAKey.getParams();
  # KeyFactory kf = KeyFactory.getInstance("DSA");
  # DSAPublicKeySpec ks = new DSAPublicKeySpec(nullParamsKey.getY(),
  # cAKeyParams.getP(),
  # cAKeyParams.getQ(),
  # cAKeyParams.getG());
  # DSAPublicKey usableKey = kf.generatePublic(ks);
  # </pre></code>
  # 
  # @see java.security.interfaces.DSAParams
  # @see java.security.interfaces.DSAPublicKey
  # @see java.security.KeyFactory
  # @see java.security.spec.DSAPublicKeySpec
  # 
  # @author David Brownell
  class AlgIdDSA < AlgIdDSAImports.const_get :AlgorithmId
    include_class_members AlgIdDSAImports
    include DSAParams
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 3437177836797504046 }
      const_attr_reader  :SerialVersionUID
    }
    
    # 
    # The three unsigned integer parameters.
    attr_accessor :p
    alias_method :attr_p, :p
    undef_method :p
    alias_method :attr_p=, :p=
    undef_method :p=
    
    attr_accessor :q
    alias_method :attr_q, :q
    undef_method :q
    alias_method :attr_q=, :q=
    undef_method :q=
    
    attr_accessor :g
    alias_method :attr_g, :g
    undef_method :g
    alias_method :attr_g=, :g=
    undef_method :g=
    
    typesig { [] }
    # Returns the DSS/DSA parameter "P"
    def get_p
      return @p
    end
    
    typesig { [] }
    # Returns the DSS/DSA parameter "Q"
    def get_q
      return @q
    end
    
    typesig { [] }
    # Returns the DSS/DSA parameter "G"
    def get_g
      return @g
    end
    
    typesig { [] }
    # 
    # Default constructor.  The OID and parameters must be
    # deserialized before this algorithm ID is used.
    # 
    # XXX deprecated for general use
    def initialize
      @p = nil
      @q = nil
      @g = nil
      super()
    end
    
    typesig { [DerValue] }
    def initialize(val)
      @p = nil
      @q = nil
      @g = nil
      super(val.get_oid)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Construct an AlgIdDSA from an X.509 encoded byte array.
    def initialize(encoded_alg)
      @p = nil
      @q = nil
      @g = nil
      super(DerValue.new(encoded_alg).get_oid)
    end
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    # 
    # Constructs a DSS/DSA Algorithm ID from unsigned integers that
    # define the algorithm parameters.  Those integers are encoded
    # as big-endian byte arrays.
    # 
    # @param p the DSS/DSA paramter "P"
    # @param q the DSS/DSA paramter "Q"
    # @param g the DSS/DSA paramter "G"
    def initialize(p, q, g)
      initialize__alg_id_dsa(BigInteger.new(1, p), BigInteger.new(1, q), BigInteger.new(1, g))
    end
    
    typesig { [BigInteger, BigInteger, BigInteger] }
    # 
    # Constructs a DSS/DSA Algorithm ID from numeric parameters.
    # If all three are null, then the parameters portion of the algorithm id
    # is set to null.  See note in header regarding use.
    # 
    # @param p the DSS/DSA paramter "P"
    # @param q the DSS/DSA paramter "Q"
    # @param g the DSS/DSA paramter "G"
    def initialize(p, q, g)
      @p = nil
      @q = nil
      @g = nil
      super(DSA_oid)
      if (!(p).nil? || !(q).nil? || !(g).nil?)
        if ((p).nil? || (q).nil? || (g).nil?)
          raise ProviderException.new("Invalid parameters for DSS/DSA" + " Algorithm ID")
        end
        begin
          @p = p
          @q = q
          @g = g
          initialize_params
        rescue IOException => e
          # this should not happen
          raise ProviderException.new("Construct DSS/DSA Algorithm ID")
        end
      end
    end
    
    typesig { [] }
    # 
    # Returns "DSA", indicating the Digital Signature Algorithm (DSA) as
    # defined by the Digital Signature Standard (DSS), FIPS 186.
    def get_name
      return "DSA"
    end
    
    typesig { [] }
    # 
    # For algorithm IDs which haven't been created from a DER encoded
    # value, "params" must be created.
    def initialize_params
      out = DerOutputStream.new
      out.put_integer(@p)
      out.put_integer(@q)
      out.put_integer(@g)
      self.attr_params = DerValue.new(DerValue.attr_tag_sequence, out.to_byte_array)
    end
    
    typesig { [] }
    # 
    # Parses algorithm parameters P, Q, and G.  They're found
    # in the "params" member, which never needs to be changed.
    def decode_params
      if ((self.attr_params).nil?)
        raise IOException.new("DSA alg params are null")
      end
      if (!(self.attr_params.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("DSA alg parsing error")
      end
      self.attr_params.attr_data.reset
      @p = self.attr_params.attr_data.get_big_integer
      @q = self.attr_params.attr_data.get_big_integer
      @g = self.attr_params.attr_data.get_big_integer
      if (!(self.attr_params.attr_data.available).equal?(0))
        raise IOException.new("AlgIdDSA params, extra=" + (self.attr_params.attr_data.available).to_s)
      end
    end
    
    typesig { [] }
    # 
    # Returns a formatted string describing the parameters.
    def to_s
      return params_to_string
    end
    
    typesig { [] }
    # 
    # Returns a string describing the parameters.
    def params_to_string
      if ((self.attr_params).nil?)
        return " null\n"
      else
        return "\n    p:\n" + (Debug.to_hex_string(@p)).to_s + "\n    q:\n" + (Debug.to_hex_string(@q)).to_s + "\n    g:\n" + (Debug.to_hex_string(@g)).to_s + "\n"
      end
    end
    
    private
    alias_method :initialize__alg_id_dsa, :initialize
  end
  
end
