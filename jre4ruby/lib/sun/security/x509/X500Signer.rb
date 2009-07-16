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
  module X500SignerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Security, :Signature
      include_const ::Java::Security, :SignatureException
      include_const ::Java::Security, :Signer
      include_const ::Java::Security, :NoSuchAlgorithmException
    }
  end
  
  # 
  # This class provides a binding between a Signature object and an
  # authenticated X.500 name (from an X.509 certificate chain), which
  # is needed in many public key signing applications.
  # 
  # <P>The name of the signer is important, both because knowing it is the
  # whole point of the signature, and because the associated X.509 certificate
  # is always used to verify the signature.
  # 
  # <P><em>The X.509 certificate chain is temporarily not associated with
  # the signer, but this omission will be resolved.</em>
  # 
  # 
  # @author David Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class X500Signer < X500SignerImports.const_get :Signer
    include_class_members X500SignerImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -8609982645394364834 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Called for each chunk of the data being signed.  That
    # is, you can present the data in many chunks, so that
    # it doesn't need to be in a single sequential buffer.
    # 
    # @param buf buffer holding the next chunk of the data to be signed
    # @param offset starting point of to-be-signed data
    # @param len how many bytes of data are to be signed
    # @exception SignatureException on errors.
    def update(buf, offset, len)
      @sig.update(buf, offset, len)
    end
    
    typesig { [] }
    # 
    # Produces the signature for the data processed by update().
    # 
    # @exception SignatureException on errors.
    def sign
      return @sig.sign
    end
    
    typesig { [] }
    # 
    # Returns the algorithm used to sign.
    def get_algorithm_id
      return @algid
    end
    
    typesig { [] }
    # 
    # Returns the name of the signing agent.
    def get_signer
      return @agent
    end
    
    typesig { [Signature, X500Name] }
    # 
    # Constructs a binding between a signature and an X500 name
    # from an X.509 certificate.
    # 
    # package private  ----hmmmmm ?????
    def initialize(sig, agent)
      @sig = nil
      @agent = nil
      @algid = nil
      super()
      if ((sig).nil? || (agent).nil?)
        raise IllegalArgumentException.new("null parameter")
      end
      @sig = sig
      @agent = agent
      begin
        @algid = AlgorithmId.get_algorithm_id(sig.get_algorithm)
      rescue NoSuchAlgorithmException => e
        raise RuntimeException.new("internal error! " + (e.get_message).to_s)
      end
    end
    
    attr_accessor :sig
    alias_method :attr_sig, :sig
    undef_method :sig
    alias_method :attr_sig=, :sig=
    undef_method :sig=
    
    attr_accessor :agent
    alias_method :attr_agent, :agent
    undef_method :agent
    alias_method :attr_agent=, :agent=
    undef_method :agent=
    
    # XXX should be X509CertChain
    attr_accessor :algid
    alias_method :attr_algid, :algid
    undef_method :algid
    alias_method :attr_algid=, :algid=
    undef_method :algid=
    
    private
    alias_method :initialize__x500signer, :initialize
  end
  
end
