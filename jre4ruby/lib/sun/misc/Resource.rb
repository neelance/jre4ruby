require "rjava"

# Copyright 1998-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module ResourceImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Net, :URL
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InterruptedIOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Security, :CodeSigner
      include_const ::Java::Util::Jar, :Manifest
      include_const ::Java::Util::Jar, :Attributes
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Sun::Nio, :ByteBuffered
    }
  end
  
  # This class is used to represent a Resource that has been loaded
  # from the class path.
  # 
  # @author  David Connelly
  # @since   1.2
  class Resource 
    include_class_members ResourceImports
    
    typesig { [] }
    # Returns the name of the Resource.
    def get_name
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the URL of the Resource.
    def get_url
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the CodeSource URL for the Resource.
    def get_code_source_url
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns an InputStream for reading the Resource data.
    def get_input_stream
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the length of the Resource data, or -1 if unknown.
    def get_content_length
      raise NotImplementedError
    end
    
    attr_accessor :cis
    alias_method :attr_cis, :cis
    undef_method :cis
    alias_method :attr_cis=, :cis=
    undef_method :cis=
    
    typesig { [] }
    # Cache result in case getBytes is called after getByteBuffer.
    def cached_input_stream
      synchronized(self) do
        if ((@cis).nil?)
          @cis = get_input_stream
        end
        return @cis
      end
    end
    
    typesig { [] }
    # Returns the Resource data as an array of bytes.
    def get_bytes
      b = nil
      # Get stream before content length so that a FileNotFoundException
      # can propagate upwards without being caught too early
      in_ = cached_input_stream
      # This code has been uglified to protect against interrupts.
      # Even if a thread has been interrupted when loading resources,
      # the IO should not abort, so must carefully retry, failing only
      # if the retry leads to some other IO exception.
      is_interrupted = JavaThread.interrupted
      len = 0
      loop do
        begin
          len = get_content_length
          break
        rescue InterruptedIOException => iioe
          JavaThread.interrupted
          is_interrupted = true
        end
      end
      begin
        if (!(len).equal?(-1))
          # Read exactly len bytes from the input stream
          b = Array.typed(::Java::Byte).new(len) { 0 }
          while (len > 0)
            n = 0
            begin
              n = in_.read(b, b.attr_length - len, len)
            rescue InterruptedIOException => iioe
              JavaThread.interrupted
              is_interrupted = true
            end
            if ((n).equal?(-1))
              raise IOException.new("unexpected EOF")
            end
            len -= n
          end
        else
          # Read until end of stream is reached
          b = Array.typed(::Java::Byte).new(1024) { 0 }
          total = 0
          loop do
            len = 0
            begin
              len = in_.read(b, total, b.attr_length - total)
              if ((len).equal?(-1))
                break
              end
            rescue InterruptedIOException => iioe
              JavaThread.interrupted
              is_interrupted = true
            end
            total += len
            if (total >= b.attr_length)
              tmp = Array.typed(::Java::Byte).new(total * 2) { 0 }
              System.arraycopy(b, 0, tmp, 0, total)
              b = tmp
            end
          end
          # Trim array to correct size, if necessary
          if (!(total).equal?(b.attr_length))
            tmp = Array.typed(::Java::Byte).new(total) { 0 }
            System.arraycopy(b, 0, tmp, 0, total)
            b = tmp
          end
        end
      ensure
        begin
          in_.close
        rescue InterruptedIOException => iioe
          is_interrupted = true
        rescue IOException => ignore
        end
        if (is_interrupted)
          JavaThread.current_thread.interrupt
        end
      end
      return b
    end
    
    typesig { [] }
    # Returns the Resource data as a ByteBuffer, but only if the input stream
    # was implemented on top of a ByteBuffer. Return <tt>null</tt> otherwise.
    def get_byte_buffer
      in_ = cached_input_stream
      if (in_.is_a?(ByteBuffered))
        return (in_).get_byte_buffer
      end
      return nil
    end
    
    typesig { [] }
    # Returns the Manifest for the Resource, or null if none.
    def get_manifest
      return nil
    end
    
    typesig { [] }
    # Returns theCertificates for the Resource, or null if none.
    def get_certificates
      return nil
    end
    
    typesig { [] }
    # Returns the code signers for the Resource, or null if none.
    def get_code_signers
      return nil
    end
    
    typesig { [] }
    def initialize
      @cis = nil
    end
    
    private
    alias_method :initialize__resource, :initialize
  end
  
end
