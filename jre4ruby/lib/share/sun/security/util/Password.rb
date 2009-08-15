require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module PasswordImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include ::Java::Io
      include ::Java::Nio
      include ::Java::Nio::Charset
      include_const ::Java::Util, :Arrays
    }
  end
  
  # A utility class for reading passwords
  class Password 
    include_class_members PasswordImports
    
    class_module.module_eval {
      typesig { [InputStream] }
      # Reads user password from given input stream.
      def read_password(in_)
        console_entered = nil
        console_bytes = nil
        begin
          # Use the new java.io.Console class
          con = nil
          if ((in_).equal?(System.in) && (!((con = System.console)).nil?))
            console_entered = con.read_password
            # readPassword returns "" if you just print ENTER,
            # to be compatible with old Password class, change to null
            if (!(console_entered).nil? && (console_entered.attr_length).equal?(0))
              return nil
            end
            console_bytes = convert_to_bytes(console_entered)
            in_ = ByteArrayInputStream.new(console_bytes)
          end
          # Rest of the lines still necessary for KeyStoreLoginModule
          # and when there is no console.
          line_buffer = nil
          buf = nil
          i = 0
          buf = line_buffer = CharArray.new(128)
          room = buf.attr_length
          offset = 0
          c = 0
          done = false
          while (!done)
            catch(:break_case) do
              case (c = in_.read)
              when -1, Character.new(?\n.ord)
                done = true
              when Character.new(?\r.ord)
                c2 = in_.read
                if ((!(c2).equal?(Character.new(?\n.ord))) && (!(c2).equal?(-1)))
                  if (!(in_.is_a?(PushbackInputStream)))
                    in_ = PushbackInputStream.new(in_)
                  end
                  (in_).unread(c2)
                else
                  done = true
                  throw :break_case, :thrown
                end
                if ((room -= 1) < 0)
                  buf = CharArray.new(offset + 128)
                  room = buf.attr_length - offset - 1
                  System.arraycopy(line_buffer, 0, buf, 0, offset)
                  Arrays.fill(line_buffer, Character.new(?\s.ord))
                  line_buffer = buf
                end
                buf[((offset += 1) - 1)] = RJava.cast_to_char(c)
              else
                if ((room -= 1) < 0)
                  buf = CharArray.new(offset + 128)
                  room = buf.attr_length - offset - 1
                  System.arraycopy(line_buffer, 0, buf, 0, offset)
                  Arrays.fill(line_buffer, Character.new(?\s.ord))
                  line_buffer = buf
                end
                buf[((offset += 1) - 1)] = RJava.cast_to_char(c)
              end
            end == :thrown or break
          end
          if ((offset).equal?(0))
            return nil
          end
          ret = CharArray.new(offset)
          System.arraycopy(buf, 0, ret, 0, offset)
          Arrays.fill(buf, Character.new(?\s.ord))
          return ret
        ensure
          if (!(console_entered).nil?)
            Arrays.fill(console_entered, Character.new(?\s.ord))
          end
          if (!(console_bytes).nil?)
            Arrays.fill(console_bytes, 0)
          end
        end
      end
      
      typesig { [Array.typed(::Java::Char)] }
      # Change a password read from Console.readPassword() into
      # its original bytes.
      # 
      # @param pass a char[]
      # @return its byte[] format, similar to new String(pass).getBytes()
      def convert_to_bytes(pass)
        if ((self.attr_enc).nil?)
          synchronized((Password)) do
            self.attr_enc = Sun::Misc::SharedSecrets.get_java_ioaccess.charset.new_encoder.on_malformed_input(CodingErrorAction::REPLACE).on_unmappable_character(CodingErrorAction::REPLACE)
          end
        end
        ba = Array.typed(::Java::Byte).new(RJava.cast_to_int((self.attr_enc.max_bytes_per_char * pass.attr_length))) { 0 }
        bb = ByteBuffer.wrap(ba)
        synchronized((self.attr_enc)) do
          self.attr_enc.reset.encode(CharBuffer.wrap(pass), bb, true)
        end
        if (bb.position < ba.attr_length)
          ba[bb.position] = Character.new(?\n.ord)
        end
        return ba
      end
      
      
      def enc
        defined?(@@enc) ? @@enc : @@enc= nil
      end
      alias_method :attr_enc, :enc
      
      def enc=(value)
        @@enc = value
      end
      alias_method :attr_enc=, :enc=
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__password, :initialize
  end
  
end
