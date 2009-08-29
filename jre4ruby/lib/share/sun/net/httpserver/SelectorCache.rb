require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module SelectorCacheImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Util
      include ::Java::Nio
      include ::Java::Net
      include ::Java::Io
      include ::Java::Security
      include ::Java::Nio::Channels
    }
  end
  
  # Implements a cache of java.nio.channels.Selector
  # where Selectors are allocated on demand and placed
  # in a temporary cache for a period of time, so they
  # can be reused. If a period of between 2 and 4 minutes
  # elapses without being used, then they are closed.
  class SelectorCache 
    include_class_members SelectorCacheImports
    
    class_module.module_eval {
      
      def cache
        defined?(@@cache) ? @@cache : @@cache= nil
      end
      alias_method :attr_cache, :cache
      
      def cache=(value)
        @@cache = value
      end
      alias_method :attr_cache=, :cache=
    }
    
    typesig { [] }
    def initialize
      @free_selectors = nil
      @free_selectors = LinkedList.new
      c = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members SelectorCache
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          cleaner = self.class::CacheCleaner.new
          cleaner.set_daemon(true)
          return cleaner
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      c.start
    end
    
    class_module.module_eval {
      typesig { [] }
      # factory method for creating single instance
      def get_selector_cache
        synchronized((SelectorCache)) do
          if ((self.attr_cache).nil?)
            self.attr_cache = SelectorCache.new
          end
        end
        return self.attr_cache
      end
      
      const_set_lazy(:SelectorWrapper) { Class.new do
        include_class_members SelectorCache
        
        attr_accessor :sel
        alias_method :attr_sel, :sel
        undef_method :sel
        alias_method :attr_sel=, :sel=
        undef_method :sel=
        
        attr_accessor :delete_flag
        alias_method :attr_delete_flag, :delete_flag
        undef_method :delete_flag
        alias_method :attr_delete_flag=, :delete_flag=
        undef_method :delete_flag=
        
        typesig { [class_self::Selector] }
        def initialize(sel)
          @sel = nil
          @delete_flag = false
          @sel = sel
          @delete_flag = false
        end
        
        typesig { [] }
        def get_selector
          return @sel
        end
        
        typesig { [] }
        def get_delete_flag
          return @delete_flag
        end
        
        typesig { [::Java::Boolean] }
        def set_delete_flag(b)
          @delete_flag = b
        end
        
        private
        alias_method :initialize__selector_wrapper, :initialize
      end }
    }
    
    # list of free selectors. Can be re-allocated for a period
    # of time, after which if not allocated will be closed
    # and removed from the list (by CacheCleaner thread)
    attr_accessor :free_selectors
    alias_method :attr_free_selectors, :free_selectors
    undef_method :free_selectors
    alias_method :attr_free_selectors=, :free_selectors=
    undef_method :free_selectors=
    
    typesig { [] }
    def get_selector
      synchronized(self) do
        wrapper = nil
        selector = nil
        if (@free_selectors.size > 0)
          wrapper = @free_selectors.remove
          selector = wrapper.get_selector
        else
          selector = Selector.open
        end
        return selector
      end
    end
    
    typesig { [Selector] }
    def free_selector(selector)
      synchronized(self) do
        @free_selectors.add(SelectorWrapper.new(selector))
      end
    end
    
    class_module.module_eval {
      # Thread ensures that entries on freeSelector list
      # remain there for at least 2 minutes and no longer
      # than 4 minutes.
      const_set_lazy(:CacheCleaner) { Class.new(JavaThread) do
        extend LocalClass
        include_class_members SelectorCache
        
        typesig { [] }
        def run
          timeout = ServerConfig.get_sel_cache_timeout * 1000
          while (true)
            begin
              JavaThread.sleep(timeout)
            rescue self.class::JavaException => e
            end
            synchronized((self.attr_free_selectors)) do
              l = self.attr_free_selectors.list_iterator
              while (l.has_next)
                w = l.next_
                if (w.get_delete_flag)
                  # 2nd pass. Close the selector
                  begin
                    w.get_selector.close
                  rescue self.class::IOException => e
                  end
                  l.remove
                else
                  # 1st pass. Set the flag
                  w.set_delete_flag(true)
                end
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__cache_cleaner, :initialize
      end }
    }
    
    private
    alias_method :initialize__selector_cache, :initialize
  end
  
end
