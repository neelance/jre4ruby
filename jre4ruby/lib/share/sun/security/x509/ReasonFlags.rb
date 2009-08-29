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
module Sun::Security::X509
  module ReasonFlagsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Enumeration
      include ::Sun::Security::Util
    }
  end
  
  # Represent the CRL Reason Flags.
  # 
  # <p>This extension, if present, defines the identifies
  # the reason for the certificate revocation.
  # <p>The ASN.1 syntax for this is:
  # <pre>
  # ReasonFlags ::= BIT STRING {
  # unused                  (0),
  # keyCompromise           (1),
  # cACompromise            (2),
  # affiliationChanged      (3),
  # superseded              (4),
  # cessationOfOperation    (5),
  # certificateHold         (6),
  # privilegeWithdrawn      (7),
  # aACompromise            (8) }
  # </pre>
  # 
  # @author Hemma Prafullchandra
  class ReasonFlags 
    include_class_members ReasonFlagsImports
    
    class_module.module_eval {
      # Reasons
      const_set_lazy(:UNUSED) { "unused" }
      const_attr_reader  :UNUSED
      
      const_set_lazy(:KEY_COMPROMISE) { "key_compromise" }
      const_attr_reader  :KEY_COMPROMISE
      
      const_set_lazy(:CA_COMPROMISE) { "ca_compromise" }
      const_attr_reader  :CA_COMPROMISE
      
      const_set_lazy(:AFFILIATION_CHANGED) { "affiliation_changed" }
      const_attr_reader  :AFFILIATION_CHANGED
      
      const_set_lazy(:SUPERSEDED) { "superseded" }
      const_attr_reader  :SUPERSEDED
      
      const_set_lazy(:CESSATION_OF_OPERATION) { "cessation_of_operation" }
      const_attr_reader  :CESSATION_OF_OPERATION
      
      const_set_lazy(:CERTIFICATE_HOLD) { "certificate_hold" }
      const_attr_reader  :CERTIFICATE_HOLD
      
      const_set_lazy(:PRIVILEGE_WITHDRAWN) { "privilege_withdrawn" }
      const_attr_reader  :PRIVILEGE_WITHDRAWN
      
      const_set_lazy(:AA_COMPROMISE) { "aa_compromise" }
      const_attr_reader  :AA_COMPROMISE
      
      const_set_lazy(:NAMES) { Array.typed(String).new([UNUSED, KEY_COMPROMISE, CA_COMPROMISE, AFFILIATION_CHANGED, SUPERSEDED, CESSATION_OF_OPERATION, CERTIFICATE_HOLD, PRIVILEGE_WITHDRAWN, AA_COMPROMISE, ]) }
      const_attr_reader  :NAMES
      
      typesig { [String] }
      def name2_index(name)
        i = 0
        while i < NAMES.attr_length
          if (NAMES[i].equals_ignore_case(name))
            return i
          end
          i += 1
        end
        raise IOException.new("Name not recognized by ReasonFlags")
      end
    }
    
    # Private data members
    attr_accessor :bit_string
    alias_method :attr_bit_string, :bit_string
    undef_method :bit_string
    alias_method :attr_bit_string=, :bit_string=
    undef_method :bit_string=
    
    typesig { [::Java::Int] }
    # Check if bit is set.
    # 
    # @param position the position in the bit string to check.
    def is_set(position)
      return @bit_string[position]
    end
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Set the bit at the specified position.
    def set(position, val)
      # enlarge bitString if necessary
      if (position >= @bit_string.attr_length)
        tmp = Array.typed(::Java::Boolean).new(position + 1) { false }
        System.arraycopy(@bit_string, 0, tmp, 0, @bit_string.attr_length)
        @bit_string = tmp
      end
      @bit_string[position] = val
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Create a ReasonFlags with the passed bit settings.
    # 
    # @param reasons the bits to be set for the ReasonFlags.
    def initialize(reasons)
      @bit_string = nil
      @bit_string = BitArray.new(reasons.attr_length * 8, reasons).to_boolean_array
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    # Create a ReasonFlags with the passed bit settings.
    # 
    # @param reasons the bits to be set for the ReasonFlags.
    def initialize(reasons)
      @bit_string = nil
      @bit_string = reasons
    end
    
    typesig { [BitArray] }
    # Create a ReasonFlags with the passed bit settings.
    # 
    # @param reasons the bits to be set for the ReasonFlags.
    def initialize(reasons)
      @bit_string = nil
      @bit_string = reasons.to_boolean_array
    end
    
    typesig { [DerInputStream] }
    # Create the object from the passed DER encoded value.
    # 
    # @param in the DerInputStream to read the ReasonFlags from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @bit_string = nil
      der_val = in_.get_der_value
      @bit_string = der_val.get_unaligned_bit_string(true).to_boolean_array
    end
    
    typesig { [DerValue] }
    # Create the object from the passed DER encoded value.
    # 
    # @param derVal the DerValue decoded from the stream.
    # @exception IOException on decoding errors.
    def initialize(der_val)
      @bit_string = nil
      @bit_string = der_val.get_unaligned_bit_string(true).to_boolean_array
    end
    
    typesig { [] }
    # Returns the reason flags as a boolean array.
    def get_flags
      return @bit_string
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (!(obj.is_a?(Boolean)))
        raise IOException.new("Attribute must be of type Boolean.")
      end
      val = (obj).boolean_value
      set(name2_index(name), val)
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      return Boolean.value_of(is_set(name2_index(name)))
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      set(name, Boolean::FALSE)
    end
    
    typesig { [] }
    # Returns a printable representation of the ReasonFlags.
    def to_s
      s = "Reason Flags [\n"
      begin
        if (is_set(0))
          s += "  Unused\n"
        end
        if (is_set(1))
          s += "  Key Compromise\n"
        end
        if (is_set(2))
          s += "  CA Compromise\n"
        end
        if (is_set(3))
          s += "  Affiliation_Changed\n"
        end
        if (is_set(4))
          s += "  Superseded\n"
        end
        if (is_set(5))
          s += "  Cessation Of Operation\n"
        end
        if (is_set(6))
          s += "  Certificate Hold\n"
        end
        if (is_set(7))
          s += "  Privilege Withdrawn\n"
        end
        if (is_set(8))
          s += "  AA Compromise\n"
        end
      rescue ArrayIndexOutOfBoundsException => ex
      end
      s += "]\n"
      return (s)
    end
    
    typesig { [DerOutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      out.put_truncated_unaligned_bit_string(BitArray.new(@bit_string))
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      i = 0
      while i < NAMES.attr_length
        elements.add_element(NAMES[i])
        i += 1
      end
      return (elements.elements)
    end
    
    private
    alias_method :initialize__reason_flags, :initialize
  end
  
end
