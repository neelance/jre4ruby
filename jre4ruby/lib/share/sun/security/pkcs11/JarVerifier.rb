require "rjava"

# Copyright 2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module JarVerifierImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Io
      include ::Java::Util
      include ::Java::Util::Jar
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :JarURLConnection
      include_const ::Java::Net, :MalformedURLException
      include ::Java::Security
      include ::Java::Security::Cert
      include_const ::Java::Security::Cert, :Certificate
    }
  end
  
  # NOTE: this class is duplicated amongst SunJCE, SunPKCS11, and SunMSCAPI.
  # All files should be kept in sync.
  # 
  # This class verifies JAR files (and any supporting JAR files), and
  # determines whether they may be used in this implementation.
  # 
  # The JCE in OpenJDK has an open cryptographic interface, meaning it
  # does not restrict which providers can be used.  Compliance with
  # United States export controls and with local law governing the
  # import/export of products incorporating the JCE in the OpenJDK is
  # the responsibility of the licensee.
  # 
  # @since 1.7
  class JarVerifier 
    include_class_members JarVerifierImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
      
      typesig { [Class] }
      # Verify the JAR file is signed by an entity which has a certificate
      # issued by a trusted CA.
      # 
      # Note: this is a temporary method and will change soon to use the
      # exception chaining mechanism, which can provide more details
      # as to why the verification failed.
      # 
      # @param c the class to be verified.
      # @return true if verification is successful.
      def verify(c)
        return true
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__jar_verifier, :initialize
  end
  
end
