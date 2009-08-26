require "rjava"

# Copyright 1996-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www
  module HeaderParserImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www
      include_const ::Java::Util, :Iterator
    }
  end
  
  # public static void main(String[] a) throws Exception {
  # System.out.print("enter line to parse> ");
  # System.out.flush();
  # DataInputStream dis = new DataInputStream(System.in);
  # String line = dis.readLine();
  # HeaderParser p = new HeaderParser(line);
  # for (int i = 0; i < asize; ++i) {
  # if (p.findKey(i) == null) break;
  # String v = p.findValue(i);
  # System.out.println(i + ") " +p.findKey(i) + "="+v);
  # }
  # System.out.println("Done!");
  # 
  # }
  # 
  # This is useful for the nightmare of parsing multi-part HTTP/RFC822 headers
  # sensibly:
  # From a String like: 'timeout=15, max=5'
  # create an array of Strings:
  # { {"timeout", "15"},
  # {"max", "5"}
  # }
  # From one like: 'Basic Realm="FuzzFace" Foo="Biz Bar Baz"'
  # create one like (no quotes in literal):
  # { {"basic", null},
  # {"realm", "FuzzFace"}
  # {"foo", "Biz Bar Baz"}
  # }
  # keys are converted to lower case, vals are left as is....
  # 
  # @author Dave Brown
  class HeaderParser 
    include_class_members HeaderParserImports
    
    # table of key/val pairs
    attr_accessor :raw
    alias_method :attr_raw, :raw
    undef_method :raw
    alias_method :attr_raw=, :raw=
    undef_method :raw=
    
    attr_accessor :tab
    alias_method :attr_tab, :tab
    undef_method :tab
    alias_method :attr_tab=, :tab=
    undef_method :tab=
    
    attr_accessor :nkeys
    alias_method :attr_nkeys, :nkeys
    undef_method :nkeys
    alias_method :attr_nkeys=, :nkeys=
    undef_method :nkeys=
    
    attr_accessor :asize
    alias_method :attr_asize, :asize
    undef_method :asize
    alias_method :attr_asize=, :asize=
    undef_method :asize=
    
    typesig { [String] }
    # initial size of array is 10
    def initialize(raw)
      @raw = nil
      @tab = nil
      @nkeys = 0
      @asize = 10
      @raw = raw
      @tab = Array.typed(Array.typed(String)).new(@asize) { Array.typed(String).new(2) { nil } }
      parse
    end
    
    typesig { [] }
    def initialize
      @raw = nil
      @tab = nil
      @nkeys = 0
      @asize = 10
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # create a new HeaderParser from this, whose keys (and corresponding values)
    # range from "start" to "end-1"
    def subsequence(start, end_)
      if ((start).equal?(0) && (end_).equal?(@nkeys))
        return self
      end
      if (start < 0 || start >= end_ || end_ > @nkeys)
        raise IllegalArgumentException.new("invalid start or end")
      end
      n = HeaderParser.new
      n.attr_tab = Array.typed(Array.typed(String)).new(@asize) { Array.typed(String).new(2) { nil } }
      n.attr_asize = @asize
      System.arraycopy(@tab, start, n.attr_tab, 0, (end_ - start))
      n.attr_nkeys = (end_ - start)
      return n
    end
    
    typesig { [] }
    def parse
      if (!(@raw).nil?)
        @raw = RJava.cast_to_string(@raw.trim)
        ca = @raw.to_char_array
        beg = 0
        end_ = 0
        i = 0
        in_key = true
        in_quote = false
        len = ca.attr_length
        while (end_ < len)
          c = ca[end_]
          if (((c).equal?(Character.new(?=.ord))) && !in_quote)
            # end of a key
            @tab[i][0] = String.new(ca, beg, end_ - beg).to_lower_case
            in_key = false
            end_ += 1
            beg = end_
          else
            if ((c).equal?(Character.new(?\".ord)))
              if (in_quote)
                @tab[((i += 1) - 1)][1] = String.new(ca, beg, end_ - beg)
                in_quote = false
                begin
                  end_ += 1
                end while (end_ < len && ((ca[end_]).equal?(Character.new(?\s.ord)) || (ca[end_]).equal?(Character.new(?,.ord))))
                in_key = true
                beg = end_
              else
                in_quote = true
                end_ += 1
                beg = end_
              end
            else
              if ((c).equal?(Character.new(?\s.ord)) || (c).equal?(Character.new(?,.ord)))
                # end key/val, of whatever we're in
                if (in_quote)
                  end_ += 1
                  next
                else
                  if (in_key)
                    @tab[((i += 1) - 1)][0] = (String.new(ca, beg, end_ - beg)).to_lower_case
                  else
                    @tab[((i += 1) - 1)][1] = (String.new(ca, beg, end_ - beg))
                  end
                end
                while (end_ < len && ((ca[end_]).equal?(Character.new(?\s.ord)) || (ca[end_]).equal?(Character.new(?,.ord))))
                  end_ += 1
                end
                in_key = true
                beg = end_
              else
                end_ += 1
              end
            end
          end
          if ((i).equal?(@asize))
            @asize = @asize * 2
            ntab = Array.typed(Array.typed(String)).new(@asize) { Array.typed(String).new(2) { nil } }
            System.arraycopy(@tab, 0, ntab, 0, @tab.attr_length)
            @tab = ntab
          end
        end
        # get last key/val, if any
        if ((end_ -= 1) > beg)
          if (!in_key)
            if ((ca[end_]).equal?(Character.new(?\".ord)))
              @tab[((i += 1) - 1)][1] = (String.new(ca, beg, end_ - beg))
            else
              @tab[((i += 1) - 1)][1] = (String.new(ca, beg, end_ - beg + 1))
            end
          else
            @tab[((i += 1) - 1)][0] = (String.new(ca, beg, end_ - beg + 1)).to_lower_case
          end
        else
          if ((end_).equal?(beg))
            if (!in_key)
              if ((ca[end_]).equal?(Character.new(?\".ord)))
                @tab[((i += 1) - 1)][1] = String.value_of(ca[end_ - 1])
              else
                @tab[((i += 1) - 1)][1] = String.value_of(ca[end_])
              end
            else
              @tab[((i += 1) - 1)][0] = String.value_of(ca[end_]).to_lower_case
            end
          end
        end
        @nkeys = i
      end
    end
    
    typesig { [::Java::Int] }
    def find_key(i)
      if (i < 0 || i > @asize)
        return nil
      end
      return @tab[i][0]
    end
    
    typesig { [::Java::Int] }
    def find_value(i)
      if (i < 0 || i > @asize)
        return nil
      end
      return @tab[i][1]
    end
    
    typesig { [String] }
    def find_value(key)
      return find_value(key, nil)
    end
    
    typesig { [String, String] }
    def find_value(k, default)
      if ((k).nil?)
        return default
      end
      k = RJava.cast_to_string(k.to_lower_case)
      i = 0
      while i < @asize
        if ((@tab[i][0]).nil?)
          return default
        else
          if ((k == @tab[i][0]))
            return @tab[i][1]
          end
        end
        (i += 1)
      end
      return default
    end
    
    class_module.module_eval {
      const_set_lazy(:ParserIterator) { Class.new do
        extend LocalClass
        include_class_members HeaderParser
        include Iterator
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        attr_accessor :returns_value
        alias_method :attr_returns_value, :returns_value
        undef_method :returns_value
        alias_method :attr_returns_value=, :returns_value=
        undef_method :returns_value=
        
        typesig { [::Java::Boolean] }
        # or key
        def initialize(return_value)
          @index = 0
          @returns_value = false
          @returns_value = return_value
        end
        
        typesig { [] }
        def has_next
          return @index < self.attr_nkeys
        end
        
        typesig { [] }
        def next_
          return self.attr_tab[((@index += 1) - 1)][@returns_value ? 1 : 0]
        end
        
        typesig { [] }
        def remove
          raise self.class::UnsupportedOperationException.new("remove not supported")
        end
        
        private
        alias_method :initialize__parser_iterator, :initialize
      end }
    }
    
    typesig { [] }
    def keys
      return ParserIterator.new_local(self, false)
    end
    
    typesig { [] }
    def values
      return ParserIterator.new_local(self, true)
    end
    
    typesig { [] }
    def to_s
      k = keys
      sbuf = StringBuffer.new
      sbuf.append("{size=" + RJava.cast_to_string(@asize) + " nkeys=" + RJava.cast_to_string(@nkeys) + " ")
      i = 0
      while k.has_next
        key = k.next_
        val = find_value(i)
        if (!(val).nil? && ("" == val))
          val = RJava.cast_to_string(nil)
        end
        sbuf.append(" {" + key + RJava.cast_to_string(((val).nil? ? "" : "," + val)) + "}")
        if (k.has_next)
          sbuf.append(",")
        end
        i += 1
      end
      sbuf.append(" }")
      return String.new(sbuf)
    end
    
    typesig { [String, ::Java::Int] }
    def find_int(k, default)
      begin
        return JavaInteger.parse_int(find_value(k, String.value_of(default)))
      rescue JavaThrowable => t
        return default
      end
    end
    
    private
    alias_method :initialize__header_parser, :initialize
  end
  
end
