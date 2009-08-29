require "rjava"

# Copyright 2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net
  module ProgressSourceImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include_const ::Java::Net, :URL
    }
  end
  
  # ProgressSource represents the source of progress changes.
  # 
  # @author Stanley Man-Kit Ho
  class ProgressSource 
    include_class_members ProgressSourceImports
    
    class_module.module_eval {
      const_set_lazy(:NEW) { State::NEW }
      const_attr_reader  :NEW
      
      const_set_lazy(:CONNECTED) { State::CONNECTED }
      const_attr_reader  :CONNECTED
      
      const_set_lazy(:UPDATE) { State::UPDATE }
      const_attr_reader  :UPDATE
      
      const_set_lazy(:DELETE) { State::DELETE }
      const_attr_reader  :DELETE
      
      class State 
        include_class_members ProgressSource
        
        class_module.module_eval {
          const_set_lazy(:NEW) { State.new.set_value_name("NEW") }
          const_attr_reader  :NEW
          
          const_set_lazy(:CONNECTED) { State.new.set_value_name("CONNECTED") }
          const_attr_reader  :CONNECTED
          
          const_set_lazy(:UPDATE) { State.new.set_value_name("UPDATE") }
          const_attr_reader  :UPDATE
          
          const_set_lazy(:DELETE) { State.new.set_value_name("DELETE") }
          const_attr_reader  :DELETE
        }
        
        typesig { [String] }
        def set_value_name(name)
          @value_name = name
          self
        end
        
        typesig { [] }
        def to_s
          @value_name
        end
        
        class_module.module_eval {
          typesig { [] }
          def values
            [NEW, CONNECTED, UPDATE, DELETE]
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__state, :initialize
      end
    }
    
    # URL
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    # URL method
    attr_accessor :method
    alias_method :attr_method, :method
    undef_method :method
    alias_method :attr_method=, :method=
    undef_method :method=
    
    # Content type
    attr_accessor :content_type
    alias_method :attr_content_type, :content_type
    undef_method :content_type
    alias_method :attr_content_type=, :content_type=
    undef_method :content_type=
    
    # bytes read
    attr_accessor :progress
    alias_method :attr_progress, :progress
    undef_method :progress
    alias_method :attr_progress=, :progress=
    undef_method :progress=
    
    # last bytes read
    attr_accessor :last_progress
    alias_method :attr_last_progress, :last_progress
    undef_method :last_progress
    alias_method :attr_last_progress=, :last_progress=
    undef_method :last_progress=
    
    # bytes expected
    attr_accessor :expected
    alias_method :attr_expected, :expected
    undef_method :expected
    alias_method :attr_expected=, :expected=
    undef_method :expected=
    
    # the last thing to happen with this source
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    # connect flag
    attr_accessor :connected
    alias_method :attr_connected, :connected
    undef_method :connected
    alias_method :attr_connected=, :connected=
    undef_method :connected=
    
    # threshold for notification
    attr_accessor :threshold
    alias_method :attr_threshold, :threshold
    undef_method :threshold
    alias_method :attr_threshold=, :threshold=
    undef_method :threshold=
    
    # progress monitor
    attr_accessor :progress_monitor
    alias_method :attr_progress_monitor, :progress_monitor
    undef_method :progress_monitor
    alias_method :attr_progress_monitor=, :progress_monitor=
    undef_method :progress_monitor=
    
    typesig { [URL, String] }
    # Construct progress source object.
    def initialize(url, method)
      initialize__progress_source(url, method, -1)
    end
    
    typesig { [URL, String, ::Java::Int] }
    # Construct progress source object.
    def initialize(url, method, expected)
      @url = nil
      @method = nil
      @content_type = nil
      @progress = 0
      @last_progress = 0
      @expected = -1
      @state = nil
      @connected = false
      @threshold = 8192
      @progress_monitor = nil
      @url = url
      @method = method
      @content_type = "content/unknown"
      @progress = 0
      @last_progress = 0
      @expected = expected
      @state = State::NEW
      @progress_monitor = ProgressMonitor.get_default
      @threshold = @progress_monitor.get_progress_update_threshold
    end
    
    typesig { [] }
    def connected
      if (!@connected)
        @connected = true
        @state = State::CONNECTED
        return false
      end
      return true
    end
    
    typesig { [] }
    # Close progress source.
    def close
      @state = State::DELETE
    end
    
    typesig { [] }
    # Return URL of progress source.
    def get_url
      return @url
    end
    
    typesig { [] }
    # Return method of URL.
    def get_method
      return @method
    end
    
    typesig { [] }
    # Return content type of URL.
    def get_content_type
      return @content_type
    end
    
    typesig { [String] }
    # Change content type
    def set_content_type(ct)
      @content_type = ct
    end
    
    typesig { [] }
    # Return current progress.
    def get_progress
      return @progress
    end
    
    typesig { [] }
    # Return expected maximum progress; -1 if expected is unknown.
    def get_expected
      return @expected
    end
    
    typesig { [] }
    # Return state.
    def get_state
      return @state
    end
    
    typesig { [] }
    # Begin progress tracking.
    def begin_tracking
      @progress_monitor.register_source(self)
    end
    
    typesig { [] }
    # Finish progress tracking.
    def finish_tracking
      @progress_monitor.unregister_source(self)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Update progress.
    def update_progress(latest_progress, expected_progress)
      @last_progress = @progress
      @progress = latest_progress
      @expected = expected_progress
      if ((connected).equal?(false))
        @state = State::CONNECTED
      else
        @state = State::UPDATE
      end
      # The threshold effectively divides the progress into
      # different set of ranges:
      # 
      # Range 0: 0..threshold-1,
      # Range 1: threshold .. 2*threshold-1
      # ....
      # Range n: n*threshold .. (n+1)*threshold-1
      # 
      # To determine which range the progress belongs to, it
      # would be calculated as follow:
      # 
      # range number = progress / threshold
      # 
      # Notification should only be triggered when the current
      # progress and the last progress are in different ranges,
      # i.e. they have different range numbers.
      # 
      # Using this range scheme, notification will be generated
      # only once when the progress reaches each range.
      if (!(@last_progress / @threshold).equal?(@progress / @threshold))
        @progress_monitor.update_progress(self)
      end
      # Detect read overrun
      if (!(@expected).equal?(-1))
        if (@progress >= @expected && !(@progress).equal?(0))
          close
        end
      end
    end
    
    typesig { [] }
    def clone
      return super
    end
    
    typesig { [] }
    def to_s
      return RJava.cast_to_string(get_class.get_name) + "[url=" + RJava.cast_to_string(@url) + ", method=" + @method + ", state=" + RJava.cast_to_string(@state) + ", content-type=" + @content_type + ", progress=" + RJava.cast_to_string(@progress) + ", expected=" + RJava.cast_to_string(@expected) + "]"
    end
    
    private
    alias_method :initialize__progress_source, :initialize
  end
  
end
