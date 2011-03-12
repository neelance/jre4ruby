require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module SoftCacheImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Lang::Ref, :ReferenceQueue
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :AbstractMap
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :AbstractSet
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # A memory-sensitive implementation of the <code>Map</code> interface.
  # 
  # <p> A <code>SoftCache</code> object uses {@link java.lang.ref.SoftReference
  # soft references} to implement a memory-sensitive hash map.  If the garbage
  # collector determines at a certain point in time that a value object in a
  # <code>SoftCache</code> entry is no longer strongly reachable, then it may
  # remove that entry in order to release the memory occupied by the value
  # object.  All <code>SoftCache</code> objects are guaranteed to be completely
  # cleared before the virtual machine will throw an
  # <code>OutOfMemoryError</code>.  Because of this automatic clearing feature,
  # the behavior of this class is somewhat different from that of other
  # <code>Map</code> implementations.
  # 
  # <p> Both null values and the null key are supported.  This class has the
  # same performance characteristics as the <code>HashMap</code> class, and has
  # the same efficiency parameters of <em>initial capacity</em> and <em>load
  # factor</em>.
  # 
  # <p> Like most collection classes, this class is not synchronized.  A
  # synchronized <code>SoftCache</code> may be constructed using the
  # <code>Collections.synchronizedMap</code> method.
  # 
  # <p> In typical usage this class will be subclassed and the <code>fill</code>
  # method will be overridden.  When the <code>get</code> method is invoked on a
  # key for which there is no mapping in the cache, it will in turn invoke the
  # <code>fill</code> method on that key in an attempt to construct a
  # corresponding value.  If the <code>fill</code> method returns such a value
  # then the cache will be updated and the new value will be returned.  Thus,
  # for example, a simple URL-content cache can be constructed as follows:
  # 
  # <pre>
  #     public class URLCache extends SoftCache {
  #         protected Object fill(Object key) {
  #             return ((URL)key).getContent();
  #         }
  #     }
  # </pre>
  # 
  # <p> The behavior of the <code>SoftCache</code> class depends in part upon
  # the actions of the garbage collector, so several familiar (though not
  # required) <code>Map</code> invariants do not hold for this class.  <p>
  # Because entries are removed from a <code>SoftCache</code> in response to
  # dynamic advice from the garbage collector, a <code>SoftCache</code> may
  # behave as though an unknown thread is silently removing entries.  In
  # particular, even if you synchronize on a <code>SoftCache</code> instance and
  # invoke none of its mutator methods, it is possible for the <code>size</code>
  # method to return smaller values over time, for the <code>isEmpty</code>
  # method to return <code>false</code> and then <code>true</code>, for the
  # <code>containsKey</code> method to return <code>true</code> and later
  # <code>false</code> for a given key, for the <code>get</code> method to
  # return a value for a given key but later return <code>null</code>, for the
  # <code>put</code> method to return <code>null</code> and the
  # <code>remove</code> method to return <code>false</code> for a key that
  # previously appeared to be in the map, and for successive examinations of the
  # key set, the value set, and the entry set to yield successively smaller
  # numbers of elements.
  # 
  # @author      Mark Reinhold
  # @since       1.2
  # @see         java.util.HashMap
  # @see         java.lang.ref.SoftReference
  class SoftCache < SoftCacheImports.const_get :AbstractMap
    include_class_members SoftCacheImports
    overload_protected {
      include Map
    }
    
    class_module.module_eval {
      # The basic idea of this implementation is to maintain an internal HashMap
      # that maps keys to soft references whose referents are the keys' values;
      # the various accessor methods dereference these soft references before
      # returning values.  Because we don't have access to the innards of the
      # HashMap, each soft reference must contain the key that maps to it so
      # that the processQueue method can remove keys whose values have been
      # discarded.  Thus the HashMap actually maps keys to instances of the
      # ValueCell class, which is a simple extension of the SoftReference class.
      const_set_lazy(:ValueCell) { Class.new(SoftReference) do
        include_class_members SoftCache
        
        class_module.module_eval {
          
          def invalid_key
            defined?(@@invalid_key) ? @@invalid_key : @@invalid_key= Object.new
          end
          alias_method :attr_invalid_key, :invalid_key
          
          def invalid_key=(value)
            @@invalid_key = value
          end
          alias_method :attr_invalid_key=, :invalid_key=
          
          
          def dropped
            defined?(@@dropped) ? @@dropped : @@dropped= 0
          end
          alias_method :attr_dropped, :dropped
          
          def dropped=(value)
            @@dropped = value
          end
          alias_method :attr_dropped=, :dropped=
        }
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        typesig { [Object, Object, class_self::ReferenceQueue] }
        def initialize(key, value, queue)
          @key = nil
          super(value, queue)
          @key = key
        end
        
        class_module.module_eval {
          typesig { [Object, Object, class_self::ReferenceQueue] }
          def create(key, value, queue)
            if ((value).nil?)
              return nil
            end
            return class_self::ValueCell.new(key, value, queue)
          end
          
          typesig { [Object, ::Java::Boolean] }
          def strip(val, drop)
            if ((val).nil?)
              return nil
            end
            vc = val
            o = vc.get
            if (drop)
              vc.drop
            end
            return o
          end
        }
        
        typesig { [] }
        def is_valid
          return (!(@key).equal?(self.attr_invalid_key))
        end
        
        typesig { [] }
        def drop
          SoftReference.instance_method(:clear).bind(self).call
          @key = self.attr_invalid_key
          self.attr_dropped += 1
        end
        
        private
        alias_method :initialize__value_cell, :initialize
      end }
    }
    
    # Hash table mapping keys to ValueCells
    attr_accessor :hash
    alias_method :attr_hash, :hash
    undef_method :hash
    alias_method :attr_hash=, :hash=
    undef_method :hash=
    
    # Reference queue for cleared ValueCells
    attr_accessor :queue
    alias_method :attr_queue, :queue
    undef_method :queue
    alias_method :attr_queue=, :queue=
    undef_method :queue=
    
    typesig { [] }
    # Process any ValueCells that have been cleared and enqueued by the
    # garbage collector.  This method should be invoked once by each public
    # mutator in this class.  We don't invoke this method in public accessors
    # because that can lead to surprising ConcurrentModificationExceptions.
    def process_queue
      vc = nil
      while (!((vc = @queue.poll)).nil?)
        if (vc.is_valid)
          @hash.remove(vc.attr_key)
        else
          ValueCell.attr_dropped -= 1
        end
      end
    end
    
    typesig { [::Java::Int, ::Java::Float] }
    # -- Constructors --
    # Construct a new, empty <code>SoftCache</code> with the given
    # initial capacity and the given load factor.
    # 
    # @param  initialCapacity  The initial capacity of the cache
    # 
    # @param  loadFactor       A number between 0.0 and 1.0
    # 
    # @throws IllegalArgumentException  If the initial capacity is less than
    #                                   or equal to zero, or if the load
    #                                   factor is less than zero
    def initialize(initial_capacity, load_factor)
      @hash = nil
      @queue = nil
      @entry_set = nil
      super()
      @queue = ReferenceQueue.new
      @entry_set = nil
      @hash = HashMap.new(initial_capacity, load_factor)
    end
    
    typesig { [::Java::Int] }
    # Construct a new, empty <code>SoftCache</code> with the given
    # initial capacity and the default load factor.
    # 
    # @param  initialCapacity  The initial capacity of the cache
    # 
    # @throws IllegalArgumentException  If the initial capacity is less than
    #                                   or equal to zero
    def initialize(initial_capacity)
      @hash = nil
      @queue = nil
      @entry_set = nil
      super()
      @queue = ReferenceQueue.new
      @entry_set = nil
      @hash = HashMap.new(initial_capacity)
    end
    
    typesig { [] }
    # Construct a new, empty <code>SoftCache</code> with the default
    # capacity and the default load factor.
    def initialize
      @hash = nil
      @queue = nil
      @entry_set = nil
      super()
      @queue = ReferenceQueue.new
      @entry_set = nil
      @hash = HashMap.new
    end
    
    typesig { [] }
    # -- Simple queries --
    # Return the number of key-value mappings in this cache.  The time
    # required by this operation is linear in the size of the map.
    def size
      return entry_set.size
    end
    
    typesig { [] }
    # Return <code>true</code> if this cache contains no key-value mappings.
    def is_empty
      return entry_set.is_empty
    end
    
    typesig { [Object] }
    # Return <code>true</code> if this cache contains a mapping for the
    # specified key.  If there is no mapping for the key, this method will not
    # attempt to construct one by invoking the <code>fill</code> method.
    # 
    # @param   key   The key whose presence in the cache is to be tested
    def contains_key(key)
      return !(ValueCell.strip(@hash.get(key), false)).nil?
    end
    
    typesig { [Object] }
    # -- Lookup and modification operations --
    # Create a value object for the given <code>key</code>.  This method is
    # invoked by the <code>get</code> method when there is no entry for
    # <code>key</code>.  If this method returns a non-<code>null</code> value,
    # then the cache will be updated to map <code>key</code> to that value,
    # and that value will be returned by the <code>get</code> method.
    # 
    # <p> The default implementation of this method simply returns
    # <code>null</code> for every <code>key</code> value.  A subclass may
    # override this method to provide more useful behavior.
    # 
    # @param  key  The key for which a value is to be computed
    # 
    # @return      A value for <code>key</code>, or <code>null</code> if one
    #              could not be computed
    # @see #get
    def fill(key)
      return nil
    end
    
    typesig { [Object] }
    # Return the value to which this cache maps the specified
    # <code>key</code>.  If the cache does not presently contain a value for
    # this key, then invoke the <code>fill</code> method in an attempt to
    # compute such a value.  If that method returns a non-<code>null</code>
    # value, then update the cache and return the new value.  Otherwise,
    # return <code>null</code>.
    # 
    # <p> Note that because this method may update the cache, it is considered
    # a mutator and may cause <code>ConcurrentModificationException</code>s to
    # be thrown if invoked while an iterator is in use.
    # 
    # @param  key  The key whose associated value, if any, is to be returned
    # 
    # @see #fill
    def get(key)
      process_queue
      v = @hash.get(key)
      if ((v).nil?)
        v = fill(key)
        if (!(v).nil?)
          @hash.put(key, ValueCell.create(key, v, @queue))
          return v
        end
      end
      return ValueCell.strip(v, false)
    end
    
    typesig { [Object, Object] }
    # Update this cache so that the given <code>key</code> maps to the given
    # <code>value</code>.  If the cache previously contained a mapping for
    # <code>key</code> then that mapping is replaced and the old value is
    # returned.
    # 
    # @param  key    The key that is to be mapped to the given
    #                <code>value</code>
    # @param  value  The value to which the given <code>key</code> is to be
    #                mapped
    # 
    # @return  The previous value to which this key was mapped, or
    #          <code>null</code> if if there was no mapping for the key
    def put(key, value)
      process_queue
      vc = ValueCell.create(key, value, @queue)
      return ValueCell.strip(@hash.put(key, vc), true)
    end
    
    typesig { [Object] }
    # Remove the mapping for the given <code>key</code> from this cache, if
    # present.
    # 
    # @param  key  The key whose mapping is to be removed
    # 
    # @return  The value to which this key was mapped, or <code>null</code> if
    #          there was no mapping for the key
    def remove(key)
      process_queue
      return ValueCell.strip(@hash.remove(key), true)
    end
    
    typesig { [] }
    # Remove all mappings from this cache.
    def clear
      process_queue
      @hash.clear
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      # -- Views --
      def val_equals(o1, o2)
        return ((o1).nil?) ? ((o2).nil?) : (o1 == o2)
      end
      
      # Internal class for entries.
      # Because it uses SoftCache.this.queue, this class cannot be static.
      const_set_lazy(:Entry) { Class.new do
        local_class_in SoftCache
        include_class_members SoftCache
        include Map::Entry
        
        attr_accessor :ent
        alias_method :attr_ent, :ent
        undef_method :ent
        alias_method :attr_ent=, :ent=
        undef_method :ent=
        
        attr_accessor :value
        alias_method :attr_value, :value
        undef_method :value
        alias_method :attr_value=, :value=
        undef_method :value=
        
        typesig { [class_self::Map::Entry, Object] }
        # Strong reference to value, to prevent the GC
        #                              from flushing the value while this Entry
        #                              exists
        def initialize(ent, value)
          @ent = nil
          @value = nil
          @ent = ent
          @value = value
        end
        
        typesig { [] }
        def get_key
          return @ent.get_key
        end
        
        typesig { [] }
        def get_value
          return @value
        end
        
        typesig { [Object] }
        def set_value(value)
          return @ent.set_value(ValueCell.create(@ent.get_key, value, self.attr_queue))
        end
        
        typesig { [Object] }
        def ==(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          return (val_equals(@ent.get_key, e.get_key) && val_equals(@value, e.get_value))
        end
        
        typesig { [] }
        def hash_code
          k = nil
          return (((((k = get_key)).nil?) ? 0 : k.hash_code) ^ (((@value).nil?) ? 0 : @value.hash_code))
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
      
      # Internal class for entry sets
      const_set_lazy(:EntrySet) { Class.new(AbstractSet) do
        local_class_in SoftCache
        include_class_members SoftCache
        
        attr_accessor :hash_entries
        alias_method :attr_hash_entries, :hash_entries
        undef_method :hash_entries
        alias_method :attr_hash_entries=, :hash_entries=
        undef_method :hash_entries=
        
        typesig { [] }
        def iterator
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            local_class_in EntrySet
            include_class_members EntrySet
            include class_self::Iterator if class_self::Iterator.class == Module
            
            attr_accessor :hash_iterator
            alias_method :attr_hash_iterator, :hash_iterator
            undef_method :hash_iterator
            alias_method :attr_hash_iterator=, :hash_iterator=
            undef_method :hash_iterator=
            
            attr_accessor :next
            alias_method :attr_next, :next
            undef_method :next
            alias_method :attr_next=, :next=
            undef_method :next=
            
            typesig { [] }
            define_method :has_next do
              while (@hash_iterator.has_next)
                ent = @hash_iterator.next_
                vc = ent.get_value
                v = nil
                if ((!(vc).nil?) && (((v = vc.get)).nil?))
                  # Value has been flushed by GC
                  next
                end
                @next = self.class::Entry.new(ent, v)
                return true
              end
              return false
            end
            
            typesig { [] }
            define_method :next_ do
              if (((@next).nil?) && !has_next)
                raise self.class::NoSuchElementException.new
              end
              e = @next
              @next = nil
              return e
            end
            
            typesig { [] }
            define_method :remove do
              @hash_iterator.remove
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              @hash_iterator = nil
              @next = nil
              super(*args)
              @hash_iterator = self.attr_hash_entries.iterator
              @next = nil
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [] }
        def is_empty
          return !(iterator.has_next)
        end
        
        typesig { [] }
        def size
          j = 0
          i = iterator
          while i.has_next
            j += 1
            i.next_
          end
          return j
        end
        
        typesig { [Object] }
        def remove(o)
          process_queue
          if (o.is_a?(self.class::Entry))
            return @hash_entries.remove((o).attr_ent)
          else
            return false
          end
        end
        
        typesig { [] }
        def initialize
          @hash_entries = nil
          super()
          @hash_entries = self.attr_hash.entry_set
        end
        
        private
        alias_method :initialize__entry_set, :initialize
      end }
    }
    
    attr_accessor :entry_set
    alias_method :attr_entry_set, :entry_set
    undef_method :entry_set
    alias_method :attr_entry_set=, :entry_set=
    undef_method :entry_set=
    
    typesig { [] }
    # Return a <code>Set</code> view of the mappings in this cache.
    def entry_set
      if ((@entry_set).nil?)
        @entry_set = EntrySet.new_local(self)
      end
      return @entry_set
    end
    
    private
    alias_method :initialize__soft_cache, :initialize
  end
  
end
