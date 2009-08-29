require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
# *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module ReplaceableStringImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
    }
  end
  
  # <code>ReplaceableString</code> is an adapter class that implements the
  # <code>Replaceable</code> API around an ordinary <code>StringBuffer</code>.
  # 
  # <p><em>Note:</em> This class does not support attributes and is not
  # intended for general use.  Most clients will need to implement
  # {@link Replaceable} in their text representation class.
  # 
  # <p>Copyright &copy; IBM Corporation 1999.  All rights reserved.
  # 
  # @see Replaceable
  # @author Alan Liu
  # @stable ICU 2.0
  class ReplaceableString 
    include_class_members ReplaceableStringImports
    include Replaceable
    
    attr_accessor :buf
    alias_method :attr_buf, :buf
    undef_method :buf
    alias_method :attr_buf=, :buf=
    undef_method :buf=
    
    typesig { [String] }
    # Construct a new object with the given initial contents.
    # @param str initial contents
    # @stable ICU 2.0
    def initialize(str)
      @buf = nil
      @buf = StringBuffer.new(str)
    end
    
    typesig { [StringBuffer] }
    # // for StringPrep
    # 
    # Construct a new object using <code>buf</code> for internal
    # storage.  The contents of <code>buf</code> at the time of
    # construction are used as the initial contents.  <em>Note!
    # Modifications to <code>buf</code> will modify this object, and
    # vice versa.</em>
    # @param buf object to be used as internal storage
    # @stable ICU 2.0
    def initialize(buf)
      @buf = nil
      @buf = buf
    end
    
    typesig { [] }
    # Return the number of characters contained in this object.
    # <code>Replaceable</code> API.
    # @stable ICU 2.0
    def length
      return @buf.length
    end
    
    typesig { [::Java::Int] }
    # Return the character at the given position in this object.
    # <code>Replaceable</code> API.
    # @param offset offset into the contents, from 0 to
    # <code>length()</code> - 1
    # @stable ICU 2.0
    def char_at(offset)
      return @buf.char_at(offset)
    end
    
    typesig { [::Java::Int, ::Java::Int, Array.typed(::Java::Char), ::Java::Int] }
    # // for StringPrep
    # 
    # Copies characters from this object into the destination
    # character array.  The first character to be copied is at index
    # <code>srcStart</code>; the last character to be copied is at
    # index <code>srcLimit-1</code> (thus the total number of
    # characters to be copied is <code>srcLimit-srcStart</code>). The
    # characters are copied into the subarray of <code>dst</code>
    # starting at index <code>dstStart</code> and ending at index
    # <code>dstStart + (srcLimit-srcStart) - 1</code>.
    # 
    # @param srcStart the beginning index to copy, inclusive; <code>0
    # <= start <= limit</code>.
    # @param srcLimit the ending index to copy, exclusive;
    # <code>start <= limit <= length()</code>.
    # @param dst the destination array.
    # @param dstStart the start offset in the destination array.
    # @stable ICU 2.0
    def get_chars(src_start, src_limit, dst, dst_start)
      Utility.get_chars(@buf, src_start, src_limit, dst, dst_start)
    end
    
    private
    alias_method :initialize__replaceable_string, :initialize
  end
  
end
