require "rjava"

# 
# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11::Wrapper
  module CK_TLS_PRF_PARAMSImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # CK_TLS_PRF_PARAMS from PKCS#11 v2.20.
  # 
  # @author  Andreas Sterbenz
  # @since   1.6
  class CK_TLS_PRF_PARAMS 
    include_class_members CK_TLS_PRF_PARAMSImports
    
    attr_accessor :p_seed
    alias_method :attr_p_seed, :p_seed
    undef_method :p_seed
    alias_method :attr_p_seed=, :p_seed=
    undef_method :p_seed=
    
    attr_accessor :p_label
    alias_method :attr_p_label, :p_label
    undef_method :p_label
    alias_method :attr_p_label=, :p_label=
    undef_method :p_label=
    
    attr_accessor :p_output
    alias_method :attr_p_output, :p_output
    undef_method :p_output
    alias_method :attr_p_output=, :p_output=
    undef_method :p_output=
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), Array.typed(::Java::Byte)] }
    def initialize(p_seed, p_label, p_output)
      @p_seed = nil
      @p_label = nil
      @p_output = nil
      @p_seed = p_seed
      @p_label = p_label
      @p_output = p_output
    end
    
    private
    alias_method :initialize__ck_tls_prf_params, :initialize
  end
  
end
