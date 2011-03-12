require "rjava"

# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module HandshakeHashImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Security
    }
  end
  
  # Abstraction for the SSL/TLS hash of all handshake messages that is
  # maintained to verify the integrity of the negotiation. Internally,
  # it consists of an MD5 and an SHA1 digest. They are used in the client
  # and server finished messages and in certificate verify messages (if sent).
  # 
  # This class transparently deals with cloneable and non-cloneable digests.
  class HandshakeHash 
    include_class_members HandshakeHashImports
    
    attr_accessor :md5
    alias_method :attr_md5, :md5
    undef_method :md5
    alias_method :attr_md5=, :md5=
    undef_method :md5=
    
    attr_accessor :sha
    alias_method :attr_sha, :sha
    undef_method :sha
    alias_method :attr_sha=, :sha=
    undef_method :sha=
    
    typesig { [::Java::Boolean] }
    # Create a new HandshakeHash. needCertificateVerify indicates whether
    # a hash for the certificate verify message is required.
    def initialize(need_certificate_verify)
      @md5 = nil
      @sha = nil
      n = need_certificate_verify ? 3 : 2
      begin
        @md5 = CloneableDigest.get_digest("MD5", n)
        @sha = CloneableDigest.get_digest("SHA", n)
      rescue NoSuchAlgorithmException => e
        raise RuntimeException.new("Algorithm MD5 or SHA not available", e)
      end
    end
    
    typesig { [::Java::Byte] }
    def update(b)
      @md5.update(b)
      @sha.update(b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def update(b, offset, len)
      @md5.update(b, offset, len)
      @sha.update(b, offset, len)
    end
    
    typesig { [] }
    # Reset the remaining digests. Note this does *not* reset the numbe of
    # digest clones that can be obtained. Digests that have already been
    # cloned and are gone remain gone.
    def reset
      @md5.reset
      @sha.reset
    end
    
    typesig { [] }
    # Return a new MD5 digest updated with all data hashed so far.
    def get_md5clone
      return clone_digest(@md5)
    end
    
    typesig { [] }
    # Return a new SHA digest updated with all data hashed so far.
    def get_shaclone
      return clone_digest(@sha)
    end
    
    class_module.module_eval {
      typesig { [MessageDigest] }
      def clone_digest(digest)
        begin
          return digest.clone
        rescue CloneNotSupportedException => e
          # cannot occur for digests generated via CloneableDigest
          raise RuntimeException.new("Could not clone digest", e)
        end
      end
    }
    
    private
    alias_method :initialize__handshake_hash, :initialize
  end
  
  # A wrapper for MessageDigests that simulates cloning of non-cloneable
  # digests. It uses the standard MessageDigest API and therefore can be used
  # transparently in place of a regular digest.
  # 
  # Note that we extend the MessageDigest class directly rather than
  # MessageDigestSpi. This works because MessageDigest was originally designed
  # this way in the JDK 1.1 days which allows us to avoid creating an internal
  # provider.
  # 
  # It can be "cloned" a limited number of times, which is specified at
  # construction time. This is achieved by internally maintaining n digests
  # in parallel. Consequently, it is only 1/n-th times as fast as the original
  # digest.
  # 
  # Example:
  #   MessageDigest md = CloneableDigest.getDigest("SHA", 2);
  #   md.update(data1);
  #   MessageDigest md2 = (MessageDigest)md.clone();
  #   md2.update(data2);
  #   byte[] d1 = md2.digest(); // digest of data1 || data2
  #   md.update(data3);
  #   byte[] d2 = md.digest();  // digest of data1 || data3
  # 
  # This class is not thread safe.
  class CloneableDigest < HandshakeHashImports.const_get :MessageDigest
    include_class_members HandshakeHashImports
    overload_protected {
      include Cloneable
    }
    
    # The individual MessageDigests. Initially, all elements are non-null.
    # When clone() is called, the non-null element with the maximum index is
    # returned and the array element set to null.
    # 
    # All non-null element are always in the same state.
    attr_accessor :digests
    alias_method :attr_digests, :digests
    undef_method :digests
    alias_method :attr_digests=, :digests=
    undef_method :digests=
    
    typesig { [MessageDigest, ::Java::Int, String] }
    def initialize(digest, n, algorithm)
      @digests = nil
      super(algorithm)
      @digests = Array.typed(MessageDigest).new(n) { nil }
      @digests[0] = digest
      i = 1
      while i < n
        @digests[i] = JsseJce.get_message_digest(algorithm)
        i += 1
      end
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Int] }
      # Return a MessageDigest for the given algorithm that can be cloned the
      # specified number of times. If the default implementation supports
      # cloning, it is returned. Otherwise, an instance of this class is
      # returned.
      def get_digest(algorithm, n)
        digest = JsseJce.get_message_digest(algorithm)
        begin
          digest.clone
          # already cloneable, use it
          return digest
        rescue CloneNotSupportedException => e
          return CloneableDigest.new(digest, n, algorithm)
        end
      end
    }
    
    typesig { [] }
    # Check if this object is still usable. If it has already been cloned the
    # maximum number of times, there are no digests left and this object can no
    # longer be used.
    def check_state
      # XXX handshaking currently doesn't stop updating hashes...
      # if (digests[0] == null) {
      #     throw new IllegalStateException("no digests left");
      # }
    end
    
    typesig { [] }
    def engine_get_digest_length
      check_state
      return @digests[0].get_digest_length
    end
    
    typesig { [::Java::Byte] }
    def engine_update(b)
      check_state
      i = 0
      while (i < @digests.attr_length) && (!(@digests[i]).nil?)
        @digests[i].update(b)
        i += 1
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def engine_update(b, offset, len)
      check_state
      i = 0
      while (i < @digests.attr_length) && (!(@digests[i]).nil?)
        @digests[i].update(b, offset, len)
        i += 1
      end
    end
    
    typesig { [] }
    def engine_digest
      check_state
      digest_ = @digests[0].digest
      digest_reset
      return digest_
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def engine_digest(buf, offset, len)
      check_state
      n = @digests[0].digest(buf, offset, len)
      digest_reset
      return n
    end
    
    typesig { [] }
    # Reset all digests after a digest() call. digests[0] has already been
    # implicitly reset by the digest() call and does not need to be reset
    # again.
    def digest_reset
      i = 1
      while (i < @digests.attr_length) && (!(@digests[i]).nil?)
        @digests[i].reset
        i += 1
      end
    end
    
    typesig { [] }
    def engine_reset
      check_state
      i = 0
      while (i < @digests.attr_length) && (!(@digests[i]).nil?)
        @digests[i].reset
        i += 1
      end
    end
    
    typesig { [] }
    def clone
      check_state
      i = @digests.attr_length - 1
      while i >= 0
        if (!(@digests[i]).nil?)
          digest_ = @digests[i]
          @digests[i] = nil
          return digest_
        end
        i -= 1
      end
      # cannot occur
      raise InternalError.new
    end
    
    private
    alias_method :initialize__cloneable_digest, :initialize
  end
  
end
