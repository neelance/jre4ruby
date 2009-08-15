require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ArraysImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Lang::Reflect
    }
  end
  
  # This class contains various methods for manipulating arrays (such as
  # sorting and searching).  This class also contains a static factory
  # that allows arrays to be viewed as lists.
  # 
  # <p>The methods in this class all throw a <tt>NullPointerException</tt> if
  # the specified array reference is null, except where noted.
  # 
  # <p>The documentation for the methods contained in this class includes
  # briefs description of the <i>implementations</i>.  Such descriptions should
  # be regarded as <i>implementation notes</i>, rather than parts of the
  # <i>specification</i>.  Implementors should feel free to substitute other
  # algorithms, so long as the specification itself is adhered to.  (For
  # example, the algorithm used by <tt>sort(Object[])</tt> does not have to be
  # a mergesort, but it does have to be <i>stable</i>.)
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch
  # @author  Neal Gafter
  # @author  John Rose
  # @since   1.2
  class Arrays 
    include_class_members ArraysImports
    
    typesig { [] }
    # Suppresses default constructor, ensuring non-instantiability.
    def initialize
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Long)] }
      # Sorting
      # 
      # Sorts the specified array of longs into ascending numerical order.
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      def sort(a)
        sort1(a, 0, a.attr_length)
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
      # Sorts the specified range of the specified array of longs into
      # ascending numerical order.  The range to be sorted extends from index
      # <tt>fromIndex</tt>, inclusive, to index <tt>toIndex</tt>, exclusive.
      # (If <tt>fromIndex==toIndex</tt>, the range to be sorted is empty.)
      # 
      # <p>The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def sort(a, from_index, to_index)
        range_check(a.attr_length, from_index, to_index)
        sort1(a, from_index, to_index - from_index)
      end
      
      typesig { [Array.typed(::Java::Int)] }
      # Sorts the specified array of ints into ascending numerical order.
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      def sort(a)
        sort1(a, 0, a.attr_length)
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # Sorts the specified range of the specified array of ints into
      # ascending numerical order.  The range to be sorted extends from index
      # <tt>fromIndex</tt>, inclusive, to index <tt>toIndex</tt>, exclusive.
      # (If <tt>fromIndex==toIndex</tt>, the range to be sorted is empty.)<p>
      # 
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def sort(a, from_index, to_index)
        range_check(a.attr_length, from_index, to_index)
        sort1(a, from_index, to_index - from_index)
      end
      
      typesig { [Array.typed(::Java::Short)] }
      # Sorts the specified array of shorts into ascending numerical order.
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      def sort(a)
        sort1(a, 0, a.attr_length)
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int] }
      # Sorts the specified range of the specified array of shorts into
      # ascending numerical order.  The range to be sorted extends from index
      # <tt>fromIndex</tt>, inclusive, to index <tt>toIndex</tt>, exclusive.
      # (If <tt>fromIndex==toIndex</tt>, the range to be sorted is empty.)<p>
      # 
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def sort(a, from_index, to_index)
        range_check(a.attr_length, from_index, to_index)
        sort1(a, from_index, to_index - from_index)
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # Sorts the specified array of chars into ascending numerical order.
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      def sort(a)
        sort1(a, 0, a.attr_length)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Sorts the specified range of the specified array of chars into
      # ascending numerical order.  The range to be sorted extends from index
      # <tt>fromIndex</tt>, inclusive, to index <tt>toIndex</tt>, exclusive.
      # (If <tt>fromIndex==toIndex</tt>, the range to be sorted is empty.)<p>
      # 
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def sort(a, from_index, to_index)
        range_check(a.attr_length, from_index, to_index)
        sort1(a, from_index, to_index - from_index)
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Sorts the specified array of bytes into ascending numerical order.
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      def sort(a)
        sort1(a, 0, a.attr_length)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Sorts the specified range of the specified array of bytes into
      # ascending numerical order.  The range to be sorted extends from index
      # <tt>fromIndex</tt>, inclusive, to index <tt>toIndex</tt>, exclusive.
      # (If <tt>fromIndex==toIndex</tt>, the range to be sorted is empty.)<p>
      # 
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def sort(a, from_index, to_index)
        range_check(a.attr_length, from_index, to_index)
        sort1(a, from_index, to_index - from_index)
      end
      
      typesig { [Array.typed(::Java::Double)] }
      # Sorts the specified array of doubles into ascending numerical order.
      # <p>
      # The <code>&lt;</code> relation does not provide a total order on
      # all floating-point values; although they are distinct numbers
      # <code>-0.0 == 0.0</code> is <code>true</code> and a NaN value
      # compares neither less than, greater than, nor equal to any
      # floating-point value, even itself.  To allow the sort to
      # proceed, instead of using the <code>&lt;</code> relation to
      # determine ascending numerical order, this method uses the total
      # order imposed by {@link Double#compareTo}.  This ordering
      # differs from the <code>&lt;</code> relation in that
      # <code>-0.0</code> is treated as less than <code>0.0</code> and
      # NaN is considered greater than any other floating-point value.
      # For the purposes of sorting, all NaN values are considered
      # equivalent and equal.
      # <p>
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      def sort(a)
        sort2(a, 0, a.attr_length)
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int] }
      # Sorts the specified range of the specified array of doubles into
      # ascending numerical order.  The range to be sorted extends from index
      # <tt>fromIndex</tt>, inclusive, to index <tt>toIndex</tt>, exclusive.
      # (If <tt>fromIndex==toIndex</tt>, the range to be sorted is empty.)
      # <p>
      # The <code>&lt;</code> relation does not provide a total order on
      # all floating-point values; although they are distinct numbers
      # <code>-0.0 == 0.0</code> is <code>true</code> and a NaN value
      # compares neither less than, greater than, nor equal to any
      # floating-point value, even itself.  To allow the sort to
      # proceed, instead of using the <code>&lt;</code> relation to
      # determine ascending numerical order, this method uses the total
      # order imposed by {@link Double#compareTo}.  This ordering
      # differs from the <code>&lt;</code> relation in that
      # <code>-0.0</code> is treated as less than <code>0.0</code> and
      # NaN is considered greater than any other floating-point value.
      # For the purposes of sorting, all NaN values are considered
      # equivalent and equal.
      # <p>
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def sort(a, from_index, to_index)
        range_check(a.attr_length, from_index, to_index)
        sort2(a, from_index, to_index)
      end
      
      typesig { [Array.typed(::Java::Float)] }
      # Sorts the specified array of floats into ascending numerical order.
      # <p>
      # The <code>&lt;</code> relation does not provide a total order on
      # all floating-point values; although they are distinct numbers
      # <code>-0.0f == 0.0f</code> is <code>true</code> and a NaN value
      # compares neither less than, greater than, nor equal to any
      # floating-point value, even itself.  To allow the sort to
      # proceed, instead of using the <code>&lt;</code> relation to
      # determine ascending numerical order, this method uses the total
      # order imposed by {@link Float#compareTo}.  This ordering
      # differs from the <code>&lt;</code> relation in that
      # <code>-0.0f</code> is treated as less than <code>0.0f</code> and
      # NaN is considered greater than any other floating-point value.
      # For the purposes of sorting, all NaN values are considered
      # equivalent and equal.
      # <p>
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      def sort(a)
        sort2(a, 0, a.attr_length)
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
      # Sorts the specified range of the specified array of floats into
      # ascending numerical order.  The range to be sorted extends from index
      # <tt>fromIndex</tt>, inclusive, to index <tt>toIndex</tt>, exclusive.
      # (If <tt>fromIndex==toIndex</tt>, the range to be sorted is empty.)
      # <p>
      # The <code>&lt;</code> relation does not provide a total order on
      # all floating-point values; although they are distinct numbers
      # <code>-0.0f == 0.0f</code> is <code>true</code> and a NaN value
      # compares neither less than, greater than, nor equal to any
      # floating-point value, even itself.  To allow the sort to
      # proceed, instead of using the <code>&lt;</code> relation to
      # determine ascending numerical order, this method uses the total
      # order imposed by {@link Float#compareTo}.  This ordering
      # differs from the <code>&lt;</code> relation in that
      # <code>-0.0f</code> is treated as less than <code>0.0f</code> and
      # NaN is considered greater than any other floating-point value.
      # For the purposes of sorting, all NaN values are considered
      # equivalent and equal.
      # <p>
      # The sorting algorithm is a tuned quicksort, adapted from Jon
      # L. Bentley and M. Douglas McIlroy's "Engineering a Sort Function",
      # Software-Practice and Experience, Vol. 23(11) P. 1249-1265 (November
      # 1993).  This algorithm offers n*log(n) performance on many data sets
      # that cause other quicksorts to degrade to quadratic performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def sort(a, from_index, to_index)
        range_check(a.attr_length, from_index, to_index)
        sort2(a, from_index, to_index)
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int] }
      def sort2(a, from_index, to_index)
        neg_zero_bits = Double.double_to_long_bits(-0.0)
        # The sort is done in three phases to avoid the expense of using
        # NaN and -0.0 aware comparisons during the main sort.
        # 
        # 
        # Preprocessing phase:  Move any NaN's to end of array, count the
        # number of -0.0's, and turn them into 0.0's.
        num_neg_zeros = 0
        i = from_index
        n = to_index
        while (i < n)
          if (!(a[i]).equal?(a[i]))
            swap(a, i, (n -= 1))
          else
            if ((a[i]).equal?(0) && (Double.double_to_long_bits(a[i])).equal?(neg_zero_bits))
              a[i] = 0.0
              num_neg_zeros += 1
            end
            i += 1
          end
        end
        # Main sort phase: quicksort everything but the NaN's
        sort1(a, from_index, n - from_index)
        # Postprocessing phase: change 0.0's to -0.0's as required
        if (!(num_neg_zeros).equal?(0))
          j = binary_search0(a, from_index, n, 0.0) # posn of ANY zero
          begin
            j -= 1
          end while (j >= from_index && (a[j]).equal?(0.0))
          # j is now one less than the index of the FIRST zero
          k = 0
          while k < num_neg_zeros
            a[(j += 1)] = -0.0
            k += 1
          end
        end
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
      def sort2(a, from_index, to_index)
        neg_zero_bits = Float.float_to_int_bits(-0.0)
        # The sort is done in three phases to avoid the expense of using
        # NaN and -0.0 aware comparisons during the main sort.
        # 
        # 
        # Preprocessing phase:  Move any NaN's to end of array, count the
        # number of -0.0's, and turn them into 0.0's.
        num_neg_zeros = 0
        i = from_index
        n = to_index
        while (i < n)
          if (!(a[i]).equal?(a[i]))
            swap(a, i, (n -= 1))
          else
            if ((a[i]).equal?(0) && (Float.float_to_int_bits(a[i])).equal?(neg_zero_bits))
              a[i] = 0.0
              num_neg_zeros += 1
            end
            i += 1
          end
        end
        # Main sort phase: quicksort everything but the NaN's
        sort1(a, from_index, n - from_index)
        # Postprocessing phase: change 0.0's to -0.0's as required
        if (!(num_neg_zeros).equal?(0))
          j = binary_search0(a, from_index, n, 0.0) # posn of ANY zero
          begin
            j -= 1
          end while (j >= from_index && (a[j]).equal?(0.0))
          # j is now one less than the index of the FIRST zero
          k = 0
          while k < num_neg_zeros
            a[(j += 1)] = -0.0
            k += 1
          end
        end
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
      # The code for each of the seven primitive types is largely identical.
      # C'est la vie.
      # 
      # 
      # Sorts the specified sub-array of longs into ascending order.
      def sort1(x, off, len)
        # Insertion sort on smallest arrays
        if (len < 7)
          i = off
          while i < len + off
            j = i
            while j > off && x[j - 1] > x[j]
              swap(x, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Choose a partition element, v
        m = off + (len >> 1) # Small arrays, middle element
        if (len > 7)
          l = off
          n = off + len - 1
          if (len > 40)
            # Big arrays, pseudomedian of 9
            s = len / 8
            l = med3(x, l, l + s, l + 2 * s)
            m = med3(x, m - s, m, m + s)
            n = med3(x, n - 2 * s, n - s, n)
          end
          m = med3(x, l, m, n) # Mid-size, med of 3
        end
        v = x[m]
        # Establish Invariant: v* (<v)* (>v)* v*
        a = off
        b = a
        c = off + len - 1
        d = c
        while (true)
          while (b <= c && x[b] <= v)
            if ((x[b]).equal?(v))
              swap(x, ((a += 1) - 1), b)
            end
            b += 1
          end
          while (c >= b && x[c] >= v)
            if ((x[c]).equal?(v))
              swap(x, c, ((d -= 1) + 1))
            end
            c -= 1
          end
          if (b > c)
            break
          end
          swap(x, ((b += 1) - 1), ((c -= 1) + 1))
        end
        # Swap partition elements back to middle
        s = 0
        n = off + len
        s = Math.min(a - off, b - a)
        vecswap(x, off, b - s, s)
        s = Math.min(d - c, n - d - 1)
        vecswap(x, b, n - s, s)
        # Recursively sort non-partition-elements
        if ((s = b - a) > 1)
          sort1(x, off, s)
        end
        if ((s = d - c) > 1)
          sort1(x, n - s, s)
        end
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
      # Swaps x[a] with x[b].
      def swap(x, a, b)
        t = x[a]
        x[a] = x[b]
        x[b] = t
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Swaps x[a .. (a+n-1)] with x[b .. (b+n-1)].
      def vecswap(x, a, b, n)
        i = 0
        while i < n
          swap(x, a, b)
          i += 1
          a += 1
          b += 1
        end
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the index of the median of the three indexed longs.
      def med3(x, a, b, c)
        return (x[a] < x[b] ? (x[b] < x[c] ? b : x[a] < x[c] ? c : a) : (x[b] > x[c] ? b : x[a] > x[c] ? c : a))
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # Sorts the specified sub-array of integers into ascending order.
      def sort1(x, off, len)
        # Insertion sort on smallest arrays
        if (len < 7)
          i = off
          while i < len + off
            j = i
            while j > off && x[j - 1] > x[j]
              swap(x, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Choose a partition element, v
        m = off + (len >> 1) # Small arrays, middle element
        if (len > 7)
          l = off
          n = off + len - 1
          if (len > 40)
            # Big arrays, pseudomedian of 9
            s = len / 8
            l = med3(x, l, l + s, l + 2 * s)
            m = med3(x, m - s, m, m + s)
            n = med3(x, n - 2 * s, n - s, n)
          end
          m = med3(x, l, m, n) # Mid-size, med of 3
        end
        v = x[m]
        # Establish Invariant: v* (<v)* (>v)* v*
        a = off
        b = a
        c = off + len - 1
        d = c
        while (true)
          while (b <= c && x[b] <= v)
            if ((x[b]).equal?(v))
              swap(x, ((a += 1) - 1), b)
            end
            b += 1
          end
          while (c >= b && x[c] >= v)
            if ((x[c]).equal?(v))
              swap(x, c, ((d -= 1) + 1))
            end
            c -= 1
          end
          if (b > c)
            break
          end
          swap(x, ((b += 1) - 1), ((c -= 1) + 1))
        end
        # Swap partition elements back to middle
        s = 0
        n = off + len
        s = Math.min(a - off, b - a)
        vecswap(x, off, b - s, s)
        s = Math.min(d - c, n - d - 1)
        vecswap(x, b, n - s, s)
        # Recursively sort non-partition-elements
        if ((s = b - a) > 1)
          sort1(x, off, s)
        end
        if ((s = d - c) > 1)
          sort1(x, n - s, s)
        end
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # Swaps x[a] with x[b].
      def swap(x, a, b)
        t = x[a]
        x[a] = x[b]
        x[b] = t
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Swaps x[a .. (a+n-1)] with x[b .. (b+n-1)].
      def vecswap(x, a, b, n)
        i = 0
        while i < n
          swap(x, a, b)
          i += 1
          a += 1
          b += 1
        end
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the index of the median of the three indexed integers.
      def med3(x, a, b, c)
        return (x[a] < x[b] ? (x[b] < x[c] ? b : x[a] < x[c] ? c : a) : (x[b] > x[c] ? b : x[a] > x[c] ? c : a))
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int] }
      # Sorts the specified sub-array of shorts into ascending order.
      def sort1(x, off, len)
        # Insertion sort on smallest arrays
        if (len < 7)
          i = off
          while i < len + off
            j = i
            while j > off && x[j - 1] > x[j]
              swap(x, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Choose a partition element, v
        m = off + (len >> 1) # Small arrays, middle element
        if (len > 7)
          l = off
          n = off + len - 1
          if (len > 40)
            # Big arrays, pseudomedian of 9
            s = len / 8
            l = med3(x, l, l + s, l + 2 * s)
            m = med3(x, m - s, m, m + s)
            n = med3(x, n - 2 * s, n - s, n)
          end
          m = med3(x, l, m, n) # Mid-size, med of 3
        end
        v = x[m]
        # Establish Invariant: v* (<v)* (>v)* v*
        a = off
        b = a
        c = off + len - 1
        d = c
        while (true)
          while (b <= c && x[b] <= v)
            if ((x[b]).equal?(v))
              swap(x, ((a += 1) - 1), b)
            end
            b += 1
          end
          while (c >= b && x[c] >= v)
            if ((x[c]).equal?(v))
              swap(x, c, ((d -= 1) + 1))
            end
            c -= 1
          end
          if (b > c)
            break
          end
          swap(x, ((b += 1) - 1), ((c -= 1) + 1))
        end
        # Swap partition elements back to middle
        s = 0
        n = off + len
        s = Math.min(a - off, b - a)
        vecswap(x, off, b - s, s)
        s = Math.min(d - c, n - d - 1)
        vecswap(x, b, n - s, s)
        # Recursively sort non-partition-elements
        if ((s = b - a) > 1)
          sort1(x, off, s)
        end
        if ((s = d - c) > 1)
          sort1(x, n - s, s)
        end
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int] }
      # Swaps x[a] with x[b].
      def swap(x, a, b)
        t = x[a]
        x[a] = x[b]
        x[b] = t
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Swaps x[a .. (a+n-1)] with x[b .. (b+n-1)].
      def vecswap(x, a, b, n)
        i = 0
        while i < n
          swap(x, a, b)
          i += 1
          a += 1
          b += 1
        end
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the index of the median of the three indexed shorts.
      def med3(x, a, b, c)
        return (x[a] < x[b] ? (x[b] < x[c] ? b : x[a] < x[c] ? c : a) : (x[b] > x[c] ? b : x[a] > x[c] ? c : a))
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Sorts the specified sub-array of chars into ascending order.
      def sort1(x, off, len)
        # Insertion sort on smallest arrays
        if (len < 7)
          i = off
          while i < len + off
            j = i
            while j > off && x[j - 1] > x[j]
              swap(x, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Choose a partition element, v
        m = off + (len >> 1) # Small arrays, middle element
        if (len > 7)
          l = off
          n = off + len - 1
          if (len > 40)
            # Big arrays, pseudomedian of 9
            s = len / 8
            l = med3(x, l, l + s, l + 2 * s)
            m = med3(x, m - s, m, m + s)
            n = med3(x, n - 2 * s, n - s, n)
          end
          m = med3(x, l, m, n) # Mid-size, med of 3
        end
        v = x[m]
        # Establish Invariant: v* (<v)* (>v)* v*
        a = off
        b = a
        c = off + len - 1
        d = c
        while (true)
          while (b <= c && x[b] <= v)
            if ((x[b]).equal?(v))
              swap(x, ((a += 1) - 1), b)
            end
            b += 1
          end
          while (c >= b && x[c] >= v)
            if ((x[c]).equal?(v))
              swap(x, c, ((d -= 1) + 1))
            end
            c -= 1
          end
          if (b > c)
            break
          end
          swap(x, ((b += 1) - 1), ((c -= 1) + 1))
        end
        # Swap partition elements back to middle
        s = 0
        n = off + len
        s = Math.min(a - off, b - a)
        vecswap(x, off, b - s, s)
        s = Math.min(d - c, n - d - 1)
        vecswap(x, b, n - s, s)
        # Recursively sort non-partition-elements
        if ((s = b - a) > 1)
          sort1(x, off, s)
        end
        if ((s = d - c) > 1)
          sort1(x, n - s, s)
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Swaps x[a] with x[b].
      def swap(x, a, b)
        t = x[a]
        x[a] = x[b]
        x[b] = t
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Swaps x[a .. (a+n-1)] with x[b .. (b+n-1)].
      def vecswap(x, a, b, n)
        i = 0
        while i < n
          swap(x, a, b)
          i += 1
          a += 1
          b += 1
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the index of the median of the three indexed chars.
      def med3(x, a, b, c)
        return (x[a] < x[b] ? (x[b] < x[c] ? b : x[a] < x[c] ? c : a) : (x[b] > x[c] ? b : x[a] > x[c] ? c : a))
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Sorts the specified sub-array of bytes into ascending order.
      def sort1(x, off, len)
        # Insertion sort on smallest arrays
        if (len < 7)
          i = off
          while i < len + off
            j = i
            while j > off && x[j - 1] > x[j]
              swap(x, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Choose a partition element, v
        m = off + (len >> 1) # Small arrays, middle element
        if (len > 7)
          l = off
          n = off + len - 1
          if (len > 40)
            # Big arrays, pseudomedian of 9
            s = len / 8
            l = med3(x, l, l + s, l + 2 * s)
            m = med3(x, m - s, m, m + s)
            n = med3(x, n - 2 * s, n - s, n)
          end
          m = med3(x, l, m, n) # Mid-size, med of 3
        end
        v = x[m]
        # Establish Invariant: v* (<v)* (>v)* v*
        a = off
        b = a
        c = off + len - 1
        d = c
        while (true)
          while (b <= c && x[b] <= v)
            if ((x[b]).equal?(v))
              swap(x, ((a += 1) - 1), b)
            end
            b += 1
          end
          while (c >= b && x[c] >= v)
            if ((x[c]).equal?(v))
              swap(x, c, ((d -= 1) + 1))
            end
            c -= 1
          end
          if (b > c)
            break
          end
          swap(x, ((b += 1) - 1), ((c -= 1) + 1))
        end
        # Swap partition elements back to middle
        s = 0
        n = off + len
        s = Math.min(a - off, b - a)
        vecswap(x, off, b - s, s)
        s = Math.min(d - c, n - d - 1)
        vecswap(x, b, n - s, s)
        # Recursively sort non-partition-elements
        if ((s = b - a) > 1)
          sort1(x, off, s)
        end
        if ((s = d - c) > 1)
          sort1(x, n - s, s)
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Swaps x[a] with x[b].
      def swap(x, a, b)
        t = x[a]
        x[a] = x[b]
        x[b] = t
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Swaps x[a .. (a+n-1)] with x[b .. (b+n-1)].
      def vecswap(x, a, b, n)
        i = 0
        while i < n
          swap(x, a, b)
          i += 1
          a += 1
          b += 1
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the index of the median of the three indexed bytes.
      def med3(x, a, b, c)
        return (x[a] < x[b] ? (x[b] < x[c] ? b : x[a] < x[c] ? c : a) : (x[b] > x[c] ? b : x[a] > x[c] ? c : a))
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int] }
      # Sorts the specified sub-array of doubles into ascending order.
      def sort1(x, off, len)
        # Insertion sort on smallest arrays
        if (len < 7)
          i = off
          while i < len + off
            j = i
            while j > off && x[j - 1] > x[j]
              swap(x, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Choose a partition element, v
        m = off + (len >> 1) # Small arrays, middle element
        if (len > 7)
          l = off
          n = off + len - 1
          if (len > 40)
            # Big arrays, pseudomedian of 9
            s = len / 8
            l = med3(x, l, l + s, l + 2 * s)
            m = med3(x, m - s, m, m + s)
            n = med3(x, n - 2 * s, n - s, n)
          end
          m = med3(x, l, m, n) # Mid-size, med of 3
        end
        v = x[m]
        # Establish Invariant: v* (<v)* (>v)* v*
        a = off
        b = a
        c = off + len - 1
        d = c
        while (true)
          while (b <= c && x[b] <= v)
            if ((x[b]).equal?(v))
              swap(x, ((a += 1) - 1), b)
            end
            b += 1
          end
          while (c >= b && x[c] >= v)
            if ((x[c]).equal?(v))
              swap(x, c, ((d -= 1) + 1))
            end
            c -= 1
          end
          if (b > c)
            break
          end
          swap(x, ((b += 1) - 1), ((c -= 1) + 1))
        end
        # Swap partition elements back to middle
        s = 0
        n = off + len
        s = Math.min(a - off, b - a)
        vecswap(x, off, b - s, s)
        s = Math.min(d - c, n - d - 1)
        vecswap(x, b, n - s, s)
        # Recursively sort non-partition-elements
        if ((s = b - a) > 1)
          sort1(x, off, s)
        end
        if ((s = d - c) > 1)
          sort1(x, n - s, s)
        end
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int] }
      # Swaps x[a] with x[b].
      def swap(x, a, b)
        t = x[a]
        x[a] = x[b]
        x[b] = t
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Swaps x[a .. (a+n-1)] with x[b .. (b+n-1)].
      def vecswap(x, a, b, n)
        i = 0
        while i < n
          swap(x, a, b)
          i += 1
          a += 1
          b += 1
        end
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the index of the median of the three indexed doubles.
      def med3(x, a, b, c)
        return (x[a] < x[b] ? (x[b] < x[c] ? b : x[a] < x[c] ? c : a) : (x[b] > x[c] ? b : x[a] > x[c] ? c : a))
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
      # Sorts the specified sub-array of floats into ascending order.
      def sort1(x, off, len)
        # Insertion sort on smallest arrays
        if (len < 7)
          i = off
          while i < len + off
            j = i
            while j > off && x[j - 1] > x[j]
              swap(x, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Choose a partition element, v
        m = off + (len >> 1) # Small arrays, middle element
        if (len > 7)
          l = off
          n = off + len - 1
          if (len > 40)
            # Big arrays, pseudomedian of 9
            s = len / 8
            l = med3(x, l, l + s, l + 2 * s)
            m = med3(x, m - s, m, m + s)
            n = med3(x, n - 2 * s, n - s, n)
          end
          m = med3(x, l, m, n) # Mid-size, med of 3
        end
        v = x[m]
        # Establish Invariant: v* (<v)* (>v)* v*
        a = off
        b = a
        c = off + len - 1
        d = c
        while (true)
          while (b <= c && x[b] <= v)
            if ((x[b]).equal?(v))
              swap(x, ((a += 1) - 1), b)
            end
            b += 1
          end
          while (c >= b && x[c] >= v)
            if ((x[c]).equal?(v))
              swap(x, c, ((d -= 1) + 1))
            end
            c -= 1
          end
          if (b > c)
            break
          end
          swap(x, ((b += 1) - 1), ((c -= 1) + 1))
        end
        # Swap partition elements back to middle
        s = 0
        n = off + len
        s = Math.min(a - off, b - a)
        vecswap(x, off, b - s, s)
        s = Math.min(d - c, n - d - 1)
        vecswap(x, b, n - s, s)
        # Recursively sort non-partition-elements
        if ((s = b - a) > 1)
          sort1(x, off, s)
        end
        if ((s = d - c) > 1)
          sort1(x, n - s, s)
        end
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
      # Swaps x[a] with x[b].
      def swap(x, a, b)
        t = x[a]
        x[a] = x[b]
        x[b] = t
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Swaps x[a .. (a+n-1)] with x[b .. (b+n-1)].
      def vecswap(x, a, b, n)
        i = 0
        while i < n
          swap(x, a, b)
          i += 1
          a += 1
          b += 1
        end
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns the index of the median of the three indexed floats.
      def med3(x, a, b, c)
        return (x[a] < x[b] ? (x[b] < x[c] ? b : x[a] < x[c] ? c : a) : (x[b] > x[c] ? b : x[a] > x[c] ? c : a))
      end
      
      typesig { [Array.typed(Object)] }
      # Sorts the specified array of objects into ascending order, according to
      # the {@linkplain Comparable natural ordering}
      # of its elements.  All elements in the array
      # must implement the {@link Comparable} interface.  Furthermore, all
      # elements in the array must be <i>mutually comparable</i> (that is,
      # <tt>e1.compareTo(e2)</tt> must not throw a <tt>ClassCastException</tt>
      # for any elements <tt>e1</tt> and <tt>e2</tt> in the array).<p>
      # 
      # This sort is guaranteed to be <i>stable</i>:  equal elements will
      # not be reordered as a result of the sort.<p>
      # 
      # The sorting algorithm is a modified mergesort (in which the merge is
      # omitted if the highest element in the low sublist is less than the
      # lowest element in the high sublist).  This algorithm offers guaranteed
      # n*log(n) performance.
      # 
      # @param a the array to be sorted
      # @throws  ClassCastException if the array contains elements that are not
      # <i>mutually comparable</i> (for example, strings and integers).
      def sort(a)
        aux = a.clone
        merge_sort(aux, a, 0, a.attr_length, 0)
      end
      
      typesig { [Array.typed(Object), ::Java::Int, ::Java::Int] }
      # Sorts the specified range of the specified array of objects into
      # ascending order, according to the
      # {@linkplain Comparable natural ordering} of its
      # elements.  The range to be sorted extends from index
      # <tt>fromIndex</tt>, inclusive, to index <tt>toIndex</tt>, exclusive.
      # (If <tt>fromIndex==toIndex</tt>, the range to be sorted is empty.)  All
      # elements in this range must implement the {@link Comparable}
      # interface.  Furthermore, all elements in this range must be <i>mutually
      # comparable</i> (that is, <tt>e1.compareTo(e2)</tt> must not throw a
      # <tt>ClassCastException</tt> for any elements <tt>e1</tt> and
      # <tt>e2</tt> in the array).<p>
      # 
      # This sort is guaranteed to be <i>stable</i>:  equal elements will
      # not be reordered as a result of the sort.<p>
      # 
      # The sorting algorithm is a modified mergesort (in which the merge is
      # omitted if the highest element in the low sublist is less than the
      # lowest element in the high sublist).  This algorithm offers guaranteed
      # n*log(n) performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      # @throws    ClassCastException if the array contains elements that are
      # not <i>mutually comparable</i> (for example, strings and
      # integers).
      def sort(a, from_index, to_index)
        range_check(a.attr_length, from_index, to_index)
        aux = copy_of_range(a, from_index, to_index)
        merge_sort(aux, a, from_index, to_index, -from_index)
      end
      
      # Tuning parameter: list size at or below which insertion sort will be
      # used in preference to mergesort or quicksort.
      const_set_lazy(:INSERTIONSORT_THRESHOLD) { 7 }
      const_attr_reader  :INSERTIONSORT_THRESHOLD
      
      typesig { [Array.typed(Object), Array.typed(Object), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Src is the source array that starts at index 0
      # Dest is the (possibly larger) array destination with a possible offset
      # low is the index in dest to start sorting
      # high is the end index in dest to end sorting
      # off is the offset to generate corresponding low, high in src
      def merge_sort(src, dest, low, high, off)
        length = high - low
        # Insertion sort on smallest arrays
        if (length < INSERTIONSORT_THRESHOLD)
          i = low
          while i < high
            j = i
            while j > low && ((dest[j - 1]) <=> dest[j]) > 0
              swap(dest, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Recursively sort halves of dest into src
        dest_low = low
        dest_high = high
        low += off
        high += off
        mid = (low + high) >> 1
        merge_sort(dest, src, low, mid, -off)
        merge_sort(dest, src, mid, high, -off)
        # If list is already sorted, just copy from src to dest.  This is an
        # optimization that results in faster sorts for nearly ordered lists.
        if (((src[mid - 1]) <=> src[mid]) <= 0)
          System.arraycopy(src, low, dest, dest_low, length)
          return
        end
        # Merge sorted halves (now in src) into dest
        i = dest_low
        p = low
        q = mid
        while i < dest_high
          if (q >= high || p < mid && ((src[p]) <=> src[q]) <= 0)
            dest[i] = src[((p += 1) - 1)]
          else
            dest[i] = src[((q += 1) - 1)]
          end
          i += 1
        end
      end
      
      typesig { [Array.typed(Object), ::Java::Int, ::Java::Int] }
      # Swaps x[a] with x[b].
      def swap(x, a, b)
        t = x[a]
        x[a] = x[b]
        x[b] = t
      end
      
      typesig { [Array.typed(T), Comparator] }
      # Sorts the specified array of objects according to the order induced by
      # the specified comparator.  All elements in the array must be
      # <i>mutually comparable</i> by the specified comparator (that is,
      # <tt>c.compare(e1, e2)</tt> must not throw a <tt>ClassCastException</tt>
      # for any elements <tt>e1</tt> and <tt>e2</tt> in the array).<p>
      # 
      # This sort is guaranteed to be <i>stable</i>:  equal elements will
      # not be reordered as a result of the sort.<p>
      # 
      # The sorting algorithm is a modified mergesort (in which the merge is
      # omitted if the highest element in the low sublist is less than the
      # lowest element in the high sublist).  This algorithm offers guaranteed
      # n*log(n) performance.
      # 
      # @param a the array to be sorted
      # @param c the comparator to determine the order of the array.  A
      # <tt>null</tt> value indicates that the elements'
      # {@linkplain Comparable natural ordering} should be used.
      # @throws  ClassCastException if the array contains elements that are
      # not <i>mutually comparable</i> using the specified comparator.
      def sort(a, c)
        aux = a.clone
        if ((c).nil?)
          merge_sort(aux, a, 0, a.attr_length, 0)
        else
          merge_sort(aux, a, 0, a.attr_length, 0, c)
        end
      end
      
      typesig { [Array.typed(T), ::Java::Int, ::Java::Int, Comparator] }
      # Sorts the specified range of the specified array of objects according
      # to the order induced by the specified comparator.  The range to be
      # sorted extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be sorted is empty.)  All elements in the range must be
      # <i>mutually comparable</i> by the specified comparator (that is,
      # <tt>c.compare(e1, e2)</tt> must not throw a <tt>ClassCastException</tt>
      # for any elements <tt>e1</tt> and <tt>e2</tt> in the range).<p>
      # 
      # This sort is guaranteed to be <i>stable</i>:  equal elements will
      # not be reordered as a result of the sort.<p>
      # 
      # The sorting algorithm is a modified mergesort (in which the merge is
      # omitted if the highest element in the low sublist is less than the
      # lowest element in the high sublist).  This algorithm offers guaranteed
      # n*log(n) performance.
      # 
      # @param a the array to be sorted
      # @param fromIndex the index of the first element (inclusive) to be
      # sorted
      # @param toIndex the index of the last element (exclusive) to be sorted
      # @param c the comparator to determine the order of the array.  A
      # <tt>null</tt> value indicates that the elements'
      # {@linkplain Comparable natural ordering} should be used.
      # @throws ClassCastException if the array contains elements that are not
      # <i>mutually comparable</i> using the specified comparator.
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def sort(a, from_index, to_index, c)
        range_check(a.attr_length, from_index, to_index)
        aux = copy_of_range(a, from_index, to_index)
        if ((c).nil?)
          merge_sort(aux, a, from_index, to_index, -from_index)
        else
          merge_sort(aux, a, from_index, to_index, -from_index, c)
        end
      end
      
      typesig { [Array.typed(Object), Array.typed(Object), ::Java::Int, ::Java::Int, ::Java::Int, Comparator] }
      # Src is the source array that starts at index 0
      # Dest is the (possibly larger) array destination with a possible offset
      # low is the index in dest to start sorting
      # high is the end index in dest to end sorting
      # off is the offset into src corresponding to low in dest
      def merge_sort(src, dest, low, high, off, c)
        length = high - low
        # Insertion sort on smallest arrays
        if (length < INSERTIONSORT_THRESHOLD)
          i = low
          while i < high
            j = i
            while j > low && c.compare(dest[j - 1], dest[j]) > 0
              swap(dest, j, j - 1)
              j -= 1
            end
            i += 1
          end
          return
        end
        # Recursively sort halves of dest into src
        dest_low = low
        dest_high = high
        low += off
        high += off
        mid = (low + high) >> 1
        merge_sort(dest, src, low, mid, -off, c)
        merge_sort(dest, src, mid, high, -off, c)
        # If list is already sorted, just copy from src to dest.  This is an
        # optimization that results in faster sorts for nearly ordered lists.
        if (c.compare(src[mid - 1], src[mid]) <= 0)
          System.arraycopy(src, low, dest, dest_low, length)
          return
        end
        # Merge sorted halves (now in src) into dest
        i = dest_low
        p = low
        q = mid
        while i < dest_high
          if (q >= high || p < mid && c.compare(src[p], src[q]) <= 0)
            dest[i] = src[((p += 1) - 1)]
          else
            dest[i] = src[((q += 1) - 1)]
          end
          i += 1
        end
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      # Check that fromIndex and toIndex are in range, and throw an
      # appropriate exception if they aren't.
      def range_check(array_len, from_index, to_index)
        if (from_index > to_index)
          raise IllegalArgumentException.new("fromIndex(" + RJava.cast_to_string(from_index) + ") > toIndex(" + RJava.cast_to_string(to_index) + ")")
        end
        if (from_index < 0)
          raise ArrayIndexOutOfBoundsException.new(from_index)
        end
        if (to_index > array_len)
          raise ArrayIndexOutOfBoundsException.new(to_index)
        end
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Long] }
      # Searching
      # 
      # Searches the specified array of longs for the specified value using the
      # binary search algorithm.  The array must be sorted (as
      # by the {@link #sort(long[])} method) prior to making this call.  If it
      # is not sorted, the results are undefined.  If the array contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      def binary_search(a, key)
        return binary_search0(a, 0, a.attr_length, key)
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int, ::Java::Long] }
      # Searches a range of
      # the specified array of longs for the specified value using the
      # binary search algorithm.
      # The range must be sorted (as
      # by the {@link #sort(long[], int, int)} method)
      # prior to making this call.  If it
      # is not sorted, the results are undefined.  If the range contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key)
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int, ::Java::Long] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key)
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          if (mid_val < key)
            low = mid + 1
          else
            if (mid_val > key)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int] }
      # Searches the specified array of ints for the specified value using the
      # binary search algorithm.  The array must be sorted (as
      # by the {@link #sort(int[])} method) prior to making this call.  If it
      # is not sorted, the results are undefined.  If the array contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      def binary_search(a, key)
        return binary_search0(a, 0, a.attr_length, key)
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Searches a range of
      # the specified array of ints for the specified value using the
      # binary search algorithm.
      # The range must be sorted (as
      # by the {@link #sort(int[], int, int)} method)
      # prior to making this call.  If it
      # is not sorted, the results are undefined.  If the range contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key)
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key)
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          if (mid_val < key)
            low = mid + 1
          else
            if (mid_val > key)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Short] }
      # Searches the specified array of shorts for the specified value using
      # the binary search algorithm.  The array must be sorted
      # (as by the {@link #sort(short[])} method) prior to making this call.  If
      # it is not sorted, the results are undefined.  If the array contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      def binary_search(a, key)
        return binary_search0(a, 0, a.attr_length, key)
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int, ::Java::Short] }
      # Searches a range of
      # the specified array of shorts for the specified value using
      # the binary search algorithm.
      # The range must be sorted
      # (as by the {@link #sort(short[], int, int)} method)
      # prior to making this call.  If
      # it is not sorted, the results are undefined.  If the range contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key)
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int, ::Java::Short] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key)
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          if (mid_val < key)
            low = mid + 1
          else
            if (mid_val > key)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Char] }
      # Searches the specified array of chars for the specified value using the
      # binary search algorithm.  The array must be sorted (as
      # by the {@link #sort(char[])} method) prior to making this call.  If it
      # is not sorted, the results are undefined.  If the array contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      def binary_search(a, key)
        return binary_search0(a, 0, a.attr_length, key)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Char] }
      # Searches a range of
      # the specified array of chars for the specified value using the
      # binary search algorithm.
      # The range must be sorted (as
      # by the {@link #sort(char[], int, int)} method)
      # prior to making this call.  If it
      # is not sorted, the results are undefined.  If the range contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key)
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Char] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key)
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          if (mid_val < key)
            low = mid + 1
          else
            if (mid_val > key)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Byte] }
      # Searches the specified array of bytes for the specified value using the
      # binary search algorithm.  The array must be sorted (as
      # by the {@link #sort(byte[])} method) prior to making this call.  If it
      # is not sorted, the results are undefined.  If the array contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      def binary_search(a, key)
        return binary_search0(a, 0, a.attr_length, key)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Byte] }
      # Searches a range of
      # the specified array of bytes for the specified value using the
      # binary search algorithm.
      # The range must be sorted (as
      # by the {@link #sort(byte[], int, int)} method)
      # prior to making this call.  If it
      # is not sorted, the results are undefined.  If the range contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Byte] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key)
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          if (mid_val < key)
            low = mid + 1
          else
            if (mid_val > key)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Double] }
      # Searches the specified array of doubles for the specified value using
      # the binary search algorithm.  The array must be sorted
      # (as by the {@link #sort(double[])} method) prior to making this call.
      # If it is not sorted, the results are undefined.  If the array contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.  This method considers all NaN values to be
      # equivalent and equal.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      def binary_search(a, key)
        return binary_search0(a, 0, a.attr_length, key)
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int, ::Java::Double] }
      # Searches a range of
      # the specified array of doubles for the specified value using
      # the binary search algorithm.
      # The range must be sorted
      # (as by the {@link #sort(double[], int, int)} method)
      # prior to making this call.
      # If it is not sorted, the results are undefined.  If the range contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.  This method considers all NaN values to be
      # equivalent and equal.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key)
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int, ::Java::Double] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key)
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          if (mid_val < key)
            low = mid + 1
             # Neither val is NaN, thisVal is smaller
          else
            if (mid_val > key)
              high = mid - 1
               # Neither val is NaN, thisVal is larger
            else
              mid_bits = Double.double_to_long_bits(mid_val)
              key_bits = Double.double_to_long_bits(key)
              if ((mid_bits).equal?(key_bits))
                # Values are equal
                return mid
                 # Key found
              else
                if (mid_bits < key_bits)
                  # (-0.0, 0.0) or (!NaN, NaN)
                  low = mid + 1
                else
                  # (0.0, -0.0) or (NaN, !NaN)
                  high = mid - 1
                end
              end
            end
          end
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Float] }
      # Searches the specified array of floats for the specified value using
      # the binary search algorithm.  The array must be sorted
      # (as by the {@link #sort(float[])} method) prior to making this call.  If
      # it is not sorted, the results are undefined.  If the array contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.  This method considers all NaN values to be
      # equivalent and equal.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      def binary_search(a, key)
        return binary_search0(a, 0, a.attr_length, key)
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int, ::Java::Float] }
      # Searches a range of
      # the specified array of floats for the specified value using
      # the binary search algorithm.
      # The range must be sorted
      # (as by the {@link #sort(float[], int, int)} method)
      # prior to making this call.  If
      # it is not sorted, the results are undefined.  If the range contains
      # multiple elements with the specified value, there is no guarantee which
      # one will be found.  This method considers all NaN values to be
      # equivalent and equal.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key)
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int, ::Java::Float] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key)
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          if (mid_val < key)
            low = mid + 1
             # Neither val is NaN, thisVal is smaller
          else
            if (mid_val > key)
              high = mid - 1
               # Neither val is NaN, thisVal is larger
            else
              mid_bits = Float.float_to_int_bits(mid_val)
              key_bits = Float.float_to_int_bits(key)
              if ((mid_bits).equal?(key_bits))
                # Values are equal
                return mid
                 # Key found
              else
                if (mid_bits < key_bits)
                  # (-0.0, 0.0) or (!NaN, NaN)
                  low = mid + 1
                else
                  # (0.0, -0.0) or (NaN, !NaN)
                  high = mid - 1
                end
              end
            end
          end
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(Object), Object] }
      # Searches the specified array for the specified object using the binary
      # search algorithm.  The array must be sorted into ascending order
      # according to the
      # {@linkplain Comparable natural ordering}
      # of its elements (as by the
      # {@link #sort(Object[])} method) prior to making this call.
      # If it is not sorted, the results are undefined.
      # (If the array contains elements that are not mutually comparable (for
      # example, strings and integers), it <i>cannot</i> be sorted according
      # to the natural ordering of its elements, hence results are undefined.)
      # If the array contains multiple
      # elements equal to the specified object, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws ClassCastException if the search key is not comparable to the
      # elements of the array.
      def binary_search(a, key)
        return binary_search0(a, 0, a.attr_length, key)
      end
      
      typesig { [Array.typed(Object), ::Java::Int, ::Java::Int, Object] }
      # Searches a range of
      # the specified array for the specified object using the binary
      # search algorithm.
      # The range must be sorted into ascending order
      # according to the
      # {@linkplain Comparable natural ordering}
      # of its elements (as by the
      # {@link #sort(Object[], int, int)} method) prior to making this
      # call.  If it is not sorted, the results are undefined.
      # (If the range contains elements that are not mutually comparable (for
      # example, strings and integers), it <i>cannot</i> be sorted according
      # to the natural ordering of its elements, hence results are undefined.)
      # If the range contains multiple
      # elements equal to the specified object, there is no guarantee which
      # one will be found.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws ClassCastException if the search key is not comparable to the
      # elements of the array within the specified range.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key)
      end
      
      typesig { [Array.typed(Object), ::Java::Int, ::Java::Int, Object] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key)
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          cmp = (mid_val <=> key)
          if (cmp < 0)
            low = mid + 1
          else
            if (cmp > 0)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(T), T, Comparator] }
      # Searches the specified array for the specified object using the binary
      # search algorithm.  The array must be sorted into ascending order
      # according to the specified comparator (as by the
      # {@link #sort(Object[], Comparator) sort(T[], Comparator)}
      # method) prior to making this call.  If it is
      # not sorted, the results are undefined.
      # If the array contains multiple
      # elements equal to the specified object, there is no guarantee which one
      # will be found.
      # 
      # @param a the array to be searched
      # @param key the value to be searched for
      # @param c the comparator by which the array is ordered.  A
      # <tt>null</tt> value indicates that the elements'
      # {@linkplain Comparable natural ordering} should be used.
      # @return index of the search key, if it is contained in the array;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element greater than the key, or <tt>a.length</tt> if all
      # elements in the array are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws ClassCastException if the array contains elements that are not
      # <i>mutually comparable</i> using the specified comparator,
      # or the search key is not comparable to the
      # elements of the array using this comparator.
      def binary_search(a, key, c)
        return binary_search0(a, 0, a.attr_length, key, c)
      end
      
      typesig { [Array.typed(T), ::Java::Int, ::Java::Int, T, Comparator] }
      # Searches a range of
      # the specified array for the specified object using the binary
      # search algorithm.
      # The range must be sorted into ascending order
      # according to the specified comparator (as by the
      # {@link #sort(Object[], int, int, Comparator)
      # sort(T[], int, int, Comparator)}
      # method) prior to making this call.
      # If it is not sorted, the results are undefined.
      # If the range contains multiple elements equal to the specified object,
      # there is no guarantee which one will be found.
      # 
      # @param a the array to be searched
      # @param fromIndex the index of the first element (inclusive) to be
      # searched
      # @param toIndex the index of the last element (exclusive) to be searched
      # @param key the value to be searched for
      # @param c the comparator by which the array is ordered.  A
      # <tt>null</tt> value indicates that the elements'
      # {@linkplain Comparable natural ordering} should be used.
      # @return index of the search key, if it is contained in the array
      # within the specified range;
      # otherwise, <tt>(-(<i>insertion point</i>) - 1)</tt>.  The
      # <i>insertion point</i> is defined as the point at which the
      # key would be inserted into the array: the index of the first
      # element in the range greater than the key,
      # or <tt>toIndex</tt> if all
      # elements in the range are less than the specified key.  Note
      # that this guarantees that the return value will be &gt;= 0 if
      # and only if the key is found.
      # @throws ClassCastException if the range contains elements that are not
      # <i>mutually comparable</i> using the specified comparator,
      # or the search key is not comparable to the
      # elements in the range using this comparator.
      # @throws IllegalArgumentException
      # if {@code fromIndex > toIndex}
      # @throws ArrayIndexOutOfBoundsException
      # if {@code fromIndex < 0 or toIndex > a.length}
      # @since 1.6
      def binary_search(a, from_index, to_index, key, c)
        range_check(a.attr_length, from_index, to_index)
        return binary_search0(a, from_index, to_index, key, c)
      end
      
      typesig { [Array.typed(T), ::Java::Int, ::Java::Int, T, Comparator] }
      # Like public version, but without range checks.
      def binary_search0(a, from_index, to_index, key, c)
        if ((c).nil?)
          return binary_search0(a, from_index, to_index, key)
        end
        low = from_index
        high = to_index - 1
        while (low <= high)
          mid = (low + high) >> 1
          mid_val = a[mid]
          cmp = c.compare(mid_val, key)
          if (cmp < 0)
            low = mid + 1
          else
            if (cmp > 0)
              high = mid - 1
            else
              return mid
            end
          end # key found
        end
        return -(low + 1) # key not found.
      end
      
      typesig { [Array.typed(::Java::Long), Array.typed(::Java::Long)] }
      # Equality Testing
      # 
      # Returns <tt>true</tt> if the two specified arrays of longs are
      # <i>equal</i> to one another.  Two arrays are considered equal if both
      # arrays contain the same number of elements, and all corresponding pairs
      # of elements in the two arrays are equal.  In other words, two arrays
      # are equal if they contain the same elements in the same order.  Also,
      # two array references are considered equal if both are <tt>null</tt>.<p>
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          if (!(a[i]).equal?(a2[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int)] }
      # Returns <tt>true</tt> if the two specified arrays of ints are
      # <i>equal</i> to one another.  Two arrays are considered equal if both
      # arrays contain the same number of elements, and all corresponding pairs
      # of elements in the two arrays are equal.  In other words, two arrays
      # are equal if they contain the same elements in the same order.  Also,
      # two array references are considered equal if both are <tt>null</tt>.<p>
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          if (!(a[i]).equal?(a2[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Short), Array.typed(::Java::Short)] }
      # Returns <tt>true</tt> if the two specified arrays of shorts are
      # <i>equal</i> to one another.  Two arrays are considered equal if both
      # arrays contain the same number of elements, and all corresponding pairs
      # of elements in the two arrays are equal.  In other words, two arrays
      # are equal if they contain the same elements in the same order.  Also,
      # two array references are considered equal if both are <tt>null</tt>.<p>
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          if (!(a[i]).equal?(a2[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Char), Array.typed(::Java::Char)] }
      # Returns <tt>true</tt> if the two specified arrays of chars are
      # <i>equal</i> to one another.  Two arrays are considered equal if both
      # arrays contain the same number of elements, and all corresponding pairs
      # of elements in the two arrays are equal.  In other words, two arrays
      # are equal if they contain the same elements in the same order.  Also,
      # two array references are considered equal if both are <tt>null</tt>.<p>
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          if (!(a[i]).equal?(a2[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
      # Returns <tt>true</tt> if the two specified arrays of bytes are
      # <i>equal</i> to one another.  Two arrays are considered equal if both
      # arrays contain the same number of elements, and all corresponding pairs
      # of elements in the two arrays are equal.  In other words, two arrays
      # are equal if they contain the same elements in the same order.  Also,
      # two array references are considered equal if both are <tt>null</tt>.<p>
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          if (!(a[i]).equal?(a2[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Boolean), Array.typed(::Java::Boolean)] }
      # Returns <tt>true</tt> if the two specified arrays of booleans are
      # <i>equal</i> to one another.  Two arrays are considered equal if both
      # arrays contain the same number of elements, and all corresponding pairs
      # of elements in the two arrays are equal.  In other words, two arrays
      # are equal if they contain the same elements in the same order.  Also,
      # two array references are considered equal if both are <tt>null</tt>.<p>
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          if (!(a[i]).equal?(a2[i]))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Double), Array.typed(::Java::Double)] }
      # Returns <tt>true</tt> if the two specified arrays of doubles are
      # <i>equal</i> to one another.  Two arrays are considered equal if both
      # arrays contain the same number of elements, and all corresponding pairs
      # of elements in the two arrays are equal.  In other words, two arrays
      # are equal if they contain the same elements in the same order.  Also,
      # two array references are considered equal if both are <tt>null</tt>.<p>
      # 
      # Two doubles <tt>d1</tt> and <tt>d2</tt> are considered equal if:
      # <pre>    <tt>new Double(d1).equals(new Double(d2))</tt></pre>
      # (Unlike the <tt>==</tt> operator, this method considers
      # <tt>NaN</tt> equals to itself, and 0.0d unequal to -0.0d.)
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      # @see Double#equals(Object)
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          if (!(Double.double_to_long_bits(a[i])).equal?(Double.double_to_long_bits(a2[i])))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Float), Array.typed(::Java::Float)] }
      # Returns <tt>true</tt> if the two specified arrays of floats are
      # <i>equal</i> to one another.  Two arrays are considered equal if both
      # arrays contain the same number of elements, and all corresponding pairs
      # of elements in the two arrays are equal.  In other words, two arrays
      # are equal if they contain the same elements in the same order.  Also,
      # two array references are considered equal if both are <tt>null</tt>.<p>
      # 
      # Two floats <tt>f1</tt> and <tt>f2</tt> are considered equal if:
      # <pre>    <tt>new Float(f1).equals(new Float(f2))</tt></pre>
      # (Unlike the <tt>==</tt> operator, this method considers
      # <tt>NaN</tt> equals to itself, and 0.0f unequal to -0.0f.)
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      # @see Float#equals(Object)
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          if (!(Float.float_to_int_bits(a[i])).equal?(Float.float_to_int_bits(a2[i])))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(Object), Array.typed(Object)] }
      # Returns <tt>true</tt> if the two specified arrays of Objects are
      # <i>equal</i> to one another.  The two arrays are considered equal if
      # both arrays contain the same number of elements, and all corresponding
      # pairs of elements in the two arrays are equal.  Two objects <tt>e1</tt>
      # and <tt>e2</tt> are considered <i>equal</i> if <tt>(e1==null ? e2==null
      # : e1.equals(e2))</tt>.  In other words, the two arrays are equal if
      # they contain the same elements in the same order.  Also, two array
      # references are considered equal if both are <tt>null</tt>.<p>
      # 
      # @param a one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      def ==(a, a2)
        if ((a).equal?(a2))
          return true
        end
        if ((a).nil? || (a2).nil?)
          return false
        end
        length = a.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          o1 = a[i]
          o2 = a2[i]
          if (!((o1).nil? ? (o2).nil? : (o1 == o2)))
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Long] }
      # Filling
      # 
      # Assigns the specified long value to each element of the specified array
      # of longs.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int, ::Java::Long] }
      # Assigns the specified long value to each element of the specified
      # range of the specified array of longs.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int] }
      # Assigns the specified int value to each element of the specified array
      # of ints.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int, ::Java::Int] }
      # Assigns the specified int value to each element of the specified
      # range of the specified array of ints.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Short] }
      # Assigns the specified short value to each element of the specified array
      # of shorts.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int, ::Java::Short] }
      # Assigns the specified short value to each element of the specified
      # range of the specified array of shorts.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Char] }
      # Assigns the specified char value to each element of the specified array
      # of chars.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int, ::Java::Char] }
      # Assigns the specified char value to each element of the specified
      # range of the specified array of chars.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Byte] }
      # Assigns the specified byte value to each element of the specified array
      # of bytes.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Byte] }
      # Assigns the specified byte value to each element of the specified
      # range of the specified array of bytes.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Boolean), ::Java::Boolean] }
      # Assigns the specified boolean value to each element of the specified
      # array of booleans.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Boolean), ::Java::Int, ::Java::Int, ::Java::Boolean] }
      # Assigns the specified boolean value to each element of the specified
      # range of the specified array of booleans.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Double] }
      # Assigns the specified double value to each element of the specified
      # array of doubles.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int, ::Java::Double] }
      # Assigns the specified double value to each element of the specified
      # range of the specified array of doubles.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Float] }
      # Assigns the specified float value to each element of the specified array
      # of floats.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int, ::Java::Float] }
      # Assigns the specified float value to each element of the specified
      # range of the specified array of floats.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(Object), Object] }
      # Assigns the specified Object reference to each element of the specified
      # array of Objects.
      # 
      # @param a the array to be filled
      # @param val the value to be stored in all elements of the array
      # @throws ArrayStoreException if the specified value is not of a
      # runtime type that can be stored in the specified array
      def fill(a, val)
        i = 0
        len = a.attr_length
        while i < len
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(Object), ::Java::Int, ::Java::Int, Object] }
      # Assigns the specified Object reference to each element of the specified
      # range of the specified array of Objects.  The range to be filled
      # extends from index <tt>fromIndex</tt>, inclusive, to index
      # <tt>toIndex</tt>, exclusive.  (If <tt>fromIndex==toIndex</tt>, the
      # range to be filled is empty.)
      # 
      # @param a the array to be filled
      # @param fromIndex the index of the first element (inclusive) to be
      # filled with the specified value
      # @param toIndex the index of the last element (exclusive) to be
      # filled with the specified value
      # @param val the value to be stored in all elements of the array
      # @throws IllegalArgumentException if <tt>fromIndex &gt; toIndex</tt>
      # @throws ArrayIndexOutOfBoundsException if <tt>fromIndex &lt; 0</tt> or
      # <tt>toIndex &gt; a.length</tt>
      # @throws ArrayStoreException if the specified value is not of a
      # runtime type that can be stored in the specified array
      def fill(a, from_index, to_index, val)
        range_check(a.attr_length, from_index, to_index)
        i = from_index
        while i < to_index
          a[i] = val
          i += 1
        end
      end
      
      typesig { [Array.typed(T), ::Java::Int] }
      # Cloning
      # 
      # Copies the specified array, truncating or padding with nulls (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>null</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # The resulting array is of exactly the same class as the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with nulls
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        return copy_of(original, new_length, original.get_class)
      end
      
      typesig { [Array.typed(U), ::Java::Int, Class] }
      # Copies the specified array, truncating or padding with nulls (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>null</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # The resulting array is of the class <tt>newType</tt>.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @param newType the class of the copy to be returned
      # @return a copy of the original array, truncated or padded with nulls
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @throws ArrayStoreException if an element copied from
      # <tt>original</tt> is not of a runtime type that can be stored in
      # an array of class <tt>newType</tt>
      # @since 1.6
      def copy_of(original, new_length, new_type)
        copy = ((new_type).equal?(Array[])) ? Array.typed(Object).new(new_length) { nil } : Array.new_instance(new_type.get_component_type, new_length)
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      # Copies the specified array, truncating or padding with zeros (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>(byte)0</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with zeros
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        copy = Array.typed(::Java::Byte).new(new_length) { 0 }
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int] }
      # Copies the specified array, truncating or padding with zeros (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>(short)0</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with zeros
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        copy = Array.typed(::Java::Short).new(new_length) { 0 }
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int] }
      # Copies the specified array, truncating or padding with zeros (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>0</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with zeros
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        copy = Array.typed(::Java::Int).new(new_length) { 0 }
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int] }
      # Copies the specified array, truncating or padding with zeros (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>0L</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with zeros
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        copy = Array.typed(::Java::Long).new(new_length) { 0 }
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int] }
      # Copies the specified array, truncating or padding with null characters (if necessary)
      # so the copy has the specified length.  For all indices that are valid
      # in both the original array and the copy, the two arrays will contain
      # identical values.  For any indices that are valid in the copy but not
      # the original, the copy will contain <tt>'\\u000'</tt>.  Such indices
      # will exist if and only if the specified length is greater than that of
      # the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with null characters
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        copy = CharArray.new(new_length)
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int] }
      # Copies the specified array, truncating or padding with zeros (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>0f</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with zeros
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        copy = Array.typed(::Java::Float).new(new_length) { 0.0 }
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int] }
      # Copies the specified array, truncating or padding with zeros (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>0d</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with zeros
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        copy = Array.typed(::Java::Double).new(new_length) { 0.0 }
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Boolean), ::Java::Int] }
      # Copies the specified array, truncating or padding with <tt>false</tt> (if necessary)
      # so the copy has the specified length.  For all indices that are
      # valid in both the original array and the copy, the two arrays will
      # contain identical values.  For any indices that are valid in the
      # copy but not the original, the copy will contain <tt>false</tt>.
      # Such indices will exist if and only if the specified length
      # is greater than that of the original array.
      # 
      # @param original the array to be copied
      # @param newLength the length of the copy to be returned
      # @return a copy of the original array, truncated or padded with false elements
      # to obtain the specified length
      # @throws NegativeArraySizeException if <tt>newLength</tt> is negative
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of(original, new_length)
        copy = Array.typed(::Java::Boolean).new(new_length) { false }
        System.arraycopy(original, 0, copy, 0, Math.min(original.attr_length, new_length))
        return copy
      end
      
      typesig { [Array.typed(T), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>null</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # <p>
      # The resulting array is of exactly the same class as the original array.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with nulls to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        return copy_of_range(original, from, to, original.get_class)
      end
      
      typesig { [Array.typed(U), ::Java::Int, ::Java::Int, Class] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>null</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # The resulting array is of the class <tt>newType</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @param newType the class of the copy to be returned
      # @return a new array containing the specified range from the original array,
      # truncated or padded with nulls to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @throws ArrayStoreException if an element copied from
      # <tt>original</tt> is not of a runtime type that can be stored in
      # an array of class <tt>newType</tt>.
      # @since 1.6
      def copy_of_range(original, from, to, new_type)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = ((new_type).equal?(Array[])) ? Array.typed(Object).new(new_length) { nil } : Array.new_instance(new_type.get_component_type, new_length)
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>(byte)0</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with zeros to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = Array.typed(::Java::Byte).new(new_length) { 0 }
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>(short)0</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with zeros to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = Array.typed(::Java::Short).new(new_length) { 0 }
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>0</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with zeros to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = Array.typed(::Java::Int).new(new_length) { 0 }
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>0L</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with zeros to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = Array.typed(::Java::Long).new(new_length) { 0 }
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>'\\u000'</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with null characters to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = CharArray.new(new_length)
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>0f</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with zeros to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = Array.typed(::Java::Float).new(new_length) { 0.0 }
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>0d</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with zeros to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = Array.typed(::Java::Double).new(new_length) { 0.0 }
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [Array.typed(::Java::Boolean), ::Java::Int, ::Java::Int] }
      # Copies the specified range of the specified array into a new array.
      # The initial index of the range (<tt>from</tt>) must lie between zero
      # and <tt>original.length</tt>, inclusive.  The value at
      # <tt>original[from]</tt> is placed into the initial element of the copy
      # (unless <tt>from == original.length</tt> or <tt>from == to</tt>).
      # Values from subsequent elements in the original array are placed into
      # subsequent elements in the copy.  The final index of the range
      # (<tt>to</tt>), which must be greater than or equal to <tt>from</tt>,
      # may be greater than <tt>original.length</tt>, in which case
      # <tt>false</tt> is placed in all elements of the copy whose index is
      # greater than or equal to <tt>original.length - from</tt>.  The length
      # of the returned array will be <tt>to - from</tt>.
      # 
      # @param original the array from which a range is to be copied
      # @param from the initial index of the range to be copied, inclusive
      # @param to the final index of the range to be copied, exclusive.
      # (This index may lie outside the array.)
      # @return a new array containing the specified range from the original array,
      # truncated or padded with false elements to obtain the required length
      # @throws ArrayIndexOutOfBoundsException if {@code from < 0}
      # or {@code from > original.length}
      # @throws IllegalArgumentException if <tt>from &gt; to</tt>
      # @throws NullPointerException if <tt>original</tt> is null
      # @since 1.6
      def copy_of_range(original, from, to)
        new_length = to - from
        if (new_length < 0)
          raise IllegalArgumentException.new(RJava.cast_to_string(from) + " > " + RJava.cast_to_string(to))
        end
        copy = Array.typed(::Java::Boolean).new(new_length) { false }
        System.arraycopy(original, from, copy, 0, Math.min(original.attr_length - from, new_length))
        return copy
      end
      
      typesig { [T] }
      # Misc
      # 
      # Returns a fixed-size list backed by the specified array.  (Changes to
      # the returned list "write through" to the array.)  This method acts
      # as bridge between array-based and collection-based APIs, in
      # combination with {@link Collection#toArray}.  The returned list is
      # serializable and implements {@link RandomAccess}.
      # 
      # <p>This method also provides a convenient way to create a fixed-size
      # list initialized to contain several elements:
      # <pre>
      # List&lt;String&gt; stooges = Arrays.asList("Larry", "Moe", "Curly");
      # </pre>
      # 
      # @param a the array by which the list will be backed
      # @return a list view of the specified array
      def as_list(*a)
        return ArrayList.new(a)
      end
      
      # @serial include
      const_set_lazy(:ArrayList) { Class.new(AbstractList) do
        include_class_members Arrays
        overload_protected {
          include RandomAccess
          include Java::Io::Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -2764017481108945198 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :a
        alias_method :attr_a, :a
        undef_method :a
        alias_method :attr_a=, :a=
        undef_method :a=
        
        typesig { [Array.typed(Object)] }
        def initialize(array)
          @a = nil
          super()
          if ((array).nil?)
            raise NullPointerException.new
          end
          @a = array
        end
        
        typesig { [] }
        def size
          return @a.attr_length
        end
        
        typesig { [] }
        def to_array
          return @a.clone
        end
        
        typesig { [Array.typed(T)] }
        def to_array(a)
          size_ = size
          if (a.attr_length < size_)
            return Arrays.copy_of(@a, size_, a.get_class)
          end
          System.arraycopy(@a, 0, a, 0, size_)
          if (a.attr_length > size_)
            a[size_] = nil
          end
          return a
        end
        
        typesig { [::Java::Int] }
        def get(index)
          return @a[index]
        end
        
        typesig { [::Java::Int, Object] }
        def set(index, element)
          old_value = @a[index]
          @a[index] = element
          return old_value
        end
        
        typesig { [Object] }
        def index_of(o)
          if ((o).nil?)
            i = 0
            while i < @a.attr_length
              if ((@a[i]).nil?)
                return i
              end
              i += 1
            end
          else
            i = 0
            while i < @a.attr_length
              if ((o == @a[i]))
                return i
              end
              i += 1
            end
          end
          return -1
        end
        
        typesig { [Object] }
        def contains(o)
          return !(index_of(o)).equal?(-1)
        end
        
        private
        alias_method :initialize__array_list, :initialize
      end }
      
      typesig { [Array.typed(::Java::Long)] }
      # Returns a hash code based on the contents of the specified array.
      # For any two <tt>long</tt> arrays <tt>a</tt> and <tt>b</tt>
      # such that <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is the same value that would be
      # obtained by invoking the {@link List#hashCode() <tt>hashCode</tt>}
      # method on a {@link List} containing a sequence of {@link Long}
      # instances representing the elements of <tt>a</tt> in the same order.
      # If <tt>a</tt> is <tt>null</tt>, this method returns 0.
      # 
      # @param a the array whose hash value to compute
      # @return a content-based hash code for <tt>a</tt>
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          element_hash = RJava.cast_to_int((element ^ (element >> 32)))
          result = 31 * result + element_hash
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Int)] }
      # Returns a hash code based on the contents of the specified array.
      # For any two non-null <tt>int</tt> arrays <tt>a</tt> and <tt>b</tt>
      # such that <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is the same value that would be
      # obtained by invoking the {@link List#hashCode() <tt>hashCode</tt>}
      # method on a {@link List} containing a sequence of {@link Integer}
      # instances representing the elements of <tt>a</tt> in the same order.
      # If <tt>a</tt> is <tt>null</tt>, this method returns 0.
      # 
      # @param a the array whose hash value to compute
      # @return a content-based hash code for <tt>a</tt>
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          result = 31 * result + element
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Short)] }
      # Returns a hash code based on the contents of the specified array.
      # For any two <tt>short</tt> arrays <tt>a</tt> and <tt>b</tt>
      # such that <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is the same value that would be
      # obtained by invoking the {@link List#hashCode() <tt>hashCode</tt>}
      # method on a {@link List} containing a sequence of {@link Short}
      # instances representing the elements of <tt>a</tt> in the same order.
      # If <tt>a</tt> is <tt>null</tt>, this method returns 0.
      # 
      # @param a the array whose hash value to compute
      # @return a content-based hash code for <tt>a</tt>
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          result = 31 * result + element
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # Returns a hash code based on the contents of the specified array.
      # For any two <tt>char</tt> arrays <tt>a</tt> and <tt>b</tt>
      # such that <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is the same value that would be
      # obtained by invoking the {@link List#hashCode() <tt>hashCode</tt>}
      # method on a {@link List} containing a sequence of {@link Character}
      # instances representing the elements of <tt>a</tt> in the same order.
      # If <tt>a</tt> is <tt>null</tt>, this method returns 0.
      # 
      # @param a the array whose hash value to compute
      # @return a content-based hash code for <tt>a</tt>
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          result = 31 * result + element
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Returns a hash code based on the contents of the specified array.
      # For any two <tt>byte</tt> arrays <tt>a</tt> and <tt>b</tt>
      # such that <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is the same value that would be
      # obtained by invoking the {@link List#hashCode() <tt>hashCode</tt>}
      # method on a {@link List} containing a sequence of {@link Byte}
      # instances representing the elements of <tt>a</tt> in the same order.
      # If <tt>a</tt> is <tt>null</tt>, this method returns 0.
      # 
      # @param a the array whose hash value to compute
      # @return a content-based hash code for <tt>a</tt>
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          result = 31 * result + element
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Boolean)] }
      # Returns a hash code based on the contents of the specified array.
      # For any two <tt>boolean</tt> arrays <tt>a</tt> and <tt>b</tt>
      # such that <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is the same value that would be
      # obtained by invoking the {@link List#hashCode() <tt>hashCode</tt>}
      # method on a {@link List} containing a sequence of {@link Boolean}
      # instances representing the elements of <tt>a</tt> in the same order.
      # If <tt>a</tt> is <tt>null</tt>, this method returns 0.
      # 
      # @param a the array whose hash value to compute
      # @return a content-based hash code for <tt>a</tt>
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          result = 31 * result + (element ? 1231 : 1237)
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Float)] }
      # Returns a hash code based on the contents of the specified array.
      # For any two <tt>float</tt> arrays <tt>a</tt> and <tt>b</tt>
      # such that <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is the same value that would be
      # obtained by invoking the {@link List#hashCode() <tt>hashCode</tt>}
      # method on a {@link List} containing a sequence of {@link Float}
      # instances representing the elements of <tt>a</tt> in the same order.
      # If <tt>a</tt> is <tt>null</tt>, this method returns 0.
      # 
      # @param a the array whose hash value to compute
      # @return a content-based hash code for <tt>a</tt>
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          result = 31 * result + Float.float_to_int_bits(element)
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Double)] }
      # Returns a hash code based on the contents of the specified array.
      # For any two <tt>double</tt> arrays <tt>a</tt> and <tt>b</tt>
      # such that <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is the same value that would be
      # obtained by invoking the {@link List#hashCode() <tt>hashCode</tt>}
      # method on a {@link List} containing a sequence of {@link Double}
      # instances representing the elements of <tt>a</tt> in the same order.
      # If <tt>a</tt> is <tt>null</tt>, this method returns 0.
      # 
      # @param a the array whose hash value to compute
      # @return a content-based hash code for <tt>a</tt>
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          bits = Double.double_to_long_bits(element)
          result = 31 * result + RJava.cast_to_int((bits ^ (bits >> 32)))
        end
        return result
      end
      
      typesig { [Array.typed(Object)] }
      # Returns a hash code based on the contents of the specified array.  If
      # the array contains other arrays as elements, the hash code is based on
      # their identities rather than their contents.  It is therefore
      # acceptable to invoke this method on an array that contains itself as an
      # element,  either directly or indirectly through one or more levels of
      # arrays.
      # 
      # <p>For any two arrays <tt>a</tt> and <tt>b</tt> such that
      # <tt>Arrays.equals(a, b)</tt>, it is also the case that
      # <tt>Arrays.hashCode(a) == Arrays.hashCode(b)</tt>.
      # 
      # <p>The value returned by this method is equal to the value that would
      # be returned by <tt>Arrays.asList(a).hashCode()</tt>, unless <tt>a</tt>
      # is <tt>null</tt>, in which case <tt>0</tt> is returned.
      # 
      # @param a the array whose content-based hash code to compute
      # @return a content-based hash code for <tt>a</tt>
      # @see #deepHashCode(Object[])
      # @since 1.5
      def hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          result = 31 * result + ((element).nil? ? 0 : element.hash_code)
        end
        return result
      end
      
      typesig { [Array.typed(Object)] }
      # Returns a hash code based on the "deep contents" of the specified
      # array.  If the array contains other arrays as elements, the
      # hash code is based on their contents and so on, ad infinitum.
      # It is therefore unacceptable to invoke this method on an array that
      # contains itself as an element, either directly or indirectly through
      # one or more levels of arrays.  The behavior of such an invocation is
      # undefined.
      # 
      # <p>For any two arrays <tt>a</tt> and <tt>b</tt> such that
      # <tt>Arrays.deepEquals(a, b)</tt>, it is also the case that
      # <tt>Arrays.deepHashCode(a) == Arrays.deepHashCode(b)</tt>.
      # 
      # <p>The computation of the value returned by this method is similar to
      # that of the value returned by {@link List#hashCode()} on a list
      # containing the same elements as <tt>a</tt> in the same order, with one
      # difference: If an element <tt>e</tt> of <tt>a</tt> is itself an array,
      # its hash code is computed not by calling <tt>e.hashCode()</tt>, but as
      # by calling the appropriate overloading of <tt>Arrays.hashCode(e)</tt>
      # if <tt>e</tt> is an array of a primitive type, or as by calling
      # <tt>Arrays.deepHashCode(e)</tt> recursively if <tt>e</tt> is an array
      # of a reference type.  If <tt>a</tt> is <tt>null</tt>, this method
      # returns 0.
      # 
      # @param a the array whose deep-content-based hash code to compute
      # @return a deep-content-based hash code for <tt>a</tt>
      # @see #hashCode(Object[])
      # @since 1.5
      def deep_hash_code(a)
        if ((a).nil?)
          return 0
        end
        result = 1
        a.each do |element|
          element_hash = 0
          if (element.is_a?(Array.typed(Object)))
            element_hash = deep_hash_code(element)
          else
            if (element.is_a?(Array.typed(::Java::Byte)))
              element_hash = hash_code(element)
            else
              if (element.is_a?(Array.typed(::Java::Short)))
                element_hash = hash_code(element)
              else
                if (element.is_a?(Array.typed(::Java::Int)))
                  element_hash = hash_code(element)
                else
                  if (element.is_a?(Array.typed(::Java::Long)))
                    element_hash = hash_code(element)
                  else
                    if (element.is_a?(Array.typed(::Java::Char)))
                      element_hash = hash_code(element)
                    else
                      if (element.is_a?(Array.typed(::Java::Float)))
                        element_hash = hash_code(element)
                      else
                        if (element.is_a?(Array.typed(::Java::Double)))
                          element_hash = hash_code(element)
                        else
                          if (element.is_a?(Array.typed(::Java::Boolean)))
                            element_hash = hash_code(element)
                          else
                            if (!(element).nil?)
                              element_hash = element.hash_code
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          result = 31 * result + element_hash
        end
        return result
      end
      
      typesig { [Array.typed(Object), Array.typed(Object)] }
      # Returns <tt>true</tt> if the two specified arrays are <i>deeply
      # equal</i> to one another.  Unlike the {@link #equals(Object[],Object[])}
      # method, this method is appropriate for use with nested arrays of
      # arbitrary depth.
      # 
      # <p>Two array references are considered deeply equal if both
      # are <tt>null</tt>, or if they refer to arrays that contain the same
      # number of elements and all corresponding pairs of elements in the two
      # arrays are deeply equal.
      # 
      # <p>Two possibly <tt>null</tt> elements <tt>e1</tt> and <tt>e2</tt> are
      # deeply equal if any of the following conditions hold:
      # <ul>
      # <li> <tt>e1</tt> and <tt>e2</tt> are both arrays of object reference
      # types, and <tt>Arrays.deepEquals(e1, e2) would return true</tt>
      # <li> <tt>e1</tt> and <tt>e2</tt> are arrays of the same primitive
      # type, and the appropriate overloading of
      # <tt>Arrays.equals(e1, e2)</tt> would return true.
      # <li> <tt>e1 == e2</tt>
      # <li> <tt>e1.equals(e2)</tt> would return true.
      # </ul>
      # Note that this definition permits <tt>null</tt> elements at any depth.
      # 
      # <p>If either of the specified arrays contain themselves as elements
      # either directly or indirectly through one or more levels of arrays,
      # the behavior of this method is undefined.
      # 
      # @param a1 one array to be tested for equality
      # @param a2 the other array to be tested for equality
      # @return <tt>true</tt> if the two arrays are equal
      # @see #equals(Object[],Object[])
      # @since 1.5
      def deep_equals(a1, a2)
        if ((a1).equal?(a2))
          return true
        end
        if ((a1).nil? || (a2).nil?)
          return false
        end
        length = a1.attr_length
        if (!(a2.attr_length).equal?(length))
          return false
        end
        i = 0
        while i < length
          e1 = a1[i]
          e2 = a2[i]
          if ((e1).equal?(e2))
            i += 1
            next
          end
          if ((e1).nil?)
            return false
          end
          # Figure out whether the two elements are equal
          eq = false
          if (e1.is_a?(Array.typed(Object)) && e2.is_a?(Array.typed(Object)))
            eq = deep_equals(e1, e2)
          else
            if (e1.is_a?(Array.typed(::Java::Byte)) && e2.is_a?(Array.typed(::Java::Byte)))
              eq = self.==(e1, e2)
            else
              if (e1.is_a?(Array.typed(::Java::Short)) && e2.is_a?(Array.typed(::Java::Short)))
                eq = self.==(e1, e2)
              else
                if (e1.is_a?(Array.typed(::Java::Int)) && e2.is_a?(Array.typed(::Java::Int)))
                  eq = self.==(e1, e2)
                else
                  if (e1.is_a?(Array.typed(::Java::Long)) && e2.is_a?(Array.typed(::Java::Long)))
                    eq = self.==(e1, e2)
                  else
                    if (e1.is_a?(Array.typed(::Java::Char)) && e2.is_a?(Array.typed(::Java::Char)))
                      eq = self.==(e1, e2)
                    else
                      if (e1.is_a?(Array.typed(::Java::Float)) && e2.is_a?(Array.typed(::Java::Float)))
                        eq = self.==(e1, e2)
                      else
                        if (e1.is_a?(Array.typed(::Java::Double)) && e2.is_a?(Array.typed(::Java::Double)))
                          eq = self.==(e1, e2)
                        else
                          if (e1.is_a?(Array.typed(::Java::Boolean)) && e2.is_a?(Array.typed(::Java::Boolean)))
                            eq = self.==(e1, e2)
                          else
                            eq = (e1 == e2)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          if (!eq)
            return false
          end
          i += 1
        end
        return true
      end
      
      typesig { [Array.typed(::Java::Long)] }
      # Returns a string representation of the contents of the specified array.
      # The string representation consists of a list of the array's elements,
      # enclosed in square brackets (<tt>"[]"</tt>).  Adjacent elements are
      # separated by the characters <tt>", "</tt> (a comma followed by a
      # space).  Elements are converted to strings as by
      # <tt>String.valueOf(long)</tt>.  Returns <tt>"null"</tt> if <tt>a</tt>
      # is <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(a[i])
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Int)] }
      # Returns a string representation of the contents of the specified array.
      # The string representation consists of a list of the array's elements,
      # enclosed in square brackets (<tt>"[]"</tt>).  Adjacent elements are
      # separated by the characters <tt>", "</tt> (a comma followed by a
      # space).  Elements are converted to strings as by
      # <tt>String.valueOf(int)</tt>.  Returns <tt>"null"</tt> if <tt>a</tt> is
      # <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(a[i])
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Short)] }
      # Returns a string representation of the contents of the specified array.
      # The string representation consists of a list of the array's elements,
      # enclosed in square brackets (<tt>"[]"</tt>).  Adjacent elements are
      # separated by the characters <tt>", "</tt> (a comma followed by a
      # space).  Elements are converted to strings as by
      # <tt>String.valueOf(short)</tt>.  Returns <tt>"null"</tt> if <tt>a</tt>
      # is <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(a[i])
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # Returns a string representation of the contents of the specified array.
      # The string representation consists of a list of the array's elements,
      # enclosed in square brackets (<tt>"[]"</tt>).  Adjacent elements are
      # separated by the characters <tt>", "</tt> (a comma followed by a
      # space).  Elements are converted to strings as by
      # <tt>String.valueOf(char)</tt>.  Returns <tt>"null"</tt> if <tt>a</tt>
      # is <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(a[i])
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Returns a string representation of the contents of the specified array.
      # The string representation consists of a list of the array's elements,
      # enclosed in square brackets (<tt>"[]"</tt>).  Adjacent elements
      # are separated by the characters <tt>", "</tt> (a comma followed
      # by a space).  Elements are converted to strings as by
      # <tt>String.valueOf(byte)</tt>.  Returns <tt>"null"</tt> if
      # <tt>a</tt> is <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(a[i])
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Boolean)] }
      # Returns a string representation of the contents of the specified array.
      # The string representation consists of a list of the array's elements,
      # enclosed in square brackets (<tt>"[]"</tt>).  Adjacent elements are
      # separated by the characters <tt>", "</tt> (a comma followed by a
      # space).  Elements are converted to strings as by
      # <tt>String.valueOf(boolean)</tt>.  Returns <tt>"null"</tt> if
      # <tt>a</tt> is <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(a[i])
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Float)] }
      # Returns a string representation of the contents of the specified array.
      # The string representation consists of a list of the array's elements,
      # enclosed in square brackets (<tt>"[]"</tt>).  Adjacent elements are
      # separated by the characters <tt>", "</tt> (a comma followed by a
      # space).  Elements are converted to strings as by
      # <tt>String.valueOf(float)</tt>.  Returns <tt>"null"</tt> if <tt>a</tt>
      # is <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(a[i])
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(::Java::Double)] }
      # Returns a string representation of the contents of the specified array.
      # The string representation consists of a list of the array's elements,
      # enclosed in square brackets (<tt>"[]"</tt>).  Adjacent elements are
      # separated by the characters <tt>", "</tt> (a comma followed by a
      # space).  Elements are converted to strings as by
      # <tt>String.valueOf(double)</tt>.  Returns <tt>"null"</tt> if <tt>a</tt>
      # is <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(a[i])
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(Object)] }
      # Returns a string representation of the contents of the specified array.
      # If the array contains other arrays as elements, they are converted to
      # strings by the {@link Object#toString} method inherited from
      # <tt>Object</tt>, which describes their <i>identities</i> rather than
      # their contents.
      # 
      # <p>The value returned by this method is equal to the value that would
      # be returned by <tt>Arrays.asList(a).toString()</tt>, unless <tt>a</tt>
      # is <tt>null</tt>, in which case <tt>"null"</tt> is returned.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @see #deepToString(Object[])
      # @since 1.5
      def to_s(a)
        if ((a).nil?)
          return "null"
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          return "[]"
        end
        b = StringBuilder.new
        b.append(Character.new(?[.ord))
        i = 0
        loop do
          b.append(String.value_of(a[i]))
          if ((i).equal?(i_max))
            return b.append(Character.new(?].ord)).to_s
          end
          b.append(", ")
          i += 1
        end
      end
      
      typesig { [Array.typed(Object)] }
      # Returns a string representation of the "deep contents" of the specified
      # array.  If the array contains other arrays as elements, the string
      # representation contains their contents and so on.  This method is
      # designed for converting multidimensional arrays to strings.
      # 
      # <p>The string representation consists of a list of the array's
      # elements, enclosed in square brackets (<tt>"[]"</tt>).  Adjacent
      # elements are separated by the characters <tt>", "</tt> (a comma
      # followed by a space).  Elements are converted to strings as by
      # <tt>String.valueOf(Object)</tt>, unless they are themselves
      # arrays.
      # 
      # <p>If an element <tt>e</tt> is an array of a primitive type, it is
      # converted to a string as by invoking the appropriate overloading of
      # <tt>Arrays.toString(e)</tt>.  If an element <tt>e</tt> is an array of a
      # reference type, it is converted to a string as by invoking
      # this method recursively.
      # 
      # <p>To avoid infinite recursion, if the specified array contains itself
      # as an element, or contains an indirect reference to itself through one
      # or more levels of arrays, the self-reference is converted to the string
      # <tt>"[...]"</tt>.  For example, an array containing only a reference
      # to itself would be rendered as <tt>"[[...]]"</tt>.
      # 
      # <p>This method returns <tt>"null"</tt> if the specified array
      # is <tt>null</tt>.
      # 
      # @param a the array whose string representation to return
      # @return a string representation of <tt>a</tt>
      # @see #toString(Object[])
      # @since 1.5
      def deep_to_string(a)
        if ((a).nil?)
          return "null"
        end
        buf_len = 20 * a.attr_length
        if (!(a.attr_length).equal?(0) && buf_len <= 0)
          buf_len = JavaInteger::MAX_VALUE
        end
        buf = StringBuilder.new(buf_len)
        deep_to_string(a, buf, HashSet.new)
        return buf.to_s
      end
      
      typesig { [Array.typed(Object), StringBuilder, JavaSet] }
      def deep_to_string(a, buf, deja_vu)
        if ((a).nil?)
          buf.append("null")
          return
        end
        i_max = a.attr_length - 1
        if ((i_max).equal?(-1))
          buf.append("[]")
          return
        end
        deja_vu.add(a)
        buf.append(Character.new(?[.ord))
        i = 0
        loop do
          element = a[i]
          if ((element).nil?)
            buf.append("null")
          else
            e_class = element.get_class
            if (e_class.is_array)
              if ((e_class).equal?(Array))
                buf.append(to_s(element))
              else
                if ((e_class).equal?(Array))
                  buf.append(to_s(element))
                else
                  if ((e_class).equal?(Array))
                    buf.append(to_s(element))
                  else
                    if ((e_class).equal?(Array))
                      buf.append(to_s(element))
                    else
                      if ((e_class).equal?(Array))
                        buf.append(to_s(element))
                      else
                        if ((e_class).equal?(Array))
                          buf.append(to_s(element))
                        else
                          if ((e_class).equal?(Array))
                            buf.append(to_s(element))
                          else
                            if ((e_class).equal?(Array))
                              buf.append(to_s(element))
                            else
                              # element is an array of object references
                              if (deja_vu.contains(element))
                                buf.append("[...]")
                              else
                                deep_to_string(element, buf, deja_vu)
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            else
              # element is non-null and not an array
              buf.append(element.to_s)
            end
          end
          if ((i).equal?(i_max))
            break
          end
          buf.append(", ")
          i += 1
        end
        buf.append(Character.new(?].ord))
        deja_vu.remove(a)
      end
    }
    
    private
    alias_method :initialize__arrays, :initialize
  end
  
end
