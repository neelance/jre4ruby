require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IndexedCollectionCertStoreImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include ::Java::Util
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include ::Java::Security::Cert
      include_const ::Javax::Security::Auth::X500, :X500Principal
    }
  end
  
  # A <code>CertStore</code> that retrieves <code>Certificates</code> and
  # <code>CRL</code>s from a <code>Collection</code>.
  # <p>
  # This implementation is functionally equivalent to CollectionCertStore
  # with two differences:
  # <ol>
  # <li>Upon construction, the elements in the specified Collection are
  # partially indexed. X509Certificates are indexed by subject, X509CRLs
  # by issuer, non-X509 Certificates and CRLs are copied without indexing,
  # other objects are ignored. This increases CertStore construction time
  # but allows significant speedups for searches which specify the indexed
  # attributes, in particular for large Collections (reduction from linear
  # time to effectively constant time). Searches for non-indexed queries
  # are as fast (or marginally faster) than for the standard
  # CollectionCertStore. Certificate subjects and CRL issuers
  # were found to be specified in most searches used internally by the
  # CertPath provider. Additional attributes could indexed if there are
  # queries that justify the effort.
  # 
  # <li>Changes to the specified Collection after construction time are
  # not detected and ignored. This is because there is no way to efficiently
  # detect if a Collection has been modified, a full traversal would be
  # required. That would degrade lookup performance to linear time and
  # eliminated the benefit of indexing. We may fix this via the introduction
  # of new public APIs in the future.
  # </ol>
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
  # @see CollectionCertStore
  # 
  # @author Andreas Sterbenz
  class IndexedCollectionCertStore < IndexedCollectionCertStoreImports.const_get :CertStoreSpi
    include_class_members IndexedCollectionCertStoreImports
    
    # Map X500Principal(subject) -> X509Certificate | List of X509Certificate
    attr_accessor :cert_subjects
    alias_method :attr_cert_subjects, :cert_subjects
    undef_method :cert_subjects
    alias_method :attr_cert_subjects=, :cert_subjects=
    undef_method :cert_subjects=
    
    # Map X500Principal(issuer) -> X509CRL | List of X509CRL
    attr_accessor :crl_issuers
    alias_method :attr_crl_issuers, :crl_issuers
    undef_method :crl_issuers
    alias_method :attr_crl_issuers=, :crl_issuers=
    undef_method :crl_issuers=
    
    # Sets of non-X509 certificates and CRLs
    attr_accessor :other_certificates
    alias_method :attr_other_certificates, :other_certificates
    undef_method :other_certificates
    alias_method :attr_other_certificates=, :other_certificates=
    undef_method :other_certificates=
    
    attr_accessor :other_crls
    alias_method :attr_other_crls, :other_crls
    undef_method :other_crls
    alias_method :attr_other_crls=, :other_crls=
    undef_method :other_crls=
    
    typesig { [CertStoreParameters] }
    # Creates a <code>CertStore</code> with the specified parameters.
    # For this class, the parameters object must be an instance of
    # <code>CollectionCertStoreParameters</code>.
    # 
    # @param params the algorithm parameters
    # @exception InvalidAlgorithmParameterException if params is not an
    #   instance of <code>CollectionCertStoreParameters</code>
    def initialize(params)
      @cert_subjects = nil
      @crl_issuers = nil
      @other_certificates = nil
      @other_crls = nil
      super(params)
      if (!(params.is_a?(CollectionCertStoreParameters)))
        raise InvalidAlgorithmParameterException.new("parameters must be CollectionCertStoreParameters")
      end
      coll = (params).get_collection
      if ((coll).nil?)
        raise InvalidAlgorithmParameterException.new("Collection must not be null")
      end
      build_index(coll)
    end
    
    typesig { [Collection] }
    # Index the specified Collection copying all references to Certificates
    # and CRLs.
    def build_index(coll)
      @cert_subjects = HashMap.new
      @crl_issuers = HashMap.new
      @other_certificates = nil
      @other_crls = nil
      coll.each do |obj|
        if (obj.is_a?(X509Certificate))
          index_certificate(obj)
        else
          if (obj.is_a?(X509CRL))
            index_crl(obj)
          else
            if (obj.is_a?(Certificate))
              if ((@other_certificates).nil?)
                @other_certificates = HashSet.new
              end
              @other_certificates.add(obj)
            else
              if (obj.is_a?(CRL))
                if ((@other_crls).nil?)
                  @other_crls = HashSet.new
                end
                @other_crls.add(obj)
              else
                # ignore
              end
            end
          end
        end
      end
      if ((@other_certificates).nil?)
        @other_certificates = Collections.empty_set
      end
      if ((@other_crls).nil?)
        @other_crls = Collections.empty_set
      end
    end
    
    typesig { [X509Certificate] }
    # Add an X509Certificate to the index.
    def index_certificate(cert)
      subject = cert.get_subject_x500principal
      old_entry = @cert_subjects.put(subject, cert)
      if (!(old_entry).nil?)
        # assume this is unlikely
        if (old_entry.is_a?(X509Certificate))
          if ((cert == old_entry))
            return
          end
          list = ArrayList.new(2)
          list.add(cert)
          list.add(old_entry)
          @cert_subjects.put(subject, list)
        else
          list = old_entry
          if ((list.contains(cert)).equal?(false))
            list.add(cert)
          end
          @cert_subjects.put(subject, list)
        end
      end
    end
    
    typesig { [X509CRL] }
    # Add an X509CRL to the index.
    def index_crl(crl)
      issuer = crl.get_issuer_x500principal
      old_entry = @crl_issuers.put(issuer, crl)
      if (!(old_entry).nil?)
        # assume this is unlikely
        if (old_entry.is_a?(X509CRL))
          if ((crl == old_entry))
            return
          end
          list = ArrayList.new(2)
          list.add(crl)
          list.add(old_entry)
          @crl_issuers.put(issuer, list)
        else
          list = old_entry
          if ((list.contains(crl)).equal?(false))
            list.add(crl)
          end
          @crl_issuers.put(issuer, list)
        end
      end
    end
    
    typesig { [CertSelector] }
    # Returns a <code>Collection</code> of <code>Certificate</code>s that
    # match the specified selector. If no <code>Certificate</code>s
    # match the selector, an empty <code>Collection</code> will be returned.
    # 
    # @param selector a <code>CertSelector</code> used to select which
    #  <code>Certificate</code>s should be returned. Specify <code>null</code>
    #  to return all <code>Certificate</code>s.
    # @return a <code>Collection</code> of <code>Certificate</code>s that
    #         match the specified selector
    # @throws CertStoreException if an exception occurs
    def engine_get_certificates(selector)
      # no selector means match all
      if ((selector).nil?)
        matches = HashSet.new
        match_x509certs(X509CertSelector.new, matches)
        matches.add_all(@other_certificates)
        return matches
      end
      if ((selector.is_a?(X509CertSelector)).equal?(false))
        matches = HashSet.new
        match_x509certs(selector, matches)
        @other_certificates.each do |cert|
          if (selector.match(cert))
            matches.add(cert)
          end
        end
        return matches
      end
      if (@cert_subjects.is_empty)
        return Collections.empty_set
      end
      x509selector = selector
      # see if the subject is specified
      subject = nil
      match_cert = x509selector.get_certificate
      if (!(match_cert).nil?)
        subject = match_cert.get_subject_x500principal
      else
        subject = x509selector.get_subject
      end
      if (!(subject).nil?)
        # yes, narrow down candidates to indexed possibilities
        entry = @cert_subjects.get(subject)
        if ((entry).nil?)
          return Collections.empty_set
        end
        if (entry.is_a?(X509Certificate))
          x509entry = entry
          if (x509selector.match(x509entry))
            return Collections.singleton(x509entry)
          else
            return Collections.empty_set
          end
        else
          list = entry
          matches = HashSet.new(16)
          list.each do |cert|
            if (x509selector.match(cert))
              matches.add(cert)
            end
          end
          return matches
        end
      end
      # cannot use index, iterate all
      matches = HashSet.new(16)
      match_x509certs(x509selector, matches)
      return matches
    end
    
    typesig { [CertSelector, Collection] }
    # Iterate through all the X509Certificates and add matches to the
    # collection.
    def match_x509certs(selector, matches)
      @cert_subjects.values.each do |obj|
        if (obj.is_a?(X509Certificate))
          cert = obj
          if (selector.match(cert))
            matches.add(cert)
          end
        else
          list = obj
          list.each do |cert|
            if (selector.match(cert))
              matches.add(cert)
            end
          end
        end
      end
    end
    
    typesig { [CRLSelector] }
    # Returns a <code>Collection</code> of <code>CRL</code>s that
    # match the specified selector. If no <code>CRL</code>s
    # match the selector, an empty <code>Collection</code> will be returned.
    # 
    # @param selector a <code>CRLSelector</code> used to select which
    #  <code>CRL</code>s should be returned. Specify <code>null</code>
    #  to return all <code>CRL</code>s.
    # @return a <code>Collection</code> of <code>CRL</code>s that
    #         match the specified selector
    # @throws CertStoreException if an exception occurs
    def engine_get_crls(selector)
      if ((selector).nil?)
        matches = HashSet.new
        match_x509crls(X509CRLSelector.new, matches)
        matches.add_all(@other_crls)
        return matches
      end
      if ((selector.is_a?(X509CRLSelector)).equal?(false))
        matches = HashSet.new
        match_x509crls(selector, matches)
        @other_crls.each do |crl|
          if (selector.match(crl))
            matches.add(crl)
          end
        end
        return matches
      end
      if (@crl_issuers.is_empty)
        return Collections.empty_set
      end
      x509selector = selector
      # see if the issuer is specified
      issuers = x509selector.get_issuers
      if (!(issuers).nil?)
        matches = HashSet.new(16)
        issuers.each do |issuer|
          entry = @crl_issuers.get(issuer)
          if ((entry).nil?)
            # empty
          else
            if (entry.is_a?(X509CRL))
              crl = entry
              if (x509selector.match(crl))
                matches.add(crl)
              end
            else
              # List
              list = entry
              list.each do |crl|
                if (x509selector.match(crl))
                  matches.add(crl)
                end
              end
            end
          end
        end
        return matches
      end
      # cannot use index, iterate all
      matches = HashSet.new(16)
      match_x509crls(x509selector, matches)
      return matches
    end
    
    typesig { [CRLSelector, Collection] }
    # Iterate through all the X509CRLs and add matches to the
    # collection.
    def match_x509crls(selector, matches)
      @crl_issuers.values.each do |obj|
        if (obj.is_a?(X509CRL))
          crl = obj
          if (selector.match(crl))
            matches.add(crl)
          end
        else
          list = obj
          list.each do |crl|
            if (selector.match(crl))
              matches.add(crl)
            end
          end
        end
      end
    end
    
    private
    alias_method :initialize__indexed_collection_cert_store, :initialize
  end
  
end
