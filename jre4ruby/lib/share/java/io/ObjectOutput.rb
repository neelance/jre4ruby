require "rjava"

# Copyright 1996-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ObjectOutputImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # ObjectOutput extends the DataOutput interface to include writing of objects.
  # DataOutput includes methods for output of primitive types, ObjectOutput
  # extends that interface to include objects, arrays, and Strings.
  # 
  # @author  unascribed
  # @see java.io.InputStream
  # @see java.io.ObjectOutputStream
  # @see java.io.ObjectInputStream
  # @since   JDK1.1
  module ObjectOutput
    include_class_members ObjectOutputImports
    include DataOutput
    
    typesig { [Object] }
    # Write an object to the underlying storage or stream.  The
    # class that implements this interface defines how the object is
    # written.
    # 
    # @param obj the object to be written
    # @exception IOException Any of the usual Input/Output related exceptions.
    def write_object(obj)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Writes a byte. This method will block until the byte is actually
    # written.
    # @param b the byte
    # @exception IOException If an I/O error has occurred.
    def write(b)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Writes an array of bytes. This method will block until the bytes
    # are actually written.
    # @param b the data to be written
    # @exception IOException If an I/O error has occurred.
    def write(b)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes a sub array of bytes.
    # @param b the data to be written
    # @param off       the start offset in the data
    # @param len       the number of bytes that are written
    # @exception IOException If an I/O error has occurred.
    def write(b, off, len)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Flushes the stream. This will write any buffered
    # output bytes.
    # @exception IOException If an I/O error has occurred.
    def flush
      raise NotImplementedError
    end
    
    typesig { [] }
    # Closes the stream. This method must be called
    # to release any resources associated with the
    # stream.
    # @exception IOException If an I/O error has occurred.
    def close
      raise NotImplementedError
    end
  end
  
end
