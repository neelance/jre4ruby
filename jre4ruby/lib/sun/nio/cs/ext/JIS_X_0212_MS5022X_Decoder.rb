require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module JIS_X_0212_MS5022X_DecoderImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Cs::Ext
      include_const ::Java::Nio::Charset, :Charset
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
    }
  end
  
  class JIS_X_0212_MS5022X_Decoder < JIS_X_0212_MS5022X_DecoderImports.const_get :JIS_X_0212_Decoder
    include_class_members JIS_X_0212_MS5022X_DecoderImports
    
    attr_accessor :_start
    alias_method :attr__start, :_start
    undef_method :_start
    alias_method :attr__start=, :_start=
    undef_method :_start=
    
    attr_accessor :_end
    alias_method :attr__end, :_end
    undef_method :_end
    alias_method :attr__end=, :_end=
    undef_method :_end=
    
    typesig { [Charset] }
    def initialize(cs)
      @_start = 0
      @_end = 0
      super(cs)
      @_start = 0x21
      @_end = 0x7e
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def decode_double(byte1, byte2)
      if (((byte1 < 0) || (byte1 > _index1.attr_length)) || ((byte2 < @_start) || (byte2 > @_end)))
        return REPLACE_CHAR
      end
      n = (_index1[byte1] & 0xf) * (@_end - @_start + 1) + (byte2 - @_start)
      unicode = _index2[_index1[byte1] >> 4].char_at(n)
      if ((unicode).equal?(Character.new(0x0000)))
        return (super(byte1, byte2))
      else
        return unicode
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:_innerIndex0) { ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x2170 << "".to_u << 0x2171 << "") + ("".to_u << 0x2172 << "".to_u << 0x2173 << "".to_u << 0x2174 << "".to_u << 0x2175 << "".to_u << 0x2176 << "".to_u << 0x2177 << "".to_u << 0x2178 << "".to_u << 0x2179 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0xFF07 << "".to_u << 0xFF02 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x70BB << "") + ("".to_u << 0x4EFC << "".to_u << 0x50F4 << "".to_u << 0x51EC << "".to_u << 0x5307 << "".to_u << 0x5324 << "".to_u << 0xFA0E << "".to_u << 0x548A << "".to_u << 0x5759 << "") + ("".to_u << 0xFA0F << "".to_u << 0xFA10 << "".to_u << 0x589E << "".to_u << 0x5BEC << "".to_u << 0x5CF5 << "".to_u << 0x5D53 << "".to_u << 0xFA11 << "".to_u << 0x5FB7 << "") + ("".to_u << 0x6085 << "".to_u << 0x6120 << "".to_u << 0x654E << "".to_u << 0x0000 << "".to_u << 0x6665 << "".to_u << 0xFA12 << "".to_u << 0xF929 << "".to_u << 0x6801 << "") + ("".to_u << 0xFA13 << "".to_u << 0xFA14 << "".to_u << 0x6A6B << "".to_u << 0x6AE2 << "".to_u << 0x6DF8 << "".to_u << 0x6DF2 << "".to_u << 0x7028 << "".to_u << 0xFA15 << "") + ("".to_u << 0xFA16 << "".to_u << 0x7501 << "".to_u << 0x7682 << "".to_u << 0x769E << "".to_u << 0xFA17 << "".to_u << 0x7930 << "".to_u << 0xFA18 << "".to_u << 0xFA19 << "") + ("".to_u << 0xFA1A << "".to_u << 0xFA1B << "".to_u << 0x7AE7 << "".to_u << 0xFA1C << "".to_u << 0xFA1D << "".to_u << 0x7DA0 << "".to_u << 0x7DD6 << "".to_u << 0xFA1E << "") + ("".to_u << 0x8362 << "".to_u << 0xFA1F << "".to_u << 0x85B0 << "".to_u << 0xFA20 << "".to_u << 0xFA21 << "".to_u << 0x8807 << "".to_u << 0xFA22 << "".to_u << 0x8B7F << "") + ("".to_u << 0x8CF4 << "".to_u << 0x8D76 << "".to_u << 0xFA23 << "".to_u << 0xFA24 << "".to_u << 0xFA25 << "".to_u << 0x90DE << "".to_u << 0xFA26 << "".to_u << 0x9115 << "") + ("".to_u << 0xFA27 << "".to_u << 0xFA28 << "".to_u << 0x9592 << "".to_u << 0xF9DC << "".to_u << 0xFA29 << "".to_u << 0x973B << "".to_u << 0x0000 << "".to_u << 0x9751 << "") + ("".to_u << 0xFA2A << "".to_u << 0xFA2B << "".to_u << 0xFA2C << "".to_u << 0x999E << "".to_u << 0x9AD9 << "".to_u << 0x9B72 << "".to_u << 0xFA2D << "".to_u << 0x9ED1 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x974D << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0x0000 << "") + ("".to_u << 0x0000 << "".to_u << 0x0000 << "".to_u << 0xE3AC << "".to_u << 0xE3AD << "".to_u << 0xE3AE << "".to_u << 0xE3AF << "".to_u << 0xE3B0 << "".to_u << 0xE3B1 << "") + ("".to_u << 0xE3B2 << "".to_u << 0xE3B3 << "".to_u << 0xE3B4 << "".to_u << 0xE3B5 << "".to_u << 0xE3B6 << "".to_u << 0xE3B7 << "".to_u << 0xE3B8 << "".to_u << 0xE3B9 << "") + ("".to_u << 0xE3BA << "".to_u << 0xE3BB << "".to_u << 0xE3BC << "".to_u << 0xE3BD << "".to_u << 0xE3BE << "".to_u << 0xE3BF << "".to_u << 0xE3C0 << "".to_u << 0xE3C1 << "") + ("".to_u << 0xE3C2 << "".to_u << 0xE3C3 << "".to_u << 0xE3C4 << "".to_u << 0xE3C5 << "".to_u << 0xE3C6 << "".to_u << 0xE3C7 << "".to_u << 0xE3C8 << "".to_u << 0xE3C9 << "") + ("".to_u << 0xE3CA << "".to_u << 0xE3CB << "".to_u << 0xE3CC << "".to_u << 0xE3CD << "".to_u << 0xE3CE << "".to_u << 0xE3CF << "".to_u << 0xE3D0 << "".to_u << 0xE3D1 << "") + ("".to_u << 0xE3D2 << "".to_u << 0xE3D3 << "".to_u << 0xE3D4 << "".to_u << 0xE3D5 << "".to_u << 0xE3D6 << "".to_u << 0xE3D7 << "".to_u << 0xE3D8 << "".to_u << 0xE3D9 << "") + ("".to_u << 0xE3DA << "".to_u << 0xE3DB << "".to_u << 0xE3DC << "".to_u << 0xE3DD << "".to_u << 0xE3DE << "".to_u << 0xE3DF << "".to_u << 0xE3E0 << "".to_u << 0xE3E1 << "") + ("".to_u << 0xE3E2 << "".to_u << 0xE3E3 << "".to_u << 0xE3E4 << "".to_u << 0xE3E5 << "".to_u << 0xE3E6 << "".to_u << 0xE3E7 << "".to_u << 0xE3E8 << "".to_u << 0xE3E9 << "") + ("".to_u << 0xE3EA << "".to_u << 0xE3EB << "".to_u << 0xE3EC << "".to_u << 0xE3ED << "".to_u << 0xE3EE << "".to_u << 0xE3EF << "".to_u << 0xE3F0 << "".to_u << 0xE3F1 << "") + ("".to_u << 0xE3F2 << "".to_u << 0xE3F3 << "".to_u << 0xE3F4 << "".to_u << 0xE3F5 << "".to_u << 0xE3F6 << "".to_u << 0xE3F7 << "".to_u << 0xE3F8 << "".to_u << 0xE3F9 << "") + ("".to_u << 0xE3FA << "".to_u << 0xE3FB << "".to_u << 0xE3FC << "".to_u << 0xE3FD << "".to_u << 0xE3FE << "".to_u << 0xE3FF << "".to_u << 0xE400 << "".to_u << 0xE401 << "") + ("".to_u << 0xE402 << "".to_u << 0xE403 << "".to_u << 0xE404 << "".to_u << 0xE405 << "".to_u << 0xE406 << "".to_u << 0xE407 << "".to_u << 0xE408 << "".to_u << 0xE409 << "") + ("".to_u << 0xE40A << "".to_u << 0xE40B << "".to_u << 0xE40C << "".to_u << 0xE40D << "".to_u << 0xE40E << "".to_u << 0xE40F << "".to_u << 0xE410 << "".to_u << 0xE411 << "") + ("".to_u << 0xE412 << "".to_u << 0xE413 << "".to_u << 0xE414 << "".to_u << 0xE415 << "".to_u << 0xE416 << "".to_u << 0xE417 << "".to_u << 0xE418 << "".to_u << 0xE419 << "") + ("".to_u << 0xE41A << "".to_u << 0xE41B << "".to_u << 0xE41C << "".to_u << 0xE41D << "".to_u << 0xE41E << "".to_u << 0xE41F << "".to_u << 0xE420 << "".to_u << 0xE421 << "") + ("".to_u << 0xE422 << "".to_u << 0xE423 << "".to_u << 0xE424 << "".to_u << 0xE425 << "".to_u << 0xE426 << "".to_u << 0xE427 << "".to_u << 0xE428 << "".to_u << 0xE429 << "") + ("".to_u << 0xE42A << "".to_u << 0xE42B << "".to_u << 0xE42C << "".to_u << 0xE42D << "".to_u << 0xE42E << "".to_u << 0xE42F << "".to_u << 0xE430 << "".to_u << 0xE431 << "") + ("".to_u << 0xE432 << "".to_u << 0xE433 << "".to_u << 0xE434 << "".to_u << 0xE435 << "".to_u << 0xE436 << "".to_u << 0xE437 << "".to_u << 0xE438 << "".to_u << 0xE439 << "") + ("".to_u << 0xE43A << "".to_u << 0xE43B << "".to_u << 0xE43C << "".to_u << 0xE43D << "".to_u << 0xE43E << "".to_u << 0xE43F << "".to_u << 0xE440 << "".to_u << 0xE441 << "") + ("".to_u << 0xE442 << "".to_u << 0xE443 << "".to_u << 0xE444 << "".to_u << 0xE445 << "".to_u << 0xE446 << "".to_u << 0xE447 << "".to_u << 0xE448 << "".to_u << 0xE449 << "") + ("".to_u << 0xE44A << "".to_u << 0xE44B << "".to_u << 0xE44C << "".to_u << 0xE44D << "".to_u << 0xE44E << "".to_u << 0xE44F << "".to_u << 0xE450 << "".to_u << 0xE451 << "") + ("".to_u << 0xE452 << "".to_u << 0xE453 << "".to_u << 0xE454 << "".to_u << 0xE455 << "".to_u << 0xE456 << "".to_u << 0xE457 << "".to_u << 0xE458 << "".to_u << 0xE459 << "") + ("".to_u << 0xE45A << "".to_u << 0xE45B << "".to_u << 0xE45C << "".to_u << 0xE45D << "".to_u << 0xE45E << "".to_u << 0xE45F << "".to_u << 0xE460 << "".to_u << 0xE461 << "") + ("".to_u << 0xE462 << "".to_u << 0xE463 << "".to_u << 0xE464 << "".to_u << 0xE465 << "".to_u << 0xE466 << "".to_u << 0xE467 << "".to_u << 0xE468 << "".to_u << 0xE469 << "") + ("".to_u << 0xE46A << "".to_u << 0xE46B << "".to_u << 0xE46C << "".to_u << 0xE46D << "".to_u << 0xE46E << "".to_u << 0xE46F << "".to_u << 0xE470 << "".to_u << 0xE471 << "") + ("".to_u << 0xE472 << "".to_u << 0xE473 << "".to_u << 0xE474 << "".to_u << 0xE475 << "".to_u << 0xE476 << "".to_u << 0xE477 << "".to_u << 0xE478 << "".to_u << 0xE479 << "") + ("".to_u << 0xE47A << "".to_u << 0xE47B << "".to_u << 0xE47C << "".to_u << 0xE47D << "".to_u << 0xE47E << "".to_u << 0xE47F << "".to_u << 0xE480 << "".to_u << 0xE481 << "") + ("".to_u << 0xE482 << "".to_u << 0xE483 << "".to_u << 0xE484 << "".to_u << 0xE485 << "".to_u << 0xE486 << "".to_u << 0xE487 << "".to_u << 0xE488 << "".to_u << 0xE489 << "") + ("".to_u << 0xE48A << "".to_u << 0xE48B << "".to_u << 0xE48C << "".to_u << 0xE48D << "".to_u << 0xE48E << "".to_u << 0xE48F << "".to_u << 0xE490 << "".to_u << 0xE491 << "") + ("".to_u << 0xE492 << "".to_u << 0xE493 << "".to_u << 0xE494 << "".to_u << 0xE495 << "".to_u << 0xE496 << "".to_u << 0xE497 << "".to_u << 0xE498 << "".to_u << 0xE499 << "") + ("".to_u << 0xE49A << "".to_u << 0xE49B << "".to_u << 0xE49C << "".to_u << 0xE49D << "".to_u << 0xE49E << "".to_u << 0xE49F << "".to_u << 0xE4A0 << "".to_u << 0xE4A1 << "") + ("".to_u << 0xE4A2 << "".to_u << 0xE4A3 << "".to_u << 0xE4A4 << "".to_u << 0xE4A5 << "".to_u << 0xE4A6 << "".to_u << 0xE4A7 << "".to_u << 0xE4A8 << "".to_u << 0xE4A9 << "") + ("".to_u << 0xE4AA << "".to_u << 0xE4AB << "".to_u << 0xE4AC << "".to_u << 0xE4AD << "".to_u << 0xE4AE << "".to_u << 0xE4AF << "".to_u << 0xE4B0 << "".to_u << 0xE4B1 << "") + ("".to_u << 0xE4B2 << "".to_u << 0xE4B3 << "".to_u << 0xE4B4 << "".to_u << 0xE4B5 << "".to_u << 0xE4B6 << "".to_u << 0xE4B7 << "".to_u << 0xE4B8 << "".to_u << 0xE4B9 << "") + ("".to_u << 0xE4BA << "".to_u << 0xE4BB << "".to_u << 0xE4BC << "".to_u << 0xE4BD << "".to_u << 0xE4BE << "".to_u << 0xE4BF << "".to_u << 0xE4C0 << "".to_u << 0xE4C1 << "") + ("".to_u << 0xE4C2 << "".to_u << 0xE4C3 << "".to_u << 0xE4C4 << "".to_u << 0xE4C5 << "".to_u << 0xE4C6 << "".to_u << 0xE4C7 << "".to_u << 0xE4C8 << "".to_u << 0xE4C9 << "") + ("".to_u << 0xE4CA << "".to_u << 0xE4CB << "".to_u << 0xE4CC << "".to_u << 0xE4CD << "".to_u << 0xE4CE << "".to_u << 0xE4CF << "".to_u << 0xE4D0 << "".to_u << 0xE4D1 << "") + ("".to_u << 0xE4D2 << "".to_u << 0xE4D3 << "".to_u << 0xE4D4 << "".to_u << 0xE4D5 << "".to_u << 0xE4D6 << "".to_u << 0xE4D7 << "".to_u << 0xE4D8 << "".to_u << 0xE4D9 << "") + ("".to_u << 0xE4DA << "".to_u << 0xE4DB << "".to_u << 0xE4DC << "".to_u << 0xE4DD << "".to_u << 0xE4DE << "".to_u << 0xE4DF << "".to_u << 0xE4E0 << "".to_u << 0xE4E1 << "") + ("".to_u << 0xE4E2 << "".to_u << 0xE4E3 << "".to_u << 0xE4E4 << "".to_u << 0xE4E5 << "".to_u << 0xE4E6 << "".to_u << 0xE4E7 << "".to_u << 0xE4E8 << "".to_u << 0xE4E9 << "") + ("".to_u << 0xE4EA << "".to_u << 0xE4EB << "".to_u << 0xE4EC << "".to_u << 0xE4ED << "".to_u << 0xE4EE << "".to_u << 0xE4EF << "".to_u << 0xE4F0 << "".to_u << 0xE4F1 << "") + ("".to_u << 0xE4F2 << "".to_u << 0xE4F3 << "".to_u << 0xE4F4 << "".to_u << 0xE4F5 << "".to_u << 0xE4F6 << "".to_u << 0xE4F7 << "".to_u << 0xE4F8 << "".to_u << 0xE4F9 << "") + ("".to_u << 0xE4FA << "".to_u << 0xE4FB << "".to_u << 0xE4FC << "".to_u << 0xE4FD << "".to_u << 0xE4FE << "".to_u << 0xE4FF << "".to_u << 0xE500 << "".to_u << 0xE501 << "") + ("".to_u << 0xE502 << "".to_u << 0xE503 << "".to_u << 0xE504 << "".to_u << 0xE505 << "".to_u << 0xE506 << "".to_u << 0xE507 << "".to_u << 0xE508 << "".to_u << 0xE509 << "") + ("".to_u << 0xE50A << "".to_u << 0xE50B << "".to_u << 0xE50C << "".to_u << 0xE50D << "".to_u << 0xE50E << "".to_u << 0xE50F << "".to_u << 0xE510 << "".to_u << 0xE511 << "") + ("".to_u << 0xE512 << "".to_u << 0xE513 << "".to_u << 0xE514 << "".to_u << 0xE515 << "".to_u << 0xE516 << "".to_u << 0xE517 << "".to_u << 0xE518 << "".to_u << 0xE519 << "") + ("".to_u << 0xE51A << "".to_u << 0xE51B << "".to_u << 0xE51C << "".to_u << 0xE51D << "".to_u << 0xE51E << "".to_u << 0xE51F << "".to_u << 0xE520 << "".to_u << 0xE521 << "") + ("".to_u << 0xE522 << "".to_u << 0xE523 << "".to_u << 0xE524 << "".to_u << 0xE525 << "".to_u << 0xE526 << "".to_u << 0xE527 << "".to_u << 0xE528 << "".to_u << 0xE529 << "") + ("".to_u << 0xE52A << "".to_u << 0xE52B << "".to_u << 0xE52C << "".to_u << 0xE52D << "".to_u << 0xE52E << "".to_u << 0xE52F << "".to_u << 0xE530 << "".to_u << 0xE531 << "") + ("".to_u << 0xE532 << "".to_u << 0xE533 << "".to_u << 0xE534 << "".to_u << 0xE535 << "".to_u << 0xE536 << "".to_u << 0xE537 << "".to_u << 0xE538 << "".to_u << 0xE539 << "") + ("".to_u << 0xE53A << "".to_u << 0xE53B << "".to_u << 0xE53C << "".to_u << 0xE53D << "".to_u << 0xE53E << "".to_u << 0xE53F << "".to_u << 0xE540 << "".to_u << 0xE541 << "") + ("".to_u << 0xE542 << "".to_u << 0xE543 << "".to_u << 0xE544 << "".to_u << 0xE545 << "".to_u << 0xE546 << "".to_u << 0xE547 << "".to_u << 0xE548 << "".to_u << 0xE549 << "") + ("".to_u << 0xE54A << "".to_u << 0xE54B << "".to_u << 0xE54C << "".to_u << 0xE54D << "".to_u << 0xE54E << "".to_u << 0xE54F << "".to_u << 0xE550 << "".to_u << 0xE551 << "") + ("".to_u << 0xE552 << "".to_u << 0xE553 << "".to_u << 0xE554 << "".to_u << 0xE555 << "".to_u << 0xE556 << "".to_u << 0xE557 << "".to_u << 0xE558 << "".to_u << 0xE559 << "") + ("".to_u << 0xE55A << "".to_u << 0xE55B << "".to_u << 0xE55C << "".to_u << 0xE55D << "".to_u << 0xE55E << "".to_u << 0xE55F << "".to_u << 0xE560 << "".to_u << 0xE561 << "") + ("".to_u << 0xE562 << "".to_u << 0xE563 << "".to_u << 0xE564 << "".to_u << 0xE565 << "".to_u << 0xE566 << "".to_u << 0xE567 << "".to_u << 0xE568 << "".to_u << 0xE569 << "") + ("".to_u << 0xE56A << "".to_u << 0xE56B << "".to_u << 0xE56C << "".to_u << 0xE56D << "".to_u << 0xE56E << "".to_u << 0xE56F << "".to_u << 0xE570 << "".to_u << 0xE571 << "") + ("".to_u << 0xE572 << "".to_u << 0xE573 << "".to_u << 0xE574 << "".to_u << 0xE575 << "".to_u << 0xE576 << "".to_u << 0xE577 << "".to_u << 0xE578 << "".to_u << 0xE579 << "") + ("".to_u << 0xE57A << "".to_u << 0xE57B << "".to_u << 0xE57C << "".to_u << 0xE57D << "".to_u << 0xE57E << "".to_u << 0xE57F << "".to_u << 0xE580 << "".to_u << 0xE581 << "") + ("".to_u << 0xE582 << "".to_u << 0xE583 << "".to_u << 0xE584 << "".to_u << 0xE585 << "".to_u << 0xE586 << "".to_u << 0xE587 << "".to_u << 0xE588 << "".to_u << 0xE589 << "") + ("".to_u << 0xE58A << "".to_u << 0xE58B << "".to_u << 0xE58C << "".to_u << 0xE58D << "".to_u << 0xE58E << "".to_u << 0xE58F << "".to_u << 0xE590 << "".to_u << 0xE591 << "") + ("".to_u << 0xE592 << "".to_u << 0xE593 << "".to_u << 0xE594 << "".to_u << 0xE595 << "".to_u << 0xE596 << "".to_u << 0xE597 << "".to_u << 0xE598 << "".to_u << 0xE599 << "") + ("".to_u << 0xE59A << "".to_u << 0xE59B << "".to_u << 0xE59C << "".to_u << 0xE59D << "".to_u << 0xE59E << "".to_u << 0xE59F << "".to_u << 0xE5A0 << "".to_u << 0xE5A1 << "") + ("".to_u << 0xE5A2 << "".to_u << 0xE5A3 << "".to_u << 0xE5A4 << "".to_u << 0xE5A5 << "".to_u << 0xE5A6 << "".to_u << 0xE5A7 << "".to_u << 0xE5A8 << "".to_u << 0xE5A9 << "") + ("".to_u << 0xE5AA << "".to_u << 0xE5AB << "".to_u << 0xE5AC << "".to_u << 0xE5AD << "".to_u << 0xE5AE << "".to_u << 0xE5AF << "".to_u << 0xE5B0 << "".to_u << 0xE5B1 << "") + ("".to_u << 0xE5B2 << "".to_u << 0xE5B3 << "".to_u << 0xE5B4 << "".to_u << 0xE5B5 << "".to_u << 0xE5B6 << "".to_u << 0xE5B7 << "".to_u << 0xE5B8 << "".to_u << 0xE5B9 << "") + ("".to_u << 0xE5BA << "".to_u << 0xE5BB << "".to_u << 0xE5BC << "".to_u << 0xE5BD << "".to_u << 0xE5BE << "".to_u << 0xE5BF << "".to_u << 0xE5C0 << "".to_u << 0xE5C1 << "") + ("".to_u << 0xE5C2 << "".to_u << 0xE5C3 << "".to_u << 0xE5C4 << "".to_u << 0xE5C5 << "".to_u << 0xE5C6 << "".to_u << 0xE5C7 << "".to_u << 0xE5C8 << "".to_u << 0xE5C9 << "") + ("".to_u << 0xE5CA << "".to_u << 0xE5CB << "".to_u << 0xE5CC << "".to_u << 0xE5CD << "".to_u << 0xE5CE << "".to_u << 0xE5CF << "".to_u << 0xE5D0 << "".to_u << 0xE5D1 << "") + ("".to_u << 0xE5D2 << "".to_u << 0xE5D3 << "".to_u << 0xE5D4 << "".to_u << 0xE5D5 << "".to_u << 0xE5D6 << "".to_u << 0xE5D7 << "".to_u << 0xE5D8 << "".to_u << 0xE5D9 << "") + ("".to_u << 0xE5DA << "".to_u << 0xE5DB << "".to_u << 0xE5DC << "".to_u << 0xE5DD << "".to_u << 0xE5DE << "".to_u << 0xE5DF << "".to_u << 0xE5E0 << "".to_u << 0xE5E1 << "") + ("".to_u << 0xE5E2 << "".to_u << 0xE5E3 << "".to_u << 0xE5E4 << "".to_u << 0xE5E5 << "".to_u << 0xE5E6 << "".to_u << 0xE5E7 << "".to_u << 0xE5E8 << "".to_u << 0xE5E9 << "") + ("".to_u << 0xE5EA << "".to_u << 0xE5EB << "".to_u << 0xE5EC << "".to_u << 0xE5ED << "".to_u << 0xE5EE << "".to_u << 0xE5EF << "".to_u << 0xE5F0 << "".to_u << 0xE5F1 << "") + ("".to_u << 0xE5F2 << "".to_u << 0xE5F3 << "".to_u << 0xE5F4 << "".to_u << 0xE5F5 << "".to_u << 0xE5F6 << "".to_u << 0xE5F7 << "".to_u << 0xE5F8 << "".to_u << 0xE5F9 << "") + ("".to_u << 0xE5FA << "".to_u << 0xE5FB << "".to_u << 0xE5FC << "".to_u << 0xE5FD << "".to_u << 0xE5FE << "".to_u << 0xE5FF << "".to_u << 0xE600 << "".to_u << 0xE601 << "") + ("".to_u << 0xE602 << "".to_u << 0xE603 << "".to_u << 0xE604 << "".to_u << 0xE605 << "".to_u << 0xE606 << "".to_u << 0xE607 << "".to_u << 0xE608 << "".to_u << 0xE609 << "") + ("".to_u << 0xE60A << "".to_u << 0xE60B << "".to_u << 0xE60C << "".to_u << 0xE60D << "".to_u << 0xE60E << "".to_u << 0xE60F << "".to_u << 0xE610 << "".to_u << 0xE611 << "") + ("".to_u << 0xE612 << "".to_u << 0xE613 << "".to_u << 0xE614 << "".to_u << 0xE615 << "".to_u << 0xE616 << "".to_u << 0xE617 << "".to_u << 0xE618 << "".to_u << 0xE619 << "") + ("".to_u << 0xE61A << "".to_u << 0xE61B << "".to_u << 0xE61C << "".to_u << 0xE61D << "".to_u << 0xE61E << "".to_u << 0xE61F << "".to_u << 0xE620 << "".to_u << 0xE621 << "") + ("".to_u << 0xE622 << "".to_u << 0xE623 << "".to_u << 0xE624 << "".to_u << 0xE625 << "".to_u << 0xE626 << "".to_u << 0xE627 << "".to_u << 0xE628 << "".to_u << 0xE629 << "") + ("".to_u << 0xE62A << "".to_u << 0xE62B << "".to_u << 0xE62C << "".to_u << 0xE62D << "".to_u << 0xE62E << "".to_u << 0xE62F << "".to_u << 0xE630 << "".to_u << 0xE631 << "") + ("".to_u << 0xE632 << "".to_u << 0xE633 << "".to_u << 0xE634 << "".to_u << 0xE635 << "".to_u << 0xE636 << "".to_u << 0xE637 << "".to_u << 0xE638 << "".to_u << 0xE639 << "") + ("".to_u << 0xE63A << "".to_u << 0xE63B << "".to_u << 0xE63C << "".to_u << 0xE63D << "".to_u << 0xE63E << "".to_u << 0xE63F << "".to_u << 0xE640 << "".to_u << 0xE641 << "") + ("".to_u << 0xE642 << "".to_u << 0xE643 << "".to_u << 0xE644 << "".to_u << 0xE645 << "".to_u << 0xE646 << "".to_u << 0xE647 << "".to_u << 0xE648 << "".to_u << 0xE649 << "") + ("".to_u << 0xE64A << "".to_u << 0xE64B << "".to_u << 0xE64C << "".to_u << 0xE64D << "".to_u << 0xE64E << "".to_u << 0xE64F << "".to_u << 0xE650 << "".to_u << 0xE651 << "") + ("".to_u << 0xE652 << "".to_u << 0xE653 << "".to_u << 0xE654 << "".to_u << 0xE655 << "".to_u << 0xE656 << "".to_u << 0xE657 << "".to_u << 0xE658 << "".to_u << 0xE659 << "") + ("".to_u << 0xE65A << "".to_u << 0xE65B << "".to_u << 0xE65C << "".to_u << 0xE65D << "".to_u << 0xE65E << "".to_u << 0xE65F << "".to_u << 0xE660 << "".to_u << 0xE661 << "") + ("".to_u << 0xE662 << "".to_u << 0xE663 << "".to_u << 0xE664 << "".to_u << 0xE665 << "".to_u << 0xE666 << "".to_u << 0xE667 << "".to_u << 0xE668 << "".to_u << 0xE669 << "") + ("".to_u << 0xE66A << "".to_u << 0xE66B << "".to_u << 0xE66C << "".to_u << 0xE66D << "".to_u << 0xE66E << "".to_u << 0xE66F << "".to_u << 0xE670 << "".to_u << 0xE671 << "") + ("".to_u << 0xE672 << "".to_u << 0xE673 << "".to_u << 0xE674 << "".to_u << 0xE675 << "".to_u << 0xE676 << "".to_u << 0xE677 << "".to_u << 0xE678 << "".to_u << 0xE679 << "") + ("".to_u << 0xE67A << "".to_u << 0xE67B << "".to_u << 0xE67C << "".to_u << 0xE67D << "".to_u << 0xE67E << "".to_u << 0xE67F << "".to_u << 0xE680 << "".to_u << 0xE681 << "") + ("".to_u << 0xE682 << "".to_u << 0xE683 << "".to_u << 0xE684 << "".to_u << 0xE685 << "".to_u << 0xE686 << "".to_u << 0xE687 << "".to_u << 0xE688 << "".to_u << 0xE689 << "") + ("".to_u << 0xE68A << "".to_u << 0xE68B << "".to_u << 0xE68C << "".to_u << 0xE68D << "".to_u << 0xE68E << "".to_u << 0xE68F << "".to_u << 0xE690 << "".to_u << 0xE691 << "") + ("".to_u << 0xE692 << "".to_u << 0xE693 << "".to_u << 0xE694 << "".to_u << 0xE695 << "".to_u << 0xE696 << "".to_u << 0xE697 << "".to_u << 0xE698 << "".to_u << 0xE699 << "") + ("".to_u << 0xE69A << "".to_u << 0xE69B << "".to_u << 0xE69C << "".to_u << 0xE69D << "".to_u << 0xE69E << "".to_u << 0xE69F << "".to_u << 0xE6A0 << "".to_u << 0xE6A1 << "") + ("".to_u << 0xE6A2 << "".to_u << 0xE6A3 << "".to_u << 0xE6A4 << "".to_u << 0xE6A5 << "".to_u << 0xE6A6 << "".to_u << 0xE6A7 << "".to_u << 0xE6A8 << "".to_u << 0xE6A9 << "") + ("".to_u << 0xE6AA << "".to_u << 0xE6AB << "".to_u << 0xE6AC << "".to_u << 0xE6AD << "".to_u << 0xE6AE << "".to_u << 0xE6AF << "".to_u << 0xE6B0 << "".to_u << 0xE6B1 << "") + ("".to_u << 0xE6B2 << "".to_u << 0xE6B3 << "".to_u << 0xE6B4 << "".to_u << 0xE6B5 << "".to_u << 0xE6B6 << "".to_u << 0xE6B7 << "".to_u << 0xE6B8 << "".to_u << 0xE6B9 << "") + ("".to_u << 0xE6BA << "".to_u << 0xE6BB << "".to_u << 0xE6BC << "".to_u << 0xE6BD << "".to_u << 0xE6BE << "".to_u << 0xE6BF << "".to_u << 0xE6C0 << "".to_u << 0xE6C1 << "") + ("".to_u << 0xE6C2 << "".to_u << 0xE6C3 << "".to_u << 0xE6C4 << "".to_u << 0xE6C5 << "".to_u << 0xE6C6 << "".to_u << 0xE6C7 << "".to_u << 0xE6C8 << "".to_u << 0xE6C9 << "") + ("".to_u << 0xE6CA << "".to_u << 0xE6CB << "".to_u << 0xE6CC << "".to_u << 0xE6CD << "".to_u << 0xE6CE << "".to_u << 0xE6CF << "".to_u << 0xE6D0 << "".to_u << 0xE6D1 << "") + ("".to_u << 0xE6D2 << "".to_u << 0xE6D3 << "".to_u << 0xE6D4 << "".to_u << 0xE6D5 << "".to_u << 0xE6D6 << "".to_u << 0xE6D7 << "".to_u << 0xE6D8 << "".to_u << 0xE6D9 << "") + ("".to_u << 0xE6DA << "".to_u << 0xE6DB << "".to_u << 0xE6DC << "".to_u << 0xE6DD << "".to_u << 0xE6DE << "".to_u << 0xE6DF << "".to_u << 0xE6E0 << "".to_u << 0xE6E1 << "") + ("".to_u << 0xE6E2 << "".to_u << 0xE6E3 << "".to_u << 0xE6E4 << "".to_u << 0xE6E5 << "".to_u << 0xE6E6 << "".to_u << 0xE6E7 << "".to_u << 0xE6E8 << "".to_u << 0xE6E9 << "") + ("".to_u << 0xE6EA << "".to_u << 0xE6EB << "".to_u << 0xE6EC << "".to_u << 0xE6ED << "".to_u << 0xE6EE << "".to_u << 0xE6EF << "".to_u << 0xE6F0 << "".to_u << 0xE6F1 << "") + ("".to_u << 0xE6F2 << "".to_u << 0xE6F3 << "".to_u << 0xE6F4 << "".to_u << 0xE6F5 << "".to_u << 0xE6F6 << "".to_u << 0xE6F7 << "".to_u << 0xE6F8 << "".to_u << 0xE6F9 << "") + ("".to_u << 0xE6FA << "".to_u << 0xE6FB << "".to_u << 0xE6FC << "".to_u << 0xE6FD << "".to_u << 0xE6FE << "".to_u << 0xE6FF << "".to_u << 0xE700 << "".to_u << 0xE701 << "") + ("".to_u << 0xE702 << "".to_u << 0xE703 << "".to_u << 0xE704 << "".to_u << 0xE705 << "".to_u << 0xE706 << "".to_u << 0xE707 << "".to_u << 0xE708 << "".to_u << 0xE709 << "") + ("".to_u << 0xE70A << "".to_u << 0xE70B << "".to_u << 0xE70C << "".to_u << 0xE70D << "".to_u << 0xE70E << "".to_u << 0xE70F << "".to_u << 0xE710 << "".to_u << 0xE711 << "") + ("".to_u << 0xE712 << "".to_u << 0xE713 << "".to_u << 0xE714 << "".to_u << 0xE715 << "".to_u << 0xE716 << "".to_u << 0xE717 << "".to_u << 0xE718 << "".to_u << 0xE719 << "") + ("".to_u << 0xE71A << "".to_u << 0xE71B << "".to_u << 0xE71C << "".to_u << 0xE71D << "".to_u << 0xE71E << "".to_u << 0xE71F << "".to_u << 0xE720 << "".to_u << 0xE721 << "") + ("".to_u << 0xE722 << "".to_u << 0xE723 << "".to_u << 0xE724 << "".to_u << 0xE725 << "".to_u << 0xE726 << "".to_u << 0xE727 << "".to_u << 0xE728 << "".to_u << 0xE729 << "") + ("".to_u << 0xE72A << "".to_u << 0xE72B << "".to_u << 0xE72C << "".to_u << 0xE72D << "".to_u << 0xE72E << "".to_u << 0xE72F << "".to_u << 0xE730 << "".to_u << 0xE731 << "") + ("".to_u << 0xE732 << "".to_u << 0xE733 << "".to_u << 0xE734 << "".to_u << 0xE735 << "".to_u << 0xE736 << "".to_u << 0xE737 << "".to_u << 0xE738 << "".to_u << 0xE739 << "") + ("".to_u << 0xE73A << "".to_u << 0xE73B << "".to_u << 0xE73C << "".to_u << 0xE73D << "".to_u << 0xE73E << "".to_u << 0xE73F << "".to_u << 0xE740 << "".to_u << 0xE741 << "") + ("".to_u << 0xE742 << "".to_u << 0xE743 << "".to_u << 0xE744 << "".to_u << 0xE745 << "".to_u << 0xE746 << "".to_u << 0xE747 << "".to_u << 0xE748 << "".to_u << 0xE749 << "") + ("".to_u << 0xE74A << "".to_u << 0xE74B << "".to_u << 0xE74C << "".to_u << 0xE74D << "".to_u << 0xE74E << "".to_u << 0xE74F << "".to_u << 0xE750 << "".to_u << 0xE751 << "") + ("".to_u << 0xE752 << "".to_u << 0xE753 << "".to_u << 0xE754 << "".to_u << 0xE755 << "".to_u << 0xE756 << "".to_u << 0xE757 << "") }
      const_attr_reader  :_innerIndex0
      
      const_set_lazy(:_index1) { Array.typed(::Java::Short).new([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]) }
      const_attr_reader  :_index1
      
      const_set_lazy(:_index2) { Array.typed(String).new([_innerIndex0]) }
      const_attr_reader  :_index2
    }
    
    private
    alias_method :initialize__jis_x_0212_ms5022x_decoder, :initialize
  end
  
end
