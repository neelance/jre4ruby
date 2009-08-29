require "rjava"

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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Util
  module KrbDataOutputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Util
      include_const ::Java::Io, :BufferedOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
    }
  end
  
  # This class implements a buffered output stream. It provides methods to write a chunck of
  # bytes to underlying data stream.
  # 
  # @author Yanni Zhang
  class KrbDataOutputStream < KrbDataOutputStreamImports.const_get :BufferedOutputStream
    include_class_members KrbDataOutputStreamImports
    
    typesig { [OutputStream] }
    def initialize(os)
      super(os)
    end
    
    typesig { [::Java::Int] }
    def write32(num)
      bytes = Array.typed(::Java::Byte).new(4) { 0 }
      bytes[0] = ((num & -0x1000000) >> 24 & 0xff)
      bytes[1] = ((num & 0xff0000) >> 16 & 0xff)
      bytes[2] = ((num & 0xff00) >> 8 & 0xff)
      bytes[3] = (num & 0xff)
      write(bytes, 0, 4)
    end
    
    typesig { [::Java::Int] }
    def write16(num)
      bytes = Array.typed(::Java::Byte).new(2) { 0 }
      bytes[0] = ((num & 0xff00) >> 8 & 0xff)
      bytes[1] = (num & 0xff)
      write(bytes, 0, 2)
    end
    
    typesig { [::Java::Int] }
    def write8(num)
      write(num & 0xff)
    end
    
    private
    alias_method :initialize__krb_data_output_stream, :initialize
  end
  
end
