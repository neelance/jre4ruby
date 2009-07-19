require "rjava"

# Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module DeleteOnExitHookImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include ::Java::Util
      include_const ::Java::Io, :JavaFile
    }
  end
  
  # This class holds a set of filenames to be deleted on VM exit through a shutdown hook.
  # A set is used both to prevent double-insertion of the same file as well as offer
  # quick removal.
  class DeleteOnExitHook 
    include_class_members DeleteOnExitHookImports
    
    class_module.module_eval {
      
      def instance
        defined?(@@instance) ? @@instance : @@instance= nil
      end
      alias_method :attr_instance, :instance
      
      def instance=(value)
        @@instance = value
      end
      alias_method :attr_instance=, :instance=
      
      
      def files
        defined?(@@files) ? @@files : @@files= LinkedHashSet.new
      end
      alias_method :attr_files, :files
      
      def files=(value)
        @@files = value
      end
      alias_method :attr_files=, :files=
      
      typesig { [] }
      def hook
        if ((self.attr_instance).nil?)
          self.attr_instance = DeleteOnExitHook.new
        end
        return self.attr_instance
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    class_module.module_eval {
      typesig { [String] }
      def add(file)
        synchronized(self) do
          if ((self.attr_files).nil?)
            raise IllegalStateException.new("Shutdown in progress")
          end
          self.attr_files.add(file)
        end
      end
    }
    
    typesig { [] }
    def run
      the_files = nil
      synchronized((DeleteOnExitHook.class)) do
        the_files = self.attr_files
        self.attr_files = nil
      end
      to_be_deleted = ArrayList.new(the_files)
      # reverse the list to maintain previous jdk deletion order.
      # Last in first deleted.
      Collections.reverse(to_be_deleted)
      to_be_deleted.each do |filename|
        (JavaFile.new(filename)).delete
      end
    end
    
    private
    alias_method :initialize__delete_on_exit_hook, :initialize
  end
  
end
