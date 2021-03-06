require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Https
  module DefaultHostnameVerifierImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Https
      include_const ::Javax::Net::Ssl, :HostnameVerifier
      include_const ::Javax::Net::Ssl, :SSLSession
    }
  end
  
  # <code>HostnameVerifier</code> provides a callback mechanism so that
  # implementers of this interface can supply a policy for
  # handling the case where the host to connect to and
  # the server name from the certificate mismatch.
  # 
  # The default implementation will deny such connections.
  # 
  # @author Xuelei Fan
  class DefaultHostnameVerifier 
    include_class_members DefaultHostnameVerifierImports
    include HostnameVerifier
    
    typesig { [String, SSLSession] }
    def verify(hostname, session)
      return false
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__default_hostname_verifier, :initialize
  end
  
end
