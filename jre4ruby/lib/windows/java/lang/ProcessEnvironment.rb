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
# 
# We use APIs that access a so-called Windows "Environment Block",
# which looks like an array of jchars like this:
# 
# FOO=BAR\u0000 ... GORP=QUUX\u0000\u0000
# 
# This data structure has a number of peculiarities we must contend with:
# (see: http://windowssdk.msdn.microsoft.com/en-us/library/ms682009.aspx)
# - The NUL jchar separators, and a double NUL jchar terminator.
# It appears that the Windows implementation requires double NUL
# termination even if the environment is empty.  We should always
# generate environments with double NUL termination, while accepting
# empty environments consisting of a single NUL.
# - on Windows9x, this is actually an array of 8-bit chars, not jchars,
# encoded in the system default encoding.
# - The block must be sorted by Unicode value, case-insensitively,
# as if folded to upper case.
# - There are magic environment variables maintained by Windows
# that start with a `=' (!) character.  These are used for
# Windows drive current directory (e.g. "=C:=C:\WINNT") or the
# exit code of the last command (e.g. "=ExitCode=0000001").
# 
# Since Java and non-9x Windows speak the same character set, and
# even the same encoding, we don't have to deal with unreliable
# conversion to byte streams.  Just add a few NUL terminators.
# 
# System.getenv(String) is case-insensitive, while System.getenv()
# returns a map that is case-sensitive, which is consistent with
# native Windows APIs.
# 
# The non-private methods in this class are not for general use even
# within this package.  Instead, they are the system-dependent parts
# of the system-independent method of the same name.  Don't even
# think of using this class unless your method's name appears below.
# 
# @author Martin Buchholz
# @since 1.5
module Java::Lang
  module ProcessEnvironmentImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include ::Java::Util
    }
  end
  
  class ProcessEnvironment < ProcessEnvironmentImports.const_get :HashMap
    include_class_members ProcessEnvironmentImports
    
    class_module.module_eval {
      typesig { [String] }
      def validate_name(name)
        # An initial `=' indicates a magic Windows variable name -- OK
        if (!(name.index_of(Character.new(?=.ord), 1)).equal?(-1) || !(name.index_of(Character.new(0x0000))).equal?(-1))
          raise IllegalArgumentException.new("Invalid environment variable name: \"" + name + "\"")
        end
        return name
      end
      
      typesig { [String] }
      def validate_value(value)
        if (!(value.index_of(Character.new(0x0000))).equal?(-1))
          raise IllegalArgumentException.new("Invalid environment variable value: \"" + value + "\"")
        end
        return value
      end
      
      typesig { [Object] }
      def non_null_string(o)
        if ((o).nil?)
          raise NullPointerException.new
        end
        return o
      end
    }
    
    typesig { [String, String] }
    def put(key, value)
      return super(validate_name(key), validate_value(value))
    end
    
    typesig { [Object] }
    def get(key)
      return super(non_null_string(key))
    end
    
    typesig { [Object] }
    def contains_key(key)
      return super(non_null_string(key))
    end
    
    typesig { [Object] }
    def contains_value(value)
      return super(non_null_string(value))
    end
    
    typesig { [Object] }
    def remove(key)
      return super(non_null_string(key))
    end
    
    class_module.module_eval {
      const_set_lazy(:CheckedEntry) { Class.new do
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
          return @e.get_key
        end
        
        typesig { [] }
        def get_value
          return @e.get_value
        end
        
        typesig { [String] }
        def set_value(value)
          return @e.set_value(validate_value(value))
        end
        
        typesig { [] }
        def to_s
          return RJava.cast_to_string(get_key) + "=" + RJava.cast_to_string(get_value)
        end
        
        typesig { [Object] }
        def ==(o)
          return (@e == o)
        end
        
        typesig { [] }
        def hash_code
          return @e.hash_code
        end
        
        private
        alias_method :initialize__checked_entry, :initialize
      end }
      
      const_set_lazy(:CheckedEntrySet) { Class.new(AbstractSet) do
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
            include_class_members CheckedEntrySet
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
              return self.class::CheckedEntry.new(@i.next_)
            end
            
            typesig { [] }
            define_method :remove do
              @i.remove
            end
            
            typesig { [] }
            define_method :initialize do
              @i = nil
              super()
              @i = self.attr_s.iterator
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        class_module.module_eval {
          typesig { [Object] }
          def checked_entry(o)
            e = o
            non_null_string(e.get_key)
            non_null_string(e.get_value)
            return e
          end
        }
        
        typesig { [Object] }
        def contains(o)
          return @s.contains(checked_entry(o))
        end
        
        typesig { [Object] }
        def remove(o)
          return @s.remove(checked_entry(o))
        end
        
        private
        alias_method :initialize__checked_entry_set, :initialize
      end }
      
      const_set_lazy(:CheckedValues) { Class.new(AbstractCollection) do
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
          return @c.iterator
        end
        
        typesig { [Object] }
        def contains(o)
          return @c.contains(non_null_string(o))
        end
        
        typesig { [Object] }
        def remove(o)
          return @c.remove(non_null_string(o))
        end
        
        private
        alias_method :initialize__checked_values, :initialize
      end }
      
      const_set_lazy(:CheckedKeySet) { Class.new(AbstractSet) do
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
          return @s.iterator
        end
        
        typesig { [Object] }
        def contains(o)
          return @s.contains(non_null_string(o))
        end
        
        typesig { [Object] }
        def remove(o)
          return @s.remove(non_null_string(o))
        end
        
        private
        alias_method :initialize__checked_key_set, :initialize
      end }
    }
    
    typesig { [] }
    def key_set
      return CheckedKeySet.new(super)
    end
    
    typesig { [] }
    def values
      return CheckedValues.new(super)
    end
    
    typesig { [] }
    def entry_set
      return CheckedEntrySet.new(super)
    end
    
    class_module.module_eval {
      const_set_lazy(:NameComparator) { Class.new do
        include_class_members ProcessEnvironment
        include Comparator
        
        typesig { [String, String] }
        def compare(s1, s2)
          # We can't use String.compareToIgnoreCase since it
          # canonicalizes to lower case, while Windows
          # canonicalizes to upper case!  For example, "_" should
          # sort *after* "Z", not before.
          n1 = s1.length
          n2 = s2.length
          min_ = Math.min(n1, n2)
          i = 0
          while i < min_
            c1 = s1.char_at(i)
            c2 = s2.char_at(i)
            if (!(c1).equal?(c2))
              c1 = Character.to_upper_case(c1)
              c2 = Character.to_upper_case(c2)
              if (!(c1).equal?(c2))
                # No overflow because of numeric promotion
                return c1 - c2
              end
            end
            i += 1
          end
          return n1 - n2
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__name_comparator, :initialize
      end }
      
      const_set_lazy(:EntryComparator) { Class.new do
        include_class_members ProcessEnvironment
        include Comparator
        
        typesig { [class_self::Map::Entry, class_self::Map::Entry] }
        def compare(e1, e2)
          return NameComparator.compare(e1.get_key, e2.get_key)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__entry_comparator, :initialize
      end }
      
      # Allow `=' as first char in name, e.g. =C:=C:\DIR
      const_set_lazy(:MIN_NAME_LENGTH) { 1 }
      const_attr_reader  :MIN_NAME_LENGTH
      
      when_class_loaded do
        const_set :NameComparator, NameComparator.new
        const_set :EntryComparator, EntryComparator.new
        const_set :TheEnvironment, ProcessEnvironment.new
        const_set :TheUnmodifiableEnvironment, Collections.unmodifiable_map(TheEnvironment)
        envblock = environment_block
        beg = 0
        end_ = 0
        eql = 0
        # An initial `=' indicates a magic Windows variable name -- OK
        beg = 0
        while (!((end_ = envblock.index_of(Character.new(0x0000), beg))).equal?(-1) && !((eql = envblock.index_of(Character.new(?=.ord), beg + 1))).equal?(-1))
          # Ignore corrupted environment strings.
          if (eql < end_)
            TheEnvironment.put(envblock.substring(beg, eql), envblock.substring(eql + 1, end_))
          end
          beg = end_ + 1
        end
        const_set :TheCaseInsensitiveEnvironment, TreeMap.new(NameComparator)
        TheCaseInsensitiveEnvironment.put_all(TheEnvironment)
      end
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    typesig { [::Java::Int] }
    def initialize(capacity)
      super(capacity)
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Only for use by System.getenv(String)
      def getenv(name)
        # The original implementation used a native call to _wgetenv,
        # but it turns out that _wgetenv is only consistent with
        # GetEnvironmentStringsW (for non-ASCII) if `wmain' is used
        # instead of `main', even in a process created using
        # CREATE_UNICODE_ENVIRONMENT.  Instead we perform the
        # case-insensitive comparison ourselves.  At least this
        # guarantees that System.getenv().get(String) will be
        # consistent with System.getenv(String).
        return TheCaseInsensitiveEnvironment.get(name)
      end
      
      typesig { [] }
      # Only for use by System.getenv()
      def getenv
        return TheUnmodifiableEnvironment
      end
      
      typesig { [] }
      # Only for use by ProcessBuilder.environment()
      def environment
        return TheEnvironment.clone
      end
      
      typesig { [::Java::Int] }
      # Only for use by Runtime.exec(...String[]envp...)
      def empty_environment(capacity)
        return ProcessEnvironment.new(capacity)
      end
      
      JNI.native_method :Java_java_lang_ProcessEnvironment_environmentBlock, [:pointer, :long], :long
      typesig { [] }
      def environment_block
        JNI.__send__(:Java_java_lang_ProcessEnvironment_environmentBlock, JNI.env, self.jni_id)
      end
    }
    
    typesig { [] }
    # Only for use by ProcessImpl.start()
    def to_environment_block
      # Sort Unicode-case-insensitively by name
      list = ArrayList.new(entry_set)
      Collections.sort(list, EntryComparator)
      sb = StringBuilder.new(size * 30)
      list.each do |e|
        sb.append(e.get_key).append(Character.new(?=.ord)).append(e.get_value).append(Character.new(0x0000))
      end
      # Ensure double NUL termination,
      # even if environment is empty.
      if ((sb.length).equal?(0))
        sb.append(Character.new(0x0000))
      end
      sb.append(Character.new(0x0000))
      return sb.to_s
    end
    
    class_module.module_eval {
      typesig { [Map] }
      def to_environment_block(map)
        return (map).nil? ? nil : (map).to_environment_block
      end
    }
    
    private
    alias_method :initialize__process_environment, :initialize
  end
  
end
