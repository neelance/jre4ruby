require "rjava"

# Copyright 1995-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ZipFileImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :EOFException
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :NoSuchElementException
    }
  end
  
  # This class is used to read entries from a zip file.
  # 
  # <p> Unless otherwise noted, passing a <tt>null</tt> argument to a constructor
  # or method in this class will cause a {@link NullPointerException} to be
  # thrown.
  # 
  # @author      David Connelly
  class ZipFile 
    include_class_members ZipFileImports
    include ZipConstants
    
    attr_accessor :jzfile
    alias_method :attr_jzfile, :jzfile
    undef_method :jzfile
    alias_method :attr_jzfile=, :jzfile=
    undef_method :jzfile=
    
    # address of jzfile data
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # zip file name
    attr_accessor :total
    alias_method :attr_total, :total
    undef_method :total
    alias_method :attr_total=, :total=
    undef_method :total=
    
    # total number of entries
    attr_accessor :close_requested
    alias_method :attr_close_requested, :close_requested
    undef_method :close_requested
    alias_method :attr_close_requested=, :close_requested=
    undef_method :close_requested=
    
    class_module.module_eval {
      const_set_lazy(:STORED) { ZipEntry::STORED }
      const_attr_reader  :STORED
      
      const_set_lazy(:DEFLATED) { ZipEntry::DEFLATED }
      const_attr_reader  :DEFLATED
      
      # Mode flag to open a zip file for reading.
      const_set_lazy(:OPEN_READ) { 0x1 }
      const_attr_reader  :OPEN_READ
      
      # Mode flag to open a zip file and mark it for deletion.  The file will be
      # deleted some time between the moment that it is opened and the moment
      # that it is closed, but its contents will remain accessible via the
      # <tt>ZipFile</tt> object until either the close method is invoked or the
      # virtual machine exits.
      const_set_lazy(:OPEN_DELETE) { 0x4 }
      const_attr_reader  :OPEN_DELETE
      
      when_class_loaded do
        # Zip library is loaded from System.initializeSystemClass
        init_ids
      end
      
      JNI.native_method :Java_java_util_zip_ZipFile_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_java_util_zip_ZipFile_initIDs, JNI.env, self.jni_id)
      end
    }
    
    typesig { [String] }
    # Opens a zip file for reading.
    # 
    # <p>First, if there is a security
    # manager, its <code>checkRead</code> method
    # is called with the <code>name</code> argument
    # as its argument to ensure the read is allowed.
    # 
    # @param name the name of the zip file
    # @throws ZipException if a ZIP format error has occurred
    # @throws IOException if an I/O error has occurred
    # @throws SecurityException if a security manager exists and its
    # <code>checkRead</code> method doesn't allow read access to the file.
    # @see SecurityManager#checkRead(java.lang.String)
    def initialize(name)
      initialize__zip_file(JavaFile.new(name), OPEN_READ)
    end
    
    typesig { [JavaFile, ::Java::Int] }
    # Opens a new <code>ZipFile</code> to read from the specified
    # <code>File</code> object in the specified mode.  The mode argument
    # must be either <tt>OPEN_READ</tt> or <tt>OPEN_READ | OPEN_DELETE</tt>.
    # 
    # <p>First, if there is a security manager, its <code>checkRead</code>
    # method is called with the <code>name</code> argument as its argument to
    # ensure the read is allowed.
    # 
    # @param file the ZIP file to be opened for reading
    # @param mode the mode in which the file is to be opened
    # @throws ZipException if a ZIP format error has occurred
    # @throws IOException if an I/O error has occurred
    # @throws SecurityException if a security manager exists and
    # its <code>checkRead</code> method
    # doesn't allow read access to the file,
    # or its <code>checkDelete</code> method doesn't allow deleting
    # the file when the <tt>OPEN_DELETE</tt> flag is set.
    # @throws IllegalArgumentException if the <tt>mode</tt> argument is invalid
    # @see SecurityManager#checkRead(java.lang.String)
    # @since 1.3
    def initialize(file, mode)
      @jzfile = 0
      @name = nil
      @total = 0
      @close_requested = false
      @inflaters = Vector.new
      if ((((mode & OPEN_READ)).equal?(0)) || (!((mode & ~(OPEN_READ | OPEN_DELETE))).equal?(0)))
        raise IllegalArgumentException.new("Illegal mode: 0x" + (JavaInteger.to_hex_string(mode)).to_s)
      end
      name = file.get_path
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_read(name)
        if (!((mode & OPEN_DELETE)).equal?(0))
          sm.check_delete(name)
        end
      end
      @jzfile = open(name, mode, file.last_modified)
      @name = name
      @total = get_total(@jzfile)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_zip_ZipFile_open, [:pointer, :long, :long, :int32, :int64], :int64
      typesig { [String, ::Java::Int, ::Java::Long] }
      def open(name, mode, last_modified_)
        JNI.__send__(:Java_java_util_zip_ZipFile_open, JNI.env, self.jni_id, name.jni_id, mode.to_int, last_modified_.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_ZipFile_getTotal, [:pointer, :long, :int64], :int32
      typesig { [::Java::Long] }
      def get_total(jzfile)
        JNI.__send__(:Java_java_util_zip_ZipFile_getTotal, JNI.env, self.jni_id, jzfile.to_int)
      end
    }
    
    typesig { [JavaFile] }
    # Opens a ZIP file for reading given the specified File object.
    # @param file the ZIP file to be opened for reading
    # @throws ZipException if a ZIP error has occurred
    # @throws IOException if an I/O error has occurred
    def initialize(file)
      initialize__zip_file(file, OPEN_READ)
    end
    
    typesig { [String] }
    # Returns the zip file entry for the specified name, or null
    # if not found.
    # 
    # @param name the name of the entry
    # @return the zip file entry, or null if not found
    # @throws IllegalStateException if the zip file has been closed
    def get_entry(name)
      if ((name).nil?)
        raise NullPointerException.new("name")
      end
      jzentry = 0
      synchronized((self)) do
        ensure_open
        jzentry = get_entry(@jzfile, name, true)
        if (!(jzentry).equal?(0))
          ze = ZipEntry.new(name, jzentry)
          free_entry(@jzfile, jzentry)
          return ze
        end
      end
      return nil
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_zip_ZipFile_getEntry, [:pointer, :long, :int64, :long, :int8], :int64
      typesig { [::Java::Long, String, ::Java::Boolean] }
      def get_entry(jzfile, name, add_slash)
        JNI.__send__(:Java_java_util_zip_ZipFile_getEntry, JNI.env, self.jni_id, jzfile.to_int, name.jni_id, add_slash ? 1 : 0)
      end
      
      JNI.native_method :Java_java_util_zip_ZipFile_freeEntry, [:pointer, :long, :int64, :int64], :void
      typesig { [::Java::Long, ::Java::Long] }
      # freeEntry releases the C jzentry struct.
      def free_entry(jzfile, jzentry)
        JNI.__send__(:Java_java_util_zip_ZipFile_freeEntry, JNI.env, self.jni_id, jzfile.to_int, jzentry.to_int)
      end
    }
    
    typesig { [ZipEntry] }
    # Returns an input stream for reading the contents of the specified
    # zip file entry.
    # 
    # <p> Closing this ZIP file will, in turn, close all input
    # streams that have been returned by invocations of this method.
    # 
    # @param entry the zip file entry
    # @return the input stream for reading the contents of the specified
    # zip file entry.
    # @throws ZipException if a ZIP format error has occurred
    # @throws IOException if an I/O error has occurred
    # @throws IllegalStateException if the zip file has been closed
    def get_input_stream(entry)
      return get_input_stream(entry.attr_name)
    end
    
    typesig { [String] }
    # Returns an input stream for reading the contents of the specified
    # entry, or null if the entry was not found.
    def get_input_stream(name)
      if ((name).nil?)
        raise NullPointerException.new("name")
      end
      jzentry = 0
      in_ = nil
      synchronized((self)) do
        ensure_open
        jzentry = get_entry(@jzfile, name, false)
        if ((jzentry).equal?(0))
          return nil
        end
        in_ = ZipFileInputStream.new_local(self, jzentry)
      end
      zfin = in_
      case (get_method(jzentry))
      when STORED
        return zfin
      when DEFLATED
        # MORE: Compute good size for inflater stream:
        size = get_size(jzentry) + 2 # Inflater likes a bit of slack
        if (size > 65536)
          size = 8192
        end
        if (size <= 0)
          size = 4096
        end
        return Class.new(InflaterInputStream.class == Class ? InflaterInputStream : Object) do
          extend LocalClass
          include_class_members ZipFile
          include InflaterInputStream if InflaterInputStream.class == Module
          
          attr_accessor :is_closed
          alias_method :attr_is_closed, :is_closed
          undef_method :is_closed
          alias_method :attr_is_closed=, :is_closed=
          undef_method :is_closed=
          
          typesig { [] }
          define_method :close do
            if (!@is_closed)
              release_inflater(self.attr_inf)
              self.attr_in.close
              @is_closed = true
            end
          end
          
          typesig { [] }
          # Override fill() method to provide an extra "dummy" byte
          # at the end of the input stream. This is required when
          # using the "nowrap" Inflater option.
          define_method :fill do
            if (@eof)
              raise EOFException.new("Unexpected end of ZLIB input stream")
            end
            self.attr_len = self.attr_in.read(self.attr_buf, 0, self.attr_buf.attr_length)
            if ((self.attr_len).equal?(-1))
              self.attr_buf[0] = 0
              self.attr_len = 1
              @eof = true
            end
            self.attr_inf.set_input(self.attr_buf, 0, self.attr_len)
          end
          
          attr_accessor :eof
          alias_method :attr_eof, :eof
          undef_method :eof
          alias_method :attr_eof=, :eof=
          undef_method :eof=
          
          typesig { [] }
          define_method :available do
            if (@is_closed)
              return 0
            end
            avail = zfin.size - self.attr_inf.get_bytes_written
            return avail > JavaInteger::MAX_VALUE ? JavaInteger::MAX_VALUE : RJava.cast_to_int(avail)
          end
          
          typesig { [] }
          define_method :initialize do
            @is_closed = false
            @eof = false
            super()
            @is_closed = false
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self, zfin, get_inflater, RJava.cast_to_int(size))
      else
        raise ZipException.new("invalid compression method")
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_zip_ZipFile_getMethod, [:pointer, :long, :int64], :int32
      typesig { [::Java::Long] }
      def get_method(jzentry)
        JNI.__send__(:Java_java_util_zip_ZipFile_getMethod, JNI.env, self.jni_id, jzentry.to_int)
      end
    }
    
    typesig { [] }
    # Gets an inflater from the list of available inflaters or allocates
    # a new one.
    def get_inflater
      synchronized((@inflaters)) do
        size_ = @inflaters.size
        if (size_ > 0)
          inf = @inflaters.remove(size_ - 1)
          inf.reset
          return inf
        else
          return Inflater.new(true)
        end
      end
    end
    
    typesig { [Inflater] }
    # Releases the specified inflater to the list of available inflaters.
    def release_inflater(inf)
      synchronized((@inflaters)) do
        @inflaters.add(inf)
      end
    end
    
    # List of available Inflater objects for decompression
    attr_accessor :inflaters
    alias_method :attr_inflaters, :inflaters
    undef_method :inflaters
    alias_method :attr_inflaters=, :inflaters=
    undef_method :inflaters=
    
    typesig { [] }
    # Returns the path name of the ZIP file.
    # @return the path name of the ZIP file
    def get_name
      return @name
    end
    
    typesig { [] }
    # Returns an enumeration of the ZIP file entries.
    # @return an enumeration of the ZIP file entries
    # @throws IllegalStateException if the zip file has been closed
    def entries
      ensure_open
      return Class.new(Enumeration.class == Class ? Enumeration : Object) do
        extend LocalClass
        include_class_members ZipFile
        include Enumeration if Enumeration.class == Module
        
        attr_accessor :i
        alias_method :attr_i, :i
        undef_method :i
        alias_method :attr_i=, :i=
        undef_method :i=
        
        typesig { [] }
        define_method :has_more_elements do
          synchronized((@local_class_parent)) do
            ensure_open
            return @i < self.attr_total
          end
        end
        
        typesig { [] }
        define_method :next_element do
          synchronized((@local_class_parent)) do
            ensure_open
            if (@i >= self.attr_total)
              raise NoSuchElementException.new
            end
            jzentry = get_next_entry(self.attr_jzfile, ((@i += 1) - 1))
            if ((jzentry).equal?(0))
              message = nil
              if (self.attr_close_requested)
                message = "ZipFile concurrently closed"
              else
                message = (get_zip_message(@local_class_parent.attr_jzfile)).to_s
              end
              raise ZipError.new("jzentry == 0" + ",\n jzfile = " + (@local_class_parent.attr_jzfile).to_s + ",\n total = " + (@local_class_parent.attr_total).to_s + ",\n name = " + (@local_class_parent.attr_name).to_s + ",\n i = " + (@i).to_s + ",\n message = " + message)
            end
            ze = ZipEntry.new(jzentry)
            free_entry(self.attr_jzfile, jzentry)
            return ze
          end
        end
        
        typesig { [] }
        define_method :initialize do
          @i = 0
          super()
          @i = 0
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_zip_ZipFile_getNextEntry, [:pointer, :long, :int64, :int32], :int64
      typesig { [::Java::Long, ::Java::Int] }
      def get_next_entry(jzfile, i)
        JNI.__send__(:Java_java_util_zip_ZipFile_getNextEntry, JNI.env, self.jni_id, jzfile.to_int, i.to_int)
      end
    }
    
    typesig { [] }
    # Returns the number of entries in the ZIP file.
    # @return the number of entries in the ZIP file
    # @throws IllegalStateException if the zip file has been closed
    def size
      ensure_open
      return @total
    end
    
    typesig { [] }
    # Closes the ZIP file.
    # <p> Closing this ZIP file will close all of the input streams
    # previously returned by invocations of the {@link #getInputStream
    # getInputStream} method.
    # 
    # @throws IOException if an I/O error has occurred
    def close
      synchronized((self)) do
        @close_requested = true
        if (!(@jzfile).equal?(0))
          # Close the zip file
          zf = @jzfile
          @jzfile = 0
          close(zf)
          # Release inflaters
          synchronized((@inflaters)) do
            size_ = @inflaters.size
            i = 0
            while i < size_
              inf = @inflaters.get(i)
              inf.end
              i += 1
            end
          end
        end
      end
    end
    
    typesig { [] }
    # Ensures that the <code>close</code> method of this ZIP file is
    # called when there are no more references to it.
    # 
    # <p>
    # Since the time when GC would invoke this method is undetermined,
    # it is strongly recommended that applications invoke the <code>close</code>
    # method as soon they have finished accessing this <code>ZipFile</code>.
    # This will prevent holding up system resources for an undetermined
    # length of time.
    # 
    # @throws IOException if an I/O error has occurred
    # @see    java.util.zip.ZipFile#close()
    def finalize
      close
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_util_zip_ZipFile_close, [:pointer, :long, :int64], :void
      typesig { [::Java::Long] }
      def close(jzfile)
        JNI.__send__(:Java_java_util_zip_ZipFile_close, JNI.env, self.jni_id, jzfile.to_int)
      end
    }
    
    typesig { [] }
    def ensure_open
      if (@close_requested)
        raise IllegalStateException.new("zip file closed")
      end
      if ((@jzfile).equal?(0))
        raise IllegalStateException.new("The object is not initialized.")
      end
    end
    
    typesig { [] }
    def ensure_open_or_zip_exception
      if (@close_requested)
        raise ZipException.new("ZipFile closed")
      end
    end
    
    class_module.module_eval {
      # Inner class implementing the input stream used to read a
      # (possibly compressed) zip file entry.
      const_set_lazy(:ZipFileInputStream) { Class.new(InputStream) do
        extend LocalClass
        include_class_members ZipFile
        
        attr_accessor :jzentry
        alias_method :attr_jzentry, :jzentry
        undef_method :jzentry
        alias_method :attr_jzentry=, :jzentry=
        undef_method :jzentry=
        
        # address of jzentry data
        attr_accessor :pos
        alias_method :attr_pos, :pos
        undef_method :pos
        alias_method :attr_pos=, :pos=
        undef_method :pos=
        
        # current position within entry data
        attr_accessor :rem
        alias_method :attr_rem, :rem
        undef_method :rem
        alias_method :attr_rem=, :rem=
        undef_method :rem=
        
        # number of remaining bytes within entry
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        typesig { [::Java::Long] }
        # uncompressed size of this entry
        def initialize(jzentry)
          @jzentry = 0
          @pos = 0
          @rem = 0
          @size = 0
          super()
          @pos = 0
          @rem = get_csize(jzentry)
          @size = get_size(jzentry)
          @jzentry = jzentry
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, len)
          if ((@rem).equal?(0))
            return -1
          end
          if (len <= 0)
            return 0
          end
          if (len > @rem)
            len = RJava.cast_to_int(@rem)
          end
          synchronized((@local_class_parent)) do
            ensure_open_or_zip_exception
            len = ZipFile.read(@local_class_parent.attr_jzfile, @jzentry, @pos, b, off, len)
          end
          if (len > 0)
            @pos += len
            @rem -= len
          end
          if ((@rem).equal?(0))
            close
          end
          return len
        end
        
        typesig { [] }
        def read
          b = Array.typed(::Java::Byte).new(1) { 0 }
          if ((read(b, 0, 1)).equal?(1))
            return b[0] & 0xff
          else
            return -1
          end
        end
        
        typesig { [::Java::Long] }
        def skip(n)
          if (n > @rem)
            n = @rem
          end
          @pos += n
          @rem -= n
          if ((@rem).equal?(0))
            close
          end
          return n
        end
        
        typesig { [] }
        def available
          return @rem > JavaInteger::MAX_VALUE ? JavaInteger::MAX_VALUE : RJava.cast_to_int(@rem)
        end
        
        typesig { [] }
        def size
          return @size
        end
        
        typesig { [] }
        def close
          @rem = 0
          synchronized((@local_class_parent)) do
            if (!(@jzentry).equal?(0) && !(@local_class_parent.attr_jzfile).equal?(0))
              free_entry(@local_class_parent.attr_jzfile, @jzentry)
              @jzentry = 0
            end
          end
        end
        
        private
        alias_method :initialize__zip_file_input_stream, :initialize
      end }
      
      JNI.native_method :Java_java_util_zip_ZipFile_read, [:pointer, :long, :int64, :int64, :int64, :long, :int32, :int32], :int32
      typesig { [::Java::Long, ::Java::Long, ::Java::Long, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      def read(jzfile, jzentry, pos, b, off, len)
        JNI.__send__(:Java_java_util_zip_ZipFile_read, JNI.env, self.jni_id, jzfile.to_int, jzentry.to_int, pos.to_int, b.jni_id, off.to_int, len.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_ZipFile_getCSize, [:pointer, :long, :int64], :int64
      typesig { [::Java::Long] }
      def get_csize(jzentry)
        JNI.__send__(:Java_java_util_zip_ZipFile_getCSize, JNI.env, self.jni_id, jzentry.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_ZipFile_getSize, [:pointer, :long, :int64], :int64
      typesig { [::Java::Long] }
      def get_size(jzentry)
        JNI.__send__(:Java_java_util_zip_ZipFile_getSize, JNI.env, self.jni_id, jzentry.to_int)
      end
      
      JNI.native_method :Java_java_util_zip_ZipFile_getZipMessage, [:pointer, :long, :int64], :long
      typesig { [::Java::Long] }
      # Temporary add on for bug troubleshooting
      def get_zip_message(jzfile)
        JNI.__send__(:Java_java_util_zip_ZipFile_getZipMessage, JNI.env, self.jni_id, jzfile.to_int)
      end
    }
    
    private
    alias_method :initialize__zip_file, :initialize
  end
  
end
