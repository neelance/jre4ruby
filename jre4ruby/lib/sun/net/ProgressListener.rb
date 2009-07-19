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
  module ProgressListenerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
      include_const ::Java::Util, :EventListener
    }
  end
  
  # ProgressListener is an interface to be implemented by parties
  # interested to be notified of progress in network input stream.
  # 
  # @author Stanley Man-Kit Ho
  module ProgressListener
    include_class_members ProgressListenerImports
    include EventListener
    
    typesig { [ProgressEvent] }
    # Start progress.
    def progress_start(evt)
      raise NotImplementedError
    end
    
    typesig { [ProgressEvent] }
    # Update progress.
    def progress_update(evt)
      raise NotImplementedError
    end
    
    typesig { [ProgressEvent] }
    # Finish progress.
    def progress_finish(evt)
      raise NotImplementedError
    end
  end
  
end
