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
module Sun::Security::X509
  module CRLExtensionsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Java::Security::Cert, :CRLException
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include ::Sun::Security::Util
      include_const ::Sun::Misc, :HexDumpEncoder
    }
  end
  
  # This class defines the CRL Extensions.
  # It is used for both CRL Extensions and CRL Entry Extensions,
  # which are defined are follows:
  # <pre>
  # TBSCertList  ::=  SEQUENCE  {
  #    version              Version OPTIONAL,   -- if present, must be v2
  #    signature            AlgorithmIdentifier,
  #    issuer               Name,
  #    thisUpdate           Time,
  #    nextUpdate           Time  OPTIONAL,
  #    revokedCertificates  SEQUENCE OF SEQUENCE  {
  #        userCertificate         CertificateSerialNumber,
  #        revocationDate          Time,
  #        crlEntryExtensions      Extensions OPTIONAL  -- if present, must be v2
  #    }  OPTIONAL,
  #    crlExtensions        [0] EXPLICIT Extensions OPTIONAL  -- if present, must be v2
  # }
  # </pre>
  # 
  # @author Hemma Prafullchandra
  class CRLExtensions 
    include_class_members CRLExtensionsImports
    
    attr_accessor :map
    alias_method :attr_map, :map
    undef_method :map
    alias_method :attr_map=, :map=
    undef_method :map=
    
    attr_accessor :unsupported_crit_ext
    alias_method :attr_unsupported_crit_ext, :unsupported_crit_ext
    undef_method :unsupported_crit_ext
    alias_method :attr_unsupported_crit_ext=, :unsupported_crit_ext=
    undef_method :unsupported_crit_ext=
    
    typesig { [] }
    # Default constructor.
    def initialize
      @map = Hashtable.new
      @unsupported_crit_ext = false
    end
    
    typesig { [DerInputStream] }
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the Extension from, i.e. the
    #        sequence of extensions.
    # @exception CRLException on decoding errors.
    def initialize(in_)
      @map = Hashtable.new
      @unsupported_crit_ext = false
      init(in_)
    end
    
    typesig { [DerInputStream] }
    # helper routine
    def init(der_strm)
      begin
        str = der_strm
        next_byte = der_strm.peek_byte
        # check for context specific byte 0; skip it
        if ((((next_byte & 0xc0)).equal?(0x80)) && (((next_byte & 0x1f)).equal?(0x0)))
          val = str.get_der_value
          str = val.attr_data
        end
        exts = str.get_sequence(5)
        i = 0
        while i < exts.attr_length
          ext = Extension.new(exts[i])
          parse_extension(ext)
          i += 1
        end
      rescue IOException => e
        raise CRLException.new("Parsing error: " + RJava.cast_to_string(e.to_s))
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:PARAMS) { Array.typed(Class).new([Boolean, Object]) }
      const_attr_reader  :PARAMS
    }
    
    typesig { [Extension] }
    # Parse the encoded extension
    def parse_extension(ext)
      begin
        ext_class = OIDMap.get_class(ext.get_extension_id)
        if ((ext_class).nil?)
          # Unsupported extension
          if (ext.is_critical)
            @unsupported_crit_ext = true
          end
          if (!(@map.put(ext.get_extension_id.to_s, ext)).nil?)
            raise CRLException.new("Duplicate extensions not allowed")
          end
          return
        end
        cons = (ext_class).get_constructor(PARAMS)
        passed = Array.typed(Object).new([Boolean.value_of(ext.is_critical), ext.get_extension_value])
        crl_ext = cons.new_instance(passed)
        if (!(@map.put(crl_ext.get_name, crl_ext)).nil?)
          raise CRLException.new("Duplicate extensions not allowed")
        end
      rescue InvocationTargetException => invk
        raise CRLException.new(invk.get_target_exception.get_message)
      rescue JavaException => e
        raise CRLException.new(e.to_s)
      end
    end
    
    typesig { [OutputStream, ::Java::Boolean] }
    # Encode the extensions in DER form to the stream.
    # 
    # @param out the DerOutputStream to marshal the contents to.
    # @param isExplicit the tag indicating whether this is an entry
    # extension (false) or a CRL extension (true).
    # @exception CRLException on encoding errors.
    def encode(out, is_explicit)
      begin
        ext_out = DerOutputStream.new
        all_exts = @map.values
        objs = all_exts.to_array
        i = 0
        while i < objs.attr_length
          if (objs[i].is_a?(CertAttrSet))
            (objs[i]).encode(ext_out)
          else
            if (objs[i].is_a?(Extension))
              (objs[i]).encode(ext_out)
            else
              raise CRLException.new("Illegal extension object")
            end
          end
          i += 1
        end
        seq = DerOutputStream.new
        seq.write(DerValue.attr_tag_sequence, ext_out)
        tmp = DerOutputStream.new
        if (is_explicit)
          tmp.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 0), seq)
        else
          tmp = seq
        end
        out.write(tmp.to_byte_array)
      rescue IOException => e
        raise CRLException.new("Encoding error: " + RJava.cast_to_string(e.to_s))
      rescue CertificateException => e
        raise CRLException.new("Encoding error: " + RJava.cast_to_string(e.to_s))
      end
    end
    
    typesig { [String] }
    # Get the extension with this alias.
    # 
    # @param alias the identifier string for the extension to retrieve.
    def get(alias_)
      attr = X509AttributeName.new(alias_)
      name = nil
      id = attr.get_prefix
      if (id.equals_ignore_case(X509CertImpl::NAME))
        # fully qualified
        index = alias_.last_index_of(".")
        name = RJava.cast_to_string(alias_.substring(index + 1))
      else
        name = alias_
      end
      return @map.get(name)
    end
    
    typesig { [String, Object] }
    # Set the extension value with this alias.
    # 
    # @param alias the identifier string for the extension to set.
    # @param obj the Object to set the extension identified by the
    #        alias.
    def set(alias_, obj)
      @map.put(alias_, obj)
    end
    
    typesig { [String] }
    # Delete the extension value with this alias.
    # 
    # @param alias the identifier string for the extension to delete.
    def delete(alias_)
      @map.remove(alias_)
    end
    
    typesig { [] }
    # Return an enumeration of the extensions.
    # @return an enumeration of the extensions in this CRL.
    def get_elements
      return @map.elements
    end
    
    typesig { [] }
    # Return a collection view of the extensions.
    # @return a collection view of the extensions in this CRL.
    def get_all_extensions
      return @map.values
    end
    
    typesig { [] }
    # Return true if a critical extension is found that is
    # not supported, otherwise return false.
    def has_unsupported_critical_extension
      return @unsupported_crit_ext
    end
    
    typesig { [Object] }
    # Compares this CRLExtensions for equality with the specified
    # object. If the <code>other</code> object is an
    # <code>instanceof</code> <code>CRLExtensions</code>, then
    # all the entries are compared with the entries from this.
    # 
    # @param other the object to test for equality with this CRLExtensions.
    # @return true iff all the entries match that of the Other,
    # false otherwise.
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(CRLExtensions)))
        return false
      end
      other_c = (other).get_all_extensions
      objs = other_c.to_array
      len = objs.attr_length
      if (!(len).equal?(@map.size))
        return false
      end
      other_ext = nil
      this_ext = nil
      key = nil
      i = 0
      while i < len
        if (objs[i].is_a?(CertAttrSet))
          key = RJava.cast_to_string((objs[i]).get_name)
        end
        other_ext = objs[i]
        if ((key).nil?)
          key = RJava.cast_to_string(other_ext.get_extension_id.to_s)
        end
        this_ext = @map.get(key)
        if ((this_ext).nil?)
          return false
        end
        if (!(this_ext == other_ext))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    # Returns a hashcode value for this CRLExtensions.
    # 
    # @return the hashcode value.
    def hash_code
      return @map.hash_code
    end
    
    typesig { [] }
    # Returns a string representation of this <tt>CRLExtensions</tt> object
    # in the form of a set of entries, enclosed in braces and separated
    # by the ASCII characters "<tt>,&nbsp;</tt>" (comma and space).
    # <p>Overrides to <tt>toString</tt> method of <tt>Object</tt>.
    # 
    # @return  a string representation of this CRLExtensions.
    def to_s
      return @map.to_s
    end
    
    private
    alias_method :initialize__crlextensions, :initialize
  end
  
end
