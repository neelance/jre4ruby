require "rjava"

# 
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
  module AuthResources_svImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
    }
  end
  
  # 
  # <p> This class represents the <code>ResourceBundle</code>
  # for the following packages:
  # 
  # <ol>
  # <li> com.sun.security.auth
  # <li> com.sun.security.auth.login
  # </ol>
  class AuthResources_sv < Java::Util::ListResourceBundle
    include_class_members AuthResources_svImports
    
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
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", "ogiltiga null-indata: {0}"]), Array.typed(Object).new(["NTDomainPrincipal: name", "NTDomainPrincipal: {0}"]), Array.typed(Object).new(["NTNumericCredential: name", "NTNumericCredential: {0}"]), Array.typed(Object).new(["Invalid NTSid value", ("Ogiltigt NTSid-v".to_u << 0x00e4 << "rde")]), Array.typed(Object).new(["NTSid: name", "NTSid: {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", "NTSidDomainPrincipal: {0}"]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NTSidGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", "NTSidPrimaryGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NTSidUserPrincipal: {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NTUserPrincipal: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", ("UnixNumericGroupPrincipal [prim".to_u << 0x00e4 << "r grupp]: {0}")]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", ("UnixNumericGroupPrincipal [till".to_u << 0x00e4 << "ggsgrupp]: {0}")]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "UnixNumericUserPrincipal: {0}"]), Array.typed(Object).new(["UnixPrincipal: name", "UnixPrincipal: {0}"]), Array.typed(Object).new(["Unable to properly expand config", ("Det g".to_u << 0x00e5 << "r inte att utvidga korrekt {0}")]), Array.typed(Object).new(["extra_config (No such file or directory)", ("{0} (Det finns ingen s".to_u << 0x00e5 << "dan fil eller katalog.)")]), Array.typed(Object).new(["Unable to locate a login configuration", ("Det g".to_u << 0x00e5 << "r inte att hitta n".to_u << 0x00e5 << "gon inloggningskonfiguration")]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", "Konfigurationsfel:\n\tOgiltig kontrollflagga, {0}"]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", ("Konfigurationsfel:\n\tDet g".to_u << 0x00e5 << "r inte att ange flera poster f".to_u << 0x00f6 << "r {0}")]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", ("Konfigurationsfel:\n\tf".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntade [{0}], l".to_u << 0x00e4 << "ste [end of file]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", ("Konfigurationsfel:\n\tLine {0}: f".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntade [{1}], hittade [{2}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", ("Konfigurationsfel:\n\tLine {0}: f".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntade [{1}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", ("Konfigurationsfel:\n\tLine {0}: systemegenskapen [{1}] utvidgad till tomt v".to_u << 0x00e4 << "rde")]), Array.typed(Object).new(["username: ", ("anv".to_u << 0x00e4 << "ndarnamn: ")]), Array.typed(Object).new(["password: ", ("l".to_u << 0x00f6 << "senord: ")]), Array.typed(Object).new(["Please enter keystore information", "Ange keystore-information"]), Array.typed(Object).new(["Keystore alias: ", "Keystore-alias: "]), Array.typed(Object).new(["Keystore password: ", ("Keystore-l".to_u << 0x00f6 << "senord: ")]), Array.typed(Object).new(["Private key password (optional): ", ("L".to_u << 0x00f6 << "senord f".to_u << 0x00f6 << "r personlig nyckel (valfritt): ")]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", ("Kerberos-anv".to_u << 0x00e4 << "ndarnamn [{0}]: ")]), Array.typed(Object).new(["Kerberos password for [username]: ", ("Kerberos-l".to_u << 0x00f6 << "senord f".to_u << 0x00f6 << "r {0}: ")]), Array.typed(Object).new([": error parsing ", ": analysfel "]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", (": fel vid till".to_u << 0x00e4 << "gg av beh".to_u << 0x00f6 << "righet ")]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", (": fel vid till".to_u << 0x00e4 << "gg av post ")]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", ("f".to_u << 0x00f6 << "rs".to_u << 0x00f6 << "k att l".to_u << 0x00e4 << "gga till beh".to_u << 0x00f6 << "righet till skrivskyddad PermissionCollection")]), Array.typed(Object).new(["expected keystore type", ("f".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntad keystore-typ")]), Array.typed(Object).new(["can not specify Principal with a ", ("det g".to_u << 0x00e5 << "r inte att specificera n".to_u << 0x00e5 << "gon principal med ")]), Array.typed(Object).new(["wildcard class without a wildcard name", ("jokertecken f".to_u << 0x00f6 << "r klass men inte f".to_u << 0x00f6 << "r namn")]), Array.typed(Object).new(["expected codeBase or SignedBy", ("f".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntade codeBase eller SignedBy")]), Array.typed(Object).new(["only Principal-based grant entries permitted", ("enbart Principal-baserade poster till".to_u << 0x00e5 << "tna")]), Array.typed(Object).new(["expected permission entry", ("f".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntade beh".to_u << 0x00f6 << "righetspost")]), Array.typed(Object).new(["number ", "antal "]), Array.typed(Object).new(["expected ", ("f".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntade ")]), Array.typed(Object).new([", read end of file", (", l".to_u << 0x00e4 << "ste filslut")]), Array.typed(Object).new(["expected ';', read end of file", ("f".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntade ';', l".to_u << 0x00e4 << "ste filslut")]), Array.typed(Object).new(["line ", "rad "]), Array.typed(Object).new([": expected '", (": f".to_u << 0x00f6 << "rv".to_u << 0x00e4 << "ntade '")]), Array.typed(Object).new(["', found '", "', hittade '"]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", ("SolarisNumericGroupPrincipal [prim".to_u << 0x00e4 << "r grupp]: ")]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", ("SolarisNumericGroupPrincipal [till".to_u << 0x00e4 << "ggsgrupp]: ")]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "SolarisNumericUserPrincipal: "]), Array.typed(Object).new(["SolarisPrincipal: ", "SolarisPrincipal: "]), Array.typed(Object).new(["provided null name", "gav null-namn"])]) }
      const_attr_reader  :Contents
    }
    
    typesig { [] }
    # 
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
    alias_method :initialize__auth_resources_sv, :initialize
  end
  
end
