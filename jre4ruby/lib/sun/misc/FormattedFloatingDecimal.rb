require "rjava"

# 
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
module Sun::Misc
  module FormattedFloatingDecimalImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Sun::Misc, :FpUtils
      include_const ::Sun::Misc, :DoubleConsts
      include_const ::Sun::Misc, :FloatConsts
      include ::Java::Util::Regex
    }
  end
  
  class FormattedFloatingDecimal 
    include_class_members FormattedFloatingDecimalImports
    
    attr_accessor :is_exceptional
    alias_method :attr_is_exceptional, :is_exceptional
    undef_method :is_exceptional
    alias_method :attr_is_exceptional=, :is_exceptional=
    undef_method :is_exceptional=
    
    attr_accessor :is_negative
    alias_method :attr_is_negative, :is_negative
    undef_method :is_negative
    alias_method :attr_is_negative=, :is_negative=
    undef_method :is_negative=
    
    attr_accessor :dec_exponent
    alias_method :attr_dec_exponent, :dec_exponent
    undef_method :dec_exponent
    alias_method :attr_dec_exponent=, :dec_exponent=
    undef_method :dec_exponent=
    
    # value set at construction, then immutable
    attr_accessor :dec_exponent_rounded
    alias_method :attr_dec_exponent_rounded, :dec_exponent_rounded
    undef_method :dec_exponent_rounded
    alias_method :attr_dec_exponent_rounded=, :dec_exponent_rounded=
    undef_method :dec_exponent_rounded=
    
    attr_accessor :digits
    alias_method :attr_digits, :digits
    undef_method :digits
    alias_method :attr_digits=, :digits=
    undef_method :digits=
    
    attr_accessor :n_digits
    alias_method :attr_n_digits, :n_digits
    undef_method :n_digits
    alias_method :attr_n_digits=, :n_digits=
    undef_method :n_digits=
    
    attr_accessor :big_int_exp
    alias_method :attr_big_int_exp, :big_int_exp
    undef_method :big_int_exp
    alias_method :attr_big_int_exp=, :big_int_exp=
    undef_method :big_int_exp=
    
    attr_accessor :big_int_nbits
    alias_method :attr_big_int_nbits, :big_int_nbits
    undef_method :big_int_nbits
    alias_method :attr_big_int_nbits=, :big_int_nbits=
    undef_method :big_int_nbits=
    
    attr_accessor :must_set_round_dir
    alias_method :attr_must_set_round_dir, :must_set_round_dir
    undef_method :must_set_round_dir
    alias_method :attr_must_set_round_dir=, :must_set_round_dir=
    undef_method :must_set_round_dir=
    
    attr_accessor :from_hex
    alias_method :attr_from_hex, :from_hex
    undef_method :from_hex
    alias_method :attr_from_hex=, :from_hex=
    undef_method :from_hex=
    
    attr_accessor :round_dir
    alias_method :attr_round_dir, :round_dir
    undef_method :round_dir
    alias_method :attr_round_dir=, :round_dir=
    undef_method :round_dir=
    
    # set by doubleValue
    attr_accessor :precision
    alias_method :attr_precision, :precision
    undef_method :precision
    alias_method :attr_precision=, :precision=
    undef_method :precision=
    
    class_module.module_eval {
      const_set_lazy(:SCIENTIFIC) { Form::SCIENTIFIC }
      const_attr_reader  :SCIENTIFIC
      
      const_set_lazy(:COMPATIBLE) { Form::COMPATIBLE }
      const_attr_reader  :COMPATIBLE
      
      const_set_lazy(:DECIMAL_FLOAT) { Form::DECIMAL_FLOAT }
      const_attr_reader  :DECIMAL_FLOAT
      
      const_set_lazy(:GENERAL) { Form::GENERAL }
      const_attr_reader  :GENERAL
      
      # number of digits to the right of decimal
      class Form 
        include_class_members FormattedFloatingDecimal
        
        class_module.module_eval {
          const_set_lazy(:SCIENTIFIC) { Form.new.set_value_name("SCIENTIFIC") }
          const_attr_reader  :SCIENTIFIC
          
          const_set_lazy(:COMPATIBLE) { Form.new.set_value_name("COMPATIBLE") }
          const_attr_reader  :COMPATIBLE
          
          const_set_lazy(:DECIMAL_FLOAT) { Form.new.set_value_name("DECIMAL_FLOAT") }
          const_attr_reader  :DECIMAL_FLOAT
          
          const_set_lazy(:GENERAL) { Form.new.set_value_name("GENERAL") }
          const_attr_reader  :GENERAL
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [SCIENTIFIC, COMPATIBLE, DECIMAL_FLOAT, GENERAL]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__form, :initialize
      end
    }
    
    attr_accessor :form
    alias_method :attr_form, :form
    undef_method :form
    alias_method :attr_form=, :form=
    undef_method :form=
    
    typesig { [::Java::Boolean, ::Java::Int, Array.typed(::Java::Char), ::Java::Int, ::Java::Boolean, ::Java::Int, Form] }
    def initialize(neg_sign, dec_exponent, digits, n, e, precision, form)
      @is_exceptional = false
      @is_negative = false
      @dec_exponent = 0
      @dec_exponent_rounded = 0
      @digits = nil
      @n_digits = 0
      @big_int_exp = 0
      @big_int_nbits = 0
      @must_set_round_dir = false
      @from_hex = false
      @round_dir = 0
      @precision = 0
      @form = nil
      @is_negative = neg_sign
      @is_exceptional = e
      @dec_exponent = dec_exponent
      @digits = digits
      @n_digits = n
      @precision = precision
      @form = form
    end
    
    class_module.module_eval {
      # 
      # Constants of the implementation
      # Most are IEEE-754 related.
      # (There are more really boring constants at the end.)
      const_set_lazy(:SignMask) { -0x8000000000000000 }
      const_attr_reader  :SignMask
      
      const_set_lazy(:ExpMask) { 0x7ff0000000000000 }
      const_attr_reader  :ExpMask
      
      const_set_lazy(:FractMask) { ~(SignMask | ExpMask) }
      const_attr_reader  :FractMask
      
      const_set_lazy(:ExpShift) { 52 }
      const_attr_reader  :ExpShift
      
      const_set_lazy(:ExpBias) { 1023 }
      const_attr_reader  :ExpBias
      
      const_set_lazy(:FractHOB) { (1 << ExpShift) }
      const_attr_reader  :FractHOB
      
      # assumed High-Order bit
      const_set_lazy(:ExpOne) { (ExpBias) << ExpShift }
      const_attr_reader  :ExpOne
      
      # exponent of 1.0
      const_set_lazy(:MaxSmallBinExp) { 62 }
      const_attr_reader  :MaxSmallBinExp
      
      const_set_lazy(:MinSmallBinExp) { -(63 / 3) }
      const_attr_reader  :MinSmallBinExp
      
      const_set_lazy(:MaxDecimalDigits) { 15 }
      const_attr_reader  :MaxDecimalDigits
      
      const_set_lazy(:MaxDecimalExponent) { 308 }
      const_attr_reader  :MaxDecimalExponent
      
      const_set_lazy(:MinDecimalExponent) { -324 }
      const_attr_reader  :MinDecimalExponent
      
      const_set_lazy(:BigDecimalExponent) { 324 }
      const_attr_reader  :BigDecimalExponent
      
      # i.e. abs(minDecimalExponent)
      const_set_lazy(:Highbyte) { -0x100000000000000 }
      const_attr_reader  :Highbyte
      
      const_set_lazy(:Highbit) { -0x8000000000000000 }
      const_attr_reader  :Highbit
      
      const_set_lazy(:Lowbytes) { ~Highbyte }
      const_attr_reader  :Lowbytes
      
      const_set_lazy(:SingleSignMask) { -0x80000000 }
      const_attr_reader  :SingleSignMask
      
      const_set_lazy(:SingleExpMask) { 0x7f800000 }
      const_attr_reader  :SingleExpMask
      
      const_set_lazy(:SingleFractMask) { ~(SingleSignMask | SingleExpMask) }
      const_attr_reader  :SingleFractMask
      
      const_set_lazy(:SingleExpShift) { 23 }
      const_attr_reader  :SingleExpShift
      
      const_set_lazy(:SingleFractHOB) { 1 << SingleExpShift }
      const_attr_reader  :SingleFractHOB
      
      const_set_lazy(:SingleExpBias) { 127 }
      const_attr_reader  :SingleExpBias
      
      const_set_lazy(:SingleMaxDecimalDigits) { 7 }
      const_attr_reader  :SingleMaxDecimalDigits
      
      const_set_lazy(:SingleMaxDecimalExponent) { 38 }
      const_attr_reader  :SingleMaxDecimalExponent
      
      const_set_lazy(:SingleMinDecimalExponent) { -45 }
      const_attr_reader  :SingleMinDecimalExponent
      
      const_set_lazy(:IntDecimalDigits) { 9 }
      const_attr_reader  :IntDecimalDigits
      
      typesig { [::Java::Long] }
      # 
      # count number of bits from high-order 1 bit to low-order 1 bit,
      # inclusive.
      def count_bits(v)
        # 
        # the strategy is to shift until we get a non-zero sign bit
        # then shift until we have no bits left, counting the difference.
        # we do byte shifting as a hack. Hope it helps.
        if ((v).equal?(0))
          return 0
        end
        while (((v & Highbyte)).equal?(0))
          v <<= 8
        end
        while (v > 0)
          # i.e. while ((v&highbit) == 0L )
          v <<= 1
        end
        n = 0
        while (!((v & Lowbytes)).equal?(0))
          v <<= 8
          n += 8
        end
        while (!(v).equal?(0))
          v <<= 1
          n += 1
        end
        return n
      end
      
      # 
      # Keep big powers of 5 handy for future reference.
      
      def b5p
        defined?(@@b5p) ? @@b5p : @@b5p= nil
      end
      alias_method :attr_b5p, :b5p
      
      def b5p=(value)
        @@b5p = value
      end
      alias_method :attr_b5p=, :b5p=
      
      typesig { [::Java::Int] }
      def big5pow(p)
        synchronized(self) do
          raise AssertError, (p).to_s if not (p >= 0) # negative power of 5
          if ((self.attr_b5p).nil?)
            self.attr_b5p = Array.typed(FDBigInt).new(p + 1) { nil }
          else
            if (self.attr_b5p.attr_length <= p)
              t = Array.typed(FDBigInt).new(p + 1) { nil }
              System.arraycopy(self.attr_b5p, 0, t, 0, self.attr_b5p.attr_length)
              self.attr_b5p = t
            end
          end
          if (!(self.attr_b5p[p]).nil?)
            return self.attr_b5p[p]
          else
            if (p < Small5pow.attr_length)
              return self.attr_b5p[p] = FDBigInt.new(Small5pow[p])
            else
              if (p < Long5pow.attr_length)
                return self.attr_b5p[p] = FDBigInt.new(Long5pow[p])
              else
                # construct the value.
                # recursively.
                q = 0
                r = 0
                # in order to compute 5^p,
                # compute its square root, 5^(p/2) and square.
                # or, let q = p / 2, r = p -q, then
                # 5^p = 5^(q+r) = 5^q * 5^r
                q = p >> 1
                r = p - q
                bigq = self.attr_b5p[q]
                if ((bigq).nil?)
                  bigq = big5pow(q)
                end
                if (r < Small5pow.attr_length)
                  return (self.attr_b5p[p] = bigq.mult(Small5pow[r]))
                else
                  bigr = self.attr_b5p[r]
                  if ((bigr).nil?)
                    bigr = big5pow(r)
                  end
                  return (self.attr_b5p[p] = bigq.mult(bigr))
                end
              end
            end
          end
        end
      end
      
      typesig { [FDBigInt, ::Java::Int, ::Java::Int] }
      # 
      # a common operation
      def mult_pow52(v, p5, p2)
        if (!(p5).equal?(0))
          if (p5 < Small5pow.attr_length)
            v = v.mult(Small5pow[p5])
          else
            v = v.mult(big5pow(p5))
          end
        end
        if (!(p2).equal?(0))
          v.lshift_me(p2)
        end
        return v
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # 
      # another common operation
      def construct_pow52(p5, p2)
        v = FDBigInt.new(big5pow(p5))
        if (!(p2).equal?(0))
          v.lshift_me(p2)
        end
        return v
      end
    }
    
    typesig { [::Java::Double] }
    # 
    # Make a floating double into a FDBigInt.
    # This could also be structured as a FDBigInt
    # constructor, but we'd have to build a lot of knowledge
    # about floating-point representation into it, and we don't want to.
    # 
    # AS A SIDE EFFECT, THIS METHOD WILL SET THE INSTANCE VARIABLES
    # bigIntExp and bigIntNBits
    def double_to_big_int(dval)
      lbits = Double.double_to_long_bits(dval) & ~SignMask
      binexp = RJava.cast_to_int((lbits >> ExpShift))
      lbits &= FractMask
      if (binexp > 0)
        lbits |= FractHOB
      else
        raise AssertError, (lbits).to_s if not (!(lbits).equal?(0)) # doubleToBigInt(0.0)
        binexp += 1
        while (((lbits & FractHOB)).equal?(0))
          lbits <<= 1
          binexp -= 1
        end
      end
      binexp -= ExpBias
      nbits = count_bits(lbits)
      # 
      # We now know where the high-order 1 bit is,
      # and we know how many there are.
      low_order_zeros = ExpShift + 1 - nbits
      lbits >>= low_order_zeros
      @big_int_exp = binexp + 1 - nbits
      @big_int_nbits = nbits
      return FDBigInt.new(lbits)
    end
    
    class_module.module_eval {
      typesig { [::Java::Double, ::Java::Boolean] }
      # 
      # Compute a number that is the ULP of the given value,
      # for purposes of addition/subtraction. Generally easy.
      # More difficult if subtracting and the argument
      # is a normalized a power of 2, as the ULP changes at these points.
      def ulp(dval, subtracting)
        lbits = Double.double_to_long_bits(dval) & ~SignMask
        binexp = RJava.cast_to_int((lbits >> ExpShift))
        ulpval = 0.0
        if (subtracting && (binexp >= ExpShift) && (((lbits & FractMask)).equal?(0)))
          # for subtraction from normalized, powers of 2,
          # use next-smaller exponent
          binexp -= 1
        end
        if (binexp > ExpShift)
          ulpval = Double.long_bits_to_double(((binexp - ExpShift)) << ExpShift)
        else
          if ((binexp).equal?(0))
            ulpval = Double::MIN_VALUE
          else
            ulpval = Double.long_bits_to_double(1 << (binexp - 1))
          end
        end
        if (subtracting)
          ulpval = -ulpval
        end
        return ulpval
      end
    }
    
    typesig { [::Java::Double] }
    # 
    # Round a double to a float.
    # In addition to the fraction bits of the double,
    # look at the class instance variable roundDir,
    # which should help us avoid double-rounding error.
    # roundDir was set in hardValueOf if the estimate was
    # close enough, but not exact. It tells us which direction
    # of rounding is preferred.
    def sticky_round(dval)
      lbits = Double.double_to_long_bits(dval)
      binexp = lbits & ExpMask
      if ((binexp).equal?(0) || (binexp).equal?(ExpMask))
        # what we have here is special.
        # don't worry, the right thing will happen.
        return (dval).to_f
      end
      lbits += @round_dir # hack-o-matic.
      return (Double.long_bits_to_double(lbits)).to_f
    end
    
    typesig { [::Java::Int, ::Java::Long, ::Java::Long] }
    # 
    # This is the easy subcase --
    # all the significant bits, after scaling, are held in lvalue.
    # negSign and decExponent tell us what processing and scaling
    # has already been done. Exceptional cases have already been
    # stripped out.
    # In particular:
    # lvalue is a finite number (not Inf, nor NaN)
    # lvalue > 0L (not zero, nor negative).
    # 
    # The only reason that we develop the digits here, rather than
    # calling on Long.toString() is that we can do it a little faster,
    # and besides want to treat trailing 0s specially. If Long.toString
    # changes, we should re-evaluate this strategy!
    def develop_long_digits(dec_exponent, lvalue, insignificant)
      digits = nil
      ndigits = 0
      digitno = 0
      c = 0
      # 
      # Discard non-significant low-order bits, while rounding,
      # up to insignificant value.
      i = 0
      i = 0
      while insignificant >= 10
        insignificant /= 10
        ((i += 1) - 1)
      end
      if (!(i).equal?(0))
        pow10 = Long5pow[i] << i # 10^i == 5^i * 2^i;
        residue = lvalue % pow10
        lvalue /= pow10
        dec_exponent += i
        if (residue >= (pow10 >> 1))
          # round up based on the low-order bits we're discarding
          ((lvalue += 1) - 1)
        end
      end
      if (lvalue <= JavaInteger::MAX_VALUE)
        raise AssertError, (lvalue).to_s if not (lvalue > 0) # lvalue <= 0
        # even easier subcase!
        # can do int arithmetic rather than long!
        ivalue = RJava.cast_to_int(lvalue)
        ndigits = 10
        digits = (self.attr_per_thread_buffer.get)
        digitno = ndigits - 1
        c = ivalue % 10
        ivalue /= 10
        while ((c).equal?(0))
          ((dec_exponent += 1) - 1)
          c = ivalue % 10
          ivalue /= 10
        end
        while (!(ivalue).equal?(0))
          digits[((digitno -= 1) + 1)] = RJava.cast_to_char((c + Character.new(?0.ord)))
          ((dec_exponent += 1) - 1)
          c = ivalue % 10
          ivalue /= 10
        end
        digits[digitno] = RJava.cast_to_char((c + Character.new(?0.ord)))
      else
        # same algorithm as above (same bugs, too )
        # but using long arithmetic.
        ndigits = 20
        digits = (self.attr_per_thread_buffer.get)
        digitno = ndigits - 1
        c = RJava.cast_to_int((lvalue % 10))
        lvalue /= 10
        while ((c).equal?(0))
          ((dec_exponent += 1) - 1)
          c = RJava.cast_to_int((lvalue % 10))
          lvalue /= 10
        end
        while (!(lvalue).equal?(0))
          digits[((digitno -= 1) + 1)] = RJava.cast_to_char((c + Character.new(?0.ord)))
          ((dec_exponent += 1) - 1)
          c = RJava.cast_to_int((lvalue % 10))
          lvalue /= 10
        end
        digits[digitno] = RJava.cast_to_char((c + Character.new(?0.ord)))
      end
      result = nil
      ndigits -= digitno
      result = CharArray.new(ndigits)
      System.arraycopy(digits, digitno, result, 0, ndigits)
      @digits = result
      @dec_exponent = dec_exponent + 1
      @n_digits = ndigits
    end
    
    typesig { [] }
    # 
    # add one to the least significant digit.
    # in the unlikely event there is a carry out,
    # deal with it.
    # assert that this will only happen where there
    # is only one digit, e.g. (float)1e-44 seems to do it.
    def roundup
      i = 0
      q = @digits[i = (@n_digits - 1)]
      if ((q).equal?(Character.new(?9.ord)))
        while ((q).equal?(Character.new(?9.ord)) && i > 0)
          @digits[i] = Character.new(?0.ord)
          q = @digits[(i -= 1)]
        end
        if ((q).equal?(Character.new(?9.ord)))
          # carryout! High-order 1, rest 0s, larger exp.
          @dec_exponent += 1
          @digits[0] = Character.new(?1.ord)
          return
        end
        # else fall through.
      end
      @digits[i] = RJava.cast_to_char((q + 1))
    end
    
    typesig { [::Java::Int] }
    # Given the desired number of digits predict the result's exponent.
    def check_exponent(length)
      if (length >= @n_digits || length < 0)
        return @dec_exponent
      end
      i = 0
      while i < length
        if (!(@digits[i]).equal?(Character.new(?9.ord)))
          # a '9' anywhere in digits will absorb the round
          return @dec_exponent
        end
        ((i += 1) - 1)
      end
      return @dec_exponent + (@digits[length] >= Character.new(?5.ord) ? 1 : 0)
    end
    
    typesig { [::Java::Int] }
    # Unlike roundup(), this method does not modify digits.  It also
    # rounds at a particular precision.
    def apply_precision(length)
      result = CharArray.new(@n_digits)
      i = 0
      while i < result.attr_length
        result[i] = Character.new(?0.ord)
        ((i += 1) - 1)
      end
      if (length >= @n_digits || length < 0)
        # no rounding necessary
        System.arraycopy(@digits, 0, result, 0, @n_digits)
        return result
      end
      if ((length).equal?(0))
        # only one digit (0 or 1) is returned because the precision
        # excludes all significant digits
        if (@digits[0] >= Character.new(?5.ord))
          result[0] = Character.new(?1.ord)
        end
        return result
      end
      i_ = length
      q = @digits[i_]
      if (q >= Character.new(?5.ord) && i_ > 0)
        q = @digits[(i_ -= 1)]
        if ((q).equal?(Character.new(?9.ord)))
          while ((q).equal?(Character.new(?9.ord)) && i_ > 0)
            q = @digits[(i_ -= 1)]
          end
          if ((q).equal?(Character.new(?9.ord)))
            # carryout! High-order 1, rest 0s, larger exp.
            result[0] = Character.new(?1.ord)
            return result
          end
        end
        result[i_] = RJava.cast_to_char((q + 1))
      end
      while ((i_ -= 1) >= 0)
        result[i_] = @digits[i_]
      end
      return result
    end
    
    typesig { [::Java::Double] }
    # 
    # FIRST IMPORTANT CONSTRUCTOR: DOUBLE
    def initialize(d)
      initialize__formatted_floating_decimal(d, JavaInteger::MAX_VALUE, Form::COMPATIBLE)
    end
    
    typesig { [::Java::Double, ::Java::Int, Form] }
    def initialize(d, precision, form)
      @is_exceptional = false
      @is_negative = false
      @dec_exponent = 0
      @dec_exponent_rounded = 0
      @digits = nil
      @n_digits = 0
      @big_int_exp = 0
      @big_int_nbits = 0
      @must_set_round_dir = false
      @from_hex = false
      @round_dir = 0
      @precision = 0
      @form = nil
      d_bits = Double.double_to_long_bits(d)
      fract_bits = 0
      bin_exp = 0
      n_significant_bits = 0
      @precision = precision
      @form = form
      # discover and delete sign
      if (!((d_bits & SignMask)).equal?(0))
        @is_negative = true
        d_bits ^= SignMask
      else
        @is_negative = false
      end
      # Begin to unpack
      # Discover obvious special cases of NaN and Infinity.
      bin_exp = RJava.cast_to_int(((d_bits & ExpMask) >> ExpShift))
      fract_bits = d_bits & FractMask
      if ((bin_exp).equal?(RJava.cast_to_int((ExpMask >> ExpShift))))
        @is_exceptional = true
        if ((fract_bits).equal?(0))
          @digits = Infinity
        else
          @digits = NotANumber
          @is_negative = false # NaN has no sign!
        end
        @n_digits = @digits.attr_length
        return
      end
      @is_exceptional = false
      # Finish unpacking
      # Normalize denormalized numbers.
      # Insert assumed high-order bit for normalized numbers.
      # Subtract exponent bias.
      if ((bin_exp).equal?(0))
        if ((fract_bits).equal?(0))
          # not a denorm, just a 0!
          @dec_exponent = 0
          @digits = Zero
          @n_digits = 1
          return
        end
        while (((fract_bits & FractHOB)).equal?(0))
          fract_bits <<= 1
          bin_exp -= 1
        end
        n_significant_bits = ExpShift + bin_exp + 1 # recall binExp is  - shift count.
        bin_exp += 1
      else
        fract_bits |= FractHOB
        n_significant_bits = ExpShift + 1
      end
      bin_exp -= ExpBias
      # call the routine that actually does all the hard work.
      dtoa(bin_exp, fract_bits, n_significant_bits)
    end
    
    typesig { [::Java::Float] }
    # 
    # SECOND IMPORTANT CONSTRUCTOR: SINGLE
    def initialize(f)
      initialize__formatted_floating_decimal(f, JavaInteger::MAX_VALUE, Form::COMPATIBLE)
    end
    
    typesig { [::Java::Float, ::Java::Int, Form] }
    def initialize(f, precision, form)
      @is_exceptional = false
      @is_negative = false
      @dec_exponent = 0
      @dec_exponent_rounded = 0
      @digits = nil
      @n_digits = 0
      @big_int_exp = 0
      @big_int_nbits = 0
      @must_set_round_dir = false
      @from_hex = false
      @round_dir = 0
      @precision = 0
      @form = nil
      f_bits = Float.float_to_int_bits(f)
      fract_bits = 0
      bin_exp = 0
      n_significant_bits = 0
      @precision = precision
      @form = form
      # discover and delete sign
      if (!((f_bits & SingleSignMask)).equal?(0))
        @is_negative = true
        f_bits ^= SingleSignMask
      else
        @is_negative = false
      end
      # Begin to unpack
      # Discover obvious special cases of NaN and Infinity.
      bin_exp = RJava.cast_to_int(((f_bits & SingleExpMask) >> SingleExpShift))
      fract_bits = f_bits & SingleFractMask
      if ((bin_exp).equal?(RJava.cast_to_int((SingleExpMask >> SingleExpShift))))
        @is_exceptional = true
        if ((fract_bits).equal?(0))
          @digits = Infinity
        else
          @digits = NotANumber
          @is_negative = false # NaN has no sign!
        end
        @n_digits = @digits.attr_length
        return
      end
      @is_exceptional = false
      # Finish unpacking
      # Normalize denormalized numbers.
      # Insert assumed high-order bit for normalized numbers.
      # Subtract exponent bias.
      if ((bin_exp).equal?(0))
        if ((fract_bits).equal?(0))
          # not a denorm, just a 0!
          @dec_exponent = 0
          @digits = Zero
          @n_digits = 1
          return
        end
        while (((fract_bits & SingleFractHOB)).equal?(0))
          fract_bits <<= 1
          bin_exp -= 1
        end
        n_significant_bits = SingleExpShift + bin_exp + 1 # recall binExp is  - shift count.
        bin_exp += 1
      else
        fract_bits |= SingleFractHOB
        n_significant_bits = SingleExpShift + 1
      end
      bin_exp -= SingleExpBias
      # call the routine that actually does all the hard work.
      dtoa(bin_exp, (fract_bits) << (ExpShift - SingleExpShift), n_significant_bits)
    end
    
    typesig { [::Java::Int, ::Java::Long, ::Java::Int] }
    def dtoa(bin_exp, fract_bits, n_significant_bits)
      n_fract_bits = 0 # number of significant bits of fractBits;
      n_tiny_bits = 0 # number of these to the right of the point.
      dec_exp = 0
      # Examine number. Determine if it is an easy case,
      # which we can do pretty trivially using float/long conversion,
      # or whether we must do real work.
      n_fract_bits = count_bits(fract_bits)
      n_tiny_bits = Math.max(0, n_fract_bits - bin_exp - 1)
      if (bin_exp <= MaxSmallBinExp && bin_exp >= MinSmallBinExp)
        # Look more closely at the number to decide if,
        # with scaling by 10^nTinyBits, the result will fit in
        # a long.
        if ((n_tiny_bits < Long5pow.attr_length) && ((n_fract_bits + N5bits[n_tiny_bits]) < 64))
          # 
          # We can do this:
          # take the fraction bits, which are normalized.
          # (a) nTinyBits == 0: Shift left or right appropriately
          # to align the binary point at the extreme right, i.e.
          # where a long int point is expected to be. The integer
          # result is easily converted to a string.
          # (b) nTinyBits > 0: Shift right by expShift-nFractBits,
          # which effectively converts to long and scales by
          # 2^nTinyBits. Then multiply by 5^nTinyBits to
          # complete the scaling. We know this won't overflow
          # because we just counted the number of bits necessary
          # in the result. The integer you get from this can
          # then be converted to a string pretty easily.
          half_ulp = 0
          if ((n_tiny_bits).equal?(0))
            if (bin_exp > n_significant_bits)
              half_ulp = 1 << (bin_exp - n_significant_bits - 1)
            else
              half_ulp = 0
            end
            if (bin_exp >= ExpShift)
              fract_bits <<= (bin_exp - ExpShift)
            else
              fract_bits >>= (ExpShift - bin_exp)
            end
            develop_long_digits(0, fract_bits, half_ulp)
            return
          end
          # 
          # The following causes excess digits to be printed
          # out in the single-float case. Our manipulation of
          # halfULP here is apparently not correct. If we
          # better understand how this works, perhaps we can
          # use this special case again. But for the time being,
          # we do not.
          # else {
          # fractBits >>>= expShift+1-nFractBits;
          # fractBits *= long5pow[ nTinyBits ];
          # halfULP = long5pow[ nTinyBits ] >> (1+nSignificantBits-nFractBits);
          # developLongDigits( -nTinyBits, fractBits, halfULP );
          # return;
          # }
        end
      end
      # 
      # This is the hard case. We are going to compute large positive
      # integers B and S and integer decExp, s.t.
      # d = ( B / S ) * 10^decExp
      # 1 <= B / S < 10
      # Obvious choices are:
      # decExp = floor( log10(d) )
      # B      = d * 2^nTinyBits * 10^max( 0, -decExp )
      # S      = 10^max( 0, decExp) * 2^nTinyBits
      # (noting that nTinyBits has already been forced to non-negative)
      # I am also going to compute a large positive integer
      # M      = (1/2^nSignificantBits) * 2^nTinyBits * 10^max( 0, -decExp )
      # i.e. M is (1/2) of the ULP of d, scaled like B.
      # When we iterate through dividing B/S and picking off the
      # quotient bits, we will know when to stop when the remainder
      # is <= M.
      # 
      # We keep track of powers of 2 and powers of 5.
      # 
      # 
      # Estimate decimal exponent. (If it is small-ish,
      # we could double-check.)
      # 
      # First, scale the mantissa bits such that 1 <= d2 < 2.
      # We are then going to estimate
      # log10(d2) ~=~  (d2-1.5)/1.5 + log(1.5)
      # and so we can estimate
      # log10(d) ~=~ log10(d2) + binExp * log10(2)
      # take the floor and call it decExp.
      # FIXME -- use more precise constants here. It costs no more.
      d2 = Double.long_bits_to_double(ExpOne | (fract_bits & ~FractHOB))
      dec_exp = RJava.cast_to_int(Math.floor((d2 - 1.5) * 0.289529654 + 0.176091259 + (bin_exp).to_f * 0.301029995663981))
      b2 = 0
      b5 = 0 # powers of 2 and powers of 5, respectively, in B
      s2 = 0
      s5 = 0 # powers of 2 and powers of 5, respectively, in S
      m2 = 0
      m5 = 0 # powers of 2 and powers of 5, respectively, in M
      bbits = 0 # binary digits needed to represent B, approx.
      ten_sbits = 0 # binary digits needed to represent 10*S, approx.
      sval = nil
      bval = nil
      mval = nil
      b5 = Math.max(0, -dec_exp)
      b2 = b5 + n_tiny_bits + bin_exp
      s5 = Math.max(0, dec_exp)
      s2 = s5 + n_tiny_bits
      m5 = b5
      m2 = b2 - n_significant_bits
      # 
      # the long integer fractBits contains the (nFractBits) interesting
      # bits from the mantissa of d ( hidden 1 added if necessary) followed
      # by (expShift+1-nFractBits) zeros. In the interest of compactness,
      # I will shift out those zeros before turning fractBits into a
      # FDBigInt. The resulting whole number will be
      # d * 2^(nFractBits-1-binExp).
      fract_bits >>= (ExpShift + 1 - n_fract_bits)
      b2 -= n_fract_bits - 1
      common2factor = Math.min(b2, s2)
      b2 -= common2factor
      s2 -= common2factor
      m2 -= common2factor
      # 
      # HACK!! For exact powers of two, the next smallest number
      # is only half as far away as we think (because the meaning of
      # ULP changes at power-of-two bounds) for this reason, we
      # hack M2. Hope this works.
      if ((n_fract_bits).equal?(1))
        m2 -= 1
      end
      if (m2 < 0)
        # oops.
        # since we cannot scale M down far enough,
        # we must scale the other values up.
        b2 -= m2
        s2 -= m2
        m2 = 0
      end
      # 
      # Construct, Scale, iterate.
      # Some day, we'll write a stopping test that takes
      # account of the assymetry of the spacing of floating-point
      # numbers below perfect powers of 2
      # 26 Sept 96 is not that day.
      # So we use a symmetric test.
      digits = @digits = CharArray.new(18)
      ndigit = 0
      low = false
      high = false
      low_digit_difference = 0
      q = 0
      # 
      # Detect the special cases where all the numbers we are about
      # to compute will fit in int or long integers.
      # In these cases, we will avoid doing FDBigInt arithmetic.
      # We use the same algorithms, except that we "normalize"
      # our FDBigInts before iterating. This is to make division easier,
      # as it makes our fist guess (quotient of high-order words)
      # more accurate!
      # 
      # Some day, we'll write a stopping test that takes
      # account of the assymetry of the spacing of floating-point
      # numbers below perfect powers of 2
      # 26 Sept 96 is not that day.
      # So we use a symmetric test.
      bbits = n_fract_bits + b2 + ((b5 < N5bits.attr_length) ? N5bits[b5] : (b5 * 3))
      ten_sbits = s2 + 1 + (((s5 + 1) < N5bits.attr_length) ? N5bits[(s5 + 1)] : ((s5 + 1) * 3))
      if (bbits < 64 && ten_sbits < 64)
        if (bbits < 32 && ten_sbits < 32)
          # wa-hoo! They're all ints!
          b = (RJava.cast_to_int(fract_bits) * Small5pow[b5]) << b2
          s = Small5pow[s5] << s2
          m = Small5pow[m5] << m2
          tens = s * 10
          # 
          # Unroll the first iteration. If our decExp estimate
          # was too high, our first quotient will be zero. In this
          # case, we discard it and decrement decExp.
          ndigit = 0
          q = b / s
          b = 10 * (b % s)
          m *= 10
          low = (b < m)
          high = (b + m > tens)
          raise AssertError, (q).to_s if not (q < 10) # excessively large digit
          if (((q).equal?(0)) && !high)
            # oops. Usually ignore leading zero.
            ((dec_exp -= 1) + 1)
          else
            digits[((ndigit += 1) - 1)] = RJava.cast_to_char((Character.new(?0.ord) + q))
          end
          # 
          # HACK! Java spec sez that we always have at least
          # one digit after the . in either F- or E-form output.
          # Thus we will need more than one digit if we're using
          # E-form
          if (!((@form).equal?(Form::COMPATIBLE) && -3 < dec_exp && dec_exp < 8))
            high = low = false
          end
          while (!low && !high)
            q = b / s
            b = 10 * (b % s)
            m *= 10
            raise AssertError, (q).to_s if not (q < 10) # excessively large digit
            if (m > 0)
              low = (b < m)
              high = (b + m > tens)
            else
              # hack -- m might overflow!
              # in this case, it is certainly > b,
              # which won't
              # and b+m > tens, too, since that has overflowed
              # either!
              low = true
              high = true
            end
            digits[((ndigit += 1) - 1)] = RJava.cast_to_char((Character.new(?0.ord) + q))
          end
          low_digit_difference = (b << 1) - tens
        else
          # still good! they're all longs!
          b_ = (fract_bits * Long5pow[b5]) << b2
          s_ = Long5pow[s5] << s2
          m_ = Long5pow[m5] << m2
          tens_ = s_ * 10
          # 
          # Unroll the first iteration. If our decExp estimate
          # was too high, our first quotient will be zero. In this
          # case, we discard it and decrement decExp.
          ndigit = 0
          q = RJava.cast_to_int((b_ / s_))
          b_ = 10 * (b_ % s_)
          m_ *= 10
          low = (b_ < m_)
          high = (b_ + m_ > tens_)
          raise AssertError, (q).to_s if not (q < 10) # excessively large digit
          if (((q).equal?(0)) && !high)
            # oops. Usually ignore leading zero.
            ((dec_exp -= 1) + 1)
          else
            digits[((ndigit += 1) - 1)] = RJava.cast_to_char((Character.new(?0.ord) + q))
          end
          # 
          # HACK! Java spec sez that we always have at least
          # one digit after the . in either F- or E-form output.
          # Thus we will need more than one digit if we're using
          # E-form
          if (!((@form).equal?(Form::COMPATIBLE) && -3 < dec_exp && dec_exp < 8))
            high = low = false
          end
          while (!low && !high)
            q = RJava.cast_to_int((b_ / s_))
            b_ = 10 * (b_ % s_)
            m_ *= 10
            raise AssertError, (q).to_s if not (q < 10) # excessively large digit
            if (m_ > 0)
              low = (b_ < m_)
              high = (b_ + m_ > tens_)
            else
              # hack -- m might overflow!
              # in this case, it is certainly > b,
              # which won't
              # and b+m > tens, too, since that has overflowed
              # either!
              low = true
              high = true
            end
            digits[((ndigit += 1) - 1)] = RJava.cast_to_char((Character.new(?0.ord) + q))
          end
          low_digit_difference = (b_ << 1) - tens_
        end
      else
        ten_sval = nil
        shift_bias = 0
        # 
        # We really must do FDBigInt arithmetic.
        # Fist, construct our FDBigInt initial values.
        bval = mult_pow52(FDBigInt.new(fract_bits), b5, b2)
        sval = construct_pow52(s5, s2)
        mval = construct_pow52(m5, m2)
        # normalize so that division works better
        bval.lshift_me(shift_bias = sval.normalize_me)
        mval.lshift_me(shift_bias)
        ten_sval = sval.mult(10)
        # 
        # Unroll the first iteration. If our decExp estimate
        # was too high, our first quotient will be zero. In this
        # case, we discard it and decrement decExp.
        ndigit = 0
        q = bval.quo_rem_iteration(sval)
        mval = mval.mult(10)
        low = (bval.cmp(mval) < 0)
        high = (bval.add(mval).cmp(ten_sval) > 0)
        raise AssertError, (q).to_s if not (q < 10) # excessively large digit
        if (((q).equal?(0)) && !high)
          # oops. Usually ignore leading zero.
          ((dec_exp -= 1) + 1)
        else
          digits[((ndigit += 1) - 1)] = RJava.cast_to_char((Character.new(?0.ord) + q))
        end
        # 
        # HACK! Java spec sez that we always have at least
        # one digit after the . in either F- or E-form output.
        # Thus we will need more than one digit if we're using
        # E-form
        if (!((@form).equal?(Form::COMPATIBLE) && -3 < dec_exp && dec_exp < 8))
          high = low = false
        end
        while (!low && !high)
          q = bval.quo_rem_iteration(sval)
          mval = mval.mult(10)
          raise AssertError, (q).to_s if not (q < 10) # excessively large digit
          low = (bval.cmp(mval) < 0)
          high = (bval.add(mval).cmp(ten_sval) > 0)
          digits[((ndigit += 1) - 1)] = RJava.cast_to_char((Character.new(?0.ord) + q))
        end
        if (high && low)
          bval.lshift_me(1)
          low_digit_difference = bval.cmp(ten_sval)
        else
          low_digit_difference = 0
        end # this here only for flow analysis!
      end
      @dec_exponent = dec_exp + 1
      @digits = digits
      @n_digits = ndigit
      # 
      # Last digit gets rounded based on stopping condition.
      if (high)
        if (low)
          if ((low_digit_difference).equal?(0))
            # it's a tie!
            # choose based on which digits we like.
            if (!((digits[@n_digits - 1] & 1)).equal?(0))
              roundup
            end
          else
            if (low_digit_difference > 0)
              roundup
            end
          end
        else
          roundup
        end
      end
    end
    
    typesig { [] }
    def to_s
      # most brain-dead version
      result = StringBuffer.new(@n_digits + 8)
      if (@is_negative)
        result.append(Character.new(?-.ord))
      end
      if (@is_exceptional)
        result.append(@digits, 0, @n_digits)
      else
        result.append("0.")
        result.append(@digits, 0, @n_digits)
        result.append(Character.new(?e.ord))
        result.append(@dec_exponent)
      end
      return String.new(result)
    end
    
    typesig { [] }
    # This method should only ever be called if this object is constructed
    # without Form.DECIMAL_FLOAT because the perThreadBuffer is not large
    # enough to handle floating-point numbers of large precision.
    def to_java_format_string
      result = (self.attr_per_thread_buffer.get)
      i = get_chars(result)
      return String.new(result, 0, i)
    end
    
    typesig { [] }
    # returns the exponent before rounding
    def get_exponent
      return @dec_exponent - 1
    end
    
    typesig { [] }
    # returns the exponent after rounding has been done by applyPrecision
    def get_exponent_rounded
      return @dec_exponent_rounded - 1
    end
    
    typesig { [Array.typed(::Java::Char)] }
    def get_chars(result)
      raise AssertError, (@n_digits).to_s if not (@n_digits <= 19) # generous bound on size of nDigits
      i = 0
      if (@is_negative)
        result[0] = Character.new(?-.ord)
        i = 1
      end
      if (@is_exceptional)
        System.arraycopy(@digits, 0, result, i, @n_digits)
        i += @n_digits
      else
        digits = @digits
        exp = @dec_exponent
        case (@form)
        when COMPATIBLE
        when DECIMAL_FLOAT
          exp = check_exponent(@dec_exponent + @precision)
          digits = apply_precision(@dec_exponent + @precision)
        when SCIENTIFIC
          exp = check_exponent(@precision + 1)
          digits = apply_precision(@precision + 1)
        when GENERAL
          exp = check_exponent(@precision)
          digits = apply_precision(@precision)
          # adjust precision to be the number of digits to right of decimal
          # the real exponent to be output is actually exp - 1, not exp
          if (exp - 1 < -4 || exp - 1 >= @precision)
            @form = Form::SCIENTIFIC
            ((@precision -= 1) + 1)
          else
            @form = Form::DECIMAL_FLOAT
            @precision = @precision - exp
          end
        else
          raise AssertError if not (false)
        end
        @dec_exponent_rounded = exp
        if (exp > 0 && (((@form).equal?(Form::COMPATIBLE) && (exp < 8)) || ((@form).equal?(Form::DECIMAL_FLOAT))))
          # print digits.digits.
          char_length = Math.min(@n_digits, exp)
          System.arraycopy(digits, 0, result, i, char_length)
          i += char_length
          if (char_length < exp)
            char_length = exp - char_length
            nz = 0
            while nz < char_length
              result[((i += 1) - 1)] = Character.new(?0.ord)
              ((nz += 1) - 1)
            end
            # Do not append ".0" for formatted floats since the user
            # may request that it be omitted. It is added as necessary
            # by the Formatter.
            if ((@form).equal?(Form::COMPATIBLE))
              result[((i += 1) - 1)] = Character.new(?..ord)
              result[((i += 1) - 1)] = Character.new(?0.ord)
            end
          else
            # Do not append ".0" for formatted floats since the user
            # may request that it be omitted. It is added as necessary
            # by the Formatter.
            if ((@form).equal?(Form::COMPATIBLE))
              result[((i += 1) - 1)] = Character.new(?..ord)
              if (char_length < @n_digits)
                t = Math.min(@n_digits - char_length, @precision)
                System.arraycopy(digits, char_length, result, i, t)
                i += t
              else
                result[((i += 1) - 1)] = Character.new(?0.ord)
              end
            else
              t_ = Math.min(@n_digits - char_length, @precision)
              if (t_ > 0)
                result[((i += 1) - 1)] = Character.new(?..ord)
                System.arraycopy(digits, char_length, result, i, t_)
                i += t_
              end
            end
          end
        else
          if (exp <= 0 && (((@form).equal?(Form::COMPATIBLE) && exp > -3) || ((@form).equal?(Form::DECIMAL_FLOAT))))
            # print 0.0* digits
            result[((i += 1) - 1)] = Character.new(?0.ord)
            if (!(exp).equal?(0))
              # write '0' s before the significant digits
              t__ = Math.min(-exp, @precision)
              if (t__ > 0)
                result[((i += 1) - 1)] = Character.new(?..ord)
                nz_ = 0
                while nz_ < t__
                  result[((i += 1) - 1)] = Character.new(?0.ord)
                  ((nz_ += 1) - 1)
                end
              end
            end
            t___ = Math.min(digits.attr_length, @precision + exp)
            if (t___ > 0)
              if ((i).equal?(1))
                result[((i += 1) - 1)] = Character.new(?..ord)
              end
              # copy only when significant digits are within the precision
              System.arraycopy(digits, 0, result, i, t___)
              i += t___
            end
          else
            result[((i += 1) - 1)] = digits[0]
            if ((@form).equal?(Form::COMPATIBLE))
              result[((i += 1) - 1)] = Character.new(?..ord)
              if (@n_digits > 1)
                System.arraycopy(digits, 1, result, i, @n_digits - 1)
                i += @n_digits - 1
              else
                result[((i += 1) - 1)] = Character.new(?0.ord)
              end
              result[((i += 1) - 1)] = Character.new(?E.ord)
            else
              if (@n_digits > 1)
                t____ = Math.min(@n_digits - 1, @precision)
                if (t____ > 0)
                  result[((i += 1) - 1)] = Character.new(?..ord)
                  System.arraycopy(digits, 1, result, i, t____)
                  i += t____
                end
              end
              result[((i += 1) - 1)] = Character.new(?e.ord)
            end
            e = 0
            if (exp <= 0)
              result[((i += 1) - 1)] = Character.new(?-.ord)
              e = -exp + 1
            else
              if (!(@form).equal?(Form::COMPATIBLE))
                result[((i += 1) - 1)] = Character.new(?+.ord)
              end
              e = exp - 1
            end
            # decExponent has 1, 2, or 3, digits
            if (e <= 9)
              if (!(@form).equal?(Form::COMPATIBLE))
                result[((i += 1) - 1)] = Character.new(?0.ord)
              end
              result[((i += 1) - 1)] = RJava.cast_to_char((e + Character.new(?0.ord)))
            else
              if (e <= 99)
                result[((i += 1) - 1)] = RJava.cast_to_char((e / 10 + Character.new(?0.ord)))
                result[((i += 1) - 1)] = RJava.cast_to_char((e % 10 + Character.new(?0.ord)))
              else
                result[((i += 1) - 1)] = RJava.cast_to_char((e / 100 + Character.new(?0.ord)))
                e %= 100
                result[((i += 1) - 1)] = RJava.cast_to_char((e / 10 + Character.new(?0.ord)))
                result[((i += 1) - 1)] = RJava.cast_to_char((e % 10 + Character.new(?0.ord)))
              end
            end
          end
        end
      end
      return i
    end
    
    class_module.module_eval {
      
      def per_thread_buffer
        defined?(@@per_thread_buffer) ? @@per_thread_buffer : @@per_thread_buffer= # Per-thread buffer for string/stringbuffer conversion
        Class.new(ThreadLocal.class == Class ? ThreadLocal : Object) do
          extend LocalClass
          include_class_members FormattedFloatingDecimal
          include ThreadLocal if ThreadLocal.class == Module
          
          typesig { [] }
          define_method :initial_value do
            synchronized(self) do
              return CharArray.new(26)
            end
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      alias_method :attr_per_thread_buffer, :per_thread_buffer
      
      def per_thread_buffer=(value)
        @@per_thread_buffer = value
      end
      alias_method :attr_per_thread_buffer=, :per_thread_buffer=
    }
    
    typesig { [Appendable] }
    # This method should only ever be called if this object is constructed
    # without Form.DECIMAL_FLOAT because the perThreadBuffer is not large
    # enough to handle floating-point numbers of large precision.
    def append_to(buf)
      result = (self.attr_per_thread_buffer.get)
      i = get_chars(result)
      if (buf.is_a?(StringBuilder))
        (buf).append(result, 0, i)
      else
        if (buf.is_a?(StringBuffer))
          (buf).append(result, 0, i)
        else
          raise AssertError if not (false)
        end
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      def read_java_format_string(in_)
        is_negative = false
        sign_seen = false
        dec_exp = 0
        c = 0
        catch(:break_parse_number) do
          begin
            in_ = (in_.trim).to_s # don't fool around with white space.
            # throws NullPointerException if null
            l = in_.length
            if ((l).equal?(0))
              raise NumberFormatException.new("empty String")
            end
            i = 0
            case (c = in_.char_at(i))
            # FALLTHROUGH
            when Character.new(?-.ord)
              is_negative = true
              ((i += 1) - 1)
              sign_seen = true
            when Character.new(?+.ord)
              ((i += 1) - 1)
              sign_seen = true
            end
            # Check for NaN and Infinity strings
            c = in_.char_at(i)
            if ((c).equal?(Character.new(?N.ord)) || (c).equal?(Character.new(?I.ord)))
              # possible NaN or infinity
              potential_na_n = false
              target_chars = nil # char arrary of "NaN" or "Infinity"
              if ((c).equal?(Character.new(?N.ord)))
                target_chars = NotANumber
                potential_na_n = true
              else
                target_chars = Infinity
              end
              # compare Input string to "NaN" or "Infinity"
              j = 0
              while (i < l && j < target_chars.attr_length)
                if ((in_.char_at(i)).equal?(target_chars[j]))
                  ((i += 1) - 1)
                  ((j += 1) - 1)
                else
                  # something is amiss, throw exception
                  throw :break_parse_number, :thrown
                end
              end
              # For the candidate string to be a NaN or infinity,
              # all characters in input string and target char[]
              # must be matched ==> j must equal targetChars.length
              # and i must equal l
              if (((j).equal?(target_chars.attr_length)) && ((i).equal?(l)))
                # return NaN or infinity
                # NaN has no sign
                return (potential_na_n ? FormattedFloatingDecimal.new(Double::NaN) : FormattedFloatingDecimal.new(is_negative ? Double::NEGATIVE_INFINITY : Double::POSITIVE_INFINITY))
              else
                # something went wrong, throw exception
                break
              end
            else
              if ((c).equal?(Character.new(?0.ord)))
                # check for hexadecimal floating-point number
                if (l > i + 1)
                  ch = in_.char_at(i + 1)
                  if ((ch).equal?(Character.new(?x.ord)) || (ch).equal?(Character.new(?X.ord)))
                    # possible hex string
                    return parse_hex_string(in_)
                  end
                end
              end
            end # look for and process decimal floating-point string
            digits = CharArray.new(l)
            n_digits = 0
            dec_seen = false
            dec_pt = 0
            n_lead_zero = 0
            n_trail_zero = 0
            while (i < l)
              case (c = in_.char_at(i))
              # out of switch.
              # out of switch.
              # out of switch.
              when Character.new(?0.ord)
                if (n_digits > 0)
                  n_trail_zero += 1
                else
                  n_lead_zero += 1
                end
              when Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord)
                while (n_trail_zero > 0)
                  digits[((n_digits += 1) - 1)] = Character.new(?0.ord)
                  n_trail_zero -= 1
                end
                digits[((n_digits += 1) - 1)] = c
              when Character.new(?..ord)
                if (dec_seen)
                  # already saw one ., this is the 2nd.
                  raise NumberFormatException.new("multiple points")
                end
                dec_pt = i
                if (sign_seen)
                  dec_pt -= 1
                end
                dec_seen = true
              else
                break
              end
              ((i += 1) - 1)
            end
            # 
            # At this point, we've scanned all the digits and decimal
            # point we're going to see. Trim off leading and trailing
            # zeros, which will just confuse us later, and adjust
            # our initial decimal exponent accordingly.
            # To review:
            # we have seen i total characters.
            # nLeadZero of them were zeros before any other digits.
            # nTrailZero of them were zeros after any other digits.
            # if ( decSeen ), then a . was seen after decPt characters
            # ( including leading zeros which have been discarded )
            # nDigits characters were neither lead nor trailing
            # zeros, nor point
            # 
            # 
            # special hack: if we saw no non-zero digits, then the
            # answer is zero!
            # Unfortunately, we feel honor-bound to keep parsing!
            if ((n_digits).equal?(0))
              digits = Zero
              n_digits = 1
              if ((n_lead_zero).equal?(0))
                # we saw NO DIGITS AT ALL,
                # not even a crummy 0!
                # this is not allowed.
                break # go throw exception
              end
            end
            # Our initial exponent is decPt, adjusted by the number of
            # discarded zeros. Or, if there was no decPt,
            # then its just nDigits adjusted by discarded trailing zeros.
            if (dec_seen)
              dec_exp = dec_pt - n_lead_zero
            else
              dec_exp = n_digits + n_trail_zero
            end
            # 
            # Look for 'e' or 'E' and an optionally signed integer.
            if ((i < l) && ((((c = in_.char_at(i))).equal?(Character.new(?e.ord))) || ((c).equal?(Character.new(?E.ord)))))
              exp_sign = 1
              exp_val = 0
              really_big = JavaInteger::MAX_VALUE / 10
              exp_overflow = false
              case (in_.char_at((i += 1)))
              # FALLTHROUGH
              when Character.new(?-.ord)
                exp_sign = -1
                ((i += 1) - 1)
              when Character.new(?+.ord)
                ((i += 1) - 1)
              end
              exp_at = i
              while (i < l)
                if (exp_val >= really_big)
                  # the next character will cause integer
                  # overflow.
                  exp_overflow = true
                end
                case (c = in_.char_at(((i += 1) - 1)))
                when Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord)
                  exp_val = exp_val * 10 + (RJava.cast_to_int(c) - RJava.cast_to_int(Character.new(?0.ord)))
                  next
                  ((i -= 1) + 1) # back up.
                  break
                else
                  ((i -= 1) + 1) # back up.
                  break
                end # stop parsing exponent.
              end
              exp_limit = BigDecimalExponent + n_digits + n_trail_zero
              if (exp_overflow || (exp_val > exp_limit))
                # 
                # The intent here is to end up with
                # infinity or zero, as appropriate.
                # The reason for yielding such a small decExponent,
                # rather than something intuitive such as
                # expSign*Integer.MAX_VALUE, is that this value
                # is subject to further manipulation in
                # doubleValue() and floatValue(), and I don't want
                # it to be able to cause overflow there!
                # (The only way we can get into trouble here is for
                # really outrageous nDigits+nTrailZero, such as 2 billion. )
                dec_exp = exp_sign * exp_limit
              else
                # this should not overflow, since we tested
                # for expVal > (MAX+N), where N >= abs(decExp)
                dec_exp = dec_exp + exp_sign * exp_val
              end
              # if we saw something not a digit ( or end of string )
              # after the [Ee][+-], without seeing any digits at all
              # this is certainly an error. If we saw some digits,
              # but then some trailing garbage, that might be ok.
              # so we just fall through in that case.
              # HUMBUG
              if ((i).equal?(exp_at))
                break
              end # certainly bad
            end
            # 
            # We parsed everything we could.
            # If there are leftovers, then this is not good input!
            if (i < l && ((!(i).equal?(l - 1)) || (!(in_.char_at(i)).equal?(Character.new(?f.ord)) && !(in_.char_at(i)).equal?(Character.new(?F.ord)) && !(in_.char_at(i)).equal?(Character.new(?d.ord)) && !(in_.char_at(i)).equal?(Character.new(?D.ord)))))
              break # go throw exception
            end
            return FormattedFloatingDecimal.new(is_negative, dec_exp, digits, n_digits, false, JavaInteger::MAX_VALUE, Form::COMPATIBLE)
          rescue StringIndexOutOfBoundsException => e
          end
        end
        raise NumberFormatException.new("For input string: \"" + in_ + "\"")
      end
    }
    
    typesig { [] }
    # 
    # Take a FormattedFloatingDecimal, which we presumably just scanned in,
    # and find out what its value is, as a double.
    # 
    # AS A SIDE EFFECT, SET roundDir TO INDICATE PREFERRED
    # ROUNDING DIRECTION in case the result is really destined
    # for a single-precision float.
    def double_value
      k_digits = Math.min(@n_digits, MaxDecimalDigits + 1)
      l_value = 0
      d_value = 0.0
      r_value = 0.0
      t_value = 0.0
      # First, check for NaN and Infinity values
      if ((@digits).equal?(Infinity) || (@digits).equal?(NotANumber))
        if ((@digits).equal?(NotANumber))
          return Double::NaN
        else
          return (@is_negative ? Double::NEGATIVE_INFINITY : Double::POSITIVE_INFINITY)
        end
      else
        if (@must_set_round_dir)
          @round_dir = 0
        end
        # 
        # convert the lead kDigits to a long integer.
        # 
        # (special performance hack: start to do it using int)
        i_value = RJava.cast_to_int(@digits[0]) - RJava.cast_to_int(Character.new(?0.ord))
        i_digits = Math.min(k_digits, IntDecimalDigits)
        i = 1
        while i < i_digits
          i_value = i_value * 10 + RJava.cast_to_int(@digits[i]) - RJava.cast_to_int(Character.new(?0.ord))
          ((i += 1) - 1)
        end
        l_value = i_value
        i_ = i_digits
        while i_ < k_digits
          l_value = l_value * 10 + (RJava.cast_to_int(@digits[i_]) - RJava.cast_to_int(Character.new(?0.ord)))
          ((i_ += 1) - 1)
        end
        d_value = (l_value).to_f
        exp = @dec_exponent - k_digits
        # 
        # lValue now contains a long integer with the value of
        # the first kDigits digits of the number.
        # dValue contains the (double) of the same.
        if (@n_digits <= MaxDecimalDigits)
          # 
          # possibly an easy case.
          # We know that the digits can be represented
          # exactly. And if the exponent isn't too outrageous,
          # the whole thing can be done with one operation,
          # thus one rounding error.
          # Note that all our constructors trim all leading and
          # trailing zeros, so simple values (including zero)
          # will always end up here
          if ((exp).equal?(0) || (d_value).equal?(0.0))
            return (@is_negative) ? -d_value : d_value
             # small floating integer
          else
            if (exp >= 0)
              if (exp <= MaxSmallTen)
                # 
                # Can get the answer with one operation,
                # thus one roundoff.
                r_value = d_value * Small10pow[exp]
                if (@must_set_round_dir)
                  t_value = r_value / Small10pow[exp]
                  @round_dir = ((t_value).equal?(d_value)) ? 0 : (t_value < d_value) ? 1 : -1
                end
                return (@is_negative) ? -r_value : r_value
              end
              slop = MaxDecimalDigits - k_digits
              if (exp <= MaxSmallTen + slop)
                # 
                # We can multiply dValue by 10^(slop)
                # and it is still "small" and exact.
                # Then we can multiply by 10^(exp-slop)
                # with one rounding.
                d_value *= Small10pow[slop]
                r_value = d_value * Small10pow[exp - slop]
                if (@must_set_round_dir)
                  t_value = r_value / Small10pow[exp - slop]
                  @round_dir = ((t_value).equal?(d_value)) ? 0 : (t_value < d_value) ? 1 : -1
                end
                return (@is_negative) ? -r_value : r_value
              end
              # 
              # Else we have a hard case with a positive exp.
            else
              if (exp >= -MaxSmallTen)
                # 
                # Can get the answer in one division.
                r_value = d_value / Small10pow[-exp]
                t_value = r_value * Small10pow[-exp]
                if (@must_set_round_dir)
                  @round_dir = ((t_value).equal?(d_value)) ? 0 : (t_value < d_value) ? 1 : -1
                end
                return (@is_negative) ? -r_value : r_value
              end
              # 
              # Else we have a hard case with a negative exp.
            end
          end
        end
        # 
        # Harder cases:
        # The sum of digits plus exponent is greater than
        # what we think we can do with one error.
        # 
        # Start by approximating the right answer by,
        # naively, scaling by powers of 10.
        if (exp > 0)
          if (@dec_exponent > MaxDecimalExponent + 1)
            # 
            # Lets face it. This is going to be
            # Infinity. Cut to the chase.
            return (@is_negative) ? Double::NEGATIVE_INFINITY : Double::POSITIVE_INFINITY
          end
          if (!((exp & 15)).equal?(0))
            d_value *= Small10pow[exp & 15]
          end
          if (!((exp >>= 4)).equal?(0))
            j = 0
            j = 0
            while exp > 1
              if (!((exp & 1)).equal?(0))
                d_value *= Big10pow[j]
              end
              ((j += 1) - 1)
              exp >>= 1
            end
            # 
            # The reason for the weird exp > 1 condition
            # in the above loop was so that the last multiply
            # would get unrolled. We handle it here.
            # It could overflow.
            t = d_value * Big10pow[j]
            if (Double.is_infinite(t))
              # 
              # It did overflow.
              # Look more closely at the result.
              # If the exponent is just one too large,
              # then use the maximum finite as our estimate
              # value. Else call the result infinity
              # and punt it.
              # ( I presume this could happen because
              # rounding forces the result here to be
              # an ULP or two larger than
              # Double.MAX_VALUE ).
              t = d_value / 2.0
              t *= Big10pow[j]
              if (Double.is_infinite(t))
                return (@is_negative) ? Double::NEGATIVE_INFINITY : Double::POSITIVE_INFINITY
              end
              t = Double::MAX_VALUE
            end
            d_value = t
          end
        else
          if (exp < 0)
            exp = -exp
            if (@dec_exponent < MinDecimalExponent - 1)
              # 
              # Lets face it. This is going to be
              # zero. Cut to the chase.
              return (@is_negative) ? -0.0 : 0.0
            end
            if (!((exp & 15)).equal?(0))
              d_value /= Small10pow[exp & 15]
            end
            if (!((exp >>= 4)).equal?(0))
              j_ = 0
              j_ = 0
              while exp > 1
                if (!((exp & 1)).equal?(0))
                  d_value *= Tiny10pow[j_]
                end
                ((j_ += 1) - 1)
                exp >>= 1
              end
              # 
              # The reason for the weird exp > 1 condition
              # in the above loop was so that the last multiply
              # would get unrolled. We handle it here.
              # It could underflow.
              t_ = d_value * Tiny10pow[j_]
              if ((t_).equal?(0.0))
                # 
                # It did underflow.
                # Look more closely at the result.
                # If the exponent is just one too small,
                # then use the minimum finite as our estimate
                # value. Else call the result 0.0
                # and punt it.
                # ( I presume this could happen because
                # rounding forces the result here to be
                # an ULP or two less than
                # Double.MIN_VALUE ).
                t_ = d_value * 2.0
                t_ *= Tiny10pow[j_]
                if ((t_).equal?(0.0))
                  return (@is_negative) ? -0.0 : 0.0
                end
                t_ = Double::MIN_VALUE
              end
              d_value = t_
            end
          end
        end
        # 
        # dValue is now approximately the result.
        # The hard part is adjusting it, by comparison
        # with FDBigInt arithmetic.
        # Formulate the EXACT big-number result as
        # bigD0 * 10^exp
        big_d0 = FDBigInt.new(l_value, @digits, k_digits, @n_digits)
        exp = @dec_exponent - @n_digits
        while (true)
          # AS A SIDE EFFECT, THIS METHOD WILL SET THE INSTANCE VARIABLES
          # bigIntExp and bigIntNBits
          big_b = double_to_big_int(d_value)
          # 
          # Scale bigD, bigB appropriately for
          # big-integer operations.
          # Naively, we multipy by powers of ten
          # and powers of two. What we actually do
          # is keep track of the powers of 5 and
          # powers of 2 we would use, then factor out
          # common divisors before doing the work.
          b2 = 0
          b5 = 0 # powers of 2, 5 in bigB
          d2 = 0
          d5 = 0 # powers of 2, 5 in bigD
          ulp2 = 0 # powers of 2 in halfUlp.
          if (exp >= 0)
            b2 = b5 = 0
            d2 = d5 = exp
          else
            b2 = b5 = -exp
            d2 = d5 = 0
          end
          if (@big_int_exp >= 0)
            b2 += @big_int_exp
          else
            d2 -= @big_int_exp
          end
          ulp2 = b2
          # shift bigB and bigD left by a number s. t.
          # halfUlp is still an integer.
          hulpbias = 0
          if (@big_int_exp + @big_int_nbits <= -ExpBias + 1)
            # This is going to be a denormalized number
            # (if not actually zero).
            # half an ULP is at 2^-(expBias+expShift+1)
            hulpbias = @big_int_exp + ExpBias + ExpShift
          else
            hulpbias = ExpShift + 2 - @big_int_nbits
          end
          b2 += hulpbias
          d2 += hulpbias
          # if there are common factors of 2, we might just as well
          # factor them out, as they add nothing useful.
          common2 = Math.min(b2, Math.min(d2, ulp2))
          b2 -= common2
          d2 -= common2
          ulp2 -= common2
          # do multiplications by powers of 5 and 2
          big_b = mult_pow52(big_b, b5, b2)
          big_d = mult_pow52(FDBigInt.new(big_d0), d5, d2)
          # 
          # to recap:
          # bigB is the scaled-big-int version of our floating-point
          # candidate.
          # bigD is the scaled-big-int version of the exact value
          # as we understand it.
          # halfUlp is 1/2 an ulp of bigB, except for special cases
          # of exact powers of 2
          # 
          # the plan is to compare bigB with bigD, and if the difference
          # is less than halfUlp, then we're satisfied. Otherwise,
          # use the ratio of difference to halfUlp to calculate a fudge
          # factor to add to the floating value, then go 'round again.
          diff = nil
          cmp_result = 0
          overvalue = false
          if ((cmp_result = big_b.cmp(big_d)) > 0)
            overvalue = true # our candidate is too big.
            diff = big_b.sub(big_d)
            if (((@big_int_nbits).equal?(1)) && (@big_int_exp > -ExpBias))
              # candidate is a normalized exact power of 2 and
              # is too big. We will be subtracting.
              # For our purposes, ulp is the ulp of the
              # next smaller range.
              ulp2 -= 1
              if (ulp2 < 0)
                # rats. Cannot de-scale ulp this far.
                # must scale diff in other direction.
                ulp2 = 0
                diff.lshift_me(1)
              end
            end
          else
            if (cmp_result < 0)
              overvalue = false # our candidate is too small.
              diff = big_d.sub(big_b)
            else
              # the candidate is exactly right!
              # this happens with surprising fequency
              break
            end
          end
          half_ulp = construct_pow52(b5, ulp2)
          if ((cmp_result = diff.cmp(half_ulp)) < 0)
            # difference is small.
            # this is close enough
            if (@must_set_round_dir)
              @round_dir = overvalue ? -1 : 1
            end
            break
          else
            if ((cmp_result).equal?(0))
              # difference is exactly half an ULP
              # round to some other value maybe, then finish
              d_value += 0.5 * ulp(d_value, overvalue)
              # should check for bigIntNBits == 1 here??
              if (@must_set_round_dir)
                @round_dir = overvalue ? -1 : 1
              end
              break
            else
              # difference is non-trivial.
              # could scale addend by ratio of difference to
              # halfUlp here, if we bothered to compute that difference.
              # Most of the time ( I hope ) it is about 1 anyway.
              d_value += ulp(d_value, overvalue)
              if ((d_value).equal?(0.0) || (d_value).equal?(Double::POSITIVE_INFINITY))
                break
              end # oops. Fell off end of range.
              next # try again.
            end
          end
        end
        return (@is_negative) ? -d_value : d_value
      end
    end
    
    typesig { [] }
    # 
    # Take a FormattedFloatingDecimal, which we presumably just scanned in,
    # and find out what its value is, as a float.
    # This is distinct from doubleValue() to avoid the extremely
    # unlikely case of a double rounding error, wherein the converstion
    # to double has one rounding error, and the conversion of that double
    # to a float has another rounding error, IN THE WRONG DIRECTION,
    # ( because of the preference to a zero low-order bit ).
    def float_value
      k_digits = Math.min(@n_digits, SingleMaxDecimalDigits + 1)
      i_value = 0
      f_value = 0.0
      # First, check for NaN and Infinity values
      if ((@digits).equal?(Infinity) || (@digits).equal?(NotANumber))
        if ((@digits).equal?(NotANumber))
          return Float::NaN
        else
          return (@is_negative ? Float::NEGATIVE_INFINITY : Float::POSITIVE_INFINITY)
        end
      else
        # 
        # convert the lead kDigits to an integer.
        i_value = RJava.cast_to_int(@digits[0]) - RJava.cast_to_int(Character.new(?0.ord))
        i = 1
        while i < k_digits
          i_value = i_value * 10 + RJava.cast_to_int(@digits[i]) - RJava.cast_to_int(Character.new(?0.ord))
          ((i += 1) - 1)
        end
        f_value = (i_value).to_f
        exp = @dec_exponent - k_digits
        # 
        # iValue now contains an integer with the value of
        # the first kDigits digits of the number.
        # fValue contains the (float) of the same.
        if (@n_digits <= SingleMaxDecimalDigits)
          # 
          # possibly an easy case.
          # We know that the digits can be represented
          # exactly. And if the exponent isn't too outrageous,
          # the whole thing can be done with one operation,
          # thus one rounding error.
          # Note that all our constructors trim all leading and
          # trailing zeros, so simple values (including zero)
          # will always end up here.
          if ((exp).equal?(0) || (f_value).equal?(0.0))
            return (@is_negative) ? -f_value : f_value
             # small floating integer
          else
            if (exp >= 0)
              if (exp <= SingleMaxSmallTen)
                # 
                # Can get the answer with one operation,
                # thus one roundoff.
                f_value *= SingleSmall10pow[exp]
                return (@is_negative) ? -f_value : f_value
              end
              slop = SingleMaxDecimalDigits - k_digits
              if (exp <= SingleMaxSmallTen + slop)
                # 
                # We can multiply dValue by 10^(slop)
                # and it is still "small" and exact.
                # Then we can multiply by 10^(exp-slop)
                # with one rounding.
                f_value *= SingleSmall10pow[slop]
                f_value *= SingleSmall10pow[exp - slop]
                return (@is_negative) ? -f_value : f_value
              end
              # 
              # Else we have a hard case with a positive exp.
            else
              if (exp >= -SingleMaxSmallTen)
                # 
                # Can get the answer in one division.
                f_value /= SingleSmall10pow[-exp]
                return (@is_negative) ? -f_value : f_value
              end
              # 
              # Else we have a hard case with a negative exp.
            end
          end
        else
          if ((@dec_exponent >= @n_digits) && (@n_digits + @dec_exponent <= MaxDecimalDigits))
            # 
            # In double-precision, this is an exact floating integer.
            # So we can compute to double, then shorten to float
            # with one round, and get the right answer.
            # 
            # First, finish accumulating digits.
            # Then convert that integer to a double, multiply
            # by the appropriate power of ten, and convert to float.
            l_value = i_value
            i_ = k_digits
            while i_ < @n_digits
              l_value = l_value * 10 + (RJava.cast_to_int(@digits[i_]) - RJava.cast_to_int(Character.new(?0.ord)))
              ((i_ += 1) - 1)
            end
            d_value = (l_value).to_f
            exp = @dec_exponent - @n_digits
            d_value *= Small10pow[exp]
            f_value = (d_value).to_f
            return (@is_negative) ? -f_value : f_value
          end
        end
        # 
        # Harder cases:
        # The sum of digits plus exponent is greater than
        # what we think we can do with one error.
        # 
        # Start by weeding out obviously out-of-range
        # results, then convert to double and go to
        # common hard-case code.
        if (@dec_exponent > SingleMaxDecimalExponent + 1)
          # 
          # Lets face it. This is going to be
          # Infinity. Cut to the chase.
          return (@is_negative) ? Float::NEGATIVE_INFINITY : Float::POSITIVE_INFINITY
        else
          if (@dec_exponent < SingleMinDecimalExponent - 1)
            # 
            # Lets face it. This is going to be
            # zero. Cut to the chase.
            return (@is_negative) ? -0.0 : 0.0
          end
        end
        # 
        # Here, we do 'way too much work, but throwing away
        # our partial results, and going and doing the whole
        # thing as double, then throwing away half the bits that computes
        # when we convert back to float.
        # 
        # The alternative is to reproduce the whole multiple-precision
        # algorythm for float precision, or to try to parameterize it
        # for common usage. The former will take about 400 lines of code,
        # and the latter I tried without success. Thus the semi-hack
        # answer here.
        @must_set_round_dir = !@from_hex
        d_value_ = double_value
        return sticky_round(d_value_)
      end
    end
    
    class_module.module_eval {
      # 
      # All the positive powers of 10 that can be
      # represented exactly in double/float.
      const_set_lazy(:Small10pow) { Array.typed(::Java::Double).new([1.0e0, 1.0e1, 1.0e2, 1.0e3, 1.0e4, 1.0e5, 1.0e6, 1.0e7, 1.0e8, 1.0e9, 1.0e10, 1.0e11, 1.0e12, 1.0e13, 1.0e14, 1.0e15, 1.0e16, 1.0e17, 1.0e18, 1.0e19, 1.0e20, 1.0e21, 1.0e22]) }
      const_attr_reader  :Small10pow
      
      const_set_lazy(:SingleSmall10pow) { Array.typed(::Java::Float).new([1.0e0, 1.0e1, 1.0e2, 1.0e3, 1.0e4, 1.0e5, 1.0e6, 1.0e7, 1.0e8, 1.0e9, 1.0e10]) }
      const_attr_reader  :SingleSmall10pow
      
      const_set_lazy(:Big10pow) { Array.typed(::Java::Double).new([1e16, 1e32, 1e64, 1e128, 1e256]) }
      const_attr_reader  :Big10pow
      
      const_set_lazy(:Tiny10pow) { Array.typed(::Java::Double).new([1e-16, 1e-32, 1e-64, 1e-128, 1e-256]) }
      const_attr_reader  :Tiny10pow
      
      const_set_lazy(:MaxSmallTen) { Small10pow.attr_length - 1 }
      const_attr_reader  :MaxSmallTen
      
      const_set_lazy(:SingleMaxSmallTen) { SingleSmall10pow.attr_length - 1 }
      const_attr_reader  :SingleMaxSmallTen
      
      const_set_lazy(:Small5pow) { Array.typed(::Java::Int).new([1, 5, 5 * 5, 5 * 5 * 5, 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5]) }
      const_attr_reader  :Small5pow
      
      const_set_lazy(:Long5pow) { Array.typed(::Java::Long).new([1, 5, 5 * 5, 5 * 5 * 5, 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5 * 5, ]) }
      const_attr_reader  :Long5pow
      
      # approximately ceil( log2( long5pow[i] ) )
      const_set_lazy(:N5bits) { Array.typed(::Java::Int).new([0, 3, 5, 7, 10, 12, 14, 17, 19, 21, 24, 26, 28, 31, 33, 35, 38, 40, 42, 45, 47, 49, 52, 54, 56, 59, 61, ]) }
      const_attr_reader  :N5bits
      
      const_set_lazy(:Infinity) { Array.typed(::Java::Char).new([Character.new(?I.ord), Character.new(?n.ord), Character.new(?f.ord), Character.new(?i.ord), Character.new(?n.ord), Character.new(?i.ord), Character.new(?t.ord), Character.new(?y.ord)]) }
      const_attr_reader  :Infinity
      
      const_set_lazy(:NotANumber) { Array.typed(::Java::Char).new([Character.new(?N.ord), Character.new(?a.ord), Character.new(?N.ord)]) }
      const_attr_reader  :NotANumber
      
      const_set_lazy(:Zero) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord), Character.new(?0.ord)]) }
      const_attr_reader  :Zero
      
      # 
      # Grammar is compatible with hexadecimal floating-point constants
      # described in section 6.4.4.2 of the C99 specification.
      # 
      # 1           234                   56                7                   8      9
      
      def hex_float_pattern
        defined?(@@hex_float_pattern) ? @@hex_float_pattern : @@hex_float_pattern= Pattern.compile("([-+])?0[xX](((\\p{XDigit}+)\\.?)|((\\p{XDigit}*)\\.(\\p{XDigit}+)))[pP]([-+])?(\\p{Digit}+)[fFdD]?")
      end
      alias_method :attr_hex_float_pattern, :hex_float_pattern
      
      def hex_float_pattern=(value)
        @@hex_float_pattern = value
      end
      alias_method :attr_hex_float_pattern=, :hex_float_pattern=
      
      typesig { [String] }
      # 
      # Convert string s to a suitable floating decimal; uses the
      # double constructor and set the roundDir variable appropriately
      # in case the value is later converted to a float.
      def parse_hex_string(s)
        # Verify string is a member of the hexadecimal floating-point
        # string language.
        m = self.attr_hex_float_pattern.matcher(s)
        valid_input = m.matches
        if (!valid_input)
          # Input does not match pattern
          raise NumberFormatException.new("For input string: \"" + s + "\"")
        else
          # validInput
          # 
          # We must isolate the sign, significand, and exponent
          # fields.  The sign value is straightforward.  Since
          # floating-point numbers are stored with a normalized
          # representation, the significand and exponent are
          # interrelated.
          # 
          # After extracting the sign, we normalized the
          # significand as a hexadecimal value, calculating an
          # exponent adjust for any shifts made during
          # normalization.  If the significand is zero, the
          # exponent doesn't need to be examined since the output
          # will be zero.
          # 
          # Next the exponent in the input string is extracted.
          # Afterwards, the significand is normalized as a *binary*
          # value and the input value's normalized exponent can be
          # computed.  The significand bits are copied into a
          # double significand; if the string has more logical bits
          # than can fit in a double, the extra bits affect the
          # round and sticky bits which are used to round the final
          # value.
          # 
          # Extract significand sign
          group1 = m.group(1)
          sign = (((group1).nil?) || (group1 == "+")) ? 1.0 : -1.0
          # Extract Significand magnitude
          # 
          # Based on the form of the significand, calculate how the
          # binary exponent needs to be adjusted to create a
          # normalized *hexadecimal* floating-point number; that
          # is, a number where there is one nonzero hex digit to
          # the left of the (hexa)decimal point.  Since we are
          # adjusting a binary, not hexadecimal exponent, the
          # exponent is adjusted by a multiple of 4.
          # 
          # There are a number of significand scenarios to consider;
          # letters are used in indicate nonzero digits:
          # 
          # 1. 000xxxx       =>      x.xxx   normalized
          # increase exponent by (number of x's - 1)*4
          # 
          # 2. 000xxx.yyyy =>        x.xxyyyy        normalized
          # increase exponent by (number of x's - 1)*4
          # 
          # 3. .000yyy  =>   y.yy    normalized
          # decrease exponent by (number of zeros + 1)*4
          # 
          # 4. 000.00000yyy => y.yy normalized
          # decrease exponent by (number of zeros to right of point + 1)*4
          # 
          # If the significand is exactly zero, return a properly
          # signed zero.
          significand_string = nil
          signif_length = 0
          exponent_adjust = 0
          left_digits = 0 # number of meaningful digits to
          # left of "decimal" point
          # (leading zeros stripped)
          right_digits = 0 # number of digits to right of
          # "decimal" point; leading zeros
          # must always be accounted for
          # 
          # The significand is made up of either
          # 
          # 1. group 4 entirely (integer portion only)
          # 
          # OR
          # 
          # 2. the fractional portion from group 7 plus any
          # (optional) integer portions from group 6.
          group4 = nil
          if (!((group4 = (m.group(4)).to_s)).nil?)
            # Integer-only significand
            # Leading zeros never matter on the integer portion
            significand_string = (strip_leading_zeros(group4)).to_s
            left_digits = significand_string.length
          else
            # Group 6 is the optional integer; leading zeros
            # never matter on the integer portion
            group6 = strip_leading_zeros(m.group(6))
            left_digits = group6.length
            # fraction
            group7 = m.group(7)
            right_digits = group7.length
            # Turn "integer.fraction" into "integer"+"fraction"
            # is the null
            # check necessary?
            significand_string = ((((group6).nil?) ? "" : group6)).to_s + group7
          end
          significand_string = (strip_leading_zeros(significand_string)).to_s
          signif_length = significand_string.length
          # 
          # Adjust exponent as described above
          if (left_digits >= 1)
            # Cases 1 and 2
            exponent_adjust = 4 * (left_digits - 1)
          else
            # Cases 3 and 4
            exponent_adjust = -4 * (right_digits - signif_length + 1)
          end
          # If the significand is zero, the exponent doesn't
          # matter; return a properly signed zero.
          if ((signif_length).equal?(0))
            # Only zeros in input
            return FormattedFloatingDecimal.new(sign * 0.0)
          end
          # Extract Exponent
          # 
          # Use an int to read in the exponent value; this should
          # provide more than sufficient range for non-contrived
          # inputs.  If reading the exponent in as an int does
          # overflow, examine the sign of the exponent and
          # significand to determine what to do.
          group8 = m.group(8)
          positive_exponent = ((group8).nil?) || (group8 == "+")
          unsigned_raw_exponent = 0
          begin
            unsigned_raw_exponent = JavaInteger.parse_int(m.group(9))
          rescue NumberFormatException => e
            # At this point, we know the exponent is
            # syntactically well-formed as a sequence of
            # digits.  Therefore, if an NumberFormatException
            # is thrown, it must be due to overflowing int's
            # range.  Also, at this point, we have already
            # checked for a zero significand.  Thus the signs
            # of the exponent and significand determine the
            # final result:
            # 
            # significand
            # +               -
            # exponent     +       +infinity       -infinity
            # -       +0.0            -0.0
            return FormattedFloatingDecimal.new(sign * (positive_exponent ? Double::POSITIVE_INFINITY : 0.0))
          end
          # exponent sign
          raw_exponent = (positive_exponent ? 1 : -1) * unsigned_raw_exponent # exponent magnitude
          # Calculate partially adjusted exponent
          exponent = raw_exponent + exponent_adjust
          # Starting copying non-zero bits into proper position in
          # a long; copy explicit bit too; this will be masked
          # later for normal values.
          round = false
          sticky = false
          bits_copied = 0
          next_shift = 0
          significand = 0
          # First iteration is different, since we only copy
          # from the leading significand bit; one more exponent
          # adjust will be needed...
          # IMPORTANT: make leadingDigit a long to avoid
          # surprising shift semantics!
          leading_digit = get_hex_digit(significand_string, 0)
          # 
          # Left shift the leading digit (53 - (bit position of
          # leading 1 in digit)); this sets the top bit of the
          # significand to 1.  The nextShift value is adjusted
          # to take into account the number of bit positions of
          # the leadingDigit actually used.  Finally, the
          # exponent is adjusted to normalize the significand
          # as a binary value, not just a hex value.
          if ((leading_digit).equal?(1))
            significand |= leading_digit << 52
            next_shift = 52 - 4
            # exponent += 0
          else
            if (leading_digit <= 3)
              # [2, 3]
              significand |= leading_digit << 51
              next_shift = 52 - 5
              exponent += 1
            else
              if (leading_digit <= 7)
                # [4, 7]
                significand |= leading_digit << 50
                next_shift = 52 - 6
                exponent += 2
              else
                if (leading_digit <= 15)
                  # [8, f]
                  significand |= leading_digit << 49
                  next_shift = 52 - 7
                  exponent += 3
                else
                  raise AssertionError.new("Result from digit converstion too large!")
                end
              end
            end
          end
          # The preceding if-else could be replaced by a single
          # code block based on the high-order bit set in
          # leadingDigit.  Given leadingOnePosition,
          # significand |= leadingDigit << (SIGNIFICAND_WIDTH - leadingOnePosition);
          # nextShift = 52 - (3 + leadingOnePosition);
          # exponent += (leadingOnePosition-1);
          # 
          # Now the exponent variable is equal to the normalized
          # binary exponent.  Code below will make representation
          # adjustments if the exponent is incremented after
          # rounding (includes overflows to infinity) or if the
          # result is subnormal.
          # 
          # Copy digit into significand until the significand can't
          # hold another full hex digit or there are no more input
          # hex digits.
          i = 0
          i = 1
          while i < signif_length && next_shift >= 0
            current_digit = get_hex_digit(significand_string, i)
            significand |= (current_digit << next_shift)
            next_shift -= 4
            ((i += 1) - 1)
          end
          # After the above loop, the bulk of the string is copied.
          # Now, we must copy any partial hex digits into the
          # significand AND compute the round bit and start computing
          # sticky bit.
          if (i < signif_length)
            # at least one hex input digit exists
            current_digit_ = get_hex_digit(significand_string, i)
            # from nextShift, figure out how many bits need
            # to be copied, if any
            case (next_shift) # must be negative
            when -1
              # three bits need to be copied in; can
              # set round bit
              significand |= ((current_digit_ & 0xe) >> 1)
              round = !((current_digit_ & 0x1)).equal?(0)
            when -2
              # two bits need to be copied in; can
              # set round and start sticky
              significand |= ((current_digit_ & 0xc) >> 2)
              round = !((current_digit_ & 0x2)).equal?(0)
              sticky = !((current_digit_ & 0x1)).equal?(0)
            when -3
              # one bit needs to be copied in
              significand |= ((current_digit_ & 0x8) >> 3)
              # Now set round and start sticky, if possible
              round = !((current_digit_ & 0x4)).equal?(0)
              sticky = !((current_digit_ & 0x3)).equal?(0)
            when -4
              # all bits copied into significand; set
              # round and start sticky
              round = (!((current_digit_ & 0x8)).equal?(0)) # is top bit set?
              # nonzeros in three low order bits?
              sticky = !((current_digit_ & 0x7)).equal?(0)
            else
              raise AssertionError.new("Unexpected shift distance remainder.")
            end
            # break;
            # Round is set; sticky might be set.
            # For the sticky bit, it suffices to check the
            # current digit and test for any nonzero digits in
            # the remaining unprocessed input.
            ((i += 1) - 1)
            while (i < signif_length && !sticky)
              current_digit_ = get_hex_digit(significand_string, i)
              sticky = sticky || (!(current_digit_).equal?(0))
              ((i += 1) - 1)
            end
          end
          # else all of string was seen, round and sticky are
          # correct as false.
          # Check for overflow and update exponent accordingly.
          if (exponent > DoubleConsts::MAX_EXPONENT)
            # Infinite result
            # overflow to properly signed infinity
            return FormattedFloatingDecimal.new(sign * Double::POSITIVE_INFINITY)
          else
            # Finite return value
            # (Usually) normal result
            if (exponent <= DoubleConsts::MAX_EXPONENT && exponent >= DoubleConsts::MIN_EXPONENT)
              # The result returned in this block cannot be a
              # zero or subnormal; however after the
              # significand is adjusted from rounding, we could
              # still overflow in infinity.
              # AND exponent bits into significand; if the
              # significand is incremented and overflows from
              # rounding, this combination will update the
              # exponent correctly, even in the case of
              # Double.MAX_VALUE overflowing to infinity.
              significand = (((exponent + DoubleConsts::EXP_BIAS) << (DoubleConsts::SIGNIFICAND_WIDTH - 1)) & DoubleConsts::EXP_BIT_MASK) | (DoubleConsts::SIGNIF_BIT_MASK & significand)
            else
              # Subnormal or zero
              # (exponent < DoubleConsts.MIN_EXPONENT)
              if (exponent < (DoubleConsts::MIN_SUB_EXPONENT - 1))
                # No way to round back to nonzero value
                # regardless of significand if the exponent is
                # less than -1075.
                return FormattedFloatingDecimal.new(sign * 0.0)
              else
                # -1075 <= exponent <= MIN_EXPONENT -1 = -1023
                # 
                # Find bit position to round to; recompute
                # round and sticky bits, and shift
                # significand right appropriately.
                sticky = sticky || round
                round = false
                # Number of bits of significand to preserve is
                # exponent - abs_min_exp +1
                # check:
                # -1075 +1074 + 1 = 0
                # -1023 +1074 + 1 = 52
                bits_discarded = 53 - (RJava.cast_to_int(exponent) - DoubleConsts::MIN_SUB_EXPONENT + 1)
                raise AssertError if not (bits_discarded >= 1 && bits_discarded <= 53)
                # What to do here:
                # First, isolate the new round bit
                round = !((significand & (1 << (bits_discarded - 1)))).equal?(0)
                if (bits_discarded > 1)
                  # create mask to update sticky bits; low
                  # order bitsDiscarded bits should be 1
                  mask = ~((~0) << (bits_discarded - 1))
                  sticky = sticky || (!((significand & mask)).equal?(0))
                end
                # Now, discard the bits
                significand = significand >> bits_discarded
                # subnorm exp.
                significand = ((((DoubleConsts::MIN_EXPONENT - 1) + DoubleConsts::EXP_BIAS) << (DoubleConsts::SIGNIFICAND_WIDTH - 1)) & DoubleConsts::EXP_BIT_MASK) | (DoubleConsts::SIGNIF_BIT_MASK & significand)
              end
            end
            # The significand variable now contains the currently
            # appropriate exponent bits too.
            # 
            # Determine if significand should be incremented;
            # making this determination depends on the least
            # significant bit and the round and sticky bits.
            # 
            # Round to nearest even rounding table, adapted from
            # table 4.7 in "Computer Arithmetic" by IsraelKoren.
            # The digit to the left of the "decimal" point is the
            # least significant bit, the digits to the right of
            # the point are the round and sticky bits
            # 
            # Number       Round(x)
            # x0.00        x0.
            # x0.01        x0.
            # x0.10        x0.
            # x0.11        x1. = x0. +1
            # x1.00        x1.
            # x1.01        x1.
            # x1.10        x1. + 1
            # x1.11        x1. + 1
            incremented = false
            least_zero = (((significand & 1)).equal?(0))
            if ((least_zero && round && sticky) || ((!least_zero) && round))
              incremented = true
              ((significand += 1) - 1)
            end
            fd = FormattedFloatingDecimal.new(FpUtils.raw_copy_sign(Double.long_bits_to_double(significand), sign))
            # 
            # Set roundingDir variable field of fd properly so
            # that the input string can be properly rounded to a
            # float value.  There are two cases to consider:
            # 
            # 1. rounding to double discards sticky bit
            # information that would change the result of a float
            # rounding (near halfway case between two floats)
            # 
            # 2. rounding to double rounds up when rounding up
            # would not occur when rounding to float.
            # 
            # For former case only needs to be considered when
            # the bits rounded away when casting to float are all
            # zero; otherwise, float round bit is properly set
            # and sticky will already be true.
            # 
            # The lower exponent bound for the code below is the
            # minimum (normalized) subnormal exponent - 1 since a
            # value with that exponent can round up to the
            # minimum subnormal value and the sticky bit
            # information must be preserved (i.e. case 1).
            if ((exponent >= FloatConsts::MIN_SUB_EXPONENT - 1) && (exponent <= FloatConsts::MAX_EXPONENT))
              # Outside above exponent range, the float value
              # will be zero or infinity.
              # 
              # If the low-order 28 bits of a rounded double
              # significand are 0, the double could be a
              # half-way case for a rounding to float.  If the
              # double value is a half-way case, the double
              # significand may have to be modified to round
              # the the right float value (see the stickyRound
              # method).  If the rounding to double has lost
              # what would be float sticky bit information, the
              # double significand must be incremented.  If the
              # double value's significand was itself
              # incremented, the float value may end up too
              # large so the increment should be undone.
              if (((significand & 0xfffffff)).equal?(0x0))
                # For negative values, the sign of the
                # roundDir is the same as for positive values
                # since adding 1 increasing the significand's
                # magnitude and subtracting 1 decreases the
                # significand's magnitude.  If neither round
                # nor sticky is true, the double value is
                # exact and no adjustment is required for a
                # proper float rounding.
                if (round || sticky)
                  if (least_zero)
                    # prerounding lsb is 0
                    # If round and sticky were both true,
                    # and the least significant
                    # significand bit were 0, the rounded
                    # significand would not have its
                    # low-order bits be zero.  Therefore,
                    # we only need to adjust the
                    # significand if round XOR sticky is
                    # true.
                    if (round ^ sticky)
                      fd.attr_round_dir = 1
                    end
                  else
                    # prerounding lsb is 1
                    # If the prerounding lsb is 1 and the
                    # resulting significand has its
                    # low-order bits zero, the significand
                    # was incremented.  Here, we undo the
                    # increment, which will ensure the
                    # right guard and sticky bits for the
                    # float rounding.
                    if (round)
                      fd.attr_round_dir = -1
                    end
                  end
                end
              end
            end
            fd.attr_from_hex = true
            return fd
          end
        end
      end
      
      typesig { [String] }
      # 
      # Return <code>s</code> with any leading zeros removed.
      def strip_leading_zeros(s)
        return s.replace_first("^0+", "")
      end
      
      typesig { [String, ::Java::Int] }
      # 
      # Extract a hexadecimal digit from position <code>position</code>
      # of string <code>s</code>.
      def get_hex_digit(s, position)
        value = Character.digit(s.char_at(position), 16)
        if (value <= -1 || value >= 16)
          raise AssertionError.new("Unxpected failure of digit converstion of " + (s.char_at(position)).to_s)
        end
        return value
      end
    }
    
    private
    alias_method :initialize__formatted_floating_decimal, :initialize
  end
  
end
