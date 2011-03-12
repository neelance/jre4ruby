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
  module MACImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Security, :InvalidKeyException
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Javax::Crypto, :Mac
      include_const ::Javax::Crypto, :SecretKey
      include_const ::Sun::Security::Ssl::CipherSuite, :MacAlg
    }
  end
  
  # This class computes the "Message Authentication Code" (MAC) for each
  # SSL message.  This is essentially a shared-secret signature, used to
  # provide integrity protection for SSL messages.  The MAC is actually
  # one of several keyed hashes, as associated with the cipher suite and
  # protocol version.  (SSL v3.0 uses one construct, TLS uses another.)
  # 
  # <P>NOTE: MAC computation is the only place in the SSL protocol that the
  # sequence number is used.  It's also reset to zero with each change of
  # a cipher spec, so this is the only place this state is needed.
  # 
  # @author David Brownell
  # @author Andreas Sterbenz
  class MAC 
    include_class_members MACImports
    
    class_module.module_eval {
      const_set_lazy(:NULL) { MAC.new }
      const_attr_reader  :NULL
      
      # Value of the null MAC is fixed
      const_set_lazy(:NullMAC) { Array.typed(::Java::Byte).new(0) { 0 } }
      const_attr_reader  :NullMAC
    }
    
    # internal identifier for the MAC algorithm
    attr_accessor :mac_alg
    alias_method :attr_mac_alg, :mac_alg
    undef_method :mac_alg
    alias_method :attr_mac_alg=, :mac_alg=
    undef_method :mac_alg=
    
    # stuff defined by the kind of MAC algorithm
    attr_accessor :mac_size
    alias_method :attr_mac_size, :mac_size
    undef_method :mac_size
    alias_method :attr_mac_size=, :mac_size=
    undef_method :mac_size=
    
    # JCE Mac object
    attr_accessor :mac
    alias_method :attr_mac, :mac
    undef_method :mac
    alias_method :attr_mac=, :mac=
    undef_method :mac=
    
    # byte array containing the additional information we MAC in each record
    # (see below)
    attr_accessor :block
    alias_method :attr_block, :block
    undef_method :block
    alias_method :attr_block=, :block=
    undef_method :block=
    
    class_module.module_eval {
      # sequence number + record type + + record length
      const_set_lazy(:BLOCK_SIZE_SSL) { 8 + 1 + 2 }
      const_attr_reader  :BLOCK_SIZE_SSL
      
      # sequence number + record type + protocol version + record length
      const_set_lazy(:BLOCK_SIZE_TLS) { 8 + 1 + 2 + 2 }
      const_attr_reader  :BLOCK_SIZE_TLS
      
      # offset of record type in block
      const_set_lazy(:BLOCK_OFFSET_TYPE) { 8 }
      const_attr_reader  :BLOCK_OFFSET_TYPE
      
      # offset of protocol version number in block (TLS only)
      const_set_lazy(:BLOCK_OFFSET_VERSION) { 8 + 1 }
      const_attr_reader  :BLOCK_OFFSET_VERSION
    }
    
    typesig { [] }
    def initialize
      @mac_alg = nil
      @mac_size = 0
      @mac = nil
      @block = nil
      @mac_size = 0
      @mac_alg = M_NULL
      @mac = nil
      @block = nil
    end
    
    typesig { [MacAlg, ProtocolVersion, SecretKey] }
    # Set up, configured for the given SSL/TLS MAC type and version.
    def initialize(mac_alg, protocol_version, key)
      @mac_alg = nil
      @mac_size = 0
      @mac = nil
      @block = nil
      @mac_alg = mac_alg
      @mac_size = mac_alg.attr_size
      algorithm = nil
      tls = (protocol_version.attr_v >= ProtocolVersion::TLS10.attr_v)
      if ((mac_alg).equal?(M_MD5))
        algorithm = RJava.cast_to_string(tls ? "HmacMD5" : "SslMacMD5")
      else
        if ((mac_alg).equal?(M_SHA))
          algorithm = RJava.cast_to_string(tls ? "HmacSHA1" : "SslMacSHA1")
        else
          raise RuntimeException.new("Unknown Mac " + RJava.cast_to_string(mac_alg))
        end
      end
      @mac = JsseJce.get_mac(algorithm)
      @mac.init(key)
      if (tls)
        @block = Array.typed(::Java::Byte).new(BLOCK_SIZE_TLS) { 0 }
        @block[BLOCK_OFFSET_VERSION] = protocol_version.attr_major
        @block[BLOCK_OFFSET_VERSION + 1] = protocol_version.attr_minor
      else
        @block = Array.typed(::Java::Byte).new(BLOCK_SIZE_SSL) { 0 }
      end
    end
    
    typesig { [] }
    # Returns the length of the MAC.
    def _maclen
      return @mac_size
    end
    
    typesig { [::Java::Byte, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Computes and returns the MAC for the data in this byte array.
    # 
    # @param type record type
    # @param buf compressed record on which the MAC is computed
    # @param offset start of compressed record data
    # @param len the size of the compressed record
    def compute(type, buf, offset, len)
      return compute(type, nil, buf, offset, len)
    end
    
    typesig { [::Java::Byte, ByteBuffer] }
    # Compute and returns the MAC for the remaining data
    # in this ByteBuffer.
    # 
    # On return, the bb position == limit, and limit will
    # have not changed.
    # 
    # @param type record type
    # @param bb a ByteBuffer in which the position and limit
    #          demarcate the data to be MAC'd.
    def compute(type, bb)
      return compute(type, bb, nil, 0, bb.remaining)
    end
    
    typesig { [] }
    # increment the sequence number in the block array
    # it is a 64-bit number stored in big-endian format
    def increment_sequence_number
      k = 7
      while ((k >= 0) && (((@block[k] += 1)).equal?(0)))
        k -= 1
      end
    end
    
    typesig { [::Java::Byte, ByteBuffer, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Compute based on either buffer type, either bb.position/limit
    # or buf/offset/len.
    def compute(type, bb, buf, offset, len)
      if ((@mac_size).equal?(0))
        return NullMAC
      end
      @block[BLOCK_OFFSET_TYPE] = type
      @block[@block.attr_length - 2] = (len >> 8)
      @block[@block.attr_length - 1] = (len)
      @mac.update(@block)
      increment_sequence_number
      # content
      if (!(bb).nil?)
        @mac.update(bb)
      else
        @mac.update(buf, offset, len)
      end
      return @mac.do_final
    end
    
    private
    alias_method :initialize__mac, :initialize
  end
  
end
