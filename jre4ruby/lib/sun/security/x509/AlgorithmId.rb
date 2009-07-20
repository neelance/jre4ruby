require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AlgorithmIdImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
      include ::Sun::Security::Util
    }
  end
  
  # This class identifies algorithms, such as cryptographic transforms, each
  # of which may be associated with parameters.  Instances of this base class
  # are used when this runtime environment has no special knowledge of the
  # algorithm type, and may also be used in other cases.  Equivalence is
  # defined according to OID and (where relevant) parameters.
  # 
  # <P>Subclasses may be used, for example when when the algorithm ID has
  # associated parameters which some code (e.g. code using public keys) needs
  # to have parsed.  Two examples of such algorithms are Diffie-Hellman key
  # exchange, and the Digital Signature Standard Algorithm (DSS/DSA).
  # 
  # <P>The OID constants defined in this class correspond to some widely
  # used algorithms, for which conventional string names have been defined.
  # This class is not a general repository for OIDs, or for such string names.
  # Note that the mappings between algorithm IDs and algorithm names is
  # not one-to-one.
  # 
  # 
  # @author David Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class AlgorithmId 
    include_class_members AlgorithmIdImports
    include Serializable
    include DerEncoder
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { 7205873507486557157 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The object identitifer being used for this algorithm.
    attr_accessor :algid
    alias_method :attr_algid, :algid
    undef_method :algid
    alias_method :attr_algid=, :algid=
    undef_method :algid=
    
    # The (parsed) parameters
    attr_accessor :alg_params
    alias_method :attr_alg_params, :alg_params
    undef_method :alg_params
    alias_method :attr_alg_params=, :alg_params=
    undef_method :alg_params=
    
    attr_accessor :constructed_from_der
    alias_method :attr_constructed_from_der, :constructed_from_der
    undef_method :constructed_from_der
    alias_method :attr_constructed_from_der=, :constructed_from_der=
    undef_method :constructed_from_der=
    
    # Parameters for this algorithm.  These are stored in unparsed
    # DER-encoded form; subclasses can be made to automaticaly parse
    # them so there is fast access to these parameters.
    attr_accessor :params
    alias_method :attr_params, :params
    undef_method :params
    alias_method :attr_params=, :params=
    undef_method :params=
    
    typesig { [] }
    # Constructs an algorithm ID which will be initialized
    # separately, for example by deserialization.
    # @deprecated use one of the other constructors.
    def initialize
      @algid = nil
      @alg_params = nil
      @constructed_from_der = true
      @params = nil
    end
    
    typesig { [ObjectIdentifier] }
    # Constructs a parameterless algorithm ID.
    # 
    # @param oid the identifier for the algorithm
    def initialize(oid)
      @algid = nil
      @alg_params = nil
      @constructed_from_der = true
      @params = nil
      @algid = oid
    end
    
    typesig { [ObjectIdentifier, AlgorithmParameters] }
    # Constructs an algorithm ID with algorithm parameters.
    # 
    # @param oid the identifier for the algorithm.
    # @param algparams the associated algorithm parameters.
    def initialize(oid, algparams)
      @algid = nil
      @alg_params = nil
      @constructed_from_der = true
      @params = nil
      @algid = oid
      @alg_params = algparams
      @constructed_from_der = false
    end
    
    typesig { [ObjectIdentifier, DerValue] }
    def initialize(oid, params)
      @algid = nil
      @alg_params = nil
      @constructed_from_der = true
      @params = nil
      @algid = oid
      @params = params
      if (!(@params).nil?)
        decode_params
      end
    end
    
    typesig { [] }
    def decode_params
      algid_string = @algid.to_s
      begin
        @alg_params = AlgorithmParameters.get_instance(algid_string)
      rescue NoSuchAlgorithmException => e
        begin
          # Try the internal EC code so that we can fully parse EC
          # keys even if the provider is not registered.
          # This code can go away once we have EC in the SUN provider.
          @alg_params = AlgorithmParameters.get_instance(algid_string, Sun::Security::Ec::ECKeyFactory.attr_ec_internal_provider)
        rescue NoSuchAlgorithmException => ee
          # This algorithm parameter type is not supported, so we cannot
          # parse the parameters.
          @alg_params = nil
          return
        end
      end
      # Decode (parse) the parameters
      @alg_params.init(@params.to_byte_array)
    end
    
    typesig { [DerOutputStream] }
    # Marshal a DER-encoded "AlgorithmID" sequence on the DER stream.
    def encode(out)
      der_encode(out)
    end
    
    typesig { [OutputStream] }
    # DER encode this object onto an output stream.
    # Implements the <code>DerEncoder</code> interface.
    # 
    # @param out
    # the output stream on which to write the DER encoding.
    # 
    # @exception IOException on encoding error.
    def der_encode(out)
      bytes = DerOutputStream.new
      tmp = DerOutputStream.new
      bytes.put_oid(@algid)
      # Setup params from algParams since no DER encoding is given
      if ((@constructed_from_der).equal?(false))
        if (!(@alg_params).nil?)
          @params = DerValue.new(@alg_params.get_encoded)
        else
          @params = nil
        end
      end
      if ((@params).nil?)
        # Changes backed out for compatibility with Solaris
        # Several AlgorithmId should omit the whole parameter part when
        # it's NULL. They are ---
        # rfc3370 2.1: Implementations SHOULD generate SHA-1
        # AlgorithmIdentifiers with absent parameters.
        # rfc3447 C1: When id-sha1, id-sha256, id-sha384 and id-sha512
        # are used in an AlgorithmIdentifier the parameters (which are
        # optional) SHOULD be omitted.
        # rfc3279 2.3.2: The id-dsa algorithm syntax includes optional
        # domain parameters... When omitted, the parameters component
        # MUST be omitted entirely
        # rfc3370 3.1: When the id-dsa-with-sha1 algorithm identifier
        # is used, the AlgorithmIdentifier parameters field MUST be absent.
        # if (
        # algid.equals((Object)SHA_oid) ||
        # algid.equals((Object)SHA256_oid) ||
        # algid.equals((Object)SHA384_oid) ||
        # algid.equals((Object)SHA512_oid) ||
        # algid.equals((Object)DSA_oid) ||
        # algid.equals((Object)sha1WithDSA_oid)) {
        # ; // no parameter part encoded
        # } else {
        # bytes.putNull();
        # }
        bytes.put_null
      else
        bytes.put_der_value(@params)
      end
      tmp.write(DerValue.attr_tag_sequence, bytes)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [] }
    # Returns the DER-encoded X.509 AlgorithmId as a byte array.
    def encode
      out = DerOutputStream.new
      der_encode(out)
      return out.to_byte_array
    end
    
    typesig { [] }
    # Returns the ISO OID for this algorithm.  This is usually converted
    # to a string and used as part of an algorithm name, for example
    # "OID.1.3.14.3.2.13" style notation.  Use the <code>getName</code>
    # call when you do not need to ensure cross-system portability
    # of algorithm names, or need a user friendly name.
    def get_oid
      return @algid
    end
    
    typesig { [] }
    # Returns a name for the algorithm which may be more intelligible
    # to humans than the algorithm's OID, but which won't necessarily
    # be comprehensible on other systems.  For example, this might
    # return a name such as "MD5withRSA" for a signature algorithm on
    # some systems.  It also returns names like "OID.1.2.3.4", when
    # no particular name for the algorithm is known.
    def get_name
      alg_name = NameTable.get(@algid)
      if (!(alg_name).nil?)
        return alg_name
      end
      if ((!(@params).nil?) && (@algid == SpecifiedWithECDSA_oid))
        begin
          params_id = AlgorithmId.parse(DerValue.new(get_encoded_params))
          params_name = params_id.get_name
          if ((params_name == "SHA"))
            params_name = "SHA1"
          end
          alg_name = params_name + "withECDSA"
        rescue IOException => e
          # ignore
        end
      end
      return ((alg_name).nil?) ? @algid.to_s : alg_name
    end
    
    typesig { [] }
    def get_parameters
      return @alg_params
    end
    
    typesig { [] }
    # Returns the DER encoded parameter, which can then be
    # used to initialize java.security.AlgorithmParamters.
    # 
    # @return DER encoded parameters, or null not present.
    def get_encoded_params
      return ((@params).nil?) ? nil : @params.to_byte_array
    end
    
    typesig { [AlgorithmId] }
    # Returns true iff the argument indicates the same algorithm
    # with the same parameters.
    def equals(other)
      params_equal = ((@params).nil? ? (other.attr_params).nil? : (@params == other.attr_params))
      return ((@algid == other.attr_algid) && params_equal)
    end
    
    typesig { [Object] }
    # Compares this AlgorithmID to another.  If algorithm parameters are
    # available, they are compared.  Otherwise, just the object IDs
    # for the algorithm are compared.
    # 
    # @param other preferably an AlgorithmId, else an ObjectIdentifier
    def equals(other)
      if ((self).equal?(other))
        return true
      end
      if (other.is_a?(AlgorithmId))
        return equals(other)
      else
        if (other.is_a?(ObjectIdentifier))
          return equals(other)
        else
          return false
        end
      end
    end
    
    typesig { [ObjectIdentifier] }
    # Compares two algorithm IDs for equality.  Returns true iff
    # they are the same algorithm, ignoring algorithm parameters.
    def equals(id)
      return (@algid == id)
    end
    
    typesig { [] }
    # Returns a hashcode for this AlgorithmId.
    # 
    # @return a hashcode for this AlgorithmId.
    def hash_code
      sbuf = StringBuilder.new
      sbuf.append(@algid.to_s)
      sbuf.append(params_to_string)
      return sbuf.to_s.hash_code
    end
    
    typesig { [] }
    # Provides a human-readable description of the algorithm parameters.
    # This may be redefined by subclasses which parse those parameters.
    def params_to_string
      if ((@params).nil?)
        return ""
      else
        if (!(@alg_params).nil?)
          return @alg_params.to_s
        else
          return ", params unparsed"
        end
      end
    end
    
    typesig { [] }
    # Returns a string describing the algorithm and its parameters.
    def to_s
      return get_name + params_to_string
    end
    
    class_module.module_eval {
      typesig { [DerValue] }
      # Parse (unmarshal) an ID from a DER sequence input value.  This form
      # parsing might be used when expanding a value which has already been
      # partially unmarshaled as a set or sequence member.
      # 
      # @exception IOException on error.
      # @param val the input value, which contains the algid and, if
      # there are any parameters, those parameters.
      # @return an ID for the algorithm.  If the system is configured
      # appropriately, this may be an instance of a class
      # with some kind of special support for this algorithm.
      # In that case, you may "narrow" the type of the ID.
      def parse(val)
        if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
          raise IOException.new("algid parse error, not a sequence")
        end
        # Get the algorithm ID and any parameters.
        algid = nil
        params = nil
        in_ = val.to_der_input_stream
        algid = in_.get_oid
        if ((in_.available).equal?(0))
          params = nil
        else
          params = in_.get_der_value
          if ((params.attr_tag).equal?(DerValue.attr_tag_null))
            if (!(params.length).equal?(0))
              raise IOException.new("invalid NULL")
            end
            params = nil
          end
          if (!(in_.available).equal?(0))
            raise IOException.new("Invalid AlgorithmIdentifier: extra data")
          end
        end
        return AlgorithmId.new(algid, params)
      end
      
      typesig { [String] }
      # Returns one of the algorithm IDs most commonly associated
      # with this algorithm name.
      # 
      # @param algname the name being used
      # @deprecated use the short get form of this method.
      # @exception NoSuchAlgorithmException on error.
      def get_algorithm_id(algname)
        return get(algname)
      end
      
      typesig { [String] }
      # Returns one of the algorithm IDs most commonly associated
      # with this algorithm name.
      # 
      # @param algname the name being used
      # @exception NoSuchAlgorithmException on error.
      def get(algname)
        oid = nil
        begin
          oid = alg_oid(algname)
        rescue IOException => ioe
          raise NoSuchAlgorithmException.new("Invalid ObjectIdentifier " + algname)
        end
        if ((oid).nil?)
          raise NoSuchAlgorithmException.new("unrecognized algorithm name: " + algname)
        end
        return AlgorithmId.new(oid)
      end
      
      typesig { [AlgorithmParameters] }
      # Returns one of the algorithm IDs most commonly associated
      # with this algorithm parameters.
      # 
      # @param algparams the associated algorithm parameters.
      # @exception NoSuchAlgorithmException on error.
      def get(algparams)
        oid = nil
        algname = algparams.get_algorithm
        begin
          oid = alg_oid(algname)
        rescue IOException => ioe
          raise NoSuchAlgorithmException.new("Invalid ObjectIdentifier " + algname)
        end
        if ((oid).nil?)
          raise NoSuchAlgorithmException.new("unrecognized algorithm name: " + algname)
        end
        return AlgorithmId.new(oid, algparams)
      end
      
      typesig { [String] }
      # Translates from some common algorithm names to the
      # OID with which they're usually associated ... this mapping
      # is the reverse of the one below, except in those cases
      # where synonyms are supported or where a given algorithm
      # is commonly associated with multiple OIDs.
      # 
      # XXX This method needs to be enhanced so that we can also pass the
      # scope of the algorithm name to it, e.g., the algorithm name "DSA"
      # may have a different OID when used as a "Signature" algorithm than when
      # used as a "KeyPairGenerator" algorithm.
      def alg_oid(name)
        # See if algname is in printable OID ("dot-dot") notation
        if (!(name.index_of(Character.new(?..ord))).equal?(-1))
          if (name.starts_with("OID."))
            return ObjectIdentifier.new(name.substring("OID.".length))
          else
            return ObjectIdentifier.new(name)
          end
        end
        # Digesting algorithms
        if (name.equals_ignore_case("MD5"))
          return AlgorithmId::MD5_oid
        end
        if (name.equals_ignore_case("MD2"))
          return AlgorithmId::MD2_oid
        end
        if (name.equals_ignore_case("SHA") || name.equals_ignore_case("SHA1") || name.equals_ignore_case("SHA-1"))
          return AlgorithmId::SHA_oid
        end
        if (name.equals_ignore_case("SHA-256") || name.equals_ignore_case("SHA256"))
          return AlgorithmId::SHA256_oid
        end
        if (name.equals_ignore_case("SHA-384") || name.equals_ignore_case("SHA384"))
          return AlgorithmId::SHA384_oid
        end
        if (name.equals_ignore_case("SHA-512") || name.equals_ignore_case("SHA512"))
          return AlgorithmId::SHA512_oid
        end
        # Various public key algorithms
        if (name.equals_ignore_case("RSA"))
          return AlgorithmId::RSAEncryption_oid
        end
        if (name.equals_ignore_case("Diffie-Hellman") || name.equals_ignore_case("DH"))
          return AlgorithmId::DH_oid
        end
        if (name.equals_ignore_case("DSA"))
          return AlgorithmId::DSA_oid
        end
        if (name.equals_ignore_case("EC"))
          return EC_oid
        end
        # Common signature types
        if (name.equals_ignore_case("MD5withRSA") || name.equals_ignore_case("MD5/RSA"))
          return AlgorithmId.attr_md5with_rsaencryption_oid
        end
        if (name.equals_ignore_case("MD2withRSA") || name.equals_ignore_case("MD2/RSA"))
          return AlgorithmId.attr_md2with_rsaencryption_oid
        end
        if (name.equals_ignore_case("SHAwithDSA") || name.equals_ignore_case("SHA1withDSA") || name.equals_ignore_case("SHA/DSA") || name.equals_ignore_case("SHA1/DSA") || name.equals_ignore_case("DSAWithSHA1") || name.equals_ignore_case("DSS") || name.equals_ignore_case("SHA-1/DSA"))
          return AlgorithmId.attr_sha1with_dsa_oid
        end
        if (name.equals_ignore_case("SHA1WithRSA") || name.equals_ignore_case("SHA1/RSA"))
          return AlgorithmId.attr_sha1with_rsaencryption_oid
        end
        if (name.equals_ignore_case("SHA1withECDSA") || name.equals_ignore_case("ECDSA"))
          return AlgorithmId.attr_sha1with_ecdsa_oid
        end
        # See if any of the installed providers supply a mapping from
        # the given algorithm name to an OID string
        oid_string = nil
        if (!self.attr_init_oid_table)
          provs = Security.get_providers
          i = 0
          while i < provs.attr_length
            enum_ = provs[i].keys
            while enum_.has_more_elements
              alias_ = enum_.next_element
              index = 0
              if (alias_.to_upper_case.starts_with("ALG.ALIAS") && !((index = alias_.to_upper_case.index_of("OID.", 0))).equal?(-1))
                index += "OID.".length
                if ((index).equal?(alias_.length))
                  # invalid alias entry
                  break
                end
                if ((self.attr_oid_table).nil?)
                  self.attr_oid_table = HashMap.new
                end
                oid_string = (alias_.substring(index)).to_s
                std_alg_name = provs[i].get_property(alias_).to_upper_case
                if ((self.attr_oid_table.get(std_alg_name)).nil?)
                  self.attr_oid_table.put(std_alg_name, ObjectIdentifier.new(oid_string))
                end
              end
            end
            i += 1
          end
          self.attr_init_oid_table = true
        end
        return self.attr_oid_table.get(name.to_upper_case)
      end
      
      typesig { [::Java::Int] }
      def oid(*values)
        return ObjectIdentifier.new_internal(values)
      end
      
      
      def init_oid_table
        defined?(@@init_oid_table) ? @@init_oid_table : @@init_oid_table= false
      end
      alias_method :attr_init_oid_table, :init_oid_table
      
      def init_oid_table=(value)
        @@init_oid_table = value
      end
      alias_method :attr_init_oid_table=, :init_oid_table=
      
      
      def oid_table
        defined?(@@oid_table) ? @@oid_table : @@oid_table= nil
      end
      alias_method :attr_oid_table, :oid_table
      
      def oid_table=(value)
        @@oid_table = value
      end
      alias_method :attr_oid_table=, :oid_table=
      
      # HASHING ALGORITHMS
      # 
      # 
      # Algorithm ID for the MD2 Message Digest Algorthm, from RFC 1319.
      # OID = 1.2.840.113549.2.2
      const_set_lazy(:MD2_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 2, 2])) }
      const_attr_reader  :MD2_oid
      
      # Algorithm ID for the MD5 Message Digest Algorthm, from RFC 1321.
      # OID = 1.2.840.113549.2.5
      const_set_lazy(:MD5_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 2, 5])) }
      const_attr_reader  :MD5_oid
      
      # Algorithm ID for the SHA1 Message Digest Algorithm, from FIPS 180-1.
      # This is sometimes called "SHA", though that is often confusing since
      # many people refer to FIPS 180 (which has an error) as defining SHA.
      # OID = 1.3.14.3.2.26. Old SHA-0 OID: 1.3.14.3.2.18.
      const_set_lazy(:SHA_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 3, 14, 3, 2, 26])) }
      const_attr_reader  :SHA_oid
      
      const_set_lazy(:SHA256_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([2, 16, 840, 1, 101, 3, 4, 2, 1])) }
      const_attr_reader  :SHA256_oid
      
      const_set_lazy(:SHA384_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([2, 16, 840, 1, 101, 3, 4, 2, 2])) }
      const_attr_reader  :SHA384_oid
      
      const_set_lazy(:SHA512_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([2, 16, 840, 1, 101, 3, 4, 2, 3])) }
      const_attr_reader  :SHA512_oid
      
      # COMMON PUBLIC KEY TYPES
      const_set_lazy(:DH_data) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 3, 1]) }
      const_attr_reader  :DH_data
      
      const_set_lazy(:DH_PKIX_data) { Array.typed(::Java::Int).new([1, 2, 840, 10046, 2, 1]) }
      const_attr_reader  :DH_PKIX_data
      
      const_set_lazy(:DSA_OIW_data) { Array.typed(::Java::Int).new([1, 3, 14, 3, 2, 12]) }
      const_attr_reader  :DSA_OIW_data
      
      const_set_lazy(:DSA_PKIX_data) { Array.typed(::Java::Int).new([1, 2, 840, 10040, 4, 1]) }
      const_attr_reader  :DSA_PKIX_data
      
      const_set_lazy(:RSA_data) { Array.typed(::Java::Int).new([1, 2, 5, 8, 1, 1]) }
      const_attr_reader  :RSA_data
      
      const_set_lazy(:RSAEncryption_data) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 1, 1]) }
      const_attr_reader  :RSAEncryption_data
      
      const_set_lazy(:EC_oid) { oid(1, 2, 840, 10045, 2, 1) }
      const_attr_reader  :EC_oid
      
      # COMMON SIGNATURE ALGORITHMS
      const_set_lazy(:Md2WithRSAEncryption_data) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 1, 2]) }
      const_attr_reader  :Md2WithRSAEncryption_data
      
      const_set_lazy(:Md5WithRSAEncryption_data) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 1, 4]) }
      const_attr_reader  :Md5WithRSAEncryption_data
      
      const_set_lazy(:Sha1WithRSAEncryption_data) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 1, 5]) }
      const_attr_reader  :Sha1WithRSAEncryption_data
      
      const_set_lazy(:Sha1WithRSAEncryption_OIW_data) { Array.typed(::Java::Int).new([1, 3, 14, 3, 2, 29]) }
      const_attr_reader  :Sha1WithRSAEncryption_OIW_data
      
      const_set_lazy(:Sha256WithRSAEncryption_data) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 1, 11]) }
      const_attr_reader  :Sha256WithRSAEncryption_data
      
      const_set_lazy(:Sha384WithRSAEncryption_data) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 1, 12]) }
      const_attr_reader  :Sha384WithRSAEncryption_data
      
      const_set_lazy(:Sha512WithRSAEncryption_data) { Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 1, 13]) }
      const_attr_reader  :Sha512WithRSAEncryption_data
      
      const_set_lazy(:ShaWithDSA_OIW_data) { Array.typed(::Java::Int).new([1, 3, 14, 3, 2, 13]) }
      const_attr_reader  :ShaWithDSA_OIW_data
      
      const_set_lazy(:Sha1WithDSA_OIW_data) { Array.typed(::Java::Int).new([1, 3, 14, 3, 2, 27]) }
      const_attr_reader  :Sha1WithDSA_OIW_data
      
      const_set_lazy(:DsaWithSHA1_PKIX_data) { Array.typed(::Java::Int).new([1, 2, 840, 10040, 4, 3]) }
      const_attr_reader  :DsaWithSHA1_PKIX_data
      
      const_set_lazy(:Sha1WithECDSA_oid) { oid(1, 2, 840, 10045, 4, 1) }
      const_attr_reader  :Sha1WithECDSA_oid
      
      const_set_lazy(:Sha224WithECDSA_oid) { oid(1, 2, 840, 10045, 4, 3, 1) }
      const_attr_reader  :Sha224WithECDSA_oid
      
      const_set_lazy(:Sha256WithECDSA_oid) { oid(1, 2, 840, 10045, 4, 3, 2) }
      const_attr_reader  :Sha256WithECDSA_oid
      
      const_set_lazy(:Sha384WithECDSA_oid) { oid(1, 2, 840, 10045, 4, 3, 3) }
      const_attr_reader  :Sha384WithECDSA_oid
      
      const_set_lazy(:Sha512WithECDSA_oid) { oid(1, 2, 840, 10045, 4, 3, 4) }
      const_attr_reader  :Sha512WithECDSA_oid
      
      const_set_lazy(:SpecifiedWithECDSA_oid) { oid(1, 2, 840, 10045, 4, 3) }
      const_attr_reader  :SpecifiedWithECDSA_oid
      
      # Algorithm ID for the PBE encryption algorithms from PKCS#5 and
      # PKCS#12.
      const_set_lazy(:PbeWithMD5AndDES_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 5, 3])) }
      const_attr_reader  :PbeWithMD5AndDES_oid
      
      const_set_lazy(:PbeWithMD5AndRC2_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 5, 6])) }
      const_attr_reader  :PbeWithMD5AndRC2_oid
      
      const_set_lazy(:PbeWithSHA1AndDES_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 5, 10])) }
      const_attr_reader  :PbeWithSHA1AndDES_oid
      
      const_set_lazy(:PbeWithSHA1AndRC2_oid) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 5, 11])) }
      const_attr_reader  :PbeWithSHA1AndRC2_oid
      
      
      def pbe_with_sha1and_desede_oid
        defined?(@@pbe_with_sha1and_desede_oid) ? @@pbe_with_sha1and_desede_oid : @@pbe_with_sha1and_desede_oid= ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 12, 1, 3]))
      end
      alias_method :attr_pbe_with_sha1and_desede_oid, :pbe_with_sha1and_desede_oid
      
      def pbe_with_sha1and_desede_oid=(value)
        @@pbe_with_sha1and_desede_oid = value
      end
      alias_method :attr_pbe_with_sha1and_desede_oid=, :pbe_with_sha1and_desede_oid=
      
      
      def pbe_with_sha1and_rc2_40_oid
        defined?(@@pbe_with_sha1and_rc2_40_oid) ? @@pbe_with_sha1and_rc2_40_oid : @@pbe_with_sha1and_rc2_40_oid= ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 2, 840, 113549, 1, 12, 1, 6]))
      end
      alias_method :attr_pbe_with_sha1and_rc2_40_oid, :pbe_with_sha1and_rc2_40_oid
      
      def pbe_with_sha1and_rc2_40_oid=(value)
        @@pbe_with_sha1and_rc2_40_oid = value
      end
      alias_method :attr_pbe_with_sha1and_rc2_40_oid=, :pbe_with_sha1and_rc2_40_oid=
      
      when_class_loaded do
        # Note the preferred OIDs are named simply with no "OIW" or
        # "PKIX" in them, even though they may point to data from these
        # specs; e.g. SHA_oid, DH_oid, DSA_oid, SHA1WithDSA_oid...
        # 
        # 
        # Algorithm ID for Diffie Hellman Key agreement, from PKCS #3.
        # Parameters include public values P and G, and may optionally specify
        # the length of the private key X.  Alternatively, algorithm parameters
        # may be derived from another source such as a Certificate Authority's
        # certificate.
        # OID = 1.2.840.113549.1.3.1
        const_set :DH_oid, ObjectIdentifier.new_internal(DH_data)
        # Algorithm ID for the Diffie Hellman Key Agreement (DH), from RFC 3279.
        # Parameters may include public values P and G.
        # OID = 1.2.840.10046.2.1
        const_set :DH_PKIX_oid, ObjectIdentifier.new_internal(DH_PKIX_data)
        # Algorithm ID for the Digital Signing Algorithm (DSA), from the
        # NIST OIW Stable Agreements part 12.
        # Parameters may include public values P, Q, and G; or these may be
        # derived from
        # another source such as a Certificate Authority's certificate.
        # OID = 1.3.14.3.2.12
        const_set :DSA_OIW_oid, ObjectIdentifier.new_internal(DSA_OIW_data)
        # Algorithm ID for the Digital Signing Algorithm (DSA), from RFC 3279.
        # Parameters may include public values P, Q, and G; or these may be
        # derived from another source such as a Certificate Authority's
        # certificate.
        # OID = 1.2.840.10040.4.1
        const_set :DSA_oid, ObjectIdentifier.new_internal(DSA_PKIX_data)
        # Algorithm ID for RSA keys used for any purpose, as defined in X.509.
        # The algorithm parameter is a single value, the number of bits in the
        # public modulus.
        # OID = 1.2.5.8.1.1
        const_set :RSA_oid, ObjectIdentifier.new_internal(RSA_data)
        # Algorithm ID for RSA keys used with RSA encryption, as defined
        # in PKCS #1.  There are no parameters associated with this algorithm.
        # OID = 1.2.840.113549.1.1.1
        const_set :RSAEncryption_oid, ObjectIdentifier.new_internal(RSAEncryption_data)
        # Identifies a signing algorithm where an MD2 digest is encrypted
        # using an RSA private key; defined in PKCS #1.  Use of this
        # signing algorithm is discouraged due to MD2 vulnerabilities.
        # OID = 1.2.840.113549.1.1.2
        const_set :Md2WithRSAEncryption_oid, ObjectIdentifier.new_internal(Md2WithRSAEncryption_data)
        # Identifies a signing algorithm where an MD5 digest is
        # encrypted using an RSA private key; defined in PKCS #1.
        # OID = 1.2.840.113549.1.1.4
        const_set :Md5WithRSAEncryption_oid, ObjectIdentifier.new_internal(Md5WithRSAEncryption_data)
        # Identifies a signing algorithm where a SHA1 digest is
        # encrypted using an RSA private key; defined by RSA DSI.
        # OID = 1.2.840.113549.1.1.5
        const_set :Sha1WithRSAEncryption_oid, ObjectIdentifier.new_internal(Sha1WithRSAEncryption_data)
        # Identifies a signing algorithm where a SHA1 digest is
        # encrypted using an RSA private key; defined in NIST OIW.
        # OID = 1.3.14.3.2.29
        const_set :Sha1WithRSAEncryption_OIW_oid, ObjectIdentifier.new_internal(Sha1WithRSAEncryption_OIW_data)
        # Identifies a signing algorithm where a SHA256 digest is
        # encrypted using an RSA private key; defined by PKCS #1.
        # OID = 1.2.840.113549.1.1.11
        const_set :Sha256WithRSAEncryption_oid, ObjectIdentifier.new_internal(Sha256WithRSAEncryption_data)
        # Identifies a signing algorithm where a SHA384 digest is
        # encrypted using an RSA private key; defined by PKCS #1.
        # OID = 1.2.840.113549.1.1.12
        const_set :Sha384WithRSAEncryption_oid, ObjectIdentifier.new_internal(Sha384WithRSAEncryption_data)
        # Identifies a signing algorithm where a SHA512 digest is
        # encrypted using an RSA private key; defined by PKCS #1.
        # OID = 1.2.840.113549.1.1.13
        const_set :Sha512WithRSAEncryption_oid, ObjectIdentifier.new_internal(Sha512WithRSAEncryption_data)
        # Identifies the FIPS 186 "Digital Signature Standard" (DSS), where a
        # SHA digest is signed using the Digital Signing Algorithm (DSA).
        # This should not be used.
        # OID = 1.3.14.3.2.13
        const_set :ShaWithDSA_OIW_oid, ObjectIdentifier.new_internal(ShaWithDSA_OIW_data)
        # Identifies the FIPS 186 "Digital Signature Standard" (DSS), where a
        # SHA1 digest is signed using the Digital Signing Algorithm (DSA).
        # OID = 1.3.14.3.2.27
        const_set :Sha1WithDSA_OIW_oid, ObjectIdentifier.new_internal(Sha1WithDSA_OIW_data)
        # Identifies the FIPS 186 "Digital Signature Standard" (DSS), where a
        # SHA1 digest is signed using the Digital Signing Algorithm (DSA).
        # OID = 1.2.840.10040.4.3
        const_set :Sha1WithDSA_oid, ObjectIdentifier.new_internal(DsaWithSHA1_PKIX_data)
        const_set :NameTable, HashMap.new
        NameTable.put(MD5_oid, "MD5")
        NameTable.put(MD2_oid, "MD2")
        NameTable.put(SHA_oid, "SHA")
        NameTable.put(SHA256_oid, "SHA256")
        NameTable.put(SHA384_oid, "SHA384")
        NameTable.put(SHA512_oid, "SHA512")
        NameTable.put(RSAEncryption_oid, "RSA")
        NameTable.put(RSA_oid, "RSA")
        NameTable.put(DH_oid, "Diffie-Hellman")
        NameTable.put(DH_PKIX_oid, "Diffie-Hellman")
        NameTable.put(DSA_oid, "DSA")
        NameTable.put(DSA_OIW_oid, "DSA")
        NameTable.put(EC_oid, "EC")
        NameTable.put(Sha1WithECDSA_oid, "SHA1withECDSA")
        NameTable.put(Sha224WithECDSA_oid, "SHA224withECDSA")
        NameTable.put(Sha256WithECDSA_oid, "SHA256withECDSA")
        NameTable.put(Sha384WithECDSA_oid, "SHA384withECDSA")
        NameTable.put(Sha512WithECDSA_oid, "SHA512withECDSA")
        NameTable.put(Md5WithRSAEncryption_oid, "MD5withRSA")
        NameTable.put(Md2WithRSAEncryption_oid, "MD2withRSA")
        NameTable.put(Sha1WithDSA_oid, "SHA1withDSA")
        NameTable.put(Sha1WithDSA_OIW_oid, "SHA1withDSA")
        NameTable.put(ShaWithDSA_OIW_oid, "SHA1withDSA")
        NameTable.put(Sha1WithRSAEncryption_oid, "SHA1withRSA")
        NameTable.put(Sha1WithRSAEncryption_OIW_oid, "SHA1withRSA")
        NameTable.put(Sha256WithRSAEncryption_oid, "SHA256withRSA")
        NameTable.put(Sha384WithRSAEncryption_oid, "SHA384withRSA")
        NameTable.put(Sha512WithRSAEncryption_oid, "SHA512withRSA")
        NameTable.put(PbeWithMD5AndDES_oid, "PBEWithMD5AndDES")
        NameTable.put(PbeWithMD5AndRC2_oid, "PBEWithMD5AndRC2")
        NameTable.put(PbeWithSHA1AndDES_oid, "PBEWithSHA1AndDES")
        NameTable.put(PbeWithSHA1AndRC2_oid, "PBEWithSHA1AndRC2")
        NameTable.put(self.attr_pbe_with_sha1and_desede_oid, "PBEWithSHA1AndDESede")
        NameTable.put(self.attr_pbe_with_sha1and_rc2_40_oid, "PBEWithSHA1AndRC2_40")
      end
    }
    
    private
    alias_method :initialize__algorithm_id, :initialize
  end
  
end
