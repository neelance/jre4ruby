require "rjava"

# Copyright 2000-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Ch
  module PipeImplImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include ::Java::Io
      include ::Java::Nio::Channels
      include ::Java::Nio::Channels::Spi
    }
  end
  
  class PipeImpl < PipeImplImports.const_get :Pipe
    include_class_members PipeImplImports
    
    # Source and sink channels
    attr_accessor :source
    alias_method :attr_source, :source
    undef_method :source
    alias_method :attr_source=, :source=
    undef_method :source=
    
    attr_accessor :sink
    alias_method :attr_sink, :sink
    undef_method :sink
    alias_method :attr_sink=, :sink=
    undef_method :sink=
    
    typesig { [SelectorProvider] }
    def initialize(sp)
      @source = nil
      @sink = nil
      super()
      fdes = Array.typed(::Java::Int).new(2) { 0 }
      IOUtil.init_pipe(fdes, true)
      sourcefd = FileDescriptor.new
      IOUtil.setfd_val(sourcefd, fdes[0])
      @source = SourceChannelImpl.new(sp, sourcefd)
      sinkfd = FileDescriptor.new
      IOUtil.setfd_val(sinkfd, fdes[1])
      @sink = SinkChannelImpl.new(sp, sinkfd)
    end
    
    typesig { [] }
    def source
      return @source
    end
    
    typesig { [] }
    def sink
      return @sink
    end
    
    private
    alias_method :initialize__pipe_impl, :initialize
  end
  
end
