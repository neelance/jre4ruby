require "rjava"

# Copyright 2002-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Action
  module OpenFileInputStreamActionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Action
      include ::Java::Io
      include_const ::Java::Security, :PrivilegedExceptionAction
    }
  end
  
  # A convenience class for opening a FileInputStream as a privileged action.
  # 
  # @author Andreas Sterbenz
  class OpenFileInputStreamAction 
    include_class_members OpenFileInputStreamActionImports
    include PrivilegedExceptionAction
    
    attr_accessor :file
    alias_method :attr_file, :file
    undef_method :file
    alias_method :attr_file=, :file=
    undef_method :file=
    
    typesig { [JavaFile] }
    def initialize(file)
      @file = nil
      @file = file
    end
    
    typesig { [String] }
    def initialize(filename)
      @file = nil
      @file = JavaFile.new(filename)
    end
    
    typesig { [] }
    def run
      return FileInputStream.new(@file)
    end
    
    private
    alias_method :initialize__open_file_input_stream_action, :initialize
  end
  
end
