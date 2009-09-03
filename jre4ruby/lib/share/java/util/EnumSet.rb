require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module EnumSetImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Sun::Misc, :SharedSecrets
    }
  end
  
  # A specialized {@link Set} implementation for use with enum types.  All of
  # the elements in an enum set must come from a single enum type that is
  # specified, explicitly or implicitly, when the set is created.  Enum sets
  # are represented internally as bit vectors.  This representation is
  # extremely compact and efficient. The space and time performance of this
  # class should be good enough to allow its use as a high-quality, typesafe
  # alternative to traditional <tt>int</tt>-based "bit flags."  Even bulk
  # operations (such as <tt>containsAll</tt> and <tt>retainAll</tt>) should
  # run very quickly if their argument is also an enum set.
  # 
  # <p>The iterator returned by the <tt>iterator</tt> method traverses the
  # elements in their <i>natural order</i> (the order in which the enum
  # constants are declared).  The returned iterator is <i>weakly
  # consistent</i>: it will never throw {@link ConcurrentModificationException}
  # and it may or may not show the effects of any modifications to the set that
  # occur while the iteration is in progress.
  # 
  # <p>Null elements are not permitted.  Attempts to insert a null element
  # will throw {@link NullPointerException}.  Attempts to test for the
  # presence of a null element or to remove one will, however, function
  # properly.
  # 
  # <P>Like most collection implementations, <tt>EnumSet</tt> is not
  # synchronized.  If multiple threads access an enum set concurrently, and at
  # least one of the threads modifies the set, it should be synchronized
  # externally.  This is typically accomplished by synchronizing on some
  # object that naturally encapsulates the enum set.  If no such object exists,
  # the set should be "wrapped" using the {@link Collections#synchronizedSet}
  # method.  This is best done at creation time, to prevent accidental
  # unsynchronized access:
  # 
  # <pre>
  # Set&lt;MyEnum&gt; s = Collections.synchronizedSet(EnumSet.noneOf(MyEnum.class));
  # </pre>
  # 
  # <p>Implementation note: All basic operations execute in constant time.
  # They are likely (though not guaranteed) to be much faster than their
  # {@link HashSet} counterparts.  Even bulk operations execute in
  # constant time if their argument is also an enum set.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author Josh Bloch
  # @since 1.5
  # @see EnumMap
  # @serial exclude
  class EnumSet < EnumSetImports.const_get :AbstractSet
    include_class_members EnumSetImports
    overload_protected {
      include Cloneable
      include Java::Io::Serializable
    }
    
    # The class of all the elements of this set.
    attr_accessor :element_type
    alias_method :attr_element_type, :element_type
    undef_method :element_type
    alias_method :attr_element_type=, :element_type=
    undef_method :element_type=
    
    # All of the values comprising T.  (Cached for performance.)
    attr_accessor :universe
    alias_method :attr_universe, :universe
    undef_method :universe
    alias_method :attr_universe=, :universe=
    undef_method :universe=
    
    class_module.module_eval {
      
      def zero_length_enum_array
        defined?(@@zero_length_enum_array) ? @@zero_length_enum_array : @@zero_length_enum_array= Array.typed(Enum).new(0) { nil }
      end
      alias_method :attr_zero_length_enum_array, :zero_length_enum_array
      
      def zero_length_enum_array=(value)
        @@zero_length_enum_array = value
      end
      alias_method :attr_zero_length_enum_array=, :zero_length_enum_array=
    }
    
    typesig { [Class, Array.typed(Enum)] }
    def initialize(element_type, universe)
      @element_type = nil
      @universe = nil
      super()
      @element_type = element_type
      @universe = universe
    end
    
    class_module.module_eval {
      typesig { [Class] }
      # Creates an empty enum set with the specified element type.
      # 
      # @param elementType the class object of the element type for this enum
      # set
      # @throws NullPointerException if <tt>elementType</tt> is null
      def none_of(element_type)
        universe = get_universe(element_type)
        if ((universe).nil?)
          raise ClassCastException.new(RJava.cast_to_string(element_type) + " not an enum")
        end
        if (universe.attr_length <= 64)
          return RegularEnumSet.new(element_type, universe)
        else
          return JumboEnumSet.new(element_type, universe)
        end
      end
      
      typesig { [Class] }
      # Creates an enum set containing all of the elements in the specified
      # element type.
      # 
      # @param elementType the class object of the element type for this enum
      # set
      # @throws NullPointerException if <tt>elementType</tt> is null
      def all_of(element_type)
        result = none_of(element_type)
        result.add_all
        return result
      end
    }
    
    typesig { [] }
    # Adds all of the elements from the appropriate enum type to this enum
    # set, which is empty prior to the call.
    def add_all
      raise NotImplementedError
    end
    
    class_module.module_eval {
      typesig { [EnumSet] }
      # Creates an enum set with the same element type as the specified enum
      # set, initially containing the same elements (if any).
      # 
      # @param s the enum set from which to initialize this enum set
      # @throws NullPointerException if <tt>s</tt> is null
      def copy_of(s)
        return s.clone
      end
      
      typesig { [Collection] }
      # Creates an enum set initialized from the specified collection.  If
      # the specified collection is an <tt>EnumSet</tt> instance, this static
      # factory method behaves identically to {@link #copyOf(EnumSet)}.
      # Otherwise, the specified collection must contain at least one element
      # (in order to determine the new enum set's element type).
      # 
      # @param c the collection from which to initialize this enum set
      # @throws IllegalArgumentException if <tt>c</tt> is not an
      # <tt>EnumSet</tt> instance and contains no elements
      # @throws NullPointerException if <tt>c</tt> is null
      def copy_of(c)
        if (c.is_a?(EnumSet))
          return (c).clone
        else
          if (c.is_empty)
            raise IllegalArgumentException.new("Collection is empty")
          end
          i = c.iterator
          first = i.next_
          result = EnumSet.of(first)
          while (i.has_next)
            result.add(i.next_)
          end
          return result
        end
      end
      
      typesig { [EnumSet] }
      # Creates an enum set with the same element type as the specified enum
      # set, initially containing all the elements of this type that are
      # <i>not</i> contained in the specified set.
      # 
      # @param s the enum set from whose complement to initialize this enum set
      # @throws NullPointerException if <tt>s</tt> is null
      def complement_of(s)
        result = copy_of(s)
        result.complement
        return result
      end
      
      typesig { [Object] }
      # Creates an enum set initially containing the specified element.
      # 
      # Overloadings of this method exist to initialize an enum set with
      # one through five elements.  A sixth overloading is provided that
      # uses the varargs feature.  This overloading may be used to create
      # an enum set initially containing an arbitrary number of elements, but
      # is likely to run slower than the overloadings that do not use varargs.
      # 
      # @param e the element that this set is to contain initially
      # @throws NullPointerException if <tt>e</tt> is null
      # @return an enum set initially containing the specified element
      def of(e)
        result = none_of(e.get_declaring_class)
        result.add(e)
        return result
      end
      
      typesig { [Object, Object] }
      # Creates an enum set initially containing the specified elements.
      # 
      # Overloadings of this method exist to initialize an enum set with
      # one through five elements.  A sixth overloading is provided that
      # uses the varargs feature.  This overloading may be used to create
      # an enum set initially containing an arbitrary number of elements, but
      # is likely to run slower than the overloadings that do not use varargs.
      # 
      # @param e1 an element that this set is to contain initially
      # @param e2 another element that this set is to contain initially
      # @throws NullPointerException if any parameters are null
      # @return an enum set initially containing the specified elements
      def of(e1, e2)
        result = none_of(e1.get_declaring_class)
        result.add(e1)
        result.add(e2)
        return result
      end
      
      typesig { [Object, Object, Object] }
      # Creates an enum set initially containing the specified elements.
      # 
      # Overloadings of this method exist to initialize an enum set with
      # one through five elements.  A sixth overloading is provided that
      # uses the varargs feature.  This overloading may be used to create
      # an enum set initially containing an arbitrary number of elements, but
      # is likely to run slower than the overloadings that do not use varargs.
      # 
      # @param e1 an element that this set is to contain initially
      # @param e2 another element that this set is to contain initially
      # @param e3 another element that this set is to contain initially
      # @throws NullPointerException if any parameters are null
      # @return an enum set initially containing the specified elements
      def of(e1, e2, e3)
        result = none_of(e1.get_declaring_class)
        result.add(e1)
        result.add(e2)
        result.add(e3)
        return result
      end
      
      typesig { [Object, Object, Object, Object] }
      # Creates an enum set initially containing the specified elements.
      # 
      # Overloadings of this method exist to initialize an enum set with
      # one through five elements.  A sixth overloading is provided that
      # uses the varargs feature.  This overloading may be used to create
      # an enum set initially containing an arbitrary number of elements, but
      # is likely to run slower than the overloadings that do not use varargs.
      # 
      # @param e1 an element that this set is to contain initially
      # @param e2 another element that this set is to contain initially
      # @param e3 another element that this set is to contain initially
      # @param e4 another element that this set is to contain initially
      # @throws NullPointerException if any parameters are null
      # @return an enum set initially containing the specified elements
      def of(e1, e2, e3, e4)
        result = none_of(e1.get_declaring_class)
        result.add(e1)
        result.add(e2)
        result.add(e3)
        result.add(e4)
        return result
      end
      
      typesig { [Object, Object, Object, Object, Object] }
      # Creates an enum set initially containing the specified elements.
      # 
      # Overloadings of this method exist to initialize an enum set with
      # one through five elements.  A sixth overloading is provided that
      # uses the varargs feature.  This overloading may be used to create
      # an enum set initially containing an arbitrary number of elements, but
      # is likely to run slower than the overloadings that do not use varargs.
      # 
      # @param e1 an element that this set is to contain initially
      # @param e2 another element that this set is to contain initially
      # @param e3 another element that this set is to contain initially
      # @param e4 another element that this set is to contain initially
      # @param e5 another element that this set is to contain initially
      # @throws NullPointerException if any parameters are null
      # @return an enum set initially containing the specified elements
      def of(e1, e2, e3, e4, e5)
        result = none_of(e1.get_declaring_class)
        result.add(e1)
        result.add(e2)
        result.add(e3)
        result.add(e4)
        result.add(e5)
        return result
      end
      
      typesig { [Object, Vararg.new(Object)] }
      # Creates an enum set initially containing the specified elements.
      # This factory, whose parameter list uses the varargs feature, may
      # be used to create an enum set initially containing an arbitrary
      # number of elements, but it is likely to run slower than the overloadings
      # that do not use varargs.
      # 
      # @param first an element that the set is to contain initially
      # @param rest the remaining elements the set is to contain initially
      # @throws NullPointerException if any of the specified elements are null,
      # or if <tt>rest</tt> is null
      # @return an enum set initially containing the specified elements
      def of(first, *rest)
        result = none_of(first.get_declaring_class)
        result.add(first)
        rest.each do |e|
          result.add(e)
        end
        return result
      end
      
      typesig { [Object, Array.typed(Object)] }
      def of(first, rest)
        of(first, *rest)
      end
      
      typesig { [Object, Object] }
      # Creates an enum set initially containing all of the elements in the
      # range defined by the two specified endpoints.  The returned set will
      # contain the endpoints themselves, which may be identical but must not
      # be out of order.
      # 
      # @param from the first element in the range
      # @param to the last element in the range
      # @throws NullPointerException if {@code from} or {@code to} are null
      # @throws IllegalArgumentException if {@code from.compareTo(to) > 0}
      # @return an enum set initially containing all of the elements in the
      # range defined by the two specified endpoints
      def range(from, to)
        if ((from <=> to) > 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        result = none_of(from.get_declaring_class)
        result.add_range(from, to)
        return result
      end
    }
    
    typesig { [Object, Object] }
    # Adds the specified range to this enum set, which is empty prior
    # to the call.
    def add_range(from, to)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a copy of this set.
    # 
    # @return a copy of this set
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        raise AssertionError.new(e)
      end
    end
    
    typesig { [] }
    # Complements the contents of this enum set.
    def complement
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Throws an exception if e is not of the correct type for this enum set.
    def type_check(e)
      e_class = e.get_class
      if (!(e_class).equal?(@element_type) && !(e_class.get_superclass).equal?(@element_type))
        raise ClassCastException.new(RJava.cast_to_string(e_class) + " != " + RJava.cast_to_string(@element_type))
      end
    end
    
    class_module.module_eval {
      typesig { [Class] }
      # Returns all of the values comprising E.
      # The result is uncloned, cached, and shared by all callers.
      def get_universe(element_type)
        return SharedSecrets.get_java_lang_access.get_enum_constants_shared(element_type)
      end
      
      # This class is used to serialize all EnumSet instances, regardless of
      # implementation type.  It captures their "logical contents" and they
      # are reconstructed using public static factories.  This is necessary
      # to ensure that the existence of a particular implementation type is
      # an implementation detail.
      # 
      # @serial include
      const_set_lazy(:SerializationProxy) { Class.new do
        include_class_members EnumSet
        include Java::Io::Serializable
        
        # The element type of this enum set.
        # 
        # @serial
        attr_accessor :element_type
        alias_method :attr_element_type, :element_type
        undef_method :element_type
        alias_method :attr_element_type=, :element_type=
        undef_method :element_type=
        
        # The elements contained in this enum set.
        # 
        # @serial
        attr_accessor :elements
        alias_method :attr_elements, :elements
        undef_method :elements
        alias_method :attr_elements=, :elements=
        undef_method :elements=
        
        typesig { [class_self::EnumSet] }
        def initialize(set)
          @element_type = nil
          @elements = nil
          @element_type = set.attr_element_type
          @elements = set.to_array(self.attr_zero_length_enum_array)
        end
        
        typesig { [] }
        def read_resolve
          result = EnumSet.none_of(@element_type)
          @elements.each do |e|
            result.add(e)
          end
          return result
        end
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 362491234563181265 }
          const_attr_reader  :SerialVersionUID
        }
        
        private
        alias_method :initialize__serialization_proxy, :initialize
      end }
    }
    
    typesig { [] }
    def write_replace
      return SerializationProxy.new(self)
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # readObject method for the serialization proxy pattern
    # See Effective Java, Second Ed., Item 78.
    def read_object(stream)
      raise Java::Io::InvalidObjectException.new("Proxy required")
    end
    
    private
    alias_method :initialize__enum_set, :initialize
  end
  
end
