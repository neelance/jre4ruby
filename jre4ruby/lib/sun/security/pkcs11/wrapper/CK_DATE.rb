require "rjava"

# 
# reserved comment block
# DO NOT REMOVE OR ALTER!
# 
# Copyright  (c) 2002 Graz University of Technology. All rights reserved.
# 
# Redistribution and use in  source and binary forms, with or without
# modification, are permitted  provided that the following conditions are met:
# 
# 1. Redistributions of  source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in  binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# 3. The end-user documentation included with the redistribution, if any, must
# include the following acknowledgment:
# 
# "This product includes software developed by IAIK of Graz University of
# Technology."
# 
# Alternately, this acknowledgment may appear in the software itself, if
# and wherever such third-party acknowledgments normally appear.
# 
# 4. The names "Graz University of Technology" and "IAIK of Graz University of
# Technology" must not be used to endorse or promote products derived from
# this software without prior written permission.
# 
# 5. Products derived from this software may not be called
# "IAIK PKCS Wrapper", nor may "IAIK" appear in their name, without prior
# written permission of Graz University of Technology.
# 
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE LICENSOR BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY  OF SUCH DAMAGE.
module Sun::Security::Pkcs11::Wrapper
  module CK_DATEImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # class .<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_DATE {&nbsp;&nbsp;
  # CK_CHAR year[4];&nbsp;&nbsp;
  # CK_CHAR month[2];&nbsp;&nbsp;
  # CK_CHAR day[2];&nbsp;&nbsp;
  # } CK_DATE;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_DATE 
    include_class_members CK_DATEImports
    include Cloneable
    
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_CHAR year[4];   - the year ("1900" - "9999")
    # </PRE>
    attr_accessor :year
    alias_method :attr_year, :year
    undef_method :year
    alias_method :attr_year=, :year=
    undef_method :year=
    
    # the year ("1900" - "9999")
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_CHAR month[2];  - the month ("01" - "12")
    # </PRE>
    attr_accessor :month
    alias_method :attr_month, :month
    undef_method :month
    alias_method :attr_month=, :month=
    undef_method :month=
    
    # the month ("01" - "12")
    # 
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_CHAR day[2];    - the day ("01" - "31")
    # </PRE>
    attr_accessor :day
    alias_method :attr_day, :day
    undef_method :day
    alias_method :attr_day=, :day=
    undef_method :day=
    
    typesig { [Array.typed(::Java::Char), Array.typed(::Java::Char), Array.typed(::Java::Char)] }
    # the day ("01" - "31")
    def initialize(year, month, day)
      @year = nil
      @month = nil
      @day = nil
      @year = year
      @month = month
      @day = day
    end
    
    typesig { [] }
    # 
    # Create a (deep) clone of this object.
    # 
    # @return A clone of this object.
    def clone
      copy = nil
      begin
        copy = super
      rescue CloneNotSupportedException => cnse
        # re-throw as RuntimeException
        raise (RuntimeException.new("Clone error").init_cause(cnse))
      end
      copy.attr_year = @year.clone
      copy.attr_month = @month.clone
      copy.attr_day = @day.clone
      return copy
    end
    
    typesig { [] }
    # 
    # Returns the string representation of CK_DATE.
    # 
    # @return the string representation of CK_DATE
    def to_s
      buffer = StringBuffer.new
      buffer.append(String.new(@day))
      buffer.append(Character.new(?..ord))
      buffer.append(String.new(@month))
      buffer.append(Character.new(?..ord))
      buffer.append(String.new(@year))
      buffer.append(" (DD.MM.YYYY)")
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_date, :initialize
  end
  
end
