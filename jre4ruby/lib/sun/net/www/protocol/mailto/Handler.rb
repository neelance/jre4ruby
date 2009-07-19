require "rjava"

# Copyright 1995-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
# -
# mailto stream opener
module Sun::Net::Www::Protocol::Mailto
  module HandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Mailto
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Net, :URLStreamHandler
      include ::Java::Io
      include ::Sun::Net::Www
      include_const ::Sun::Net::Smtp, :SmtpClient
    }
  end
  
  # import sun.net.www.protocol.news.ArticlePoster;
  # open an nntp input stream given a URL
  class Handler < HandlerImports.const_get :URLStreamHandler
    include_class_members HandlerImports
    
    typesig { [URL] }
    # //     private String decodePercent(String s) {
    # //      if (s==null || s.indexOf('%') < 0)
    # //          return s;
    # //      int limit = s.length();
    # //      char d[] = new char[limit];
    # //      int dp = 0;
    # //      for (int sp = 0; sp < limit; sp++) {
    # //          int c = s.charAt(sp);
    # //          if (c == '%' && sp + 2 < limit) {
    # //              int s1 = s.charAt(sp + 1);
    # //              int s2 = s.charAt(sp + 2);
    # //              if ('0' <= s1 && s1 <= '9')
    # //                  s1 = s1 - '0';
    # //              else if ('a' <= s1 && s1 <= 'f')
    # //                  s1 = s1 - 'a' + 10;
    # //              else if ('A' <= s1 && s1 <= 'F')
    # //                  s1 = s1 - 'A' + 10;
    # //              else
    # //                  s1 = -1;
    # //              if ('0' <= s2 && s2 <= '9')
    # //                  s2 = s2 - '0';
    # //              else if ('a' <= s2 && s2 <= 'f')
    # //                  s2 = s2 - 'a' + 10;
    # //              else if ('A' <= s2 && s2 <= 'F')
    # //                  s2 = s2 - 'A' + 10;
    # //              else
    # //                  s2 = -1;
    # //              if (s1 >= 0 && s2 >= 0) {
    # //                  c = (s1 << 4) | s2;
    # //                  sp += 2;
    # //              }
    # //          }
    # //          d[dp++] = (char) c;
    # //      }
    # //      return new String(d, 0, dp);
    # //     }
    # 
    # //     public InputStream openStream(URL u) {
    # //          String dest = u.file;
    # //          String subj = "";
    # //          int lastsl = dest.lastIndexOf('/');
    # //          if (lastsl >= 0) {
    # //              int st = dest.charAt(0) == '/' ? 1 : 0;
    # //              if (lastsl > st)
    # //                  subj = dest.substring(st, lastsl);
    # //              dest = dest.substring(lastsl + 1);
    # //          }
    # //          if (u.postData != null) {
    # //              ArticlePoster.MailTo("Posted form",
    # //                                   decodePercent(dest),
    # //                                   u.postData);
    # //          }
    # //          else
    # //              ArticlePoster.MailTo(decodePercent(subj), decodePercent(dest));
    # //      return null;
    # //     }
    def open_connection(u)
      synchronized(self) do
        return MailToURLConnection.new(u)
      end
    end
    
    typesig { [URL, String, ::Java::Int, ::Java::Int] }
    # This method is called to parse the string spec into URL u for a
    # mailto protocol.
    # 
    # @param   u the URL to receive the result of parsing the spec
    # @param   spec the URL string to parse
    # @param   start the character position to start parsing at.  This is
    # just past the ':'.
    # @param   limit the character position to stop parsing at.
    def parse_url(u, spec, start, limit)
      protocol = u.get_protocol
      host = ""
      port = u.get_port
      file = ""
      if (start < limit)
        file = (spec.substring(start, limit)).to_s
      end
      # Let's just make sure we DO have an Email address in the URL.
      nogood = false
      if ((file).nil? || (file == ""))
        nogood = true
      else
        allwhites = true
        i = 0
        while i < file.length
          if (!Character.is_whitespace(file.char_at(i)))
            allwhites = false
          end
          ((i += 1) - 1)
        end
        if (allwhites)
          nogood = true
        end
      end
      if (nogood)
        raise RuntimeException.new("No email address")
      end
      set_url(u, protocol, host, port, file, nil)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__handler, :initialize
  end
  
end
