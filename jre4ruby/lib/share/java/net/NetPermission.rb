require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module NetPermissionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include ::Java::Security
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :StringTokenizer
    }
  end
  
  # This class is for various network permissions.
  # A NetPermission contains a name (also referred to as a "target name") but
  # no actions list; you either have the named permission
  # or you don't.
  # <P>
  # The target name is the name of the network permission (see below). The naming
  # convention follows the  hierarchical property naming convention.
  # Also, an asterisk
  # may appear at the end of the name, following a ".", or by itself, to
  # signify a wildcard match. For example: "foo.*" or "*" is valid,
  # "*foo" or "a*b" is not valid.
  # <P>
  # The following table lists all the possible NetPermission target names,
  # and for each provides a description of what the permission allows
  # and a discussion of the risks of granting code the permission.
  # <P>
  # 
  # <table border=1 cellpadding=5 summary="Permission target name, what the permission allows, and associated risks">
  # <tr>
  # <th>Permission Target Name</th>
  # <th>What the Permission Allows</th>
  # <th>Risks of Allowing this Permission</th>
  # </tr>
  # 
  # <tr>
  # <td>setDefaultAuthenticator</td>
  # <td>The ability to set the
  # way authentication information is retrieved when
  # a proxy or HTTP server asks for authentication</td>
  # <td>Malicious
  # code can set an authenticator that monitors and steals user
  # authentication input as it retrieves the input from the user.</td>
  # </tr>
  # 
  # <tr>
  # <td>requestPasswordAuthentication</td>
  # <td>The ability
  # to ask the authenticator registered with the system for
  # a password</td>
  # <td>Malicious code may steal this password.</td>
  # </tr>
  # 
  # <tr>
  # <td>specifyStreamHandler</td>
  # <td>The ability
  # to specify a stream handler when constructing a URL</td>
  # <td>Malicious code may create a URL with resources that it would
  # normally not have access to (like file:/foo/fum/), specifying a
  # stream handler that gets the actual bytes from someplace it does
  # have access to. Thus it might be able to trick the system into
  # creating a ProtectionDomain/CodeSource for a class even though
  # that class really didn't come from that location.</td>
  # </tr>
  # 
  # <tr>
  # <td>setProxySelector</td>
  # <td>The ability to set the proxy selector used to make decisions
  # on which proxies to use when making network connections.</td>
  # <td>Malicious code can set a ProxySelector that directs network
  # traffic to an arbitrary network host.</td>
  # </tr>
  # 
  # <tr>
  # <td>getProxySelector</td>
  # <td>The ability to get the proxy selector used to make decisions
  # on which proxies to use when making network connections.</td>
  # <td>Malicious code can get a ProxySelector to discover proxy
  # hosts and ports on internal networks, which could then become
  # targets for attack.</td>
  # </tr>
  # 
  # <tr>
  # <td>setCookieHandler</td>
  # <td>The ability to set the cookie handler that processes highly
  # security sensitive cookie information for an Http session.</td>
  # <td>Malicious code can set a cookie handler to obtain access to
  # highly security sensitive cookie information. Some web servers
  # use cookies to save user private information such as access
  # control information, or to track user browsing habit.</td>
  # </tr>
  # 
  # <tr>
  # <td>getCookieHandler</td>
  # <td>The ability to get the cookie handler that processes highly
  # security sensitive cookie information for an Http session.</td>
  # <td>Malicious code can get a cookie handler to obtain access to
  # highly security sensitive cookie information. Some web servers
  # use cookies to save user private information such as access
  # control information, or to track user browsing habit.</td>
  # </tr>
  # 
  # <tr>
  # <td>setResponseCache</td>
  # <td>The ability to set the response cache that provides access to
  # a local response cache.</td>
  # <td>Malicious code getting access to the local response cache
  # could access security sensitive information, or create false
  # entries in the response cache.</td>
  # </tr>
  # 
  # <tr>
  # <td>getResponseCache</td>
  # <td>The ability to get the response cache that provides
  # access to a local response cache.</td>
  # <td>Malicious code getting access to the local response cache
  # could access security sensitive information.</td>
  # </tr>
  # 
  # </table>
  # 
  # @see java.security.BasicPermission
  # @see java.security.Permission
  # @see java.security.Permissions
  # @see java.security.PermissionCollection
  # @see java.lang.SecurityManager
  # 
  # 
  # @author Marianne Mueller
  # @author Roland Schemers
  class NetPermission < NetPermissionImports.const_get :BasicPermission
    include_class_members NetPermissionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -8343910153355041693 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [String] }
    # Creates a new NetPermission with the specified name.
    # The name is the symbolic name of the NetPermission, such as
    # "setDefaultAuthenticator", etc. An asterisk
    # may appear at the end of the name, following a ".", or by itself, to
    # signify a wildcard match.
    # 
    # @param name the name of the NetPermission.
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty.
    def initialize(name)
      super(name)
    end
    
    typesig { [String, String] }
    # Creates a new NetPermission object with the specified name.
    # The name is the symbolic name of the NetPermission, and the
    # actions String is currently unused and should be null.
    # 
    # @param name the name of the NetPermission.
    # @param actions should be null.
    # 
    # @throws NullPointerException if <code>name</code> is <code>null</code>.
    # @throws IllegalArgumentException if <code>name</code> is empty.
    def initialize(name, actions)
      super(name, actions)
    end
    
    private
    alias_method :initialize__net_permission, :initialize
  end
  
end