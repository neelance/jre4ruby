require "rjava"

# 
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
module Sun::Security::Provider::Certpath
  module PolicyNodeImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaSet
      include ::Java::Security::Cert
    }
  end
  
  # 
  # Implements the <code>PolicyNode</code> interface.
  # <p>
  # This class provides an implementation of the <code>PolicyNode</code>
  # interface, and is used internally to build and search Policy Trees.
  # While the implementation is mutable during construction, it is immutable
  # before returning to a client and no mutable public or protected methods
  # are exposed by this implementation, as per the contract of PolicyNode.
  # 
  # @since       1.4
  # @author      Seth Proctor
  # @author      Sean Mullan
  class PolicyNodeImpl 
    include_class_members PolicyNodeImplImports
    include PolicyNode
    
    class_module.module_eval {
      # 
      # Use to specify the special policy "Any Policy"
      const_set_lazy(:ANY_POLICY) { "2.5.29.32.0" }
      const_attr_reader  :ANY_POLICY
    }
    
    # every node has one parent, and zero or more children
    attr_accessor :m_parent
    alias_method :attr_m_parent, :m_parent
    undef_method :m_parent
    alias_method :attr_m_parent=, :m_parent=
    undef_method :m_parent=
    
    attr_accessor :m_children
    alias_method :attr_m_children, :m_children
    undef_method :m_children
    alias_method :attr_m_children=, :m_children=
    undef_method :m_children=
    
    # the 4 fields specified by RFC 3280
    attr_accessor :m_valid_policy
    alias_method :attr_m_valid_policy, :m_valid_policy
    undef_method :m_valid_policy
    alias_method :attr_m_valid_policy=, :m_valid_policy=
    undef_method :m_valid_policy=
    
    attr_accessor :m_qualifier_set
    alias_method :attr_m_qualifier_set, :m_qualifier_set
    undef_method :m_qualifier_set
    alias_method :attr_m_qualifier_set=, :m_qualifier_set=
    undef_method :m_qualifier_set=
    
    attr_accessor :m_criticality_indicator
    alias_method :attr_m_criticality_indicator, :m_criticality_indicator
    undef_method :m_criticality_indicator
    alias_method :attr_m_criticality_indicator=, :m_criticality_indicator=
    undef_method :m_criticality_indicator=
    
    attr_accessor :m_expected_policy_set
    alias_method :attr_m_expected_policy_set, :m_expected_policy_set
    undef_method :m_expected_policy_set
    alias_method :attr_m_expected_policy_set=, :m_expected_policy_set=
    undef_method :m_expected_policy_set=
    
    attr_accessor :m_original_expected_policy_set
    alias_method :attr_m_original_expected_policy_set, :m_original_expected_policy_set
    undef_method :m_original_expected_policy_set
    alias_method :attr_m_original_expected_policy_set=, :m_original_expected_policy_set=
    undef_method :m_original_expected_policy_set=
    
    # the tree depth
    attr_accessor :m_depth
    alias_method :attr_m_depth, :m_depth
    undef_method :m_depth
    alias_method :attr_m_depth=, :m_depth=
    undef_method :m_depth=
    
    # immutability flag
    attr_accessor :is_immutable
    alias_method :attr_is_immutable, :is_immutable
    undef_method :is_immutable
    alias_method :attr_is_immutable=, :is_immutable=
    undef_method :is_immutable=
    
    typesig { [PolicyNodeImpl, String, JavaSet, ::Java::Boolean, JavaSet, ::Java::Boolean] }
    # 
    # Constructor which takes a <code>PolicyNodeImpl</code> representing the
    # parent in the Policy Tree to this node. If null, this is the
    # root of the tree. The constructor also takes the associated data
    # for this node, as found in the certificate. It also takes a boolean
    # argument specifying whether this node is being created as a result
    # of policy mapping.
    # 
    # @param parent the PolicyNode above this in the tree, or null if this
    # node is the tree's root node
    # @param validPolicy a String representing this node's valid policy OID
    # @param qualifierSet the Set of qualifiers for this policy
    # @param criticalityIndicator a boolean representing whether or not the
    # extension is critical
    # @param expectedPolicySet a Set of expected policies
    # @param generatedByPolicyMapping a boolean indicating whether this
    # node was generated by a policy mapping
    def initialize(parent, valid_policy, qualifier_set, criticality_indicator, expected_policy_set, generated_by_policy_mapping)
      @m_parent = nil
      @m_children = nil
      @m_valid_policy = nil
      @m_qualifier_set = nil
      @m_criticality_indicator = false
      @m_expected_policy_set = nil
      @m_original_expected_policy_set = false
      @m_depth = 0
      @is_immutable = false
      @m_parent = parent
      @m_children = HashSet.new
      if (!(valid_policy).nil?)
        @m_valid_policy = valid_policy
      else
        @m_valid_policy = ""
      end
      if (!(qualifier_set).nil?)
        @m_qualifier_set = HashSet.new(qualifier_set)
      else
        @m_qualifier_set = HashSet.new
      end
      @m_criticality_indicator = criticality_indicator
      if (!(expected_policy_set).nil?)
        @m_expected_policy_set = HashSet.new(expected_policy_set)
      else
        @m_expected_policy_set = HashSet.new
      end
      @m_original_expected_policy_set = !generated_by_policy_mapping
      # see if we're the root, and act appropriately
      if (!(@m_parent).nil?)
        @m_depth = @m_parent.get_depth + 1
        @m_parent.add_child(self)
      else
        @m_depth = 0
      end
    end
    
    typesig { [PolicyNodeImpl, PolicyNodeImpl] }
    # 
    # Alternate constructor which makes a new node with the policy data
    # in an existing <code>PolicyNodeImpl</code>.
    # 
    # @param parent a PolicyNode that's the new parent of the node, or
    # null if this is the root node
    # @param node a PolicyNode containing the policy data to copy
    def initialize(parent, node)
      initialize__policy_node_impl(parent, node.attr_m_valid_policy, node.attr_m_qualifier_set, node.attr_m_criticality_indicator, node.attr_m_expected_policy_set, false)
    end
    
    typesig { [] }
    def get_parent
      return @m_parent
    end
    
    typesig { [] }
    def get_children
      return Collections.unmodifiable_set(@m_children).iterator
    end
    
    typesig { [] }
    def get_depth
      return @m_depth
    end
    
    typesig { [] }
    def get_valid_policy
      return @m_valid_policy
    end
    
    typesig { [] }
    def get_policy_qualifiers
      return Collections.unmodifiable_set(@m_qualifier_set)
    end
    
    typesig { [] }
    def get_expected_policies
      return Collections.unmodifiable_set(@m_expected_policy_set)
    end
    
    typesig { [] }
    def is_critical
      return @m_criticality_indicator
    end
    
    typesig { [] }
    # 
    # Return a printable representation of the PolicyNode.
    # Starting at the node on which this method is called,
    # it recurses through the tree and prints out each node.
    # 
    # @return a String describing the contents of the Policy Node
    def to_s
      buffer = StringBuffer.new(self.as_string)
      it = get_children
      while (it.has_next)
        buffer.append(it.next)
      end
      return buffer.to_s
    end
    
    typesig { [] }
    # private methods and package private operations
    def is_immutable
      return @is_immutable
    end
    
    typesig { [] }
    # 
    # Sets the immutability flag of this node and all of its children
    # to true.
    def set_immutable
      if (@is_immutable)
        return
      end
      @m_children.each do |node|
        node.set_immutable
      end
      @is_immutable = true
    end
    
    typesig { [PolicyNodeImpl] }
    # 
    # Private method sets a child node. This is called from the child's
    # constructor.
    # 
    # @param child new <code>PolicyNodeImpl</code> child node
    def add_child(child)
      if (@is_immutable)
        raise IllegalStateException.new("PolicyNode is immutable")
      end
      @m_children.add(child)
    end
    
    typesig { [String] }
    # 
    # Adds an expectedPolicy to the expected policy set.
    # If this is the original expected policy set initialized
    # by the constructor, then the expected policy set is cleared
    # before the expected policy is added.
    # 
    # @param expectedPolicy a String representing an expected policy.
    def add_expected_policy(expected_policy)
      if (@is_immutable)
        raise IllegalStateException.new("PolicyNode is immutable")
      end
      if (@m_original_expected_policy_set)
        @m_expected_policy_set.clear
        @m_original_expected_policy_set = false
      end
      @m_expected_policy_set.add(expected_policy)
    end
    
    typesig { [::Java::Int] }
    # 
    # Removes all paths which don't reach the specified depth.
    # 
    # @param depth an int representing the desired minimum depth of all paths
    def prune(depth)
      if (@is_immutable)
        raise IllegalStateException.new("PolicyNode is immutable")
      end
      # if we have no children, we can't prune below us...
      if ((@m_children.size).equal?(0))
        return
      end
      it = @m_children.iterator
      while (it.has_next)
        node = it.next
        node.prune(depth)
        # now that we've called prune on the child, see if we should
        # remove it from the tree
        if (((node.attr_m_children.size).equal?(0)) && (depth > @m_depth + 1))
          it.remove
        end
      end
    end
    
    typesig { [PolicyNode] }
    # 
    # Deletes the specified child node of this node, if it exists.
    # 
    # @param childNode the child node to be deleted
    def delete_child(child_node)
      if (@is_immutable)
        raise IllegalStateException.new("PolicyNode is immutable")
      end
      @m_children.remove(child_node)
    end
    
    typesig { [] }
    # 
    # Returns a copy of the tree, without copying the policy-related data,
    # rooted at the node on which this was called.
    # 
    # @return a copy of the tree
    def copy_tree
      return copy_tree(nil)
    end
    
    typesig { [PolicyNodeImpl] }
    def copy_tree(parent)
      new_node = PolicyNodeImpl.new(parent, self)
      @m_children.each do |node|
        node.copy_tree(new_node)
      end
      return new_node
    end
    
    typesig { [::Java::Int] }
    # 
    # Returns all nodes at the specified depth in the tree.
    # 
    # @param depth an int representing the depth of the desired nodes
    # @return a <code>Set</code> of all nodes at the specified depth
    def get_policy_nodes(depth)
      set = HashSet.new
      get_policy_nodes(depth, set)
      return set
    end
    
    typesig { [::Java::Int, JavaSet] }
    # 
    # Add all nodes at depth depth to set and return the Set.
    # Internal recursion helper.
    def get_policy_nodes(depth, set)
      # if we've reached the desired depth, then return ourself
      if ((@m_depth).equal?(depth))
        set.add(self)
      else
        @m_children.each do |node|
          node.get_policy_nodes(depth, set)
        end
      end
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean] }
    # 
    # Finds all nodes at the specified depth whose expected_policy_set
    # contains the specified expected OID (if matchAny is false)
    # or the special OID "any value" (if matchAny is true).
    # 
    # @param depth an int representing the desired depth
    # @param expectedOID a String encoding the valid OID to match
    # @param matchAny a boolean indicating whether an expected_policy_set
    # containing ANY_POLICY should be considered a match
    # @return a Set of matched <code>PolicyNode</code>s
    def get_policy_nodes_expected(depth, expected_oid, match_any)
      if ((expected_oid == ANY_POLICY))
        return get_policy_nodes(depth)
      else
        return get_policy_nodes_expected_helper(depth, expected_oid, match_any)
      end
    end
    
    typesig { [::Java::Int, String, ::Java::Boolean] }
    def get_policy_nodes_expected_helper(depth, expected_oid, match_any)
      set = HashSet.new
      if (@m_depth < depth)
        @m_children.each do |node|
          set.add_all(node.get_policy_nodes_expected_helper(depth, expected_oid, match_any))
        end
      else
        if (match_any)
          if (@m_expected_policy_set.contains(ANY_POLICY))
            set.add(self)
          end
        else
          if (@m_expected_policy_set.contains(expected_oid))
            set.add(self)
          end
        end
      end
      return set
    end
    
    typesig { [::Java::Int, String] }
    # 
    # Finds all nodes at the specified depth that contains the
    # specified valid OID
    # 
    # @param depth an int representing the desired depth
    # @param validOID a String encoding the valid OID to match
    # @return a Set of matched <code>PolicyNode</code>s
    def get_policy_nodes_valid(depth, valid_oid)
      set = HashSet.new
      if (@m_depth < depth)
        @m_children.each do |node|
          set.add_all(node.get_policy_nodes_valid(depth, valid_oid))
        end
      else
        if ((@m_valid_policy == valid_oid))
          set.add(self)
        end
      end
      return set
    end
    
    class_module.module_eval {
      typesig { [String] }
      def policy_to_string(oid)
        if ((oid == ANY_POLICY))
          return "anyPolicy"
        else
          return oid
        end
      end
    }
    
    typesig { [] }
    # 
    # Prints out some data on this node.
    def as_string
      if ((@m_parent).nil?)
        return "anyPolicy  ROOT\n"
      else
        sb = StringBuffer.new
        i = 0
        n = get_depth
        while i < n
          sb.append("  ")
          ((i += 1) - 1)
        end
        sb.append(policy_to_string(get_valid_policy))
        sb.append("  CRIT: ")
        sb.append(is_critical)
        sb.append("  EP: ")
        get_expected_policies.each do |policy|
          sb.append(policy_to_string(policy))
          sb.append(" ")
        end
        sb.append(" (")
        sb.append(get_depth)
        sb.append(")\n")
        return sb.to_s
      end
    end
    
    private
    alias_method :initialize__policy_node_impl, :initialize
  end
  
end
