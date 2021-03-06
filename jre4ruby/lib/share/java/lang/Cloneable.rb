require "rjava"

# Copyright 1995-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module CloneableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # A class implements the <code>Cloneable</code> interface to
  # indicate to the {@link java.lang.Object#clone()} method that it
  # is legal for that method to make a
  # field-for-field copy of instances of that class.
  # <p>
  # Invoking Object's clone method on an instance that does not implement the
  # <code>Cloneable</code> interface results in the exception
  # <code>CloneNotSupportedException</code> being thrown.
  # <p>
  # By convention, classes that implement this interface should override
  # <tt>Object.clone</tt> (which is protected) with a public method.
  # See {@link java.lang.Object#clone()} for details on overriding this
  # method.
  # <p>
  # Note that this interface does <i>not</i> contain the <tt>clone</tt> method.
  # Therefore, it is not possible to clone an object merely by virtue of the
  # fact that it implements this interface.  Even if the clone method is invoked
  # reflectively, there is no guarantee that it will succeed.
  # 
  # @author  unascribed
  # @see     java.lang.CloneNotSupportedException
  # @see     java.lang.Object#clone()
  # @since   JDK1.0
  module Cloneable
    include_class_members CloneableImports
  end
  
end
