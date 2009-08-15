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
module Sun::Security::Provider::Certpath
  module AdjacencyListImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider::Certpath
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :JavaList
    }
  end
  
  # An AdjacencyList is used to store the history of certification paths
  # attempted in constructing a path from an initiator to a target. The
  # AdjacencyList is initialized with a <code>List</code> of
  # <code>List</code>s, where each sub-<code>List</code> contains objects of
  # type <code>Vertex</code>. A <code>Vertex</code> describes one possible or
  # actual step in the chain building process, and the associated
  # <code>Certificate</code>. Specifically, a <code>Vertex</code> object
  # contains a <code>Certificate</code> and an index value referencing the
  # next sub-list in the process. If the index value is -1 then this
  # <code>Vertex</code> doesn't continue the attempted build path.
  # <p>
  # Example:
  # <p>
  # Attempted Paths:<ul>
  # <li>C1-&gt;C2-&gt;C3
  # <li>C1-&gt;C4-&gt;C5
  # <li>C1-&gt;C4-&gt;C6
  # <li>C1-&gt;C4-&gt;C7
  # <li>C1-&gt;C8-&gt;C9
  # <li>C1-&gt;C10-&gt;C11
  # </ul>
  # <p>
  # AdjacencyList structure:<ul>
  # <li>AL[0] = C1,1
  # <li>AL[1] = C2,2   =&gt;C4,3   =&gt;C8,4     =&gt;C10,5
  # <li>AL[2] = C3,-1
  # <li>AL[3] = C5,-1  =&gt;C6,-1  =&gt;C7,-1
  # <li>AL[4] = C9,-1
  # <li>AL[5] = C11,-1
  # </ul>
  # <p>
  # The iterator method returns objects of type <code>BuildStep</code>, not
  # objects of type <code>Vertex</code>.
  # A <code>BuildStep</code> contains a <code>Vertex</code> and a result code,
  # accessable via getResult method. There are five result values.
  # <code>POSSIBLE</code> denotes that the current step represents a
  # <code>Certificate</code> that the builder is considering at this point in
  # the build. <code>FOLLOW</code> denotes a <code>Certificate</code> (one of
  # those noted as <code>POSSIBLE</code>) that the builder is using to try
  # extending the chain. <code>BACK</code> represents that a
  # <code>FOLLOW</code> was incorrect, and is being removed from the chain.
  # There is exactly one <code>FOLLOW</code> for each <code>BACK</code>. The
  # values <code>SUCCEED</code> and <code>FAIL</code> mean that we've come to
  # the end of the build process, and there will not be any more entries in
  # the list.
  # <p>
  # @see sun.security.provider.certpath.BuildStep
  # @see sun.security.provider.certpath.Vertex
  # <p>
  # @author  seth proctor
  # @since   1.4
  class AdjacencyList 
    include_class_members AdjacencyListImports
    
    # the actual set of steps the AdjacencyList represents
    attr_accessor :m_step_list
    alias_method :attr_m_step_list, :m_step_list
    undef_method :m_step_list
    alias_method :attr_m_step_list=, :m_step_list=
    undef_method :m_step_list=
    
    # the original list, just for the toString method
    attr_accessor :m_orig_list
    alias_method :attr_m_orig_list, :m_orig_list
    undef_method :m_orig_list
    alias_method :attr_m_orig_list=, :m_orig_list=
    undef_method :m_orig_list=
    
    typesig { [JavaList] }
    # Constructs a new <code>AdjacencyList</code> based on the specified
    # <code>List</code>. See the example above.
    # 
    # @param list a <code>List</code> of <code>List</code>s of
    # <code>Vertex</code> objects
    def initialize(list)
      @m_step_list = nil
      @m_orig_list = nil
      @m_step_list = ArrayList.new
      @m_orig_list = list
      build_list(list, 0, nil)
    end
    
    typesig { [] }
    # Gets an <code>Iterator</code> to iterate over the set of
    # <code>BuildStep</code>s in build-order. Any attempts to change
    # the list through the remove method will fail.
    # 
    # @return an <code>Iterator</code> over the <code>BuildStep</code>s
    def iterator
      return Collections.unmodifiable_list(@m_step_list).iterator
    end
    
    typesig { [JavaList, ::Java::Int, BuildStep] }
    # Recursive, private method which actually builds the step list from
    # the given adjacency list. <code>Follow</code> is the parent BuildStep
    # that we followed to get here, and if it's null, it means that we're
    # at the start.
    def build_list(the_list, index, follow)
      # Each time this method is called, we're examining a new list
      # from the global list. So, we have to start by getting the list
      # that contains the set of Vertexes we're considering.
      l = the_list.get(index)
      begin
        # we're interested in the case where all indexes are -1...
        all_neg_one = true
        # ...and in the case where every entry has a Throwable
        all_xcps = true
        l.each do |v|
          if (!(v.get_index).equal?(-1))
            # count an empty list the same as an index of -1...this
            # is to patch a bug somewhere in the builder
            if (!(the_list.get(v.get_index).size).equal?(0))
              all_neg_one = false
            end
          else
            if ((v.get_throwable).nil?)
              all_xcps = false
            end
          end
          # every entry, regardless of the final use for it, is always
          # entered as a possible step before we take any actions
          @m_step_list.add(BuildStep.new(v, BuildStep::POSSIBLE))
        end
        if (all_neg_one)
          # There are two cases that we could be looking at here. We
          # may need to back up, or the build may have succeeded at
          # this point. This is based on whether or not any
          # exceptions were found in the list.
          if (all_xcps)
            # we need to go back...see if this is the last one
            if ((follow).nil?)
              @m_step_list.add(BuildStep.new(nil, BuildStep::FAIL))
            else
              @m_step_list.add(BuildStep.new(follow.get_vertex, BuildStep::BACK))
            end
            return false
          else
            # we succeeded...now the only question is which is the
            # successful step? If there's only one entry without
            # a throwable, then that's the successful step. Otherwise,
            # we'll have to make some guesses...
            possibles = ArrayList.new
            l.each do |v|
              if ((v.get_throwable).nil?)
                possibles.add(v)
              end
            end
            if ((possibles.size).equal?(1))
              # real easy...we've found the final Vertex
              @m_step_list.add(BuildStep.new(possibles.get(0), BuildStep::SUCCEED))
            else
              # ok...at this point, there is more than one Cert
              # which might be the succeed step...how do we know
              # which it is? I'm going to assume that our builder
              # algorithm is good enough to know which is the
              # correct one, and put it first...but a FIXME goes
              # here anyway, and we should be comparing to the
              # target/initiator Cert...
              @m_step_list.add(BuildStep.new(possibles.get(0), BuildStep::SUCCEED))
            end
            return true
          end
        else
          # There's at least one thing that we can try before we give
          # up and go back. Run through the list now, and enter a new
          # BuildStep for each path that we try to follow. If none of
          # the paths we try produce a successful end, we're going to
          # have to back out ourselves.
          success = false
          l.each do |v|
            # Note that we'll only find a SUCCEED case when we're
            # looking at the last possible path, so we don't need to
            # consider success in the while loop
            if (!(v.get_index).equal?(-1))
              if (!(the_list.get(v.get_index).size).equal?(0))
                # If the entry we're looking at doesn't have an
                # index of -1, and doesn't lead to an empty list,
                # then it's something we follow!
                bs = BuildStep.new(v, BuildStep::FOLLOW)
                @m_step_list.add(bs)
                success = build_list(the_list, v.get_index, bs)
              end
            end
          end
          if (success)
            # We're already finished!
            return true
          else
            # We failed, and we've exhausted all the paths that we
            # could take. The only choice is to back ourselves out.
            if ((follow).nil?)
              @m_step_list.add(BuildStep.new(nil, BuildStep::FAIL))
            else
              @m_step_list.add(BuildStep.new(follow.get_vertex, BuildStep::BACK))
            end
            return false
          end
        end
      rescue JavaException => e
      end
      # we'll never get here, but you know java...
      return false
    end
    
    typesig { [] }
    # Prints out a string representation of this AdjacencyList.
    # 
    # @return String representation
    def to_s
      out = "[\n"
      i = 0
      @m_orig_list.each do |l|
        out = out + "LinkedList[" + RJava.cast_to_string(((i += 1) - 1)) + "]:\n"
        l.each do |step|
          begin
            out = out + RJava.cast_to_string(step.to_s)
            out = out + "\n"
          rescue JavaException => e
            out = out + "No Such Element\n"
          end
        end
      end
      out = out + "]\n"
      return out
    end
    
    private
    alias_method :initialize__adjacency_list, :initialize
  end
  
end
