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
  module AuthResources_zh_TWImports #:nodoc:
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
  class AuthResources_zh_TW < Java::Util::ListResourceBundle
    include_class_members AuthResources_zh_TWImports
    
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
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", ("".to_u << 0x7121 << "".to_u << 0x6548 << "".to_u << 0x7a7a << "".to_u << 0x8f38 << "".to_u << 0x5165 << "".to_u << 0xff1a << " {0}")]), Array.typed(Object).new(["NTDomainPrincipal: name", "NTDomainPrincipal: {0}"]), Array.typed(Object).new(["NTNumericCredential: name", "NTNumericCredential: {0}"]), Array.typed(Object).new(["Invalid NTSid value", ("".to_u << 0x7121 << "".to_u << 0x6548 << " NTSid ".to_u << 0x503c << "")]), Array.typed(Object).new(["NTSid: name", "NTSid: {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", "NTSidDomainPrincipal: {0}"]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NTSidGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", "NTSidPrimaryGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NTSidUserPrincipal: {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NTUserPrincipal: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", ("UnixNumericGroupPrincipal [".to_u << 0x4e3b << "".to_u << 0x7fa4 << "".to_u << 0x7d44 << "]".to_u << 0xff1a << " {0}")]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", ("UnixNumericGroupPrincipal [".to_u << 0x9644 << "".to_u << 0x52a0 << "".to_u << 0x7fa4 << "".to_u << 0x7d44 << "]".to_u << 0xff1a << " {0}")]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "UnixNumericUserPrincipal: {0}"]), Array.typed(Object).new(["UnixPrincipal: name", ("UnixPrincipal".to_u << 0xff1a << " {0}")]), Array.typed(Object).new(["Unable to properly expand config", ("".to_u << 0x7121 << "".to_u << 0x6cd5 << "".to_u << 0x5b8c << "".to_u << 0x5168 << "".to_u << 0x64f4 << "".to_u << 0x5145 << " {0}")]), Array.typed(Object).new(["extra_config (No such file or directory)", ("{0} ".to_u << 0xff08 << "".to_u << 0x6c92 << "".to_u << 0x6709 << "".to_u << 0x6b64 << "".to_u << 0x6a94 << "".to_u << 0x6848 << "".to_u << 0x6216 << "".to_u << 0x76ee << "".to_u << 0x9304 << "".to_u << 0xff09 << "")]), Array.typed(Object).new(["Unable to locate a login configuration", ("".to_u << 0x7121 << "".to_u << 0x6cd5 << "".to_u << 0x5b9a << "".to_u << 0x4f4d << "".to_u << 0x767b << "".to_u << 0x5165 << "".to_u << 0x914d << "".to_u << 0x7f6e << "")]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x932f << "".to_u << 0x8aa4 << "".to_u << 0xff1a << "\n\t".to_u << 0x7121 << "".to_u << 0x6548 << "".to_u << 0x7684 << "".to_u << 0x63a7 << "".to_u << 0x5236 << "".to_u << 0x65d7 << "".to_u << 0x865f << "".to_u << 0xff0c << " {0}")]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x932f << "".to_u << 0x8aa4 << "".to_u << 0xff1a << "\n\t".to_u << 0x7121 << "".to_u << 0x6cd5 << "".to_u << 0x6307 << "".to_u << 0x5b9a << "".to_u << 0x591a << "".to_u << 0x91cd << "".to_u << 0x9805 << "".to_u << 0x76ee << " {0}")]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x932f << "".to_u << 0x8aa4 << "".to_u << 0xff1a << "\n\t".to_u << 0x9810 << "".to_u << 0x671f << "".to_u << 0x7684 << " [{0}], ".to_u << 0x8b80 << "".to_u << 0x53d6 << " [".to_u << 0x6a94 << "".to_u << 0x6848 << "".to_u << 0x672b << "".to_u << 0x7aef << "]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x932f << "".to_u << 0x8aa4 << "".to_u << 0xff1a << "\n\t".to_u << 0x884c << " {0}: ".to_u << 0x9810 << "".to_u << 0x671f << "".to_u << 0x7684 << " [{1}], ".to_u << 0x767c << "".to_u << 0x73fe << " [{2}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x932f << "".to_u << 0x8aa4 << "".to_u << 0xff1a << "\n\t".to_u << 0x884c << " {0}: ".to_u << 0x9810 << "".to_u << 0x671f << "".to_u << 0x7684 << " [{1}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", ("".to_u << 0x914d << "".to_u << 0x7f6e << "".to_u << 0x932f << "".to_u << 0x8aa4 << "".to_u << 0xff1a << "\n\t".to_u << 0x884c << " {0}: ".to_u << 0x7cfb << "".to_u << 0x7d71 << "".to_u << 0x5c6c << "".to_u << 0x6027 << " [{1}] ".to_u << 0x64f4 << "".to_u << 0x5145 << "".to_u << 0x81f3 << "".to_u << 0x7a7a << "".to_u << 0x503c << "")]), Array.typed(Object).new(["username: ", ("".to_u << 0x4f7f << "".to_u << 0x7528 << "".to_u << 0x8005 << "".to_u << 0x540d << "".to_u << 0x7a31 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["password: ", ("".to_u << 0x5bc6 << "".to_u << 0x78bc << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Please enter keystore information", ("".to_u << 0x8acb << "".to_u << 0x8f38 << "".to_u << 0x5165 << " keystore ".to_u << 0x8cc7 << "".to_u << 0x8a0a << "")]), Array.typed(Object).new(["Keystore alias: ", ("Keystore ".to_u << 0x5225 << "".to_u << 0x540d << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Keystore password: ", ("Keystore ".to_u << 0x5bc6 << "".to_u << 0x78bc << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Private key password (optional): ", ("".to_u << 0x79c1 << "".to_u << 0x4eba << "".to_u << 0x95dc << "".to_u << 0x9375 << "".to_u << 0x5bc6 << "".to_u << 0x78bc << "".to_u << 0xff08 << "".to_u << 0x9078 << "".to_u << 0x64c7 << "".to_u << 0x6027 << "".to_u << 0x7684 << "".to_u << 0xff09 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", ("Kerberos ".to_u << 0x4f7f << "".to_u << 0x7528 << "".to_u << 0x8005 << "".to_u << 0x540d << "".to_u << 0x7a31 << " [{0}]: ")]), Array.typed(Object).new(["Kerberos password for [username]: ", ("Kerberos ".to_u << 0x7684 << " {0} ".to_u << 0x5bc6 << "".to_u << 0x78bc << "".to_u << 0xff1a << "  ")]), Array.typed(Object).new([": error parsing ", ("".to_u << 0xff1a << "".to_u << 0x8a9e << "".to_u << 0x6cd5 << "".to_u << 0x932f << "".to_u << 0x8aa4 << " ")]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", ("".to_u << 0xff1a << "".to_u << 0x65b0 << "".to_u << 0x589e << "".to_u << 0x8a31 << "".to_u << 0x53ef << "".to_u << 0x6b0a << "".to_u << 0x932f << "".to_u << 0x8aa4 << " ")]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", ("".to_u << 0x65b0 << "".to_u << 0x589e << "".to_u << 0x8f38 << "".to_u << 0x5165 << "".to_u << 0x932f << "".to_u << 0x8aa4 << " ")]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", ("".to_u << 0x8a66 << "".to_u << 0x8457 << "".to_u << 0x65b0 << "".to_u << 0x589e << "".to_u << 0x8a31 << "".to_u << 0x53ef << "".to_u << 0x6b0a << "".to_u << 0x81f3 << "".to_u << 0x552f << "".to_u << 0x8b80 << "".to_u << 0x7684 << " PermissionCollection")]), Array.typed(Object).new(["expected keystore type", ("".to_u << 0x9810 << "".to_u << 0x671f << "".to_u << 0x7684 << " keystore ".to_u << 0x985e << "".to_u << 0x578b << "")]), Array.typed(Object).new(["can not specify Principal with a ", ("".to_u << 0x7121 << "".to_u << 0x6cd5 << "".to_u << 0x4ee5 << "".to_u << 0x6b64 << "".to_u << 0x4f86 << "".to_u << 0x6307 << "".to_u << 0x5b9a << " Principal ")]), Array.typed(Object).new(["wildcard class without a wildcard name", ("".to_u << 0x842c << "".to_u << 0x7528 << "".to_u << 0x5b57 << "".to_u << 0x5143 << "".to_u << 0x985e << "".to_u << 0x5225 << "".to_u << 0x672a << "".to_u << 0x9644 << "".to_u << 0x842c << "".to_u << 0x7528 << "".to_u << 0x5b57 << "".to_u << 0x5143 << "".to_u << 0x540d << "".to_u << 0x7a31 << "")]), Array.typed(Object).new(["expected codeBase or SignedBy", ("".to_u << 0x9810 << "".to_u << 0x671f << "".to_u << 0x7684 << " codeBase ".to_u << 0x6216 << " SignedBy")]), Array.typed(Object).new(["only Principal-based grant entries permitted", ("".to_u << 0x53ea << "".to_u << 0x5141 << "".to_u << 0x8a31 << "".to_u << 0x4ee5 << " Principal ".to_u << 0x70ba << "".to_u << 0x57fa << "".to_u << 0x790e << "".to_u << 0x7684 << "".to_u << 0x6388 << "".to_u << 0x6b0a << "".to_u << 0x8f38 << "".to_u << 0x5165 << "")]), Array.typed(Object).new(["expected permission entry", ("".to_u << 0x9810 << "".to_u << 0x671f << "".to_u << 0x8a31 << "".to_u << 0x53ef << "".to_u << 0x8f38 << "".to_u << 0x5165 << "")]), Array.typed(Object).new(["number ", ("".to_u << 0x865f << "".to_u << 0x78bc << " ")]), Array.typed(Object).new(["expected ", ("".to_u << 0x9810 << "".to_u << 0x671f << "".to_u << 0x7684 << " ")]), Array.typed(Object).new([", read end of file", ("".to_u << 0xff0c << "".to_u << 0x8b80 << "".to_u << 0x53d6 << "".to_u << 0x6a94 << "".to_u << 0x6848 << "".to_u << 0x672b << "".to_u << 0x7aef << "")]), Array.typed(Object).new(["expected ';', read end of file", ("".to_u << 0x9810 << "".to_u << 0x671f << "".to_u << 0x7684 << " ';', ".to_u << 0x8b80 << "".to_u << 0x53d6 << "".to_u << 0x6a94 << "".to_u << 0x6848 << "".to_u << 0x672b << "".to_u << 0x7aef << "")]), Array.typed(Object).new(["line ", ("".to_u << 0x884c << " ")]), Array.typed(Object).new([": expected '", (": ".to_u << 0x9810 << "".to_u << 0x671f << " '")]), Array.typed(Object).new(["', found '", ("', ".to_u << 0x767c << "".to_u << 0x73fe << " '")]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", ("SolarisNumericGroupPrincipal [".to_u << 0x4e3b << "".to_u << 0x7fa4 << "".to_u << 0x7d44 << "]".to_u << 0xff1a << " ")]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", ("SolarisNumericGroupPrincipal [".to_u << 0x9644 << "".to_u << 0x52a0 << "".to_u << 0x7fa4 << "".to_u << 0x7d44 << "]".to_u << 0xff1a << " ")]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "SolarisNumericUserPrincipal: "]), Array.typed(Object).new(["SolarisPrincipal: ", "SolarisPrincipal: "]), Array.typed(Object).new(["provided null name", ("".to_u << 0x63d0 << "".to_u << 0x4f9b << "".to_u << 0x7684 << "".to_u << 0x7a7a << "".to_u << 0x540d << "".to_u << 0x7a31 << "")])]) }
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
    alias_method :initialize__auth_resources_zh_tw, :initialize
  end
  
end
