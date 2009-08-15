require "rjava"

# Portions Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
# *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module CharTrieImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :DataInputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  # Trie implementation which stores data in char, 16 bits.
  # @author synwee
  # @see com.ibm.icu.impl.Trie
  # @since release 2.1, Jan 01 2002
  # 
  # note that i need to handle the block calculations later, since chartrie
  # in icu4c uses the same index array.
  class CharTrie < CharTrieImports.const_get :Trie
    include_class_members CharTrieImports
    
    typesig { [InputStream, DataManipulate] }
    # public constructors ---------------------------------------------
    # 
    # <p>Creates a new Trie with the settings for the trie data.</p>
    # <p>Unserialize the 32-bit-aligned input stream and use the data for the
    # trie.</p>
    # @param inputStream file input stream to a ICU data file, containing
    # the trie
    # @param dataManipulate object which provides methods to parse the char
    # data
    # @throws IOException thrown when data reading fails
    # @draft 2.1
    def initialize(input_stream, data_manipulate)
      @m_initial_value_ = 0
      @m_data_ = nil
      @m_friend_agent_ = nil
      super(input_stream, data_manipulate)
      if (!is_char_trie)
        raise IllegalArgumentException.new("Data given does not belong to a char trie.")
      end
      @m_friend_agent_ = FriendAgent.new_local(self)
    end
    
    class_module.module_eval {
      # Java friend implementation
      const_set_lazy(:FriendAgent) { Class.new do
        extend LocalClass
        include_class_members CharTrie
        
        typesig { [] }
        # Gives out the index array of the trie
        # @return index array of trie
        def get_private_index
          return self.attr_m_index_
        end
        
        typesig { [] }
        # Gives out the data array of the trie
        # @return data array of trie
        def get_private_data
          return self.attr_m_data_
        end
        
        typesig { [] }
        # Gives out the data offset in the trie
        # @return data offset in the trie
        def get_private_initial_value
          return self.attr_m_initial_value_
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__friend_agent, :initialize
      end }
    }
    
    typesig { [UCharacterProperty] }
    # public methods --------------------------------------------------
    # 
    # Java friend implementation
    # To store the index and data array into the argument.
    # @param friend java friend UCharacterProperty object to store the array
    def put_index_data(friend)
      friend.set_index_data(@m_friend_agent_)
    end
    
    typesig { [::Java::Int] }
    # Gets the value associated with the codepoint.
    # If no value is associated with the codepoint, a default value will be
    # returned.
    # @param ch codepoint
    # @return offset to data
    # @draft 2.1
    def get_code_point_value(ch)
      offset = get_code_point_offset(ch)
      # return -1 if there is an error, in this case we return the default
      # value: m_initialValue_
      return (offset >= 0) ? @m_data_[offset] : @m_initial_value_
    end
    
    typesig { [::Java::Char] }
    # Gets the value to the data which this lead surrogate character points
    # to.
    # Returned data may contain folding offset information for the next
    # trailing surrogate character.
    # This method does not guarantee correct results for trail surrogates.
    # @param ch lead surrogate character
    # @return data value
    # @draft 2.1
    def get_lead_value(ch)
      return @m_data_[get_lead_offset(ch)]
    end
    
    typesig { [::Java::Char, ::Java::Char] }
    # Get the value associated with a pair of surrogates.
    # @param lead a lead surrogate
    # @param trail a trail surrogate
    # @draft 2.1
    def get_surrogate_value(lead, trail)
      offset = get_surrogate_offset(lead, trail)
      if (offset > 0)
        return @m_data_[offset]
      end
      return @m_initial_value_
    end
    
    typesig { [::Java::Int, ::Java::Char] }
    # <p>Get a value from a folding offset (from the value of a lead surrogate)
    # and a trail surrogate.</p>
    # <p>If the
    # @param leadvalue value associated with the lead surrogate which contains
    # the folding offset
    # @param trail surrogate
    # @return trie data value associated with the trail character
    # @draft 2.1
    def get_trail_value(leadvalue, trail)
      if ((self.attr_m_data_manipulate_).nil?)
        raise NullPointerException.new("The field DataManipulate in this Trie is null")
      end
      offset = self.attr_m_data_manipulate_.get_folding_offset(leadvalue)
      if (offset > 0)
        return @m_data_[get_raw_offset(offset, RJava.cast_to_char((trail & SURROGATE_MASK_)))]
      end
      return @m_initial_value_
    end
    
    typesig { [InputStream] }
    # protected methods -----------------------------------------------
    # 
    # <p>Parses the input stream and stores its trie content into a index and
    # data array</p>
    # @param inputStream data input stream containing trie data
    # @exception IOException thrown when data reading fails
    def unserialize(input_stream)
      input = DataInputStream.new(input_stream)
      index_data_length = self.attr_m_data_offset_ + self.attr_m_data_length_
      self.attr_m_index_ = CharArray.new(index_data_length)
      i = 0
      while i < index_data_length
        self.attr_m_index_[i] = input.read_char
        i += 1
      end
      @m_data_ = self.attr_m_index_
      @m_initial_value_ = @m_data_[self.attr_m_data_offset_]
    end
    
    typesig { [::Java::Char, ::Java::Char] }
    # Gets the offset to the data which the surrogate pair points to.
    # @param lead lead surrogate
    # @param trail trailing surrogate
    # @return offset to data
    # @draft 2.1
    def get_surrogate_offset(lead, trail)
      if ((self.attr_m_data_manipulate_).nil?)
        raise NullPointerException.new("The field DataManipulate in this Trie is null")
      end
      # get fold position for the next trail surrogate
      offset = self.attr_m_data_manipulate_.get_folding_offset(get_lead_value(lead))
      # get the real data from the folded lead/trail units
      if (offset > 0)
        return get_raw_offset(offset, RJava.cast_to_char((trail & SURROGATE_MASK_)))
      end
      # return -1 if there is an error, in this case we return the default
      # value: m_initialValue_
      return -1
    end
    
    typesig { [::Java::Int] }
    # Gets the value at the argument index.
    # For use internally in TrieIterator.
    # @param index value at index will be retrieved
    # @return 32 bit value
    # @see com.ibm.icu.impl.TrieIterator
    # @draft 2.1
    def get_value(index)
      return @m_data_[index]
    end
    
    typesig { [] }
    # Gets the default initial value
    # @return 32 bit value
    # @draft 2.1
    def get_initial_value
      return @m_initial_value_
    end
    
    # private data members --------------------------------------------
    # 
    # Default value
    attr_accessor :m_initial_value_
    alias_method :attr_m_initial_value_, :m_initial_value_
    undef_method :m_initial_value_
    alias_method :attr_m_initial_value_=, :m_initial_value_=
    undef_method :m_initial_value_=
    
    # Array of char data
    attr_accessor :m_data_
    alias_method :attr_m_data_, :m_data_
    undef_method :m_data_
    alias_method :attr_m_data_=, :m_data_=
    undef_method :m_data_=
    
    # Agent for friends
    attr_accessor :m_friend_agent_
    alias_method :attr_m_friend_agent_, :m_friend_agent_
    undef_method :m_friend_agent_
    alias_method :attr_m_friend_agent_=, :m_friend_agent_=
    undef_method :m_friend_agent_=
    
    private
    alias_method :initialize__char_trie, :initialize
  end
  
end
