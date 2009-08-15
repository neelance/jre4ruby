require "rjava"

# Copyright 1996-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
  module DigestOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :EOFException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :FilterOutputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :ByteArrayOutputStream
    }
  end
  
  # A transparent stream that updates the associated message digest using
  # the bits going through the stream.
  # 
  # <p>To complete the message digest computation, call one of the
  # <code>digest</code> methods on the associated message
  # digest after your calls to one of this digest ouput stream's
  # {@link #write(int) write} methods.
  # 
  # <p>It is possible to turn this stream on or off (see
  # {@link #on(boolean) on}). When it is on, a call to one of the
  # <code>write</code> methods results in
  # an update on the message digest.  But when it is off, the message
  # digest is not updated. The default is for the stream to be on.
  # 
  # @see MessageDigest
  # @see DigestInputStream
  # 
  # @author Benjamin Renaud
  class DigestOutputStream < DigestOutputStreamImports.const_get :FilterOutputStream
    include_class_members DigestOutputStreamImports
    
    attr_accessor :on
    alias_method :attr_on, :on
    undef_method :on
    alias_method :attr_on=, :on=
    undef_method :on=
    
    # The message digest associated with this stream.
    attr_accessor :digest
    alias_method :attr_digest, :digest
    undef_method :digest
    alias_method :attr_digest=, :digest=
    undef_method :digest=
    
    typesig { [OutputStream, MessageDigest] }
    # Creates a digest output stream, using the specified output stream
    # and message digest.
    # 
    # @param stream the output stream.
    # 
    # @param digest the message digest to associate with this stream.
    def initialize(stream, digest)
      @on = false
      @digest = nil
      super(stream)
      @on = true
      set_message_digest(digest)
    end
    
    typesig { [] }
    # Returns the message digest associated with this stream.
    # 
    # @return the message digest associated with this stream.
    # @see #setMessageDigest(java.security.MessageDigest)
    def get_message_digest
      return @digest
    end
    
    typesig { [MessageDigest] }
    # Associates the specified message digest with this stream.
    # 
    # @param digest the message digest to be associated with this stream.
    # @see #getMessageDigest()
    def set_message_digest(digest)
      @digest = digest
    end
    
    typesig { [::Java::Int] }
    # Updates the message digest (if the digest function is on) using
    # the specified byte, and in any case writes the byte
    # to the output stream. That is, if the digest function is on
    # (see {@link #on(boolean) on}), this method calls
    # <code>update</code> on the message digest associated with this
    # stream, passing it the byte <code>b</code>. This method then
    # writes the byte to the output stream, blocking until the byte
    # is actually written.
    # 
    # @param b the byte to be used for updating and writing to the
    # output stream.
    # 
    # @exception IOException if an I/O error occurs.
    # 
    # @see MessageDigest#update(byte)
    def write(b)
      if (@on)
        @digest.update(b)
      end
      self.attr_out.write(b)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Updates the message digest (if the digest function is on) using
    # the specified subarray, and in any case writes the subarray to
    # the output stream. That is, if the digest function is on (see
    # {@link #on(boolean) on}), this method calls <code>update</code>
    # on the message digest associated with this stream, passing it
    # the subarray specifications. This method then writes the subarray
    # bytes to the output stream, blocking until the bytes are actually
    # written.
    # 
    # @param b the array containing the subarray to be used for updating
    # and writing to the output stream.
    # 
    # @param off the offset into <code>b</code> of the first byte to
    # be updated and written.
    # 
    # @param len the number of bytes of data to be updated and written
    # from <code>b</code>, starting at offset <code>off</code>.
    # 
    # @exception IOException if an I/O error occurs.
    # 
    # @see MessageDigest#update(byte[], int, int)
    def write(b, off, len)
      if (@on)
        @digest.update(b, off, len)
      end
      self.attr_out.write(b, off, len)
    end
    
    typesig { [::Java::Boolean] }
    # Turns the digest function on or off. The default is on.  When
    # it is on, a call to one of the <code>write</code> methods results in an
    # update on the message digest.  But when it is off, the message
    # digest is not updated.
    # 
    # @param on true to turn the digest function on, false to turn it
    # off.
    def on(on)
      @on = on
    end
    
    typesig { [] }
    # Prints a string representation of this digest output stream and
    # its associated message digest object.
    def to_s
      return "[Digest Output Stream] " + RJava.cast_to_string(@digest.to_s)
    end
    
    private
    alias_method :initialize__digest_output_stream, :initialize
  end
  
end
