require "rjava"

# Copyright 1998-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright Taligent, Inc. 1996,1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996, 1997 - All Rights Reserved
module Sun::Text
  module IntHashtableImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text
    }
  end
  
  # Simple internal class for doing hash mapping. Much, much faster than the
  # standard Hashtable for integer to integer mappings,
  # and doesn't require object creation.<br>
  # If a key is not found, the defaultValue is returned.
  # Note: the keys are limited to values above Integer.MIN_VALUE+1.<br>
  class IntHashtable 
    include_class_members IntHashtableImports
    
    typesig { [] }
    def initialize
      @default_value = 0
      @prime_index = 0
      @high_water_mark = 0
      @low_water_mark = 0
      @count = 0
      @values = nil
      @key_list = nil
      initialize_(3)
    end
    
    typesig { [::Java::Int] }
    def initialize(initial_size)
      @default_value = 0
      @prime_index = 0
      @high_water_mark = 0
      @low_water_mark = 0
      @count = 0
      @values = nil
      @key_list = nil
      initialize_(least_greater_prime_index(RJava.cast_to_int((initial_size / HIGH_WATER_FACTOR))))
    end
    
    typesig { [] }
    def size
      return @count
    end
    
    typesig { [] }
    def is_empty
      return (@count).equal?(0)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put(key, value)
      if (@count > @high_water_mark)
        rehash
      end
      index = find(key)
      if (@key_list[index] <= MAX_UNUSED)
        # deleted or empty
        @key_list[index] = key
        (@count += 1)
      end
      @values[index] = value # reset value
    end
    
    typesig { [::Java::Int] }
    def get(key)
      return @values[find(key)]
    end
    
    typesig { [::Java::Int] }
    def remove(key)
      index = find(key)
      if (@key_list[index] > MAX_UNUSED)
        # neither deleted nor empty
        @key_list[index] = DELETED # set to deleted
        @values[index] = @default_value # set to default
        (@count -= 1)
        if (@count < @low_water_mark)
          rehash
        end
      end
    end
    
    typesig { [] }
    def get_default_value
      return @default_value
    end
    
    typesig { [::Java::Int] }
    def set_default_value(new_value)
      @default_value = new_value
      rehash
    end
    
    typesig { [Object] }
    def ==(that)
      if (!(that.get_class).equal?(self.get_class))
        return false
      end
      other = that
      if (!(other.size).equal?(@count) || !(other.attr_default_value).equal?(@default_value))
        return false
      end
      i = 0
      while i < @key_list.attr_length
        key = @key_list[i]
        if (key > MAX_UNUSED && !(other.get(key)).equal?(@values[i]))
          return false
        end
        (i += 1)
      end
      return true
    end
    
    typesig { [] }
    def hash_code
      # NOTE:  This function isn't actually used anywhere in this package, but it's here
      # in case this class is ever used to make sure we uphold the invariants about
      # hashCode() and equals()
      # WARNING:  This function hasn't undergone rigorous testing to make sure it actually
      # gives good distribution.  We've eyeballed the results, and they appear okay, but
      # you copy this algorithm (or these seed and multiplier values) at your own risk.
      # --rtg 8/17/99
      result = 465 # an arbitrary seed value
      scrambler = 1362796821 # an arbitrary multiplier.
      i = 0
      while i < @key_list.attr_length
        # this line just scrambles the bits as each value is added into the
        # has value.  This helps to make sure we affect all the bits and that
        # the same values in a different order will produce a different hash value
        result = RJava.cast_to_int((result * scrambler + 1))
        result += @key_list[i]
        (i += 1)
      end
      i_ = 0
      while i_ < @values.attr_length
        result = RJava.cast_to_int((result * scrambler + 1))
        result += @values[i_]
        (i_ += 1)
      end
      return result
    end
    
    typesig { [] }
    def clone
      result = super
      @values = @values.clone
      @key_list = @key_list.clone
      return result
    end
    
    # =======================PRIVATES============================
    attr_accessor :default_value
    alias_method :attr_default_value, :default_value
    undef_method :default_value
    alias_method :attr_default_value=, :default_value=
    undef_method :default_value=
    
    # the tables have to have prime-number lengths. Rather than compute
    # primes, we just keep a table, with the current index we are using.
    attr_accessor :prime_index
    alias_method :attr_prime_index, :prime_index
    undef_method :prime_index
    alias_method :attr_prime_index=, :prime_index=
    undef_method :prime_index=
    
    class_module.module_eval {
      # highWaterFactor determines the maximum number of elements before
      # a rehash. Can be tuned for different performance/storage characteristics.
      const_set_lazy(:HIGH_WATER_FACTOR) { 0.4 }
      const_attr_reader  :HIGH_WATER_FACTOR
    }
    
    attr_accessor :high_water_mark
    alias_method :attr_high_water_mark, :high_water_mark
    undef_method :high_water_mark
    alias_method :attr_high_water_mark=, :high_water_mark=
    undef_method :high_water_mark=
    
    class_module.module_eval {
      # lowWaterFactor determines the minimum number of elements before
      # a rehash. Can be tuned for different performance/storage characteristics.
      const_set_lazy(:LOW_WATER_FACTOR) { 0.0 }
      const_attr_reader  :LOW_WATER_FACTOR
    }
    
    attr_accessor :low_water_mark
    alias_method :attr_low_water_mark, :low_water_mark
    undef_method :low_water_mark
    alias_method :attr_low_water_mark=, :low_water_mark=
    undef_method :low_water_mark=
    
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    # we use two arrays to minimize allocations
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
    attr_accessor :key_list
    alias_method :attr_key_list, :key_list
    undef_method :key_list
    alias_method :attr_key_list=, :key_list=
    undef_method :key_list=
    
    class_module.module_eval {
      const_set_lazy(:EMPTY) { JavaInteger::MIN_VALUE }
      const_attr_reader  :EMPTY
      
      const_set_lazy(:DELETED) { EMPTY + 1 }
      const_attr_reader  :DELETED
      
      const_set_lazy(:MAX_UNUSED) { DELETED }
      const_attr_reader  :MAX_UNUSED
    }
    
    typesig { [::Java::Int] }
    def initialize_(prime_index)
      if (prime_index < 0)
        prime_index = 0
      else
        if (prime_index >= PRIMES.attr_length)
          System.out.println("TOO BIG")
          prime_index = PRIMES.attr_length - 1
          # throw new java.util.IllegalArgumentError();
        end
      end
      @prime_index = prime_index
      initial_size = PRIMES[prime_index]
      @values = Array.typed(::Java::Int).new(initial_size) { 0 }
      @key_list = Array.typed(::Java::Int).new(initial_size) { 0 }
      i = 0
      while i < initial_size
        @key_list[i] = EMPTY
        @values[i] = @default_value
        (i += 1)
      end
      @count = 0
      @low_water_mark = RJava.cast_to_int((initial_size * LOW_WATER_FACTOR))
      @high_water_mark = RJava.cast_to_int((initial_size * HIGH_WATER_FACTOR))
    end
    
    typesig { [] }
    def rehash
      old_values = @values
      oldkey_list = @key_list
      new_prime_index = @prime_index
      if (@count > @high_water_mark)
        (new_prime_index += 1)
      else
        if (@count < @low_water_mark)
          new_prime_index -= 2
        end
      end
      initialize_(new_prime_index)
      i = old_values.attr_length - 1
      while i >= 0
        key = oldkey_list[i]
        if (key > MAX_UNUSED)
          put_internal(key, old_values[i])
        end
        (i -= 1)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def put_internal(key, value)
      index = find(key)
      if (@key_list[index] < MAX_UNUSED)
        # deleted or empty
        @key_list[index] = key
        (@count += 1)
      end
      @values[index] = value # reset value
    end
    
    typesig { [::Java::Int] }
    def find(key)
      if (key <= MAX_UNUSED)
        raise IllegalArgumentException.new("key can't be less than 0xFFFFFFFE")
      end
      first_deleted = -1 # assume invalid index
      index = (key ^ 0x4000000) % @key_list.attr_length
      if (index < 0)
        index = -index
      end # positive only
      jump = 0 # lazy evaluate
      while (true)
        table_hash = @key_list[index]
        if ((table_hash).equal?(key))
          # quick check
          return index
        else
          if (table_hash > MAX_UNUSED)
            # neither correct nor unused
            # ignore
          else
            if ((table_hash).equal?(EMPTY))
              # empty, end o' the line
              if (first_deleted >= 0)
                index = first_deleted # reset if had deleted slot
              end
              return index
            else
              if (first_deleted < 0)
                # remember first deleted
                first_deleted = index
              end
            end
          end
        end
        if ((jump).equal?(0))
          # lazy compute jump
          jump = (key % (@key_list.attr_length - 1))
          if (jump < 0)
            jump = -jump
          end
          (jump += 1)
        end
        index = (index + jump) % @key_list.attr_length
        if ((index).equal?(first_deleted))
          # We've searched all entries for the given key.
          return index
        end
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def least_greater_prime_index(source)
        i = 0
        i = 0
        while i < PRIMES.attr_length
          if (source < PRIMES[i])
            break
          end
          (i += 1)
        end
        return ((i).equal?(0)) ? 0 : (i - 1)
      end
      
      # This list is the result of buildList below. Can be tuned for different
      # performance/storage characteristics.
      const_set_lazy(:PRIMES) { Array.typed(::Java::Int).new([17, 37, 67, 131, 257, 521, 1031, 2053, 4099, 8209, 16411, 32771, 65537, 131101, 262147, 524309, 1048583, 2097169, 4194319, 8388617, 16777259, 33554467, 67108879, 134217757, 268435459, 536870923, 1073741827, 2147483647]) }
      const_attr_reader  :PRIMES
    }
    
    private
    alias_method :initialize__int_hashtable, :initialize
  end
  
end
