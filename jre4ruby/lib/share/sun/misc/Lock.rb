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
  module LockImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # The Lock class provides a simple, useful interface to a lock.
  # Unlike monitors which synchronize access to an object, locks
  # synchronize access to an arbitrary set of resources (objects,
  # methods, variables, etc.). <p>
  # 
  # The programmer using locks must be responsible for clearly defining
  # the semantics of their use and should handle deadlock avoidance in
  # the face of exceptions. <p>
  # 
  # For example, if you want to protect a set of method invocations with
  # a lock, and one of the methods may throw an exception, you must be
  # prepared to release the lock similarly to the following example:
  # <pre>
  # class SomeClass {
  # Lock myLock = new Lock();
  # 
  # void someMethod() {
  # myLock.lock();
  # try {
  # StartOperation();
  # ContinueOperation();
  # EndOperation();
  # } finally {
  # myLock.unlock();
  # }
  # }
  # }
  # </pre>
  # 
  # @author      Peter King
  class Lock 
    include_class_members LockImports
    
    attr_accessor :locked
    alias_method :attr_locked, :locked
    undef_method :locked
    alias_method :attr_locked=, :locked=
    undef_method :locked=
    
    typesig { [] }
    # Create a lock, which is initially not locked.
    def initialize
      @locked = false
    end
    
    typesig { [] }
    # Acquire the lock.  If someone else has the lock, wait until it
    # has been freed, and then try to acquire it again.  This method
    # will not return until the lock has been acquired.
    # 
    # @exception  java.lang.InterruptedException if any thread has
    # interrupted this thread.
    def lock
      synchronized(self) do
        while (@locked)
          wait
        end
        @locked = true
      end
    end
    
    typesig { [] }
    # Release the lock.  If someone else is waiting for the lock, the
    # will be notitified so they can try to acquire the lock again.
    def unlock
      synchronized(self) do
        @locked = false
        notify_all
      end
    end
    
    private
    alias_method :initialize__lock, :initialize
  end
  
end
