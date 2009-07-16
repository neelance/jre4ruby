require "rjava"

# 
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
  module JarInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Jar
      include ::Java::Util::Zip
      include ::Java::Io
      include_const ::Sun::Security::Util, :ManifestEntryVerifier
    }
  end
  
  # 
  # The <code>JarInputStream</code> class is used to read the contents of
  # a JAR file from any input stream. It extends the class
  # <code>java.util.zip.ZipInputStream</code> with support for reading
  # an optional <code>Manifest</code> entry. The <code>Manifest</code>
  # can be used to store meta-information about the JAR file and its entries.
  # 
  # @author  David Connelly
  # @see     Manifest
  # @see     java.util.zip.ZipInputStream
  # @since   1.2
  class JarInputStream < JarInputStreamImports.const_get :ZipInputStream
    include_class_members JarInputStreamImports
    
    attr_accessor :man
    alias_method :attr_man, :man
    undef_method :man
    alias_method :attr_man=, :man=
    undef_method :man=
    
    attr_accessor :first
    alias_method :attr_first, :first
    undef_method :first
    alias_method :attr_first=, :first=
    undef_method :first=
    
    attr_accessor :jv
    alias_method :attr_jv, :jv
    undef_method :jv
    alias_method :attr_jv=, :jv=
    undef_method :jv=
    
    attr_accessor :mev
    alias_method :attr_mev, :mev
    undef_method :mev
    alias_method :attr_mev=, :mev=
    undef_method :mev=
    
    typesig { [InputStream] }
    # 
    # Creates a new <code>JarInputStream</code> and reads the optional
    # manifest. If a manifest is present, also attempts to verify
    # the signatures if the JarInputStream is signed.
    # @param in the actual input stream
    # @exception IOException if an I/O error has occurred
    def initialize(in_)
      initialize__jar_input_stream(in_, true)
    end
    
    typesig { [InputStream, ::Java::Boolean] }
    # 
    # Creates a new <code>JarInputStream</code> and reads the optional
    # manifest. If a manifest is present and verify is true, also attempts
    # to verify the signatures if the JarInputStream is signed.
    # 
    # @param in the actual input stream
    # @param verify whether or not to verify the JarInputStream if
    # it is signed.
    # @exception IOException if an I/O error has occurred
    def initialize(in_, verify)
      @man = nil
      @first = nil
      @jv = nil
      @mev = nil
      super(in_)
      e = ZipInputStream.instance_method(:get_next_entry).bind(self).call
      if (!(e).nil? && e.get_name.equals_ignore_case("META-INF/"))
        e = ZipInputStream.instance_method(:get_next_entry).bind(self).call
      end
      if (!(e).nil? && JarFile::MANIFEST_NAME.equals_ignore_case(e.get_name))
        @man = Manifest.new
        bytes = get_bytes(BufferedInputStream.new(self))
        @man.read(ByteArrayInputStream.new(bytes))
        # man.read(new BufferedInputStream(this));
        close_entry
        if (verify)
          @jv = JarVerifier.new(bytes)
          @mev = ManifestEntryVerifier.new(@man)
        end
        @first = get_next_jar_entry
      else
        @first = e
      end
    end
    
    typesig { [InputStream] }
    def get_bytes(is)
      buffer = Array.typed(::Java::Byte).new(8192) { 0 }
      baos = ByteArrayOutputStream.new(2048)
      n = 0
      baos.reset
      while (!((n = is.read(buffer, 0, buffer.attr_length))).equal?(-1))
        baos.write(buffer, 0, n)
      end
      return baos.to_byte_array
    end
    
    typesig { [] }
    # 
    # Returns the <code>Manifest</code> for this JAR file, or
    # <code>null</code> if none.
    # 
    # @return the <code>Manifest</code> for this JAR file, or
    # <code>null</code> if none.
    def get_manifest
      return @man
    end
    
    typesig { [] }
    # 
    # Reads the next ZIP file entry and positions the stream at the
    # beginning of the entry data. If verification has been enabled,
    # any invalid signature detected while positioning the stream for
    # the next entry will result in an exception.
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    # @exception SecurityException if any of the jar file entries
    # are incorrectly signed.
    def get_next_entry
      e = nil
      if ((@first).nil?)
        e = super
      else
        e = @first
        @first = nil
      end
      if (!(@jv).nil? && !(e).nil?)
        # At this point, we might have parsed all the meta-inf
        # entries and have nothing to verify. If we have
        # nothing to verify, get rid of the JarVerifier object.
        if ((@jv.nothing_to_verify).equal?(true))
          @jv = nil
          @mev = nil
        else
          @jv.begin_entry(e, @mev)
        end
      end
      return e
    end
    
    typesig { [] }
    # 
    # Reads the next JAR file entry and positions the stream at the
    # beginning of the entry data. If verification has been enabled,
    # any invalid signature detected while positioning the stream for
    # the next entry will result in an exception.
    # @return the next JAR file entry, or null if there are no more entries
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    # @exception SecurityException if any of the jar file entries
    # are incorrectly signed.
    def get_next_jar_entry
      return get_next_entry
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Reads from the current JAR file entry into an array of bytes.
    # If <code>len</code> is not zero, the method
    # blocks until some input is available; otherwise, no
    # bytes are read and <code>0</code> is returned.
    # If verification has been enabled, any invalid signature
    # on the current entry will be reported at some point before the
    # end of the entry is reached.
    # @param b the buffer into which the data is read
    # @param off the start offset in the destination array <code>b</code>
    # @param len the maximum number of bytes to read
    # @return the actual number of bytes read, or -1 if the end of the
    # entry is reached
    # @exception  NullPointerException If <code>b</code> is <code>null</code>.
    # @exception  IndexOutOfBoundsException If <code>off</code> is negative,
    # <code>len</code> is negative, or <code>len</code> is greater than
    # <code>b.length - off</code>
    # @exception ZipException if a ZIP file error has occurred
    # @exception IOException if an I/O error has occurred
    # @exception SecurityException if any of the jar file entries
    # are incorrectly signed.
    def read(b, off, len)
      n = 0
      if ((@first).nil?)
        n = super(b, off, len)
      else
        n = -1
      end
      if (!(@jv).nil?)
        @jv.update(n, b, off, len, @mev)
      end
      return n
    end
    
    typesig { [String] }
    # 
    # Creates a new <code>JarEntry</code> (<code>ZipEntry</code>) for the
    # specified JAR file entry name. The manifest attributes of
    # the specified JAR file entry name will be copied to the new
    # <CODE>JarEntry</CODE>.
    # 
    # @param name the name of the JAR/ZIP file entry
    # @return the <code>JarEntry</code> object just created
    def create_zip_entry(name)
      e = JarEntry.new(name)
      if (!(@man).nil?)
        e.attr_attr = @man.get_attributes(name)
      end
      return e
    end
    
    private
    alias_method :initialize__jar_input_stream, :initialize
  end
  
end
