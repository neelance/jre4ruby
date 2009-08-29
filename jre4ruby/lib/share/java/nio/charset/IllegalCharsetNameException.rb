require "rjava"

# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
# 
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
# -- This file was mechanically generated: Do not edit! -- //
module Java::Nio::Charset
  module IllegalCharsetNameExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Charset
    }
  end
  
  # Unchecked exception thrown when a string that is not a
  # <a href=Charset.html#names>legal charset name</a> is used as such.
  # 
  # @since 1.4
  class IllegalCharsetNameException < IllegalCharsetNameExceptionImports.const_get :IllegalArgumentException
    include_class_members IllegalCharsetNameExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 1457525358470002989 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :charset_name
    alias_method :attr_charset_name, :charset_name
    undef_method :charset_name
    alias_method :attr_charset_name=, :charset_name=
    undef_method :charset_name=
    
    typesig { [String] }
    # Constructs an instance of this class. </p>
    # 
    # @param  charsetName
    # The illegal charset name
    def initialize(charset_name)
      @charset_name = nil
      super(String.value_of(charset_name))
      @charset_name = charset_name
    end
    
    typesig { [] }
    # Retrieves the illegal charset name. </p>
    # 
    # @return  The illegal charset name
    def get_charset_name
      return @charset_name
    end
    
    private
    alias_method :initialize__illegal_charset_name_exception, :initialize
  end
  
end
