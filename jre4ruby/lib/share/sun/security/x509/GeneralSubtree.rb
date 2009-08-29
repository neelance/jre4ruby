require "rjava"

# Copyright 1997-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module GeneralSubtreeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include ::Java::Io
      include ::Sun::Security::Util
    }
  end
  
  # Represent the GeneralSubtree ASN.1 object, whose syntax is:
  # <pre>
  # GeneralSubtree ::= SEQUENCE {
  # base             GeneralName,
  # minimum  [0]     BaseDistance DEFAULT 0,
  # maximum  [1]     BaseDistance OPTIONAL
  # }
  # BaseDistance ::= INTEGER (0..MAX)
  # </pre>
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  class GeneralSubtree 
    include_class_members GeneralSubtreeImports
    
    class_module.module_eval {
      const_set_lazy(:TAG_MIN) { 0 }
      const_attr_reader  :TAG_MIN
      
      const_set_lazy(:TAG_MAX) { 1 }
      const_attr_reader  :TAG_MAX
      
      const_set_lazy(:MIN_DEFAULT) { 0 }
      const_attr_reader  :MIN_DEFAULT
    }
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :minimum
    alias_method :attr_minimum, :minimum
    undef_method :minimum
    alias_method :attr_minimum=, :minimum=
    undef_method :minimum=
    
    attr_accessor :maximum
    alias_method :attr_maximum, :maximum
    undef_method :maximum
    alias_method :attr_maximum=, :maximum=
    undef_method :maximum=
    
    attr_accessor :myhash
    alias_method :attr_myhash, :myhash
    undef_method :myhash
    alias_method :attr_myhash=, :myhash=
    undef_method :myhash=
    
    typesig { [GeneralName, ::Java::Int, ::Java::Int] }
    # The default constructor for the class.
    # 
    # @params name the GeneralName
    # @params min the minimum BaseDistance
    # @params max the maximum BaseDistance
    def initialize(name, min, max)
      @name = nil
      @minimum = MIN_DEFAULT
      @maximum = -1
      @myhash = -1
      @name = name
      @minimum = min
      @maximum = max
    end
    
    typesig { [DerValue] }
    # Create the object from its DER encoded form.
    # 
    # @param val the DER encoded from of the same.
    def initialize(val)
      @name = nil
      @minimum = MIN_DEFAULT
      @maximum = -1
      @myhash = -1
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for GeneralSubtree.")
      end
      @name = GeneralName.new(val.attr_data.get_der_value, true)
      # NB. this is always encoded with the IMPLICIT tag
      # The checks only make sense if we assume implicit tagging,
      # with explicit tagging the form is always constructed.
      while (!(val.attr_data.available).equal?(0))
        opt = val.attr_data.get_der_value
        if (opt.is_context_specific(TAG_MIN) && !opt.is_constructed)
          opt.reset_tag(DerValue.attr_tag_integer)
          @minimum = opt.get_integer
        else
          if (opt.is_context_specific(TAG_MAX) && !opt.is_constructed)
            opt.reset_tag(DerValue.attr_tag_integer)
            @maximum = opt.get_integer
          else
            raise IOException.new("Invalid encoding of GeneralSubtree.")
          end
        end
      end
    end
    
    typesig { [] }
    # Return the GeneralName.
    # 
    # @return the GeneralName
    def get_name
      # XXXX May want to consider cloning this
      return @name
    end
    
    typesig { [] }
    # Return the minimum BaseDistance.
    # 
    # @return the minimum BaseDistance. Default is 0 if not set.
    def get_minimum
      return @minimum
    end
    
    typesig { [] }
    # Return the maximum BaseDistance.
    # 
    # @return the maximum BaseDistance, or -1 if not set.
    def get_maximum
      return @maximum
    end
    
    typesig { [] }
    # Return a printable string of the GeneralSubtree.
    def to_s
      s = "\n   GeneralSubtree: [\n" + "    GeneralName: " + RJava.cast_to_string((((@name).nil?) ? "" : @name.to_s)) + "\n    Minimum: " + RJava.cast_to_string(@minimum)
      if ((@maximum).equal?(-1))
        s += "\t    Maximum: undefined"
      else
        s += "\t    Maximum: " + RJava.cast_to_string(@maximum)
      end
      s += "    ]\n"
      return (s)
    end
    
    typesig { [Object] }
    # Compare this GeneralSubtree with another
    # 
    # @param other GeneralSubtree to compare to this
    # @returns true if match
    def ==(other)
      if (!(other.is_a?(GeneralSubtree)))
        return false
      end
      other_gs = other
      if ((@name).nil?)
        if (!(other_gs.attr_name).nil?)
          return false
        end
      else
        if (!(((@name) == other_gs.attr_name)))
          return false
        end
      end
      if (!(@minimum).equal?(other_gs.attr_minimum))
        return false
      end
      if (!(@maximum).equal?(other_gs.attr_maximum))
        return false
      end
      return true
    end
    
    typesig { [] }
    # Returns the hash code for this GeneralSubtree.
    # 
    # @return a hash code value.
    def hash_code
      if ((@myhash).equal?(-1))
        @myhash = 17
        if (!(@name).nil?)
          @myhash = 37 * @myhash + @name.hash_code
        end
        if (!(@minimum).equal?(MIN_DEFAULT))
          @myhash = 37 * @myhash + @minimum
        end
        if (!(@maximum).equal?(-1))
          @myhash = 37 * @myhash + @maximum
        end
      end
      return @myhash
    end
    
    typesig { [DerOutputStream] }
    # Encode the GeneralSubtree.
    # 
    # @params out the DerOutputStream to encode this object to.
    def encode(out)
      seq = DerOutputStream.new
      @name.encode(seq)
      if (!(@minimum).equal?(MIN_DEFAULT))
        tmp = DerOutputStream.new
        tmp.put_integer(@minimum)
        seq.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_MIN), tmp)
      end
      if (!(@maximum).equal?(-1))
        tmp = DerOutputStream.new
        tmp.put_integer(@maximum)
        seq.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, false, TAG_MAX), tmp)
      end
      out.write(DerValue.attr_tag_sequence, seq)
    end
    
    private
    alias_method :initialize__general_subtree, :initialize
  end
  
end
