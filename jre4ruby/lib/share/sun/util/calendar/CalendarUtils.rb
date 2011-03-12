require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Util::Calendar
  module CalendarUtilsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
    }
  end
  
  class CalendarUtils 
    include_class_members CalendarUtilsImports
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Returns whether the specified year is a leap year in the Gregorian
      # calendar system.
      # 
      # @param gregorianYear a Gregorian calendar year
      # @return true if the given year is a leap year in the Gregorian
      # calendar system.
      # @see CalendarDate#isLeapYear
      def is_gregorian_leap_year(gregorian_year)
        return ((((gregorian_year % 4)).equal?(0)) && ((!((gregorian_year % 100)).equal?(0)) || (((gregorian_year % 400)).equal?(0))))
      end
      
      typesig { [::Java::Int] }
      # Returns whether the specified year is a leap year in the Julian
      # calendar system. The year number must be a normalized one
      # (e.g., 45 B.C.E. is 1-45).
      # 
      # @param normalizedJulianYear a normalized Julian calendar year
      # @return true if the given year is a leap year in the Julian
      # calendar system.
      # @see CalendarDate#isLeapYear
      def is_julian_leap_year(normalized_julian_year)
        return ((normalized_julian_year % 4)).equal?(0)
      end
      
      typesig { [::Java::Long, ::Java::Long] }
      # Divides two integers and returns the floor of the quotient.
      # For example, <code>floorDivide(-1, 4)</code> returns -1 while
      # -1/4 is 0.
      # 
      # @param n the numerator
      # @param d a divisor that must be greater than 0
      # @return the floor of the quotient
      def floor_divide(n, d)
        return ((n >= 0) ? (n / d) : (((n + 1) / d) - 1))
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Divides two integers and returns the floor of the quotient.
      # For example, <code>floorDivide(-1, 4)</code> returns -1 while
      # -1/4 is 0.
      # 
      # @param n the numerator
      # @param d a divisor that must be greater than 0
      # @return the floor of the quotient
      def floor_divide(n, d)
        return ((n >= 0) ? (n / d) : (((n + 1) / d) - 1))
      end
      
      typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Int)] }
      # Divides two integers and returns the floor of the quotient and
      # the modulus remainder.  For example,
      # <code>floorDivide(-1,4)</code> returns <code>-1</code> with
      # <code>3</code> as its remainder, while <code>-1/4</code> is
      # <code>0</code> and <code>-1%4</code> is <code>-1</code>.
      # 
      # @param n the numerator
      # @param d a divisor which must be > 0
      # @param r an array of at least one element in which the value
      # <code>mod(n, d)</code> is returned.
      # @return the floor of the quotient.
      def floor_divide(n, d, r)
        if (n >= 0)
          r[0] = n % d
          return n / d
        end
        q = ((n + 1) / d) - 1
        r[0] = n - (q * d)
        return q
      end
      
      typesig { [::Java::Long, ::Java::Int, Array.typed(::Java::Int)] }
      # Divides two integers and returns the floor of the quotient and
      # the modulus remainder.  For example,
      # <code>floorDivide(-1,4)</code> returns <code>-1</code> with
      # <code>3</code> as its remainder, while <code>-1/4</code> is
      # <code>0</code> and <code>-1%4</code> is <code>-1</code>.
      # 
      # @param n the numerator
      # @param d a divisor which must be > 0
      # @param r an array of at least one element in which the value
      # <code>mod(n, d)</code> is returned.
      # @return the floor of the quotient.
      def floor_divide(n, d, r)
        if (n >= 0)
          r[0] = ((n % d)).to_int
          return ((n / d)).to_int
        end
        q = ((((n + 1) / d) - 1)).to_int
        r[0] = ((n - (q * d))).to_int
        return q
      end
      
      typesig { [::Java::Long, ::Java::Long] }
      def mod(x, y)
        return (x - y * floor_divide(x, y))
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      def mod(x, y)
        return (x - y * floor_divide(x, y))
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      def amod(x, y)
        z = mod(x, y)
        return ((z).equal?(0)) ? y : z
      end
      
      typesig { [::Java::Long, ::Java::Long] }
      def amod(x, y)
        z = mod(x, y)
        return ((z).equal?(0)) ? y : z
      end
      
      typesig { [StringBuilder, ::Java::Int, ::Java::Int] }
      # Mimics sprintf(buf, "%0*d", decaimal, width).
      def sprintf0d(sb, value, width)
        d = value
        if (d < 0)
          sb.append(Character.new(?-.ord))
          d = -d
          (width -= 1)
        end
        n = 10
        i = 2
        while i < width
          n *= 10
          i += 1
        end
        i_ = 1
        while i_ < width && d < n
          sb.append(Character.new(?0.ord))
          n /= 10
          i_ += 1
        end
        sb.append(d)
        return sb
      end
      
      typesig { [StringBuffer, ::Java::Int, ::Java::Int] }
      def sprintf0d(sb, value, width)
        d = value
        if (d < 0)
          sb.append(Character.new(?-.ord))
          d = -d
          (width -= 1)
        end
        n = 10
        i = 2
        while i < width
          n *= 10
          i += 1
        end
        i_ = 1
        while i_ < width && d < n
          sb.append(Character.new(?0.ord))
          n /= 10
          i_ += 1
        end
        sb.append(d)
        return sb
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__calendar_utils, :initialize
  end
  
end
