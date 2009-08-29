require "rjava"

# Copyright 1996-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module EventObjectImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # <p>
  # The root class from which all event state objects shall be derived.
  # <p>
  # All Events are constructed with a reference to the object, the "source",
  # that is logically deemed to be the object upon which the Event in question
  # initially occurred upon.
  # 
  # @since JDK1.1
  class EventObject 
    include_class_members EventObjectImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 5516075349620653480 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The object on which the Event initially occurred.
    attr_accessor :source
    alias_method :attr_source, :source
    undef_method :source
    alias_method :attr_source=, :source=
    undef_method :source=
    
    typesig { [Object] }
    # Constructs a prototypical Event.
    # 
    # @param    source    The object on which the Event initially occurred.
    # @exception  IllegalArgumentException  if source is null.
    def initialize(source)
      @source = nil
      if ((source).nil?)
        raise IllegalArgumentException.new("null source")
      end
      @source = source
    end
    
    typesig { [] }
    # The object on which the Event initially occurred.
    # 
    # @return   The object on which the Event initially occurred.
    def get_source
      return @source
    end
    
    typesig { [] }
    # Returns a String representation of this EventObject.
    # 
    # @return  A a String representation of this EventObject.
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "[source=" + RJava.cast_to_string(@source) + "]"
    end
    
    private
    alias_method :initialize__event_object, :initialize
  end
  
end
