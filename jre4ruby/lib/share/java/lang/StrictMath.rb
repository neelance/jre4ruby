require "rjava"

# Copyright 1999-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module StrictMathImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Util, :Random
      include_const ::Sun::Misc, :FpUtils
    }
  end
  
  # The class {@code StrictMath} contains methods for performing basic
  # numeric operations such as the elementary exponential, logarithm,
  # square root, and trigonometric functions.
  # 
  # <p>To help ensure portability of Java programs, the definitions of
  # some of the numeric functions in this package require that they
  # produce the same results as certain published algorithms. These
  # algorithms are available from the well-known network library
  # {@code netlib} as the package "Freely Distributable Math
  # Library," <a
  # href="ftp://ftp.netlib.org/fdlibm.tar">{@code fdlibm}</a>. These
  # algorithms, which are written in the C programming language, are
  # then to be understood as executed with all floating-point
  # operations following the rules of Java floating-point arithmetic.
  # 
  # <p>The Java math library is defined with respect to
  # {@code fdlibm} version 5.3. Where {@code fdlibm} provides
  # more than one definition for a function (such as
  # {@code acos}), use the "IEEE 754 core function" version
  # (residing in a file whose name begins with the letter
  # {@code e}).  The methods which require {@code fdlibm}
  # semantics are {@code sin}, {@code cos}, {@code tan},
  # {@code asin}, {@code acos}, {@code atan},
  # {@code exp}, {@code log}, {@code log10},
  # {@code cbrt}, {@code atan2}, {@code pow},
  # {@code sinh}, {@code cosh}, {@code tanh},
  # {@code hypot}, {@code expm1}, and {@code log1p}.
  # 
  # @author  unascribed
  # @author  Joseph D. Darcy
  # @since   1.3
  class StrictMath 
    include_class_members StrictMathImports
    
    typesig { [] }
    # Don't let anyone instantiate this class.
    def initialize
    end
    
    class_module.module_eval {
      # The {@code double} value that is closer than any other to
      # <i>e</i>, the base of the natural logarithms.
      const_set_lazy(:E) { 2.7182818284590452354 }
      const_attr_reader  :E
      
      # The {@code double} value that is closer than any other to
      # <i>pi</i>, the ratio of the circumference of a circle to its
      # diameter.
      const_set_lazy(:PI) { 3.14159265358979323846 }
      const_attr_reader  :PI
      
      JNI.load_native_method :Java_java_lang_StrictMath_sin, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the trigonometric sine of an angle. Special cases:
      # <ul><li>If the argument is NaN or an infinity, then the
      # result is NaN.
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.</ul>
      # 
      # @param   a   an angle, in radians.
      # @return  the sine of the argument.
      def sin(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_sin, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_cos, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the trigonometric cosine of an angle. Special cases:
      # <ul><li>If the argument is NaN or an infinity, then the
      # result is NaN.</ul>
      # 
      # @param   a   an angle, in radians.
      # @return  the cosine of the argument.
      def cos(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_cos, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_tan, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the trigonometric tangent of an angle. Special cases:
      # <ul><li>If the argument is NaN or an infinity, then the result
      # is NaN.
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.</ul>
      # 
      # @param   a   an angle, in radians.
      # @return  the tangent of the argument.
      def tan(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_tan, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_asin, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the arc sine of a value; the returned angle is in the
      # range -<i>pi</i>/2 through <i>pi</i>/2.  Special cases:
      # <ul><li>If the argument is NaN or its absolute value is greater
      # than 1, then the result is NaN.
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.</ul>
      # 
      # @param   a   the value whose arc sine is to be returned.
      # @return  the arc sine of the argument.
      def asin(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_asin, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_acos, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the arc cosine of a value; the returned angle is in the
      # range 0.0 through <i>pi</i>.  Special case:
      # <ul><li>If the argument is NaN or its absolute value is greater
      # than 1, then the result is NaN.</ul>
      # 
      # @param   a   the value whose arc cosine is to be returned.
      # @return  the arc cosine of the argument.
      def acos(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_acos, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_atan, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the arc tangent of a value; the returned angle is in the
      # range -<i>pi</i>/2 through <i>pi</i>/2.  Special cases:
      # <ul><li>If the argument is NaN, then the result is NaN.
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.</ul>
      # 
      # @param   a   the value whose arc tangent is to be returned.
      # @return  the arc tangent of the argument.
      def atan(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_atan, JNI.env, self.jni_id, a)
      end
      
      typesig { [::Java::Double] }
      # Converts an angle measured in degrees to an approximately
      # equivalent angle measured in radians.  The conversion from
      # degrees to radians is generally inexact.
      # 
      # @param   angdeg   an angle, in degrees
      # @return  the measurement of the angle {@code angdeg}
      # in radians.
      def to_radians(angdeg)
        return angdeg / 180.0 * PI
      end
      
      typesig { [::Java::Double] }
      # Converts an angle measured in radians to an approximately
      # equivalent angle measured in degrees.  The conversion from
      # radians to degrees is generally inexact; users should
      # <i>not</i> expect {@code cos(toRadians(90.0))} to exactly
      # equal {@code 0.0}.
      # 
      # @param   angrad   an angle, in radians
      # @return  the measurement of the angle {@code angrad}
      # in degrees.
      def to_degrees(angrad)
        return angrad * 180.0 / PI
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_exp, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns Euler's number <i>e</i> raised to the power of a
      # {@code double} value. Special cases:
      # <ul><li>If the argument is NaN, the result is NaN.
      # <li>If the argument is positive infinity, then the result is
      # positive infinity.
      # <li>If the argument is negative infinity, then the result is
      # positive zero.</ul>
      # 
      # @param   a   the exponent to raise <i>e</i> to.
      # @return  the value <i>e</i><sup>{@code a}</sup>,
      # where <i>e</i> is the base of the natural logarithms.
      def exp(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_exp, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_log, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the natural logarithm (base <i>e</i>) of a {@code double}
      # value. Special cases:
      # <ul><li>If the argument is NaN or less than zero, then the result
      # is NaN.
      # <li>If the argument is positive infinity, then the result is
      # positive infinity.
      # <li>If the argument is positive zero or negative zero, then the
      # result is negative infinity.</ul>
      # 
      # @param   a   a value
      # @return  the value ln&nbsp;{@code a}, the natural logarithm of
      # {@code a}.
      def log(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_log, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_log10, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the base 10 logarithm of a {@code double} value.
      # Special cases:
      # 
      # <ul><li>If the argument is NaN or less than zero, then the result
      # is NaN.
      # <li>If the argument is positive infinity, then the result is
      # positive infinity.
      # <li>If the argument is positive zero or negative zero, then the
      # result is negative infinity.
      # <li> If the argument is equal to 10<sup><i>n</i></sup> for
      # integer <i>n</i>, then the result is <i>n</i>.
      # </ul>
      # 
      # @param   a   a value
      # @return  the base 10 logarithm of  {@code a}.
      # @since 1.5
      def log10(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_log10, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_sqrt, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the correctly rounded positive square root of a
      # {@code double} value.
      # Special cases:
      # <ul><li>If the argument is NaN or less than zero, then the result
      # is NaN.
      # <li>If the argument is positive infinity, then the result is positive
      # infinity.
      # <li>If the argument is positive zero or negative zero, then the
      # result is the same as the argument.</ul>
      # Otherwise, the result is the {@code double} value closest to
      # the true mathematical square root of the argument value.
      # 
      # @param   a   a value.
      # @return  the positive square root of {@code a}.
      def sqrt(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_sqrt, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_cbrt, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the cube root of a {@code double} value.  For
      # positive finite {@code x}, {@code cbrt(-x) ==
      # -cbrt(x)}; that is, the cube root of a negative value is
      # the negative of the cube root of that value's magnitude.
      # Special cases:
      # 
      # <ul>
      # 
      # <li>If the argument is NaN, then the result is NaN.
      # 
      # <li>If the argument is infinite, then the result is an infinity
      # with the same sign as the argument.
      # 
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.
      # 
      # </ul>
      # 
      # @param   a   a value.
      # @return  the cube root of {@code a}.
      # @since 1.5
      def cbrt(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_cbrt, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_IEEEremainder, [:pointer, :long, :double, :double], :double
      typesig { [::Java::Double, ::Java::Double] }
      # Computes the remainder operation on two arguments as prescribed
      # by the IEEE 754 standard.
      # The remainder value is mathematically equal to
      # <code>f1&nbsp;-&nbsp;f2</code>&nbsp;&times;&nbsp;<i>n</i>,
      # where <i>n</i> is the mathematical integer closest to the exact
      # mathematical value of the quotient {@code f1/f2}, and if two
      # mathematical integers are equally close to {@code f1/f2},
      # then <i>n</i> is the integer that is even. If the remainder is
      # zero, its sign is the same as the sign of the first argument.
      # Special cases:
      # <ul><li>If either argument is NaN, or the first argument is infinite,
      # or the second argument is positive zero or negative zero, then the
      # result is NaN.
      # <li>If the first argument is finite and the second argument is
      # infinite, then the result is the same as the first argument.</ul>
      # 
      # @param   f1   the dividend.
      # @param   f2   the divisor.
      # @return  the remainder when {@code f1} is divided by
      # {@code f2}.
      def _ieeeremainder(f1, f2)
        JNI.call_native_method(:Java_java_lang_StrictMath_IEEEremainder, JNI.env, self.jni_id, f1, f2)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_ceil, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the smallest (closest to negative infinity)
      # {@code double} value that is greater than or equal to the
      # argument and is equal to a mathematical integer. Special cases:
      # <ul><li>If the argument value is already equal to a
      # mathematical integer, then the result is the same as the
      # argument.  <li>If the argument is NaN or an infinity or
      # positive zero or negative zero, then the result is the same as
      # the argument.  <li>If the argument value is less than zero but
      # greater than -1.0, then the result is negative zero.</ul> Note
      # that the value of {@code StrictMath.ceil(x)} is exactly the
      # value of {@code -StrictMath.floor(-x)}.
      # 
      # @param   a   a value.
      # @return  the smallest (closest to negative infinity)
      # floating-point value that is greater than or equal to
      # the argument and is equal to a mathematical integer.
      def ceil(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_ceil, JNI.env, self.jni_id, a)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_floor, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the largest (closest to positive infinity)
      # {@code double} value that is less than or equal to the
      # argument and is equal to a mathematical integer. Special cases:
      # <ul><li>If the argument value is already equal to a
      # mathematical integer, then the result is the same as the
      # argument.  <li>If the argument is NaN or an infinity or
      # positive zero or negative zero, then the result is the same as
      # the argument.</ul>
      # 
      # @param   a   a value.
      # @return  the largest (closest to positive infinity)
      # floating-point value that less than or equal to the argument
      # and is equal to a mathematical integer.
      def floor(a)
        JNI.call_native_method(:Java_java_lang_StrictMath_floor, JNI.env, self.jni_id, a)
      end
      
      typesig { [::Java::Double] }
      # Returns the {@code double} value that is closest in value
      # to the argument and is equal to a mathematical integer. If two
      # {@code double} values that are mathematical integers are
      # equally close to the value of the argument, the result is the
      # integer value that is even. Special cases:
      # <ul><li>If the argument value is already equal to a mathematical
      # integer, then the result is the same as the argument.
      # <li>If the argument is NaN or an infinity or positive zero or negative
      # zero, then the result is the same as the argument.</ul>
      # 
      # @param   a   a value.
      # @return  the closest floating-point value to {@code a} that is
      # equal to a mathematical integer.
      # @author Joseph D. Darcy
      def rint(a)
        # If the absolute value of a is not less than 2^52, it
        # is either a finite integer (the double format does not have
        # enough significand bits for a number that large to have any
        # fractional portion), an infinity, or a NaN.  In any of
        # these cases, rint of the argument is the argument.
        # 
        # Otherwise, the sum (twoToThe52 + a ) will properly round
        # away any fractional portion of a since ulp(twoToThe52) ==
        # 1.0; subtracting out twoToThe52 from this sum will then be
        # exact and leave the rounded integer portion of a.
        # 
        # This method does *not* need to be declared strictfp to get
        # fully reproducible results.  Whether or not a method is
        # declared strictfp can only make a difference in the
        # returned result if some operation would overflow or
        # underflow with strictfp semantics.  The operation
        # (twoToThe52 + a ) cannot overflow since large values of a
        # are screened out; the add cannot underflow since twoToThe52
        # is too large.  The subtraction ((twoToThe52 + a ) -
        # twoToThe52) will be exact as discussed above and thus
        # cannot overflow or meaningfully underflow.  Finally, the
        # last multiply in the return statement is by plus or minus
        # 1.0, which is exact too.
        two_to_the52 = ((1 << 52)).to_f # 2^52
        sign = FpUtils.raw_copy_sign(1.0, a) # preserve sign info
        a = Math.abs(a)
        if (a < two_to_the52)
          # E_min <= ilogb(a) <= 51
          a = ((two_to_the52 + a) - two_to_the52)
        end
        return sign * a # restore original sign
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_atan2, [:pointer, :long, :double, :double], :double
      typesig { [::Java::Double, ::Java::Double] }
      # Returns the angle <i>theta</i> from the conversion of rectangular
      # coordinates ({@code x},&nbsp;{@code y}) to polar
      # coordinates (r,&nbsp;<i>theta</i>).
      # This method computes the phase <i>theta</i> by computing an arc tangent
      # of {@code y/x} in the range of -<i>pi</i> to <i>pi</i>. Special
      # cases:
      # <ul><li>If either argument is NaN, then the result is NaN.
      # <li>If the first argument is positive zero and the second argument
      # is positive, or the first argument is positive and finite and the
      # second argument is positive infinity, then the result is positive
      # zero.
      # <li>If the first argument is negative zero and the second argument
      # is positive, or the first argument is negative and finite and the
      # second argument is positive infinity, then the result is negative zero.
      # <li>If the first argument is positive zero and the second argument
      # is negative, or the first argument is positive and finite and the
      # second argument is negative infinity, then the result is the
      # {@code double} value closest to <i>pi</i>.
      # <li>If the first argument is negative zero and the second argument
      # is negative, or the first argument is negative and finite and the
      # second argument is negative infinity, then the result is the
      # {@code double} value closest to -<i>pi</i>.
      # <li>If the first argument is positive and the second argument is
      # positive zero or negative zero, or the first argument is positive
      # infinity and the second argument is finite, then the result is the
      # {@code double} value closest to <i>pi</i>/2.
      # <li>If the first argument is negative and the second argument is
      # positive zero or negative zero, or the first argument is negative
      # infinity and the second argument is finite, then the result is the
      # {@code double} value closest to -<i>pi</i>/2.
      # <li>If both arguments are positive infinity, then the result is the
      # {@code double} value closest to <i>pi</i>/4.
      # <li>If the first argument is positive infinity and the second argument
      # is negative infinity, then the result is the {@code double}
      # value closest to 3*<i>pi</i>/4.
      # <li>If the first argument is negative infinity and the second argument
      # is positive infinity, then the result is the {@code double} value
      # closest to -<i>pi</i>/4.
      # <li>If both arguments are negative infinity, then the result is the
      # {@code double} value closest to -3*<i>pi</i>/4.</ul>
      # 
      # @param   y   the ordinate coordinate
      # @param   x   the abscissa coordinate
      # @return  the <i>theta</i> component of the point
      # (<i>r</i>,&nbsp;<i>theta</i>)
      # in polar coordinates that corresponds to the point
      # (<i>x</i>,&nbsp;<i>y</i>) in Cartesian coordinates.
      def atan2(y, x)
        JNI.call_native_method(:Java_java_lang_StrictMath_atan2, JNI.env, self.jni_id, y, x)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_pow, [:pointer, :long, :double, :double], :double
      typesig { [::Java::Double, ::Java::Double] }
      # Returns the value of the first argument raised to the power of the
      # second argument. Special cases:
      # 
      # <ul><li>If the second argument is positive or negative zero, then the
      # result is 1.0.
      # <li>If the second argument is 1.0, then the result is the same as the
      # first argument.
      # <li>If the second argument is NaN, then the result is NaN.
      # <li>If the first argument is NaN and the second argument is nonzero,
      # then the result is NaN.
      # 
      # <li>If
      # <ul>
      # <li>the absolute value of the first argument is greater than 1
      # and the second argument is positive infinity, or
      # <li>the absolute value of the first argument is less than 1 and
      # the second argument is negative infinity,
      # </ul>
      # then the result is positive infinity.
      # 
      # <li>If
      # <ul>
      # <li>the absolute value of the first argument is greater than 1 and
      # the second argument is negative infinity, or
      # <li>the absolute value of the
      # first argument is less than 1 and the second argument is positive
      # infinity,
      # </ul>
      # then the result is positive zero.
      # 
      # <li>If the absolute value of the first argument equals 1 and the
      # second argument is infinite, then the result is NaN.
      # 
      # <li>If
      # <ul>
      # <li>the first argument is positive zero and the second argument
      # is greater than zero, or
      # <li>the first argument is positive infinity and the second
      # argument is less than zero,
      # </ul>
      # then the result is positive zero.
      # 
      # <li>If
      # <ul>
      # <li>the first argument is positive zero and the second argument
      # is less than zero, or
      # <li>the first argument is positive infinity and the second
      # argument is greater than zero,
      # </ul>
      # then the result is positive infinity.
      # 
      # <li>If
      # <ul>
      # <li>the first argument is negative zero and the second argument
      # is greater than zero but not a finite odd integer, or
      # <li>the first argument is negative infinity and the second
      # argument is less than zero but not a finite odd integer,
      # </ul>
      # then the result is positive zero.
      # 
      # <li>If
      # <ul>
      # <li>the first argument is negative zero and the second argument
      # is a positive finite odd integer, or
      # <li>the first argument is negative infinity and the second
      # argument is a negative finite odd integer,
      # </ul>
      # then the result is negative zero.
      # 
      # <li>If
      # <ul>
      # <li>the first argument is negative zero and the second argument
      # is less than zero but not a finite odd integer, or
      # <li>the first argument is negative infinity and the second
      # argument is greater than zero but not a finite odd integer,
      # </ul>
      # then the result is positive infinity.
      # 
      # <li>If
      # <ul>
      # <li>the first argument is negative zero and the second argument
      # is a negative finite odd integer, or
      # <li>the first argument is negative infinity and the second
      # argument is a positive finite odd integer,
      # </ul>
      # then the result is negative infinity.
      # 
      # <li>If the first argument is finite and less than zero
      # <ul>
      # <li> if the second argument is a finite even integer, the
      # result is equal to the result of raising the absolute value of
      # the first argument to the power of the second argument
      # 
      # <li>if the second argument is a finite odd integer, the result
      # is equal to the negative of the result of raising the absolute
      # value of the first argument to the power of the second
      # argument
      # 
      # <li>if the second argument is finite and not an integer, then
      # the result is NaN.
      # </ul>
      # 
      # <li>If both arguments are integers, then the result is exactly equal
      # to the mathematical result of raising the first argument to the power
      # of the second argument if that result can in fact be represented
      # exactly as a {@code double} value.</ul>
      # 
      # <p>(In the foregoing descriptions, a floating-point value is
      # considered to be an integer if and only if it is finite and a
      # fixed point of the method {@link #ceil ceil} or,
      # equivalently, a fixed point of the method {@link #floor
      # floor}. A value is a fixed point of a one-argument
      # method if and only if the result of applying the method to the
      # value is equal to the value.)
      # 
      # @param   a   base.
      # @param   b   the exponent.
      # @return  the value {@code a}<sup>{@code b}</sup>.
      def pow(a, b)
        JNI.call_native_method(:Java_java_lang_StrictMath_pow, JNI.env, self.jni_id, a, b)
      end
      
      typesig { [::Java::Float] }
      # Returns the closest {@code int} to the argument. The
      # result is rounded to an integer by adding 1/2, taking the
      # floor of the result, and casting the result to type {@code int}.
      # In other words, the result is equal to the value of the expression:
      # <p>{@code (int)Math.floor(a + 0.5f)}
      # 
      # <p>Special cases:
      # <ul><li>If the argument is NaN, the result is 0.
      # <li>If the argument is negative infinity or any value less than or
      # equal to the value of {@code Integer.MIN_VALUE}, the result is
      # equal to the value of {@code Integer.MIN_VALUE}.
      # <li>If the argument is positive infinity or any value greater than or
      # equal to the value of {@code Integer.MAX_VALUE}, the result is
      # equal to the value of {@code Integer.MAX_VALUE}.</ul>
      # 
      # @param   a   a floating-point value to be rounded to an integer.
      # @return  the value of the argument rounded to the nearest
      # {@code int} value.
      # @see     java.lang.Integer#MAX_VALUE
      # @see     java.lang.Integer#MIN_VALUE
      def round(a)
        return RJava.cast_to_int(floor(a + 0.5))
      end
      
      typesig { [::Java::Double] }
      # Returns the closest {@code long} to the argument. The result
      # is rounded to an integer by adding 1/2, taking the floor of the
      # result, and casting the result to type {@code long}. In other
      # words, the result is equal to the value of the expression:
      # <p>{@code (long)Math.floor(a + 0.5d)}
      # 
      # <p>Special cases:
      # <ul><li>If the argument is NaN, the result is 0.
      # <li>If the argument is negative infinity or any value less than or
      # equal to the value of {@code Long.MIN_VALUE}, the result is
      # equal to the value of {@code Long.MIN_VALUE}.
      # <li>If the argument is positive infinity or any value greater than or
      # equal to the value of {@code Long.MAX_VALUE}, the result is
      # equal to the value of {@code Long.MAX_VALUE}.</ul>
      # 
      # @param   a  a floating-point value to be rounded to a
      # {@code long}.
      # @return  the value of the argument rounded to the nearest
      # {@code long} value.
      # @see     java.lang.Long#MAX_VALUE
      # @see     java.lang.Long#MIN_VALUE
      def round(a)
        return floor(a + 0.5)
      end
      
      
      def random_number_generator
        defined?(@@random_number_generator) ? @@random_number_generator : @@random_number_generator= nil
      end
      alias_method :attr_random_number_generator, :random_number_generator
      
      def random_number_generator=(value)
        @@random_number_generator = value
      end
      alias_method :attr_random_number_generator=, :random_number_generator=
      
      typesig { [] }
      def init_rng
        synchronized(self) do
          if ((self.attr_random_number_generator).nil?)
            self.attr_random_number_generator = Random.new
          end
        end
      end
      
      typesig { [] }
      # Returns a {@code double} value with a positive sign, greater
      # than or equal to {@code 0.0} and less than {@code 1.0}.
      # Returned values are chosen pseudorandomly with (approximately)
      # uniform distribution from that range.
      # 
      # <p>When this method is first called, it creates a single new
      # pseudorandom-number generator, exactly as if by the expression
      # <blockquote>{@code new java.util.Random}</blockquote> This
      # new pseudorandom-number generator is used thereafter for all
      # calls to this method and is used nowhere else.
      # 
      # <p>This method is properly synchronized to allow correct use by
      # more than one thread. However, if many threads need to generate
      # pseudorandom numbers at a great rate, it may reduce contention
      # for each thread to have its own pseudorandom number generator.
      # 
      # @return  a pseudorandom {@code double} greater than or equal
      # to {@code 0.0} and less than {@code 1.0}.
      # @see     java.util.Random#nextDouble()
      def random
        if ((self.attr_random_number_generator).nil?)
          init_rng
        end
        return self.attr_random_number_generator.next_double
      end
      
      typesig { [::Java::Int] }
      # Returns the absolute value of an {@code int} value..
      # If the argument is not negative, the argument is returned.
      # If the argument is negative, the negation of the argument is returned.
      # 
      # <p>Note that if the argument is equal to the value of
      # {@link Integer#MIN_VALUE}, the most negative representable
      # {@code int} value, the result is that same value, which is
      # negative.
      # 
      # @param   a   the  argument whose absolute value is to be determined.
      # @return  the absolute value of the argument.
      def abs(a)
        return (a < 0) ? -a : a
      end
      
      typesig { [::Java::Long] }
      # Returns the absolute value of a {@code long} value.
      # If the argument is not negative, the argument is returned.
      # If the argument is negative, the negation of the argument is returned.
      # 
      # <p>Note that if the argument is equal to the value of
      # {@link Long#MIN_VALUE}, the most negative representable
      # {@code long} value, the result is that same value, which
      # is negative.
      # 
      # @param   a   the  argument whose absolute value is to be determined.
      # @return  the absolute value of the argument.
      def abs(a)
        return (a < 0) ? -a : a
      end
      
      typesig { [::Java::Float] }
      # Returns the absolute value of a {@code float} value.
      # If the argument is not negative, the argument is returned.
      # If the argument is negative, the negation of the argument is returned.
      # Special cases:
      # <ul><li>If the argument is positive zero or negative zero, the
      # result is positive zero.
      # <li>If the argument is infinite, the result is positive infinity.
      # <li>If the argument is NaN, the result is NaN.</ul>
      # In other words, the result is the same as the value of the expression:
      # <p>{@code Float.intBitsToFloat(0x7fffffff & Float.floatToIntBits(a))}
      # 
      # @param   a   the argument whose absolute value is to be determined
      # @return  the absolute value of the argument.
      def abs(a)
        return (a <= 0.0) ? 0.0 - a : a
      end
      
      typesig { [::Java::Double] }
      # Returns the absolute value of a {@code double} value.
      # If the argument is not negative, the argument is returned.
      # If the argument is negative, the negation of the argument is returned.
      # Special cases:
      # <ul><li>If the argument is positive zero or negative zero, the result
      # is positive zero.
      # <li>If the argument is infinite, the result is positive infinity.
      # <li>If the argument is NaN, the result is NaN.</ul>
      # In other words, the result is the same as the value of the expression:
      # <p>{@code Double.longBitsToDouble((Double.doubleToLongBits(a)<<1)>>>1)}
      # 
      # @param   a   the argument whose absolute value is to be determined
      # @return  the absolute value of the argument.
      def abs(a)
        return (a <= 0.0) ? 0.0 - a : a
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns the greater of two {@code int} values. That is, the
      # result is the argument closer to the value of
      # {@link Integer#MAX_VALUE}. If the arguments have the same value,
      # the result is that same value.
      # 
      # @param   a   an argument.
      # @param   b   another argument.
      # @return  the larger of {@code a} and {@code b}.
      def max(a, b)
        return (a >= b) ? a : b
      end
      
      typesig { [::Java::Long, ::Java::Long] }
      # Returns the greater of two {@code long} values. That is, the
      # result is the argument closer to the value of
      # {@link Long#MAX_VALUE}. If the arguments have the same value,
      # the result is that same value.
      # 
      # @param   a   an argument.
      # @param   b   another argument.
      # @return  the larger of {@code a} and {@code b}.
      def max(a, b)
        return (a >= b) ? a : b
      end
      
      
      def negative_zero_float_bits
        defined?(@@negative_zero_float_bits) ? @@negative_zero_float_bits : @@negative_zero_float_bits= Float.float_to_int_bits(-0.0)
      end
      alias_method :attr_negative_zero_float_bits, :negative_zero_float_bits
      
      def negative_zero_float_bits=(value)
        @@negative_zero_float_bits = value
      end
      alias_method :attr_negative_zero_float_bits=, :negative_zero_float_bits=
      
      
      def negative_zero_double_bits
        defined?(@@negative_zero_double_bits) ? @@negative_zero_double_bits : @@negative_zero_double_bits= Double.double_to_long_bits(-0.0)
      end
      alias_method :attr_negative_zero_double_bits, :negative_zero_double_bits
      
      def negative_zero_double_bits=(value)
        @@negative_zero_double_bits = value
      end
      alias_method :attr_negative_zero_double_bits=, :negative_zero_double_bits=
      
      typesig { [::Java::Float, ::Java::Float] }
      # Returns the greater of two {@code float} values.  That is,
      # the result is the argument closer to positive infinity. If the
      # arguments have the same value, the result is that same
      # value. If either value is NaN, then the result is NaN.  Unlike
      # the numerical comparison operators, this method considers
      # negative zero to be strictly smaller than positive zero. If one
      # argument is positive zero and the other negative zero, the
      # result is positive zero.
      # 
      # @param   a   an argument.
      # @param   b   another argument.
      # @return  the larger of {@code a} and {@code b}.
      def max(a, b)
        if (!(a).equal?(a))
          return a
        end # a is NaN
        if (((a).equal?(0.0)) && ((b).equal?(0.0)) && ((Float.float_to_int_bits(a)).equal?(self.attr_negative_zero_float_bits)))
          return b
        end
        return (a >= b) ? a : b
      end
      
      typesig { [::Java::Double, ::Java::Double] }
      # Returns the greater of two {@code double} values.  That
      # is, the result is the argument closer to positive infinity. If
      # the arguments have the same value, the result is that same
      # value. If either value is NaN, then the result is NaN.  Unlike
      # the numerical comparison operators, this method considers
      # negative zero to be strictly smaller than positive zero. If one
      # argument is positive zero and the other negative zero, the
      # result is positive zero.
      # 
      # @param   a   an argument.
      # @param   b   another argument.
      # @return  the larger of {@code a} and {@code b}.
      def max(a, b)
        if (!(a).equal?(a))
          return a
        end # a is NaN
        if (((a).equal?(0.0)) && ((b).equal?(0.0)) && ((Double.double_to_long_bits(a)).equal?(self.attr_negative_zero_double_bits)))
          return b
        end
        return (a >= b) ? a : b
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns the smaller of two {@code int} values. That is,
      # the result the argument closer to the value of
      # {@link Integer#MIN_VALUE}.  If the arguments have the same
      # value, the result is that same value.
      # 
      # @param   a   an argument.
      # @param   b   another argument.
      # @return  the smaller of {@code a} and {@code b}.
      def min(a, b)
        return (a <= b) ? a : b
      end
      
      typesig { [::Java::Long, ::Java::Long] }
      # Returns the smaller of two {@code long} values. That is,
      # the result is the argument closer to the value of
      # {@link Long#MIN_VALUE}. If the arguments have the same
      # value, the result is that same value.
      # 
      # @param   a   an argument.
      # @param   b   another argument.
      # @return  the smaller of {@code a} and {@code b}.
      def min(a, b)
        return (a <= b) ? a : b
      end
      
      typesig { [::Java::Float, ::Java::Float] }
      # Returns the smaller of two {@code float} values.  That is,
      # the result is the value closer to negative infinity. If the
      # arguments have the same value, the result is that same
      # value. If either value is NaN, then the result is NaN.  Unlike
      # the numerical comparison operators, this method considers
      # negative zero to be strictly smaller than positive zero.  If
      # one argument is positive zero and the other is negative zero,
      # the result is negative zero.
      # 
      # @param   a   an argument.
      # @param   b   another argument.
      # @return  the smaller of {@code a} and {@code b.}
      def min(a, b)
        if (!(a).equal?(a))
          return a
        end # a is NaN
        if (((a).equal?(0.0)) && ((b).equal?(0.0)) && ((Float.float_to_int_bits(b)).equal?(self.attr_negative_zero_float_bits)))
          return b
        end
        return (a <= b) ? a : b
      end
      
      typesig { [::Java::Double, ::Java::Double] }
      # Returns the smaller of two {@code double} values.  That
      # is, the result is the value closer to negative infinity. If the
      # arguments have the same value, the result is that same
      # value. If either value is NaN, then the result is NaN.  Unlike
      # the numerical comparison operators, this method considers
      # negative zero to be strictly smaller than positive zero. If one
      # argument is positive zero and the other is negative zero, the
      # result is negative zero.
      # 
      # @param   a   an argument.
      # @param   b   another argument.
      # @return  the smaller of {@code a} and {@code b}.
      def min(a, b)
        if (!(a).equal?(a))
          return a
        end # a is NaN
        if (((a).equal?(0.0)) && ((b).equal?(0.0)) && ((Double.double_to_long_bits(b)).equal?(self.attr_negative_zero_double_bits)))
          return b
        end
        return (a <= b) ? a : b
      end
      
      typesig { [::Java::Double] }
      # Returns the size of an ulp of the argument.  An ulp of a
      # {@code double} value is the positive distance between this
      # floating-point value and the {@code double} value next
      # larger in magnitude.  Note that for non-NaN <i>x</i>,
      # <code>ulp(-<i>x</i>) == ulp(<i>x</i>)</code>.
      # 
      # <p>Special Cases:
      # <ul>
      # <li> If the argument is NaN, then the result is NaN.
      # <li> If the argument is positive or negative infinity, then the
      # result is positive infinity.
      # <li> If the argument is positive or negative zero, then the result is
      # {@code Double.MIN_VALUE}.
      # <li> If the argument is &plusmn;{@code Double.MAX_VALUE}, then
      # the result is equal to 2<sup>971</sup>.
      # </ul>
      # 
      # @param d the floating-point value whose ulp is to be returned
      # @return the size of an ulp of the argument
      # @author Joseph D. Darcy
      # @since 1.5
      def ulp(d)
        return Sun::Misc::FpUtils.ulp(d)
      end
      
      typesig { [::Java::Float] }
      # Returns the size of an ulp of the argument.  An ulp of a
      # {@code float} value is the positive distance between this
      # floating-point value and the {@code float} value next
      # larger in magnitude.  Note that for non-NaN <i>x</i>,
      # <code>ulp(-<i>x</i>) == ulp(<i>x</i>)</code>.
      # 
      # <p>Special Cases:
      # <ul>
      # <li> If the argument is NaN, then the result is NaN.
      # <li> If the argument is positive or negative infinity, then the
      # result is positive infinity.
      # <li> If the argument is positive or negative zero, then the result is
      # {@code Float.MIN_VALUE}.
      # <li> If the argument is &plusmn;{@code Float.MAX_VALUE}, then
      # the result is equal to 2<sup>104</sup>.
      # </ul>
      # 
      # @param f the floating-point value whose ulp is to be returned
      # @return the size of an ulp of the argument
      # @author Joseph D. Darcy
      # @since 1.5
      def ulp(f)
        return Sun::Misc::FpUtils.ulp(f)
      end
      
      typesig { [::Java::Double] }
      # Returns the signum function of the argument; zero if the argument
      # is zero, 1.0 if the argument is greater than zero, -1.0 if the
      # argument is less than zero.
      # 
      # <p>Special Cases:
      # <ul>
      # <li> If the argument is NaN, then the result is NaN.
      # <li> If the argument is positive zero or negative zero, then the
      # result is the same as the argument.
      # </ul>
      # 
      # @param d the floating-point value whose signum is to be returned
      # @return the signum function of the argument
      # @author Joseph D. Darcy
      # @since 1.5
      def signum(d)
        return Sun::Misc::FpUtils.signum(d)
      end
      
      typesig { [::Java::Float] }
      # Returns the signum function of the argument; zero if the argument
      # is zero, 1.0f if the argument is greater than zero, -1.0f if the
      # argument is less than zero.
      # 
      # <p>Special Cases:
      # <ul>
      # <li> If the argument is NaN, then the result is NaN.
      # <li> If the argument is positive zero or negative zero, then the
      # result is the same as the argument.
      # </ul>
      # 
      # @param f the floating-point value whose signum is to be returned
      # @return the signum function of the argument
      # @author Joseph D. Darcy
      # @since 1.5
      def signum(f)
        return Sun::Misc::FpUtils.signum(f)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_sinh, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the hyperbolic sine of a {@code double} value.
      # The hyperbolic sine of <i>x</i> is defined to be
      # (<i>e<sup>x</sup>&nbsp;-&nbsp;e<sup>-x</sup></i>)/2
      # where <i>e</i> is {@linkplain Math#E Euler's number}.
      # 
      # <p>Special cases:
      # <ul>
      # 
      # <li>If the argument is NaN, then the result is NaN.
      # 
      # <li>If the argument is infinite, then the result is an infinity
      # with the same sign as the argument.
      # 
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.
      # 
      # </ul>
      # 
      # @param   x The number whose hyperbolic sine is to be returned.
      # @return  The hyperbolic sine of {@code x}.
      # @since 1.5
      def sinh(x)
        JNI.call_native_method(:Java_java_lang_StrictMath_sinh, JNI.env, self.jni_id, x)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_cosh, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the hyperbolic cosine of a {@code double} value.
      # The hyperbolic cosine of <i>x</i> is defined to be
      # (<i>e<sup>x</sup>&nbsp;+&nbsp;e<sup>-x</sup></i>)/2
      # where <i>e</i> is {@linkplain Math#E Euler's number}.
      # 
      # <p>Special cases:
      # <ul>
      # 
      # <li>If the argument is NaN, then the result is NaN.
      # 
      # <li>If the argument is infinite, then the result is positive
      # infinity.
      # 
      # <li>If the argument is zero, then the result is {@code 1.0}.
      # 
      # </ul>
      # 
      # @param   x The number whose hyperbolic cosine is to be returned.
      # @return  The hyperbolic cosine of {@code x}.
      # @since 1.5
      def cosh(x)
        JNI.call_native_method(:Java_java_lang_StrictMath_cosh, JNI.env, self.jni_id, x)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_tanh, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the hyperbolic tangent of a {@code double} value.
      # The hyperbolic tangent of <i>x</i> is defined to be
      # (<i>e<sup>x</sup>&nbsp;-&nbsp;e<sup>-x</sup></i>)/(<i>e<sup>x</sup>&nbsp;+&nbsp;e<sup>-x</sup></i>),
      # in other words, {@linkplain Math#sinh
      # sinh(<i>x</i>)}/{@linkplain Math#cosh cosh(<i>x</i>)}.  Note
      # that the absolute value of the exact tanh is always less than
      # 1.
      # 
      # <p>Special cases:
      # <ul>
      # 
      # <li>If the argument is NaN, then the result is NaN.
      # 
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.
      # 
      # <li>If the argument is positive infinity, then the result is
      # {@code +1.0}.
      # 
      # <li>If the argument is negative infinity, then the result is
      # {@code -1.0}.
      # 
      # </ul>
      # 
      # @param   x The number whose hyperbolic tangent is to be returned.
      # @return  The hyperbolic tangent of {@code x}.
      # @since 1.5
      def tanh(x)
        JNI.call_native_method(:Java_java_lang_StrictMath_tanh, JNI.env, self.jni_id, x)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_hypot, [:pointer, :long, :double, :double], :double
      typesig { [::Java::Double, ::Java::Double] }
      # Returns sqrt(<i>x</i><sup>2</sup>&nbsp;+<i>y</i><sup>2</sup>)
      # without intermediate overflow or underflow.
      # 
      # <p>Special cases:
      # <ul>
      # 
      # <li> If either argument is infinite, then the result
      # is positive infinity.
      # 
      # <li> If either argument is NaN and neither argument is infinite,
      # then the result is NaN.
      # 
      # </ul>
      # 
      # @param x a value
      # @param y a value
      # @return sqrt(<i>x</i><sup>2</sup>&nbsp;+<i>y</i><sup>2</sup>)
      # without intermediate overflow or underflow
      # @since 1.5
      def hypot(x, y)
        JNI.call_native_method(:Java_java_lang_StrictMath_hypot, JNI.env, self.jni_id, x, y)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_expm1, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns <i>e</i><sup>x</sup>&nbsp;-1.  Note that for values of
      # <i>x</i> near 0, the exact sum of
      # {@code expm1(x)}&nbsp;+&nbsp;1 is much closer to the true
      # result of <i>e</i><sup>x</sup> than {@code exp(x)}.
      # 
      # <p>Special cases:
      # <ul>
      # <li>If the argument is NaN, the result is NaN.
      # 
      # <li>If the argument is positive infinity, then the result is
      # positive infinity.
      # 
      # <li>If the argument is negative infinity, then the result is
      # -1.0.
      # 
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.
      # 
      # </ul>
      # 
      # @param   x   the exponent to raise <i>e</i> to in the computation of
      # <i>e</i><sup>{@code x}</sup>&nbsp;-1.
      # @return  the value <i>e</i><sup>{@code x}</sup>&nbsp;-&nbsp;1.
      # @since 1.5
      def expm1(x)
        JNI.call_native_method(:Java_java_lang_StrictMath_expm1, JNI.env, self.jni_id, x)
      end
      
      JNI.load_native_method :Java_java_lang_StrictMath_log1p, [:pointer, :long, :double], :double
      typesig { [::Java::Double] }
      # Returns the natural logarithm of the sum of the argument and 1.
      # Note that for small values {@code x}, the result of
      # {@code log1p(x)} is much closer to the true result of ln(1
      # + {@code x}) than the floating-point evaluation of
      # {@code log(1.0+x)}.
      # 
      # <p>Special cases:
      # <ul>
      # 
      # <li>If the argument is NaN or less than -1, then the result is
      # NaN.
      # 
      # <li>If the argument is positive infinity, then the result is
      # positive infinity.
      # 
      # <li>If the argument is negative one, then the result is
      # negative infinity.
      # 
      # <li>If the argument is zero, then the result is a zero with the
      # same sign as the argument.
      # 
      # </ul>
      # 
      # @param   x   a value
      # @return the value ln({@code x}&nbsp;+&nbsp;1), the natural
      # log of {@code x}&nbsp;+&nbsp;1
      # @since 1.5
      def log1p(x)
        JNI.call_native_method(:Java_java_lang_StrictMath_log1p, JNI.env, self.jni_id, x)
      end
      
      typesig { [::Java::Double, ::Java::Double] }
      # Returns the first floating-point argument with the sign of the
      # second floating-point argument.  For this method, a NaN
      # {@code sign} argument is always treated as if it were
      # positive.
      # 
      # @param magnitude  the parameter providing the magnitude of the result
      # @param sign   the parameter providing the sign of the result
      # @return a value with the magnitude of {@code magnitude}
      # and the sign of {@code sign}.
      # @since 1.6
      def copy_sign(magnitude, sign)
        return Sun::Misc::FpUtils.copy_sign(magnitude, sign)
      end
      
      typesig { [::Java::Float, ::Java::Float] }
      # Returns the first floating-point argument with the sign of the
      # second floating-point argument.  For this method, a NaN
      # {@code sign} argument is always treated as if it were
      # positive.
      # 
      # @param magnitude  the parameter providing the magnitude of the result
      # @param sign   the parameter providing the sign of the result
      # @return a value with the magnitude of {@code magnitude}
      # and the sign of {@code sign}.
      # @since 1.6
      def copy_sign(magnitude, sign)
        return Sun::Misc::FpUtils.copy_sign(magnitude, sign)
      end
      
      typesig { [::Java::Float] }
      # Returns the unbiased exponent used in the representation of a
      # {@code float}.  Special cases:
      # 
      # <ul>
      # <li>If the argument is NaN or infinite, then the result is
      # {@link Float#MAX_EXPONENT} + 1.
      # <li>If the argument is zero or subnormal, then the result is
      # {@link Float#MIN_EXPONENT} -1.
      # </ul>
      # @param f a {@code float} value
      # @since 1.6
      def get_exponent(f)
        return Sun::Misc::FpUtils.get_exponent(f)
      end
      
      typesig { [::Java::Double] }
      # Returns the unbiased exponent used in the representation of a
      # {@code double}.  Special cases:
      # 
      # <ul>
      # <li>If the argument is NaN or infinite, then the result is
      # {@link Double#MAX_EXPONENT} + 1.
      # <li>If the argument is zero or subnormal, then the result is
      # {@link Double#MIN_EXPONENT} -1.
      # </ul>
      # @param d a {@code double} value
      # @since 1.6
      def get_exponent(d)
        return Sun::Misc::FpUtils.get_exponent(d)
      end
      
      typesig { [::Java::Double, ::Java::Double] }
      # Returns the floating-point number adjacent to the first
      # argument in the direction of the second argument.  If both
      # arguments compare as equal the second argument is returned.
      # 
      # <p>Special cases:
      # <ul>
      # <li> If either argument is a NaN, then NaN is returned.
      # 
      # <li> If both arguments are signed zeros, {@code direction}
      # is returned unchanged (as implied by the requirement of
      # returning the second argument if the arguments compare as
      # equal).
      # 
      # <li> If {@code start} is
      # &plusmn;{@link Double#MIN_VALUE} and {@code direction}
      # has a value such that the result should have a smaller
      # magnitude, then a zero with the same sign as {@code start}
      # is returned.
      # 
      # <li> If {@code start} is infinite and
      # {@code direction} has a value such that the result should
      # have a smaller magnitude, {@link Double#MAX_VALUE} with the
      # same sign as {@code start} is returned.
      # 
      # <li> If {@code start} is equal to &plusmn;
      # {@link Double#MAX_VALUE} and {@code direction} has a
      # value such that the result should have a larger magnitude, an
      # infinity with same sign as {@code start} is returned.
      # </ul>
      # 
      # @param start  starting floating-point value
      # @param direction value indicating which of
      # {@code start}'s neighbors or {@code start} should
      # be returned
      # @return The floating-point number adjacent to {@code start} in the
      # direction of {@code direction}.
      # @since 1.6
      def next_after(start, direction)
        return Sun::Misc::FpUtils.next_after(start, direction)
      end
      
      typesig { [::Java::Float, ::Java::Double] }
      # Returns the floating-point number adjacent to the first
      # argument in the direction of the second argument.  If both
      # arguments compare as equal a value equivalent to the second argument
      # is returned.
      # 
      # <p>Special cases:
      # <ul>
      # <li> If either argument is a NaN, then NaN is returned.
      # 
      # <li> If both arguments are signed zeros, a value equivalent
      # to {@code direction} is returned.
      # 
      # <li> If {@code start} is
      # &plusmn;{@link Float#MIN_VALUE} and {@code direction}
      # has a value such that the result should have a smaller
      # magnitude, then a zero with the same sign as {@code start}
      # is returned.
      # 
      # <li> If {@code start} is infinite and
      # {@code direction} has a value such that the result should
      # have a smaller magnitude, {@link Float#MAX_VALUE} with the
      # same sign as {@code start} is returned.
      # 
      # <li> If {@code start} is equal to &plusmn;
      # {@link Float#MAX_VALUE} and {@code direction} has a
      # value such that the result should have a larger magnitude, an
      # infinity with same sign as {@code start} is returned.
      # </ul>
      # 
      # @param start  starting floating-point value
      # @param direction value indicating which of
      # {@code start}'s neighbors or {@code start} should
      # be returned
      # @return The floating-point number adjacent to {@code start} in the
      # direction of {@code direction}.
      # @since 1.6
      def next_after(start, direction)
        return Sun::Misc::FpUtils.next_after(start, direction)
      end
      
      typesig { [::Java::Double] }
      # Returns the floating-point value adjacent to {@code d} in
      # the direction of positive infinity.  This method is
      # semantically equivalent to {@code nextAfter(d,
      # Double.POSITIVE_INFINITY)}; however, a {@code nextUp}
      # implementation may run faster than its equivalent
      # {@code nextAfter} call.
      # 
      # <p>Special Cases:
      # <ul>
      # <li> If the argument is NaN, the result is NaN.
      # 
      # <li> If the argument is positive infinity, the result is
      # positive infinity.
      # 
      # <li> If the argument is zero, the result is
      # {@link Double#MIN_VALUE}
      # 
      # </ul>
      # 
      # @param d starting floating-point value
      # @return The adjacent floating-point value closer to positive
      # infinity.
      # @since 1.6
      def next_up(d)
        return Sun::Misc::FpUtils.next_up(d)
      end
      
      typesig { [::Java::Float] }
      # Returns the floating-point value adjacent to {@code f} in
      # the direction of positive infinity.  This method is
      # semantically equivalent to {@code nextAfter(f,
      # Float.POSITIVE_INFINITY)}; however, a {@code nextUp}
      # implementation may run faster than its equivalent
      # {@code nextAfter} call.
      # 
      # <p>Special Cases:
      # <ul>
      # <li> If the argument is NaN, the result is NaN.
      # 
      # <li> If the argument is positive infinity, the result is
      # positive infinity.
      # 
      # <li> If the argument is zero, the result is
      # {@link Float#MIN_VALUE}
      # 
      # </ul>
      # 
      # @param f starting floating-point value
      # @return The adjacent floating-point value closer to positive
      # infinity.
      # @since 1.6
      def next_up(f)
        return Sun::Misc::FpUtils.next_up(f)
      end
      
      typesig { [::Java::Double, ::Java::Int] }
      # Return {@code d} &times;
      # 2<sup>{@code scaleFactor}</sup> rounded as if performed
      # by a single correctly rounded floating-point multiply to a
      # member of the double value set.  See the Java
      # Language Specification for a discussion of floating-point
      # value sets.  If the exponent of the result is between {@link
      # Double#MIN_EXPONENT} and {@link Double#MAX_EXPONENT}, the
      # answer is calculated exactly.  If the exponent of the result
      # would be larger than {@code Double.MAX_EXPONENT}, an
      # infinity is returned.  Note that if the result is subnormal,
      # precision may be lost; that is, when {@code scalb(x, n)}
      # is subnormal, {@code scalb(scalb(x, n), -n)} may not equal
      # <i>x</i>.  When the result is non-NaN, the result has the same
      # sign as {@code d}.
      # 
      # <p>Special cases:
      # <ul>
      # <li> If the first argument is NaN, NaN is returned.
      # <li> If the first argument is infinite, then an infinity of the
      # same sign is returned.
      # <li> If the first argument is zero, then a zero of the same
      # sign is returned.
      # </ul>
      # 
      # @param d number to be scaled by a power of two.
      # @param scaleFactor power of 2 used to scale {@code d}
      # @return {@code d} &times; 2<sup>{@code scaleFactor}</sup>
      # @since 1.6
      def scalb(d, scale_factor)
        return Sun::Misc::FpUtils.scalb(d, scale_factor)
      end
      
      typesig { [::Java::Float, ::Java::Int] }
      # Return {@code f} &times;
      # 2<sup>{@code scaleFactor}</sup> rounded as if performed
      # by a single correctly rounded floating-point multiply to a
      # member of the float value set.  See the Java
      # Language Specification for a discussion of floating-point
      # value sets.  If the exponent of the result is between {@link
      # Float#MIN_EXPONENT} and {@link Float#MAX_EXPONENT}, the
      # answer is calculated exactly.  If the exponent of the result
      # would be larger than {@code Float.MAX_EXPONENT}, an
      # infinity is returned.  Note that if the result is subnormal,
      # precision may be lost; that is, when {@code scalb(x, n)}
      # is subnormal, {@code scalb(scalb(x, n), -n)} may not equal
      # <i>x</i>.  When the result is non-NaN, the result has the same
      # sign as {@code f}.
      # 
      # <p>Special cases:
      # <ul>
      # <li> If the first argument is NaN, NaN is returned.
      # <li> If the first argument is infinite, then an infinity of the
      # same sign is returned.
      # <li> If the first argument is zero, then a zero of the same
      # sign is returned.
      # </ul>
      # 
      # @param f number to be scaled by a power of two.
      # @param scaleFactor power of 2 used to scale {@code f}
      # @return {@code f} &times; 2<sup>{@code scaleFactor}</sup>
      # @since 1.6
      def scalb(f, scale_factor)
        return Sun::Misc::FpUtils.scalb(f, scale_factor)
      end
    }
    
    private
    alias_method :initialize__strict_math, :initialize
  end
  
end
