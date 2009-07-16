require "rjava"

# 
# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Validator
  module KeyStoresImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Validator
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
      include ::Java::Security::Cert
      include_const ::Java::Security::Cert, :Certificate
      include ::Sun::Security::Action
    }
  end
  
  # 
  # Collection of static utility methods related to KeyStores.
  # 
  # @author Andreas Sterbenz
  class KeyStores 
    include_class_members KeyStoresImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      typesig { [KeyStore] }
      # in the future, all accesses to the system cacerts keystore should
      # go through this class. but not right now.
      # 
      # private final static String javaHome =
      # (String)AccessController.doPrivileged(new GetPropertyAction("java.home"));
      # 
      # private final static char SEP = File.separatorChar;
      # 
      # private static KeyStore caCerts;
      # 
      # private static KeyStore getKeyStore(String type, String name,
      # char[] password) throws IOException {
      # if (type == null) {
      # type = "JKS";
      # }
      # try {
      # KeyStore ks = KeyStore.getInstance(type);
      # FileInputStream in = (FileInputStream)AccessController.doPrivileged
      # (new OpenFileInputStreamAction(name));
      # ks.load(in, password);
      # return ks;
      # } catch (GeneralSecurityException e) {
      # // XXX
      # throw new IOException();
      # } catch (PrivilegedActionException e) {
      # throw (IOException)e.getCause();
      # }
      # }
      # 
      # 
      # Return a KeyStore with the contents of the lib/security/cacerts file.
      # The file is only opened once per JVM invocation and the contents
      # cached subsequently.
      # 
      # public synchronized static KeyStore getCaCerts() throws IOException {
      # if (caCerts != null) {
      # return caCerts;
      # }
      # String name = javaHome + SEP + "lib" + SEP + "security" + SEP + "cacerts";
      # caCerts = getKeyStore(null, name, null);
      # return caCerts;
      # }
      # 
      # 
      # Return a Set with all trusted X509Certificates contained in
      # this KeyStore.
      def get_trusted_certs(ks)
        set = HashSet.new
        begin
          e = ks.aliases
          while e.has_more_elements
            alias_ = e.next_element
            if (ks.is_certificate_entry(alias_))
              cert = ks.get_certificate(alias_)
              if (cert.is_a?(X509Certificate))
                set.add(cert)
              end
            else
              if (ks.is_key_entry(alias_))
                certs = ks.get_certificate_chain(alias_)
                if ((!(certs).nil?) && (certs.attr_length > 0) && (certs[0].is_a?(X509Certificate)))
                  set.add(certs[0])
                end
              end
            end
          end
        rescue KeyStoreException => e
          # ignore
        end
        return set
      end
    }
    
    private
    alias_method :initialize__key_stores, :initialize
  end
  
end
