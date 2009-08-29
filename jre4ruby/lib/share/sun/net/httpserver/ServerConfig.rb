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
module Sun::Net::Httpserver
  module ServerConfigImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  # Parameters that users will not likely need to set
  # but are useful for debugging
  class ServerConfig 
    include_class_members ServerConfigImports
    
    class_module.module_eval {
      
      def clock_tick
        defined?(@@clock_tick) ? @@clock_tick : @@clock_tick= 0
      end
      alias_method :attr_clock_tick, :clock_tick
      
      def clock_tick=(value)
        @@clock_tick = value
      end
      alias_method :attr_clock_tick=, :clock_tick=
      
      
      def default_clock_tick
        defined?(@@default_clock_tick) ? @@default_clock_tick : @@default_clock_tick= 10000
      end
      alias_method :attr_default_clock_tick, :default_clock_tick
      
      def default_clock_tick=(value)
        @@default_clock_tick = value
      end
      alias_method :attr_default_clock_tick=, :default_clock_tick=
      
      # 10 sec.
      # These values must be a reasonable multiple of clockTick
      
      def default_read_timeout
        defined?(@@default_read_timeout) ? @@default_read_timeout : @@default_read_timeout= 20
      end
      alias_method :attr_default_read_timeout, :default_read_timeout
      
      def default_read_timeout=(value)
        @@default_read_timeout = value
      end
      alias_method :attr_default_read_timeout=, :default_read_timeout=
      
      # 20 sec.
      
      def default_write_timeout
        defined?(@@default_write_timeout) ? @@default_write_timeout : @@default_write_timeout= 60
      end
      alias_method :attr_default_write_timeout, :default_write_timeout
      
      def default_write_timeout=(value)
        @@default_write_timeout = value
      end
      alias_method :attr_default_write_timeout=, :default_write_timeout=
      
      # 60 sec.
      
      def default_idle_interval
        defined?(@@default_idle_interval) ? @@default_idle_interval : @@default_idle_interval= 300
      end
      alias_method :attr_default_idle_interval, :default_idle_interval
      
      def default_idle_interval=(value)
        @@default_idle_interval = value
      end
      alias_method :attr_default_idle_interval=, :default_idle_interval=
      
      # 5 min
      
      def default_sel_cache_timeout
        defined?(@@default_sel_cache_timeout) ? @@default_sel_cache_timeout : @@default_sel_cache_timeout= 120
      end
      alias_method :attr_default_sel_cache_timeout, :default_sel_cache_timeout
      
      def default_sel_cache_timeout=(value)
        @@default_sel_cache_timeout = value
      end
      alias_method :attr_default_sel_cache_timeout=, :default_sel_cache_timeout=
      
      # seconds
      
      def default_max_idle_connections
        defined?(@@default_max_idle_connections) ? @@default_max_idle_connections : @@default_max_idle_connections= 200
      end
      alias_method :attr_default_max_idle_connections, :default_max_idle_connections
      
      def default_max_idle_connections=(value)
        @@default_max_idle_connections = value
      end
      alias_method :attr_default_max_idle_connections=, :default_max_idle_connections=
      
      
      def default_drain_amount
        defined?(@@default_drain_amount) ? @@default_drain_amount : @@default_drain_amount= 64 * 1024
      end
      alias_method :attr_default_drain_amount, :default_drain_amount
      
      def default_drain_amount=(value)
        @@default_drain_amount = value
      end
      alias_method :attr_default_drain_amount=, :default_drain_amount=
      
      
      def read_timeout
        defined?(@@read_timeout) ? @@read_timeout : @@read_timeout= 0
      end
      alias_method :attr_read_timeout, :read_timeout
      
      def read_timeout=(value)
        @@read_timeout = value
      end
      alias_method :attr_read_timeout=, :read_timeout=
      
      
      def write_timeout
        defined?(@@write_timeout) ? @@write_timeout : @@write_timeout= 0
      end
      alias_method :attr_write_timeout, :write_timeout
      
      def write_timeout=(value)
        @@write_timeout = value
      end
      alias_method :attr_write_timeout=, :write_timeout=
      
      
      def idle_interval
        defined?(@@idle_interval) ? @@idle_interval : @@idle_interval= 0
      end
      alias_method :attr_idle_interval, :idle_interval
      
      def idle_interval=(value)
        @@idle_interval = value
      end
      alias_method :attr_idle_interval=, :idle_interval=
      
      
      def sel_cache_timeout
        defined?(@@sel_cache_timeout) ? @@sel_cache_timeout : @@sel_cache_timeout= 0
      end
      alias_method :attr_sel_cache_timeout, :sel_cache_timeout
      
      def sel_cache_timeout=(value)
        @@sel_cache_timeout = value
      end
      alias_method :attr_sel_cache_timeout=, :sel_cache_timeout=
      
      
      def drain_amount
        defined?(@@drain_amount) ? @@drain_amount : @@drain_amount= 0
      end
      alias_method :attr_drain_amount, :drain_amount
      
      def drain_amount=(value)
        @@drain_amount = value
      end
      alias_method :attr_drain_amount=, :drain_amount=
      
      # max # of bytes to drain from an inputstream
      
      def max_idle_connections
        defined?(@@max_idle_connections) ? @@max_idle_connections : @@max_idle_connections= 0
      end
      alias_method :attr_max_idle_connections, :max_idle_connections
      
      def max_idle_connections=(value)
        @@max_idle_connections = value
      end
      alias_method :attr_max_idle_connections=, :max_idle_connections=
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= false
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      when_class_loaded do
        self.attr_idle_interval = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetLongAction.new("sun.net.httpserver.idleInterval", self.attr_default_idle_interval))).long_value * 1000
        self.attr_clock_tick = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new("sun.net.httpserver.clockTick", self.attr_default_clock_tick))).int_value
        self.attr_max_idle_connections = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetIntegerAction.new("sun.net.httpserver.maxIdleConnections", self.attr_default_max_idle_connections))).int_value
        self.attr_read_timeout = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetLongAction.new("sun.net.httpserver.readTimeout", self.attr_default_read_timeout))).long_value * 1000
        self.attr_sel_cache_timeout = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetLongAction.new("sun.net.httpserver.selCacheTimeout", self.attr_default_sel_cache_timeout))).long_value * 1000
        self.attr_write_timeout = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetLongAction.new("sun.net.httpserver.writeTimeout", self.attr_default_write_timeout))).long_value * 1000
        self.attr_drain_amount = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetLongAction.new("sun.net.httpserver.drainAmount", self.attr_default_drain_amount))).long_value
        self.attr_debug = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("sun.net.httpserver.debug"))).boolean_value
      end
      
      typesig { [] }
      def get_read_timeout
        return self.attr_read_timeout
      end
      
      typesig { [] }
      def get_sel_cache_timeout
        return self.attr_sel_cache_timeout
      end
      
      typesig { [] }
      def debug_enabled
        return self.attr_debug
      end
      
      typesig { [] }
      def get_idle_interval
        return self.attr_idle_interval
      end
      
      typesig { [] }
      def get_clock_tick
        return self.attr_clock_tick
      end
      
      typesig { [] }
      def get_max_idle_connections
        return self.attr_max_idle_connections
      end
      
      typesig { [] }
      def get_write_timeout
        return self.attr_write_timeout
      end
      
      typesig { [] }
      def get_drain_amount
        return self.attr_drain_amount
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__server_config, :initialize
  end
  
end
