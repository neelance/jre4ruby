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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal
  module KDCOptionsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :Config
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5::Internal::Util, :KerberosFlags
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # Implements the ASN.1 KDCOptions type.
  # 
  # <xmp>
  # KDCOptions   ::= KerberosFlags
  # -- reserved(0),
  # -- forwardable(1),
  # -- forwarded(2),
  # -- proxiable(3),
  # -- proxy(4),
  # -- allow-postdate(5),
  # -- postdated(6),
  # -- unused7(7),
  # -- renewable(8),
  # -- unused9(9),
  # -- unused10(10),
  # -- opt-hardware-auth(11),
  # -- unused12(12),
  # -- unused13(13),
  # -- 15 is reserved for canonicalize
  # -- unused15(15),
  # -- 26 was unused in 1510
  # -- disable-transited-check(26),
  # -- renewable-ok(27),
  # -- enc-tkt-in-skey(28),
  # -- renew(30),
  # -- validate(31)
  # 
  # KerberosFlags   ::= BIT STRING (SIZE (32..MAX))
  # -- minimum number of bits shall be sent,
  # -- but no fewer than 32
  # 
  # </xmp>
  # 
  # <p>
  # This definition reflects the Network Working Group RFC 4120
  # specification available at
  # <a href="http://www.ietf.org/rfc/rfc4120.txt">
  # http://www.ietf.org/rfc/rfc4120.txt</a>.
  # 
  # <p>
  # This class appears as data field in the initial request(KRB_AS_REQ)
  # or subsequent request(KRB_TGS_REQ) to the KDC and indicates the flags
  # that the client wants to set on the tickets.
  # 
  # The optional bits are:
  # <UL>
  # <LI>KDCOptions.RESERVED
  # <LI>KDCOptions.FORWARDABLE
  # <LI>KDCOptions.FORWARDED
  # <LI>KDCOptions.PROXIABLE
  # <LI>KDCOptions.PROXY
  # <LI>KDCOptions.ALLOW_POSTDATE
  # <LI>KDCOptions.POSTDATED
  # <LI>KDCOptions.RENEWABLE
  # <LI>KDCOptions.RENEWABLE_OK
  # <LI>KDCOptions.ENC_TKT_IN_SKEY
  # <LI>KDCOptions.RENEW
  # <LI>KDCOptions.VALIDATE
  # </UL>
  # <p> Various checks must be made before honoring an option. The restrictions
  # on the use of some options are as follows:
  # <ol>
  # <li> FORWARDABLE, FORWARDED, PROXIABLE, RENEWABLE options may be set in
  # subsequent request only if the ticket_granting ticket on which it is based has
  # the same options (FORWARDABLE, FORWARDED, PROXIABLE, RENEWABLE) set.
  # <li> ALLOW_POSTDATE may be set in subsequent request only if the
  # ticket-granting ticket on which it is based also has its MAY_POSTDATE flag set.
  # <li> POSTDATED may be set in subsequent request only if the
  # ticket-granting ticket on which it is based also has its MAY_POSTDATE flag set.
  # <li> RENEWABLE or RENEW may be set in subsequent request only if the
  # ticket-granting ticket on which it is based also has its RENEWABLE flag set.
  # <li> POXY may be set in subsequent request only if the ticket-granting ticket
  # on which it is based also has its PROXIABLE flag set, and the address(es) of
  # the host from which the resulting ticket is to be valid should be included
  # in the addresses field of the request.
  # <li>FORWARDED, PROXY, ENC_TKT_IN_SKEY, RENEW, VALIDATE are used only in
  # subsequent requests.
  # </ol><p>
  class KDCOptions < KDCOptionsImports.const_get :KerberosFlags
    include_class_members KDCOptionsImports
    
    attr_accessor :kdc_opt_proxiable
    alias_method :attr_kdc_opt_proxiable, :kdc_opt_proxiable
    undef_method :kdc_opt_proxiable
    alias_method :attr_kdc_opt_proxiable=, :kdc_opt_proxiable=
    undef_method :kdc_opt_proxiable=
    
    attr_accessor :kdc_opt_renewable_ok
    alias_method :attr_kdc_opt_renewable_ok, :kdc_opt_renewable_ok
    undef_method :kdc_opt_renewable_ok
    alias_method :attr_kdc_opt_renewable_ok=, :kdc_opt_renewable_ok=
    undef_method :kdc_opt_renewable_ok=
    
    attr_accessor :kdc_opt_forwardable
    alias_method :attr_kdc_opt_forwardable, :kdc_opt_forwardable
    undef_method :kdc_opt_forwardable
    alias_method :attr_kdc_opt_forwardable=, :kdc_opt_forwardable=
    undef_method :kdc_opt_forwardable=
    
    class_module.module_eval {
      # KDC Options
      const_set_lazy(:RESERVED) { 0 }
      const_attr_reader  :RESERVED
      
      const_set_lazy(:FORWARDABLE) { 1 }
      const_attr_reader  :FORWARDABLE
      
      const_set_lazy(:FORWARDED) { 2 }
      const_attr_reader  :FORWARDED
      
      const_set_lazy(:PROXIABLE) { 3 }
      const_attr_reader  :PROXIABLE
      
      const_set_lazy(:PROXY) { 4 }
      const_attr_reader  :PROXY
      
      const_set_lazy(:ALLOW_POSTDATE) { 5 }
      const_attr_reader  :ALLOW_POSTDATE
      
      const_set_lazy(:POSTDATED) { 6 }
      const_attr_reader  :POSTDATED
      
      const_set_lazy(:UNUSED7) { 7 }
      const_attr_reader  :UNUSED7
      
      const_set_lazy(:RENEWABLE) { 8 }
      const_attr_reader  :RENEWABLE
      
      const_set_lazy(:UNUSED9) { 9 }
      const_attr_reader  :UNUSED9
      
      const_set_lazy(:UNUSED10) { 10 }
      const_attr_reader  :UNUSED10
      
      const_set_lazy(:UNUSED11) { 11 }
      const_attr_reader  :UNUSED11
      
      const_set_lazy(:RENEWABLE_OK) { 27 }
      const_attr_reader  :RENEWABLE_OK
      
      const_set_lazy(:ENC_TKT_IN_SKEY) { 28 }
      const_attr_reader  :ENC_TKT_IN_SKEY
      
      const_set_lazy(:RENEW) { 30 }
      const_attr_reader  :RENEW
      
      const_set_lazy(:VALIDATE) { 31 }
      const_attr_reader  :VALIDATE
    }
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    typesig { [] }
    def initialize
      @kdc_opt_proxiable = 0
      @kdc_opt_renewable_ok = 0
      @kdc_opt_forwardable = 0
      @debug = false
      super(Krb5::KDC_OPTS_MAX + 1)
      @kdc_opt_proxiable = 0x10000000
      @kdc_opt_renewable_ok = 0x10
      @kdc_opt_forwardable = 0x40000000
      @debug = Krb5::DEBUG
      set_default
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    def initialize(size, data)
      @kdc_opt_proxiable = 0
      @kdc_opt_renewable_ok = 0
      @kdc_opt_forwardable = 0
      @debug = false
      super(size, data)
      @kdc_opt_proxiable = 10000000
      @kdc_opt_renewable_ok = 10
      @kdc_opt_forwardable = 40000000
      @debug = Krb5::DEBUG
      if ((size > data.attr_length * BITS_PER_UNIT) || (size > Krb5::KDC_OPTS_MAX + 1))
        raise Asn1Exception.new(Krb5::BITSTRING_BAD_LENGTH)
      end
    end
    
    typesig { [Array.typed(::Java::Boolean)] }
    # Constructs a KDCOptions from the specified bit settings.
    # 
    # @param data the bits to be set for the KDCOptions.
    # @exception Asn1Exception if an error occurs while decoding an ASN1
    # encoded data.
    def initialize(data)
      @kdc_opt_proxiable = 0
      @kdc_opt_renewable_ok = 0
      @kdc_opt_forwardable = 0
      @debug = false
      super(data)
      @kdc_opt_proxiable = 10000000
      @kdc_opt_renewable_ok = 10
      @kdc_opt_forwardable = 40000000
      @debug = Krb5::DEBUG
      if (data.attr_length > Krb5::KDC_OPTS_MAX + 1)
        raise Asn1Exception.new(Krb5::BITSTRING_BAD_LENGTH)
      end
    end
    
    typesig { [DerValue] }
    def initialize(encoding)
      initialize__kdcoptions(encoding.get_unaligned_bit_string(true).to_boolean_array)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructs a KDCOptions from the passed bit settings.
    # 
    # @param options the bits to be set for the KDCOptions.
    def initialize(options)
      @kdc_opt_proxiable = 0
      @kdc_opt_renewable_ok = 0
      @kdc_opt_forwardable = 0
      @debug = false
      super(options.attr_length * BITS_PER_UNIT, options)
      @kdc_opt_proxiable = 10000000
      @kdc_opt_renewable_ok = 10
      @kdc_opt_forwardable = 40000000
      @debug = Krb5::DEBUG
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a KDCOptions from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @param data the Der input stream value, which contains one or more
      # marshaled value.
      # @param explicitTag tag number.
      # @param optional indicate if this data field is optional
      # @return an instance of KDCOptions.
      # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
      # @exception IOException if an I/O error occurs while reading encoded data.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return KDCOptions.new(sub_der)
        end
      end
    }
    
    typesig { [::Java::Int, ::Java::Boolean] }
    # Sets the value(true/false) for one of the <code>KDCOptions</code>.
    # 
    # @param option an option bit.
    # @param value true if the option is selected, false if the option is not selected.
    # @exception ArrayIndexOutOfBoundsException if array index out of bound occurs.
    # @see sun.security.krb5.internal.Krb5
    def set(option, value)
      super(option, value)
    end
    
    typesig { [::Java::Int] }
    # Gets the value(true/false) for one of the <code>KDCOptions</code>.
    # 
    # @param option an option bit.
    # @return value true if the option is selected, false if the option is not selected.
    # @exception ArrayIndexOutOfBoundsException if array index out of bound occurs.
    # @see sun.security.krb5.internal.Krb5
    def get(option)
      return super(option)
    end
    
    typesig { [] }
    def set_default
      begin
        config = Config.get_instance
        # First see if the IBM hex format is being used.
        # If not, try the Sun's string (boolean) format.
        options = config.get_default_int_value("kdc_default_options", "libdefaults")
        if (((options & RENEWABLE_OK)).equal?(RENEWABLE_OK))
          set(RENEWABLE_OK, true)
        else
          if (config.get_default_boolean_value("renewable", "libdefaults"))
            set(RENEWABLE_OK, true)
          end
        end
        if (((options & PROXIABLE)).equal?(PROXIABLE))
          set(PROXIABLE, true)
        else
          if (config.get_default_boolean_value("proxiable", "libdefaults"))
            set(PROXIABLE, true)
          end
        end
        if (((options & FORWARDABLE)).equal?(FORWARDABLE))
          set(FORWARDABLE, true)
        else
          if (config.get_default_boolean_value("forwardable", "libdefaults"))
            set(FORWARDABLE, true)
          end
        end
      rescue KrbException => e
        if (@debug)
          System.out.println("Exception in getting default values for " + "KDC Options from the configuration ")
          e.print_stack_trace
        end
      end
    end
    
    private
    alias_method :initialize__kdcoptions, :initialize
  end
  
end
