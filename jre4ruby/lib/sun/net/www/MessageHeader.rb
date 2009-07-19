require "rjava"

# Copyright 1995-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# -
# news stream opener
module Sun::Net::Www
  module MessageHeaderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www
      include ::Java::Io
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # An RFC 844 or MIME message header.  Includes methods
  # for parsing headers from incoming streams, fetching
  # values, setting values, and printing headers.
  # Key values of null are legal: they indicate lines in
  # the header that don't have a valid key, but do have
  # a value (this isn't legal according to the standard,
  # but lines like this are everywhere).
  class MessageHeader 
    include_class_members MessageHeaderImports
    
    attr_accessor :keys
    alias_method :attr_keys, :keys
    undef_method :keys
    alias_method :attr_keys=, :keys=
    undef_method :keys=
    
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
    attr_accessor :nkeys
    alias_method :attr_nkeys, :nkeys
    undef_method :nkeys
    alias_method :attr_nkeys=, :nkeys=
    undef_method :nkeys=
    
    typesig { [] }
    def initialize
      @keys = nil
      @values = nil
      @nkeys = 0
      grow
    end
    
    typesig { [InputStream] }
    def initialize(is)
      @keys = nil
      @values = nil
      @nkeys = 0
      parse_header(is)
    end
    
    typesig { [] }
    # Reset a message header (all key/values removed)
    def reset
      synchronized(self) do
        @keys = nil
        @values = nil
        @nkeys = 0
        grow
      end
    end
    
    typesig { [String] }
    # Find the value that corresponds to this key.
    # It finds only the first occurrence of the key.
    # @param k the key to find.
    # @return null if not found.
    def find_value(k)
      synchronized(self) do
        if ((k).nil?)
          i = @nkeys
          while (i -= 1) >= 0
            if ((@keys[i]).nil?)
              return @values[i]
            end
          end
        else
          i = @nkeys
          while (i -= 1) >= 0
            if (k.equals_ignore_case(@keys[i]))
              return @values[i]
            end
          end
        end
        return nil
      end
    end
    
    typesig { [String] }
    # return the location of the key
    def get_key(k)
      synchronized(self) do
        i = @nkeys
        while (i -= 1) >= 0
          if (((@keys[i]).equal?(k)) || (!(k).nil? && k.equals_ignore_case(@keys[i])))
            return i
          end
        end
        return -1
      end
    end
    
    typesig { [::Java::Int] }
    def get_key(n)
      synchronized(self) do
        if (n < 0 || n >= @nkeys)
          return nil
        end
        return @keys[n]
      end
    end
    
    typesig { [::Java::Int] }
    def get_value(n)
      synchronized(self) do
        if (n < 0 || n >= @nkeys)
          return nil
        end
        return @values[n]
      end
    end
    
    typesig { [String, String] }
    # Deprecated: Use multiValueIterator() instead.
    # 
    # Find the next value that corresponds to this key.
    # It finds the first value that follows v. To iterate
    # over all the values of a key use:
    # <pre>
    # for(String v=h.findValue(k); v!=null; v=h.findNextValue(k, v)) {
    # ...
    # }
    # </pre>
    def find_next_value(k, v)
      synchronized(self) do
        found_v = false
        if ((k).nil?)
          i = @nkeys
          while (i -= 1) >= 0
            if ((@keys[i]).nil?)
              if (found_v)
                return @values[i]
              else
                if ((@values[i]).equal?(v))
                  found_v = true
                end
              end
            end
          end
        else
          i = @nkeys
          while (i -= 1) >= 0
            if (k.equals_ignore_case(@keys[i]))
              if (found_v)
                return @values[i]
              else
                if ((@values[i]).equal?(v))
                  found_v = true
                end
              end
            end
          end
        end
        return nil
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:HeaderIterator) { Class.new do
        extend LocalClass
        include_class_members MessageHeader
        include Iterator
        
        attr_accessor :index
        alias_method :attr_index, :index
        undef_method :index
        alias_method :attr_index=, :index=
        undef_method :index=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :have_next
        alias_method :attr_have_next, :have_next
        undef_method :have_next
        alias_method :attr_have_next=, :have_next=
        undef_method :have_next=
        
        attr_accessor :lock
        alias_method :attr_lock, :lock
        undef_method :lock
        alias_method :attr_lock=, :lock=
        undef_method :lock=
        
        typesig { [String, Object] }
        def initialize(k, lock)
          @index = 0
          @next = -1
          @key = nil
          @have_next = false
          @lock = nil
          @key = k
          @lock = lock
        end
        
        typesig { [] }
        def has_next
          synchronized((@lock)) do
            if (@have_next)
              return true
            end
            while (@index < self.attr_nkeys)
              if (@key.equals_ignore_case(self.attr_keys[@index]))
                @have_next = true
                @next = ((@index += 1) - 1)
                return true
              end
              ((@index += 1) - 1)
            end
            return false
          end
        end
        
        typesig { [] }
        def next
          synchronized((@lock)) do
            if (@have_next)
              @have_next = false
              return self.attr_values[@next]
            end
            if (has_next)
              return next
            else
              raise NoSuchElementException.new("No more elements")
            end
          end
        end
        
        typesig { [] }
        def remove
          raise UnsupportedOperationException.new("remove not allowed")
        end
        
        private
        alias_method :initialize__header_iterator, :initialize
      end }
    }
    
    typesig { [String] }
    # return an Iterator that returns all values of a particular
    # key in sequence
    def multi_value_iterator(k)
      return HeaderIterator.new_local(self, k, self)
    end
    
    typesig { [] }
    def get_headers
      synchronized(self) do
        return get_headers(nil)
      end
    end
    
    typesig { [Array.typed(String)] }
    def get_headers(exclude_list)
      synchronized(self) do
        skip_it = false
        m = HashMap.new
        i = @nkeys
        while (i -= 1) >= 0
          if (!(exclude_list).nil?)
            # check if the key is in the excludeList.
            # if so, don't include it in the Map.
            j = 0
            while j < exclude_list.attr_length
              if ((!(exclude_list[j]).nil?) && (exclude_list[j].equals_ignore_case(@keys[i])))
                skip_it = true
                break
              end
              ((j += 1) - 1)
            end
          end
          if (!skip_it)
            l = m.get(@keys[i])
            if ((l).nil?)
              l = ArrayList.new
              m.put(@keys[i], l)
            end
            l.add(@values[i])
          else
            # reset the flag
            skip_it = false
          end
        end
        key_set_ = m.key_set
        i_ = key_set_.iterator
        while i_.has_next
          key = i_.next
          l = m.get(key)
          m.put(key, Collections.unmodifiable_list(l))
        end
        return Collections.unmodifiable_map(m)
      end
    end
    
    typesig { [PrintStream] }
    # Prints the key-value pairs represented by this
    # header.  Also prints the RFC required blank line
    # at the end. Omits pairs with a null key.
    def print(p)
      synchronized(self) do
        i = 0
        while i < @nkeys
          if (!(@keys[i]).nil?)
            p.print((@keys[i] + (!(@values[i]).nil? ? ": " + (@values[i]).to_s : "")).to_s + "\r\n")
          end
          ((i += 1) - 1)
        end
        p.print("\r\n")
        p.flush
      end
    end
    
    typesig { [String, String] }
    # Adds a key value pair to the end of the
    # header.  Duplicates are allowed
    def add(k, v)
      synchronized(self) do
        grow
        @keys[@nkeys] = k
        @values[@nkeys] = v
        ((@nkeys += 1) - 1)
      end
    end
    
    typesig { [String, String] }
    # Prepends a key value pair to the beginning of the
    # header.  Duplicates are allowed
    def prepend(k, v)
      synchronized(self) do
        grow
        i = @nkeys
        while i > 0
          @keys[i] = @keys[i - 1]
          @values[i] = @values[i - 1]
          ((i -= 1) + 1)
        end
        @keys[0] = k
        @values[0] = v
        ((@nkeys += 1) - 1)
      end
    end
    
    typesig { [::Java::Int, String, String] }
    # Overwrite the previous key/val pair at location 'i'
    # with the new k/v.  If the index didn't exist before
    # the key/val is simply tacked onto the end.
    def set(i, k, v)
      synchronized(self) do
        grow
        if (i < 0)
          return
        else
          if (i >= @nkeys)
            add(k, v)
          else
            @keys[i] = k
            @values[i] = v
          end
        end
      end
    end
    
    typesig { [] }
    # grow the key/value arrays as needed
    def grow
      if ((@keys).nil? || @nkeys >= @keys.attr_length)
        nk = Array.typed(String).new(@nkeys + 4) { nil }
        nv = Array.typed(String).new(@nkeys + 4) { nil }
        if (!(@keys).nil?)
          System.arraycopy(@keys, 0, nk, 0, @nkeys)
        end
        if (!(@values).nil?)
          System.arraycopy(@values, 0, nv, 0, @nkeys)
        end
        @keys = nk
        @values = nv
      end
    end
    
    typesig { [String] }
    # Remove the key from the header. If there are multiple values under
    # the same key, they are all removed.
    # Nothing is done if the key doesn't exist.
    # After a remove, the other pairs' order are not changed.
    # @param k the key to remove
    def remove(k)
      synchronized(self) do
        if ((k).nil?)
          i = 0
          while i < @nkeys
            while ((@keys[i]).nil? && i < @nkeys)
              j = i
              while j < @nkeys - 1
                @keys[j] = @keys[j + 1]
                @values[j] = @values[j + 1]
                ((j += 1) - 1)
              end
              ((@nkeys -= 1) + 1)
            end
            ((i += 1) - 1)
          end
        else
          i = 0
          while i < @nkeys
            while (k.equals_ignore_case(@keys[i]) && i < @nkeys)
              j = i
              while j < @nkeys - 1
                @keys[j] = @keys[j + 1]
                @values[j] = @values[j + 1]
                ((j += 1) - 1)
              end
              ((@nkeys -= 1) + 1)
            end
            ((i += 1) - 1)
          end
        end
      end
    end
    
    typesig { [String, String] }
    # Sets the value of a key.  If the key already
    # exists in the header, it's value will be
    # changed.  Otherwise a new key/value pair will
    # be added to the end of the header.
    def set(k, v)
      synchronized(self) do
        i = @nkeys
        while (i -= 1) >= 0
          if (k.equals_ignore_case(@keys[i]))
            @values[i] = v
            return
          end
        end
        add(k, v)
      end
    end
    
    typesig { [String, String] }
    # Set's the value of a key only if there is no
    # key with that value already.
    def set_if_not_set(k, v)
      synchronized(self) do
        if ((find_value(k)).nil?)
          add(k, v)
        end
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Convert a message-id string to canonical form (strips off
      # leading and trailing <>s)
      def canonical_id(id)
        if ((id).nil?)
          return ""
        end
        st = 0
        len = id.length
        substr = false
        c = 0
        while (st < len && (((c = id.char_at(st))).equal?(Character.new(?<.ord)) || c <= Character.new(?\s.ord)))
          ((st += 1) - 1)
          substr = true
        end
        while (st < len && (((c = id.char_at(len - 1))).equal?(Character.new(?>.ord)) || c <= Character.new(?\s.ord)))
          ((len -= 1) + 1)
          substr = true
        end
        return substr ? id.substring(st, len) : id
      end
    }
    
    typesig { [InputStream] }
    # Parse a MIME header from an input stream.
    def parse_header(is)
      synchronized((self)) do
        @nkeys = 0
      end
      merge_header(is)
    end
    
    typesig { [InputStream] }
    # Parse and merge a MIME header from an input stream.
    def merge_header(is)
      if ((is).nil?)
        return
      end
      s = CharArray.new(10)
      firstc = is.read
      while (!(firstc).equal?(Character.new(?\n.ord)) && !(firstc).equal?(Character.new(?\r.ord)) && firstc >= 0)
        len = 0
        keyend = -1
        c = 0
        in_key = firstc > Character.new(?\s.ord)
        s[((len += 1) - 1)] = RJava.cast_to_char(firstc)
        catch(:break_parseloop) do
          while ((c = is.read) >= 0)
            case (c)
            when Character.new(?:.ord)
              if (in_key && len > 0)
                keyend = len
              end
              in_key = false
            when Character.new(?\t.ord)
              c = Character.new(?\s.ord)
              in_key = false
            when Character.new(?\s.ord)
              in_key = false
            when Character.new(?\r.ord), Character.new(?\n.ord)
              firstc = is.read
              if ((c).equal?(Character.new(?\r.ord)) && (firstc).equal?(Character.new(?\n.ord)))
                firstc = is.read
                if ((firstc).equal?(Character.new(?\r.ord)))
                  firstc = is.read
                end
              end
              if ((firstc).equal?(Character.new(?\n.ord)) || (firstc).equal?(Character.new(?\r.ord)) || firstc > Character.new(?\s.ord))
                throw :break_parseloop, :thrown
              end
              # continuation
              c = Character.new(?\s.ord)
            end
            if (len >= s.attr_length)
              ns = CharArray.new(s.attr_length * 2)
              System.arraycopy(s, 0, ns, 0, len)
              s = ns
            end
            s[((len += 1) - 1)] = RJava.cast_to_char(c)
          end
          firstc = -1
        end == :thrown or break
        while (len > 0 && s[len - 1] <= Character.new(?\s.ord))
          ((len -= 1) + 1)
        end
        k = nil
        if (keyend <= 0)
          k = (nil).to_s
          keyend = 0
        else
          k = (String.copy_value_of(s, 0, keyend)).to_s
          if (keyend < len && (s[keyend]).equal?(Character.new(?:.ord)))
            ((keyend += 1) - 1)
          end
          while (keyend < len && s[keyend] <= Character.new(?\s.ord))
            ((keyend += 1) - 1)
          end
        end
        v = nil
        if (keyend >= len)
          v = (String.new).to_s
        else
          v = (String.copy_value_of(s, keyend, len - keyend)).to_s
        end
        add(k, v)
      end
    end
    
    typesig { [] }
    def to_s
      synchronized(self) do
        result = (super + @nkeys).to_s + " pairs: "
        i = 0
        while i < @keys.attr_length && i < @nkeys
          result += "{" + (@keys[i]).to_s + ": " + (@values[i]).to_s + "}"
          ((i += 1) - 1)
        end
        return result
      end
    end
    
    private
    alias_method :initialize__message_header, :initialize
  end
  
end
