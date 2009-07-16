require "rjava"

# 
# Copyright 1997 Sun Microsystems, Inc.  All Rights Reserved.
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
  module UniqueIdentityImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include_const ::Sun::Misc, :HexDumpEncoder
      include ::Sun::Security::Util
    }
  end
  
  # 
  # This class defines the UniqueIdentity class used by certificates.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class UniqueIdentity 
    include_class_members UniqueIdentityImports
    
    # Private data members
    attr_accessor :id
    alias_method :attr_id, :id
    undef_method :id
    alias_method :attr_id=, :id=
    undef_method :id=
    
    typesig { [BitArray] }
    # 
    # The default constructor for this class.
    # 
    # @param id the byte array containing the unique identifier.
    def initialize(id)
      @id = nil
      @id = id
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # 
    # The default constructor for this class.
    # 
    # @param id the byte array containing the unique identifier.
    def initialize(id)
      @id = nil
      @id = BitArray.new(id.attr_length * 8, id)
    end
    
    typesig { [DerInputStream] }
    # 
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the UniqueIdentity from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @id = nil
      der_val = in_.get_der_value
      @id = der_val.get_unaligned_bit_string(true)
    end
    
    typesig { [DerValue] }
    # 
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param derVal the DerValue decoded from the stream.
    # @param tag the tag the value is encoded under.
    # @exception IOException on decoding errors.
    def initialize(der_val)
      @id = nil
      @id = der_val.get_unaligned_bit_string(true)
    end
    
    typesig { [] }
    # 
    # Return the UniqueIdentity as a printable string.
    def to_s
      return ("UniqueIdentity:" + (@id.to_s).to_s + "\n")
    end
    
    typesig { [DerOutputStream, ::Java::Byte] }
    # 
    # Encode the UniqueIdentity in DER form to the stream.
    # 
    # @param out the DerOutputStream to marshal the contents to.
    # @param tag enocode it under the following tag.
    # @exception IOException on errors.
    def encode(out, tag)
      bytes = @id.to_byte_array
      excess_bits = bytes.attr_length * 8 - @id.length
      out.write(tag)
      out.put_length(bytes.attr_length + 1)
      out.write(excess_bits)
      out.write(bytes)
    end
    
    typesig { [] }
    # 
    # Return the unique id.
    def get_id
      if ((@id).nil?)
        return nil
      end
      return @id.to_boolean_array
    end
    
    private
    alias_method :initialize__unique_identity, :initialize
  end
  
end
