require "rjava"

# 
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
  module ObjectInputImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # ObjectInput extends the DataInput interface to include the reading of
  # objects. DataInput includes methods for the input of primitive types,
  # ObjectInput extends that interface to include objects, arrays, and Strings.
  # 
  # @author  unascribed
  # @see java.io.InputStream
  # @see java.io.ObjectOutputStream
  # @see java.io.ObjectInputStream
  # @since   JDK1.1
  module ObjectInput
    include_class_members ObjectInputImports
    include DataInput
    
    typesig { [] }
    # 
    # Read and return an object. The class that implements this interface
    # defines where the object is "read" from.
    # 
    # @return the object read from the stream
    # @exception java.lang.ClassNotFoundException If the class of a serialized
    # object cannot be found.
    # @exception IOException If any of the usual Input/Output
    # related exceptions occur.
    def read_object
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Reads a byte of data. This method will block if no input is
    # available.
    # @return  the byte read, or -1 if the end of the
    # stream is reached.
    # @exception IOException If an I/O error has occurred.
    def read
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # Reads into an array of bytes.  This method will
    # block until some input is available.
    # @param b the buffer into which the data is read
    # @return  the actual number of bytes read, -1 is
    # returned when the end of the stream is reached.
    # @exception IOException If an I/O error has occurred.
    def read(b)
      raise NotImplementedError
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Reads into an array of bytes.  This method will
    # block until some input is available.
    # @param b the buffer into which the data is read
    # @param off the start offset of the data
    # @param len the maximum number of bytes read
    # @return  the actual number of bytes read, -1 is
    # returned when the end of the stream is reached.
    # @exception IOException If an I/O error has occurred.
    def read(b, off, len)
      raise NotImplementedError
    end
    
    typesig { [::Java::Long] }
    # 
    # Skips n bytes of input.
    # @param n the number of bytes to be skipped
    # @return  the actual number of bytes skipped.
    # @exception IOException If an I/O error has occurred.
    def skip(n)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the number of bytes that can be read
    # without blocking.
    # @return the number of available bytes.
    # @exception IOException If an I/O error has occurred.
    def available
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Closes the input stream. Must be called
    # to release any resources associated with
    # the stream.
    # @exception IOException If an I/O error has occurred.
    def close
      raise NotImplementedError
    end
  end
  
end
