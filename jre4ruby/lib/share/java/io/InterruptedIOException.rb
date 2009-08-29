require "rjava"

# Copyright 1995-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
  module InterruptedIOExceptionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Signals that an I/O operation has been interrupted. An
  # <code>InterruptedIOException</code> is thrown to indicate that an
  # input or output transfer has been terminated because the thread
  # performing it was interrupted. The field {@link #bytesTransferred}
  # indicates how many bytes were successfully transferred before
  # the interruption occurred.
  # 
  # @author  unascribed
  # @see     java.io.InputStream
  # @see     java.io.OutputStream
  # @see     java.lang.Thread#interrupt()
  # @since   JDK1.0
  class InterruptedIOException < InterruptedIOExceptionImports.const_get :IOException
    include_class_members InterruptedIOExceptionImports
    
    typesig { [] }
    # Constructs an <code>InterruptedIOException</code> with
    # <code>null</code> as its error detail message.
    def initialize
      @bytes_transferred = 0
      super()
      @bytes_transferred = 0
    end
    
    typesig { [String] }
    # Constructs an <code>InterruptedIOException</code> with the
    # specified detail message. The string <code>s</code> can be
    # retrieved later by the
    # <code>{@link java.lang.Throwable#getMessage}</code>
    # method of class <code>java.lang.Throwable</code>.
    # 
    # @param   s   the detail message.
    def initialize(s)
      @bytes_transferred = 0
      super(s)
      @bytes_transferred = 0
    end
    
    # Reports how many bytes had been transferred as part of the I/O
    # operation before it was interrupted.
    # 
    # @serial
    attr_accessor :bytes_transferred
    alias_method :attr_bytes_transferred, :bytes_transferred
    undef_method :bytes_transferred
    alias_method :attr_bytes_transferred=, :bytes_transferred=
    undef_method :bytes_transferred=
    
    private
    alias_method :initialize__interrupted_ioexception, :initialize
  end
  
end
