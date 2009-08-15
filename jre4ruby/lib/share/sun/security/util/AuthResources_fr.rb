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
  module AuthResources_frImports
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
  class AuthResources_fr < Java::Util::ListResourceBundle
    include_class_members AuthResources_frImports
    
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
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", ("entr".to_u << 0x00e9 << "e Null non valide {0}")]), Array.typed(Object).new(["NTDomainPrincipal: name", "NTDomainPrincipal : {0}"]), Array.typed(Object).new(["NTNumericCredential: name", "NTNumericCredential : {0}"]), Array.typed(Object).new(["Invalid NTSid value", "Valeur de NTSid non valide"]), Array.typed(Object).new(["NTSid: name", "NTSid : {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", "NTSidDomainPrincipal : {0}"]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NTSidGroupPrincipal : {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", "NTSidPrimaryGroupPrincipal : {0}"]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NTSidUserPrincipal : {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NTUserPrincipal : {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", "UnixNumericGroupPrincipal [groupe principal] : {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", ("UnixNumericGroupPrincipal [groupe suppl".to_u << 0x00e9 << "mentaire] : {0}")]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "UnixNumericUserPrincipal : {0}"]), Array.typed(Object).new(["UnixPrincipal: name", "UnixPrincipal : {0}"]), Array.typed(Object).new(["Unable to properly expand config", ("Impossible de d".to_u << 0x00e9 << "velopper {0} correctement")]), Array.typed(Object).new(["extra_config (No such file or directory)", ("{0} (fichier ou r".to_u << 0x00e9 << "pertoire introuvable)")]), Array.typed(Object).new(["Unable to locate a login configuration", "Impossible de trouver une configuration de connexion"]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", ("Erreur de configuration :\n\tIndicateur de contr".to_u << 0x00f4 << "le non valide, {0}")]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", ("Erreur de configuration :\n\tImpossible de sp".to_u << 0x00e9 << "cifier des entr".to_u << 0x00e9 << "es multiples pour {0}")]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", "Erreur de configuration :\n\tattendu [{0}], lecture [fin de fichier]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", ("Erreur de configuration :\n\tLigne {0} : attendu [{1}], trouv".to_u << 0x00e9 << " [{2}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", "Erreur de configuration :\n\tLigne {0} : attendu [{1}]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", ("Erreur de configuration :\n\tLigne {0} : propri".to_u << 0x00e9 << "t".to_u << 0x00e9 << " syst".to_u << 0x00e8 << "me [{1}] d".to_u << 0x00e9 << "velopp".to_u << 0x00e9 << "e en valeur vide")]), Array.typed(Object).new(["username: ", "Nom d'utilisateur : "]), Array.typed(Object).new(["password: ", "Mot de passe : "]), Array.typed(Object).new(["Please enter keystore information", ("Veuillez entrer les informations relatives ".to_u << 0x00e0 << " Keystore")]), Array.typed(Object).new(["Keystore alias: ", "Alias pour Keystore : "]), Array.typed(Object).new(["Keystore password: ", "Mot de passe pour Keystore : "]), Array.typed(Object).new(["Private key password (optional): ", ("Mot de passe de cl".to_u << 0x00e9 << " priv".to_u << 0x00e9 << "e (facultatif) : ")]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", "Nom d''utilisateur Kerberos [{0}] : "]), Array.typed(Object).new(["Kerberos password for [username]: ", ("Mot de pass".to_u << 0x00e9 << " Kerberos pour {0} : ")]), Array.typed(Object).new([": error parsing ", " : erreur d'analyse "]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", " : erreur d'ajout de permission "]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", (" : erreur d'ajout d'entr".to_u << 0x00e9 << "e ")]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", ("tentative d'ajout de permission ".to_u << 0x00e0 << " un ensemble de permissions en lecture seule")]), Array.typed(Object).new(["expected keystore type", "type de Keystore attendu"]), Array.typed(Object).new(["can not specify Principal with a ", ("impossible de sp".to_u << 0x00e9 << "cifier Principal avec une")]), Array.typed(Object).new(["wildcard class without a wildcard name", ("classe g".to_u << 0x00e9 << "n".to_u << 0x00e9 << "rique sans nom g".to_u << 0x00e9 << "n".to_u << 0x00e9 << "rique")]), Array.typed(Object).new(["expected codeBase or SignedBy", "codeBase ou SignedBy attendu"]), Array.typed(Object).new(["only Principal-based grant entries permitted", ("seules les entr".to_u << 0x00e9 << "es bas".to_u << 0x00e9 << "es sur Principal sont autoris".to_u << 0x00e9 << "es")]), Array.typed(Object).new(["expected permission entry", ("entr".to_u << 0x00e9 << "e de permission attendue")]), Array.typed(Object).new(["number ", "nombre "]), Array.typed(Object).new(["expected ", "attendu "]), Array.typed(Object).new([", read end of file", ", lecture de fin de fichier"]), Array.typed(Object).new(["expected ';', read end of file", "attendu ';', lecture de fin de fichier"]), Array.typed(Object).new(["line ", "ligne "]), Array.typed(Object).new([": expected '", " : attendu '"]), Array.typed(Object).new(["', found '", ("', trouv".to_u << 0x00e9 << " '")]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", "SolarisNumericGroupPrincipal [groupe principal] : "]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", ("SolarisNumericGroupPrincipal [groupe suppl".to_u << 0x00e9 << "mentaire] : ")]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "SolarisNumericUserPrincipal : "]), Array.typed(Object).new(["SolarisPrincipal: ", "SolarisPrincipal : "]), Array.typed(Object).new(["provided null name", ("nom Null sp".to_u << 0x00e9 << "cifi".to_u << 0x00e9 << "")])]) }
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
    alias_method :initialize__auth_resources_fr, :initialize
  end
  
end
