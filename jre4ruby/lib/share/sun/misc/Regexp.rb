require "rjava"

# Copyright 1995-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RegexpImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # A class to represent a regular expression.  Only handles '*'s.
  # @author  James Gosling
  class Regexp 
    include_class_members RegexpImports
    
    # if true then the matching process ignores case.
    attr_accessor :ignore_case
    alias_method :attr_ignore_case, :ignore_case
    undef_method :ignore_case
    alias_method :attr_ignore_case=, :ignore_case=
    undef_method :ignore_case=
    
    # regular expressions are carved into three regions: a constant string
    # prefix, a constant string suffix, and a series of floating strings in
    # between.  In the input regular expression, they are separated by *s
    attr_accessor :exp
    alias_method :attr_exp, :exp
    undef_method :exp
    alias_method :attr_exp=, :exp=
    undef_method :exp=
    
    attr_accessor :prefix
    alias_method :attr_prefix, :prefix
    undef_method :prefix
    alias_method :attr_prefix=, :prefix=
    undef_method :prefix=
    
    attr_accessor :suffix
    alias_method :attr_suffix, :suffix
    undef_method :suffix
    alias_method :attr_suffix=, :suffix=
    undef_method :suffix=
    
    attr_accessor :exact
    alias_method :attr_exact, :exact
    undef_method :exact
    alias_method :attr_exact=, :exact=
    undef_method :exact=
    
    attr_accessor :prefix_len
    alias_method :attr_prefix_len, :prefix_len
    undef_method :prefix_len
    alias_method :attr_prefix_len=, :prefix_len=
    undef_method :prefix_len=
    
    attr_accessor :suffix_len
    alias_method :attr_suffix_len, :suffix_len
    undef_method :suffix_len
    alias_method :attr_suffix_len=, :suffix_len=
    undef_method :suffix_len=
    
    attr_accessor :total_len
    alias_method :attr_total_len, :total_len
    undef_method :total_len
    alias_method :attr_total_len=, :total_len=
    undef_method :total_len=
    
    attr_accessor :mids
    alias_method :attr_mids, :mids
    undef_method :mids
    alias_method :attr_mids=, :mids=
    undef_method :mids=
    
    typesig { [String] }
    # Create a new regular expression object.  The regular expression
    # is a series of constant strings separated by *s.  For example:
    # <dl>
    # <dt>*.gif       <dd>Matches any string that ends in ".gif".
    # <dt>/tmp/*      <dd>Matches any string that starts with "/tmp/".
    # <dt>/tmp/*.gif  <dd>Matches any string that starts with "/tmp/" and ends
    # with ".gif".
    # <dt>/tmp/*new*.gif <dd>Matches any string that starts with "/tmp/"
    # and ends with ".gif" and has "new" somewhere in between.
    # </dl>
    def initialize(s)
      @ignore_case = false
      @exp = nil
      @prefix = nil
      @suffix = nil
      @exact = false
      @prefix_len = 0
      @suffix_len = 0
      @total_len = 0
      @mids = nil
      @exp = s
      firstst = s.index_of(Character.new(?*.ord))
      lastst = s.last_index_of(Character.new(?*.ord))
      if (firstst < 0)
        @total_len = s.length
        @exact = true # no * s
      else
        @prefix_len = firstst
        if ((firstst).equal?(0))
          @prefix = RJava.cast_to_string(nil)
        else
          @prefix = RJava.cast_to_string(s.substring(0, firstst))
        end
        @suffix_len = s.length - lastst - 1
        if ((@suffix_len).equal?(0))
          @suffix = RJava.cast_to_string(nil)
        else
          @suffix = RJava.cast_to_string(s.substring(lastst + 1))
        end
        nmids = 0
        pos = firstst
        while (pos < lastst && pos >= 0)
          nmids += 1
          pos = s.index_of(Character.new(?*.ord), pos + 1)
        end
        @total_len = @prefix_len + @suffix_len
        if (nmids > 0)
          @mids = Array.typed(String).new(nmids) { nil }
          pos = firstst
          i = 0
          while i < nmids
            pos += 1
            npos = s.index_of(Character.new(?*.ord), pos)
            if (pos < npos)
              @mids[i] = s.substring(pos, npos)
              @total_len += @mids[i].length
            end
            pos = npos
            i += 1
          end
        end
      end
    end
    
    typesig { [String] }
    # Returns true iff the String s matches this regular expression.
    def matches(s)
      return matches(s, 0, s.length)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Returns true iff the substring of s from offset for len characters
    # matches this regular expression.
    def matches(s, offset, len)
      if (@exact)
        return (len).equal?(@total_len) && @exp.region_matches(@ignore_case, 0, s, offset, len)
      end
      if (len < @total_len)
        return false
      end
      if (@prefix_len > 0 && !@prefix.region_matches(@ignore_case, 0, s, offset, @prefix_len) || @suffix_len > 0 && !@suffix.region_matches(@ignore_case, 0, s, offset + len - @suffix_len, @suffix_len))
        return false
      end
      if ((@mids).nil?)
        return true
      end
      nmids = @mids.attr_length
      spos = offset + @prefix_len
      limit = offset + len - @suffix_len
      i = 0
      while i < nmids
        ms = @mids[i]
        ml = ms.length
        while (spos + ml <= limit && !ms.region_matches(@ignore_case, 0, s, spos, ml))
          spos += 1
        end
        if (spos + ml > limit)
          return false
        end
        spos += ml
        i += 1
      end
      return true
    end
    
    private
    alias_method :initialize__regexp, :initialize
  end
  
end
