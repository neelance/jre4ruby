require "rjava"

# 
# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Ref
  module WeakReferenceImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Ref
    }
  end
  
  # 
  # Weak reference objects, which do not prevent their referents from being
  # made finalizable, finalized, and then reclaimed.  Weak references are most
  # often used to implement canonicalizing mappings.
  # 
  # <p> Suppose that the garbage collector determines at a certain point in time
  # that an object is <a href="package-summary.html#reachability">weakly
  # reachable</a>.  At that time it will atomically clear all weak references to
  # that object and all weak references to any other weakly-reachable objects
  # from which that object is reachable through a chain of strong and soft
  # references.  At the same time it will declare all of the formerly
  # weakly-reachable objects to be finalizable.  At the same time or at some
  # later time it will enqueue those newly-cleared weak references that are
  # registered with reference queues.
  # 
  # @author   Mark Reinhold
  # @since    1.2
  class WeakReference < WeakReferenceImports.const_get :Reference
    include_class_members WeakReferenceImports
    
    typesig { [Object] }
    # 
    # Creates a new weak reference that refers to the given object.  The new
    # reference is not registered with any queue.
    # 
    # @param referent object the new weak reference will refer to
    def initialize(referent)
      super(referent)
    end
    
    typesig { [Object, ReferenceQueue] }
    # 
    # Creates a new weak reference that refers to the given object and is
    # registered with the given queue.
    # 
    # @param referent object the new weak reference will refer to
    # @param q the queue with which the reference is to be registered,
    # or <tt>null</tt> if registration is not required
    def initialize(referent, q)
      super(referent, q)
    end
    
    private
    alias_method :initialize__weak_reference, :initialize
  end
  
end
