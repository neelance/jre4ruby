require "rjava"

# 
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
module Sun::Security::Jgss
  module GSSNameImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include ::Org::Ietf::Jgss
      include ::Sun::Security::Jgss::Spi
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Arrays
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
    }
  end
  
  # 
  # This is the implementation class for GSSName. Conceptually the
  # GSSName is a container with mechanism specific name elements. Each
  # name element is a representation of how that particular mechanism
  # would canonicalize this principal.
  # 
  # Generally a GSSName is created by an application when it supplies
  # a sequence of bytes and a nametype that helps each mechanism
  # decide how to interpret those bytes.
  # 
  # It is not necessary to create name elements for each available
  # mechanism at the time the application creates the GSSName. This
  # implementation does this lazily, as and when name elements for
  # mechanisms are required to be handed out. (Generally, other GSS
  # classes like GSSContext and GSSCredential request specific
  # elements depending on the mechanisms that they are dealing with.)
  # Assume that getting a mechanism to parse the applciation specified
  # bytes is an expensive call.
  # 
  # When a GSSName is canonicalized wrt some mechanism, it is supposed
  # to discard all elements of other mechanisms and retain only the
  # element for this mechanism. In GSS terminology this is called a
  # Mechanism Name or MN. This implementation tries to retain the
  # application provided bytes and name type just in case the MN is
  # asked to produce an element for a mechanism that is different.
  # 
  # When a GSSName is to be exported, the name element for the desired
  # mechanism is converted to a byte representation and written
  # out. It might happen that a name element for that mechanism cannot
  # be obtained. This happens when the mechanism is just not supported
  # in this GSS-API or when the mechanism is supported but bytes
  # corresponding to the nametypes that it understands are not
  # available in this GSSName.
  # 
  # This class is safe for sharing. Each retrieval of a name element
  # from getElement() might potentially add a new element to the
  # hashmap of elements, but getElement() is synchronized.
  # 
  # @author Mayank Upadhyay
  # @since 1.4
  class GSSNameImpl 
    include_class_members GSSNameImplImports
    include GSSName
    
    attr_accessor :gss_manager
    alias_method :attr_gss_manager, :gss_manager
    undef_method :gss_manager
    alias_method :attr_gss_manager=, :gss_manager=
    undef_method :gss_manager=
    
    # 
    # Store whatever the application passed in. We will use this to
    # get individual mechanisms to create name elements as and when
    # needed.
    # Store both the String and the byte[]. Leave I18N to the
    # mechanism by allowing it to extract bytes from the String!
    attr_accessor :app_name_str
    alias_method :attr_app_name_str, :app_name_str
    undef_method :app_name_str
    alias_method :attr_app_name_str=, :app_name_str=
    undef_method :app_name_str=
    
    attr_accessor :app_name_bytes
    alias_method :attr_app_name_bytes, :app_name_bytes
    undef_method :app_name_bytes
    alias_method :attr_app_name_bytes=, :app_name_bytes=
    undef_method :app_name_bytes=
    
    attr_accessor :app_name_type
    alias_method :attr_app_name_type, :app_name_type
    undef_method :app_name_type
    alias_method :attr_app_name_type=, :app_name_type=
    undef_method :app_name_type=
    
    # 
    # When we figure out what the printable name would be, we store
    # both the name and its type.
    attr_accessor :printable_name
    alias_method :attr_printable_name, :printable_name
    undef_method :printable_name
    alias_method :attr_printable_name=, :printable_name=
    undef_method :printable_name=
    
    attr_accessor :printable_name_type
    alias_method :attr_printable_name_type, :printable_name_type
    undef_method :printable_name_type
    alias_method :attr_printable_name_type=, :printable_name_type=
    undef_method :printable_name_type=
    
    attr_accessor :elements
    alias_method :attr_elements, :elements
    undef_method :elements
    alias_method :attr_elements=, :elements=
    undef_method :elements=
    
    attr_accessor :mech_element
    alias_method :attr_mech_element, :mech_element
    undef_method :mech_element
    alias_method :attr_mech_element=, :mech_element=
    undef_method :mech_element=
    
    class_module.module_eval {
      typesig { [GSSManagerImpl, GSSNameSpi] }
      def wrap_element(gss_manager, mech_element)
        return ((mech_element).nil? ? nil : GSSNameImpl.new(gss_manager, mech_element))
      end
    }
    
    typesig { [GSSManagerImpl, GSSNameSpi] }
    def initialize(gss_manager, mech_element)
      @gss_manager = nil
      @app_name_str = nil
      @app_name_bytes = nil
      @app_name_type = nil
      @printable_name = nil
      @printable_name_type = nil
      @elements = nil
      @mech_element = nil
      @gss_manager = gss_manager
      @app_name_str = (@printable_name = (mech_element.to_s).to_s).to_s
      @app_name_type = @printable_name_type = mech_element.get_string_name_type
      @mech_element = mech_element
      @elements = HashMap.new(1)
      @elements.put(mech_element.get_mechanism, @mech_element)
    end
    
    typesig { [GSSManagerImpl, Object, Oid] }
    def initialize(gss_manager, app_name, app_name_type)
      initialize__gssname_impl(gss_manager, app_name, app_name_type, nil)
    end
    
    typesig { [GSSManagerImpl, Object, Oid, Oid] }
    def initialize(gss_manager, app_name, app_name_type, mech)
      @gss_manager = nil
      @app_name_str = nil
      @app_name_bytes = nil
      @app_name_type = nil
      @printable_name = nil
      @printable_name_type = nil
      @elements = nil
      @mech_element = nil
      if ((app_name).nil?)
        raise GSSExceptionImpl.new(GSSException::BAD_NAME, "Cannot import null name")
      end
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      if ((NT_EXPORT_NAME == app_name_type))
        import_name(gss_manager, app_name)
      else
        init(gss_manager, app_name, app_name_type, mech)
      end
    end
    
    typesig { [GSSManagerImpl, Object, Oid, Oid] }
    def init(gss_manager, app_name, app_name_type, mech)
      @gss_manager = gss_manager
      @elements = HashMap.new(gss_manager.get_mechs.attr_length)
      if (app_name.is_a?(String))
        @app_name_str = app_name
        # 
        # If appNameType is null, then the nametype for this printable
        # string is determined only by interrogating the
        # mechanism. Thus, defer the setting of printableName and
        # printableNameType till later.
        if (!(app_name_type).nil?)
          @printable_name = @app_name_str
          @printable_name_type = app_name_type
        end
      else
        @app_name_bytes = app_name
      end
      @app_name_type = app_name_type
      @mech_element = get_element(mech)
      # 
      # printableName will be null if appName was in a byte[] or if
      # appName was in a String but appNameType was null.
      if ((@printable_name).nil?)
        @printable_name = (@mech_element.to_s).to_s
        @printable_name_type = @mech_element.get_string_name_type
      end
      # 
      # At this point the GSSNameImpl has the following set:
      # appNameStr or appNameBytes
      # appNameType (could be null)
      # printableName
      # printableNameType
      # mechElement (which also exists in the hashmap of elements)
    end
    
    typesig { [GSSManagerImpl, Object] }
    def import_name(gss_manager, app_name)
      pos = 0
      bytes = nil
      if (app_name.is_a?(String))
        begin
          bytes = (app_name).get_bytes("UTF-8")
        rescue UnsupportedEncodingException => e
          # Won't happen
        end
      else
        bytes = app_name
      end
      if ((!(bytes[((pos += 1) - 1)]).equal?(0x4)) || (!(bytes[((pos += 1) - 1)]).equal?(0x1)))
        raise GSSExceptionImpl.new(GSSException::BAD_NAME, "Exported name token id is corrupted!")
      end
      oid_len = (((0xff & bytes[((pos += 1) - 1)]) << 8) | (0xff & bytes[((pos += 1) - 1)]))
      temp = nil
      begin
        din = DerInputStream.new(bytes, pos, oid_len)
        temp = ObjectIdentifier.new(din)
      rescue IOException => e
        raise GSSExceptionImpl.new(GSSException::BAD_NAME, "Exported name Object identifier is corrupted!")
      end
      oid = Oid.new(temp.to_s)
      pos += oid_len
      mech_portion_len = (((0xff & bytes[((pos += 1) - 1)]) << 24) | ((0xff & bytes[((pos += 1) - 1)]) << 16) | ((0xff & bytes[((pos += 1) - 1)]) << 8) | (0xff & bytes[((pos += 1) - 1)]))
      mech_portion = Array.typed(::Java::Byte).new(mech_portion_len) { 0 }
      System.arraycopy(bytes, pos, mech_portion, 0, mech_portion_len)
      init(gss_manager, mech_portion, NT_EXPORT_NAME, oid)
    end
    
    typesig { [Oid] }
    def canonicalize(mech)
      if ((mech).nil?)
        mech = ProviderList::DEFAULT_MECH_OID
      end
      return wrap_element(@gss_manager, get_element(mech))
    end
    
    typesig { [GSSName] }
    # 
    # This method may return false negatives. But if it says two
    # names are equals, then there is some mechanism that
    # authenticates them as the same principal.
    def equals(other)
      if (self.is_anonymous || other.is_anonymous)
        return false
      end
      if ((other).equal?(self))
        return true
      end
      if (!(other.is_a?(GSSNameImpl)))
        return equals(@gss_manager.create_name(other.to_s, other.get_string_name_type))
      end
      # 
      # XXX Do a comparison of the appNameStr/appNameBytes if
      # available. If that fails, then proceed with this test.
      that = other
      my_element = @mech_element
      element = that.attr_mech_element
      # 
      # XXX If they are not of the same mechanism type, convert both to
      # Kerberos since it is guaranteed to be present.
      if (((my_element).nil?) && (!(element).nil?))
        my_element = self.get_element(element.get_mechanism)
      else
        if ((!(my_element).nil?) && ((element).nil?))
          element = that.get_element(my_element.get_mechanism)
        end
      end
      if (!(my_element).nil? && !(element).nil?)
        return (my_element == element)
      end
      if ((!(@app_name_type).nil?) && (!(that.attr_app_name_type).nil?))
        if (!(@app_name_type == that.attr_app_name_type))
          return false
        end
        my_bytes = nil
        bytes = nil
        begin
          my_bytes = (!(@app_name_str).nil? ? @app_name_str.get_bytes("UTF-8") : @app_name_bytes)
          bytes = (!(that.attr_app_name_str).nil? ? that.attr_app_name_str.get_bytes("UTF-8") : that.attr_app_name_bytes)
        rescue UnsupportedEncodingException => e
          # Won't happen
        end
        return (Arrays == my_bytes)
      end
      return false
    end
    
    typesig { [] }
    # 
    # Returns a hashcode value for this GSSName.
    # 
    # @return a hashCode value
    def hash_code
      # 
      # XXX
      # In order to get this to work reliably and properly(!), obtain a
      # Kerberos name element for the name and then call hashCode on its
      # string representation. But this cannot be done if the nametype
      # is not one of those supported by the Kerberos provider and hence
      # this name cannot be imported by Kerberos. In that case return a
      # constant value!
      return 1
    end
    
    typesig { [Object] }
    def equals(another)
      begin
        # XXX This can lead to an infinite loop. Extract info
        # and create a GSSNameImpl with it.
        if (another.is_a?(GSSName))
          return equals(another)
        end
      rescue GSSException => e
        # Squelch it and return false
      end
      return false
    end
    
    typesig { [] }
    # 
    # Returns a flat name representation for this object. The name
    # format is defined in RFC 2743:
    # <pre>
    # Length           Name          Description
    # 2               TOK_ID          Token Identifier
    # For exported name objects, this
    # must be hex 04 01.
    # 2               MECH_OID_LEN    Length of the Mechanism OID
    # MECH_OID_LEN    MECH_OID        Mechanism OID, in DER
    # 4               NAME_LEN        Length of name
    # NAME_LEN        NAME            Exported name; format defined in
    # applicable mechanism draft.
    # </pre>
    # 
    # Note that it is not required to canonicalize a name before
    # calling export(). i.e., the name need not be an MN. If it is
    # not an MN, an implementation defined algorithm can be used for
    # choosing the mechanism which should export this name.
    # 
    # @return the flat name representation for this object
    # @exception GSSException with major codes NAME_NOT_MN, BAD_NAME,
    # BAD_NAME, FAILURE.
    def export
      if ((@mech_element).nil?)
        # Use default mech
        @mech_element = get_element(ProviderList::DEFAULT_MECH_OID)
      end
      mech_portion = @mech_element.export
      oid_bytes = nil
      oid = nil
      begin
        oid = ObjectIdentifier.new(@mech_element.get_mechanism.to_s)
      rescue IOException => e
        raise GSSExceptionImpl.new(GSSException::FAILURE, "Invalid OID String ")
      end
      dout = DerOutputStream.new
      begin
        dout.put_oid(oid)
      rescue IOException => e
        raise GSSExceptionImpl.new(GSSException::FAILURE, "Could not ASN.1 Encode " + (oid.to_s).to_s)
      end
      oid_bytes = dout.to_byte_array
      ret_val = Array.typed(::Java::Byte).new(2 + 2 + oid_bytes.attr_length + 4 + mech_portion.attr_length) { 0 }
      pos = 0
      ret_val[((pos += 1) - 1)] = 0x4
      ret_val[((pos += 1) - 1)] = 0x1
      ret_val[((pos += 1) - 1)] = (oid_bytes.attr_length >> 8)
      ret_val[((pos += 1) - 1)] = oid_bytes.attr_length
      System.arraycopy(oid_bytes, 0, ret_val, pos, oid_bytes.attr_length)
      pos += oid_bytes.attr_length
      ret_val[((pos += 1) - 1)] = (mech_portion.attr_length >> 24)
      ret_val[((pos += 1) - 1)] = (mech_portion.attr_length >> 16)
      ret_val[((pos += 1) - 1)] = (mech_portion.attr_length >> 8)
      ret_val[((pos += 1) - 1)] = mech_portion.attr_length
      System.arraycopy(mech_portion, 0, ret_val, pos, mech_portion.attr_length)
      return ret_val
    end
    
    typesig { [] }
    def to_s
      return @printable_name
    end
    
    typesig { [] }
    def get_string_name_type
      return @printable_name_type
    end
    
    typesig { [] }
    def is_anonymous
      if ((@printable_name_type).nil?)
        return false
      else
        return (GSSName::NT_ANONYMOUS == @printable_name_type)
      end
    end
    
    typesig { [] }
    def is_mn
      return true # Since always canonicalized for some mech
    end
    
    typesig { [Oid] }
    def get_element(mech_oid)
      synchronized(self) do
        ret_val = @elements.get(mech_oid)
        if ((ret_val).nil?)
          if (!(@app_name_str).nil?)
            ret_val = @gss_manager.get_name_element(@app_name_str, @app_name_type, mech_oid)
          else
            ret_val = @gss_manager.get_name_element(@app_name_bytes, @app_name_type, mech_oid)
          end
          @elements.put(mech_oid, ret_val)
        end
        return ret_val
      end
    end
    
    typesig { [] }
    def get_elements
      return HashSet.new(@elements.values)
    end
    
    class_module.module_eval {
      typesig { [Oid] }
      def get_name_type_str(name_type_oid)
        if ((name_type_oid).nil?)
          return "(NT is null)"
        end
        if ((name_type_oid == NT_USER_NAME))
          return "NT_USER_NAME"
        end
        if ((name_type_oid == NT_HOSTBASED_SERVICE))
          return "NT_HOSTBASED_SERVICE"
        end
        if ((name_type_oid == NT_EXPORT_NAME))
          return "NT_EXPORT_NAME"
        end
        if ((name_type_oid == GSSUtil::NT_GSS_KRB5_PRINCIPAL))
          return "NT_GSS_KRB5_PRINCIPAL"
        else
          return "Unknown"
        end
      end
    }
    
    private
    alias_method :initialize__gssname_impl, :initialize
  end
  
end
