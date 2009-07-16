require "rjava"

# 
# Copyright 1998-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module InheritableThreadLocalImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Ref
    }
  end
  
  # 
  # This class extends <tt>ThreadLocal</tt> to provide inheritance of values
  # from parent thread to child thread: when a child thread is created, the
  # child receives initial values for all inheritable thread-local variables
  # for which the parent has values.  Normally the child's values will be
  # identical to the parent's; however, the child's value can be made an
  # arbitrary function of the parent's by overriding the <tt>childValue</tt>
  # method in this class.
  # 
  # <p>Inheritable thread-local variables are used in preference to
  # ordinary thread-local variables when the per-thread-attribute being
  # maintained in the variable (e.g., User ID, Transaction ID) must be
  # automatically transmitted to any child threads that are created.
  # 
  # @author  Josh Bloch and Doug Lea
  # @see     ThreadLocal
  # @since   1.2
  class InheritableThreadLocal < InheritableThreadLocalImports.const_get :ThreadLocal
    include_class_members InheritableThreadLocalImports
    
    typesig { [Object] }
    # 
    # Computes the child's initial value for this inheritable thread-local
    # variable as a function of the parent's value at the time the child
    # thread is created.  This method is called from within the parent
    # thread before the child is started.
    # <p>
    # This method merely returns its input argument, and should be overridden
    # if a different behavior is desired.
    # 
    # @param parentValue the parent thread's value
    # @return the child thread's initial value
    def child_value(parent_value)
      return parent_value
    end
    
    typesig { [JavaThread] }
    # 
    # Get the map associated with a ThreadLocal.
    # 
    # @param t the current thread
    def get_map(t)
      return t.attr_inheritable_thread_locals
    end
    
    typesig { [JavaThread, Object] }
    # 
    # Create the map associated with a ThreadLocal.
    # 
    # @param t the current thread
    # @param firstValue value for the initial entry of the table.
    # @param map the map to store.
    def create_map(t, first_value)
      t.attr_inheritable_thread_locals = ThreadLocalMap.new(self, first_value)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__inheritable_thread_local, :initialize
  end
  
end
