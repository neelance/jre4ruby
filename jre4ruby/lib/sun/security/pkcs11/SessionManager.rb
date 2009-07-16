require "rjava"

# 
# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SessionManagerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include_const ::Java::Security, :ProviderException
      include_const ::Sun::Security::Util, :Debug
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # Session manager. There is one session manager object per PKCS#11
  # provider. It allows code to checkout a session, release it
  # back to the pool, or force it to be closed.
  # 
  # The session manager pools sessions to minimize the number of
  # C_OpenSession() and C_CloseSession() that have to be made. It
  # maintains two pools: one for "object" sessions and one for
  # "operation" sessions.
  # 
  # The reason for this separation is how PKCS#11 deals with session objects.
  # It defines that when a session is closed, all objects created within
  # that session are destroyed. In other words, we may never close a session
  # while a Key created it in is still in use. We would like to keep the
  # number of such sessions low. Note that we occasionally want to explicitly
  # close a session, see P11Signature.
  # 
  # NOTE that all sessions obtained from this class MUST be returned using
  # either releaseSession() or closeSession() using a finally block or a
  # finalizer where appropriate. Otherwise, they will be "lost", i.e. there
  # will be a resource leak eventually leading to exhaustion.
  # 
  # Note that sessions are automatically closed when they are not used for a
  # period of time, see Session.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class SessionManager 
    include_class_members SessionManagerImports
    
    class_module.module_eval {
      const_set_lazy(:DEFAULT_MAX_SESSIONS) { 32 }
      const_attr_reader  :DEFAULT_MAX_SESSIONS
      
      const_set_lazy(:Debug) { Debug.get_instance("pkcs11") }
      const_attr_reader  :Debug
    }
    
    # token instance
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # maximum number of sessions to open with this token
    attr_accessor :max_sessions
    alias_method :attr_max_sessions, :max_sessions
    undef_method :max_sessions
    alias_method :attr_max_sessions=, :max_sessions=
    undef_method :max_sessions=
    
    # total number of active sessions
    attr_accessor :active_sessions
    alias_method :attr_active_sessions, :active_sessions
    undef_method :active_sessions
    alias_method :attr_active_sessions=, :active_sessions=
    undef_method :active_sessions=
    
    # pool of available object sessions
    attr_accessor :obj_sessions
    alias_method :attr_obj_sessions, :obj_sessions
    undef_method :obj_sessions
    alias_method :attr_obj_sessions=, :obj_sessions=
    undef_method :obj_sessions=
    
    # pool of available operation sessions
    attr_accessor :op_sessions
    alias_method :attr_op_sessions, :op_sessions
    undef_method :op_sessions
    alias_method :attr_op_sessions=, :op_sessions=
    undef_method :op_sessions=
    
    # maximum number of active sessions during this invocation, for debugging
    attr_accessor :max_active_sessions
    alias_method :attr_max_active_sessions, :max_active_sessions
    undef_method :max_active_sessions
    alias_method :attr_max_active_sessions=, :max_active_sessions=
    undef_method :max_active_sessions=
    
    # flags to use in the C_OpenSession() call
    attr_accessor :open_session_flags
    alias_method :attr_open_session_flags, :open_session_flags
    undef_method :open_session_flags
    alias_method :attr_open_session_flags=, :open_session_flags=
    undef_method :open_session_flags=
    
    typesig { [Token] }
    def initialize(token)
      @token = nil
      @max_sessions = 0
      @active_sessions = 0
      @obj_sessions = nil
      @op_sessions = nil
      @max_active_sessions = 0
      @open_session_flags = 0
      n = 0
      if (token.is_write_protected)
        @open_session_flags = CKF_SERIAL_SESSION
        n = token.attr_token_info.attr_ul_max_session_count
      else
        @open_session_flags = CKF_SERIAL_SESSION | CKF_RW_SESSION
        n = token.attr_token_info.attr_ul_max_rw_session_count
      end
      if ((n).equal?(CK_EFFECTIVELY_INFINITE))
        n = JavaInteger::MAX_VALUE
      else
        if (((n).equal?(CK_UNAVAILABLE_INFORMATION)) || (n < 0))
          # choose an arbitrary concrete value
          n = DEFAULT_MAX_SESSIONS
        end
      end
      @max_sessions = RJava.cast_to_int(Math.min(n, JavaInteger::MAX_VALUE))
      @token = token
      @obj_sessions = Pool.new(self)
      @op_sessions = Pool.new(self)
    end
    
    typesig { [] }
    # returns whether only a fairly low number of sessions are
    # supported by this token.
    def low_max_sessions
      return (@max_sessions <= DEFAULT_MAX_SESSIONS)
    end
    
    typesig { [] }
    def get_obj_session
      synchronized(self) do
        session = @obj_sessions.poll
        if (!(session).nil?)
          return ensure_valid(session)
        end
        session = @op_sessions.poll
        if (!(session).nil?)
          return ensure_valid(session)
        end
        session = open_session
        return ensure_valid(session)
      end
    end
    
    typesig { [] }
    def get_op_session
      synchronized(self) do
        session = @op_sessions.poll
        if (!(session).nil?)
          return ensure_valid(session)
        end
        # create a new session rather than re-using an obj session
        # that avoids potential expensive cancels() for Signatures & RSACipher
        if (@active_sessions < @max_sessions)
          session = open_session
          return ensure_valid(session)
        end
        session = @obj_sessions.poll
        if (!(session).nil?)
          return ensure_valid(session)
        end
        raise ProviderException.new("Could not obtain session")
      end
    end
    
    typesig { [Session] }
    def ensure_valid(session)
      session.id
      return session
    end
    
    typesig { [Session] }
    def kill_session(session)
      synchronized(self) do
        if (((session).nil?) || ((@token.is_valid).equal?(false)))
          return nil
        end
        if (!(Debug).nil?)
          location = Exception.new.get_stack_trace[2].to_s
          System.out.println("Killing session (" + location + ") active: " + (@active_sessions).to_s)
        end
        begin
          close_session(session)
          return nil
        rescue PKCS11Exception => e
          raise ProviderException.new(e)
        end
      end
    end
    
    typesig { [Session] }
    def release_session(session)
      synchronized(self) do
        if (((session).nil?) || ((@token.is_valid).equal?(false)))
          return nil
        end
        if (session.has_objects)
          @obj_sessions.release(session)
        else
          @op_sessions.release(session)
        end
        return nil
      end
    end
    
    typesig { [Session] }
    def demote_obj_session(session)
      synchronized(self) do
        if ((@token.is_valid).equal?(false))
          return
        end
        if (!(Debug).nil?)
          System.out.println("Demoting session, active: " + (@active_sessions).to_s)
        end
        present = @obj_sessions.remove(session)
        if ((present).equal?(false))
          # session is currently in use
          # will be added to correct pool on release, nothing to do now
          return
        end
        @op_sessions.release(session)
      end
    end
    
    typesig { [] }
    def open_session
      if (@active_sessions >= @max_sessions)
        raise ProviderException.new("No more sessions available")
      end
      id_ = @token.attr_p11._c_open_session(@token.attr_provider.attr_slot_id, @open_session_flags, nil, nil)
      session = Session.new(@token, id_)
      ((@active_sessions += 1) - 1)
      if (!(Debug).nil?)
        if (@active_sessions > @max_active_sessions)
          @max_active_sessions = @active_sessions
          if ((@max_active_sessions % 10).equal?(0))
            System.out.println("Open sessions: " + (@max_active_sessions).to_s)
          end
        end
      end
      return session
    end
    
    typesig { [Session] }
    def close_session(session)
      if (session.has_objects)
        raise ProviderException.new("Internal error: close session with active objects")
      end
      @token.attr_p11._c_close_session(session.id)
      ((@active_sessions -= 1) + 1)
    end
    
    class_module.module_eval {
      const_set_lazy(:Pool) { Class.new do
        include_class_members SessionManager
        
        attr_accessor :mgr
        alias_method :attr_mgr, :mgr
        undef_method :mgr
        alias_method :attr_mgr=, :mgr=
        undef_method :mgr=
        
        attr_accessor :pool
        alias_method :attr_pool, :pool
        undef_method :pool
        alias_method :attr_pool=, :pool=
        undef_method :pool=
        
        typesig { [SessionManager] }
        def initialize(mgr)
          @mgr = nil
          @pool = nil
          @mgr = mgr
          @pool = ArrayList.new
        end
        
        typesig { [Session] }
        def remove(session)
          return @pool.remove(session)
        end
        
        typesig { [] }
        def poll
          n = @pool.size
          if ((n).equal?(0))
            return nil
          end
          session = @pool.remove(n - 1)
          return session
        end
        
        typesig { [Session] }
        def release(session)
          @pool.add(session)
          # if there are idle sessions, close them
          if (session.has_objects)
            return
          end
          n = @pool.size
          if (n < 5)
            return
          end
          oldest_session = @pool.get(0)
          time = System.current_time_millis
          if (session.is_live(time) && oldest_session.is_live(time))
            return
          end
          Collections.sort(@pool)
          i = 0
          exc = nil
          while (i < n - 1)
            # always keep at least 1 session open
            oldest_session = @pool.get(i)
            if (oldest_session.is_live(time))
              break
            end
            ((i += 1) - 1)
            begin
              @mgr.close_session(oldest_session)
            rescue PKCS11Exception => e
              exc = e
            end
          end
          if (!(Debug).nil?)
            System.out.println("Closing " + (i).to_s + " idle sessions, active: " + (@mgr.attr_active_sessions).to_s)
          end
          sub_list_ = @pool.sub_list(0, i)
          sub_list_.clear
          if (!(exc).nil?)
            raise ProviderException.new(exc)
          end
        end
        
        private
        alias_method :initialize__pool, :initialize
      end }
    }
    
    private
    alias_method :initialize__session_manager, :initialize
  end
  
end
