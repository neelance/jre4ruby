require "rjava"

# 
# Copyright 1994-1998 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module ObserverImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # 
  # A class can implement the <code>Observer</code> interface when it
  # wants to be informed of changes in observable objects.
  # 
  # @author  Chris Warth
  # @see     java.util.Observable
  # @since   JDK1.0
  module Observer
    include_class_members ObserverImports
    
    typesig { [Observable, Object] }
    # 
    # This method is called whenever the observed object is changed. An
    # application calls an <tt>Observable</tt> object's
    # <code>notifyObservers</code> method to have all the object's
    # observers notified of the change.
    # 
    # @param   o     the observable object.
    # @param   arg   an argument passed to the <code>notifyObservers</code>
    # method.
    def update(o, arg)
      raise NotImplementedError
    end
  end
  
end
