require "rjava"

# Copyright 1995-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Smtp
  module SmtpClientImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Smtp
      include_const ::Java::Util, :StringTokenizer
      include ::Java::Io
      include ::Java::Net
      include_const ::Sun::Net, :TransferProtocolClient
    }
  end
  
  # This class implements the SMTP client.
  # You can send a piece of mail by creating a new SmtpClient, calling
  # the "to" method to add destinations, calling "from" to name the
  # sender, calling startMessage to return a stream to which you write
  # the message (with RFC733 headers) and then you finally close the Smtp
  # Client.
  # 
  # @author      James Gosling
  class SmtpClient < SmtpClientImports.const_get :TransferProtocolClient
    include_class_members SmtpClientImports
    
    attr_accessor :mailhost
    alias_method :attr_mailhost, :mailhost
    undef_method :mailhost
    alias_method :attr_mailhost=, :mailhost=
    undef_method :mailhost=
    
    attr_accessor :message
    alias_method :attr_message, :message
    undef_method :message
    alias_method :attr_message=, :message=
    undef_method :message=
    
    typesig { [] }
    # issue the QUIT command to the SMTP server and close the connection.
    def close_server
      if (server_is_open)
        close_message
        issue_command("QUIT\r\n", 221)
        super
      end
    end
    
    typesig { [String, ::Java::Int] }
    def issue_command(cmd, expect)
      send_server(cmd)
      reply = 0
      while (!((reply = read_server_response)).equal?(expect))
        if (!(reply).equal?(220))
          raise SmtpProtocolException.new(get_response_string)
        end
      end
    end
    
    typesig { [String] }
    def to_canonical(s)
      if (s.starts_with("<"))
        issue_command("rcpt to: " + s + "\r\n", 250)
      else
        issue_command("rcpt to: <" + s + ">\r\n", 250)
      end
    end
    
    typesig { [String] }
    def to(s)
      st = 0
      limit = s.length
      pos = 0
      lastnonsp = 0
      parendepth = 0
      ignore = false
      while (pos < limit)
        c = s.char_at(pos)
        if (parendepth > 0)
          if ((c).equal?(Character.new(?(.ord)))
            parendepth += 1
          else
            if ((c).equal?(Character.new(?).ord)))
              parendepth -= 1
            end
          end
          if ((parendepth).equal?(0))
            if (lastnonsp > st)
              ignore = true
            else
              st = pos + 1
            end
          end
        else
          if ((c).equal?(Character.new(?(.ord)))
            parendepth += 1
          else
            if ((c).equal?(Character.new(?<.ord)))
              st = lastnonsp = pos + 1
            else
              if ((c).equal?(Character.new(?>.ord)))
                ignore = true
              else
                if ((c).equal?(Character.new(?,.ord)))
                  if (lastnonsp > st)
                    to_canonical(s.substring(st, lastnonsp))
                  end
                  st = pos + 1
                  ignore = false
                else
                  if (c > Character.new(?\s.ord) && !ignore)
                    lastnonsp = pos + 1
                  else
                    if ((st).equal?(pos))
                      st += 1
                    end
                  end
                end
              end
            end
          end
        end
        pos += 1
      end
      if (lastnonsp > st)
        to_canonical(s.substring(st, lastnonsp))
      end
    end
    
    typesig { [String] }
    def from(s)
      if (s.starts_with("<"))
        issue_command("mail from: " + s + "\r\n", 250)
      else
        issue_command("mail from: <" + s + ">\r\n", 250)
      end
    end
    
    typesig { [String] }
    # open a SMTP connection to host <i>host</i>.
    def open_server(host)
      @mailhost = host
      open_server(@mailhost, 25)
      issue_command("helo " + RJava.cast_to_string(InetAddress.get_local_host.get_host_name) + "\r\n", 250)
    end
    
    typesig { [] }
    def start_message
      issue_command("data\r\n", 354)
      begin
        @message = SmtpPrintStream.new(self.attr_server_output, self)
      rescue UnsupportedEncodingException => e
        raise InternalError.new(RJava.cast_to_string(self.attr_encoding) + " encoding not found")
      end
      return @message
    end
    
    typesig { [] }
    def close_message
      if (!(@message).nil?)
        @message.close
      end
    end
    
    typesig { [String] }
    # New SMTP client connected to host <i>host</i>.
    def initialize(host)
      @mailhost = nil
      @message = nil
      super()
      if (!(host).nil?)
        begin
          open_server(host)
          @mailhost = host
          return
        rescue JavaException => e
        end
      end
      begin
        s = nil
        @mailhost = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("mail.host")))
        if (!(@mailhost).nil?)
          open_server(@mailhost)
          return
        end
      rescue JavaException => e
      end
      begin
        @mailhost = "localhost"
        open_server(@mailhost)
      rescue JavaException => e
        @mailhost = "mailhost"
        open_server(@mailhost)
      end
    end
    
    typesig { [] }
    # Create an uninitialized SMTP client.
    def initialize
      initialize__smtp_client(nil)
    end
    
    typesig { [::Java::Int] }
    def initialize(to)
      @mailhost = nil
      @message = nil
      super()
      set_connect_timeout(to)
      begin
        s = nil
        @mailhost = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("mail.host")))
        if (!(@mailhost).nil?)
          open_server(@mailhost)
          return
        end
      rescue JavaException => e
      end
      begin
        @mailhost = "localhost"
        open_server(@mailhost)
      rescue JavaException => e
        @mailhost = "mailhost"
        open_server(@mailhost)
      end
    end
    
    typesig { [] }
    def get_mail_host
      return @mailhost
    end
    
    typesig { [] }
    def get_encoding
      return self.attr_encoding
    end
    
    private
    alias_method :initialize__smtp_client, :initialize
  end
  
  class SmtpPrintStream < Java::Io::PrintStream
    include_class_members SmtpClientImports
    
    attr_accessor :target
    alias_method :attr_target, :target
    undef_method :target
    alias_method :attr_target=, :target=
    undef_method :target=
    
    attr_accessor :lastc
    alias_method :attr_lastc, :lastc
    undef_method :lastc
    alias_method :attr_lastc=, :lastc=
    undef_method :lastc=
    
    typesig { [OutputStream, SmtpClient] }
    def initialize(fos, cl)
      @target = nil
      @lastc = 0
      super(fos, false, cl.get_encoding)
      @lastc = Character.new(?\n.ord)
      @target = cl
    end
    
    typesig { [] }
    def close
      if ((@target).nil?)
        return
      end
      if (!(@lastc).equal?(Character.new(?\n.ord)))
        write(Character.new(?\n.ord))
      end
      begin
        @target.issue_command(".\r\n", 250)
        @target.attr_message = nil
        self.attr_out = nil
        @target = nil
      rescue IOException => e
      end
    end
    
    typesig { [::Java::Int] }
    def write(b)
      begin
        # quote a dot at the beginning of a line
        if ((@lastc).equal?(Character.new(?\n.ord)) && (b).equal?(Character.new(?..ord)))
          self.attr_out.write(Character.new(?..ord))
        end
        # translate NL to CRLF
        if ((b).equal?(Character.new(?\n.ord)) && !(@lastc).equal?(Character.new(?\r.ord)))
          self.attr_out.write(Character.new(?\r.ord))
        end
        self.attr_out.write(b)
        @lastc = b
      rescue IOException => e
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    def write(b, off, len)
      begin
        lc = @lastc
        while ((len -= 1) >= 0)
          c = b[((off += 1) - 1)]
          # quote a dot at the beginning of a line
          if ((lc).equal?(Character.new(?\n.ord)) && (c).equal?(Character.new(?..ord)))
            self.attr_out.write(Character.new(?..ord))
          end
          # translate NL to CRLF
          if ((c).equal?(Character.new(?\n.ord)) && !(lc).equal?(Character.new(?\r.ord)))
            self.attr_out.write(Character.new(?\r.ord))
          end
          self.attr_out.write(c)
          lc = c
        end
        @lastc = lc
      rescue IOException => e
      end
    end
    
    typesig { [String] }
    def print(s)
      len = s.length
      i = 0
      while i < len
        write(s.char_at(i))
        i += 1
      end
    end
    
    private
    alias_method :initialize__smtp_print_stream, :initialize
  end
  
end
