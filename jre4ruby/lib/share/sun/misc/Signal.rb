require "rjava"

# Copyright 1998-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module SignalImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :Hashtable
    }
  end
  
  # This class provides ANSI/ISO C signal support. A Java program can register
  # signal handlers for the current process. There are two restrictions:
  # <ul>
  # <li>
  # Java code cannot register a handler for signals that are already used
  # by the Java VM implementation. The <code>Signal.handle</code>
  # function raises an <code>IllegalArgumentException</code> if such an attempt
  # is made.
  # <li>
  # When <code>Signal.handle</code> is called, the VM internally registers a
  # special C signal handler. There is no way to force the Java signal handler
  # to run synchronously before the C signal handler returns. Instead, when the
  # VM receives a signal, the special C signal handler creates a new thread
  # (at priority <code>Thread.MAX_PRIORITY</code>) to
  # run the registered Java signal handler. The C signal handler immediately
  # returns. Note that because the Java signal handler runs in a newly created
  # thread, it may not actually be executed until some time after the C signal
  # handler returns.
  # </ul>
  # <p>
  # Signal objects are created based on their names. For example:
  # <blockquote><pre>
  # new Signal("INT");
  # </blockquote></pre>
  # constructs a signal object corresponding to <code>SIGINT</code>, which is
  # typically produced when the user presses <code>Ctrl-C</code> at the command line.
  # The <code>Signal</code> constructor throws <code>IllegalArgumentException</code>
  # when it is passed an unknown signal.
  # <p>
  # This is an example of how Java code handles <code>SIGINT</code>:
  # <blockquote><pre>
  # SignalHandler handler = new SignalHandler () {
  # public void handle(Signal sig) {
  # ... // handle SIGINT
  # }
  # };
  # Signal.handle(new Signal("INT"), handler);
  # </blockquote></pre>
  # 
  # @author   Sheng Liang
  # @author   Bill Shannon
  # @see      sun.misc.SignalHandler
  # @since    1.2
  class Signal 
    include_class_members SignalImports
    
    class_module.module_eval {
      
      def handlers
        defined?(@@handlers) ? @@handlers : @@handlers= Hashtable.new(4)
      end
      alias_method :attr_handlers, :handlers
      
      def handlers=(value)
        @@handlers = value
      end
      alias_method :attr_handlers=, :handlers=
      
      
      def signals
        defined?(@@signals) ? @@signals : @@signals= Hashtable.new(4)
      end
      alias_method :attr_signals, :signals
      
      def signals=(value)
        @@signals = value
      end
      alias_method :attr_signals=, :signals=
    }
    
    attr_accessor :number
    alias_method :attr_number, :number
    undef_method :number
    alias_method :attr_number=, :number=
    undef_method :number=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    typesig { [] }
    # Returns the signal number
    def get_number
      return @number
    end
    
    typesig { [] }
    # Returns the signal name.
    # 
    # @return the name of the signal.
    # @see sun.misc.Signal#Signal(String name)
    def get_name
      return @name
    end
    
    typesig { [Object] }
    # Compares the equality of two <code>Signal</code> objects.
    # 
    # @param other the object to compare with.
    # @return whether two <code>Signal</code> objects are equal.
    def ==(other)
      if ((self).equal?(other))
        return true
      end
      if ((other).nil? || !(other.is_a?(Signal)))
        return false
      end
      other1 = other
      return (@name == other1.attr_name) && ((@number).equal?(other1.attr_number))
    end
    
    typesig { [] }
    # Returns a hashcode for this Signal.
    # 
    # @return  a hash code value for this object.
    def hash_code
      return @number
    end
    
    typesig { [] }
    # Returns a string representation of this signal. For example, "SIGINT"
    # for an object constructed using <code>new Signal ("INT")</code>.
    # 
    # @return a string representation of the signal
    def to_s
      return "SIG" + @name
    end
    
    typesig { [String] }
    # Constructs a signal from its name.
    # 
    # @param name the name of the signal.
    # @exception IllegalArgumentException unknown signal
    # @see sun.misc.Signal#getName()
    def initialize(name)
      @number = 0
      @name = nil
      @number = find_signal(name)
      @name = name
      if (@number < 0)
        raise IllegalArgumentException.new("Unknown signal: " + name)
      end
    end
    
    class_module.module_eval {
      typesig { [Signal, SignalHandler] }
      # Registers a signal handler.
      # 
      # @param sig a signal
      # @param handler the handler to be registered with the given signal.
      # @result the old handler
      # @exception IllegalArgumentException the signal is in use by the VM
      # @see sun.misc.Signal#raise(Signal sig)
      # @see sun.misc.SignalHandler
      # @see sun.misc.SignalHandler#SIG_DFL
      # @see sun.misc.SignalHandler#SIG_IGN
      def handle(sig, handler)
        synchronized(self) do
          new_h = (handler.is_a?(NativeSignalHandler)) ? (handler).get_handler : 2
          old_h = handle0(sig.attr_number, new_h)
          if ((old_h).equal?(-1))
            raise IllegalArgumentException.new("Signal already used by VM or OS: " + RJava.cast_to_string(sig))
          end
          self.attr_signals.put(sig.attr_number, sig)
          synchronized((self.attr_handlers)) do
            old_handler = self.attr_handlers.get(sig)
            self.attr_handlers.remove(sig)
            if ((new_h).equal?(2))
              self.attr_handlers.put(sig, handler)
            end
            if ((old_h).equal?(0))
              return SignalHandler::SIG_DFL
            else
              if ((old_h).equal?(1))
                return SignalHandler::SIG_IGN
              else
                if ((old_h).equal?(2))
                  return old_handler
                else
                  return NativeSignalHandler.new(old_h)
                end
              end
            end
          end
        end
      end
      
      typesig { [Signal] }
      # Raises a signal in the current process.
      # 
      # @param sig a signal
      # @see sun.misc.Signal#handle(Signal sig, SignalHandler handler)
      def raise(sig)
        if ((self.attr_handlers.get(sig)).nil?)
          raise IllegalArgumentException.new("Unhandled signal: " + RJava.cast_to_string(sig))
        end
        raise0(sig.attr_number)
      end
      
      typesig { [::Java::Int] }
      # Called by the VM to execute Java signal handlers.
      def dispatch(number)
        sig = self.attr_signals.get(number)
        handler = self.attr_handlers.get(sig)
        runnable = Class.new(Runnable.class == Class ? Runnable : Object) do
          local_class_in Signal
          include_class_members Signal
          include Runnable if Runnable.class == Module
          
          typesig { [] }
          define_method :run do
            # Don't bother to reset the priority. Signal handler will
            # run at maximum priority inherited from the VM signal
            # dispatch thread.
            # Thread.currentThread().setPriority(Thread.NORM_PRIORITY);
            handler.handle(sig)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
        if (!(handler).nil?)
          JavaThread.new(runnable, RJava.cast_to_string(sig) + " handler").start
        end
      end
      
      JNI.load_native_method :Java_sun_misc_Signal_findSignal, [:pointer, :long, :long], :int32
      typesig { [String] }
      # Find the signal number, given a name. Returns -1 for unknown signals.
      def find_signal(sig_name)
        JNI.call_native_method(:Java_sun_misc_Signal_findSignal, JNI.env, self.jni_id, sig_name.jni_id)
      end
      
      JNI.load_native_method :Java_sun_misc_Signal_handle0, [:pointer, :long, :int32, :int64], :int64
      typesig { [::Java::Int, ::Java::Long] }
      # Registers a native signal handler, and returns the old handler.
      # Handler values:
      # 0     default handler
      # 1     ignore the signal
      # 2     call back to Signal.dispatch
      # other arbitrary native signal handlers
      def handle0(sig, native_h)
        JNI.call_native_method(:Java_sun_misc_Signal_handle0, JNI.env, self.jni_id, sig.to_int, native_h.to_int)
      end
      
      JNI.load_native_method :Java_sun_misc_Signal_raise0, [:pointer, :long, :int32], :void
      typesig { [::Java::Int] }
      # Raise a given signal number
      def raise0(sig)
        JNI.call_native_method(:Java_sun_misc_Signal_raise0, JNI.env, self.jni_id, sig.to_int)
      end
    }
    
    private
    alias_method :initialize__signal, :initialize
  end
  
end
