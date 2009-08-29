require "rjava"

# Copyright 1999 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# Basic .au and .snd audio handler.
# @author  Jeff Nisewanger
module Sun::Net::Www::Content::Audio
  module BasicImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Content::Audio
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Sun::Applet, :AppletAudioClip
    }
  end
  
  # Returns an AppletAudioClip object.
  # This provides backwards compatibility with the behavior
  # of ClassLoader.getResource().getContent() on JDK1.1.
  class Basic < BasicImports.const_get :ContentHandler
    include_class_members BasicImports
    
    typesig { [URLConnection] }
    def get_content(uc)
      return AppletAudioClip.new(uc)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize_basic, :initialize
  end
  
end
