require "rjava"

# Copyright 2000-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Logging
  module LevelImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include_const ::Java::Util, :ResourceBundle
    }
  end
  
  # The Level class defines a set of standard logging levels that
  # can be used to control logging output.  The logging Level objects
  # are ordered and are specified by ordered integers.  Enabling logging
  # at a given level also enables logging at all higher levels.
  # <p>
  # Clients should normally use the predefined Level constants such
  # as Level.SEVERE.
  # <p>
  # The levels in descending order are:
  # <ul>
  # <li>SEVERE (highest value)
  # <li>WARNING
  # <li>INFO
  # <li>CONFIG
  # <li>FINE
  # <li>FINER
  # <li>FINEST  (lowest value)
  # </ul>
  # In addition there is a level OFF that can be used to turn
  # off logging, and a level ALL that can be used to enable
  # logging of all messages.
  # <p>
  # It is possible for third parties to define additional logging
  # levels by subclassing Level.  In such cases subclasses should
  # take care to chose unique integer level values and to ensure that
  # they maintain the Object uniqueness property across serialization
  # by defining a suitable readResolve method.
  # 
  # @since 1.4
  class Level 
    include_class_members LevelImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      
      def known
        defined?(@@known) ? @@known : @@known= Java::Util::ArrayList.new
      end
      alias_method :attr_known, :known
      
      def known=(value)
        @@known = value
      end
      alias_method :attr_known=, :known=
      
      
      def default_bundle
        defined?(@@default_bundle) ? @@default_bundle : @@default_bundle= "sun.util.logging.resources.logging"
      end
      alias_method :attr_default_bundle, :default_bundle
      
      def default_bundle=(value)
        @@default_bundle = value
      end
      alias_method :attr_default_bundle=, :default_bundle=
    }
    
    # @serial  The non-localized name of the level.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # @serial  The integer value of the level.
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    # @serial The resource bundle name to be used in localizing the level name.
    attr_accessor :resource_bundle_name
    alias_method :attr_resource_bundle_name, :resource_bundle_name
    undef_method :resource_bundle_name
    alias_method :attr_resource_bundle_name=, :resource_bundle_name=
    undef_method :resource_bundle_name=
    
    class_module.module_eval {
      # OFF is a special level that can be used to turn off logging.
      # This level is initialized to <CODE>Integer.MAX_VALUE</CODE>.
      const_set_lazy(:OFF) { Level.new("OFF", JavaInteger::MAX_VALUE, self.attr_default_bundle) }
      const_attr_reader  :OFF
      
      # SEVERE is a message level indicating a serious failure.
      # <p>
      # In general SEVERE messages should describe events that are
      # of considerable importance and which will prevent normal
      # program execution.   They should be reasonably intelligible
      # to end users and to system administrators.
      # This level is initialized to <CODE>1000</CODE>.
      const_set_lazy(:SEVERE) { Level.new("SEVERE", 1000, self.attr_default_bundle) }
      const_attr_reader  :SEVERE
      
      # WARNING is a message level indicating a potential problem.
      # <p>
      # In general WARNING messages should describe events that will
      # be of interest to end users or system managers, or which
      # indicate potential problems.
      # This level is initialized to <CODE>900</CODE>.
      const_set_lazy(:WARNING) { Level.new("WARNING", 900, self.attr_default_bundle) }
      const_attr_reader  :WARNING
      
      # INFO is a message level for informational messages.
      # <p>
      # Typically INFO messages will be written to the console
      # or its equivalent.  So the INFO level should only be
      # used for reasonably significant messages that will
      # make sense to end users and system admins.
      # This level is initialized to <CODE>800</CODE>.
      const_set_lazy(:INFO) { Level.new("INFO", 800, self.attr_default_bundle) }
      const_attr_reader  :INFO
      
      # CONFIG is a message level for static configuration messages.
      # <p>
      # CONFIG messages are intended to provide a variety of static
      # configuration information, to assist in debugging problems
      # that may be associated with particular configurations.
      # For example, CONFIG message might include the CPU type,
      # the graphics depth, the GUI look-and-feel, etc.
      # This level is initialized to <CODE>700</CODE>.
      const_set_lazy(:CONFIG) { Level.new("CONFIG", 700, self.attr_default_bundle) }
      const_attr_reader  :CONFIG
      
      # FINE is a message level providing tracing information.
      # <p>
      # All of FINE, FINER, and FINEST are intended for relatively
      # detailed tracing.  The exact meaning of the three levels will
      # vary between subsystems, but in general, FINEST should be used
      # for the most voluminous detailed output, FINER for somewhat
      # less detailed output, and FINE for the  lowest volume (and
      # most important) messages.
      # <p>
      # In general the FINE level should be used for information
      # that will be broadly interesting to developers who do not have
      # a specialized interest in the specific subsystem.
      # <p>
      # FINE messages might include things like minor (recoverable)
      # failures.  Issues indicating potential performance problems
      # are also worth logging as FINE.
      # This level is initialized to <CODE>500</CODE>.
      const_set_lazy(:FINE) { Level.new("FINE", 500, self.attr_default_bundle) }
      const_attr_reader  :FINE
      
      # FINER indicates a fairly detailed tracing message.
      # By default logging calls for entering, returning, or throwing
      # an exception are traced at this level.
      # This level is initialized to <CODE>400</CODE>.
      const_set_lazy(:FINER) { Level.new("FINER", 400, self.attr_default_bundle) }
      const_attr_reader  :FINER
      
      # FINEST indicates a highly detailed tracing message.
      # This level is initialized to <CODE>300</CODE>.
      const_set_lazy(:FINEST) { Level.new("FINEST", 300, self.attr_default_bundle) }
      const_attr_reader  :FINEST
      
      # ALL indicates that all messages should be logged.
      # This level is initialized to <CODE>Integer.MIN_VALUE</CODE>.
      const_set_lazy(:ALL) { Level.new("ALL", JavaInteger::MIN_VALUE, self.attr_default_bundle) }
      const_attr_reader  :ALL
    }
    
    typesig { [String, ::Java::Int] }
    # Create a named Level with a given integer value.
    # <p>
    # Note that this constructor is "protected" to allow subclassing.
    # In general clients of logging should use one of the constant Level
    # objects such as SEVERE or FINEST.  However, if clients need to
    # add new logging levels, they may subclass Level and define new
    # constants.
    # @param name  the name of the Level, for example "SEVERE".
    # @param value an integer value for the level.
    # @throws NullPointerException if the name is null
    def initialize(name, value)
      initialize__level(name, value, nil)
    end
    
    typesig { [String, ::Java::Int, String] }
    # Create a named Level with a given integer value and a
    # given localization resource name.
    # <p>
    # @param name  the name of the Level, for example "SEVERE".
    # @param value an integer value for the level.
    # @param resourceBundleName name of a resource bundle to use in
    #    localizing the given name. If the resourceBundleName is null
    #    or an empty string, it is ignored.
    # @throws NullPointerException if the name is null
    def initialize(name, value, resource_bundle_name)
      @name = nil
      @value = 0
      @resource_bundle_name = nil
      if ((name).nil?)
        raise NullPointerException.new
      end
      @name = name
      @value = value
      @resource_bundle_name = resource_bundle_name
      synchronized((Level)) do
        self.attr_known.add(self)
      end
    end
    
    typesig { [] }
    # Return the level's localization resource bundle name, or
    # null if no localization bundle is defined.
    # 
    # @return localization resource bundle name
    def get_resource_bundle_name
      return @resource_bundle_name
    end
    
    typesig { [] }
    # Return the non-localized string name of the Level.
    # 
    # @return non-localized name
    def get_name
      return @name
    end
    
    typesig { [] }
    # Return the localized string name of the Level, for
    # the current default locale.
    # <p>
    # If no localization information is available, the
    # non-localized name is returned.
    # 
    # @return localized name
    def get_localized_name
      begin
        rb = ResourceBundle.get_bundle(@resource_bundle_name)
        return rb.get_string(@name)
      rescue JavaException => ex
        return @name
      end
    end
    
    typesig { [] }
    # @return the non-localized name of the Level, for example "INFO".
    def to_s
      return @name
    end
    
    typesig { [] }
    # Get the integer value for this level.  This integer value
    # can be used for efficient ordering comparisons between
    # Level objects.
    # @return the integer value for this level.
    def int_value
      return @value
    end
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { -8176160795706313070 }
      const_attr_reader  :SerialVersionUID
    }
    
    typesig { [] }
    # Serialization magic to prevent "doppelgangers".
    # This is a performance optimization.
    def read_resolve
      synchronized((Level)) do
        i = 0
        while i < self.attr_known.size
          other = self.attr_known.get(i)
          if ((@name == other.attr_name) && (@value).equal?(other.attr_value) && ((@resource_bundle_name).equal?(other.attr_resource_bundle_name) || (!(@resource_bundle_name).nil? && (@resource_bundle_name == other.attr_resource_bundle_name))))
            return other
          end
          i += 1
        end
        # Woops.  Whoever sent us this object knows
        # about a new log level.  Add it to our list.
        self.attr_known.add(self)
        return self
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Parse a level name string into a Level.
      # <p>
      # The argument string may consist of either a level name
      # or an integer value.
      # <p>
      # For example:
      # <ul>
      # <li>     "SEVERE"
      # <li>     "1000"
      # </ul>
      # @param  name   string to be parsed
      # @throws NullPointerException if the name is null
      # @throws IllegalArgumentException if the value is not valid.
      # Valid values are integers between <CODE>Integer.MIN_VALUE</CODE>
      # and <CODE>Integer.MAX_VALUE</CODE>, and all known level names.
      # Known names are the levels defined by this class (i.e. <CODE>FINE</CODE>,
      # <CODE>FINER</CODE>, <CODE>FINEST</CODE>), or created by this class with
      # appropriate package access, or new levels defined or created
      # by subclasses.
      # 
      # @return The parsed value. Passing an integer that corresponds to a known name
      # (eg 700) will return the associated name (eg <CODE>CONFIG</CODE>).
      # Passing an integer that does not (eg 1) will return a new level name
      # initialized to that value.
      def parse(name)
        synchronized(self) do
          # Check that name is not null.
          name.length
          # Look for a known Level with the given non-localized name.
          i = 0
          while i < self.attr_known.size
            l = self.attr_known.get(i)
            if ((name == l.attr_name))
              return l
            end
            i += 1
          end
          # Now, check if the given name is an integer.  If so,
          # first look for a Level with the given value and then
          # if necessary create one.
          begin
            x = JavaInteger.parse_int(name)
            i_ = 0
            while i_ < self.attr_known.size
              l = self.attr_known.get(i_)
              if ((l.attr_value).equal?(x))
                return l
              end
              i_ += 1
            end
            # Create a new Level.
            return Level.new(name, x)
          rescue NumberFormatException => ex
            # Not an integer.
            # Drop through.
          end
          # Finally, look for a known level with the given localized name,
          # in the current default locale.
          # This is relatively expensive, but not excessively so.
          i__ = 0
          while i__ < self.attr_known.size
            l = self.attr_known.get(i__)
            if ((name == l.get_localized_name))
              return l
            end
            i__ += 1
          end
          # OK, we've tried everything and failed
          raise IllegalArgumentException.new("Bad level \"" + name + "\"")
        end
      end
    }
    
    typesig { [Object] }
    # Compare two objects for value equality.
    # @return true if and only if the two objects have the same level value.
    def ==(ox)
      begin
        lx = ox
        return ((lx.attr_value).equal?(@value))
      rescue JavaException => ex
        return false
      end
    end
    
    typesig { [] }
    # Generate a hashcode.
    # @return a hashcode based on the level value
    def hash_code
      return @value
    end
    
    private
    alias_method :initialize__level, :initialize
  end
  
end
