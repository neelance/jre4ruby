require "rjava"

# Copyright 1997-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Jar
  module JarExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Jar
    }
  end
  
  # Signals that an error of some sort has occurred while reading from
  # or writing to a JAR file.
  # 
  # @author  David Connelly
  # @since   1.2
  class JarException < Java::Util::Zip::ZipException
    include_class_members JarExceptionImports
    
    typesig { [] }
    # Constructs a JarException with no detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # Constructs a JarException with the specified detail message.
    # @param s the detail message
    def initialize(s)
      super(s)
    end
    
    private
    alias_method :initialize__jar_exception, :initialize
  end
  
end
