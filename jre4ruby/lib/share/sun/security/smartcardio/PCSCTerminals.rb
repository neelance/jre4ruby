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
  module PCSCTerminalsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Smartcardio
      include ::Java::Util
      include ::Java::Lang::Ref
      include ::Javax::Smartcardio
    }
  end
  
  # TerminalFactorySpi implementation class.
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class PCSCTerminals < PCSCTerminalsImports.const_get :CardTerminals
    include_class_members PCSCTerminalsImports
    
    class_module.module_eval {
      # SCARDCONTEXT, currently shared between all threads/terminals
      
      def context_id
        defined?(@@context_id) ? @@context_id : @@context_id= 0
      end
      alias_method :attr_context_id, :context_id
      
      def context_id=(value)
        @@context_id = value
      end
      alias_method :attr_context_id=, :context_id=
    }
    
    # terminal state used by waitForCard()
    attr_accessor :state_map
    alias_method :attr_state_map, :state_map
    undef_method :state_map
    alias_method :attr_state_map=, :state_map=
    undef_method :state_map=
    
    typesig { [] }
    def initialize
      @state_map = nil
      super()
      # empty
    end
    
    class_module.module_eval {
      typesig { [] }
      def init_context
        synchronized(self) do
          if ((self.attr_context_id).equal?(0))
            self.attr_context_id = _scard_establish_context(SCARD_SCOPE_USER)
          end
        end
      end
      
      const_set_lazy(:Terminals) { HashMap.new }
      const_attr_reader  :Terminals
      
      typesig { [String] }
      def impl_get_terminal(name)
        synchronized(self) do
          ref = Terminals.get(name)
          terminal = (!(ref).nil?) ? ref.get : nil
          if (!(terminal).nil?)
            return terminal
          end
          terminal = TerminalImpl.new(self.attr_context_id, name)
          Terminals.put(name, WeakReference.new(terminal))
          return terminal
        end
      end
    }
    
    typesig { [State] }
    def list(state)
      synchronized(self) do
        if ((state).nil?)
          raise NullPointerException.new
        end
        begin
          reader_names = _scard_list_readers(self.attr_context_id)
          list = ArrayList.new(reader_names.attr_length)
          if ((@state_map).nil?)
            # If waitForChange() has never been called, treat event
            # queries as status queries.
            if ((state).equal?(CARD_INSERTION))
              state = CARD_PRESENT
            else
              if ((state).equal?(CARD_REMOVAL))
                state = CARD_ABSENT
              end
            end
          end
          reader_names.each do |readerName|
            terminal = impl_get_terminal(reader_name)
            reader_state = nil
            case (state)
            when ALL
              list.add(terminal)
            when CARD_PRESENT
              if (terminal.is_card_present)
                list.add(terminal)
              end
            when CARD_ABSENT
              if ((terminal.is_card_present).equal?(false))
                list.add(terminal)
              end
            when CARD_INSERTION
              reader_state = @state_map.get(reader_name)
              if ((!(reader_state).nil?) && reader_state.is_insertion)
                list.add(terminal)
              end
            when CARD_REMOVAL
              reader_state = @state_map.get(reader_name)
              if ((!(reader_state).nil?) && reader_state.is_removal)
                list.add(terminal)
              end
            else
              raise CardException.new("Unknown state: " + RJava.cast_to_string(state))
            end
          end
          return Collections.unmodifiable_list(list)
        rescue PCSCException => e
          raise CardException.new("list() failed", e)
        end
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:ReaderState) { Class.new do
        include_class_members PCSCTerminals
        
        attr_accessor :current
        alias_method :attr_current, :current
        undef_method :current
        alias_method :attr_current=, :current=
        undef_method :current=
        
        attr_accessor :previous
        alias_method :attr_previous, :previous
        undef_method :previous
        alias_method :attr_previous=, :previous=
        undef_method :previous=
        
        typesig { [] }
        def initialize
          @current = 0
          @previous = 0
          @current = SCARD_STATE_UNAWARE
          @previous = SCARD_STATE_UNAWARE
        end
        
        typesig { [] }
        def get
          return @current
        end
        
        typesig { [::Java::Int] }
        def update(new_state)
          @previous = @current
          @current = new_state
        end
        
        typesig { [] }
        def is_insertion
          return !present(@previous) && present(@current)
        end
        
        typesig { [] }
        def is_removal
          return present(@previous) && !present(@current)
        end
        
        class_module.module_eval {
          typesig { [::Java::Int] }
          def present(state)
            return !((state & SCARD_STATE_PRESENT)).equal?(0)
          end
        }
        
        private
        alias_method :initialize__reader_state, :initialize
      end }
    }
    
    typesig { [::Java::Long] }
    def wait_for_change(timeout)
      synchronized(self) do
        if (timeout < 0)
          raise IllegalArgumentException.new("Timeout must not be negative: " + RJava.cast_to_string(timeout))
        end
        if ((@state_map).nil?)
          # We need to initialize the state database.
          # Do that with a recursive call, which will return immediately
          # because we pass SCARD_STATE_UNAWARE.
          # After that, proceed with the real call.
          @state_map = HashMap.new
          wait_for_change(0)
        end
        if ((timeout).equal?(0))
          timeout = TIMEOUT_INFINITE
        end
        begin
          reader_names = _scard_list_readers(self.attr_context_id)
          n = reader_names.attr_length
          if ((n).equal?(0))
            raise IllegalStateException.new("No terminals available")
          end
          status = Array.typed(::Java::Int).new(n) { 0 }
          reader_states = Array.typed(ReaderState).new(n) { nil }
          i = 0
          while i < reader_names.attr_length
            name = reader_names[i]
            state = @state_map.get(name)
            if ((state).nil?)
              state = ReaderState.new
            end
            reader_states[i] = state
            status[i] = state.get
            i += 1
          end
          status = _scard_get_status_change(self.attr_context_id, timeout, status, reader_names)
          @state_map.clear # remove any readers that are no longer available
          i_ = 0
          while i_ < n
            state = reader_states[i_]
            state.update(status[i_])
            @state_map.put(reader_names[i_], state)
            i_ += 1
          end
          return true
        rescue PCSCException => e
          if ((e.attr_code).equal?(SCARD_E_TIMEOUT))
            return false
          else
            raise CardException.new("waitForChange() failed", e)
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [SwtList, ::Java::Long, ::Java::Boolean] }
      def wait_for_cards(terminals, timeout, want_present)
        # the argument sanity checks are performed in
        # javax.smartcardio.TerminalFactory or TerminalImpl
        this_timeout = 0
        if ((timeout).equal?(0))
          timeout = TIMEOUT_INFINITE
          this_timeout = TIMEOUT_INFINITE
        else
          # if timeout is not infinite, do the initial call that retrieves
          # the status with a 0 timeout. Otherwise, we might get incorrect
          # timeout exceptions (seen on Solaris with PC/SC shim)
          this_timeout = 0
        end
        names = Array.typed(String).new(terminals.size) { nil }
        i = 0
        terminals.each do |terminal|
          if ((terminal.is_a?(TerminalImpl)).equal?(false))
            raise IllegalArgumentException.new("Invalid terminal type: " + RJava.cast_to_string(terminal.get_class.get_name))
          end
          impl = terminal
          names[((i += 1) - 1)] = impl.attr_name
        end
        status = Array.typed(::Java::Int).new(names.attr_length) { 0 }
        Arrays.fill(status, SCARD_STATE_UNAWARE)
        begin
          while (true)
            # note that we pass "timeout" on each native PC/SC call
            # that means that if we end up making multiple (more than 2)
            # calls, we might wait too long.
            # for now assume that is unlikely and not a problem.
            status = _scard_get_status_change(self.attr_context_id, this_timeout, status, names)
            this_timeout = timeout
            results = nil
            i = 0
            while i < names.attr_length
              now_present = !((status[i] & SCARD_STATE_PRESENT)).equal?(0)
              if ((now_present).equal?(want_present))
                if ((results).nil?)
                  results = ArrayList.new
                end
                results.add(impl_get_terminal(names[i]))
              end
              i += 1
            end
            if (!(results).nil?)
              return Collections.unmodifiable_list(results)
            end
          end
        rescue PCSCException => e
          if ((e.attr_code).equal?(SCARD_E_TIMEOUT))
            return Collections.empty_list
          else
            raise CardException.new("waitForCard() failed", e)
          end
        end
      end
    }
    
    private
    alias_method :initialize__pcscterminals, :initialize
  end
  
end
