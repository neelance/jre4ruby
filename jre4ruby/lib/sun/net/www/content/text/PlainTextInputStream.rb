require "rjava"

# 
# Copyright 1996 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Content::Text
  module PlainTextInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Content::Text
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :FilterInputStream
    }
  end
  
  # 
  # PlainTextInputStream class extends the FilterInputStream class.
  # Currently all calls to the PlainTextInputStream object will call
  # the corresponding methods in the FilterInputStream class.  Hence
  # for now its use is more semantic.
  # 
  # @author Sunita Mani
  class PlainTextInputStream < PlainTextInputStreamImports.const_get :FilterInputStream
    include_class_members PlainTextInputStreamImports
    
    typesig { [InputStream] }
    # 
    # Calls FilterInputStream's constructor.
    # @param an InputStream
    def initialize(is)
      super(is)
    end
    
    private
    alias_method :initialize__plain_text_input_stream, :initialize
  end
  
end
