require "rjava"

# 
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
  module DigestInputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :EOFException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :FilterInputStream
      include_const ::Java::Io, :PrintStream
      include_const ::Java::Io, :ByteArrayInputStream
    }
  end
  
  # 
  # A transparent stream that updates the associated message digest using
  # the bits going through the stream.
  # 
  # <p>To complete the message digest computation, call one of the
  # <code>digest</code> methods on the associated message
  # digest after your calls to one of this digest input stream's
  # {@link #read() read} methods.
  # 
  # <p>It is possible to turn this stream on or off (see
  # {@link #on(boolean) on}). When it is on, a call to one of the
  # <code>read</code> methods
  # results in an update on the message digest.  But when it is off,
  # the message digest is not updated. The default is for the stream
  # to be on.
  # 
  # <p>Note that digest objects can compute only one digest (see
  # {@link MessageDigest}),
  # so that in order to compute intermediate digests, a caller should
  # retain a handle onto the digest object, and clone it for each
  # digest to be computed, leaving the orginal digest untouched.
  # 
  # @see MessageDigest
  # 
  # @see DigestOutputStream
  # 
  # @author Benjamin Renaud
  class DigestInputStream < DigestInputStreamImports.const_get :FilterInputStream
    include_class_members DigestInputStreamImports
    
    # NOTE: This should be made a generic UpdaterInputStream
    # Are we on or off?
    attr_accessor :on
    alias_method :attr_on, :on
    undef_method :on
    alias_method :attr_on=, :on=
    undef_method :on=
    
    # 
    # The message digest associated with this stream.
    attr_accessor :digest
    alias_method :attr_digest, :digest
    undef_method :digest
    alias_method :attr_digest=, :digest=
    undef_method :digest=
    
    typesig { [InputStream, MessageDigest] }
    # 
    # Creates a digest input stream, using the specified input stream
    # and message digest.
    # 
    # @param stream the input stream.
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
    # 
    # Returns the message digest associated with this stream.
    # 
    # @return the message digest associated with this stream.
    # @see #setMessageDigest(java.security.MessageDigest)
    def get_message_digest
      return @digest
    end
    
    typesig { [MessageDigest] }
    # 
    # Associates the specified message digest with this stream.
    # 
    # @param digest the message digest to be associated with this stream.
    # @see #getMessageDigest()
    def set_message_digest(digest)
      @digest = digest
    end
    
    typesig { [] }
    # 
    # Reads a byte, and updates the message digest (if the digest
    # function is on).  That is, this method reads a byte from the
    # input stream, blocking until the byte is actually read. If the
    # digest function is on (see {@link #on(boolean) on}), this method
    # will then call <code>update</code> on the message digest associated
    # with this stream, passing it the byte read.
    # 
    # @return the byte read.
    # 
    # @exception IOException if an I/O error occurs.
    # 
    # @see MessageDigest#update(byte)
    def read
      ch = self.attr_in.read
      if (@on && !(ch).equal?(-1))
        @digest.update(ch)
      end
      return ch
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # 
    # Reads into a byte array, and updates the message digest (if the
    # digest function is on).  That is, this method reads up to
    # <code>len</code> bytes from the input stream into the array
    # <code>b</code>, starting at offset <code>off</code>. This method
    # blocks until the data is actually
    # read. If the digest function is on (see
    # {@link #on(boolean) on}), this method will then call <code>update</code>
    # on the message digest associated with this stream, passing it
    # the data.
    # 
    # @param b the array into which the data is read.
    # 
    # @param off the starting offset into <code>b</code> of where the
    # data should be placed.
    # 
    # @param len the maximum number of bytes to be read from the input
    # stream into b, starting at offset <code>off</code>.
    # 
    # @return  the actual number of bytes read. This is less than
    # <code>len</code> if the end of the stream is reached prior to
    # reading <code>len</code> bytes. -1 is returned if no bytes were
    # read because the end of the stream had already been reached when
    # the call was made.
    # 
    # @exception IOException if an I/O error occurs.
    # 
    # @see MessageDigest#update(byte[], int, int)
    def read(b, off, len)
      result = self.attr_in.read(b, off, len)
      if (@on && !(result).equal?(-1))
        @digest.update(b, off, result)
      end
      return result
    end
    
    typesig { [::Java::Boolean] }
    # 
    # Turns the digest function on or off. The default is on.  When
    # it is on, a call to one of the <code>read</code> methods results in an
    # update on the message digest.  But when it is off, the message
    # digest is not updated.
    # 
    # @param on true to turn the digest function on, false to turn
    # it off.
    def on(on)
      @on = on
    end
    
    typesig { [] }
    # 
    # Prints a string representation of this digest input stream and
    # its associated message digest object.
    def to_s
      return "[Digest Input Stream] " + (@digest.to_s).to_s
    end
    
    private
    alias_method :initialize__digest_input_stream, :initialize
  end
  
end
