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
module Java::Util
  module RandomAccessImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
    }
  end
  
  # Marker interface used by <tt>List</tt> implementations to indicate that
  # they support fast (generally constant time) random access.  The primary
  # purpose of this interface is to allow generic algorithms to alter their
  # behavior to provide good performance when applied to either random or
  # sequential access lists.
  # 
  # <p>The best algorithms for manipulating random access lists (such as
  # <tt>ArrayList</tt>) can produce quadratic behavior when applied to
  # sequential access lists (such as <tt>LinkedList</tt>).  Generic list
  # algorithms are encouraged to check whether the given list is an
  # <tt>instanceof</tt> this interface before applying an algorithm that would
  # provide poor performance if it were applied to a sequential access list,
  # and to alter their behavior if necessary to guarantee acceptable
  # performance.
  # 
  # <p>It is recognized that the distinction between random and sequential
  # access is often fuzzy.  For example, some <tt>List</tt> implementations
  # provide asymptotically linear access times if they get huge, but constant
  # access times in practice.  Such a <tt>List</tt> implementation
  # should generally implement this interface.  As a rule of thumb, a
  # <tt>List</tt> implementation should implement this interface if,
  # for typical instances of the class, this loop:
  # <pre>
  # for (int i=0, n=list.size(); i &lt; n; i++)
  # list.get(i);
  # </pre>
  # runs faster than this loop:
  # <pre>
  # for (Iterator i=list.iterator(); i.hasNext(); )
  # i.next();
  # </pre>
  # 
  # <p>This interface is a member of the
  # <a href="{@docRoot}/../technotes/guides/collections/index.html">
  # Java Collections Framework</a>.
  # 
  # @since 1.4
  module RandomAccess
    include_class_members RandomAccessImports
  end
  
end
