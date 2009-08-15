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
  module AuthResources_koImports
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
  class AuthResources_ko < Java::Util::ListResourceBundle
    include_class_members AuthResources_koImports
    
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
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", ("".to_u << 0xc798 << "".to_u << 0xbabb << "".to_u << 0xb41c << " ".to_u << 0xb110 << " ".to_u << 0xc785 << "".to_u << 0xb825 << ":  {0}")]), Array.typed(Object).new(["NTDomainPrincipal: name", "NTDomainPrincipal: {0}"]), Array.typed(Object).new(["NTNumericCredential: name", "NTNumericCredential: {0}"]), Array.typed(Object).new(["Invalid NTSid value", ("".to_u << 0xc798 << "".to_u << 0xbabb << "".to_u << 0xb41c << " NTSid ".to_u << 0xac12 << "")]), Array.typed(Object).new(["NTSid: name", "NTSid: {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", "NTSidDomainPrincipal: {0}"]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NTSidGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", "NTSidPrimaryGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NTSidUserPrincipal: {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NTUserPrincipal: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", ("UnixNumericGroupPrincipal [".to_u << 0xae30 << "".to_u << 0xbcf8 << " ".to_u << 0xadf8 << "".to_u << 0xb8f9 << "]:  {0}")]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", ("UnixNumericGroupPrincipal [".to_u << 0xbcf4 << "".to_u << 0xc870 << " ".to_u << 0xadf8 << "".to_u << 0xb8f9 << "]:  {0}")]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "UnixNumericUserPrincipal: {0}"]), Array.typed(Object).new(["UnixPrincipal: name", "UnixPrincipal: {0}"]), Array.typed(Object).new(["Unable to properly expand config", ("".to_u << 0xc801 << "".to_u << 0xc808 << "".to_u << 0xd788 << " ".to_u << 0xd655 << "".to_u << 0xc7a5 << "".to_u << 0xd560 << " ".to_u << 0xc218 << " ".to_u << 0xc5c6 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ". {0}")]), Array.typed(Object).new(["extra_config (No such file or directory)", ("{0} (".to_u << 0xd574 << "".to_u << 0xb2f9 << " ".to_u << 0xd30c << "".to_u << 0xc77c << "".to_u << 0xc774 << "".to_u << 0xb098 << " ".to_u << 0xb514 << "".to_u << 0xb809 << "".to_u << 0xd1a0 << "".to_u << 0xb9ac << "".to_u << 0xac00 << " ".to_u << 0xc5c6 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".)")]), Array.typed(Object).new(["Unable to locate a login configuration", ("".to_u << 0xb85c << "".to_u << 0xadf8 << "".to_u << 0xc778 << " ".to_u << 0xad6c << "".to_u << 0xc131 << "".to_u << 0xc744 << " ".to_u << 0xcc3e << "".to_u << 0xc744 << " ".to_u << 0xc218 << " ".to_u << 0xc5c6 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", ("".to_u << 0xad6c << "".to_u << 0xc131 << " ".to_u << 0xc624 << "".to_u << 0xb958 << ":\n\t".to_u << 0xc798 << "".to_u << 0xbabb << "".to_u << 0xb41c << " ".to_u << 0xcee8 << "".to_u << 0xd2b8 << "".to_u << 0xb864 << " ".to_u << 0xd50c << "".to_u << 0xb798 << "".to_u << 0xadf8 << ", {0}")]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", ("".to_u << 0xad6c << "".to_u << 0xc131 << " ".to_u << 0xc624 << "".to_u << 0xb958 << ":\n\t{0}".to_u << 0xc5d0 << " ".to_u << 0xb300 << "".to_u << 0xd574 << " ".to_u << 0xc5ec << "".to_u << 0xb7ec << " ".to_u << 0xd56d << "".to_u << 0xbaa9 << "".to_u << 0xc744 << " ".to_u << 0xc9c0 << "".to_u << 0xc815 << "".to_u << 0xd560 << " ".to_u << 0xc218 << " ".to_u << 0xc5c6 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", ("".to_u << 0xad6c << "".to_u << 0xc131 << " ".to_u << 0xc624 << "".to_u << 0xb958 << ":\n\t".to_u << 0xc608 << "".to_u << 0xc0c1 << " [{0}], ".to_u << 0xc77d << "".to_u << 0xc74c << " [".to_u << 0xd30c << "".to_u << 0xc77c << "".to_u << 0xc758 << " ".to_u << 0xb05d << "]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", ("".to_u << 0xad6c << "".to_u << 0xc131 << " ".to_u << 0xc624 << "".to_u << 0xb958 << ":\n\t".to_u << 0xc904 << " {0}: ".to_u << 0xc608 << "".to_u << 0xc0c1 << " [{1}], ".to_u << 0xbc1c << "".to_u << 0xacac << " [{2}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", ("".to_u << 0xad6c << "".to_u << 0xc131 << " ".to_u << 0xc624 << "".to_u << 0xb958 << ":\n\t".to_u << 0xc904 << " {0}: ".to_u << 0xc608 << "".to_u << 0xc0c1 << " [{1}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", ("".to_u << 0xad6c << "".to_u << 0xc131 << " ".to_u << 0xc624 << "".to_u << 0xb958 << ":\n\t".to_u << 0xc904 << " {0}: ".to_u << 0xc2dc << "".to_u << 0xc2a4 << "".to_u << 0xd15c << " ".to_u << 0xb4f1 << "".to_u << 0xb85d << " ".to_u << 0xc815 << "".to_u << 0xbcf4 << " [{1}]".to_u << 0xc774 << "(".to_u << 0xac00 << ") ".to_u << 0xbe48 << " ".to_u << 0xac12 << "".to_u << 0xc73c << "".to_u << 0xb85c << " ".to_u << 0xd655 << "".to_u << 0xc7a5 << "".to_u << 0xb418 << "".to_u << 0xc5c8 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["username: ", ("".to_u << 0xc0ac << "".to_u << 0xc6a9 << "".to_u << 0xc790 << " ".to_u << 0xc774 << "".to_u << 0xb984 << ": ")]), Array.typed(Object).new(["password: ", ("".to_u << 0xc554 << "".to_u << 0xd638 << ": ")]), Array.typed(Object).new(["Please enter keystore information", ("Keystore ".to_u << 0xc815 << "".to_u << 0xbcf4 << "".to_u << 0xb97c << " ".to_u << 0xc785 << "".to_u << 0xb825 << "".to_u << 0xd558 << "".to_u << 0xc2ed << "".to_u << 0xc2dc << "".to_u << 0xc624 << ".")]), Array.typed(Object).new(["Keystore alias: ", ("Keystore ".to_u << 0xbcc4 << "".to_u << 0xba85 << ": ")]), Array.typed(Object).new(["Keystore password: ", ("Keystore ".to_u << 0xc554 << "".to_u << 0xd638 << ": ")]), Array.typed(Object).new(["Private key password (optional): ", ("".to_u << 0xac1c << "".to_u << 0xc778 << " ".to_u << 0xd0a4 << " ".to_u << 0xc554 << "".to_u << 0xd638 << "(".to_u << 0xc120 << "".to_u << 0xd0dd << " ".to_u << 0xc0ac << "".to_u << 0xd56d << "): ")]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", ("Kerberos ".to_u << 0xc0ac << "".to_u << 0xc6a9 << "".to_u << 0xc790 << " ".to_u << 0xc774 << "".to_u << 0xb984 << " [{0}]: ")]), Array.typed(Object).new(["Kerberos password for [username]: ", ("{0}".to_u << 0xc758 << " Kerberos ".to_u << 0xc554 << "".to_u << 0xd638 << ": ")]), Array.typed(Object).new([": error parsing ", (": ".to_u << 0xad6c << "".to_u << 0xbb38 << " ".to_u << 0xbd84 << "".to_u << 0xc11d << " ".to_u << 0xc624 << "".to_u << 0xb958 << " ")]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", (": ".to_u << 0xc0ac << "".to_u << 0xc6a9 << " ".to_u << 0xad8c << "".to_u << 0xd55c << " ".to_u << 0xcd94 << "".to_u << 0xac00 << " ".to_u << 0xc911 << " ".to_u << 0xc624 << "".to_u << 0xb958 << " ")]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", (": ".to_u << 0xc785 << "".to_u << 0xb825 << " ".to_u << 0xd56d << "".to_u << 0xbaa9 << " ".to_u << 0xcd94 << "".to_u << 0xac00 << " ".to_u << 0xc911 << " ".to_u << 0xc624 << "".to_u << 0xb958 << " ")]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", ("".to_u << 0xc77d << "".to_u << 0xae30 << " ".to_u << 0xc804 << "".to_u << 0xc6a9 << " PermissionCollection".to_u << 0xc5d0 << " ".to_u << 0xc0ac << "".to_u << 0xc6a9 << " ".to_u << 0xad8c << "".to_u << 0xd55c << "".to_u << 0xc744 << " ".to_u << 0xcd94 << "".to_u << 0xac00 << "".to_u << 0xd558 << "".to_u << 0xb824 << "".to_u << 0xace0 << " ".to_u << 0xc2dc << "".to_u << 0xb3c4 << "".to_u << 0xd588 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["expected keystore type", ("Keystore ".to_u << 0xc720 << "".to_u << 0xd615 << "".to_u << 0xc774 << " ".to_u << 0xd544 << "".to_u << 0xc694 << "".to_u << 0xd569 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["can not specify Principal with a ", ("".to_u << 0xc640 << "".to_u << 0xc77c << "".to_u << 0xb4dc << "".to_u << 0xce74 << "".to_u << 0xb4dc << " ".to_u << 0xd074 << "".to_u << 0xb798 << "".to_u << 0xc2a4 << "".to_u << 0xb97c << " ".to_u << 0xc640 << "".to_u << 0xc77c << "".to_u << 0xb4dc << "".to_u << 0xce74 << "".to_u << 0xb4dc << " ".to_u << 0xc774 << "".to_u << 0xb984 << "".to_u << 0xc774 << " ".to_u << 0xc5c6 << "".to_u << 0xc774 << " ")]), Array.typed(Object).new(["wildcard class without a wildcard name", ("".to_u << 0xae30 << "".to_u << 0xbcf8 << "".to_u << 0xac12 << "".to_u << 0xc744 << " ".to_u << 0xc9c0 << "".to_u << 0xc815 << "".to_u << 0xd560 << " ".to_u << 0xc218 << " ".to_u << 0xc5c6 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["expected codeBase or SignedBy", ("codeBase ".to_u << 0xb610 << "".to_u << 0xb294 << " SignedBy".to_u << 0xac00 << " ".to_u << 0xd544 << "".to_u << 0xc694 << "".to_u << 0xd569 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["only Principal-based grant entries permitted", ("".to_u << 0xae30 << "".to_u << 0xbcf8 << "".to_u << 0xac12 << " ".to_u << 0xae30 << "".to_u << 0xbc18 << " ".to_u << 0xbd80 << "".to_u << 0xc5ec << " ".to_u << 0xc785 << "".to_u << 0xb825 << " ".to_u << 0xd56d << "".to_u << 0xbaa9 << "".to_u << 0xb9cc << " ".to_u << 0xd5c8 << "".to_u << 0xc6a9 << "".to_u << 0xb429 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["expected permission entry", ("".to_u << 0xc0ac << "".to_u << 0xc6a9 << " ".to_u << 0xad8c << "".to_u << 0xd55c << " ".to_u << 0xc785 << "".to_u << 0xb825 << " ".to_u << 0xd56d << "".to_u << 0xbaa9 << "".to_u << 0xc774 << " ".to_u << 0xd544 << "".to_u << 0xc694 << "".to_u << 0xd569 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["number ", ("".to_u << 0xc22b << "".to_u << 0xc790 << " ")]), Array.typed(Object).new(["expected ", ("".to_u << 0xd544 << "".to_u << 0xc694 << "".to_u << 0xd569 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ". ")]), Array.typed(Object).new([", read end of file", (", ".to_u << 0xd30c << "".to_u << 0xc77c << "".to_u << 0xc758 << " ".to_u << 0xb05d << "".to_u << 0xc744 << " ".to_u << 0xc77d << "".to_u << 0xc5c8 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["expected ';', read end of file", ("';'".to_u << 0xc774 << " ".to_u << 0xd544 << "".to_u << 0xc694 << "".to_u << 0xd569 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ". ".to_u << 0xd30c << "".to_u << 0xc77c << "".to_u << 0xc758 << " ".to_u << 0xb05d << "".to_u << 0xc744 << " ".to_u << 0xc77d << "".to_u << 0xc5c8 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["line ", ("".to_u << 0xc904 << " ")]), Array.typed(Object).new([": expected '", (":  '".to_u << 0xc774 << " ".to_u << 0xd544 << "".to_u << 0xc694 << "".to_u << 0xd569 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["', found '", ("', '".to_u << 0xc744 << " ".to_u << 0xcc3e << "".to_u << 0xc558 << "".to_u << 0xc2b5 << "".to_u << 0xb2c8 << "".to_u << 0xb2e4 << ".")]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", ("SolarisNumericGroupPrincipal [".to_u << 0xae30 << "".to_u << 0xbcf8 << " ".to_u << 0xadf8 << "".to_u << 0xb8f9 << "]: ")]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", ("SolarisNumericGroupPrincipal [".to_u << 0xbcf4 << "".to_u << 0xc870 << " ".to_u << 0xadf8 << "".to_u << 0xb8f9 << "]: ")]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "SolarisNumericUserPrincipal: "]), Array.typed(Object).new(["SolarisPrincipal: ", "SolarisPrincipal: "]), Array.typed(Object).new(["provided null name", ("".to_u << 0xc81c << "".to_u << 0xacf5 << "".to_u << 0xb41c << " ".to_u << 0xb110 << " ".to_u << 0xc774 << "".to_u << 0xb984 << "")])]) }
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
    alias_method :initialize__auth_resources_ko, :initialize
  end
  
end
