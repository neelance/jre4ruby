require "rjava"

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
  module ManifestEntryVerifierImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include ::Java::Security
      include ::Java::Io
      include_const ::Java::Security, :CodeSigner
      include ::Java::Util
      include ::Java::Util::Jar
      include_const ::Sun::Misc, :BASE64Decoder
      include_const ::Sun::Security::Jca, :Providers
    }
  end
  
  # This class is used to verify each entry in a jar file with its
  # manifest value.
  class ManifestEntryVerifier 
    include_class_members ManifestEntryVerifierImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("jar") }
      const_attr_reader  :Debug
      
      const_set_lazy(:DigestProvider) { Providers.get_sun_provider }
      const_attr_reader  :DigestProvider
    }
    
    # the created digest objects
    attr_accessor :created_digests
    alias_method :attr_created_digests, :created_digests
    undef_method :created_digests
    alias_method :attr_created_digests=, :created_digests=
    undef_method :created_digests=
    
    # the digests in use for a given entry
    attr_accessor :digests
    alias_method :attr_digests, :digests
    undef_method :digests
    alias_method :attr_digests=, :digests=
    undef_method :digests=
    
    # the manifest hashes for the digests in use
    attr_accessor :manifest_hashes
    alias_method :attr_manifest_hashes, :manifest_hashes
    undef_method :manifest_hashes
    alias_method :attr_manifest_hashes=, :manifest_hashes=
    undef_method :manifest_hashes=
    
    attr_accessor :decoder
    alias_method :attr_decoder, :decoder
    undef_method :decoder
    alias_method :attr_decoder=, :decoder=
    undef_method :decoder=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :man
    alias_method :attr_man, :man
    undef_method :man
    alias_method :attr_man=, :man=
    undef_method :man=
    
    attr_accessor :skip
    alias_method :attr_skip, :skip
    undef_method :skip
    alias_method :attr_skip=, :skip=
    undef_method :skip=
    
    attr_accessor :entry
    alias_method :attr_entry, :entry
    undef_method :entry
    alias_method :attr_entry=, :entry=
    undef_method :entry=
    
    attr_accessor :signers
    alias_method :attr_signers, :signers
    undef_method :signers
    alias_method :attr_signers=, :signers=
    undef_method :signers=
    
    typesig { [Manifest] }
    # Create a new ManifestEntryVerifier object.
    def initialize(man)
      @created_digests = nil
      @digests = nil
      @manifest_hashes = nil
      @decoder = nil
      @name = nil
      @man = nil
      @skip = true
      @entry = nil
      @signers = nil
      @created_digests = HashMap.new(11)
      @digests = ArrayList.new
      @manifest_hashes = ArrayList.new
      @decoder = BASE64Decoder.new
      @man = man
    end
    
    typesig { [String, JarEntry] }
    # Find the hashes in the
    # manifest for this entry, save them, and set the MessageDigest
    # objects to calculate the hashes on the fly. If name is
    # null it signifies that update/verify should ignore this entry.
    def set_entry(name, entry)
      @digests.clear
      @manifest_hashes.clear
      @name = name
      @entry = entry
      @skip = true
      @signers = nil
      if ((@man).nil? || (name).nil?)
        return
      end
      # get the headers from the manifest for this entry
      # if there aren't any, we can't verify any digests for this entry
      attr = @man.get_attributes(name)
      if ((attr).nil?)
        # ugh. we should be able to remove this at some point.
        # there are broken jars floating around with ./name and /name
        # in the manifest, and "name" in the zip/jar file.
        attr = @man.get_attributes("./" + name)
        if ((attr).nil?)
          attr = @man.get_attributes("/" + name)
          if ((attr).nil?)
            return
          end
        end
      end
      attr.entry_set.each do |se|
        key = se.get_key.to_s
        if (key.to_upper_case(Locale::ENGLISH).ends_with("-DIGEST"))
          # 7 is length of "-Digest"
          algorithm = key.substring(0, key.length - 7)
          digest = @created_digests.get(algorithm)
          if ((digest).nil?)
            begin
              digest = MessageDigest.get_instance(algorithm, DigestProvider)
              @created_digests.put(algorithm, digest)
            rescue NoSuchAlgorithmException => nsae
              # ignore
            end
          end
          if (!(digest).nil?)
            @skip = false
            digest.reset
            @digests.add(digest)
            @manifest_hashes.add(@decoder.decode_buffer(se.get_value))
          end
        end
      end
    end
    
    typesig { [::Java::Byte] }
    # update the digests for the digests we are interested in
    def update(buffer)
      if (@skip)
        return
      end
      i = 0
      while i < @digests.size
        @digests.get(i).update(buffer)
        i += 1
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # update the digests for the digests we are interested in
    def update(buffer, off, len)
      if (@skip)
        return
      end
      i = 0
      while i < @digests.size
        @digests.get(i).update(buffer, off, len)
        i += 1
      end
    end
    
    typesig { [] }
    # get the JarEntry for this object
    def get_entry
      return @entry
    end
    
    typesig { [Hashtable, Hashtable] }
    # go through all the digests, calculating the final digest
    # and comparing it to the one in the manifest. If this is
    # the first time we have verified this object, remove its
    # code signers from sigFileSigners and place in verifiedSigners.
    def verify(verified_signers, sig_file_signers)
      if (@skip)
        return nil
      end
      if (!(@signers).nil?)
        return @signers
      end
      i = 0
      while i < @digests.size
        digest = @digests.get(i)
        man_hash = @manifest_hashes.get(i)
        the_hash = digest.digest
        if (!(Debug).nil?)
          Debug.println("Manifest Entry: " + @name + " digest=" + RJava.cast_to_string(digest.get_algorithm))
          Debug.println("  manifest " + RJava.cast_to_string(to_hex(man_hash)))
          Debug.println("  computed " + RJava.cast_to_string(to_hex(the_hash)))
          Debug.println
        end
        if (!MessageDigest.is_equal(the_hash, man_hash))
          raise SecurityException.new(RJava.cast_to_string(digest.get_algorithm) + " digest error for " + @name)
        end
        i += 1
      end
      # take it out of sigFileSigners and put it in verifiedSigners...
      @signers = sig_file_signers.remove(@name)
      if (!(@signers).nil?)
        verified_signers.put(@name, @signers)
      end
      return @signers
    end
    
    class_module.module_eval {
      # for the toHex function
      const_set_lazy(:Hexc) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?a.ord), Character.new(?b.ord), Character.new(?c.ord), Character.new(?d.ord), Character.new(?e.ord), Character.new(?f.ord)]) }
      const_attr_reader  :Hexc
      
      typesig { [Array.typed(::Java::Byte)] }
      # convert a byte array to a hex string for debugging purposes
      # @param data the binary data to be converted to a hex string
      # @return an ASCII hex string
      def to_hex(data)
        sb = StringBuffer.new(data.attr_length * 2)
        i = 0
        while i < data.attr_length
          sb.append(Hexc[(data[i] >> 4) & 0xf])
          sb.append(Hexc[data[i] & 0xf])
          i += 1
        end
        return sb.to_s
      end
    }
    
    private
    alias_method :initialize__manifest_entry_verifier, :initialize
  end
  
end
