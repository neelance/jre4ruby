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
module Java::Security
  module MessageDigestSpiImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Sun::Security::Jca, :JCAUtil
    }
  end
  
  # This class defines the <i>Service Provider Interface</i> (<b>SPI</b>)
  # for the <code>MessageDigest</code> class, which provides the functionality
  # of a message digest algorithm, such as MD5 or SHA. Message digests are
  # secure one-way hash functions that take arbitrary-sized data and output a
  # fixed-length hash value.
  # 
  # <p> All the abstract methods in this class must be implemented by a
  # cryptographic service provider who wishes to supply the implementation
  # of a particular message digest algorithm.
  # 
  # <p> Implementations are free to implement the Cloneable interface.
  # 
  # @author Benjamin Renaud
  # 
  # 
  # @see MessageDigest
  class MessageDigestSpi 
    include_class_members MessageDigestSpiImports
    
    # for re-use in engineUpdate(ByteBuffer input)
    attr_accessor :temp_array
    alias_method :attr_temp_array, :temp_array
    undef_method :temp_array
    alias_method :attr_temp_array=, :temp_array=
    undef_method :temp_array=
    
    typesig { [] }
    # Returns the digest length in bytes.
    # 
    # <p>This concrete method has been added to this previously-defined
    # abstract class. (For backwards compatibility, it cannot be abstract.)
    # 
    # <p>The default behavior is to return 0.
    # 
    # <p>This method may be overridden by a provider to return the digest
    # length.
    # 
    # @return the digest length in bytes.
    # 
    # @since 1.2
    def engine_get_digest_length
      return 0
    end
    
    typesig { [::Java::Byte] }
    # Updates the digest using the specified byte.
    # 
    # @param input the byte to use for the update.
    def engine_update(input)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Updates the digest using the specified array of bytes,
    # starting at the specified offset.
    # 
    # @param input the array of bytes to use for the update.
    # 
    # @param offset the offset to start from in the array of bytes.
    # 
    # @param len the number of bytes to use, starting at
    # <code>offset</code>.
    def engine_update(input, offset, len)
      raise NotImplementedError
    end
    
    typesig { [ByteBuffer] }
    # Update the digest using the specified ByteBuffer. The digest is
    # updated using the <code>input.remaining()</code> bytes starting
    # at <code>input.position()</code>.
    # Upon return, the buffer's position will be equal to its limit;
    # its limit will not have changed.
    # 
    # @param input the ByteBuffer
    # @since 1.5
    def engine_update(input)
      if ((input.has_remaining).equal?(false))
        return
      end
      if (input.has_array)
        b = input.array
        ofs = input.array_offset
        pos = input.position
        lim = input.limit
        engine_update(b, ofs + pos, lim - pos)
        input.position(lim)
      else
        len = input.remaining
        n = JCAUtil.get_temp_array_size(len)
        if (((@temp_array).nil?) || (n > @temp_array.attr_length))
          @temp_array = Array.typed(::Java::Byte).new(n) { 0 }
        end
        while (len > 0)
          chunk = Math.min(len, @temp_array.attr_length)
          input.get(@temp_array, 0, chunk)
          engine_update(@temp_array, 0, chunk)
          len -= chunk
        end
      end
    end
    
    typesig { [] }
    # Completes the hash computation by performing final
    # operations such as padding. Once <code>engineDigest</code> has
    # been called, the engine should be reset (see
    # {@link #engineReset() engineReset}).
    # Resetting is the responsibility of the
    # engine implementor.
    # 
    # @return the array of bytes for the resulting hash value.
    def engine_digest
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Completes the hash computation by performing final
    # operations such as padding. Once <code>engineDigest</code> has
    # been called, the engine should be reset (see
    # {@link #engineReset() engineReset}).
    # Resetting is the responsibility of the
    # engine implementor.
    # 
    # This method should be abstract, but we leave it concrete for
    # binary compatibility.  Knowledgeable providers should override this
    # method.
    # 
    # @param buf the output buffer in which to store the digest
    # 
    # @param offset offset to start from in the output buffer
    # 
    # @param len number of bytes within buf allotted for the digest.
    # Both this default implementation and the SUN provider do not
    # return partial digests.  The presence of this parameter is solely
    # for consistency in our API's.  If the value of this parameter is less
    # than the actual digest length, the method will throw a DigestException.
    # This parameter is ignored if its value is greater than or equal to
    # the actual digest length.
    # 
    # @return the length of the digest stored in the output buffer.
    # 
    # @exception DigestException if an error occurs.
    # 
    # @since 1.2
    def engine_digest(buf, offset, len)
      digest = engine_digest
      if (len < digest.attr_length)
        raise DigestException.new("partial digests not returned")
      end
      if (buf.attr_length - offset < digest.attr_length)
        raise DigestException.new("insufficient space in the output " + "buffer to store the digest")
      end
      System.arraycopy(digest, 0, buf, offset, digest.attr_length)
      return digest.attr_length
    end
    
    typesig { [] }
    # Resets the digest for further use.
    def engine_reset
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a clone if the implementation is cloneable.
    # 
    # @return a clone if the implementation is cloneable.
    # 
    # @exception CloneNotSupportedException if this is called on an
    # implementation that does not support <code>Cloneable</code>.
    def clone
      if (self.is_a?(Cloneable))
        return super
      else
        raise CloneNotSupportedException.new
      end
    end
    
    typesig { [] }
    def initialize
      @temp_array = nil
    end
    
    private
    alias_method :initialize__message_digest_spi, :initialize
  end
  
end
