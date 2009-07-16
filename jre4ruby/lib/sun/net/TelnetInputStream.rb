require "rjava"

# 
# Copyright 1994-1995 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net
  module TelnetInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include ::Java::Io
    }
  end
  
  # 
  # This class provides input and output streams for telnet clients.
  # This class overrides read to do CRLF processing as specified in
  # RFC 854. The class assumes it is running on a system where lines
  # are terminated with a single newline <LF> character.
  # 
  # This is the relevant section of RFC 824 regarding CRLF processing:
  # 
  # <pre>
  # The sequence "CR LF", as defined, will cause the NVT to be
  # positioned at the left margin of the next print line (as would,
  # for example, the sequence "LF CR").  However, many systems and
  # terminals do not treat CR and LF independently, and will have to
  # go to some effort to simulate their effect.  (For example, some
  # terminals do not have a CR independent of the LF, but on such
  # terminals it may be possible to simulate a CR by backspacing.)
  # Therefore, the sequence "CR LF" must be treated as a single "new
  # line" character and used whenever their combined action is
  # intended; the sequence "CR NUL" must be used where a carriage
  # return alone is actually desired; and the CR character must be
  # avoided in other contexts.  This rule gives assurance to systems
  # which must decide whether to perform a "new line" function or a
  # multiple-backspace that the TELNET stream contains a character
  # following a CR that will allow a rational decision.
  # 
  # Note that "CR LF" or "CR NUL" is required in both directions
  # (in the default ASCII mode), to preserve the symmetry of the
  # NVT model.  Even though it may be known in some situations
  # (e.g., with remote echo and suppress go ahead options in
  # effect) that characters are not being sent to an actual
  # printer, nonetheless, for the sake of consistency, the protocol
  # requires that a NUL be inserted following a CR not followed by
  # a LF in the data stream.  The converse of this is that a NUL
  # received in the data stream after a CR (in the absence of
  # options negotiations which explicitly specify otherwise) should
  # be stripped out prior to applying the NVT to local character
  # set mapping.
  # </pre>
  # 
  # @author      Jonathan Payne
  class TelnetInputStream < TelnetInputStreamImports.const_get :FilterInputStream
    include_class_members TelnetInputStreamImports
    
    # If stickyCRLF is true, then we're a machine, like an IBM PC,
    # where a Newline is a CR followed by LF.  On UNIX, this is false
    # because Newline is represented with just a LF character.
    attr_accessor :sticky_crlf
    alias_method :attr_sticky_crlf, :sticky_crlf
    undef_method :sticky_crlf
    alias_method :attr_sticky_crlf=, :sticky_crlf=
    undef_method :sticky_crlf=
    
    attr_accessor :seen_cr
    alias_method :attr_seen_cr, :seen_cr
    undef_method :seen_cr
    alias_method :attr_seen_cr=, :seen_cr=
    undef_method :seen_cr=
    
    attr_accessor :binary_mode
    alias_method :attr_binary_mode, :binary_mode
    undef_method :binary_mode
    alias_method :attr_binary_mode=, :binary_mode=
    undef_method :binary_mode=
    
    typesig { [InputStream, ::Java::Boolean] }
    def initialize(fd, binary)
      @sticky_crlf = false
      @seen_cr = false
      @binary_mode = false
      super(fd)
      @sticky_crlf = false
      @seen_cr = false
      @binary_mode = false
      @binary_mode = binary
    end
    
    typesig { [::Java::Boolean] }
    def set_sticky_crlf(on)
      @sticky_crlf = on
    end
    
    typesig { [] }
    def read
      if (@binary_mode)
        return super
      end
      c = 0
      # If last time we determined we saw a CRLF pair, and we're
      # not turning that into just a Newline (that is, we're
      # stickyCRLF), then return the LF part of that sticky
      # pair now.
      if (@seen_cr)
        @seen_cr = false
        return Character.new(?\n.ord)
      end
      if (((c = super)).equal?(Character.new(?\r.ord)))
        # CR
        case (c = super)
        when -1
          # this is an error
          raise TelnetProtocolException.new("misplaced CR in input")
        when 0
          # NUL - treat CR as CR
          return Character.new(?\r.ord)
        when Character.new(?\n.ord)
          # CRLF - treat as NL
          if (@sticky_crlf)
            @seen_cr = true
            return Character.new(?\r.ord)
          else
            return Character.new(?\n.ord)
          end
        else
          # this is an error
          raise TelnetProtocolException.new("misplaced CR in input")
        end
      end
      return c
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # read into a byte array
    def read(bytes)
      return read(bytes, 0, bytes.attr_length)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Read into a byte array at offset <i>off</i> for length <i>length</i>
    # bytes.
    def read(bytes, off, length)
      if (@binary_mode)
        return super(bytes, off, length)
      end
      c = 0
      off_start = off
      while ((length -= 1) >= 0)
        c = read
        if ((c).equal?(-1))
          break
        end
        bytes[((off += 1) - 1)] = c
      end
      return (off > off_start) ? off - off_start : -1
    end
    
    private
    alias_method :initialize__telnet_input_stream, :initialize
  end
  
end
