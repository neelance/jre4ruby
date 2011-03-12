require "rjava"

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
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module ConcurrentNavigableMapImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
    }
  end
  
  # A {@link ConcurrentMap} supporting {@link NavigableMap} operations,
  # and recursively so for its navigable sub-maps.
  # 
  # <p>This interface is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author Doug Lea
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  # @since 1.6
  module ConcurrentNavigableMap
    include_class_members ConcurrentNavigableMapImports
    include ConcurrentMap
    include NavigableMap
    
    typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException     {@inheritDoc}
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_map(from_key, from_inclusive, to_key, to_inclusive)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException     {@inheritDoc}
    # @throws IllegalArgumentException {@inheritDoc}
    def head_map(to_key, inclusive)
      raise NotImplementedError
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException     {@inheritDoc}
    # @throws IllegalArgumentException {@inheritDoc}
    def tail_map(from_key, inclusive)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException     {@inheritDoc}
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_map(from_key, to_key)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException     {@inheritDoc}
    # @throws IllegalArgumentException {@inheritDoc}
    def head_map(to_key)
      raise NotImplementedError
    end
    
    typesig { [Object] }
    # @throws ClassCastException       {@inheritDoc}
    # @throws NullPointerException     {@inheritDoc}
    # @throws IllegalArgumentException {@inheritDoc}
    def tail_map(from_key)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a reverse order view of the mappings contained in this map.
    # The descending map is backed by this map, so changes to the map are
    # reflected in the descending map, and vice-versa.
    # 
    # <p>The returned map has an ordering equivalent to
    # <tt>{@link Collections#reverseOrder(Comparator) Collections.reverseOrder}(comparator())</tt>.
    # The expression {@code m.descendingMap().descendingMap()} returns a
    # view of {@code m} essentially equivalent to {@code m}.
    # 
    # @return a reverse order view of this map
    def descending_map
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a {@link NavigableSet} view of the keys contained in this map.
    # The set's iterator returns the keys in ascending order.
    # The set is backed by the map, so changes to the map are
    # reflected in the set, and vice-versa.  The set supports element
    # removal, which removes the corresponding mapping from the map,
    # via the {@code Iterator.remove}, {@code Set.remove},
    # {@code removeAll}, {@code retainAll}, and {@code clear}
    # operations.  It does not support the {@code add} or {@code addAll}
    # operations.
    # 
    # <p>The view's {@code iterator} is a "weakly consistent" iterator
    # that will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    # 
    # @return a navigable set view of the keys in this map
    def navigable_key_set
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a {@link NavigableSet} view of the keys contained in this map.
    # The set's iterator returns the keys in ascending order.
    # The set is backed by the map, so changes to the map are
    # reflected in the set, and vice-versa.  The set supports element
    # removal, which removes the corresponding mapping from the map,
    # via the {@code Iterator.remove}, {@code Set.remove},
    # {@code removeAll}, {@code retainAll}, and {@code clear}
    # operations.  It does not support the {@code add} or {@code addAll}
    # operations.
    # 
    # <p>The view's {@code iterator} is a "weakly consistent" iterator
    # that will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    # 
    # <p>This method is equivalent to method {@code navigableKeySet}.
    # 
    # @return a navigable set view of the keys in this map
    def key_set
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a reverse order {@link NavigableSet} view of the keys contained in this map.
    # The set's iterator returns the keys in descending order.
    # The set is backed by the map, so changes to the map are
    # reflected in the set, and vice-versa.  The set supports element
    # removal, which removes the corresponding mapping from the map,
    # via the {@code Iterator.remove}, {@code Set.remove},
    # {@code removeAll}, {@code retainAll}, and {@code clear}
    # operations.  It does not support the {@code add} or {@code addAll}
    # operations.
    # 
    # <p>The view's {@code iterator} is a "weakly consistent" iterator
    # that will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    # 
    # @return a reverse order navigable set view of the keys in this map
    def descending_key_set
      raise NotImplementedError
    end
  end
  
end
