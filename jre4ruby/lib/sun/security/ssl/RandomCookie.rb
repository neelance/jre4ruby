require "rjava"

# 
# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module RandomCookieImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Io
      include_const ::Java::Security, :SecureRandom
    }
  end
  
  # 
  # RandomCookie ... SSL hands standard format random cookies (nonces)
  # around.  These know how to encode/decode themselves on SSL streams,
  # and can be created and printed.
  # 
  # @author David Brownell
  class RandomCookie 
    include_class_members RandomCookieImports
    
    attr_accessor :random_bytes
    alias_method :attr_random_bytes, :random_bytes
    undef_method :random_bytes
    alias_method :attr_random_bytes=, :random_bytes=
    undef_method :random_bytes=
    
    typesig { [SecureRandom] }
    # exactly 32 bytes
    def initialize(generator)
      @random_bytes = nil
      temp = System.current_time_millis / 1000
      gmt_unix_time = 0
      if (temp < JavaInteger::MAX_VALUE)
        gmt_unix_time = RJava.cast_to_int(temp)
      else
        gmt_unix_time = JavaInteger::MAX_VALUE # Whoops!
      end
      @random_bytes = Array.typed(::Java::Byte).new(32) { 0 }
      generator.next_bytes(@random_bytes)
      @random_bytes[0] = (gmt_unix_time >> 24)
      @random_bytes[1] = (gmt_unix_time >> 16)
      @random_bytes[2] = (gmt_unix_time >> 8)
      @random_bytes[3] = gmt_unix_time
    end
    
    typesig { [HandshakeInStream] }
    def initialize(m)
      @random_bytes = nil
      @random_bytes = Array.typed(::Java::Byte).new(32) { 0 }
      m.read(@random_bytes, 0, 32)
    end
    
    typesig { [HandshakeOutStream] }
    def send(out)
      out.write(@random_bytes, 0, 32)
    end
    
    typesig { [PrintStream] }
    def print(s)
      i = 0
      gmt_unix_time = 0
      gmt_unix_time = @random_bytes[0] << 24
      gmt_unix_time += @random_bytes[1] << 16
      gmt_unix_time += @random_bytes[2] << 8
      gmt_unix_time += @random_bytes[3]
      s.print("GMT: " + (gmt_unix_time).to_s + " ")
      s.print("bytes = { ")
      i = 4
      while i < 32
        if (!(i).equal?(4))
          s.print(", ")
        end
        s.print(@random_bytes[i] & 0xff)
        ((i += 1) - 1)
      end
      s.println(" }")
    end
    
    private
    alias_method :initialize__random_cookie, :initialize
  end
  
end
