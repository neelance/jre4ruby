require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Smartcardio
  module ChannelImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
      include ::Java::Nio
      include_const ::Java::Security, :AccessController
      include ::Javax::Smartcardio
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # CardChannel implementation.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class ChannelImpl < ChannelImplImports.const_get :CardChannel
    include_class_members ChannelImplImports
    
    # the card this channel is associated with
    attr_accessor :card
    alias_method :attr_card, :card
    undef_method :card
    alias_method :attr_card=, :card=
    undef_method :card=
    
    # the channel number, 0 for the basic logical channel
    attr_accessor :channel
    alias_method :attr_channel, :channel
    undef_method :channel
    alias_method :attr_channel=, :channel=
    undef_method :channel=
    
    # whether this channel has been closed. only logical channels can be closed
    attr_accessor :is_closed
    alias_method :attr_is_closed, :is_closed
    undef_method :is_closed
    alias_method :attr_is_closed=, :is_closed=
    undef_method :is_closed=
    
    typesig { [CardImpl, ::Java::Int] }
    def initialize(card, channel)
      @card = nil
      @channel = 0
      @is_closed = false
      super()
      @card = card
      @channel = channel
    end
    
    typesig { [] }
    def check_closed
      @card.check_state
      if (@is_closed)
        raise IllegalStateException.new("Logical channel has been closed")
      end
    end
    
    typesig { [] }
    def get_card
      return @card
    end
    
    typesig { [] }
    def get_channel_number
      check_closed
      return @channel
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      def check_manage_channel(b)
        if (b.attr_length < 4)
          raise IllegalArgumentException.new("Command APDU must be at least 4 bytes long")
        end
        if ((b[0] >= 0) && ((b[1]).equal?(0x70)))
          raise IllegalArgumentException.new("Manage channel command not allowed, use openLogicalChannel()")
        end
      end
    }
    
    typesig { [CommandAPDU] }
    def transmit(command)
      check_closed
      @card.check_exclusive
      command_bytes = command.get_bytes
      response_bytes = do_transmit(command_bytes)
      return ResponseAPDU.new(response_bytes)
    end
    
    typesig { [ByteBuffer, ByteBuffer] }
    def transmit(command, response)
      check_closed
      @card.check_exclusive
      if (((command).nil?) || ((response).nil?))
        raise NullPointerException.new
      end
      if (response.is_read_only)
        raise ReadOnlyBufferException.new
      end
      if ((command).equal?(response))
        raise IllegalArgumentException.new("command and response must not be the same object")
      end
      if (response.remaining < 258)
        raise IllegalArgumentException.new("Insufficient space in response buffer")
      end
      command_bytes = Array.typed(::Java::Byte).new(command.remaining) { 0 }
      command.get(command_bytes)
      response_bytes = do_transmit(command_bytes)
      response.put(response_bytes)
      return response_bytes.attr_length
    end
    
    class_module.module_eval {
      const_set_lazy(:T0GetResponse) { get_boolean_property("sun.security.smartcardio.t0GetResponse", true) }
      const_attr_reader  :T0GetResponse
      
      const_set_lazy(:T1GetResponse) { get_boolean_property("sun.security.smartcardio.t1GetResponse", true) }
      const_attr_reader  :T1GetResponse
      
      const_set_lazy(:T1StripLe) { get_boolean_property("sun.security.smartcardio.t1StripLe", false) }
      const_attr_reader  :T1StripLe
      
      typesig { [String, ::Java::Boolean] }
      def get_boolean_property(name, def_)
        val = AccessController.do_privileged(GetPropertyAction.new(name))
        if ((val).nil?)
          return def_
        end
        if (val.equals_ignore_case("true"))
          return true
        else
          if (val.equals_ignore_case("false"))
            return false
          else
            raise IllegalArgumentException.new(name + " must be either 'true' or 'false'")
          end
        end
      end
    }
    
    typesig { [Array.typed(::Java::Byte), Array.typed(::Java::Byte), ::Java::Int] }
    def concat(b1, b2, n2)
      n1 = b1.attr_length
      if (((n1).equal?(0)) && ((n2).equal?(b2.attr_length)))
        return b2
      end
      res = Array.typed(::Java::Byte).new(n1 + n2) { 0 }
      System.arraycopy(b1, 0, res, 0, n1)
      System.arraycopy(b2, 0, res, n1, n2)
      return res
    end
    
    class_module.module_eval {
      const_set_lazy(:B0) { Array.typed(::Java::Byte).new(0) { 0 } }
      const_attr_reader  :B0
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    def do_transmit(command)
      # note that we modify the 'command' array in some cases, so it must
      # be a copy of the application provided data.
      begin
        check_manage_channel(command)
        set_channel(command)
        n = command.attr_length
        t0 = (@card.attr_protocol).equal?(SCARD_PROTOCOL_T0)
        t1 = (@card.attr_protocol).equal?(SCARD_PROTOCOL_T1)
        if (t0 && (n >= 7) && ((command[4]).equal?(0)))
          raise CardException.new("Extended length forms not supported for T=0")
        end
        if ((t0 || (t1 && T1StripLe)) && (n >= 7))
          lc = command[4] & 0xff
          if (!(lc).equal?(0))
            if ((n).equal?(lc + 6))
              n -= 1
            end
          else
            lc = ((command[5] & 0xff) << 8) | (command[6] & 0xff)
            if ((n).equal?(lc + 9))
              n -= 2
            end
          end
        end
        getresponse = (t0 && T0GetResponse) || (t1 && T1GetResponse)
        k = 0
        result = B0
        while (true)
          if ((k += 1) >= 32)
            raise CardException.new("Could not obtain response")
          end
          response = _scard_transmit(@card.attr_card_id, @card.attr_protocol, command, 0, n)
          rn = response.attr_length
          if (getresponse && (rn >= 2))
            # see ISO 7816/2005, 5.1.3
            if (((rn).equal?(2)) && ((response[0]).equal?(0x6c)))
              # Resend command using SW2 as short Le field
              command[n - 1] = response[1]
              next
            end
            if ((response[rn - 2]).equal?(0x61))
              # Issue a GET RESPONSE command with the same CLA
              # using SW2 as short Le field
              if (rn > 2)
                result = concat(result, response, rn - 2)
              end
              command[1] = 0xc0
              command[2] = 0
              command[3] = 0
              command[4] = response[rn - 1]
              n = 5
              next
            end
          end
          result = concat(result, response, rn)
          break
        end
        return result
      rescue PCSCException => e
        @card.handle_error(e)
        raise CardException.new(e)
      end
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      def get_sw(res)
        if (res.attr_length < 2)
          raise CardException.new("Invalid response length: " + (res.attr_length).to_s)
        end
        sw1 = res[res.attr_length - 2] & 0xff
        sw2 = res[res.attr_length - 1] & 0xff
        return (sw1 << 8) | sw2
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      def is_ok(res)
        return ((res.attr_length).equal?(2)) && ((get_sw(res)).equal?(0x9000))
      end
    }
    
    typesig { [Array.typed(::Java::Byte)] }
    def set_channel(com)
      cla = com[0]
      if (cla < 0)
        # proprietary class format, cannot set or check logical channel
        # for now, just return
        return
      end
      # classes 001x xxxx is reserved for future use in ISO, ignore
      if (((cla & 0xe0)).equal?(0x20))
        return
      end
      # see ISO 7816/2005, table 2 and 3
      if (@channel <= 3)
        # mask of bits 7, 1, 0 (channel number)
        # 0xbc == 1011 1100
        com[0] &= 0xbc
        com[0] |= @channel
      else
        if (@channel <= 19)
          # mask of bits 7, 3, 2, 1, 0 (channel number)
          # 0xbc == 1011 0000
          com[0] &= 0xb0
          com[0] |= 0x40
          com[0] |= (@channel - 4)
        else
          raise RuntimeException.new("Unsupported channel number: " + (@channel).to_s)
        end
      end
    end
    
    typesig { [] }
    def close
      if ((get_channel_number).equal?(0))
        raise IllegalStateException.new("Cannot close basic logical channel")
      end
      if (@is_closed)
        return
      end
      @card.check_exclusive
      begin
        com = Array.typed(::Java::Byte).new([0x0, 0x70, 0x80, 0])
        com[3] = get_channel_number
        set_channel(com)
        res = _scard_transmit(@card.attr_card_id, @card.attr_protocol, com, 0, com.attr_length)
        if ((is_ok(res)).equal?(false))
          raise CardException.new("close() failed: " + (PCSC.to_s(res)).to_s)
        end
      rescue PCSCException => e
        @card.handle_error(e)
        raise CardException.new("Could not close channel", e)
      ensure
        @is_closed = true
      end
    end
    
    typesig { [] }
    def to_s
      return "PC/SC channel " + (@channel).to_s
    end
    
    private
    alias_method :initialize__channel_impl, :initialize
  end
  
end
