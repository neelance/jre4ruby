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
module Java::Util::Zip
  module CheckedOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
      include_const ::Java::Io, :FilterOutputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # 
  # An output stream that also maintains a checksum of the data being
  # written. The checksum can then be used to verify the integrity of
  # the output data.
  # 
  # @see         Checksum
  # @author      David Connelly
  class CheckedOutputStream < CheckedOutputStreamImports.const_get :FilterOutputStream
    include_class_members CheckedOutputStreamImports
    
    attr_accessor :cksum
    alias_method :attr_cksum, :cksum
    undef_method :cksum
    alias_method :attr_cksum=, :cksum=
    undef_method :cksum=
    
    typesig { [OutputStream, Checksum] }
    # 
    # Creates an output stream with the specified Checksum.
    # @param out the output stream
    # @param cksum the checksum
    def initialize(out, cksum)
      @cksum = nil
      super(out)
      @cksum = cksum
    end
    
    typesig { [::Java::Int] }
    # 
    # Writes a byte. Will block until the byte is actually written.
    # @param b the byte to be written
    # @exception IOException if an I/O error has occurred
    def write(b)
      self.attr_out.write(b)
      @cksum.update(b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Writes an array of bytes. Will block until the bytes are
    # actually written.
    # @param b the data to be written
    # @param off the start offset of the data
    # @param len the number of bytes to be written
    # @exception IOException if an I/O error has occurred
    def write(b, off, len)
      self.attr_out.write(b, off, len)
      @cksum.update(b, off, len)
    end
    
    typesig { [] }
    # 
    # Returns the Checksum for this output stream.
    # @return the Checksum
    def get_checksum
      return @cksum
    end
    
    private
    alias_method :initialize__checked_output_stream, :initialize
  end
  
end
