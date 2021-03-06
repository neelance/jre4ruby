require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Annotation
  module RetentionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Annotation
    }
  end
  
  # Indicates how long annotations with the annotated type are to
  # be retained.  If no Retention annotation is present on
  # an annotation type declaration, the retention policy defaults to
  # {@code RetentionPolicy.CLASS}.
  # 
  # <p>A Retention meta-annotation has effect only if the
  # meta-annotated type is used directly for annotation.  It has no
  # effect if the meta-annotated type is used as a member type in
  # another annotation type.
  # 
  # @author  Joshua Bloch
  # @since 1.5
  module Retention
    include_class_members RetentionImports
  end
  
end
