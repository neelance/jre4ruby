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
  module GeneralNamesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Util
      include_const ::Java::Io, :IOException
      include ::Sun::Security::Util
    }
  end
  
  # This object class represents the GeneralNames type required in
  # X509 certificates.
  # <p>The ASN.1 syntax for this is:
  # <pre>
  # GeneralNames ::= SEQUENCE SIZE (1..MAX) OF GeneralName
  # </pre>
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class GeneralNames 
    include_class_members GeneralNamesImports
    
    attr_accessor :names
    alias_method :attr_names, :names
    undef_method :names
    alias_method :attr_names=, :names=
    undef_method :names=
    
    typesig { [DerValue] }
    # Create the GeneralNames, decoding from the passed DerValue.
    # 
    # @param derVal the DerValue to construct the GeneralNames from.
    # @exception IOException on error.
    def initialize(der_val)
      initialize__general_names()
      if (!(der_val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for GeneralNames.")
      end
      if ((der_val.attr_data.available).equal?(0))
        raise IOException.new("No data available in " + "passed DER encoded value.")
      end
      # Decode all the GeneralName's
      while (!(der_val.attr_data.available).equal?(0))
        enc_name = der_val.attr_data.get_der_value
        name = GeneralName.new(enc_name)
        add(name)
      end
    end
    
    typesig { [] }
    # The default constructor for this class.
    def initialize
      @names = nil
      @names = ArrayList.new
    end
    
    typesig { [GeneralName] }
    def add(name)
      if ((name).nil?)
        raise NullPointerException.new
      end
      @names.add(name)
      return self
    end
    
    typesig { [::Java::Int] }
    def get(index)
      return @names.get(index)
    end
    
    typesig { [] }
    def is_empty
      return @names.is_empty
    end
    
    typesig { [] }
    def size
      return @names.size
    end
    
    typesig { [] }
    def iterator
      return @names.iterator
    end
    
    typesig { [] }
    def names
      return @names
    end
    
    typesig { [DerOutputStream] }
    # Write the extension to the DerOutputStream.
    # 
    # @param out the DerOutputStream to write the extension to.
    # @exception IOException on error.
    def encode(out)
      if (is_empty)
        return
      end
      temp = DerOutputStream.new
      @names.each do |gn|
        gn.encode(temp)
      end
      out.write(DerValue.attr_tag_sequence, temp)
    end
    
    typesig { [Object] }
    # compare this GeneralNames to other object for equality
    # 
    # @returns true iff this equals other
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if ((obj.is_a?(GeneralNames)).equal?(false))
        return false
      end
      other = obj
      return (@names == other.attr_names)
    end
    
    typesig { [] }
    def hash_code
      return @names.hash_code
    end
    
    typesig { [] }
    def to_s
      return @names.to_s
    end
    
    private
    alias_method :initialize__general_names, :initialize
  end
  
end
