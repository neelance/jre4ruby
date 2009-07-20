require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss::Wrapper
  module GSSNameElementImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Wrapper
      include ::Org::Ietf::Jgss
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :Security
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :UnsupportedEncodingException
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Sun::Security::Util, :DerInputStream
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Jgss, :GSSUtil
      include_const ::Sun::Security::Jgss, :GSSExceptionImpl
      include_const ::Sun::Security::Jgss::Spi, :GSSNameSpi
    }
  end
  
  # This class is essentially a wrapper class for the gss_name_t
  # structure of the native GSS library.
  # @author Valerie Peng
  # @since 1.6
  class GSSNameElement 
    include_class_members GSSNameElementImports
    include GSSNameSpi
    
    attr_accessor :p_name
    alias_method :attr_p_name, :p_name
    undef_method :p_name
    alias_method :attr_p_name=, :p_name=
    undef_method :p_name=
    
    # Pointer to the gss_name_t structure
    attr_accessor :printable_name
    alias_method :attr_printable_name, :printable_name
    undef_method :printable_name
    alias_method :attr_printable_name=, :printable_name=
    undef_method :printable_name=
    
    attr_accessor :printable_type
    alias_method :attr_printable_type, :printable_type
    undef_method :printable_type
    alias_method :attr_printable_type=, :printable_type=
    undef_method :printable_type=
    
    attr_accessor :c_stub
    alias_method :attr_c_stub, :c_stub
    undef_method :c_stub
    alias_method :attr_c_stub=, :c_stub=
    undef_method :c_stub=
    
    class_module.module_eval {
      const_set_lazy(:DEF_ACCEPTOR) { GSSNameElement.new }
      const_attr_reader  :DEF_ACCEPTOR
      
      typesig { [Oid, GSSLibStub] }
      def get_native_name_type(name_type, stub)
        if ((GSSUtil::NT_GSS_KRB5_PRINCIPAL == name_type) || (GSSName::NT_HOSTBASED_SERVICE == name_type))
          supported_nts = nil
          begin
            supported_nts = stub.inquire_names_for_mech
          rescue GSSException => ge
            if ((ge.get_major).equal?(GSSException::BAD_MECH) && GSSUtil.is_sp_nego_mech(stub.get_mech))
              # Workaround known Heimdal issue and retry with KRB5
              begin
                stub = GSSLibStub.get_instance(GSSUtil::GSS_KRB5_MECH_OID)
                supported_nts = stub.inquire_names_for_mech
              rescue GSSException => ge2
                # Should never happen
                SunNativeProvider.debug("Name type list unavailable: " + (ge2.get_major_string).to_s)
              end
            else
              SunNativeProvider.debug("Name type list unavailable: " + (ge.get_major_string).to_s)
            end
          end
          if (!(supported_nts).nil?)
            i = 0
            while i < supported_nts.attr_length
              if ((supported_nts[i] == name_type))
                return name_type
              end
              i += 1
            end
            # Special handling the specified name type
            if ((GSSUtil::NT_GSS_KRB5_PRINCIPAL == name_type))
              SunNativeProvider.debug("Override " + (name_type).to_s + " with mechanism default(null)")
              return nil # Use mechanism specific default
            else
              SunNativeProvider.debug("Override " + (name_type).to_s + " with " + (GSSUtil::NT_HOSTBASED_SERVICE2).to_s)
              return GSSUtil::NT_HOSTBASED_SERVICE2
            end
          end
        end
        return name_type
      end
    }
    
    typesig { [] }
    def initialize
      @p_name = 0
      @printable_name = nil
      @printable_type = nil
      @c_stub = nil
      @printable_name = "<DEFAULT ACCEPTOR>"
    end
    
    typesig { [::Java::Long, GSSLibStub] }
    def initialize(p_native_name, stub)
      @p_name = 0
      @printable_name = nil
      @printable_type = nil
      @c_stub = nil
      raise AssertError if not ((!(stub).nil?))
      if ((p_native_name).equal?(0))
        raise GSSException.new(GSSException::BAD_NAME)
      end
      # Note: pNativeName is assumed to be a MN.
      @p_name = p_native_name
      @c_stub = stub
      set_printables
    end
    
    typesig { [Array.typed(::Java::Byte), Oid, GSSLibStub] }
    def initialize(name_bytes, name_type, stub)
      @p_name = 0
      @printable_name = nil
      @printable_type = nil
      @c_stub = nil
      raise AssertError if not ((!(stub).nil?))
      if ((name_bytes).nil?)
        raise GSSException.new(GSSException::BAD_NAME)
      end
      @c_stub = stub
      name = name_bytes
      if (!(name_type).nil?)
        # Special handling the specified name type if
        # necessary
        name_type = get_native_name_type(name_type, stub)
        if ((GSSName::NT_EXPORT_NAME == name_type))
          # Need to add back the mech Oid portion (stripped
          # off by GSSNameImpl class prior to calling this
          # method) for "NT_EXPORT_NAME"
          mech_bytes = nil
          dout = DerOutputStream.new
          mech = @c_stub.get_mech
          begin
            dout.put_oid(ObjectIdentifier.new(mech.to_s))
          rescue IOException => e
            raise GSSExceptionImpl.new(GSSException::FAILURE, e)
          end
          mech_bytes = dout.to_byte_array
          name = Array.typed(::Java::Byte).new(2 + 2 + mech_bytes.attr_length + 4 + name_bytes.attr_length) { 0 }
          pos = 0
          name[((pos += 1) - 1)] = 0x4
          name[((pos += 1) - 1)] = 0x1
          name[((pos += 1) - 1)] = (mech_bytes.attr_length >> 8)
          name[((pos += 1) - 1)] = mech_bytes.attr_length
          System.arraycopy(mech_bytes, 0, name, pos, mech_bytes.attr_length)
          pos += mech_bytes.attr_length
          name[((pos += 1) - 1)] = (name_bytes.attr_length >> 24)
          name[((pos += 1) - 1)] = (name_bytes.attr_length >> 16)
          name[((pos += 1) - 1)] = (name_bytes.attr_length >> 8)
          name[((pos += 1) - 1)] = name_bytes.attr_length
          System.arraycopy(name_bytes, 0, name, pos, name_bytes.attr_length)
        end
      end
      @p_name = @c_stub.import_name(name, name_type)
      set_printables
      SunNativeProvider.debug("Imported " + @printable_name + " w/ type " + (@printable_type).to_s)
    end
    
    typesig { [] }
    def set_printables
      printables = nil
      printables = @c_stub.display_name(@p_name)
      raise AssertError if not (((!(printables).nil?) && ((printables.attr_length).equal?(2))))
      @printable_name = (printables[0]).to_s
      raise AssertError if not ((!(@printable_name).nil?))
      @printable_type = printables[1]
      if ((@printable_type).nil?)
        @printable_type = GSSName::NT_USER_NAME
      end
    end
    
    typesig { [] }
    # Need to be public for GSSUtil.getSubject()
    def get_krb_name
      m_name = 0
      stub = @c_stub
      if (!GSSUtil.is_kerberos_mech(@c_stub.get_mech))
        stub = GSSLibStub.get_instance(GSSUtil::GSS_KRB5_MECH_OID)
      end
      m_name = stub.canonicalize_name(@p_name)
      printables2 = stub.display_name(m_name)
      stub.release_name(m_name)
      SunNativeProvider.debug("Got kerberized name: " + (printables2[0]).to_s)
      return printables2[0]
    end
    
    typesig { [] }
    def get_provider
      return SunNativeProvider::INSTANCE
    end
    
    typesig { [GSSNameSpi] }
    def equals(other)
      if (!(other.is_a?(GSSNameElement)))
        return false
      end
      return @c_stub.compare_name(@p_name, (other).attr_p_name)
    end
    
    typesig { [Object] }
    def equals(other)
      if (!(other.is_a?(GSSNameElement)))
        return false
      end
      begin
        return equals(other)
      rescue GSSException => ex
        return false
      end
    end
    
    typesig { [] }
    def hash_code
      return Long.new(@p_name).hash_code
    end
    
    typesig { [] }
    def export
      name_val = @c_stub.export_name(@p_name)
      # Need to strip off the mech Oid portion of the exported
      # bytes since GSSNameImpl class will subsequently add it.
      pos = 0
      if ((!(name_val[((pos += 1) - 1)]).equal?(0x4)) || (!(name_val[((pos += 1) - 1)]).equal?(0x1)))
        raise GSSException.new(GSSException::BAD_NAME)
      end
      mech_oid_len = (((0xff & name_val[((pos += 1) - 1)]) << 8) | (0xff & name_val[((pos += 1) - 1)]))
      temp = nil
      begin
        din = DerInputStream.new(name_val, pos, mech_oid_len)
        temp = ObjectIdentifier.new(din)
      rescue IOException => e
        raise GSSExceptionImpl.new(GSSException::BAD_NAME, e)
      end
      mech2 = Oid.new(temp.to_s)
      raise AssertError if not (((mech2 == get_mechanism)))
      pos += mech_oid_len
      mech_portion_len = (((0xff & name_val[((pos += 1) - 1)]) << 24) | ((0xff & name_val[((pos += 1) - 1)]) << 16) | ((0xff & name_val[((pos += 1) - 1)]) << 8) | (0xff & name_val[((pos += 1) - 1)]))
      mech_portion = Array.typed(::Java::Byte).new(mech_portion_len) { 0 }
      System.arraycopy(name_val, pos, mech_portion, 0, mech_portion_len)
      return mech_portion
    end
    
    typesig { [] }
    def get_mechanism
      return @c_stub.get_mech
    end
    
    typesig { [] }
    def to_s
      return @printable_name
    end
    
    typesig { [] }
    def get_string_name_type
      return @printable_type
    end
    
    typesig { [] }
    def is_anonymous_name
      return ((GSSName::NT_ANONYMOUS == @printable_type))
    end
    
    typesig { [] }
    def dispose
      if (!(@p_name).equal?(0))
        @c_stub.release_name(@p_name)
        @p_name = 0
      end
    end
    
    typesig { [] }
    def finalize
      dispose
    end
    
    private
    alias_method :initialize__gssname_element, :initialize
  end
  
end
