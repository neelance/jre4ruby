require "rjava"

# Copyright 1996-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Mailto
  module MailToURLConnectionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Mailto
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :InetAddress
      include_const ::Java::Net, :SocketPermission
      include ::Java::Io
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Security, :Permission
      include ::Sun::Net::Www
      include_const ::Sun::Net::Smtp, :SmtpClient
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # Handle mailto URLs. To send mail using a mailto URLConnection,
  # call <code>getOutputStream</code>, write the message to the output
  # stream, and close it.
  class MailToURLConnection < MailToURLConnectionImports.const_get :URLConnection
    include_class_members MailToURLConnectionImports
    
    attr_accessor :is
    alias_method :attr_is, :is
    undef_method :is
    alias_method :attr_is=, :is=
    undef_method :is=
    
    attr_accessor :os
    alias_method :attr_os, :os
    undef_method :os
    alias_method :attr_os=, :os=
    undef_method :os=
    
    attr_accessor :client
    alias_method :attr_client, :client
    undef_method :client
    alias_method :attr_client=, :client=
    undef_method :client=
    
    attr_accessor :permission
    alias_method :attr_permission, :permission
    undef_method :permission
    alias_method :attr_permission=, :permission=
    undef_method :permission=
    
    attr_accessor :connect_timeout
    alias_method :attr_connect_timeout, :connect_timeout
    undef_method :connect_timeout
    alias_method :attr_connect_timeout=, :connect_timeout=
    undef_method :connect_timeout=
    
    attr_accessor :read_timeout
    alias_method :attr_read_timeout, :read_timeout
    undef_method :read_timeout
    alias_method :attr_read_timeout=, :read_timeout=
    undef_method :read_timeout=
    
    typesig { [URL] }
    def initialize(u)
      @is = nil
      @os = nil
      @client = nil
      @permission = nil
      @connect_timeout = 0
      @read_timeout = 0
      super(u)
      @is = nil
      @os = nil
      @connect_timeout = -1
      @read_timeout = -1
      props = MessageHeader.new
      props.add("content-type", "text/html")
      set_properties(props)
    end
    
    typesig { [] }
    # Get the user's full email address - stolen from
    # HotJavaApplet.getMailAddress().
    def get_from_address
      str = System.get_property("user.fromaddr")
      if ((str).nil?)
        str = RJava.cast_to_string(System.get_property("user.name"))
        if (!(str).nil?)
          host = System.get_property("mail.host")
          if ((host).nil?)
            begin
              host = RJava.cast_to_string(InetAddress.get_local_host.get_host_name)
            rescue Java::Net::UnknownHostException => e
            end
          end
          str += "@" + host
        else
          str = ""
        end
      end
      return str
    end
    
    typesig { [] }
    def connect
      System.err.println("connect. Timeout = " + RJava.cast_to_string(@connect_timeout))
      @client = SmtpClient.new(@connect_timeout)
      @client.set_read_timeout(@read_timeout)
    end
    
    typesig { [] }
    def get_output_stream
      synchronized(self) do
        if (!(@os).nil?)
          return @os
        else
          if (!(@is).nil?)
            raise IOException.new("Cannot write output after reading input.")
          end
        end
        connect
        to = ParseUtil.decode(self.attr_url.get_path)
        @client.from(get_from_address)
        @client.to(to)
        @os = @client.start_message
        return @os
      end
    end
    
    typesig { [] }
    def get_permission
      if ((@permission).nil?)
        connect
        host = RJava.cast_to_string(@client.get_mail_host) + ":" + RJava.cast_to_string(25)
        @permission = SocketPermission.new(host, "connect")
      end
      return @permission
    end
    
    typesig { [::Java::Int] }
    def set_connect_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeouts can't be negative")
      end
      @connect_timeout = timeout
    end
    
    typesig { [] }
    def get_connect_timeout
      return (@connect_timeout < 0 ? 0 : @connect_timeout)
    end
    
    typesig { [::Java::Int] }
    def set_read_timeout(timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeouts can't be negative")
      end
      @read_timeout = timeout
    end
    
    typesig { [] }
    def get_read_timeout
      return @read_timeout < 0 ? 0 : @read_timeout
    end
    
    private
    alias_method :initialize__mail_to_urlconnection, :initialize
  end
  
end
