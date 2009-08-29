require "rjava"

# Copyright 2001-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module AuthResources_zh_CNImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
    }
  end
  
  # <p> This class represents the <code>ResourceBundle</code>
  # for the following packages:
  # 
  # <ol>
  # <li> com.sun.security.auth
  # <li> com.sun.security.auth.login
  # </ol>
  class AuthResources_zh_CN < Java::Util::ListResourceBundle
    include_class_members AuthResources_zh_CNImports
    
    class_module.module_eval {
      # NT principals
      # UnixPrincipals
      # com.sun.security.auth.login.ConfigFile
      # com.sun.security.auth.module.JndiLoginModule
      # com.sun.security.auth.module.KeyStoreLoginModule
      # com.sun.security.auth.module.Krb5LoginModule
      # EVERYTHING BELOW IS DEPRECATED  **
      # com.sun.security.auth.PolicyFile
      # com.sun.security.auth.PolicyParser
      # SolarisPrincipals
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", ("".to_u << 0x65e0 << "".to_u << 0x6548 << "".to_u << 0x7684 << "".to_u << 0x7a7a << "".to_u << 0x8f93 << "".to_u << 0x5165 << "".to_u << 0xff1a << " {0}")]), Array.typed(Object).new(["NTDomainPrincipal: name", "NTDomainPrincipal: {0}"]), Array.typed(Object).new(["NTNumericCredential: name", "NTNumericCredential: {0}"]), Array.typed(Object).new(["Invalid NTSid value", ("".to_u << 0x65e0 << "".to_u << 0x6548 << "".to_u << 0x7684 << " NTSid ".to_u << 0x503c << "")]), Array.typed(Object).new(["NTSid: name", "NTSid: {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", "NTSidDomainPrincipal: {0}"]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NTSidGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", "NTSidPrimaryGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NTSidUserPrincipal: {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NTUserPrincipal: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", ("UnixNumericGroupPrincipal [".to_u << 0x4e3b << "".to_u << 0x7fa4 << "".to_u << 0x7ec4 << "]".to_u << 0xff1a << " {0}")]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", ("UnixNumericGroupPrincipal [".to_u << 0x9644 << "".to_u << 0x52a0 << "".to_u << 0x7fa4 << "".to_u << 0x7ec4 << "]".to_u << 0xff1a << " {0}")]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "UnixNumericUserPrincipal: {0}"]), Array.typed(Object).new(["UnixPrincipal: name", ("UnixPrincipal".to_u << 0xff1a << " {0}")]), Array.typed(Object).new(["Unable to properly expand config", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x5b8c << "".to_u << 0x5168 << "".to_u << 0x6269 << "".to_u << 0x5145 << " {0}")]), Array.typed(Object).new(["extra_config (No such file or directory)", ("{0} ".to_u << 0xff08 << "".to_u << 0x6ca1 << "".to_u << 0x6709 << "".to_u << 0x6b64 << "".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x6216 << "".to_u << 0x76ee << "".to_u << 0x5f55 << "".to_u << 0xff09 << "")]), Array.typed(Object).new(["Unable to locate a login configuration", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x5b9a << "".to_u << 0x4f4d << "".to_u << 0x767b << "".to_u << 0x5f55 << "".to_u << 0x914d << "".to_u << 0x7f6e << "")]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x9519 << "".to_u << 0x8bef << "".to_u << 0xff1a << "\n\t".to_u << 0x65e0 << "".to_u << 0x6548 << "".to_u << 0x7684 << "".to_u << 0x63a7 << "".to_u << 0x5236 << "".to_u << 0x6807 << "".to_u << 0x8bb0 << "".to_u << 0xff0c << " {0}")]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x9519 << "".to_u << 0x8bef << "".to_u << 0xff1a << "\n\t".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x6307 << "".to_u << 0x5b9a << "".to_u << 0x591a << "".to_u << 0x4e2a << "".to_u << 0x9879 << "".to_u << 0x76ee << " {0}")]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x9519 << "".to_u << 0x8bef << "".to_u << 0xff1a << "\n\t".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << " [{0}], ".to_u << 0x8bfb << "".to_u << 0x53d6 << " [".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x672b << "".to_u << 0x7aef << "]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x9519 << "".to_u << 0x8bef << "".to_u << 0xff1a << "\n\t".to_u << 0x884c << " {0}: ".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << " [{1}], ".to_u << 0x627e << "".to_u << 0x5230 << " [{2}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x9519 << "".to_u << 0x8bef << "".to_u << 0xff1a << "\n\t".to_u << 0x884c << " {0}: ".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << " [{1}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x9519 << "".to_u << 0x8bef << "".to_u << 0xff1a << "\n\t".to_u << 0x884c << " {0}: ".to_u << 0x7cfb << "".to_u << 0x7edf << "".to_u << 0x5c5e << "".to_u << 0x6027 << " [{1}] ".to_u << 0x6269 << "".to_u << 0x5145 << "".to_u << 0x81f3 << "".to_u << 0x7a7a << "".to_u << 0x503c << "")]), Array.typed(Object).new(["username: ", ("".to_u << 0x7528 << "".to_u << 0x6237 << "".to_u << 0x540d << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["password: ", ("".to_u << 0x5bc6 << "".to_u << 0x7801 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Please enter keystore information", ("".to_u << 0x8bf7 << "".to_u << 0x8f93 << "".to_u << 0x5165 << " keystore ".to_u << 0x4fe1 << "".to_u << 0x606f << "")]), Array.typed(Object).new(["Keystore alias: ", ("Keystore ".to_u << 0x522b << "".to_u << 0x540d << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Keystore password: ", ("Keystore ".to_u << 0x5bc6 << "".to_u << 0x7801 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Private key password (optional): ", ("".to_u << 0x79c1 << "".to_u << 0x4eba << "".to_u << 0x5173 << "".to_u << 0x952e << "".to_u << 0x5bc6 << "".to_u << 0x7801 << "".to_u << 0xff08 << "".to_u << 0x53ef << "".to_u << 0x9009 << "".to_u << 0x7684 << "".to_u << 0xff09 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", ("Kerberos ".to_u << 0x7528 << "".to_u << 0x6237 << "".to_u << 0x540d << " [{0}]: ")]), Array.typed(Object).new(["Kerberos password for [username]: ", (" {0} ".to_u << 0x7684 << " Kerberos ".to_u << 0x5bc6 << "".to_u << 0x7801 << ": ")]), Array.typed(Object).new([": error parsing ", ("".to_u << 0xff1a << "".to_u << 0x8bed << "".to_u << 0x6cd5 << "".to_u << 0x89e3 << "".to_u << 0x6790 << "".to_u << 0x9519 << "".to_u << 0x8bef << " ")]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", ("".to_u << 0xff1a << "".to_u << 0x6dfb << "".to_u << 0x52a0 << "".to_u << 0x6743 << "".to_u << 0x9650 << "".to_u << 0x9519 << "".to_u << 0x8bef << " ")]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", ("".to_u << 0x6dfb << "".to_u << 0x52a0 << "".to_u << 0x9879 << "".to_u << 0x76ee << "".to_u << 0x9519 << "".to_u << 0x8bef << " ")]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", ("".to_u << 0x8bd5 << "".to_u << 0x56fe << "".to_u << 0x5c06 << "".to_u << 0x6743 << "".to_u << 0x9650 << "".to_u << 0x6dfb << "".to_u << 0x52a0 << "".to_u << 0x81f3 << "".to_u << 0x53ea << "".to_u << 0x8bfb << "".to_u << 0x7684 << " PermissionCollection")]), Array.typed(Object).new(["expected keystore type", ("".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << " keystore ".to_u << 0x7c7b << "".to_u << 0x578b << "")]), Array.typed(Object).new(["can not specify Principal with a ", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x4ee5 << "".to_u << 0x6b64 << "".to_u << 0x6765 << "".to_u << 0x6307 << "".to_u << 0x5b9a << " Principal ")]), Array.typed(Object).new(["wildcard class without a wildcard name", ("".to_u << 0x65e0 << "".to_u << 0x901a << "".to_u << 0x914d << "".to_u << 0x5b57 << "".to_u << 0x7b26 << "".to_u << 0x540d << "".to_u << 0x79f0 << "".to_u << 0x7684 << "".to_u << 0x901a << "".to_u << 0x914d << "".to_u << 0x5b57 << "".to_u << 0x7b26 << "".to_u << 0x7c7b << "")]), Array.typed(Object).new(["expected codeBase or SignedBy", ("".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << " codeBase ".to_u << 0x6216 << " SignedBy")]), Array.typed(Object).new(["only Principal-based grant entries permitted", ("".to_u << 0x53ea << "".to_u << 0x5141 << "".to_u << 0x8bb8 << "".to_u << 0x57fa << "".to_u << 0x4e8e << " Principal ".to_u << 0x7684 << "".to_u << 0x6388 << "".to_u << 0x6743 << "".to_u << 0x9879 << "".to_u << 0x76ee << "")]), Array.typed(Object).new(["expected permission entry", ("".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << "".to_u << 0x6743 << "".to_u << 0x9650 << "".to_u << 0x9879 << "".to_u << 0x76ee << "")]), Array.typed(Object).new(["number ", ("".to_u << 0x53f7 << "".to_u << 0x7801 << " ")]), Array.typed(Object).new(["expected ", ("".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << " ")]), Array.typed(Object).new([", read end of file", ("".to_u << 0xff0c << "".to_u << 0x8bfb << "".to_u << 0x53d6 << "".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x672b << "".to_u << 0x7aef << "")]), Array.typed(Object).new(["expected ';', read end of file", ("".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << " ';', ".to_u << 0x8bfb << "".to_u << 0x53d6 << "".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x672b << "".to_u << 0x7aef << "")]), Array.typed(Object).new(["line ", ("".to_u << 0x884c << " ")]), Array.typed(Object).new([": expected '", (": ".to_u << 0x9884 << "".to_u << 0x671f << "".to_u << 0x7684 << " '")]), Array.typed(Object).new(["', found '", ("', ".to_u << 0x627e << "".to_u << 0x5230 << " '")]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", ("SolarisNumericGroupPrincipal [".to_u << 0x4e3b << "".to_u << 0x7fa4 << "".to_u << 0x7ec4 << "]".to_u << 0xff1a << " ")]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", ("SolarisNumericGroupPrincipal [".to_u << 0x9644 << "".to_u << 0x52a0 << "".to_u << 0x7fa4 << "".to_u << 0x7ec4 << "]".to_u << 0xff1a << " ")]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "SolarisNumericUserPrincipal: "]), Array.typed(Object).new(["SolarisPrincipal: ", "SolarisPrincipal: "]), Array.typed(Object).new(["provided null name", ("".to_u << 0x5df2 << "".to_u << 0x63d0 << "".to_u << 0x4f9b << "".to_u << 0x7684 << "".to_u << 0x7a7a << "".to_u << 0x540d << "".to_u << 0x79f0 << "")])]) }
      const_attr_reader  :Contents
    }
    
    typesig { [] }
    # Returns the contents of this <code>ResourceBundle</code>.
    # 
    # <p>
    # 
    # @return the contents of this <code>ResourceBundle</code>.
    def get_contents
      return Contents
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__auth_resources_zh_cn, :initialize
  end
  
end
