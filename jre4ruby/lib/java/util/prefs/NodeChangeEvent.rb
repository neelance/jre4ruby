require "rjava"

# 
# Copyright 2000-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Prefs
  module NodeChangeEventImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
      include_const ::Java::Io, :NotSerializableException
    }
  end
  
  # 
  # An event emitted by a <tt>Preferences</tt> node to indicate that
  # a child of that node has been added or removed.<p>
  # 
  # Note, that although NodeChangeEvent inherits Serializable interface from
  # java.util.EventObject, it is not intended to be Serializable. Appropriate
  # serialization methods are implemented to throw NotSerializableException.
  # 
  # @author  Josh Bloch
  # @see     Preferences
  # @see     NodeChangeListener
  # @see     PreferenceChangeEvent
  # @since   1.4
  # @serial  exclude
  class NodeChangeEvent < Java::Util::EventObject
    include_class_members NodeChangeEventImports
    
    # 
    # The node that was added or removed.
    # 
    # @serial
    attr_accessor :child
    alias_method :attr_child, :child
    undef_method :child
    alias_method :attr_child=, :child=
    undef_method :child=
    
    typesig { [Preferences, Preferences] }
    # 
    # Constructs a new <code>NodeChangeEvent</code> instance.
    # 
    # @param parent  The parent of the node that was added or removed.
    # @param child   The node that was added or removed.
    def initialize(parent, child)
      @child = nil
      super(parent)
      @child = child
    end
    
    typesig { [] }
    # 
    # Returns the parent of the node that was added or removed.
    # 
    # @return  The parent Preferences node whose child was added or removed
    def get_parent
      return get_source
    end
    
    typesig { [] }
    # 
    # Returns the node that was added or removed.
    # 
    # @return  The node that was added or removed.
    def get_child
      return @child
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # 
    # Throws NotSerializableException, since NodeChangeEvent objects are not
    # intended to be serializable.
    def write_object(out)
      raise NotSerializableException.new("Not serializable.")
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # 
    # Throws NotSerializableException, since NodeChangeEvent objects are not
    # intended to be serializable.
    def read_object(in_)
      raise NotSerializableException.new("Not serializable.")
    end
    
    class_module.module_eval {
      # Defined so that this class isn't flagged as a potential problem when
      # searches for missing serialVersionUID fields are done.
      const_set_lazy(:SerialVersionUID) { 8068949086596572957 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__node_change_event, :initialize
  end
  
end
