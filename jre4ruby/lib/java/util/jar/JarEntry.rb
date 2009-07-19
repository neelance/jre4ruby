require "rjava"

# Copyright 1997-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Jar
  module JarEntryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Jar
      include_const ::Java::Io, :IOException
      include_const ::Java::Util::Zip, :ZipEntry
      include_const ::Java::Security, :CodeSigner
      include_const ::Java::Security::Cert, :Certificate
    }
  end
  
  # This class is used to represent a JAR file entry.
  class JarEntry < JarEntryImports.const_get :ZipEntry
    include_class_members JarEntryImports
    
    attr_accessor :attr
    alias_method :attr_attr, :attr
    undef_method :attr
    alias_method :attr_attr=, :attr=
    undef_method :attr=
    
    attr_accessor :certs
    alias_method :attr_certs, :certs
    undef_method :certs
    alias_method :attr_certs=, :certs=
    undef_method :certs=
    
    attr_accessor :signers
    alias_method :attr_signers, :signers
    undef_method :signers
    alias_method :attr_signers=, :signers=
    undef_method :signers=
    
    typesig { [String] }
    # Creates a new <code>JarEntry</code> for the specified JAR file
    # entry name.
    # 
    # @param name the JAR file entry name
    # @exception NullPointerException if the entry name is <code>null</code>
    # @exception IllegalArgumentException if the entry name is longer than
    # 0xFFFF bytes.
    def initialize(name)
      @attr = nil
      @certs = nil
      @signers = nil
      super(name)
    end
    
    typesig { [ZipEntry] }
    # Creates a new <code>JarEntry</code> with fields taken from the
    # specified <code>ZipEntry</code> object.
    # @param ze the <code>ZipEntry</code> object to create the
    # <code>JarEntry</code> from
    def initialize(ze)
      @attr = nil
      @certs = nil
      @signers = nil
      super(ze)
    end
    
    typesig { [JarEntry] }
    # Creates a new <code>JarEntry</code> with fields taken from the
    # specified <code>JarEntry</code> object.
    # 
    # @param je the <code>JarEntry</code> to copy
    def initialize(je)
      initialize__jar_entry(je)
      @attr = je.attr_attr
      @certs = je.attr_certs
      @signers = je.attr_signers
    end
    
    typesig { [] }
    # Returns the <code>Manifest</code> <code>Attributes</code> for this
    # entry, or <code>null</code> if none.
    # 
    # @return the <code>Manifest</code> <code>Attributes</code> for this
    # entry, or <code>null</code> if none
    def get_attributes
      return @attr
    end
    
    typesig { [] }
    # Returns the <code>Certificate</code> objects for this entry, or
    # <code>null</code> if none. This method can only be called once
    # the <code>JarEntry</code> has been completely verified by reading
    # from the entry input stream until the end of the stream has been
    # reached. Otherwise, this method will return <code>null</code>.
    # 
    # <p>The returned certificate array comprises all the signer certificates
    # that were used to verify this entry. Each signer certificate is
    # followed by its supporting certificate chain (which may be empty).
    # Each signer certificate and its supporting certificate chain are ordered
    # bottom-to-top (i.e., with the signer certificate first and the (root)
    # certificate authority last).
    # 
    # @return the <code>Certificate</code> objects for this entry, or
    # <code>null</code> if none.
    def get_certificates
      return (@certs).nil? ? nil : @certs.clone
    end
    
    typesig { [] }
    # Returns the <code>CodeSigner</code> objects for this entry, or
    # <code>null</code> if none. This method can only be called once
    # the <code>JarEntry</code> has been completely verified by reading
    # from the entry input stream until the end of the stream has been
    # reached. Otherwise, this method will return <code>null</code>.
    # 
    # <p>The returned array comprises all the code signers that have signed
    # this entry.
    # 
    # @return the <code>CodeSigner</code> objects for this entry, or
    # <code>null</code> if none.
    # 
    # @since 1.5
    def get_code_signers
      return (@signers).nil? ? nil : @signers.clone
    end
    
    private
    alias_method :initialize__jar_entry, :initialize
  end
  
end
