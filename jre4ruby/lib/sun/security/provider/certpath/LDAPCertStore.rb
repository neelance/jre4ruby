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
  module LDAPCertStoreImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Net, :URI
      include ::Java::Util
      include_const ::Javax::Naming, :Context
      include_const ::Javax::Naming, :NamingEnumeration
      include_const ::Javax::Naming, :NamingException
      include_const ::Javax::Naming, :NameNotFoundException
      include_const ::Javax::Naming::Directory, :Attribute
      include_const ::Javax::Naming::Directory, :Attributes
      include_const ::Javax::Naming::Directory, :BasicAttributes
      include_const ::Javax::Naming::Directory, :DirContext
      include_const ::Javax::Naming::Directory, :InitialDirContext
      include ::Java::Security
      include_const ::Java::Security::Cert, :Certificate
      include ::Java::Security::Cert
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Sun::Misc, :HexDumpEncoder
      include_const ::Sun::Security::Util, :Cache
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::X509, :X500Name
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # A <code>CertStore</code> that retrieves <code>Certificates</code> and
  # <code>CRL</code>s from an LDAP directory, using the PKIX LDAP V2 Schema
  # (RFC 2587):
  # <a href="http://www.ietf.org/rfc/rfc2587.txt">
  # http://www.ietf.org/rfc/rfc2587.txt</a>.
  # <p>
  # Before calling the {@link #engineGetCertificates engineGetCertificates} or
  # {@link #engineGetCRLs engineGetCRLs} methods, the
  # {@link #LDAPCertStore(CertStoreParameters)
  # LDAPCertStore(CertStoreParameters)} constructor is called to create the
  # <code>CertStore</code> and establish the DNS name and port of the LDAP
  # server from which <code>Certificate</code>s and <code>CRL</code>s will be
  # retrieved.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # As described in the javadoc for <code>CertStoreSpi</code>, the
  # <code>engineGetCertificates</code> and <code>engineGetCRLs</code> methods
  # must be thread-safe. That is, multiple threads may concurrently
  # invoke these methods on a single <code>LDAPCertStore</code> object
  # (or more than one) with no ill effects. This allows a
  # <code>CertPathBuilder</code> to search for a CRL while simultaneously
  # searching for further certificates, for instance.
  # <p>
  # This is achieved by adding the <code>synchronized</code> keyword to the
  # <code>engineGetCertificates</code> and <code>engineGetCRLs</code> methods.
  # <p>
  # This classes uses caching and requests multiple attributes at once to
  # minimize LDAP round trips. The cache is associated with the CertStore
  # instance. It uses soft references to hold the values to minimize impact
  # on footprint and currently has a maximum size of 750 attributes and a
  # 30 second default lifetime.
  # <p>
  # We always request CA certificates, cross certificate pairs, and ARLs in
  # a single LDAP request when any one of them is needed. The reason is that
  # we typically need all of them anyway and requesting them in one go can
  # reduce the number of requests to a third. Even if we don't need them,
  # these attributes are typically small enough not to cause a noticeable
  # overhead. In addition, when the prefetchCRLs flag is true, we also request
  # the full CRLs. It is currently false initially but set to true once any
  # request for an ARL to the server returns an null value. The reason is
  # that CRLs could be rather large but are rarely used. This implementation
  # should improve performance in most cases.
  # 
  # @see java.security.cert.CertStore
  # 
  # @since       1.4
  # @author      Steve Hanna
  # @author      Andreas Sterbenz
  class LDAPCertStore < LDAPCertStoreImports.const_get :CertStoreSpi
    include_class_members LDAPCertStoreImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("certpath") }
      const_attr_reader  :Debug
      
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
      
      # LDAP attribute identifiers.
      const_set_lazy(:USER_CERT) { "userCertificate;binary" }
      const_attr_reader  :USER_CERT
      
      const_set_lazy(:CA_CERT) { "cACertificate;binary" }
      const_attr_reader  :CA_CERT
      
      const_set_lazy(:CROSS_CERT) { "crossCertificatePair;binary" }
      const_attr_reader  :CROSS_CERT
      
      const_set_lazy(:CRL) { "certificateRevocationList;binary" }
      const_attr_reader  :CRL
      
      const_set_lazy(:ARL) { "authorityRevocationList;binary" }
      const_attr_reader  :ARL
      
      const_set_lazy(:DELTA_CRL) { "deltaRevocationList;binary" }
      const_attr_reader  :DELTA_CRL
      
      # Constants for various empty values
      const_set_lazy(:STRING0) { Array.typed(String).new(0) { nil } }
      const_attr_reader  :STRING0
      
      const_set_lazy(:BB0) { Array.typed(Array.typed(::Java::Byte)).new(0) { nil } }
      const_attr_reader  :BB0
      
      const_set_lazy(:EMPTY_ATTRIBUTES) { BasicAttributes.new }
      const_attr_reader  :EMPTY_ATTRIBUTES
      
      # cache related constants
      const_set_lazy(:DEFAULT_CACHE_SIZE) { 750 }
      const_attr_reader  :DEFAULT_CACHE_SIZE
      
      const_set_lazy(:DEFAULT_CACHE_LIFETIME) { 30 }
      const_attr_reader  :DEFAULT_CACHE_LIFETIME
      
      const_set_lazy(:PROP_LIFETIME) { "sun.security.certpath.ldap.cache.lifetime" }
      const_attr_reader  :PROP_LIFETIME
      
      when_class_loaded do
        s = AccessController.do_privileged(GetPropertyAction.new(PROP_LIFETIME))
        if (!(s).nil?)
          const_set :LIFETIME, JavaInteger.parse_int(s) # throws NumberFormatException
        else
          const_set :LIFETIME, DEFAULT_CACHE_LIFETIME
        end
      end
    }
    
    # The CertificateFactory used to decode certificates from
    # their binary stored form.
    attr_accessor :cf
    alias_method :attr_cf, :cf
    undef_method :cf
    alias_method :attr_cf=, :cf=
    undef_method :cf=
    
    # The JNDI directory context.
    attr_accessor :ctx
    alias_method :attr_ctx, :ctx
    undef_method :ctx
    alias_method :attr_ctx=, :ctx=
    undef_method :ctx=
    
    # Flag indicating whether we should prefetch CRLs.
    attr_accessor :prefetch_crls
    alias_method :attr_prefetch_crls, :prefetch_crls
    undef_method :prefetch_crls
    alias_method :attr_prefetch_crls=, :prefetch_crls=
    undef_method :prefetch_crls=
    
    attr_accessor :value_cache
    alias_method :attr_value_cache, :value_cache
    undef_method :value_cache
    alias_method :attr_value_cache=, :value_cache=
    undef_method :value_cache=
    
    attr_accessor :cache_hits
    alias_method :attr_cache_hits, :cache_hits
    undef_method :cache_hits
    alias_method :attr_cache_hits=, :cache_hits=
    undef_method :cache_hits=
    
    attr_accessor :cache_misses
    alias_method :attr_cache_misses, :cache_misses
    undef_method :cache_misses
    alias_method :attr_cache_misses=, :cache_misses=
    undef_method :cache_misses=
    
    attr_accessor :requests
    alias_method :attr_requests, :requests
    undef_method :requests
    alias_method :attr_requests=, :requests=
    undef_method :requests=
    
    typesig { [CertStoreParameters] }
    # Creates a <code>CertStore</code> with the specified parameters.
    # For this class, the parameters object must be an instance of
    # <code>LDAPCertStoreParameters</code>.
    # 
    # @param params the algorithm parameters
    # @exception InvalidAlgorithmParameterException if params is not an
    # instance of <code>LDAPCertStoreParameters</code>
    def initialize(params)
      @cf = nil
      @ctx = nil
      @prefetch_crls = false
      @value_cache = nil
      @cache_hits = 0
      @cache_misses = 0
      @requests = 0
      super(params)
      @prefetch_crls = false
      @cache_hits = 0
      @cache_misses = 0
      @requests = 0
      if (!(params.is_a?(LDAPCertStoreParameters)))
        raise InvalidAlgorithmParameterException.new("parameters must be LDAPCertStoreParameters")
      end
      lparams = params
      # Create InitialDirContext needed to communicate with the server
      create_initial_dir_context(lparams.get_server_name, lparams.get_port)
      # Create CertificateFactory for use later on
      begin
        @cf = CertificateFactory.get_instance("X.509")
      rescue CertificateException => e
        raise InvalidAlgorithmParameterException.new("unable to create CertificateFactory for X.509")
      end
      if ((LIFETIME).equal?(0))
        @value_cache = Cache.new_null_cache
      else
        if (LIFETIME < 0)
          @value_cache = Cache.new_soft_memory_cache(DEFAULT_CACHE_SIZE)
        else
          @value_cache = Cache.new_soft_memory_cache(DEFAULT_CACHE_SIZE, LIFETIME)
        end
      end
    end
    
    class_module.module_eval {
      # Returns an LDAP CertStore. This method consults a cache of
      # CertStores (shared per JVM) using the LDAP server/port as a key.
      const_set_lazy(:CertStoreCache) { Cache.new_soft_memory_cache(185) }
      const_attr_reader  :CertStoreCache
      
      typesig { [LDAPCertStoreParameters] }
      def get_instance(params)
        synchronized(self) do
          lcs = CertStoreCache.get(params)
          if ((lcs).nil?)
            lcs = CertStore.get_instance("LDAP", params)
            CertStoreCache.put(params, lcs)
          else
            if (!(Debug).nil?)
              Debug.println("LDAPCertStore.getInstance: cache hit")
            end
          end
          return lcs
        end
      end
    }
    
    typesig { [String, ::Java::Int] }
    # Create InitialDirContext.
    # 
    # @param server Server DNS name hosting LDAP service
    # @param port   Port at which server listens for requests
    # @throws InvalidAlgorithmParameterException if creation fails
    def create_initial_dir_context(server, port)
      url = "ldap://" + server + ":" + (port).to_s
      env = Hashtable.new
      env.put(Context::INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory")
      env.put(Context::PROVIDER_URL, url)
      begin
        @ctx = InitialDirContext.new(env)
        # By default, follow referrals unless application has
        # overridden property in an application resource file.
        current_env = @ctx.get_environment
        if ((current_env.get(Context::REFERRAL)).nil?)
          @ctx.add_to_environment(Context::REFERRAL, "follow")
        end
      rescue NamingException => e
        if (!(Debug).nil?)
          Debug.println("LDAPCertStore.engineInit about to throw " + "InvalidAlgorithmParameterException")
          e.print_stack_trace
        end
        ee = InvalidAlgorithmParameterException.new("unable to create InitialDirContext using supplied parameters")
        ee.init_cause(e)
        raise ee
      end
    end
    
    class_module.module_eval {
      # Private class encapsulating the actual LDAP operations and cache
      # handling. Use:
      # 
      # LDAPRequest request = new LDAPRequest(dn);
      # request.addRequestedAttribute(CROSS_CERT);
      # request.addRequestedAttribute(CA_CERT);
      # byte[][] crossValues = request.getValues(CROSS_CERT);
      # byte[][] caValues = request.getValues(CA_CERT);
      # 
      # At most one LDAP request is sent for each instance created. If all
      # getValues() calls can be satisfied from the cache, no request
      # is sent at all. If a request is sent, all requested attributes
      # are always added to the cache irrespective of whether the getValues()
      # method is called.
      const_set_lazy(:LDAPRequest) { Class.new do
        extend LocalClass
        include_class_members LDAPCertStore
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :value_map
        alias_method :attr_value_map, :value_map
        undef_method :value_map
        alias_method :attr_value_map=, :value_map=
        undef_method :value_map=
        
        attr_accessor :requested_attributes
        alias_method :attr_requested_attributes, :requested_attributes
        undef_method :requested_attributes
        alias_method :attr_requested_attributes=, :requested_attributes=
        undef_method :requested_attributes=
        
        typesig { [String] }
        def initialize(name)
          @name = nil
          @value_map = nil
          @requested_attributes = nil
          @name = name
          @requested_attributes = ArrayList.new(5)
        end
        
        typesig { [] }
        def get_name
          return @name
        end
        
        typesig { [String] }
        def add_requested_attribute(attr_id)
          if (!(@value_map).nil?)
            raise IllegalStateException.new("Request already sent")
          end
          @requested_attributes.add(attr_id)
        end
        
        typesig { [String] }
        # Gets one or more binary values from an attribute.
        # 
        # @param name          the location holding the attribute
        # @param attrId                the attribute identifier
        # @return                      an array of binary values (byte arrays)
        # @throws NamingException      if a naming exception occurs
        def get_values(attr_id)
          if (DEBUG && (((self.attr_cache_hits + self.attr_cache_misses) % 50).equal?(0)))
            System.out.println("Cache hits: " + (self.attr_cache_hits).to_s + "; misses: " + (self.attr_cache_misses).to_s)
          end
          cache_key = @name + "|" + attr_id
          values = self.attr_value_cache.get(cache_key)
          if (!(values).nil?)
            self.attr_cache_hits += 1
            return values
          end
          self.attr_cache_misses += 1
          attrs = get_value_map
          values = attrs.get(attr_id)
          return values
        end
        
        typesig { [] }
        # Get a map containing the values for this request. The first time
        # this method is called on an object, the LDAP request is sent,
        # the results parsed and added to a private map and also to the
        # cache of this LDAPCertStore. Subsequent calls return the private
        # map immediately.
        # 
        # The map contains an entry for each requested attribute. The
        # attribute name is the key, values are byte[][]. If there are no
        # values for that attribute, values are byte[0][].
        # 
        # @return                      the value Map
        # @throws NamingException      if a naming exception occurs
        def get_value_map
          if (!(@value_map).nil?)
            return @value_map
          end
          if (DEBUG)
            System.out.println("Request: " + @name + ":" + (@requested_attributes).to_s)
            self.attr_requests += 1
            if ((self.attr_requests % 5).equal?(0))
              System.out.println("LDAP requests: " + (self.attr_requests).to_s)
            end
          end
          @value_map = HashMap.new(8)
          attr_ids = @requested_attributes.to_array(STRING0)
          attrs = nil
          begin
            attrs = self.attr_ctx.get_attributes(@name, attr_ids)
          rescue NameNotFoundException => e
            # name does not exist on this LDAP server
            # treat same as not attributes found
            attrs = EMPTY_ATTRIBUTES
          end
          @requested_attributes.each do |attrId|
            attr = attrs.get(attr_id)
            values = get_attribute_values(attr)
            cache_attribute(attr_id, values)
            @value_map.put(attr_id, values)
          end
          return @value_map
        end
        
        typesig { [String, Array.typed(Array.typed(::Java::Byte))] }
        # Add the values to the cache.
        def cache_attribute(attr_id, values)
          cache_key = @name + "|" + attr_id
          self.attr_value_cache.put(cache_key, values)
        end
        
        typesig { [Attribute] }
        # Get the values for the given attribute. If the attribute is null
        # or does not contain any values, a zero length byte array is
        # returned. NOTE that it is assumed that all values are byte arrays.
        def get_attribute_values(attr)
          values = nil
          if ((attr).nil?)
            values = BB0
          else
            values = Array.typed(Array.typed(::Java::Byte)).new(attr.size) { nil }
            i = 0
            enum_ = attr.get_all
            while (enum_.has_more)
              obj = enum_.next
              if (!(Debug).nil?)
                if (obj.is_a?(String))
                  Debug.println("LDAPCertStore.getAttrValues() " + "enum.next is a string!: " + (obj).to_s)
                end
              end
              value = obj
              values[((i += 1) - 1)] = value
            end
          end
          return values
        end
        
        private
        alias_method :initialize__ldaprequest, :initialize
      end }
    }
    
    typesig { [LDAPRequest, String, X509CertSelector] }
    # Gets certificates from an attribute id and location in the LDAP
    # directory. Returns a Collection containing only the Certificates that
    # match the specified CertSelector.
    # 
    # @param name the location holding the attribute
    # @param id the attribute identifier
    # @param sel a CertSelector that the Certificates must match
    # @return a Collection of Certificates found
    # @throws CertStoreException       if an exception occurs
    def get_certificates(request, id, sel)
      # fetch encoded certs from storage
      encoded_cert = nil
      begin
        encoded_cert = request.get_values(id)
      rescue NamingException => naming_ex
        raise CertStoreException.new(naming_ex)
      end
      n = encoded_cert.attr_length
      if ((n).equal?(0))
        return Collections.empty_set
      end
      certs = ArrayList.new(n)
      # decode certs and check if they satisfy selector
      i = 0
      while i < n
        bais = ByteArrayInputStream.new(encoded_cert[i])
        begin
          cert = @cf.generate_certificate(bais)
          if (sel.match(cert))
            certs.add(cert)
          end
        rescue CertificateException => e
          if (!(Debug).nil?)
            Debug.println("LDAPCertStore.getCertificates() encountered " + "exception while parsing cert, skipping the bad data: ")
            encoder = HexDumpEncoder.new
            Debug.println("[ " + (encoder.encode_buffer(encoded_cert[i])).to_s + " ]")
          end
        end
        i += 1
      end
      return certs
    end
    
    typesig { [LDAPRequest, String] }
    # Gets certificate pairs from an attribute id and location in the LDAP
    # directory.
    # 
    # @param name the location holding the attribute
    # @param id the attribute identifier
    # @return a Collection of X509CertificatePairs found
    # @throws CertStoreException       if an exception occurs
    def get_cert_pairs(request, id)
      # fetch the encoded cert pairs from storage
      encoded_cert_pair = nil
      begin
        encoded_cert_pair = request.get_values(id)
      rescue NamingException => naming_ex
        raise CertStoreException.new(naming_ex)
      end
      n = encoded_cert_pair.attr_length
      if ((n).equal?(0))
        return Collections.empty_set
      end
      cert_pairs = ArrayList.new(n)
      # decode each cert pair and add it to the Collection
      i = 0
      while i < n
        begin
          cert_pair = X509CertificatePair.generate_certificate_pair(encoded_cert_pair[i])
          cert_pairs.add(cert_pair)
        rescue CertificateException => e
          if (!(Debug).nil?)
            Debug.println("LDAPCertStore.getCertPairs() encountered exception " + "while parsing cert, skipping the bad data: ")
            encoder = HexDumpEncoder.new
            Debug.println("[ " + (encoder.encode_buffer(encoded_cert_pair[i])).to_s + " ]")
          end
        end
        i += 1
      end
      return cert_pairs
    end
    
    typesig { [LDAPRequest, X509CertSelector, X509CertSelector] }
    # Looks at certificate pairs stored in the crossCertificatePair attribute
    # at the specified location in the LDAP directory. Returns a Collection
    # containing all Certificates stored in the forward component that match
    # the forward CertSelector and all Certificates stored in the reverse
    # component that match the reverse CertSelector.
    # <p>
    # If either forward or reverse is null, all certificates from the
    # corresponding component will be rejected.
    # 
    # @param name the location to look in
    # @param forward the forward CertSelector (or null)
    # @param reverse the reverse CertSelector (or null)
    # @return a Collection of Certificates found
    # @throws CertStoreException       if an exception occurs
    def get_matching_cross_certs(request, forward, reverse)
      # Get the cert pairs
      cert_pairs = get_cert_pairs(request, CROSS_CERT)
      # Find Certificates that match and put them in a list
      matching_certs = ArrayList.new
      cert_pairs.each do |certPair|
        cert = nil
        if (!(forward).nil?)
          cert = cert_pair.get_forward
          if ((!(cert).nil?) && forward.match(cert))
            matching_certs.add(cert)
          end
        end
        if (!(reverse).nil?)
          cert = cert_pair.get_reverse
          if ((!(cert).nil?) && reverse.match(cert))
            matching_certs.add(cert)
          end
        end
      end
      return matching_certs
    end
    
    typesig { [CertSelector] }
    # Returns a <code>Collection</code> of <code>Certificate</code>s that
    # match the specified selector. If no <code>Certificate</code>s
    # match the selector, an empty <code>Collection</code> will be returned.
    # <p>
    # It is not practical to search every entry in the LDAP database for
    # matching <code>Certificate</code>s. Instead, the <code>CertSelector</code>
    # is examined in order to determine where matching <code>Certificate</code>s
    # are likely to be found (according to the PKIX LDAPv2 schema, RFC 2587).
    # If the subject is specified, its directory entry is searched. If the
    # issuer is specified, its directory entry is searched. If neither the
    # subject nor the issuer are specified (or the selector is not an
    # <code>X509CertSelector</code>), a <code>CertStoreException</code> is
    # thrown.
    # 
    # @param selector a <code>CertSelector</code> used to select which
    # <code>Certificate</code>s should be returned.
    # @return a <code>Collection</code> of <code>Certificate</code>s that
    # match the specified selector
    # @throws CertStoreException if an exception occurs
    def engine_get_certificates(selector)
      synchronized(self) do
        if (!(Debug).nil?)
          Debug.println("LDAPCertStore.engineGetCertificates() selector: " + (String.value_of(selector)).to_s)
        end
        if ((selector).nil?)
          selector = X509CertSelector.new
        end
        if (!(selector.is_a?(X509CertSelector)))
          raise CertStoreException.new("LDAPCertStore needs an X509CertSelector " + "to find certs")
        end
        xsel = selector
        basic_constraints = xsel.get_basic_constraints
        subject = xsel.get_subject_as_string
        issuer = xsel.get_issuer_as_string
        certs = HashSet.new
        if (!(Debug).nil?)
          Debug.println("LDAPCertStore.engineGetCertificates() basicConstraints: " + (basic_constraints).to_s)
        end
        # basicConstraints:
        # -2: only EE certs accepted
        # -1: no check is done
        # 0: any CA certificate accepted
        # >1: certificate's basicConstraints extension pathlen must match
        if (!(subject).nil?)
          if (!(Debug).nil?)
            Debug.println("LDAPCertStore.engineGetCertificates() " + "subject is not null")
          end
          request = LDAPRequest.new_local(self, subject)
          if (basic_constraints > -2)
            request.add_requested_attribute(CROSS_CERT)
            request.add_requested_attribute(CA_CERT)
            request.add_requested_attribute(ARL)
            if (@prefetch_crls)
              request.add_requested_attribute(CRL)
            end
          end
          if (basic_constraints < 0)
            request.add_requested_attribute(USER_CERT)
          end
          if (basic_constraints > -2)
            certs.add_all(get_matching_cross_certs(request, xsel, nil))
            if (!(Debug).nil?)
              Debug.println("LDAPCertStore.engineGetCertificates() after " + "getMatchingCrossCerts(subject,xsel,null),certs.size(): " + (certs.size).to_s)
            end
            certs.add_all(get_certificates(request, CA_CERT, xsel))
            if (!(Debug).nil?)
              Debug.println("LDAPCertStore.engineGetCertificates() after " + "getCertificates(subject,CA_CERT,xsel),certs.size(): " + (certs.size).to_s)
            end
          end
          if (basic_constraints < 0)
            certs.add_all(get_certificates(request, USER_CERT, xsel))
            if (!(Debug).nil?)
              Debug.println("LDAPCertStore.engineGetCertificates() after " + "getCertificates(subject,USER_CERT, xsel),certs.size(): " + (certs.size).to_s)
            end
          end
        else
          if (!(Debug).nil?)
            Debug.println("LDAPCertStore.engineGetCertificates() subject is null")
          end
          if ((basic_constraints).equal?(-2))
            raise CertStoreException.new("need subject to find EE certs")
          end
          if ((issuer).nil?)
            raise CertStoreException.new("need subject or issuer to find certs")
          end
        end
        if (!(Debug).nil?)
          Debug.println("LDAPCertStore.engineGetCertificates() about to " + "getMatchingCrossCerts...")
        end
        if ((!(issuer).nil?) && (basic_constraints > -2))
          request = LDAPRequest.new_local(self, issuer)
          request.add_requested_attribute(CROSS_CERT)
          request.add_requested_attribute(CA_CERT)
          request.add_requested_attribute(ARL)
          if (@prefetch_crls)
            request.add_requested_attribute(CRL)
          end
          certs.add_all(get_matching_cross_certs(request, nil, xsel))
          if (!(Debug).nil?)
            Debug.println("LDAPCertStore.engineGetCertificates() after " + "getMatchingCrossCerts(issuer,null,xsel),certs.size(): " + (certs.size).to_s)
          end
          certs.add_all(get_certificates(request, CA_CERT, xsel))
          if (!(Debug).nil?)
            Debug.println("LDAPCertStore.engineGetCertificates() after " + "getCertificates(issuer,CA_CERT,xsel),certs.size(): " + (certs.size).to_s)
          end
        end
        if (!(Debug).nil?)
          Debug.println("LDAPCertStore.engineGetCertificates() returning certs")
        end
        return certs
      end
    end
    
    typesig { [LDAPRequest, String, X509CRLSelector] }
    # Gets CRLs from an attribute id and location in the LDAP directory.
    # Returns a Collection containing only the CRLs that match the
    # specified CRLSelector.
    # 
    # @param name the location holding the attribute
    # @param id the attribute identifier
    # @param sel a CRLSelector that the CRLs must match
    # @return a Collection of CRLs found
    # @throws CertStoreException       if an exception occurs
    def get_crls(request, id, sel)
      # fetch the encoded crls from storage
      encoded_crl = nil
      begin
        encoded_crl = request.get_values(id)
      rescue NamingException => naming_ex
        raise CertStoreException.new(naming_ex)
      end
      n = encoded_crl.attr_length
      if ((n).equal?(0))
        return Collections.empty_set
      end
      crls = ArrayList.new(n)
      # decode each crl and check if it matches selector
      i = 0
      while i < n
        begin
          crl = @cf.generate_crl(ByteArrayInputStream.new(encoded_crl[i]))
          if (sel.match(crl))
            crls.add(crl)
          end
        rescue CRLException => e
          if (!(Debug).nil?)
            Debug.println("LDAPCertStore.getCRLs() encountered exception" + " while parsing CRL, skipping the bad data: ")
            encoder = HexDumpEncoder.new
            Debug.println("[ " + (encoder.encode_buffer(encoded_crl[i])).to_s + " ]")
          end
        end
        i += 1
      end
      return crls
    end
    
    typesig { [CRLSelector] }
    # Returns a <code>Collection</code> of <code>CRL</code>s that
    # match the specified selector. If no <code>CRL</code>s
    # match the selector, an empty <code>Collection</code> will be returned.
    # <p>
    # It is not practical to search every entry in the LDAP database for
    # matching <code>CRL</code>s. Instead, the <code>CRLSelector</code>
    # is examined in order to determine where matching <code>CRL</code>s
    # are likely to be found (according to the PKIX LDAPv2 schema, RFC 2587).
    # If issuerNames or certChecking are specified, the issuer's directory
    # entry is searched. If neither issuerNames or certChecking are specified
    # (or the selector is not an <code>X509CRLSelector</code>), a
    # <code>CertStoreException</code> is thrown.
    # 
    # @param selector A <code>CRLSelector</code> used to select which
    # <code>CRL</code>s should be returned. Specify <code>null</code>
    # to return all <code>CRL</code>s.
    # @return A <code>Collection</code> of <code>CRL</code>s that
    # match the specified selector
    # @throws CertStoreException if an exception occurs
    def engine_get_crls(selector)
      synchronized(self) do
        if (!(Debug).nil?)
          Debug.println("LDAPCertStore.engineGetCRLs() selector: " + (selector).to_s)
        end
        # Set up selector and collection to hold CRLs
        if ((selector).nil?)
          selector = X509CRLSelector.new
        end
        if (!(selector.is_a?(X509CRLSelector)))
          raise CertStoreException.new("need X509CRLSelector to find CRLs")
        end
        xsel = selector
        crls = HashSet.new
        # Look in directory entry for issuer of cert we're checking.
        issuer_names = nil
        cert_checking = xsel.get_certificate_checking
        if (!(cert_checking).nil?)
          issuer_names = HashSet.new
          issuer = cert_checking.get_issuer_x500principal
          issuer_names.add(issuer.get_name(X500Principal::RFC2253))
        else
          # But if we don't know which cert we're checking, try the directory
          # entries of all acceptable CRL issuers
          issuer_names = xsel.get_issuer_names
          if ((issuer_names).nil?)
            raise CertStoreException.new("need issuerNames or certChecking to " + "find CRLs")
          end
        end
        issuer_names.each do |nameObject|
          issuer_name = nil
          if (name_object.is_a?(Array.typed(::Java::Byte)))
            begin
              issuer = X500Principal.new(name_object)
              issuer_name = (issuer.get_name(X500Principal::RFC2253)).to_s
            rescue IllegalArgumentException => e
              next
            end
          else
            issuer_name = (name_object).to_s
          end
          # If all we want is CA certs, try to get the (probably shorter) ARL
          entry_crls = Collections.empty_set
          if ((cert_checking).nil? || !(cert_checking.get_basic_constraints).equal?(-1))
            request = LDAPRequest.new_local(self, issuer_name)
            request.add_requested_attribute(CROSS_CERT)
            request.add_requested_attribute(CA_CERT)
            request.add_requested_attribute(ARL)
            if (@prefetch_crls)
              request.add_requested_attribute(CRL)
            end
            begin
              entry_crls = get_crls(request, ARL, xsel)
              if (entry_crls.is_empty)
                # no ARLs found. We assume that means that there are
                # no ARLs on this server at all and prefetch the CRLs.
                @prefetch_crls = true
              else
                crls.add_all(entry_crls)
              end
            rescue CertStoreException => e
              if (!(Debug).nil?)
                Debug.println("LDAPCertStore.engineGetCRLs non-fatal error " + "retrieving ARLs:" + (e).to_s)
                e.print_stack_trace
              end
            end
          end
          # Otherwise, get the CRL
          # if certChecking is null, we don't know if we should look in ARL or CRL
          # attribute, so check both for matching CRLs.
          if (entry_crls.is_empty || (cert_checking).nil?)
            request = LDAPRequest.new_local(self, issuer_name)
            request.add_requested_attribute(CRL)
            entry_crls = get_crls(request, CRL, xsel)
            crls.add_all(entry_crls)
          end
        end
        return crls
      end
    end
    
    class_module.module_eval {
      typesig { [URI] }
      # converts an LDAP URI into LDAPCertStoreParameters
      def get_parameters(uri)
        host = uri.get_host
        if ((host).nil?)
          return SunLDAPCertStoreParameters.new
        else
          port = uri.get_port
          return ((port).equal?(-1) ? SunLDAPCertStoreParameters.new(host) : SunLDAPCertStoreParameters.new(host, port))
        end
      end
      
      # Subclass of LDAPCertStoreParameters with overridden equals/hashCode
      # methods. This is necessary because the parameters are used as
      # keys in the LDAPCertStore cache.
      const_set_lazy(:SunLDAPCertStoreParameters) { Class.new(LDAPCertStoreParameters) do
        include_class_members LDAPCertStore
        
        attr_accessor :hash_code
        alias_method :attr_hash_code, :hash_code
        undef_method :hash_code
        alias_method :attr_hash_code=, :hash_code=
        undef_method :hash_code=
        
        typesig { [String, ::Java::Int] }
        def initialize(server_name, port)
          @hash_code = 0
          super(server_name, port)
          @hash_code = 0
        end
        
        typesig { [String] }
        def initialize(server_name)
          @hash_code = 0
          super(server_name)
          @hash_code = 0
        end
        
        typesig { [] }
        def initialize
          @hash_code = 0
          super()
          @hash_code = 0
        end
        
        typesig { [Object] }
        def equals(obj)
          if (!(obj.is_a?(LDAPCertStoreParameters)))
            return false
          end
          params = obj
          return ((get_port).equal?(params.get_port) && get_server_name.equals_ignore_case(params.get_server_name))
        end
        
        typesig { [] }
        def hash_code
          if ((@hash_code).equal?(0))
            result = 17
            result = 37 * result + get_port
            result = 37 * result + get_server_name.to_lower_case.hash_code
            @hash_code = result
          end
          return @hash_code
        end
        
        private
        alias_method :initialize__sun_ldapcert_store_parameters, :initialize
      end }
      
      # This inner class wraps an existing X509CertSelector and adds
      # additional criteria to match on when the certificate's subject is
      # different than the LDAP Distinguished Name entry. The LDAPCertStore
      # implementation uses the subject DN as the directory entry for
      # looking up certificates. This can be problematic if the certificates
      # that you want to fetch have a different subject DN than the entry
      # where they are stored. You could set the selector's subject to the
      # LDAP DN entry, but then the resulting match would fail to find the
      # desired certificates because the subject DNs would not match. This
      # class avoids that problem by introducing a certSubject which should
      # be set to the certificate's subject DN when it is different than
      # the LDAP DN.
      const_set_lazy(:LDAPCertSelector) { Class.new(X509CertSelector) do
        include_class_members LDAPCertStore
        
        attr_accessor :cert_subject
        alias_method :attr_cert_subject, :cert_subject
        undef_method :cert_subject
        alias_method :attr_cert_subject=, :cert_subject=
        undef_method :cert_subject=
        
        attr_accessor :selector
        alias_method :attr_selector, :selector
        undef_method :selector
        alias_method :attr_selector=, :selector=
        undef_method :selector=
        
        attr_accessor :subject
        alias_method :attr_subject, :subject
        undef_method :subject
        alias_method :attr_subject=, :subject=
        undef_method :subject=
        
        typesig { [X509CertSelector, X500Principal, String] }
        # Creates an LDAPCertSelector.
        # 
        # @param selector the X509CertSelector to wrap
        # @param certSubject the subject DN of the certificate that you want
        # to retrieve via LDAP
        # @param ldapDN the LDAP DN where the certificate is stored
        def initialize(selector, cert_subject, ldap_dn)
          @cert_subject = nil
          @selector = nil
          @subject = nil
          super()
          @selector = (selector).nil? ? X509CertSelector.new : selector
          @cert_subject = cert_subject
          @subject = X500Name.new(ldap_dn).as_x500principal
        end
        
        typesig { [] }
        # we only override the get (accessor methods) since the set methods
        # will not be invoked by the code that uses this LDAPCertSelector.
        def get_certificate
          return @selector.get_certificate
        end
        
        typesig { [] }
        def get_serial_number
          return @selector.get_serial_number
        end
        
        typesig { [] }
        def get_issuer
          return @selector.get_issuer
        end
        
        typesig { [] }
        def get_issuer_as_string
          return @selector.get_issuer_as_string
        end
        
        typesig { [] }
        def get_issuer_as_bytes
          return @selector.get_issuer_as_bytes
        end
        
        typesig { [] }
        def get_subject
          # return the ldap DN
          return @subject
        end
        
        typesig { [] }
        def get_subject_as_string
          # return the ldap DN
          return @subject.get_name
        end
        
        typesig { [] }
        def get_subject_as_bytes
          # return the encoded ldap DN
          return @subject.get_encoded
        end
        
        typesig { [] }
        def get_subject_key_identifier
          return @selector.get_subject_key_identifier
        end
        
        typesig { [] }
        def get_authority_key_identifier
          return @selector.get_authority_key_identifier
        end
        
        typesig { [] }
        def get_certificate_valid
          return @selector.get_certificate_valid
        end
        
        typesig { [] }
        def get_private_key_valid
          return @selector.get_private_key_valid
        end
        
        typesig { [] }
        def get_subject_public_key_alg_id
          return @selector.get_subject_public_key_alg_id
        end
        
        typesig { [] }
        def get_subject_public_key
          return @selector.get_subject_public_key
        end
        
        typesig { [] }
        def get_key_usage
          return @selector.get_key_usage
        end
        
        typesig { [] }
        def get_extended_key_usage
          return @selector.get_extended_key_usage
        end
        
        typesig { [] }
        def get_match_all_subject_alt_names
          return @selector.get_match_all_subject_alt_names
        end
        
        typesig { [] }
        def get_subject_alternative_names
          return @selector.get_subject_alternative_names
        end
        
        typesig { [] }
        def get_name_constraints
          return @selector.get_name_constraints
        end
        
        typesig { [] }
        def get_basic_constraints
          return @selector.get_basic_constraints
        end
        
        typesig { [] }
        def get_policy
          return @selector.get_policy
        end
        
        typesig { [] }
        def get_path_to_names
          return @selector.get_path_to_names
        end
        
        typesig { [Certificate] }
        def match(cert)
          # temporarily set the subject criterion to the certSubject
          # so that match will not reject the desired certificates
          @selector.set_subject(@cert_subject)
          match_ = @selector.match(cert)
          @selector.set_subject(@subject)
          return match_
        end
        
        private
        alias_method :initialize__ldapcert_selector, :initialize
      end }
      
      # This class has the same purpose as LDAPCertSelector except it is for
      # X.509 CRLs.
      const_set_lazy(:LDAPCRLSelector) { Class.new(X509CRLSelector) do
        include_class_members LDAPCertStore
        
        attr_accessor :selector
        alias_method :attr_selector, :selector
        undef_method :selector
        alias_method :attr_selector=, :selector=
        undef_method :selector=
        
        attr_accessor :cert_issuers
        alias_method :attr_cert_issuers, :cert_issuers
        undef_method :cert_issuers
        alias_method :attr_cert_issuers=, :cert_issuers=
        undef_method :cert_issuers=
        
        attr_accessor :issuers
        alias_method :attr_issuers, :issuers
        undef_method :issuers
        alias_method :attr_issuers=, :issuers=
        undef_method :issuers=
        
        attr_accessor :issuer_names
        alias_method :attr_issuer_names, :issuer_names
        undef_method :issuer_names
        alias_method :attr_issuer_names=, :issuer_names=
        undef_method :issuer_names=
        
        typesig { [X509CRLSelector, Collection, String] }
        # Creates an LDAPCRLSelector.
        # 
        # @param selector the X509CRLSelector to wrap
        # @param certIssuers the issuer DNs of the CRLs that you want
        # to retrieve via LDAP
        # @param ldapDN the LDAP DN where the CRL is stored
        def initialize(selector, cert_issuers, ldap_dn)
          @selector = nil
          @cert_issuers = nil
          @issuers = nil
          @issuer_names = nil
          super()
          @selector = (selector).nil? ? X509CRLSelector.new : selector
          @cert_issuers = cert_issuers
          @issuer_names = HashSet.new
          @issuer_names.add(ldap_dn)
          @issuers = HashSet.new
          @issuers.add(X500Name.new(ldap_dn).as_x500principal)
        end
        
        typesig { [] }
        # we only override the get (accessor methods) since the set methods
        # will not be invoked by the code that uses this LDAPCRLSelector.
        def get_issuers
          # return the ldap DN
          return Collections.unmodifiable_collection(@issuers)
        end
        
        typesig { [] }
        def get_issuer_names
          # return the ldap DN
          return Collections.unmodifiable_collection(@issuer_names)
        end
        
        typesig { [] }
        def get_min_crl
          return @selector.get_min_crl
        end
        
        typesig { [] }
        def get_max_crl
          return @selector.get_max_crl
        end
        
        typesig { [] }
        def get_date_and_time
          return @selector.get_date_and_time
        end
        
        typesig { [] }
        def get_certificate_checking
          return @selector.get_certificate_checking
        end
        
        typesig { [CRL] }
        def match(crl)
          # temporarily set the issuer criterion to the certIssuers
          # so that match will not reject the desired CRL
          @selector.set_issuers(@cert_issuers)
          match_ = @selector.match(crl)
          @selector.set_issuers(@issuers)
          return match_
        end
        
        private
        alias_method :initialize__ldapcrlselector, :initialize
      end }
    }
    
    private
    alias_method :initialize__ldapcert_store, :initialize
  end
  
end
