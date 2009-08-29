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
  module TerminalImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
      include ::Java::Util
      include ::Javax::Smartcardio
    }
  end
  
  # CardTerminal implementation.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class TerminalImpl < TerminalImplImports.const_get :CardTerminal
    include_class_members TerminalImplImports
    
    # native SCARDCONTEXT
    attr_accessor :context_id
    alias_method :attr_context_id, :context_id
    undef_method :context_id
    alias_method :attr_context_id=, :context_id=
    undef_method :context_id=
    
    # the name of this terminal (native PC/SC name)
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :card
    alias_method :attr_card, :card
    undef_method :card
    alias_method :attr_card=, :card=
    undef_method :card=
    
    typesig { [::Java::Long, String] }
    def initialize(context_id, name)
      @context_id = 0
      @name = nil
      @card = nil
      super()
      @context_id = context_id
      @name = name
    end
    
    typesig { [] }
    def get_name
      return @name
    end
    
    typesig { [String] }
    def connect(protocol)
      synchronized(self) do
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(CardPermission.new(@name, "connect"))
        end
        if (!(@card).nil?)
          if (@card.is_valid)
            card_proto = @card.get_protocol
            if ((protocol == "*") || protocol.equals_ignore_case(card_proto))
              return @card
            else
              raise CardException.new("Cannot connect using " + protocol + ", connection already established using " + card_proto)
            end
          else
            @card = nil
          end
        end
        begin
          @card = CardImpl.new(self, protocol)
          return @card
        rescue PCSCException => e
          if ((e.attr_code).equal?(SCARD_W_REMOVED_CARD))
            raise CardNotPresentException.new("No card present", e)
          else
            raise CardException.new("connect() failed", e)
          end
        end
      end
    end
    
    typesig { [] }
    def is_card_present
      begin
        status = _scard_get_status_change(@context_id, 0, Array.typed(::Java::Int).new([SCARD_STATE_UNAWARE]), Array.typed(String).new([@name]))
        return !((status[0] & SCARD_STATE_PRESENT)).equal?(0)
      rescue PCSCException => e
        raise CardException.new("isCardPresent() failed", e)
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Long] }
    def wait_for_card(want_present, timeout)
      if (timeout < 0)
        raise IllegalArgumentException.new("timeout must not be negative")
      end
      if ((timeout).equal?(0))
        timeout = TIMEOUT_INFINITE
      end
      status = Array.typed(::Java::Int).new([SCARD_STATE_UNAWARE])
      readers = Array.typed(String).new([@name])
      begin
        # check if card status already matches
        status = _scard_get_status_change(@context_id, 0, status, readers)
        present = !((status[0] & SCARD_STATE_PRESENT)).equal?(0)
        if ((want_present).equal?(present))
          return true
        end
        # no match, wait
        status = _scard_get_status_change(@context_id, timeout, status, readers)
        present = !((status[0] & SCARD_STATE_PRESENT)).equal?(0)
        # should never happen
        if (!(want_present).equal?(present))
          raise CardException.new("wait mismatch")
        end
        return true
      rescue PCSCException => e
        if ((e.attr_code).equal?(SCARD_E_TIMEOUT))
          return false
        else
          raise CardException.new("waitForCard() failed", e)
        end
      end
    end
    
    typesig { [::Java::Long] }
    def wait_for_card_present(timeout)
      return wait_for_card(true, timeout)
    end
    
    typesig { [::Java::Long] }
    def wait_for_card_absent(timeout)
      return wait_for_card(false, timeout)
    end
    
    typesig { [] }
    def to_s
      return "PC/SC terminal " + @name
    end
    
    private
    alias_method :initialize__terminal_impl, :initialize
  end
  
end
