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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal
  module AuthContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :EncryptionKey
      include_const ::Java::Util, :BitSet
    }
  end
  
  # public ReplayCache replayCache;
  class AuthContext 
    include_class_members AuthContextImports
    
    attr_accessor :remote_address
    alias_method :attr_remote_address, :remote_address
    undef_method :remote_address
    alias_method :attr_remote_address=, :remote_address=
    undef_method :remote_address=
    
    attr_accessor :remote_port
    alias_method :attr_remote_port, :remote_port
    undef_method :remote_port
    alias_method :attr_remote_port=, :remote_port=
    undef_method :remote_port=
    
    attr_accessor :local_address
    alias_method :attr_local_address, :local_address
    undef_method :local_address
    alias_method :attr_local_address=, :local_address=
    undef_method :local_address=
    
    attr_accessor :local_port
    alias_method :attr_local_port, :local_port
    undef_method :local_port
    alias_method :attr_local_port=, :local_port=
    undef_method :local_port=
    
    attr_accessor :key_block
    alias_method :attr_key_block, :key_block
    undef_method :key_block
    alias_method :attr_key_block=, :key_block=
    undef_method :key_block=
    
    attr_accessor :local_subkey
    alias_method :attr_local_subkey, :local_subkey
    undef_method :local_subkey
    alias_method :attr_local_subkey=, :local_subkey=
    undef_method :local_subkey=
    
    attr_accessor :remote_subkey
    alias_method :attr_remote_subkey, :remote_subkey
    undef_method :remote_subkey
    alias_method :attr_remote_subkey=, :remote_subkey=
    undef_method :remote_subkey=
    
    attr_accessor :auth_context_flags
    alias_method :attr_auth_context_flags, :auth_context_flags
    undef_method :auth_context_flags
    alias_method :attr_auth_context_flags=, :auth_context_flags=
    undef_method :auth_context_flags=
    
    attr_accessor :remote_seq_number
    alias_method :attr_remote_seq_number, :remote_seq_number
    undef_method :remote_seq_number
    alias_method :attr_remote_seq_number=, :remote_seq_number=
    undef_method :remote_seq_number=
    
    attr_accessor :local_seq_number
    alias_method :attr_local_seq_number, :local_seq_number
    undef_method :local_seq_number
    alias_method :attr_local_seq_number=, :local_seq_number=
    undef_method :local_seq_number=
    
    attr_accessor :authenticator
    alias_method :attr_authenticator, :authenticator
    undef_method :authenticator
    alias_method :attr_authenticator=, :authenticator=
    undef_method :authenticator=
    
    attr_accessor :req_cksum_type
    alias_method :attr_req_cksum_type, :req_cksum_type
    undef_method :req_cksum_type
    alias_method :attr_req_cksum_type=, :req_cksum_type=
    undef_method :req_cksum_type=
    
    attr_accessor :safe_cksum_type
    alias_method :attr_safe_cksum_type, :safe_cksum_type
    undef_method :safe_cksum_type
    alias_method :attr_safe_cksum_type=, :safe_cksum_type=
    undef_method :safe_cksum_type=
    
    attr_accessor :initialization_vector
    alias_method :attr_initialization_vector, :initialization_vector
    undef_method :initialization_vector
    alias_method :attr_initialization_vector=, :initialization_vector=
    undef_method :initialization_vector=
    
    typesig { [] }
    def initialize
      @remote_address = nil
      @remote_port = 0
      @local_address = nil
      @local_port = 0
      @key_block = nil
      @local_subkey = nil
      @remote_subkey = nil
      @auth_context_flags = nil
      @remote_seq_number = 0
      @local_seq_number = 0
      @authenticator = nil
      @req_cksum_type = 0
      @safe_cksum_type = 0
      @initialization_vector = nil
    end
    
    private
    alias_method :initialize__auth_context, :initialize
  end
  
end
