require "rjava"

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
module Java::Lang
  module StackTraceElementImports
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # An element in a stack trace, as returned by {@link
  # Throwable#getStackTrace()}.  Each element represents a single stack frame.
  # All stack frames except for the one at the top of the stack represent
  # a method invocation.  The frame at the top of the stack represents the
  # execution point at which the stack trace was generated.  Typically,
  # this is the point at which the throwable corresponding to the stack trace
  # was created.
  # 
  # @since  1.4
  # @author Josh Bloch
  class StackTraceElement 
    include_class_members StackTraceElementImports
    include Java::Io::Serializable
    
    # Normally initialized by VM (public constructor added in 1.5)
    attr_accessor :declaring_class
    alias_method :attr_declaring_class, :declaring_class
    undef_method :declaring_class
    alias_method :attr_declaring_class=, :declaring_class=
    undef_method :declaring_class=
    
    attr_accessor :method_name
    alias_method :attr_method_name, :method_name
    undef_method :method_name
    alias_method :attr_method_name=, :method_name=
    undef_method :method_name=
    
    attr_accessor :file_name
    alias_method :attr_file_name, :file_name
    undef_method :file_name
    alias_method :attr_file_name=, :file_name=
    undef_method :file_name=
    
    attr_accessor :line_number
    alias_method :attr_line_number, :line_number
    undef_method :line_number
    alias_method :attr_line_number=, :line_number=
    undef_method :line_number=
    
    typesig { [String, String, String, ::Java::Int] }
    # Creates a stack trace element representing the specified execution
    # point.
    # 
    # @param declaringClass the fully qualified name of the class containing
    # the execution point represented by the stack trace element
    # @param methodName the name of the method containing the execution point
    # represented by the stack trace element
    # @param fileName the name of the file containing the execution point
    # represented by the stack trace element, or <tt>null</tt> if
    # this information is unavailable
    # @param lineNumber the line number of the source line containing the
    # execution point represented by this stack trace element, or
    # a negative number if this information is unavailable. A value
    # of -2 indicates that the method containing the execution point
    # is a native method
    # @throws NullPointerException if <tt>declaringClass</tt> or
    # <tt>methodName</tt> is null
    # @since 1.5
    def initialize(declaring_class, method_name, file_name, line_number)
      @declaring_class = nil
      @method_name = nil
      @file_name = nil
      @line_number = 0
      if ((declaring_class).nil?)
        raise NullPointerException.new("Declaring class is null")
      end
      if ((method_name).nil?)
        raise NullPointerException.new("Method name is null")
      end
      @declaring_class = declaring_class
      @method_name = method_name
      @file_name = file_name
      @line_number = line_number
    end
    
    typesig { [] }
    # Returns the name of the source file containing the execution point
    # represented by this stack trace element.  Generally, this corresponds
    # to the <tt>SourceFile</tt> attribute of the relevant <tt>class</tt>
    # file (as per <i>The Java Virtual Machine Specification</i>, Section
    # 4.7.7).  In some systems, the name may refer to some source code unit
    # other than a file, such as an entry in source repository.
    # 
    # @return the name of the file containing the execution point
    # represented by this stack trace element, or <tt>null</tt> if
    # this information is unavailable.
    def get_file_name
      return @file_name
    end
    
    typesig { [] }
    # Returns the line number of the source line containing the execution
    # point represented by this stack trace element.  Generally, this is
    # derived from the <tt>LineNumberTable</tt> attribute of the relevant
    # <tt>class</tt> file (as per <i>The Java Virtual Machine
    # Specification</i>, Section 4.7.8).
    # 
    # @return the line number of the source line containing the execution
    # point represented by this stack trace element, or a negative
    # number if this information is unavailable.
    def get_line_number
      return @line_number
    end
    
    typesig { [] }
    # Returns the fully qualified name of the class containing the
    # execution point represented by this stack trace element.
    # 
    # @return the fully qualified name of the <tt>Class</tt> containing
    # the execution point represented by this stack trace element.
    def get_class_name
      return @declaring_class
    end
    
    typesig { [] }
    # Returns the name of the method containing the execution point
    # represented by this stack trace element.  If the execution point is
    # contained in an instance or class initializer, this method will return
    # the appropriate <i>special method name</i>, <tt>&lt;init&gt;</tt> or
    # <tt>&lt;clinit&gt;</tt>, as per Section 3.9 of <i>The Java Virtual
    # Machine Specification</i>.
    # 
    # @return the name of the method containing the execution point
    # represented by this stack trace element.
    def get_method_name
      return @method_name
    end
    
    typesig { [] }
    # Returns true if the method containing the execution point
    # represented by this stack trace element is a native method.
    # 
    # @return <tt>true</tt> if the method containing the execution point
    # represented by this stack trace element is a native method.
    def is_native_method
      return (@line_number).equal?(-2)
    end
    
    typesig { [] }
    # Returns a string representation of this stack trace element.  The
    # format of this string depends on the implementation, but the following
    # examples may be regarded as typical:
    # <ul>
    # <li>
    # <tt>"MyClass.mash(MyClass.java:9)"</tt> - Here, <tt>"MyClass"</tt>
    # is the <i>fully-qualified name</i> of the class containing the
    # execution point represented by this stack trace element,
    # <tt>"mash"</tt> is the name of the method containing the execution
    # point, <tt>"MyClass.java"</tt> is the source file containing the
    # execution point, and <tt>"9"</tt> is the line number of the source
    # line containing the execution point.
    # <li>
    # <tt>"MyClass.mash(MyClass.java)"</tt> - As above, but the line
    # number is unavailable.
    # <li>
    # <tt>"MyClass.mash(Unknown Source)"</tt> - As above, but neither
    # the file name nor the line  number are available.
    # <li>
    # <tt>"MyClass.mash(Native Method)"</tt> - As above, but neither
    # the file name nor the line  number are available, and the method
    # containing the execution point is known to be a native method.
    # </ul>
    # @see    Throwable#printStackTrace()
    def to_s
      return RJava.cast_to_string(get_class_name) + "." + @method_name + RJava.cast_to_string((is_native_method ? "(Native Method)" : (!(@file_name).nil? && @line_number >= 0 ? "(" + @file_name + ":" + RJava.cast_to_string(@line_number) + ")" : (!(@file_name).nil? ? "(" + @file_name + ")" : "(Unknown Source)"))))
    end
    
    typesig { [Object] }
    # Returns true if the specified object is another
    # <tt>StackTraceElement</tt> instance representing the same execution
    # point as this instance.  Two stack trace elements <tt>a</tt> and
    # <tt>b</tt> are equal if and only if:
    # <pre>
    # equals(a.getFileName(), b.getFileName()) &&
    # a.getLineNumber() == b.getLineNumber()) &&
    # equals(a.getClassName(), b.getClassName()) &&
    # equals(a.getMethodName(), b.getMethodName())
    # </pre>
    # where <tt>equals</tt> is defined as:
    # <pre>
    # static boolean equals(Object a, Object b) {
    # return a==b || (a != null && a.equals(b));
    # }
    # </pre>
    # 
    # @param  obj the object to be compared with this stack trace element.
    # @return true if the specified object is another
    # <tt>StackTraceElement</tt> instance representing the same
    # execution point as this instance.
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(StackTraceElement)))
        return false
      end
      e = obj
      return (e.attr_declaring_class == @declaring_class) && (e.attr_line_number).equal?(@line_number) && eq(@method_name, e.attr_method_name) && eq(@file_name, e.attr_file_name)
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      def eq(a, b)
        return (a).equal?(b) || (!(a).nil? && (a == b))
      end
    }
    
    typesig { [] }
    # Returns a hash code value for this stack trace element.
    def hash_code
      result = 31 * @declaring_class.hash_code + @method_name.hash_code
      result = 31 * result + ((@file_name).nil? ? 0 : @file_name.hash_code)
      result = 31 * result + @line_number
      return result
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 6992337162326171013 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__stack_trace_element, :initialize
  end
  
end
