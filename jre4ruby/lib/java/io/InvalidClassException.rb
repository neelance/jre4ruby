require "rjava"

# 
# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module InvalidClassExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # 
  # Thrown when the Serialization runtime detects one of the following
  # problems with a Class.
  # <UL>
  # <LI> The serial version of the class does not match that of the class
  # descriptor read from the stream
  # <LI> The class contains unknown datatypes
  # <LI> The class does not have an accessible no-arg constructor
  # </UL>
  # 
  # @author  unascribed
  # @since   JDK1.1
  class InvalidClassException < InvalidClassExceptionImports.const_get :ObjectStreamException
    include_class_members InvalidClassExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -4333316296251054416 }
      const_attr_reader  :SerialVersionUID
    }
    
    # 
    # Name of the invalid class.
    # 
    # @serial Name of the invalid class.
    attr_accessor :classname
    alias_method :attr_classname, :classname
    undef_method :classname
    alias_method :attr_classname=, :classname=
    undef_method :classname=
    
    typesig { [String] }
    # 
    # Report an InvalidClassException for the reason specified.
    # 
    # @param reason  String describing the reason for the exception.
    def initialize(reason)
      @classname = nil
      super(reason)
    end
    
    typesig { [String, String] }
    # 
    # Constructs an InvalidClassException object.
    # 
    # @param cname   a String naming the invalid class.
    # @param reason  a String describing the reason for the exception.
    def initialize(cname, reason)
      @classname = nil
      super(reason)
      @classname = cname
    end
    
    typesig { [] }
    # 
    # Produce the message and include the classname, if present.
    def get_message
      if ((@classname).nil?)
        return super
      else
        return @classname + "; " + (super).to_s
      end
    end
    
    private
    alias_method :initialize__invalid_class_exception, :initialize
  end
  
end
