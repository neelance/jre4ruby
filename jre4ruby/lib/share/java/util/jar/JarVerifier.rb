require "rjava"

# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Jar
  module JarVerifierImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Jar
      include ::Java::Io
      include ::Java::Util
      include ::Java::Util::Zip
      include ::Java::Security
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Sun::Security::Util, :ManifestDigester
      include_const ::Sun::Security::Util, :ManifestEntryVerifier
      include_const ::Sun::Security::Util, :SignatureFileVerifier
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # @author      Roland Schemers
  class JarVerifier 
    include_class_members JarVerifierImports
    
    class_module.module_eval {
      # Are we debugging ?
      const_set_lazy(:Debug) { Debug.get_instance("jar") }
      const_attr_reader  :Debug
    }
    
    # a table mapping names to code signers, for jar entries that have
    # had their actual hashes verified
    attr_accessor :verified_signers
    alias_method :attr_verified_signers, :verified_signers
    undef_method :verified_signers
    alias_method :attr_verified_signers=, :verified_signers=
    undef_method :verified_signers=
    
    # a table mapping names to code signers, for jar entries that have
    # passed the .SF/.DSA -> MANIFEST check
    attr_accessor :sig_file_signers
    alias_method :attr_sig_file_signers, :sig_file_signers
    undef_method :sig_file_signers
    alias_method :attr_sig_file_signers=, :sig_file_signers=
    undef_method :sig_file_signers=
    
    # a hash table to hold .SF bytes
    attr_accessor :sig_file_data
    alias_method :attr_sig_file_data, :sig_file_data
    undef_method :sig_file_data
    alias_method :attr_sig_file_data=, :sig_file_data=
    undef_method :sig_file_data=
    
    # "queue" of pending PKCS7 blocks that we couldn't parse
    # until we parsed the .SF file
    attr_accessor :pending_blocks
    alias_method :attr_pending_blocks, :pending_blocks
    undef_method :pending_blocks
    alias_method :attr_pending_blocks=, :pending_blocks=
    undef_method :pending_blocks=
    
    # cache of CodeSigner objects
    attr_accessor :signer_cache
    alias_method :attr_signer_cache, :signer_cache
    undef_method :signer_cache
    alias_method :attr_signer_cache=, :signer_cache=
    undef_method :signer_cache=
    
    # Are we parsing a block?
    attr_accessor :parsing_block_or_sf
    alias_method :attr_parsing_block_or_sf, :parsing_block_or_sf
    undef_method :parsing_block_or_sf
    alias_method :attr_parsing_block_or_sf=, :parsing_block_or_sf=
    undef_method :parsing_block_or_sf=
    
    # Are we done parsing META-INF entries?
    attr_accessor :parsing_meta
    alias_method :attr_parsing_meta, :parsing_meta
    undef_method :parsing_meta
    alias_method :attr_parsing_meta=, :parsing_meta=
    undef_method :parsing_meta=
    
    # Are there are files to verify?
    attr_accessor :any_to_verify
    alias_method :attr_any_to_verify, :any_to_verify
    undef_method :any_to_verify
    alias_method :attr_any_to_verify=, :any_to_verify=
    undef_method :any_to_verify=
    
    # The output stream to use when keeping track of files we are interested
    # in
    attr_accessor :baos
    alias_method :attr_baos, :baos
    undef_method :baos
    alias_method :attr_baos=, :baos=
    undef_method :baos=
    
    # The ManifestDigester object
    attr_accessor :man_dig
    alias_method :attr_man_dig, :man_dig
    undef_method :man_dig
    alias_method :attr_man_dig=, :man_dig=
    undef_method :man_dig=
    
    # the bytes for the manDig object
    attr_accessor :manifest_raw_bytes
    alias_method :attr_manifest_raw_bytes, :manifest_raw_bytes
    undef_method :manifest_raw_bytes
    alias_method :attr_manifest_raw_bytes=, :manifest_raw_bytes=
    undef_method :manifest_raw_bytes=
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(raw_bytes)
      @verified_signers = nil
      @sig_file_signers = nil
      @sig_file_data = nil
      @pending_blocks = nil
      @signer_cache = nil
      @parsing_block_or_sf = false
      @parsing_meta = true
      @any_to_verify = true
      @baos = nil
      @man_dig = nil
      @manifest_raw_bytes = nil
      @manifest_raw_bytes = raw_bytes
      @sig_file_signers = Hashtable.new
      @verified_signers = Hashtable.new
      @sig_file_data = Hashtable.new(11)
      @pending_blocks = ArrayList.new
      @baos = ByteArrayOutputStream.new
    end
    
    typesig { [JarEntry, ManifestEntryVerifier] }
    # This method scans to see which entry we're parsing and
    # keeps various state information depending on what type of
    # file is being parsed.
    def begin_entry(je, mev)
      if ((je).nil?)
        return
      end
      if (!(Debug).nil?)
        Debug.println("beginEntry " + RJava.cast_to_string(je.get_name))
      end
      name = je.get_name
      # Assumptions:
      # 1. The manifest should be the first entry in the META-INF directory.
      # 2. The .SF/.DSA files follow the manifest, before any normal entries
      # 3. Any of the following will throw a SecurityException:
      # a. digest mismatch between a manifest section and
      # the SF section.
      # b. digest mismatch between the actual jar entry and the manifest
      if (@parsing_meta)
        uname = name.to_upper_case(Locale::ENGLISH)
        if ((uname.starts_with("META-INF/") || uname.starts_with("/META-INF/")))
          if (je.is_directory)
            mev.set_entry(nil, je)
            return
          end
          if (SignatureFileVerifier.is_block_or_sf(uname))
            # We parse only DSA or RSA PKCS7 blocks.
            @parsing_block_or_sf = true
            @baos.reset
            mev.set_entry(nil, je)
          end
          return
        end
      end
      if (@parsing_meta)
        done_with_meta
      end
      if (je.is_directory)
        mev.set_entry(nil, je)
        return
      end
      # be liberal in what you accept. If the name starts with ./, remove
      # it as we internally canonicalize it with out the ./.
      if (name.starts_with("./"))
        name = RJava.cast_to_string(name.substring(2))
      end
      # be liberal in what you accept. If the name starts with /, remove
      # it as we internally canonicalize it with out the /.
      if (name.starts_with("/"))
        name = RJava.cast_to_string(name.substring(1))
      end
      # only set the jev object for entries that have a signature
      if (!(@sig_file_signers.get(name)).nil?)
        mev.set_entry(name, je)
        return
      end
      # don't compute the digest for this entry
      mev.set_entry(nil, je)
      return
    end
    
    typesig { [::Java::Int, ManifestEntryVerifier] }
    # update a single byte.
    def update(b, mev)
      if (!(b).equal?(-1))
        if (@parsing_block_or_sf)
          @baos.write(b)
        else
          mev.update(b)
        end
      else
        process_entry(mev)
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ManifestEntryVerifier] }
    # update an array of bytes.
    def update(n, b, off, len, mev)
      if (!(n).equal?(-1))
        if (@parsing_block_or_sf)
          @baos.write(b, off, n)
        else
          mev.update(b, off, n)
        end
      else
        process_entry(mev)
      end
    end
    
    typesig { [ManifestEntryVerifier] }
    # called when we reach the end of entry in one of the read() methods.
    def process_entry(mev)
      if (!@parsing_block_or_sf)
        je = mev.get_entry
        if ((!(je).nil?) && ((je.attr_signers).nil?))
          je.attr_signers = mev.verify(@verified_signers, @sig_file_signers)
          je.attr_certs = map_signers_to_cert_array(je.attr_signers)
        end
      else
        begin
          @parsing_block_or_sf = false
          if (!(Debug).nil?)
            Debug.println("processEntry: processing block")
          end
          uname = mev.get_entry.get_name.to_upper_case(Locale::ENGLISH)
          if (uname.ends_with(".SF"))
            key = uname.substring(0, uname.length - 3)
            bytes = @baos.to_byte_array
            # add to sigFileData in case future blocks need it
            @sig_file_data.put(key, bytes)
            # check pending blocks, we can now process
            # anyone waiting for this .SF file
            it = @pending_blocks.iterator
            while (it.has_next)
              sfv = it.next_
              if (sfv.need_signature_file(key))
                if (!(Debug).nil?)
                  Debug.println("processEntry: processing pending block")
                end
                sfv.set_signature_file(bytes)
                sfv.process(@sig_file_signers)
              end
            end
            return
          end
          # now we are parsing a signature block file
          key = uname.substring(0, uname.last_index_of("."))
          if ((@signer_cache).nil?)
            @signer_cache = ArrayList.new
          end
          if ((@man_dig).nil?)
            synchronized((@manifest_raw_bytes)) do
              if ((@man_dig).nil?)
                @man_dig = ManifestDigester.new(@manifest_raw_bytes)
                @manifest_raw_bytes = nil
              end
            end
          end
          sfv = SignatureFileVerifier.new(@signer_cache, @man_dig, uname, @baos.to_byte_array)
          if (sfv.need_signature_file_bytes)
            # see if we have already parsed an external .SF file
            bytes = @sig_file_data.get(key)
            if ((bytes).nil?)
              # put this block on queue for later processing
              # since we don't have the .SF bytes yet
              # (uname, block);
              if (!(Debug).nil?)
                Debug.println("adding pending block")
              end
              @pending_blocks.add(sfv)
              return
            else
              sfv.set_signature_file(bytes)
            end
          end
          sfv.process(@sig_file_signers)
        rescue Sun::Security::Pkcs::ParsingException => pe
          if (!(Debug).nil?)
            Debug.println("processEntry caught: " + RJava.cast_to_string(pe))
          end
          # ignore and treat as unsigned
        rescue IOException => ioe
          if (!(Debug).nil?)
            Debug.println("processEntry caught: " + RJava.cast_to_string(ioe))
          end
          # ignore and treat as unsigned
        rescue SignatureException => se
          if (!(Debug).nil?)
            Debug.println("processEntry caught: " + RJava.cast_to_string(se))
          end
          # ignore and treat as unsigned
        rescue NoSuchAlgorithmException => nsae
          if (!(Debug).nil?)
            Debug.println("processEntry caught: " + RJava.cast_to_string(nsae))
          end
          # ignore and treat as unsigned
        rescue CertificateException => ce
          if (!(Debug).nil?)
            Debug.println("processEntry caught: " + RJava.cast_to_string(ce))
          end
          # ignore and treat as unsigned
        end
      end
    end
    
    typesig { [String] }
    # Return an array of java.security.cert.Certificate objects for
    # the given file in the jar.
    def get_certs(name)
      return map_signers_to_cert_array(get_code_signers(name))
    end
    
    typesig { [String] }
    # return an array of CodeSigner objects for
    # the given file in the jar. this array is not cloned.
    def get_code_signers(name)
      return @verified_signers.get(name)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(CodeSigner)] }
      # Convert an array of signers into an array of concatenated certificate
      # arrays.
      def map_signers_to_cert_array(signers)
        if (!(signers).nil?)
          cert_chains = ArrayList.new
          i = 0
          while i < signers.attr_length
            cert_chains.add_all(signers[i].get_signer_cert_path.get_certificates)
            i += 1
          end
          # Convert into a Certificate[]
          return cert_chains.to_array(Array.typed(Java::Security::Cert::Certificate).new(cert_chains.size) { nil })
        end
        return nil
      end
    }
    
    typesig { [] }
    # returns true if there no files to verify.
    # should only be called after all the META-INF entries
    # have been processed.
    def nothing_to_verify
      return ((@any_to_verify).equal?(false))
    end
    
    typesig { [] }
    # called to let us know we have processed all the
    # META-INF entries, and if we re-read one of them, don't
    # re-process it. Also gets rid of any data structures
    # we needed when parsing META-INF entries.
    def done_with_meta
      @parsing_meta = false
      @any_to_verify = !@sig_file_signers.is_empty
      @baos = nil
      @sig_file_data = nil
      @pending_blocks = nil
      @signer_cache = nil
      @man_dig = nil
    end
    
    class_module.module_eval {
      const_set_lazy(:VerifierStream) { Class.new(Java::Io::InputStream) do
        include_class_members JarVerifier
        
        attr_accessor :is
        alias_method :attr_is, :is
        undef_method :is
        alias_method :attr_is=, :is=
        undef_method :is=
        
        attr_accessor :jv
        alias_method :attr_jv, :jv
        undef_method :jv
        alias_method :attr_jv=, :jv=
        undef_method :jv=
        
        attr_accessor :mev
        alias_method :attr_mev, :mev
        undef_method :mev
        alias_method :attr_mev=, :mev=
        undef_method :mev=
        
        attr_accessor :num_left
        alias_method :attr_num_left, :num_left
        undef_method :num_left
        alias_method :attr_num_left=, :num_left=
        undef_method :num_left=
        
        typesig { [self::Manifest, self::JarEntry, self::InputStream, self::JarVerifier] }
        def initialize(man, je, is, jv)
          @is = nil
          @jv = nil
          @mev = nil
          @num_left = 0
          super()
          @is = is
          @jv = jv
          @mev = self.class::ManifestEntryVerifier.new(man)
          @jv.begin_entry(je, @mev)
          @num_left = je.get_size
          if ((@num_left).equal?(0))
            @jv.update(-1, @mev)
          end
        end
        
        typesig { [] }
        def read
          if (@num_left > 0)
            b = @is.read
            @jv.update(b, @mev)
            @num_left -= 1
            if ((@num_left).equal?(0))
              @jv.update(-1, @mev)
            end
            return b
          else
            return -1
          end
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, len)
          if ((@num_left > 0) && (@num_left < len))
            len = RJava.cast_to_int(@num_left)
          end
          if (@num_left > 0)
            n = @is.read(b, off, len)
            @jv.update(n, b, off, len, @mev)
            @num_left -= n
            if ((@num_left).equal?(0))
              @jv.update(-1, b, off, len, @mev)
            end
            return n
          else
            return -1
          end
        end
        
        typesig { [] }
        def close
          if (!(@is).nil?)
            @is.close
          end
          @is = nil
          @mev = nil
          @jv = nil
        end
        
        typesig { [] }
        def available
          return @is.available
        end
        
        private
        alias_method :initialize__verifier_stream, :initialize
      end }
    }
    
    private
    alias_method :initialize__jar_verifier, :initialize
  end
  
end
