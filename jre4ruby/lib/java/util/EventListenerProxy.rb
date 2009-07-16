require "rjava"

# 
# Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EventListenerProxyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # 
  # An abstract wrapper class for an EventListener class which associates a set
  # of additional parameters with the listener. Subclasses must provide the
  # storage and accessor methods for the additional arguments or parameters.
  # 
  # Subclasses of EventListenerProxy may be returned by getListeners() methods
  # as a way of associating named properties with their listeners.
  # 
  # For example, a Bean which supports named properties would have a two
  # argument method signature for adding a PropertyChangeListener for a
  # property:
  # 
  # public void addPropertyChangeListener(String propertyName,
  # PropertyChangeListener listener);
  # 
  # If the Bean also implemented the zero argument get listener method:
  # 
  # public PropertyChangeListener[] getPropertyChangeListeners();
  # 
  # then the array may contain inner PropertyChangeListeners which are also
  # PropertyChangeListenerProxy objects.
  # 
  # If the calling method is interested in retrieving the named property then it
  # would have to test the element to see if it is a proxy class.
  # 
  # @since 1.4
  class EventListenerProxy 
    include_class_members EventListenerProxyImports
    include EventListener
    
    attr_accessor :listener
    alias_method :attr_listener, :listener
    undef_method :listener
    alias_method :attr_listener=, :listener=
    undef_method :listener=
    
    typesig { [EventListener] }
    # 
    # @param listener The listener object.
    def initialize(listener)
      @listener = nil
      @listener = listener
    end
    
    typesig { [] }
    # 
    # @return The listener associated with this proxy.
    def get_listener
      return @listener
    end
    
    private
    alias_method :initialize__event_listener_proxy, :initialize
  end
  
end
