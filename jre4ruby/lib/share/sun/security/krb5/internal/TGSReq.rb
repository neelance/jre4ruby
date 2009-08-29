require "rjava"

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
module Sun::Security::Krb5::Internal
  module TGSReqImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  class TGSReq < TGSReqImports.const_get :KDCReq
    include_class_members TGSReqImports
    
    typesig { [Array.typed(PAData), KDCReqBody] }
    def initialize(new_p_adata, new_req_body)
      super(new_p_adata, new_req_body, Krb5::KRB_TGS_REQ)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def initialize(data)
      super()
      init(DerValue.new(data))
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      super()
      init(encoding)
    end
    
    typesig { [DerValue] }
    def init(encoding)
      init(encoding, Krb5::KRB_TGS_REQ)
    end
    
    private
    alias_method :initialize__tgsreq, :initialize
  end
  
end
