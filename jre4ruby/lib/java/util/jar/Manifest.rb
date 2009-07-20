require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Jar
  module ManifestImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Jar
      include_const ::Java::Io, :FilterInputStream
      include_const ::Java::Io, :DataOutputStream
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Iterator
    }
  end
  
  # The Manifest class is used to maintain Manifest entry names and their
  # associated Attributes. There are main Manifest Attributes as well as
  # per-entry Attributes. For information on the Manifest format, please
  # see the
  # <a href="../../../../technotes/guides/jar/jar.html">
  # Manifest format specification</a>.
  # 
  # @author  David Connelly
  # @see     Attributes
  # @since   1.2
  class Manifest 
    include_class_members ManifestImports
    include Cloneable
    
    # manifest main attributes
    attr_accessor :attr
    alias_method :attr_attr, :attr
    undef_method :attr
    alias_method :attr_attr=, :attr=
    undef_method :attr=
    
    # manifest entries
    attr_accessor :entries
    alias_method :attr_entries, :entries
    undef_method :entries
    alias_method :attr_entries=, :entries=
    undef_method :entries=
    
    typesig { [] }
    # Constructs a new, empty Manifest.
    def initialize
      @attr = Attributes.new
      @entries = HashMap.new
    end
    
    typesig { [InputStream] }
    # Constructs a new Manifest from the specified input stream.
    # 
    # @param is the input stream containing manifest data
    # @throws IOException if an I/O error has occured
    def initialize(is)
      @attr = Attributes.new
      @entries = HashMap.new
      read(is)
    end
    
    typesig { [Manifest] }
    # Constructs a new Manifest that is a copy of the specified Manifest.
    # 
    # @param man the Manifest to copy
    def initialize(man)
      @attr = Attributes.new
      @entries = HashMap.new
      @attr.put_all(man.get_main_attributes)
      @entries.put_all(man.get_entries)
    end
    
    typesig { [] }
    # Returns the main Attributes for the Manifest.
    # @return the main Attributes for the Manifest
    def get_main_attributes
      return @attr
    end
    
    typesig { [] }
    # Returns a Map of the entries contained in this Manifest. Each entry
    # is represented by a String name (key) and associated Attributes (value).
    # The Map permits the {@code null} key, but no entry with a null key is
    # created by {@link #read}, nor is such an entry written by using {@link
    # #write}.
    # 
    # @return a Map of the entries contained in this Manifest
    def get_entries
      return @entries
    end
    
    typesig { [String] }
    # Returns the Attributes for the specified entry name.
    # This method is defined as:
    # <pre>
    # return (Attributes)getEntries().get(name)
    # </pre>
    # Though {@code null} is a valid {@code name}, when
    # {@code getAttributes(null)} is invoked on a {@code Manifest}
    # obtained from a jar file, {@code null} will be returned.  While jar
    # files themselves do not allow {@code null}-named attributes, it is
    # possible to invoke {@link #getEntries} on a {@code Manifest}, and
    # on that result, invoke {@code put} with a null key and an
    # arbitrary value.  Subsequent invocations of
    # {@code getAttributes(null)} will return the just-{@code put}
    # value.
    # <p>
    # Note that this method does not return the manifest's main attributes;
    # see {@link #getMainAttributes}.
    # 
    # @param name entry name
    # @return the Attributes for the specified entry name
    def get_attributes(name)
      return get_entries.get(name)
    end
    
    typesig { [] }
    # Clears the main Attributes as well as the entries in this Manifest.
    def clear
      @attr.clear
      @entries.clear
    end
    
    typesig { [OutputStream] }
    # Writes the Manifest to the specified OutputStream.
    # Attributes.Name.MANIFEST_VERSION must be set in
    # MainAttributes prior to invoking this method.
    # 
    # @param out the output stream
    # @exception IOException if an I/O error has occurred
    # @see #getMainAttributes
    def write(out)
      dos = DataOutputStream.new(out)
      # Write out the main attributes for the manifest
      @attr.write_main(dos)
      # Now write out the pre-entry attributes
      it = @entries.entry_set.iterator
      while (it.has_next)
        e = it.next
        buffer = StringBuffer.new("Name: ")
        value = e.get_key
        if (!(value).nil?)
          vb = value.get_bytes("UTF8")
          value = (String.new(vb, 0, 0, vb.attr_length)).to_s
        end
        buffer.append(value)
        buffer.append("\r\n")
        make72_safe(buffer)
        dos.write_bytes(buffer.to_s)
        (e.get_value).write(dos)
      end
      dos.flush
    end
    
    class_module.module_eval {
      typesig { [StringBuffer] }
      # Adds line breaks to enforce a maximum 72 bytes per line.
      def make72_safe(line)
        length_ = line.length
        if (length_ > 72)
          index = 70
          while (index < length_ - 2)
            line.insert(index, "\r\n ")
            index += 72
            length_ += 3
          end
        end
        return
      end
    }
    
    typesig { [InputStream] }
    # Reads the Manifest from the specified InputStream. The entry
    # names and attributes read will be merged in with the current
    # manifest entries.
    # 
    # @param is the input stream
    # @exception IOException if an I/O error has occurred
    def read(is)
      # Buffered input stream for reading manifest data
      fis = FastInputStream.new(is)
      # Line buffer
      lbuf = Array.typed(::Java::Byte).new(512) { 0 }
      # Read the main attributes for the manifest
      @attr.read(fis, lbuf)
      # Total number of entries, attributes read
      ecount = 0
      acount = 0
      # Average size of entry attributes
      asize = 2
      # Now parse the manifest entries
      len = 0
      name = nil
      skip_empty_lines = true
      lastline = nil
      while (!((len = fis.read_line(lbuf))).equal?(-1))
        if (!(lbuf[(len -= 1)]).equal?(Character.new(?\n.ord)))
          raise IOException.new("manifest line too long")
        end
        if (len > 0 && (lbuf[len - 1]).equal?(Character.new(?\r.ord)))
          (len -= 1)
        end
        if ((len).equal?(0) && skip_empty_lines)
          next
        end
        skip_empty_lines = false
        if ((name).nil?)
          name = (parse_name(lbuf, len)).to_s
          if ((name).nil?)
            raise IOException.new("invalid manifest format")
          end
          if ((fis.peek).equal?(Character.new(?\s.ord)))
            # name is wrapped
            lastline = Array.typed(::Java::Byte).new(len - 6) { 0 }
            System.arraycopy(lbuf, 6, lastline, 0, len - 6)
            next
          end
        else
          # continuation line
          buf = Array.typed(::Java::Byte).new(lastline.attr_length + len - 1) { 0 }
          System.arraycopy(lastline, 0, buf, 0, lastline.attr_length)
          System.arraycopy(lbuf, 1, buf, lastline.attr_length, len - 1)
          if ((fis.peek).equal?(Character.new(?\s.ord)))
            # name is wrapped
            lastline = buf
            next
          end
          name = (String.new(buf, 0, buf.attr_length, "UTF8")).to_s
          lastline = nil
        end
        attr = get_attributes(name)
        if ((attr).nil?)
          attr = Attributes.new(asize)
          @entries.put(name, attr)
        end
        attr.read(fis, lbuf)
        ecount += 1
        acount += attr.size
        # XXX: Fix for when the average is 0. When it is 0,
        # you get an Attributes object with an initial
        # capacity of 0, which tickles a bug in HashMap.
        asize = Math.max(2, acount / ecount)
        name = (nil).to_s
        skip_empty_lines = true
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def parse_name(lbuf, len)
      if ((to_lower(lbuf[0])).equal?(Character.new(?n.ord)) && (to_lower(lbuf[1])).equal?(Character.new(?a.ord)) && (to_lower(lbuf[2])).equal?(Character.new(?m.ord)) && (to_lower(lbuf[3])).equal?(Character.new(?e.ord)) && (lbuf[4]).equal?(Character.new(?:.ord)) && (lbuf[5]).equal?(Character.new(?\s.ord)))
        begin
          return String.new(lbuf, 6, len - 6, "UTF8")
        rescue Exception => e
        end
      end
      return nil
    end
    
    typesig { [::Java::Int] }
    def to_lower(c)
      return (c >= Character.new(?A.ord) && c <= Character.new(?Z.ord)) ? Character.new(?a.ord) + (c - Character.new(?A.ord)) : c
    end
    
    typesig { [Object] }
    # Returns true if the specified Object is also a Manifest and has
    # the same main Attributes and entries.
    # 
    # @param o the object to be compared
    # @return true if the specified Object is also a Manifest and has
    # the same main Attributes and entries
    def equals(o)
      if (o.is_a?(Manifest))
        m = o
        return (@attr == m.get_main_attributes) && (@entries == m.get_entries)
      else
        return false
      end
    end
    
    typesig { [] }
    # Returns the hash code for this Manifest.
    def hash_code
      return @attr.hash_code + @entries.hash_code
    end
    
    typesig { [] }
    # Returns a shallow copy of this Manifest.  The shallow copy is
    # implemented as follows:
    # <pre>
    # public Object clone() { return new Manifest(this); }
    # </pre>
    # @return a shallow copy of this Manifest
    def clone
      return Manifest.new(self)
    end
    
    class_module.module_eval {
      # A fast buffered input stream for parsing manifest files.
      const_set_lazy(:FastInputStream) { Class.new(FilterInputStream) do
        include_class_members Manifest
        
        attr_accessor :buf
        alias_method :attr_buf, :buf
        undef_method :buf
        alias_method :attr_buf=, :buf=
        undef_method :buf=
        
        attr_accessor :count
        alias_method :attr_count, :count
        undef_method :count
        alias_method :attr_count=, :count=
        undef_method :count=
        
        attr_accessor :pos
        alias_method :attr_pos, :pos
        undef_method :pos
        alias_method :attr_pos=, :pos=
        undef_method :pos=
        
        typesig { [InputStream] }
        def initialize(in_)
          initialize__fast_input_stream(in_, 8192)
        end
        
        typesig { [InputStream, ::Java::Int] }
        def initialize(in_, size)
          @buf = nil
          @count = 0
          @pos = 0
          super(in_)
          @count = 0
          @pos = 0
          @buf = Array.typed(::Java::Byte).new(size) { 0 }
        end
        
        typesig { [] }
        def read
          if (@pos >= @count)
            fill
            if (@pos >= @count)
              return -1
            end
          end
          return @buf[((@pos += 1) - 1)] & 0xff
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, len)
          avail = @count - @pos
          if (avail <= 0)
            if (len >= @buf.attr_length)
              return self.attr_in.read(b, off, len)
            end
            fill
            avail = @count - @pos
            if (avail <= 0)
              return -1
            end
          end
          if (len > avail)
            len = avail
          end
          System.arraycopy(@buf, @pos, b, off, len)
          @pos += len
          return len
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        # Reads 'len' bytes from the input stream, or until an end-of-line
        # is reached. Returns the number of bytes read.
        def read_line(b, off, len)
          tbuf = @buf
          total = 0
          while (total < len)
            avail = @count - @pos
            if (avail <= 0)
              fill
              avail = @count - @pos
              if (avail <= 0)
                return -1
              end
            end
            n = len - total
            if (n > avail)
              n = avail
            end
            tpos = @pos
            maxpos = tpos + n
            while (tpos < maxpos && !(tbuf[((tpos += 1) - 1)]).equal?(Character.new(?\n.ord)))
            end
            n = tpos - @pos
            System.arraycopy(tbuf, @pos, b, off, n)
            off += n
            total += n
            @pos = tpos
            if ((tbuf[tpos - 1]).equal?(Character.new(?\n.ord)))
              break
            end
          end
          return total
        end
        
        typesig { [] }
        def peek
          if ((@pos).equal?(@count))
            fill
          end
          return @buf[@pos]
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def read_line(b)
          return read_line(b, 0, b.attr_length)
        end
        
        typesig { [::Java::Long] }
        def skip(n)
          if (n <= 0)
            return 0
          end
          avail = @count - @pos
          if (avail <= 0)
            return self.attr_in.skip(n)
          end
          if (n > avail)
            n = avail
          end
          @pos += n
          return n
        end
        
        typesig { [] }
        def available
          return (@count - @pos) + self.attr_in.available
        end
        
        typesig { [] }
        def close
          if (!(self.attr_in).nil?)
            self.attr_in.close
            self.attr_in = nil
            @buf = nil
          end
        end
        
        typesig { [] }
        def fill
          @count = @pos = 0
          n = self.attr_in.read(@buf, 0, @buf.attr_length)
          if (n > 0)
            @count = n
          end
        end
        
        private
        alias_method :initialize__fast_input_stream, :initialize
      end }
    }
    
    private
    alias_method :initialize__manifest, :initialize
  end
  
end
