require "rjava"

# Copyright 1995-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RegexpPoolImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include ::Java::Io
    }
  end
  
  # A class to represent a pool of regular expressions.  A string
  # can be matched against the whole pool all at once.  It is much
  # faster than doing individual regular expression matches one-by-one.
  # 
  # @see java.misc.RegexpTarget
  # @author  James Gosling
  class RegexpPool 
    include_class_members RegexpPoolImports
    
    attr_accessor :prefix_machine
    alias_method :attr_prefix_machine, :prefix_machine
    undef_method :prefix_machine
    alias_method :attr_prefix_machine=, :prefix_machine=
    undef_method :prefix_machine=
    
    attr_accessor :suffix_machine
    alias_method :attr_suffix_machine, :suffix_machine
    undef_method :suffix_machine
    alias_method :attr_suffix_machine=, :suffix_machine=
    undef_method :suffix_machine=
    
    class_module.module_eval {
      const_set_lazy(:BIG) { 0x7fffffff }
      const_attr_reader  :BIG
    }
    
    attr_accessor :last_depth
    alias_method :attr_last_depth, :last_depth
    undef_method :last_depth
    alias_method :attr_last_depth=, :last_depth=
    undef_method :last_depth=
    
    typesig { [] }
    def initialize
      @prefix_machine = RegexpNode.new
      @suffix_machine = RegexpNode.new
      @last_depth = BIG
    end
    
    typesig { [String, Object] }
    # Add a regular expression to the pool of regular expressions.
    # @param   re  The regular expression to add to the pool.
    # For now, only handles strings that either begin or end with
    # a '*'.
    # @param   ret The object to be returned when this regular expression is
    # matched.  If ret is an instance of the RegexpTarget class, ret.found
    # is called with the string fragment that matched the '*' as its
    # parameter.
    # @exception REException error
    def add(re, ret)
      add(re, ret, false)
    end
    
    typesig { [String, Object] }
    # Replace the target for the regular expression with a different
    # target.
    # 
    # @param   re  The regular expression to be replaced in the pool.
    # For now, only handles strings that either begin or end with
    # a '*'.
    # @param   ret The object to be returned when this regular expression is
    # matched.  If ret is an instance of the RegexpTarget class, ret.found
    # is called with the string fragment that matched the '*' as its
    # parameter.
    def replace(re, ret)
      begin
        add(re, ret, true)
      rescue JavaException => e
        # should never occur if replace is true
      end
    end
    
    typesig { [String] }
    # Delete the regular expression and its target.
    # @param re The regular expression to be deleted from the pool.
    # must begin or end with a '*'
    # @return target - the old target.
    def delete(re)
      o = nil
      p = @prefix_machine
      best = p
      len = re.length - 1
      i = 0
      prefix = true
      if (!re.starts_with("*") || !re.ends_with("*"))
        len += 1
      end
      if (len <= 0)
        return nil
      end
      # March forward through the prefix machine
      i = 0
      while !(p).nil?
        if (!(p.attr_result).nil? && p.attr_depth < BIG && (!p.attr_exact || (i).equal?(len)))
          best = p
        end
        if (i >= len)
          break
        end
        p = p.find(re.char_at(i))
        i += 1
      end
      # march backward through the suffix machine
      p = @suffix_machine
      i = len
      while (i -= 1) >= 0 && !(p).nil?
        if (!(p.attr_result).nil? && p.attr_depth < BIG)
          prefix = false
          best = p
        end
        p = p.find(re.char_at(i))
      end
      # delete only if there is an exact match
      if (prefix)
        if ((re == best.attr_re))
          o = best.attr_result
          best.attr_result = nil
        end
      else
        if ((re == best.attr_re))
          o = best.attr_result
          best.attr_result = nil
        end
      end
      return o
    end
    
    typesig { [String] }
    # Search for a match to a string & return the object associated
    # with it with the match.  When multiple regular expressions
    # would match the string, the best match is returned first.
    # The next best match is returned the next time matchNext is
    # called.
    # @param s    The string to match against the regular expressions
    # in the pool.
    # @return     null on failure, otherwise the object associated with
    # the regular expression when it was added to the pool.
    # If the object is an instance of RegexpTarget, then
    # the return value is the result from calling
    # return.found(string_that_matched_wildcard).
    def match(s)
      return match_after(s, BIG)
    end
    
    typesig { [String] }
    # Identical to match except that it will only find matches to
    # regular expressions that were added to the pool <i>after</i>
    # the last regular expression that matched in the last call
    # to match() or matchNext()
    def match_next(s)
      return match_after(s, @last_depth)
    end
    
    typesig { [String, Object, ::Java::Boolean] }
    def add(re, ret, replace)
      len = re.length
      p = nil
      if ((re.char_at(0)).equal?(Character.new(?*.ord)))
        p = @suffix_machine
        while (len > 1)
          p = p.add(re.char_at((len -= 1)))
        end
      else
        exact = false
        if ((re.char_at(len - 1)).equal?(Character.new(?*.ord)))
          len -= 1
        else
          exact = true
        end
        p = @prefix_machine
        i = 0
        while i < len
          p = p.add(re.char_at(i))
          i += 1
        end
        p.attr_exact = exact
      end
      if (!(p.attr_result).nil? && !replace)
        raise REException.new(re + " is a duplicate")
      end
      p.attr_re = re
      p.attr_result = ret
    end
    
    typesig { [String, ::Java::Int] }
    def match_after(s, last_match_depth)
      p = @prefix_machine
      best = p
      bst = 0
      bend = 0
      len = s.length
      i = 0
      if (len <= 0)
        return nil
      end
      # March forward through the prefix machine
      i = 0
      while !(p).nil?
        if (!(p.attr_result).nil? && p.attr_depth < last_match_depth && (!p.attr_exact || (i).equal?(len)))
          @last_depth = p.attr_depth
          best = p
          bst = i
          bend = len
        end
        if (i >= len)
          break
        end
        p = p.find(s.char_at(i))
        i += 1
      end
      # march backward through the suffix machine
      p = @suffix_machine
      i = len
      while (i -= 1) >= 0 && !(p).nil?
        if (!(p.attr_result).nil? && p.attr_depth < last_match_depth)
          @last_depth = p.attr_depth
          best = p
          bst = 0
          bend = i + 1
        end
        p = p.find(s.char_at(i))
      end
      o = best.attr_result
      if (!(o).nil? && o.is_a?(RegexpTarget))
        o = (o).found(s.substring(bst, bend))
      end
      return o
    end
    
    typesig { [] }
    # Resets the pool so that the next call to matchNext looks
    # at all regular expressions in the pool.  match(s); is equivalent
    # to reset(); matchNext(s);
    # <p><b>Multithreading note:</b> reset/nextMatch leave state in the
    # regular expression pool.  If multiple threads could be using this
    # pool this way, they should be syncronized to avoid race hazards.
    # match() was done in such a way that there are no such race
    # hazards: multiple threads can be matching in the same pool
    # simultaneously.
    def reset
      @last_depth = BIG
    end
    
    typesig { [PrintStream] }
    # Print this pool to standard output
    def print(out)
      out.print("Regexp pool:\n")
      if (!(@suffix_machine.attr_firstchild).nil?)
        out.print(" Suffix machine: ")
        @suffix_machine.attr_firstchild.print(out)
        out.print("\n")
      end
      if (!(@prefix_machine.attr_firstchild).nil?)
        out.print(" Prefix machine: ")
        @prefix_machine.attr_firstchild.print(out)
        out.print("\n")
      end
    end
    
    private
    alias_method :initialize__regexp_pool, :initialize
  end
  
  # A node in a regular expression finite state machine.
  class RegexpNode 
    include_class_members RegexpPoolImports
    
    attr_accessor :c
    alias_method :attr_c, :c
    undef_method :c
    alias_method :attr_c=, :c=
    undef_method :c=
    
    attr_accessor :firstchild
    alias_method :attr_firstchild, :firstchild
    undef_method :firstchild
    alias_method :attr_firstchild=, :firstchild=
    undef_method :firstchild=
    
    attr_accessor :nextsibling
    alias_method :attr_nextsibling, :nextsibling
    undef_method :nextsibling
    alias_method :attr_nextsibling=, :nextsibling=
    undef_method :nextsibling=
    
    attr_accessor :depth
    alias_method :attr_depth, :depth
    undef_method :depth
    alias_method :attr_depth=, :depth=
    undef_method :depth=
    
    attr_accessor :exact
    alias_method :attr_exact, :exact
    undef_method :exact
    alias_method :attr_exact=, :exact=
    undef_method :exact=
    
    attr_accessor :result
    alias_method :attr_result, :result
    undef_method :result
    alias_method :attr_result=, :result=
    undef_method :result=
    
    attr_accessor :re
    alias_method :attr_re, :re
    undef_method :re
    alias_method :attr_re=, :re=
    undef_method :re=
    
    typesig { [] }
    def initialize
      @c = 0
      @firstchild = nil
      @nextsibling = nil
      @depth = 0
      @exact = false
      @result = nil
      @re = nil
      @c = Character.new(?#.ord)
      @depth = 0
    end
    
    typesig { [::Java::Char, ::Java::Int] }
    def initialize(c, depth)
      @c = 0
      @firstchild = nil
      @nextsibling = nil
      @depth = 0
      @exact = false
      @result = nil
      @re = nil
      @c = c
      @depth = depth
    end
    
    typesig { [::Java::Char] }
    def add(c)
      p = @firstchild
      if ((p).nil?)
        p = RegexpNode.new(c, @depth + 1)
      else
        while (!(p).nil?)
          if ((p.attr_c).equal?(c))
            return p
          else
            p = p.attr_nextsibling
          end
        end
        p = RegexpNode.new(c, @depth + 1)
        p.attr_nextsibling = @firstchild
      end
      @firstchild = p
      return p
    end
    
    typesig { [::Java::Char] }
    def find(c)
      p = @firstchild
      while !(p).nil?
        if ((p.attr_c).equal?(c))
          return p
        end
        p = p.attr_nextsibling
      end
      return nil
    end
    
    typesig { [PrintStream] }
    def print(out)
      if (!(@nextsibling).nil?)
        p = self
        out.print("(")
        while (!(p).nil?)
          out.write(p.attr_c)
          if (!(p.attr_firstchild).nil?)
            p.attr_firstchild.print(out)
          end
          p = p.attr_nextsibling
          out.write(!(p).nil? ? Character.new(?|.ord) : Character.new(?).ord))
        end
      else
        out.write(@c)
        if (!(@firstchild).nil?)
          @firstchild.print(out)
        end
      end
    end
    
    private
    alias_method :initialize__regexp_node, :initialize
  end
  
end
