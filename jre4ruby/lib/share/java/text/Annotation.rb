require "rjava"

# Copyright 1997-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Text
  module AnnotationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
    }
  end
  
  # An Annotation object is used as a wrapper for a text attribute value if
  # the attribute has annotation characteristics. These characteristics are:
  # <ul>
  # <li>The text range that the attribute is applied to is critical to the
  # semantics of the range. That means, the attribute cannot be applied to subranges
  # of the text range that it applies to, and, if two adjacent text ranges have
  # the same value for this attribute, the attribute still cannot be applied to
  # the combined range as a whole with this value.
  # <li>The attribute or its value usually do no longer apply if the underlying text is
  # changed.
  # </ul>
  # 
  # An example is grammatical information attached to a sentence:
  # For the previous sentence, you can say that "an example"
  # is the subject, but you cannot say the same about "an", "example", or "exam".
  # When the text is changed, the grammatical information typically becomes invalid.
  # Another example is Japanese reading information (yomi).
  # 
  # <p>
  # Wrapping the attribute value into an Annotation object guarantees that
  # adjacent text runs don't get merged even if the attribute values are equal,
  # and indicates to text containers that the attribute should be discarded if
  # the underlying text is modified.
  # 
  # @see AttributedCharacterIterator
  # @since 1.2
  class Annotation 
    include_class_members AnnotationImports
    
    typesig { [Object] }
    # Constructs an annotation record with the given value, which
    # may be null.
    # @param value The value of the attribute
    def initialize(value)
      @value = nil
      @value = value
    end
    
    typesig { [] }
    # Returns the value of the attribute, which may be null.
    def get_value
      return @value
    end
    
    typesig { [] }
    # Returns the String representation of this Annotation.
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "[value=" + RJava.cast_to_string(@value) + "]"
    end
    
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    private
    alias_method :initialize__annotation, :initialize
  end
  
end
