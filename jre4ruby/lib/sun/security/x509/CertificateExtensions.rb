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
  module CertificateExtensionsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Java::Security::Cert, :CertificateException
      include ::Java::Util
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::Util
    }
  end
  
  # This class defines the Extensions attribute for the Certificate.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see CertAttrSet
  class CertificateExtensions 
    include_class_members CertificateExtensionsImports
    include CertAttrSet
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions" }
      const_attr_reader  :IDENT
      
      # name
      const_set_lazy(:NAME) { "extensions" }
      const_attr_reader  :NAME
      
      const_set_lazy(:Debug) { Debug.get_instance("x509") }
      const_attr_reader  :Debug
    }
    
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
    
    attr_accessor :unparseable_extensions
    alias_method :attr_unparseable_extensions, :unparseable_extensions
    undef_method :unparseable_extensions
    alias_method :attr_unparseable_extensions=, :unparseable_extensions=
    undef_method :unparseable_extensions=
    
    typesig { [] }
    # Default constructor.
    def initialize
      @map = Hashtable.new
      @unsupported_crit_ext = false
      @unparseable_extensions = nil
    end
    
    typesig { [DerInputStream] }
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the Extension from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @map = Hashtable.new
      @unsupported_crit_ext = false
      @unparseable_extensions = nil
      init(in_)
    end
    
    typesig { [DerInputStream] }
    # helper routine
    def init(in_)
      exts = in_.get_sequence(5)
      i = 0
      while i < exts.attr_length
        ext = Extension.new(exts[i])
        parse_extension(ext)
        i += 1
      end
    end
    
    class_module.module_eval {
      
      def params
        defined?(@@params) ? @@params : @@params= Array.typed(Class).new([Boolean.class, Object.class])
      end
      alias_method :attr_params, :params
      
      def params=(value)
        @@params = value
      end
      alias_method :attr_params=, :params=
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
          if ((@map.put(ext.get_extension_id.to_s, ext)).nil?)
            return
          else
            raise IOException.new("Duplicate extensions not allowed")
          end
        end
        cons = (ext_class).get_constructor(self.attr_params)
        passed = Array.typed(Object).new([Boolean.value_of(ext.is_critical), ext.get_extension_value])
        cert_ext = cons.new_instance(passed)
        if (!(@map.put(cert_ext.get_name, cert_ext)).nil?)
          raise IOException.new("Duplicate extensions not allowed")
        end
      rescue InvocationTargetException => invk
        e = invk.get_target_exception
        if ((ext.is_critical).equal?(false))
          # ignore errors parsing non-critical extensions
          if ((@unparseable_extensions).nil?)
            @unparseable_extensions = HashMap.new
          end
          @unparseable_extensions.put(ext.get_extension_id.to_s, UnparseableExtension.new(ext, e))
          if (!(Debug).nil?)
            Debug.println("Error parsing extension: " + (ext).to_s)
            e.print_stack_trace
            h = HexDumpEncoder.new
            System.err.println(h.encode_buffer(ext.get_extension_value))
          end
          return
        end
        if (e.is_a?(IOException))
          raise e
        else
          raise IOException.new(e.to_s).init_cause(e)
        end
      rescue IOException => e
        raise e
      rescue Exception => e
        raise IOException.new(e.to_s).init_cause(e)
      end
    end
    
    typesig { [OutputStream] }
    # Encode the extensions in DER form to the stream, setting
    # the context specific tag as needed in the X.509 v3 certificate.
    # 
    # @param out the DerOutputStream to marshal the contents to.
    # @exception CertificateException on encoding errors.
    # @exception IOException on errors.
    def encode(out)
      encode(out, false)
    end
    
    typesig { [OutputStream, ::Java::Boolean] }
    # Encode the extensions in DER form to the stream.
    # 
    # @param out the DerOutputStream to marshal the contents to.
    # @param isCertReq if true then no context specific tag is added.
    # @exception CertificateException on encoding errors.
    # @exception IOException on errors.
    def encode(out, is_cert_req)
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
            raise CertificateException.new("Illegal extension object")
          end
        end
        i += 1
      end
      seq = DerOutputStream.new
      seq.write(DerValue.attr_tag_sequence, ext_out)
      tmp = nil
      if (!is_cert_req)
        # certificate
        tmp = DerOutputStream.new
        tmp.write(DerValue.create_tag(DerValue::TAG_CONTEXT, true, 3), seq)
      else
        tmp = seq
      end # pkcs#10 certificateRequest
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    # @param name the extension name used in the cache.
    # @param obj the object to set.
    # @exception IOException if the object could not be cached.
    def set(name, obj)
      if (obj.is_a?(Extension))
        @map.put(name, obj)
      else
        raise IOException.new("Unknown extension type.")
      end
    end
    
    typesig { [String] }
    # Get the attribute value.
    # @param name the extension name used in the lookup.
    # @exception IOException if named extension is not found.
    def get(name)
      obj = @map.get(name)
      if ((obj).nil?)
        raise IOException.new("No extension found with name " + name)
      end
      return (obj)
    end
    
    typesig { [String] }
    # Delete the attribute value.
    # @param name the extension name used in the lookup.
    # @exception IOException if named extension is not found.
    def delete(name)
      obj = @map.get(name)
      if ((obj).nil?)
        raise IOException.new("No extension found with name " + name)
      end
      @map.remove(name)
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      return @map.elements
    end
    
    typesig { [] }
    # Return a collection view of the extensions.
    # @return a collection view of the extensions in this Certificate.
    def get_all_extensions
      return @map.values
    end
    
    typesig { [] }
    def get_unparseable_extensions
      if ((@unparseable_extensions).nil?)
        return Collections.empty_map
      else
        return @unparseable_extensions
      end
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return NAME
    end
    
    typesig { [] }
    # Return true if a critical extension is found that is
    # not supported, otherwise return false.
    def has_unsupported_critical_extension
      return @unsupported_crit_ext
    end
    
    typesig { [Object] }
    # Compares this CertificateExtensions for equality with the specified
    # object. If the <code>other</code> object is an
    # <code>instanceof</code> <code>CertificateExtensions</code>, then
    # all the entries are compared with the entries from this.
    # 
    # @param other the object to test for equality with this
    # CertificateExtensions.
    # @return true iff all the entries match that of the Other,
    # false otherwise.
    def equals(other)
      if ((self).equal?(other))
        return true
      end
      if (!(other.is_a?(CertificateExtensions)))
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
          key = ((objs[i]).get_name).to_s
        end
        other_ext = objs[i]
        if ((key).nil?)
          key = (other_ext.get_extension_id.to_s).to_s
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
      return (self.get_unparseable_extensions == (other).get_unparseable_extensions)
    end
    
    typesig { [] }
    # Returns a hashcode value for this CertificateExtensions.
    # 
    # @return the hashcode value.
    def hash_code
      return @map.hash_code + get_unparseable_extensions.hash_code
    end
    
    typesig { [] }
    # Returns a string representation of this <tt>CertificateExtensions</tt>
    # object in the form of a set of entries, enclosed in braces and separated
    # by the ASCII characters "<tt>,&nbsp;</tt>" (comma and space).
    # <p>Overrides to <tt>toString</tt> method of <tt>Object</tt>.
    # 
    # @return  a string representation of this CertificateExtensions.
    def to_s
      return @map.to_s
    end
    
    private
    alias_method :initialize__certificate_extensions, :initialize
  end
  
  class UnparseableExtension < CertificateExtensionsImports.const_get :Extension
    include_class_members CertificateExtensionsImports
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :why
    alias_method :attr_why, :why
    undef_method :why
    alias_method :attr_why=, :why=
    undef_method :why=
    
    typesig { [Extension, Exception] }
    def initialize(ext, why)
      @name = nil
      @why = nil
      super(ext)
      @name = ""
      begin
        ext_class = OIDMap.get_class(ext.get_extension_id)
        if (!(ext_class).nil?)
          field = ext_class.get_declared_field("NAME")
          @name = ((field.get(nil))).to_s + " "
        end
      rescue Exception => e
        # If we cannot find the name, just ignore it
      end
      @why = why
    end
    
    typesig { [] }
    def to_s
      return (super).to_s + "Unparseable " + @name + "extension due to\n" + (@why).to_s + "\n\n" + (Sun::Misc::HexDumpEncoder.new.encode_buffer(get_extension_value)).to_s
    end
    
    private
    alias_method :initialize__unparseable_extension, :initialize
  end
  
end
