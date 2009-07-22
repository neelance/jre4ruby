require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module ObjectIdentifierImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include ::Java::Io
    }
  end
  
  # >= 2
  # 
  # Represent an ISO Object Identifier.
  # 
  # <P>Object Identifiers are arbitrary length hierarchical identifiers.
  # The individual components are numbers, and they define paths from the
  # root of an ISO-managed identifier space.  You will sometimes see a
  # string name used instead of (or in addition to) the numerical id.
  # These are synonyms for the numerical IDs, but are not widely used
  # since most sites do not know all the requisite strings, while all
  # sites can parse the numeric forms.
  # 
  # <P>So for example, JavaSoft has the sole authority to assign the
  # meaning to identifiers below the 1.3.6.1.4.1.42.2.17 node in the
  # hierarchy, and other organizations can easily acquire the ability
  # to assign such unique identifiers.
  # 
  # 
  # @author David Brownell
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class ObjectIdentifier 
    include_class_members ObjectIdentifierImports
    include Serializable
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { 8697030238860181294 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:MaxFirstComponent) { 2 }
      const_attr_reader  :MaxFirstComponent
      
      const_set_lazy(:MaxSecondComponent) { 39 }
      const_attr_reader  :MaxSecondComponent
    }
    
    typesig { [String] }
    # Constructs an object identifier from a string.  This string
    # should be of the form 1.23.34.45.56 etc.
    def initialize(oid)
      @components = nil
      @component_len = 0
      @string_form = nil
      ch = Character.new(?..ord)
      start = 0
      end_ = 0
      # Calculate length of oid
      @component_len = 0
      while (!((end_ = oid.index_of(ch, start))).equal?(-1))
        start = end_ + 1
        @component_len += 1
      end
      @component_len += 1
      @components = Array.typed(::Java::Int).new(@component_len) { 0 }
      start = 0
      i = 0
      comp = nil
      begin
        while (!((end_ = oid.index_of(ch, start))).equal?(-1))
          comp = (oid.substring(start, end_)).to_s
          @components[((i += 1) - 1)] = JavaInteger.value_of(comp).int_value
          start = end_ + 1
        end
        comp = (oid.substring(start)).to_s
        @components[i] = JavaInteger.value_of(comp).int_value
      rescue Exception => e
        raise IOException.new("ObjectIdentifier() -- Invalid format: " + (e.to_s).to_s, e)
      end
      check_valid_oid(@components, @component_len)
      @string_form = oid
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int] }
    # Check if the values make a legal OID. There must be at least 2
    # components and they must be all non-negative. The first component
    # should be 0,1 or 2. When the first component is 0 or 1, the
    # second component should be less than or equal to 39
    # 
    # @param values the components that will make the OID
    # @param len the number of components to check. Note that the allocation
    # size of <code>values</code> may be longer than <code>len</code>.
    # In this case, only the first <code>len</code> items are checked.
    # @exception IOException if this is not a legal OID
    def check_valid_oid(values, len)
      if ((values).nil? || len < 2)
        raise IOException.new("ObjectIdentifier() -- " + "Must be at least two oid components ")
      end
      i = 0
      while i < len
        if (values[i] < 0)
          raise IOException.new("ObjectIdentifier() -- " + "oid component #" + ((i + 1)).to_s + " must be non-negative ")
        end
        i += 1
      end
      if (values[0] > MaxFirstComponent)
        raise IOException.new("ObjectIdentifier() -- " + "First oid component is invalid ")
      end
      if (values[0] < 2 && values[1] > MaxSecondComponent)
        raise IOException.new("ObjectIdentifier() -- " + "Second oid component is invalid ")
      end
    end
    
    typesig { [Array.typed(::Java::Int)] }
    # Constructs an object ID from an array of integers.  This
    # is used to construct constant object IDs.
    def initialize(values)
      @components = nil
      @component_len = 0
      @string_form = nil
      check_valid_oid(values, values.attr_length)
      @components = values.clone
      @component_len = values.attr_length
    end
    
    typesig { [DerInputStream] }
    # Constructs an object ID from an ASN.1 encoded input stream.
    # The encoding of the ID in the stream uses "DER", a BER/1 subset.
    # In this case, that means a triple { typeId, length, data }.
    # 
    # <P><STRONG>NOTE:</STRONG>  When an exception is thrown, the
    # input stream has not been returned to its "initial" state.
    # 
    # @param in DER-encoded data holding an object ID
    # @exception IOException indicates a decoding error
    def initialize(in_)
      @components = nil
      @component_len = 0
      @string_form = nil
      type_id = 0
      buffer_end = 0
      # Object IDs are a "universal" type, and their tag needs only
      # one byte of encoding.  Verify that the tag of this datum
      # is that of an object ID.
      # 
      # Then get and check the length of the ID's encoding.  We set
      # up so that we can use in.available() to check for the end of
      # this value in the data stream.
      type_id = in_.get_byte
      if (!(type_id).equal?(DerValue.attr_tag_object_id))
        raise IOException.new("ObjectIdentifier() -- data isn't an object ID" + " (tag = " + (type_id).to_s + ")")
      end
      buffer_end = in_.available - in_.get_length - 1
      if (buffer_end < 0)
        raise IOException.new("ObjectIdentifier() -- not enough data")
      end
      init_from_encoding(in_, buffer_end)
    end
    
    typesig { [DerInputBuffer] }
    # Build the OID from the rest of a DER input buffer; the tag
    # and length have been removed/verified
    def initialize(buf)
      @components = nil
      @component_len = 0
      @string_form = nil
      init_from_encoding(DerInputStream.new(buf), 0)
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Boolean] }
    # Private constructor for use by newInternal(). Dummy argument
    # to avoid clash with the public constructor.
    def initialize(components, dummy)
      @components = nil
      @component_len = 0
      @string_form = nil
      @components = components
      @component_len = components.attr_length
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Int)] }
      # Create a new ObjectIdentifier for internal use. The values are
      # neither checked nor cloned.
      def new_internal(values)
        return ObjectIdentifier.new(values, true)
      end
    }
    
    typesig { [DerInputStream, ::Java::Int] }
    # Helper function -- get the OID from a stream, after tag and
    # length are verified.
    def init_from_encoding(in_, buffer_end)
      # Now get the components ("sub IDs") one at a time.  We fill a
      # temporary buffer, resizing it as needed.
      component = 0
      first_subid = true
      @components = Array.typed(::Java::Int).new(AllocationQuantum) { 0 }
      @component_len = 0
      while in_.available > buffer_end
        component = get_component(in_)
        if (component < 0)
          raise IOException.new("ObjectIdentifier() -- " + "component values must be nonnegative")
        end
        if (first_subid)
          x = 0
          y = 0
          # NOTE:  the allocation quantum is large enough that we know
          # we don't have to reallocate here!
          if (component < 40)
            x = 0
          else
            if (component < 80)
              x = 1
            else
              x = 2
            end
          end
          y = component - (x * 40)
          @components[0] = x
          @components[1] = y
          @component_len = 2
          first_subid = false
        else
          # Other components are encoded less exotically.  The only
          # potential trouble is the need to grow the array.
          if (@component_len >= @components.attr_length)
            tmp_components = 0
            tmp_components = Array.typed(::Java::Int).new(@components.attr_length + AllocationQuantum) { 0 }
            System.arraycopy(@components, 0, tmp_components, 0, @components.attr_length)
            @components = tmp_components
          end
          @components[((@component_len += 1) - 1)] = component
        end
      end
      check_valid_oid(@components, @component_len)
      # Final sanity check -- if we didn't use exactly the number of bytes
      # specified, something's quite wrong.
      if (!(in_.available).equal?(buffer_end))
        raise IOException.new("ObjectIdentifier() -- malformed input data")
      end
    end
    
    typesig { [DerOutputStream] }
    # n.b. the only public interface is DerOutputStream.putOID()
    def encode(out)
      bytes = DerOutputStream.new
      i = 0
      # According to ISO X.660, when the 1st component is 0 or 1, the 2nd
      # component is restricted to be less than or equal to 39, thus make
      # it small enough to be encoded into one single byte.
      if (@components[0] < 2)
        bytes.write((@components[0] * 40) + @components[1])
      else
        put_component(bytes, (@components[0] * 40) + @components[1])
      end
      i = 2
      while i < @component_len
        put_component(bytes, @components[i])
        i += 1
      end
      # Now that we've constructed the component, encode
      # it in the stream we were given.
      out.write(DerValue.attr_tag_object_id, bytes)
    end
    
    class_module.module_eval {
      typesig { [DerInputStream] }
      # Tricky OID component parsing technique ... note that one bit
      # per octet is lost, this returns at most 28 bits of component.
      # Also, notice this parses in big-endian format.
      def get_component(in_)
        retval = 0
        i = 0
        tmp = 0
        i = 0
        retval = 0
        while i < 4
          retval <<= 7
          tmp = in_.get_byte
          retval |= (tmp & 0x7f)
          if (((tmp & 0x80)).equal?(0))
            return retval
          end
          i += 1
        end
        raise IOException.new("ObjectIdentifier() -- component value too big")
      end
      
      typesig { [DerOutputStream, ::Java::Int] }
      # Reverse of the above routine.  Notice it needs to emit in
      # big-endian form, so it buffers the output until it's ready.
      # (Minimum length encoding is a DER requirement.)
      def put_component(out, val)
        i = 0
        # TODO: val must be <128*128*128*128 here, otherwise, 4 bytes is not
        # enough to hold it. Will address this later.
        buf = Array.typed(::Java::Byte).new(4) { 0 }
        i = 0
        while i < 4
          buf[i] = (val & 0x7f)
          val >>= 7
          if ((val).equal?(0))
            break
          end
          i += 1
        end
        while i > 0
          out.write(buf[i] | 0x80)
          (i -= 1)
        end
        out.write(buf[0])
      end
    }
    
    typesig { [ObjectIdentifier] }
    # XXX this API should probably facilitate the JDK sort utility
    # 
    # Compares this identifier with another, for sorting purposes.
    # An identifier does not precede itself.
    # 
    # @param other identifer that may precede this one.
    # @return true iff <em>other</em> precedes this one
    # in a particular sorting order.
    def precedes(other)
      i = 0
      # shorter IDs go first
      if ((other).equal?(self) || @component_len < other.attr_component_len)
        return false
      end
      if (other.attr_component_len < @component_len)
        return true
      end
      # for each component, the lesser component goes first
      i = 0
      while i < @component_len
        if (other.attr_components[i] < @components[i])
          return true
        end
        i += 1
      end
      # identical IDs don't precede each other
      return false
    end
    
    typesig { [ObjectIdentifier] }
    # @deprecated Use equals((Object)oid)
    def equals(other)
      return equals(other)
    end
    
    typesig { [Object] }
    # Compares this identifier with another, for equality.
    # 
    # @return true iff the names are identical.
    def equals(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(ObjectIdentifier)).equal?(false))
        return false
      end
      other = obj
      if (!(@component_len).equal?(other.attr_component_len))
        return false
      end
      i = 0
      while i < @component_len
        if (!(@components[i]).equal?(other.attr_components[i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    typesig { [] }
    def hash_code
      h = @component_len
      i = 0
      while i < @component_len
        h += @components[i] * 37
        i += 1
      end
      return h
    end
    
    typesig { [] }
    # Returns a string form of the object ID.  The format is the
    # conventional "dot" notation for such IDs, without any
    # user-friendly descriptive strings, since those strings
    # will not be understood everywhere.
    def to_s
      s = @string_form
      if ((s).nil?)
        sb = StringBuffer.new(@component_len * 4)
        i = 0
        while i < @component_len
          if (!(i).equal?(0))
            sb.append(Character.new(?..ord))
          end
          sb.append(@components[i])
          i += 1
        end
        s = (sb.to_s).to_s
        @string_form = s
      end
      return s
    end
    
    # To simplify, we assume no individual component of an object ID is
    # larger than 32 bits.  Then we represent the path from the root as
    # an array that's (usually) only filled at the beginning.
    attr_accessor :components
    alias_method :attr_components, :components
    undef_method :components
    alias_method :attr_components=, :components=
    undef_method :components=
    
    # path from root
    attr_accessor :component_len
    alias_method :attr_component_len, :component_len
    undef_method :component_len
    alias_method :attr_component_len=, :component_len=
    undef_method :component_len=
    
    # how much is used.
    attr_accessor :string_form
    alias_method :attr_string_form, :string_form
    undef_method :string_form
    alias_method :attr_string_form=, :string_form=
    undef_method :string_form=
    
    class_module.module_eval {
      const_set_lazy(:AllocationQuantum) { 5 }
      const_attr_reader  :AllocationQuantum
    }
    
    private
    alias_method :initialize__object_identifier, :initialize
  end
  
end
