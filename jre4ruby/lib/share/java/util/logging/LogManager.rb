require "rjava"

# Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module LogManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
      include_const ::Java::Lang::Ref, :WeakReference
      include_const ::Java::Beans, :PropertyChangeListener
      include_const ::Java::Beans, :PropertyChangeSupport
      include_const ::Java::Net, :URL
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # There is a single global LogManager object that is used to
  # maintain a set of shared state about Loggers and log services.
  # <p>
  # This LogManager object:
  # <ul>
  # <li> Manages a hierarchical namespace of Logger objects.  All
  # named Loggers are stored in this namespace.
  # <li> Manages a set of logging control properties.  These are
  # simple key-value pairs that can be used by Handlers and
  # other logging objects to configure themselves.
  # </ul>
  # <p>
  # The global LogManager object can be retrieved using LogManager.getLogManager().
  # The LogManager object is created during class initialization and
  # cannot subsequently be changed.
  # <p>
  # At startup the LogManager class is located using the
  # java.util.logging.manager system property.
  # <p>
  # By default, the LogManager reads its initial configuration from
  # a properties file "lib/logging.properties" in the JRE directory.
  # If you edit that property file you can change the default logging
  # configuration for all uses of that JRE.
  # <p>
  # In addition, the LogManager uses two optional system properties that
  # allow more control over reading the initial configuration:
  # <ul>
  # <li>"java.util.logging.config.class"
  # <li>"java.util.logging.config.file"
  # </ul>
  # These two properties may be set via the Preferences API, or as
  # command line property definitions to the "java" command, or as
  # system property definitions passed to JNI_CreateJavaVM.
  # <p>
  # If the "java.util.logging.config.class" property is set, then the
  # property value is treated as a class name.  The given class will be
  # loaded, an object will be instantiated, and that object's constructor
  # is responsible for reading in the initial configuration.  (That object
  # may use other system properties to control its configuration.)  The
  # alternate configuration class can use <tt>readConfiguration(InputStream)</tt>
  # to define properties in the LogManager.
  # <p>
  # If "java.util.logging.config.class" property is <b>not</b> set,
  # then the "java.util.logging.config.file" system property can be used
  # to specify a properties file (in java.util.Properties format). The
  # initial logging configuration will be read from this file.
  # <p>
  # If neither of these properties is defined then, as described
  # above, the LogManager will read its initial configuration from
  # a properties file "lib/logging.properties" in the JRE directory.
  # <p>
  # The properties for loggers and Handlers will have names starting
  # with the dot-separated name for the handler or logger.
  # <p>
  # The global logging properties may include:
  # <ul>
  # <li>A property "handlers".  This defines a whitespace or comma separated
  # list of class names for handler classes to load and register as
  # handlers on the root Logger (the Logger named "").  Each class
  # name must be for a Handler class which has a default constructor.
  # Note that these Handlers may be created lazily, when they are
  # first used.
  # 
  # <li>A property "&lt;logger&gt;.handlers". This defines a whitespace or
  # comma separated list of class names for handlers classes to
  # load and register as handlers to the specified logger. Each class
  # name must be for a Handler class which has a default constructor.
  # Note that these Handlers may be created lazily, when they are
  # first used.
  # 
  # <li>A property "&lt;logger&gt;.useParentHandlers". This defines a boolean
  # value. By default every logger calls its parent in addition to
  # handling the logging message itself, this often result in messages
  # being handled by the root logger as well. When setting this property
  # to false a Handler needs to be configured for this logger otherwise
  # no logging messages are delivered.
  # 
  # <li>A property "config".  This property is intended to allow
  # arbitrary configuration code to be run.  The property defines a
  # whitespace or comma separated list of class names.  A new instance will be
  # created for each named class.  The default constructor of each class
  # may execute arbitrary code to update the logging configuration, such as
  # setting logger levels, adding handlers, adding filters, etc.
  # </ul>
  # <p>
  # Note that all classes loaded during LogManager configuration are
  # first searched on the system class path before any user class path.
  # That includes the LogManager class, any config classes, and any
  # handler classes.
  # <p>
  # Loggers are organized into a naming hierarchy based on their
  # dot separated names.  Thus "a.b.c" is a child of "a.b", but
  # "a.b1" and a.b2" are peers.
  # <p>
  # All properties whose names end with ".level" are assumed to define
  # log levels for Loggers.  Thus "foo.level" defines a log level for
  # the logger called "foo" and (recursively) for any of its children
  # in the naming hierarchy.  Log Levels are applied in the order they
  # are defined in the properties file.  Thus level settings for child
  # nodes in the tree should come after settings for their parents.
  # The property name ".level" can be used to set the level for the
  # root of the tree.
  # <p>
  # All methods on the LogManager object are multi-thread safe.
  # 
  # @since 1.4
  class LogManager 
    include_class_members LogManagerImports
    
    class_module.module_eval {
      # The global LogManager object
      
      def manager
        defined?(@@manager) ? @@manager : @@manager= nil
      end
      alias_method :attr_manager, :manager
      
      def manager=(value)
        @@manager = value
      end
      alias_method :attr_manager=, :manager=
      
      const_set_lazy(:EmptyHandlers) { Array.typed(Handler).new([]) }
      const_attr_reader  :EmptyHandlers
    }
    
    attr_accessor :props
    alias_method :attr_props, :props
    undef_method :props
    alias_method :attr_props=, :props=
    undef_method :props=
    
    attr_accessor :changes
    alias_method :attr_changes, :changes
    undef_method :changes
    alias_method :attr_changes=, :changes=
    undef_method :changes=
    
    class_module.module_eval {
      const_set_lazy(:DefaultLevel) { Level::INFO }
      const_attr_reader  :DefaultLevel
    }
    
    # Table of known loggers.  Maps names to Loggers.
    attr_accessor :loggers
    alias_method :attr_loggers, :loggers
    undef_method :loggers
    alias_method :attr_loggers=, :loggers=
    undef_method :loggers=
    
    # Tree of known loggers
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    attr_accessor :root_logger
    alias_method :attr_root_logger, :root_logger
    undef_method :root_logger
    alias_method :attr_root_logger=, :root_logger=
    undef_method :root_logger=
    
    # Have we done the primordial reading of the configuration file?
    # (Must be done after a suitable amount of java.lang.System
    # initialization has been done)
    attr_accessor :read_primordial_configuration
    alias_method :attr_read_primordial_configuration, :read_primordial_configuration
    undef_method :read_primordial_configuration
    alias_method :attr_read_primordial_configuration=, :read_primordial_configuration=
    undef_method :read_primordial_configuration=
    
    # Have we initialized global (root) handlers yet?
    # This gets set to false in readConfiguration
    attr_accessor :initialized_global_handlers
    alias_method :attr_initialized_global_handlers, :initialized_global_handlers
    undef_method :initialized_global_handlers
    alias_method :attr_initialized_global_handlers=, :initialized_global_handlers=
    undef_method :initialized_global_handlers=
    
    # True if JVM death is imminent and the exit hook has been called.
    attr_accessor :death_imminent
    alias_method :attr_death_imminent, :death_imminent
    undef_method :death_imminent
    alias_method :attr_death_imminent=, :death_imminent=
    undef_method :death_imminent=
    
    class_module.module_eval {
      when_class_loaded do
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members LogManager
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            cname = nil
            begin
              cname = RJava.cast_to_string(System.get_property("java.util.logging.manager"))
              if (!(cname).nil?)
                begin
                  clz = ClassLoader.get_system_class_loader.load_class(cname)
                  self.attr_manager = clz.new_instance
                rescue self.class::ClassNotFoundException => ex
                  clz_ = JavaThread.current_thread.get_context_class_loader.load_class(cname)
                  self.attr_manager = clz_.new_instance
                end
              end
            rescue self.class::JavaException => ex
              System.err.println("Could not load Logmanager \"" + cname + "\"")
              ex.print_stack_trace
            end
            if ((self.attr_manager).nil?)
              self.attr_manager = self.class::LogManager.new
            end
            # Create and retain Logger for the root of the namespace.
            self.attr_manager.attr_root_logger = RootLogger.new
            self.attr_manager.add_logger(self.attr_manager.attr_root_logger)
            # Adding the global Logger. Doing so in the Logger.<clinit>
            # would deadlock with the LogManager.<clinit>.
            Logger.attr_global.set_log_manager(self.attr_manager)
            self.attr_manager.add_logger(Logger.attr_global)
            # We don't call readConfiguration() here, as we may be running
            # very early in the JVM startup sequence.  Instead readConfiguration
            # will be called lazily in getLogManager().
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      # This private class is used as a shutdown hook.
      # It does a "reset" to close all open handlers.
      const_set_lazy(:Cleaner) { Class.new(JavaThread) do
        extend LocalClass
        include_class_members LogManager
        
        typesig { [] }
        def run
          # This is to ensure the LogManager.<clinit> is completed
          # before synchronized block. Otherwise deadlocks are possible.
          mgr = self.attr_manager
          # If the global handlers haven't been initialized yet, we
          # don't want to initialize them just so we can close them!
          synchronized((@local_class_parent)) do
            # Note that death is imminent.
            self.attr_death_imminent = true
            self.attr_initialized_global_handlers = true
          end
          # Do a reset to close all active handlers.
          reset
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__cleaner, :initialize
      end }
    }
    
    typesig { [] }
    # Protected constructor.  This is protected so that container applications
    # (such as J2EE containers) can subclass the object.  It is non-public as
    # it is intended that there only be one LogManager object, whose value is
    # retrieved by calling Logmanager.getLogManager.
    def initialize
      @props = Properties.new
      @changes = PropertyChangeSupport.new(LogManager)
      @loggers = Hashtable.new
      @root = LogNode.new(nil)
      @root_logger = nil
      @read_primordial_configuration = false
      @initialized_global_handlers = true
      @death_imminent = false
      @our_permission = LoggingPermission.new("control", nil)
      # Add a shutdown hook to close the global handlers.
      begin
        Runtime.get_runtime.add_shutdown_hook(Cleaner.new_local(self))
      rescue IllegalStateException => e
        # If the VM is already shutting down,
        # We do not need to register shutdownHook.
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      # Return the global LogManager object.
      def get_log_manager
        if (!(self.attr_manager).nil?)
          self.attr_manager.read_primordial_configuration
        end
        return self.attr_manager
      end
    }
    
    typesig { [] }
    def read_primordial_configuration
      if (!@read_primordial_configuration)
        synchronized((self)) do
          if (!@read_primordial_configuration)
            # If System.in/out/err are null, it's a good
            # indication that we're still in the
            # bootstrapping phase
            if ((System.out).nil?)
              return
            end
            @read_primordial_configuration = true
            begin
              AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members LogManager
                include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  read_configuration
                  return nil
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self))
            rescue JavaException => ex
              # System.err.println("Can't read logging configuration:");
              # ex.printStackTrace();
            end
          end
        end
      end
    end
    
    typesig { [PropertyChangeListener] }
    # Adds an event listener to be invoked when the logging
    # properties are re-read. Adding multiple instances of
    # the same event Listener results in multiple entries
    # in the property event listener table.
    # 
    # @param l  event listener
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    # @exception NullPointerException if the PropertyChangeListener is null.
    def add_property_change_listener(l)
      if ((l).nil?)
        raise NullPointerException.new
      end
      check_access
      @changes.add_property_change_listener(l)
    end
    
    typesig { [PropertyChangeListener] }
    # Removes an event listener for property change events.
    # If the same listener instance has been added to the listener table
    # through multiple invocations of <CODE>addPropertyChangeListener</CODE>,
    # then an equivalent number of
    # <CODE>removePropertyChangeListener</CODE> invocations are required to remove
    # all instances of that listener from the listener table.
    # <P>
    # Returns silently if the given listener is not found.
    # 
    # @param l  event listener (can be null)
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def remove_property_change_listener(l)
      check_access
      @changes.remove_property_change_listener(l)
    end
    
    typesig { [String] }
    # Package-level method.
    # Find or create a specified logger instance. If a logger has
    # already been created with the given name it is returned.
    # Otherwise a new logger instance is created and registered
    # in the LogManager global namespace.
    def demand_logger(name)
      synchronized(self) do
        result = get_logger(name)
        if ((result).nil?)
          result = Logger.new(name, nil)
          add_logger(result)
          result = get_logger(name)
        end
        return result
      end
    end
    
    typesig { [Logger, String] }
    # If logger.getUseParentHandlers() returns 'true' and any of the logger's
    # parents have levels or handlers defined, make sure they are instantiated.
    def process_parent_handlers(logger, name)
      ix = 1
      loop do
        ix2 = name.index_of(".", ix)
        if (ix2 < 0)
          break
        end
        pname = name.substring(0, ix2)
        if (!(get_property(pname + ".level")).nil? || !(get_property(pname + ".handlers")).nil?)
          # This pname has a level/handlers definition.
          # Make sure it exists.
          demand_logger(pname)
        end
        ix = ix2 + 1
      end
    end
    
    typesig { [Logger, String, String] }
    # Add new per logger handlers.
    # We need to raise privilege here. All our decisions will
    # be made based on the logging configuration, which can
    # only be modified by trusted code.
    def load_logger_handlers(logger, name, handlers_property_name)
      AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members LogManager
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          if (!(logger).equal?(self.attr_root_logger))
            use_parent = get_boolean_property(name + ".useParentHandlers", true)
            if (!use_parent)
              logger.set_use_parent_handlers(false)
            end
          end
          names = parse_class_names(handlers_property_name)
          i = 0
          while i < names.attr_length
            word = names[i]
            begin
              clz = ClassLoader.get_system_class_loader.load_class(word)
              hdl = clz.new_instance
              begin
                # Check if there is a property defining the
                # this handler's level.
                levs = get_property(word + ".level")
                if (!(levs).nil?)
                  hdl.set_level(Level.parse(levs))
                end
              rescue self.class::JavaException => ex
                System.err.println("Can't set level for " + word)
                # Probably a bad level. Drop through.
              end
              # Add this Handler to the logger
              logger.add_handler(hdl)
            rescue self.class::JavaException => ex
              System.err.println("Can't load log handler \"" + word + "\"")
              System.err.println("" + RJava.cast_to_string(ex))
              ex.print_stack_trace
            end
            i += 1
          end
          return nil
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [Logger] }
    # Add a named logger.  This does nothing and returns false if a logger
    # with the same name is already registered.
    # <p>
    # The Logger factory methods call this method to register each
    # newly created Logger.
    # <p>
    # The application should retain its own reference to the Logger
    # object to avoid it being garbage collected.  The LogManager
    # may only retain a weak reference.
    # 
    # @param   logger the new logger.
    # @return  true if the argument logger was registered successfully,
    # false if a logger of that name already exists.
    # @exception NullPointerException if the logger name is null.
    def add_logger(logger)
      synchronized(self) do
        name = logger.get_name
        if ((name).nil?)
          raise NullPointerException.new
        end
        ref = @loggers.get(name)
        if (!(ref).nil?)
          if ((ref.get).nil?)
            # Hashtable holds stale weak reference
            # to a logger which has been GC-ed.
            # Allow to register new one.
            @loggers.remove(name)
          else
            # We already have a registered logger with the given name.
            return false
          end
        end
        # We're adding a new logger.
        # Note that we are creating a weak reference here.
        @loggers.put(name, WeakReference.new(logger))
        # Apply any initial level defined for the new logger.
        level = get_level_property(name + ".level", nil)
        if (!(level).nil?)
          do_set_level(logger, level)
        end
        # Do we have a per logger handler too?
        # Note: this will add a 200ms penalty
        load_logger_handlers(logger, name, name + ".handlers")
        process_parent_handlers(logger, name)
        # Find the new node and its parent.
        node = find_node(name)
        node.attr_logger_ref = WeakReference.new(logger)
        parent = nil
        nodep = node.attr_parent
        while (!(nodep).nil?)
          node_ref = nodep.attr_logger_ref
          if (!(node_ref).nil?)
            parent = node_ref.get
            if (!(parent).nil?)
              break
            end
          end
          nodep = nodep.attr_parent
        end
        if (!(parent).nil?)
          do_set_parent(logger, parent)
        end
        # Walk over the children and tell them we are their new parent.
        node.walk_and_set_parent(logger)
        return true
      end
    end
    
    class_module.module_eval {
      typesig { [Logger, Level] }
      # Private method to set a level on a logger.
      # If necessary, we raise privilege before doing the call.
      def do_set_level(logger, level)
        sm = System.get_security_manager
        if ((sm).nil?)
          # There is no security manager, so things are easy.
          logger.set_level(level)
          return
        end
        AccessController.do_privileged(# There is a security manager.  Raise privilege before
        # calling setLevel.
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members LogManager
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            logger.set_level(level)
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [Logger, Logger] }
      # Private method to set a parent on a logger.
      # If necessary, we raise privilege before doing the setParent call.
      def do_set_parent(logger, parent)
        sm = System.get_security_manager
        if ((sm).nil?)
          # There is no security manager, so things are easy.
          logger.set_parent(parent)
          return
        end
        AccessController.do_privileged(# There is a security manager.  Raise privilege before
        # calling setParent.
        Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members LogManager
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            logger.set_parent(parent)
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
    }
    
    typesig { [String] }
    # Find a node in our tree of logger nodes.
    # If necessary, create it.
    def find_node(name)
      if ((name).nil? || (name == ""))
        return @root
      end
      node = @root
      while (name.length > 0)
        ix = name.index_of(".")
        head = nil
        if (ix > 0)
          head = RJava.cast_to_string(name.substring(0, ix))
          name = RJava.cast_to_string(name.substring(ix + 1))
        else
          head = name
          name = ""
        end
        if ((node.attr_children).nil?)
          node.attr_children = HashMap.new
        end
        child = node.attr_children.get(head)
        if ((child).nil?)
          child = LogNode.new(node)
          node.attr_children.put(head, child)
        end
        node = child
      end
      return node
    end
    
    typesig { [String] }
    # Method to find a named logger.
    # <p>
    # Note that since untrusted code may create loggers with
    # arbitrary names this method should not be relied on to
    # find Loggers for security sensitive logging.
    # <p>
    # @param name name of the logger
    # @return  matching logger or null if none is found
    def get_logger(name)
      synchronized(self) do
        ref = @loggers.get(name)
        if ((ref).nil?)
          return nil
        end
        logger = ref.get
        if ((logger).nil?)
          # Hashtable holds stale weak reference
          # to a logger which has been GC-ed.
          @loggers.remove(name)
        end
        return logger
      end
    end
    
    typesig { [] }
    # Get an enumeration of known logger names.
    # <p>
    # Note:  Loggers may be added dynamically as new classes are loaded.
    # This method only reports on the loggers that are currently registered.
    # <p>
    # @return  enumeration of logger name strings
    def get_logger_names
      synchronized(self) do
        return @loggers.keys
      end
    end
    
    typesig { [] }
    # Reinitialize the logging properties and reread the logging configuration.
    # <p>
    # The same rules are used for locating the configuration properties
    # as are used at startup.  So normally the logging properties will
    # be re-read from the same file that was used at startup.
    # <P>
    # Any log level definitions in the new configuration file will be
    # applied using Logger.setLevel(), if the target Logger exists.
    # <p>
    # A PropertyChangeEvent will be fired after the properties are read.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    # @exception  IOException if there are IO problems reading the configuration.
    def read_configuration
      check_access
      # if a configuration class is specified, load it and use it.
      cname = System.get_property("java.util.logging.config.class")
      if (!(cname).nil?)
        begin
          # Instantiate the named class.  It is its constructor's
          # responsibility to initialize the logging configuration, by
          # calling readConfiguration(InputStream) with a suitable stream.
          begin
            clz = ClassLoader.get_system_class_loader.load_class(cname)
            clz.new_instance
            return
          rescue ClassNotFoundException => ex
            clz_ = JavaThread.current_thread.get_context_class_loader.load_class(cname)
            clz_.new_instance
            return
          end
        rescue JavaException => ex
          System.err.println("Logging configuration class \"" + cname + "\" failed")
          System.err.println("" + RJava.cast_to_string(ex))
          # keep going and useful config file.
        end
      end
      fname = System.get_property("java.util.logging.config.file")
      if ((fname).nil?)
        fname = RJava.cast_to_string(System.get_property("java.home"))
        if ((fname).nil?)
          raise JavaError.new("Can't find java.home ??")
        end
        f = JavaFile.new(fname, "lib")
        f = JavaFile.new(f, "logging.properties")
        fname = RJava.cast_to_string(f.get_canonical_path)
      end
      in_ = FileInputStream.new(fname)
      bin = BufferedInputStream.new(in_)
      begin
        read_configuration(bin)
      ensure
        if (!(in_).nil?)
          in_.close
        end
      end
    end
    
    typesig { [] }
    # Reset the logging configuration.
    # <p>
    # For all named loggers, the reset operation removes and closes
    # all Handlers and (except for the root logger) sets the level
    # to null.  The root logger's level is set to Level.INFO.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def reset
      check_access
      synchronized((self)) do
        @props = Properties.new
        # Since we are doing a reset we no longer want to initialize
        # the global handlers, if they haven't been initialized yet.
        @initialized_global_handlers = true
      end
      enum_ = get_logger_names
      while (enum_.has_more_elements)
        name = enum_.next_element
        reset_logger(name)
      end
    end
    
    typesig { [String] }
    # Private method to reset an individual target logger.
    def reset_logger(name)
      logger = get_logger(name)
      if ((logger).nil?)
        return
      end
      # Close all the Logger's handlers.
      targets = logger.get_handlers
      i = 0
      while i < targets.attr_length
        h = targets[i]
        logger.remove_handler(h)
        begin
          h.close
        rescue JavaException => ex
          # Problems closing a handler?  Keep going...
        end
        i += 1
      end
      if (!(name).nil? && (name == ""))
        # This is the root logger.
        logger.set_level(DefaultLevel)
      else
        logger.set_level(nil)
      end
    end
    
    typesig { [String] }
    # get a list of whitespace separated classnames from a property.
    def parse_class_names(property_name)
      hands = get_property(property_name)
      if ((hands).nil?)
        return Array.typed(String).new(0) { nil }
      end
      hands = RJava.cast_to_string(hands.trim)
      ix = 0
      result = Vector.new
      while (ix < hands.length)
        end_ = ix
        while (end_ < hands.length)
          if (Character.is_whitespace(hands.char_at(end_)))
            break
          end
          if ((hands.char_at(end_)).equal?(Character.new(?,.ord)))
            break
          end
          end_ += 1
        end
        word = hands.substring(ix, end_)
        ix = end_ + 1
        word = RJava.cast_to_string(word.trim)
        if ((word.length).equal?(0))
          next
        end
        result.add(word)
      end
      return result.to_array(Array.typed(String).new(result.size) { nil })
    end
    
    typesig { [InputStream] }
    # Reinitialize the logging properties and reread the logging configuration
    # from the given stream, which should be in java.util.Properties format.
    # A PropertyChangeEvent will be fired after the properties are read.
    # <p>
    # Any log level definitions in the new configuration file will be
    # applied using Logger.setLevel(), if the target Logger exists.
    # 
    # @param ins       stream to read properties from
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    # @exception  IOException if there are problems reading from the stream.
    def read_configuration(ins)
      check_access
      reset
      # Load the properties
      @props.load(ins)
      # Instantiate new configuration objects.
      names = parse_class_names("config")
      i = 0
      while i < names.attr_length
        word = names[i]
        begin
          clz = ClassLoader.get_system_class_loader.load_class(word)
          clz.new_instance
        rescue JavaException => ex
          System.err.println("Can't load config class \"" + word + "\"")
          System.err.println("" + RJava.cast_to_string(ex))
          # ex.printStackTrace();
        end
        i += 1
      end
      # Set levels on any pre-existing loggers, based on the new properties.
      set_levels_on_existing_loggers
      # Notify any interested parties that our properties have changed.
      @changes.fire_property_change(nil, nil, nil)
      # Note that we need to reinitialize global handles when
      # they are first referenced.
      synchronized((self)) do
        @initialized_global_handlers = false
      end
    end
    
    typesig { [String] }
    # Get the value of a logging property.
    # The method returns null if the property is not found.
    # @param name      property name
    # @return          property value
    def get_property(name)
      return @props.get_property(name)
    end
    
    typesig { [String, String] }
    # Package private method to get a String property.
    # If the property is not defined we return the given
    # default value.
    def get_string_property(name, default_value)
      val = get_property(name)
      if ((val).nil?)
        return default_value
      end
      return val.trim
    end
    
    typesig { [String, ::Java::Int] }
    # Package private method to get an integer property.
    # If the property is not defined or cannot be parsed
    # we return the given default value.
    def get_int_property(name, default_value)
      val = get_property(name)
      if ((val).nil?)
        return default_value
      end
      begin
        return JavaInteger.parse_int(val.trim)
      rescue JavaException => ex
        return default_value
      end
    end
    
    typesig { [String, ::Java::Boolean] }
    # Package private method to get a boolean property.
    # If the property is not defined or cannot be parsed
    # we return the given default value.
    def get_boolean_property(name, default_value)
      val = get_property(name)
      if ((val).nil?)
        return default_value
      end
      val = RJava.cast_to_string(val.to_lower_case)
      if ((val == "true") || (val == "1"))
        return true
      else
        if ((val == "false") || (val == "0"))
          return false
        end
      end
      return default_value
    end
    
    typesig { [String, Level] }
    # Package private method to get a Level property.
    # If the property is not defined or cannot be parsed
    # we return the given default value.
    def get_level_property(name, default_value)
      val = get_property(name)
      if ((val).nil?)
        return default_value
      end
      begin
        return Level.parse(val.trim)
      rescue JavaException => ex
        return default_value
      end
    end
    
    typesig { [String, Filter] }
    # Package private method to get a filter property.
    # We return an instance of the class named by the "name"
    # property. If the property is not defined or has problems
    # we return the defaultValue.
    def get_filter_property(name, default_value)
      val = get_property(name)
      begin
        if (!(val).nil?)
          clz = ClassLoader.get_system_class_loader.load_class(val)
          return clz.new_instance
        end
      rescue JavaException => ex
        # We got one of a variety of exceptions in creating the
        # class or creating an instance.
        # Drop through.
      end
      # We got an exception.  Return the defaultValue.
      return default_value
    end
    
    typesig { [String, Formatter] }
    # Package private method to get a formatter property.
    # We return an instance of the class named by the "name"
    # property. If the property is not defined or has problems
    # we return the defaultValue.
    def get_formatter_property(name, default_value)
      val = get_property(name)
      begin
        if (!(val).nil?)
          clz = ClassLoader.get_system_class_loader.load_class(val)
          return clz.new_instance
        end
      rescue JavaException => ex
        # We got one of a variety of exceptions in creating the
        # class or creating an instance.
        # Drop through.
      end
      # We got an exception.  Return the defaultValue.
      return default_value
    end
    
    typesig { [] }
    # Private method to load the global handlers.
    # We do the real work lazily, when the global handlers
    # are first used.
    def initialize_global_handlers
      synchronized(self) do
        if (@initialized_global_handlers)
          return
        end
        @initialized_global_handlers = true
        if (@death_imminent)
          # Aaargh...
          # The VM is shutting down and our exit hook has been called.
          # Avoid allocating global handlers.
          return
        end
        load_logger_handlers(@root_logger, nil, "handlers")
      end
    end
    
    attr_accessor :our_permission
    alias_method :attr_our_permission, :our_permission
    undef_method :our_permission
    alias_method :attr_our_permission=, :our_permission=
    undef_method :our_permission=
    
    typesig { [] }
    # Check that the current context is trusted to modify the logging
    # configuration.  This requires LoggingPermission("control").
    # <p>
    # If the check fails we throw a SecurityException, otherwise
    # we return normally.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def check_access
      sm = System.get_security_manager
      if ((sm).nil?)
        return
      end
      sm.check_permission(@our_permission)
    end
    
    class_module.module_eval {
      # Nested class to represent a node in our tree of named loggers.
      const_set_lazy(:LogNode) { Class.new do
        include_class_members LogManager
        
        attr_accessor :children
        alias_method :attr_children, :children
        undef_method :children
        alias_method :attr_children=, :children=
        undef_method :children=
        
        attr_accessor :logger_ref
        alias_method :attr_logger_ref, :logger_ref
        undef_method :logger_ref
        alias_method :attr_logger_ref=, :logger_ref=
        undef_method :logger_ref=
        
        attr_accessor :parent
        alias_method :attr_parent, :parent
        undef_method :parent
        alias_method :attr_parent=, :parent=
        undef_method :parent=
        
        typesig { [class_self::LogNode] }
        def initialize(parent)
          @children = nil
          @logger_ref = nil
          @parent = nil
          @parent = parent
        end
        
        typesig { [class_self::Logger] }
        # Recursive method to walk the tree below a node and set
        # a new parent logger.
        def walk_and_set_parent(parent)
          if ((@children).nil?)
            return
          end
          values_ = @children.values.iterator
          while (values_.has_next)
            node = values_.next_
            ref = node.attr_logger_ref
            logger = ((ref).nil?) ? nil : ref.get
            if ((logger).nil?)
              node.walk_and_set_parent(parent)
            else
              do_set_parent(logger, parent)
            end
          end
        end
        
        private
        alias_method :initialize__log_node, :initialize
      end }
      
      # We use a subclass of Logger for the root logger, so
      # that we only instantiate the global handlers when they
      # are first needed.
      const_set_lazy(:RootLogger) { Class.new(Logger) do
        extend LocalClass
        include_class_members LogManager
        
        typesig { [] }
        def initialize
          super("", nil)
          set_level(DefaultLevel)
        end
        
        typesig { [class_self::LogRecord] }
        def log(record)
          # Make sure that the global handlers have been instantiated.
          initialize_global_handlers
          super(record)
        end
        
        typesig { [class_self::Handler] }
        def add_handler(h)
          initialize_global_handlers
          super(h)
        end
        
        typesig { [class_self::Handler] }
        def remove_handler(h)
          initialize_global_handlers
          super(h)
        end
        
        typesig { [] }
        def get_handlers
          initialize_global_handlers
          return super
        end
        
        private
        alias_method :initialize__root_logger, :initialize
      end }
    }
    
    typesig { [] }
    # Private method to be called when the configuration has
    # changed to apply any level settings to any pre-existing loggers.
    def set_levels_on_existing_loggers
      synchronized(self) do
        enum_ = @props.property_names
        while (enum_.has_more_elements)
          key = enum_.next_element
          if (!key.ends_with(".level"))
            # Not a level definition.
            next
          end
          ix = key.length - 6
          name = key.substring(0, ix)
          level = get_level_property(key, nil)
          if ((level).nil?)
            System.err.println("Bad level value for property: " + key)
            next
          end
          l = get_logger(name)
          if ((l).nil?)
            next
          end
          l.set_level(level)
        end
      end
    end
    
    class_module.module_eval {
      # Management Support
      
      def logging_mxbean
        defined?(@@logging_mxbean) ? @@logging_mxbean : @@logging_mxbean= nil
      end
      alias_method :attr_logging_mxbean, :logging_mxbean
      
      def logging_mxbean=(value)
        @@logging_mxbean = value
      end
      alias_method :attr_logging_mxbean=, :logging_mxbean=
      
      # String representation of the
      # {@link javax.management.ObjectName} for {@link LoggingMXBean}.
      # @since 1.5
      const_set_lazy(:LOGGING_MXBEAN_NAME) { "java.util.logging:type=Logging" }
      const_attr_reader  :LOGGING_MXBEAN_NAME
      
      typesig { [] }
      # Returns <tt>LoggingMXBean</tt> for managing loggers.
      # The <tt>LoggingMXBean</tt> can also obtained from the
      # {@link java.lang.management.ManagementFactory#getPlatformMBeanServer
      # platform <tt>MBeanServer</tt>} method.
      # 
      # @return a {@link LoggingMXBean} object.
      # 
      # @see java.lang.management.ManagementFactory
      # @since 1.5
      def get_logging_mxbean
        synchronized(self) do
          if ((self.attr_logging_mxbean).nil?)
            self.attr_logging_mxbean = Logging.new
          end
          return self.attr_logging_mxbean
        end
      end
    }
    
    private
    alias_method :initialize__log_manager, :initialize
  end
  
end
