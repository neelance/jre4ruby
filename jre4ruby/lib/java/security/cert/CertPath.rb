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
module Java::Security::Cert
  module CertPathImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security::Cert
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :NotSerializableException
      include_const ::Java::Io, :ObjectStreamException
      include_const ::Java::Io, :Serializable
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
    }
  end
  
  # An immutable sequence of certificates (a certification path).
  # <p>
  # This is an abstract class that defines the methods common to all
  # <code>CertPath</code>s. Subclasses can handle different kinds of
  # certificates (X.509, PGP, etc.).
  # <p>
  # All <code>CertPath</code> objects have a type, a list of
  # <code>Certificate</code>s, and one or more supported encodings. Because the
  # <code>CertPath</code> class is immutable, a <code>CertPath</code> cannot
  # change in any externally visible way after being constructed. This
  # stipulation applies to all public fields and methods of this class and any
  # added or overridden by subclasses.
  # <p>
  # The type is a <code>String</code> that identifies the type of
  # <code>Certificate</code>s in the certification path. For each
  # certificate <code>cert</code> in a certification path <code>certPath</code>,
  # <code>cert.getType().equals(certPath.getType())</code> must be
  # <code>true</code>.
  # <p>
  # The list of <code>Certificate</code>s is an ordered <code>List</code> of
  # zero or more <code>Certificate</code>s. This <code>List</code> and all
  # of the <code>Certificate</code>s contained in it must be immutable.
  # <p>
  # Each <code>CertPath</code> object must support one or more encodings
  # so that the object can be translated into a byte array for storage or
  # transmission to other parties. Preferably, these encodings should be
  # well-documented standards (such as PKCS#7). One of the encodings supported
  # by a <code>CertPath</code> is considered the default encoding. This
  # encoding is used if no encoding is explicitly requested (for the
  # {@link #getEncoded() getEncoded()} method, for instance).
  # <p>
  # All <code>CertPath</code> objects are also <code>Serializable</code>.
  # <code>CertPath</code> objects are resolved into an alternate
  # {@link CertPathRep CertPathRep} object during serialization. This allows
  # a <code>CertPath</code> object to be serialized into an equivalent
  # representation regardless of its underlying implementation.
  # <p>
  # <code>CertPath</code> objects can be created with a
  # <code>CertificateFactory</code> or they can be returned by other classes,
  # such as a <code>CertPathBuilder</code>.
  # <p>
  # By convention, X.509 <code>CertPath</code>s (consisting of
  # <code>X509Certificate</code>s), are ordered starting with the target
  # certificate and ending with a certificate issued by the trust anchor. That
  # is, the issuer of one certificate is the subject of the following one. The
  # certificate representing the {@link TrustAnchor TrustAnchor} should not be
  # included in the certification path. Unvalidated X.509 <code>CertPath</code>s
  # may not follow these conventions. PKIX <code>CertPathValidator</code>s will
  # detect any departure from these conventions that cause the certification
  # path to be invalid and throw a <code>CertPathValidatorException</code>.
  # <p>
  # <b>Concurrent Access</b>
  # <p>
  # All <code>CertPath</code> objects must be thread-safe. That is, multiple
  # threads may concurrently invoke the methods defined in this class on a
  # single <code>CertPath</code> object (or more than one) with no
  # ill effects. This is also true for the <code>List</code> returned by
  # <code>CertPath.getCertificates</code>.
  # <p>
  # Requiring <code>CertPath</code> objects to be immutable and thread-safe
  # allows them to be passed around to various pieces of code without worrying
  # about coordinating access.  Providing this thread-safety is
  # generally not difficult, since the <code>CertPath</code> and
  # <code>List</code> objects in question are immutable.
  # 
  # @see CertificateFactory
  # @see CertPathBuilder
  # 
  # @author      Yassir Elley
  # @since       1.4
  class CertPath 
    include_class_members CertPathImports
    include Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6068470306649138683 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    typesig { [String] }
    # the type of certificates in this chain
    # 
    # Creates a <code>CertPath</code> of the specified type.
    # <p>
    # This constructor is protected because most users should use a
    # <code>CertificateFactory</code> to create <code>CertPath</code>s.
    # 
    # @param type the standard name of the type of
    # <code>Certificate</code>s in this path
    def initialize(type)
      @type = nil
      @type = type
    end
    
    typesig { [] }
    # Returns the type of <code>Certificate</code>s in this certification
    # path. This is the same string that would be returned by
    # {@link java.security.cert.Certificate#getType() cert.getType()}
    # for all <code>Certificate</code>s in the certification path.
    # 
    # @return the type of <code>Certificate</code>s in this certification
    # path (never null)
    def get_type
      return @type
    end
    
    typesig { [] }
    # Returns an iteration of the encodings supported by this certification
    # path, with the default encoding first. Attempts to modify the returned
    # <code>Iterator</code> via its <code>remove</code> method result in an
    # <code>UnsupportedOperationException</code>.
    # 
    # @return an <code>Iterator</code> over the names of the supported
    # encodings (as Strings)
    def get_encodings
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # Compares this certification path for equality with the specified
    # object. Two <code>CertPath</code>s are equal if and only if their
    # types are equal and their certificate <code>List</code>s (and by
    # implication the <code>Certificate</code>s in those <code>List</code>s)
    # are equal. A <code>CertPath</code> is never equal to an object that is
    # not a <code>CertPath</code>.
    # <p>
    # This algorithm is implemented by this method. If it is overridden,
    # the behavior specified here must be maintained.
    # 
    # @param other the object to test for equality with this certification path
    # @return true if the specified object is equal to this certification path,
    # false otherwise
    def equals(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(CertPath)))
        return false
      end
      other_cp = other
      if (!(other_cp.get_type == @type))
        return false
      end
      this_cert_list = self.get_certificates
      other_cert_list = other_cp.get_certificates
      return ((this_cert_list == other_cert_list))
    end
    
    typesig { [] }
    # Returns the hashcode for this certification path. The hash code of
    # a certification path is defined to be the result of the following
    # calculation:
    # <pre><code>
    # hashCode = path.getType().hashCode();
    # hashCode = 31*hashCode + path.getCertificates().hashCode();
    # </code></pre>
    # This ensures that <code>path1.equals(path2)</code> implies that
    # <code>path1.hashCode()==path2.hashCode()</code> for any two certification
    # paths, <code>path1</code> and <code>path2</code>, as required by the
    # general contract of <code>Object.hashCode</code>.
    # 
    # @return the hashcode value for this certification path
    def hash_code
      hash_code_ = @type.hash_code
      hash_code_ = 31 * hash_code_ + get_certificates.hash_code
      return hash_code_
    end
    
    typesig { [] }
    # Returns a string representation of this certification path.
    # This calls the <code>toString</code> method on each of the
    # <code>Certificate</code>s in the path.
    # 
    # @return a string representation of this certification path
    def to_s
      sb = StringBuffer.new
      string_iterator = get_certificates.iterator
      sb.append("\n" + @type + " Cert Path: length = " + (get_certificates.size).to_s + ".\n")
      sb.append("[\n")
      i = 1
      while (string_iterator.has_next)
        sb.append("==========================================" + "===============Certificate " + (i).to_s + " start.\n")
        string_cert = string_iterator.next
        sb.append(string_cert.to_s)
        sb.append("\n========================================" + "=================Certificate " + (i).to_s + " end.\n\n\n")
        ((i += 1) - 1)
      end
      sb.append("\n]")
      return sb.to_s
    end
    
    typesig { [] }
    # Returns the encoded form of this certification path, using the default
    # encoding.
    # 
    # @return the encoded bytes
    # @exception CertificateEncodingException if an encoding error occurs
    def get_encoded
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Returns the encoded form of this certification path, using the
    # specified encoding.
    # 
    # @param encoding the name of the encoding to use
    # @return the encoded bytes
    # @exception CertificateEncodingException if an encoding error occurs or
    # the encoding requested is not supported
    def get_encoded(encoding)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the list of certificates in this certification path.
    # The <code>List</code> returned must be immutable and thread-safe.
    # 
    # @return an immutable <code>List</code> of <code>Certificate</code>s
    # (may be empty, but not null)
    def get_certificates
      raise NotImplementedError
    end
    
    typesig { [] }
    # Replaces the <code>CertPath</code> to be serialized with a
    # <code>CertPathRep</code> object.
    # 
    # @return the <code>CertPathRep</code> to be serialized
    # 
    # @throws ObjectStreamException if a <code>CertPathRep</code> object
    # representing this certification path could not be created
    def write_replace
      begin
        return CertPathRep.new(@type, get_encoded)
      rescue CertificateException => ce
        nse = NotSerializableException.new("java.security.cert.CertPath: " + @type)
        nse.init_cause(ce)
        raise nse
      end
    end
    
    class_module.module_eval {
      # Alternate <code>CertPath</code> class for serialization.
      # @since 1.4
      const_set_lazy(:CertPathRep) { Class.new do
        include_class_members CertPath
        include Serializable
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 3015633072427920915 }
          const_attr_reader  :SerialVersionUID
        }
        
        # The Certificate type
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        # The encoded form of the cert path
        attr_accessor :data
        alias_method :attr_data, :data
        undef_method :data
        alias_method :attr_data=, :data=
        undef_method :data=
        
        typesig { [String, Array.typed(::Java::Byte)] }
        # Creates a <code>CertPathRep</code> with the specified
        # type and encoded form of a certification path.
        # 
        # @param type the standard name of a <code>CertPath</code> type
        # @param data the encoded form of the certification path
        def initialize(type, data)
          @type = nil
          @data = nil
          @type = type
          @data = data
        end
        
        typesig { [] }
        # Returns a <code>CertPath</code> constructed from the type and data.
        # 
        # @return the resolved <code>CertPath</code> object
        # 
        # @throws ObjectStreamException if a <code>CertPath</code> could not
        # be constructed
        def read_resolve
          begin
            cf = CertificateFactory.get_instance(@type)
            return cf.generate_cert_path(ByteArrayInputStream.new(@data))
          rescue CertificateException => ce
            nse = NotSerializableException.new("java.security.cert.CertPath: " + @type)
            nse.init_cause(ce)
            raise nse
          end
        end
        
        private
        alias_method :initialize__cert_path_rep, :initialize
      end }
    }
    
    private
    alias_method :initialize__cert_path, :initialize
  end
  
end
