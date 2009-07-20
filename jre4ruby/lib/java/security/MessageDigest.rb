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
module Java::Security
  module MessageDigestImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include ::Java::Util
      include ::Java::Lang
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :ByteArrayOutputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Nio, :ByteBuffer
    }
  end
  
  # This MessageDigest class provides applications the functionality of a
  # message digest algorithm, such as MD5 or SHA.
  # Message digests are secure one-way hash functions that take arbitrary-sized
  # data and output a fixed-length hash value.
  # 
  # <p>A MessageDigest object starts out initialized. The data is
  # processed through it using the {@link #update(byte) update}
  # methods. At any point {@link #reset() reset} can be called
  # to reset the digest. Once all the data to be updated has been
  # updated, one of the {@link #digest() digest} methods should
  # be called to complete the hash computation.
  # 
  # <p>The <code>digest</code> method can be called once for a given number
  # of updates. After <code>digest</code> has been called, the MessageDigest
  # object is reset to its initialized state.
  # 
  # <p>Implementations are free to implement the Cloneable interface.
  # Client applications can test cloneability by attempting cloning
  # and catching the CloneNotSupportedException: <p>
  # 
  # <pre>
  # MessageDigest md = MessageDigest.getInstance("SHA");
  # 
  # try {
  # md.update(toChapter1);
  # MessageDigest tc1 = md.clone();
  # byte[] toChapter1Digest = tc1.digest();
  # md.update(toChapter2);
  # ...etc.
  # } catch (CloneNotSupportedException cnse) {
  # throw new DigestException("couldn't make digest of partial content");
  # }
  # </pre>
  # 
  # <p>Note that if a given implementation is not cloneable, it is
  # still possible to compute intermediate digests by instantiating
  # several instances, if the number of digests is known in advance.
  # 
  # <p>Note that this class is abstract and extends from
  # <code>MessageDigestSpi</code> for historical reasons.
  # Application developers should only take notice of the methods defined in
  # this <code>MessageDigest</code> class; all the methods in
  # the superclass are intended for cryptographic service providers who wish to
  # supply their own implementations of message digest algorithms.
  # 
  # @author Benjamin Renaud
  # 
  # 
  # @see DigestInputStream
  # @see DigestOutputStream
  class MessageDigest < MessageDigestImports.const_get :MessageDigestSpi
    include_class_members MessageDigestImports
    
    attr_accessor :algorithm
    alias_method :attr_algorithm, :algorithm
    undef_method :algorithm
    alias_method :attr_algorithm=, :algorithm=
    undef_method :algorithm=
    
    class_module.module_eval {
      # The state of this digest
      const_set_lazy(:INITIAL) { 0 }
      const_attr_reader  :INITIAL
      
      const_set_lazy(:IN_PROGRESS) { 1 }
      const_attr_reader  :IN_PROGRESS
    }
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # The provider
    attr_accessor :provider
    alias_method :attr_provider, :provider
    undef_method :provider
    alias_method :attr_provider=, :provider=
    undef_method :provider=
    
    typesig { [String] }
    # Creates a message digest with the specified algorithm name.
    # 
    # @param algorithm the standard name of the digest algorithm.
    # See Appendix A in the <a href=
    # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard algorithm names.
    def initialize(algorithm)
      @algorithm = nil
      @state = 0
      @provider = nil
      super()
      @state = INITIAL
      @algorithm = algorithm
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns a MessageDigest object that implements the specified digest
      # algorithm.
      # 
      # <p> This method traverses the list of registered security Providers,
      # starting with the most preferred Provider.
      # A new MessageDigest object encapsulating the
      # MessageDigestSpi implementation from the first
      # Provider that supports the specified algorithm is returned.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @return a Message Digest object that implements the specified algorithm.
      # 
      # @exception NoSuchAlgorithmException if no Provider supports a
      # MessageDigestSpi implementation for the
      # specified algorithm.
      # 
      # @see Provider
      def get_instance(algorithm)
        begin
          objs = Security.get_impl(algorithm, "MessageDigest", nil)
          if (objs[0].is_a?(MessageDigest))
            md = objs[0]
            md.attr_provider = objs[1]
            return md
          else
            delegate = Delegate.new(objs[0], algorithm)
            delegate.attr_provider = objs[1]
            return delegate
          end
        rescue NoSuchProviderException => e
          raise NoSuchAlgorithmException.new(algorithm + " not found")
        end
      end
      
      typesig { [String, String] }
      # Returns a MessageDigest object that implements the specified digest
      # algorithm.
      # 
      # <p> A new MessageDigest object encapsulating the
      # MessageDigestSpi implementation from the specified provider
      # is returned.  The specified provider must be registered
      # in the security provider list.
      # 
      # <p> Note that the list of registered providers may be retrieved via
      # the {@link Security#getProviders() Security.getProviders()} method.
      # 
      # @param algorithm the name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the name of the provider.
      # 
      # @return a MessageDigest object that implements the specified algorithm.
      # 
      # @exception NoSuchAlgorithmException if a MessageDigestSpi
      # implementation for the specified algorithm is not
      # available from the specified provider.
      # 
      # @exception NoSuchProviderException if the specified provider is not
      # registered in the security provider list.
      # 
      # @exception IllegalArgumentException if the provider name is null
      # or empty.
      # 
      # @see Provider
      def get_instance(algorithm, provider)
        if ((provider).nil? || (provider.length).equal?(0))
          raise IllegalArgumentException.new("missing provider")
        end
        objs = Security.get_impl(algorithm, "MessageDigest", provider)
        if (objs[0].is_a?(MessageDigest))
          md = objs[0]
          md.attr_provider = objs[1]
          return md
        else
          delegate = Delegate.new(objs[0], algorithm)
          delegate.attr_provider = objs[1]
          return delegate
        end
      end
      
      typesig { [String, Provider] }
      # Returns a MessageDigest object that implements the specified digest
      # algorithm.
      # 
      # <p> A new MessageDigest object encapsulating the
      # MessageDigestSpi implementation from the specified Provider
      # object is returned.  Note that the specified Provider object
      # does not have to be registered in the provider list.
      # 
      # @param algorithm the name of the algorithm requested.
      # See Appendix A in the <a href=
      # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
      # Java Cryptography Architecture API Specification &amp; Reference </a>
      # for information about standard algorithm names.
      # 
      # @param provider the provider.
      # 
      # @return a MessageDigest object that implements the specified algorithm.
      # 
      # @exception NoSuchAlgorithmException if a MessageDigestSpi
      # implementation for the specified algorithm is not available
      # from the specified Provider object.
      # 
      # @exception IllegalArgumentException if the specified provider is null.
      # 
      # @see Provider
      # 
      # @since 1.4
      def get_instance(algorithm, provider)
        if ((provider).nil?)
          raise IllegalArgumentException.new("missing provider")
        end
        objs = Security.get_impl(algorithm, "MessageDigest", provider)
        if (objs[0].is_a?(MessageDigest))
          md = objs[0]
          md.attr_provider = objs[1]
          return md
        else
          delegate = Delegate.new(objs[0], algorithm)
          delegate.attr_provider = objs[1]
          return delegate
        end
      end
    }
    
    typesig { [] }
    # Returns the provider of this message digest object.
    # 
    # @return the provider of this message digest object
    def get_provider
      return @provider
    end
    
    typesig { [::Java::Byte] }
    # Updates the digest using the specified byte.
    # 
    # @param input the byte with which to update the digest.
    def update(input)
      engine_update(input)
      @state = IN_PROGRESS
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Updates the digest using the specified array of bytes, starting
    # at the specified offset.
    # 
    # @param input the array of bytes.
    # 
    # @param offset the offset to start from in the array of bytes.
    # 
    # @param len the number of bytes to use, starting at
    # <code>offset</code>.
    def update(input, offset, len)
      if ((input).nil?)
        raise IllegalArgumentException.new("No input buffer given")
      end
      if (input.attr_length - offset < len)
        raise IllegalArgumentException.new("Input buffer too short")
      end
      engine_update(input, offset, len)
      @state = IN_PROGRESS
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Updates the digest using the specified array of bytes.
    # 
    # @param input the array of bytes.
    def update(input)
      engine_update(input, 0, input.attr_length)
      @state = IN_PROGRESS
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
    def update(input)
      if ((input).nil?)
        raise NullPointerException.new
      end
      engine_update(input)
      @state = IN_PROGRESS
    end
    
    typesig { [] }
    # Completes the hash computation by performing final operations
    # such as padding. The digest is reset after this call is made.
    # 
    # @return the array of bytes for the resulting hash value.
    def digest
      # Resetting is the responsibility of implementors.
      result = engine_digest
      @state = INITIAL
      return result
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Completes the hash computation by performing final operations
    # such as padding. The digest is reset after this call is made.
    # 
    # @param buf output buffer for the computed digest
    # 
    # @param offset offset into the output buffer to begin storing the digest
    # 
    # @param len number of bytes within buf allotted for the digest
    # 
    # @return the number of bytes placed into <code>buf</code>
    # 
    # @exception DigestException if an error occurs.
    def digest(buf, offset, len)
      if ((buf).nil?)
        raise IllegalArgumentException.new("No output buffer given")
      end
      if (buf.attr_length - offset < len)
        raise IllegalArgumentException.new("Output buffer too small for specified offset and length")
      end
      num_bytes = engine_digest(buf, offset, len)
      @state = INITIAL
      return num_bytes
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Performs a final update on the digest using the specified array
    # of bytes, then completes the digest computation. That is, this
    # method first calls {@link #update(byte[]) update(input)},
    # passing the <i>input</i> array to the <code>update</code> method,
    # then calls {@link #digest() digest()}.
    # 
    # @param input the input to be updated before the digest is
    # completed.
    # 
    # @return the array of bytes for the resulting hash value.
    def digest(input)
      update(input)
      return digest
    end
    
    typesig { [] }
    # Returns a string representation of this message digest object.
    def to_s
      baos = ByteArrayOutputStream.new
      p = PrintStream.new(baos)
      p.print(@algorithm + " Message Digest from " + (@provider.get_name).to_s + ", ")
      case (@state)
      when INITIAL
        p.print("<initialized>")
      when IN_PROGRESS
        p.print("<in progress>")
      end
      p.println
      return (baos.to_s)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      # Compares two digests for equality. Does a simple byte compare.
      # 
      # @param digesta one of the digests to compare.
      # 
      # @param digestb the other digest to compare.
      # 
      # @return true if the digests are equal, false otherwise.
      def is_equal(digesta, digestb)
        if (!(digesta.attr_length).equal?(digestb.attr_length))
          return false
        end
        i = 0
        while i < digesta.attr_length
          if (!(digesta[i]).equal?(digestb[i]))
            return false
          end
          i += 1
        end
        return true
      end
    }
    
    typesig { [] }
    # Resets the digest for further use.
    def reset
      engine_reset
      @state = INITIAL
    end
    
    typesig { [] }
    # Returns a string that identifies the algorithm, independent of
    # implementation details. The name should be a standard
    # Java Security name (such as "SHA", "MD5", and so on).
    # See Appendix A in the <a href=
    # "../../../technotes/guides/security/crypto/CryptoSpec.html#AppA">
    # Java Cryptography Architecture API Specification &amp; Reference </a>
    # for information about standard algorithm names.
    # 
    # @return the name of the algorithm
    def get_algorithm
      return @algorithm
    end
    
    typesig { [] }
    # Returns the length of the digest in bytes, or 0 if this operation is
    # not supported by the provider and the implementation is not cloneable.
    # 
    # @return the digest length in bytes, or 0 if this operation is not
    # supported by the provider and the implementation is not cloneable.
    # 
    # @since 1.2
    def get_digest_length
      digest_len = engine_get_digest_length
      if ((digest_len).equal?(0))
        begin
          md = clone
          digest_ = md.digest
          return digest_.attr_length
        rescue CloneNotSupportedException => e
          return digest_len
        end
      end
      return digest_len
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
    
    class_module.module_eval {
      # The following class allows providers to extend from MessageDigestSpi
      # rather than from MessageDigest. It represents a MessageDigest with an
      # encapsulated, provider-supplied SPI object (of type MessageDigestSpi).
      # If the provider implementation is an instance of MessageDigestSpi,
      # the getInstance() methods above return an instance of this class, with
      # the SPI object encapsulated.
      # 
      # Note: All SPI methods from the original MessageDigest class have been
      # moved up the hierarchy into a new class (MessageDigestSpi), which has
      # been interposed in the hierarchy between the API (MessageDigest)
      # and its original parent (Object).
      const_set_lazy(:Delegate) { Class.new(MessageDigest) do
        include_class_members MessageDigest
        
        # The provider implementation (delegate)
        attr_accessor :digest_spi
        alias_method :attr_digest_spi, :digest_spi
        undef_method :digest_spi
        alias_method :attr_digest_spi=, :digest_spi=
        undef_method :digest_spi=
        
        typesig { [MessageDigestSpi, String] }
        # constructor
        def initialize(digest_spi, algorithm)
          @digest_spi = nil
          super(algorithm)
          @digest_spi = digest_spi
        end
        
        typesig { [] }
        # Returns a clone if the delegate is cloneable.
        # 
        # @return a clone if the delegate is cloneable.
        # 
        # @exception CloneNotSupportedException if this is called on a
        # delegate that does not support <code>Cloneable</code>.
        def clone
          if (@digest_spi.is_a?(Cloneable))
            digest_spi_clone = @digest_spi.clone
            # Because 'algorithm', 'provider', and 'state' are private
            # members of our supertype, we must perform a cast to
            # access them.
            that = Delegate.new(digest_spi_clone, (self).attr_algorithm)
            that.attr_provider = (self).attr_provider
            that.attr_state = (self).attr_state
            return that
          else
            raise CloneNotSupportedException.new
          end
        end
        
        typesig { [] }
        def engine_get_digest_length
          return @digest_spi.engine_get_digest_length
        end
        
        typesig { [::Java::Byte] }
        def engine_update(input)
          @digest_spi.engine_update(input)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def engine_update(input, offset, len)
          @digest_spi.engine_update(input, offset, len)
        end
        
        typesig { [ByteBuffer] }
        def engine_update(input)
          @digest_spi.engine_update(input)
        end
        
        typesig { [] }
        def engine_digest
          return @digest_spi.engine_digest
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def engine_digest(buf, offset, len)
          return @digest_spi.engine_digest(buf, offset, len)
        end
        
        typesig { [] }
        def engine_reset
          @digest_spi.engine_reset
        end
        
        private
        alias_method :initialize__delegate, :initialize
      end }
    }
    
    private
    alias_method :initialize__message_digest, :initialize
  end
  
end
