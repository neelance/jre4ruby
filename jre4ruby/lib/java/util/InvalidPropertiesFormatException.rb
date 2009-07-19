require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module InvalidPropertiesFormatExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :NotSerializableException
      include_const ::Java::Io, :IOException
    }
  end
  
  # Thrown to indicate that an operation could not complete because
  # the input did not conform to the appropriate XML document type
  # for a collection of properties, as per the {@link Properties}
  # specification.<p>
  # 
  # Note, that although InvalidPropertiesFormatException inherits Serializable
  # interface from Exception, it is not intended to be Serializable. Appropriate
  # serialization methods are implemented to throw NotSerializableException.
  # 
  # @see     Properties
  # @since   1.5
  # @serial exclude
  class InvalidPropertiesFormatException < InvalidPropertiesFormatExceptionImports.const_get :IOException
    include_class_members InvalidPropertiesFormatExceptionImports
    
    typesig { [Exception] }
    # Constructs an InvalidPropertiesFormatException with the specified
    # cause.
    # 
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link Throwable#getCause()} method).
    def initialize(cause)
      super((cause).nil? ? nil : cause.to_s)
      self.init_cause(cause)
    end
    
    typesig { [String] }
    # Constructs an InvalidPropertiesFormatException with the specified
    # detail message.
    # 
    # @param   message   the detail message. The detail message is saved for
    # later retrieval by the {@link Throwable#getMessage()} method.
    def initialize(message)
      super(message)
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Throws NotSerializableException, since InvalidPropertiesFormatException
    # objects are not intended to be serializable.
    def write_object(out)
      raise NotSerializableException.new("Not serializable.")
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Throws NotSerializableException, since InvalidPropertiesFormatException
    # objects are not intended to be serializable.
    def read_object(in_)
      raise NotSerializableException.new("Not serializable.")
    end
    
    private
    alias_method :initialize__invalid_properties_format_exception, :initialize
  end
  
end
