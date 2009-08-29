require "rjava"

# Copyright 1997-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SerialNumberImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Math, :BigInteger
      include ::Sun::Security::Util
    }
  end
  
  # This class defines the SerialNumber class used by certificates.
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class SerialNumber 
    include_class_members SerialNumberImports
    
    attr_accessor :serial_num
    alias_method :attr_serial_num, :serial_num
    undef_method :serial_num
    alias_method :attr_serial_num=, :serial_num=
    undef_method :serial_num=
    
    typesig { [DerValue] }
    # Construct the class from the DerValue
    def construct(der_val)
      @serial_num = der_val.get_big_integer
      if (!(der_val.attr_data.available).equal?(0))
        raise IOException.new("Excess SerialNumber data")
      end
    end
    
    typesig { [BigInteger] }
    # The default constructor for this class using BigInteger.
    # 
    # @param num the BigInteger number used to create the serial number.
    def initialize(num)
      @serial_num = nil
      @serial_num = num
    end
    
    typesig { [::Java::Int] }
    # The default constructor for this class using int.
    # 
    # @param num the BigInteger number used to create the serial number.
    def initialize(num)
      @serial_num = nil
      @serial_num = BigInteger.value_of(num)
    end
    
    typesig { [DerInputStream] }
    # Create the object, decoding the values from the passed DER stream.
    # 
    # @param in the DerInputStream to read the SerialNumber from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @serial_num = nil
      der_val = in_.get_der_value
      construct(der_val)
    end
    
    typesig { [DerValue] }
    # Create the object, decoding the values from the passed DerValue.
    # 
    # @param val the DerValue to read the SerialNumber from.
    # @exception IOException on decoding errors.
    def initialize(val)
      @serial_num = nil
      construct(val)
    end
    
    typesig { [InputStream] }
    # Create the object, decoding the values from the passed stream.
    # 
    # @param in the InputStream to read the SerialNumber from.
    # @exception IOException on decoding errors.
    def initialize(in_)
      @serial_num = nil
      der_val = DerValue.new(in_)
      construct(der_val)
    end
    
    typesig { [] }
    # Return the SerialNumber as user readable string.
    def to_s
      return ("SerialNumber: [" + RJava.cast_to_string(Debug.to_hex_string(@serial_num)) + "]")
    end
    
    typesig { [DerOutputStream] }
    # Encode the SerialNumber in DER form to the stream.
    # 
    # @param out the DerOutputStream to marshal the contents to.
    # @exception IOException on errors.
    def encode(out)
      out.put_integer(@serial_num)
    end
    
    typesig { [] }
    # Return the serial number.
    def get_number
      return @serial_num
    end
    
    private
    alias_method :initialize__serial_number, :initialize
  end
  
end
