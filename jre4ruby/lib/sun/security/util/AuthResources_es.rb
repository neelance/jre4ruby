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
  module AuthResources_esImports
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
  class AuthResources_es < Java::Util::ListResourceBundle
    include_class_members AuthResources_esImports
    
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
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["invalid null input: value", ("entrada nula no v".to_u << 0x00e1 << "lida: {0}")]), Array.typed(Object).new(["NTDomainPrincipal: name", "NTDomainPrincipal: {0}"]), Array.typed(Object).new(["NTNumericCredential: name", "NTNumericCredential: {0}"]), Array.typed(Object).new(["Invalid NTSid value", ("Valor de NTSid no v".to_u << 0x00e1 << "lido")]), Array.typed(Object).new(["NTSid: name", "NTSid: {0}"]), Array.typed(Object).new(["NTSidDomainPrincipal: name", "NTSidDomainPrincipal: {0}"]), Array.typed(Object).new(["NTSidGroupPrincipal: name", "NTSidGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidPrimaryGroupPrincipal: name", "NTSidPrimaryGroupPrincipal: {0}"]), Array.typed(Object).new(["NTSidUserPrincipal: name", "NTSidUserPrincipal: {0}"]), Array.typed(Object).new(["NTUserPrincipal: name", "NTUserPrincipal: {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Primary Group]: name", "UnixNumericGroupPrincipal [Grupo principal] {0}"]), Array.typed(Object).new(["UnixNumericGroupPrincipal [Supplementary Group]: name", "UnixNumericGroupPrincipal [Grupo adicional] {0}"]), Array.typed(Object).new(["UnixNumericUserPrincipal: name", "UnixNumericUserPrincipal: {0}"]), Array.typed(Object).new(["UnixPrincipal: name", "UnixPrincipal: {0}"]), Array.typed(Object).new(["Unable to properly expand config", "No se puede ampliar correctamente {0}"]), Array.typed(Object).new(["extra_config (No such file or directory)", "{0} (No existe tal archivo o directorio)"]), Array.typed(Object).new(["Unable to locate a login configuration", ("No se puede localizar una configuraci".to_u << 0x00f3 << "n de inicio de sesi".to_u << 0x00f3 << "n")]), Array.typed(Object).new(["Configuration Error:\n\tInvalid control flag, flag", ("Error de configuraci".to_u << 0x00f3 << "n:\n\tIndicador de control no v".to_u << 0x00e1 << "lido, {0}")]), Array.typed(Object).new(["Configuration Error:\n\tCan not specify multiple entries for appName", ("Error de configuraci".to_u << 0x00f3 << "n:\n\tNo se pueden especificar m".to_u << 0x00fa << "ltiples entradas para {0}")]), Array.typed(Object).new(["Configuration Error:\n\texpected [expect], read [end of file]", ("Error de configuraci".to_u << 0x00f3 << "n:\n\tse esperaba [{0}], se ha le".to_u << 0x00ed << "do [end of file]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect], found [value]", ("Error de configuraci".to_u << 0x00f3 << "n:\n\tL".to_u << 0x00ed << "nea {0}: se esperaba [{1}], se ha encontrado [{2}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: expected [expect]", ("Error de configuraci".to_u << 0x00f3 << "n:\n\tL".to_u << 0x00ed << "nea {0}: se esperaba [{1}]")]), Array.typed(Object).new(["Configuration Error:\n\tLine line: system property [value] expanded to empty value", ("Error de configuraci".to_u << 0x00f3 << "n:\n\tL".to_u << 0x00ed << "nea {0}: propiedad de sistema [{1}] ampliada a valor vac".to_u << 0x00ed << "o")]), Array.typed(Object).new(["username: ", "nombre de usuario: "]), Array.typed(Object).new(["password: ", ("contrase".to_u << 0x00f1 << "a: ")]), Array.typed(Object).new(["Please enter keystore information", ("Introduzca la informaci".to_u << 0x00f3 << "n del almac".to_u << 0x00e9 << "n de claves")]), Array.typed(Object).new(["Keystore alias: ", ("Alias de almac".to_u << 0x00e9 << "n de claves: ")]), Array.typed(Object).new(["Keystore password: ", ("Contrase".to_u << 0x00f1 << "a de almac".to_u << 0x00e9 << "n de claves: ")]), Array.typed(Object).new(["Private key password (optional): ", ("Contrase".to_u << 0x00f1 << "a de clave privada (opcional): ")]), Array.typed(Object).new(["Kerberos username [[defUsername]]: ", "Nombre de usuario de Kerberos [{0}]: "]), Array.typed(Object).new(["Kerberos password for [username]: ", ("Contrase".to_u << 0x00f1 << "a de Kerberos de {0}: ")]), Array.typed(Object).new([": error parsing ", (": error de an".to_u << 0x00e1 << "lisis ")]), Array.typed(Object).new([": ", ": "]), Array.typed(Object).new([": error adding Permission ", ": error al agregar Permiso "]), Array.typed(Object).new([" ", " "]), Array.typed(Object).new([": error adding Entry ", ": error al agregar Entrada "]), Array.typed(Object).new(["(", "("]), Array.typed(Object).new([")", ")"]), Array.typed(Object).new(["attempt to add a Permission to a readonly PermissionCollection", ("se ha intentado agregar un Permiso a una Colecci".to_u << 0x00f3 << "n de permisos de s".to_u << 0x00f3 << "lo lectura")]), Array.typed(Object).new(["expected keystore type", ("se esperaba un tipo de almac".to_u << 0x00e9 << "n de claves")]), Array.typed(Object).new(["can not specify Principal with a ", "no se puede especificar Principal con una "]), Array.typed(Object).new(["wildcard class without a wildcard name", ("clase comod".to_u << 0x00ed << "n sin nombre de comod".to_u << 0x00ed << "n")]), Array.typed(Object).new(["expected codeBase or SignedBy", ("se esperaba base de c".to_u << 0x00f3 << "digos o SignedBy")]), Array.typed(Object).new(["only Principal-based grant entries permitted", ("s".to_u << 0x00f3 << "lo se permite conceder entradas basadas en Principal")]), Array.typed(Object).new(["expected permission entry", "se esperaba un permiso de entrada"]), Array.typed(Object).new(["number ", ("n".to_u << 0x00fa << "mero ")]), Array.typed(Object).new(["expected ", "se esperaba "]), Array.typed(Object).new([", read end of file", (", se ha le".to_u << 0x00ed << "do final de archivo")]), Array.typed(Object).new(["expected ';', read end of file", ("se esperaba ';', se ha le".to_u << 0x00ed << "do final de archivo")]), Array.typed(Object).new(["line ", ("l".to_u << 0x00ed << "nea ")]), Array.typed(Object).new([": expected '", ": se esperaba '"]), Array.typed(Object).new(["', found '", "', se ha encontrado '"]), Array.typed(Object).new(["'", "'"]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Primary Group]: ", "SolarisNumericGroupPrincipal [Grupo principal]: "]), Array.typed(Object).new(["SolarisNumericGroupPrincipal [Supplementary Group]: ", "SolarisNumericGroupPrincipal [Grupo adicional]: "]), Array.typed(Object).new(["SolarisNumericUserPrincipal: ", "SolarisNumericUserPrincipal: "]), Array.typed(Object).new(["SolarisPrincipal: ", "SolarisPrincipal: "]), Array.typed(Object).new(["provided null name", "se ha proporcionado un nombre nulo"])]) }
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
    alias_method :initialize__auth_resources_es, :initialize
  end
  
end
