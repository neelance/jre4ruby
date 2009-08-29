require "rjava"

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
  module PreferenceChangeEventImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
      include_const ::Java::Io, :NotSerializableException
    }
  end
  
  # An event emitted by a <tt>Preferences</tt> node to indicate that
  # a preference has been added, removed or has had its value changed.<p>
  # 
  # Note, that although PreferenceChangeEvent inherits Serializable interface
  # from EventObject, it is not intended to be Serializable. Appropriate
  # serialization methods are implemented to throw NotSerializableException.
  # 
  # @author  Josh Bloch
  # @see Preferences
  # @see PreferenceChangeListener
  # @see NodeChangeEvent
  # @since   1.4
  # @serial exclude
  class PreferenceChangeEvent < Java::Util::EventObject
    include_class_members PreferenceChangeEventImports
    
    # Key of the preference that changed.
    # 
    # @serial
    attr_accessor :key
    alias_method :attr_key, :key
    undef_method :key
    alias_method :attr_key=, :key=
    undef_method :key=
    
    # New value for preference, or <tt>null</tt> if it was removed.
    # 
    # @serial
    attr_accessor :new_value
    alias_method :attr_new_value, :new_value
    undef_method :new_value
    alias_method :attr_new_value=, :new_value=
    undef_method :new_value=
    
    typesig { [Preferences, String, String] }
    # Constructs a new <code>PreferenceChangeEvent</code> instance.
    # 
    # @param node  The Preferences node that emitted the event.
    # @param key  The key of the preference that was changed.
    # @param newValue  The new value of the preference, or <tt>null</tt>
    # if the preference is being removed.
    def initialize(node, key, new_value)
      @key = nil
      @new_value = nil
      super(node)
      @key = key
      @new_value = new_value
    end
    
    typesig { [] }
    # Returns the preference node that emitted the event.
    # 
    # @return  The preference node that emitted the event.
    def get_node
      return get_source
    end
    
    typesig { [] }
    # Returns the key of the preference that was changed.
    # 
    # @return  The key of the preference that was changed.
    def get_key
      return @key
    end
    
    typesig { [] }
    # Returns the new value for the preference.
    # 
    # @return  The new value for the preference, or <tt>null</tt> if the
    # preference was removed.
    def get_new_value
      return @new_value
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Throws NotSerializableException, since NodeChangeEvent objects
    # are not intended to be serializable.
    def write_object(out)
      raise NotSerializableException.new("Not serializable.")
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Throws NotSerializableException, since PreferenceChangeEvent objects
    # are not intended to be serializable.
    def read_object(in_)
      raise NotSerializableException.new("Not serializable.")
    end
    
    class_module.module_eval {
      # Defined so that this class isn't flagged as a potential problem when
      # searches for missing serialVersionUID fields are done.
      const_set_lazy(:SerialVersionUID) { 793724513368024975 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__preference_change_event, :initialize
  end
  
end
