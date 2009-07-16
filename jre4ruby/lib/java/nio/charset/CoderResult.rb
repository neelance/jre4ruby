require "rjava"

# 
# Copyright 2001-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio::Charset
  module CoderResultImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Charset
      include_const ::Java::Lang::Ref, :WeakReference
      include ::Java::Nio
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :HashMap
    }
  end
  
  # 
  # A description of the result state of a coder.
  # 
  # <p> A charset coder, that is, either a decoder or an encoder, consumes bytes
  # (or characters) from an input buffer, translates them, and writes the
  # resulting characters (or bytes) to an output buffer.  A coding process
  # terminates for one of four categories of reasons, which are described by
  # instances of this class:
  # 
  # <ul>
  # 
  # <li><p> <i>Underflow</i> is reported when there is no more input to be
  # processed, or there is insufficient input and additional input is
  # required.  This condition is represented by the unique result object
  # {@link #UNDERFLOW}, whose {@link #isUnderflow() isUnderflow} method
  # returns <tt>true</tt>.  </p></li>
  # 
  # <li><p> <i>Overflow</i> is reported when there is insufficient room
  # remaining in the output buffer.  This condition is represented by the
  # unique result object {@link #OVERFLOW}, whose {@link #isOverflow()
  # isOverflow} method returns <tt>true</tt>.  </p></li>
  # 
  # <li><p> A <i>malformed-input error</i> is reported when a sequence of
  # input units is not well-formed.  Such errors are described by instances of
  # this class whose {@link #isMalformed() isMalformed} method returns
  # <tt>true</tt> and whose {@link #length() length} method returns the length
  # of the malformed sequence.  There is one unique instance of this class for
  # all malformed-input errors of a given length.  </p></li>
  # 
  # <li><p> An <i>unmappable-character error</i> is reported when a sequence
  # of input units denotes a character that cannot be represented in the
  # output charset.  Such errors are described by instances of this class
  # whose {@link #isUnmappable() isUnmappable} method returns <tt>true</tt> and
  # whose {@link #length() length} method returns the length of the input
  # sequence denoting the unmappable character.  There is one unique instance
  # of this class for all unmappable-character errors of a given length.
  # </p></li>
  # 
  # </ul>
  # 
  # For convenience, the {@link #isError() isError} method returns <tt>true</tt>
  # for result objects that describe malformed-input and unmappable-character
  # errors but <tt>false</tt> for those that describe underflow or overflow
  # conditions.  </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class CoderResult 
    include_class_members CoderResultImports
    
    class_module.module_eval {
      const_set_lazy(:CR_UNDERFLOW) { 0 }
      const_attr_reader  :CR_UNDERFLOW
      
      const_set_lazy(:CR_OVERFLOW) { 1 }
      const_attr_reader  :CR_OVERFLOW
      
      const_set_lazy(:CR_ERROR_MIN) { 2 }
      const_attr_reader  :CR_ERROR_MIN
      
      const_set_lazy(:CR_MALFORMED) { 2 }
      const_attr_reader  :CR_MALFORMED
      
      const_set_lazy(:CR_UNMAPPABLE) { 3 }
      const_attr_reader  :CR_UNMAPPABLE
      
      const_set_lazy(:Names) { Array.typed(String).new(["UNDERFLOW", "OVERFLOW", "MALFORMED", "UNMAPPABLE"]) }
      const_attr_reader  :Names
    }
    
    attr_accessor :type
    alias_method :attr_type, :type
    undef_method :type
    alias_method :attr_type=, :type=
    undef_method :type=
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    typesig { [::Java::Int, ::Java::Int] }
    def initialize(type, length)
      @type = 0
      @length = 0
      @type = type
      @length = length
    end
    
    typesig { [] }
    # 
    # Returns a string describing this coder result.
    # 
    # @return  A descriptive string
    def to_s
      nm = Names[@type]
      return is_error ? nm + "[" + (@length).to_s + "]" : nm
    end
    
    typesig { [] }
    # 
    # Tells whether or not this object describes an underflow condition.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this object denotes underflow
    def is_underflow
      return ((@type).equal?(CR_UNDERFLOW))
    end
    
    typesig { [] }
    # 
    # Tells whether or not this object describes an overflow condition.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this object denotes overflow
    def is_overflow
      return ((@type).equal?(CR_OVERFLOW))
    end
    
    typesig { [] }
    # 
    # Tells whether or not this object describes an error condition.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this object denotes either a
    # malformed-input error or an unmappable-character error
    def is_error
      return (@type >= CR_ERROR_MIN)
    end
    
    typesig { [] }
    # 
    # Tells whether or not this object describes a malformed-input error.
    # </p>
    # 
    # @return  <tt>true</tt> if, and only if, this object denotes a
    # malformed-input error
    def is_malformed
      return ((@type).equal?(CR_MALFORMED))
    end
    
    typesig { [] }
    # 
    # Tells whether or not this object describes an unmappable-character
    # error.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this object denotes an
    # unmappable-character error
    def is_unmappable
      return ((@type).equal?(CR_UNMAPPABLE))
    end
    
    typesig { [] }
    # 
    # Returns the length of the erroneous input described by this
    # object&nbsp;&nbsp;<i>(optional operation)</i>.  </p>
    # 
    # @return  The length of the erroneous input, a positive integer
    # 
    # @throws  UnsupportedOperationException
    # If this object does not describe an error condition, that is,
    # if the {@link #isError() isError} does not return <tt>true</tt>
    def length
      if (!is_error)
        raise UnsupportedOperationException.new
      end
      return @length
    end
    
    class_module.module_eval {
      # 
      # Result object indicating underflow, meaning that either the input buffer
      # has been completely consumed or, if the input buffer is not yet empty,
      # that additional input is required.  </p>
      const_set_lazy(:UNDERFLOW) { CoderResult.new(CR_UNDERFLOW, 0) }
      const_attr_reader  :UNDERFLOW
      
      # 
      # Result object indicating overflow, meaning that there is insufficient
      # room in the output buffer.  </p>
      const_set_lazy(:OVERFLOW) { CoderResult.new(CR_OVERFLOW, 0) }
      const_attr_reader  :OVERFLOW
      
      const_set_lazy(:Cache) { Class.new do
        include_class_members CoderResult
        
        attr_accessor :cache
        alias_method :attr_cache, :cache
        undef_method :cache
        alias_method :attr_cache=, :cache=
        undef_method :cache=
        
        typesig { [::Java::Int] }
        def create(len)
          raise NotImplementedError
        end
        
        typesig { [::Java::Int] }
        def get(len)
          synchronized(self) do
            if (len <= 0)
              raise IllegalArgumentException.new("Non-positive length")
            end
            k = len
            w = nil
            e = nil
            if ((@cache).nil?)
              @cache = HashMap.new
            else
              if (!((w = @cache.get(k))).nil?)
                e = w.get
              end
            end
            if ((e).nil?)
              e = create(len)
              @cache.put(k, WeakReference.new(e))
            end
            return e
          end
        end
        
        typesig { [] }
        def initialize
          @cache = nil
        end
        
        private
        alias_method :initialize__cache, :initialize
      end }
      
      
      def malformed_cache
        defined?(@@malformed_cache) ? @@malformed_cache : @@malformed_cache= Class.new(Cache.class == Class ? Cache : Object) do
          extend LocalClass
          include_class_members CoderResult
          include Cache if Cache.class == Module
          
          typesig { [::Java::Int] }
          define_method :create do |len|
            return CoderResult.new(CR_MALFORMED, len)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      alias_method :attr_malformed_cache, :malformed_cache
      
      def malformed_cache=(value)
        @@malformed_cache = value
      end
      alias_method :attr_malformed_cache=, :malformed_cache=
      
      typesig { [::Java::Int] }
      # 
      # Static factory method that returns the unique object describing a
      # malformed-input error of the given length.  </p>
      # 
      # @return  The requested coder-result object
      def malformed_for_length(length)
        return self.attr_malformed_cache.get(length)
      end
      
      
      def unmappable_cache
        defined?(@@unmappable_cache) ? @@unmappable_cache : @@unmappable_cache= Class.new(Cache.class == Class ? Cache : Object) do
          extend LocalClass
          include_class_members CoderResult
          include Cache if Cache.class == Module
          
          typesig { [::Java::Int] }
          define_method :create do |len|
            return CoderResult.new(CR_UNMAPPABLE, len)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      alias_method :attr_unmappable_cache, :unmappable_cache
      
      def unmappable_cache=(value)
        @@unmappable_cache = value
      end
      alias_method :attr_unmappable_cache=, :unmappable_cache=
      
      typesig { [::Java::Int] }
      # 
      # Static factory method that returns the unique result object describing
      # an unmappable-character error of the given length.  </p>
      # 
      # @return  The requested coder-result object
      def unmappable_for_length(length)
        return self.attr_unmappable_cache.get(length)
      end
    }
    
    typesig { [] }
    # 
    # Throws an exception appropriate to the result described by this object.
    # </p>
    # 
    # @throws  BufferUnderflowException
    # If this object is {@link #UNDERFLOW}
    # 
    # @throws  BufferOverflowException
    # If this object is {@link #OVERFLOW}
    # 
    # @throws  MalformedInputException
    # If this object represents a malformed-input error; the
    # exception's length value will be that of this object
    # 
    # @throws  UnmappableCharacterException
    # If this object represents an unmappable-character error; the
    # exceptions length value will be that of this object
    def throw_exception
      case (@type)
      when CR_UNDERFLOW
        raise BufferUnderflowException.new
      when CR_OVERFLOW
        raise BufferOverflowException.new
      when CR_MALFORMED
        raise MalformedInputException.new(@length)
      when CR_UNMAPPABLE
        raise UnmappableCharacterException.new(@length)
      else
        raise AssertError if not (false)
      end
    end
    
    private
    alias_method :initialize__coder_result, :initialize
  end
  
end
