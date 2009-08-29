require "rjava"

# Copyright 2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Http
  module NTLMAuthSequenceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Http
      include_const ::Java::Io, :IOException
      include_const ::Sun::Misc, :BASE64Encoder
      include_const ::Sun::Misc, :BASE64Decoder
    }
  end
  
  # Hooks into Windows implementation of NTLM.
  # This class will be replaced if a cross-platform version of NTLM
  # is implemented in the future.
  class NTLMAuthSequence 
    include_class_members NTLMAuthSequenceImports
    
    attr_accessor :username
    alias_method :attr_username, :username
    undef_method :username
    alias_method :attr_username=, :username=
    undef_method :username=
    
    attr_accessor :password
    alias_method :attr_password, :password
    undef_method :password
    alias_method :attr_password=, :password=
    undef_method :password=
    
    attr_accessor :ntdomain
    alias_method :attr_ntdomain, :ntdomain
    undef_method :ntdomain
    alias_method :attr_ntdomain=, :ntdomain=
    undef_method :ntdomain=
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    attr_accessor :crd_handle
    alias_method :attr_crd_handle, :crd_handle
    undef_method :crd_handle
    alias_method :attr_crd_handle=, :crd_handle=
    undef_method :crd_handle=
    
    attr_accessor :ctx_handle
    alias_method :attr_ctx_handle, :ctx_handle
    undef_method :ctx_handle
    alias_method :attr_ctx_handle=, :ctx_handle=
    undef_method :ctx_handle=
    
    class_module.module_eval {
      when_class_loaded do
        init_first
      end
    }
    
    typesig { [String, String, String] }
    def initialize(username, password, ntdomain)
      @username = nil
      @password = nil
      @ntdomain = nil
      @state = 0
      @crd_handle = 0
      @ctx_handle = 0
      @username = username
      @password = password
      @ntdomain = ntdomain
      @state = 0
      @crd_handle = get_credentials_handle(username, ntdomain, password)
      if ((@crd_handle).equal?(0))
        raise IOException.new("could not get credentials handle")
      end
    end
    
    typesig { [String] }
    def get_auth_header(token)
      input = nil
      if (!(token).nil?)
        input = (BASE64Decoder.new).decode_buffer(token)
      end
      b = get_next_token(@crd_handle, input)
      if ((b).nil?)
        raise IOException.new("Internal authentication error")
      end
      return (B64Encoder.new).encode(b)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_net_www_protocol_http_NTLMAuthSequence_initFirst, [:pointer, :long], :void
      typesig { [] }
      def init_first
        JNI.__send__(:Java_sun_net_www_protocol_http_NTLMAuthSequence_initFirst, JNI.env, self.jni_id)
      end
    }
    
    JNI.native_method :Java_sun_net_www_protocol_http_NTLMAuthSequence_getCredentialsHandle, [:pointer, :long, :long, :long, :long], :int64
    typesig { [String, String, String] }
    def get_credentials_handle(user, domain, password)
      JNI.__send__(:Java_sun_net_www_protocol_http_NTLMAuthSequence_getCredentialsHandle, JNI.env, self.jni_id, user.jni_id, domain.jni_id, password.jni_id)
    end
    
    JNI.native_method :Java_sun_net_www_protocol_http_NTLMAuthSequence_getNextToken, [:pointer, :long, :int64, :long], :long
    typesig { [::Java::Long, Array.typed(::Java::Byte)] }
    def get_next_token(crd_handle, last_token)
      JNI.__send__(:Java_sun_net_www_protocol_http_NTLMAuthSequence_getNextToken, JNI.env, self.jni_id, crd_handle.to_int, last_token.jni_id)
    end
    
    private
    alias_method :initialize__ntlmauth_sequence, :initialize
  end
  
  class B64Encoder < NTLMAuthSequenceImports.const_get :BASE64Encoder
    include_class_members NTLMAuthSequenceImports
    
    typesig { [] }
    def bytes_per_line
      return 1024
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__b64encoder, :initialize
  end
  
end
