require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CollectionCertStoreImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CRL
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :ConcurrentModificationException
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Security::Cert, :CertSelector
      include_const ::Java::Security::Cert, :CertStore
      include_const ::Java::Security::Cert, :CertStoreException
      include_const ::Java::Security::Cert, :CertStoreParameters
      include_const ::Java::Security::Cert, :CollectionCertStoreParameters
      include_const ::Java::Security::Cert, :CRLSelector
      include_const ::Java::Security::Cert, :CertStoreSpi
    }
  end
  
  # A <code>CertStore</code> that retrieves <code>Certificates</code> and
  # <code>CRL</code>s from a <code>Collection</code>.
  # <p>
  # Before calling the {@link #engineGetCertificates engineGetCertificates} or
  # {@link #engineGetCRLs engineGetCRLs} methods, the
  # {@link #CollectionCertStore(CertStoreParameters)
  # CollectionCertStore(CertStoreParameters)} constructor is called to
  # create the <code>CertStore</code> and establish the
  # <code>Collection</code> from which <code>Certificate</code>s and
  # <code>CRL</code>s will be retrieved. If the specified
  # <code>Collection</code> contains an object that is not a
  # <code>Certificate</code> or <code>CRL</code>, that object will be
  # ignored.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # As described in the javadoc for <code>CertStoreSpi</code>, the
  # <code>engineGetCertificates</code> and <code>engineGetCRLs</code> methods
  # must be thread-safe. That is, multiple threads may concurrently
  # invoke these methods on a single <code>CollectionCertStore</code>
  # object (or more than one) with no ill effects.
  # <p>
  # This is achieved by requiring that the <code>Collection</code> passed to
  # the {@link #CollectionCertStore(CertStoreParameters)
  # CollectionCertStore(CertStoreParameters)} constructor (via the
  # <code>CollectionCertStoreParameters</code> object) must have fail-fast
  # iterators. Simultaneous modifications to the <code>Collection</code> can thus be
  # detected and certificate or CRL retrieval can be retried. The fact that
  # <code>Certificate</code>s and <code>CRL</code>s must be thread-safe is also
  # essential.
  # 
  # @see java.security.cert.CertStore
  # 
  # @since       1.4
  # @author      Steve Hanna
  class CollectionCertStore < CollectionCertStoreImports.const_get :CertStoreSpi
    include_class_members CollectionCertStoreImports
    
    attr_accessor :coll
    alias_method :attr_coll, :coll
    undef_method :coll
    alias_method :attr_coll=, :coll=
    undef_method :coll=
    
    typesig { [CertStoreParameters] }
    # Creates a <code>CertStore</code> with the specified parameters.
    # For this class, the parameters object must be an instance of
    # <code>CollectionCertStoreParameters</code>. The <code>Collection</code>
    # included in the <code>CollectionCertStoreParameters</code> object
    # must be thread-safe.
    # 
    # @param params the algorithm parameters
    # @exception InvalidAlgorithmParameterException if params is not an
    # instance of <code>CollectionCertStoreParameters</code>
    def initialize(params)
      @coll = nil
      super(params)
      if (!(params.is_a?(CollectionCertStoreParameters)))
        raise InvalidAlgorithmParameterException.new("parameters must be CollectionCertStoreParameters")
      end
      @coll = (params).get_collection
    end
    
    typesig { [CertSelector] }
    # Returns a <code>Collection</code> of <code>Certificate</code>s that
    # match the specified selector. If no <code>Certificate</code>s
    # match the selector, an empty <code>Collection</code> will be returned.
    # 
    # @param selector a <code>CertSelector</code> used to select which
    # <code>Certificate</code>s should be returned. Specify <code>null</code>
    # to return all <code>Certificate</code>s.
    # @return a <code>Collection</code> of <code>Certificate</code>s that
    # match the specified selector
    # @throws CertStoreException if an exception occurs
    def engine_get_certificates(selector)
      if ((@coll).nil?)
        raise CertStoreException.new("Collection is null")
      end
      # Tolerate a few ConcurrentModificationExceptions
      c = 0
      while c < 10
        begin
          result = HashSet.new
          i = @coll.iterator
          if (!(selector).nil?)
            while (i.has_next)
              o = i.next
              if ((o.is_a?(Certificate)) && selector.match(o))
                result.add(o)
              end
            end
          else
            while (i.has_next)
              o = i.next
              if (o.is_a?(Certificate))
                result.add(o)
              end
            end
          end
          return (result)
        rescue ConcurrentModificationException => e
        end
        ((c += 1) - 1)
      end
      raise ConcurrentModificationException.new("Too many " + "ConcurrentModificationExceptions")
    end
    
    typesig { [CRLSelector] }
    # Returns a <code>Collection</code> of <code>CRL</code>s that
    # match the specified selector. If no <code>CRL</code>s
    # match the selector, an empty <code>Collection</code> will be returned.
    # 
    # @param selector a <code>CRLSelector</code> used to select which
    # <code>CRL</code>s should be returned. Specify <code>null</code>
    # to return all <code>CRL</code>s.
    # @return a <code>Collection</code> of <code>CRL</code>s that
    # match the specified selector
    # @throws CertStoreException if an exception occurs
    def engine_get_crls(selector)
      if ((@coll).nil?)
        raise CertStoreException.new("Collection is null")
      end
      # Tolerate a few ConcurrentModificationExceptions
      c = 0
      while c < 10
        begin
          result = HashSet.new
          i = @coll.iterator
          if (!(selector).nil?)
            while (i.has_next)
              o = i.next
              if ((o.is_a?(CRL)) && selector.match(o))
                result.add(o)
              end
            end
          else
            while (i.has_next)
              o = i.next
              if (o.is_a?(CRL))
                result.add(o)
              end
            end
          end
          return (result)
        rescue ConcurrentModificationException => e
        end
        ((c += 1) - 1)
      end
      raise ConcurrentModificationException.new("Too many " + "ConcurrentModificationExceptions")
    end
    
    private
    alias_method :initialize__collection_cert_store, :initialize
  end
  
end
