require "rjava"

# Copyright 1995-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ThreadGroupImports
    class_module.module_eval {
      include ::Java::Lang
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Misc, :VM
    }
  end
  
  # A thread group represents a set of threads. In addition, a thread
  # group can also include other thread groups. The thread groups form
  # a tree in which every thread group except the initial thread group
  # has a parent.
  # <p>
  # A thread is allowed to access information about its own thread
  # group, but not to access information about its thread group's
  # parent thread group or any other thread groups.
  # 
  # @author  unascribed
  # @since   JDK1.0
  # 
  # The locking strategy for this code is to try to lock only one level of the
  # tree wherever possible, but otherwise to lock from the bottom up.
  # That is, from child thread groups to parents.
  # This has the advantage of limiting the number of locks that need to be held
  # and in particular avoids having to grab the lock for the root thread group,
  # (or a global lock) which would be a source of contention on a
  # multi-processor system with many thread groups.
  # This policy often leads to taking a snapshot of the state of a thread group
  # and working off of that snapshot, rather than holding the thread group locked
  # while we work on the children.
  class JavaThreadGroup 
    include_class_members ThreadGroupImports
    include JavaThread::UncaughtExceptionHandler
    
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :max_priority
    alias_method :attr_max_priority, :max_priority
    undef_method :max_priority
    alias_method :attr_max_priority=, :max_priority=
    undef_method :max_priority=
    
    attr_accessor :destroyed
    alias_method :attr_destroyed, :destroyed
    undef_method :destroyed
    alias_method :attr_destroyed=, :destroyed=
    undef_method :destroyed=
    
    attr_accessor :daemon
    alias_method :attr_daemon, :daemon
    undef_method :daemon
    alias_method :attr_daemon=, :daemon=
    undef_method :daemon=
    
    attr_accessor :vm_allow_suspension
    alias_method :attr_vm_allow_suspension, :vm_allow_suspension
    undef_method :vm_allow_suspension
    alias_method :attr_vm_allow_suspension=, :vm_allow_suspension=
    undef_method :vm_allow_suspension=
    
    attr_accessor :n_unstarted_threads
    alias_method :attr_n_unstarted_threads, :n_unstarted_threads
    undef_method :n_unstarted_threads
    alias_method :attr_n_unstarted_threads=, :n_unstarted_threads=
    undef_method :n_unstarted_threads=
    
    attr_accessor :nthreads
    alias_method :attr_nthreads, :nthreads
    undef_method :nthreads
    alias_method :attr_nthreads=, :nthreads=
    undef_method :nthreads=
    
    attr_accessor :threads
    alias_method :attr_threads, :threads
    undef_method :threads
    alias_method :attr_threads=, :threads=
    undef_method :threads=
    
    attr_accessor :ngroups
    alias_method :attr_ngroups, :ngroups
    undef_method :ngroups
    alias_method :attr_ngroups=, :ngroups=
    undef_method :ngroups=
    
    attr_accessor :groups
    alias_method :attr_groups, :groups
    undef_method :groups
    alias_method :attr_groups=, :groups=
    undef_method :groups=
    
    typesig { [] }
    # Creates an empty Thread group that is not in any Thread group.
    # This method is used to create the system Thread group.
    def initialize
      @parent = nil
      @name = nil
      @max_priority = 0
      @destroyed = false
      @daemon = false
      @vm_allow_suspension = false
      @n_unstarted_threads = 0
      @nthreads = 0
      @threads = nil
      @ngroups = 0
      @groups = nil # called from C code
      @name = "system"
      @max_priority = JavaThread::MAX_PRIORITY
    end
    
    typesig { [String] }
    # Constructs a new thread group. The parent of this new group is
    # the thread group of the currently running thread.
    # <p>
    # The <code>checkAccess</code> method of the parent thread group is
    # called with no arguments; this may result in a security exception.
    # 
    # @param   name   the name of the new thread group.
    # @exception  SecurityException  if the current thread cannot create a
    # thread in the specified thread group.
    # @see     java.lang.ThreadGroup#checkAccess()
    # @since   JDK1.0
    def initialize(name)
      initialize__thread_group(JavaThread.current_thread.get_thread_group, name)
    end
    
    typesig { [JavaThreadGroup, String] }
    # Creates a new thread group. The parent of this new group is the
    # specified thread group.
    # <p>
    # The <code>checkAccess</code> method of the parent thread group is
    # called with no arguments; this may result in a security exception.
    # 
    # @param     parent   the parent thread group.
    # @param     name     the name of the new thread group.
    # @exception  NullPointerException  if the thread group argument is
    # <code>null</code>.
    # @exception  SecurityException  if the current thread cannot create a
    # thread in the specified thread group.
    # @see     java.lang.SecurityException
    # @see     java.lang.ThreadGroup#checkAccess()
    # @since   JDK1.0
    def initialize(parent, name)
      @parent = nil
      @name = nil
      @max_priority = 0
      @destroyed = false
      @daemon = false
      @vm_allow_suspension = false
      @n_unstarted_threads = 0
      @nthreads = 0
      @threads = nil
      @ngroups = 0
      @groups = nil
      if ((parent).nil?)
        raise NullPointerException.new
      end
      parent.check_access
      @name = name
      @max_priority = parent.attr_max_priority
      @daemon = parent.attr_daemon
      @vm_allow_suspension = parent.attr_vm_allow_suspension
      @parent = parent
      parent.add(self)
    end
    
    typesig { [] }
    # Returns the name of this thread group.
    # 
    # @return  the name of this thread group.
    # @since   JDK1.0
    def get_name
      return @name
    end
    
    typesig { [] }
    # Returns the parent of this thread group.
    # <p>
    # First, if the parent is not <code>null</code>, the
    # <code>checkAccess</code> method of the parent thread group is
    # called with no arguments; this may result in a security exception.
    # 
    # @return  the parent of this thread group. The top-level thread group
    # is the only thread group whose parent is <code>null</code>.
    # @exception  SecurityException  if the current thread cannot modify
    # this thread group.
    # @see        java.lang.ThreadGroup#checkAccess()
    # @see        java.lang.SecurityException
    # @see        java.lang.RuntimePermission
    # @since   JDK1.0
    def get_parent
      if (!(@parent).nil?)
        @parent.check_access
      end
      return @parent
    end
    
    typesig { [] }
    # Returns the maximum priority of this thread group. Threads that are
    # part of this group cannot have a higher priority than the maximum
    # priority.
    # 
    # @return  the maximum priority that a thread in this thread group
    # can have.
    # @see     #setMaxPriority
    # @since   JDK1.0
    def get_max_priority
      return @max_priority
    end
    
    typesig { [] }
    # Tests if this thread group is a daemon thread group. A
    # daemon thread group is automatically destroyed when its last
    # thread is stopped or its last thread group is destroyed.
    # 
    # @return  <code>true</code> if this thread group is a daemon thread group;
    # <code>false</code> otherwise.
    # @since   JDK1.0
    def is_daemon
      return @daemon
    end
    
    typesig { [] }
    # Tests if this thread group has been destroyed.
    # 
    # @return  true if this object is destroyed
    # @since   JDK1.1
    def is_destroyed
      synchronized(self) do
        return @destroyed
      end
    end
    
    typesig { [::Java::Boolean] }
    # Changes the daemon status of this thread group.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # A daemon thread group is automatically destroyed when its last
    # thread is stopped or its last thread group is destroyed.
    # 
    # @param      daemon   if <code>true</code>, marks this thread group as
    # a daemon thread group; otherwise, marks this
    # thread group as normal.
    # @exception  SecurityException  if the current thread cannot modify
    # this thread group.
    # @see        java.lang.SecurityException
    # @see        java.lang.ThreadGroup#checkAccess()
    # @since      JDK1.0
    def set_daemon(daemon)
      check_access
      @daemon = daemon
    end
    
    typesig { [::Java::Int] }
    # Sets the maximum priority of the group. Threads in the thread
    # group that already have a higher priority are not affected.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # If the <code>pri</code> argument is less than
    # {@link Thread#MIN_PRIORITY} or greater than
    # {@link Thread#MAX_PRIORITY}, the maximum priority of the group
    # remains unchanged.
    # <p>
    # Otherwise, the priority of this ThreadGroup object is set to the
    # smaller of the specified <code>pri</code> and the maximum permitted
    # priority of the parent of this thread group. (If this thread group
    # is the system thread group, which has no parent, then its maximum
    # priority is simply set to <code>pri</code>.) Then this method is
    # called recursively, with <code>pri</code> as its argument, for
    # every thread group that belongs to this thread group.
    # 
    # @param      pri   the new priority of the thread group.
    # @exception  SecurityException  if the current thread cannot modify
    # this thread group.
    # @see        #getMaxPriority
    # @see        java.lang.SecurityException
    # @see        java.lang.ThreadGroup#checkAccess()
    # @since      JDK1.0
    def set_max_priority(pri)
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        check_access
        if (pri < JavaThread::MIN_PRIORITY || pri > JavaThread::MAX_PRIORITY)
          return
        end
        @max_priority = (!(@parent).nil?) ? Math.min(pri, @parent.attr_max_priority) : pri
        ngroups_snapshot = @ngroups
        if (!(@groups).nil?)
          groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
        else
          groups_snapshot = nil
        end
      end
      i = 0
      while i < ngroups_snapshot
        groups_snapshot[i].set_max_priority(pri)
        i += 1
      end
    end
    
    typesig { [JavaThreadGroup] }
    # Tests if this thread group is either the thread group
    # argument or one of its ancestor thread groups.
    # 
    # @param   g   a thread group.
    # @return  <code>true</code> if this thread group is the thread group
    # argument or one of its ancestor thread groups;
    # <code>false</code> otherwise.
    # @since   JDK1.0
    def parent_of(g)
      while !(g).nil?
        if ((g).equal?(self))
          return true
        end
        g = g.attr_parent
      end
      return false
    end
    
    typesig { [] }
    # Determines if the currently running thread has permission to
    # modify this thread group.
    # <p>
    # If there is a security manager, its <code>checkAccess</code> method
    # is called with this thread group as its argument. This may result
    # in throwing a <code>SecurityException</code>.
    # 
    # @exception  SecurityException  if the current thread is not allowed to
    # access this thread group.
    # @see        java.lang.SecurityManager#checkAccess(java.lang.ThreadGroup)
    # @since      JDK1.0
    def check_access
      security = System.get_security_manager
      if (!(security).nil?)
        security.check_access(self)
      end
    end
    
    typesig { [] }
    # Returns an estimate of the number of active threads in this
    # thread group.  The result might not reflect concurrent activity,
    # and might be affected by the presence of certain system threads.
    # <p>
    # Due to the inherently imprecise nature of the result, it is
    # recommended that this method only be used for informational purposes.
    # 
    # @return  an estimate of the number of active threads in this thread
    # group and in any other thread group that has this thread
    # group as an ancestor.
    # @since   JDK1.0
    def active_count
      result = 0
      # Snapshot sub-group data so we don't hold this lock
      # while our children are computing.
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        if (@destroyed)
          return 0
        end
        result = @nthreads
        ngroups_snapshot = @ngroups
        if (!(@groups).nil?)
          groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
        else
          groups_snapshot = nil
        end
      end
      i = 0
      while i < ngroups_snapshot
        result += groups_snapshot[i].active_count
        i += 1
      end
      return result
    end
    
    typesig { [Array.typed(JavaThread)] }
    # Copies into the specified array every active thread in this
    # thread group and its subgroups.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # An application might use the <code>activeCount</code> method to
    # get an estimate of how big the array should be, however <i>if the
    # array is too short to hold all the threads, the extra threads are
    # silently ignored.</i>  If it is critical to obtain every active
    # thread in this thread group and its subgroups, the caller should
    # verify that the returned int value is strictly less than the length
    # of <tt>list</tt>.
    # <p>
    # Due to the inherent race condition in this method, it is recommended
    # that the method only be used for informational purposes.
    # 
    # @param   list   an array into which to place the list of threads.
    # @return  the number of threads put into the array.
    # @exception  SecurityException  if the current thread does not
    # have permission to enumerate this thread group.
    # @see     java.lang.ThreadGroup#activeCount()
    # @see     java.lang.ThreadGroup#checkAccess()
    # @since   JDK1.0
    def enumerate(list)
      check_access
      return enumerate(list, 0, true)
    end
    
    typesig { [Array.typed(JavaThread), ::Java::Boolean] }
    # Copies into the specified array every active thread in this
    # thread group. If the <code>recurse</code> flag is
    # <code>true</code>, references to every active thread in this
    # thread's subgroups are also included. If the array is too short to
    # hold all the threads, the extra threads are silently ignored.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # An application might use the <code>activeCount</code> method to
    # get an estimate of how big the array should be, however <i>if the
    # array is too short to hold all the threads, the extra threads are
    # silently ignored.</i>  If it is critical to obtain every active thread
    # in this thread group, the caller should verify that the returned int
    # value is strictly less than the length of <tt>list</tt>.
    # <p>
    # Due to the inherent race condition in this method, it is recommended
    # that the method only be used for informational purposes.
    # 
    # @param   list      an array into which to place the list of threads.
    # @param   recurse   a flag indicating whether also to include threads
    # in thread groups that are subgroups of this
    # thread group.
    # @return  the number of threads placed into the array.
    # @exception  SecurityException  if the current thread does not
    # have permission to enumerate this thread group.
    # @see     java.lang.ThreadGroup#activeCount()
    # @see     java.lang.ThreadGroup#checkAccess()
    # @since   JDK1.0
    def enumerate(list, recurse)
      check_access
      return enumerate(list, 0, recurse)
    end
    
    typesig { [Array.typed(JavaThread), ::Java::Int, ::Java::Boolean] }
    def enumerate(list, n, recurse)
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        if (@destroyed)
          return 0
        end
        nt = @nthreads
        if (nt > list.attr_length - n)
          nt = list.attr_length - n
        end
        i = 0
        while i < nt
          if (@threads[i].is_alive)
            list[((n += 1) - 1)] = @threads[i]
          end
          i += 1
        end
        if (recurse)
          ngroups_snapshot = @ngroups
          if (!(@groups).nil?)
            groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
          else
            groups_snapshot = nil
          end
        end
      end
      if (recurse)
        i_ = 0
        while i_ < ngroups_snapshot
          n = groups_snapshot[i_].enumerate(list, n, true)
          i_ += 1
        end
      end
      return n
    end
    
    typesig { [] }
    # Returns an estimate of the number of active groups in this
    # thread group.  The result might not reflect concurrent activity.
    # <p>
    # Due to the inherently imprecise nature of the result, it is
    # recommended that this method only be used for informational purposes.
    # 
    # @return  the number of active thread groups with this thread group as
    # an ancestor.
    # @since   JDK1.0
    def active_group_count
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        if (@destroyed)
          return 0
        end
        ngroups_snapshot = @ngroups
        if (!(@groups).nil?)
          groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
        else
          groups_snapshot = nil
        end
      end
      n = ngroups_snapshot
      i = 0
      while i < ngroups_snapshot
        n += groups_snapshot[i].active_group_count
        i += 1
      end
      return n
    end
    
    typesig { [Array.typed(JavaThreadGroup)] }
    # Copies into the specified array references to every active
    # subgroup in this thread group.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # An application might use the <code>activeGroupCount</code> method to
    # get an estimate of how big the array should be, however <i>if the
    # array is too short to hold all the thread groups, the extra thread
    # groups are silently ignored.</i>  If it is critical to obtain every
    # active subgroup in this thread group, the caller should verify that
    # the returned int value is strictly less than the length of
    # <tt>list</tt>.
    # <p>
    # Due to the inherent race condition in this method, it is recommended
    # that the method only be used for informational purposes.
    # 
    # @param   list   an array into which to place the list of thread groups.
    # @return  the number of thread groups put into the array.
    # @exception  SecurityException  if the current thread does not
    # have permission to enumerate this thread group.
    # @see     java.lang.ThreadGroup#activeGroupCount()
    # @see     java.lang.ThreadGroup#checkAccess()
    # @since   JDK1.0
    def enumerate(list)
      check_access
      return enumerate(list, 0, true)
    end
    
    typesig { [Array.typed(JavaThreadGroup), ::Java::Boolean] }
    # Copies into the specified array references to every active
    # subgroup in this thread group. If the <code>recurse</code> flag is
    # <code>true</code>, references to all active subgroups of the
    # subgroups and so forth are also included.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # An application might use the <code>activeGroupCount</code> method to
    # get an estimate of how big the array should be, however <i>if the
    # array is too short to hold all the thread groups, the extra thread
    # groups are silently ignored.</i>  If it is critical to obtain every
    # active subgroup in this thread group, the caller should verify that
    # the returned int value is strictly less than the length of
    # <tt>list</tt>.
    # <p>
    # Due to the inherent race condition in this method, it is recommended
    # that the method only be used for informational purposes.
    # 
    # @param   list      an array into which to place the list of threads.
    # @param   recurse   a flag indicating whether to recursively enumerate
    # all included thread groups.
    # @return  the number of thread groups put into the array.
    # @exception  SecurityException  if the current thread does not
    # have permission to enumerate this thread group.
    # @see     java.lang.ThreadGroup#activeGroupCount()
    # @see     java.lang.ThreadGroup#checkAccess()
    # @since   JDK1.0
    def enumerate(list, recurse)
      check_access
      return enumerate(list, 0, recurse)
    end
    
    typesig { [Array.typed(JavaThreadGroup), ::Java::Int, ::Java::Boolean] }
    def enumerate(list, n, recurse)
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        if (@destroyed)
          return 0
        end
        ng = @ngroups
        if (ng > list.attr_length - n)
          ng = list.attr_length - n
        end
        if (ng > 0)
          System.arraycopy(@groups, 0, list, n, ng)
          n += ng
        end
        if (recurse)
          ngroups_snapshot = @ngroups
          if (!(@groups).nil?)
            groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
          else
            groups_snapshot = nil
          end
        end
      end
      if (recurse)
        i = 0
        while i < ngroups_snapshot
          n = groups_snapshot[i].enumerate(list, n, true)
          i += 1
        end
      end
      return n
    end
    
    typesig { [] }
    # Stops all threads in this thread group.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # This method then calls the <code>stop</code> method on all the
    # threads in this thread group and in all of its subgroups.
    # 
    # @exception  SecurityException  if the current thread is not allowed
    # to access this thread group or any of the threads in
    # the thread group.
    # @see        java.lang.SecurityException
    # @see        java.lang.Thread#stop()
    # @see        java.lang.ThreadGroup#checkAccess()
    # @since      JDK1.0
    # @deprecated    This method is inherently unsafe.  See
    # {@link Thread#stop} for details.
    def stop
      if (stop_or_suspend(false))
        JavaThread.current_thread.stop
      end
    end
    
    typesig { [] }
    # Interrupts all threads in this thread group.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # This method then calls the <code>interrupt</code> method on all the
    # threads in this thread group and in all of its subgroups.
    # 
    # @exception  SecurityException  if the current thread is not allowed
    # to access this thread group or any of the threads in
    # the thread group.
    # @see        java.lang.Thread#interrupt()
    # @see        java.lang.SecurityException
    # @see        java.lang.ThreadGroup#checkAccess()
    # @since      1.2
    def interrupt
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        check_access
        i = 0
        while i < @nthreads
          @threads[i].interrupt
          i += 1
        end
        ngroups_snapshot = @ngroups
        if (!(@groups).nil?)
          groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
        else
          groups_snapshot = nil
        end
      end
      i_ = 0
      while i_ < ngroups_snapshot
        groups_snapshot[i_].interrupt
        i_ += 1
      end
    end
    
    typesig { [] }
    # Suspends all threads in this thread group.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # This method then calls the <code>suspend</code> method on all the
    # threads in this thread group and in all of its subgroups.
    # 
    # @exception  SecurityException  if the current thread is not allowed
    # to access this thread group or any of the threads in
    # the thread group.
    # @see        java.lang.Thread#suspend()
    # @see        java.lang.SecurityException
    # @see        java.lang.ThreadGroup#checkAccess()
    # @since      JDK1.0
    # @deprecated    This method is inherently deadlock-prone.  See
    # {@link Thread#suspend} for details.
    def suspend
      if (stop_or_suspend(true))
        JavaThread.current_thread.suspend
      end
    end
    
    typesig { [::Java::Boolean] }
    # Helper method: recursively stops or suspends (as directed by the
    # boolean argument) all of the threads in this thread group and its
    # subgroups, except the current thread.  This method returns true
    # if (and only if) the current thread is found to be in this thread
    # group or one of its subgroups.
    def stop_or_suspend(suspend)
      suicide = false
      us = JavaThread.current_thread
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        check_access
        i = 0
        while i < @nthreads
          if ((@threads[i]).equal?(us))
            suicide = true
          else
            if (suspend)
              @threads[i].suspend
            else
              @threads[i].stop
            end
          end
          i += 1
        end
        ngroups_snapshot = @ngroups
        if (!(@groups).nil?)
          groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
        end
      end
      i_ = 0
      while i_ < ngroups_snapshot
        suicide = groups_snapshot[i_].stop_or_suspend(suspend) || suicide
        i_ += 1
      end
      return suicide
    end
    
    typesig { [] }
    # Resumes all threads in this thread group.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # <p>
    # This method then calls the <code>resume</code> method on all the
    # threads in this thread group and in all of its sub groups.
    # 
    # @exception  SecurityException  if the current thread is not allowed to
    # access this thread group or any of the threads in the
    # thread group.
    # @see        java.lang.SecurityException
    # @see        java.lang.Thread#resume()
    # @see        java.lang.ThreadGroup#checkAccess()
    # @since      JDK1.0
    # @deprecated    This method is used solely in conjunction with
    # <tt>Thread.suspend</tt> and <tt>ThreadGroup.suspend</tt>,
    # both of which have been deprecated, as they are inherently
    # deadlock-prone.  See {@link Thread#suspend} for details.
    def resume
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        check_access
        i = 0
        while i < @nthreads
          @threads[i].resume
          i += 1
        end
        ngroups_snapshot = @ngroups
        if (!(@groups).nil?)
          groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
        else
          groups_snapshot = nil
        end
      end
      i_ = 0
      while i_ < ngroups_snapshot
        groups_snapshot[i_].resume
        i_ += 1
      end
    end
    
    typesig { [] }
    # Destroys this thread group and all of its subgroups. This thread
    # group must be empty, indicating that all threads that had been in
    # this thread group have since stopped.
    # <p>
    # First, the <code>checkAccess</code> method of this thread group is
    # called with no arguments; this may result in a security exception.
    # 
    # @exception  IllegalThreadStateException  if the thread group is not
    # empty or if the thread group has already been destroyed.
    # @exception  SecurityException  if the current thread cannot modify this
    # thread group.
    # @see        java.lang.ThreadGroup#checkAccess()
    # @since      JDK1.0
    def destroy
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        check_access
        if (@destroyed || (@nthreads > 0))
          raise IllegalThreadStateException.new
        end
        ngroups_snapshot = @ngroups
        if (!(@groups).nil?)
          groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
        else
          groups_snapshot = nil
        end
        if (!(@parent).nil?)
          @destroyed = true
          @ngroups = 0
          @groups = nil
          @nthreads = 0
          @threads = nil
        end
      end
      i = 0
      while i < ngroups_snapshot
        groups_snapshot[i].destroy
        i += 1
      end
      if (!(@parent).nil?)
        @parent.remove(self)
      end
    end
    
    typesig { [JavaThreadGroup] }
    # Adds the specified Thread group to this group.
    # @param g the specified Thread group to be added
    # @exception IllegalThreadStateException If the Thread group has been destroyed.
    def add(g)
      synchronized((self)) do
        if (@destroyed)
          raise IllegalThreadStateException.new
        end
        if ((@groups).nil?)
          @groups = Array.typed(JavaThreadGroup).new(4) { nil }
        else
          if ((@ngroups).equal?(@groups.attr_length))
            @groups = Arrays.copy_of(@groups, @ngroups * 2)
          end
        end
        @groups[@ngroups] = g
        # This is done last so it doesn't matter in case the
        # thread is killed
        @ngroups += 1
      end
    end
    
    typesig { [JavaThreadGroup] }
    # Removes the specified Thread group from this group.
    # @param g the Thread group to be removed
    # @return if this Thread has already been destroyed.
    def remove(g)
      synchronized((self)) do
        if (@destroyed)
          return
        end
        i = 0
        while i < @ngroups
          if ((@groups[i]).equal?(g))
            @ngroups -= 1
            System.arraycopy(@groups, i + 1, @groups, i, @ngroups - i)
            # Zap dangling reference to the dead group so that
            # the garbage collector will collect it.
            @groups[@ngroups] = nil
            break
          end
          i += 1
        end
        if ((@nthreads).equal?(0))
          notify_all
        end
        if (@daemon && ((@nthreads).equal?(0)) && ((@n_unstarted_threads).equal?(0)) && ((@ngroups).equal?(0)))
          destroy
        end
      end
    end
    
    typesig { [] }
    # Increments the count of unstarted threads in the thread group.
    # Unstarted threads are not added to the thread group so that they
    # can be collected if they are never started, but they must be
    # counted so that daemon thread groups with unstarted threads in
    # them are not destroyed.
    def add_unstarted
      synchronized((self)) do
        if (@destroyed)
          raise IllegalThreadStateException.new
        end
        @n_unstarted_threads += 1
      end
    end
    
    typesig { [JavaThread] }
    # Adds the specified Thread to this group.
    # @param t the Thread to be added
    # @exception IllegalThreadStateException If the Thread group has been destroyed.
    def add(t)
      synchronized((self)) do
        if (@destroyed)
          raise IllegalThreadStateException.new
        end
        if ((@threads).nil?)
          @threads = Array.typed(JavaThread).new(4) { nil }
        else
          if ((@nthreads).equal?(@threads.attr_length))
            @threads = Arrays.copy_of(@threads, @nthreads * 2)
          end
        end
        @threads[@nthreads] = t
        # This is done last so it doesn't matter in case the
        # thread is killed
        @nthreads += 1
        @n_unstarted_threads -= 1
      end
    end
    
    typesig { [JavaThread] }
    # Removes the specified Thread from this group.
    # @param t the Thread to be removed
    # @return if the Thread has already been destroyed.
    def remove(t)
      synchronized((self)) do
        if (@destroyed)
          return
        end
        i = 0
        while i < @nthreads
          if ((@threads[i]).equal?(t))
            System.arraycopy(@threads, i + 1, @threads, i, (@nthreads -= 1) - i)
            # Zap dangling reference to the dead thread so that
            # the garbage collector will collect it.
            @threads[@nthreads] = nil
            break
          end
          i += 1
        end
        if ((@nthreads).equal?(0))
          notify_all
        end
        if (@daemon && ((@nthreads).equal?(0)) && ((@n_unstarted_threads).equal?(0)) && ((@ngroups).equal?(0)))
          destroy
        end
      end
    end
    
    typesig { [] }
    # Prints information about this thread group to the standard
    # output. This method is useful only for debugging.
    # 
    # @since   JDK1.0
    def list
      list(System.out, 0)
    end
    
    typesig { [PrintStream, ::Java::Int] }
    def list(out, indent)
      ngroups_snapshot = 0
      groups_snapshot = nil
      synchronized((self)) do
        j = 0
        while j < indent
          out.print(" ")
          j += 1
        end
        out.println(self)
        indent += 4
        i = 0
        while i < @nthreads
          j_ = 0
          while j_ < indent
            out.print(" ")
            j_ += 1
          end
          out.println(@threads[i])
          i += 1
        end
        ngroups_snapshot = @ngroups
        if (!(@groups).nil?)
          groups_snapshot = Arrays.copy_of(@groups, ngroups_snapshot)
        else
          groups_snapshot = nil
        end
      end
      i_ = 0
      while i_ < ngroups_snapshot
        groups_snapshot[i_].list(out, indent)
        i_ += 1
      end
    end
    
    typesig { [JavaThread, JavaThrowable] }
    # Called by the Java Virtual Machine when a thread in this
    # thread group stops because of an uncaught exception, and the thread
    # does not have a specific {@link Thread.UncaughtExceptionHandler}
    # installed.
    # <p>
    # The <code>uncaughtException</code> method of
    # <code>ThreadGroup</code> does the following:
    # <ul>
    # <li>If this thread group has a parent thread group, the
    # <code>uncaughtException</code> method of that parent is called
    # with the same two arguments.
    # <li>Otherwise, this method checks to see if there is a
    # {@linkplain Thread#getDefaultUncaughtExceptionHandler default
    # uncaught exception handler} installed, and if so, its
    # <code>uncaughtException</code> method is called with the same
    # two arguments.
    # <li>Otherwise, this method determines if the <code>Throwable</code>
    # argument is an instance of {@link ThreadDeath}. If so, nothing
    # special is done. Otherwise, a message containing the
    # thread's name, as returned from the thread's {@link
    # Thread#getName getName} method, and a stack backtrace,
    # using the <code>Throwable</code>'s {@link
    # Throwable#printStackTrace printStackTrace} method, is
    # printed to the {@linkplain System#err standard error stream}.
    # </ul>
    # <p>
    # Applications can override this method in subclasses of
    # <code>ThreadGroup</code> to provide alternative handling of
    # uncaught exceptions.
    # 
    # @param   t   the thread that is about to exit.
    # @param   e   the uncaught exception.
    # @since   JDK1.0
    def uncaught_exception(t, e)
      if (!(@parent).nil?)
        @parent.uncaught_exception(t, e)
      else
        ueh = JavaThread.get_default_uncaught_exception_handler
        if (!(ueh).nil?)
          ueh.uncaught_exception(t, e)
        else
          if (!(e.is_a?(ThreadDeath)))
            System.err.print("Exception in thread \"" + RJava.cast_to_string(t.get_name) + "\" ")
            e.print_stack_trace(System.err)
          end
        end
      end
    end
    
    typesig { [::Java::Boolean] }
    # Used by VM to control lowmem implicit suspension.
    # 
    # @param b boolean to allow or disallow suspension
    # @return true on success
    # @since   JDK1.1
    # @deprecated The definition of this call depends on {@link #suspend},
    # which is deprecated.  Further, the behavior of this call
    # was never specified.
    def allow_thread_suspension(b)
      @vm_allow_suspension = b
      if (!b)
        VM.unsuspend_some_threads
      end
      return true
    end
    
    typesig { [] }
    # Returns a string representation of this Thread group.
    # 
    # @return  a string representation of this thread group.
    # @since   JDK1.0
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "[name=" + RJava.cast_to_string(get_name) + ",maxpri=" + RJava.cast_to_string(@max_priority) + "]"
    end
    
    private
    alias_method :initialize__thread_group, :initialize
  end
  
end
