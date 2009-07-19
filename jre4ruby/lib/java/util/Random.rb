require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RandomImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
      include_const ::Java::Util::Concurrent::Atomic, :AtomicLong
      include_const ::Sun::Misc, :Unsafe
    }
  end
  
  # An instance of this class is used to generate a stream of
  # pseudorandom numbers. The class uses a 48-bit seed, which is
  # modified using a linear congruential formula. (See Donald Knuth,
  # <i>The Art of Computer Programming, Volume 3</i>, Section 3.2.1.)
  # <p>
  # If two instances of {@code Random} are created with the same
  # seed, and the same sequence of method calls is made for each, they
  # will generate and return identical sequences of numbers. In order to
  # guarantee this property, particular algorithms are specified for the
  # class {@code Random}. Java implementations must use all the algorithms
  # shown here for the class {@code Random}, for the sake of absolute
  # portability of Java code. However, subclasses of class {@code Random}
  # are permitted to use other algorithms, so long as they adhere to the
  # general contracts for all the methods.
  # <p>
  # The algorithms implemented by class {@code Random} use a
  # {@code protected} utility method that on each invocation can supply
  # up to 32 pseudorandomly generated bits.
  # <p>
  # Many applications will find the method {@link Math#random} simpler to use.
  # 
  # @author  Frank Yellin
  # @since   1.0
  class Random 
    include_class_members RandomImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1 for interoperability
      const_set_lazy(:SerialVersionUID) { 3905348978240129619 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The internal state associated with this pseudorandom number generator.
    # (The specs for the methods in this class describe the ongoing
    # computation of this value.)
    attr_accessor :seed
    alias_method :attr_seed, :seed
    undef_method :seed
    alias_method :attr_seed=, :seed=
    undef_method :seed=
    
    class_module.module_eval {
      const_set_lazy(:Multiplier) { 0x5deece66d }
      const_attr_reader  :Multiplier
      
      const_set_lazy(:Addend) { 0xb }
      const_attr_reader  :Addend
      
      const_set_lazy(:Mask) { (1 << 48) - 1 }
      const_attr_reader  :Mask
    }
    
    typesig { [] }
    # Creates a new random number generator. This constructor sets
    # the seed of the random number generator to a value very likely
    # to be distinct from any other invocation of this constructor.
    def initialize
      initialize__random((self.attr_seed_uniquifier += 1) + System.nano_time)
    end
    
    class_module.module_eval {
      
      def seed_uniquifier
        defined?(@@seed_uniquifier) ? @@seed_uniquifier : @@seed_uniquifier= 8682522807148012
      end
      alias_method :attr_seed_uniquifier, :seed_uniquifier
      
      def seed_uniquifier=(value)
        @@seed_uniquifier = value
      end
      alias_method :attr_seed_uniquifier=, :seed_uniquifier=
    }
    
    typesig { [::Java::Long] }
    # Creates a new random number generator using a single {@code long} seed.
    # The seed is the initial value of the internal state of the pseudorandom
    # number generator which is maintained by method {@link #next}.
    # 
    # <p>The invocation {@code new Random(seed)} is equivalent to:
    # <pre> {@code
    # Random rnd = new Random();
    # rnd.setSeed(seed);}</pre>
    # 
    # @param seed the initial seed
    # @see   #setSeed(long)
    def initialize(seed)
      @seed = nil
      @next_next_gaussian = 0.0
      @have_next_next_gaussian = false
      @seed = AtomicLong.new(0)
      set_seed(seed)
    end
    
    typesig { [::Java::Long] }
    # Sets the seed of this random number generator using a single
    # {@code long} seed. The general contract of {@code setSeed} is
    # that it alters the state of this random number generator object
    # so as to be in exactly the same state as if it had just been
    # created with the argument {@code seed} as a seed. The method
    # {@code setSeed} is implemented by class {@code Random} by
    # atomically updating the seed to
    # <pre>{@code (seed ^ 0x5DEECE66DL) & ((1L << 48) - 1)}</pre>
    # and clearing the {@code haveNextNextGaussian} flag used by {@link
    # #nextGaussian}.
    # 
    # <p>The implementation of {@code setSeed} by class {@code Random}
    # happens to use only 48 bits of the given seed. In general, however,
    # an overriding method may use all 64 bits of the {@code long}
    # argument as a seed value.
    # 
    # @param seed the initial seed
    def set_seed(seed)
      synchronized(self) do
        seed = (seed ^ Multiplier) & Mask
        @seed.set(seed)
        @have_next_next_gaussian = false
      end
    end
    
    typesig { [::Java::Int] }
    # Generates the next pseudorandom number. Subclasses should
    # override this, as this is used by all other methods.
    # 
    # <p>The general contract of {@code next} is that it returns an
    # {@code int} value and if the argument {@code bits} is between
    # {@code 1} and {@code 32} (inclusive), then that many low-order
    # bits of the returned value will be (approximately) independently
    # chosen bit values, each of which is (approximately) equally
    # likely to be {@code 0} or {@code 1}. The method {@code next} is
    # implemented by class {@code Random} by atomically updating the seed to
    # <pre>{@code (seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1)}</pre>
    # and returning
    # <pre>{@code (int)(seed >>> (48 - bits))}.</pre>
    # 
    # This is a linear congruential pseudorandom number generator, as
    # defined by D. H. Lehmer and described by Donald E. Knuth in
    # <i>The Art of Computer Programming,</i> Volume 3:
    # <i>Seminumerical Algorithms</i>, section 3.2.1.
    # 
    # @param  bits random bits
    # @return the next pseudorandom value from this random number
    # generator's sequence
    # @since  1.1
    def next(bits)
      oldseed = 0
      nextseed = 0
      seed = @seed
      begin
        oldseed = seed.get
        nextseed = (oldseed * Multiplier + Addend) & Mask
      end while (!seed.compare_and_set(oldseed, nextseed))
      return RJava.cast_to_int((nextseed >> (48 - bits)))
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Generates random bytes and places them into a user-supplied
    # byte array.  The number of random bytes produced is equal to
    # the length of the byte array.
    # 
    # <p>The method {@code nextBytes} is implemented by class {@code Random}
    # as if by:
    # <pre> {@code
    # public void nextBytes(byte[] bytes) {
    # for (int i = 0; i < bytes.length; )
    # for (int rnd = nextInt(), n = Math.min(bytes.length - i, 4);
    # n-- > 0; rnd >>= 8)
    # bytes[i++] = (byte)rnd;
    # }}</pre>
    # 
    # @param  bytes the byte array to fill with random bytes
    # @throws NullPointerException if the byte array is null
    # @since  1.1
    def next_bytes(bytes)
      i = 0
      len = bytes.attr_length
      while i < len
        rnd = next_int
        n = Math.min(len - i, JavaInteger::SIZE / Byte::SIZE)
        while ((n -= 1) + 1) > 0
          bytes[((i += 1) - 1)] = rnd
          rnd >>= Byte::SIZE
        end
      end
    end
    
    typesig { [] }
    # Returns the next pseudorandom, uniformly distributed {@code int}
    # value from this random number generator's sequence. The general
    # contract of {@code nextInt} is that one {@code int} value is
    # pseudorandomly generated and returned. All 2<font size="-1"><sup>32
    # </sup></font> possible {@code int} values are produced with
    # (approximately) equal probability.
    # 
    # <p>The method {@code nextInt} is implemented by class {@code Random}
    # as if by:
    # <pre> {@code
    # public int nextInt() {
    # return next(32);
    # }}</pre>
    # 
    # @return the next pseudorandom, uniformly distributed {@code int}
    # value from this random number generator's sequence
    def next_int
      return next(32)
    end
    
    typesig { [::Java::Int] }
    # Returns a pseudorandom, uniformly distributed {@code int} value
    # between 0 (inclusive) and the specified value (exclusive), drawn from
    # this random number generator's sequence.  The general contract of
    # {@code nextInt} is that one {@code int} value in the specified range
    # is pseudorandomly generated and returned.  All {@code n} possible
    # {@code int} values are produced with (approximately) equal
    # probability.  The method {@code nextInt(int n)} is implemented by
    # class {@code Random} as if by:
    # <pre> {@code
    # public int nextInt(int n) {
    # if (n <= 0)
    # throw new IllegalArgumentException("n must be positive");
    # 
    # if ((n & -n) == n)  // i.e., n is a power of 2
    # return (int)((n * (long)next(31)) >> 31);
    # 
    # int bits, val;
    # do {
    # bits = next(31);
    # val = bits % n;
    # } while (bits - val + (n-1) < 0);
    # return val;
    # }}</pre>
    # 
    # <p>The hedge "approximately" is used in the foregoing description only
    # because the next method is only approximately an unbiased source of
    # independently chosen bits.  If it were a perfect source of randomly
    # chosen bits, then the algorithm shown would choose {@code int}
    # values from the stated range with perfect uniformity.
    # <p>
    # The algorithm is slightly tricky.  It rejects values that would result
    # in an uneven distribution (due to the fact that 2^31 is not divisible
    # by n). The probability of a value being rejected depends on n.  The
    # worst case is n=2^30+1, for which the probability of a reject is 1/2,
    # and the expected number of iterations before the loop terminates is 2.
    # <p>
    # The algorithm treats the case where n is a power of two specially: it
    # returns the correct number of high-order bits from the underlying
    # pseudo-random number generator.  In the absence of special treatment,
    # the correct number of <i>low-order</i> bits would be returned.  Linear
    # congruential pseudo-random number generators such as the one
    # implemented by this class are known to have short periods in the
    # sequence of values of their low-order bits.  Thus, this special case
    # greatly increases the length of the sequence of values returned by
    # successive calls to this method if n is a small power of two.
    # 
    # @param n the bound on the random number to be returned.  Must be
    # positive.
    # @return the next pseudorandom, uniformly distributed {@code int}
    # value between {@code 0} (inclusive) and {@code n} (exclusive)
    # from this random number generator's sequence
    # @exception IllegalArgumentException if n is not positive
    # @since 1.2
    def next_int(n)
      if (n <= 0)
        raise IllegalArgumentException.new("n must be positive")
      end
      if (((n & -n)).equal?(n))
        # i.e., n is a power of 2
        return RJava.cast_to_int(((n * next(31)) >> 31))
      end
      bits = 0
      val = 0
      begin
        bits = next(31)
        val = bits % n
      end while (bits - val + (n - 1) < 0)
      return val
    end
    
    typesig { [] }
    # Returns the next pseudorandom, uniformly distributed {@code long}
    # value from this random number generator's sequence. The general
    # contract of {@code nextLong} is that one {@code long} value is
    # pseudorandomly generated and returned.
    # 
    # <p>The method {@code nextLong} is implemented by class {@code Random}
    # as if by:
    # <pre> {@code
    # public long nextLong() {
    # return ((long)next(32) << 32) + next(32);
    # }}</pre>
    # 
    # Because class {@code Random} uses a seed with only 48 bits,
    # this algorithm will not return all possible {@code long} values.
    # 
    # @return the next pseudorandom, uniformly distributed {@code long}
    # value from this random number generator's sequence
    def next_long
      # it's okay that the bottom word remains signed.
      return ((next(32)) << 32) + next(32)
    end
    
    typesig { [] }
    # Returns the next pseudorandom, uniformly distributed
    # {@code boolean} value from this random number generator's
    # sequence. The general contract of {@code nextBoolean} is that one
    # {@code boolean} value is pseudorandomly generated and returned.  The
    # values {@code true} and {@code false} are produced with
    # (approximately) equal probability.
    # 
    # <p>The method {@code nextBoolean} is implemented by class {@code Random}
    # as if by:
    # <pre> {@code
    # public boolean nextBoolean() {
    # return next(1) != 0;
    # }}</pre>
    # 
    # @return the next pseudorandom, uniformly distributed
    # {@code boolean} value from this random number generator's
    # sequence
    # @since 1.2
    def next_boolean
      return !(next(1)).equal?(0)
    end
    
    typesig { [] }
    # Returns the next pseudorandom, uniformly distributed {@code float}
    # value between {@code 0.0} and {@code 1.0} from this random
    # number generator's sequence.
    # 
    # <p>The general contract of {@code nextFloat} is that one
    # {@code float} value, chosen (approximately) uniformly from the
    # range {@code 0.0f} (inclusive) to {@code 1.0f} (exclusive), is
    # pseudorandomly generated and returned. All 2<font
    # size="-1"><sup>24</sup></font> possible {@code float} values
    # of the form <i>m&nbsp;x&nbsp</i>2<font
    # size="-1"><sup>-24</sup></font>, where <i>m</i> is a positive
    # integer less than 2<font size="-1"><sup>24</sup> </font>, are
    # produced with (approximately) equal probability.
    # 
    # <p>The method {@code nextFloat} is implemented by class {@code Random}
    # as if by:
    # <pre> {@code
    # public float nextFloat() {
    # return next(24) / ((float)(1 << 24));
    # }}</pre>
    # 
    # <p>The hedge "approximately" is used in the foregoing description only
    # because the next method is only approximately an unbiased source of
    # independently chosen bits. If it were a perfect source of randomly
    # chosen bits, then the algorithm shown would choose {@code float}
    # values from the stated range with perfect uniformity.<p>
    # [In early versions of Java, the result was incorrectly calculated as:
    # <pre> {@code
    # return next(30) / ((float)(1 << 30));}</pre>
    # This might seem to be equivalent, if not better, but in fact it
    # introduced a slight nonuniformity because of the bias in the rounding
    # of floating-point numbers: it was slightly more likely that the
    # low-order bit of the significand would be 0 than that it would be 1.]
    # 
    # @return the next pseudorandom, uniformly distributed {@code float}
    # value between {@code 0.0} and {@code 1.0} from this
    # random number generator's sequence
    def next_float
      return next(24) / (((1 << 24)).to_f)
    end
    
    typesig { [] }
    # Returns the next pseudorandom, uniformly distributed
    # {@code double} value between {@code 0.0} and
    # {@code 1.0} from this random number generator's sequence.
    # 
    # <p>The general contract of {@code nextDouble} is that one
    # {@code double} value, chosen (approximately) uniformly from the
    # range {@code 0.0d} (inclusive) to {@code 1.0d} (exclusive), is
    # pseudorandomly generated and returned.
    # 
    # <p>The method {@code nextDouble} is implemented by class {@code Random}
    # as if by:
    # <pre> {@code
    # public double nextDouble() {
    # return (((long)next(26) << 27) + next(27))
    # / (double)(1L << 53);
    # }}</pre>
    # 
    # <p>The hedge "approximately" is used in the foregoing description only
    # because the {@code next} method is only approximately an unbiased
    # source of independently chosen bits. If it were a perfect source of
    # randomly chosen bits, then the algorithm shown would choose
    # {@code double} values from the stated range with perfect uniformity.
    # <p>[In early versions of Java, the result was incorrectly calculated as:
    # <pre> {@code
    # return (((long)next(27) << 27) + next(27))
    # / (double)(1L << 54);}</pre>
    # This might seem to be equivalent, if not better, but in fact it
    # introduced a large nonuniformity because of the bias in the rounding
    # of floating-point numbers: it was three times as likely that the
    # low-order bit of the significand would be 0 than that it would be 1!
    # This nonuniformity probably doesn't matter much in practice, but we
    # strive for perfection.]
    # 
    # @return the next pseudorandom, uniformly distributed {@code double}
    # value between {@code 0.0} and {@code 1.0} from this
    # random number generator's sequence
    # @see Math#random
    def next_double
      return (((next(26)) << 27) + next(27)) / ((1 << 53)).to_f
    end
    
    attr_accessor :next_next_gaussian
    alias_method :attr_next_next_gaussian, :next_next_gaussian
    undef_method :next_next_gaussian
    alias_method :attr_next_next_gaussian=, :next_next_gaussian=
    undef_method :next_next_gaussian=
    
    attr_accessor :have_next_next_gaussian
    alias_method :attr_have_next_next_gaussian, :have_next_next_gaussian
    undef_method :have_next_next_gaussian
    alias_method :attr_have_next_next_gaussian=, :have_next_next_gaussian=
    undef_method :have_next_next_gaussian=
    
    typesig { [] }
    # Returns the next pseudorandom, Gaussian ("normally") distributed
    # {@code double} value with mean {@code 0.0} and standard
    # deviation {@code 1.0} from this random number generator's sequence.
    # <p>
    # The general contract of {@code nextGaussian} is that one
    # {@code double} value, chosen from (approximately) the usual
    # normal distribution with mean {@code 0.0} and standard deviation
    # {@code 1.0}, is pseudorandomly generated and returned.
    # 
    # <p>The method {@code nextGaussian} is implemented by class
    # {@code Random} as if by a threadsafe version of the following:
    # <pre> {@code
    # private double nextNextGaussian;
    # private boolean haveNextNextGaussian = false;
    # 
    # public double nextGaussian() {
    # if (haveNextNextGaussian) {
    # haveNextNextGaussian = false;
    # return nextNextGaussian;
    # } else {
    # double v1, v2, s;
    # do {
    # v1 = 2 * nextDouble() - 1;   // between -1.0 and 1.0
    # v2 = 2 * nextDouble() - 1;   // between -1.0 and 1.0
    # s = v1 * v1 + v2 * v2;
    # } while (s >= 1 || s == 0);
    # double multiplier = StrictMath.sqrt(-2 * StrictMath.log(s)/s);
    # nextNextGaussian = v2 * multiplier;
    # haveNextNextGaussian = true;
    # return v1 * multiplier;
    # }
    # }}</pre>
    # This uses the <i>polar method</i> of G. E. P. Box, M. E. Muller, and
    # G. Marsaglia, as described by Donald E. Knuth in <i>The Art of
    # Computer Programming</i>, Volume 3: <i>Seminumerical Algorithms</i>,
    # section 3.4.1, subsection C, algorithm P. Note that it generates two
    # independent values at the cost of only one call to {@code StrictMath.log}
    # and one call to {@code StrictMath.sqrt}.
    # 
    # @return the next pseudorandom, Gaussian ("normally") distributed
    # {@code double} value with mean {@code 0.0} and
    # standard deviation {@code 1.0} from this random number
    # generator's sequence
    def next_gaussian
      synchronized(self) do
        # See Knuth, ACP, Section 3.4.1 Algorithm C.
        if (@have_next_next_gaussian)
          @have_next_next_gaussian = false
          return @next_next_gaussian
        else
          v1 = 0.0
          v2 = 0.0
          s = 0.0
          begin
            v1 = 2 * next_double - 1 # between -1 and 1
            v2 = 2 * next_double - 1 # between -1 and 1
            s = v1 * v1 + v2 * v2
          end while (s >= 1 || (s).equal?(0))
          multiplier = StrictMath.sqrt(-2 * StrictMath.log(s) / s)
          @next_next_gaussian = v2 * multiplier
          @have_next_next_gaussian = true
          return v1 * multiplier
        end
      end
    end
    
    class_module.module_eval {
      # Serializable fields for Random.
      # 
      # @serialField    seed long
      # seed for random computations
      # @serialField    nextNextGaussian double
      # next Gaussian to be returned
      # @serialField      haveNextNextGaussian boolean
      # nextNextGaussian is valid
      const_set_lazy(:SerialPersistentFields) { Array.typed(ObjectStreamField).new([ObjectStreamField.new("seed", Long::TYPE), ObjectStreamField.new("nextNextGaussian", Double::TYPE), ObjectStreamField.new("haveNextNextGaussian", Boolean::TYPE)]) }
      const_attr_reader  :SerialPersistentFields
    }
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the {@code Random} instance from a stream (that is,
    # deserialize it).
    def read_object(s)
      fields = s.read_fields
      # The seed is read in as {@code long} for
      # historical reasons, but it is converted to an AtomicLong.
      seed_val = fields.get("seed", -1)
      if (seed_val < 0)
        raise Java::Io::StreamCorruptedException.new("Random: invalid seed")
      end
      reset_seed(seed_val)
      @next_next_gaussian = fields.get("nextNextGaussian", 0.0)
      @have_next_next_gaussian = fields.get("haveNextNextGaussian", false)
    end
    
    typesig { [ObjectOutputStream] }
    # Save the {@code Random} instance to a stream.
    def write_object(s)
      synchronized(self) do
        # set the values of the Serializable fields
        fields = s.put_fields
        # The seed is serialized as a long for historical reasons.
        fields.put("seed", @seed.get)
        fields.put("nextNextGaussian", @next_next_gaussian)
        fields.put("haveNextNextGaussian", @have_next_next_gaussian)
        # save them
        s.write_fields
      end
    end
    
    class_module.module_eval {
      # Support for resetting seed while deserializing
      const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
      const_attr_reader  :UnsafeInstance
      
      when_class_loaded do
        begin
          const_set :SeedOffset, UnsafeInstance.object_field_offset(Random.class.get_declared_field("seed"))
        rescue Exception => ex
          raise JavaError.new(ex)
        end
      end
    }
    
    typesig { [::Java::Long] }
    def reset_seed(seed_val)
      UnsafeInstance.put_object_volatile(self, SeedOffset, AtomicLong.new(seed_val))
    end
    
    private
    alias_method :initialize__random, :initialize
  end
  
end
