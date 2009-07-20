require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module CodeSourceImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :SocketPermission
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Io, :ByteArrayInputStream
      include_const ::Java::Io, :IOException
      include ::Java::Security::Cert
    }
  end
  
  # <p>This class extends the concept of a codebase to
  # encapsulate not only the location (URL) but also the certificate chains
  # that were used to verify signed code originating from that location.
  # 
  # @author Li Gong
  # @author Roland Schemers
  class CodeSource 
    include_class_members CodeSourceImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 4977541819976013951 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The code location.
    # 
    # @serial
    attr_accessor :location
    alias_method :attr_location, :location
    undef_method :location
    alias_method :attr_location=, :location=
    undef_method :location=
    
    # The code signers.
    attr_accessor :signers
    alias_method :attr_signers, :signers
    undef_method :signers
    alias_method :attr_signers=, :signers=
    undef_method :signers=
    
    # The code signers. Certificate chains are concatenated.
    attr_accessor :certs
    alias_method :attr_certs, :certs
    undef_method :certs
    alias_method :attr_certs=, :certs=
    undef_method :certs=
    
    # cached SocketPermission used for matchLocation
    attr_accessor :sp
    alias_method :attr_sp, :sp
    undef_method :sp
    alias_method :attr_sp=, :sp=
    undef_method :sp=
    
    # for generating cert paths
    attr_accessor :factory
    alias_method :attr_factory, :factory
    undef_method :factory
    alias_method :attr_factory=, :factory=
    undef_method :factory=
    
    typesig { [URL, Array.typed(Java::Security::Cert::Certificate)] }
    # Constructs a CodeSource and associates it with the specified
    # location and set of certificates.
    # 
    # @param url the location (URL).
    # 
    # @param certs the certificate(s). It may be null. The contents of the
    # array are copied to protect against subsequent modification.
    def initialize(url, certs)
      @location = nil
      @signers = nil
      @certs = nil
      @sp = nil
      @factory = nil
      @location = url
      # Copy the supplied certs
      if (!(certs).nil?)
        @certs = certs.clone
      end
    end
    
    typesig { [URL, Array.typed(CodeSigner)] }
    # Constructs a CodeSource and associates it with the specified
    # location and set of code signers.
    # 
    # @param url the location (URL).
    # @param signers the code signers. It may be null. The contents of the
    # array are copied to protect against subsequent modification.
    # 
    # @since 1.5
    def initialize(url, signers)
      @location = nil
      @signers = nil
      @certs = nil
      @sp = nil
      @factory = nil
      @location = url
      # Copy the supplied signers
      if (!(signers).nil?)
        @signers = signers.clone
      end
    end
    
    typesig { [] }
    # Returns the hash code value for this object.
    # 
    # @return a hash code value for this object.
    def hash_code
      if (!(@location).nil?)
        return @location.hash_code
      else
        return 0
      end
    end
    
    typesig { [Object] }
    # Tests for equality between the specified object and this
    # object. Two CodeSource objects are considered equal if their
    # locations are of identical value and if their signer certificate
    # chains are of identical value. It is not required that
    # the certificate chains be in the same order.
    # 
    # @param obj the object to test for equality with this object.
    # 
    # @return true if the objects are considered equal, false otherwise.
    def equals(obj)
      if ((obj).equal?(self))
        return true
      end
      # objects types must be equal
      if (!(obj.is_a?(CodeSource)))
        return false
      end
      cs = obj
      # URLs must match
      if ((@location).nil?)
        # if location is null, then cs.location must be null as well
        if (!(cs.attr_location).nil?)
          return false
        end
      else
        # if location is not null, then it must equal cs.location
        if (!(@location == cs.attr_location))
          return false
        end
      end
      # certs must match
      return match_certs(cs, true)
    end
    
    typesig { [] }
    # Returns the location associated with this CodeSource.
    # 
    # @return the location (URL).
    def get_location
      # since URL is practically immutable, returning itself is not
      # a security problem
      return @location
    end
    
    typesig { [] }
    # Returns the certificates associated with this CodeSource.
    # <p>
    # If this CodeSource object was created using the
    # {@link #CodeSource(URL url, CodeSigner[] signers)}
    # constructor then its certificate chains are extracted and used to
    # create an array of Certificate objects. Each signer certificate is
    # followed by its supporting certificate chain (which may be empty).
    # Each signer certificate and its supporting certificate chain is ordered
    # bottom-to-top (i.e., with the signer certificate first and the (root)
    # certificate authority last).
    # 
    # @return A copy of the certificates array, or null if there is none.
    def get_certificates
      if (!(@certs).nil?)
        return @certs.clone
      else
        if (!(@signers).nil?)
          # Convert the code signers to certs
          cert_chains = ArrayList.new
          i = 0
          while i < @signers.attr_length
            cert_chains.add_all(@signers[i].get_signer_cert_path.get_certificates)
            i += 1
          end
          @certs = cert_chains.to_array(Array.typed(Java::Security::Cert::Certificate).new(cert_chains.size) { nil })
          return @certs.clone
        else
          return nil
        end
      end
    end
    
    typesig { [] }
    # Returns the code signers associated with this CodeSource.
    # <p>
    # If this CodeSource object was created using the
    # {@link #CodeSource(URL url, Certificate[] certs)}
    # constructor then its certificate chains are extracted and used to
    # create an array of CodeSigner objects. Note that only X.509 certificates
    # are examined - all other certificate types are ignored.
    # 
    # @return A copy of the code signer array, or null if there is none.
    # 
    # @since 1.5
    def get_code_signers
      if (!(@signers).nil?)
        return @signers.clone
      else
        if (!(@certs).nil?)
          # Convert the certs to code signers
          @signers = convert_cert_array_to_signer_array(@certs)
          return @signers.clone
        else
          return nil
        end
      end
    end
    
    typesig { [CodeSource] }
    # Returns true if this CodeSource object "implies" the specified CodeSource.
    # <P>
    # More specifically, this method makes the following checks, in order.
    # If any fail, it returns false. If they all succeed, it returns true.<p>
    # <ol>
    # <li> <i>codesource</i> must not be null.
    # <li> If this object's certificates are not null, then all
    # of this object's certificates must be present in <i>codesource</i>'s
    # certificates.
    # <li> If this object's location (getLocation()) is not null, then the
    # following checks are made against this object's location and
    # <i>codesource</i>'s:<p>
    # <ol>
    # <li>  <i>codesource</i>'s location must not be null.
    # 
    # <li>  If this object's location
    # equals <i>codesource</i>'s location, then return true.
    # 
    # <li>  This object's protocol (getLocation().getProtocol()) must be
    # equal to <i>codesource</i>'s protocol.
    # 
    # <li>  If this object's host (getLocation().getHost()) is not null,
    # then the SocketPermission
    # constructed with this object's host must imply the
    # SocketPermission constructed with <i>codesource</i>'s host.
    # 
    # <li>  If this object's port (getLocation().getPort()) is not
    # equal to -1 (that is, if a port is specified), it must equal
    # <i>codesource</i>'s port.
    # 
    # <li>  If this object's file (getLocation().getFile()) doesn't equal
    # <i>codesource</i>'s file, then the following checks are made:
    # If this object's file ends with "/-",
    # then <i>codesource</i>'s file must start with this object's
    # file (exclusive the trailing "-").
    # If this object's file ends with a "/*",
    # then <i>codesource</i>'s file must start with this object's
    # file and must not have any further "/" separators.
    # If this object's file doesn't end with a "/",
    # then <i>codesource</i>'s file must match this object's
    # file with a '/' appended.
    # 
    # <li>  If this object's reference (getLocation().getRef()) is
    # not null, it must equal <i>codesource</i>'s reference.
    # 
    # </ol>
    # </ol>
    # <p>
    # For example, the codesource objects with the following locations
    # and null certificates all imply
    # the codesource with the location "http://java.sun.com/classes/foo.jar"
    # and null certificates:
    # <pre>
    # http:
    # http://*.sun.com/classes/*
    # http://java.sun.com/classes/-
    # http://java.sun.com/classes/foo.jar
    # </pre>
    # 
    # Note that if this CodeSource has a null location and a null
    # certificate chain, then it implies every other CodeSource.
    # 
    # @param codesource CodeSource to compare against.
    # 
    # @return true if the specified codesource is implied by this codesource,
    # false if not.
    def implies(codesource)
      if ((codesource).nil?)
        return false
      end
      return match_certs(codesource, false) && match_location(codesource)
    end
    
    typesig { [CodeSource, ::Java::Boolean] }
    # Returns true if all the certs in this
    # CodeSource are also in <i>that</i>.
    # 
    # @param that the CodeSource to check against.
    # @param strict If true then a strict equality match is performed.
    # Otherwise a subset match is performed.
    def match_certs(that, strict)
      match = false
      # match any key
      if ((@certs).nil? && (@signers).nil?)
        if (strict)
          return ((that.attr_certs).nil? && (that.attr_signers).nil?)
        else
          return true
        end
        # both have signers
      else
        if (!(@signers).nil? && !(that.attr_signers).nil?)
          if (strict && !(@signers.attr_length).equal?(that.attr_signers.attr_length))
            return false
          end
          i = 0
          while i < @signers.attr_length
            match = false
            j = 0
            while j < that.attr_signers.attr_length
              if ((@signers[i] == that.attr_signers[j]))
                match = true
                break
              end
              j += 1
            end
            if (!match)
              return false
            end
            i += 1
          end
          return true
          # both have certs
        else
          if (!(@certs).nil? && !(that.attr_certs).nil?)
            if (strict && !(@certs.attr_length).equal?(that.attr_certs.attr_length))
              return false
            end
            i = 0
            while i < @certs.attr_length
              match = false
              j = 0
              while j < that.attr_certs.attr_length
                if ((@certs[i] == that.attr_certs[j]))
                  match = true
                  break
                end
                j += 1
              end
              if (!match)
                return false
              end
              i += 1
            end
            return true
          end
        end
      end
      return false
    end
    
    typesig { [CodeSource] }
    # Returns true if two CodeSource's have the "same" location.
    # 
    # @param that CodeSource to compare against
    def match_location(that)
      if ((@location).nil?)
        return true
      end
      if (((that).nil?) || ((that.attr_location).nil?))
        return false
      end
      if ((@location == that.attr_location))
        return true
      end
      if (!(@location.get_protocol == that.attr_location.get_protocol))
        return false
      end
      this_host = @location.get_host
      that_host = that.attr_location.get_host
      if (!(this_host).nil?)
        if ((("" == this_host) || ("localhost" == this_host)) && (("" == that_host) || ("localhost" == that_host)))
          # ok
        else
          if (!(this_host == that_host))
            if ((that_host).nil?)
              return false
            end
            if ((@sp).nil?)
              @sp = SocketPermission.new(this_host, "resolve")
            end
            if ((that.attr_sp).nil?)
              that.attr_sp = SocketPermission.new(that_host, "resolve")
            end
            if (!@sp.implies(that.attr_sp))
              return false
            end
          end
        end
      end
      if (!(@location.get_port).equal?(-1))
        if (!(@location.get_port).equal?(that.attr_location.get_port))
          return false
        end
      end
      if (@location.get_file.ends_with("/-"))
        # Matches the directory and (recursively) all files
        # and subdirectories contained in that directory.
        # For example, "/a/b/-" implies anything that starts with
        # "/a/b/"
        this_path = @location.get_file.substring(0, @location.get_file.length - 1)
        if (!that.attr_location.get_file.starts_with(this_path))
          return false
        end
      else
        if (@location.get_file.ends_with("/*"))
          # Matches the directory and all the files contained in that
          # directory.
          # For example, "/a/b/*" implies anything that starts with
          # "/a/b/" but has no further slashes
          last = that.attr_location.get_file.last_index_of(Character.new(?/.ord))
          if ((last).equal?(-1))
            return false
          end
          this_path = @location.get_file.substring(0, @location.get_file.length - 1)
          that_path = that.attr_location.get_file.substring(0, last + 1)
          if (!(that_path == this_path))
            return false
          end
        else
          # Exact matches only.
          # For example, "/a/b" and "/a/b/" both imply "/a/b/"
          if ((!(that.attr_location.get_file == @location.get_file)) && (!(that.attr_location.get_file == (@location.get_file).to_s + "/")))
            return false
          end
        end
      end
      if ((@location.get_ref).nil?)
        return true
      else
        return (@location.get_ref == that.attr_location.get_ref)
      end
    end
    
    typesig { [] }
    # Returns a string describing this CodeSource, telling its
    # URL and certificates.
    # 
    # @return information about this CodeSource.
    def to_s
      sb = StringBuilder.new
      sb.append("(")
      sb.append(@location)
      if (!(@certs).nil? && @certs.attr_length > 0)
        i = 0
        while i < @certs.attr_length
          sb.append(" " + (@certs[i]).to_s)
          i += 1
        end
      else
        if (!(@signers).nil? && @signers.attr_length > 0)
          i = 0
          while i < @signers.attr_length
            sb.append(" " + (@signers[i]).to_s)
            i += 1
          end
        else
          sb.append(" <no signer certificates>")
        end
      end
      sb.append(")")
      return sb.to_s
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Writes this object out to a stream (i.e., serializes it).
    # 
    # @serialData An initial <code>URL</code> is followed by an
    # <code>int</code> indicating the number of certificates to follow
    # (a value of "zero" denotes that there are no certificates associated
    # with this object).
    # Each certificate is written out starting with a <code>String</code>
    # denoting the certificate type, followed by an
    # <code>int</code> specifying the length of the certificate encoding,
    # followed by the certificate encoding itself which is written out as an
    # array of bytes. Finally, if any code signers are present then the array
    # of code signers is serialized and written out too.
    def write_object(oos)
      oos.default_write_object # location
      # Serialize the array of certs
      if ((@certs).nil? || (@certs.attr_length).equal?(0))
        oos.write_int(0)
      else
        # write out the total number of certs
        oos.write_int(@certs.attr_length)
        # write out each cert, including its type
        i = 0
        while i < @certs.attr_length
          cert = @certs[i]
          begin
            oos.write_utf(cert.get_type)
            encoded = cert.get_encoded
            oos.write_int(encoded.attr_length)
            oos.write(encoded)
          rescue CertificateEncodingException => cee
            raise IOException.new(cee.get_message)
          end
          i += 1
        end
      end
      # Serialize the array of code signers (if any)
      if (!(@signers).nil? && @signers.attr_length > 0)
        oos.write_object(@signers)
      end
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Restores this object from a stream (i.e., deserializes it).
    def read_object(ois)
      cf = nil
      cfs = nil
      ois.default_read_object # location
      # process any new-style certs in the stream (if present)
      size_ = ois.read_int
      if (size_ > 0)
        # we know of 3 different cert types: X.509, PGP, SDSI, which
        # could all be present in the stream at the same time
        cfs = Hashtable.new(3)
        @certs = Array.typed(Java::Security::Cert::Certificate).new(size_) { nil }
      end
      i = 0
      while i < size_
        # read the certificate type, and instantiate a certificate
        # factory of that type (reuse existing factory if possible)
        cert_type = ois.read_utf
        if (cfs.contains_key(cert_type))
          # reuse certificate factory
          cf = cfs.get(cert_type)
        else
          # create new certificate factory
          begin
            cf = CertificateFactory.get_instance(cert_type)
          rescue CertificateException => ce
            raise ClassNotFoundException.new("Certificate factory for " + cert_type + " not found")
          end
          # store the certificate factory so we can reuse it later
          cfs.put(cert_type, cf)
        end
        # parse the certificate
        encoded = nil
        begin
          encoded = Array.typed(::Java::Byte).new(ois.read_int) { 0 }
        rescue OutOfMemoryError => oome
          raise IOException.new("Certificate too big")
        end
        ois.read_fully(encoded)
        bais = ByteArrayInputStream.new(encoded)
        begin
          @certs[i] = cf.generate_certificate(bais)
        rescue CertificateException => ce
          raise IOException.new(ce.get_message)
        end
        bais.close
        i += 1
      end
      # Deserialize array of code signers (if any)
      begin
        @signers = ois.read_object
      rescue IOException => ioe
        # no signers present
      end
    end
    
    typesig { [Array.typed(Java::Security::Cert::Certificate)] }
    # Convert an array of certificates to an array of code signers.
    # The array of certificates is a concatenation of certificate chains
    # where the initial certificate in each chain is the end-entity cert.
    # 
    # @return An array of code signers or null if none are generated.
    def convert_cert_array_to_signer_array(certs)
      if ((certs).nil?)
        return nil
      end
      begin
        # Initialize certificate factory
        if ((@factory).nil?)
          @factory = CertificateFactory.get_instance("X.509")
        end
        # Iterate through all the certificates
        i = 0
        signers = ArrayList.new
        while (i < certs.attr_length)
          cert_chain = ArrayList.new
          cert_chain.add(certs[((i += 1) - 1)]) # first cert is an end-entity cert
          j = i
          # Extract chain of certificates
          # (loop while certs are not end-entity certs)
          while (j < certs.attr_length && certs[j].is_a?(X509Certificate) && !((certs[j]).get_basic_constraints).equal?(-1))
            cert_chain.add(certs[j])
            j += 1
          end
          i = j
          cert_path = @factory.generate_cert_path(cert_chain)
          signers.add(CodeSigner.new(cert_path, nil))
        end
        if (signers.is_empty)
          return nil
        else
          return signers.to_array(Array.typed(CodeSigner).new(signers.size) { nil })
        end
      rescue CertificateException => e
        return nil # TODO - may be better to throw an ex. here
      end
    end
    
    private
    alias_method :initialize__code_source, :initialize
  end
  
end
