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
module Java::Lang
  # The set of warnings that are to be suppressed by the compiler in the
  # annotated element.  Duplicate names are permitted.  The second and
  # successive occurrences of a name are ignored.  The presence of
  # unrecognized warning names is <i>not</i> an error: Compilers must
  # ignore any warning names they do not recognize.  They are, however,
  # free to emit a warning if an annotation contains an unrecognized
  # warning name.
  # 
  # <p>Compiler vendors should document the warning names they support in
  # conjunction with this annotation type. They are encouraged to cooperate
  # to ensure that the same names work across multiple compilers.
  module SuppressWarningsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Annotation
      include_const ::Java::Lang::Annotation, :ElementType
    }
  end
  
  # Indicates that the named compiler warnings should be suppressed in the
  # annotated element (and in all program elements contained in the annotated
  # element).  Note that the set of warnings suppressed in a given element is
  # a superset of the warnings suppressed in all containing elements.  For
  # example, if you annotate a class to suppress one warning and annotate a
  # method to suppress another, both warnings will be suppressed in the method.
  # 
  # <p>As a matter of style, programmers should always use this annotation
  # on the most deeply nested element where it is effective.  If you want to
  # suppress a warning in a particular method, you should annotate that
  # method rather than its class.
  # 
  # @since 1.5
  # @author Josh Bloch
  module SuppressWarnings
    include_class_members SuppressWarningsImports
  end
  
end