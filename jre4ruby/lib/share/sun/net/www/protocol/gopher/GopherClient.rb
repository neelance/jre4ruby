require "rjava"

# Copyright 1996-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Gopher
  module GopherClientImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Gopher
      include ::Java::Io
      include ::Java::Util
      include ::Java::Net
      include ::Sun::Net::Www
      include_const ::Sun::Net, :NetworkClient
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLStreamHandler
      include_const ::Sun::Security::Action, :GetBooleanAction
    }
  end
  
  # Class to maintain the state of a gopher fetch and handle the protocol
  class GopherClient < GopherClientImports.const_get :NetworkClient
    include_class_members GopherClientImports
    overload_protected {
      include Runnable
    }
    
    class_module.module_eval {
      # The following three data members are left in for binary
      # backwards-compatibility.  Unfortunately, HotJava sets them directly
      # when it wants to change the settings.  The new design has us not
      # cache these, so this is unnecessary, but eliminating the data members
      # would break HJB 1.1 under JDK 1.2.
      # 
      # These data members are not used, and their values are meaningless.
      # REMIND:  Take them out for JDK 2.0!
      # @deprecated
      
      def use_gopher_proxy
        defined?(@@use_gopher_proxy) ? @@use_gopher_proxy : @@use_gopher_proxy= false
      end
      alias_method :attr_use_gopher_proxy, :use_gopher_proxy
      
      def use_gopher_proxy=(value)
        @@use_gopher_proxy = value
      end
      alias_method :attr_use_gopher_proxy=, :use_gopher_proxy=
      
      # @deprecated
      
      def gopher_proxy_host
        defined?(@@gopher_proxy_host) ? @@gopher_proxy_host : @@gopher_proxy_host= nil
      end
      alias_method :attr_gopher_proxy_host, :gopher_proxy_host
      
      def gopher_proxy_host=(value)
        @@gopher_proxy_host = value
      end
      alias_method :attr_gopher_proxy_host=, :gopher_proxy_host=
      
      # @deprecated
      
      def gopher_proxy_port
        defined?(@@gopher_proxy_port) ? @@gopher_proxy_port : @@gopher_proxy_port= 0
      end
      alias_method :attr_gopher_proxy_port, :gopher_proxy_port
      
      def gopher_proxy_port=(value)
        @@gopher_proxy_port = value
      end
      alias_method :attr_gopher_proxy_port=, :gopher_proxy_port=
      
      when_class_loaded do
        self.attr_use_gopher_proxy = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("gopherProxySet")).boolean_value
        self.attr_gopher_proxy_host = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("gopherProxyHost")))
        self.attr_gopher_proxy_port = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new("gopherProxyPort", 80)).int_value
      end
    }
    
    attr_accessor :os
    alias_method :attr_os, :os
    undef_method :os
    alias_method :attr_os=, :os=
    undef_method :os=
    
    attr_accessor :u
    alias_method :attr_u, :u
    undef_method :u
    alias_method :attr_u=, :u=
    undef_method :u=
    
    attr_accessor :gtype
    alias_method :attr_gtype, :gtype
    undef_method :gtype
    alias_method :attr_gtype=, :gtype=
    undef_method :gtype=
    
    attr_accessor :gkey
    alias_method :attr_gkey, :gkey
    undef_method :gkey
    alias_method :attr_gkey=, :gkey=
    undef_method :gkey=
    
    attr_accessor :connection
    alias_method :attr_connection, :connection
    undef_method :connection
    alias_method :attr_connection=, :connection=
    undef_method :connection=
    
    typesig { [Sun::Net::Www::URLConnection] }
    def initialize(connection)
      @os = nil
      @u = nil
      @gtype = 0
      @gkey = nil
      @connection = nil
      super()
      @connection = connection
    end
    
    class_module.module_eval {
      typesig { [] }
      # @return true if gopher connections should go through a proxy, according
      #          to system properties.
      def get_use_gopher_proxy
        return Java::Security::AccessController.do_privileged(GetBooleanAction.new("gopherProxySet")).boolean_value
      end
      
      typesig { [] }
      # @return the proxy host to use, or null if nothing is set.
      def get_gopher_proxy_host
        host = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("gopherProxyHost"))
        if (("" == host))
          host = RJava.cast_to_string(nil)
        end
        return host
      end
      
      typesig { [] }
      # @return the proxy port to use.  Will default reasonably.
      def get_gopher_proxy_port
        return Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new("gopherProxyPort", 80)).int_value
      end
    }
    
    typesig { [URL] }
    # Given a url, setup to fetch the gopher document it refers to
    def open_stream(u)
      @u = u
      @os = @os
      i = 0
      s = u.get_file
      limit = s.length
      c = Character.new(?1.ord)
      while (i < limit && ((c = s.char_at(i))).equal?(Character.new(?/.ord)))
        i += 1
      end
      @gtype = (c).equal?(Character.new(?/.ord)) ? Character.new(?1.ord) : c
      if (i < limit)
        i += 1
      end
      @gkey = RJava.cast_to_string(s.substring(i))
      open_server(u.get_host, u.get_port <= 0 ? 70 : u.get_port)
      msgh = MessageHeader.new
      case (@gtype)
      when Character.new(?0.ord), Character.new(?7.ord)
        msgh.add("content-type", "text/plain")
      when Character.new(?1.ord)
        msgh.add("content-type", "text/html")
      when Character.new(?g.ord), Character.new(?I.ord)
        msgh.add("content-type", "image/gif")
      else
        msgh.add("content-type", "content/unknown")
      end
      if (!(@gtype).equal?(Character.new(?7.ord)))
        self.attr_server_output.print(RJava.cast_to_string(decode_percent(@gkey)) + "\r\n")
        self.attr_server_output.flush
      else
        if ((i = @gkey.index_of(Character.new(??.ord))) >= 0)
          self.attr_server_output.print(decode_percent(RJava.cast_to_string(@gkey.substring(0, i)) + "\t" + RJava.cast_to_string(@gkey.substring(i + 1)) + "\r\n"))
          self.attr_server_output.flush
          msgh.add("content-type", "text/html")
        else
          msgh.add("content-type", "text/html")
        end
      end
      @connection.set_properties(msgh)
      if ((msgh.find_value("content-type")).equal?("text/html"))
        @os = PipedOutputStream.new
        ret = PipedInputStream.new
        ret.connect(@os)
        JavaThread.new(self).start
        return ret
      end
      return GopherInputStream.new(self, self.attr_server_input)
    end
    
    typesig { [String] }
    # Translate all the instances of %NN into the character they represent
    def decode_percent(s)
      if ((s).nil? || s.index_of(Character.new(?%.ord)) < 0)
        return s
      end
      limit = s.length
      d = CharArray.new(limit)
      dp = 0
      sp = 0
      while sp < limit
        c = s.char_at(sp)
        if ((c).equal?(Character.new(?%.ord)) && sp + 2 < limit)
          s1 = s.char_at(sp + 1)
          s2 = s.char_at(sp + 2)
          if (Character.new(?0.ord) <= s1 && s1 <= Character.new(?9.ord))
            s1 = s1 - Character.new(?0.ord)
          else
            if (Character.new(?a.ord) <= s1 && s1 <= Character.new(?f.ord))
              s1 = s1 - Character.new(?a.ord) + 10
            else
              if (Character.new(?A.ord) <= s1 && s1 <= Character.new(?F.ord))
                s1 = s1 - Character.new(?A.ord) + 10
              else
                s1 = -1
              end
            end
          end
          if (Character.new(?0.ord) <= s2 && s2 <= Character.new(?9.ord))
            s2 = s2 - Character.new(?0.ord)
          else
            if (Character.new(?a.ord) <= s2 && s2 <= Character.new(?f.ord))
              s2 = s2 - Character.new(?a.ord) + 10
            else
              if (Character.new(?A.ord) <= s2 && s2 <= Character.new(?F.ord))
                s2 = s2 - Character.new(?A.ord) + 10
              else
                s2 = -1
              end
            end
          end
          if (s1 >= 0 && s2 >= 0)
            c = (s1 << 4) | s2
            sp += 2
          end
        end
        d[((dp += 1) - 1)] = RJava.cast_to_char(c)
        sp += 1
      end
      return String.new(d, 0, dp)
    end
    
    typesig { [String] }
    # Turn special characters into the %NN form
    def encode_percent(s)
      if ((s).nil?)
        return s
      end
      limit = s.length
      d = nil
      dp = 0
      sp = 0
      while sp < limit
        c = s.char_at(sp)
        if (c <= Character.new(?\s.ord) || (c).equal?(Character.new(?".ord)) || (c).equal?(Character.new(?%.ord)))
          if ((d).nil?)
            d = s.to_char_array
          end
          if (dp + 3 >= d.attr_length)
            nd = CharArray.new(dp + 10)
            System.arraycopy(d, 0, nd, 0, dp)
            d = nd
          end
          d[dp] = Character.new(?%.ord)
          dig = (c >> 4) & 0xf
          d[dp + 1] = RJava.cast_to_char((dig < 10 ? Character.new(?0.ord) + dig : Character.new(?A.ord) - 10 + dig))
          dig = c & 0xf
          d[dp + 2] = RJava.cast_to_char((dig < 10 ? Character.new(?0.ord) + dig : Character.new(?A.ord) - 10 + dig))
          dp += 3
        else
          if (!(d).nil?)
            if (dp >= d.attr_length)
              nd = CharArray.new(dp + 10)
              System.arraycopy(d, 0, nd, 0, dp)
              d = nd
            end
            d[dp] = RJava.cast_to_char(c)
          end
          dp += 1
        end
        sp += 1
      end
      return (d).nil? ? s : String.new(d, 0, dp)
    end
    
    typesig { [] }
    # This method is run as a seperate thread when an incoming gopher
    # document requires translation to html
    def run
      qpos = -1
      begin
        if ((@gtype).equal?(Character.new(?7.ord)) && (qpos = @gkey.index_of(Character.new(??.ord))) < 0)
          ps = PrintStream.new(@os, false, self.attr_encoding)
          ps.print("<html><head><title>Searchable Gopher Index</title></head>\n<body><h1>Searchable Gopher Index</h1><isindex>\n</body></html>\n")
        else
          if (!(@gtype).equal?(Character.new(?1.ord)) && !(@gtype).equal?(Character.new(?7.ord)))
            buf = Array.typed(::Java::Byte).new(2048) { 0 }
            begin
              n = 0
              while ((n = self.attr_server_input.read(buf)) >= 0)
                @os.write(buf, 0, n)
              end
            rescue JavaException => e
            end
          else
            ps = PrintStream.new(@os, false, self.attr_encoding)
            title = nil
            if ((@gtype).equal?(Character.new(?7.ord)))
              title = "Results of searching for \"" + RJava.cast_to_string(@gkey.substring(qpos + 1)) + "\" on " + RJava.cast_to_string(@u.get_host)
            else
              title = "Gopher directory " + @gkey + " from " + RJava.cast_to_string(@u.get_host)
            end
            ps.print("<html><head><title>")
            ps.print(title)
            ps.print("</title></head>\n<body>\n<H1>")
            ps.print(title)
            ps.print("</h1><dl compact>\n")
            ds = DataInputStream.new(self.attr_server_input)
            s = nil
            while (!((s = RJava.cast_to_string(ds.read_line))).nil?)
              len = s.length
              while (len > 0 && s.char_at(len - 1) <= Character.new(?\s.ord))
                len -= 1
              end
              if (len <= 0)
                next
              end
              key = s.char_at(0)
              t1 = s.index_of(Character.new(?\t.ord))
              t2 = t1 > 0 ? s.index_of(Character.new(?\t.ord), t1 + 1) : -1
              t3 = t2 > 0 ? s.index_of(Character.new(?\t.ord), t2 + 1) : -1
              if (t3 < 0)
                # ps.print("<br><i>"+s+"</i>\n");
                next
              end
              port = t3 + 1 < len ? ":" + RJava.cast_to_string(s.substring(t3 + 1, len)) : ""
              host = t2 + 1 < t3 ? s.substring(t2 + 1, t3) : @u.get_host
              ps.print("<dt><a href=\"gopher://" + host + port + "/" + RJava.cast_to_string(s.substring(0, 1)) + RJava.cast_to_string(encode_percent(s.substring(t1 + 1, t2))) + "\">\n")
              ps.print("<img align=middle border=0 width=25 height=32 src=")
              case (key)
              when Character.new(?0.ord)
                ps.print(System.get_property("java.net.ftp.imagepath.text"))
              when Character.new(?1.ord)
                ps.print(System.get_property("java.net.ftp.imagepath.directory"))
              when Character.new(?g.ord)
                ps.print(System.get_property("java.net.ftp.imagepath.gif"))
              else
                ps.print(System.get_property("java.net.ftp.imagepath.file"))
              end
              ps.print(".gif align=middle><dd>\n")
              ps.print(RJava.cast_to_string(s.substring(1, t1)) + "</a>\n")
            end
            ps.print("</dl></body>\n")
            ps.close
          end
        end
      rescue UnsupportedEncodingException => e
        raise InternalError.new(RJava.cast_to_string(self.attr_encoding) + " encoding not found")
      rescue IOException => e
      ensure
        begin
          close_server
          @os.close
        rescue IOException => e2
        end
      end
    end
    
    private
    alias_method :initialize__gopher_client, :initialize
  end
  
  # An input stream that does nothing more than hold on to the NetworkClient
  # that created it.  This is used when only the input stream is needed, and
  # the network client needs to be closed when the input stream is closed.
  class GopherInputStream < GopherClientImports.const_get :FilterInputStream
    include_class_members GopherClientImports
    
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    typesig { [NetworkClient, InputStream] }
    def initialize(o, fd)
      @parent = nil
      super(fd)
      @parent = o
    end
    
    typesig { [] }
    def close
      begin
        @parent.close_server
        super
      rescue IOException => e
      end
    end
    
    private
    alias_method :initialize__gopher_input_stream, :initialize
  end
  
end
