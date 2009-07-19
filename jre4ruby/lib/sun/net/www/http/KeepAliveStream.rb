require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module KeepAliveStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Http
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :HttpURLConnection
      include ::Java::Io
      include_const ::Java::Util, :StringTokenizer
      include_const ::Sun::Net, :ProgressSource
      include_const ::Sun::Net::Www, :MeteredStream
    }
  end
  
  # A stream that has the property of being able to be kept alive for
  # multiple downloads from the same server.
  # 
  # @author Stephen R. Pietrowicz (NCSA)
  # @author Dave Brown
  class KeepAliveStream < KeepAliveStreamImports.const_get :MeteredStream
    include_class_members KeepAliveStreamImports
    include Hurryable
    
    # instance variables
    attr_accessor :hc
    alias_method :attr_hc, :hc
    undef_method :hc
    alias_method :attr_hc=, :hc=
    undef_method :hc=
    
    attr_accessor :hurried
    alias_method :attr_hurried, :hurried
    undef_method :hurried
    alias_method :attr_hurried=, :hurried=
    undef_method :hurried=
    
    # has this KeepAliveStream been put on the queue for asynchronous cleanup.
    attr_accessor :queued_for_cleanup
    alias_method :attr_queued_for_cleanup, :queued_for_cleanup
    undef_method :queued_for_cleanup
    alias_method :attr_queued_for_cleanup=, :queued_for_cleanup=
    undef_method :queued_for_cleanup=
    
    class_module.module_eval {
      
      def queue
        defined?(@@queue) ? @@queue : @@queue= KeepAliveStreamCleaner.new
      end
      alias_method :attr_queue, :queue
      
      def queue=(value)
        @@queue = value
      end
      alias_method :attr_queue=, :queue=
      
      
      def cleaner_thread
        defined?(@@cleaner_thread) ? @@cleaner_thread : @@cleaner_thread= nil
      end
      alias_method :attr_cleaner_thread, :cleaner_thread
      
      def cleaner_thread=(value)
        @@cleaner_thread = value
      end
      alias_method :attr_cleaner_thread=, :cleaner_thread=
      
      
      def start_cleanup_thread
        defined?(@@start_cleanup_thread) ? @@start_cleanup_thread : @@start_cleanup_thread= false
      end
      alias_method :attr_start_cleanup_thread, :start_cleanup_thread
      
      def start_cleanup_thread=(value)
        @@start_cleanup_thread = value
      end
      alias_method :attr_start_cleanup_thread=, :start_cleanup_thread=
    }
    
    typesig { [InputStream, ProgressSource, ::Java::Int, HttpClient] }
    # Constructor
    def initialize(is, pi, expected, hc)
      @hc = nil
      @hurried = false
      @queued_for_cleanup = false
      super(is, pi, expected)
      @queued_for_cleanup = false
      @hc = hc
    end
    
    typesig { [] }
    # Attempt to cache this connection
    def close
      # If the inputstream is closed already, just return.
      if (self.attr_closed)
        return
      end
      # If this stream has already been queued for cleanup.
      if (@queued_for_cleanup)
        return
      end
      # Skip past the data that's left in the Inputstream because
      # some sort of error may have occurred.
      # Do this ONLY if the skip won't block. The stream may have
      # been closed at the beginning of a big file and we don't want
      # to hang around for nothing. So if we can't skip without blocking
      # we just close the socket and, therefore, terminate the keepAlive
      # NOTE: Don't close super class
      begin
        if (self.attr_expected > self.attr_count)
          nskip = (self.attr_expected - self.attr_count)
          if (nskip <= available)
            n = 0
            while (n < nskip)
              nskip = nskip - n
              n = skip(nskip)
            end
          else
            if (self.attr_expected <= KeepAliveStreamCleaner::MAX_DATA_REMAINING && !@hurried)
              # put this KeepAliveStream on the queue so that the data remaining
              # on the socket can be cleanup asyncronously.
              queue_for_cleanup(KeepAliveCleanerEntry.new(self, @hc))
            else
              @hc.close_server
            end
          end
        end
        if (!self.attr_closed && !@hurried && !@queued_for_cleanup)
          @hc.finished
        end
      ensure
        if (!(self.attr_pi).nil?)
          self.attr_pi.finish_tracking
        end
        if (!@queued_for_cleanup)
          # nulling out the underlying inputstream as well as
          # httpClient to let gc collect the memories faster
          self.attr_in = nil
          @hc = nil
          self.attr_closed = true
        end
      end
    end
    
    typesig { [] }
    # we explicitly do not support mark/reset
    def mark_supported
      return false
    end
    
    typesig { [::Java::Int] }
    def mark(limit)
    end
    
    typesig { [] }
    def reset
      raise IOException.new("mark/reset not supported")
    end
    
    typesig { [] }
    def hurry
      synchronized(self) do
        begin
          # CASE 0: we're actually already done
          if (self.attr_closed || self.attr_count >= self.attr_expected)
            return false
          else
            if (self.attr_in.available < (self.attr_expected - self.attr_count))
              # CASE I: can't meet the demand
              return false
            else
              # CASE II: fill our internal buffer
              # Remind: possibly check memory here
              buf = Array.typed(::Java::Byte).new(self.attr_expected - self.attr_count) { 0 }
              dis = DataInputStream.new(self.attr_in)
              dis.read_fully(buf)
              self.attr_in = ByteArrayInputStream.new(buf)
              @hurried = true
              return true
            end
          end
        rescue IOException => e
          # e.printStackTrace();
          return false
        end
      end
    end
    
    class_module.module_eval {
      typesig { [KeepAliveCleanerEntry] }
      def queue_for_cleanup(kace)
        synchronized(self) do
          if (!(self.attr_queue).nil? && !kace.get_queued_for_cleanup)
            if (!self.attr_queue.offer(kace))
              kace.get_http_client.close_server
              return
            end
            kace.set_queued_for_cleanup
          end
          self.attr_start_cleanup_thread = ((self.attr_cleaner_thread).nil?)
          if (!self.attr_start_cleanup_thread)
            if (!self.attr_cleaner_thread.is_alive)
              self.attr_start_cleanup_thread = true
            end
          end
          if (self.attr_start_cleanup_thread)
            Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
              extend LocalClass
              include_class_members KeepAliveStream
              include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                # We want to create the Keep-Alive-SocketCleaner in the
                # system threadgroup
                grp = JavaThread.current_thread.get_thread_group
                parent = nil
                while (!((parent = grp.get_parent)).nil?)
                  grp = parent
                end
                self.attr_cleaner_thread = JavaThread.new(grp, self.attr_queue, "Keep-Alive-SocketCleaner")
                self.attr_cleaner_thread.set_daemon(true)
                self.attr_cleaner_thread.set_priority(JavaThread::MAX_PRIORITY - 2)
                self.attr_cleaner_thread.start
                return nil
              end
              
              typesig { [] }
              define_method :initialize do
                super()
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
        end
      end
    }
    
    typesig { [] }
    def remaining_to_read
      return self.attr_expected - self.attr_count
    end
    
    typesig { [] }
    def set_closed
      self.attr_in = nil
      @hc = nil
      self.attr_closed = true
    end
    
    private
    alias_method :initialize__keep_alive_stream, :initialize
  end
  
  class KeepAliveCleanerEntry 
    include_class_members KeepAliveStreamImports
    
    attr_accessor :kas
    alias_method :attr_kas, :kas
    undef_method :kas
    alias_method :attr_kas=, :kas=
    undef_method :kas=
    
    attr_accessor :hc
    alias_method :attr_hc, :hc
    undef_method :hc
    alias_method :attr_hc=, :hc=
    undef_method :hc=
    
    typesig { [KeepAliveStream, HttpClient] }
    def initialize(kas, hc)
      @kas = nil
      @hc = nil
      @kas = kas
      @hc = hc
    end
    
    typesig { [] }
    def get_keep_alive_stream
      return @kas
    end
    
    typesig { [] }
    def get_http_client
      return @hc
    end
    
    typesig { [] }
    def set_queued_for_cleanup
      @kas.attr_queued_for_cleanup = true
    end
    
    typesig { [] }
    def get_queued_for_cleanup
      return @kas.attr_queued_for_cleanup
    end
    
    private
    alias_method :initialize__keep_alive_cleaner_entry, :initialize
  end
  
end
