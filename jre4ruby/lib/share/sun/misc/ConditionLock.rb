require "rjava"

# Copyright 1994-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module ConditionLockImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # ConditionLock is a Lock with a built in state variable.  This class
  # provides the ability to wait for the state variable to be set to a
  # desired value and then acquire the lock.<p>
  # 
  # The lockWhen() and unlockWith() methods can be safely intermixed
  # with the lock() and unlock() methods. However if there is a thread
  # waiting for the state variable to become a particular value and you
  # simply call Unlock(), that thread will not be able to acquire the
  # lock until the state variable equals its desired value. <p>
  # 
  # @author      Peter King
  class ConditionLock < ConditionLockImports.const_get :Lock
    include_class_members ConditionLockImports
    
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    typesig { [] }
    # Creates a ConditionLock.
    def initialize
      @state = 0
      super()
      @state = 0
    end
    
    typesig { [::Java::Int] }
    # Creates a ConditionLock in an initialState.
    def initialize(initial_state)
      @state = 0
      super()
      @state = 0
      @state = initial_state
    end
    
    typesig { [::Java::Int] }
    # Acquires the lock when the state variable equals the desired state.
    # 
    # @param desiredState the desired state
    # @exception  java.lang.InterruptedException if any thread has
    # interrupted this thread.
    def lock_when(desired_state)
      synchronized(self) do
        while (!(@state).equal?(desired_state))
          wait
        end
        lock
      end
    end
    
    typesig { [::Java::Int] }
    # Releases the lock, and sets the state to a new value.
    # @param newState the new state
    def unlock_with(new_state)
      synchronized(self) do
        @state = new_state
        unlock
      end
    end
    
    private
    alias_method :initialize__condition_lock, :initialize
  end
  
end
