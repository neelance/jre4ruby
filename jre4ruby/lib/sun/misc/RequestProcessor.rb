require "rjava"

# Copyright 1996 Sun Microsystems, Inc.  All Rights Reserved.
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
  module RequestProcessorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
    }
  end
  
  # The request processor allows functors (Request instances) to be created
  # in arbitrary threads, and to be posted for execution in a non-restricted
  # thread.
  # 
  # @author      Steven B. Byrne
  class RequestProcessor 
    include_class_members RequestProcessorImports
    include Runnable
    
    class_module.module_eval {
      
      def request_queue
        defined?(@@request_queue) ? @@request_queue : @@request_queue= nil
      end
      alias_method :attr_request_queue, :request_queue
      
      def request_queue=(value)
        @@request_queue = value
      end
      alias_method :attr_request_queue=, :request_queue=
      
      
      def dispatcher
        defined?(@@dispatcher) ? @@dispatcher : @@dispatcher= nil
      end
      alias_method :attr_dispatcher, :dispatcher
      
      def dispatcher=(value)
        @@dispatcher = value
      end
      alias_method :attr_dispatcher=, :dispatcher=
      
      typesig { [Request] }
      # Queues a Request instance for execution by the request procesor
      # thread.
      def post_request(req)
        lazy_initialize
        self.attr_request_queue.enqueue(req)
      end
    }
    
    typesig { [] }
    # Process requests as they are queued.
    def run
      lazy_initialize
      while (true)
        begin
          obj = self.attr_request_queue.dequeue
          if (obj.is_a?(Request))
            # ignore bogons
            req = obj
            begin
              req.execute
            rescue Exception => t
              # do nothing at the moment...maybe report an error
              # in the future
            end
          end
        rescue InterruptedException => e
          # do nothing at the present time.
        end
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      # This method initiates the request processor thread.  It is safe
      # to call it after the thread has been started.  It provides a way for
      # clients to deliberately control the context in which the request
      # processor thread is created
      def start_processing
        synchronized(self) do
          if ((self.attr_dispatcher).nil?)
            self.attr_dispatcher = JavaThread.new(RequestProcessor.new, "Request Processor")
            self.attr_dispatcher.set_priority(JavaThread::NORM_PRIORITY + 2)
            self.attr_dispatcher.start
          end
        end
      end
      
      typesig { [] }
      # This method performs lazy initialization.
      def lazy_initialize
        synchronized(self) do
          if ((self.attr_request_queue).nil?)
            self.attr_request_queue = Queue.new
          end
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__request_processor, :initialize
  end
  
end
