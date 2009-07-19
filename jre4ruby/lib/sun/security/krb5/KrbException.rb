require "rjava"

# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5
  module KrbExceptionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5::Internal, :Krb5
      include_const ::Sun::Security::Krb5::Internal, :KRBError
    }
  end
  
  class KrbException < KrbExceptionImports.const_get :Exception
    include_class_members KrbExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -4993302876451928596 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :return_code
    alias_method :attr_return_code, :return_code
    undef_method :return_code
    alias_method :attr_return_code=, :return_code=
    undef_method :return_code=
    
    attr_accessor :error
    alias_method :attr_error, :error
    undef_method :error
    alias_method :attr_error=, :error=
    undef_method :error=
    
    typesig { [String] }
    def initialize(s)
      @return_code = 0
      @error = nil
      super(s)
    end
    
    typesig { [::Java::Int] }
    def initialize(i)
      @return_code = 0
      @error = nil
      super()
      @return_code = i
    end
    
    typesig { [::Java::Int, String] }
    def initialize(i, s)
      initialize__krb_exception(s)
      @return_code = i
    end
    
    typesig { [KRBError] }
    def initialize(e)
      @return_code = 0
      @error = nil
      super()
      @return_code = e.get_error_code
      @error = e
    end
    
    typesig { [KRBError, String] }
    def initialize(e, s)
      initialize__krb_exception(s)
      @return_code = e.get_error_code
      @error = e
    end
    
    typesig { [] }
    def get_error
      return @error
    end
    
    typesig { [] }
    def return_code
      return @return_code
    end
    
    typesig { [] }
    def return_code_symbol
      return return_code_symbol(@return_code)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def return_code_symbol(i)
        return "not yet implemented"
      end
    }
    
    typesig { [] }
    def return_code_message
      return Krb5.get_error_message(@return_code)
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      def error_message(i)
        return Krb5.get_error_message(i)
      end
    }
    
    typesig { [] }
    def krb_error_message
      strbuf = StringBuffer.new("krb_error " + (@return_code).to_s)
      msg = get_message
      if (!(msg).nil?)
        strbuf.append(" ")
        strbuf.append(msg)
      end
      return strbuf.to_s
    end
    
    typesig { [] }
    # Returns messages like:
    # "Integrity check on decrypted field failed (31) - \
    # Could not decrypt service ticket"
    # If the error code is 0 then the first half is skipped.
    def get_message
      message = StringBuffer.new
      return_code_ = return_code
      if (!(return_code_).equal?(0))
        message.append(return_code_message)
        message.append(" (").append(return_code).append(Character.new(?).ord))
      end
      cons_message = super
      if (!(cons_message).nil? && !(cons_message.length).equal?(0))
        if (!(return_code_).equal?(0))
          message.append(" - ")
        end
        message.append(cons_message)
      end
      return message.to_s
    end
    
    typesig { [] }
    def to_s
      return ("KrbException: " + (get_message).to_s)
    end
    
    typesig { [] }
    def hash_code
      result = 17
      result = 37 * result + @return_code
      if (!(@error).nil?)
        result = 37 * result + @error.hash_code
      end
      return result
    end
    
    typesig { [Object] }
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(KrbException)))
        return false
      end
      other = obj
      if (!(@return_code).equal?(other.attr_return_code))
        return false
      end
      return ((@error).nil?) ? ((other.attr_error).nil?) : ((@error == other.attr_error))
    end
    
    private
    alias_method :initialize__krb_exception, :initialize
  end
  
end
