require "rjava"

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
  module SessionIdImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include_const ::Java::Security, :SecureRandom
    }
  end
  
  # Encapsulates an SSL session ID.  SSL Session IDs are not reused by
  # servers during the lifetime of any sessions it created.  Sessions may
  # be used by many connections, either concurrently (for example, two
  # connections to a web server at the same time) or sequentially (over as
  # long a time period as is allowed by a given server).
  # 
  # @author Satish Dharmaraj
  # @author David Brownell
  class SessionId 
    include_class_members SessionIdImports
    
    attr_accessor :session_id
    alias_method :attr_session_id, :session_id
    undef_method :session_id
    alias_method :attr_session_id=, :session_id=
    undef_method :session_id=
    
    typesig { [::Java::Boolean, SecureRandom] }
    # max 32 bytes
    # Constructs a new session ID ... perhaps for a rejoinable session
    def initialize(is_rejoinable, generator)
      @session_id = nil
      if (is_rejoinable)
        # this will be unique, it's a timestamp plus much randomness
        @session_id = RandomCookie.new(generator).attr_random_bytes
      else
        @session_id = Array.typed(::Java::Byte).new(0) { 0 }
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Constructs a session ID from a byte array (max size 32 bytes)
    def initialize(session_id)
      @session_id = nil
      @session_id = session_id
    end
    
    typesig { [] }
    # Returns the length of the ID, in bytes
    def length
      return @session_id.attr_length
    end
    
    typesig { [] }
    # Returns the bytes in the ID.  May be an empty array.
    def get_id
      return @session_id.clone
    end
    
    typesig { [] }
    # Returns the ID as a string
    def to_s
      len = @session_id.attr_length
      s = StringBuffer.new(10 + 2 * len)
      s.append("{")
      i = 0
      while i < len
        s.append(0xff & @session_id[i])
        if (!(i).equal?((len - 1)))
          s.append(", ")
        end
        i += 1
      end
      s.append("}")
      return s.to_s
    end
    
    typesig { [] }
    # Returns a value which is the same for session IDs which are equal
    def hash_code
      retval = 0
      i = 0
      while i < @session_id.attr_length
        retval += @session_id[i]
        i += 1
      end
      return retval
    end
    
    typesig { [Object] }
    # Returns true if the parameter is the same session ID
    def ==(obj)
      if (!(obj.is_a?(SessionId)))
        return false
      end
      s = obj
      b = s.get_id
      if (!(b.attr_length).equal?(@session_id.attr_length))
        return false
      end
      i = 0
      while i < @session_id.attr_length
        if (!(b[i]).equal?(@session_id[i]))
          return false
        end
        i += 1
      end
      return true
    end
    
    private
    alias_method :initialize__session_id, :initialize
  end
  
end
