require "rjava"

# Copyright 1994-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module ObservableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # This class represents an observable object, or "data"
  # in the model-view paradigm. It can be subclassed to represent an
  # object that the application wants to have observed.
  # <p>
  # An observable object can have one or more observers. An observer
  # may be any object that implements interface <tt>Observer</tt>. After an
  # observable instance changes, an application calling the
  # <code>Observable</code>'s <code>notifyObservers</code> method
  # causes all of its observers to be notified of the change by a call
  # to their <code>update</code> method.
  # <p>
  # The order in which notifications will be delivered is unspecified.
  # The default implementation provided in the Observable class will
  # notify Observers in the order in which they registered interest, but
  # subclasses may change this order, use no guaranteed order, deliver
  # notifications on separate threads, or may guarantee that their
  # subclass follows this order, as they choose.
  # <p>
  # Note that this notification mechanism is has nothing to do with threads
  # and is completely separate from the <tt>wait</tt> and <tt>notify</tt>
  # mechanism of class <tt>Object</tt>.
  # <p>
  # When an observable object is newly created, its set of observers is
  # empty. Two observers are considered the same if and only if the
  # <tt>equals</tt> method returns true for them.
  # 
  # @author  Chris Warth
  # @see     java.util.Observable#notifyObservers()
  # @see     java.util.Observable#notifyObservers(java.lang.Object)
  # @see     java.util.Observer
  # @see     java.util.Observer#update(java.util.Observable, java.lang.Object)
  # @since   JDK1.0
  class Observable 
    include_class_members ObservableImports
    
    attr_accessor :changed
    alias_method :attr_changed, :changed
    undef_method :changed
    alias_method :attr_changed=, :changed=
    undef_method :changed=
    
    attr_accessor :obs
    alias_method :attr_obs, :obs
    undef_method :obs
    alias_method :attr_obs=, :obs=
    undef_method :obs=
    
    typesig { [] }
    # Construct an Observable with zero Observers.
    def initialize
      @changed = false
      @obs = nil
      @obs = Vector.new
    end
    
    typesig { [Observer] }
    # Adds an observer to the set of observers for this object, provided
    # that it is not the same as some observer already in the set.
    # The order in which notifications will be delivered to multiple
    # observers is not specified. See the class comment.
    # 
    # @param   o   an observer to be added.
    # @throws NullPointerException   if the parameter o is null.
    def add_observer(o)
      synchronized(self) do
        if ((o).nil?)
          raise NullPointerException.new
        end
        if (!@obs.contains(o))
          @obs.add_element(o)
        end
      end
    end
    
    typesig { [Observer] }
    # Deletes an observer from the set of observers of this object.
    # Passing <CODE>null</CODE> to this method will have no effect.
    # @param   o   the observer to be deleted.
    def delete_observer(o)
      synchronized(self) do
        @obs.remove_element(o)
      end
    end
    
    typesig { [] }
    # If this object has changed, as indicated by the
    # <code>hasChanged</code> method, then notify all of its observers
    # and then call the <code>clearChanged</code> method to
    # indicate that this object has no longer changed.
    # <p>
    # Each observer has its <code>update</code> method called with two
    # arguments: this observable object and <code>null</code>. In other
    # words, this method is equivalent to:
    # <blockquote><tt>
    # notifyObservers(null)</tt></blockquote>
    # 
    # @see     java.util.Observable#clearChanged()
    # @see     java.util.Observable#hasChanged()
    # @see     java.util.Observer#update(java.util.Observable, java.lang.Object)
    def notify_observers
      notify_observers(nil)
    end
    
    typesig { [Object] }
    # If this object has changed, as indicated by the
    # <code>hasChanged</code> method, then notify all of its observers
    # and then call the <code>clearChanged</code> method to indicate
    # that this object has no longer changed.
    # <p>
    # Each observer has its <code>update</code> method called with two
    # arguments: this observable object and the <code>arg</code> argument.
    # 
    # @param   arg   any object.
    # @see     java.util.Observable#clearChanged()
    # @see     java.util.Observable#hasChanged()
    # @see     java.util.Observer#update(java.util.Observable, java.lang.Object)
    def notify_observers(arg)
      # a temporary array buffer, used as a snapshot of the state of
      # current Observers.
      arr_local = nil
      synchronized((self)) do
        # We don't want the Observer doing callbacks into
        # arbitrary code while holding its own Monitor.
        # The code where we extract each Observable from
        # the Vector and store the state of the Observer
        # needs synchronization, but notifying observers
        # does not (should not).  The worst result of any
        # potential race-condition here is that:
        # 1) a newly-added Observer will miss a
        #   notification in progress
        # 2) a recently unregistered Observer will be
        #   wrongly notified when it doesn't care
        if (!@changed)
          return
        end
        arr_local = @obs.to_array
        clear_changed
      end
      i = arr_local.attr_length - 1
      while i >= 0
        (arr_local[i]).update(self, arg)
        i -= 1
      end
    end
    
    typesig { [] }
    # Clears the observer list so that this object no longer has any observers.
    def delete_observers
      synchronized(self) do
        @obs.remove_all_elements
      end
    end
    
    typesig { [] }
    # Marks this <tt>Observable</tt> object as having been changed; the
    # <tt>hasChanged</tt> method will now return <tt>true</tt>.
    def set_changed
      synchronized(self) do
        @changed = true
      end
    end
    
    typesig { [] }
    # Indicates that this object has no longer changed, or that it has
    # already notified all of its observers of its most recent change,
    # so that the <tt>hasChanged</tt> method will now return <tt>false</tt>.
    # This method is called automatically by the
    # <code>notifyObservers</code> methods.
    # 
    # @see     java.util.Observable#notifyObservers()
    # @see     java.util.Observable#notifyObservers(java.lang.Object)
    def clear_changed
      synchronized(self) do
        @changed = false
      end
    end
    
    typesig { [] }
    # Tests if this object has changed.
    # 
    # @return  <code>true</code> if and only if the <code>setChanged</code>
    #          method has been called more recently than the
    #          <code>clearChanged</code> method on this object;
    #          <code>false</code> otherwise.
    # @see     java.util.Observable#clearChanged()
    # @see     java.util.Observable#setChanged()
    def has_changed
      synchronized(self) do
        return @changed
      end
    end
    
    typesig { [] }
    # Returns the number of observers of this <tt>Observable</tt> object.
    # 
    # @return  the number of observers of this object.
    def count_observers
      synchronized(self) do
        return @obs.size
      end
    end
    
    private
    alias_method :initialize__observable, :initialize
  end
  
end
