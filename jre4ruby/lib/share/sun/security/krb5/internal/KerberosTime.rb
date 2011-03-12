require "rjava"

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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal
  module KerberosTimeImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Java::Util, :TimeZone
      include ::Sun::Security::Util
      include_const ::Sun::Security::Krb5, :Config
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Util, :GregorianCalendar
      include_const ::Java::Util, :Calendar
      include_const ::Java::Io, :IOException
    }
  end
  
  # Implements the ASN.1 KerberosTime type.
  # 
  # <xmp>
  # KerberosTime    ::= GeneralizedTime -- with no fractional seconds
  # </xmp>
  # 
  # The timestamps used in Kerberos are encoded as GeneralizedTimes. A
  # KerberosTime value shall not include any fractional portions of the
  # seconds.  As required by the DER, it further shall not include any
  # separators, and it shall specify the UTC time zone (Z).
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  class KerberosTime 
    include_class_members KerberosTimeImports
    include Cloneable
    
    attr_accessor :kerberos_time
    alias_method :attr_kerberos_time, :kerberos_time
    undef_method :kerberos_time
    alias_method :attr_kerberos_time=, :kerberos_time=
    undef_method :kerberos_time=
    
    class_module.module_eval {
      # milliseconds since epoch, a Date.getTime() value
      
      def sync_time
        defined?(@@sync_time) ? @@sync_time : @@sync_time= 0
      end
      alias_method :attr_sync_time, :sync_time
      
      def sync_time=(value)
        @@sync_time = value
      end
      alias_method :attr_sync_time=, :sync_time=
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      const_set_lazy(:NOW) { true }
      const_attr_reader  :NOW
      
      const_set_lazy(:UNADJUSTED_NOW) { false }
      const_attr_reader  :UNADJUSTED_NOW
    }
    
    typesig { [] }
    # defaults to zero instead of now; use setNow() for current time
    def initialize
      @kerberos_time = 0
      @kerberos_time = 0
    end
    
    typesig { [::Java::Long] }
    def initialize(time)
      @kerberos_time = 0
      @kerberos_time = time
    end
    
    typesig { [] }
    def clone
      return KerberosTime.new(@kerberos_time)
    end
    
    typesig { [String] }
    # This constructor is used in the native code
    # src/windows/native/sun/security/krb5/NativeCreds.c
    def initialize(time)
      @kerberos_time = 0
      @kerberos_time = to_kerberos_time(time)
    end
    
    typesig { [DerValue] }
    # Constructs a KerberosTime object.
    # @param encoding a DER-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def initialize(encoding)
      @kerberos_time = 0
      calendar = GregorianCalendar.new
      temp = encoding.get_generalized_time
      @kerberos_time = temp.get_time
    end
    
    class_module.module_eval {
      typesig { [String] }
      def to_kerberos_time(time)
        # this method only used by KerberosTime class.
        # ASN.1 GeneralizedTime format:
        # "19700101000000Z"
        #  |   | | | | | |
        #  0   4 6 8 | | |
        #           10 | |
        #                         12 |
        #                           14
        if (!(time.length).equal?(15))
          raise Asn1Exception.new(Krb5::ASN1_BAD_TIMEFORMAT)
        end
        if (!(time.char_at(14)).equal?(Character.new(?Z.ord)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_TIMEFORMAT)
        end
        year = JavaInteger.parse_int(time.substring(0, 4))
        calendar = Calendar.get_instance(TimeZone.get_time_zone("UTC"))
        calendar.clear # so that millisecond is zero
        calendar.set(year, JavaInteger.parse_int(time.substring(4, 6)) - 1, JavaInteger.parse_int(time.substring(6, 8)), JavaInteger.parse_int(time.substring(8, 10)), JavaInteger.parse_int(time.substring(10, 12)), JavaInteger.parse_int(time.substring(12, 14)))
        # The Date constructor assumes the setting are local relative
        # and converts the time to UTC before storing it.  Since we
        # want the internal representation to correspond to local
        # and not UTC time we subtract the UTC time offset.
        return (calendar.get_time.get_time)
      end
      
      typesig { [String, ::Java::Int] }
      # should be moved to sun.security.krb5.util class
      def zero_pad(s, length_)
        temp = StringBuffer.new(s)
        while (temp.length < length_)
          temp.insert(0, Character.new(?0.ord))
        end
        return temp.to_s
      end
    }
    
    typesig { [JavaDate] }
    def initialize(time)
      @kerberos_time = 0
      @kerberos_time = time.get_time # (time.getTimezoneOffset() * 60000L);
    end
    
    typesig { [::Java::Boolean] }
    def initialize(init_to_now)
      @kerberos_time = 0
      if (init_to_now)
        temp = JavaDate.new
        set_time(temp)
      else
        @kerberos_time = 0
      end
    end
    
    typesig { [] }
    # Returns a string representation of KerberosTime object.
    # @return a string representation of this object.
    def to_generalized_time_string
      calendar = Calendar.get_instance(TimeZone.get_time_zone("UTC"))
      calendar.clear
      calendar.set_time_in_millis(@kerberos_time)
      return zero_pad(JavaInteger.to_s(calendar.get(Calendar::YEAR)), 4) + zero_pad(JavaInteger.to_s(calendar.get(Calendar::MONTH) + 1), 2) + zero_pad(JavaInteger.to_s(calendar.get(Calendar::DAY_OF_MONTH)), 2) + zero_pad(JavaInteger.to_s(calendar.get(Calendar::HOUR_OF_DAY)), 2) + zero_pad(JavaInteger.to_s(calendar.get(Calendar::MINUTE)), 2) + zero_pad(JavaInteger.to_s(calendar.get(Calendar::SECOND)), 2) + Character.new(?Z.ord)
    end
    
    typesig { [] }
    # Encodes this object to a byte array.
    # @return a byte array of encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      out = DerOutputStream.new
      out.put_generalized_time(self.to_date)
      return out.to_byte_array
    end
    
    typesig { [] }
    def get_time
      return @kerberos_time
    end
    
    typesig { [JavaDate] }
    def set_time(time)
      @kerberos_time = time.get_time # (time.getTimezoneOffset() * 60000L);
    end
    
    typesig { [::Java::Long] }
    def set_time(time)
      @kerberos_time = time
    end
    
    typesig { [] }
    def to_date
      temp = JavaDate.new(@kerberos_time)
      temp.set_time(temp.get_time)
      return temp
    end
    
    typesig { [] }
    def set_now
      temp = JavaDate.new
      set_time(temp)
    end
    
    typesig { [] }
    def get_micro_seconds
      temp_long = Long.new((@kerberos_time % 1000) * 1000)
      return temp_long.int_value
    end
    
    typesig { [::Java::Int] }
    def set_micro_seconds(usec)
      temp_int = usec
      temp_long = temp_int.long_value / 1000
      @kerberos_time = @kerberos_time - (@kerberos_time % 1000) + temp_long
    end
    
    typesig { [JavaInteger] }
    def set_micro_seconds(usec)
      if (!(usec).nil?)
        temp_long = usec.long_value / 1000
        @kerberos_time = @kerberos_time - (@kerberos_time % 1000) + temp_long
      end
    end
    
    typesig { [::Java::Int] }
    def in_clock_skew(clock_skew)
      now = KerberosTime.new(KerberosTime::NOW)
      if (Java::Lang::Math.abs(@kerberos_time - now.attr_kerberos_time) > clock_skew * 1000)
        return false
      end
      return true
    end
    
    typesig { [] }
    def in_clock_skew
      return in_clock_skew(get_default_skew)
    end
    
    typesig { [::Java::Int, KerberosTime] }
    def in_clock_skew(clock_skew, now)
      if (Java::Lang::Math.abs(@kerberos_time - now.attr_kerberos_time) > clock_skew * 1000)
        return false
      end
      return true
    end
    
    typesig { [KerberosTime] }
    def in_clock_skew(time)
      return in_clock_skew(get_default_skew, time)
    end
    
    typesig { [KerberosTime, ::Java::Int] }
    def greater_than_wrtclock_skew(time, clock_skew)
      if ((@kerberos_time - time.attr_kerberos_time) > clock_skew * 1000)
        return true
      end
      return false
    end
    
    typesig { [KerberosTime] }
    def greater_than_wrtclock_skew(time)
      return greater_than_wrtclock_skew(time, get_default_skew)
    end
    
    typesig { [KerberosTime] }
    def greater_than(time)
      return @kerberos_time > time.attr_kerberos_time
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(KerberosTime)))
        return false
      end
      return (@kerberos_time).equal?((obj).attr_kerberos_time)
    end
    
    typesig { [] }
    def hash_code
      return 37 * 17 + ((@kerberos_time ^ (@kerberos_time >> 32))).to_int
    end
    
    typesig { [] }
    def is_zero
      return (@kerberos_time).equal?(0)
    end
    
    typesig { [] }
    def get_seconds
      temp_long = Long.new(@kerberos_time / 1000)
      return temp_long.int_value
    end
    
    typesig { [::Java::Int] }
    def set_seconds(sec)
      temp_int = sec
      @kerberos_time = temp_int.long_value * 1000
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a kerberostime from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception on error.
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicates if this data field is optional
      # @return an instance of KerberosTime.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return KerberosTime.new(sub_der)
        end
      end
      
      typesig { [] }
      def get_default_skew
        tdiff = Krb5::DEFAULT_ALLOWABLE_CLOCKSKEW
        begin
          c = Config.get_instance
          if (((tdiff = c.get_default_int_value("clockskew", "libdefaults"))).equal?(JavaInteger::MIN_VALUE))
            # value is not defined
            tdiff = Krb5::DEFAULT_ALLOWABLE_CLOCKSKEW
          end
        rescue KrbException => e
          if (self.attr_debug)
            System.out.println("Exception in getting clockskew from " + "Configuration " + "using default value " + RJava.cast_to_string(e.get_message))
          end
        end
        return tdiff
      end
    }
    
    typesig { [] }
    def to_s
      return to_generalized_time_string
    end
    
    private
    alias_method :initialize__kerberos_time, :initialize
  end
  
end
