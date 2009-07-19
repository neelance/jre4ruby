require "rjava"

# Copyright 1996-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Http
  module HttpAuthenticatorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Net, :URL
    }
  end
  
  # An interface for all objects that implement HTTP authentication.
  # See the HTTP spec for details on how this works in general.
  # A single class or object can implement an arbitrary number of
  # authentication schemes.
  # 
  # @author David Brown
  # 
  # @deprecated -- use java.net.Authenticator instead
  # @see java.net.Authenticator
  # 
  # 
  # REMIND:  Unless compatibility with sun.* API's from 1.2 to 2.0 is
  # a goal, there's no reason to carry this forward into JDK 2.0.
  module HttpAuthenticator
    include_class_members HttpAuthenticatorImports
    
    typesig { [String] }
    # Indicate whether the specified authentication scheme is
    # supported.  In accordance with HTTP specifications, the
    # scheme name should be checked in a case-insensitive fashion.
    def scheme_supported(scheme)
      raise NotImplementedError
    end
    
    typesig { [URL, String, String] }
    # Returns the String that should be included in the HTTP
    # <B>Authorization</B> field.  Return null if no info was
    # supplied or could be found.
    # <P>
    # Example:
    # --> GET http://www.authorization-required.com/ HTTP/1.0
    # <-- HTTP/1.0 403 Unauthorized
    # <-- WWW-Authenticate: Basic realm="WallyWorld"
    # call schemeSupported("Basic"); (return true)
    # call authString(u, "Basic", "WallyWorld", null);
    # return "QWadhgWERghghWERfdfQ=="
    # --> GET http://www.authorization-required.com/ HTTP/1.0
    # --> Authorization: Basic QWadhgWERghghWERfdfQ==
    # <-- HTTP/1.0 200 OK
    # <B> YAY!!!</B>
    def auth_string(u, scheme, realm)
      raise NotImplementedError
    end
  end
  
end
