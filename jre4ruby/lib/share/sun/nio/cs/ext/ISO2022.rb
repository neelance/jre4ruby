require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Nio::Cs::Ext
  module ISO2022Imports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Sun::Nio::Cs, :Surrogate
    }
  end
  
  class ISO2022 < ISO2022Imports.const_get :Charset
    include_class_members ISO2022Imports
    
    class_module.module_eval {
      const_set_lazy(:ISO_ESC) { 0x1b }
      const_attr_reader  :ISO_ESC
      
      const_set_lazy(:ISO_SI) { 0xf }
      const_attr_reader  :ISO_SI
      
      const_set_lazy(:ISO_SO) { 0xe }
      const_attr_reader  :ISO_SO
      
      const_set_lazy(:ISO_SS2_7) { 0x4e }
      const_attr_reader  :ISO_SS2_7
      
      const_set_lazy(:ISO_SS3_7) { 0x4f }
      const_attr_reader  :ISO_SS3_7
      
      const_set_lazy(:MSB) { 0x80 }
      const_attr_reader  :MSB
      
      const_set_lazy(:REPLACE_CHAR) { Character.new(0xFFFD) }
      const_attr_reader  :REPLACE_CHAR
      
      const_set_lazy(:MinDesignatorLength) { 3 }
      const_attr_reader  :MinDesignatorLength
    }
    
    typesig { [String, Array.typed(String)] }
    def initialize(csname, aliases)
      super(csname, aliases)
    end
    
    typesig { [] }
    def new_decoder
      return Decoder.new(self)
    end
    
    typesig { [] }
    def new_encoder
      return Encoder.new(self)
    end
    
    class_module.module_eval {
      const_set_lazy(:Decoder) { Class.new(CharsetDecoder) do
        include_class_members ISO2022
        
        # Value to be filled by subclass
        attr_accessor :sodesig
        alias_method :attr_sodesig, :sodesig
        undef_method :sodesig
        alias_method :attr_sodesig=, :sodesig=
        undef_method :sodesig=
        
        attr_accessor :ss2desig
        alias_method :attr_ss2desig, :ss2desig
        undef_method :ss2desig
        alias_method :attr_ss2desig=, :ss2desig=
        undef_method :ss2desig=
        
        attr_accessor :ss3desig
        alias_method :attr_ss3desig, :ss3desig
        undef_method :ss3desig
        alias_method :attr_ss3desig=, :ss3desig=
        undef_method :ss3desig=
        
        attr_accessor :sodecoder
        alias_method :attr_sodecoder, :sodecoder
        undef_method :sodecoder
        alias_method :attr_sodecoder=, :sodecoder=
        undef_method :sodecoder=
        
        attr_accessor :ss2decoder
        alias_method :attr_ss2decoder, :ss2decoder
        undef_method :ss2decoder
        alias_method :attr_ss2decoder=, :ss2decoder=
        undef_method :ss2decoder=
        
        attr_accessor :ss3decoder
        alias_method :attr_ss3decoder, :ss3decoder
        undef_method :ss3decoder
        alias_method :attr_ss3decoder=, :ss3decoder=
        undef_method :ss3decoder=
        
        class_module.module_eval {
          const_set_lazy(:SOFlag) { 0 }
          const_attr_reader  :SOFlag
          
          const_set_lazy(:SS2Flag) { 1 }
          const_attr_reader  :SS2Flag
          
          const_set_lazy(:SS3Flag) { 2 }
          const_attr_reader  :SS3Flag
        }
        
        attr_accessor :cur_sodes
        alias_method :attr_cur_sodes, :cur_sodes
        undef_method :cur_sodes
        alias_method :attr_cur_sodes=, :cur_sodes=
        undef_method :cur_sodes=
        
        attr_accessor :cur_ss2des
        alias_method :attr_cur_ss2des, :cur_ss2des
        undef_method :cur_ss2des
        alias_method :attr_cur_ss2des=, :cur_ss2des=
        undef_method :cur_ss2des=
        
        attr_accessor :cur_ss3des
        alias_method :attr_cur_ss3des, :cur_ss3des
        undef_method :cur_ss3des
        alias_method :attr_cur_ss3des=, :cur_ss3des=
        undef_method :cur_ss3des=
        
        attr_accessor :shiftout
        alias_method :attr_shiftout, :shiftout
        undef_method :shiftout
        alias_method :attr_shiftout=, :shiftout=
        undef_method :shiftout=
        
        attr_accessor :tmp_decoder
        alias_method :attr_tmp_decoder, :tmp_decoder
        undef_method :tmp_decoder
        alias_method :attr_tmp_decoder=, :tmp_decoder=
        undef_method :tmp_decoder=
        
        typesig { [self::Charset] }
        def initialize(cs)
          @sodesig = nil
          @ss2desig = nil
          @ss3desig = nil
          @sodecoder = nil
          @ss2decoder = nil
          @ss3decoder = nil
          @cur_sodes = 0
          @cur_ss2des = 0
          @cur_ss3des = 0
          @shiftout = false
          @tmp_decoder = nil
          super(cs, 1.0, 1.0)
          @ss2desig = nil
          @ss3desig = nil
          @ss2decoder = nil
          @ss3decoder = nil
        end
        
        typesig { [] }
        def impl_reset
          @cur_sodes = 0
          @cur_ss2des = 0
          @cur_ss3des = 0
          @shiftout = false
        end
        
        typesig { [::Java::Byte, ::Java::Byte, ::Java::Byte] }
        def decode(byte1, byte2, shift_flag)
          byte1 |= MSB
          byte2 |= MSB
          tmp_byte = Array.typed(::Java::Byte).new([byte1, byte2])
          tmp_char = CharArray.new(1)
          i = 0
          tmp_index = 0
          case (shift_flag)
          when self.class::SOFlag
            tmp_index = @cur_sodes
            @tmp_decoder = @sodecoder
          when self.class::SS2Flag
            tmp_index = @cur_ss2des
            @tmp_decoder = @ss2decoder
          when self.class::SS3Flag
            tmp_index = @cur_ss3des
            @tmp_decoder = @ss3decoder
          end
          if (!(@tmp_decoder).nil?)
            i = 0
            while i < @tmp_decoder.attr_length
              if ((tmp_index).equal?(i))
                begin
                  bb = ByteBuffer.wrap(tmp_byte, 0, 2)
                  cc = CharBuffer.wrap(tmp_char, 0, 1)
                  @tmp_decoder[i].decode(bb, cc, true)
                  cc.flip
                  return cc.get
                rescue self.class::JavaException => e
                end
              end
              i += 1
            end
          end
          return REPLACE_CHAR
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, Array.typed(Array.typed(::Java::Byte))] }
        def find_desig(in_, sp, sl, desigs)
          if ((desigs).nil?)
            return -1
          end
          i = 0
          while (i < desigs.attr_length)
            if (!(desigs[i]).nil? && sl - sp >= desigs[i].attr_length)
              j = 0
              while (j < desigs[i].attr_length && (in_[sp + j]).equal?(desigs[i][j]))
                j += 1
              end
              if ((j).equal?(desigs[i].attr_length))
                return i
              end
            end
            i += 1
          end
          return -1
        end
        
        typesig { [self::ByteBuffer, Array.typed(Array.typed(::Java::Byte))] }
        def find_desig_buf(in_, desigs)
          if ((desigs).nil?)
            return -1
          end
          i = 0
          while (i < desigs.attr_length)
            if (!(desigs[i]).nil? && in_.remaining >= desigs[i].attr_length)
              j = 0
              in_.mark
              while (j < desigs[i].attr_length && (in_.get).equal?(desigs[i][j]))
                j += 1
              end
              if ((j).equal?(desigs[i].attr_length))
                return i
              end
              in_.reset
            end
            i += 1
          end
          return -1
        end
        
        typesig { [self::ByteBuffer, self::CharBuffer] }
        def decode_array_loop(src, dst)
          sa = src.array
          sp = src.array_offset + src.position
          sl = src.array_offset + src.limit
          raise AssertError if not ((sp <= sl))
          sp = (sp <= sl ? sp : sl)
          da = dst.array
          dp = dst.array_offset + dst.position
          dl = dst.array_offset + dst.limit
          raise AssertError if not ((dp <= dl))
          dp = (dp <= dl ? dp : dl)
          b1 = 0
          b2 = 0
          b3 = 0
          begin
            while (sp < sl)
              b1 = sa[sp] & 0xff
              input_size = 1
              catch(:break_case) do
                case (b1)
                when ISO_SO
                  @shiftout = true
                  input_size = 1
                when ISO_SI
                  @shiftout = false
                  input_size = 1
                when ISO_ESC
                  if (sl - sp - 1 < MinDesignatorLength)
                    return CoderResult::UNDERFLOW
                  end
                  desig = find_desig(sa, sp + 1, sl, @sodesig)
                  if (!(desig).equal?(-1))
                    @cur_sodes = desig
                    input_size = @sodesig[desig].attr_length + 1
                    throw :break_case, :thrown
                  end
                  desig = find_desig(sa, sp + 1, sl, @ss2desig)
                  if (!(desig).equal?(-1))
                    @cur_ss2des = desig
                    input_size = @ss2desig[desig].attr_length + 1
                    throw :break_case, :thrown
                  end
                  desig = find_desig(sa, sp + 1, sl, @ss3desig)
                  if (!(desig).equal?(-1))
                    @cur_ss3des = desig
                    input_size = @ss3desig[desig].attr_length + 1
                    throw :break_case, :thrown
                  end
                  if (sl - sp < 2)
                    return CoderResult::UNDERFLOW
                  end
                  b1 = sa[sp + 1]
                  case (b1)
                  when ISO_SS2_7
                    if (sl - sp < 4)
                      return CoderResult::UNDERFLOW
                    end
                    b2 = sa[sp + 2]
                    b3 = sa[sp + 3]
                    if (dl - dp < 1)
                      return CoderResult::OVERFLOW
                    end
                    da[dp] = decode(b2, b3, self.class::SS2Flag)
                    dp += 1
                    input_size = 4
                  when ISO_SS3_7
                    if (sl - sp < 4)
                      return CoderResult::UNDERFLOW
                    end
                    b2 = sa[sp + 2]
                    b3 = sa[sp + 3]
                    if (dl - dp < 1)
                      return CoderResult::OVERFLOW
                    end
                    da[dp] = decode(b2, b3, self.class::SS3Flag)
                    dp += 1
                    input_size = 4
                  else
                    return CoderResult.malformed_for_length(2)
                  end
                else
                  if (dl - dp < 1)
                    return CoderResult::OVERFLOW
                  end
                  if (!@shiftout)
                    da[((dp += 1) - 1)] = RJava.cast_to_char((sa[sp] & 0xff))
                  else
                    if (dl - dp < 1)
                      return CoderResult::OVERFLOW
                    end
                    if (sl - sp < 2)
                      return CoderResult::UNDERFLOW
                    end
                    b2 = sa[sp + 1] & 0xff
                    da[((dp += 1) - 1)] = decode(b1, b2, self.class::SOFlag)
                    input_size = 2
                  end
                end
              end == :thrown or break
              sp += input_size
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(sp - src.array_offset)
            dst.position(dp - dst.array_offset)
          end
        end
        
        typesig { [self::ByteBuffer, self::CharBuffer] }
        def decode_buffer_loop(src, dst)
          mark_ = src.position
          b1 = 0
          b2 = 0
          b3 = 0
          begin
            while (src.has_remaining)
              b1 = src.get
              input_size = 1
              catch(:break_case) do
                case (b1)
                when ISO_SO
                  @shiftout = true
                when ISO_SI
                  @shiftout = false
                when ISO_ESC
                  if (src.remaining < MinDesignatorLength)
                    return CoderResult::UNDERFLOW
                  end
                  desig = find_desig_buf(src, @sodesig)
                  if (!(desig).equal?(-1))
                    @cur_sodes = desig
                    input_size = @sodesig[desig].attr_length + 1
                    throw :break_case, :thrown
                  end
                  desig = find_desig_buf(src, @ss2desig)
                  if (!(desig).equal?(-1))
                    @cur_ss2des = desig
                    input_size = @ss2desig[desig].attr_length + 1
                    throw :break_case, :thrown
                  end
                  desig = find_desig_buf(src, @ss3desig)
                  if (!(desig).equal?(-1))
                    @cur_ss3des = desig
                    input_size = @ss3desig[desig].attr_length + 1
                    throw :break_case, :thrown
                  end
                  if (src.remaining < 1)
                    return CoderResult::UNDERFLOW
                  end
                  b1 = src.get
                  case (b1)
                  when ISO_SS2_7
                    if (src.remaining < 2)
                      return CoderResult::UNDERFLOW
                    end
                    b2 = src.get
                    b3 = src.get
                    if (dst.remaining < 1)
                      return CoderResult::OVERFLOW
                    end
                    dst.put(decode(b2, b3, self.class::SS2Flag))
                    input_size = 4
                  when ISO_SS3_7
                    if (src.remaining < 2)
                      return CoderResult::UNDERFLOW
                    end
                    b2 = src.get
                    b3 = src.get
                    if (dst.remaining < 1)
                      return CoderResult::OVERFLOW
                    end
                    dst.put(decode(b2, b3, self.class::SS3Flag))
                    input_size = 4
                  else
                    return CoderResult.malformed_for_length(2)
                  end
                else
                  if (dst.remaining < 1)
                    return CoderResult::OVERFLOW
                  end
                  if (!@shiftout)
                    dst.put(RJava.cast_to_char((b1 & 0xff)))
                  else
                    if (dst.remaining < 1)
                      return CoderResult::OVERFLOW
                    end
                    if (src.remaining < 1)
                      return CoderResult::UNDERFLOW
                    end
                    b2 = src.get & 0xff
                    dst.put(decode(b1, b2, self.class::SOFlag))
                    input_size = 2
                  end
                end
              end == :thrown or break
              mark_ += input_size
            end
            return CoderResult::UNDERFLOW
          rescue self.class::JavaException => e
            e.print_stack_trace
            return CoderResult::OVERFLOW
          ensure
            src.position(mark_)
          end
        end
        
        typesig { [self::ByteBuffer, self::CharBuffer] }
        def decode_loop(src, dst)
          if (src.has_array && dst.has_array)
            return decode_array_loop(src, dst)
          else
            return decode_buffer_loop(src, dst)
          end
        end
        
        private
        alias_method :initialize__decoder, :initialize
      end }
      
      const_set_lazy(:Encoder) { Class.new(CharsetEncoder) do
        include_class_members ISO2022
        
        attr_accessor :sgp
        alias_method :attr_sgp, :sgp
        undef_method :sgp
        alias_method :attr_sgp=, :sgp=
        undef_method :sgp=
        
        attr_accessor :ss2
        alias_method :attr_ss2, :ss2
        undef_method :ss2
        alias_method :attr_ss2=, :ss2=
        undef_method :ss2=
        
        attr_accessor :p2
        alias_method :attr_p2, :p2
        undef_method :p2
        alias_method :attr_p2=, :p2=
        undef_method :p2=
        
        attr_accessor :p3
        alias_method :attr_p3, :p3
        undef_method :p3
        alias_method :attr_p3=, :p3=
        undef_method :p3=
        
        attr_accessor :msb
        alias_method :attr_msb, :msb
        undef_method :msb
        alias_method :attr_msb=, :msb=
        undef_method :msb=
        
        attr_accessor :maximum_designator_length
        alias_method :attr_maximum_designator_length, :maximum_designator_length
        undef_method :maximum_designator_length
        alias_method :attr_maximum_designator_length=, :maximum_designator_length=
        undef_method :maximum_designator_length=
        
        attr_accessor :sodesig
        alias_method :attr_sodesig, :sodesig
        undef_method :sodesig
        alias_method :attr_sodesig=, :sodesig=
        undef_method :sodesig=
        
        attr_accessor :ss2desig
        alias_method :attr_ss2desig, :ss2desig
        undef_method :ss2desig
        alias_method :attr_ss2desig=, :ss2desig=
        undef_method :ss2desig=
        
        attr_accessor :ss3desig
        alias_method :attr_ss3desig, :ss3desig
        undef_method :ss3desig
        alias_method :attr_ss3desig=, :ss3desig=
        undef_method :ss3desig=
        
        attr_accessor :isoencoder
        alias_method :attr_isoencoder, :isoencoder
        undef_method :isoencoder
        alias_method :attr_isoencoder=, :isoencoder=
        undef_method :isoencoder=
        
        attr_accessor :shiftout
        alias_method :attr_shiftout, :shiftout
        undef_method :shiftout
        alias_method :attr_shiftout=, :shiftout=
        undef_method :shiftout=
        
        attr_accessor :sodes_defined
        alias_method :attr_sodes_defined, :sodes_defined
        undef_method :sodes_defined
        alias_method :attr_sodes_defined=, :sodes_defined=
        undef_method :sodes_defined=
        
        attr_accessor :ss2des_defined
        alias_method :attr_ss2des_defined, :ss2des_defined
        undef_method :ss2des_defined
        alias_method :attr_ss2des_defined=, :ss2des_defined=
        undef_method :ss2des_defined=
        
        attr_accessor :ss3des_defined
        alias_method :attr_ss3des_defined, :ss3des_defined
        undef_method :ss3des_defined
        alias_method :attr_ss3des_defined=, :ss3des_defined=
        undef_method :ss3des_defined=
        
        attr_accessor :newshiftout
        alias_method :attr_newshiftout, :newshiftout
        undef_method :newshiftout
        alias_method :attr_newshiftout=, :newshiftout=
        undef_method :newshiftout=
        
        attr_accessor :new_sodes_defined
        alias_method :attr_new_sodes_defined, :new_sodes_defined
        undef_method :new_sodes_defined
        alias_method :attr_new_sodes_defined=, :new_sodes_defined=
        undef_method :new_sodes_defined=
        
        attr_accessor :new_ss2des_defined
        alias_method :attr_new_ss2des_defined, :new_ss2des_defined
        undef_method :new_ss2des_defined
        alias_method :attr_new_ss2des_defined=, :new_ss2des_defined=
        undef_method :new_ss2des_defined=
        
        attr_accessor :new_ss3des_defined
        alias_method :attr_new_ss3des_defined, :new_ss3des_defined
        undef_method :new_ss3des_defined
        alias_method :attr_new_ss3des_defined=, :new_ss3des_defined=
        undef_method :new_ss3des_defined=
        
        typesig { [self::Charset] }
        def initialize(cs)
          @sgp = nil
          @ss2 = 0
          @p2 = 0
          @p3 = 0
          @msb = 0
          @maximum_designator_length = 0
          @sodesig = nil
          @ss2desig = nil
          @ss3desig = nil
          @isoencoder = nil
          @shiftout = false
          @sodes_defined = false
          @ss2des_defined = false
          @ss3des_defined = false
          @newshiftout = false
          @new_sodes_defined = false
          @new_ss2des_defined = false
          @new_ss3des_defined = false
          super(cs, 4.0, 8.0)
          @sgp = self.class::Surrogate::Parser.new
          @ss2 = 0x8e
          @p2 = 0xa2
          @p3 = 0xa3
          @msb = 0x80
          @maximum_designator_length = 4
          @ss2desig = nil
          @ss3desig = nil
          @shiftout = false
          @sodes_defined = false
          @ss2des_defined = false
          @ss3des_defined = false
          @newshiftout = false
          @new_sodes_defined = false
          @new_ss2des_defined = false
          @new_ss3des_defined = false
        end
        
        typesig { [::Java::Char] }
        def can_encode(c)
          return (@isoencoder.can_encode(c))
        end
        
        typesig { [] }
        def impl_reset
          @shiftout = false
          @sodes_defined = false
          @ss2des_defined = false
          @ss3des_defined = false
        end
        
        typesig { [::Java::Char, Array.typed(::Java::Byte)] }
        def unicode_to_native(unicode, ebyte)
          index = 0
          tmp_byte = 0
          conv_char = Array.typed(::Java::Char).new([unicode])
          conv_byte = Array.typed(::Java::Byte).new(4) { 0 }
          converted = 0
          begin
            cc = CharBuffer.wrap(conv_char)
            bb = ByteBuffer.allocate(4)
            @isoencoder.encode(cc, bb, true)
            bb.flip
            converted = bb.remaining
            bb.get(conv_byte, 0, converted)
          rescue self.class::JavaException => e
            return -1
          end
          if ((converted).equal?(2))
            if (!@sodes_defined)
              @new_sodes_defined = true
              ebyte[0] = ISO_ESC
              tmp_byte = @sodesig.get_bytes
              System.arraycopy(tmp_byte, 0, ebyte, 1, tmp_byte.attr_length)
              index = tmp_byte.attr_length + 1
            end
            if (!@shiftout)
              @newshiftout = true
              ebyte[((index += 1) - 1)] = ISO_SO
            end
            ebyte[((index += 1) - 1)] = (conv_byte[0] & 0x7f)
            ebyte[((index += 1) - 1)] = (conv_byte[1] & 0x7f)
          else
            if (((conv_byte[0]).equal?(@ss2)) && ((conv_byte[1]).equal?(@p2)))
              if (!@ss2des_defined)
                @new_ss2des_defined = true
                ebyte[0] = ISO_ESC
                tmp_byte = @ss2desig.get_bytes
                System.arraycopy(tmp_byte, 0, ebyte, 1, tmp_byte.attr_length)
                index = tmp_byte.attr_length + 1
              end
              ebyte[((index += 1) - 1)] = ISO_ESC
              ebyte[((index += 1) - 1)] = ISO_SS2_7
              ebyte[((index += 1) - 1)] = (conv_byte[2] & 0x7f)
              ebyte[((index += 1) - 1)] = (conv_byte[3] & 0x7f)
            end
            if (((conv_byte[0]).equal?(@ss2)) && ((conv_byte[1]).equal?(0xa3)))
              if (!@ss3des_defined)
                @new_ss3des_defined = true
                ebyte[0] = ISO_ESC
                tmp_byte = @ss3desig.get_bytes
                System.arraycopy(tmp_byte, 0, ebyte, 1, tmp_byte.attr_length)
                index = tmp_byte.attr_length + 1
              end
              ebyte[((index += 1) - 1)] = ISO_ESC
              ebyte[((index += 1) - 1)] = ISO_SS3_7
              ebyte[((index += 1) - 1)] = (conv_byte[2] & 0x7f)
              ebyte[((index += 1) - 1)] = (conv_byte[3] & 0x7f)
            end
          end
          return index
        end
        
        typesig { [self::CharBuffer, self::ByteBuffer] }
        def encode_array_loop(src, dst)
          sa = src.array
          sp = src.array_offset + src.position
          sl = src.array_offset + src.limit
          raise AssertError if not ((sp <= sl))
          sp = (sp <= sl ? sp : sl)
          da = dst.array
          dp = dst.array_offset + dst.position
          dl = dst.array_offset + dst.limit
          raise AssertError if not ((dp <= dl))
          dp = (dp <= dl ? dp : dl)
          output_size = 0
          output_byte = Array.typed(::Java::Byte).new(8) { 0 }
          @newshiftout = @shiftout
          @new_sodes_defined = @sodes_defined
          @new_ss2des_defined = @ss2des_defined
          @new_ss3des_defined = @ss3des_defined
          begin
            while (sp < sl)
              c = sa[sp]
              if (Surrogate.is(c))
                if (@sgp.parse(c, sa, sp, sl) < 0)
                  return @sgp.error
                end
                return @sgp.unmappable_result
              end
              if (c < 0x80)
                # ASCII
                if (@shiftout)
                  @newshiftout = false
                  output_size = 2
                  output_byte[0] = ISO_SI
                  output_byte[1] = (c & 0x7f)
                else
                  output_size = 1
                  output_byte[0] = (c & 0x7f)
                end
                if ((sa[sp]).equal?(Character.new(?\n.ord)))
                  @new_sodes_defined = false
                  @new_ss2des_defined = false
                  @new_ss3des_defined = false
                end
              else
                output_size = unicode_to_native(c, output_byte)
                if ((output_size).equal?(0))
                  return CoderResult.unmappable_for_length(1)
                end
              end
              if (dl - dp < output_size)
                return CoderResult::OVERFLOW
              end
              i = 0
              while i < output_size
                da[((dp += 1) - 1)] = output_byte[i]
                i += 1
              end
              sp += 1
              @shiftout = @newshiftout
              @sodes_defined = @new_sodes_defined
              @ss2des_defined = @new_ss2des_defined
              @ss3des_defined = @new_ss3des_defined
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(sp - src.array_offset)
            dst.position(dp - dst.array_offset)
          end
        end
        
        typesig { [self::CharBuffer, self::ByteBuffer] }
        def encode_buffer_loop(src, dst)
          output_size = 0
          output_byte = Array.typed(::Java::Byte).new(8) { 0 }
          input_size = 0 # Size of input
          @newshiftout = @shiftout
          @new_sodes_defined = @sodes_defined
          @new_ss2des_defined = @ss2des_defined
          @new_ss3des_defined = @ss3des_defined
          mark = src.position
          begin
            while (src.has_remaining)
              input_char = src.get
              if (Surrogate.is(input_char))
                if (@sgp.parse(input_char, src) < 0)
                  return @sgp.error
                end
                return @sgp.unmappable_result
              end
              if (input_char < 0x80)
                # ASCII
                if (@shiftout)
                  @newshiftout = false
                  output_size = 2
                  output_byte[0] = ISO_SI
                  output_byte[1] = (input_char & 0x7f)
                else
                  output_size = 1
                  output_byte[0] = (input_char & 0x7f)
                end
                if ((input_char).equal?(Character.new(?\n.ord)))
                  @new_sodes_defined = false
                  @new_ss2des_defined = false
                  @new_ss3des_defined = false
                end
              else
                output_size = unicode_to_native(input_char, output_byte)
                if ((output_size).equal?(0))
                  return CoderResult.unmappable_for_length(1)
                end
              end
              if (dst.remaining < output_size)
                return CoderResult::OVERFLOW
              end
              i = 0
              while i < output_size
                dst.put(output_byte[i])
                i += 1
              end
              mark += 1
              @shiftout = @newshiftout
              @sodes_defined = @new_sodes_defined
              @ss2des_defined = @new_ss2des_defined
              @ss3des_defined = @new_ss3des_defined
            end
            return CoderResult::UNDERFLOW
          ensure
            src.position(mark)
          end
        end
        
        typesig { [self::CharBuffer, self::ByteBuffer] }
        def encode_loop(src, dst)
          if (src.has_array && dst.has_array)
            return encode_array_loop(src, dst)
          else
            return encode_buffer_loop(src, dst)
          end
        end
        
        private
        alias_method :initialize__encoder, :initialize
      end }
    }
    
    private
    alias_method :initialize__iso2022, :initialize
  end
  
end
