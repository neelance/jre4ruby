require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Provider
  module DigestBaseImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Security, :MessageDigestSpi
      include_const ::Java::Security, :DigestException
      include_const ::Java::Security, :ProviderException
    }
  end
  
  # Common base message digest implementation for the Sun provider.
  # It implements all the JCA methods as suitable for a Java message digest
  # implementation of an algorithm based on a compression function (as all
  # commonly used algorithms are). The individual digest subclasses only need to
  # implement the following methods:
  # 
  # . abstract void implCompress(byte[] b, int ofs);
  # . abstract void implDigest(byte[] out, int ofs);
  # . abstract void implReset();
  # . public abstract Object clone();
  # 
  # See the inline documentation for details.
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class DigestBase < DigestBaseImports.const_get :MessageDigestSpi
    include_class_members DigestBaseImports
    include Cloneable
    
    # one element byte array, temporary storage for update(byte)
    attr_accessor :one_byte
    alias_method :attr_one_byte, :one_byte
    undef_method :one_byte
    alias_method :attr_one_byte=, :one_byte=
    undef_method :one_byte=
    
    # algorithm name to use in the exception message
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    # length of the message digest in bytes
    attr_accessor :digest_length
    alias_method :attr_digest_length, :digest_length
    undef_method :digest_length
    alias_method :attr_digest_length=, :digest_length=
    undef_method :digest_length=
    
    # size of the input to the compression function in bytes
    attr_accessor :block_size
    alias_method :attr_block_size, :block_size
    undef_method :block_size
    alias_method :attr_block_size=, :block_size=
    undef_method :block_size=
    
    # buffer to store partial blocks, blockSize bytes large
    # Subclasses should not access this array directly except possibly in their
    # implDigest() method. See MD5.java as an example.
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # offset into buffer
    attr_accessor :buf_ofs
    alias_method :attr_buf_ofs, :buf_ofs
    undef_method :buf_ofs
    alias_method :attr_buf_ofs=, :buf_ofs=
    undef_method :buf_ofs=
    
    # number of bytes processed so far. subclasses should not modify
    # this value.
    # also used as a flag to indicate reset status
    # -1: need to call engineReset() before next call to update()
    # 0: is already reset
    attr_accessor :bytes_processed
    alias_method :attr_bytes_processed, :bytes_processed
    undef_method :bytes_processed
    alias_method :attr_bytes_processed=, :bytes_processed=
    undef_method :bytes_processed=
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Main constructor.
    def initialize(algorithm, digest_length, block_size)
      @one_byte = nil
      @algorithm = nil
      @digest_length = 0
      @block_size = 0
      @buffer = nil
      @buf_ofs = 0
      @bytes_processed = 0
      super()
      @algorithm = algorithm
      @digest_length = digest_length
      @block_size = block_size
      @buffer = Array.typed(::Java::Byte).new(block_size) { 0 }
    end
    
    typesig { [DigestBase] }
    # Constructor for cloning. Replicates common data.
    def initialize(base)
      @one_byte = nil
      @algorithm = nil
      @digest_length = 0
      @block_size = 0
      @buffer = nil
      @buf_ofs = 0
      @bytes_processed = 0
      super()
      @algorithm = base.attr_algorithm
      @digest_length = base.attr_digest_length
      @block_size = base.attr_block_size
      @buffer = base.attr_buffer.clone
      @buf_ofs = base.attr_buf_ofs
      @bytes_processed = base.attr_bytes_processed
    end
    
    typesig { [] }
    # return digest length. See JCA doc.
    def engine_get_digest_length
      return @digest_length
    end
    
    typesig { [::Java::Byte] }
    # single byte update. See JCA doc.
    def engine_update(b)
      if ((@one_byte).nil?)
        @one_byte = Array.typed(::Java::Byte).new(1) { 0 }
      end
      @one_byte[0] = b
      engine_update(@one_byte, 0, 1)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # array update. See JCA doc.
    def engine_update(b, ofs, len)
      if ((len).equal?(0))
        return
      end
      if ((ofs < 0) || (len < 0) || (ofs > b.attr_length - len))
        raise ArrayIndexOutOfBoundsException.new
      end
      if (@bytes_processed < 0)
        engine_reset
      end
      @bytes_processed += len
      # if buffer is not empty, we need to fill it before proceeding
      if (!(@buf_ofs).equal?(0))
        n = Math.min(len, @block_size - @buf_ofs)
        System.arraycopy(b, ofs, @buffer, @buf_ofs, n)
        @buf_ofs += n
        ofs += n
        len -= n
        if (@buf_ofs >= @block_size)
          # compress completed block now
          impl_compress(@buffer, 0)
          @buf_ofs = 0
        end
      end
      # compress complete blocks
      while (len >= @block_size)
        impl_compress(b, ofs)
        len -= @block_size
        ofs += @block_size
      end
      # copy remainder to buffer
      if (len > 0)
        System.arraycopy(b, ofs, @buffer, 0, len)
        @buf_ofs = len
      end
    end
    
    typesig { [] }
    # reset this object. See JCA doc.
    def engine_reset
      if ((@bytes_processed).equal?(0))
        # already reset, ignore
        return
      end
      impl_reset
      @buf_ofs = 0
      @bytes_processed = 0
    end
    
    typesig { [] }
    # return the digest. See JCA doc.
    def engine_digest
      b = Array.typed(::Java::Byte).new(@digest_length) { 0 }
      begin
        engine_digest(b, 0, b.attr_length)
      rescue DigestException => e
        raise ProviderException.new("Internal error").init_cause(e)
      end
      return b
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # return the digest in the specified array. See JCA doc.
    def engine_digest(out, ofs, len)
      if (len < @digest_length)
        raise DigestException.new("Length must be at least " + (@digest_length).to_s + " for " + @algorithm + "digests")
      end
      if ((ofs < 0) || (len < 0) || (ofs > out.attr_length - len))
        raise DigestException.new("Buffer too short to store digest")
      end
      if (@bytes_processed < 0)
        engine_reset
      end
      impl_digest(out, ofs)
      @bytes_processed = -1
      return @digest_length
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Core compression function. Processes blockSize bytes at a time
    # and updates the state of this object.
    def impl_compress(b, ofs)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    # Return the digest. Subclasses do not need to reset() themselves,
    # DigestBase calls implReset() when necessary.
    def impl_digest(out, ofs)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Reset subclass specific state to their initial values. DigestBase
    # calls this method when necessary.
    def impl_reset
      raise NotImplementedError
    end
    
    typesig { [] }
    # Clone this digest. Should be implemented as "return new MyDigest(this)".
    # That constructor should first call "super(baseDigest)" and then copy
    # subclass specific data.
    def clone
      raise NotImplementedError
    end
    
    class_module.module_eval {
      when_class_loaded do
        # we need 128 byte padding for SHA-384/512
        # and an additional 8 bytes for the high 8 bytes of the 16
        # byte bit counter in SHA-384/512
        const_set :Padding, Array.typed(::Java::Byte).new(136) { 0 }
        Padding[0] = 0x80
      end
    }
    
    private
    alias_method :initialize__digest_base, :initialize
  end
  
end
