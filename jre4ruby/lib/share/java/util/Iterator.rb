require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module IteratorImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # An iterator over a collection.  {@code Iterator} takes the place of
  # {@link Enumeration} in the Java Collections Framework.  Iterators
  # differ from enumerations in two ways:
  # 
  # <ul>
  #      <li> Iterators allow the caller to remove elements from the
  #           underlying collection during the iteration with well-defined
  #           semantics.
  #      <li> Method names have been improved.
  # </ul>
  # 
  # <p>This interface is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author  Josh Bloch
  # @see Collection
  # @see ListIterator
  # @see Iterable
  # @since 1.2
  module Iterator
    include_class_members IteratorImports
    
    typesig { [] }
    # Returns {@code true} if the iteration has more elements.
    # (In other words, returns {@code true} if {@link #next} would
    # return an element rather than throwing an exception.)
    # 
    # @return {@code true} if the iteration has more elements
    def has_next
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the next element in the iteration.
    # 
    # @return the next element in the iteration
    # @throws NoSuchElementException if the iteration has no more elements
    def next_
      raise NotImplementedError
    end
    
    typesig { [] }
    # Removes from the underlying collection the last element returned
    # by this iterator (optional operation).  This method can be called
    # only once per call to {@link #next}.  The behavior of an iterator
    # is unspecified if the underlying collection is modified while the
    # iteration is in progress in any way other than by calling this
    # method.
    # 
    # @throws UnsupportedOperationException if the {@code remove}
    #         operation is not supported by this iterator
    # 
    # @throws IllegalStateException if the {@code next} method has not
    #         yet been called, or the {@code remove} method has already
    #         been called after the last call to the {@code next}
    #         method
    def remove
      raise NotImplementedError
    end
  end
  
end
