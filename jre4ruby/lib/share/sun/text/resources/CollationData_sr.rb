require "rjava"

# Portions Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Sun::Text::Resources
  module CollationData_srImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_sr < CollationData_srImports.const_get :ListResourceBundle
    include_class_members CollationData_srImports
    
    typesig { [] }
    # Overrides ListResourceBundle
    def get_contents
      # for sr, default plus the following
      # thousand sign
      # Arabic script sorts after Z's
      # a
      # be
      # ve
      # ghe
      # ghe-upturn
      # ghe-mid-hook
      # gje
      # ghe-stroke
      # de
      # dje
      # ie
      # che
      # io
      # che-descender
      # uk ie
      # zhe
      # zhe-descender
      # zhe-breve
      # ze
      # zh-descender
      # dze
      # i
      # uk/bg i
      # palochka
      # uk yi
      # short i
      # je
      # ka
      # ka-stroke
      # ka-hook
      # ka-vt-stroke
      # bashkir-ka
      # kje
      # ka-descender
      # el
      # lje
      # em
      # en
      # yat
      # en-descender
      # en-ghe
      # shha
      # en-hook
      # nje
      # o
      # ha
      # pe
      # pe-mid-hook
      # er
      # es
      # es-descender
      # te
      # te-descender
      # tshe
      # u
      # straight u
      # short u
      # straight u-stroke
      # ef
      # ha
      # ha-descender
      # tse
      # te tse
      # che
      # che-descender
      # che-vt-stroke
      # che
      # dzhe
      # sha
      # shcha
      # hard sign
      # yeru
      # soft sign
      # e
      # yu
      # ya
      # omega
      # yat
      # iotified e
      # little yus
      # iotified little yus
      # big yus
      # iotified big yus
      # ksi
      # psi
      # fita
      # izhitsa
      # izhitsa-double-grave
      # uk
      # round omega
      # omega-titlo
      # ot
      # koppa
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", ("& 9 < ".to_u << 0x0482 << " ") + "& Z " + ("< ".to_u << 0x0430 << " , ".to_u << 0x0410 << "") + ("< ".to_u << 0x0431 << " , ".to_u << 0x0411 << "") + ("< ".to_u << 0x0432 << " , ".to_u << 0x0412 << "") + ("< ".to_u << 0x0433 << " , ".to_u << 0x0413 << "") + ("; ".to_u << 0x0491 << " , ".to_u << 0x0490 << "") + ("; ".to_u << 0x0495 << " , ".to_u << 0x0494 << "") + ("; ".to_u << 0x0453 << " , ".to_u << 0x0403 << "") + ("; ".to_u << 0x0493 << " , ".to_u << 0x0492 << "") + ("< ".to_u << 0x0434 << " , ".to_u << 0x0414 << "") + ("< ".to_u << 0x0452 << " , ".to_u << 0x0402 << "") + ("< ".to_u << 0x0435 << " , ".to_u << 0x0415 << "") + ("; ".to_u << 0x04bd << " , ".to_u << 0x04bc << "") + ("; ".to_u << 0x0451 << " , ".to_u << 0x0401 << "") + ("; ".to_u << 0x04bf << " , ".to_u << 0x04be << "") + ("< ".to_u << 0x0454 << " , ".to_u << 0x0404 << "") + ("< ".to_u << 0x0436 << " , ".to_u << 0x0416 << "") + ("; ".to_u << 0x0497 << " , ".to_u << 0x0496 << "") + ("; ".to_u << 0x04c2 << " , ".to_u << 0x04c1 << "") + ("< ".to_u << 0x0437 << " , ".to_u << 0x0417 << "") + ("; ".to_u << 0x0499 << " , ".to_u << 0x0498 << "") + ("< ".to_u << 0x0455 << " , ".to_u << 0x0405 << "") + ("< ".to_u << 0x0438 << " , ".to_u << 0x0418 << "") + ("< ".to_u << 0x0456 << " , ".to_u << 0x0406 << "") + ("; ".to_u << 0x04c0 << " ") + ("< ".to_u << 0x0457 << " , ".to_u << 0x0407 << "") + ("< ".to_u << 0x0439 << " , ".to_u << 0x0419 << "") + ("< ".to_u << 0x0458 << " , ".to_u << 0x0408 << "") + ("< ".to_u << 0x043a << " , ".to_u << 0x041a << "") + ("; ".to_u << 0x049f << " , ".to_u << 0x049e << "") + ("; ".to_u << 0x04c4 << " , ".to_u << 0x04c3 << "") + ("; ".to_u << 0x049d << " , ".to_u << 0x049c << "") + ("; ".to_u << 0x04a1 << " , ".to_u << 0x04a0 << "") + ("; ".to_u << 0x045c << " , ".to_u << 0x040c << "") + ("; ".to_u << 0x049b << " , ".to_u << 0x049a << "") + ("< ".to_u << 0x043b << " , ".to_u << 0x041b << "") + ("< ".to_u << 0x0459 << " , ".to_u << 0x0409 << "") + ("< ".to_u << 0x043c << " , ".to_u << 0x041c << "") + ("< ".to_u << 0x043d << " , ".to_u << 0x041d << "") + ("; ".to_u << 0x0463 << " ") + ("; ".to_u << 0x04a3 << " , ".to_u << 0x04a2 << "") + ("; ".to_u << 0x04a5 << " , ".to_u << 0x04a4 << "") + ("; ".to_u << 0x04bb << " , ".to_u << 0x04ba << "") + ("; ".to_u << 0x04c8 << " , ".to_u << 0x04c7 << "") + ("< ".to_u << 0x045a << " , ".to_u << 0x040a << "") + ("< ".to_u << 0x043e << " , ".to_u << 0x041e << "") + ("; ".to_u << 0x04a9 << " , ".to_u << 0x04a8 << "") + ("< ".to_u << 0x043f << " , ".to_u << 0x041f << "") + ("; ".to_u << 0x04a7 << " , ".to_u << 0x04a6 << "") + ("< ".to_u << 0x0440 << " , ".to_u << 0x0420 << "") + ("< ".to_u << 0x0441 << " , ".to_u << 0x0421 << "") + ("; ".to_u << 0x04ab << " , ".to_u << 0x04aa << "") + ("< ".to_u << 0x0442 << " , ".to_u << 0x0422 << "") + ("; ".to_u << 0x04ad << " , ".to_u << 0x04ac << "") + ("< ".to_u << 0x045b << " , ".to_u << 0x040b << "") + ("< ".to_u << 0x0443 << " , ".to_u << 0x0423 << "") + ("; ".to_u << 0x04af << " , ".to_u << 0x04ae << "") + ("< ".to_u << 0x045e << " , ".to_u << 0x040e << "") + ("< ".to_u << 0x04b1 << " , ".to_u << 0x04b0 << "") + ("< ".to_u << 0x0444 << " , ".to_u << 0x0424 << "") + ("< ".to_u << 0x0445 << " , ".to_u << 0x0425 << "") + ("; ".to_u << 0x04b3 << " , ".to_u << 0x04b2 << "") + ("< ".to_u << 0x0446 << " , ".to_u << 0x0426 << "") + ("; ".to_u << 0x04b5 << " , ".to_u << 0x04b4 << "") + ("< ".to_u << 0x0447 << " , ".to_u << 0x0427 << "") + ("; ".to_u << 0x04b7 << " ; ".to_u << 0x04b6 << "") + ("; ".to_u << 0x04b9 << " , ".to_u << 0x04b8 << "") + ("; ".to_u << 0x04cc << " , ".to_u << 0x04cb << "") + ("< ".to_u << 0x045f << " , ".to_u << 0x040f << "") + ("< ".to_u << 0x0448 << " , ".to_u << 0x0428 << "") + ("< ".to_u << 0x0449 << " , ".to_u << 0x0429 << "") + ("< ".to_u << 0x044a << " , ".to_u << 0x042a << "") + ("< ".to_u << 0x044b << " , ".to_u << 0x042b << "") + ("< ".to_u << 0x044c << " , ".to_u << 0x042c << "") + ("< ".to_u << 0x044d << " , ".to_u << 0x042d << "") + ("< ".to_u << 0x044e << " , ".to_u << 0x042e << "") + ("< ".to_u << 0x044f << " , ".to_u << 0x042f << "") + ("< ".to_u << 0x0461 << " , ".to_u << 0x0460 << "") + ("< ".to_u << 0x0462 << " ") + ("< ".to_u << 0x0465 << " , ".to_u << 0x0464 << "") + ("< ".to_u << 0x0467 << " , ".to_u << 0x0466 << "") + ("< ".to_u << 0x0469 << " , ".to_u << 0x0468 << "") + ("< ".to_u << 0x046b << " , ".to_u << 0x046a << "") + ("< ".to_u << 0x046d << " , ".to_u << 0x046c << "") + ("< ".to_u << 0x046f << " , ".to_u << 0x046e << "") + ("< ".to_u << 0x0471 << " , ".to_u << 0x0470 << "") + ("< ".to_u << 0x0473 << " , ".to_u << 0x0472 << "") + ("< ".to_u << 0x0475 << " , ".to_u << 0x0474 << "") + ("; ".to_u << 0x0477 << " , ".to_u << 0x0476 << "") + ("< ".to_u << 0x0479 << " , ".to_u << 0x0478 << "") + ("< ".to_u << 0x047b << " , ".to_u << 0x047a << "") + ("< ".to_u << 0x047d << " , ".to_u << 0x047c << "") + ("< ".to_u << 0x047f << " , ".to_u << 0x047e << "") + ("< ".to_u << 0x0481 << " , ".to_u << 0x0480 << "")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_sr, :initialize
  end
  
end
