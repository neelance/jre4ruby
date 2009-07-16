require "rjava"

# 
# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5
  module KrbKdcReqImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5::Internal, :Krb5
      include_const ::Sun::Security::Krb5::Internal, :UDPClient
      include_const ::Sun::Security::Krb5::Internal, :TCPClient
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InterruptedIOException
      include_const ::Java::Net, :SocketTimeoutException
      include_const ::Java::Net, :UnknownHostException
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :PrivilegedActionException
    }
  end
  
  class KrbKdcReq 
    include_class_members KrbKdcReqImports
    
    class_module.module_eval {
      # 
      # Default port for a KDC.
      const_set_lazy(:DEFAULT_KDC_PORT) { Krb5::KDC_INET_DEFAULT_PORT }
      const_attr_reader  :DEFAULT_KDC_PORT
      
      # Currently there is no option to specify retries
      # in the kerberos configuration file
      const_set_lazy(:DEFAULT_KDC_RETRY_LIMIT) { Krb5::KDC_RETRY_LIMIT }
      const_attr_reader  :DEFAULT_KDC_RETRY_LIMIT
      
      # milliseconds
      const_set_lazy(:DEBUG) { Krb5::DEBUG }
      const_attr_reader  :DEBUG
      
      
      def udp_pref_limit
        defined?(@@udp_pref_limit) ? @@udp_pref_limit : @@udp_pref_limit= -1
      end
      alias_method :attr_udp_pref_limit, :udp_pref_limit
      
      def udp_pref_limit=(value)
        @@udp_pref_limit = value
      end
      alias_method :attr_udp_pref_limit=, :udp_pref_limit=
      
      when_class_loaded do
        # 
        # Get default timeout.
        timeout = -1
        begin
          cfg = Config.get_instance
          temp = cfg.get_default("kdc_timeout", "libdefaults")
          timeout = parse_positive_int_string(temp)
          temp = (cfg.get_default("udp_preference_limit", "libdefaults")).to_s
          self.attr_udp_pref_limit = parse_positive_int_string(temp)
        rescue Exception => exc
          # ignore any exceptions; use the default time out values
          if (DEBUG)
            System.out.println("Exception in getting kdc_timeout value, " + "using default value " + (exc.get_message).to_s)
          end
        end
        if (timeout > 0)
          const_set :DEFAULT_KDC_TIMEOUT, timeout
        else
          const_set :DEFAULT_KDC_TIMEOUT, 30 * 1000
        end # 30 seconds
      end
    }
    
    attr_accessor :obuf
    alias_method :attr_obuf, :obuf
    undef_method :obuf
    alias_method :attr_obuf=, :obuf=
    undef_method :obuf=
    
    attr_accessor :ibuf
    alias_method :attr_ibuf, :ibuf
    undef_method :ibuf
    alias_method :attr_ibuf=, :ibuf=
    undef_method :ibuf=
    
    typesig { [String] }
    # 
    # Sends the provided data to the KDC of the specified realm.
    # Returns the response from the KDC.
    # Default realm/KDC is used if realm is null.
    # @param realm the realm of the KDC where data is to be sent.
    # @returns the kdc to which the AS request was sent to
    # @exception InterruptedIOException if timeout expires
    # @exception KrbException
    def send(realm)
      use_tcp = (self.attr_udp_pref_limit > 0 && (!(@obuf).nil? && @obuf.attr_length > self.attr_udp_pref_limit))
      return (send(realm, use_tcp))
    end
    
    typesig { [String, ::Java::Boolean] }
    def send(realm, use_tcp)
      if ((@obuf).nil?)
        return nil
      end
      saved_exception = nil
      cfg = Config.get_instance
      if ((realm).nil?)
        realm = (cfg.get_default_realm).to_s
        if ((realm).nil?)
          raise KrbException.new(Krb5::KRB_ERR_GENERIC, "Cannot find default realm")
        end
      end
      # 
      # Get timeout.
      timeout = get_kdc_timeout(realm)
      kdc_list = cfg.get_kdclist(realm)
      if ((kdc_list).nil?)
        raise KrbException.new("Cannot get kdc for realm " + realm)
      end
      temp_kdc = nil # may include the port number also
      st = StringTokenizer.new(kdc_list)
      while (st.has_more_tokens)
        temp_kdc = (st.next_token).to_s
        begin
          send(realm, temp_kdc, use_tcp)
          break
        rescue Exception => e
          saved_exception = e
        end
      end
      if ((@ibuf).nil? && !(saved_exception).nil?)
        if (saved_exception.is_a?(IOException))
          raise saved_exception
        else
          raise saved_exception
        end
      end
      return temp_kdc
    end
    
    typesig { [String, String, ::Java::Boolean] }
    # send the AS Request to the specified KDC
    def send(realm, temp_kdc, use_tcp)
      if ((@obuf).nil?)
        return
      end
      saved_exception = nil
      port = Krb5::KDC_INET_DEFAULT_PORT
      # 
      # Get timeout.
      timeout = get_kdc_timeout(realm)
      # 
      # Get port number for this KDC.
      str_tok = StringTokenizer.new(temp_kdc, ":")
      kdc = str_tok.next_token
      if (str_tok.has_more_tokens)
        port_str = str_tok.next_token
        temp_port = parse_positive_int_string(port_str)
        if (temp_port > 0)
          port = temp_port
        end
      end
      if (DEBUG)
        System.out.println(">>> KrbKdcReq send: kdc=" + kdc + ((use_tcp ? " TCP:" : " UDP:")).to_s + (port).to_s + ", timeout=" + (timeout).to_s + ", number of retries =" + (DEFAULT_KDC_RETRY_LIMIT).to_s + ", #bytes=" + (@obuf.attr_length).to_s)
      end
      kdc_communication = KdcCommunication.new(kdc, port, use_tcp, timeout, @obuf)
      begin
        @ibuf = AccessController.do_privileged(kdc_communication)
        if (DEBUG)
          System.out.println(">>> KrbKdcReq send: #bytes read=" + ((!(@ibuf).nil? ? @ibuf.attr_length : 0)).to_s)
        end
      rescue PrivilegedActionException => e
        wrapped_exception = e.get_exception
        if (wrapped_exception.is_a?(IOException))
          raise wrapped_exception
        else
          raise wrapped_exception
        end
      end
      if (DEBUG)
        System.out.println(">>> KrbKdcReq send: #bytes read=" + ((!(@ibuf).nil? ? @ibuf.attr_length : 0)).to_s)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:KdcCommunication) { Class.new do
        include_class_members KrbKdcReq
        include PrivilegedExceptionAction
        
        attr_accessor :kdc
        alias_method :attr_kdc, :kdc
        undef_method :kdc
        alias_method :attr_kdc=, :kdc=
        undef_method :kdc=
        
        attr_accessor :port
        alias_method :attr_port, :port
        undef_method :port
        alias_method :attr_port=, :port=
        undef_method :port=
        
        attr_accessor :use_tcp
        alias_method :attr_use_tcp, :use_tcp
        undef_method :use_tcp
        alias_method :attr_use_tcp=, :use_tcp=
        undef_method :use_tcp=
        
        attr_accessor :timeout
        alias_method :attr_timeout, :timeout
        undef_method :timeout
        alias_method :attr_timeout=, :timeout=
        undef_method :timeout=
        
        attr_accessor :obuf
        alias_method :attr_obuf, :obuf
        undef_method :obuf
        alias_method :attr_obuf=, :obuf=
        undef_method :obuf=
        
        typesig { [String, ::Java::Int, ::Java::Boolean, ::Java::Int, Array.typed(::Java::Byte)] }
        def initialize(kdc, port, use_tcp, timeout, obuf)
          @kdc = nil
          @port = 0
          @use_tcp = false
          @timeout = 0
          @obuf = nil
          @kdc = kdc
          @port = port
          @use_tcp = use_tcp
          @timeout = timeout
          @obuf = obuf
        end
        
        typesig { [] }
        # The caller only casts IOException and KrbException so don't
        # add any new ones!
        def run
          ibuf = nil
          if (@use_tcp)
            kdc_client = TCPClient.new(@kdc, @port)
            begin
              # 
              # Send the data to the kdc.
              kdc_client.send(@obuf)
              # 
              # And get a response.
              ibuf = kdc_client.receive
            ensure
              kdc_client.close
            end
          else
            # For each KDC we try DEFAULT_KDC_RETRY_LIMIT (3) times to
            # get the response
            i = 1
            while i <= DEFAULT_KDC_RETRY_LIMIT
              kdc_client_ = UDPClient.new(@kdc, @port, @timeout)
              if (DEBUG)
                System.out.println(">>> KDCCommunication: kdc=" + @kdc + ((@use_tcp ? " TCP:" : " UDP:")).to_s + (@port).to_s + ", timeout=" + (@timeout).to_s + ",Attempt =" + (i).to_s + ", #bytes=" + (@obuf.attr_length).to_s)
              end
              begin
                # 
                # Send the data to the kdc.
                kdc_client_.send(@obuf)
                # 
                # And get a response.
                begin
                  ibuf = kdc_client_.receive
                  break
                rescue SocketTimeoutException => se
                  if (DEBUG)
                    System.out.println("SocketTimeOutException with " + "attempt: " + (i).to_s)
                  end
                  if ((i).equal?(DEFAULT_KDC_RETRY_LIMIT))
                    ibuf = nil
                    raise se
                  end
                end
              ensure
                kdc_client_.close
              end
              ((i += 1) - 1)
            end
          end
          return ibuf
        end
        
        private
        alias_method :initialize__kdc_communication, :initialize
      end }
    }
    
    typesig { [String] }
    # 
    # Returns a timeout value for the KDC of the given realm.
    # A KDC-specific timeout, if specified in the config file,
    # overrides the default timeout (which may also be specified
    # in the config file). Default timeout is returned if null
    # is specified for realm.
    # @param realm the realm which kdc's timeout is requested
    # @return KDC timeout
    def get_kdc_timeout(realm)
      timeout = DEFAULT_KDC_TIMEOUT
      if ((realm).nil?)
        return timeout
      end
      temp_timeout = -1
      begin
        temp = Config.get_instance.get_default("kdc_timeout", realm)
        temp_timeout = parse_positive_int_string(temp)
      rescue Exception => exc
      end
      if (temp_timeout > 0)
        timeout = temp_timeout
      end
      return timeout
    end
    
    class_module.module_eval {
      typesig { [String] }
      def parse_positive_int_string(int_string)
        if ((int_string).nil?)
          return -1
        end
        ret = -1
        begin
          ret = JavaInteger.parse_int(int_string)
        rescue Exception => exc
          return -1
        end
        if (ret >= 0)
          return ret
        end
        return -1
      end
    }
    
    typesig { [] }
    def initialize
      @obuf = nil
      @ibuf = nil
    end
    
    private
    alias_method :initialize__krb_kdc_req, :initialize
  end
  
end
