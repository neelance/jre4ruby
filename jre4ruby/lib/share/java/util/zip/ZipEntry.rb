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
module Java::Util::Zip
  module ZipEntryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Util, :JavaDate
    }
  end
  
  # This class is used to represent a ZIP file entry.
  # 
  # @author      David Connelly
  class ZipEntry 
    include_class_members ZipEntryImports
    include ZipConstants
    include Cloneable
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # entry name
    attr_accessor :time
    alias_method :attr_time, :time
    undef_method :time
    alias_method :attr_time=, :time=
    undef_method :time=
    
    # modification time (in DOS time)
    attr_accessor :crc
    alias_method :attr_crc, :crc
    undef_method :crc
    alias_method :attr_crc=, :crc=
    undef_method :crc=
    
    # crc-32 of entry data
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    # uncompressed size of entry data
    attr_accessor :csize
    alias_method :attr_csize, :csize
    undef_method :csize
    alias_method :attr_csize=, :csize=
    undef_method :csize=
    
    # compressed size of entry data
    attr_accessor :method
    alias_method :attr_method, :method
    undef_method :method
    alias_method :attr_method=, :method=
    undef_method :method=
    
    # compression method
    attr_accessor :extra
    alias_method :attr_extra, :extra
    undef_method :extra
    alias_method :attr_extra=, :extra=
    undef_method :extra=
    
    # optional extra field data for entry
    attr_accessor :comment
    alias_method :attr_comment, :comment
    undef_method :comment
    alias_method :attr_comment=, :comment=
    undef_method :comment=
    
    class_module.module_eval {
      # optional comment string for entry
      # Compression method for uncompressed entries.
      const_set_lazy(:STORED) { 0 }
      const_attr_reader  :STORED
      
      # Compression method for compressed (deflated) entries.
      const_set_lazy(:DEFLATED) { 8 }
      const_attr_reader  :DEFLATED
      
      when_class_loaded do
        # Zip library is loaded from System.initializeSystemClass
        init_ids
      end
      
      JNI.load_native_method :Java_java_util_zip_ZipEntry_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.call_native_method(:Java_java_util_zip_ZipEntry_initIDs, JNI.env, self.jni_id)
      end
    }
    
    typesig { [String] }
    # Creates a new zip entry with the specified name.
    # 
    # @param name the entry name
    # @exception NullPointerException if the entry name is null
    # @exception IllegalArgumentException if the entry name is longer than
    #            0xFFFF bytes
    def initialize(name)
      @name = nil
      @time = -1
      @crc = -1
      @size = -1
      @csize = -1
      @method = -1
      @extra = nil
      @comment = nil
      if ((name).nil?)
        raise NullPointerException.new
      end
      if (name.length > 0xffff)
        raise IllegalArgumentException.new("entry name too long")
      end
      @name = name
    end
    
    typesig { [ZipEntry] }
    # Creates a new zip entry with fields taken from the specified
    # zip entry.
    # @param e a zip Entry object
    def initialize(e)
      @name = nil
      @time = -1
      @crc = -1
      @size = -1
      @csize = -1
      @method = -1
      @extra = nil
      @comment = nil
      @name = RJava.cast_to_string(e.attr_name)
      @time = e.attr_time
      @crc = e.attr_crc
      @size = e.attr_size
      @csize = e.attr_csize
      @method = e.attr_method
      @extra = e.attr_extra
      @comment = RJava.cast_to_string(e.attr_comment)
    end
    
    typesig { [String, ::Java::Long] }
    # Creates a new zip entry for the given name with fields initialized
    # from the specified jzentry data.
    def initialize(name, jzentry)
      @name = nil
      @time = -1
      @crc = -1
      @size = -1
      @csize = -1
      @method = -1
      @extra = nil
      @comment = nil
      @name = name
      init_fields(jzentry)
    end
    
    JNI.load_native_method :Java_java_util_zip_ZipEntry_initFields, [:pointer, :long, :int64], :void
    typesig { [::Java::Long] }
    def init_fields(jzentry)
      JNI.call_native_method(:Java_java_util_zip_ZipEntry_initFields, JNI.env, self.jni_id, jzentry.to_int)
    end
    
    typesig { [::Java::Long] }
    # Creates a new zip entry with fields initialized from the specified
    # jzentry data.
    def initialize(jzentry)
      @name = nil
      @time = -1
      @crc = -1
      @size = -1
      @csize = -1
      @method = -1
      @extra = nil
      @comment = nil
      init_fields(jzentry)
    end
    
    typesig { [] }
    # Returns the name of the entry.
    # @return the name of the entry
    def get_name
      return @name
    end
    
    typesig { [::Java::Long] }
    # Sets the modification time of the entry.
    # @param time the entry modification time in number of milliseconds
    #             since the epoch
    # @see #getTime()
    def set_time(time)
      @time = java_to_dos_time(time)
    end
    
    typesig { [] }
    # Returns the modification time of the entry, or -1 if not specified.
    # @return the modification time of the entry, or -1 if not specified
    # @see #setTime(long)
    def get_time
      return !(@time).equal?(-1) ? dos_to_java_time(@time) : -1
    end
    
    typesig { [::Java::Long] }
    # Sets the uncompressed size of the entry data.
    # @param size the uncompressed size in bytes
    # @exception IllegalArgumentException if the specified size is less
    #            than 0 or greater than 0xFFFFFFFF bytes
    # @see #getSize()
    def set_size(size)
      if (size < 0 || size > 0xffffffff)
        raise IllegalArgumentException.new("invalid entry size")
      end
      @size = size
    end
    
    typesig { [] }
    # Returns the uncompressed size of the entry data, or -1 if not known.
    # @return the uncompressed size of the entry data, or -1 if not known
    # @see #setSize(long)
    def get_size
      return @size
    end
    
    typesig { [] }
    # Returns the size of the compressed entry data, or -1 if not known.
    # In the case of a stored entry, the compressed size will be the same
    # as the uncompressed size of the entry.
    # @return the size of the compressed entry data, or -1 if not known
    # @see #setCompressedSize(long)
    def get_compressed_size
      return @csize
    end
    
    typesig { [::Java::Long] }
    # Sets the size of the compressed entry data.
    # @param csize the compressed size to set to
    # @see #getCompressedSize()
    def set_compressed_size(csize)
      @csize = csize
    end
    
    typesig { [::Java::Long] }
    # Sets the CRC-32 checksum of the uncompressed entry data.
    # @param crc the CRC-32 value
    # @exception IllegalArgumentException if the specified CRC-32 value is
    #            less than 0 or greater than 0xFFFFFFFF
    # @see #getCrc()
    def set_crc(crc)
      if (crc < 0 || crc > 0xffffffff)
        raise IllegalArgumentException.new("invalid entry crc-32")
      end
      @crc = crc
    end
    
    typesig { [] }
    # Returns the CRC-32 checksum of the uncompressed entry data, or -1 if
    # not known.
    # @return the CRC-32 checksum of the uncompressed entry data, or -1 if
    # not known
    # @see #setCrc(long)
    def get_crc
      return @crc
    end
    
    typesig { [::Java::Int] }
    # Sets the compression method for the entry.
    # @param method the compression method, either STORED or DEFLATED
    # @exception IllegalArgumentException if the specified compression
    #            method is invalid
    # @see #getMethod()
    def set_method(method)
      if (!(method).equal?(STORED) && !(method).equal?(DEFLATED))
        raise IllegalArgumentException.new("invalid compression method")
      end
      @method = method
    end
    
    typesig { [] }
    # Returns the compression method of the entry, or -1 if not specified.
    # @return the compression method of the entry, or -1 if not specified
    # @see #setMethod(int)
    def get_method
      return @method
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Sets the optional extra field data for the entry.
    # @param extra the extra field data bytes
    # @exception IllegalArgumentException if the length of the specified
    #            extra field data is greater than 0xFFFF bytes
    # @see #getExtra()
    def set_extra(extra)
      if (!(extra).nil? && extra.attr_length > 0xffff)
        raise IllegalArgumentException.new("invalid extra field length")
      end
      @extra = extra
    end
    
    typesig { [] }
    # Returns the extra field data for the entry, or null if none.
    # @return the extra field data for the entry, or null if none
    # @see #setExtra(byte[])
    def get_extra
      return @extra
    end
    
    typesig { [String] }
    # Sets the optional comment string for the entry.
    # @param comment the comment string
    # @exception IllegalArgumentException if the length of the specified
    #            comment string is greater than 0xFFFF bytes
    # @see #getComment()
    def set_comment(comment)
      if (!(comment).nil? && comment.length > 0xffff / 3 && ZipOutputStream.get_utf8length(comment) > 0xffff)
        raise IllegalArgumentException.new("invalid entry comment length")
      end
      @comment = comment
    end
    
    typesig { [] }
    # Returns the comment string for the entry, or null if none.
    # @return the comment string for the entry, or null if none
    # @see #setComment(String)
    def get_comment
      return @comment
    end
    
    typesig { [] }
    # Returns true if this is a directory entry. A directory entry is
    # defined to be one whose name ends with a '/'.
    # @return true if this is a directory entry
    def is_directory
      return @name.ends_with("/")
    end
    
    typesig { [] }
    # Returns a string representation of the ZIP entry.
    def to_s
      return get_name
    end
    
    class_module.module_eval {
      typesig { [::Java::Long] }
      # Converts DOS time to Java time (number of milliseconds since epoch).
      def dos_to_java_time(dtime)
        d = JavaDate.new(((((dtime >> 25) & 0x7f) + 80)).to_int, ((((dtime >> 21) & 0xf) - 1)).to_int, (((dtime >> 16) & 0x1f)).to_int, (((dtime >> 11) & 0x1f)).to_int, (((dtime >> 5) & 0x3f)).to_int, (((dtime << 1) & 0x3e)).to_int)
        return d.get_time
      end
      
      typesig { [::Java::Long] }
      # Converts Java time to DOS time.
      def java_to_dos_time(time)
        d = JavaDate.new(time)
        year = d.get_year + 1900
        if (year < 1980)
          return (1 << 21) | (1 << 16)
        end
        return (year - 1980) << 25 | (d.get_month + 1) << 21 | d.get_date << 16 | d.get_hours << 11 | d.get_minutes << 5 | d.get_seconds >> 1
      end
    }
    
    typesig { [] }
    # Returns the hash code value for this entry.
    def hash_code
      return @name.hash_code
    end
    
    typesig { [] }
    # Returns a copy of this entry.
    def clone
      begin
        e = super
        e.attr_extra = ((@extra).nil?) ? nil : @extra.clone
        return e
      rescue CloneNotSupportedException => e_
        # This should never happen, since we are Cloneable
        raise InternalError.new
      end
    end
    
    private
    alias_method :initialize__zip_entry, :initialize
  end
  
end
