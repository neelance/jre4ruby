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
  module AuthResources_deImports #:nodoc:
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
  class AuthResources_de < Java::Util::ListResourceBundle
    include_class_members AuthResources_deImports
    
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
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", ("Ung".to_u << 0x00fc << "ltige Nulleingabe: {0}")]), Array.typed(Object).new(["NTDomainPrincipal: name", ("NT-Dom".to_u << 0x00e4 << "nen-Principal: {0}")]), Array.typed(Object).new(["NTNumericCredential: name", "NT numerische Authentisierung: {0}"]), Array.typed(Object).new(["Invalid NTSid value", ("Ung".to_u << 0x00fc << "ltiger NTSid-Wert")]), Array.typed(Object).new(["NTSid: name", "NTSid: {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", ("NT-Sid-Dom".to_u << 0x00e4 << "nen-Principal: {0}")]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NT-Sid-Gruppen-Principal: {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", ("NT-Sid-Prim".to_u << 0x00e4 << "rgruppen-Principal: {0}")]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NT-Sid-Benutzer-Principal: {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NT-Benutzer-Principal: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", ("Unix numerischer Gruppen-Principal [Prim".to_u << 0x00e4 << "rgruppe]: {0}")]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", "Unix numerische Gruppen-Principal [Zusatzgruppe]: {0}"]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "Unix numerischer Benutzer-Principal: {0}"]), Array.typed(Object).new(["UnixPrincipal: name", "Unix-Principal: {0}"]), Array.typed(Object).new(["Unable to properly expand config", ("{0} kann nicht ordnungsgem".to_u << 0x00e4 << "".to_u << 0x00df << " erweitert werden.")]), Array.typed(Object).new(["extra_config (No such file or directory)", "{0} (Datei oder Verzeichnis existiert nicht.)"]), Array.typed(Object).new(["Unable to locate a login configuration", "Anmeldekonfiguration kann nicht gefunden werden."]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", ("Konfigurationsfehler:\n\tUng".to_u << 0x00fc << "ltiges Steuerflag, {0}")]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", ("Konfigurationsfehler:\n\tEs k".to_u << 0x00f6 << "nnen nicht mehrere Angaben f".to_u << 0x00fc << "r {0} gemacht werden.")]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", "Konfigurationsfehler:\n\terwartet [{0}], gelesen [Dateiende]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", "Konfigurationsfehler:\n\tZeile {0}: erwartet [{1}], gefunden [{2}]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", "Konfigurationsfehler:\n\tZeile {0}: erwartet [{1}]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", "Konfigurationsfehler:\n\tZeile {0}: Systemeigenschaft [{1}] auf leeren Wert erweitert"]), Array.typed(Object).new(["username: ", "Benutzername: "]), Array.typed(Object).new(["password: ", "Passwort: "]), Array.typed(Object).new(["Please enter keystore information", "Bitte geben Sie die Keystore-Informationen ein"]), Array.typed(Object).new(["Keystore alias: ", "Keystore-Alias: "]), Array.typed(Object).new(["Keystore password: ", "Keystore-Passwort: "]), Array.typed(Object).new(["Private key password (optional): ", ("Privates Schl".to_u << 0x00fc << "sselpasswort (optional): ")]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", "Kerberos-Benutzername [{0}]: "]), Array.typed(Object).new(["Kerberos password for [username]: ", ("Kerberos-Passwort f".to_u << 0x00fc << "r {0}: ")]), Array.typed(Object).new([": error parsing ", ": Parser-Fehler "]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", (": Fehler beim Hinzuf".to_u << 0x00fc << "gen der Berechtigung ")]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", (": Fehler beim Hinzuf".to_u << 0x00fc << "gen des Eintrags ")]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", ("Es wurde versucht, eine Berechtigung zu einer schreibgesch".to_u << 0x00fc << "tzten Berechtigungssammlung hinzuzuf".to_u << 0x00fc << "gen.")]), Array.typed(Object).new(["expected keystore type", "erwarteter Keystore-Typ"]), Array.typed(Object).new(["can not specify Principal with a ", "Principal kann nicht mit einer "]), Array.typed(Object).new(["wildcard class without a wildcard name", "Wildcard-Klasse ohne Wildcard-Namen angegeben werden."]), Array.typed(Object).new(["expected codeBase or SignedBy", "codeBase oder SignedBy erwartet"]), Array.typed(Object).new(["only Principal-based grant entries permitted", ("Nur Principal-basierte Berechtigungseintr".to_u << 0x00e4 << "ge erlaubt")]), Array.typed(Object).new(["expected permission entry", "Berechtigungseintrag erwartet"]), Array.typed(Object).new(["number ", "Nummer "]), Array.typed(Object).new(["expected ", "erwartet "]), Array.typed(Object).new([", read end of file", ", Dateiende lesen"]), Array.typed(Object).new(["expected ';', read end of file", "';' erwartet, Dateiende lesen"]), Array.typed(Object).new(["line ", "Zeile "]), Array.typed(Object).new([": expected '", ": erwartet '"]), Array.typed(Object).new(["', found '", "', gefunden '"]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", ("Solaris numerischer Gruppen-Principal [Prim".to_u << 0x00e4 << "rgruppe]: ")]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", "Solaris numerischer Gruppen-Principal [Zusatzgruppe]: "]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "Solaris numerischer Benutzer-Principal: "]), Array.typed(Object).new(["SolarisPrincipal: ", "Solaris-Principal: "]), Array.typed(Object).new(["provided null name", "enthielt leeren Namen"])]) }
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
    alias_method :initialize__auth_resources_de, :initialize
  end
  
end
