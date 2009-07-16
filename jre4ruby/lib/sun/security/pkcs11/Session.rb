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
module Sun::Security::Pkcs11
  module SessionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include_const ::Java::Util::Concurrent::Atomic, :AtomicInteger
      include ::Java::Security
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # A session object. Sessions are obtained via the SessionManager,
  # see there for details. Most code will only ever need one method in
  # this class, the id() method to obtain the session id.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class Session 
    include_class_members SessionImports
    include JavaComparable
    
    class_module.module_eval {
      # time after which to close idle sessions, in milliseconds (3 minutes)
      const_set_lazy(:MAX_IDLE_TIME) { 3 * 60 * 1000 }
      const_attr_reader  :MAX_IDLE_TIME
    }
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # session id
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    # number of objects created within this session
    attr_accessor :created_objects
    alias_method :attr_created_objects, :created_objects
    undef_method :created_objects
    alias_method :attr_created_objects=, :created_objects=
    undef_method :created_objects=
    
    # time this session was last used
    # not synchronized/volatile for performance, so may be unreliable
    # this could lead to idle sessions being closed early, but that is harmless
    attr_accessor :last_access
    alias_method :attr_last_access, :last_access
    undef_method :last_access
    alias_method :attr_last_access=, :last_access=
    undef_method :last_access=
    
    typesig { [Token, ::Java::Long] }
    def initialize(token, id)
      @token = nil
      @id = 0
      @created_objects = nil
      @last_access = 0
      @token = token
      @id = id
      @created_objects = AtomicInteger.new
      id
    end
    
    typesig { [Session] }
    def compare_to(other)
      if ((@last_access).equal?(other.attr_last_access))
        return 0
      else
        return (@last_access < other.attr_last_access) ? -1 : 1
      end
    end
    
    typesig { [::Java::Long] }
    def is_live(current_time)
      return current_time - @last_access < MAX_IDLE_TIME
    end
    
    typesig { [] }
    def id_internal
      return @id
    end
    
    typesig { [] }
    def id
      if ((@token.is_present(self)).equal?(false))
        raise ProviderException.new("Token has been removed")
      end
      @last_access = System.current_time_millis
      return @id
    end
    
    typesig { [] }
    def add_object
      n = @created_objects.increment_and_get
      # XXX update statistics in session manager if n == 1
    end
    
    typesig { [] }
    def remove_object
      n = @created_objects.decrement_and_get
      if ((n).equal?(0))
        @token.attr_session_manager.demote_obj_session(self)
      else
        if (n < 0)
          raise ProviderException.new("Internal error: objects created " + (n).to_s)
        end
      end
    end
    
    typesig { [] }
    def has_objects
      return !(@created_objects.get).equal?(0)
    end
    
    private
    alias_method :initialize__session, :initialize
  end
  
end
