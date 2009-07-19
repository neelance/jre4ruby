require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module OptionalDataExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Exception indicating the failure of an object read operation due to
  # unread primitive data, or the end of data belonging to a serialized
  # object in the stream.  This exception may be thrown in two cases:
  # 
  # <ul>
  # <li>An attempt was made to read an object when the next element in the
  # stream is primitive data.  In this case, the OptionalDataException's
  # length field is set to the number of bytes of primitive data
  # immediately readable from the stream, and the eof field is set to
  # false.
  # 
  # <li>An attempt was made to read past the end of data consumable by a
  # class-defined readObject or readExternal method.  In this case, the
  # OptionalDataException's eof field is set to true, and the length field
  # is set to 0.
  # </ul>
  # 
  # @author  unascribed
  # @since   JDK1.1
  class OptionalDataException < OptionalDataExceptionImports.const_get :ObjectStreamException
    include_class_members OptionalDataExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -8011121865681257820 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [::Java::Int] }
    # Create an <code>OptionalDataException</code> with a length.
    def initialize(len)
      @length = 0
      @eof = false
      super()
      @eof = false
      @length = len
    end
    
    typesig { [::Java::Boolean] }
    # Create an <code>OptionalDataException</code> signifying no
    # more primitive data is available.
    def initialize(end_)
      @length = 0
      @eof = false
      super()
      @length = 0
      @eof = end_
    end
    
    # The number of bytes of primitive data available to be read
    # in the current buffer.
    # 
    # @serial
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    # True if there is no more data in the buffered part of the stream.
    # 
    # @serial
    attr_accessor :eof
    alias_method :attr_eof, :eof
    undef_method :eof
    alias_method :attr_eof=, :eof=
    undef_method :eof=
    
    private
    alias_method :initialize__optional_data_exception, :initialize
  end
  
end
