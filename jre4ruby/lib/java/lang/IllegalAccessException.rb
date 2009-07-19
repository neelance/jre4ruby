require "rjava"

# Copyright 1995-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module IllegalAccessExceptionImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # An IllegalAccessException is thrown when an application tries
  # to reflectively create an instance (other than an array),
  # set or get a field, or invoke a method, but the currently
  # executing method does not have access to the definition of
  # the specified class, field, method or constructor.
  # 
  # @author  unascribed
  # @see     Class#newInstance()
  # @see     java.lang.reflect.Field#set(Object, Object)
  # @see     java.lang.reflect.Field#setBoolean(Object, boolean)
  # @see     java.lang.reflect.Field#setByte(Object, byte)
  # @see     java.lang.reflect.Field#setShort(Object, short)
  # @see     java.lang.reflect.Field#setChar(Object, char)
  # @see     java.lang.reflect.Field#setInt(Object, int)
  # @see     java.lang.reflect.Field#setLong(Object, long)
  # @see     java.lang.reflect.Field#setFloat(Object, float)
  # @see     java.lang.reflect.Field#setDouble(Object, double)
  # @see     java.lang.reflect.Field#get(Object)
  # @see     java.lang.reflect.Field#getBoolean(Object)
  # @see     java.lang.reflect.Field#getByte(Object)
  # @see     java.lang.reflect.Field#getShort(Object)
  # @see     java.lang.reflect.Field#getChar(Object)
  # @see     java.lang.reflect.Field#getInt(Object)
  # @see     java.lang.reflect.Field#getLong(Object)
  # @see     java.lang.reflect.Field#getFloat(Object)
  # @see     java.lang.reflect.Field#getDouble(Object)
  # @see     java.lang.reflect.Method#invoke(Object, Object[])
  # @see     java.lang.reflect.Constructor#newInstance(Object[])
  # @since   JDK1.0
  class IllegalAccessException < IllegalAccessExceptionImports.const_get :Exception
    include_class_members IllegalAccessExceptionImports
    
    typesig { [] }
    # Constructs an <code>IllegalAccessException</code> without a
    # detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs an <code>IllegalAccessException</code> with a detail message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__illegal_access_exception, :initialize
  end
  
end
