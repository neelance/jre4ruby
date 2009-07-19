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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Util
  module MissingResourceExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Signals that a resource is missing.
  # @see java.lang.Exception
  # @see ResourceBundle
  # @author      Mark Davis
  # @since       JDK1.1
  class MissingResourceException < MissingResourceExceptionImports.const_get :RuntimeException
    include_class_members MissingResourceExceptionImports
    
    typesig { [String, String, String] }
    # Constructs a MissingResourceException with the specified information.
    # A detail message is a String that describes this particular exception.
    # @param s the detail message
    # @param className the name of the resource class
    # @param key the key for the missing resource.
    def initialize(s, class_name, key)
      @class_name = nil
      @key = nil
      super(s)
      @class_name = class_name
      @key = key
    end
    
    typesig { [String, String, String, Exception] }
    # Constructs a <code>MissingResourceException</code> with
    # <code>message</code>, <code>className</code>, <code>key</code>,
    # and <code>cause</code>. This constructor is package private for
    # use by <code>ResourceBundle.getBundle</code>.
    # 
    # @param message
    # the detail message
    # @param className
    # the name of the resource class
    # @param key
    # the key for the missing resource.
    # @param cause
    # the cause (which is saved for later retrieval by the
    # {@link Throwable.getCause()} method). (A null value is
    # permitted, and indicates that the cause is nonexistent
    # or unknown.)
    def initialize(message, class_name, key, cause)
      @class_name = nil
      @key = nil
      super(message, cause)
      @class_name = class_name
      @key = key
    end
    
    typesig { [] }
    # Gets parameter passed by constructor.
    # 
    # @return the name of the resource class
    def get_class_name
      return @class_name
    end
    
    typesig { [] }
    # Gets parameter passed by constructor.
    # 
    # @return the key for the missing resource
    def get_key
      return @key
    end
    
    class_module.module_eval {
      # ============ privates ============
      # serialization compatibility with JDK1.1
      const_set_lazy(:SerialVersionUID) { -4876345176062000401 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The class name of the resource bundle requested by the user.
    # @serial
    attr_accessor :class_name
    alias_method :attr_class_name, :class_name
    undef_method :class_name
    alias_method :attr_class_name=, :class_name=
    undef_method :class_name=
    
    # The name of the specific resource requested by the user.
    # @serial
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    private
    alias_method :initialize__missing_resource_exception, :initialize
  end
  
end
