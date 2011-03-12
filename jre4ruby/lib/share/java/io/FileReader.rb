require "rjava"

# Copyright 1996-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module FileReaderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Convenience class for reading character files.  The constructors of this
  # class assume that the default character encoding and the default byte-buffer
  # size are appropriate.  To specify these values yourself, construct an
  # InputStreamReader on a FileInputStream.
  # 
  # <p><code>FileReader</code> is meant for reading streams of characters.
  # For reading streams of raw bytes, consider using a
  # <code>FileInputStream</code>.
  # 
  # @see InputStreamReader
  # @see FileInputStream
  # 
  # @author      Mark Reinhold
  # @since       JDK1.1
  class FileReader < FileReaderImports.const_get :InputStreamReader
    include_class_members FileReaderImports
    
    typesig { [String] }
    # Creates a new <tt>FileReader</tt>, given the name of the
    # file to read from.
    # 
    # @param fileName the name of the file to read from
    # @exception  FileNotFoundException  if the named file does not exist,
    #                   is a directory rather than a regular file,
    #                   or for some other reason cannot be opened for
    #                   reading.
    def initialize(file_name)
      super(FileInputStream.new(file_name))
    end
    
    typesig { [JavaFile] }
    # Creates a new <tt>FileReader</tt>, given the <tt>File</tt>
    # to read from.
    # 
    # @param file the <tt>File</tt> to read from
    # @exception  FileNotFoundException  if the file does not exist,
    #                   is a directory rather than a regular file,
    #                   or for some other reason cannot be opened for
    #                   reading.
    def initialize(file)
      super(FileInputStream.new(file))
    end
    
    typesig { [FileDescriptor] }
    # Creates a new <tt>FileReader</tt>, given the
    # <tt>FileDescriptor</tt> to read from.
    # 
    # @param fd the FileDescriptor to read from
    def initialize(fd)
      super(FileInputStream.new(fd))
    end
    
    private
    alias_method :initialize__file_reader, :initialize
  end
  
end
