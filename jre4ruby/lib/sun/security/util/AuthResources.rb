require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AuthResourcesImports
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
  class AuthResources < Java::Util::ListResourceBundle
    include_class_members AuthResourcesImports
    
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
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", "invalid null input: {0}"]), Array.typed(Object).new(["NTDomainPrincipal: name", "NTDomainPrincipal: {0}"]), Array.typed(Object).new(["NTNumericCredential: name", "NTNumericCredential: {0}"]), Array.typed(Object).new(["Invalid NTSid value", "Invalid NTSid value"]), Array.typed(Object).new(["NTSid: name", "NTSid: {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", "NTSidDomainPrincipal: {0}"]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NTSidGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", "NTSidPrimaryGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NTSidUserPrincipal: {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NTUserPrincipal: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", "UnixNumericGroupPrincipal [Primary Group]: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", "UnixNumericGroupPrincipal [Supplementary Group]: {0}"]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "UnixNumericUserPrincipal: {0}"]), Array.typed(Object).new(["UnixPrincipal: name", "UnixPrincipal: {0}"]), Array.typed(Object).new(["Unable to properly expand config", "Unable to properly expand {0}"]), Array.typed(Object).new(["extra_config (No such file or directory)", "{0} (No such file or directory)"]), Array.typed(Object).new(["Configuration Error:\n\tNo such file or directory", "Configuration Error:\n\tNo such file or directory"]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", "Configuration Error:\n\tInvalid control flag, {0}"]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", "Configuration Error:\n\tCan not specify multiple entries for {0}"]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", "Configuration Error:\n\texpected [{0}], read [end of file]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", "Configuration Error:\n\tLine {0}: expected [{1}], found [{2}]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", "Configuration Error:\n\tLine {0}: expected [{1}]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", "Configuration Error:\n\tLine {0}: system property [{1}] expanded to empty value"]), Array.typed(Object).new(["username: ", "username: "]), Array.typed(Object).new(["password: ", "password: "]), Array.typed(Object).new(["Please enter keystore information", "Please enter keystore information"]), Array.typed(Object).new(["Keystore alias: ", "Keystore alias: "]), Array.typed(Object).new(["Keystore password: ", "Keystore password: "]), Array.typed(Object).new(["Private key password (optional): ", "Private key password (optional): "]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", "Kerberos username [{0}]: "]), Array.typed(Object).new(["Kerberos password for [username]: ", "Kerberos password for {0}: "]), Array.typed(Object).new([": error parsing ", ": error parsing "]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", ": error adding Permission "]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", ": error adding Entry "]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", "attempt to add a Permission to a readonly PermissionCollection"]), Array.typed(Object).new(["expected keystore type", "expected keystore type"]), Array.typed(Object).new(["can not specify Principal with a ", "can not specify Principal with a "]), Array.typed(Object).new(["wildcard class without a wildcard name", "wildcard class without a wildcard name"]), Array.typed(Object).new(["expected codeBase or SignedBy", "expected codeBase or SignedBy"]), Array.typed(Object).new(["only Principal-based grant entries permitted", "only Principal-based grant entries permitted"]), Array.typed(Object).new(["expected permission entry", "expected permission entry"]), Array.typed(Object).new(["number ", "number "]), Array.typed(Object).new(["expected ", "expected "]), Array.typed(Object).new([", read end of file", ", read end of file"]), Array.typed(Object).new(["expected ';', read end of file", "expected ';', read end of file"]), Array.typed(Object).new(["line ", "line "]), Array.typed(Object).new([": expected '", ": expected '"]), Array.typed(Object).new(["', found '", "', found '"]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", "SolarisNumericGroupPrincipal [Primary Group]: "]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", "SolarisNumericGroupPrincipal [Supplementary Group]: "]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "SolarisNumericUserPrincipal: "]), Array.typed(Object).new(["SolarisPrincipal: ", "SolarisPrincipal: "]), Array.typed(Object).new(["provided null name", "provided null name"])]) }
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
    alias_method :initialize__auth_resources, :initialize
  end
  
end
