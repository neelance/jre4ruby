require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module LoadLibraryActionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Action
    }
  end
  
  # A convenience class for loading a system library as a privileged action.
  # 
  # <p>An instance of this class can be used as the argument of
  # <code>AccessController.doPrivileged</code>.
  # 
  # <p>The following code attempts to load the system library named
  # <code>"lib"</code> as a privileged action: <p>
  # 
  # <pre>
  # java.security.AccessController.doPrivileged(new LoadLibraryAction("lib"));
  # </pre>
  # 
  # @author Roland Schemers
  # @see java.security.PrivilegedAction
  # @see java.security.AccessController
  # @since 1.2
  class LoadLibraryAction 
    include_class_members LoadLibraryActionImports
    include Java::Security::PrivilegedAction
    
    attr_accessor :the_lib
    alias_method :attr_the_lib, :the_lib
    undef_method :the_lib
    alias_method :attr_the_lib=, :the_lib=
    undef_method :the_lib=
    
    typesig { [String] }
    # Constructor that takes the name of the system library that needs to be
    # loaded.
    # 
    # <p>The manner in which a library name is mapped to the
    # actual system library is system dependent.
    # 
    # @param theLib the name of the library.
    def initialize(the_lib)
      @the_lib = nil
      @the_lib = the_lib
    end
    
    typesig { [] }
    # Loads the system library whose name was specified in the constructor.
    def run
      System.load_library(@the_lib)
      return nil
    end
    
    private
    alias_method :initialize__load_library_action, :initialize
  end
  
end
