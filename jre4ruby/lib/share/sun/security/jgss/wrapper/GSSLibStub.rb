require "rjava"

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
module Sun::Security::Jgss::Wrapper
  module GSSLibStubImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss::Wrapper
      include_const ::Java::Util, :Hashtable
      include_const ::Org::Ietf::Jgss, :Oid
      include_const ::Org::Ietf::Jgss, :GSSName
      include_const ::Org::Ietf::Jgss, :ChannelBinding
      include_const ::Org::Ietf::Jgss, :MessageProp
      include_const ::Org::Ietf::Jgss, :GSSException
      include_const ::Sun::Security::Jgss, :GSSUtil
    }
  end
  
  # This class is essentially a JNI calling stub for all wrapper classes.
  # 
  # @author Valerie Peng
  # @since 1.6
  class GSSLibStub 
    include_class_members GSSLibStubImports
    
    attr_accessor :mech
    alias_method :attr_mech, :mech
    undef_method :mech
    alias_method :attr_mech=, :mech=
    undef_method :mech=
    
    attr_accessor :p_mech
    alias_method :attr_p_mech, :p_mech
    undef_method :p_mech
    alias_method :attr_p_mech=, :p_mech=
    undef_method :p_mech=
    
    class_module.module_eval {
      JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_init, [:pointer, :long, :long], :int8
      typesig { [String] }
      # Initialization routine to dynamically load function pointers.
      # 
      # @param library name to dlopen
      # @return true if succeeded, false otherwise.
      def init(lib)
        JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_init, JNI.env, self.jni_id, lib.jni_id) != 0
      end
      
      JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_getMechPtr, [:pointer, :long, :long], :int64
      typesig { [Array.typed(::Java::Byte)] }
      def get_mech_ptr(oid_der_encoding)
        JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_getMechPtr, JNI.env, self.jni_id, oid_der_encoding.jni_id)
      end
      
      JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_indicateMechs, [:pointer, :long], :long
      typesig { [] }
      # Miscellaneous routines
      def indicate_mechs
        JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_indicateMechs, JNI.env, self.jni_id)
      end
    }
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_inquireNamesForMech, [:pointer, :long], :long
    typesig { [] }
    def inquire_names_for_mech
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_inquireNamesForMech, JNI.env, self.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_releaseName, [:pointer, :long, :int64], :void
    typesig { [::Java::Long] }
    # Name related routines
    def release_name(p_name)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_releaseName, JNI.env, self.jni_id, p_name.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_importName, [:pointer, :long, :long, :long], :int64
    typesig { [Array.typed(::Java::Byte), Oid] }
    def import_name(name, type)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_importName, JNI.env, self.jni_id, name.jni_id, type.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_compareName, [:pointer, :long, :int64, :int64], :int8
    typesig { [::Java::Long, ::Java::Long] }
    def compare_name(p_name1, p_name2)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_compareName, JNI.env, self.jni_id, p_name1.to_int, p_name2.to_int) != 0
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_canonicalizeName, [:pointer, :long, :int64], :int64
    typesig { [::Java::Long] }
    def canonicalize_name(p_name)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_canonicalizeName, JNI.env, self.jni_id, p_name.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_exportName, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    def export_name(p_name)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_exportName, JNI.env, self.jni_id, p_name.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_displayName, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    def display_name(p_name)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_displayName, JNI.env, self.jni_id, p_name.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_acquireCred, [:pointer, :long, :int64, :int32, :int32], :int64
    typesig { [::Java::Long, ::Java::Int, ::Java::Int] }
    # Credential related routines
    def acquire_cred(p_name, lifetime, usage)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_acquireCred, JNI.env, self.jni_id, p_name.to_int, lifetime.to_int, usage.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_releaseCred, [:pointer, :long, :int64], :int64
    typesig { [::Java::Long] }
    def release_cred(p_cred)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_releaseCred, JNI.env, self.jni_id, p_cred.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_getCredName, [:pointer, :long, :int64], :int64
    typesig { [::Java::Long] }
    def get_cred_name(p_cred)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_getCredName, JNI.env, self.jni_id, p_cred.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_getCredTime, [:pointer, :long, :int64], :int32
    typesig { [::Java::Long] }
    def get_cred_time(p_cred)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_getCredTime, JNI.env, self.jni_id, p_cred.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_getCredUsage, [:pointer, :long, :int64], :int32
    typesig { [::Java::Long] }
    def get_cred_usage(p_cred)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_getCredUsage, JNI.env, self.jni_id, p_cred.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_importContext, [:pointer, :long, :long], :long
    typesig { [Array.typed(::Java::Byte)] }
    # Context related routines
    def import_context(inter_proc_token)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_importContext, JNI.env, self.jni_id, inter_proc_token.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_initContext, [:pointer, :long, :int64, :int64, :long, :long, :long], :long
    typesig { [::Java::Long, ::Java::Long, ChannelBinding, Array.typed(::Java::Byte), NativeGSSContext] }
    def init_context(p_cred, target_name, cb, in_token, context)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_initContext, JNI.env, self.jni_id, p_cred.to_int, target_name.to_int, cb.jni_id, in_token.jni_id, context.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_acceptContext, [:pointer, :long, :int64, :long, :long, :long], :long
    typesig { [::Java::Long, ChannelBinding, Array.typed(::Java::Byte), NativeGSSContext] }
    def accept_context(p_cred, cb, in_token, context)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_acceptContext, JNI.env, self.jni_id, p_cred.to_int, cb.jni_id, in_token.jni_id, context.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_inquireContext, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    def inquire_context(p_context)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_inquireContext, JNI.env, self.jni_id, p_context.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_getContextMech, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    def get_context_mech(p_context)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_getContextMech, JNI.env, self.jni_id, p_context.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_getContextName, [:pointer, :long, :int64, :int8], :int64
    typesig { [::Java::Long, ::Java::Boolean] }
    def get_context_name(p_context, is_src)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_getContextName, JNI.env, self.jni_id, p_context.to_int, is_src ? 1 : 0)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_getContextTime, [:pointer, :long, :int64], :int32
    typesig { [::Java::Long] }
    def get_context_time(p_context)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_getContextTime, JNI.env, self.jni_id, p_context.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_deleteContext, [:pointer, :long, :int64], :int64
    typesig { [::Java::Long] }
    def delete_context(p_context)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_deleteContext, JNI.env, self.jni_id, p_context.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_wrapSizeLimit, [:pointer, :long, :int64, :int32, :int32, :int32], :int32
    typesig { [::Java::Long, ::Java::Int, ::Java::Int, ::Java::Int] }
    def wrap_size_limit(p_context, flags, qop, out_size)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_wrapSizeLimit, JNI.env, self.jni_id, p_context.to_int, flags.to_int, qop.to_int, out_size.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_exportContext, [:pointer, :long, :int64], :long
    typesig { [::Java::Long] }
    def export_context(p_context)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_exportContext, JNI.env, self.jni_id, p_context.to_int)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_getMic, [:pointer, :long, :int64, :int32, :long], :long
    typesig { [::Java::Long, ::Java::Int, Array.typed(::Java::Byte)] }
    def get_mic(p_context, qop, msg)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_getMic, JNI.env, self.jni_id, p_context.to_int, qop.to_int, msg.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_verifyMic, [:pointer, :long, :int64, :long, :long, :long], :void
    typesig { [::Java::Long, Array.typed(::Java::Byte), Array.typed(::Java::Byte), MessageProp] }
    def verify_mic(p_context, token, msg, prop)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_verifyMic, JNI.env, self.jni_id, p_context.to_int, token.jni_id, msg.jni_id, prop.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_wrap, [:pointer, :long, :int64, :long, :long], :long
    typesig { [::Java::Long, Array.typed(::Java::Byte), MessageProp] }
    def wrap(p_context, msg, prop)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_wrap, JNI.env, self.jni_id, p_context.to_int, msg.jni_id, prop.jni_id)
    end
    
    JNI.load_native_method :Java_sun_security_jgss_wrapper_GSSLibStub_unwrap, [:pointer, :long, :int64, :long, :long], :long
    typesig { [::Java::Long, Array.typed(::Java::Byte), MessageProp] }
    def unwrap(p_context, msg_token, prop)
      JNI.call_native_method(:Java_sun_security_jgss_wrapper_GSSLibStub_unwrap, JNI.env, self.jni_id, p_context.to_int, msg_token.jni_id, prop.jni_id)
    end
    
    class_module.module_eval {
      
      def table
        defined?(@@table) ? @@table : @@table= Hashtable.new(5)
      end
      alias_method :attr_table, :table
      
      def table=(value)
        @@table = value
      end
      alias_method :attr_table=, :table=
      
      typesig { [Oid] }
      def get_instance(mech)
        s = self.attr_table.get(mech)
        if ((s).nil?)
          s = GSSLibStub.new(mech)
          self.attr_table.put(mech, s)
        end
        return s
      end
    }
    
    typesig { [Oid] }
    def initialize(mech)
      @mech = nil
      @p_mech = 0
      SunNativeProvider.debug("Created GSSLibStub for mech " + RJava.cast_to_string(mech))
      @mech = mech
      @p_mech = get_mech_ptr(mech.get_der)
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(GSSLibStub)))
        return false
      end
      return ((@mech == (obj).get_mech))
    end
    
    typesig { [] }
    def hash_code
      return @mech.hash_code
    end
    
    typesig { [] }
    def get_mech
      return @mech
    end
    
    private
    alias_method :initialize__gsslib_stub, :initialize
  end
  
end
