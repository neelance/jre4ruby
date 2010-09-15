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
module Sun::Net::Www::Http
  module KeepAliveStreamCleanerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Http
      include_const ::Java::Util::Concurrent, :LinkedBlockingQueue
      include_const ::Java::Util::Concurrent, :TimeUnit
      include_const ::Java::Io, :IOException
      include_const ::Sun::Net, :NetProperties
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
    }
  end
  
  # This class is used to cleanup any remaining data that may be on a KeepAliveStream
  # so that the connection can be cached in the KeepAliveCache.
  # Instances of this class can be used as a FIFO queue for KeepAliveCleanerEntry objects.
  # Executing this Runnable removes each KeepAliveCleanerEntry from the Queue, reads
  # the reamining bytes on its KeepAliveStream, and if successful puts the connection in
  # the KeepAliveCache.
  # 
  # @author Chris Hegarty
  class KeepAliveStreamCleaner < KeepAliveStreamCleanerImports.const_get :LinkedBlockingQueue
    include_class_members KeepAliveStreamCleanerImports
    overload_protected {
      include Runnable
    }
    
    class_module.module_eval {
      # maximum amount of remaining data that we will try to cleanup
      
      def max_data_remaining
        defined?(@@max_data_remaining) ? @@max_data_remaining : @@max_data_remaining= 512
      end
      alias_method :attr_max_data_remaining, :max_data_remaining
      
      def max_data_remaining=(value)
        @@max_data_remaining = value
      end
      alias_method :attr_max_data_remaining=, :max_data_remaining=
      
      # maximum amount of KeepAliveStreams to be queued
      
      def max_capacity
        defined?(@@max_capacity) ? @@max_capacity : @@max_capacity= 10
      end
      alias_method :attr_max_capacity, :max_capacity
      
      def max_capacity=(value)
        @@max_capacity = value
      end
      alias_method :attr_max_capacity=, :max_capacity=
      
      # timeout for both socket and poll on the queue
      const_set_lazy(:TIMEOUT) { 5000 }
      const_attr_reader  :TIMEOUT
      
      # max retries for skipping data
      const_set_lazy(:MAX_RETRIES) { 5 }
      const_attr_reader  :MAX_RETRIES
      
      when_class_loaded do
        max_data_key = "http.KeepAlive.remainingData"
        max_data = (AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          local_class_in KeepAliveStreamCleaner
          include_class_members KeepAliveStreamCleaner
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return NetProperties.get_integer(max_data_key, self.attr_max_data_remaining)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))).int_value * 1024
        self.attr_max_data_remaining = max_data
        max_capacity_key = "http.KeepAlive.queuedConnections"
        max_capacity = (AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          local_class_in KeepAliveStreamCleaner
          include_class_members KeepAliveStreamCleaner
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return NetProperties.get_integer(max_capacity_key, self.attr_max_capacity)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))).int_value
        self.attr_max_capacity = max_capacity
      end
    }
    
    typesig { [] }
    def initialize
      super(self.attr_max_capacity)
    end
    
    typesig { [::Java::Int] }
    def initialize(capacity)
      super(capacity)
    end
    
    typesig { [] }
    def run
      kace = nil
      begin
        begin
          kace = poll(TIMEOUT, TimeUnit::MILLISECONDS)
          if ((kace).nil?)
            break
          end
          kas = kace.get_keep_alive_stream
          if (!(kas).nil?)
            synchronized((kas)) do
              hc = kace.get_http_client
              begin
                if (!(hc).nil? && !hc.is_in_keep_alive_cache)
                  old_timeout = hc.set_timeout(TIMEOUT)
                  remaining_to_read_ = kas.remaining_to_read
                  if (remaining_to_read_ > 0)
                    n = 0
                    retries = 0
                    while (n < remaining_to_read_ && retries < MAX_RETRIES)
                      remaining_to_read_ = remaining_to_read_ - n
                      n = kas.skip(remaining_to_read_)
                      if ((n).equal?(0))
                        retries += 1
                      end
                    end
                    remaining_to_read_ = remaining_to_read_ - n
                  end
                  if ((remaining_to_read_).equal?(0))
                    hc.set_timeout(old_timeout)
                    hc.finished
                  else
                    hc.close_server
                  end
                end
              rescue IOException => ioe
                hc.close_server
              ensure
                kas.set_closed
              end
            end
          end
        rescue InterruptedException => ie
        end
      end while (!(kace).nil?)
    end
    
    private
    alias_method :initialize__keep_alive_stream_cleaner, :initialize
  end
  
end
