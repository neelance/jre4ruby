require "rjava"

# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Prefs
  module InvalidPreferencesFormatExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
      include_const ::Java::Io, :NotSerializableException
    }
  end
  
  # Thrown to indicate that an operation could not complete because
  # the input did not conform to the appropriate XML document type
  # for a collection of preferences, as per the {@link Preferences}
  # specification.
  # 
  # @author  Josh Bloch
  # @see     Preferences
  # @since   1.4
  class InvalidPreferencesFormatException < InvalidPreferencesFormatExceptionImports.const_get :Exception
    include_class_members InvalidPreferencesFormatExceptionImports
    
    typesig { [Exception] }
    # Constructs an InvalidPreferencesFormatException with the specified
    # cause.
    # 
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link Throwable#getCause()} method).
    def initialize(cause)
      super(cause)
    end
    
    typesig { [String] }
    # Constructs an InvalidPreferencesFormatException with the specified
    # detail message.
    # 
    # @param   message   the detail message. The detail message is saved for
    # later retrieval by the {@link Throwable#getMessage()} method.
    def initialize(message)
      super(message)
    end
    
    typesig { [String, Exception] }
    # Constructs an InvalidPreferencesFormatException with the specified
    # detail message and cause.
    # 
    # @param  message   the detail message. The detail message is saved for
    # later retrieval by the {@link Throwable#getMessage()} method.
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link Throwable#getCause()} method).
    def initialize(message, cause)
      super(message, cause)
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -791715184232119669 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__invalid_preferences_format_exception, :initialize
  end
  
end
