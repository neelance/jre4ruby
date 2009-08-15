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
  module AuthResources_itImports
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
  class AuthResources_it < Java::Util::ListResourceBundle
    include_class_members AuthResources_itImports
    
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
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", "input nullo non valido: {0}"]), Array.typed(Object).new(["NTDomainPrincipal: name", "NTDomainPrincipal: {0}"]), Array.typed(Object).new(["NTNumericCredential: name", "NTNumericCredential: {0}"]), Array.typed(Object).new(["Invalid NTSid value", "Valore NTSid non valido"]), Array.typed(Object).new(["NTSid: name", "NTSid: {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", "NTSidDomainPrincipal: {0}"]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NTSidGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", "NTSidPrimaryGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NTSidUserPrincipal: {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NTUserPrincipal: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", "UnixNumericGroupPrincipal [gruppo primario]: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", "UnixNumericGroupPrincipal [gruppo supplementare]: {0}"]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "UnixNumericUserPrincipal: {0}"]), Array.typed(Object).new(["UnixPrincipal: name", "UnixPrincipal: {0}"]), Array.typed(Object).new(["Unable to properly expand config", "Impossibile espandere correttamente {0}"]), Array.typed(Object).new(["extra_config (No such file or directory)", "{0} (file o directory inesistente)"]), Array.typed(Object).new(["Unable to locate a login configuration", "Impossibile trovare una configurazione di login"]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", "Errore di configurazione:\n\tflag di controllo non valido, {0}"]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", ("Errore di configurazione:\n\timpossibile specificare pi".to_u << 0x00f9 << " valori per {0}")]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", "Errore di configurazione:\n\tprevisto [{0}], letto [end of file]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", "Errore di configurazione:\n\triga {0}: previsto [{1}], trovato [{2}]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", "Errore di configurazione:\n\triga {0}: previsto [{1}]"]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", ("Errore di configurazione:\n\triga {0}: propriet".to_u << 0x00e0 << " di sistema [{1}] espansa a valore vuoto")]), Array.typed(Object).new(["username: ", "Nome utente: "]), Array.typed(Object).new(["password: ", "Password: "]), Array.typed(Object).new(["Please enter keystore information", "Inserire le informazioni per il keystore"]), Array.typed(Object).new(["Keystore alias: ", "Alias keystore: "]), Array.typed(Object).new(["Keystore password: ", "Password keystore: "]), Array.typed(Object).new(["Private key password (optional): ", "Password chiave privata (opzionale): "]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", "Nome utente Kerberos [{0}]: "]), Array.typed(Object).new(["Kerberos password for [username]: ", "Password Kerberos per {0}: "]), Array.typed(Object).new([": error parsing ", ": errore nell'analisi "]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", ": errore nell'aggiunta del permesso "]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", ": errore nell'aggiunta dell'entry "]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", "tentativo di aggiungere un permesso a una PermissionCollection di sola lettura"]), Array.typed(Object).new(["expected keystore type", "tipo di keystore previsto"]), Array.typed(Object).new(["can not specify Principal with a ", "impossibile specificare Principal con una "]), Array.typed(Object).new(["wildcard class without a wildcard name", "classe wildcard senza un nome wildcard"]), Array.typed(Object).new(["expected codeBase or SignedBy", "previsto codeBase o SignedBy"]), Array.typed(Object).new(["only Principal-based grant entries permitted", "sono permessi solo valori garantiti basati su Principal"]), Array.typed(Object).new(["expected permission entry", "prevista entry di permesso"]), Array.typed(Object).new(["number ", "numero "]), Array.typed(Object).new(["expected ", "previsto "]), Array.typed(Object).new([", read end of file", ", letto end of file"]), Array.typed(Object).new(["expected ';', read end of file", "previsto ';', letto end of file"]), Array.typed(Object).new(["line ", "riga "]), Array.typed(Object).new([": expected '", ": previsto '"]), Array.typed(Object).new(["', found '", "', trovato '"]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", "SolarisNumericGroupPrincipal [gruppo primario]: "]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", "SolarisNumericGroupPrincipal [gruppo supplementare]: "]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "SolarisNumericUserPrincipal: "]), Array.typed(Object).new(["SolarisPrincipal: ", "SolarisPrincipal: "]), Array.typed(Object).new(["provided null name", ("il nome fornito ".to_u << 0x00e8 << " nullo")])]) }
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
    alias_method :initialize__auth_resources_it, :initialize
  end
  
end
