require "rjava"

# 
# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module SignatureFileVerifierImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Security, :CodeSigner
      include_const ::Java::Security::Cert, :CertPath
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateFactory
      include ::Java::Security
      include ::Java::Io
      include ::Java::Util
      include ::Java::Util::Jar
      include_const ::Java::Io, :ByteArrayOutputStream
      include ::Sun::Security::Pkcs
      include_const ::Sun::Security::Timestamp, :TimestampToken
      include_const ::Sun::Misc, :BASE64Decoder
      include_const ::Sun::Security::Jca, :Providers
    }
  end
  
  class SignatureFileVerifier 
    include_class_members SignatureFileVerifierImports
    
    class_module.module_eval {
      # Are we debugging ?
      const_set_lazy(:Debug) { Debug.get_instance("jar") }
      const_attr_reader  :Debug
    }
    
    # cache of CodeSigner objects
    attr_accessor :signer_cache
    alias_method :attr_signer_cache, :signer_cache
    undef_method :signer_cache
    alias_method :attr_signer_cache=, :signer_cache=
    undef_method :signer_cache=
    
    class_module.module_eval {
      const_set_lazy(:ATTR_DIGEST) { ("-DIGEST-" + (ManifestDigester::MF_MAIN_ATTRS).to_s).to_upper_case(Locale::ENGLISH) }
      const_attr_reader  :ATTR_DIGEST
    }
    
    # the PKCS7 block for this .DSA/.RSA file
    attr_accessor :block
    alias_method :attr_block, :block
    undef_method :block
    alias_method :attr_block=, :block=
    undef_method :block=
    
    # the raw bytes of the .SF file
    attr_accessor :sf_bytes
    alias_method :attr_sf_bytes, :sf_bytes
    undef_method :sf_bytes
    alias_method :attr_sf_bytes=, :sf_bytes=
    undef_method :sf_bytes=
    
    # the name of the signature block file, uppercased and without
    # the extension (.DSA/.RSA)
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # the ManifestDigester
    attr_accessor :md
    alias_method :attr_md, :md
    undef_method :md
    alias_method :attr_md=, :md=
    undef_method :md=
    
    # cache of created MessageDigest objects
    attr_accessor :created_digests
    alias_method :attr_created_digests, :created_digests
    undef_method :created_digests
    alias_method :attr_created_digests=, :created_digests=
    undef_method :created_digests=
    
    # workaround for parsing Netscape jars
    attr_accessor :workaround
    alias_method :attr_workaround, :workaround
    undef_method :workaround
    alias_method :attr_workaround=, :workaround=
    undef_method :workaround=
    
    # for generating certpath objects
    attr_accessor :certificate_factory
    alias_method :attr_certificate_factory, :certificate_factory
    undef_method :certificate_factory
    alias_method :attr_certificate_factory=, :certificate_factory=
    undef_method :certificate_factory=
    
    typesig { [ArrayList, ManifestDigester, String, Array.typed(::Java::Byte)] }
    # 
    # Create the named SignatureFileVerifier.
    # 
    # @param name the name of the signature block file (.DSA/.RSA)
    # 
    # @param rawBytes the raw bytes of the signature block file
    def initialize(signer_cache, md, name, raw_bytes)
      @signer_cache = nil
      @block = nil
      @sf_bytes = nil
      @name = nil
      @md = nil
      @created_digests = nil
      @workaround = false
      @certificate_factory = nil
      # new PKCS7() calls CertificateFactory.getInstance()
      # need to use local providers here, see Providers class
      obj = nil
      begin
        obj = Providers.start_jar_verification
        @block = PKCS7.new(raw_bytes)
        @sf_bytes = @block.get_content_info.get_data
        @certificate_factory = CertificateFactory.get_instance("X509")
      ensure
        Providers.stop_jar_verification(obj)
      end
      @name = name.substring(0, name.last_index_of(".")).to_upper_case(Locale::ENGLISH)
      @md = md
      @signer_cache = signer_cache
    end
    
    typesig { [] }
    # 
    # returns true if we need the .SF file
    def need_signature_file_bytes
      return (@sf_bytes).nil?
    end
    
    typesig { [String] }
    # 
    # returns true if we need this .SF file.
    # 
    # @param name the name of the .SF file without the extension
    def need_signature_file(name)
      return @name.equals_ignore_case(name)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # used to set the raw bytes of the .SF file when it
    # is external to the signature block file.
    def set_signature_file(sf_bytes)
      @sf_bytes = sf_bytes
    end
    
    class_module.module_eval {
      typesig { [String] }
      # 
      # Utility method used by JarVerifier and JarSigner
      # to determine the signature file names and PKCS7 block
      # files names that are supported
      # 
      # @param s file name
      # @return true if the input file name is a supported
      # Signature File or PKCS7 block file name
      def is_block_or_sf(s)
        # we currently only support DSA and RSA PKCS7 blocks
        if (s.ends_with(".SF") || s.ends_with(".DSA") || s.ends_with(".RSA"))
          return true
        end
        return false
      end
    }
    
    typesig { [String] }
    # get digest from cache
    def get_digest(algorithm)
      if ((@created_digests).nil?)
        @created_digests = HashMap.new
      end
      digest = @created_digests.get(algorithm)
      if ((digest).nil?)
        begin
          digest = MessageDigest.get_instance(algorithm)
          @created_digests.put(algorithm, digest)
        rescue NoSuchAlgorithmException => nsae
          # ignore
        end
      end
      return digest
    end
    
    typesig { [Hashtable] }
    # 
    # process the signature block file. Goes through the .SF file
    # and adds code signers for each section where the .SF section
    # hash was verified against the Manifest section.
    def process(signers)
      # calls Signature.getInstance() and MessageDigest.getInstance()
      # need to use local providers here, see Providers class
      obj = nil
      begin
        obj = Providers.start_jar_verification
        process_impl(signers)
      ensure
        Providers.stop_jar_verification(obj)
      end
    end
    
    typesig { [Hashtable] }
    def process_impl(signers)
      sf = Manifest.new
      sf.read(ByteArrayInputStream.new(@sf_bytes))
      version = sf.get_main_attributes.get_value(Attributes::Name::SIGNATURE_VERSION)
      if (((version).nil?) || !(version.equals_ignore_case("1.0")))
        # XXX: should this be an exception?
        # for now we just ignore this signature file
        return
      end
      infos = @block.verify(@sf_bytes)
      if ((infos).nil?)
        raise SecurityException.new("cannot verify signature block file " + @name)
      end
      decoder = BASE64Decoder.new
      new_signers = get_signers(infos, @block)
      # make sure we have something to do all this work for...
      if ((new_signers).nil?)
        return
      end
      entries = sf.get_entries.entry_set.iterator
      # see if we can verify the whole manifest first
      manifest_signed = verify_manifest_hash(sf, @md, decoder)
      # verify manifest main attributes
      if (!manifest_signed && !verify_manifest_main_attrs(sf, @md, decoder))
        raise SecurityException.new("Invalid signature file digest for Manifest main attributes")
      end
      # go through each section in the signature file
      while (entries.has_next)
        e = entries.next
        name = e.get_key
        if (manifest_signed || (verify_section(e.get_value, name, @md, decoder)))
          if (name.starts_with("./"))
            name = (name.substring(2)).to_s
          end
          if (name.starts_with("/"))
            name = (name.substring(1)).to_s
          end
          update_signers(new_signers, signers, name)
          if (!(Debug).nil?)
            Debug.println("processSignature signed name = " + name)
          end
        else
          if (!(Debug).nil?)
            Debug.println("processSignature unsigned name = " + name)
          end
        end
      end
    end
    
    typesig { [Manifest, ManifestDigester, BASE64Decoder] }
    # 
    # See if the whole manifest was signed.
    def verify_manifest_hash(sf, md, decoder)
      mattr = sf.get_main_attributes
      manifest_signed = false
      # go through all the attributes and process *-Digest-Manifest entries
      mattr.entry_set.each do |se|
        key = se.get_key.to_s
        if (key.to_upper_case(Locale::ENGLISH).ends_with("-DIGEST-MANIFEST"))
          # 16 is length of "-Digest-Manifest"
          algorithm = key.substring(0, key.length - 16)
          digest = get_digest(algorithm)
          if (!(digest).nil?)
            computed_hash = md.manifest_digest(digest)
            expected_hash = decoder.decode_buffer(se.get_value)
            if (!(Debug).nil?)
              Debug.println("Signature File: Manifest digest " + (digest.get_algorithm).to_s)
              Debug.println("  sigfile  " + (to_hex(expected_hash)).to_s)
              Debug.println("  computed " + (to_hex(computed_hash)).to_s)
              Debug.println
            end
            if (MessageDigest.is_equal(computed_hash, expected_hash))
              manifest_signed = true
            else
              # XXX: we will continue and verify each section
            end
          end
        end
      end
      return manifest_signed
    end
    
    typesig { [Manifest, ManifestDigester, BASE64Decoder] }
    def verify_manifest_main_attrs(sf, md, decoder)
      mattr = sf.get_main_attributes
      attrs_verified = true
      # go through all the attributes and process
      # digest entries for the manifest main attributes
      mattr.entry_set.each do |se|
        key = se.get_key.to_s
        if (key.to_upper_case(Locale::ENGLISH).ends_with(ATTR_DIGEST))
          algorithm = key.substring(0, key.length - ATTR_DIGEST.length)
          digest = get_digest(algorithm)
          if (!(digest).nil?)
            mde = md.get(ManifestDigester::MF_MAIN_ATTRS, false)
            computed_hash = mde.digest(digest)
            expected_hash = decoder.decode_buffer(se.get_value)
            if (!(Debug).nil?)
              Debug.println("Signature File: " + "Manifest Main Attributes digest " + (digest.get_algorithm).to_s)
              Debug.println("  sigfile  " + (to_hex(expected_hash)).to_s)
              Debug.println("  computed " + (to_hex(computed_hash)).to_s)
              Debug.println
            end
            if (MessageDigest.is_equal(computed_hash, expected_hash))
              # good
            else
              # we will *not* continue and verify each section
              attrs_verified = false
              if (!(Debug).nil?)
                Debug.println("Verification of " + "Manifest main attributes failed")
                Debug.println
              end
              break
            end
          end
        end
      end
      # this method returns 'true' if either:
      # . manifest main attributes were not signed, or
      # . manifest main attributes were signed and verified
      return attrs_verified
    end
    
    typesig { [Attributes, String, ManifestDigester, BASE64Decoder] }
    # 
    # given the .SF digest header, and the data from the
    # section in the manifest, see if the hashes match.
    # if not, throw a SecurityException.
    # 
    # @return true if all the -Digest headers verified
    # @exception SecurityException if the hash was not equal
    def verify_section(sf_attr, name, md, decoder)
      one_digest_verified = false
      mde = md.get(name, @block.is_old_style)
      if ((mde).nil?)
        raise SecurityException.new("no manifiest section for signature file entry " + name)
      end
      if (!(sf_attr).nil?)
        # sun.misc.HexDumpEncoder hex = new sun.misc.HexDumpEncoder();
        # hex.encodeBuffer(data, System.out);
        # go through all the attributes and process *-Digest entries
        sf_attr.entry_set.each do |se|
          key = se.get_key.to_s
          if (key.to_upper_case(Locale::ENGLISH).ends_with("-DIGEST"))
            # 7 is length of "-Digest"
            algorithm = key.substring(0, key.length - 7)
            digest_ = get_digest(algorithm)
            if (!(digest_).nil?)
              ok = false
              expected = decoder.decode_buffer(se.get_value)
              computed = nil
              if (@workaround)
                computed = mde.digest_workaround(digest_)
              else
                computed = mde.digest(digest_)
              end
              if (!(Debug).nil?)
                Debug.println("Signature Block File: " + name + " digest=" + (digest_.get_algorithm).to_s)
                Debug.println("  expected " + (to_hex(expected)).to_s)
                Debug.println("  computed " + (to_hex(computed)).to_s)
                Debug.println
              end
              if (MessageDigest.is_equal(computed, expected))
                one_digest_verified = true
                ok = true
              else
                # attempt to fallback to the workaround
                if (!@workaround)
                  computed = mde.digest_workaround(digest_)
                  if (MessageDigest.is_equal(computed, expected))
                    if (!(Debug).nil?)
                      Debug.println("  re-computed " + (to_hex(computed)).to_s)
                      Debug.println
                    end
                    @workaround = true
                    one_digest_verified = true
                    ok = true
                  end
                end
              end
              if (!ok)
                raise SecurityException.new("invalid " + (digest_.get_algorithm).to_s + " signature file digest for " + name)
              end
            end
          end
        end
      end
      return one_digest_verified
    end
    
    typesig { [Array.typed(SignerInfo), PKCS7] }
    # 
    # Given the PKCS7 block and SignerInfo[], create an array of
    # CodeSigner objects. We do this only *once* for a given
    # signature block file.
    def get_signers(infos, block)
      signers = nil
      i = 0
      while i < infos.attr_length
        info = infos[i]
        chain = info.get_certificate_chain(block)
        cert_chain = @certificate_factory.generate_cert_path(chain)
        if ((signers).nil?)
          signers = ArrayList.new
        end
        # Append the new code signer
        signers.add(CodeSigner.new(cert_chain, get_timestamp(info)))
        if (!(Debug).nil?)
          Debug.println("Signature Block Certificate: " + (chain.get(0)).to_s)
        end
        ((i += 1) - 1)
      end
      if (!(signers).nil?)
        return signers.to_array(Array.typed(CodeSigner).new(signers.size) { nil })
      else
        return nil
      end
    end
    
    typesig { [SignerInfo] }
    # 
    # Examines a signature timestamp token to generate a timestamp object.
    # 
    # Examines the signer's unsigned attributes for a
    # <tt>signatureTimestampToken</tt> attribute. If present,
    # then it is parsed to extract the date and time at which the
    # timestamp was generated.
    # 
    # @param info A signer information element of a PKCS 7 block.
    # 
    # @return A timestamp token or null if none is present.
    # @throws IOException if an error is encountered while parsing the
    # PKCS7 data.
    # @throws NoSuchAlgorithmException if an error is encountered while
    # verifying the PKCS7 object.
    # @throws SignatureException if an error is encountered while
    # verifying the PKCS7 object.
    # @throws CertificateException if an error is encountered while generating
    # the TSA's certpath.
    def get_timestamp(info)
      timestamp = nil
      # Extract the signer's unsigned attributes
      unsigned_attrs = info.get_unauthenticated_attributes
      if (!(unsigned_attrs).nil?)
        timestamp_token_attr = unsigned_attrs.get_attribute("signatureTimestampToken")
        if (!(timestamp_token_attr).nil?)
          timestamp_token = PKCS7.new(timestamp_token_attr.get_value)
          # Extract the content (an encoded timestamp token info)
          encoded_timestamp_token_info = timestamp_token.get_content_info.get_data
          # Extract the signer (the Timestamping Authority)
          # while verifying the content
          tsa = timestamp_token.verify(encoded_timestamp_token_info)
          # Expect only one signer
          chain = tsa[0].get_certificate_chain(timestamp_token)
          tsa_chain = @certificate_factory.generate_cert_path(chain)
          # Create a timestamp token info object
          timestamp_token_info = TimestampToken.new(encoded_timestamp_token_info)
          # Create a timestamp object
          timestamp = Timestamp.new(timestamp_token_info.get_date, tsa_chain)
        end
      end
      return timestamp
    end
    
    class_module.module_eval {
      # for the toHex function
      const_set_lazy(:Hexc) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord)]) }
      const_attr_reader  :Hexc
      
      typesig { [Array.typed(::Java::Byte)] }
      # 
      # convert a byte array to a hex string for debugging purposes
      # @param data the binary data to be converted to a hex string
      # @return an ASCII hex string
      def to_hex(data)
        sb = StringBuffer.new(data.attr_length * 2)
        i = 0
        while i < data.attr_length
          sb.append(Hexc[(data[i] >> 4) & 0xf])
          sb.append(Hexc[data[i] & 0xf])
          ((i += 1) - 1)
        end
        return sb.to_s
      end
      
      typesig { [Array.typed(CodeSigner), CodeSigner] }
      # returns true if set contains signer
      def contains(set, signer)
        i = 0
        while i < set.attr_length
          if ((set[i] == signer))
            return true
          end
          ((i += 1) - 1)
        end
        return false
      end
      
      typesig { [Array.typed(CodeSigner), Array.typed(CodeSigner)] }
      # returns true if subset is a subset of set
      def is_sub_set(subset, set)
        # check for the same object
        if ((set).equal?(subset))
          return true
        end
        match = false
        i = 0
        while i < subset.attr_length
          if (!contains(set, subset[i]))
            return false
          end
          ((i += 1) - 1)
        end
        return true
      end
      
      typesig { [Array.typed(CodeSigner), Array.typed(CodeSigner), Array.typed(CodeSigner)] }
      # 
      # returns true if signer contains exactly the same code signers as
      # oldSigner and newSigner, false otherwise. oldSigner
      # is allowed to be null.
      def matches(signers, old_signers, new_signers)
        # special case
        if (((old_signers).nil?) && ((signers).equal?(new_signers)))
          return true
        end
        match = false
        # make sure all oldSigners are in signers
        if ((!(old_signers).nil?) && !is_sub_set(old_signers, signers))
          return false
        end
        # make sure all newSigners are in signers
        if (!is_sub_set(new_signers, signers))
          return false
        end
        # now make sure all the code signers in signers are
        # also in oldSigners or newSigners
        i = 0
        while i < signers.attr_length
          found = ((!(old_signers).nil?) && contains(old_signers, signers[i])) || contains(new_signers, signers[i])
          if (!found)
            return false
          end
          ((i += 1) - 1)
        end
        return true
      end
    }
    
    typesig { [Array.typed(CodeSigner), Hashtable, String] }
    def update_signers(new_signers, signers, name)
      old_signers = signers.get(name)
      # search through the cache for a match, go in reverse order
      # as we are more likely to find a match with the last one
      # added to the cache
      cached_signers = nil
      i = @signer_cache.size - 1
      while !(i).equal?(-1)
        cached_signers = @signer_cache.get(i)
        if (matches(cached_signers, old_signers, new_signers))
          signers.put(name, cached_signers)
          return
        end
        ((i -= 1) + 1)
      end
      if ((old_signers).nil?)
        cached_signers = new_signers
      else
        cached_signers = Array.typed(CodeSigner).new(old_signers.attr_length + new_signers.attr_length) { nil }
        System.arraycopy(old_signers, 0, cached_signers, 0, old_signers.attr_length)
        System.arraycopy(new_signers, 0, cached_signers, old_signers.attr_length, new_signers.attr_length)
      end
      @signer_cache.add(cached_signers)
      signers.put(name, cached_signers)
    end
    
    private
    alias_method :initialize__signature_file_verifier, :initialize
  end
  
end
