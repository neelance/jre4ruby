require "rjava"

# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Util
  module PreHashedMapImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :AbstractMap
      include_const ::Java::Util, :AbstractSet
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # A precomputed hash map.
  # 
  # <p> Subclasses of this class are of the following form:
  # 
  # <blockquote><pre>
  # class FooMap
  # extends sun.util.PreHashedMap&lt;String&gt;
  # {
  # 
  # private FooMap() {
  # super(ROWS, SIZE, SHIFT, MASK);
  # }
  # 
  # protected void init(Object[] ht) {
  # ht[0] = new Object[] { "key-1", value_1 };
  # ht[1] = new Object[] { "key-2", value_2,
  # new Object { "key-3", value_3 } };
  # ...
  # }
  # 
  # }</pre></blockquote>
  # 
  # <p> The <tt>init</tt> method is invoked by the <tt>PreHashedMap</tt>
  # constructor with an object array long enough for the map's rows.  The method
  # must construct the hash chain for each row and store it in the appropriate
  # element of the array.
  # 
  # <p> Each entry in the map is represented by a unique hash-chain node.  The
  # final node of a hash chain is a two-element object array whose first element
  # is the entry's key and whose second element is the entry's value.  A
  # non-final node of a hash chain is a three-element object array whose first
  # two elements are the entry's key and value and whose third element is the
  # next node in the chain.
  # 
  # <p> Instances of this class are mutable and are not safe for concurrent
  # access.  They may be made immutable and thread-safe via the appropriate
  # methods in the {@link java.util.Collections} utility class.
  # 
  # <p> In the JDK build, subclasses of this class are typically created via the
  # <tt>Hasher</tt> program in the <tt>make/tools/Hasher</tt> directory.
  # 
  # @author Mark Reinhold
  # @since 1.5
  # 
  # @see java.util.AbstractMap
  class PreHashedMap < PreHashedMapImports.const_get :AbstractMap
    include_class_members PreHashedMapImports
    
    attr_accessor :rows
    alias_method :attr_rows, :rows
    undef_method :rows
    alias_method :attr_rows=, :rows=
    undef_method :rows=
    
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    attr_accessor :shift
    alias_method :attr_shift, :shift
    undef_method :shift
    alias_method :attr_shift=, :shift=
    undef_method :shift=
    
    attr_accessor :mask
    alias_method :attr_mask, :mask
    undef_method :mask
    alias_method :attr_mask=, :mask=
    undef_method :mask=
    
    attr_accessor :ht
    alias_method :attr_ht, :ht
    undef_method :ht
    alias_method :attr_ht=, :ht=
    undef_method :ht=
    
    typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Creates a new map.
    # 
    # <p> This constructor invokes the {@link #init init} method, passing it a
    # newly-constructed row array that is <tt>rows</tt> elements long.
    # 
    # @param rows
    # The number of rows in the map
    # @param size
    # The number of entries in the map
    # @param shift
    # The value by which hash codes are right-shifted
    # @param mask
    # The value with which hash codes are masked after being shifted
    def initialize(rows, size, shift, mask)
      @rows = 0
      @size = 0
      @shift = 0
      @mask = 0
      @ht = nil
      super()
      @rows = rows
      @size = size
      @shift = shift
      @mask = mask
      @ht = Array.typed(Object).new(rows) { nil }
      init(@ht)
    end
    
    typesig { [Array.typed(Object)] }
    # Initializes this map.
    # 
    # <p> This method must construct the map's hash chains and store them into
    # the appropriate elements of the given hash-table row array.
    # 
    # @param rows
    # The row array to be initialized
    def init(ht)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # @SuppressWarnings("unchecked")
    def to_v(x)
      return x
    end
    
    typesig { [Object] }
    def get(k)
      h = (k.hash_code >> @shift) & @mask
      a = @ht[h]
      if ((a).nil?)
        return nil
      end
      loop do
        if ((a[0] == k))
          return to_v(a[1])
        end
        if (a.attr_length < 3)
          return nil
        end
        a = a[2]
      end
    end
    
    typesig { [String, Object] }
    # @throws UnsupportedOperationException
    # If the given key is not part of this map's initial key set
    def put(k, v)
      h = (k.hash_code >> @shift) & @mask
      a = @ht[h]
      if ((a).nil?)
        raise UnsupportedOperationException.new(k)
      end
      loop do
        if ((a[0] == k))
          ov = to_v(a[1])
          a[1] = v
          return ov
        end
        if (a.attr_length < 3)
          raise UnsupportedOperationException.new(k)
        end
        a = a[2]
      end
    end
    
    typesig { [] }
    def key_set
      return Class.new(AbstractSet.class == Class ? AbstractSet : Object) do
        extend LocalClass
        include_class_members PreHashedMap
        include AbstractSet if AbstractSet.class == Module
        
        typesig { [] }
        define_method :size do
          return self.attr_size
        end
        
        typesig { [] }
        define_method :iterator do
          abstract_set_class = self.class
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members abstract_set_class
            include class_self::Iterator if class_self::Iterator.class == Module
            
            attr_accessor :i
            alias_method :attr_i, :i
            undef_method :i
            alias_method :attr_i=, :i=
            undef_method :i=
            
            attr_accessor :a
            alias_method :attr_a, :a
            undef_method :a
            alias_method :attr_a=, :a=
            undef_method :a=
            
            attr_accessor :cur
            alias_method :attr_cur, :cur
            undef_method :cur
            alias_method :attr_cur=, :cur=
            undef_method :cur=
            
            typesig { [] }
            define_method :find_next do
              if (!(@a).nil?)
                if ((@a.attr_length).equal?(3))
                  @a = @a[2]
                  @cur = RJava.cast_to_string(@a[0])
                  return true
                end
                @i += 1
                @a = nil
              end
              @cur = RJava.cast_to_string(nil)
              if (@i >= self.attr_rows)
                return false
              end
              if (@i < 0 || (self.attr_ht[@i]).nil?)
                begin
                  if ((@i += 1) >= self.attr_rows)
                    return false
                  end
                end while ((self.attr_ht[@i]).nil?)
              end
              @a = self.attr_ht[@i]
              @cur = RJava.cast_to_string(@a[0])
              return true
            end
            
            typesig { [] }
            define_method :has_next do
              if (!(@cur).nil?)
                return true
              end
              return find_next
            end
            
            typesig { [] }
            define_method :next_ do
              if ((@cur).nil?)
                if (!find_next)
                  raise self.class::NoSuchElementException.new
                end
              end
              s = @cur
              @cur = RJava.cast_to_string(nil)
              return s
            end
            
            typesig { [] }
            define_method :remove do
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              @i = 0
              @a = nil
              @cur = nil
              super(*args)
              @i = -1
              @a = nil
              @cur = nil
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [] }
    def entry_set
      return Class.new(AbstractSet.class == Class ? AbstractSet : Object) do
        extend LocalClass
        include_class_members PreHashedMap
        include AbstractSet if AbstractSet.class == Module
        
        typesig { [] }
        define_method :size do
          return self.attr_size
        end
        
        typesig { [] }
        define_method :iterator do
          abstract_set_class = self.class
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members abstract_set_class
            include class_self::Iterator if class_self::Iterator.class == Module
            
            attr_accessor :i
            alias_method :attr_i, :i
            undef_method :i
            alias_method :attr_i=, :i=
            undef_method :i=
            
            typesig { [] }
            define_method :has_next do
              return @i.has_next
            end
            
            typesig { [] }
            define_method :next_ do
              iterator_class = self.class
              return Class.new(self.class::Map::Entry.class == Class ? self.class::Map::Entry : Object) do
                extend LocalClass
                include_class_members iterator_class
                include class_self::Map::Entry if class_self::Map::Entry.class == Module
                
                attr_accessor :k
                alias_method :attr_k, :k
                undef_method :k
                alias_method :attr_k=, :k=
                undef_method :k=
                
                typesig { [] }
                define_method :get_key do
                  return @k
                end
                
                typesig { [] }
                define_method :get_value do
                  return get(@k)
                end
                
                typesig { [] }
                define_method :hash_code do
                  v = get(@k)
                  return (@k.hash_code + ((v).nil? ? 0 : v.hash_code))
                end
                
                typesig { [Object] }
                define_method :== do |ob|
                  if ((ob).equal?(self))
                    return true
                  end
                  if (!(ob.is_a?(self.class::Map::Entry)))
                    return false
                  end
                  that = ob
                  return (((self.get_key).nil? ? (that.get_key).nil? : (self.get_key == that.get_key)) && ((self.get_value).nil? ? (that.get_value).nil? : (self.get_value == that.get_value)))
                end
                
                typesig { [class_self::V] }
                define_method :set_value do |v|
                  raise self.class::UnsupportedOperationException.new
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  @k = nil
                  super(*args)
                  @k = self.attr_i.next_
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self)
            end
            
            typesig { [] }
            define_method :remove do
              raise self.class::UnsupportedOperationException.new
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              @i = nil
              super(*args)
              @i = key_set.iterator
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    private
    alias_method :initialize__pre_hashed_map, :initialize
  end
  
end
