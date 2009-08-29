require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module LoggerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Util
      include ::Java::Security
      include_const ::Java::Lang::Ref, :WeakReference
    }
  end
  
  # A Logger object is used to log messages for a specific
  # system or application component.  Loggers are normally named,
  # using a hierarchical dot-separated namespace.  Logger names
  # can be arbitrary strings, but they should normally be based on
  # the package name or class name of the logged component, such
  # as java.net or javax.swing.  In addition it is possible to create
  # "anonymous" Loggers that are not stored in the Logger namespace.
  # <p>
  # Logger objects may be obtained by calls on one of the getLogger
  # factory methods.  These will either create a new Logger or
  # return a suitable existing Logger.
  # <p>
  # Logging messages will be forwarded to registered Handler
  # objects, which can forward the messages to a variety of
  # destinations, including consoles, files, OS logs, etc.
  # <p>
  # Each Logger keeps track of a "parent" Logger, which is its
  # nearest existing ancestor in the Logger namespace.
  # <p>
  # Each Logger has a "Level" associated with it.  This reflects
  # a minimum Level that this logger cares about.  If a Logger's
  # level is set to <tt>null</tt>, then its effective level is inherited
  # from its parent, which may in turn obtain it recursively from its
  # parent, and so on up the tree.
  # <p>
  # The log level can be configured based on the properties from the
  # logging configuration file, as described in the description
  # of the LogManager class.  However it may also be dynamically changed
  # by calls on the Logger.setLevel method.  If a logger's level is
  # changed the change may also affect child loggers, since any child
  # logger that has <tt>null</tt> as its level will inherit its
  # effective level from its parent.
  # <p>
  # On each logging call the Logger initially performs a cheap
  # check of the request level (e.g. SEVERE or FINE) against the
  # effective log level of the logger.  If the request level is
  # lower than the log level, the logging call returns immediately.
  # <p>
  # After passing this initial (cheap) test, the Logger will allocate
  # a LogRecord to describe the logging message.  It will then call a
  # Filter (if present) to do a more detailed check on whether the
  # record should be published.  If that passes it will then publish
  # the LogRecord to its output Handlers.  By default, loggers also
  # publish to their parent's Handlers, recursively up the tree.
  # <p>
  # Each Logger may have a ResourceBundle name associated with it.
  # The named bundle will be used for localizing logging messages.
  # If a Logger does not have its own ResourceBundle name, then
  # it will inherit the ResourceBundle name from its parent,
  # recursively up the tree.
  # <p>
  # Most of the logger output methods take a "msg" argument.  This
  # msg argument may be either a raw value or a localization key.
  # During formatting, if the logger has (or inherits) a localization
  # ResourceBundle and if the ResourceBundle has a mapping for the msg
  # string, then the msg string is replaced by the localized value.
  # Otherwise the original msg string is used.  Typically, formatters use
  # java.text.MessageFormat style formatting to format parameters, so
  # for example a format string "{0} {1}" would format two parameters
  # as strings.
  # <p>
  # When mapping ResourceBundle names to ResourceBundles, the Logger
  # will first try to use the Thread's ContextClassLoader.  If that
  # is null it will try the SystemClassLoader instead.  As a temporary
  # transition feature in the initial implementation, if the Logger is
  # unable to locate a ResourceBundle from the ContextClassLoader or
  # SystemClassLoader the Logger will also search up the class stack
  # and use successive calling ClassLoaders to try to locate a ResourceBundle.
  # (This call stack search is to allow containers to transition to
  # using ContextClassLoaders and is likely to be removed in future
  # versions.)
  # <p>
  # Formatting (including localization) is the responsibility of
  # the output Handler, which will typically call a Formatter.
  # <p>
  # Note that formatting need not occur synchronously.  It may be delayed
  # until a LogRecord is actually written to an external sink.
  # <p>
  # The logging methods are grouped in five main categories:
  # <ul>
  # <li><p>
  # There are a set of "log" methods that take a log level, a message
  # string, and optionally some parameters to the message string.
  # <li><p>
  # There are a set of "logp" methods (for "log precise") that are
  # like the "log" methods, but also take an explicit source class name
  # and method name.
  # <li><p>
  # There are a set of "logrb" method (for "log with resource bundle")
  # that are like the "logp" method, but also take an explicit resource
  # bundle name for use in localizing the log message.
  # <li><p>
  # There are convenience methods for tracing method entries (the
  # "entering" methods), method returns (the "exiting" methods) and
  # throwing exceptions (the "throwing" methods).
  # <li><p>
  # Finally, there are a set of convenience methods for use in the
  # very simplest cases, when a developer simply wants to log a
  # simple string at a given log level.  These methods are named
  # after the standard Level names ("severe", "warning", "info", etc.)
  # and take a single argument, a message string.
  # </ul>
  # <p>
  # For the methods that do not take an explicit source name and
  # method name, the Logging framework will make a "best effort"
  # to determine which class and method called into the logging method.
  # However, it is important to realize that this automatically inferred
  # information may only be approximate (or may even be quite wrong!).
  # Virtual machines are allowed to do extensive optimizations when
  # JITing and may entirely remove stack frames, making it impossible
  # to reliably locate the calling class and method.
  # <P>
  # All methods on Logger are multi-thread safe.
  # <p>
  # <b>Subclassing Information:</b> Note that a LogManager class may
  # provide its own implementation of named Loggers for any point in
  # the namespace.  Therefore, any subclasses of Logger (unless they
  # are implemented in conjunction with a new LogManager class) should
  # take care to obtain a Logger instance from the LogManager class and
  # should delegate operations such as "isLoggable" and "log(LogRecord)"
  # to that instance.  Note that in order to intercept all logging
  # output, subclasses need only override the log(LogRecord) method.
  # All the other logging methods are implemented as calls on this
  # log(LogRecord) method.
  # 
  # @since 1.4
  class Logger 
    include_class_members LoggerImports
    
    class_module.module_eval {
      const_set_lazy(:EmptyHandlers) { Array.typed(Handler).new(0) { nil } }
      const_attr_reader  :EmptyHandlers
      
      const_set_lazy(:OffValue) { Level::OFF.int_value }
      const_attr_reader  :OffValue
    }
    
    attr_accessor :manager
    alias_method :attr_manager, :manager
    undef_method :manager
    alias_method :attr_manager=, :manager=
    undef_method :manager=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :handlers
    alias_method :attr_handlers, :handlers
    undef_method :handlers
    alias_method :attr_handlers=, :handlers=
    undef_method :handlers=
    
    attr_accessor :resource_bundle_name
    alias_method :attr_resource_bundle_name, :resource_bundle_name
    undef_method :resource_bundle_name
    alias_method :attr_resource_bundle_name=, :resource_bundle_name=
    undef_method :resource_bundle_name=
    
    attr_accessor :use_parent_handlers
    alias_method :attr_use_parent_handlers, :use_parent_handlers
    undef_method :use_parent_handlers
    alias_method :attr_use_parent_handlers=, :use_parent_handlers=
    undef_method :use_parent_handlers=
    
    attr_accessor :filter
    alias_method :attr_filter, :filter
    undef_method :filter
    alias_method :attr_filter=, :filter=
    undef_method :filter=
    
    attr_accessor :anonymous
    alias_method :attr_anonymous, :anonymous
    undef_method :anonymous
    alias_method :attr_anonymous=, :anonymous=
    undef_method :anonymous=
    
    attr_accessor :catalog
    alias_method :attr_catalog, :catalog
    undef_method :catalog
    alias_method :attr_catalog=, :catalog=
    undef_method :catalog=
    
    # Cached resource bundle
    attr_accessor :catalog_name
    alias_method :attr_catalog_name, :catalog_name
    undef_method :catalog_name
    alias_method :attr_catalog_name=, :catalog_name=
    undef_method :catalog_name=
    
    # name associated with catalog
    attr_accessor :catalog_locale
    alias_method :attr_catalog_locale, :catalog_locale
    undef_method :catalog_locale
    alias_method :attr_catalog_locale=, :catalog_locale=
    undef_method :catalog_locale=
    
    class_module.module_eval {
      # locale associated with catalog
      # The fields relating to parent-child relationships and levels
      # are managed under a separate lock, the treeLock.
      
      def tree_lock
        defined?(@@tree_lock) ? @@tree_lock : @@tree_lock= Object.new
      end
      alias_method :attr_tree_lock, :tree_lock
      
      def tree_lock=(value)
        @@tree_lock = value
      end
      alias_method :attr_tree_lock=, :tree_lock=
    }
    
    # We keep weak references from parents to children, but strong
    # references from children to parents.
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    # our nearest parent.
    attr_accessor :kids
    alias_method :attr_kids, :kids
    undef_method :kids
    alias_method :attr_kids=, :kids=
    undef_method :kids=
    
    # WeakReferences to loggers that have us as parent
    attr_accessor :level_object
    alias_method :attr_level_object, :level_object
    undef_method :level_object
    alias_method :attr_level_object=, :level_object=
    undef_method :level_object=
    
    attr_accessor :level_value
    alias_method :attr_level_value, :level_value
    undef_method :level_value
    alias_method :attr_level_value=, :level_value=
    undef_method :level_value=
    
    class_module.module_eval {
      # current effective level value
      # 
      # GLOBAL_LOGGER_NAME is a name for the global logger.
      # This name is provided as a convenience to developers who are making
      # casual use of the Logging package.  Developers who are making serious
      # use of the logging package (for example in products) should create
      # and use their own Logger objects, with appropriate names, so that
      # logging can be controlled on a suitable per-Logger granularity.
      # <p>
      # The preferred way to get the global logger object is via the call
      # <code>Logger.getLogger(Logger.GLOBAL_LOGGER_NAME)</code>.
      # @since 1.6
      const_set_lazy(:GLOBAL_LOGGER_NAME) { "global" }
      const_attr_reader  :GLOBAL_LOGGER_NAME
      
      # The "global" Logger object is provided as a convenience to developers
      # who are making casual use of the Logging package.  Developers
      # who are making serious use of the logging package (for example
      # in products) should create and use their own Logger objects,
      # with appropriate names, so that logging can be controlled on a
      # suitable per-Logger granularity.
      # <p>
      # @deprecated Initialization of this field is prone to deadlocks.
      # The field must be initialized by the Logger class initialization
      # which may cause deadlocks with the LogManager class initialization.
      # In such cases two class initialization wait for each other to complete.
      # As of JDK version 1.6, the preferred way to get the global logger object
      # is via the call <code>Logger.getLogger(Logger.GLOBAL_LOGGER_NAME)</code>.
      const_set_lazy(:Global) { Logger.new(GLOBAL_LOGGER_NAME) }
      const_attr_reader  :Global
    }
    
    typesig { [String, String] }
    # Protected method to construct a logger for a named subsystem.
    # <p>
    # The logger will be initially configured with a null Level
    # and with useParentHandlers true.
    # 
    # @param   name    A name for the logger.  This should
    # be a dot-separated name and should normally
    # be based on the package name or class name
    # of the subsystem, such as java.net
    # or javax.swing.  It may be null for anonymous Loggers.
    # @param   resourceBundleName  name of ResourceBundle to be used for localizing
    # messages for this logger.  May be null if none
    # of the messages require localization.
    # @throws MissingResourceException if the ResourceBundleName is non-null and
    # no corresponding resource can be found.
    def initialize(name, resource_bundle_name)
      @manager = nil
      @name = nil
      @handlers = nil
      @resource_bundle_name = nil
      @use_parent_handlers = true
      @filter = nil
      @anonymous = false
      @catalog = nil
      @catalog_name = nil
      @catalog_locale = nil
      @parent = nil
      @kids = nil
      @level_object = nil
      @level_value = 0
      @manager = LogManager.get_log_manager
      if (!(resource_bundle_name).nil?)
        # Note: we may get a MissingResourceException here.
        setup_resource_info(resource_bundle_name)
      end
      @name = name
      @level_value = Level::INFO.int_value
    end
    
    typesig { [String] }
    # This constructor is used only to create the global Logger.
    # It is needed to break a cyclic dependence between the LogManager
    # and Logger static initializers causing deadlocks.
    def initialize(name)
      @manager = nil
      @name = nil
      @handlers = nil
      @resource_bundle_name = nil
      @use_parent_handlers = true
      @filter = nil
      @anonymous = false
      @catalog = nil
      @catalog_name = nil
      @catalog_locale = nil
      @parent = nil
      @kids = nil
      @level_object = nil
      @level_value = 0
      # The manager field is not initialized here.
      @name = name
      @level_value = Level::INFO.int_value
    end
    
    typesig { [LogManager] }
    # It is called from the LogManager.<clinit> to complete
    # initialization of the global Logger.
    def set_log_manager(manager)
      @manager = manager
    end
    
    typesig { [] }
    def check_access
      if (!@anonymous)
        if ((@manager).nil?)
          # Complete initialization of the global Logger.
          @manager = LogManager.get_log_manager
        end
        @manager.check_access
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Find or create a logger for a named subsystem.  If a logger has
      # already been created with the given name it is returned.  Otherwise
      # a new logger is created.
      # <p>
      # If a new logger is created its log level will be configured
      # based on the LogManager configuration and it will configured
      # to also send logging output to its parent's handlers.  It will
      # be registered in the LogManager global namespace.
      # 
      # @param   name            A name for the logger.  This should
      # be a dot-separated name and should normally
      # be based on the package name or class name
      # of the subsystem, such as java.net
      # or javax.swing
      # @return a suitable Logger
      # @throws NullPointerException if the name is null.
      def get_logger(name)
        synchronized(self) do
          manager = LogManager.get_log_manager
          return manager.demand_logger(name)
        end
      end
      
      typesig { [String, String] }
      # Find or create a logger for a named subsystem.  If a logger has
      # already been created with the given name it is returned.  Otherwise
      # a new logger is created.
      # <p>
      # If a new logger is created its log level will be configured
      # based on the LogManager and it will configured to also send logging
      # output to its parent loggers Handlers.  It will be registered in
      # the LogManager global namespace.
      # <p>
      # If the named Logger already exists and does not yet have a
      # localization resource bundle then the given resource bundle
      # name is used.  If the named Logger already exists and has
      # a different resource bundle name then an IllegalArgumentException
      # is thrown.
      # <p>
      # @param   name    A name for the logger.  This should
      # be a dot-separated name and should normally
      # be based on the package name or class name
      # of the subsystem, such as java.net
      # or javax.swing
      # @param   resourceBundleName  name of ResourceBundle to be used for localizing
      # messages for this logger. May be <CODE>null</CODE> if none of
      # the messages require localization.
      # @return a suitable Logger
      # @throws MissingResourceException if the named ResourceBundle cannot be found.
      # @throws IllegalArgumentException if the Logger already exists and uses
      # a different resource bundle name.
      # @throws NullPointerException if the name is null.
      def get_logger(name, resource_bundle_name)
        synchronized(self) do
          manager = LogManager.get_log_manager
          result = manager.demand_logger(name)
          if ((result.attr_resource_bundle_name).nil?)
            # Note: we may get a MissingResourceException here.
            result.setup_resource_info(resource_bundle_name)
          else
            if (!(result.attr_resource_bundle_name == resource_bundle_name))
              raise IllegalArgumentException.new(RJava.cast_to_string(result.attr_resource_bundle_name) + " != " + resource_bundle_name)
            end
          end
          return result
        end
      end
      
      typesig { [] }
      # Create an anonymous Logger.  The newly created Logger is not
      # registered in the LogManager namespace.  There will be no
      # access checks on updates to the logger.
      # <p>
      # This factory method is primarily intended for use from applets.
      # Because the resulting Logger is anonymous it can be kept private
      # by the creating class.  This removes the need for normal security
      # checks, which in turn allows untrusted applet code to update
      # the control state of the Logger.  For example an applet can do
      # a setLevel or an addHandler on an anonymous Logger.
      # <p>
      # Even although the new logger is anonymous, it is configured
      # to have the root logger ("") as its parent.  This means that
      # by default it inherits its effective level and handlers
      # from the root logger.
      # <p>
      # 
      # @return a newly created private Logger
      def get_anonymous_logger
        synchronized(self) do
          manager = LogManager.get_log_manager
          result = Logger.new(nil, nil)
          result.attr_anonymous = true
          root = manager.get_logger("")
          result.do_set_parent(root)
          return result
        end
      end
      
      typesig { [String] }
      # Create an anonymous Logger.  The newly created Logger is not
      # registered in the LogManager namespace.  There will be no
      # access checks on updates to the logger.
      # <p>
      # This factory method is primarily intended for use from applets.
      # Because the resulting Logger is anonymous it can be kept private
      # by the creating class.  This removes the need for normal security
      # checks, which in turn allows untrusted applet code to update
      # the control state of the Logger.  For example an applet can do
      # a setLevel or an addHandler on an anonymous Logger.
      # <p>
      # Even although the new logger is anonymous, it is configured
      # to have the root logger ("") as its parent.  This means that
      # by default it inherits its effective level and handlers
      # from the root logger.
      # <p>
      # @param   resourceBundleName  name of ResourceBundle to be used for localizing
      # messages for this logger.
      # May be null if none of the messages require localization.
      # @return a newly created private Logger
      # @throws MissingResourceException if the named ResourceBundle cannot be found.
      def get_anonymous_logger(resource_bundle_name)
        synchronized(self) do
          manager = LogManager.get_log_manager
          result = Logger.new(nil, resource_bundle_name)
          result.attr_anonymous = true
          root = manager.get_logger("")
          result.do_set_parent(root)
          return result
        end
      end
    }
    
    typesig { [] }
    # Retrieve the localization resource bundle for this
    # logger for the current default locale.  Note that if
    # the result is null, then the Logger will use a resource
    # bundle inherited from its parent.
    # 
    # @return localization bundle (may be null)
    def get_resource_bundle
      return find_resource_bundle(get_resource_bundle_name)
    end
    
    typesig { [] }
    # Retrieve the localization resource bundle name for this
    # logger.  Note that if the result is null, then the Logger
    # will use a resource bundle name inherited from its parent.
    # 
    # @return localization bundle name (may be null)
    def get_resource_bundle_name
      return @resource_bundle_name
    end
    
    typesig { [Filter] }
    # Set a filter to control output on this Logger.
    # <P>
    # After passing the initial "level" check, the Logger will
    # call this Filter to check if a log record should really
    # be published.
    # 
    # @param   newFilter  a filter object (may be null)
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def set_filter(new_filter)
      synchronized(self) do
        check_access
        @filter = new_filter
      end
    end
    
    typesig { [] }
    # Get the current filter for this Logger.
    # 
    # @return  a filter object (may be null)
    def get_filter
      synchronized(self) do
        return @filter
      end
    end
    
    typesig { [LogRecord] }
    # Log a LogRecord.
    # <p>
    # All the other logging methods in this class call through
    # this method to actually perform any logging.  Subclasses can
    # override this single method to capture all log activity.
    # 
    # @param record the LogRecord to be published
    def log(record)
      if (record.get_level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      synchronized((self)) do
        if (!(@filter).nil? && !@filter.is_loggable(record))
          return
        end
      end
      # Post the LogRecord to all our Handlers, and then to
      # our parents' handlers, all the way up the tree.
      logger = self
      while (!(logger).nil?)
        targets = logger.get_handlers
        if (!(targets).nil?)
          i = 0
          while i < targets.attr_length
            targets[i].publish(record)
            i += 1
          end
        end
        if (!logger.get_use_parent_handlers)
          break
        end
        logger = logger.get_parent
      end
    end
    
    typesig { [LogRecord] }
    # private support method for logging.
    # We fill in the logger name, resource bundle name, and
    # resource bundle and then call "void log(LogRecord)".
    def do_log(lr)
      lr.set_logger_name(@name)
      ebname = get_effective_resource_bundle_name
      if (!(ebname).nil?)
        lr.set_resource_bundle_name(ebname)
        lr.set_resource_bundle(find_resource_bundle(ebname))
      end
      log(lr)
    end
    
    typesig { [Level, String] }
    # ================================================================
    # Start of convenience methods WITHOUT className and methodName
    # ================================================================
    # 
    # Log a message, with no arguments.
    # <p>
    # If the logger is currently enabled for the given message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   msg     The string message (or a key in the message catalog)
    def log(level, msg)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      do_log(lr)
    end
    
    typesig { [Level, String, Object] }
    # Log a message, with one object parameter.
    # <p>
    # If the logger is currently enabled for the given message
    # level then a corresponding LogRecord is created and forwarded
    # to all the registered output Handler objects.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   msg     The string message (or a key in the message catalog)
    # @param   param1  parameter to the message
    def log(level, msg, param1)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      params = Array.typed(Object).new([param1])
      lr.set_parameters(params)
      do_log(lr)
    end
    
    typesig { [Level, String, Array.typed(Object)] }
    # Log a message, with an array of object arguments.
    # <p>
    # If the logger is currently enabled for the given message
    # level then a corresponding LogRecord is created and forwarded
    # to all the registered output Handler objects.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   msg     The string message (or a key in the message catalog)
    # @param   params  array of parameters to the message
    def log(level, msg, params)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_parameters(params)
      do_log(lr)
    end
    
    typesig { [Level, String, JavaThrowable] }
    # Log a message, with associated Throwable information.
    # <p>
    # If the logger is currently enabled for the given message
    # level then the given arguments are stored in a LogRecord
    # which is forwarded to all registered output handlers.
    # <p>
    # Note that the thrown argument is stored in the LogRecord thrown
    # property, rather than the LogRecord parameters property.  Thus is it
    # processed specially by output Formatters and is not treated
    # as a formatting parameter to the LogRecord message property.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   msg     The string message (or a key in the message catalog)
    # @param   thrown  Throwable associated with log message.
    def log(level, msg, thrown)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_thrown(thrown)
      do_log(lr)
    end
    
    typesig { [Level, String, String, String] }
    # ================================================================
    # Start of convenience methods WITH className and methodName
    # ================================================================
    # 
    # Log a message, specifying source class and method,
    # with no arguments.
    # <p>
    # If the logger is currently enabled for the given message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that issued the logging request
    # @param   msg     The string message (or a key in the message catalog)
    def logp(level, source_class, source_method, msg)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      do_log(lr)
    end
    
    typesig { [Level, String, String, String, Object] }
    # Log a message, specifying source class and method,
    # with a single object parameter to the log message.
    # <p>
    # If the logger is currently enabled for the given message
    # level then a corresponding LogRecord is created and forwarded
    # to all the registered output Handler objects.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that issued the logging request
    # @param   msg      The string message (or a key in the message catalog)
    # @param   param1    Parameter to the log message.
    def logp(level, source_class, source_method, msg, param1)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      params = Array.typed(Object).new([param1])
      lr.set_parameters(params)
      do_log(lr)
    end
    
    typesig { [Level, String, String, String, Array.typed(Object)] }
    # Log a message, specifying source class and method,
    # with an array of object arguments.
    # <p>
    # If the logger is currently enabled for the given message
    # level then a corresponding LogRecord is created and forwarded
    # to all the registered output Handler objects.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that issued the logging request
    # @param   msg     The string message (or a key in the message catalog)
    # @param   params  Array of parameters to the message
    def logp(level, source_class, source_method, msg, params)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      lr.set_parameters(params)
      do_log(lr)
    end
    
    typesig { [Level, String, String, String, JavaThrowable] }
    # Log a message, specifying source class and method,
    # with associated Throwable information.
    # <p>
    # If the logger is currently enabled for the given message
    # level then the given arguments are stored in a LogRecord
    # which is forwarded to all registered output handlers.
    # <p>
    # Note that the thrown argument is stored in the LogRecord thrown
    # property, rather than the LogRecord parameters property.  Thus is it
    # processed specially by output Formatters and is not treated
    # as a formatting parameter to the LogRecord message property.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that issued the logging request
    # @param   msg     The string message (or a key in the message catalog)
    # @param   thrown  Throwable associated with log message.
    def logp(level, source_class, source_method, msg, thrown)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      lr.set_thrown(thrown)
      do_log(lr)
    end
    
    typesig { [LogRecord, String] }
    # =========================================================================
    # Start of convenience methods WITH className, methodName and bundle name.
    # =========================================================================
    # Private support method for logging for "logrb" methods.
    # We fill in the logger name, resource bundle name, and
    # resource bundle and then call "void log(LogRecord)".
    def do_log(lr, rbname)
      lr.set_logger_name(@name)
      if (!(rbname).nil?)
        lr.set_resource_bundle_name(rbname)
        lr.set_resource_bundle(find_resource_bundle(rbname))
      end
      log(lr)
    end
    
    typesig { [Level, String, String, String, String] }
    # Log a message, specifying source class, method, and resource bundle name
    # with no arguments.
    # <p>
    # If the logger is currently enabled for the given message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # The msg string is localized using the named resource bundle.  If the
    # resource bundle name is null, or an empty String or invalid
    # then the msg string is not localized.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that issued the logging request
    # @param   bundleName     name of resource bundle to localize msg,
    # can be null
    # @param   msg     The string message (or a key in the message catalog)
    def logrb(level, source_class, source_method, bundle_name, msg)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      do_log(lr, bundle_name)
    end
    
    typesig { [Level, String, String, String, String, Object] }
    # Log a message, specifying source class, method, and resource bundle name,
    # with a single object parameter to the log message.
    # <p>
    # If the logger is currently enabled for the given message
    # level then a corresponding LogRecord is created and forwarded
    # to all the registered output Handler objects.
    # <p>
    # The msg string is localized using the named resource bundle.  If the
    # resource bundle name is null, or an empty String or invalid
    # then the msg string is not localized.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that issued the logging request
    # @param   bundleName     name of resource bundle to localize msg,
    # can be null
    # @param   msg      The string message (or a key in the message catalog)
    # @param   param1    Parameter to the log message.
    def logrb(level, source_class, source_method, bundle_name, msg, param1)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      params = Array.typed(Object).new([param1])
      lr.set_parameters(params)
      do_log(lr, bundle_name)
    end
    
    typesig { [Level, String, String, String, String, Array.typed(Object)] }
    # Log a message, specifying source class, method, and resource bundle name,
    # with an array of object arguments.
    # <p>
    # If the logger is currently enabled for the given message
    # level then a corresponding LogRecord is created and forwarded
    # to all the registered output Handler objects.
    # <p>
    # The msg string is localized using the named resource bundle.  If the
    # resource bundle name is null, or an empty String or invalid
    # then the msg string is not localized.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that issued the logging request
    # @param   bundleName     name of resource bundle to localize msg,
    # can be null.
    # @param   msg     The string message (or a key in the message catalog)
    # @param   params  Array of parameters to the message
    def logrb(level, source_class, source_method, bundle_name, msg, params)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      lr.set_parameters(params)
      do_log(lr, bundle_name)
    end
    
    typesig { [Level, String, String, String, String, JavaThrowable] }
    # Log a message, specifying source class, method, and resource bundle name,
    # with associated Throwable information.
    # <p>
    # If the logger is currently enabled for the given message
    # level then the given arguments are stored in a LogRecord
    # which is forwarded to all registered output handlers.
    # <p>
    # The msg string is localized using the named resource bundle.  If the
    # resource bundle name is null, or an empty String or invalid
    # then the msg string is not localized.
    # <p>
    # Note that the thrown argument is stored in the LogRecord thrown
    # property, rather than the LogRecord parameters property.  Thus is it
    # processed specially by output Formatters and is not treated
    # as a formatting parameter to the LogRecord message property.
    # <p>
    # @param   level   One of the message level identifiers, e.g. SEVERE
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that issued the logging request
    # @param   bundleName     name of resource bundle to localize msg,
    # can be null
    # @param   msg     The string message (or a key in the message catalog)
    # @param   thrown  Throwable associated with log message.
    def logrb(level, source_class, source_method, bundle_name, msg, thrown)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(level, msg)
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      lr.set_thrown(thrown)
      do_log(lr, bundle_name)
    end
    
    typesig { [String, String] }
    # ======================================================================
    # Start of convenience methods for logging method entries and returns.
    # ======================================================================
    # 
    # Log a method entry.
    # <p>
    # This is a convenience method that can be used to log entry
    # to a method.  A LogRecord with message "ENTRY", log level
    # FINER, and the given sourceMethod and sourceClass is logged.
    # <p>
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that is being entered
    def entering(source_class, source_method)
      if (Level::FINER.int_value < @level_value)
        return
      end
      logp(Level::FINER, source_class, source_method, "ENTRY")
    end
    
    typesig { [String, String, Object] }
    # Log a method entry, with one parameter.
    # <p>
    # This is a convenience method that can be used to log entry
    # to a method.  A LogRecord with message "ENTRY {0}", log level
    # FINER, and the given sourceMethod, sourceClass, and parameter
    # is logged.
    # <p>
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that is being entered
    # @param   param1         parameter to the method being entered
    def entering(source_class, source_method, param1)
      if (Level::FINER.int_value < @level_value)
        return
      end
      params = Array.typed(Object).new([param1])
      logp(Level::FINER, source_class, source_method, "ENTRY {0}", params)
    end
    
    typesig { [String, String, Array.typed(Object)] }
    # Log a method entry, with an array of parameters.
    # <p>
    # This is a convenience method that can be used to log entry
    # to a method.  A LogRecord with message "ENTRY" (followed by a
    # format {N} indicator for each entry in the parameter array),
    # log level FINER, and the given sourceMethod, sourceClass, and
    # parameters is logged.
    # <p>
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of method that is being entered
    # @param   params         array of parameters to the method being entered
    def entering(source_class, source_method, params)
      if (Level::FINER.int_value < @level_value)
        return
      end
      msg = "ENTRY"
      if ((params).nil?)
        logp(Level::FINER, source_class, source_method, msg)
        return
      end
      i = 0
      while i < params.attr_length
        msg = msg + " {" + RJava.cast_to_string(i) + "}"
        i += 1
      end
      logp(Level::FINER, source_class, source_method, msg, params)
    end
    
    typesig { [String, String] }
    # Log a method return.
    # <p>
    # This is a convenience method that can be used to log returning
    # from a method.  A LogRecord with message "RETURN", log level
    # FINER, and the given sourceMethod and sourceClass is logged.
    # <p>
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of the method
    def exiting(source_class, source_method)
      if (Level::FINER.int_value < @level_value)
        return
      end
      logp(Level::FINER, source_class, source_method, "RETURN")
    end
    
    typesig { [String, String, Object] }
    # Log a method return, with result object.
    # <p>
    # This is a convenience method that can be used to log returning
    # from a method.  A LogRecord with message "RETURN {0}", log level
    # FINER, and the gives sourceMethod, sourceClass, and result
    # object is logged.
    # <p>
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod   name of the method
    # @param   result  Object that is being returned
    def exiting(source_class, source_method, result)
      if (Level::FINER.int_value < @level_value)
        return
      end
      params = Array.typed(Object).new([result])
      logp(Level::FINER, source_class, source_method, "RETURN {0}", result)
    end
    
    typesig { [String, String, JavaThrowable] }
    # Log throwing an exception.
    # <p>
    # This is a convenience method to log that a method is
    # terminating by throwing an exception.  The logging is done
    # using the FINER level.
    # <p>
    # If the logger is currently enabled for the given message
    # level then the given arguments are stored in a LogRecord
    # which is forwarded to all registered output handlers.  The
    # LogRecord's message is set to "THROW".
    # <p>
    # Note that the thrown argument is stored in the LogRecord thrown
    # property, rather than the LogRecord parameters property.  Thus is it
    # processed specially by output Formatters and is not treated
    # as a formatting parameter to the LogRecord message property.
    # <p>
    # @param   sourceClass    name of class that issued the logging request
    # @param   sourceMethod  name of the method.
    # @param   thrown  The Throwable that is being thrown.
    def throwing(source_class, source_method, thrown)
      if (Level::FINER.int_value < @level_value || (@level_value).equal?(OffValue))
        return
      end
      lr = LogRecord.new(Level::FINER, "THROW")
      lr.set_source_class_name(source_class)
      lr.set_source_method_name(source_method)
      lr.set_thrown(thrown)
      do_log(lr)
    end
    
    typesig { [String] }
    # =======================================================================
    # Start of simple convenience methods using level names as method names
    # =======================================================================
    # 
    # Log a SEVERE message.
    # <p>
    # If the logger is currently enabled for the SEVERE message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   msg     The string message (or a key in the message catalog)
    def severe(msg)
      if (Level::SEVERE.int_value < @level_value)
        return
      end
      log(Level::SEVERE, msg)
    end
    
    typesig { [String] }
    # Log a WARNING message.
    # <p>
    # If the logger is currently enabled for the WARNING message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   msg     The string message (or a key in the message catalog)
    def warning(msg)
      if (Level::WARNING.int_value < @level_value)
        return
      end
      log(Level::WARNING, msg)
    end
    
    typesig { [String] }
    # Log an INFO message.
    # <p>
    # If the logger is currently enabled for the INFO message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   msg     The string message (or a key in the message catalog)
    def info(msg)
      if (Level::INFO.int_value < @level_value)
        return
      end
      log(Level::INFO, msg)
    end
    
    typesig { [String] }
    # Log a CONFIG message.
    # <p>
    # If the logger is currently enabled for the CONFIG message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   msg     The string message (or a key in the message catalog)
    def config(msg)
      if (Level::CONFIG.int_value < @level_value)
        return
      end
      log(Level::CONFIG, msg)
    end
    
    typesig { [String] }
    # Log a FINE message.
    # <p>
    # If the logger is currently enabled for the FINE message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   msg     The string message (or a key in the message catalog)
    def fine(msg)
      if (Level::FINE.int_value < @level_value)
        return
      end
      log(Level::FINE, msg)
    end
    
    typesig { [String] }
    # Log a FINER message.
    # <p>
    # If the logger is currently enabled for the FINER message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   msg     The string message (or a key in the message catalog)
    def finer(msg)
      if (Level::FINER.int_value < @level_value)
        return
      end
      log(Level::FINER, msg)
    end
    
    typesig { [String] }
    # Log a FINEST message.
    # <p>
    # If the logger is currently enabled for the FINEST message
    # level then the given message is forwarded to all the
    # registered output Handler objects.
    # <p>
    # @param   msg     The string message (or a key in the message catalog)
    def finest(msg)
      if (Level::FINEST.int_value < @level_value)
        return
      end
      log(Level::FINEST, msg)
    end
    
    typesig { [Level] }
    # ================================================================
    # End of convenience methods
    # ================================================================
    # 
    # Set the log level specifying which message levels will be
    # logged by this logger.  Message levels lower than this
    # value will be discarded.  The level value Level.OFF
    # can be used to turn off logging.
    # <p>
    # If the new level is null, it means that this node should
    # inherit its level from its nearest ancestor with a specific
    # (non-null) level value.
    # 
    # @param newLevel   the new value for the log level (may be null)
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def set_level(new_level)
      check_access
      synchronized((self.attr_tree_lock)) do
        @level_object = new_level
        update_effective_level
      end
    end
    
    typesig { [] }
    # Get the log Level that has been specified for this Logger.
    # The result may be null, which means that this logger's
    # effective level will be inherited from its parent.
    # 
    # @return  this Logger's level
    def get_level
      return @level_object
    end
    
    typesig { [Level] }
    # Check if a message of the given level would actually be logged
    # by this logger.  This check is based on the Loggers effective level,
    # which may be inherited from its parent.
    # 
    # @param   level   a message logging level
    # @return  true if the given message level is currently being logged.
    def is_loggable(level)
      if (level.int_value < @level_value || (@level_value).equal?(OffValue))
        return false
      end
      return true
    end
    
    typesig { [] }
    # Get the name for this logger.
    # @return logger name.  Will be null for anonymous Loggers.
    def get_name
      return @name
    end
    
    typesig { [Handler] }
    # Add a log Handler to receive logging messages.
    # <p>
    # By default, Loggers also send their output to their parent logger.
    # Typically the root Logger is configured with a set of Handlers
    # that essentially act as default handlers for all loggers.
    # 
    # @param   handler a logging Handler
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def add_handler(handler)
      synchronized(self) do
        # Check for null handler
        handler.get_class
        check_access
        if ((@handlers).nil?)
          @handlers = ArrayList.new
        end
        @handlers.add(handler)
      end
    end
    
    typesig { [Handler] }
    # Remove a log Handler.
    # <P>
    # Returns silently if the given Handler is not found or is null
    # 
    # @param   handler a logging Handler
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def remove_handler(handler)
      synchronized(self) do
        check_access
        if ((handler).nil?)
          return
        end
        if ((@handlers).nil?)
          return
        end
        @handlers.remove(handler)
      end
    end
    
    typesig { [] }
    # Get the Handlers associated with this logger.
    # <p>
    # @return  an array of all registered Handlers
    def get_handlers
      synchronized(self) do
        if ((@handlers).nil?)
          return EmptyHandlers
        end
        return @handlers.to_array(Array.typed(Handler).new(@handlers.size) { nil })
      end
    end
    
    typesig { [::Java::Boolean] }
    # Specify whether or not this logger should send its output
    # to it's parent Logger.  This means that any LogRecords will
    # also be written to the parent's Handlers, and potentially
    # to its parent, recursively up the namespace.
    # 
    # @param useParentHandlers   true if output is to be sent to the
    # logger's parent.
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def set_use_parent_handlers(use_parent_handlers)
      synchronized(self) do
        check_access
        @use_parent_handlers = use_parent_handlers
      end
    end
    
    typesig { [] }
    # Discover whether or not this logger is sending its output
    # to its parent logger.
    # 
    # @return  true if output is to be sent to the logger's parent
    def get_use_parent_handlers
      synchronized(self) do
        return @use_parent_handlers
      end
    end
    
    typesig { [String] }
    # Private utility method to map a resource bundle name to an
    # actual resource bundle, using a simple one-entry cache.
    # Returns null for a null name.
    # May also return null if we can't find the resource bundle and
    # there is no suitable previous cached value.
    def find_resource_bundle(name)
      synchronized(self) do
        # Return a null bundle for a null name.
        if ((name).nil?)
          return nil
        end
        current_locale = Locale.get_default
        # Normally we should hit on our simple one entry cache.
        if (!(@catalog).nil? && (current_locale).equal?(@catalog_locale) && (name).equal?(@catalog_name))
          return @catalog
        end
        # Use the thread's context ClassLoader.  If there isn't one,
        # use the SystemClassloader.
        cl = JavaThread.current_thread.get_context_class_loader
        if ((cl).nil?)
          cl = ClassLoader.get_system_class_loader
        end
        begin
          @catalog = ResourceBundle.get_bundle(name, current_locale, cl)
          @catalog_name = name
          @catalog_locale = current_locale
          return @catalog
        rescue MissingResourceException => ex
          # Woops.  We can't find the ResourceBundle in the default
          # ClassLoader.  Drop through.
        end
        # Fall back to searching up the call stack and trying each
        # calling ClassLoader.
        ix = 0
        loop do
          clz = Sun::Reflect::Reflection.get_caller_class(ix)
          if ((clz).nil?)
            break
          end
          cl2 = clz.get_class_loader
          if ((cl2).nil?)
            cl2 = ClassLoader.get_system_class_loader
          end
          if ((cl).equal?(cl2))
            # We've already checked this classloader.
            ix += 1
            next
          end
          cl = cl2
          begin
            @catalog = ResourceBundle.get_bundle(name, current_locale, cl)
            @catalog_name = name
            @catalog_locale = current_locale
            return @catalog
          rescue MissingResourceException => ex
            # Ok, this one didn't work either.
            # Drop through, and try the next one.
          end
          ix += 1
        end
        if ((name == @catalog_name))
          # Return the previous cached value for that name.
          # This may be null.
          return @catalog
        end
        # Sorry, we're out of luck.
        return nil
      end
    end
    
    typesig { [String] }
    # Private utility method to initialize our one entry
    # resource bundle cache.
    # Note: for consistency reasons, we are careful to check
    # that a suitable ResourceBundle exists before setting the
    # ResourceBundleName.
    def setup_resource_info(name)
      synchronized(self) do
        if ((name).nil?)
          return
        end
        rb = find_resource_bundle(name)
        if ((rb).nil?)
          # We've failed to find an expected ResourceBundle.
          raise MissingResourceException.new("Can't find " + name + " bundle", name, "")
        end
        @resource_bundle_name = name
      end
    end
    
    typesig { [] }
    # Return the parent for this Logger.
    # <p>
    # This method returns the nearest extant parent in the namespace.
    # Thus if a Logger is called "a.b.c.d", and a Logger called "a.b"
    # has been created but no logger "a.b.c" exists, then a call of
    # getParent on the Logger "a.b.c.d" will return the Logger "a.b".
    # <p>
    # The result will be null if it is called on the root Logger
    # in the namespace.
    # 
    # @return nearest existing parent Logger
    def get_parent
      synchronized((self.attr_tree_lock)) do
        return @parent
      end
    end
    
    typesig { [Logger] }
    # Set the parent for this Logger.  This method is used by
    # the LogManager to update a Logger when the namespace changes.
    # <p>
    # It should not be called from application code.
    # <p>
    # @param  parent   the new parent logger
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have LoggingPermission("control").
    def set_parent(parent)
      if ((parent).nil?)
        raise NullPointerException.new
      end
      @manager.check_access
      do_set_parent(parent)
    end
    
    typesig { [Logger] }
    # Private method to do the work for parenting a child
    # Logger onto a parent logger.
    def do_set_parent(new_parent)
      # System.err.println("doSetParent \"" + getName() + "\" \""
      # + newParent.getName() + "\"");
      synchronized((self.attr_tree_lock)) do
        # Remove ourself from any previous parent.
        if (!(@parent).nil?)
          # assert parent.kids != null;
          iter = @parent.attr_kids.iterator
          while iter.has_next
            ref = iter.next_
            kid = ref.get
            if ((kid).equal?(self))
              iter.remove
              break
            end
          end
          # We have now removed ourself from our parents' kids.
        end
        # Set our new parent.
        @parent = new_parent
        if ((@parent.attr_kids).nil?)
          @parent.attr_kids = ArrayList.new(2)
        end
        @parent.attr_kids.add(WeakReference.new(self))
        # As a result of the reparenting, the effective level
        # may have changed for us and our children.
        update_effective_level
      end
    end
    
    typesig { [] }
    # Recalculate the effective level for this node and
    # recursively for our children.
    def update_effective_level
      # assert Thread.holdsLock(treeLock);
      # Figure out our current effective level.
      new_level_value = 0
      if (!(@level_object).nil?)
        new_level_value = @level_object.int_value
      else
        if (!(@parent).nil?)
          new_level_value = @parent.attr_level_value
        else
          # This may happen during initialization.
          new_level_value = Level::INFO.int_value
        end
      end
      # If our effective value hasn't changed, we're done.
      if ((@level_value).equal?(new_level_value))
        return
      end
      @level_value = new_level_value
      # System.err.println("effective level: \"" + getName() + "\" := " + level);
      # Recursively update the level on each of our kids.
      if (!(@kids).nil?)
        i = 0
        while i < @kids.size
          ref = @kids.get(i)
          kid = ref.get
          if (!(kid).nil?)
            kid.update_effective_level
          end
          i += 1
        end
      end
    end
    
    typesig { [] }
    # Private method to get the potentially inherited
    # resource bundle name for this Logger.
    # May return null
    def get_effective_resource_bundle_name
      target = self
      while (!(target).nil?)
        rbn = target.get_resource_bundle_name
        if (!(rbn).nil?)
          return rbn
        end
        target = target.get_parent
      end
      return nil
    end
    
    private
    alias_method :initialize__logger, :initialize
  end
  
end
