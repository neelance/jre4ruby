require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
  module CollationData_elImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class CollationData_el < CollationData_elImports.const_get :ListResourceBundle
    include_class_members CollationData_elImports
    
    typesig { [] }
    def get_contents
      # ?? \u03f3 is letter yot
      # punctuations
      # upper numeral sign
      # lower numeral sign
      # ypogegrammeni
      # question mark
      # tonos
      # dialytika tonos
      # Greek letters sorts after Z's
      # alpha
      # alpha-tonos
      # beta
      # beta symbol
      # gamma
      # delta
      # epsilon
      # epsilon-tonos
      # zeta
      # eta
      # eta-tonos
      # theta
      # theta-symbol
      # iota
      # iota-tonos
      # iota-dialytika
      # iota-dialytika
      # kappa
      # kappa symbol
      # lamda
      # mu
      # nu
      # xi
      # omicron
      # omicron-tonos
      # pi
      # pi-symbol
      # rho
      # rho-symbol
      # sigma(final)
      # sigma
      # sigma-symbol
      # tau
      # upsilon
      # upsilon-tonos
      # upsilon-dialytika
      # upsilon-diaeresis-hook
      # upsilon-dialytika-tonos
      # upsilon-hook symbol
      # upsilon-acute-hook
      # phi
      # phi-symbol
      # chi
      # psi
      # omega
      # omega-tonos
      # stigma, digamma
      # koppa, sampi
      # shei
      # fei
      # khei
      # hori
      # gangia
      # shima
      # dei
      # Micro symbol sorts with mu
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["Rule", ("& ".to_u << 0x0361 << " = ".to_u << 0x0387 << " = ".to_u << 0x03f3 << " ") + ("& ".to_u << 0x00b5 << " ") + ("< ".to_u << 0x0374 << " ") + ("< ".to_u << 0x0375 << " ") + ("< ".to_u << 0x037a << " ") + ("< ".to_u << 0x037e << " ") + ("< ".to_u << 0x0384 << " ") + ("< ".to_u << 0x0385 << " ") + ("& Z < ".to_u << 0x03b1 << " , ".to_u << 0x0391 << " ") + ("; ".to_u << 0x03ac << " , ".to_u << 0x0386 << " ") + ("< ".to_u << 0x03b2 << " , ".to_u << 0x0392 << " ") + ("; ".to_u << 0x03d0 << " ") + ("< ".to_u << 0x03b3 << " , ".to_u << 0x0393 << " ") + ("< ".to_u << 0x03b4 << " , ".to_u << 0x0394 << " ") + ("< ".to_u << 0x03b5 << " , ".to_u << 0x0395 << " ") + ("; ".to_u << 0x03ad << " , ".to_u << 0x0388 << " ") + ("< ".to_u << 0x03b6 << " , ".to_u << 0x0396 << " ") + ("< ".to_u << 0x03b7 << " , ".to_u << 0x0397 << " ") + ("; ".to_u << 0x03ae << " , ".to_u << 0x0389 << " ") + ("< ".to_u << 0x03b8 << " , ".to_u << 0x0398 << " ") + ("; ".to_u << 0x03d1 << " ") + ("< ".to_u << 0x03b9 << " , ".to_u << 0x0399 << " ") + ("; ".to_u << 0x03af << " , ".to_u << 0x038a << " ") + ("; ".to_u << 0x03ca << " , ".to_u << 0x03aa << " ") + ("; ".to_u << 0x0390 << " ") + ("< ".to_u << 0x03ba << " , ".to_u << 0x039a << " ") + ("; ".to_u << 0x03f0 << " ") + ("< ".to_u << 0x03bb << " , ".to_u << 0x039b << " ") + ("< ".to_u << 0x03bc << " , ".to_u << 0x039c << " ") + ("< ".to_u << 0x03bd << " , ".to_u << 0x039d << " ") + ("< ".to_u << 0x03be << " , ".to_u << 0x039e << " ") + ("< ".to_u << 0x03bf << " , ".to_u << 0x039f << " ") + ("; ".to_u << 0x03cc << " , ".to_u << 0x038c << " ") + ("< ".to_u << 0x03c0 << " , ".to_u << 0x03a0 << " ") + ("; ".to_u << 0x03d6 << " < ".to_u << 0x03c1 << " ") + (", ".to_u << 0x03a1 << " ") + ("; ".to_u << 0x03f1 << " ") + ("< ".to_u << 0x03c3 << " , ".to_u << 0x03c2 << " ") + (", ".to_u << 0x03a3 << " ") + ("; ".to_u << 0x03f2 << " ") + ("< ".to_u << 0x03c4 << " , ".to_u << 0x03a4 << " ") + ("< ".to_u << 0x03c5 << " , ".to_u << 0x03a5 << " ") + ("; ".to_u << 0x03cd << " , ".to_u << 0x038e << " ") + ("; ".to_u << 0x03cb << " , ".to_u << 0x03ab << " ") + ("= ".to_u << 0x03d4 << " ") + ("; ".to_u << 0x03b0 << " ") + ("; ".to_u << 0x03d2 << " ") + ("; ".to_u << 0x03d3 << " ") + ("< ".to_u << 0x03c6 << " , ".to_u << 0x03a6 << " ") + ("; ".to_u << 0x03d5 << " ") + ("< ".to_u << 0x03c7 << " , ".to_u << 0x03a7 << " ") + ("< ".to_u << 0x03c8 << " , ".to_u << 0x03a8 << " ") + ("< ".to_u << 0x03c9 << " , ".to_u << 0x03a9 << " ") + ("; ".to_u << 0x03ce << " , ".to_u << 0x038f << " ") + (", ".to_u << 0x03da << " , ".to_u << 0x03dc << " ") + (", ".to_u << 0x03de << " , ".to_u << 0x03e0 << " ") + ("< ".to_u << 0x03e3 << " , ".to_u << 0x03e2 << " ") + ("< ".to_u << 0x03e5 << " , ".to_u << 0x03e4 << " ") + ("< ".to_u << 0x03e7 << " , ".to_u << 0x03e6 << " ") + ("< ".to_u << 0x03e9 << " , ".to_u << 0x03e8 << " ") + ("< ".to_u << 0x03eb << " , ".to_u << 0x03ea << " ") + ("< ".to_u << 0x03ed << " , ".to_u << 0x03ec << " ") + ("< ".to_u << 0x03ef << " , ".to_u << 0x03ee << " ") + ("& ".to_u << 0x03bc << " = ".to_u << 0x00b5 << " ")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__collation_data_el, :initialize
  end
  
end
