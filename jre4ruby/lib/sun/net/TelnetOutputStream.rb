require "rjava"

# 
# Copyright 1994-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
  module TelnetOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include ::Java::Io
    }
  end
  
  # 
  # This class provides input and output streams for telnet clients.
  # This class overrides write to do CRLF processing as specified in
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
  class TelnetOutputStream < TelnetOutputStreamImports.const_get :BufferedOutputStream
    include_class_members TelnetOutputStreamImports
    
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
    
    typesig { [OutputStream, ::Java::Boolean] }
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
    # 
    # set the stickyCRLF flag. Tells wether the terminal considers CRLF as a single
    # char.
    # 
    # @param   on      the <code>boolean</code> to set the flag to.
    def set_sticky_crlf(on)
      @sticky_crlf = on
    end
    
    typesig { [::Java::Int] }
    # 
    # Writes the int to the stream and does CR LF processing if necessary.
    def write(c)
      if (@binary_mode)
        super(c)
        return
      end
      if (@seen_cr)
        if (!(c).equal?(Character.new(?\n.ord)))
          super(0)
        end
        super(c)
        if (!(c).equal?(Character.new(?\r.ord)))
          @seen_cr = false
        end
      else
        # !seenCR
        if ((c).equal?(Character.new(?\n.ord)))
          super(Character.new(?\r.ord))
          super(Character.new(?\n.ord))
          return
        end
        if ((c).equal?(Character.new(?\r.ord)))
          if (@sticky_crlf)
            @seen_cr = true
          else
            super(Character.new(?\r.ord))
            c = 0
          end
        end
        super(c)
      end
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Write the bytes at offset <i>off</i> in buffer <i>bytes</i> for
    # <i>length</i> bytes.
    def write(bytes, off, length)
      if (@binary_mode)
        super(bytes, off, length)
        return
      end
      while ((length -= 1) >= 0)
        write(bytes[((off += 1) - 1)])
      end
    end
    
    private
    alias_method :initialize__telnet_output_stream, :initialize
  end
  
end
