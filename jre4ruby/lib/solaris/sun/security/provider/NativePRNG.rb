require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NativePRNGImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Io
      include ::Java::Security
      include_const ::Java::Security, :SecureRandom
    }
  end
  
  # Native PRNG implementation for Solaris/Linux. It interacts with
  # /dev/random and /dev/urandom, so it is only available if those
  # files are present. Otherwise, SHA1PRNG is used instead of this class.
  # 
  # getSeed() and setSeed() directly read/write /dev/random. However,
  # /dev/random is only writable by root in many configurations. Because
  # we cannot just ignore bytes specified via setSeed(), we keep a
  # SHA1PRNG around in parallel.
  # 
  # nextBytes() reads the bytes directly from /dev/urandom (and then
  # mixes them with bytes from the SHA1PRNG for the reasons explained
  # above). Reading bytes from /dev/urandom means that constantly get
  # new entropy the operating system has collected. This is a notable
  # advantage over the SHA1PRNG model, which acquires entropy only
  # initially during startup although the VM may be running for months.
  # 
  # Also note that we do not need any initial pure random seed from
  # /dev/random. This is an advantage because on some versions of Linux
  # it can be exhausted very quickly and could thus impact startup time.
  # 
  # Finally, note that we use a singleton for the actual work (RandomIO)
  # to avoid having to open and close /dev/[u]random constantly. However,
  # there may me many NativePRNG instances created by the JCA framework.
  # 
  # @since   1.5
  # @author  Andreas Sterbenz
  class NativePRNG < NativePRNGImports.const_get :SecureRandomSpi
    include_class_members NativePRNGImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -6599091113397072932 }
      const_attr_reader  :SerialVersionUID
      
      # name of the pure random file (also used for setSeed())
      const_set_lazy(:NAME_RANDOM) { "/dev/random" }
      const_attr_reader  :NAME_RANDOM
      
      # name of the pseudo random file
      const_set_lazy(:NAME_URANDOM) { "/dev/urandom" }
      const_attr_reader  :NAME_URANDOM
      
      # singleton instance or null if not available
      const_set_lazy(:INSTANCE) { init_io }
      const_attr_reader  :INSTANCE
      
      typesig { [] }
      def init_io
        o = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members NativePRNG
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            random_file = self.class::JavaFile.new(NAME_RANDOM)
            if ((random_file.exists).equal?(false))
              return nil
            end
            urandom_file = self.class::JavaFile.new(NAME_URANDOM)
            if ((urandom_file.exists).equal?(false))
              return nil
            end
            begin
              return self.class::RandomIO.new(random_file, urandom_file)
            rescue self.class::JavaException => e
              return nil
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return o
      end
      
      typesig { [] }
      # return whether the NativePRNG is available
      def is_available
        return !(INSTANCE).nil?
      end
    }
    
    typesig { [] }
    # constructor, called by the JCA framework
    def initialize
      super()
      if ((INSTANCE).nil?)
        raise AssertionError.new("NativePRNG not available")
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # set the seed
    def engine_set_seed(seed)
      INSTANCE.impl_set_seed(seed)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # get pseudo random bytes
    def engine_next_bytes(bytes)
      INSTANCE.impl_next_bytes(bytes)
    end
    
    typesig { [::Java::Int] }
    # get true random bytes
    def engine_generate_seed(num_bytes)
      return INSTANCE.impl_generate_seed(num_bytes)
    end
    
    class_module.module_eval {
      # Nested class doing the actual work. Singleton, see INSTANCE above.
      const_set_lazy(:RandomIO) { Class.new do
        include_class_members NativePRNG
        
        class_module.module_eval {
          # we buffer data we read from /dev/urandom for efficiency,
          # but we limit the lifetime to avoid using stale bits
          # lifetime in ms, currently 100 ms (0.1 s)
          const_set_lazy(:MAX_BUFFER_TIME) { 100 }
          const_attr_reader  :MAX_BUFFER_TIME
          
          # size of the /dev/urandom buffer
          const_set_lazy(:BUFFER_SIZE) { 32 }
          const_attr_reader  :BUFFER_SIZE
        }
        
        # In/OutputStream for /dev/random and /dev/urandom
        attr_accessor :random_in
        alias_method :attr_random_in, :random_in
        undef_method :random_in
        alias_method :attr_random_in=, :random_in=
        undef_method :random_in=
        
        attr_accessor :urandom_in
        alias_method :attr_urandom_in, :urandom_in
        undef_method :urandom_in
        alias_method :attr_urandom_in=, :urandom_in=
        undef_method :urandom_in=
        
        attr_accessor :random_out
        alias_method :attr_random_out, :random_out
        undef_method :random_out
        alias_method :attr_random_out=, :random_out=
        undef_method :random_out=
        
        # flag indicating if we have tried to open randomOut yet
        attr_accessor :random_out_initialized
        alias_method :attr_random_out_initialized, :random_out_initialized
        undef_method :random_out_initialized
        alias_method :attr_random_out_initialized=, :random_out_initialized=
        undef_method :random_out_initialized=
        
        # SHA1PRNG instance for mixing
        # initialized lazily on demand to avoid problems during startup
        attr_accessor :mix_random
        alias_method :attr_mix_random, :mix_random
        undef_method :mix_random
        alias_method :attr_mix_random=, :mix_random=
        undef_method :mix_random=
        
        # buffer for /dev/urandom bits
        attr_accessor :urandom_buffer
        alias_method :attr_urandom_buffer, :urandom_buffer
        undef_method :urandom_buffer
        alias_method :attr_urandom_buffer=, :urandom_buffer=
        undef_method :urandom_buffer=
        
        # number of bytes left in urandomBuffer
        attr_accessor :buffered
        alias_method :attr_buffered, :buffered
        undef_method :buffered
        alias_method :attr_buffered=, :buffered=
        undef_method :buffered=
        
        # time we read the data into the urandomBuffer
        attr_accessor :last_read
        alias_method :attr_last_read, :last_read
        undef_method :last_read
        alias_method :attr_last_read=, :last_read=
        undef_method :last_read=
        
        # mutex lock for nextBytes()
        attr_accessor :lock_get_bytes
        alias_method :attr_lock_get_bytes, :lock_get_bytes
        undef_method :lock_get_bytes
        alias_method :attr_lock_get_bytes=, :lock_get_bytes=
        undef_method :lock_get_bytes=
        
        # mutex lock for getSeed()
        attr_accessor :lock_get_seed
        alias_method :attr_lock_get_seed, :lock_get_seed
        undef_method :lock_get_seed
        alias_method :attr_lock_get_seed=, :lock_get_seed=
        undef_method :lock_get_seed=
        
        # mutex lock for setSeed()
        attr_accessor :lock_set_seed
        alias_method :attr_lock_set_seed, :lock_set_seed
        undef_method :lock_set_seed
        alias_method :attr_lock_set_seed=, :lock_set_seed=
        undef_method :lock_set_seed=
        
        typesig { [self::JavaFile, self::JavaFile] }
        # constructor, called only once from initIO()
        def initialize(random_file, urandom_file)
          @random_in = nil
          @urandom_in = nil
          @random_out = nil
          @random_out_initialized = false
          @mix_random = nil
          @urandom_buffer = nil
          @buffered = 0
          @last_read = 0
          @lock_get_bytes = self.class::Object.new
          @lock_get_seed = self.class::Object.new
          @lock_set_seed = self.class::Object.new
          @random_in = self.class::FileInputStream.new(random_file)
          @urandom_in = self.class::FileInputStream.new(urandom_file)
          @urandom_buffer = Array.typed(::Java::Byte).new(self.class::BUFFER_SIZE) { 0 }
        end
        
        typesig { [] }
        # get the SHA1PRNG for mixing
        # initialize if not yet created
        def get_mix_random
          r = @mix_random
          if ((r).nil?)
            synchronized((@lock_get_bytes)) do
              r = @mix_random
              if ((r).nil?)
                r = Sun::Security::Provider::self.class::SecureRandom.new
                begin
                  b = Array.typed(::Java::Byte).new(20) { 0 }
                  read_fully(@urandom_in, b)
                  r.engine_set_seed(b)
                rescue self.class::IOException => e
                  raise self.class::ProviderException.new("init failed", e)
                end
                @mix_random = r
              end
            end
          end
          return r
        end
        
        class_module.module_eval {
          typesig { [self::InputStream, Array.typed(::Java::Byte)] }
          # read data.length bytes from in
          # /dev/[u]random are not normal files, so we need to loop the read.
          # just keep trying as long as we are making progress
          def read_fully(in_, data)
            len = data.attr_length
            ofs = 0
            while (len > 0)
              k = in_.read(data, ofs, len)
              if (k <= 0)
                raise self.class::EOFException.new("/dev/[u]random closed?")
              end
              ofs += k
              len -= k
            end
            if (len > 0)
              raise self.class::IOException.new("Could not read from /dev/[u]random")
            end
          end
        }
        
        typesig { [::Java::Int] }
        # get true random bytes, just read from /dev/random
        def impl_generate_seed(num_bytes)
          synchronized((@lock_get_seed)) do
            begin
              b = Array.typed(::Java::Byte).new(num_bytes) { 0 }
              read_fully(@random_in, b)
              return b
            rescue self.class::IOException => e
              raise self.class::ProviderException.new("generateSeed() failed", e)
            end
          end
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        # supply random bytes to the OS
        # write to /dev/random if possible
        # always add the seed to our mixing random
        def impl_set_seed(seed)
          synchronized((@lock_set_seed)) do
            if ((@random_out_initialized).equal?(false))
              @random_out_initialized = true
              @random_out = AccessController.do_privileged(Class.new(self.class::PrivilegedAction.class == Class ? self.class::PrivilegedAction : Object) do
                extend LocalClass
                include_class_members RandomIO
                include self::PrivilegedAction if self::PrivilegedAction.class == Module
                
                typesig { [] }
                define_method :run do
                  begin
                    return self.class::FileOutputStream.new(NAME_RANDOM, true)
                  rescue self.class::JavaException => e
                    return nil
                  end
                end
                
                typesig { [] }
                define_method :initialize do
                  super()
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
            end
            if (!(@random_out).nil?)
              begin
                @random_out.write(seed)
              rescue self.class::IOException => e
                raise self.class::ProviderException.new("setSeed() failed", e)
              end
            end
            get_mix_random.engine_set_seed(seed)
          end
        end
        
        typesig { [] }
        # ensure that there is at least one valid byte in the buffer
        # if not, read new bytes
        def ensure_buffer_valid
          time = System.current_time_millis
          if ((@buffered > 0) && (time - @last_read < self.class::MAX_BUFFER_TIME))
            return
          end
          @last_read = time
          read_fully(@urandom_in, @urandom_buffer)
          @buffered = @urandom_buffer.attr_length
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        # get pseudo random bytes
        # read from /dev/urandom and XOR with bytes generated by the
        # mixing SHA1PRNG
        def impl_next_bytes(data)
          synchronized((@lock_get_bytes)) do
            begin
              get_mix_random.engine_next_bytes(data)
              len = data.attr_length
              ofs = 0
              while (len > 0)
                ensure_buffer_valid
                buffer_ofs = @urandom_buffer.attr_length - @buffered
                while ((len > 0) && (@buffered > 0))
                  data[((ofs += 1) - 1)] ^= @urandom_buffer[((buffer_ofs += 1) - 1)]
                  len -= 1
                  @buffered -= 1
                end
              end
            rescue self.class::IOException => e
              raise self.class::ProviderException.new("nextBytes() failed", e)
            end
          end
        end
        
        private
        alias_method :initialize__random_io, :initialize
      end }
    }
    
    private
    alias_method :initialize__native_prng, :initialize
  end
  
end
