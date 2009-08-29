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
  module JarOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Jar
      include ::Java::Util::Zip
      include ::Java::Io
    }
  end
  
  # The <code>JarOutputStream</code> class is used to write the contents
  # of a JAR file to any output stream. It extends the class
  # <code>java.util.zip.ZipOutputStream</code> with support
  # for writing an optional <code>Manifest</code> entry. The
  # <code>Manifest</code> can be used to specify meta-information about
  # the JAR file and its entries.
  # 
  # @author  David Connelly
  # @see     Manifest
  # @see     java.util.zip.ZipOutputStream
  # @since   1.2
  class JarOutputStream < JarOutputStreamImports.const_get :ZipOutputStream
    include_class_members JarOutputStreamImports
    
    class_module.module_eval {
      const_set_lazy(:JAR_MAGIC) { 0xcafe }
      const_attr_reader  :JAR_MAGIC
    }
    
    typesig { [OutputStream, Manifest] }
    # Creates a new <code>JarOutputStream</code> with the specified
    # <code>Manifest</code>. The manifest is written as the first
    # entry to the output stream.
    # 
    # @param out the actual output stream
    # @param man the optional <code>Manifest</code>
    # @exception IOException if an I/O error has occurred
    def initialize(out, man)
      @first_entry = false
      super(out)
      @first_entry = true
      if ((man).nil?)
        raise NullPointerException.new("man")
      end
      e = ZipEntry.new(JarFile::MANIFEST_NAME)
      put_next_entry(e)
      man.write(BufferedOutputStream.new(self))
      close_entry
    end
    
    typesig { [OutputStream] }
    # Creates a new <code>JarOutputStream</code> with no manifest.
    # @param out the actual output stream
    # @exception IOException if an I/O error has occurred
    def initialize(out)
      @first_entry = false
      super(out)
      @first_entry = true
    end
    
    typesig { [ZipEntry] }
    # Begins writing a new JAR file entry and positions the stream
    # to the start of the entry data. This method will also close
    # any previous entry. The default compression method will be
    # used if no compression method was specified for the entry.
    # The current time will be used if the entry has no set modification
    # time.
    # 
    # @param ze the ZIP/JAR entry to be written
    # @exception ZipException if a ZIP error has occurred
    # @exception IOException if an I/O error has occurred
    def put_next_entry(ze)
      if (@first_entry)
        # Make sure that extra field data for first JAR
        # entry includes JAR magic number id.
        edata = ze.get_extra
        if ((edata).nil? || !has_magic(edata))
          if ((edata).nil?)
            edata = Array.typed(::Java::Byte).new(4) { 0 }
          else
            # Prepend magic to existing extra data
            tmp = Array.typed(::Java::Byte).new(edata.attr_length + 4) { 0 }
            System.arraycopy(edata, 0, tmp, 4, edata.attr_length)
            edata = tmp
          end
          set16(edata, 0, JAR_MAGIC) # extra field id
          set16(edata, 2, 0) # extra field size
          ze.set_extra(edata)
        end
        @first_entry = false
      end
      super(ze)
    end
    
    attr_accessor :first_entry
    alias_method :attr_first_entry, :first_entry
    undef_method :first_entry
    alias_method :attr_first_entry=, :first_entry=
    undef_method :first_entry=
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      # Returns true if specified byte array contains the
      # jar magic extra field id.
      def has_magic(edata)
        begin
          i = 0
          while (i < edata.attr_length)
            if ((get16(edata, i)).equal?(JAR_MAGIC))
              return true
            end
            i += get16(edata, i + 2) + 4
          end
        rescue ArrayIndexOutOfBoundsException => e
          # Invalid extra field data
        end
        return false
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      # Fetches unsigned 16-bit value from byte array at specified offset.
      # The bytes are assumed to be in Intel (little-endian) byte order.
      def get16(b, off)
        return (b[off] & 0xff) | ((b[off + 1] & 0xff) << 8)
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Sets 16-bit value at specified offset. The bytes are assumed to
      # be in Intel (little-endian) byte order.
      def set16(b, off, value)
        b[off + 0] = value
        b[off + 1] = (value >> 8)
      end
    }
    
    private
    alias_method :initialize__jar_output_stream, :initialize
  end
  
end
