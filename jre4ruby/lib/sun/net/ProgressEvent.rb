require "rjava"

# 
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
  module ProgressEventImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include_const ::Java::Util, :EventObject
      include_const ::Java::Net, :URL
    }
  end
  
  # 
  # ProgressEvent represents an progress event in monitering network input stream.
  # 
  # @author Stanley Man-Kit Ho
  class ProgressEvent < ProgressEventImports.const_get :EventObject
    include_class_members ProgressEventImports
    
    # URL of the stream
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    # content type of the stream
    attr_accessor :content_type
    alias_method :attr_content_type, :content_type
    undef_method :content_type
    alias_method :attr_content_type=, :content_type=
    undef_method :content_type=
    
    # method associated with URL
    attr_accessor :method
    alias_method :attr_method, :method
    undef_method :method
    alias_method :attr_method=, :method=
    undef_method :method=
    
    # bytes read
    attr_accessor :progress
    alias_method :attr_progress, :progress
    undef_method :progress
    alias_method :attr_progress=, :progress=
    undef_method :progress=
    
    # bytes expected
    attr_accessor :expected
    alias_method :attr_expected, :expected
    undef_method :expected
    alias_method :attr_expected=, :expected=
    undef_method :expected=
    
    # the last thing to happen
    attr_accessor :state
    alias_method :attr_state, :state
    undef_method :state
    alias_method :attr_state=, :state=
    undef_method :state=
    
    typesig { [ProgressSource, URL, String, String, ProgressSource::State, ::Java::Int, ::Java::Int] }
    # 
    # Construct a ProgressEvent object.
    def initialize(source, url, method, content_type, state, progress, expected)
      @url = nil
      @content_type = nil
      @method = nil
      @progress = 0
      @expected = 0
      @state = nil
      super(source)
      @url = url
      @method = method
      @content_type = content_type
      @progress = progress
      @expected = expected
      @state = state
    end
    
    typesig { [] }
    # 
    # Return URL related to the progress.
    def get_url
      return @url
    end
    
    typesig { [] }
    # 
    # Return method associated with URL.
    def get_method
      return @method
    end
    
    typesig { [] }
    # 
    # Return content type of the URL.
    def get_content_type
      return @content_type
    end
    
    typesig { [] }
    # 
    # Return current progress value.
    def get_progress
      return @progress
    end
    
    typesig { [] }
    # 
    # Return expected maximum progress value; -1 if expected is unknown.
    def get_expected
      return @expected
    end
    
    typesig { [] }
    # 
    # Return state.
    def get_state
      return @state
    end
    
    typesig { [] }
    def to_s
      return (get_class.get_name).to_s + "[url=" + (@url).to_s + ", method=" + @method + ", state=" + (@state).to_s + ", content-type=" + @content_type + ", progress=" + (@progress).to_s + ", expected=" + (@expected).to_s + "]"
    end
    
    private
    alias_method :initialize__progress_event, :initialize
  end
  
end
