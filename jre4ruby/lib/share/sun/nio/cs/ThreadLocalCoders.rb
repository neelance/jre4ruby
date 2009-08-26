require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs
  module ThreadLocalCodersImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs
      include ::Java::Nio
      include ::Java::Nio::Charset
    }
  end
  
  # Utility class for caching per-thread decoders and encoders.
  class ThreadLocalCoders 
    include_class_members ThreadLocalCodersImports
    
    class_module.module_eval {
      const_set_lazy(:CACHE_SIZE) { 3 }
      const_attr_reader  :CACHE_SIZE
      
      const_set_lazy(:Cache) { Class.new do
        include_class_members ThreadLocalCoders
        
        # Thread-local reference to array of cached objects, in LRU order
        attr_accessor :cache
        alias_method :attr_cache, :cache
        undef_method :cache
        alias_method :attr_cache=, :cache=
        undef_method :cache=
        
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        typesig { [::Java::Int] }
        def initialize(size)
          @cache = self.class::ThreadLocal.new
          @size = 0
          @size = size
        end
        
        typesig { [Object] }
        def create(name)
          raise NotImplementedError
        end
        
        typesig { [Array.typed(Object), ::Java::Int] }
        def move_to_front(oa, i)
          ob = oa[i]
          j = i
          while j > 0
            oa[j] = oa[j - 1]
            j -= 1
          end
          oa[0] = ob
        end
        
        typesig { [Object, Object] }
        def has_name(ob, name)
          raise NotImplementedError
        end
        
        typesig { [Object] }
        def for_name(name)
          oa = @cache.get
          if ((oa).nil?)
            oa = Array.typed(Object).new(@size) { nil }
            @cache.set(oa)
          else
            i = 0
            while i < oa.attr_length
              ob = oa[i]
              if ((ob).nil?)
                i += 1
                next
              end
              if (has_name(ob, name))
                if (i > 0)
                  move_to_front(oa, i)
                end
                return ob
              end
              i += 1
            end
          end
          # Create a new object
          ob = create(name)
          oa[oa.attr_length - 1] = ob
          move_to_front(oa, oa.attr_length - 1)
          return ob
        end
        
        private
        alias_method :initialize__cache, :initialize
      end }
      
      
      def decoder_cache
        defined?(@@decoder_cache) ? @@decoder_cache : @@decoder_cache= Class.new(Cache.class == Class ? Cache : Object) do
          extend LocalClass
          include_class_members ThreadLocalCoders
          include Cache if Cache.class == Module
          
          typesig { [Object, Object] }
          define_method :has_name do |ob, name|
            if (name.is_a?(self.class::String))
              return (((ob).charset.name == name))
            end
            if (name.is_a?(self.class::Charset))
              return ((ob).charset == name)
            end
            return false
          end
          
          typesig { [Object] }
          define_method :create do |name|
            if (name.is_a?(self.class::String))
              return Charset.for_name(name).new_decoder
            end
            if (name.is_a?(self.class::Charset))
              return (name).new_decoder
            end
            raise AssertError if not (false)
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self, CACHE_SIZE)
      end
      alias_method :attr_decoder_cache, :decoder_cache
      
      def decoder_cache=(value)
        @@decoder_cache = value
      end
      alias_method :attr_decoder_cache=, :decoder_cache=
      
      typesig { [Object] }
      def decoder_for(name)
        cd = self.attr_decoder_cache.for_name(name)
        cd.reset
        return cd
      end
      
      
      def encoder_cache
        defined?(@@encoder_cache) ? @@encoder_cache : @@encoder_cache= Class.new(Cache.class == Class ? Cache : Object) do
          extend LocalClass
          include_class_members ThreadLocalCoders
          include Cache if Cache.class == Module
          
          typesig { [Object, Object] }
          define_method :has_name do |ob, name|
            if (name.is_a?(self.class::String))
              return (((ob).charset.name == name))
            end
            if (name.is_a?(self.class::Charset))
              return ((ob).charset == name)
            end
            return false
          end
          
          typesig { [Object] }
          define_method :create do |name|
            if (name.is_a?(self.class::String))
              return Charset.for_name(name).new_encoder
            end
            if (name.is_a?(self.class::Charset))
              return (name).new_encoder
            end
            raise AssertError if not (false)
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self, CACHE_SIZE)
      end
      alias_method :attr_encoder_cache, :encoder_cache
      
      def encoder_cache=(value)
        @@encoder_cache = value
      end
      alias_method :attr_encoder_cache=, :encoder_cache=
      
      typesig { [Object] }
      def encoder_for(name)
        ce = self.attr_encoder_cache.for_name(name)
        ce.reset
        return ce
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__thread_local_coders, :initialize
  end
  
end
