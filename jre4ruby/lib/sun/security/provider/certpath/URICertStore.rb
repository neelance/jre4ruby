require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module URICertStoreImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :HttpURLConnection
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Security, :InvalidAlgorithmParameterException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :Provider
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Cert, :CertSelector
      include_const ::Java::Security::Cert, :CertStore
      include_const ::Java::Security::Cert, :CertStoreException
      include_const ::Java::Security::Cert, :CertStoreParameters
      include_const ::Java::Security::Cert, :CertStoreSpi
      include_const ::Java::Security::Cert, :CRLException
      include_const ::Java::Security::Cert, :CRLSelector
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :X509CertSelector
      include_const ::Java::Security::Cert, :X509CRL
      include_const ::Java::Security::Cert, :X509CRLSelector
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :JavaList
      include_const ::Sun::Security::X509, :AccessDescription
      include_const ::Sun::Security::X509, :GeneralNameInterface
      include_const ::Sun::Security::X509, :URIName
      include_const ::Sun::Security::Util, :Cache
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # A <code>CertStore</code> that retrieves <code>Certificates</code> or
  # <code>CRL</code>s from a URI, for example, as specified in an X.509
  # AuthorityInformationAccess or CRLDistributionPoint extension.
  # <p>
  # For CRLs, this implementation retrieves a single DER encoded CRL per URI.
  # For Certificates, this implementation retrieves a single DER encoded CRL or
  # a collection of Certificates encoded as a PKCS#7 "certs-only" CMS message.
  # <p>
  # This <code>CertStore</code> also implements Certificate/CRL caching.
  # Currently, the cache is shared between all applications in the VM and uses a
  # hardcoded policy. The cache has a maximum size of 185 entries, which are held
  # by SoftReferences. A request will be satisfied from the cache if we last
  # checked for an update within CHECK_INTERVAL (last 30 seconds). Otherwise,
  # we open an URLConnection to download the Certificate(s)/CRL using an
  # If-Modified-Since request (HTTP) if possible. Note that both positive and
  # negative responses are cached, i.e. if we are unable to open the connection
  # or the Certificate(s)/CRL cannot be parsed, we remember this result and
  # additional calls during the CHECK_INTERVAL period do not try to open another
  # connection.
  # <p>
  # The URICertStore is not currently a standard CertStore type. We should
  # consider adding a standard "URI" CertStore type.
  # 
  # @author Andreas Sterbenz
  # @author Sean Mullan
  # @since 7.0
  class URICertStore < URICertStoreImports.const_get :CertStoreSpi
    include_class_members URICertStoreImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
      
      # interval between checks for update of cached Certificates/CRLs
      # (30 seconds)
      const_set_lazy(:CHECK_INTERVAL) { 30 * 1000 }
      const_attr_reader  :CHECK_INTERVAL
      
      # size of the cache (see Cache class for sizing recommendations)
      const_set_lazy(:CACHE_SIZE) { 185 }
      const_attr_reader  :CACHE_SIZE
    }
    
    # X.509 certificate factory instance
    attr_accessor :factory
    alias_method :attr_factory, :factory
    undef_method :factory
    alias_method :attr_factory=, :factory=
    undef_method :factory=
    
    # cached Collection of X509Certificates (may be empty, never null)
    attr_accessor :certs
    alias_method :attr_certs, :certs
    undef_method :certs
    alias_method :attr_certs=, :certs=
    undef_method :certs=
    
    # cached X509CRL (may be null)
    attr_accessor :crl
    alias_method :attr_crl, :crl
    undef_method :crl
    alias_method :attr_crl=, :crl=
    undef_method :crl=
    
    # time we last checked for an update
    attr_accessor :last_checked
    alias_method :attr_last_checked, :last_checked
    undef_method :last_checked
    alias_method :attr_last_checked=, :last_checked=
    undef_method :last_checked=
    
    # time server returned as last modified time stamp
    # or 0 if not available
    attr_accessor :last_modified
    alias_method :attr_last_modified, :last_modified
    undef_method :last_modified
    alias_method :attr_last_modified=, :last_modified=
    undef_method :last_modified=
    
    # the URI of this CertStore
    attr_accessor :uri
    alias_method :attr_uri, :uri
    undef_method :uri
    alias_method :attr_uri=, :uri=
    undef_method :uri=
    
    # true if URI is ldap
    attr_accessor :ldap
    alias_method :attr_ldap, :ldap
    undef_method :ldap
    alias_method :attr_ldap=, :ldap=
    undef_method :ldap=
    
    attr_accessor :ldap_cert_store
    alias_method :attr_ldap_cert_store, :ldap_cert_store
    undef_method :ldap_cert_store
    alias_method :attr_ldap_cert_store=, :ldap_cert_store=
    undef_method :ldap_cert_store=
    
    attr_accessor :ldap_path
    alias_method :attr_ldap_path, :ldap_path
    undef_method :ldap_path
    alias_method :attr_ldap_path=, :ldap_path=
    undef_method :ldap_path=
    
    typesig { [CertStoreParameters] }
    # Creates a URICertStore.
    # 
    # @param parameters specifying the URI
    def initialize(params)
      @factory = nil
      @certs = nil
      @crl = nil
      @last_checked = 0
      @last_modified = 0
      @uri = nil
      @ldap = false
      @ldap_cert_store = nil
      @ldap_path = nil
      super(params)
      @certs = Collections.empty_set
      @ldap = false
      if (!(params.is_a?(URICertStoreParameters)))
        raise InvalidAlgorithmParameterException.new("params must be instanceof URICertStoreParameters")
      end
      @uri = (params).attr_uri
      # if ldap URI, use an LDAPCertStore to fetch certs and CRLs
      if ((@uri.get_scheme.to_lower_case == "ldap"))
        @ldap = true
        @ldap_cert_store = LDAPCertStore.get_instance(LDAPCertStore.get_parameters(@uri))
        @ldap_path = (@uri.get_path).to_s
        # strip off leading '/'
        if ((@ldap_path.char_at(0)).equal?(Character.new(?/.ord)))
          @ldap_path = (@ldap_path.substring(1)).to_s
        end
      end
      begin
        @factory = CertificateFactory.get_instance("X.509")
      rescue CertificateException => e
        raise RuntimeException.new
      end
    end
    
    class_module.module_eval {
      # Returns a URI CertStore. This method consults a cache of
      # CertStores (shared per JVM) using the URI as a key.
      const_set_lazy(:CertStoreCache) { Cache.new_soft_memory_cache(CACHE_SIZE) }
      const_attr_reader  :CertStoreCache
      
      typesig { [URICertStoreParameters] }
      def get_instance(params)
        synchronized(self) do
          if (!(Debug).nil?)
            Debug.println("CertStore URI:" + (params.attr_uri).to_s)
          end
          ucs = CertStoreCache.get(params)
          if ((ucs).nil?)
            ucs = UCS.new(URICertStore.new(params), nil, "URI", params)
            CertStoreCache.put(params, ucs)
          else
            if (!(Debug).nil?)
              Debug.println("URICertStore.getInstance: cache hit")
            end
          end
          return ucs
        end
      end
      
      typesig { [AccessDescription] }
      # Creates a CertStore from information included in the AccessDescription
      # object of a certificate's Authority Information Access Extension.
      def get_instance(ad)
        if (!(ad.get_access_method == AccessDescription::Ad_CAISSUERS_Id))
          return nil
        end
        gn = ad.get_access_location.get_name
        if (!(gn.is_a?(URIName)))
          return nil
        end
        uri = (gn).get_uri
        begin
          return URICertStore.get_instance(URICertStore::URICertStoreParameters.new(uri))
        rescue Exception => ex
          if (!(Debug).nil?)
            Debug.println("exception creating CertStore: " + (ex).to_s)
            ex.print_stack_trace
          end
          return nil
        end
      end
    }
    
    typesig { [CertSelector] }
    # Returns a <code>Collection</code> of <code>X509Certificate</code>s that
    # match the specified selector. If no <code>X509Certificate</code>s
    # match the selector, an empty <code>Collection</code> will be returned.
    # 
    # @param selector a <code>CertSelector</code> used to select which
    # <code>X509Certificate</code>s should be returned. Specify
    # <code>null</code> to return all <code>X509Certificate</code>s.
    # @return a <code>Collection</code> of <code>X509Certificate</code>s that
    # match the specified selector
    # @throws CertStoreException if an exception occurs
    def engine_get_certificates(selector)
      synchronized(self) do
        # if ldap URI we wrap the CertSelector in an LDAPCertSelector to
        # avoid LDAP DN matching issues (see LDAPCertSelector for more info)
        if (@ldap)
          xsel = selector
          begin
            xsel = LDAPCertStore::LDAPCertSelector.new(xsel, xsel.get_subject, @ldap_path)
          rescue IOException => ioe
            raise CertStoreException.new(ioe)
          end
          # Fetch the certificates via LDAP. LDAPCertStore has its own
          # caching mechanism, see the class description for more info.
          return @ldap_cert_store.get_certificates(xsel)
        end
        # Return the Certificates for this entry. It returns the cached value
        # if it is still current and fetches the Certificates otherwise.
        # For the caching details, see the top of this class.
        time = System.current_time_millis
        if (time - @last_checked < CHECK_INTERVAL)
          if (!(Debug).nil?)
            Debug.println("Returning certificates from cache")
          end
          return get_matching_certs(@certs, selector)
        end
        @last_checked = time
        in_ = nil
        begin
          connection = @uri.to_url.open_connection
          if (!(@last_modified).equal?(0))
            connection.set_if_modified_since(@last_modified)
          end
          in_ = connection.get_input_stream
          old_last_modified = @last_modified
          @last_modified = connection.get_last_modified
          if (!(old_last_modified).equal?(0))
            if ((old_last_modified).equal?(@last_modified))
              if (!(Debug).nil?)
                Debug.println("Not modified, using cached copy")
              end
              return get_matching_certs(@certs, selector)
            else
              if (connection.is_a?(HttpURLConnection))
                # some proxy servers omit last modified
                hconn = connection
                if ((hconn.get_response_code).equal?(HttpURLConnection::HTTP_NOT_MODIFIED))
                  if (!(Debug).nil?)
                    Debug.println("Not modified, using cached copy")
                  end
                  return get_matching_certs(@certs, selector)
                end
              end
            end
          end
          if (!(Debug).nil?)
            Debug.println("Downloading new certificates...")
          end
          @certs = @factory.generate_certificates(in_)
          return get_matching_certs(@certs, selector)
        rescue IOException => e
          if (!(Debug).nil?)
            Debug.println("Exception fetching certificates:")
            e.print_stack_trace
          end
        rescue CertificateException => e
          if (!(Debug).nil?)
            Debug.println("Exception fetching certificates:")
            e.print_stack_trace
          end
        ensure
          if (!(in_).nil?)
            begin
              in_.close
            rescue IOException => e
              # ignore
            end
          end
        end
        # exception, forget previous values
        @last_modified = 0
        @certs = Collections.empty_set
        return @certs
      end
    end
    
    class_module.module_eval {
      typesig { [Collection, CertSelector] }
      # Iterates over the specified Collection of X509Certificates and
      # returns only those that match the criteria specified in the
      # CertSelector.
      def get_matching_certs(certs, selector)
        # if selector not specified, all certs match
        if ((selector).nil?)
          return certs
        end
        matched_certs = ArrayList.new(certs.size)
        certs.each do |cert|
          if (selector.match(cert))
            matched_certs.add(cert)
          end
        end
        return matched_certs
      end
    }
    
    typesig { [CRLSelector] }
    # Returns a <code>Collection</code> of <code>X509CRL</code>s that
    # match the specified selector. If no <code>X509CRL</code>s
    # match the selector, an empty <code>Collection</code> will be returned.
    # 
    # @param selector A <code>CRLSelector</code> used to select which
    # <code>X509CRL</code>s should be returned. Specify <code>null</code>
    # to return all <code>X509CRL</code>s.
    # @return A <code>Collection</code> of <code>X509CRL</code>s that
    # match the specified selector
    # @throws CertStoreException if an exception occurs
    def engine_get_crls(selector)
      synchronized(self) do
        # if ldap URI we wrap the CRLSelector in an LDAPCRLSelector to
        # avoid LDAP DN matching issues (see LDAPCRLSelector for more info)
        if (@ldap)
          xsel = selector
          begin
            xsel = LDAPCertStore::LDAPCRLSelector.new(xsel, nil, @ldap_path)
          rescue IOException => ioe
            raise CertStoreException.new(ioe)
          end
          # Fetch the CRLs via LDAP. LDAPCertStore has its own
          # caching mechanism, see the class description for more info.
          return @ldap_cert_store.get_crls(xsel)
        end
        # Return the CRLs for this entry. It returns the cached value
        # if it is still current and fetches the CRLs otherwise.
        # For the caching details, see the top of this class.
        time = System.current_time_millis
        if (time - @last_checked < CHECK_INTERVAL)
          if (!(Debug).nil?)
            Debug.println("Returning CRL from cache")
          end
          return get_matching_crls(@crl, selector)
        end
        @last_checked = time
        in_ = nil
        begin
          connection = @uri.to_url.open_connection
          if (!(@last_modified).equal?(0))
            connection.set_if_modified_since(@last_modified)
          end
          in_ = connection.get_input_stream
          old_last_modified = @last_modified
          @last_modified = connection.get_last_modified
          if (!(old_last_modified).equal?(0))
            if ((old_last_modified).equal?(@last_modified))
              if (!(Debug).nil?)
                Debug.println("Not modified, using cached copy")
              end
              return get_matching_crls(@crl, selector)
            else
              if (connection.is_a?(HttpURLConnection))
                # some proxy servers omit last modified
                hconn = connection
                if ((hconn.get_response_code).equal?(HttpURLConnection::HTTP_NOT_MODIFIED))
                  if (!(Debug).nil?)
                    Debug.println("Not modified, using cached copy")
                  end
                  return get_matching_crls(@crl, selector)
                end
              end
            end
          end
          if (!(Debug).nil?)
            Debug.println("Downloading new CRL...")
          end
          @crl = @factory.generate_crl(in_)
          return get_matching_crls(@crl, selector)
        rescue IOException => e
          if (!(Debug).nil?)
            Debug.println("Exception fetching CRL:")
            e.print_stack_trace
          end
        rescue CRLException => e
          if (!(Debug).nil?)
            Debug.println("Exception fetching CRL:")
            e.print_stack_trace
          end
        ensure
          if (!(in_).nil?)
            begin
              in_.close
            rescue IOException => e
              # ignore
            end
          end
        end
        # exception, forget previous values
        @last_modified = 0
        @crl = nil
        return Collections.empty_list
      end
    end
    
    class_module.module_eval {
      typesig { [X509CRL, CRLSelector] }
      # Checks if the specified X509CRL matches the criteria specified in the
      # CRLSelector.
      def get_matching_crls(crl, selector)
        if ((selector).nil? || (!(crl).nil? && selector.match(crl)))
          return Collections.singleton_list(crl)
        else
          return Collections.empty_list
        end
      end
      
      # CertStoreParameters for the URICertStore.
      const_set_lazy(:URICertStoreParameters) { Class.new do
        include_class_members URICertStore
        include CertStoreParameters
        
        attr_accessor :uri
        alias_method :attr_uri, :uri
        undef_method :uri
        alias_method :attr_uri=, :uri=
        undef_method :uri=
        
        attr_accessor :hash_code
        alias_method :attr_hash_code, :hash_code
        undef_method :hash_code
        alias_method :attr_hash_code=, :hash_code=
        undef_method :hash_code=
        
        typesig { [URI] }
        def initialize(uri)
          @uri = nil
          @hash_code = 0
          @uri = uri
        end
        
        typesig { [Object] }
        def equals(obj)
          if (!(obj.is_a?(URICertStoreParameters)))
            return false
          end
          params = obj
          return (@uri == params.attr_uri)
        end
        
        typesig { [] }
        def hash_code
          if ((@hash_code).equal?(0))
            result = 17
            result = 37 * result + @uri.hash_code
            @hash_code = result
          end
          return @hash_code
        end
        
        typesig { [] }
        def clone
          begin
            return super
          rescue CloneNotSupportedException => e
            # Cannot happen
            raise InternalError.new(e.to_s)
          end
        end
        
        private
        alias_method :initialize__uricert_store_parameters, :initialize
      end }
      
      # This class allows the URICertStore to be accessed as a CertStore.
      const_set_lazy(:UCS) { Class.new(CertStore) do
        include_class_members URICertStore
        
        typesig { [CertStoreSpi, Provider, String, CertStoreParameters] }
        def initialize(spi, p, type, params)
          super(spi, p, type, params)
        end
        
        private
        alias_method :initialize__ucs, :initialize
      end }
    }
    
    private
    alias_method :initialize__uricert_store, :initialize
  end
  
end
