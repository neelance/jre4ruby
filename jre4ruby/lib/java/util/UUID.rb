require "rjava"

# Copyright 2003-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UUIDImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Security
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :UnsupportedEncodingException
    }
  end
  
  # A class that represents an immutable universally unique identifier (UUID).
  # A UUID represents a 128-bit value.
  # 
  # <p> There exist different variants of these global identifiers.  The methods
  # of this class are for manipulating the Leach-Salz variant, although the
  # constructors allow the creation of any variant of UUID (described below).
  # 
  # <p> The layout of a variant 2 (Leach-Salz) UUID is as follows:
  # 
  # The most significant long consists of the following unsigned fields:
  # <pre>
  # 0xFFFFFFFF00000000 time_low
  # 0x00000000FFFF0000 time_mid
  # 0x000000000000F000 version
  # 0x0000000000000FFF time_hi
  # </pre>
  # The least significant long consists of the following unsigned fields:
  # <pre>
  # 0xC000000000000000 variant
  # 0x3FFF000000000000 clock_seq
  # 0x0000FFFFFFFFFFFF node
  # </pre>
  # 
  # <p> The variant field contains a value which identifies the layout of the
  # {@code UUID}.  The bit layout described above is valid only for a {@code
  # UUID} with a variant value of 2, which indicates the Leach-Salz variant.
  # 
  # <p> The version field holds a value that describes the type of this {@code
  # UUID}.  There are four different basic types of UUIDs: time-based, DCE
  # security, name-based, and randomly generated UUIDs.  These types have a
  # version value of 1, 2, 3 and 4, respectively.
  # 
  # <p> For more information including algorithms used to create {@code UUID}s,
  # see <a href="http://www.ietf.org/rfc/rfc4122.txt"> <i>RFC&nbsp;4122: A
  # Universally Unique IDentifier (UUID) URN Namespace</i></a>, section 4.2
  # &quot;Algorithms for Creating a Time-Based UUID&quot;.
  # 
  # @since   1.5
  class UUID 
    include_class_members UUIDImports
    include Java::Io::Serializable
    include JavaComparable
    
    class_module.module_eval {
      # Explicit serialVersionUID for interoperability.
      const_set_lazy(:SerialVersionUID) { -4856846361193249489 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The most significant 64 bits of this UUID.
    # 
    # @serial
    attr_accessor :most_sig_bits
    alias_method :attr_most_sig_bits, :most_sig_bits
    undef_method :most_sig_bits
    alias_method :attr_most_sig_bits=, :most_sig_bits=
    undef_method :most_sig_bits=
    
    # The least significant 64 bits of this UUID.
    # 
    # @serial
    attr_accessor :least_sig_bits
    alias_method :attr_least_sig_bits, :least_sig_bits
    undef_method :least_sig_bits
    alias_method :attr_least_sig_bits=, :least_sig_bits=
    undef_method :least_sig_bits=
    
    # The version number associated with this UUID. Computed on demand.
    attr_accessor :version
    alias_method :attr_version, :version
    undef_method :version
    alias_method :attr_version=, :version=
    undef_method :version=
    
    # The variant number associated with this UUID. Computed on demand.
    attr_accessor :variant
    alias_method :attr_variant, :variant
    undef_method :variant
    alias_method :attr_variant=, :variant=
    undef_method :variant=
    
    # The timestamp associated with this UUID. Computed on demand.
    attr_accessor :timestamp
    alias_method :attr_timestamp, :timestamp
    undef_method :timestamp
    alias_method :attr_timestamp=, :timestamp=
    undef_method :timestamp=
    
    # The clock sequence associated with this UUID. Computed on demand.
    attr_accessor :sequence
    alias_method :attr_sequence, :sequence
    undef_method :sequence
    alias_method :attr_sequence=, :sequence=
    undef_method :sequence=
    
    # The node number associated with this UUID. Computed on demand.
    attr_accessor :node
    alias_method :attr_node, :node
    undef_method :node
    alias_method :attr_node=, :node=
    undef_method :node=
    
    # The hashcode of this UUID. Computed on demand.
    attr_accessor :hash_code
    alias_method :attr_hash_code, :hash_code
    undef_method :hash_code
    alias_method :attr_hash_code=, :hash_code=
    undef_method :hash_code=
    
    class_module.module_eval {
      # The random number generator used by this class to create random
      # based UUIDs.
      
      def number_generator
        defined?(@@number_generator) ? @@number_generator : @@number_generator= nil
      end
      alias_method :attr_number_generator, :number_generator
      
      def number_generator=(value)
        @@number_generator = value
      end
      alias_method :attr_number_generator=, :number_generator=
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructors and Factories
    # 
    # Private constructor which uses a byte array to construct the new UUID.
    def initialize(data)
      @most_sig_bits = 0
      @least_sig_bits = 0
      @version = -1
      @variant = -1
      @timestamp = -1
      @sequence = -1
      @node = -1
      @hash_code = -1
      msb = 0
      lsb = 0
      raise AssertError if not ((data.attr_length).equal?(16))
      i = 0
      while i < 8
        msb = (msb << 8) | (data[i] & 0xff)
        i += 1
      end
      i_ = 8
      while i_ < 16
        lsb = (lsb << 8) | (data[i_] & 0xff)
        i_ += 1
      end
      @most_sig_bits = msb
      @least_sig_bits = lsb
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # Constructs a new {@code UUID} using the specified data.  {@code
    # mostSigBits} is used for the most significant 64 bits of the {@code
    # UUID} and {@code leastSigBits} becomes the least significant 64 bits of
    # the {@code UUID}.
    # 
    # @param  mostSigBits
    # The most significant bits of the {@code UUID}
    # 
    # @param  leastSigBits
    # The least significant bits of the {@code UUID}
    def initialize(most_sig_bits, least_sig_bits)
      @most_sig_bits = 0
      @least_sig_bits = 0
      @version = -1
      @variant = -1
      @timestamp = -1
      @sequence = -1
      @node = -1
      @hash_code = -1
      @most_sig_bits = most_sig_bits
      @least_sig_bits = least_sig_bits
    end
    
    class_module.module_eval {
      typesig { [] }
      # Static factory to retrieve a type 4 (pseudo randomly generated) UUID.
      # 
      # The {@code UUID} is generated using a cryptographically strong pseudo
      # random number generator.
      # 
      # @return  A randomly generated {@code UUID}
      def random_uuid
        ng = self.attr_number_generator
        if ((ng).nil?)
          self.attr_number_generator = ng = SecureRandom.new
        end
        random_bytes = Array.typed(::Java::Byte).new(16) { 0 }
        ng.next_bytes(random_bytes)
        random_bytes[6] &= 0xf
        # clear version
        random_bytes[6] |= 0x40
        # set to version 4
        random_bytes[8] &= 0x3f
        # clear variant
        random_bytes[8] |= 0x80
        # set to IETF variant
        return UUID.new(random_bytes)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Static factory to retrieve a type 3 (name based) {@code UUID} based on
      # the specified byte array.
      # 
      # @param  name
      # A byte array to be used to construct a {@code UUID}
      # 
      # @return  A {@code UUID} generated from the specified array
      def name_uuidfrom_bytes(name)
        md = nil
        begin
          md = MessageDigest.get_instance("MD5")
        rescue NoSuchAlgorithmException => nsae
          raise InternalError.new("MD5 not supported")
        end
        md5bytes = md.digest(name)
        md5bytes[6] &= 0xf
        # clear version
        md5bytes[6] |= 0x30
        # set to version 3
        md5bytes[8] &= 0x3f
        # clear variant
        md5bytes[8] |= 0x80
        # set to IETF variant
        return UUID.new(md5bytes)
      end
      
      typesig { [String] }
      # Creates a {@code UUID} from the string standard representation as
      # described in the {@link #toString} method.
      # 
      # @param  name
      # A string that specifies a {@code UUID}
      # 
      # @return  A {@code UUID} with the specified value
      # 
      # @throws  IllegalArgumentException
      # If name does not conform to the string representation as
      # described in {@link #toString}
      def from_string(name)
        components = name.split(Regexp.new("-"))
        if (!(components.attr_length).equal?(5))
          raise IllegalArgumentException.new("Invalid UUID string: " + name)
        end
        i = 0
        while i < 5
          components[i] = "0x" + (components[i]).to_s
          i += 1
        end
        most_sig_bits = Long.decode(components[0]).long_value
        most_sig_bits <<= 16
        most_sig_bits |= Long.decode(components[1]).long_value
        most_sig_bits <<= 16
        most_sig_bits |= Long.decode(components[2]).long_value
        least_sig_bits = Long.decode(components[3]).long_value
        least_sig_bits <<= 48
        least_sig_bits |= Long.decode(components[4]).long_value
        return UUID.new(most_sig_bits, least_sig_bits)
      end
    }
    
    typesig { [] }
    # Field Accessor Methods
    # 
    # Returns the least significant 64 bits of this UUID's 128 bit value.
    # 
    # @return  The least significant 64 bits of this UUID's 128 bit value
    def get_least_significant_bits
      return @least_sig_bits
    end
    
    typesig { [] }
    # Returns the most significant 64 bits of this UUID's 128 bit value.
    # 
    # @return  The most significant 64 bits of this UUID's 128 bit value
    def get_most_significant_bits
      return @most_sig_bits
    end
    
    typesig { [] }
    # The version number associated with this {@code UUID}.  The version
    # number describes how this {@code UUID} was generated.
    # 
    # The version number has the following meaning:
    # <p><ul>
    # <li>1    Time-based UUID
    # <li>2    DCE security UUID
    # <li>3    Name-based UUID
    # <li>4    Randomly generated UUID
    # </ul>
    # 
    # @return  The version number of this {@code UUID}
    def version
      if (@version < 0)
        # Version is bits masked by 0x000000000000F000 in MS long
        @version = RJava.cast_to_int(((@most_sig_bits >> 12) & 0xf))
      end
      return @version
    end
    
    typesig { [] }
    # The variant number associated with this {@code UUID}.  The variant
    # number describes the layout of the {@code UUID}.
    # 
    # The variant number has the following meaning:
    # <p><ul>
    # <li>0    Reserved for NCS backward compatibility
    # <li>2    The Leach-Salz variant (used by this class)
    # <li>6    Reserved, Microsoft Corporation backward compatibility
    # <li>7    Reserved for future definition
    # </ul>
    # 
    # @return  The variant number of this {@code UUID}
    def variant
      if (@variant < 0)
        # This field is composed of a varying number of bits
        if (((@least_sig_bits >> 63)).equal?(0))
          @variant = 0
        else
          if (((@least_sig_bits >> 62)).equal?(2))
            @variant = 2
          else
            @variant = RJava.cast_to_int((@least_sig_bits >> 61))
          end
        end
      end
      return @variant
    end
    
    typesig { [] }
    # The timestamp value associated with this UUID.
    # 
    # <p> The 60 bit timestamp value is constructed from the time_low,
    # time_mid, and time_hi fields of this {@code UUID}.  The resulting
    # timestamp is measured in 100-nanosecond units since midnight,
    # October 15, 1582 UTC.
    # 
    # <p> The timestamp value is only meaningful in a time-based UUID, which
    # has version type 1.  If this {@code UUID} is not a time-based UUID then
    # this method throws UnsupportedOperationException.
    # 
    # @throws UnsupportedOperationException
    # If this UUID is not a version 1 UUID
    def timestamp
      if (!(version).equal?(1))
        raise UnsupportedOperationException.new("Not a time-based UUID")
      end
      result = @timestamp
      if (result < 0)
        result = (@most_sig_bits & 0xfff) << 48
        result |= ((@most_sig_bits >> 16) & 0xffff) << 32
        result |= @most_sig_bits >> 32
        @timestamp = result
      end
      return result
    end
    
    typesig { [] }
    # The clock sequence value associated with this UUID.
    # 
    # <p> The 14 bit clock sequence value is constructed from the clock
    # sequence field of this UUID.  The clock sequence field is used to
    # guarantee temporal uniqueness in a time-based UUID.
    # 
    # <p> The {@code clockSequence} value is only meaningful in a time-based
    # UUID, which has version type 1.  If this UUID is not a time-based UUID
    # then this method throws UnsupportedOperationException.
    # 
    # @return  The clock sequence of this {@code UUID}
    # 
    # @throws  UnsupportedOperationException
    # If this UUID is not a version 1 UUID
    def clock_sequence
      if (!(version).equal?(1))
        raise UnsupportedOperationException.new("Not a time-based UUID")
      end
      if (@sequence < 0)
        @sequence = RJava.cast_to_int(((@least_sig_bits & 0x3fff000000000000) >> 48))
      end
      return @sequence
    end
    
    typesig { [] }
    # The node value associated with this UUID.
    # 
    # <p> The 48 bit node value is constructed from the node field of this
    # UUID.  This field is intended to hold the IEEE 802 address of the machine
    # that generated this UUID to guarantee spatial uniqueness.
    # 
    # <p> The node value is only meaningful in a time-based UUID, which has
    # version type 1.  If this UUID is not a time-based UUID then this method
    # throws UnsupportedOperationException.
    # 
    # @return  The node value of this {@code UUID}
    # 
    # @throws  UnsupportedOperationException
    # If this UUID is not a version 1 UUID
    def node
      if (!(version).equal?(1))
        raise UnsupportedOperationException.new("Not a time-based UUID")
      end
      if (@node < 0)
        @node = @least_sig_bits & 0xffffffffffff
      end
      return @node
    end
    
    typesig { [] }
    # Object Inherited Methods
    # 
    # Returns a {@code String} object representing this {@code UUID}.
    # 
    # <p> The UUID string representation is as described by this BNF:
    # <blockquote><pre>
    # {@code
    # UUID                   = <time_low> "-" <time_mid> "-"
    # <time_high_and_version> "-"
    # <variant_and_sequence> "-"
    # <node>
    # time_low               = 4*<hexOctet>
    # time_mid               = 2*<hexOctet>
    # time_high_and_version  = 2*<hexOctet>
    # variant_and_sequence   = 2*<hexOctet>
    # node                   = 6*<hexOctet>
    # hexOctet               = <hexDigit><hexDigit>
    # hexDigit               =
    # "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
    # | "a" | "b" | "c" | "d" | "e" | "f"
    # | "A" | "B" | "C" | "D" | "E" | "F"
    # }</pre></blockquote>
    # 
    # @return  A string representation of this {@code UUID}
    def to_s
      return ((digits(@most_sig_bits >> 32, 8)).to_s + "-" + (digits(@most_sig_bits >> 16, 4)).to_s + "-" + (digits(@most_sig_bits, 4)).to_s + "-" + (digits(@least_sig_bits >> 48, 4)).to_s + "-" + (digits(@least_sig_bits, 12)).to_s)
    end
    
    class_module.module_eval {
      typesig { [::Java::Long, ::Java::Int] }
      # Returns val represented by the specified number of hex digits.
      def digits(val, digits_)
        hi = 1 << (digits_ * 4)
        return Long.to_hex_string(hi | (val & (hi - 1))).substring(1)
      end
    }
    
    typesig { [] }
    # Returns a hash code for this {@code UUID}.
    # 
    # @return  A hash code value for this {@code UUID}
    def hash_code
      if ((@hash_code).equal?(-1))
        @hash_code = RJava.cast_to_int(((@most_sig_bits >> 32) ^ @most_sig_bits ^ (@least_sig_bits >> 32) ^ @least_sig_bits))
      end
      return @hash_code
    end
    
    typesig { [Object] }
    # Compares this object to the specified object.  The result is {@code
    # true} if and only if the argument is not {@code null}, is a {@code UUID}
    # object, has the same variant, and contains the same value, bit for bit,
    # as this {@code UUID}.
    # 
    # @param  obj
    # The object to be compared
    # 
    # @return  {@code true} if the objects are the same; {@code false}
    # otherwise
    def equals(obj)
      if (!(obj.is_a?(UUID)))
        return false
      end
      if (!((obj).variant).equal?(self.variant))
        return false
      end
      id = obj
      return ((@most_sig_bits).equal?(id.attr_most_sig_bits) && (@least_sig_bits).equal?(id.attr_least_sig_bits))
    end
    
    typesig { [UUID] }
    # Comparison Operations
    # 
    # Compares this UUID with the specified UUID.
    # 
    # <p> The first of two UUIDs is greater than the second if the most
    # significant field in which the UUIDs differ is greater for the first
    # UUID.
    # 
    # @param  val
    # {@code UUID} to which this {@code UUID} is to be compared
    # 
    # @return  -1, 0 or 1 as this {@code UUID} is less than, equal to, or
    # greater than {@code val}
    def compare_to(val)
      # The ordering is intentionally set up so that the UUIDs
      # can simply be numerically compared as two numbers
      return (@most_sig_bits < val.attr_most_sig_bits ? -1 : (@most_sig_bits > val.attr_most_sig_bits ? 1 : (@least_sig_bits < val.attr_least_sig_bits ? -1 : (@least_sig_bits > val.attr_least_sig_bits ? 1 : 0))))
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the {@code UUID} instance from a stream (that is,
    # deserialize it).  This is necessary to set the transient fields to their
    # correct uninitialized value so they will be recomputed on demand.
    def read_object(in_)
      in_.default_read_object
      # Set "cached computation" fields to their initial values
      @version = -1
      @variant = -1
      @timestamp = -1
      @sequence = -1
      @node = -1
      @hash_code = -1
    end
    
    private
    alias_method :initialize__uuid, :initialize
  end
  
end
