require "rjava"

# Copyright 2000-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Prefs
  module FileSystemPreferencesFactoryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
    }
  end
  
  # Factory for FileSystemPreferences.  This class allows FileSystemPreferences
  # to be installed as the Preferences implementations via the
  # java.util.prefs.PreferencesFactory system property.
  # 
  # @author  Josh Bloch
  # @see     FileSystemPreferences
  # @see     Preferences
  # @since   1.4
  class FileSystemPreferencesFactory 
    include_class_members FileSystemPreferencesFactoryImports
    include PreferencesFactory
    
    typesig { [] }
    def user_root
      return FileSystemPreferences.get_user_root
    end
    
    typesig { [] }
    def system_root
      return FileSystemPreferences.get_system_root
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__file_system_preferences_factory, :initialize
  end
  
end
