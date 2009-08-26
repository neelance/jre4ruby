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
# 
# 
# This file is available under and governed by the GNU General Public
# License version 2 only, as published by the Free Software Foundation.
# However, the following notice accompanied the original version of this
# file:
# 
# Written by Doug Lea with assistance from members of JCP JSR-166
# Expert Group and released to the public domain, as explained at
# http://creativecommons.org/licenses/publicdomain
module Java::Util::Concurrent
  module ConcurrentSkipListMapImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Concurrent
      include ::Java::Util
      include ::Java::Util::Concurrent::Atomic
    }
  end
  
  # A scalable concurrent {@link ConcurrentNavigableMap} implementation.
  # The map is sorted according to the {@linkplain Comparable natural
  # ordering} of its keys, or by a {@link Comparator} provided at map
  # creation time, depending on which constructor is used.
  # 
  # <p>This class implements a concurrent variant of <a
  # href="http://www.cs.umd.edu/~pugh/">SkipLists</a> providing
  # expected average <i>log(n)</i> time cost for the
  # <tt>containsKey</tt>, <tt>get</tt>, <tt>put</tt> and
  # <tt>remove</tt> operations and their variants.  Insertion, removal,
  # update, and access operations safely execute concurrently by
  # multiple threads.  Iterators are <i>weakly consistent</i>, returning
  # elements reflecting the state of the map at some point at or since
  # the creation of the iterator.  They do <em>not</em> throw {@link
  # ConcurrentModificationException}, and may proceed concurrently with
  # other operations. Ascending key ordered views and their iterators
  # are faster than descending ones.
  # 
  # <p>All <tt>Map.Entry</tt> pairs returned by methods in this class
  # and its views represent snapshots of mappings at the time they were
  # produced. They do <em>not</em> support the <tt>Entry.setValue</tt>
  # method. (Note however that it is possible to change mappings in the
  # associated map using <tt>put</tt>, <tt>putIfAbsent</tt>, or
  # <tt>replace</tt>, depending on exactly which effect you need.)
  # 
  # <p>Beware that, unlike in most collections, the <tt>size</tt>
  # method is <em>not</em> a constant-time operation. Because of the
  # asynchronous nature of these maps, determining the current number
  # of elements requires a traversal of the elements.  Additionally,
  # the bulk operations <tt>putAll</tt>, <tt>equals</tt>, and
  # <tt>clear</tt> are <em>not</em> guaranteed to be performed
  # atomically. For example, an iterator operating concurrently with a
  # <tt>putAll</tt> operation might view only some of the added
  # elements.
  # 
  # <p>This class and its views and iterators implement all of the
  # <em>optional</em> methods of the {@link Map} and {@link Iterator}
  # interfaces. Like most other concurrent collections, this class does
  # <em>not</em> permit the use of <tt>null</tt> keys or values because some
  # null return values cannot be reliably distinguished from the absence of
  # elements.
  # 
  # <p>This class is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @author Doug Lea
  # @param <K> the type of keys maintained by this map
  # @param <V> the type of mapped values
  # @since 1.6
  class ConcurrentSkipListMap < ConcurrentSkipListMapImports.const_get :AbstractMap
    include_class_members ConcurrentSkipListMapImports
    overload_protected {
      include ConcurrentNavigableMap
      include Cloneable
      include Java::Io::Serializable
    }
    
    class_module.module_eval {
      # This class implements a tree-like two-dimensionally linked skip
      # list in which the index levels are represented in separate
      # nodes from the base nodes holding data.  There are two reasons
      # for taking this approach instead of the usual array-based
      # structure: 1) Array based implementations seem to encounter
      # more complexity and overhead 2) We can use cheaper algorithms
      # for the heavily-traversed index lists than can be used for the
      # base lists.  Here's a picture of some of the basics for a
      # possible list with 2 levels of index:
      # 
      # Head nodes          Index nodes
      # +-+    right        +-+                      +-+
      # |2|---------------->| |--------------------->| |->null
      # +-+                 +-+                      +-+
      # | down              |                        |
      # v                   v                        v
      # +-+            +-+  +-+       +-+            +-+       +-+
      # |1|----------->| |->| |------>| |----------->| |------>| |->null
      # +-+            +-+  +-+       +-+            +-+       +-+
      # v              |    |         |              |         |
      # Nodes  next     v    v         v              v         v
      # +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+
      # | |->|A|->|B|->|C|->|D|->|E|->|F|->|G|->|H|->|I|->|J|->|K|->null
      # +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+  +-+
      # 
      # The base lists use a variant of the HM linked ordered set
      # algorithm. See Tim Harris, "A pragmatic implementation of
      # non-blocking linked lists"
      # http://www.cl.cam.ac.uk/~tlh20/publications.html and Maged
      # Michael "High Performance Dynamic Lock-Free Hash Tables and
      # List-Based Sets"
      # http://www.research.ibm.com/people/m/michael/pubs.htm.  The
      # basic idea in these lists is to mark the "next" pointers of
      # deleted nodes when deleting to avoid conflicts with concurrent
      # insertions, and when traversing to keep track of triples
      # (predecessor, node, successor) in order to detect when and how
      # to unlink these deleted nodes.
      # 
      # Rather than using mark-bits to mark list deletions (which can
      # be slow and space-intensive using AtomicMarkedReference), nodes
      # use direct CAS'able next pointers.  On deletion, instead of
      # marking a pointer, they splice in another node that can be
      # thought of as standing for a marked pointer (indicating this by
      # using otherwise impossible field values).  Using plain nodes
      # acts roughly like "boxed" implementations of marked pointers,
      # but uses new nodes only when nodes are deleted, not for every
      # link.  This requires less space and supports faster
      # traversal. Even if marked references were better supported by
      # JVMs, traversal using this technique might still be faster
      # because any search need only read ahead one more node than
      # otherwise required (to check for trailing marker) rather than
      # unmasking mark bits or whatever on each read.
      # 
      # This approach maintains the essential property needed in the HM
      # algorithm of changing the next-pointer of a deleted node so
      # that any other CAS of it will fail, but implements the idea by
      # changing the pointer to point to a different node, not by
      # marking it.  While it would be possible to further squeeze
      # space by defining marker nodes not to have key/value fields, it
      # isn't worth the extra type-testing overhead.  The deletion
      # markers are rarely encountered during traversal and are
      # normally quickly garbage collected. (Note that this technique
      # would not work well in systems without garbage collection.)
      # 
      # In addition to using deletion markers, the lists also use
      # nullness of value fields to indicate deletion, in a style
      # similar to typical lazy-deletion schemes.  If a node's value is
      # null, then it is considered logically deleted and ignored even
      # though it is still reachable. This maintains proper control of
      # concurrent replace vs delete operations -- an attempted replace
      # must fail if a delete beat it by nulling field, and a delete
      # must return the last non-null value held in the field. (Note:
      # Null, rather than some special marker, is used for value fields
      # here because it just so happens to mesh with the Map API
      # requirement that method get returns null if there is no
      # mapping, which allows nodes to remain concurrently readable
      # even when deleted. Using any other marker value here would be
      # messy at best.)
      # 
      # Here's the sequence of events for a deletion of node n with
      # predecessor b and successor f, initially:
      # 
      # +------+       +------+      +------+
      # ...  |   b  |------>|   n  |----->|   f  | ...
      # +------+       +------+      +------+
      # 
      # 1. CAS n's value field from non-null to null.
      # From this point on, no public operations encountering
      # the node consider this mapping to exist. However, other
      # ongoing insertions and deletions might still modify
      # n's next pointer.
      # 
      # 2. CAS n's next pointer to point to a new marker node.
      # From this point on, no other nodes can be appended to n.
      # which avoids deletion errors in CAS-based linked lists.
      # 
      # +------+       +------+      +------+       +------+
      # ...  |   b  |------>|   n  |----->|marker|------>|   f  | ...
      # +------+       +------+      +------+       +------+
      # 
      # 3. CAS b's next pointer over both n and its marker.
      # From this point on, no new traversals will encounter n,
      # and it can eventually be GCed.
      # +------+                                    +------+
      # ...  |   b  |----------------------------------->|   f  | ...
      # +------+                                    +------+
      # 
      # A failure at step 1 leads to simple retry due to a lost race
      # with another operation. Steps 2-3 can fail because some other
      # thread noticed during a traversal a node with null value and
      # helped out by marking and/or unlinking.  This helping-out
      # ensures that no thread can become stuck waiting for progress of
      # the deleting thread.  The use of marker nodes slightly
      # complicates helping-out code because traversals must track
      # consistent reads of up to four nodes (b, n, marker, f), not
      # just (b, n, f), although the next field of a marker is
      # immutable, and once a next field is CAS'ed to point to a
      # marker, it never again changes, so this requires less care.
      # 
      # Skip lists add indexing to this scheme, so that the base-level
      # traversals start close to the locations being found, inserted
      # or deleted -- usually base level traversals only traverse a few
      # nodes. This doesn't change the basic algorithm except for the
      # need to make sure base traversals start at predecessors (here,
      # b) that are not (structurally) deleted, otherwise retrying
      # after processing the deletion.
      # 
      # Index levels are maintained as lists with volatile next fields,
      # using CAS to link and unlink.  Races are allowed in index-list
      # operations that can (rarely) fail to link in a new index node
      # or delete one. (We can't do this of course for data nodes.)
      # However, even when this happens, the index lists remain sorted,
      # so correctly serve as indices.  This can impact performance,
      # but since skip lists are probabilistic anyway, the net result
      # is that under contention, the effective "p" value may be lower
      # than its nominal value. And race windows are kept small enough
      # that in practice these failures are rare, even under a lot of
      # contention.
      # 
      # The fact that retries (for both base and index lists) are
      # relatively cheap due to indexing allows some minor
      # simplifications of retry logic. Traversal restarts are
      # performed after most "helping-out" CASes. This isn't always
      # strictly necessary, but the implicit backoffs tend to help
      # reduce other downstream failed CAS's enough to outweigh restart
      # cost.  This worsens the worst case, but seems to improve even
      # highly contended cases.
      # 
      # Unlike most skip-list implementations, index insertion and
      # deletion here require a separate traversal pass occuring after
      # the base-level action, to add or remove index nodes.  This adds
      # to single-threaded overhead, but improves contended
      # multithreaded performance by narrowing interference windows,
      # and allows deletion to ensure that all index nodes will be made
      # unreachable upon return from a public remove operation, thus
      # avoiding unwanted garbage retention. This is more important
      # here than in some other data structures because we cannot null
      # out node fields referencing user keys since they might still be
      # read by other ongoing traversals.
      # 
      # Indexing uses skip list parameters that maintain good search
      # performance while using sparser-than-usual indices: The
      # hardwired parameters k=1, p=0.5 (see method randomLevel) mean
      # that about one-quarter of the nodes have indices. Of those that
      # do, half have one level, a quarter have two, and so on (see
      # Pugh's Skip List Cookbook, sec 3.4).  The expected total space
      # requirement for a map is slightly less than for the current
      # implementation of java.util.TreeMap.
      # 
      # Changing the level of the index (i.e, the height of the
      # tree-like structure) also uses CAS. The head index has initial
      # level/height of one. Creation of an index with height greater
      # than the current level adds a level to the head index by
      # CAS'ing on a new top-most head. To maintain good performance
      # after a lot of removals, deletion methods heuristically try to
      # reduce the height if the topmost levels appear to be empty.
      # This may encounter races in which it possible (but rare) to
      # reduce and "lose" a level just as it is about to contain an
      # index (that will then never be encountered). This does no
      # structural harm, and in practice appears to be a better option
      # than allowing unrestrained growth of levels.
      # 
      # The code for all this is more verbose than you'd like. Most
      # operations entail locating an element (or position to insert an
      # element). The code to do this can't be nicely factored out
      # because subsequent uses require a snapshot of predecessor
      # and/or successor and/or value fields which can't be returned
      # all at once, at least not without creating yet another object
      # to hold them -- creating such little objects is an especially
      # bad idea for basic internal search operations because it adds
      # to GC overhead.  (This is one of the few times I've wished Java
      # had macros.) Instead, some traversal code is interleaved within
      # insertion and removal operations.  The control logic to handle
      # all the retry conditions is sometimes twisty. Most search is
      # broken into 2 parts. findPredecessor() searches index nodes
      # only, returning a base-level predecessor of the key. findNode()
      # finishes out the base-level search. Even with this factoring,
      # there is a fair amount of near-duplication of code to handle
      # variants.
      # 
      # For explanation of algorithms sharing at least a couple of
      # features with this one, see Mikhail Fomitchev's thesis
      # (http://www.cs.yorku.ca/~mikhail/), Keir Fraser's thesis
      # (http://www.cl.cam.ac.uk/users/kaf24/), and Hakan Sundell's
      # thesis (http://www.cs.chalmers.se/~phs/).
      # 
      # Given the use of tree-like index nodes, you might wonder why
      # this doesn't use some kind of search tree instead, which would
      # support somewhat faster search operations. The reason is that
      # there are no known efficient lock-free insertion and deletion
      # algorithms for search trees. The immutability of the "down"
      # links of index nodes (as opposed to mutable "left" fields in
      # true trees) makes this tractable using only CAS operations.
      # 
      # Notation guide for local variables
      # Node:         b, n, f    for  predecessor, node, successor
      # Index:        q, r, d    for index node, right, down.
      # t          for another index node
      # Head:         h
      # Levels:       j
      # Keys:         k, key
      # Values:       v, value
      # Comparisons:  c
      const_set_lazy(:SerialVersionUID) { -8627078645895051609 }
      const_attr_reader  :SerialVersionUID
      
      # Generates the initial random seed for the cheaper per-instance
      # random number generators used in randomLevel.
      const_set_lazy(:SeedGenerator) { Random.new }
      const_attr_reader  :SeedGenerator
      
      # Special value used to identify base-level header
      const_set_lazy(:BASE_HEADER) { Object.new }
      const_attr_reader  :BASE_HEADER
    }
    
    # The topmost head index of the skiplist.
    attr_accessor :head
    alias_method :attr_head, :head
    undef_method :head
    alias_method :attr_head=, :head=
    undef_method :head=
    
    # The comparator used to maintain order in this map, or null
    # if using natural ordering.
    # @serial
    attr_accessor :comparator
    alias_method :attr_comparator, :comparator
    undef_method :comparator
    alias_method :attr_comparator=, :comparator=
    undef_method :comparator=
    
    # Seed for simple random number generator.  Not volatile since it
    # doesn't matter too much if different threads don't see updates.
    attr_accessor :random_seed
    alias_method :attr_random_seed, :random_seed
    undef_method :random_seed
    alias_method :attr_random_seed=, :random_seed=
    undef_method :random_seed=
    
    # Lazily initialized key set
    attr_accessor :key_set
    alias_method :attr_key_set, :key_set
    undef_method :key_set
    alias_method :attr_key_set=, :key_set=
    undef_method :key_set=
    
    # Lazily initialized entry set
    attr_accessor :entry_set
    alias_method :attr_entry_set, :entry_set
    undef_method :entry_set
    alias_method :attr_entry_set=, :entry_set=
    undef_method :entry_set=
    
    # Lazily initialized values collection
    attr_accessor :values
    alias_method :attr_values, :values
    undef_method :values
    alias_method :attr_values=, :values=
    undef_method :values=
    
    # Lazily initialized descending key set
    attr_accessor :descending_map
    alias_method :attr_descending_map, :descending_map
    undef_method :descending_map
    alias_method :attr_descending_map=, :descending_map=
    undef_method :descending_map=
    
    typesig { [] }
    # Initializes or resets state. Needed by constructors, clone,
    # clear, readObject. and ConcurrentSkipListSet.clone.
    # (Note that comparator must be separately initialized.)
    def initialize_
      @key_set = nil
      @entry_set = nil
      @values = nil
      @descending_map = nil
      @random_seed = SeedGenerator.next_int | 0x100 # ensure nonzero
      @head = HeadIndex.new(Node.new(nil, BASE_HEADER, nil), nil, nil, 1)
    end
    
    class_module.module_eval {
      # Updater for casHead
      const_set_lazy(:HeadUpdater) { AtomicReferenceFieldUpdater.new_updater(ConcurrentSkipListMap, HeadIndex, "head") }
      const_attr_reader  :HeadUpdater
    }
    
    typesig { [HeadIndex, HeadIndex] }
    # compareAndSet head node
    def cas_head(cmp, val)
      return HeadUpdater.compare_and_set(self, cmp, val)
    end
    
    class_module.module_eval {
      # ---------------- Nodes --------------
      # 
      # Nodes hold keys and values, and are singly linked in sorted
      # order, possibly with some intervening marker nodes. The list is
      # headed by a dummy node accessible as head.node. The value field
      # is declared only as Object because it takes special non-V
      # values for marker and header nodes.
      const_set_lazy(:Node) { Class.new do
        include_class_members ConcurrentSkipListMap
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :value
        alias_method :attr_value, :value
        undef_method :value
        alias_method :attr_value=, :value=
        undef_method :value=
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        typesig { [Object, Object, self::Node] }
        # Creates a new regular node.
        def initialize(key, value, next_)
          @key = nil
          @value = nil
          @next = nil
          @key = key
          @value = value
          @next = next_
        end
        
        typesig { [self::Node] }
        # Creates a new marker node. A marker is distinguished by
        # having its value field point to itself.  Marker nodes also
        # have null keys, a fact that is exploited in a few places,
        # but this doesn't distinguish markers from the base-level
        # header node (head.node), which also has a null key.
        def initialize(next_)
          @key = nil
          @value = nil
          @next = nil
          @key = nil
          @value = self
          @next = next_
        end
        
        class_module.module_eval {
          # Updater for casNext
          const_set_lazy(:NextUpdater) { AtomicReferenceFieldUpdater.new_updater(Node, Node, "next") }
          const_attr_reader  :NextUpdater
          
          # Updater for casValue
          const_set_lazy(:ValueUpdater) { AtomicReferenceFieldUpdater.new_updater(Node, Object, "value") }
          const_attr_reader  :ValueUpdater
        }
        
        typesig { [Object, Object] }
        # compareAndSet value field
        def cas_value(cmp, val)
          return self.class::ValueUpdater.compare_and_set(self, cmp, val)
        end
        
        typesig { [self::Node, self::Node] }
        # compareAndSet next field
        def cas_next(cmp, val)
          return self.class::NextUpdater.compare_and_set(self, cmp, val)
        end
        
        typesig { [] }
        # Returns true if this node is a marker. This method isn't
        # actually called in any current code checking for markers
        # because callers will have already read value field and need
        # to use that read (not another done here) and so directly
        # test if value points to node.
        # @param n a possibly null reference to a node
        # @return true if this node is a marker node
        def is_marker
          return (@value).equal?(self)
        end
        
        typesig { [] }
        # Returns true if this node is the header of base-level list.
        # @return true if this node is header node
        def is_base_header
          return (@value).equal?(BASE_HEADER)
        end
        
        typesig { [self::Node] }
        # Tries to append a deletion marker to this node.
        # @param f the assumed current successor of this node
        # @return true if successful
        def append_marker(f)
          return cas_next(f, self.class::Node.new(f))
        end
        
        typesig { [self::Node, self::Node] }
        # Helps out a deletion by appending marker or unlinking from
        # predecessor. This is called during traversals when value
        # field seen to be null.
        # @param b predecessor
        # @param f successor
        def help_delete(b, f)
          # Rechecking links and then doing only one of the
          # help-out stages per call tends to minimize CAS
          # interference among helping threads.
          if ((f).equal?(@next) && (self).equal?(b.attr_next))
            if ((f).nil? || !(f.attr_value).equal?(f))
              # not already marked
              append_marker(f)
            else
              b.cas_next(self, f.attr_next)
            end
          end
        end
        
        typesig { [] }
        # Returns value if this node contains a valid key-value pair,
        # else null.
        # @return this node's value if it isn't a marker or header or
        # is deleted, else null.
        def get_valid_value
          v = @value
          if ((v).equal?(self) || (v).equal?(BASE_HEADER))
            return nil
          end
          return v
        end
        
        typesig { [] }
        # Creates and returns a new SimpleImmutableEntry holding current
        # mapping if this node holds a valid value, else null.
        # @return new entry or null
        def create_snapshot
          v = get_valid_value
          if ((v).nil?)
            return nil
          end
          return self.class::AbstractMap::SimpleImmutableEntry.new(@key, v)
        end
        
        private
        alias_method :initialize__node, :initialize
      end }
      
      # ---------------- Indexing --------------
      # 
      # Index nodes represent the levels of the skip list.  Note that
      # even though both Nodes and Indexes have forward-pointing
      # fields, they have different types and are handled in different
      # ways, that can't nicely be captured by placing field in a
      # shared abstract class.
      const_set_lazy(:Index) { Class.new do
        include_class_members ConcurrentSkipListMap
        
        attr_accessor :node
        alias_method :attr_node, :node
        undef_method :node
        alias_method :attr_node=, :node=
        undef_method :node=
        
        attr_accessor :down
        alias_method :attr_down, :down
        undef_method :down
        alias_method :attr_down=, :down=
        undef_method :down=
        
        attr_accessor :right
        alias_method :attr_right, :right
        undef_method :right
        alias_method :attr_right=, :right=
        undef_method :right=
        
        typesig { [self::Node, self::Index, self::Index] }
        # Creates index node with given values.
        def initialize(node, down, right)
          @node = nil
          @down = nil
          @right = nil
          @node = node
          @down = down
          @right = right
        end
        
        class_module.module_eval {
          # Updater for casRight
          const_set_lazy(:RightUpdater) { AtomicReferenceFieldUpdater.new_updater(Index, Index, "right") }
          const_attr_reader  :RightUpdater
        }
        
        typesig { [self::Index, self::Index] }
        # compareAndSet right field
        def cas_right(cmp, val)
          return self.class::RightUpdater.compare_and_set(self, cmp, val)
        end
        
        typesig { [] }
        # Returns true if the node this indexes has been deleted.
        # @return true if indexed node is known to be deleted
        def indexes_deleted_node
          return (@node.attr_value).nil?
        end
        
        typesig { [self::Index, self::Index] }
        # Tries to CAS newSucc as successor.  To minimize races with
        # unlink that may lose this index node, if the node being
        # indexed is known to be deleted, it doesn't try to link in.
        # @param succ the expected current successor
        # @param newSucc the new successor
        # @return true if successful
        def link(succ, new_succ)
          n = @node
          new_succ.attr_right = succ
          return !(n.attr_value).nil? && cas_right(succ, new_succ)
        end
        
        typesig { [self::Index] }
        # Tries to CAS right field to skip over apparent successor
        # succ.  Fails (forcing a retraversal by caller) if this node
        # is known to be deleted.
        # @param succ the expected current successor
        # @return true if successful
        def unlink(succ)
          return !indexes_deleted_node && cas_right(succ, succ.attr_right)
        end
        
        private
        alias_method :initialize__index, :initialize
      end }
      
      # ---------------- Head nodes --------------
      # 
      # Nodes heading each level keep track of their level.
      const_set_lazy(:HeadIndex) { Class.new(Index) do
        include_class_members ConcurrentSkipListMap
        
        attr_accessor :level
        alias_method :attr_level, :level
        undef_method :level
        alias_method :attr_level=, :level=
        undef_method :level=
        
        typesig { [self::Node, self::Index, self::Index, ::Java::Int] }
        def initialize(node, down, right, level)
          @level = 0
          super(node, down, right)
          @level = level
        end
        
        private
        alias_method :initialize__head_index, :initialize
      end }
      
      # ---------------- Comparison utilities --------------
      # 
      # Represents a key with a comparator as a Comparable.
      # 
      # Because most sorted collections seem to use natural ordering on
      # Comparables (Strings, Integers, etc), most internal methods are
      # geared to use them. This is generally faster than checking
      # per-comparison whether to use comparator or comparable because
      # it doesn't require a (Comparable) cast for each comparison.
      # (Optimizers can only sometimes remove such redundant checks
      # themselves.) When Comparators are used,
      # ComparableUsingComparators are created so that they act in the
      # same way as natural orderings. This penalizes use of
      # Comparators vs Comparables, which seems like the right
      # tradeoff.
      const_set_lazy(:ComparableUsingComparator) { Class.new do
        include_class_members ConcurrentSkipListMap
        include JavaComparable
        
        attr_accessor :actual_key
        alias_method :attr_actual_key, :actual_key
        undef_method :actual_key
        alias_method :attr_actual_key=, :actual_key=
        undef_method :actual_key=
        
        attr_accessor :cmp
        alias_method :attr_cmp, :cmp
        undef_method :cmp
        alias_method :attr_cmp=, :cmp=
        undef_method :cmp=
        
        typesig { [Object, self::Comparator] }
        def initialize(key, cmp)
          @actual_key = nil
          @cmp = nil
          @actual_key = key
          @cmp = cmp
        end
        
        typesig { [Object] }
        def compare_to(k2)
          return @cmp.compare(@actual_key, k2)
        end
        
        private
        alias_method :initialize__comparable_using_comparator, :initialize
      end }
    }
    
    typesig { [Object] }
    # If using comparator, return a ComparableUsingComparator, else
    # cast key as Comparable, which may cause ClassCastException,
    # which is propagated back to caller.
    def comparable(key)
      if ((key).nil?)
        raise NullPointerException.new
      end
      if (!(@comparator).nil?)
        return ComparableUsingComparator.new(key, @comparator)
      else
        return key
      end
    end
    
    typesig { [Object, Object] }
    # Compares using comparator or natural ordering. Used when the
    # ComparableUsingComparator approach doesn't apply.
    def compare(k1, k2)
      cmp = @comparator
      if (!(cmp).nil?)
        return cmp.compare(k1, k2)
      else
        return ((k1) <=> k2)
      end
    end
    
    typesig { [Object, Object, Object] }
    # Returns true if given key greater than or equal to least and
    # strictly less than fence, bypassing either test if least or
    # fence are null. Needed mainly in submap operations.
    def in_half_open_range(key, least, fence)
      if ((key).nil?)
        raise NullPointerException.new
      end
      return (((least).nil? || compare(key, least) >= 0) && ((fence).nil? || compare(key, fence) < 0))
    end
    
    typesig { [Object, Object, Object] }
    # Returns true if given key greater than or equal to least and less
    # or equal to fence. Needed mainly in submap operations.
    def in_open_range(key, least, fence)
      if ((key).nil?)
        raise NullPointerException.new
      end
      return (((least).nil? || compare(key, least) >= 0) && ((fence).nil? || compare(key, fence) <= 0))
    end
    
    typesig { [JavaComparable] }
    # ---------------- Traversal --------------
    # 
    # Returns a base-level node with key strictly less than given key,
    # or the base-level header if there is no such node.  Also
    # unlinks indexes to deleted nodes found along the way.  Callers
    # rely on this side-effect of clearing indices to deleted nodes.
    # @param key the key
    # @return a predecessor of key
    def find_predecessor(key)
      if ((key).nil?)
        raise NullPointerException.new
      end # don't postpone errors
      loop do
        q = @head
        r = q.attr_right
        loop do
          if (!(r).nil?)
            n = r.attr_node
            k = n.attr_key
            if ((n.attr_value).nil?)
              if (!q.unlink(r))
                break
              end # restart
              r = q.attr_right # reread r
              next
            end
            if ((key <=> k) > 0)
              q = r
              r = r.attr_right
              next
            end
          end
          d = q.attr_down
          if (!(d).nil?)
            q = d
            r = d.attr_right
          else
            return q.attr_node
          end
        end
      end
    end
    
    typesig { [JavaComparable] }
    # Returns node holding key or null if no such, clearing out any
    # deleted nodes seen along the way.  Repeatedly traverses at
    # base-level looking for key starting at predecessor returned
    # from findPredecessor, processing base-level deletions as
    # encountered. Some callers rely on this side-effect of clearing
    # deleted nodes.
    # 
    # Restarts occur, at traversal step centered on node n, if:
    # 
    # (1) After reading n's next field, n is no longer assumed
    # predecessor b's current successor, which means that
    # we don't have a consistent 3-node snapshot and so cannot
    # unlink any subsequent deleted nodes encountered.
    # 
    # (2) n's value field is null, indicating n is deleted, in
    # which case we help out an ongoing structural deletion
    # before retrying.  Even though there are cases where such
    # unlinking doesn't require restart, they aren't sorted out
    # here because doing so would not usually outweigh cost of
    # restarting.
    # 
    # (3) n is a marker or n's predecessor's value field is null,
    # indicating (among other possibilities) that
    # findPredecessor returned a deleted node. We can't unlink
    # the node because we don't know its predecessor, so rely
    # on another call to findPredecessor to notice and return
    # some earlier predecessor, which it will do. This check is
    # only strictly needed at beginning of loop, (and the
    # b.value check isn't strictly needed at all) but is done
    # each iteration to help avoid contention with other
    # threads by callers that will fail to be able to change
    # links, and so will retry anyway.
    # 
    # The traversal loops in doPut, doRemove, and findNear all
    # include the same three kinds of checks. And specialized
    # versions appear in findFirst, and findLast and their
    # variants. They can't easily share code because each uses the
    # reads of fields held in locals occurring in the orders they
    # were performed.
    # 
    # @param key the key
    # @return node holding key, or null if no such
    def find_node(key)
      loop do
        b = find_predecessor(key)
        n = b.attr_next
        loop do
          if ((n).nil?)
            return nil
          end
          f = n.attr_next
          if (!(n).equal?(b.attr_next))
            # inconsistent read
            break
          end
          v = n.attr_value
          if ((v).nil?)
            # n is deleted
            n.help_delete(b, f)
            break
          end
          if ((v).equal?(n) || (b.attr_value).nil?)
            # b is deleted
            break
          end
          c = (key <=> n.attr_key)
          if ((c).equal?(0))
            return n
          end
          if (c < 0)
            return nil
          end
          b = n
          n = f
        end
      end
    end
    
    typesig { [Object] }
    # Specialized variant of findNode to perform Map.get. Does a weak
    # traversal, not bothering to fix any deleted index nodes,
    # returning early if it happens to see key in index, and passing
    # over any deleted base nodes, falling back to getUsingFindNode
    # only if it would otherwise return value from an ongoing
    # deletion. Also uses "bound" to eliminate need for some
    # comparisons (see Pugh Cookbook). Also folds uses of null checks
    # and node-skipping because markers have null keys.
    # @param okey the key
    # @return the value, or null if absent
    def do_get(okey)
      key = comparable(okey)
      bound = nil
      q = @head
      r = q.attr_right
      n = nil
      k = nil
      c = 0
      loop do
        d = nil
        # Traverse rights
        if (!(r).nil? && !((n = r.attr_node)).equal?(bound) && !((k = n.attr_key)).nil?)
          if ((c = (key <=> k)) > 0)
            q = r
            r = r.attr_right
            next
          else
            if ((c).equal?(0))
              v = n.attr_value
              return (!(v).nil?) ? v : get_using_find_node(key)
            else
              bound = n
            end
          end
        end
        # Traverse down
        if (!((d = q.attr_down)).nil?)
          q = d
          r = d.attr_right
        else
          break
        end
      end
      # Traverse nexts
      n = q.attr_node.attr_next
      while !(n).nil?
        if (!((k = n.attr_key)).nil?)
          if (((c = (key <=> k))).equal?(0))
            v = n.attr_value
            return (!(v).nil?) ? v : get_using_find_node(key)
          else
            if (c < 0)
              break
            end
          end
        end
        n = n.attr_next
      end
      return nil
    end
    
    typesig { [JavaComparable] }
    # Performs map.get via findNode.  Used as a backup if doGet
    # encounters an in-progress deletion.
    # @param key the key
    # @return the value, or null if absent
    def get_using_find_node(key)
      # Loop needed here and elsewhere in case value field goes
      # null just as it is about to be returned, in which case we
      # lost a race with a deletion, so must retry.
      loop do
        n = find_node(key)
        if ((n).nil?)
          return nil
        end
        v = n.attr_value
        if (!(v).nil?)
          return v
        end
      end
    end
    
    typesig { [Object, Object, ::Java::Boolean] }
    # ---------------- Insertion --------------
    # 
    # Main insertion method.  Adds element if not present, or
    # replaces value if present and onlyIfAbsent is false.
    # @param kkey the key
    # @param value  the value that must be associated with key
    # @param onlyIfAbsent if should not insert if already present
    # @return the old value, or null if newly inserted
    def do_put(kkey, value, only_if_absent)
      key = comparable(kkey)
      loop do
        b = find_predecessor(key)
        n = b.attr_next
        loop do
          if (!(n).nil?)
            f = n.attr_next
            if (!(n).equal?(b.attr_next))
              # inconsistent read
              break
            end
            v = n.attr_value
            if ((v).nil?)
              # n is deleted
              n.help_delete(b, f)
              break
            end
            if ((v).equal?(n) || (b.attr_value).nil?)
              # b is deleted
              break
            end
            c = (key <=> n.attr_key)
            if (c > 0)
              b = n
              n = f
              next
            end
            if ((c).equal?(0))
              if (only_if_absent || n.cas_value(v, value))
                return v
              else
                break
              end # restart if lost race to replace value
            end
            # else c < 0; fall through
          end
          z = Node.new(kkey, value, n)
          if (!b.cas_next(n, z))
            break
          end # restart if lost race to append to b
          level = random_level
          if (level > 0)
            insert_index(z, level)
          end
          return nil
        end
      end
    end
    
    typesig { [] }
    # Returns a random level for inserting a new node.
    # Hardwired to k=1, p=0.5, max 31 (see above and
    # Pugh's "Skip List Cookbook", sec 3.4).
    # 
    # This uses the simplest of the generators described in George
    # Marsaglia's "Xorshift RNGs" paper.  This is not a high-quality
    # generator but is acceptable here.
    def random_level
      x = @random_seed
      x ^= x << 13
      x ^= x >> 17
      @random_seed = x ^= x << 5
      if (!((x & 0x8001)).equal?(0))
        # test highest and lowest bits
        return 0
      end
      level = 1
      while (!(((x >>= 1) & 1)).equal?(0))
        (level += 1)
      end
      return level
    end
    
    typesig { [Node, ::Java::Int] }
    # Creates and adds index nodes for the given node.
    # @param z the node
    # @param level the level of the index
    def insert_index(z, level)
      h = @head
      max = h.attr_level
      if (level <= max)
        idx = nil
        i = 1
        while i <= level
          idx = Index.new(z, idx, nil)
          (i += 1)
        end
        add_index(idx, h, level)
      else
        # Add a new level
        # 
        # To reduce interference by other threads checking for
        # empty levels in tryReduceLevel, new levels are added
        # with initialized right pointers. Which in turn requires
        # keeping levels in an array to access them while
        # creating new head index nodes from the opposite
        # direction.
        level = max + 1
        idxs = Array.typed(Index).new(level + 1) { nil }
        idx = nil
        i = 1
        while i <= level
          idxs[i] = idx = Index.new(z, idx, nil)
          (i += 1)
        end
        oldh = nil
        k = 0
        loop do
          oldh = @head
          old_level = oldh.attr_level
          if (level <= old_level)
            # lost race to add level
            k = level
            break
          end
          newh = oldh
          oldbase = oldh.attr_node
          j = old_level + 1
          while j <= level
            newh = HeadIndex.new(oldbase, newh, idxs[j], j)
            (j += 1)
          end
          if (cas_head(oldh, newh))
            k = old_level
            break
          end
        end
        add_index(idxs[k], oldh, k)
      end
    end
    
    typesig { [Index, HeadIndex, ::Java::Int] }
    # Adds given index nodes from given level down to 1.
    # @param idx the topmost index node being inserted
    # @param h the value of head to use to insert. This must be
    # snapshotted by callers to provide correct insertion level
    # @param indexLevel the level of the index
    def add_index(idx, h, index_level)
      # Track next level to insert in case of retries
      insertion_level = index_level
      key = comparable(idx.attr_node.attr_key)
      if ((key).nil?)
        raise NullPointerException.new
      end
      # Similar to findPredecessor, but adding index nodes along
      # path to key.
      loop do
        j = h.attr_level
        q = h
        r = q.attr_right
        t = idx
        loop do
          if (!(r).nil?)
            n = r.attr_node
            # compare before deletion check avoids needing recheck
            c = (key <=> n.attr_key)
            if ((n.attr_value).nil?)
              if (!q.unlink(r))
                break
              end
              r = q.attr_right
              next
            end
            if (c > 0)
              q = r
              r = r.attr_right
              next
            end
          end
          if ((j).equal?(insertion_level))
            # Don't insert index if node already deleted
            if (t.indexes_deleted_node)
              find_node(key) # cleans up
              return
            end
            if (!q.link(r, t))
              break
            end # restart
            if (((insertion_level -= 1)).equal?(0))
              # need final deletion check before return
              if (t.indexes_deleted_node)
                find_node(key)
              end
              return
            end
          end
          if ((j -= 1) >= insertion_level && j < index_level)
            t = t.attr_down
          end
          q = q.attr_down
          r = q.attr_right
        end
      end
    end
    
    typesig { [Object, Object] }
    # ---------------- Deletion --------------
    # 
    # Main deletion method. Locates node, nulls value, appends a
    # deletion marker, unlinks predecessor, removes associated index
    # nodes, and possibly reduces head index level.
    # 
    # Index nodes are cleared out simply by calling findPredecessor.
    # which unlinks indexes to deleted nodes found along path to key,
    # which will include the indexes to this node.  This is done
    # unconditionally. We can't check beforehand whether there are
    # index nodes because it might be the case that some or all
    # indexes hadn't been inserted yet for this node during initial
    # search for it, and we'd like to ensure lack of garbage
    # retention, so must call to be sure.
    # 
    # @param okey the key
    # @param value if non-null, the value that must be
    # associated with key
    # @return the node, or null if not found
    def do_remove(okey, value)
      key = comparable(okey)
      loop do
        b = find_predecessor(key)
        n = b.attr_next
        loop do
          if ((n).nil?)
            return nil
          end
          f = n.attr_next
          if (!(n).equal?(b.attr_next))
            # inconsistent read
            break
          end
          v = n.attr_value
          if ((v).nil?)
            # n is deleted
            n.help_delete(b, f)
            break
          end
          if ((v).equal?(n) || (b.attr_value).nil?)
            # b is deleted
            break
          end
          c = (key <=> n.attr_key)
          if (c < 0)
            return nil
          end
          if (c > 0)
            b = n
            n = f
            next
          end
          if (!(value).nil? && !(value == v))
            return nil
          end
          if (!n.cas_value(v, nil))
            break
          end
          if (!n.append_marker(f) || !b.cas_next(n, f))
            find_node(key)
             # Retry via findNode
          else
            find_predecessor(key) # Clean index
            if ((@head.attr_right).nil?)
              try_reduce_level
            end
          end
          return v
        end
      end
    end
    
    typesig { [] }
    # Possibly reduce head level if it has no nodes.  This method can
    # (rarely) make mistakes, in which case levels can disappear even
    # though they are about to contain index nodes. This impacts
    # performance, not correctness.  To minimize mistakes as well as
    # to reduce hysteresis, the level is reduced by one only if the
    # topmost three levels look empty. Also, if the removed level
    # looks non-empty after CAS, we try to change it back quick
    # before anyone notices our mistake! (This trick works pretty
    # well because this method will practically never make mistakes
    # unless current thread stalls immediately before first CAS, in
    # which case it is very unlikely to stall again immediately
    # afterwards, so will recover.)
    # 
    # We put up with all this rather than just let levels grow
    # because otherwise, even a small map that has undergone a large
    # number of insertions and removals will have a lot of levels,
    # slowing down access more than would an occasional unwanted
    # reduction.
    def try_reduce_level
      h = @head
      d = nil
      e = nil
      # try to set
      if (h.attr_level > 3 && !((d = h.attr_down)).nil? && !((e = d.attr_down)).nil? && (e.attr_right).nil? && (d.attr_right).nil? && (h.attr_right).nil? && cas_head(h, d) && !(h.attr_right).nil?)
        # recheck
        cas_head(d, h)
      end # try to backout
    end
    
    typesig { [] }
    # ---------------- Finding and removing first element --------------
    # 
    # Specialized variant of findNode to get first valid node.
    # @return first node or null if empty
    def find_first
      loop do
        b = @head.attr_node
        n = b.attr_next
        if ((n).nil?)
          return nil
        end
        if (!(n.attr_value).nil?)
          return n
        end
        n.help_delete(b, n.attr_next)
      end
    end
    
    typesig { [] }
    # Removes first entry; returns its snapshot.
    # @return null if empty, else snapshot of first entry
    def do_remove_first_entry
      loop do
        b = @head.attr_node
        n = b.attr_next
        if ((n).nil?)
          return nil
        end
        f = n.attr_next
        if (!(n).equal?(b.attr_next))
          next
        end
        v = n.attr_value
        if ((v).nil?)
          n.help_delete(b, f)
          next
        end
        if (!n.cas_value(v, nil))
          next
        end
        if (!n.append_marker(f) || !b.cas_next(n, f))
          find_first
        end # retry
        clear_index_to_first
        return AbstractMap::SimpleImmutableEntry.new(n.attr_key, v)
      end
    end
    
    typesig { [] }
    # Clears out index nodes associated with deleted first entry.
    def clear_index_to_first
      loop do
        q = @head
        loop do
          r = q.attr_right
          if (!(r).nil? && r.indexes_deleted_node && !q.unlink(r))
            break
          end
          if (((q = q.attr_down)).nil?)
            if ((@head.attr_right).nil?)
              try_reduce_level
            end
            return
          end
        end
      end
    end
    
    typesig { [] }
    # ---------------- Finding and removing last element --------------
    # 
    # Specialized version of find to get last valid node.
    # @return last node or null if empty
    def find_last
      # findPredecessor can't be used to traverse index level
      # because this doesn't use comparisons.  So traversals of
      # both levels are folded together.
      q = @head
      loop do
        d = nil
        r = nil
        if (!((r = q.attr_right)).nil?)
          if (r.indexes_deleted_node)
            q.unlink(r)
            q = @head # restart
          else
            q = r
          end
        else
          if (!((d = q.attr_down)).nil?)
            q = d
          else
            b = q.attr_node
            n = b.attr_next
            loop do
              if ((n).nil?)
                return (b.is_base_header) ? nil : b
              end
              f = n.attr_next # inconsistent read
              if (!(n).equal?(b.attr_next))
                break
              end
              v = n.attr_value
              if ((v).nil?)
                # n is deleted
                n.help_delete(b, f)
                break
              end
              if ((v).equal?(n) || (b.attr_value).nil?)
                # b is deleted
                break
              end
              b = n
              n = f
            end
            q = @head # restart
          end
        end
      end
    end
    
    typesig { [] }
    # Specialized variant of findPredecessor to get predecessor of last
    # valid node.  Needed when removing the last entry.  It is possible
    # that all successors of returned node will have been deleted upon
    # return, in which case this method can be retried.
    # @return likely predecessor of last node
    def find_predecessor_of_last
      loop do
        q = @head
        loop do
          d = nil
          r = nil
          if (!((r = q.attr_right)).nil?)
            if (r.indexes_deleted_node)
              q.unlink(r)
              break # must restart
            end
            # proceed as far across as possible without overshooting
            if (!(r.attr_node.attr_next).nil?)
              q = r
              next
            end
          end
          if (!((d = q.attr_down)).nil?)
            q = d
          else
            return q.attr_node
          end
        end
      end
    end
    
    typesig { [] }
    # Removes last entry; returns its snapshot.
    # Specialized variant of doRemove.
    # @return null if empty, else snapshot of last entry
    def do_remove_last_entry
      loop do
        b = find_predecessor_of_last
        n = b.attr_next
        if ((n).nil?)
          if (b.is_base_header)
            # empty
            return nil
          else
            next
          end # all b's successors are deleted; retry
        end
        loop do
          f = n.attr_next
          if (!(n).equal?(b.attr_next))
            # inconsistent read
            break
          end
          v = n.attr_value
          if ((v).nil?)
            # n is deleted
            n.help_delete(b, f)
            break
          end
          if ((v).equal?(n) || (b.attr_value).nil?)
            # b is deleted
            break
          end
          if (!(f).nil?)
            b = n
            n = f
            next
          end
          if (!n.cas_value(v, nil))
            break
          end
          key = n.attr_key
          ck = comparable(key)
          if (!n.append_marker(f) || !b.cas_next(n, f))
            find_node(ck)
             # Retry via findNode
          else
            find_predecessor(ck) # Clean index
            if ((@head.attr_right).nil?)
              try_reduce_level
            end
          end
          return AbstractMap::SimpleImmutableEntry.new(key, v)
        end
      end
    end
    
    class_module.module_eval {
      # ---------------- Relational operations --------------
      # Control values OR'ed as arguments to findNear
      const_set_lazy(:EQ) { 1 }
      const_attr_reader  :EQ
      
      const_set_lazy(:LT) { 2 }
      const_attr_reader  :LT
      
      const_set_lazy(:GT) { 0 }
      const_attr_reader  :GT
    }
    
    typesig { [Object, ::Java::Int] }
    # Actually checked as !LT
    # 
    # Utility for ceiling, floor, lower, higher methods.
    # @param kkey the key
    # @param rel the relation -- OR'ed combination of EQ, LT, GT
    # @return nearest node fitting relation, or null if no such
    def find_near(kkey, rel)
      key = comparable(kkey)
      loop do
        b = find_predecessor(key)
        n = b.attr_next
        loop do
          if ((n).nil?)
            return (((rel & LT)).equal?(0) || b.is_base_header) ? nil : b
          end
          f = n.attr_next
          if (!(n).equal?(b.attr_next))
            # inconsistent read
            break
          end
          v = n.attr_value
          if ((v).nil?)
            # n is deleted
            n.help_delete(b, f)
            break
          end
          if ((v).equal?(n) || (b.attr_value).nil?)
            # b is deleted
            break
          end
          c = (key <=> n.attr_key)
          if (((c).equal?(0) && !((rel & EQ)).equal?(0)) || (c < 0 && ((rel & LT)).equal?(0)))
            return n
          end
          if (c <= 0 && !((rel & LT)).equal?(0))
            return (b.is_base_header) ? nil : b
          end
          b = n
          n = f
        end
      end
    end
    
    typesig { [Object, ::Java::Int] }
    # Returns SimpleImmutableEntry for results of findNear.
    # @param key the key
    # @param rel the relation -- OR'ed combination of EQ, LT, GT
    # @return Entry fitting relation, or null if no such
    def get_near(key, rel)
      loop do
        n = find_near(key, rel)
        if ((n).nil?)
          return nil
        end
        e = n.create_snapshot
        if (!(e).nil?)
          return e
        end
      end
    end
    
    typesig { [] }
    # ---------------- Constructors --------------
    # 
    # Constructs a new, empty map, sorted according to the
    # {@linkplain Comparable natural ordering} of the keys.
    def initialize
      @head = nil
      @comparator = nil
      @random_seed = 0
      @key_set = nil
      @entry_set = nil
      @values = nil
      @descending_map = nil
      super()
      @comparator = nil
      initialize_
    end
    
    typesig { [Comparator] }
    # Constructs a new, empty map, sorted according to the specified
    # comparator.
    # 
    # @param comparator the comparator that will be used to order this map.
    # If <tt>null</tt>, the {@linkplain Comparable natural
    # ordering} of the keys will be used.
    def initialize(comparator)
      @head = nil
      @comparator = nil
      @random_seed = 0
      @key_set = nil
      @entry_set = nil
      @values = nil
      @descending_map = nil
      super()
      @comparator = comparator
      initialize_
    end
    
    typesig { [Map] }
    # Constructs a new map containing the same mappings as the given map,
    # sorted according to the {@linkplain Comparable natural ordering} of
    # the keys.
    # 
    # @param  m the map whose mappings are to be placed in this map
    # @throws ClassCastException if the keys in <tt>m</tt> are not
    # {@link Comparable}, or are not mutually comparable
    # @throws NullPointerException if the specified map or any of its keys
    # or values are null
    def initialize(m)
      @head = nil
      @comparator = nil
      @random_seed = 0
      @key_set = nil
      @entry_set = nil
      @values = nil
      @descending_map = nil
      super()
      @comparator = nil
      initialize_
      put_all(m)
    end
    
    typesig { [SortedMap] }
    # Constructs a new map containing the same mappings and using the
    # same ordering as the specified sorted map.
    # 
    # @param m the sorted map whose mappings are to be placed in this
    # map, and whose comparator is to be used to sort this map
    # @throws NullPointerException if the specified sorted map or any of
    # its keys or values are null
    def initialize(m)
      @head = nil
      @comparator = nil
      @random_seed = 0
      @key_set = nil
      @entry_set = nil
      @values = nil
      @descending_map = nil
      super()
      @comparator = m.comparator
      initialize_
      build_from_sorted(m)
    end
    
    typesig { [] }
    # Returns a shallow copy of this <tt>ConcurrentSkipListMap</tt>
    # instance. (The keys and values themselves are not cloned.)
    # 
    # @return a shallow copy of this map
    def clone
      clone = nil
      begin
        clone = super
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
      clone.initialize_
      clone.build_from_sorted(self)
      return clone
    end
    
    typesig { [SortedMap] }
    # Streamlined bulk insertion to initialize from elements of
    # given sorted map.  Call only from constructor or clone
    # method.
    def build_from_sorted(map)
      if ((map).nil?)
        raise NullPointerException.new
      end
      h = @head
      basepred = h.attr_node
      # Track the current rightmost node at each level. Uses an
      # ArrayList to avoid committing to initial or maximum level.
      preds = ArrayList.new
      # initialize
      i = 0
      while i <= h.attr_level
        preds.add(nil)
        (i += 1)
      end
      q = h
      i_ = h.attr_level
      while i_ > 0
        preds.set(i_, q)
        q = q.attr_down
        (i_ -= 1)
      end
      it = map.entry_set.iterator
      while (it.has_next)
        e = it.next_
        j = random_level
        if (j > h.attr_level)
          j = h.attr_level + 1
        end
        k = e.get_key
        v = e.get_value
        if ((k).nil? || (v).nil?)
          raise NullPointerException.new
        end
        z = Node.new(k, v, nil)
        basepred.attr_next = z
        basepred = z
        if (j > 0)
          idx = nil
          i__ = 1
          while i__ <= j
            idx = Index.new(z, idx, nil)
            if (i__ > h.attr_level)
              h = HeadIndex.new(h.attr_node, h, idx, i__)
            end
            if (i__ < preds.size)
              preds.get(i__).attr_right = idx
              preds.set(i__, idx)
            else
              preds.add(idx)
            end
            (i__ += 1)
          end
        end
      end
      @head = h
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # ---------------- Serialization --------------
    # 
    # Save the state of this map to a stream.
    # 
    # @serialData The key (Object) and value (Object) for each
    # key-value mapping represented by the map, followed by
    # <tt>null</tt>. The key-value mappings are emitted in key-order
    # (as determined by the Comparator, or by the keys' natural
    # ordering if no Comparator).
    def write_object(s)
      # Write out the Comparator and any hidden stuff
      s.default_write_object
      # Write out keys and values (alternating)
      n = find_first
      while !(n).nil?
        v = n.get_valid_value
        if (!(v).nil?)
          s.write_object(n.attr_key)
          s.write_object(v)
        end
        n = n.attr_next
      end
      s.write_object(nil)
    end
    
    typesig { [Java::Io::ObjectInputStream] }
    # Reconstitute the map from a stream.
    def read_object(s)
      # Read in the Comparator and any hidden stuff
      s.default_read_object
      # Reset transients
      initialize_
      # This is nearly identical to buildFromSorted, but is
      # distinct because readObject calls can't be nicely adapted
      # as the kind of iterator needed by buildFromSorted. (They
      # can be, but doing so requires type cheats and/or creation
      # of adaptor classes.) It is simpler to just adapt the code.
      h = @head
      basepred = h.attr_node
      preds = ArrayList.new
      i = 0
      while i <= h.attr_level
        preds.add(nil)
        (i += 1)
      end
      q = h
      i_ = h.attr_level
      while i_ > 0
        preds.set(i_, q)
        q = q.attr_down
        (i_ -= 1)
      end
      loop do
        k = s.read_object
        if ((k).nil?)
          break
        end
        v = s.read_object
        if ((v).nil?)
          raise NullPointerException.new
        end
        key = k
        val = v
        j = random_level
        if (j > h.attr_level)
          j = h.attr_level + 1
        end
        z = Node.new(key, val, nil)
        basepred.attr_next = z
        basepred = z
        if (j > 0)
          idx = nil
          i__ = 1
          while i__ <= j
            idx = Index.new(z, idx, nil)
            if (i__ > h.attr_level)
              h = HeadIndex.new(h.attr_node, h, idx, i__)
            end
            if (i__ < preds.size)
              preds.get(i__).attr_right = idx
              preds.set(i__, idx)
            else
              preds.add(idx)
            end
            (i__ += 1)
          end
        end
      end
      @head = h
    end
    
    typesig { [Object] }
    # ------ Map API methods ------
    # 
    # Returns <tt>true</tt> if this map contains a mapping for the specified
    # key.
    # 
    # @param key key whose presence in this map is to be tested
    # @return <tt>true</tt> if this map contains a mapping for the specified key
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    def contains_key(key)
      return !(do_get(key)).nil?
    end
    
    typesig { [Object] }
    # Returns the value to which the specified key is mapped,
    # or {@code null} if this map contains no mapping for the key.
    # 
    # <p>More formally, if this map contains a mapping from a key
    # {@code k} to a value {@code v} such that {@code key} compares
    # equal to {@code k} according to the map's ordering, then this
    # method returns {@code v}; otherwise it returns {@code null}.
    # (There can be at most one such mapping.)
    # 
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    def get(key)
      return do_get(key)
    end
    
    typesig { [Object, Object] }
    # Associates the specified value with the specified key in this map.
    # If the map previously contained a mapping for the key, the old
    # value is replaced.
    # 
    # @param key key with which the specified value is to be associated
    # @param value value to be associated with the specified key
    # @return the previous value associated with the specified key, or
    # <tt>null</tt> if there was no mapping for the key
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key or value is null
    def put(key, value)
      if ((value).nil?)
        raise NullPointerException.new
      end
      return do_put(key, value, false)
    end
    
    typesig { [Object] }
    # Removes the mapping for the specified key from this map if present.
    # 
    # @param  key key for which mapping should be removed
    # @return the previous value associated with the specified key, or
    # <tt>null</tt> if there was no mapping for the key
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    def remove(key)
      return do_remove(key, nil)
    end
    
    typesig { [Object] }
    # Returns <tt>true</tt> if this map maps one or more keys to the
    # specified value.  This operation requires time linear in the
    # map size.
    # 
    # @param value value whose presence in this map is to be tested
    # @return <tt>true</tt> if a mapping to <tt>value</tt> exists;
    # <tt>false</tt> otherwise
    # @throws NullPointerException if the specified value is null
    def contains_value(value)
      if ((value).nil?)
        raise NullPointerException.new
      end
      n = find_first
      while !(n).nil?
        v = n.get_valid_value
        if (!(v).nil? && (value == v))
          return true
        end
        n = n.attr_next
      end
      return false
    end
    
    typesig { [] }
    # Returns the number of key-value mappings in this map.  If this map
    # contains more than <tt>Integer.MAX_VALUE</tt> elements, it
    # returns <tt>Integer.MAX_VALUE</tt>.
    # 
    # <p>Beware that, unlike in most collections, this method is
    # <em>NOT</em> a constant-time operation. Because of the
    # asynchronous nature of these maps, determining the current
    # number of elements requires traversing them all to count them.
    # Additionally, it is possible for the size to change during
    # execution of this method, in which case the returned result
    # will be inaccurate. Thus, this method is typically not very
    # useful in concurrent applications.
    # 
    # @return the number of elements in this map
    def size
      count = 0
      n = find_first
      while !(n).nil?
        if (!(n.get_valid_value).nil?)
          (count += 1)
        end
        n = n.attr_next
      end
      return (count >= JavaInteger::MAX_VALUE) ? JavaInteger::MAX_VALUE : RJava.cast_to_int(count)
    end
    
    typesig { [] }
    # Returns <tt>true</tt> if this map contains no key-value mappings.
    # @return <tt>true</tt> if this map contains no key-value mappings
    def is_empty
      return (find_first).nil?
    end
    
    typesig { [] }
    # Removes all of the mappings from this map.
    def clear
      initialize_
    end
    
    typesig { [] }
    # ---------------- View methods --------------
    # 
    # Note: Lazy initialization works for views because view classes
    # are stateless/immutable so it doesn't matter wrt correctness if
    # more than one is created (which will only rarely happen).  Even
    # so, the following idiom conservatively ensures that the method
    # returns the one it created if it does so, not one created by
    # another racing thread.
    # 
    # 
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
      ks = @key_set
      return (!(ks).nil?) ? ks : (@key_set = KeySet.new(self))
    end
    
    typesig { [] }
    def navigable_key_set
      ks = @key_set
      return (!(ks).nil?) ? ks : (@key_set = KeySet.new(self))
    end
    
    typesig { [] }
    # Returns a {@link Collection} view of the values contained in this map.
    # The collection's iterator returns the values in ascending order
    # of the corresponding keys.
    # The collection is backed by the map, so changes to the map are
    # reflected in the collection, and vice-versa.  The collection
    # supports element removal, which removes the corresponding
    # mapping from the map, via the <tt>Iterator.remove</tt>,
    # <tt>Collection.remove</tt>, <tt>removeAll</tt>,
    # <tt>retainAll</tt> and <tt>clear</tt> operations.  It does not
    # support the <tt>add</tt> or <tt>addAll</tt> operations.
    # 
    # <p>The view's <tt>iterator</tt> is a "weakly consistent" iterator
    # that will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    def values
      vs = @values
      return (!(vs).nil?) ? vs : (@values = Values.new(self))
    end
    
    typesig { [] }
    # Returns a {@link Set} view of the mappings contained in this map.
    # The set's iterator returns the entries in ascending key order.
    # The set is backed by the map, so changes to the map are
    # reflected in the set, and vice-versa.  The set supports element
    # removal, which removes the corresponding mapping from the map,
    # via the <tt>Iterator.remove</tt>, <tt>Set.remove</tt>,
    # <tt>removeAll</tt>, <tt>retainAll</tt> and <tt>clear</tt>
    # operations.  It does not support the <tt>add</tt> or
    # <tt>addAll</tt> operations.
    # 
    # <p>The view's <tt>iterator</tt> is a "weakly consistent" iterator
    # that will never throw {@link ConcurrentModificationException},
    # and guarantees to traverse elements as they existed upon
    # construction of the iterator, and may (but is not guaranteed to)
    # reflect any modifications subsequent to construction.
    # 
    # <p>The <tt>Map.Entry</tt> elements returned by
    # <tt>iterator.next()</tt> do <em>not</em> support the
    # <tt>setValue</tt> operation.
    # 
    # @return a set view of the mappings contained in this map,
    # sorted in ascending key order
    def entry_set
      es = @entry_set
      return (!(es).nil?) ? es : (@entry_set = EntrySet.new(self))
    end
    
    typesig { [] }
    def descending_map
      dm = @descending_map
      return (!(dm).nil?) ? dm : (@descending_map = SubMap.new(self, nil, false, nil, false, true))
    end
    
    typesig { [] }
    def descending_key_set
      return descending_map.navigable_key_set
    end
    
    typesig { [Object] }
    # ---------------- AbstractMap Overrides --------------
    # 
    # Compares the specified object with this map for equality.
    # Returns <tt>true</tt> if the given object is also a map and the
    # two maps represent the same mappings.  More formally, two maps
    # <tt>m1</tt> and <tt>m2</tt> represent the same mappings if
    # <tt>m1.entrySet().equals(m2.entrySet())</tt>.  This
    # operation may return misleading results if either map is
    # concurrently modified during execution of this method.
    # 
    # @param o object to be compared for equality with this map
    # @return <tt>true</tt> if the specified object is equal to this map
    def ==(o)
      if ((o).equal?(self))
        return true
      end
      if (!(o.is_a?(Map)))
        return false
      end
      m = o
      begin
        self.entry_set.each do |e|
          if (!(e.get_value == m.get(e.get_key)))
            return false
          end
        end
        m.entry_set.each do |e|
          k = e.get_key
          v = e.get_value
          if ((k).nil? || (v).nil? || !(v == get(k)))
            return false
          end
        end
        return true
      rescue ClassCastException => unused
        return false
      rescue NullPointerException => unused
        return false
      end
    end
    
    typesig { [Object, Object] }
    # ------ ConcurrentMap API methods ------
    # 
    # {@inheritDoc}
    # 
    # @return the previous value associated with the specified key,
    # or <tt>null</tt> if there was no mapping for the key
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key or value is null
    def put_if_absent(key, value)
      if ((value).nil?)
        raise NullPointerException.new
      end
      return do_put(key, value, true)
    end
    
    typesig { [Object, Object] }
    # {@inheritDoc}
    # 
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key is null
    def remove(key, value)
      if ((key).nil?)
        raise NullPointerException.new
      end
      if ((value).nil?)
        return false
      end
      return !(do_remove(key, value)).nil?
    end
    
    typesig { [Object, Object, Object] }
    # {@inheritDoc}
    # 
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if any of the arguments are null
    def replace(key, old_value, new_value)
      if ((old_value).nil? || (new_value).nil?)
        raise NullPointerException.new
      end
      k = comparable(key)
      loop do
        n = find_node(k)
        if ((n).nil?)
          return false
        end
        v = n.attr_value
        if (!(v).nil?)
          if (!(old_value == v))
            return false
          end
          if (n.cas_value(v, new_value))
            return true
          end
        end
      end
    end
    
    typesig { [Object, Object] }
    # {@inheritDoc}
    # 
    # @return the previous value associated with the specified key,
    # or <tt>null</tt> if there was no mapping for the key
    # @throws ClassCastException if the specified key cannot be compared
    # with the keys currently in the map
    # @throws NullPointerException if the specified key or value is null
    def replace(key, value)
      if ((value).nil?)
        raise NullPointerException.new
      end
      k = comparable(key)
      loop do
        n = find_node(k)
        if ((n).nil?)
          return nil
        end
        v = n.attr_value
        if (!(v).nil? && n.cas_value(v, value))
          return v
        end
      end
    end
    
    typesig { [] }
    # ------ SortedMap API methods ------
    def comparator
      return @comparator
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def first_key
      n = find_first
      if ((n).nil?)
        raise NoSuchElementException.new
      end
      return n.attr_key
    end
    
    typesig { [] }
    # @throws NoSuchElementException {@inheritDoc}
    def last_key
      n = find_last
      if ((n).nil?)
        raise NoSuchElementException.new
      end
      return n.attr_key
    end
    
    typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromKey} or {@code toKey} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_map(from_key, from_inclusive, to_key, to_inclusive)
      if ((from_key).nil? || (to_key).nil?)
        raise NullPointerException.new
      end
      return SubMap.new(self, from_key, from_inclusive, to_key, to_inclusive, false)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code toKey} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def head_map(to_key, inclusive)
      if ((to_key).nil?)
        raise NullPointerException.new
      end
      return SubMap.new(self, nil, false, to_key, inclusive, false)
    end
    
    typesig { [Object, ::Java::Boolean] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromKey} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def tail_map(from_key, inclusive)
      if ((from_key).nil?)
        raise NullPointerException.new
      end
      return SubMap.new(self, from_key, inclusive, nil, false, false)
    end
    
    typesig { [Object, Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromKey} or {@code toKey} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def sub_map(from_key, to_key)
      return sub_map(from_key, true, to_key, false)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code toKey} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def head_map(to_key)
      return head_map(to_key, false)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if {@code fromKey} is null
    # @throws IllegalArgumentException {@inheritDoc}
    def tail_map(from_key)
      return tail_map(from_key, true)
    end
    
    typesig { [Object] }
    # ---------------- Relational operations --------------
    # 
    # Returns a key-value mapping associated with the greatest key
    # strictly less than the given key, or <tt>null</tt> if there is
    # no such key. The returned entry does <em>not</em> support the
    # <tt>Entry.setValue</tt> method.
    # 
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    def lower_entry(key)
      return get_near(key, LT)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    def lower_key(key)
      n = find_near(key, LT)
      return ((n).nil?) ? nil : n.attr_key
    end
    
    typesig { [Object] }
    # Returns a key-value mapping associated with the greatest key
    # less than or equal to the given key, or <tt>null</tt> if there
    # is no such key. The returned entry does <em>not</em> support
    # the <tt>Entry.setValue</tt> method.
    # 
    # @param key the key
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    def floor_entry(key)
      return get_near(key, LT | EQ)
    end
    
    typesig { [Object] }
    # @param key the key
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    def floor_key(key)
      n = find_near(key, LT | EQ)
      return ((n).nil?) ? nil : n.attr_key
    end
    
    typesig { [Object] }
    # Returns a key-value mapping associated with the least key
    # greater than or equal to the given key, or <tt>null</tt> if
    # there is no such entry. The returned entry does <em>not</em>
    # support the <tt>Entry.setValue</tt> method.
    # 
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    def ceiling_entry(key)
      return get_near(key, GT | EQ)
    end
    
    typesig { [Object] }
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    def ceiling_key(key)
      n = find_near(key, GT | EQ)
      return ((n).nil?) ? nil : n.attr_key
    end
    
    typesig { [Object] }
    # Returns a key-value mapping associated with the least key
    # strictly greater than the given key, or <tt>null</tt> if there
    # is no such key. The returned entry does <em>not</em> support
    # the <tt>Entry.setValue</tt> method.
    # 
    # @param key the key
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    def higher_entry(key)
      return get_near(key, GT)
    end
    
    typesig { [Object] }
    # @param key the key
    # @throws ClassCastException {@inheritDoc}
    # @throws NullPointerException if the specified key is null
    def higher_key(key)
      n = find_near(key, GT)
      return ((n).nil?) ? nil : n.attr_key
    end
    
    typesig { [] }
    # Returns a key-value mapping associated with the least
    # key in this map, or <tt>null</tt> if the map is empty.
    # The returned entry does <em>not</em> support
    # the <tt>Entry.setValue</tt> method.
    def first_entry
      loop do
        n = find_first
        if ((n).nil?)
          return nil
        end
        e = n.create_snapshot
        if (!(e).nil?)
          return e
        end
      end
    end
    
    typesig { [] }
    # Returns a key-value mapping associated with the greatest
    # key in this map, or <tt>null</tt> if the map is empty.
    # The returned entry does <em>not</em> support
    # the <tt>Entry.setValue</tt> method.
    def last_entry
      loop do
        n = find_last
        if ((n).nil?)
          return nil
        end
        e = n.create_snapshot
        if (!(e).nil?)
          return e
        end
      end
    end
    
    typesig { [] }
    # Removes and returns a key-value mapping associated with
    # the least key in this map, or <tt>null</tt> if the map is empty.
    # The returned entry does <em>not</em> support
    # the <tt>Entry.setValue</tt> method.
    def poll_first_entry
      return do_remove_first_entry
    end
    
    typesig { [] }
    # Removes and returns a key-value mapping associated with
    # the greatest key in this map, or <tt>null</tt> if the map is empty.
    # The returned entry does <em>not</em> support
    # the <tt>Entry.setValue</tt> method.
    def poll_last_entry
      return do_remove_last_entry
    end
    
    class_module.module_eval {
      # ---------------- Iterators --------------
      # 
      # Base of iterator classes:
      const_set_lazy(:Iter) { Class.new do
        extend LocalClass
        include_class_members ConcurrentSkipListMap
        include Iterator
        
        # the last node returned by next()
        attr_accessor :last_returned
        alias_method :attr_last_returned, :last_returned
        undef_method :last_returned
        alias_method :attr_last_returned=, :last_returned=
        undef_method :last_returned=
        
        # the next node to return from next();
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        # Cache of next value field to maintain weak consistency
        attr_accessor :next_value
        alias_method :attr_next_value, :next_value
        undef_method :next_value
        alias_method :attr_next_value=, :next_value=
        undef_method :next_value=
        
        typesig { [] }
        # Initializes ascending iterator for entire range.
        def initialize
          @last_returned = nil
          @next = nil
          @next_value = nil
          loop do
            @next = find_first
            if ((@next).nil?)
              break
            end
            x = @next.attr_value
            if (!(x).nil? && !(x).equal?(@next))
              @next_value = x
              break
            end
          end
        end
        
        typesig { [] }
        def has_next
          return !(@next).nil?
        end
        
        typesig { [] }
        # Advances next to higher entry.
        def advance
          if ((@next).nil?)
            raise self.class::NoSuchElementException.new
          end
          @last_returned = @next
          loop do
            @next = @next.attr_next
            if ((@next).nil?)
              break
            end
            x = @next.attr_value
            if (!(x).nil? && !(x).equal?(@next))
              @next_value = x
              break
            end
          end
        end
        
        typesig { [] }
        def remove
          l = @last_returned
          if ((l).nil?)
            raise self.class::IllegalStateException.new
          end
          # It would not be worth all of the overhead to directly
          # unlink from here. Using remove is fast enough.
          @local_class_parent.remove(l.attr_key)
          @last_returned = nil
        end
        
        private
        alias_method :initialize__iter, :initialize
      end }
      
      const_set_lazy(:ValueIterator) { Class.new(Iter) do
        extend LocalClass
        include_class_members ConcurrentSkipListMap
        
        typesig { [] }
        def next_
          v = self.attr_next_value
          advance
          return v
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__value_iterator, :initialize
      end }
      
      const_set_lazy(:KeyIterator) { Class.new(Iter) do
        extend LocalClass
        include_class_members ConcurrentSkipListMap
        
        typesig { [] }
        def next_
          n = self.attr_next
          advance
          return n.attr_key
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__key_iterator, :initialize
      end }
      
      const_set_lazy(:EntryIterator) { Class.new(Iter) do
        extend LocalClass
        include_class_members ConcurrentSkipListMap
        
        typesig { [] }
        def next_
          n = self.attr_next
          v = self.attr_next_value
          advance
          return self.class::AbstractMap::SimpleImmutableEntry.new(n.attr_key, v)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__entry_iterator, :initialize
      end }
    }
    
    typesig { [] }
    # Factory methods for iterators needed by ConcurrentSkipListSet etc
    def key_iterator
      return KeyIterator.new_local(self)
    end
    
    typesig { [] }
    def value_iterator
      return ValueIterator.new_local(self)
    end
    
    typesig { [] }
    def entry_iterator
      return EntryIterator.new_local(self)
    end
    
    class_module.module_eval {
      typesig { [Collection] }
      # ---------------- View Classes --------------
      # 
      # View classes are static, delegating to a ConcurrentNavigableMap
      # to allow use by SubMaps, which outweighs the ugliness of
      # needing type-tests for Iterator methods.
      def to_list(c)
        # Using size() here would be a pessimization.
        list = ArrayList.new
        c.each do |e|
          list.add(e)
        end
        return list
      end
      
      const_set_lazy(:KeySet) { Class.new(AbstractSet) do
        include_class_members ConcurrentSkipListMap
        overload_protected {
          include NavigableSet
        }
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        typesig { [self::ConcurrentNavigableMap] }
        def initialize(map)
          @m = nil
          super()
          @m = map
        end
        
        typesig { [] }
        def size
          return @m.size
        end
        
        typesig { [] }
        def is_empty
          return @m.is_empty
        end
        
        typesig { [Object] }
        def contains(o)
          return @m.contains_key(o)
        end
        
        typesig { [Object] }
        def remove(o)
          return !(@m.remove(o)).nil?
        end
        
        typesig { [] }
        def clear
          @m.clear
        end
        
        typesig { [Object] }
        def lower(e)
          return @m.lower_key(e)
        end
        
        typesig { [Object] }
        def floor(e)
          return @m.floor_key(e)
        end
        
        typesig { [Object] }
        def ceiling(e)
          return @m.ceiling_key(e)
        end
        
        typesig { [Object] }
        def higher(e)
          return @m.higher_key(e)
        end
        
        typesig { [] }
        def comparator
          return @m.comparator
        end
        
        typesig { [] }
        def first
          return @m.first_key
        end
        
        typesig { [] }
        def last
          return @m.last_key
        end
        
        typesig { [] }
        def poll_first
          e = @m.poll_first_entry
          return (e).nil? ? nil : e.get_key
        end
        
        typesig { [] }
        def poll_last
          e = @m.poll_last_entry
          return (e).nil? ? nil : e.get_key
        end
        
        typesig { [] }
        def iterator
          if (@m.is_a?(self.class::ConcurrentSkipListMap))
            return (@m).key_iterator
          else
            return (@m).key_iterator
          end
        end
        
        typesig { [Object] }
        def ==(o)
          if ((o).equal?(self))
            return true
          end
          if (!(o.is_a?(self.class::JavaSet)))
            return false
          end
          c = o
          begin
            return contains_all(c) && c.contains_all(self)
          rescue self.class::ClassCastException => unused
            return false
          rescue self.class::NullPointerException => unused
            return false
          end
        end
        
        typesig { [] }
        def to_array
          return to_list(self).to_array
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          return to_list(self).to_array(a)
        end
        
        typesig { [] }
        def descending_iterator
          return descending_set.iterator
        end
        
        typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
        def sub_set(from_element, from_inclusive, to_element, to_inclusive)
          return self.class::KeySet.new(@m.sub_map(from_element, from_inclusive, to_element, to_inclusive))
        end
        
        typesig { [Object, ::Java::Boolean] }
        def head_set(to_element, inclusive)
          return self.class::KeySet.new(@m.head_map(to_element, inclusive))
        end
        
        typesig { [Object, ::Java::Boolean] }
        def tail_set(from_element, inclusive)
          return self.class::KeySet.new(@m.tail_map(from_element, inclusive))
        end
        
        typesig { [Object, Object] }
        def sub_set(from_element, to_element)
          return sub_set(from_element, true, to_element, false)
        end
        
        typesig { [Object] }
        def head_set(to_element)
          return head_set(to_element, false)
        end
        
        typesig { [Object] }
        def tail_set(from_element)
          return tail_set(from_element, true)
        end
        
        typesig { [] }
        def descending_set
          return self.class::KeySet.new(@m.descending_map)
        end
        
        private
        alias_method :initialize__key_set, :initialize
      end }
      
      const_set_lazy(:Values) { Class.new(AbstractCollection) do
        include_class_members ConcurrentSkipListMap
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        typesig { [self::ConcurrentNavigableMap] }
        def initialize(map)
          @m = nil
          super()
          @m = map
        end
        
        typesig { [] }
        def iterator
          if (@m.is_a?(self.class::ConcurrentSkipListMap))
            return (@m).value_iterator
          else
            return (@m).value_iterator
          end
        end
        
        typesig { [] }
        def is_empty
          return @m.is_empty
        end
        
        typesig { [] }
        def size
          return @m.size
        end
        
        typesig { [Object] }
        def contains(o)
          return @m.contains_value(o)
        end
        
        typesig { [] }
        def clear
          @m.clear
        end
        
        typesig { [] }
        def to_array
          return to_list(self).to_array
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          return to_list(self).to_array(a)
        end
        
        private
        alias_method :initialize__values, :initialize
      end }
      
      const_set_lazy(:EntrySet) { Class.new(AbstractSet) do
        include_class_members ConcurrentSkipListMap
        
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        typesig { [self::ConcurrentNavigableMap] }
        def initialize(map)
          @m = nil
          super()
          @m = map
        end
        
        typesig { [] }
        def iterator
          if (@m.is_a?(self.class::ConcurrentSkipListMap))
            return (@m).entry_iterator
          else
            return (@m).entry_iterator
          end
        end
        
        typesig { [Object] }
        def contains(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          v = @m.get(e.get_key)
          return !(v).nil? && (v == e.get_value)
        end
        
        typesig { [Object] }
        def remove(o)
          if (!(o.is_a?(self.class::Map::Entry)))
            return false
          end
          e = o
          return @m.remove(e.get_key, e.get_value)
        end
        
        typesig { [] }
        def is_empty
          return @m.is_empty
        end
        
        typesig { [] }
        def size
          return @m.size
        end
        
        typesig { [] }
        def clear
          @m.clear
        end
        
        typesig { [Object] }
        def ==(o)
          if ((o).equal?(self))
            return true
          end
          if (!(o.is_a?(self.class::JavaSet)))
            return false
          end
          c = o
          begin
            return contains_all(c) && c.contains_all(self)
          rescue self.class::ClassCastException => unused
            return false
          rescue self.class::NullPointerException => unused
            return false
          end
        end
        
        typesig { [] }
        def to_array
          return to_list(self).to_array
        end
        
        typesig { [Array.typed(self::T)] }
        def to_array(a)
          return to_list(self).to_array(a)
        end
        
        private
        alias_method :initialize__entry_set, :initialize
      end }
      
      # Submaps returned by {@link ConcurrentSkipListMap} submap operations
      # represent a subrange of mappings of their underlying
      # maps. Instances of this class support all methods of their
      # underlying maps, differing in that mappings outside their range are
      # ignored, and attempts to add mappings outside their ranges result
      # in {@link IllegalArgumentException}.  Instances of this class are
      # constructed only using the <tt>subMap</tt>, <tt>headMap</tt>, and
      # <tt>tailMap</tt> methods of their underlying maps.
      # 
      # @serial include
      const_set_lazy(:SubMap) { Class.new(AbstractMap) do
        include_class_members ConcurrentSkipListMap
        overload_protected {
          include ConcurrentNavigableMap
          include Cloneable
          include Java::Io::Serializable
        }
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -7647078645895051609 }
          const_attr_reader  :SerialVersionUID
        }
        
        # Underlying map
        attr_accessor :m
        alias_method :attr_m, :m
        undef_method :m
        alias_method :attr_m=, :m=
        undef_method :m=
        
        # lower bound key, or null if from start
        attr_accessor :lo
        alias_method :attr_lo, :lo
        undef_method :lo
        alias_method :attr_lo=, :lo=
        undef_method :lo=
        
        # upper bound key, or null if to end
        attr_accessor :hi
        alias_method :attr_hi, :hi
        undef_method :hi
        alias_method :attr_hi=, :hi=
        undef_method :hi=
        
        # inclusion flag for lo
        attr_accessor :lo_inclusive
        alias_method :attr_lo_inclusive, :lo_inclusive
        undef_method :lo_inclusive
        alias_method :attr_lo_inclusive=, :lo_inclusive=
        undef_method :lo_inclusive=
        
        # inclusion flag for hi
        attr_accessor :hi_inclusive
        alias_method :attr_hi_inclusive, :hi_inclusive
        undef_method :hi_inclusive
        alias_method :attr_hi_inclusive=, :hi_inclusive=
        undef_method :hi_inclusive=
        
        # direction
        attr_accessor :is_descending
        alias_method :attr_is_descending, :is_descending
        undef_method :is_descending
        alias_method :attr_is_descending=, :is_descending=
        undef_method :is_descending=
        
        # Lazily initialized view holders
        attr_accessor :key_set_view
        alias_method :attr_key_set_view, :key_set_view
        undef_method :key_set_view
        alias_method :attr_key_set_view=, :key_set_view=
        undef_method :key_set_view=
        
        attr_accessor :entry_set_view
        alias_method :attr_entry_set_view, :entry_set_view
        undef_method :entry_set_view
        alias_method :attr_entry_set_view=, :entry_set_view=
        undef_method :entry_set_view=
        
        attr_accessor :values_view
        alias_method :attr_values_view, :values_view
        undef_method :values_view
        alias_method :attr_values_view=, :values_view=
        undef_method :values_view=
        
        typesig { [self::ConcurrentSkipListMap, Object, ::Java::Boolean, Object, ::Java::Boolean, ::Java::Boolean] }
        # Creates a new submap, initializing all fields
        def initialize(map, from_key, from_inclusive, to_key, to_inclusive, is_descending)
          @m = nil
          @lo = nil
          @hi = nil
          @lo_inclusive = false
          @hi_inclusive = false
          @is_descending = false
          @key_set_view = nil
          @entry_set_view = nil
          @values_view = nil
          super()
          if (!(from_key).nil? && !(to_key).nil? && map.compare(from_key, to_key) > 0)
            raise self.class::IllegalArgumentException.new("inconsistent range")
          end
          @m = map
          @lo = from_key
          @hi = to_key
          @lo_inclusive = from_inclusive
          @hi_inclusive = to_inclusive
          @is_descending = is_descending
        end
        
        typesig { [Object] }
        # ----------------  Utilities --------------
        def too_low(key)
          if (!(@lo).nil?)
            c = @m.compare(key, @lo)
            if (c < 0 || ((c).equal?(0) && !@lo_inclusive))
              return true
            end
          end
          return false
        end
        
        typesig { [Object] }
        def too_high(key)
          if (!(@hi).nil?)
            c = @m.compare(key, @hi)
            if (c > 0 || ((c).equal?(0) && !@hi_inclusive))
              return true
            end
          end
          return false
        end
        
        typesig { [Object] }
        def in_bounds(key)
          return !too_low(key) && !too_high(key)
        end
        
        typesig { [Object] }
        def check_key_bounds(key)
          if ((key).nil?)
            raise self.class::NullPointerException.new
          end
          if (!in_bounds(key))
            raise self.class::IllegalArgumentException.new("key out of range")
          end
        end
        
        typesig { [self::ConcurrentSkipListMap::Node] }
        # Returns true if node key is less than upper bound of range
        def is_before_end(n)
          if ((n).nil?)
            return false
          end
          if ((@hi).nil?)
            return true
          end
          k = n.attr_key
          if ((k).nil?)
            # pass by markers and headers
            return true
          end
          c = @m.compare(k, @hi)
          if (c > 0 || ((c).equal?(0) && !@hi_inclusive))
            return false
          end
          return true
        end
        
        typesig { [] }
        # Returns lowest node. This node might not be in range, so
        # most usages need to check bounds
        def lo_node
          if ((@lo).nil?)
            return @m.find_first
          else
            if (@lo_inclusive)
              return @m.find_near(@lo, @m.attr_gt | @m.attr_eq)
            else
              return @m.find_near(@lo, @m.attr_gt)
            end
          end
        end
        
        typesig { [] }
        # Returns highest node. This node might not be in range, so
        # most usages need to check bounds
        def hi_node
          if ((@hi).nil?)
            return @m.find_last
          else
            if (@hi_inclusive)
              return @m.find_near(@hi, @m.attr_lt | @m.attr_eq)
            else
              return @m.find_near(@hi, @m.attr_lt)
            end
          end
        end
        
        typesig { [] }
        # Returns lowest absolute key (ignoring directonality)
        def lowest_key
          n = lo_node
          if (is_before_end(n))
            return n.attr_key
          else
            raise self.class::NoSuchElementException.new
          end
        end
        
        typesig { [] }
        # Returns highest absolute key (ignoring directonality)
        def highest_key
          n = hi_node
          if (!(n).nil?)
            last = n.attr_key
            if (in_bounds(last))
              return last
            end
          end
          raise self.class::NoSuchElementException.new
        end
        
        typesig { [] }
        def lowest_entry
          loop do
            n = lo_node
            if (!is_before_end(n))
              return nil
            end
            e = n.create_snapshot
            if (!(e).nil?)
              return e
            end
          end
        end
        
        typesig { [] }
        def highest_entry
          loop do
            n = hi_node
            if ((n).nil? || !in_bounds(n.attr_key))
              return nil
            end
            e = n.create_snapshot
            if (!(e).nil?)
              return e
            end
          end
        end
        
        typesig { [] }
        def remove_lowest
          loop do
            n = lo_node
            if ((n).nil?)
              return nil
            end
            k = n.attr_key
            if (!in_bounds(k))
              return nil
            end
            v = @m.do_remove(k, nil)
            if (!(v).nil?)
              return self.class::AbstractMap::SimpleImmutableEntry.new(k, v)
            end
          end
        end
        
        typesig { [] }
        def remove_highest
          loop do
            n = hi_node
            if ((n).nil?)
              return nil
            end
            k = n.attr_key
            if (!in_bounds(k))
              return nil
            end
            v = @m.do_remove(k, nil)
            if (!(v).nil?)
              return self.class::AbstractMap::SimpleImmutableEntry.new(k, v)
            end
          end
        end
        
        typesig { [Object, ::Java::Int] }
        # Submap version of ConcurrentSkipListMap.getNearEntry
        def get_near_entry(key, rel)
          if (@is_descending)
            # adjust relation for direction
            if (((rel & @m.attr_lt)).equal?(0))
              rel |= @m.attr_lt
            else
              rel &= ~@m.attr_lt
            end
          end
          if (too_low(key))
            return (!((rel & @m.attr_lt)).equal?(0)) ? nil : lowest_entry
          end
          if (too_high(key))
            return (!((rel & @m.attr_lt)).equal?(0)) ? highest_entry : nil
          end
          loop do
            n = @m.find_near(key, rel)
            if ((n).nil? || !in_bounds(n.attr_key))
              return nil
            end
            k = n.attr_key
            v = n.get_valid_value
            if (!(v).nil?)
              return self.class::AbstractMap::SimpleImmutableEntry.new(k, v)
            end
          end
        end
        
        typesig { [Object, ::Java::Int] }
        # Almost the same as getNearEntry, except for keys
        def get_near_key(key, rel)
          if (@is_descending)
            # adjust relation for direction
            if (((rel & @m.attr_lt)).equal?(0))
              rel |= @m.attr_lt
            else
              rel &= ~@m.attr_lt
            end
          end
          if (too_low(key))
            if (((rel & @m.attr_lt)).equal?(0))
              n = lo_node
              if (is_before_end(n))
                return n.attr_key
              end
            end
            return nil
          end
          if (too_high(key))
            if (!((rel & @m.attr_lt)).equal?(0))
              n = hi_node
              if (!(n).nil?)
                last = n.attr_key
                if (in_bounds(last))
                  return last
                end
              end
            end
            return nil
          end
          loop do
            n = @m.find_near(key, rel)
            if ((n).nil? || !in_bounds(n.attr_key))
              return nil
            end
            k = n.attr_key
            v = n.get_valid_value
            if (!(v).nil?)
              return k
            end
          end
        end
        
        typesig { [Object] }
        # ----------------  Map API methods --------------
        def contains_key(key)
          if ((key).nil?)
            raise self.class::NullPointerException.new
          end
          k = key
          return in_bounds(k) && @m.contains_key(k)
        end
        
        typesig { [Object] }
        def get(key)
          if ((key).nil?)
            raise self.class::NullPointerException.new
          end
          k = key
          return ((!in_bounds(k)) ? nil : @m.get(k))
        end
        
        typesig { [Object, Object] }
        def put(key, value)
          check_key_bounds(key)
          return @m.put(key, value)
        end
        
        typesig { [Object] }
        def remove(key)
          k = key
          return (!in_bounds(k)) ? nil : @m.remove(k)
        end
        
        typesig { [] }
        def size
          count = 0
          n = lo_node
          while is_before_end(n)
            if (!(n.get_valid_value).nil?)
              (count += 1)
            end
            n = n.attr_next
          end
          return count >= JavaInteger::MAX_VALUE ? JavaInteger::MAX_VALUE : RJava.cast_to_int(count)
        end
        
        typesig { [] }
        def is_empty
          return !is_before_end(lo_node)
        end
        
        typesig { [Object] }
        def contains_value(value)
          if ((value).nil?)
            raise self.class::NullPointerException.new
          end
          n = lo_node
          while is_before_end(n)
            v = n.get_valid_value
            if (!(v).nil? && (value == v))
              return true
            end
            n = n.attr_next
          end
          return false
        end
        
        typesig { [] }
        def clear
          n = lo_node
          while is_before_end(n)
            if (!(n.get_valid_value).nil?)
              @m.remove(n.attr_key)
            end
            n = n.attr_next
          end
        end
        
        typesig { [Object, Object] }
        # ----------------  ConcurrentMap API methods --------------
        def put_if_absent(key, value)
          check_key_bounds(key)
          return @m.put_if_absent(key, value)
        end
        
        typesig { [Object, Object] }
        def remove(key, value)
          k = key
          return in_bounds(k) && @m.remove(k, value)
        end
        
        typesig { [Object, Object, Object] }
        def replace(key, old_value, new_value)
          check_key_bounds(key)
          return @m.replace(key, old_value, new_value)
        end
        
        typesig { [Object, Object] }
        def replace(key, value)
          check_key_bounds(key)
          return @m.replace(key, value)
        end
        
        typesig { [] }
        # ----------------  SortedMap API methods --------------
        def comparator
          cmp = @m.comparator
          if (@is_descending)
            return Collections.reverse_order(cmp)
          else
            return cmp
          end
        end
        
        typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
        # Utility to create submaps, where given bounds override
        # unbounded(null) ones and/or are checked against bounded ones.
        def new_sub_map(from_key, from_inclusive, to_key, to_inclusive)
          if (@is_descending)
            # flip senses
            tk = from_key
            from_key = to_key
            to_key = tk
            ti = from_inclusive
            from_inclusive = to_inclusive
            to_inclusive = ti
          end
          if (!(@lo).nil?)
            if ((from_key).nil?)
              from_key = @lo
              from_inclusive = @lo_inclusive
            else
              c = @m.compare(from_key, @lo)
              if (c < 0 || ((c).equal?(0) && !@lo_inclusive && from_inclusive))
                raise self.class::IllegalArgumentException.new("key out of range")
              end
            end
          end
          if (!(@hi).nil?)
            if ((to_key).nil?)
              to_key = @hi
              to_inclusive = @hi_inclusive
            else
              c = @m.compare(to_key, @hi)
              if (c > 0 || ((c).equal?(0) && !@hi_inclusive && to_inclusive))
                raise self.class::IllegalArgumentException.new("key out of range")
              end
            end
          end
          return self.class::SubMap.new(@m, from_key, from_inclusive, to_key, to_inclusive, @is_descending)
        end
        
        typesig { [Object, ::Java::Boolean, Object, ::Java::Boolean] }
        def sub_map(from_key, from_inclusive, to_key, to_inclusive)
          if ((from_key).nil? || (to_key).nil?)
            raise self.class::NullPointerException.new
          end
          return new_sub_map(from_key, from_inclusive, to_key, to_inclusive)
        end
        
        typesig { [Object, ::Java::Boolean] }
        def head_map(to_key, inclusive)
          if ((to_key).nil?)
            raise self.class::NullPointerException.new
          end
          return new_sub_map(nil, false, to_key, inclusive)
        end
        
        typesig { [Object, ::Java::Boolean] }
        def tail_map(from_key, inclusive)
          if ((from_key).nil?)
            raise self.class::NullPointerException.new
          end
          return new_sub_map(from_key, inclusive, nil, false)
        end
        
        typesig { [Object, Object] }
        def sub_map(from_key, to_key)
          return sub_map(from_key, true, to_key, false)
        end
        
        typesig { [Object] }
        def head_map(to_key)
          return head_map(to_key, false)
        end
        
        typesig { [Object] }
        def tail_map(from_key)
          return tail_map(from_key, true)
        end
        
        typesig { [] }
        def descending_map
          return self.class::SubMap.new(@m, @lo, @lo_inclusive, @hi, @hi_inclusive, !@is_descending)
        end
        
        typesig { [Object] }
        # ----------------  Relational methods --------------
        def ceiling_entry(key)
          return get_near_entry(key, (@m.attr_gt | @m.attr_eq))
        end
        
        typesig { [Object] }
        def ceiling_key(key)
          return get_near_key(key, (@m.attr_gt | @m.attr_eq))
        end
        
        typesig { [Object] }
        def lower_entry(key)
          return get_near_entry(key, (@m.attr_lt))
        end
        
        typesig { [Object] }
        def lower_key(key)
          return get_near_key(key, (@m.attr_lt))
        end
        
        typesig { [Object] }
        def floor_entry(key)
          return get_near_entry(key, (@m.attr_lt | @m.attr_eq))
        end
        
        typesig { [Object] }
        def floor_key(key)
          return get_near_key(key, (@m.attr_lt | @m.attr_eq))
        end
        
        typesig { [Object] }
        def higher_entry(key)
          return get_near_entry(key, (@m.attr_gt))
        end
        
        typesig { [Object] }
        def higher_key(key)
          return get_near_key(key, (@m.attr_gt))
        end
        
        typesig { [] }
        def first_key
          return @is_descending ? highest_key : lowest_key
        end
        
        typesig { [] }
        def last_key
          return @is_descending ? lowest_key : highest_key
        end
        
        typesig { [] }
        def first_entry
          return @is_descending ? highest_entry : lowest_entry
        end
        
        typesig { [] }
        def last_entry
          return @is_descending ? lowest_entry : highest_entry
        end
        
        typesig { [] }
        def poll_first_entry
          return @is_descending ? remove_highest : remove_lowest
        end
        
        typesig { [] }
        def poll_last_entry
          return @is_descending ? remove_lowest : remove_highest
        end
        
        typesig { [] }
        # ---------------- Submap Views --------------
        def key_set
          ks = @key_set_view
          return (!(ks).nil?) ? ks : (@key_set_view = self.class::KeySet.new(self))
        end
        
        typesig { [] }
        def navigable_key_set
          ks = @key_set_view
          return (!(ks).nil?) ? ks : (@key_set_view = self.class::KeySet.new(self))
        end
        
        typesig { [] }
        def values
          vs = @values_view
          return (!(vs).nil?) ? vs : (@values_view = self.class::Values.new(self))
        end
        
        typesig { [] }
        def entry_set
          es = @entry_set_view
          return (!(es).nil?) ? es : (@entry_set_view = self.class::EntrySet.new(self))
        end
        
        typesig { [] }
        def descending_key_set
          return descending_map.navigable_key_set
        end
        
        typesig { [] }
        def key_iterator
          return self.class::SubMapKeyIterator.new_local(self)
        end
        
        typesig { [] }
        def value_iterator
          return self.class::SubMapValueIterator.new_local(self)
        end
        
        typesig { [] }
        def entry_iterator
          return self.class::SubMapEntryIterator.new_local(self)
        end
        
        class_module.module_eval {
          # Variant of main Iter class to traverse through submaps.
          const_set_lazy(:SubMapIter) { Class.new do
            extend LocalClass
            include_class_members SubMap
            include self::Iterator
            
            # the last node returned by next()
            attr_accessor :last_returned
            alias_method :attr_last_returned, :last_returned
            undef_method :last_returned
            alias_method :attr_last_returned=, :last_returned=
            undef_method :last_returned=
            
            # the next node to return from next();
            attr_accessor :next
            alias_method :attr_next, :next
            undef_method :next
            alias_method :attr_next=, :next=
            undef_method :next=
            
            # Cache of next value field to maintain weak consistency
            attr_accessor :next_value
            alias_method :attr_next_value, :next_value
            undef_method :next_value
            alias_method :attr_next_value=, :next_value=
            undef_method :next_value=
            
            typesig { [] }
            def initialize
              @last_returned = nil
              @next = nil
              @next_value = nil
              loop do
                @next = self.attr_is_descending ? hi_node : lo_node
                if ((@next).nil?)
                  break
                end
                x = @next.attr_value
                if (!(x).nil? && !(x).equal?(@next))
                  if (!in_bounds(@next.attr_key))
                    @next = nil
                  else
                    @next_value = x
                  end
                  break
                end
              end
            end
            
            typesig { [] }
            def has_next
              return !(@next).nil?
            end
            
            typesig { [] }
            def advance
              if ((@next).nil?)
                raise self.class::NoSuchElementException.new
              end
              @last_returned = @next
              if (self.attr_is_descending)
                descend
              else
                ascend
              end
            end
            
            typesig { [] }
            def ascend
              loop do
                @next = @next.attr_next
                if ((@next).nil?)
                  break
                end
                x = @next.attr_value
                if (!(x).nil? && !(x).equal?(@next))
                  if (too_high(@next.attr_key))
                    @next = nil
                  else
                    @next_value = x
                  end
                  break
                end
              end
            end
            
            typesig { [] }
            def descend
              loop do
                @next = self.attr_m.find_near(@last_returned.attr_key, LT)
                if ((@next).nil?)
                  break
                end
                x = @next.attr_value
                if (!(x).nil? && !(x).equal?(@next))
                  if (too_low(@next.attr_key))
                    @next = nil
                  else
                    @next_value = x
                  end
                  break
                end
              end
            end
            
            typesig { [] }
            def remove
              l = @last_returned
              if ((l).nil?)
                raise self.class::IllegalStateException.new
              end
              self.attr_m.remove(l.attr_key)
              @last_returned = nil
            end
            
            private
            alias_method :initialize__sub_map_iter, :initialize
          end }
          
          const_set_lazy(:SubMapValueIterator) { Class.new(self::SubMapIter) do
            extend LocalClass
            include_class_members SubMap
            
            typesig { [] }
            def next_
              v = self.attr_next_value
              advance
              return v
            end
            
            typesig { [] }
            def initialize
              super()
            end
            
            private
            alias_method :initialize__sub_map_value_iterator, :initialize
          end }
          
          const_set_lazy(:SubMapKeyIterator) { Class.new(self::SubMapIter) do
            extend LocalClass
            include_class_members SubMap
            
            typesig { [] }
            def next_
              n = self.attr_next
              advance
              return n.attr_key
            end
            
            typesig { [] }
            def initialize
              super()
            end
            
            private
            alias_method :initialize__sub_map_key_iterator, :initialize
          end }
          
          const_set_lazy(:SubMapEntryIterator) { Class.new(self::SubMapIter) do
            extend LocalClass
            include_class_members SubMap
            
            typesig { [] }
            def next_
              n = self.attr_next
              v = self.attr_next_value
              advance
              return self.class::AbstractMap::SimpleImmutableEntry.new(n.attr_key, v)
            end
            
            typesig { [] }
            def initialize
              super()
            end
            
            private
            alias_method :initialize__sub_map_entry_iterator, :initialize
          end }
        }
        
        private
        alias_method :initialize__sub_map, :initialize
      end }
    }
    
    private
    alias_method :initialize__concurrent_skip_list_map, :initialize
  end
  
end
