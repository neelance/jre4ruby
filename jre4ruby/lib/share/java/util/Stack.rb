require "rjava"

# Copyright 1994-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module StackImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # The <code>Stack</code> class represents a last-in-first-out
  # (LIFO) stack of objects. It extends class <tt>Vector</tt> with five
  # operations that allow a vector to be treated as a stack. The usual
  # <tt>push</tt> and <tt>pop</tt> operations are provided, as well as a
  # method to <tt>peek</tt> at the top item on the stack, a method to test
  # for whether the stack is <tt>empty</tt>, and a method to <tt>search</tt>
  # the stack for an item and discover how far it is from the top.
  # <p>
  # When a stack is first created, it contains no items.
  # 
  # <p>A more complete and consistent set of LIFO stack operations is
  # provided by the {@link Deque} interface and its implementations, which
  # should be used in preference to this class.  For example:
  # <pre>   {@code
  # Deque<Integer> stack = new ArrayDeque<Integer>();}</pre>
  # 
  # @author  Jonathan Payne
  # @since   JDK1.0
  class Stack < StackImports.const_get :Vector
    include_class_members StackImports
    
    typesig { [] }
    # Creates an empty Stack.
    def initialize
      super()
    end
    
    typesig { [Object] }
    # Pushes an item onto the top of this stack. This has exactly
    # the same effect as:
    # <blockquote><pre>
    # addElement(item)</pre></blockquote>
    # 
    # @param   item   the item to be pushed onto this stack.
    # @return  the <code>item</code> argument.
    # @see     java.util.Vector#addElement
    def push(item)
      add_element(item)
      return item
    end
    
    typesig { [] }
    # Removes the object at the top of this stack and returns that
    # object as the value of this function.
    # 
    # @return     The object at the top of this stack (the last item
    # of the <tt>Vector</tt> object).
    # @exception  EmptyStackException  if this stack is empty.
    def pop
      synchronized(self) do
        obj = nil
        len = size
        obj = peek
        remove_element_at(len - 1)
        return obj
      end
    end
    
    typesig { [] }
    # Looks at the object at the top of this stack without removing it
    # from the stack.
    # 
    # @return     the object at the top of this stack (the last item
    # of the <tt>Vector</tt> object).
    # @exception  EmptyStackException  if this stack is empty.
    def peek
      synchronized(self) do
        len = size
        if ((len).equal?(0))
          raise EmptyStackException.new
        end
        return element_at(len - 1)
      end
    end
    
    typesig { [] }
    # Tests if this stack is empty.
    # 
    # @return  <code>true</code> if and only if this stack contains
    # no items; <code>false</code> otherwise.
    def empty
      return (size).equal?(0)
    end
    
    typesig { [Object] }
    # Returns the 1-based position where an object is on this stack.
    # If the object <tt>o</tt> occurs as an item in this stack, this
    # method returns the distance from the top of the stack of the
    # occurrence nearest the top of the stack; the topmost item on the
    # stack is considered to be at distance <tt>1</tt>. The <tt>equals</tt>
    # method is used to compare <tt>o</tt> to the
    # items in this stack.
    # 
    # @param   o   the desired object.
    # @return  the 1-based position from the top of the stack where
    # the object is located; the return value <code>-1</code>
    # indicates that the object is not on the stack.
    def search(o)
      synchronized(self) do
        i = last_index_of(o)
        if (i >= 0)
          return size - i
        end
        return -1
      end
    end
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 1224463164541339165 }
      const_attr_reader  :SerialVersionUID
    }
    
    private
    alias_method :initialize__stack, :initialize
  end
  
end
