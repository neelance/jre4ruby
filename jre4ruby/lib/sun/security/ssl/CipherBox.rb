require "rjava"

# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CipherBoxImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :IOException
      include ::Java::Security
      include ::Javax::Crypto
      include_const ::Javax::Crypto::Spec, :SecretKeySpec
      include_const ::Javax::Crypto::Spec, :IvParameterSpec
      include ::Java::Nio
      include ::Sun::Security::Ssl::CipherSuite
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # This class handles bulk data enciphering/deciphering for each SSLv3
  # message.  This provides data confidentiality.  Stream ciphers (such
  # as RC4) don't need to do padding; block ciphers (e.g. DES) need it.
  # 
  # Individual instances are obtained by calling the static method
  # newCipherBox(), which should only be invoked by BulkCipher.newCipher().
  # 
  # NOTE that any ciphering involved in key exchange (e.g. with RSA) is
  # handled separately.
  # 
  # @author David Brownell
  # @author Andreas Sterbenz
  class CipherBox 
    include_class_members CipherBoxImports
    
    class_module.module_eval {
      # A CipherBox that implements the identity operation
      const_set_lazy(:NULL) { CipherBox.new }
      const_attr_reader  :NULL
      
      # Class and subclass dynamic debugging support
      const_set_lazy(:Debug) { Debug.get_instance("ssl") }
      const_attr_reader  :Debug
    }
    
    # the protocol version this cipher conforms to
    attr_accessor :protocol_version
    alias_method :attr_protocol_version, :protocol_version
    undef_method :protocol_version
    alias_method :attr_protocol_version=, :protocol_version=
    undef_method :protocol_version=
    
    # cipher object
    attr_accessor :cipher
    alias_method :attr_cipher, :cipher
    undef_method :cipher
    alias_method :attr_cipher=, :cipher=
    undef_method :cipher=
    
    # Cipher blocksize, 0 for stream ciphers
    attr_accessor :block_size
    alias_method :attr_block_size, :block_size
    undef_method :block_size
    alias_method :attr_block_size=, :block_size=
    undef_method :block_size=
    
    typesig { [] }
    # NULL cipherbox. Identity operation, no encryption.
    def initialize
      @protocol_version = nil
      @cipher = nil
      @block_size = 0
      @protocol_version = ProtocolVersion::DEFAULT
      @cipher = nil
    end
    
    typesig { [ProtocolVersion, BulkCipher, SecretKey, IvParameterSpec, ::Java::Boolean] }
    # Construct a new CipherBox using the cipher transformation.
    # 
    # @exception NoSuchAlgorithmException if no appropriate JCE Cipher
    # implementation could be found.
    def initialize(protocol_version, bulk_cipher, key, iv, encrypt)
      @protocol_version = nil
      @cipher = nil
      @block_size = 0
      begin
        @protocol_version = protocol_version
        @cipher = JsseJce.get_cipher(bulk_cipher.attr_transformation)
        mode = encrypt ? Cipher::ENCRYPT_MODE : Cipher::DECRYPT_MODE
        @cipher.init(mode, key, iv)
        # do not call getBlockSize until after init()
        # otherwise we would disrupt JCE delayed provider selection
        @block_size = @cipher.get_block_size
        # some providers implement getBlockSize() incorrectly
        if ((@block_size).equal?(1))
          @block_size = 0
        end
      rescue NoSuchAlgorithmException => e
        raise e
      rescue Exception => e
        raise NoSuchAlgorithmException.new("Could not create cipher " + (bulk_cipher).to_s, e)
      rescue ExceptionInInitializerError => e
        raise NoSuchAlgorithmException.new("Could not create cipher " + (bulk_cipher).to_s, e)
      end
    end
    
    class_module.module_eval {
      typesig { [ProtocolVersion, BulkCipher, SecretKey, IvParameterSpec, ::Java::Boolean] }
      # Factory method to obtain a new CipherBox object.
      def new_cipher_box(version, cipher, key, iv, encrypt)
        if ((cipher.attr_allowed).equal?(false))
          raise NoSuchAlgorithmException.new("Unsupported cipher " + (cipher).to_s)
        end
        if ((cipher).equal?(B_NULL))
          return NULL
        else
          return CipherBox.new(version, cipher, key, iv, encrypt)
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Encrypts a block of data, returning the size of the
    # resulting block.
    def encrypt(buf, offset, len)
      if ((@cipher).nil?)
        return len
      end
      begin
        if (!(@block_size).equal?(0))
          len = add_padding(buf, offset, len, @block_size)
        end
        if (!(Debug).nil? && Debug.is_on("plaintext"))
          begin
            hd = HexDumpEncoder.new
            System.out.println("Padded plaintext before ENCRYPTION:  len = " + (len).to_s)
            hd.encode_buffer(ByteArrayInputStream.new(buf, offset, len), System.out)
          rescue IOException => e
          end
        end
        new_len = @cipher.update(buf, offset, len, buf, offset)
        if (!(new_len).equal?(len))
          # catch BouncyCastle buffering error
          raise RuntimeException.new("Cipher buffering error " + "in JCE provider " + (@cipher.get_provider.get_name).to_s)
        end
        return new_len
      rescue ShortBufferException => e
        raise ArrayIndexOutOfBoundsException.new(e.to_s)
      end
    end
    
    typesig { [ByteBuffer] }
    # Encrypts a ByteBuffer block of data, returning the size of the
    # resulting block.
    # 
    # The byte buffers position and limit initially define the amount
    # to encrypt.  On return, the position and limit are
    # set to last position padded/encrypted.  The limit may have changed
    # because of the added padding bytes.
    def encrypt(bb)
      len = bb.remaining
      if ((@cipher).nil?)
        bb.position(bb.limit)
        return len
      end
      begin
        pos = bb.position
        if (!(@block_size).equal?(0))
          # addPadding adjusts pos/limit
          len = add_padding(bb, @block_size)
          bb.position(pos)
        end
        if (!(Debug).nil? && Debug.is_on("plaintext"))
          begin
            hd = HexDumpEncoder.new
            System.out.println("Padded plaintext before ENCRYPTION:  len = " + (len).to_s)
            hd.encode_buffer(bb, System.out)
          rescue IOException => e
          end
          # reset back to beginning
          bb.position(pos)
        end
        # Encrypt "in-place".  This does not add its own padding.
        dup = bb.duplicate
        new_len = @cipher.update(dup, bb)
        if (!(bb.position).equal?(dup.position))
          raise RuntimeException.new("bytebuffer padding error")
        end
        if (!(new_len).equal?(len))
          # catch BouncyCastle buffering error
          raise RuntimeException.new("Cipher buffering error " + "in JCE provider " + (@cipher.get_provider.get_name).to_s)
        end
        return new_len
      rescue ShortBufferException => e
        exc = RuntimeException.new(e.to_s)
        exc.init_cause(e)
        raise exc
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Decrypts a block of data, returning the size of the
    # resulting block if padding was required.
    def decrypt(buf, offset, len)
      if ((@cipher).nil?)
        return len
      end
      begin
        new_len = @cipher.update(buf, offset, len, buf, offset)
        if (!(new_len).equal?(len))
          # catch BouncyCastle buffering error
          raise RuntimeException.new("Cipher buffering error " + "in JCE provider " + (@cipher.get_provider.get_name).to_s)
        end
        if (!(Debug).nil? && Debug.is_on("plaintext"))
          begin
            hd = HexDumpEncoder.new
            System.out.println("Padded plaintext after DECRYPTION:  len = " + (new_len).to_s)
            hd.encode_buffer(ByteArrayInputStream.new(buf, offset, new_len), System.out)
          rescue IOException => e
          end
        end
        if (!(@block_size).equal?(0))
          new_len = remove_padding(buf, offset, new_len, @block_size, @protocol_version)
        end
        return new_len
      rescue ShortBufferException => e
        raise ArrayIndexOutOfBoundsException.new(e.to_s)
      end
    end
    
    typesig { [ByteBuffer] }
    # Decrypts a block of data, returning the size of the
    # resulting block if padding was required.  position and limit
    # point to the end of the decrypted/depadded data.  The initial
    # limit and new limit may be different, given we may
    # have stripped off some padding bytes.
    def decrypt(bb)
      len = bb.remaining
      if ((@cipher).nil?)
        bb.position(bb.limit)
        return len
      end
      begin
        # Decrypt "in-place".
        pos = bb.position
        dup = bb.duplicate
        new_len = @cipher.update(dup, bb)
        if (!(new_len).equal?(len))
          # catch BouncyCastle buffering error
          raise RuntimeException.new("Cipher buffering error " + "in JCE provider " + (@cipher.get_provider.get_name).to_s)
        end
        if (!(Debug).nil? && Debug.is_on("plaintext"))
          bb.position(pos)
          begin
            hd = HexDumpEncoder.new
            System.out.println("Padded plaintext after DECRYPTION:  len = " + (new_len).to_s)
            hd.encode_buffer(bb, System.out)
          rescue IOException => e
          end
        end
        # Remove the block padding.
        if (!(@block_size).equal?(0))
          bb.position(pos)
          new_len = remove_padding(bb, @block_size, @protocol_version)
        end
        return new_len
      rescue ShortBufferException => e
        exc = RuntimeException.new(e.to_s)
        exc.init_cause(e)
        raise exc
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
      def add_padding(buf, offset, len, block_size)
        newlen = len + 1
        pad = 0
        i = 0
        if (!((newlen % block_size)).equal?(0))
          newlen += block_size - 1
          newlen -= newlen % block_size
        end
        pad = (newlen - len)
        if (buf.attr_length < (newlen + offset))
          raise IllegalArgumentException.new("no space to pad buffer")
        end
        # TLS version of the padding works for both SSLv3 and TLSv1
        i = 0
        offset += len
        while i < pad
          buf[((offset += 1) - 1)] = (pad - 1)
          i += 1
        end
        return newlen
      end
      
      typesig { [ByteBuffer, ::Java::Int] }
      # Apply the padding to the buffer.
      # 
      # Limit is advanced to the new buffer length.
      # Position is equal to limit.
      def add_padding(bb, block_size)
        len = bb.remaining
        offset = bb.position
        newlen = len + 1
        pad = 0
        i = 0
        if (!((newlen % block_size)).equal?(0))
          newlen += block_size - 1
          newlen -= newlen % block_size
        end
        pad = (newlen - len)
        # Update the limit to what will be padded.
        bb.limit(newlen + offset)
        # TLS version of the padding works for both SSLv3 and TLSv1
        i = 0
        offset += len
        while i < pad
          bb.put(((offset += 1) - 1), (pad - 1))
          i += 1
        end
        bb.position(offset)
        bb.limit(offset)
        return newlen
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int, ProtocolVersion] }
      # Typical TLS padding format for a 64 bit block cipher is as follows:
      # xx xx xx xx xx xx xx 00
      # xx xx xx xx xx xx 01 01
      # ...
      # xx 06 06 06 06 06 06 06
      # 07 07 07 07 07 07 07 07
      # TLS also allows any amount of padding from 1 and 256 bytes as long
      # as it makes the data a multiple of the block size
      def remove_padding(buf, offset, len, block_size, protocol_version)
        # last byte is length byte (i.e. actual padding length - 1)
        pad_offset = offset + len - 1
        pad = buf[pad_offset] & 0xff
        newlen = len - (pad + 1)
        if (newlen < 0)
          raise BadPaddingException.new("Padding length invalid: " + (pad).to_s)
        end
        if (protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v)
          i = 1
          while i <= pad
            val = buf[pad_offset - i] & 0xff
            if (!(val).equal?(pad))
              raise BadPaddingException.new("Invalid TLS padding: " + (val).to_s)
            end
            i += 1
          end
        else
          # SSLv3
          # SSLv3 requires 0 <= length byte < block size
          # some implementations do 1 <= length byte <= block size,
          # so accept that as well
          # v3 does not require any particular value for the other bytes
          if (pad > block_size)
            raise BadPaddingException.new("Invalid SSLv3 padding: " + (pad).to_s)
          end
        end
        return newlen
      end
      
      typesig { [ByteBuffer, ::Java::Int, ProtocolVersion] }
      # Position/limit is equal the removed padding.
      def remove_padding(bb, block_size, protocol_version)
        len = bb.remaining
        offset = bb.position
        # last byte is length byte (i.e. actual padding length - 1)
        pad_offset = offset + len - 1
        pad = bb.get(pad_offset) & 0xff
        newlen = len - (pad + 1)
        if (newlen < 0)
          raise BadPaddingException.new("Padding length invalid: " + (pad).to_s)
        end
        # We could zero the padding area, but not much useful
        # information there.
        if (protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v)
          bb.put(pad_offset, 0) # zero the padding.
          i = 1
          while i <= pad
            val = bb.get(pad_offset - i) & 0xff
            if (!(val).equal?(pad))
              raise BadPaddingException.new("Invalid TLS padding: " + (val).to_s)
            end
            i += 1
          end
        else
          # SSLv3
          # SSLv3 requires 0 <= length byte < block size
          # some implementations do 1 <= length byte <= block size,
          # so accept that as well
          # v3 does not require any particular value for the other bytes
          if (pad > block_size)
            raise BadPaddingException.new("Invalid SSLv3 padding: " + (pad).to_s)
          end
        end
        # Reset buffer limit to remove padding.
        bb.position(offset + newlen)
        bb.limit(offset + newlen)
        return newlen
      end
    }
    
    private
    alias_method :initialize__cipher_box, :initialize
  end
  
end
