require "rjava"

# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module UtilImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Lang::Ref, :SoftReference
      include ::Java::Lang::Reflect
      include_const ::Java::Io, :IOException
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :MappedByteBuffer
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include ::Java::Util
      include_const ::Sun::Misc, :Unsafe
      include_const ::Sun::Misc, :Cleaner
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  class Util 
    include_class_members UtilImports
    
    class_module.module_eval {
      # -- Caches --
      # The number of temp buffers in our pool
      const_set_lazy(:TEMP_BUF_POOL_SIZE) { 3 }
      const_attr_reader  :TEMP_BUF_POOL_SIZE
      
      # Per-thread soft cache of the last temporary direct buffer
      
      def buffer_pool
        defined?(@@buffer_pool) ? @@buffer_pool : @@buffer_pool= nil
      end
      alias_method :attr_buffer_pool, :buffer_pool
      
      def buffer_pool=(value)
        @@buffer_pool = value
      end
      alias_method :attr_buffer_pool=, :buffer_pool=
      
      when_class_loaded do
        self.attr_buffer_pool = Array.typed(ThreadLocal).new(TEMP_BUF_POOL_SIZE) { nil }
        i = 0
        while i < TEMP_BUF_POOL_SIZE
          self.attr_buffer_pool[i] = ThreadLocal.new
          i += 1
        end
      end
      
      typesig { [::Java::Int] }
      def get_temporary_direct_buffer(size)
        buf = nil
        # Grab a buffer if available
        i = 0
        while i < TEMP_BUF_POOL_SIZE
          ref = (self.attr_buffer_pool[i].get)
          if ((!(ref).nil?) && (!((buf = ref.get)).nil?) && (buf.capacity >= size))
            buf.rewind
            buf.limit(size)
            self.attr_buffer_pool[i].set(nil)
            return buf
          end
          i += 1
        end
        # Make a new one
        return ByteBuffer.allocate_direct(size)
      end
      
      typesig { [ByteBuffer] }
      def release_temporary_direct_buffer(buf)
        if ((buf).nil?)
          return
        end
        # Put it in an empty slot if such exists
        i = 0
        while i < TEMP_BUF_POOL_SIZE
          ref = (self.attr_buffer_pool[i].get)
          if (((ref).nil?) || ((ref.get).nil?))
            self.attr_buffer_pool[i].set(SoftReference.new(buf))
            return
          end
          i += 1
        end
        # Otherwise replace a smaller one in the cache if such exists
        i_ = 0
        while i_ < TEMP_BUF_POOL_SIZE
          ref = (self.attr_buffer_pool[i_].get)
          in_cache_buf = ref.get
          if (((in_cache_buf).nil?) || (buf.capacity > in_cache_buf.capacity))
            self.attr_buffer_pool[i_].set(SoftReference.new(buf))
            return
          end
          i_ += 1
        end
      end
      
      const_set_lazy(:SelectorWrapper) { Class.new do
        include_class_members Util
        
        attr_accessor :sel
        alias_method :attr_sel, :sel
        undef_method :sel
        alias_method :attr_sel=, :sel=
        undef_method :sel=
        
        typesig { [class_self::Selector] }
        def initialize(sel)
          @sel = nil
          @sel = sel
          Cleaner.create(self, self.class::Closer.new(sel))
        end
        
        class_module.module_eval {
          const_set_lazy(:Closer) { Class.new do
            include_class_members SelectorWrapper
            include class_self::Runnable
            
            attr_accessor :sel
            alias_method :attr_sel, :sel
            undef_method :sel
            alias_method :attr_sel=, :sel=
            undef_method :sel=
            
            typesig { [class_self::Selector] }
            def initialize(sel)
              @sel = nil
              @sel = sel
            end
            
            typesig { [] }
            def run
              begin
                @sel.close
              rescue self.class::JavaThrowable => th
                raise self.class::JavaError.new(th)
              end
            end
            
            private
            alias_method :initialize__closer, :initialize
          end }
        }
        
        typesig { [] }
        def get
          return @sel
        end
        
        private
        alias_method :initialize__selector_wrapper, :initialize
      end }
      
      # Per-thread cached selector
      
      def local_selector
        defined?(@@local_selector) ? @@local_selector : @@local_selector= ThreadLocal.new
      end
      alias_method :attr_local_selector, :local_selector
      
      def local_selector=(value)
        @@local_selector = value
      end
      alias_method :attr_local_selector=, :local_selector=
      
      # Hold a reference to the selWrapper object to prevent it from
      # being cleaned when the temporary selector wrapped is on lease.
      
      def local_selector_wrapper
        defined?(@@local_selector_wrapper) ? @@local_selector_wrapper : @@local_selector_wrapper= ThreadLocal.new
      end
      alias_method :attr_local_selector_wrapper, :local_selector_wrapper
      
      def local_selector_wrapper=(value)
        @@local_selector_wrapper = value
      end
      alias_method :attr_local_selector_wrapper=, :local_selector_wrapper=
      
      typesig { [SelectableChannel] }
      # When finished, invoker must ensure that selector is empty
      # by cancelling any related keys and explicitly releasing
      # the selector by invoking releaseTemporarySelector()
      def get_temporary_selector(sc)
        ref = self.attr_local_selector.get
        sel_wrapper = nil
        sel = nil
        if ((ref).nil? || (((sel_wrapper = ref.get)).nil?) || (((sel = sel_wrapper.get)).nil?) || (!(sel.provider).equal?(sc.provider)))
          sel = sc.provider.open_selector
          self.attr_local_selector.set(SoftReference.new(SelectorWrapper.new(sel)))
        else
          self.attr_local_selector_wrapper.set(sel_wrapper)
        end
        return sel
      end
      
      typesig { [Selector] }
      def release_temporary_selector(sel)
        # Selector should be empty
        sel.select_now # Flush cancelled keys
        raise AssertError, "Temporary selector not empty" if not (sel.keys.is_empty)
        self.attr_local_selector_wrapper.set(nil)
      end
      
      typesig { [Array.typed(ByteBuffer), ::Java::Int, ::Java::Int] }
      # -- Random stuff --
      def subsequence(bs, offset, length)
        if (((offset).equal?(0)) && ((length).equal?(bs.attr_length)))
          return bs
        end
        n = length
        bs2 = Array.typed(ByteBuffer).new(n) { nil }
        i = 0
        while i < n
          bs2[i] = bs[offset + i]
          i += 1
        end
        return bs2
      end
      
      typesig { [JavaSet] }
      def ungrowable_set(s)
        return Class.new(JavaSet.class == Class ? JavaSet : Object) do
          extend LocalClass
          include_class_members Util
          include JavaSet if JavaSet.class == Module
          
          typesig { [] }
          define_method :size do
            return s.size
          end
          
          typesig { [] }
          define_method :is_empty do
            return s.is_empty
          end
          
          typesig { [Object] }
          define_method :contains do |o|
            return s.contains(o)
          end
          
          typesig { [] }
          define_method :to_array do
            return s.to_array
          end
          
          typesig { [Array.typed(Object)] }
          define_method :to_array do |a|
            return s.to_array(a)
          end
          
          typesig { [] }
          define_method :to_s do
            return s.to_s
          end
          
          typesig { [] }
          define_method :iterator do
            return s.iterator
          end
          
          typesig { [Object] }
          define_method :== do |o|
            return (s == o)
          end
          
          typesig { [] }
          define_method :hash_code do
            return s.hash_code
          end
          
          typesig { [] }
          define_method :clear do
            s.clear
          end
          
          typesig { [Object] }
          define_method :remove do |o|
            return s.remove(o)
          end
          
          typesig { [Collection] }
          define_method :contains_all do |coll|
            return s.contains_all(coll)
          end
          
          typesig { [Collection] }
          define_method :remove_all do |coll|
            return s.remove_all(coll)
          end
          
          typesig { [Collection] }
          define_method :retain_all do |coll|
            return s.retain_all(coll)
          end
          
          typesig { [E] }
          define_method :add do |o|
            raise self.class::UnsupportedOperationException.new
          end
          
          typesig { [Collection] }
          define_method :add_all do |coll|
            raise self.class::UnsupportedOperationException.new
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      # -- Unsafe access --
      
      def unsafe
        defined?(@@unsafe) ? @@unsafe : @@unsafe= Unsafe.get_unsafe
      end
      alias_method :attr_unsafe, :unsafe
      
      def unsafe=(value)
        @@unsafe = value
      end
      alias_method :attr_unsafe=, :unsafe=
      
      typesig { [::Java::Long] }
      def __get(a)
        return self.attr_unsafe.get_byte(a)
      end
      
      typesig { [::Java::Long, ::Java::Byte] }
      def __put(a, b)
        self.attr_unsafe.put_byte(a, b)
      end
      
      typesig { [ByteBuffer] }
      def erase(bb)
        self.attr_unsafe.set_memory((bb).address, bb.capacity, 0)
      end
      
      typesig { [] }
      def unsafe
        return self.attr_unsafe
      end
      
      
      def page_size
        defined?(@@page_size) ? @@page_size : @@page_size= -1
      end
      alias_method :attr_page_size, :page_size
      
      def page_size=(value)
        @@page_size = value
      end
      alias_method :attr_page_size=, :page_size=
      
      typesig { [] }
      def page_size
        if ((self.attr_page_size).equal?(-1))
          self.attr_page_size = unsafe.page_size
        end
        return self.attr_page_size
      end
      
      
      def direct_byte_buffer_constructor
        defined?(@@direct_byte_buffer_constructor) ? @@direct_byte_buffer_constructor : @@direct_byte_buffer_constructor= nil
      end
      alias_method :attr_direct_byte_buffer_constructor, :direct_byte_buffer_constructor
      
      def direct_byte_buffer_constructor=(value)
        @@direct_byte_buffer_constructor = value
      end
      alias_method :attr_direct_byte_buffer_constructor=, :direct_byte_buffer_constructor=
      
      typesig { [] }
      def init_dbbconstructor
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Util
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              cl = Class.for_name("java.nio.DirectByteBuffer")
              ctor = cl.get_declared_constructor(Array.typed(self.class::Class).new([Array, Array, Runnable]))
              ctor.set_accessible(true)
              self.attr_direct_byte_buffer_constructor = ctor
            rescue self.class::ClassNotFoundException => x
              raise self.class::InternalError.new
            rescue self.class::NoSuchMethodException => x
              raise self.class::InternalError.new
            rescue self.class::IllegalArgumentException => x
              raise self.class::InternalError.new
            rescue self.class::ClassCastException => x
              raise self.class::InternalError.new
            end
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [::Java::Int, ::Java::Long, Runnable] }
      def new_mapped_byte_buffer(size, addr, unmapper)
        dbb = nil
        if ((self.attr_direct_byte_buffer_constructor).nil?)
          init_dbbconstructor
        end
        begin
          dbb = self.attr_direct_byte_buffer_constructor.new_instance(Array.typed(Object).new([size, Long.new(addr), unmapper]))
        rescue InstantiationException => e
          raise InternalError.new
        rescue IllegalAccessException => e
          raise InternalError.new
        rescue InvocationTargetException => e
          raise InternalError.new
        end
        return dbb
      end
      
      
      def direct_byte_buffer_rconstructor
        defined?(@@direct_byte_buffer_rconstructor) ? @@direct_byte_buffer_rconstructor : @@direct_byte_buffer_rconstructor= nil
      end
      alias_method :attr_direct_byte_buffer_rconstructor, :direct_byte_buffer_rconstructor
      
      def direct_byte_buffer_rconstructor=(value)
        @@direct_byte_buffer_rconstructor = value
      end
      alias_method :attr_direct_byte_buffer_rconstructor=, :direct_byte_buffer_rconstructor=
      
      typesig { [] }
      def init_dbbrconstructor
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Util
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              cl = Class.for_name("java.nio.DirectByteBufferR")
              ctor = cl.get_declared_constructor(Array.typed(self.class::Class).new([Array, Array, Runnable]))
              ctor.set_accessible(true)
              self.attr_direct_byte_buffer_rconstructor = ctor
            rescue self.class::ClassNotFoundException => x
              raise self.class::InternalError.new
            rescue self.class::NoSuchMethodException => x
              raise self.class::InternalError.new
            rescue self.class::IllegalArgumentException => x
              raise self.class::InternalError.new
            rescue self.class::ClassCastException => x
              raise self.class::InternalError.new
            end
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [::Java::Int, ::Java::Long, Runnable] }
      def new_mapped_byte_buffer_r(size, addr, unmapper)
        dbb = nil
        if ((self.attr_direct_byte_buffer_rconstructor).nil?)
          init_dbbrconstructor
        end
        begin
          dbb = self.attr_direct_byte_buffer_rconstructor.new_instance(Array.typed(Object).new([size, Long.new(addr), unmapper]))
        rescue InstantiationException => e
          raise InternalError.new
        rescue IllegalAccessException => e
          raise InternalError.new
        rescue InvocationTargetException => e
          raise InternalError.new
        end
        return dbb
      end
      
      # -- Bug compatibility --
      
      def bug_level
        defined?(@@bug_level) ? @@bug_level : @@bug_level= nil
      end
      alias_method :attr_bug_level, :bug_level
      
      def bug_level=(value)
        @@bug_level = value
      end
      alias_method :attr_bug_level=, :bug_level=
      
      typesig { [String] }
      def at_bug_level(bl)
        # package-private
        if ((self.attr_bug_level).nil?)
          if (!Sun::Misc::VM.is_booted)
            return false
          end
          value = AccessController.do_privileged(GetPropertyAction.new("sun.nio.ch.bugLevel"))
          self.attr_bug_level = RJava.cast_to_string((!(value).nil?) ? value : "")
        end
        return (self.attr_bug_level == bl)
      end
      
      # -- Initialization --
      
      def loaded
        defined?(@@loaded) ? @@loaded : @@loaded= false
      end
      alias_method :attr_loaded, :loaded
      
      def loaded=(value)
        @@loaded = value
      end
      alias_method :attr_loaded=, :loaded=
      
      typesig { [] }
      def load
        synchronized((Util)) do
          if (self.attr_loaded)
            return
          end
          self.attr_loaded = true
          Java::Security::AccessController.do_privileged(Sun::Security::Action::LoadLibraryAction.new("net"))
          Java::Security::AccessController.do_privileged(Sun::Security::Action::LoadLibraryAction.new("nio"))
          # IOUtil must be initialized; Its native methods are called from
          # other places in native nio code so they must be set up.
          IOUtil.init_ids
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__util, :initialize
  end
  
end
