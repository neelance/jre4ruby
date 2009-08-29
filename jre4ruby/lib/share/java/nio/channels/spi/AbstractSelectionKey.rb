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
module Java::Nio::Channels::Spi
  module AbstractSelectionKeyImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels::Spi
      include ::Java::Nio::Channels
    }
  end
  
  # Base implementation class for selection keys.
  # 
  # <p> This class tracks the validity of the key and implements cancellation.
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class AbstractSelectionKey < AbstractSelectionKeyImports.const_get :SelectionKey
    include_class_members AbstractSelectionKeyImports
    
    typesig { [] }
    # Initializes a new instance of this class.  </p>
    def initialize
      @valid = false
      super()
      @valid = true
    end
    
    attr_accessor :valid
    alias_method :attr_valid, :valid
    undef_method :valid
    alias_method :attr_valid=, :valid=
    undef_method :valid=
    
    typesig { [] }
    def is_valid
      return @valid
    end
    
    typesig { [] }
    def invalidate
      # package-private
      @valid = false
    end
    
    typesig { [] }
    # Cancels this key.
    # 
    # <p> If this key has not yet been cancelled then it is added to its
    # selector's cancelled-key set while synchronized on that set.  </p>
    def cancel
      # Synchronizing "this" to prevent this key from getting canceled
      # multiple times by different threads, which might cause race
      # condition between selector's select() and channel's close().
      synchronized((self)) do
        if (@valid)
          @valid = false
          (selector).cancel(self)
        end
      end
    end
    
    private
    alias_method :initialize__abstract_selection_key, :initialize
  end
  
end
