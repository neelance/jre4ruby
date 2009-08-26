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
module Sun::Security::Util
  module ManifestDigesterImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include ::Java::Security
      include_const ::Java::Util, :HashMap
      include_const ::Java::Io, :ByteArrayOutputStream
    }
  end
  
  # This class is used to compute digests on sections of the Manifest.
  class ManifestDigester 
    include_class_members ManifestDigesterImports
    
    class_module.module_eval {
      const_set_lazy(:MF_MAIN_ATTRS) { "Manifest-Main-Attributes" }
      const_attr_reader  :MF_MAIN_ATTRS
    }
    
    # the raw bytes of the manifest
    attr_accessor :raw_bytes
    alias_method :attr_raw_bytes, :raw_bytes
    undef_method :raw_bytes
    alias_method :attr_raw_bytes=, :raw_bytes=
    undef_method :raw_bytes=
    
    # the offset/length pair for a section
    attr_accessor :entries
    alias_method :attr_entries, :entries
    undef_method :entries
    alias_method :attr_entries=, :entries=
    undef_method :entries=
    
    class_module.module_eval {
      # the start of the next section
      # key is a UTF-8 string
      # state returned by findSection
      const_set_lazy(:Position) { Class.new do
        include_class_members ManifestDigester
        
        attr_accessor :end_of_first_line
        alias_method :attr_end_of_first_line, :end_of_first_line
        undef_method :end_of_first_line
        alias_method :attr_end_of_first_line=, :end_of_first_line=
        undef_method :end_of_first_line=
        
        # not including newline character
        attr_accessor :end_of_section
        alias_method :attr_end_of_section, :end_of_section
        undef_method :end_of_section
        alias_method :attr_end_of_section=, :end_of_section=
        undef_method :end_of_section=
        
        # end of section, not including the blank line
        # between sections
        attr_accessor :start_of_next
        alias_method :attr_start_of_next, :start_of_next
        undef_method :start_of_next
        alias_method :attr_start_of_next=, :start_of_next=
        undef_method :start_of_next=
        
        typesig { [] }
        def initialize
          @end_of_first_line = 0
          @end_of_section = 0
          @start_of_next = 0
        end
        
        private
        alias_method :initialize__position, :initialize
      end }
    }
    
    typesig { [::Java::Int, Position] }
    # find a section in the manifest.
    # 
    # @param offset should point to the starting offset with in the
    # raw bytes of the next section.
    # 
    # @pos set by
    # 
    # @returns false if end of bytes has been reached, otherwise returns
    # true
    def find_section(offset, pos)
      i = offset
      len = @raw_bytes.attr_length
      last = offset
      next_ = 0
      all_blank = true
      pos.attr_end_of_first_line = -1
      while (i < len)
        b = @raw_bytes[i]
        case (b)
        when Character.new(?\r.ord)
          if ((pos.attr_end_of_first_line).equal?(-1))
            pos.attr_end_of_first_line = i - 1
          end
          if ((i < len) && ((@raw_bytes[i + 1]).equal?(Character.new(?\n.ord))))
            i += 1
          end
          if ((pos.attr_end_of_first_line).equal?(-1))
            pos.attr_end_of_first_line = i - 1
          end
          if (all_blank || ((i).equal?(len - 1)))
            if ((i).equal?(len - 1))
              pos.attr_end_of_section = i
            else
              pos.attr_end_of_section = last
            end
            pos.attr_start_of_next = i + 1
            return true
          else
            # start of a new line
            last = i
            all_blank = true
          end
        when Character.new(?\n.ord)
          if ((pos.attr_end_of_first_line).equal?(-1))
            pos.attr_end_of_first_line = i - 1
          end
          if (all_blank || ((i).equal?(len - 1)))
            if ((i).equal?(len - 1))
              pos.attr_end_of_section = i
            else
              pos.attr_end_of_section = last
            end
            pos.attr_start_of_next = i + 1
            return true
          else
            # start of a new line
            last = i
            all_blank = true
          end
        else
          all_blank = false
        end
        i += 1
      end
      return false
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(bytes)
      @raw_bytes = nil
      @entries = nil
      @raw_bytes = bytes
      @entries = HashMap.new
      baos = ByteArrayOutputStream.new
      pos = Position.new
      if (!find_section(0, pos))
        return
      end # XXX: exception?
      # create an entry for main attributes
      @entries.put(MF_MAIN_ATTRS, Entry.new(0, pos.attr_end_of_section + 1, pos.attr_start_of_next, @raw_bytes))
      start = pos.attr_start_of_next
      while (find_section(start, pos))
        len = pos.attr_end_of_first_line - start + 1
        section_len = pos.attr_end_of_section - start + 1
        section_len_with_blank = pos.attr_start_of_next - start
        if (len > 6)
          if (is_name_attr(bytes, start))
            name_buf = StringBuilder.new
            begin
              name_buf.append(String.new(bytes, start + 6, len - 6, "UTF8"))
              i = start + len
              if ((i - start) < section_len)
                if ((bytes[i]).equal?(Character.new(?\r.ord)))
                  i += 2
                else
                  i += 1
                end
              end
              while ((i - start) < section_len)
                if ((bytes[((i += 1) - 1)]).equal?(Character.new(?\s.ord)))
                  # name is wrapped
                  wrap_start = i
                  while (((i - start) < section_len) && (!(bytes[((i += 1) - 1)]).equal?(Character.new(?\n.ord))))
                  end
                  if (!(bytes[i - 1]).equal?(Character.new(?\n.ord)))
                    return
                  end # XXX: exception?
                  wrap_len = 0
                  if ((bytes[i - 2]).equal?(Character.new(?\r.ord)))
                    wrap_len = i - wrap_start - 2
                  else
                    wrap_len = i - wrap_start - 1
                  end
                  name_buf.append(String.new(bytes, wrap_start, wrap_len, "UTF8"))
                else
                  break
                end
              end
              @entries.put(name_buf.to_s, Entry.new(start, section_len, section_len_with_blank, @raw_bytes))
            rescue Java::Io::UnsupportedEncodingException => uee
              raise IllegalStateException.new("UTF8 not available on platform")
            end
          end
        end
        start = pos.attr_start_of_next
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int] }
    def is_name_attr(bytes, start)
      return (((bytes[start]).equal?(Character.new(?N.ord))) || ((bytes[start]).equal?(Character.new(?n.ord)))) && (((bytes[start + 1]).equal?(Character.new(?a.ord))) || ((bytes[start + 1]).equal?(Character.new(?A.ord)))) && (((bytes[start + 2]).equal?(Character.new(?m.ord))) || ((bytes[start + 2]).equal?(Character.new(?M.ord)))) && (((bytes[start + 3]).equal?(Character.new(?e.ord))) || ((bytes[start + 3]).equal?(Character.new(?E.ord)))) && ((bytes[start + 4]).equal?(Character.new(?:.ord))) && ((bytes[start + 5]).equal?(Character.new(?\s.ord)))
    end
    
    class_module.module_eval {
      const_set_lazy(:Entry) { Class.new do
        include_class_members ManifestDigester
        
        attr_accessor :offset
        alias_method :attr_offset, :offset
        undef_method :offset
        alias_method :attr_offset=, :offset=
        undef_method :offset=
        
        attr_accessor :length
        alias_method :attr_length, :length
        undef_method :length
        alias_method :attr_length=, :length=
        undef_method :length=
        
        attr_accessor :length_with_blank_line
        alias_method :attr_length_with_blank_line, :length_with_blank_line
        undef_method :length_with_blank_line
        alias_method :attr_length_with_blank_line=, :length_with_blank_line=
        undef_method :length_with_blank_line=
        
        attr_accessor :raw_bytes
        alias_method :attr_raw_bytes, :raw_bytes
        undef_method :raw_bytes
        alias_method :attr_raw_bytes=, :raw_bytes=
        undef_method :raw_bytes=
        
        attr_accessor :old_style
        alias_method :attr_old_style, :old_style
        undef_method :old_style
        alias_method :attr_old_style=, :old_style=
        undef_method :old_style=
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Int, Array.typed(::Java::Byte)] }
        def initialize(offset, length, length_with_blank_line, raw_bytes)
          @offset = 0
          @length = 0
          @length_with_blank_line = 0
          @raw_bytes = nil
          @old_style = false
          @offset = offset
          @length = length
          @length_with_blank_line = length_with_blank_line
          @raw_bytes = raw_bytes
        end
        
        typesig { [class_self::MessageDigest] }
        def digest(md)
          md.reset
          if (@old_style)
            do_old_style(md, @raw_bytes, @offset, @length_with_blank_line)
          else
            md.update(@raw_bytes, @offset, @length_with_blank_line)
          end
          return md.digest
        end
        
        typesig { [class_self::MessageDigest, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def do_old_style(md, bytes, offset, length)
          # this is too gross to even document, but here goes
          # the 1.1 jar verification code ignored spaces at the
          # end of lines when calculating digests, so that is
          # what this code does. It only gets called if we
          # are parsing a 1.1 signed signature file
          i = offset
          start = offset
          max = offset + length
          prev = -1
          while (i < max)
            if (((bytes[i]).equal?(Character.new(?\r.ord))) && ((prev).equal?(Character.new(?\s.ord))))
              md.update(bytes, start, i - start - 1)
              start = i
            end
            prev = bytes[i]
            i += 1
          end
          md.update(bytes, start, i - start)
        end
        
        typesig { [class_self::MessageDigest] }
        # Netscape doesn't include the new line. Intel and JavaSoft do
        def digest_workaround(md)
          md.reset
          md.update(@raw_bytes, @offset, @length)
          return md.digest
        end
        
        private
        alias_method :initialize__entry, :initialize
      end }
    }
    
    typesig { [String, ::Java::Boolean] }
    def get(name, old_style)
      e = @entries.get(name)
      if (!(e).nil?)
        e.attr_old_style = old_style
      end
      return e
    end
    
    typesig { [MessageDigest] }
    def manifest_digest(md)
      md.reset
      md.update(@raw_bytes, 0, @raw_bytes.attr_length)
      return md.digest
    end
    
    private
    alias_method :initialize__manifest_digester, :initialize
  end
  
end
