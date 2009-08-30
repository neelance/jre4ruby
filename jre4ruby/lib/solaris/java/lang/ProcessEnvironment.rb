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
# 
# We use APIs that access the standard Unix environ array, which
# is defined by UNIX98 to look like:
# 
# char **environ;
# 
# These are unsorted, case-sensitive, null-terminated arrays of bytes
# of the form FOO=BAR\000 which are usually encoded in the user's
# default encoding (file.encoding is an excellent choice for
# encoding/decoding these).  However, even though the user cannot
# directly access the underlying byte representation, we take pains
# to pass on the child the exact byte representation we inherit from
# the parent process for any environment name or value not created by
# Javaland.  So we keep track of all the byte representations.
# 
# Internally, we define the types Variable and Value that exhibit
# String/byteArray duality.  The internal representation of the
# environment then looks like a Map<Variable,Value>.  But we don't
# expose this to the user -- we only provide a Map<String,String>
# view, although we could also provide a Map<byte[],byte[]> view.
# 
# The non-private methods in this class are not for general use even
# within this package.  Instead, they are the system-dependent parts
# of the system-independent method of the same name.  Don't even
# think of using this class unless your method's name appears below.
# 
# @author  Martin Buchholz
# @since   1.5
module Java::Lang
  module ProcessEnvironmentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include ::Java::Util
    }
  end
  
  class ProcessEnvironment 
    include_class_members ProcessEnvironmentImports
    
    class_module.module_eval {
      const_set_lazy(:MIN_NAME_LENGTH) { 0 }
      const_attr_reader  :MIN_NAME_LENGTH
      
      when_class_loaded do
        # We cache the C environment.  This means that subsequent calls
        # to putenv/setenv from C will not be visible from Java code.
        environ_ = environ
        const_set :TheEnvironment, HashMap.new(environ_.attr_length / 2 + 3)
        # Read environment variables back to front,
        # so that earlier variables override later ones.
        i = environ_.attr_length - 1
        while i > 0
          TheEnvironment.put(Variable.value_of(environ_[i - 1]), Value.value_of(environ_[i]))
          i -= 2
        end
        const_set :TheUnmodifiableEnvironment, Collections.unmodifiable_map(StringEnvironment.new(TheEnvironment))
      end
      
      typesig { [String] }
      # Only for use by System.getenv(String)
      def getenv(name)
        return TheUnmodifiableEnvironment.get(name)
      end
      
      typesig { [] }
      # Only for use by System.getenv()
      def getenv
        return TheUnmodifiableEnvironment
      end
      
      typesig { [] }
      # Only for use by ProcessBuilder.environment()
      def environment
        return StringEnvironment.new((TheEnvironment.clone))
      end
      
      typesig { [::Java::Int] }
      # Only for use by Runtime.exec(...String[]envp...)
      def empty_environment(capacity)
        return StringEnvironment.new(HashMap.new(capacity))
      end
      
      JNI.native_method :Java_java_lang_ProcessEnvironment_environ, [:pointer, :long], :long
      typesig { [] }
      def environ
        JNI.__send__(:Java_java_lang_ProcessEnvironment_environ, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    # This class is not instantiable.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Check that name is suitable for insertion into Environment map
      def validate_variable(name)
        if (!(name.index_of(Character.new(?=.ord))).equal?(-1) || !(name.index_of(Character.new(0x0000))).equal?(-1))
          raise IllegalArgumentException.new("Invalid environment variable name: \"" + name + "\"")
        end
      end
      
      typesig { [String] }
      # Check that value is suitable for insertion into Environment map
      def validate_value(value)
        if (!(value.index_of(Character.new(0x0000))).equal?(-1))
          raise IllegalArgumentException.new("Invalid environment variable value: \"" + value + "\"")
        end
      end
      
      # A class hiding the byteArray-String duality of
      # text data on Unixoid operating systems.
      const_set_lazy(:ExternalData) { Class.new do
        include_class_members ProcessEnvironment
        
        attr_accessor :str
        alias_method :attr_str, :str
        undef_method :str
        alias_method :attr_str=, :str=
        undef_method :str=
        
        attr_accessor :bytes
        alias_method :attr_bytes, :bytes
        undef_method :bytes
        alias_method :attr_bytes=, :bytes=
        undef_method :bytes=
        
        typesig { [String, Array.typed(::Java::Byte)] }
        def initialize(str, bytes)
          @str = nil
          @bytes = nil
          @str = str
          @bytes = bytes
        end
        
        typesig { [] }
        def get_bytes
          return @bytes
        end
        
        typesig { [] }
        def to_s
          return @str
        end
        
        typesig { [Object] }
        def ==(o)
          return o.is_a?(self.class::ExternalData) && array_equals(get_bytes, (o).get_bytes)
        end
        
        typesig { [] }
        def hash_code
          return array_hash(get_bytes)
        end
        
        private
        alias_method :initialize__external_data, :initialize
      end }
      
      const_set_lazy(:Variable) { Class.new(ExternalData) do
        include_class_members ProcessEnvironment
        overload_protected {
          include JavaComparable
        }
        
        typesig { [String, Array.typed(::Java::Byte)] }
        def initialize(str, bytes)
          super(str, bytes)
        end
        
        class_module.module_eval {
          typesig { [Object] }
          def value_of_query_only(str)
            return value_of_query_only(str)
          end
          
          typesig { [String] }
          def value_of_query_only(str)
            return class_self::Variable.new(str, str.get_bytes)
          end
          
          typesig { [String] }
          def value_of(str)
            validate_variable(str)
            return value_of_query_only(str)
          end
          
          typesig { [Array.typed(::Java::Byte)] }
          def value_of(bytes)
            return class_self::Variable.new(String.new(bytes), bytes)
          end
        }
        
        typesig { [class_self::Variable] }
        def compare_to(variable)
          return array_compare(get_bytes, variable.get_bytes)
        end
        
        typesig { [Object] }
        def ==(o)
          return o.is_a?(self.class::Variable) && super(o)
        end
        
        private
        alias_method :initialize__variable, :initialize
      end }
      
      const_set_lazy(:Value) { Class.new(ExternalData) do
        include_class_members ProcessEnvironment
        overload_protected {
          include JavaComparable
        }
        
        typesig { [String, Array.typed(::Java::Byte)] }
        def initialize(str, bytes)
          super(str, bytes)
        end
        
        class_module.module_eval {
          typesig { [Object] }
          def value_of_query_only(str)
            return value_of_query_only(str)
          end
          
          typesig { [String] }
          def value_of_query_only(str)
            return class_self::Value.new(str, str.get_bytes)
          end
          
          typesig { [String] }
          def value_of(str)
            validate_value(str)
            return value_of_query_only(str)
          end
          
          typesig { [Array.typed(::Java::Byte)] }
          def value_of(bytes)
            return class_self::Value.new(String.new(bytes), bytes)
          end
        }
        
        typesig { [class_self::Value] }
        def compare_to(value)
          return array_compare(get_bytes, value.get_bytes)
        end
        
        typesig { [Object] }
        def ==(o)
          return o.is_a?(self.class::Value) && super(o)
        end
        
        private
        alias_method :initialize__value, :initialize
      end }
      
      # This implements the String map view the user sees.
      const_set_lazy(:StringEnvironment) { Class.new(AbstractMap) do
        include_class_members ProcessEnvironment
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        class_module.module_eval {
          typesig { [class_self::Value] }
          def to_s(v)
            return (v).nil? ? nil : v.to_s
          end
        }
        
        typesig { [class_self::Map] }
        def initialize(m)
          @m = nil
          super()
          @m = m
        end
        
        typesig { [] }
        def size
          return @m.size
        end
        
        typesig { [] }
        def is_empty
          return @m.is_empty
        end
        
        typesig { [] }
        def clear
          @m.clear
        end
        
        typesig { [Object] }
        def contains_key(key)
          return @m.contains_key(Variable.value_of_query_only(key))
        end
        
        typesig { [Object] }
        def contains_value(value)
          return @m.contains_value(Value.value_of_query_only(value))
        end
        
        typesig { [Object] }
        def get(key)
          return to_s(@m.get(Variable.value_of_query_only(key)))
        end
        
        typesig { [String, String] }
        def put(key, value)
          return to_s(@m.put(Variable.value_of(key), Value.value_of(value)))
        end
        
        typesig { [Object] }
        def remove(key)
          return to_s(@m.remove(Variable.value_of_query_only(key)))
        end
        
        typesig { [] }
        def key_set
          return self.class::StringKeySet.new(@m.key_set)
        end
        
        typesig { [] }
        def entry_set
          return self.class::StringEntrySet.new(@m.entry_set)
        end
        
        typesig { [] }
        def values
          return self.class::StringValues.new(@m.values)
        end
        
        typesig { [Array.typed(::Java::Int)] }
        # It is technically feasible to provide a byte-oriented view
        # as follows:
        # public Map<byte[],byte[]> asByteArrayMap() {
        # return new ByteArrayEnvironment(m);
        # }
        # Convert to Unix style environ as a monolithic byte array
        # inspired by the Windows Environment Block, except we work
        # exclusively with bytes instead of chars, and we need only
        # one trailing NUL on Unix.
        # This keeps the JNI as simple and efficient as possible.
        def to_environment_block(envc)
          count = @m.size * 2 # For added '=' and NUL
          @m.entry_set.each do |entry|
            count += entry.get_key.get_bytes.attr_length
            count += entry.get_value.get_bytes.attr_length
          end
          block = Array.typed(::Java::Byte).new(count) { 0 }
          i = 0
          @m.entry_set.each do |entry|
            key = entry.get_key.get_bytes
            value = entry.get_value.get_bytes
            System.arraycopy(key, 0, block, i, key.attr_length)
            i += key.attr_length
            block[((i += 1) - 1)] = Character.new(?=.ord)
            System.arraycopy(value, 0, block, i, value.attr_length)
            i += value.attr_length + 1
          end
          envc[0] = @m.size
          return block
        end
        
        private
        alias_method :initialize__string_environment, :initialize
      end }
      
      typesig { [Map, Array.typed(::Java::Int)] }
      def to_environment_block(map, envc)
        return (map).nil? ? nil : (map).to_environment_block(envc)
      end
      
      const_set_lazy(:StringEntry) { Class.new do
        include_class_members ProcessEnvironment
        include Map::Entry
        
        attr_accessor :e
        alias_method :attr_e, :e
        undef_method :e
        alias_method :attr_e=, :e=
        undef_method :e=
        
        typesig { [class_self::Map::Entry] }
        def initialize(e)
          @e = nil
          @e = e
        end
        
        typesig { [] }
        def get_key
          return @e.get_key.to_s
        end
        
        typesig { [] }
        def get_value
          return @e.get_value.to_s
        end
        
        typesig { [String] }
        def set_value(new_value)
          return @e.set_value(Value.value_of(new_value)).to_s
        end
        
        typesig { [] }
        def to_s
          return RJava.cast_to_string(get_key) + "=" + RJava.cast_to_string(get_value)
        end
        
        typesig { [Object] }
        def ==(o)
          return o.is_a?(self.class::StringEntry) && (@e == (o).attr_e)
        end
        
        typesig { [] }
        def hash_code
          return @e.hash_code
        end
        
        private
        alias_method :initialize__string_entry, :initialize
      end }
      
      const_set_lazy(:StringEntrySet) { Class.new(AbstractSet) do
        include_class_members ProcessEnvironment
        
        attr_accessor :s
        alias_method :attr_s, :s
        undef_method :s
        alias_method :attr_s=, :s=
        undef_method :s=
        
        typesig { [class_self::JavaSet] }
        def initialize(s)
          @s = nil
          super()
          @s = s
        end
        
        typesig { [] }
        def size
          return @s.size
        end
        
        typesig { [] }
        def is_empty
          return @s.is_empty
        end
        
        typesig { [] }
        def clear
          @s.clear
        end
        
        typesig { [] }
        def iterator
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members StringEntrySet
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
              return self.class::StringEntry.new(@i.next_)
            end
            
            typesig { [] }
            define_method :remove do
              @i.remove
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              @i = nil
              super(*args)
              @i = self.attr_s.iterator
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        class_module.module_eval {
          typesig { [Object] }
          def vv_entry(o)
            if (o.is_a?(class_self::StringEntry))
              return (o).attr_e
            end
            return Class.new(class_self::Map::Entry.class == Class ? class_self::Map::Entry : Object) do
              extend LocalClass
              include_class_members StringEntrySet
              include class_self::Map::Entry if class_self::Map::Entry.class == Module
              
              typesig { [] }
              define_method :get_key do
                return Variable.value_of_query_only((o).get_key)
              end
              
              typesig { [] }
              define_method :get_value do
                return Value.value_of_query_only((o).get_value)
              end
              
              typesig { [class_self::Value] }
              define_method :set_value do |value|
                raise self.class::UnsupportedOperationException.new
              end
              
              typesig { [Object] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self)
          end
        }
        
        typesig { [Object] }
        def contains(o)
          return @s.contains(vv_entry(o))
        end
        
        typesig { [Object] }
        def remove(o)
          return @s.remove(vv_entry(o))
        end
        
        typesig { [Object] }
        def ==(o)
          return o.is_a?(self.class::StringEntrySet) && (@s == (o).attr_s)
        end
        
        typesig { [] }
        def hash_code
          return @s.hash_code
        end
        
        private
        alias_method :initialize__string_entry_set, :initialize
      end }
      
      const_set_lazy(:StringValues) { Class.new(AbstractCollection) do
        include_class_members ProcessEnvironment
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        typesig { [class_self::Collection] }
        def initialize(c)
          @c = nil
          super()
          @c = c
        end
        
        typesig { [] }
        def size
          return @c.size
        end
        
        typesig { [] }
        def is_empty
          return @c.is_empty
        end
        
        typesig { [] }
        def clear
          @c.clear
        end
        
        typesig { [] }
        def iterator
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members StringValues
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
              return @i.next_.to_s
            end
            
            typesig { [] }
            define_method :remove do
              @i.remove
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              @i = nil
              super(*args)
              @i = self.attr_c.iterator
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [Object] }
        def contains(o)
          return @c.contains(Value.value_of_query_only(o))
        end
        
        typesig { [Object] }
        def remove(o)
          return @c.remove(Value.value_of_query_only(o))
        end
        
        typesig { [Object] }
        def ==(o)
          return o.is_a?(self.class::StringValues) && (@c == (o).attr_c)
        end
        
        typesig { [] }
        def hash_code
          return @c.hash_code
        end
        
        private
        alias_method :initialize__string_values, :initialize
      end }
      
      const_set_lazy(:StringKeySet) { Class.new(AbstractSet) do
        include_class_members ProcessEnvironment
        
        attr_accessor :s
        alias_method :attr_s, :s
        undef_method :s
        alias_method :attr_s=, :s=
        undef_method :s=
        
        typesig { [class_self::JavaSet] }
        def initialize(s)
          @s = nil
          super()
          @s = s
        end
        
        typesig { [] }
        def size
          return @s.size
        end
        
        typesig { [] }
        def is_empty
          return @s.is_empty
        end
        
        typesig { [] }
        def clear
          @s.clear
        end
        
        typesig { [] }
        def iterator
          return Class.new(self.class::Iterator.class == Class ? self.class::Iterator : Object) do
            extend LocalClass
            include_class_members StringKeySet
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
              return @i.next_.to_s
            end
            
            typesig { [] }
            define_method :remove do
              @i.remove
            end
            
            typesig { [Object] }
            define_method :initialize do |*args|
              @i = nil
              super(*args)
              @i = self.attr_s.iterator
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [Object] }
        def contains(o)
          return @s.contains(Variable.value_of_query_only(o))
        end
        
        typesig { [Object] }
        def remove(o)
          return @s.remove(Variable.value_of_query_only(o))
        end
        
        private
        alias_method :initialize__string_key_set, :initialize
      end }
      
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      # Replace with general purpose method someday
      def array_compare(x, y)
        min = x.attr_length < y.attr_length ? x.attr_length : y.attr_length
        i = 0
        while i < min
          if (!(x[i]).equal?(y[i]))
            return x[i] - y[i]
          end
          i += 1
        end
        return x.attr_length - y.attr_length
      end
      
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      # Replace with general purpose method someday
      def array_equals(x, y)
        if (!(x.attr_length).equal?(y.attr_length))
          return false
        end
        i = 0
        while i < x.attr_length
          if (!(x[i]).equal?(y[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Replace with general purpose method someday
      def array_hash(x)
        hash = 0
        i = 0
        while i < x.attr_length
          hash = 31 * hash + x[i]
          i += 1
        end
        return hash
      end
    }
    
    private
    alias_method :initialize__process_environment, :initialize
  end
  
end
