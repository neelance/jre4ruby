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
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent::Locks
  module AbstractOwnableSynchronizerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent::Locks
    }
  end
  
  # A synchronizer that may be exclusively owned by a thread.  This
  # class provides a basis for creating locks and related synchronizers
  # that may entail a notion of ownership.  The
  # <tt>AbstractOwnableSynchronizer</tt> class itself does not manage or
  # use this information. However, subclasses and tools may use
  # appropriately maintained values to help control and monitor access
  # and provide diagnostics.
  # 
  # @since 1.6
  # @author Doug Lea
  class AbstractOwnableSynchronizer 
    include_class_members AbstractOwnableSynchronizerImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      # Use serial ID even though all fields transient.
      const_set_lazy(:SerialVersionUID) { 3737899427754241961 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Empty constructor for use by subclasses.
    def initialize
      @exclusive_owner_thread = nil
    end
    
    # The current owner of exclusive mode synchronization.
    attr_accessor :exclusive_owner_thread
    alias_method :attr_exclusive_owner_thread, :exclusive_owner_thread
    undef_method :exclusive_owner_thread
    alias_method :attr_exclusive_owner_thread=, :exclusive_owner_thread=
    undef_method :exclusive_owner_thread=
    
    typesig { [JavaThread] }
    # Sets the thread that currently owns exclusive access. A
    # <tt>null</tt> argument indicates that no thread owns access.
    # This method does not otherwise impose any synchronization or
    # <tt>volatile</tt> field accesses.
    def set_exclusive_owner_thread(t)
      @exclusive_owner_thread = t
    end
    
    typesig { [] }
    # Returns the thread last set by
    # <tt>setExclusiveOwnerThread</tt>, or <tt>null</tt> if never
    # set.  This method does not otherwise impose any synchronization
    # or <tt>volatile</tt> field accesses.
    # @return the owner thread
    def get_exclusive_owner_thread
      return @exclusive_owner_thread
    end
    
    private
    alias_method :initialize__abstract_ownable_synchronizer, :initialize
  end
  
end
