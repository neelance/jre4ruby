require "rjava"

# 
# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AccessDescriptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Security::Cert
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # 
  # @author      Ram Marti
  class AccessDescription 
    include_class_members AccessDescriptionImports
    
    attr_accessor :myhash
    alias_method :attr_myhash, :myhash
    undef_method :myhash
    alias_method :attr_myhash=, :myhash=
    undef_method :myhash=
    
    attr_accessor :access_method
    alias_method :attr_access_method, :access_method
    undef_method :access_method
    alias_method :attr_access_method=, :access_method=
    undef_method :access_method=
    
    attr_accessor :access_location
    alias_method :attr_access_location, :access_location
    undef_method :access_location
    alias_method :attr_access_location=, :access_location=
    undef_method :access_location=
    
    class_module.module_eval {
      const_set_lazy(:Ad_OCSP_Id) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 48, 1])) }
      const_attr_reader  :Ad_OCSP_Id
      
      const_set_lazy(:Ad_CAISSUERS_Id) { ObjectIdentifier.new_internal(Array.typed(::Java::Int).new([1, 3, 6, 1, 5, 5, 7, 48, 2])) }
      const_attr_reader  :Ad_CAISSUERS_Id
    }
    
    typesig { [DerValue] }
    def initialize(der_value)
      @myhash = -1
      @access_method = nil
      @access_location = nil
      der_in = der_value.get_data
      @access_method = der_in.get_oid
      @access_location = GeneralName.new(der_in.get_der_value)
    end
    
    typesig { [] }
    def get_access_method
      return @access_method
    end
    
    typesig { [] }
    def get_access_location
      return @access_location
    end
    
    typesig { [DerOutputStream] }
    def encode(out)
      tmp = DerOutputStream.new
      tmp.put_oid(@access_method)
      @access_location.encode(tmp)
      out.write(DerValue.attr_tag_sequence, tmp)
    end
    
    typesig { [] }
    def hash_code
      if ((@myhash).equal?(-1))
        @myhash = @access_method.hash_code + @access_location.hash_code
      end
      return @myhash
    end
    
    typesig { [Object] }
    def equals(obj)
      if ((obj).nil? || (!(obj.is_a?(AccessDescription))))
        return false
      end
      that = obj
      if ((self).equal?(that))
        return true
      end
      return ((@access_method == that.get_access_method) && (@access_location == that.get_access_location))
    end
    
    typesig { [] }
    def to_s
      return ("accessMethod: " + (@access_method.to_s).to_s + "\n   accessLocation: " + (@access_location.to_s).to_s)
    end
    
    private
    alias_method :initialize__access_description, :initialize
  end
  
end
