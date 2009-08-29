require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module LoggingImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :ArrayList
    }
  end
  
  # Logging is the implementation class of LoggingMXBean.
  # 
  # The <tt>LoggingMXBean</tt> interface provides a standard
  # method for management access to the individual
  # java.util.Logger objects available at runtime.
  # 
  # @author Ron Mann
  # @author Mandy Chung
  # @since 1.5
  # 
  # @see javax.management
  # @see java.util.Logger
  # @see java.util.LogManager
  class Logging 
    include_class_members LoggingImports
    include LoggingMXBean
    
    class_module.module_eval {
      
      def log_manager
        defined?(@@log_manager) ? @@log_manager : @@log_manager= LogManager.get_log_manager
      end
      alias_method :attr_log_manager, :log_manager
      
      def log_manager=(value)
        @@log_manager = value
      end
      alias_method :attr_log_manager=, :log_manager=
    }
    
    typesig { [] }
    # Constructor of Logging which is the implementation class
    # of LoggingMXBean.
    def initialize
    end
    
    typesig { [] }
    def get_logger_names
      loggers = self.attr_log_manager.get_logger_names
      array = ArrayList.new
      while loggers.has_more_elements
        array.add(loggers.next_element)
      end
      return array
    end
    
    class_module.module_eval {
      
      def empty_string
        defined?(@@empty_string) ? @@empty_string : @@empty_string= ""
      end
      alias_method :attr_empty_string, :empty_string
      
      def empty_string=(value)
        @@empty_string = value
      end
      alias_method :attr_empty_string=, :empty_string=
    }
    
    typesig { [String] }
    def get_logger_level(logger_name)
      l = self.attr_log_manager.get_logger(logger_name)
      if ((l).nil?)
        return nil
      end
      level = l.get_level
      if ((level).nil?)
        return self.attr_empty_string
      else
        return level.get_name
      end
    end
    
    typesig { [String, String] }
    def set_logger_level(logger_name, level_name)
      if ((logger_name).nil?)
        raise NullPointerException.new("loggerName is null")
      end
      logger = self.attr_log_manager.get_logger(logger_name)
      if ((logger).nil?)
        raise IllegalArgumentException.new("Logger " + logger_name + "does not exist")
      end
      level = nil
      if (!(level_name).nil?)
        # parse will throw IAE if logLevel is invalid
        level = Level.parse(level_name)
      end
      logger.set_level(level)
    end
    
    typesig { [String] }
    def get_parent_logger_name(logger_name)
      l = self.attr_log_manager.get_logger(logger_name)
      if ((l).nil?)
        return nil
      end
      p = l.get_parent
      if ((p).nil?)
        # root logger
        return self.attr_empty_string
      else
        return p.get_name
      end
    end
    
    private
    alias_method :initialize__logging, :initialize
  end
  
end
