require "rjava"

# Copyright 1995-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module URLStreamHandlerFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # This interface defines a factory for <code>URL</code> stream
  # protocol handlers.
  # <p>
  # It is used by the <code>URL</code> class to create a
  # <code>URLStreamHandler</code> for a specific protocol.
  # 
  # @author  Arthur van Hoff
  # @see     java.net.URL
  # @see     java.net.URLStreamHandler
  # @since   JDK1.0
  module URLStreamHandlerFactory
    include_class_members URLStreamHandlerFactoryImports
    
    typesig { [String] }
    # Creates a new <code>URLStreamHandler</code> instance with the specified
    # protocol.
    # 
    # @param   protocol   the protocol ("<code>ftp</code>",
    # "<code>http</code>", "<code>nntp</code>", etc.).
    # @return  a <code>URLStreamHandler</code> for the specific protocol.
    # @see     java.net.URLStreamHandler
    def create_urlstream_handler(protocol)
      raise NotImplementedError
    end
  end
  
end
