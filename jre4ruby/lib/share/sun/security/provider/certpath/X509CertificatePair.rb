require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider::Certpath
  module X509CertificatePairImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security::Cert, :CertificateEncodingException
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Interfaces, :DSAPublicKey
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :DerValue
      include_const ::Sun::Security::Util, :Cache
      include_const ::Sun::Security::X509, :X509CertImpl
      include_const ::Sun::Security::Provider, :X509Factory
    }
  end
  
  # This class represents an X.509 Certificate Pair object, which is primarily
  # used to hold a pair of cross certificates issued between Certification
  # Authorities. The ASN.1 structure is listed below. The forward certificate
  # of the CertificatePair contains a certificate issued to this CA by another
  # CA. The reverse certificate of the CertificatePair contains a certificate
  # issued by this CA to another CA. When both the forward and the reverse
  # certificates are present in the CertificatePair, the issuer name in one
  # certificate shall match the subject name in the other and vice versa, and
  # the subject public key in one certificate shall be capable of verifying the
  # digital signature on the other certificate and vice versa.  If a subject
  # public key in one certificate does not contain required key algorithm
  # parameters, then the signature check involving that key is not done.<p>
  # 
  # The ASN.1 syntax for this object is:
  # <pre>
  # CertificatePair      ::=     SEQUENCE {
  # forward [0]     Certificate OPTIONAL,
  # reverse [1]     Certificate OPTIONAL
  # -- at least one of the pair shall be present -- }
  # </pre><p>
  # 
  # This structure uses EXPLICIT tagging. References: Annex A of
  # X.509(2000), X.509(1997).
  # 
  # @author      Sean Mullan
  # @since       1.4
  class X509CertificatePair 
    include_class_members X509CertificatePairImports
    
    class_module.module_eval {
      # ASN.1 explicit tags
      const_set_lazy(:TAG_FORWARD) { 0 }
      const_attr_reader  :TAG_FORWARD
      
      const_set_lazy(:TAG_REVERSE) { 1 }
      const_attr_reader  :TAG_REVERSE
    }
    
    attr_accessor :forward
    alias_method :attr_forward, :forward
    undef_method :forward
    alias_method :attr_forward=, :forward=
    undef_method :forward=
    
    attr_accessor :reverse
    alias_method :attr_reverse, :reverse
    undef_method :reverse
    alias_method :attr_reverse=, :reverse=
    undef_method :reverse=
    
    attr_accessor :encoded
    alias_method :attr_encoded, :encoded
    undef_method :encoded
    alias_method :attr_encoded=, :encoded=
    undef_method :encoded=
    
    class_module.module_eval {
      const_set_lazy(:Cache) { Cache.new_soft_memory_cache(750) }
      const_attr_reader  :Cache
    }
    
    typesig { [] }
    # Creates an empty instance of X509CertificatePair.
    def initialize
      @forward = nil
      @reverse = nil
      @encoded = nil
    end
    
    typesig { [X509Certificate, X509Certificate] }
    # Creates an instance of X509CertificatePair. At least one of
    # the pair must be non-null.
    # 
    # @param forward The forward component of the certificate pair
    # which represents a certificate issued to this CA by other CAs.
    # @param reverse The reverse component of the certificate pair
    # which represents a certificate issued by this CA to other CAs.
    # @throws CertificateException If an exception occurs.
    def initialize(forward, reverse)
      @forward = nil
      @reverse = nil
      @encoded = nil
      if ((forward).nil? && (reverse).nil?)
        raise CertificateException.new("at least one of certificate pair " + "must be non-null")
      end
      @forward = forward
      @reverse = reverse
      check_pair
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Create a new X509CertificatePair from its encoding.
    # 
    # For internal use only, external code should use generateCertificatePair.
    def initialize(encoded)
      @forward = nil
      @reverse = nil
      @encoded = nil
      begin
        parse(DerValue.new(encoded))
        @encoded = encoded
      rescue IOException => ex
        raise CertificateException.new(ex.to_s)
      end
      check_pair
    end
    
    class_module.module_eval {
      typesig { [] }
      # Clear the cache for debugging.
      def clear_cache
        synchronized(self) do
          Cache.clear
        end
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Create a X509CertificatePair from its encoding. Uses cache lookup
      # if possible.
      def generate_certificate_pair(encoded)
        synchronized(self) do
          key = Cache::EqualByteArray.new(encoded)
          pair = Cache.get(key)
          if (!(pair).nil?)
            return pair
          end
          pair = X509CertificatePair.new(encoded)
          key = Cache::EqualByteArray.new(pair.attr_encoded)
          Cache.put(key, pair)
          return pair
        end
      end
    }
    
    typesig { [X509Certificate] }
    # Sets the forward component of the certificate pair.
    def set_forward(cert)
      check_pair
      @forward = cert
    end
    
    typesig { [X509Certificate] }
    # Sets the reverse component of the certificate pair.
    def set_reverse(cert)
      check_pair
      @reverse = cert
    end
    
    typesig { [] }
    # Returns the forward component of the certificate pair.
    # 
    # @return The forward certificate, or null if not set.
    def get_forward
      return @forward
    end
    
    typesig { [] }
    # Returns the reverse component of the certificate pair.
    # 
    # @return The reverse certificate, or null if not set.
    def get_reverse
      return @reverse
    end
    
    typesig { [] }
    # Return the DER encoded form of the certificate pair.
    # 
    # @return The encoded form of the certificate pair.
    # @throws CerticateEncodingException If an encoding exception occurs.
    def get_encoded
      begin
        if ((@encoded).nil?)
          tmp = DerOutputStream.new
          emit(tmp)
          @encoded = tmp.to_byte_array
        end
      rescue IOException => ex
        raise CertificateEncodingException.new(ex.to_s)
      end
      return @encoded
    end
    
    typesig { [] }
    # Return a printable representation of the certificate pair.
    # 
    # @return A String describing the contents of the pair.
    def to_s
      sb = StringBuffer.new
      sb.append("X.509 Certificate Pair: [\n")
      if (!(@forward).nil?)
        sb.append("  Forward: " + RJava.cast_to_string(@forward) + "\n")
      end
      if (!(@reverse).nil?)
        sb.append("  Reverse: " + RJava.cast_to_string(@reverse) + "\n")
      end
      sb.append("]")
      return sb.to_s
    end
    
    typesig { [DerValue] }
    # Parse the encoded bytes
    def parse(val)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Sequence tag missing for X509CertificatePair")
      end
      while (!(val.attr_data).nil? && !(val.attr_data.available).equal?(0))
        opt = val.attr_data.get_der_value
        tag = (opt.attr_tag & 0x1f)
        case (tag)
        when TAG_FORWARD
          if (opt.is_context_specific && opt.is_constructed)
            if (!(@forward).nil?)
              raise IOException.new("Duplicate forward " + "certificate in X509CertificatePair")
            end
            opt = opt.attr_data.get_der_value
            @forward = X509Factory.intern(X509CertImpl.new(opt.to_byte_array))
          end
        when TAG_REVERSE
          if (opt.is_context_specific && opt.is_constructed)
            if (!(@reverse).nil?)
              raise IOException.new("Duplicate reverse " + "certificate in X509CertificatePair")
            end
            opt = opt.attr_data.get_der_value
            @reverse = X509Factory.intern(X509CertImpl.new(opt.to_byte_array))
          end
        else
          raise IOException.new("Invalid encoding of " + "X509CertificatePair")
        end
      end
      if ((@forward).nil? && (@reverse).nil?)
        raise CertificateException.new("at least one of certificate pair " + "must be non-null")
      end
    end
    
    typesig { [DerOutputStream] }
    # Translate to encoded bytes
    def emit(out)
      tagged = DerOutputStream.new
      if (!(@forward).nil?)
        tmp = DerOutputStream.new
        tmp.put_der_value(DerValue.new(@forward.get_encoded))
        tagged.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_FORWARD), tmp)
      end
      if (!(@reverse).nil?)
        tmp = DerOutputStream.new
        tmp.put_der_value(DerValue.new(@reverse.get_encoded))
        tagged.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_REVERSE), tmp)
      end
      out.write(DerValue.attr_tag_sequence, tagged)
    end
    
    typesig { [] }
    # Check for a valid certificate pair
    def check_pair
      # if either of pair is missing, return w/o error
      if ((@forward).nil? || (@reverse).nil?)
        return
      end
      # If both elements of the pair are present, check that they
      # are a valid pair.
      fw_subject = @forward.get_subject_x500principal
      fw_issuer = @forward.get_issuer_x500principal
      rv_subject = @reverse.get_subject_x500principal
      rv_issuer = @reverse.get_issuer_x500principal
      if (!(fw_issuer == rv_subject) || !(rv_issuer == fw_subject))
        raise CertificateException.new("subject and issuer names in " + "forward and reverse certificates do not match")
      end
      # check signatures unless key parameters are missing
      begin
        pk = @reverse.get_public_key
        if (!(pk.is_a?(DSAPublicKey)) || !((pk).get_params).nil?)
          @forward.verify(pk)
        end
        pk = @forward.get_public_key
        if (!(pk.is_a?(DSAPublicKey)) || !((pk).get_params).nil?)
          @reverse.verify(pk)
        end
      rescue GeneralSecurityException => e
        raise CertificateException.new("invalid signature: " + RJava.cast_to_string(e.get_message))
      end
    end
    
    private
    alias_method :initialize__x509certificate_pair, :initialize
  end
  
end
