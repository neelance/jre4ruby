require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module AssertionErrorImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # Thrown to indicate that an assertion has failed.
  # 
  # <p>The seven one-argument public constructors provided by this
  # class ensure that the assertion error returned by the invocation:
  # <pre>
  # new AssertionError(<i>expression</i>)
  # </pre>
  # has as its detail message the <i>string conversion</i> of
  # <i>expression</i> (as defined in <a
  # href="http://java.sun.com/docs/books/jls/second_edition/html/j.title.doc.html">
  # <i>The Java Language Specification, Second Edition</i></a>,
  # <a href="http://java.sun.com/docs/books/jls/second_edition/html/expressions.doc.html#40220">
  # Section  15.18.1.1</a>), regardless of the type of <i>expression</i>.
  # 
  # @since   1.4
  class AssertionError < AssertionErrorImports.const_get :JavaError
    include_class_members AssertionErrorImports
    
    typesig { [] }
    # Constructs an AssertionError with no detail message.
    def initialize
      super()
    end
    
    typesig { [String] }
    # This internal constructor does no processing on its string argument,
    # even if it is a null reference.  The public constructors will
    # never call this constructor with a null argument.
    def initialize(detail_message)
      super(detail_message)
    end
    
    typesig { [Object] }
    # Constructs an AssertionError with its detail message derived
    # from the specified object, which is converted to a string as
    # defined in <i>The Java Language Specification, Second
    # Edition</i>, Section 15.18.1.1.
    # <p>
    # If the specified object is an instance of <tt>Throwable</tt>, it
    # becomes the <i>cause</i> of the newly constructed assertion error.
    # 
    # @param detailMessage value to be used in constructing detail message
    # @see   Throwable#getCause()
    def initialize(detail_message)
      initialize__assertion_error("" + RJava.cast_to_string(detail_message))
      if (detail_message.is_a?(JavaThrowable))
        init_cause(detail_message)
      end
    end
    
    typesig { [::Java::Boolean] }
    # Constructs an AssertionError with its detail message derived
    # from the specified <code>boolean</code>, which is converted to
    # a string as defined in <i>The Java Language Specification,
    # Second Edition</i>, Section 15.18.1.1.
    # 
    # @param detailMessage value to be used in constructing detail message
    def initialize(detail_message)
      initialize__assertion_error("" + RJava.cast_to_string(detail_message))
    end
    
    typesig { [::Java::Char] }
    # Constructs an AssertionError with its detail message derived
    # from the specified <code>char</code>, which is converted to a
    # string as defined in <i>The Java Language Specification, Second
    # Edition</i>, Section 15.18.1.1.
    # 
    # @param detailMessage value to be used in constructing detail message
    def initialize(detail_message)
      initialize__assertion_error("" + RJava.cast_to_string(detail_message))
    end
    
    typesig { [::Java::Int] }
    # Constructs an AssertionError with its detail message derived
    # from the specified <code>int</code>, which is converted to a
    # string as defined in <i>The Java Language Specification, Second
    # Edition</i>, Section 15.18.1.1.
    # 
    # @param detailMessage value to be used in constructing detail message
    def initialize(detail_message)
      initialize__assertion_error("" + RJava.cast_to_string(detail_message))
    end
    
    typesig { [::Java::Long] }
    # Constructs an AssertionError with its detail message derived
    # from the specified <code>long</code>, which is converted to a
    # string as defined in <i>The Java Language Specification, Second
    # Edition</i>, Section 15.18.1.1.
    # 
    # @param detailMessage value to be used in constructing detail message
    def initialize(detail_message)
      initialize__assertion_error("" + RJava.cast_to_string(detail_message))
    end
    
    typesig { [::Java::Float] }
    # Constructs an AssertionError with its detail message derived
    # from the specified <code>float</code>, which is converted to a
    # string as defined in <i>The Java Language Specification, Second
    # Edition</i>, Section 15.18.1.1.
    # 
    # @param detailMessage value to be used in constructing detail message
    def initialize(detail_message)
      initialize__assertion_error("" + RJava.cast_to_string(detail_message))
    end
    
    typesig { [::Java::Double] }
    # Constructs an AssertionError with its detail message derived
    # from the specified <code>double</code>, which is converted to a
    # string as defined in <i>The Java Language Specification, Second
    # Edition</i>, Section 15.18.1.1.
    # 
    # @param detailMessage value to be used in constructing detail message
    def initialize(detail_message)
      initialize__assertion_error("" + RJava.cast_to_string(detail_message))
    end
    
    private
    alias_method :initialize__assertion_error, :initialize
  end
  
end
