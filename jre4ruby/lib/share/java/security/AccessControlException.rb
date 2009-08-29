require "rjava"

# Copyright 1997-2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module AccessControlExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
    }
  end
  
  # <p> This exception is thrown by the AccessController to indicate
  # that a requested access (to a critical system resource such as the
  # file system or the network) is denied.
  # 
  # <p> The reason to deny access can vary.  For example, the requested
  # permission might be of an incorrect type,  contain an invalid
  # value, or request access that is not allowed according to the
  # security policy.  Such information should be given whenever
  # possible at the time the exception is thrown.
  # 
  # @author Li Gong
  # @author Roland Schemers
  class AccessControlException < AccessControlExceptionImports.const_get :SecurityException
    include_class_members AccessControlExceptionImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 5138225684096988535 }
      const_attr_reader  :SerialVersionUID
    }
    
    # the permission that caused the exeception to be thrown.
    attr_accessor :perm
    alias_method :attr_perm, :perm
    undef_method :perm
    alias_method :attr_perm=, :perm=
    undef_method :perm=
    
    typesig { [String] }
    # Constructs an <code>AccessControlException</code> with the
    # specified, detailed message.
    # 
    # @param   s   the detail message.
    def initialize(s)
      @perm = nil
      super(s)
    end
    
    typesig { [String, Permission] }
    # Constructs an <code>AccessControlException</code> with the
    # specified, detailed message, and the requested permission that caused
    # the exception.
    # 
    # @param   s   the detail message.
    # @param   p   the permission that caused the exception.
    def initialize(s, p)
      @perm = nil
      super(s)
      @perm = p
    end
    
    typesig { [] }
    # Gets the Permission object associated with this exeception, or
    # null if there was no corresponding Permission object.
    # 
    # @return the Permission object.
    def get_permission
      return @perm
    end
    
    private
    alias_method :initialize__access_control_exception, :initialize
  end
  
end
