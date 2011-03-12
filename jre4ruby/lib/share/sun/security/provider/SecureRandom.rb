require "rjava"

# Copyright 1998-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SecureRandomImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :SecureRandomSpi
      include_const ::Java::Security, :NoSuchAlgorithmException
    }
  end
  
  # <p>This class provides a crytpographically strong pseudo-random number
  # generator based on the SHA-1 hash algorithm.
  # 
  # <p>Note that if a seed is not provided, we attempt to provide sufficient
  # seed bytes to completely randomize the internal state of the generator
  # (20 bytes).  However, our seed generation algorithm has not been thoroughly
  # studied or widely deployed.
  # 
  # <p>Also note that when a random object is deserialized,
  # <a href="#engineNextBytes(byte[])">engineNextBytes</a> invoked on the
  # restored random object will yield the exact same (random) bytes as the
  # original object.  If this behaviour is not desired, the restored random
  # object should be seeded, using
  # <a href="#engineSetSeed(byte[])">engineSetSeed</a>.
  # 
  # @author Benjamin Renaud
  # @author Josh Bloch
  # @author Gadi Guy
  class SecureRandom < SecureRandomImports.const_get :SecureRandomSpi
    include_class_members SecureRandomImports
    overload_protected {
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 3581829991155417889 }
      const_attr_reader  :SerialVersionUID
      
      # This static object will be seeded by SeedGenerator, and used
      # to seed future instances of SecureRandom
      
      def seeder
        defined?(@@seeder) ? @@seeder : @@seeder= nil
      end
      alias_method :attr_seeder, :seeder
      
      def seeder=(value)
        @@seeder = value
      end
      alias_method :attr_seeder=, :seeder=
      
      const_set_lazy(:DIGEST_SIZE) { 20 }
      const_attr_reader  :DIGEST_SIZE
    }
    
    attr_accessor :digest
    alias_method :attr_digest, :digest
    undef_method :digest
    alias_method :attr_digest=, :digest=
    undef_method :digest=
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    attr_accessor :remainder
    alias_method :attr_remainder, :remainder
    undef_method :remainder
    alias_method :attr_remainder=, :remainder=
    undef_method :remainder=
    
    attr_accessor :rem_count
    alias_method :attr_rem_count, :rem_count
    undef_method :rem_count
    alias_method :attr_rem_count=, :rem_count=
    undef_method :rem_count=
    
    typesig { [] }
    # This empty constructor automatically seeds the generator.  We attempt
    # to provide sufficient seed bytes to completely randomize the internal
    # state of the generator (20 bytes).  Note, however, that our seed
    # generation algorithm has not been thoroughly studied or widely deployed.
    # 
    # <p>The first time this constructor is called in a given Virtual Machine,
    # it may take several seconds of CPU time to seed the generator, depending
    # on the underlying hardware.  Successive calls run quickly because they
    # rely on the same (internal) pseudo-random number generator for their
    # seed bits.
    def initialize
      @digest = nil
      @state = nil
      @remainder = nil
      @rem_count = 0
      super()
      init(nil)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # This constructor is used to instatiate the private seeder object
    # with a given seed from the SeedGenerator.
    # 
    # @param seed the seed.
    def initialize(seed)
      @digest = nil
      @state = nil
      @remainder = nil
      @rem_count = 0
      super()
      init(seed)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # This call, used by the constructors, instantiates the SHA digest
    # and sets the seed, if given.
    def init(seed)
      begin
        @digest = MessageDigest.get_instance("SHA")
      rescue NoSuchAlgorithmException => e
        raise InternalError.new("internal error: SHA-1 not available.")
      end
      if (!(seed).nil?)
        engine_set_seed(seed)
      end
    end
    
    typesig { [::Java::Int] }
    # Returns the given number of seed bytes, computed using the seed
    # generation algorithm that this class uses to seed itself.  This
    # call may be used to seed other random number generators.  While
    # we attempt to return a "truly random" sequence of bytes, we do not
    # know exactly how random the bytes returned by this call are.  (See
    # the empty constructor <a href = "#SecureRandom">SecureRandom</a>
    # for a brief description of the underlying algorithm.)
    # The prudent user will err on the side of caution and get extra
    # seed bytes, although it should be noted that seed generation is
    # somewhat costly.
    # 
    # @param numBytes the number of seed bytes to generate.
    # 
    # @return the seed bytes.
    def engine_generate_seed(num_bytes)
      b = Array.typed(::Java::Byte).new(num_bytes) { 0 }
      SeedGenerator.generate_seed(b)
      return b
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reseeds this random object. The given seed supplements, rather than
    # replaces, the existing seed. Thus, repeated calls are guaranteed
    # never to reduce randomness.
    # 
    # @param seed the seed.
    def engine_set_seed(seed)
      synchronized(self) do
        if (!(@state).nil?)
          @digest.update(@state)
          i = 0
          while i < @state.attr_length
            @state[i] = 0
            i += 1
          end
        end
        @state = @digest.digest(seed)
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      def update_state(state, output)
        last = 1
        v = 0
        t = 0
        zf = false
        # state(n + 1) = (state(n) + output(n) + 1) % 2^160;
        i = 0
        while i < state.attr_length
          # Add two bytes
          v = (state[i]).to_int + (output[i]).to_int + last
          # Result is lower 8 bits
          t = v
          # Store result. Check for state collision.
          zf = zf | (!(state[i]).equal?(t))
          state[i] = t
          # High 8 bits are carry. Store for next iteration.
          last = v >> 8
          i += 1
        end
        # Make sure at least one bit changes!
        if (!zf)
          state[0] += 1
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    # Generates a user-specified number of random bytes.
    # 
    # @param bytes the array to be filled in with random bytes.
    def engine_next_bytes(result)
      synchronized(self) do
        index = 0
        todo = 0
        output = @remainder
        if ((@state).nil?)
          if ((self.attr_seeder).nil?)
            self.attr_seeder = SecureRandom.new(SeedGenerator.get_system_entropy)
            self.attr_seeder.engine_set_seed(engine_generate_seed(DIGEST_SIZE))
          end
          seed = Array.typed(::Java::Byte).new(DIGEST_SIZE) { 0 }
          self.attr_seeder.engine_next_bytes(seed)
          @state = @digest.digest(seed)
        end
        # Use remainder from last time
        r = @rem_count
        if (r > 0)
          # How many bytes?
          todo = (result.attr_length - index) < (DIGEST_SIZE - r) ? (result.attr_length - index) : (DIGEST_SIZE - r)
          # Copy the bytes, zero the buffer
          i = 0
          while i < todo
            result[i] = output[r]
            output[((r += 1) - 1)] = 0
            i += 1
          end
          @rem_count += todo
          index += todo
        end
        # If we need more bytes, make them.
        while (index < result.attr_length)
          # Step the state
          @digest.update(@state)
          output = @digest.digest
          update_state(@state, output)
          # How many bytes?
          todo = (result.attr_length - index) > DIGEST_SIZE ? DIGEST_SIZE : result.attr_length - index
          # Copy the bytes, zero the buffer
          i = 0
          while i < todo
            result[((index += 1) - 1)] = output[i]
            output[i] = 0
            i += 1
          end
          @rem_count += todo
        end
        # Store remainder for next time
        @remainder = output
        @rem_count %= DIGEST_SIZE
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # readObject is called to restore the state of the random object from
    # a stream.  We have to create a new instance of MessageDigest, because
    # it is not included in the stream (it is marked "transient").
    # 
    # Note that the engineNextBytes() method invoked on the restored random
    # object will yield the exact same (random) bytes as the original.
    # If you do not want this behaviour, you should re-seed the restored
    # random object, using engineSetSeed().
    def read_object(s)
      s.default_read_object
      begin
        @digest = MessageDigest.get_instance("SHA")
      rescue NoSuchAlgorithmException => e
        raise InternalError.new("internal error: SHA-1 not available.")
      end
    end
    
    private
    alias_method :initialize__secure_random, :initialize
  end
  
end
