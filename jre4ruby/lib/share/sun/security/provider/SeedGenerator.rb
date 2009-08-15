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
module Sun::Security::Provider
  module SeedGeneratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Security
      include ::Java::Io
      include_const ::Java::Util, :Properties
      include_const ::Java::Util, :Enumeration
      include ::Java::Net
      include_const ::Sun::Security::Util, :Debug
    }
  end
  
  # <P> This class generates seeds for the cryptographically strong random
  # number generator.
  # <P> The seed is produced using one of two techniques, via a computation
  # of current system activity or from an entropy gathering device.
  # <p> In the default technique the seed is  produced by counting the
  # number of times the VM manages to loop in a given period. This number
  # roughly reflects the machine load at that point in time.
  # The samples are translated using a permutation (s-box)
  # and then XORed together. This process is non linear and
  # should prevent the samples from "averaging out". The s-box
  # was designed to have even statistical distribution; it's specific
  # values are not crucial for the security of the seed.
  # We also create a number of sleeper threads which add entropy
  # to the system by keeping the scheduler busy.
  # Twenty such samples should give us roughly 160 bits of randomness.
  # <P> These values are gathered in the background by a daemon thread
  # thus allowing the system to continue performing it's different
  # activites, which in turn add entropy to the random seed.
  # <p> The class also gathers miscellaneous system information, some
  # machine dependent, some not. This information is then hashed together
  # with the 20 seed bytes.
  # <P> The alternative to the above approach is to acquire seed material
  # from an entropy gathering device, such as /dev/random. This can be
  # accomplished by setting the value of the "securerandom.source"
  # security property (in the Java security properties file) to a URL
  # specifying the location of the entropy gathering device.
  # In the event the specified URL cannot be accessed the default
  # mechanism is used.
  # The Java security properties file is located in the file named
  # &lt;JAVA_HOME&gt;/lib/security/java.security.
  # &lt;JAVA_HOME&gt; refers to the value of the java.home system property,
  # and specifies the directory where the JRE is installed.
  # 
  # @author Joshua Bloch
  # @author Gadi Guy
  class SeedGenerator 
    include_class_members SeedGeneratorImports
    
    class_module.module_eval {
      # Static instance is created at link time
      
      def instance
        defined?(@@instance) ? @@instance : @@instance= nil
      end
      alias_method :attr_instance, :instance
      
      def instance=(value)
        @@instance = value
      end
      alias_method :attr_instance=, :instance=
      
      const_set_lazy(:Debug) { Debug.get_instance("provider") }
      const_attr_reader  :Debug
      
      const_set_lazy(:URL_DEV_RANDOM) { SunEntries::URL_DEV_RANDOM }
      const_attr_reader  :URL_DEV_RANDOM
      
      const_set_lazy(:URL_DEV_URANDOM) { SunEntries::URL_DEV_URANDOM }
      const_attr_reader  :URL_DEV_URANDOM
      
      # Static initializer to hook in selected or best performing generator
      when_class_loaded do
        egd_source = SunEntries.get_seed_source
        # Try the URL specifying the source
        # e.g. file:/dev/random
        # 
        # The URL file:/dev/random or file:/dev/urandom is used to indicate
        # the SeedGenerator using OS support, if available.
        # On Windows, the causes MS CryptoAPI to be used.
        # On Solaris and Linux, this is the identical to using
        # URLSeedGenerator to read from /dev/random
        if ((egd_source == URL_DEV_RANDOM) || (egd_source == URL_DEV_URANDOM))
          begin
            self.attr_instance = NativeSeedGenerator.new
            if (!(Debug).nil?)
              Debug.println("Using operating system seed generator")
            end
          rescue IOException => e
            if (!(Debug).nil?)
              Debug.println("Failed to use operating system seed " + "generator: " + RJava.cast_to_string(e.to_s))
            end
          end
        else
          if (!(egd_source.length).equal?(0))
            begin
              self.attr_instance = URLSeedGenerator.new(egd_source)
              if (!(Debug).nil?)
                Debug.println("Using URL seed generator reading from " + egd_source)
              end
            rescue IOException => e
              if (!(Debug).nil?)
                Debug.println("Failed to create seed generator with " + egd_source + ": " + RJava.cast_to_string(e.to_s))
              end
            end
          end
        end
        # Fall back to ThreadedSeedGenerator
        if ((self.attr_instance).nil?)
          if (!(Debug).nil?)
            Debug.println("Using default threaded seed generator")
          end
          self.attr_instance = ThreadedSeedGenerator.new
        end
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Fill result with bytes from the queue. Wait for it if it isn't ready.
      def generate_seed(result)
        self.attr_instance.get_seed_bytes(result)
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    def get_seed_bytes(result)
      i = 0
      while i < result.attr_length
        result[i] = get_seed_byte
        i += 1
      end
    end
    
    typesig { [] }
    def get_seed_byte
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [] }
      # Retrieve some system information, hashed.
      def get_system_entropy
        ba = nil
        md = nil
        begin
          md = MessageDigest.get_instance("SHA")
        rescue NoSuchAlgorithmException => nsae
          raise InternalError.new("internal error: SHA-1 not available.")
        end
        # The current time in millis
        b = System.current_time_millis
        md.update(b)
        Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members SeedGenerator
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              # System properties can change from machine to machine
              s = nil
              p = System.get_properties
              e = p.property_names
              while (e.has_more_elements)
                s = RJava.cast_to_string(e.next_element)
                md.update(s.get_bytes)
                md.update(p.get_property(s).get_bytes)
              end
              md.update(InetAddress.get_local_host.to_s.get_bytes)
              # The temporary dir
              f = JavaFile.new(p.get_property("java.io.tmpdir"))
              sa = f.list
              i = 0
              while i < sa.attr_length
                md.update(sa[i].get_bytes)
                i += 1
              end
            rescue JavaException => ex
              md.update(ex.hash_code)
            end
            # get Runtime memory stats
            rt = Runtime.get_runtime
            mem_bytes = long_to_byte_array(rt.total_memory)
            md.update(mem_bytes, 0, mem_bytes.attr_length)
            mem_bytes = long_to_byte_array(rt.free_memory)
            md.update(mem_bytes, 0, mem_bytes.attr_length)
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return md.digest
      end
      
      typesig { [::Java::Long] }
      # Helper function to convert a long into a byte array (least significant
      # byte first).
      def long_to_byte_array(l)
        ret_val = Array.typed(::Java::Byte).new(8) { 0 }
        i = 0
        while i < 8
          ret_val[i] = l
          l >>= 8
          i += 1
        end
        return ret_val
      end
      
      # // This method helps the test utility receive unprocessed seed bytes.
      # public static int genTestSeed() {
      # return myself.getByte();
      # }
      const_set_lazy(:ThreadedSeedGenerator) { Class.new(SeedGenerator) do
        include_class_members SeedGenerator
        overload_protected {
          include Runnable
        }
        
        # Queue is used to collect seed bytes
        attr_accessor :pool
        alias_method :attr_pool, :pool
        undef_method :pool
        alias_method :attr_pool=, :pool=
        undef_method :pool=
        
        attr_accessor :start
        alias_method :attr_start, :start
        undef_method :start
        alias_method :attr_start=, :start=
        undef_method :start=
        
        attr_accessor :end
        alias_method :attr_end, :end
        undef_method :end
        alias_method :attr_end=, :end=
        undef_method :end=
        
        attr_accessor :count
        alias_method :attr_count, :count
        undef_method :count
        alias_method :attr_count=, :count=
        undef_method :count=
        
        # Thread group for our threads
        attr_accessor :seed_group
        alias_method :attr_seed_group, :seed_group
        undef_method :seed_group
        alias_method :attr_seed_group=, :seed_group=
        undef_method :seed_group=
        
        typesig { [] }
        # The constructor is only called once to construct the one
        # instance we actually use. It instantiates the message digest
        # and starts the thread going.
        def initialize
          @pool = nil
          @start = 0
          @end = 0
          @count = 0
          @seed_group = nil
          super()
          @pool = Array.typed(::Java::Byte).new(20) { 0 }
          @start = @end = 0
          digest = nil
          begin
            digest = MessageDigest.get_instance("SHA")
          rescue NoSuchAlgorithmException => e
            raise InternalError.new("internal error: SHA-1 not available.")
          end
          finalsg = Array.typed(JavaThreadGroup).new(1) { nil }
          t = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members ThreadedSeedGenerator
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              parent = nil
              group = JavaThread.current_thread.get_thread_group
              while (!((parent = group.get_parent)).nil?)
                group = parent
              end
              finalsg[0] = JavaThreadGroup.new(group, "SeedGenerator ThreadGroup")
              new_t = JavaThread.new(finalsg[0], @local_class_parent, "SeedGenerator Thread")
              new_t.set_priority(JavaThread::MIN_PRIORITY)
              new_t.set_daemon(true)
              return new_t
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          @seed_group = finalsg[0]
          t.start
        end
        
        typesig { [] }
        # This method does the actual work. It collects random bytes and
        # pushes them into the queue.
        def run
          begin
            while (true)
              # Queue full? Wait till there's room.
              synchronized((self)) do
                while (@count >= @pool.attr_length)
                  wait
                end
              end
              counter = 0
              quanta = 0
              v = 0
              # Spin count must not be under 64000
              counter = quanta = 0
              while (counter < 64000) && (quanta < 6)
                # Start some noisy threads
                begin
                  bt = BogusThread.new
                  t = JavaThread.new(@seed_group, bt, "SeedGenerator Thread")
                  t.start
                rescue JavaException => e
                  raise InternalError.new("internal error: " + "SeedGenerator thread creation error.")
                end
                # We wait 250milli quanta, so the minimum wait time
                # cannot be under 250milli.
                latch = 0
                latch = 0
                l = System.current_time_millis + 250
                while (System.current_time_millis < l)
                  synchronized((self)) do
                  end
                  latch += 1
                end
                # Translate the value using the permutation, and xor
                # it with previous values gathered.
                v ^= self.attr_rnd_tab[latch % 255]
                counter += latch
                quanta += 1
              end
              # Push it into the queue and notify anybody who might
              # be waiting for it.
              synchronized((self)) do
                @pool[@end] = v
                @end += 1
                @count += 1
                if (@end >= @pool.attr_length)
                  @end = 0
                end
                notify_all
              end
            end
          rescue JavaException => e
            raise InternalError.new("internal error: " + "SeedGenerator thread generated an exception.")
          end
        end
        
        typesig { [] }
        def get_seed_byte
          b = 0
          begin
            # Wait for it...
            synchronized((self)) do
              while (@count <= 0)
                wait
              end
            end
          rescue JavaException => e
            if (@count <= 0)
              raise InternalError.new("internal error: " + "SeedGenerator thread generated an exception.")
            end
          end
          synchronized((self)) do
            # Get it from the queue
            b = @pool[@start]
            @pool[@start] = 0
            @start += 1
            @count -= 1
            if ((@start).equal?(@pool.attr_length))
              @start = 0
            end
            # Notify the daemon thread, just in case it is
            # waiting for us to make room in the queue.
            notify_all
          end
          return b
        end
        
        class_module.module_eval {
          # The permutation was calculated by generating 64k of random
          # data and using it to mix the trivial permutation.
          # It should be evenly distributed. The specific values
          # are not crucial to the security of this class.
          
          def rnd_tab
            defined?(@@rnd_tab) ? @@rnd_tab : @@rnd_tab= Array.typed(::Java::Byte).new([56, 30, -107, -6, -86, 25, -83, 75, -12, -64, 5, -128, 78, 21, 16, 32, 70, -81, 37, -51, -43, -46, -108, 87, 29, 17, -55, 22, -11, -111, -115, 84, -100, 108, -45, -15, -98, 72, -33, -28, 31, -52, -37, -117, -97, -27, 93, -123, 47, 126, -80, -62, -93, -79, 61, -96, -65, -5, -47, -119, 14, 89, 81, -118, -88, 20, 67, -126, -113, 60, -102, 55, 110, 28, 85, 121, 122, -58, 2, 45, 43, 24, -9, 103, -13, 102, -68, -54, -101, -104, 19, 13, -39, -26, -103, 62, 77, 51, 44, 111, 73, 18, -127, -82, 4, -30, 11, -99, -74, 40, -89, 42, -76, -77, -94, -35, -69, 35, 120, 76, 33, -73, -7, 82, -25, -10, 88, 125, -112, 58, 83, 95, 6, 10, 98, -34, 80, 15, -91, 86, -19, 52, -17, 117, 49, -63, 118, -90, 36, -116, -40, -71, 97, -53, -109, -85, 109, -16, -3, 104, -95, 68, 54, 34, 26, 114, -1, 106, -121, 3, 66, 0, 100, -84, 57, 107, 119, -42, 112, -61, 1, 48, 38, 12, -56, -57, 39, -106, -72, 41, 7, 71, -29, -59, -8, -38, 79, -31, 124, -124, 8, 91, 116, 99, -4, 9, -36, -78, 63, -49, -67, -87, 59, 101, -32, 92, 94, 53, -41, 115, -66, -70, -122, 50, -50, -22, -20, -18, -21, 23, -2, -48, 96, 65, -105, 123, -14, -110, 69, -24, -120, -75, 74, 127, -60, 113, 90, -114, 105, 46, 27, -125, -23, -44, 64])
          end
          alias_method :attr_rnd_tab, :rnd_tab
          
          def rnd_tab=(value)
            @@rnd_tab = value
          end
          alias_method :attr_rnd_tab=, :rnd_tab=
          
          # This inner thread causes the thread scheduler to become 'noisy',
          # thus adding entropy to the system load.
          # At least one instance of this class is generated for every seed byte.
          const_set_lazy(:BogusThread) { Class.new do
            include_class_members ThreadedSeedGenerator
            include Runnable
            
            typesig { [] }
            def run
              begin
                i = 0
                while i < 5
                  JavaThread.sleep(50)
                  i += 1
                end
                # System.gc();
              rescue JavaException => e
              end
            end
            
            typesig { [] }
            def initialize
            end
            
            private
            alias_method :initialize__bogus_thread, :initialize
          end }
        }
        
        private
        alias_method :initialize__threaded_seed_generator, :initialize
      end }
      
      const_set_lazy(:URLSeedGenerator) { Class.new(SeedGenerator) do
        include_class_members SeedGenerator
        
        attr_accessor :device_name
        alias_method :attr_device_name, :device_name
        undef_method :device_name
        alias_method :attr_device_name=, :device_name=
        undef_method :device_name=
        
        attr_accessor :dev_random
        alias_method :attr_dev_random, :dev_random
        undef_method :dev_random
        alias_method :attr_dev_random=, :dev_random=
        undef_method :dev_random=
        
        typesig { [String] }
        # The constructor is only called once to construct the one
        # instance we actually use. It opens the entropy gathering device
        # which will supply the randomness.
        def initialize(egdurl)
          @device_name = nil
          @dev_random = nil
          super()
          if ((egdurl).nil?)
            raise IOException.new("No random source specified")
          end
          @device_name = egdurl
          init
        end
        
        typesig { [] }
        def initialize
          initialize__urlseed_generator(SeedGenerator::URL_DEV_RANDOM)
        end
        
        typesig { [] }
        def init
          device = URL.new(@device_name)
          @dev_random = Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members URLSeedGenerator
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              begin
                return BufferedInputStream.new(device.open_stream)
              rescue IOException => ioe
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
          if ((@dev_random).nil?)
            raise IOException.new("failed to open " + RJava.cast_to_string(device))
          end
        end
        
        typesig { [] }
        def get_seed_byte
          b = Array.typed(::Java::Byte).new(1) { 0 }
          stat = 0
          begin
            stat = @dev_random.read(b, 0, b.attr_length)
          rescue IOException => ioe
            raise InternalError.new("URLSeedGenerator " + @device_name + " generated exception: " + RJava.cast_to_string(ioe.get_message))
          end
          if ((stat).equal?(b.attr_length))
            return b[0]
          else
            if ((stat).equal?(-1))
              raise InternalError.new("URLSeedGenerator " + @device_name + " reached end of file")
            else
              raise InternalError.new("URLSeedGenerator " + @device_name + " failed read")
            end
          end
        end
        
        private
        alias_method :initialize__urlseed_generator, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__seed_generator, :initialize
  end
  
end
