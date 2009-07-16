require "rjava"

# 
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
  module CardImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
      include_const ::Java::Nio, :ByteBuffer
      include ::Javax::Smartcardio
    }
  end
  
  # 
  # Card implementation.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class CardImpl < CardImplImports.const_get :Card
    include_class_members CardImplImports
    
    class_module.module_eval {
      const_set_lazy(:OK) { State::OK }
      const_attr_reader  :OK
      
      const_set_lazy(:REMOVED) { State::REMOVED }
      const_attr_reader  :REMOVED
      
      const_set_lazy(:DISCONNECTED) { State::DISCONNECTED }
      const_attr_reader  :DISCONNECTED
      
      class State 
        include_class_members CardImpl
        
        class_module.module_eval {
          const_set_lazy(:OK) { State.new.set_value_name("OK") }
          const_attr_reader  :OK
          
          const_set_lazy(:REMOVED) { State.new.set_value_name("REMOVED") }
          const_attr_reader  :REMOVED
          
          const_set_lazy(:DISCONNECTED) { State.new.set_value_name("DISCONNECTED") }
          const_attr_reader  :DISCONNECTED
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [OK, REMOVED, DISCONNECTED]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__state, :initialize
      end
    }
    
    # the terminal that created this card
    attr_accessor :terminal
    alias_method :attr_terminal, :terminal
    undef_method :terminal
    alias_method :attr_terminal=, :terminal=
    undef_method :terminal=
    
    # the native SCARDHANDLE
    attr_accessor :card_id
    alias_method :attr_card_id, :card_id
    undef_method :card_id
    alias_method :attr_card_id=, :card_id=
    undef_method :card_id=
    
    # atr of this card
    attr_accessor :atr
    alias_method :attr_atr, :atr
    undef_method :atr
    alias_method :attr_atr=, :atr=
    undef_method :atr=
    
    # protocol in use, one of SCARD_PROTOCOL_T0 and SCARD_PROTOCOL_T1
    attr_accessor :protocol
    alias_method :attr_protocol, :protocol
    undef_method :protocol
    alias_method :attr_protocol=, :protocol=
    undef_method :protocol=
    
    # the basic logical channel (channel 0)
    attr_accessor :basic_channel
    alias_method :attr_basic_channel, :basic_channel
    undef_method :basic_channel
    alias_method :attr_basic_channel=, :basic_channel=
    undef_method :basic_channel=
    
    # state of this card connection
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # thread holding exclusive access to the card, or null
    attr_accessor :exclusive_thread
    alias_method :attr_exclusive_thread, :exclusive_thread
    undef_method :exclusive_thread
    alias_method :attr_exclusive_thread=, :exclusive_thread=
    undef_method :exclusive_thread=
    
    typesig { [TerminalImpl, String] }
    def initialize(terminal, protocol)
      @terminal = nil
      @card_id = 0
      @atr = nil
      @protocol = 0
      @basic_channel = nil
      @state = nil
      @exclusive_thread = nil
      super()
      @terminal = terminal
      sharing_mode = SCARD_SHARE_SHARED
      connect_protocol = 0
      if ((protocol == "*"))
        connect_protocol = SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1
      else
        if (protocol.equals_ignore_case("T=0"))
          connect_protocol = SCARD_PROTOCOL_T0
        else
          if (protocol.equals_ignore_case("T=1"))
            connect_protocol = SCARD_PROTOCOL_T1
          else
            if (protocol.equals_ignore_case("direct"))
              # testing
              connect_protocol = 0
              sharing_mode = SCARD_SHARE_DIRECT
            else
              raise IllegalArgumentException.new("Unsupported protocol " + protocol)
            end
          end
        end
      end
      @card_id = _scard_connect(terminal.attr_context_id, terminal.attr_name, sharing_mode, connect_protocol)
      status = Array.typed(::Java::Byte).new(2) { 0 }
      atr_bytes = _scard_status(@card_id, status)
      @atr = ATR.new(atr_bytes)
      @protocol = status[1] & 0xff
      @basic_channel = ChannelImpl.new(self, 0)
      @state = State::OK
    end
    
    typesig { [] }
    def check_state
      s = @state
      if ((s).equal?(State::DISCONNECTED))
        raise IllegalStateException.new("Card has been disconnected")
      else
        if ((s).equal?(State::REMOVED))
          raise IllegalStateException.new("Card has been removed")
        end
      end
    end
    
    typesig { [] }
    def is_valid
      if (!(@state).equal?(State::OK))
        return false
      end
      # ping card via SCardStatus
      begin
        _scard_status(@card_id, Array.typed(::Java::Byte).new(2) { 0 })
        return true
      rescue PCSCException => e
        @state = State::REMOVED
        return false
      end
    end
    
    typesig { [String] }
    def check_security(action)
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(CardPermission.new(@terminal.attr_name, action))
      end
    end
    
    typesig { [PCSCException] }
    def handle_error(e)
      if ((e.attr_code).equal?(SCARD_W_REMOVED_CARD))
        @state = State::REMOVED
      end
    end
    
    typesig { [] }
    def get_atr
      return @atr
    end
    
    typesig { [] }
    def get_protocol
      case (@protocol)
      when SCARD_PROTOCOL_T0
        return "T=0"
      when SCARD_PROTOCOL_T1
        return "T=1"
      else
        # should never occur
        return "Unknown protocol " + (@protocol).to_s
      end
    end
    
    typesig { [] }
    def get_basic_channel
      check_security("getBasicChannel")
      check_state
      return @basic_channel
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte)] }
      def get_sw(b)
        if (b.attr_length < 2)
          return -1
        end
        sw1 = b[b.attr_length - 2] & 0xff
        sw2 = b[b.attr_length - 1] & 0xff
        return (sw1 << 8) | sw2
      end
      
      
      def command_open_channel
        defined?(@@command_open_channel) ? @@command_open_channel : @@command_open_channel= Array.typed(::Java::Byte).new([0, 0x70, 0, 0, 1])
      end
      alias_method :attr_command_open_channel, :command_open_channel
      
      def command_open_channel=(value)
        @@command_open_channel = value
      end
      alias_method :attr_command_open_channel=, :command_open_channel=
    }
    
    typesig { [] }
    def open_logical_channel
      check_security("openLogicalChannel")
      check_state
      check_exclusive
      begin
        response = _scard_transmit(@card_id, @protocol, self.attr_command_open_channel, 0, self.attr_command_open_channel.attr_length)
        if ((!(response.attr_length).equal?(3)) || (!(get_sw(response)).equal?(0x9000)))
          raise CardException.new("openLogicalChannel() failed, card response: " + (PCSC.to_s(response)).to_s)
        end
        return ChannelImpl.new(self, response[0])
      rescue PCSCException => e
        handle_error(e)
        raise CardException.new("openLogicalChannel() failed", e)
      end
    end
    
    typesig { [] }
    def check_exclusive
      t = @exclusive_thread
      if ((t).nil?)
        return
      end
      if (!(t).equal?(JavaThread.current_thread))
        raise CardException.new("Exclusive access established by another Thread")
      end
    end
    
    typesig { [] }
    def begin_exclusive
      synchronized(self) do
        check_security("exclusive")
        check_state
        if (!(@exclusive_thread).nil?)
          raise CardException.new("Exclusive access has already been assigned to Thread " + (@exclusive_thread.get_name).to_s)
        end
        begin
          _scard_begin_transaction(@card_id)
        rescue PCSCException => e
          handle_error(e)
          raise CardException.new("beginExclusive() failed", e)
        end
        @exclusive_thread = JavaThread.current_thread
      end
    end
    
    typesig { [] }
    def end_exclusive
      synchronized(self) do
        check_state
        if (!(@exclusive_thread).equal?(JavaThread.current_thread))
          raise IllegalStateException.new("Exclusive access not assigned to current Thread")
        end
        begin
          _scard_end_transaction(@card_id, SCARD_LEAVE_CARD)
        rescue PCSCException => e
          handle_error(e)
          raise CardException.new("beginExclusive() failed", e)
        ensure
          @exclusive_thread = nil
        end
      end
    end
    
    typesig { [::Java::Int, Array.typed(::Java::Byte)] }
    def transmit_control_command(control_code, command)
      check_security("transmitControl")
      check_state
      check_exclusive
      if ((command).nil?)
        raise NullPointerException.new
      end
      begin
        r = _scard_control(@card_id, control_code, command)
        return r
      rescue PCSCException => e
        handle_error(e)
        raise CardException.new("transmitControlCommand() failed", e)
      end
    end
    
    typesig { [::Java::Boolean] }
    def disconnect(reset)
      if (reset)
        check_security("reset")
      end
      if (!(@state).equal?(State::OK))
        return
      end
      check_exclusive
      begin
        _scard_disconnect(@card_id, (reset ? SCARD_LEAVE_CARD : SCARD_RESET_CARD))
      rescue PCSCException => e
        raise CardException.new("disconnect() failed", e)
      ensure
        @state = State::DISCONNECTED
        @exclusive_thread = nil
      end
    end
    
    typesig { [] }
    def to_s
      return "PC/SC card in " + (@terminal.get_name).to_s + ", protocol " + (get_protocol).to_s + ", state " + (@state).to_s
    end
    
    typesig { [] }
    def finalize
      begin
        if ((@state).equal?(State::OK))
          _scard_disconnect(@card_id, SCARD_LEAVE_CARD)
        end
      ensure
        super
      end
    end
    
    private
    alias_method :initialize__card_impl, :initialize
  end
  
end
