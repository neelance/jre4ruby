require "rjava"

# Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ErrorManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
    }
  end
  
  # ErrorManager objects can be attached to Handlers to process
  # any error that occur on a Handler during Logging.
  # <p>
  # When processing logging output, if a Handler encounters problems
  # then rather than throwing an Exception back to the issuer of
  # the logging call (who is unlikely to be interested) the Handler
  # should call its associated ErrorManager.
  class ErrorManager 
    include_class_members ErrorManagerImports
    
    attr_accessor :reported
    alias_method :attr_reported, :reported
    undef_method :reported
    alias_method :attr_reported=, :reported=
    undef_method :reported=
    
    class_module.module_eval {
      # We declare standard error codes for important categories of errors.
      # 
      # 
      # GENERIC_FAILURE is used for failure that don't fit
      # into one of the other categories.
      const_set_lazy(:GENERIC_FAILURE) { 0 }
      const_attr_reader  :GENERIC_FAILURE
      
      # WRITE_FAILURE is used when a write to an output stream fails.
      const_set_lazy(:WRITE_FAILURE) { 1 }
      const_attr_reader  :WRITE_FAILURE
      
      # FLUSH_FAILURE is used when a flush to an output stream fails.
      const_set_lazy(:FLUSH_FAILURE) { 2 }
      const_attr_reader  :FLUSH_FAILURE
      
      # CLOSE_FAILURE is used when a close of an output stream fails.
      const_set_lazy(:CLOSE_FAILURE) { 3 }
      const_attr_reader  :CLOSE_FAILURE
      
      # OPEN_FAILURE is used when an open of an output stream fails.
      const_set_lazy(:OPEN_FAILURE) { 4 }
      const_attr_reader  :OPEN_FAILURE
      
      # FORMAT_FAILURE is used when formatting fails for any reason.
      const_set_lazy(:FORMAT_FAILURE) { 5 }
      const_attr_reader  :FORMAT_FAILURE
    }
    
    typesig { [String, JavaException, ::Java::Int] }
    # The error method is called when a Handler failure occurs.
    # <p>
    # This method may be overriden in subclasses.  The default
    # behavior in this base class is that the first call is
    # reported to System.err, and subsequent calls are ignored.
    # 
    # @param msg    a descriptive string (may be null)
    # @param ex     an exception (may be null)
    # @param code   an error code defined in ErrorManager
    def error(msg, ex, code)
      synchronized(self) do
        if (@reported)
          # We only report the first error, to avoid clogging
          # the screen.
          return
        end
        @reported = true
        text = "java.util.logging.ErrorManager: " + RJava.cast_to_string(code)
        if (!(msg).nil?)
          text = text + ": " + msg
        end
        System.err.println(text)
        if (!(ex).nil?)
          ex.print_stack_trace
        end
      end
    end
    
    typesig { [] }
    def initialize
      @reported = false
    end
    
    private
    alias_method :initialize__error_manager, :initialize
  end
  
end
