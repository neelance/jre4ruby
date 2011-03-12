require "rjava"

# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::X509
  module GeneralSubtreesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Io
      include ::Java::Util
      include ::Sun::Security::Util
    }
  end
  
  # Represent the GeneralSubtrees ASN.1 object.
  # <p>
  # The ASN.1 for this is
  # <pre>
  # GeneralSubtrees ::= SEQUENCE SIZE (1..MAX) OF GeneralSubtree
  # </pre>
  # </p>
  # 
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @author Andreas Sterbenz
  class GeneralSubtrees 
    include_class_members GeneralSubtreesImports
    include Cloneable
    
    attr_accessor :trees
    alias_method :attr_trees, :trees
    undef_method :trees
    alias_method :attr_trees=, :trees=
    undef_method :trees=
    
    class_module.module_eval {
      # Private variables
      const_set_lazy(:NAME_DIFF_TYPE) { GeneralNameInterface::NAME_DIFF_TYPE }
      const_attr_reader  :NAME_DIFF_TYPE
      
      const_set_lazy(:NAME_MATCH) { GeneralNameInterface::NAME_MATCH }
      const_attr_reader  :NAME_MATCH
      
      const_set_lazy(:NAME_NARROWS) { GeneralNameInterface::NAME_NARROWS }
      const_attr_reader  :NAME_NARROWS
      
      const_set_lazy(:NAME_WIDENS) { GeneralNameInterface::NAME_WIDENS }
      const_attr_reader  :NAME_WIDENS
      
      const_set_lazy(:NAME_SAME_TYPE) { GeneralNameInterface::NAME_SAME_TYPE }
      const_attr_reader  :NAME_SAME_TYPE
    }
    
    typesig { [] }
    # The default constructor for the class.
    def initialize
      @trees = nil
      @trees = ArrayList.new
    end
    
    typesig { [GeneralSubtrees] }
    def initialize(source)
      @trees = nil
      @trees = ArrayList.new(source.attr_trees)
    end
    
    typesig { [DerValue] }
    # Create the object from the passed DER encoded form.
    # 
    # @param val the DER encoded form of the same.
    def initialize(val)
      initialize__general_subtrees()
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding of GeneralSubtrees.")
      end
      while (!(val.attr_data.available).equal?(0))
        opt = val.attr_data.get_der_value
        tree = GeneralSubtree.new(opt)
        add(tree)
      end
    end
    
    typesig { [::Java::Int] }
    def get(index)
      return @trees.get(index)
    end
    
    typesig { [::Java::Int] }
    def remove(index)
      @trees.remove(index)
    end
    
    typesig { [GeneralSubtree] }
    def add(tree)
      if ((tree).nil?)
        raise NullPointerException.new
      end
      @trees.add(tree)
    end
    
    typesig { [GeneralSubtree] }
    def contains(tree)
      if ((tree).nil?)
        raise NullPointerException.new
      end
      return @trees.contains(tree)
    end
    
    typesig { [] }
    def size
      return @trees.size
    end
    
    typesig { [] }
    def iterator
      return @trees.iterator
    end
    
    typesig { [] }
    def trees
      return @trees
    end
    
    typesig { [] }
    def clone
      return GeneralSubtrees.new(self)
    end
    
    typesig { [] }
    # Return a printable string of the GeneralSubtree.
    def to_s
      s = "   GeneralSubtrees:\n" + RJava.cast_to_string(@trees.to_s) + "\n"
      return s
    end
    
    typesig { [DerOutputStream] }
    # Encode the GeneralSubtrees.
    # 
    # @params out the DerOutputStrean to encode this object to.
    def encode(out)
      seq = DerOutputStream.new
      i = 0
      n = size
      while i < n
        get(i).encode(seq)
        i += 1
      end
      out.write(DerValue.attr_tag_sequence, seq)
    end
    
    typesig { [Object] }
    # Compare two general subtrees by comparing the subtrees
    # of each.
    # 
    # @param other GeneralSubtrees to compare to this
    # @returns true if match
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(GeneralSubtrees)).equal?(false))
        return false
      end
      other = obj
      return (@trees == other.attr_trees)
    end
    
    typesig { [] }
    def hash_code
      return @trees.hash_code
    end
    
    typesig { [::Java::Int] }
    # Return the GeneralNameInterface form of the GeneralName in one of
    # the GeneralSubtrees.
    # 
    # @param ndx index of the GeneralSubtree from which to obtain the name
    def get_general_name_interface(ndx)
      return get_general_name_interface(get(ndx))
    end
    
    class_module.module_eval {
      typesig { [GeneralSubtree] }
      def get_general_name_interface(gs)
        gn = gs.get_name
        gni = gn.get_name
        return gni
      end
    }
    
    typesig { [] }
    # minimize this GeneralSubtrees by removing all redundant entries.
    # Internal method used by intersect and reduce.
    def minimize
      # Algorithm: compare each entry n to all subsequent entries in
      # the list: if any subsequent entry matches or widens entry n,
      # remove entry n. If any subsequent entries narrow entry n, remove
      # the subsequent entries.
      i = 0
      while i < size
        current = get_general_name_interface(i)
        remove1 = false
        # compare current to subsequent elements
        j = i + 1
        while j < size
          subsequent = get_general_name_interface(j)
          case (current.constrains(subsequent))
          when GeneralNameInterface::NAME_DIFF_TYPE
            # not comparable; different name types; keep checking
            j += 1
            next
            # delete one of the duplicates
            remove1 = true
          when GeneralNameInterface::NAME_MATCH
            # delete one of the duplicates
            remove1 = true
          when GeneralNameInterface::NAME_NARROWS
            # subsequent narrows current
            # remove narrower name (subsequent)
            remove(j)
            j -= 1 # continue check with new subsequent
            j += 1
            next
            # subsequent widens current
            # remove narrower name current
            remove1 = true
          when GeneralNameInterface::NAME_WIDENS
            # subsequent widens current
            # remove narrower name current
            remove1 = true
          when GeneralNameInterface::NAME_SAME_TYPE
            # keep both for now; keep checking
            j += 1
            next
          end
          break
          j += 1
        end # end of this pass of subsequent elements
        if (remove1)
          remove(i)
          i -= 1 # check the new i value
        end
        i += 1
      end
    end
    
    typesig { [GeneralNameInterface] }
    # create a subtree containing an instance of the input
    # name type that widens all other names of that type.
    # 
    # @params name GeneralNameInterface name
    # @returns GeneralSubtree containing widest name of that type
    # @throws RuntimeException on error (should not occur)
    def create_widest_subtree(name)
      begin
        new_name = nil
        case (name.get_type)
        when GeneralNameInterface::NAME_ANY
          # Create new OtherName with same OID as baseName, but
          # empty value
          other_oid = (name).get_oid
          new_name = GeneralName.new(OtherName.new(other_oid, nil))
        when GeneralNameInterface::NAME_RFC822
          new_name = GeneralName.new(RFC822Name.new(""))
        when GeneralNameInterface::NAME_DNS
          new_name = GeneralName.new(DNSName.new(""))
        when GeneralNameInterface::NAME_X400
          new_name = GeneralName.new(X400Address.new(nil))
        when GeneralNameInterface::NAME_DIRECTORY
          new_name = GeneralName.new(X500Name.new(""))
        when GeneralNameInterface::NAME_EDI
          new_name = GeneralName.new(EDIPartyName.new(""))
        when GeneralNameInterface::NAME_URI
          new_name = GeneralName.new(URIName.new(""))
        when GeneralNameInterface::NAME_IP
          new_name = GeneralName.new(IPAddressName.new(nil))
        when GeneralNameInterface::NAME_OID
          new_name = GeneralName.new(OIDName.new(ObjectIdentifier.new(nil)))
        else
          raise IOException.new("Unsupported GeneralNameInterface type: " + RJava.cast_to_string(name.get_type))
        end
        return GeneralSubtree.new(new_name, 0, -1)
      rescue IOException => e
        raise RuntimeException.new("Unexpected error: " + RJava.cast_to_string(e), e)
      end
    end
    
    typesig { [GeneralSubtrees] }
    # intersect this GeneralSubtrees with other.  This function
    # is used in merging permitted NameConstraints.  The operation
    # is performed as follows:
    # <ul>
    # <li>If a name in other narrows all names of the same type in this,
    #     the result will contain the narrower name and none of the
    #     names it narrows.
    # <li>If a name in other widens all names of the same type in this,
    #     the result will not contain the wider name.
    # <li>If a name in other does not share the same subtree with any name
    #     of the same type in this, then the name is added to the list
    #     of GeneralSubtrees returned.  These names should be added to
    #     the list of names that are specifically excluded.  The reason
    #     is that, if the intersection is empty, then no names of that
    #     type are permitted, and the only way to express this in
    #     NameConstraints is to include the name in excludedNames.
    # <li>If a name in this has no name of the same type in other, then
    #     the result contains the name in this.  No name of a given type
    #     means the name type is completely permitted.
    # <li>If a name in other has no name of the same type in this, then
    #     the result contains the name in other.  This means that
    #     the name is now constrained in some way, whereas before it was
    #     completely permitted.
    # <ul>
    # 
    # @param other GeneralSubtrees to be intersected with this
    # @returns GeneralSubtrees to be merged with excluded; these are
    #          empty-valued name types corresponding to entries that were
    #          of the same type but did not share the same subtree between
    #          this and other. Returns null if no such.
    def intersect(other)
      if ((other).nil?)
        raise NullPointerException.new("other GeneralSubtrees must not be null")
      end
      new_this = GeneralSubtrees.new
      new_excluded = nil
      # Step 1: If this is empty, just add everything in other to this and
      # return no new excluded entries
      if ((size).equal?(0))
        union(other)
        return nil
      end
      # Step 2: For ease of checking the subtrees, minimize them by
      # constructing versions that contain only the widest instance of
      # each type
      self.minimize
      other.minimize
      # Step 3: Check each entry in this to see whether we keep it or
      # remove it, and whether we add anything to newExcluded or newThis.
      # We keep an entry in this unless it is narrowed by all entries in
      # other.  We add an entry to newExcluded if there is at least one
      # entry of the same nameType in other, but this entry does
      # not share the same subtree with any of the entries in other.
      # We add an entry from other to newThis if there is no name of the
      # same type in this.
      i = 0
      while i < size
        this_entry = get_general_name_interface(i)
        remove_this_entry = false
        # Step 3a: If the widest name of this type in other narrows
        # thisEntry, remove thisEntry and add widest other to newThis.
        # Simultaneously, check for situation where there is a name of
        # this type in other, but no name in other matches, narrows,
        # or widens thisEntry.
        same_type = false
        j = 0
        while j < other.size
          other_entry_gs = other.get(j)
          other_entry = get_general_name_interface(other_entry_gs)
          case (this_entry.constrains(other_entry))
          when NAME_NARROWS
            remove(i)
            i -= 1
            new_this.add(other_entry_gs)
            same_type = false
          when NAME_SAME_TYPE
            same_type = true
            j += 1
            next
            same_type = false
          when NAME_MATCH, NAME_WIDENS
            same_type = false
          when NAME_DIFF_TYPE
            j += 1
            next
          else
            j += 1
            next
          end
          break
          j += 1
        end
        # Step 3b: If sameType is still true, we have the situation
        # where there was a name of the same type as thisEntry in
        # other, but no name in other widened, matched, or narrowed
        # thisEntry.
        if (same_type)
          # Step 3b.1: See if there are any entries in this and other
          # with this type that match, widen, or narrow each other.
          # If not, then we need to add a "widest subtree" of this
          # type to excluded.
          intersection = false
          j_ = 0
          while j_ < size
            this_alt_entry = get_general_name_interface(j_)
            if ((this_alt_entry.get_type).equal?(this_entry.get_type))
              k = 0
              while k < other.size
                oth_alt_entry = other.get_general_name_interface(k)
                constraint_type = this_alt_entry.constrains(oth_alt_entry)
                if ((constraint_type).equal?(NAME_MATCH) || (constraint_type).equal?(NAME_WIDENS) || (constraint_type).equal?(NAME_NARROWS))
                  intersection = true
                  break
                end
                k += 1
              end
            end
            j_ += 1
          end
          if ((intersection).equal?(false))
            if ((new_excluded).nil?)
              new_excluded = GeneralSubtrees.new
            end
            widest_subtree = create_widest_subtree(this_entry)
            if (!new_excluded.contains(widest_subtree))
              new_excluded.add(widest_subtree)
            end
          end
          # Step 3b.2: Remove thisEntry from this
          remove(i)
          i -= 1
        end
        i += 1
      end
      # Step 4: Add all entries in newThis to this
      if (new_this.size > 0)
        union(new_this)
      end
      # Step 5: Add all entries in other that do not have any entry of the
      # same type in this to this
      i_ = 0
      while i_ < other.size
        other_entry_gs = other.get(i_)
        other_entry = get_general_name_interface(other_entry_gs)
        diff_type = false
        j = 0
        while j < size
          this_entry = get_general_name_interface(j)
          case (this_entry.constrains(other_entry))
          when NAME_DIFF_TYPE
            diff_type = true
            # continue to see if we find something later of the
            # same type
            j += 1
            next
            diff_type = false # we found an entry of the same type
            # break because we know we won't be adding it to
            # this now
          when NAME_NARROWS, NAME_SAME_TYPE, NAME_MATCH, NAME_WIDENS
            diff_type = false # we found an entry of the same type
            # break because we know we won't be adding it to
            # this now
          else
            j += 1
            next
          end
          break
          j += 1
        end
        if (diff_type)
          add(other_entry_gs)
        end
        i_ += 1
      end
      # Step 6: Return the newExcluded GeneralSubtrees
      return new_excluded
    end
    
    typesig { [GeneralSubtrees] }
    # construct union of this GeneralSubtrees with other.
    # 
    # @param other GeneralSubtrees to be united with this
    def union(other)
      if (!(other).nil?)
        i = 0
        n = other.size
        while i < n
          add(other.get(i))
          i += 1
        end
        # Minimize this
        minimize
      end
    end
    
    typesig { [GeneralSubtrees] }
    # reduce this GeneralSubtrees by contents of another.  This function
    # is used in merging excluded NameConstraints with permitted NameConstraints
    # to obtain a minimal form of permitted NameConstraints.  It is an
    # optimization, and does not affect correctness of the results.
    # 
    # @param excluded GeneralSubtrees
    def reduce(excluded)
      if ((excluded).nil?)
        return
      end
      i = 0
      n = excluded.size
      while i < n
        excluded_name = excluded.get_general_name_interface(i)
        j = 0
        while j < size
          permitted = get_general_name_interface(j)
          case (excluded_name.constrains(permitted))
          when GeneralNameInterface::NAME_DIFF_TYPE
          when GeneralNameInterface::NAME_MATCH
            remove(j)
            j -= 1
          when GeneralNameInterface::NAME_NARROWS
            # permitted narrows excluded
            remove(j)
            j -= 1
          when GeneralNameInterface::NAME_WIDENS
            # permitted widens excluded
          when GeneralNameInterface::NAME_SAME_TYPE
          end
          j += 1
        end # end of this pass of permitted
        i += 1
      end # end of pass of excluded
    end
    
    private
    alias_method :initialize__general_subtrees, :initialize
  end
  
end
