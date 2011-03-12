require "rjava"

# Copyright 1996-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996,1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996, 1997 - All Rights Reserved
# 
#   The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
#   Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module CollationRulesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
    }
  end
  
  # CollationRules contains the default en_US collation rules as a base
  # for building other collation tables.
  # <p>Note that decompositions are done before these rules are used,
  # so they do not have to contain accented characters, such as A-grave.
  # @see                RuleBasedCollator
  # @see                LocaleElements
  # @author             Helena Shih, Mark Davis
  class CollationRules 
    include_class_members CollationRulesImports
    
    class_module.module_eval {
      # no FRENCH accent order by default, add in French Delta
      # IGNORABLES (up to first < character)
      # COMPLETELY IGNORE format characters
      # Control Characters
      # null, .. eot
      # enq, ...
      # vt,, so
      # si, dle, dc1, dc2, dc3
      # dc4, nak, syn, etb, can
      # em, sub, esc, fs, gs
      # rs, us, del
      # ....then the C1 Latin 1 reserved control codes
      # IGNORE except for secondary, tertiary difference
      # Spaces
      # spaces
      # spaces
      # spaces
      # spaces
      # whitespace
      # Non-spacing accents
      # non-spacing acute accent
      # non-spacing grave accent
      # non-spacing breve accent
      # non-spacing circumflex accent
      # non-spacing caron/hacek accent
      # non-spacing ring above accent
      # non-spacing vertical line above
      # non-spacing diaeresis accent
      # non-spacing double acute accent
      # non-spacing tilde accent
      # non-spacing dot above/overdot accent
      # non-spacing macron accent
      # non-spacing short slash overlay (overstruck diacritic)
      # non-spacing cedilla accent
      # non-spacing ogonek accent
      # non-spacing dot-below/underdot accent
      # non-spacing underscore/underline accent
      # with the rest of the general diacritical marks in binary order
      # non-spacing overscore/overline
      # non-spacing hook above
      # non-spacing double vertical line above
      # non-spacing double grave
      # non-spacing chandrabindu
      # non-spacing inverted breve
      # non-spacing turned comma above/cedilla above
      # non-spacing comma above
      # non-spacing reversed comma above
      # non-spacing comma above right
      # non-spacing grave below
      # non-spacing acute below
      # non-spacing left tack below
      # non-spacing tack below
      # non-spacing left angle above
      # non-spacing horn
      # non-spacing left half ring below
      # non-spacing up tack below
      # non-spacing down tack below
      # non-spacing plus sign below
      # non-spacing minus sign below
      # non-spacing palatalized hook below
      # non-spacing retroflex hook below
      # non-spacing double dot below
      # non-spacing ring below
      # non-spacing comma below
      # non-spacing vertical line below
      # non-spacing bridge below
      # non-spacing inverted double arch below
      # non-spacing hacek below
      # non-spacing circumflex below
      # non-spacing breve below
      # non-spacing inverted breve below
      # non-spacing tilde below
      # non-spacing macron below
      # non-spacing double underscore
      # non-spacing tilde overlay
      # non-spacing short bar overlay
      # non-spacing long bar overlay
      # non-spacing long slash overlay
      # non-spacing right half ring below
      # non-spacing inverted bridge below
      # non-spacing square below
      # non-spacing seagull below
      # non-spacing x above
      # non-spacing vertical tilde
      # non-spacing double overscore
      # + ";\u0340"          // non-spacing grave tone mark == \u0300
      # + ";\u0341"          // non-spacing acute tone mark == \u0301
      # + "\u0343;" // == \u0313
      # newer
      # Cyrillic accents
      # symbol accents
      # symbol accents
      # symbol accents
      # symbol accents
      # symbol accents
      # symbol accents
      # dashes
      # dashes
      # dashes
      # dashes
      # other punctuation
      # underline/underscore (spacing)
      # overline or macron (spacing)
      # comma (spacing)
      # semicolon
      # colon
      # exclamation point
      # inverted exclamation point
      # question mark
      # inverted question mark
      # slash
      # period/full stop
      # acute accent (spacing)
      # grave accent (spacing)
      # circumflex accent (spacing)
      # diaresis/umlaut accent (spacing)
      # tilde accent (spacing)
      # middle dot (spacing)
      # cedilla accent (spacing)
      # apostrophe
      # quotation marks
      # left angle quotes
      # right angle quotes
      # left parenthesis
      # right parenthesis
      # left bracket
      # right bracket
      # left brace
      # right brace
      # section symbol
      # paragraph symbol
      # copyright symbol
      # registered trademark symbol
      # at sign
      # international currency symbol
      # baht sign
      # cent sign
      # colon sign
      # cruzeiro sign
      # dollar sign
      # dong sign
      # euro sign
      # franc sign
      # lira sign
      # mill sign
      # naira sign
      # peseta sign
      # pound-sterling sign
      # rupee sign
      # new shekel sign
      # won sign
      # yen sign
      # asterisk
      # backslash
      # ampersand
      # number sign
      # percent sign
      # plus sign
      # plus-or-minus sign
      # divide sign
      # multiply sign
      # less-than sign
      # equal sign
      # greater-than sign
      # end of line symbol/logical NOT symbol
      # vertical line/logical OR symbol
      # broken vertical line
      # degree symbol
      # micro symbol
      # NUMERICS
      # 1/4,1/2,3/4 fractions
      # NON-IGNORABLES
      # eth
      # s-zet
      # thorn
      # ae & AE ligature
      # oe & OE ligature
      const_set_lazy(:DEFAULTRULES) { String.new("" + ("='".to_u << 0x200B << "'=".to_u << 0x200C << "=".to_u << 0x200D << "=".to_u << 0x200E << "=".to_u << 0x200F << "") + ("=".to_u << 0x0000 << " =".to_u << 0x0001 << " =".to_u << 0x0002 << " =".to_u << 0x0003 << " =".to_u << 0x0004 << "") + ("=".to_u << 0x0005 << " =".to_u << 0x0006 << " =".to_u << 0x0007 << " =".to_u << 0x0008 << " ='".to_u << 0x0009 << "'") + ("='".to_u << 0x000b << "' =".to_u << 0x000e << "") + ("=".to_u << 0x000f << " ='".to_u << 0x0010 << "' =".to_u << 0x0011 << " =".to_u << 0x0012 << " =".to_u << 0x0013 << "") + ("=".to_u << 0x0014 << " =".to_u << 0x0015 << " =".to_u << 0x0016 << " =".to_u << 0x0017 << " =".to_u << 0x0018 << "") + ("=".to_u << 0x0019 << " =".to_u << 0x001a << " =".to_u << 0x001b << " =".to_u << 0x001c << " =".to_u << 0x001d << "") + ("=".to_u << 0x001e << " =".to_u << 0x001f << " =".to_u << 0x007f << "") + ("=".to_u << 0x0080 << " =".to_u << 0x0081 << " =".to_u << 0x0082 << " =".to_u << 0x0083 << " =".to_u << 0x0084 << " =".to_u << 0x0085 << "") + ("=".to_u << 0x0086 << " =".to_u << 0x0087 << " =".to_u << 0x0088 << " =".to_u << 0x0089 << " =".to_u << 0x008a << " =".to_u << 0x008b << "") + ("=".to_u << 0x008c << " =".to_u << 0x008d << " =".to_u << 0x008e << " =".to_u << 0x008f << " =".to_u << 0x0090 << " =".to_u << 0x0091 << "") + ("=".to_u << 0x0092 << " =".to_u << 0x0093 << " =".to_u << 0x0094 << " =".to_u << 0x0095 << " =".to_u << 0x0096 << " =".to_u << 0x0097 << "") + ("=".to_u << 0x0098 << " =".to_u << 0x0099 << " =".to_u << 0x009a << " =".to_u << 0x009b << " =".to_u << 0x009c << " =".to_u << 0x009d << "") + ("=".to_u << 0x009e << " =".to_u << 0x009f << "") + (";'".to_u << 0x0020 << "';'".to_u << 0x00A0 << "'") + (";'".to_u << 0x2000 << "';'".to_u << 0x2001 << "';'".to_u << 0x2002 << "';'".to_u << 0x2003 << "';'".to_u << 0x2004 << "'") + (";'".to_u << 0x2005 << "';'".to_u << 0x2006 << "';'".to_u << 0x2007 << "';'".to_u << 0x2008 << "';'".to_u << 0x2009 << "'") + (";'".to_u << 0x200A << "';'".to_u << 0x3000 << "';'".to_u << 0xFEFF << "'") + (";'\r' ;'\t' ;'\n';'\f';'".to_u << 0x000b << "'") + (";".to_u << 0x0301 << "") + (";".to_u << 0x0300 << "") + (";".to_u << 0x0306 << "") + (";".to_u << 0x0302 << "") + (";".to_u << 0x030c << "") + (";".to_u << 0x030a << "") + (";".to_u << 0x030d << "") + (";".to_u << 0x0308 << "") + (";".to_u << 0x030b << "") + (";".to_u << 0x0303 << "") + (";".to_u << 0x0307 << "") + (";".to_u << 0x0304 << "") + (";".to_u << 0x0337 << "") + (";".to_u << 0x0327 << "") + (";".to_u << 0x0328 << "") + (";".to_u << 0x0323 << "") + (";".to_u << 0x0332 << "") + (";".to_u << 0x0305 << "") + (";".to_u << 0x0309 << "") + (";".to_u << 0x030e << "") + (";".to_u << 0x030f << "") + (";".to_u << 0x0310 << "") + (";".to_u << 0x0311 << "") + (";".to_u << 0x0312 << "") + (";".to_u << 0x0313 << "") + (";".to_u << 0x0314 << "") + (";".to_u << 0x0315 << "") + (";".to_u << 0x0316 << "") + (";".to_u << 0x0317 << "") + (";".to_u << 0x0318 << "") + (";".to_u << 0x0319 << "") + (";".to_u << 0x031a << "") + (";".to_u << 0x031b << "") + (";".to_u << 0x031c << "") + (";".to_u << 0x031d << "") + (";".to_u << 0x031e << "") + (";".to_u << 0x031f << "") + (";".to_u << 0x0320 << "") + (";".to_u << 0x0321 << "") + (";".to_u << 0x0322 << "") + (";".to_u << 0x0324 << "") + (";".to_u << 0x0325 << "") + (";".to_u << 0x0326 << "") + (";".to_u << 0x0329 << "") + (";".to_u << 0x032a << "") + (";".to_u << 0x032b << "") + (";".to_u << 0x032c << "") + (";".to_u << 0x032d << "") + (";".to_u << 0x032e << "") + (";".to_u << 0x032f << "") + (";".to_u << 0x0330 << "") + (";".to_u << 0x0331 << "") + (";".to_u << 0x0333 << "") + (";".to_u << 0x0334 << "") + (";".to_u << 0x0335 << "") + (";".to_u << 0x0336 << "") + (";".to_u << 0x0338 << "") + (";".to_u << 0x0339 << "") + (";".to_u << 0x033a << "") + (";".to_u << 0x033b << "") + (";".to_u << 0x033c << "") + (";".to_u << 0x033d << "") + (";".to_u << 0x033e << "") + (";".to_u << 0x033f << "") + (";".to_u << 0x0342 << ";") + ("".to_u << 0x0344 << ";".to_u << 0x0345 << ";".to_u << 0x0360 << ";".to_u << 0x0361 << "") + (";".to_u << 0x0483 << ";".to_u << 0x0484 << ";".to_u << 0x0485 << ";".to_u << 0x0486 << "") + (";".to_u << 0x20D0 << ";".to_u << 0x20D1 << ";".to_u << 0x20D2 << "") + (";".to_u << 0x20D3 << ";".to_u << 0x20D4 << ";".to_u << 0x20D5 << "") + (";".to_u << 0x20D6 << ";".to_u << 0x20D7 << ";".to_u << 0x20D8 << "") + (";".to_u << 0x20D9 << ";".to_u << 0x20DA << ";".to_u << 0x20DB << "") + (";".to_u << 0x20DC << ";".to_u << 0x20DD << ";".to_u << 0x20DE << "") + (";".to_u << 0x20DF << ";".to_u << 0x20E0 << ";".to_u << 0x20E1 << "") + (",'".to_u << 0x002D << "';".to_u << 0x00AD << "") + (";".to_u << 0x2010 << ";".to_u << 0x2011 << ";".to_u << 0x2012 << "") + (";".to_u << 0x2013 << ";".to_u << 0x2014 << ";".to_u << 0x2015 << "") + (";".to_u << 0x2212 << "") + ("<'".to_u << 0x005f << "'") + ("<".to_u << 0x00af << "") + ("<'".to_u << 0x002c << "'") + ("<'".to_u << 0x003b << "'") + ("<'".to_u << 0x003a << "'") + ("<'".to_u << 0x0021 << "'") + ("<".to_u << 0x00a1 << "") + ("<'".to_u << 0x003f << "'") + ("<".to_u << 0x00bf << "") + ("<'".to_u << 0x002f << "'") + ("<'".to_u << 0x002e << "'") + ("<".to_u << 0x00b4 << "") + ("<'".to_u << 0x0060 << "'") + ("<'".to_u << 0x005e << "'") + ("<".to_u << 0x00a8 << "") + ("<'".to_u << 0x007e << "'") + ("<".to_u << 0x00b7 << "") + ("<".to_u << 0x00b8 << "") + ("<'".to_u << 0x0027 << "'") + "<'\"'" + ("<".to_u << 0x00ab << "") + ("<".to_u << 0x00bb << "") + ("<'".to_u << 0x0028 << "'") + ("<'".to_u << 0x0029 << "'") + ("<'".to_u << 0x005b << "'") + ("<'".to_u << 0x005d << "'") + ("<'".to_u << 0x007b << "'") + ("<'".to_u << 0x007d << "'") + ("<".to_u << 0x00a7 << "") + ("<".to_u << 0x00b6 << "") + ("<".to_u << 0x00a9 << "") + ("<".to_u << 0x00ae << "") + ("<'".to_u << 0x0040 << "'") + ("<".to_u << 0x00a4 << "") + ("<".to_u << 0x0e3f << "") + ("<".to_u << 0x00a2 << "") + ("<".to_u << 0x20a1 << "") + ("<".to_u << 0x20a2 << "") + ("<'".to_u << 0x0024 << "'") + ("<".to_u << 0x20ab << "") + ("<".to_u << 0x20ac << "") + ("<".to_u << 0x20a3 << "") + ("<".to_u << 0x20a4 << "") + ("<".to_u << 0x20a5 << "") + ("<".to_u << 0x20a6 << "") + ("<".to_u << 0x20a7 << "") + ("<".to_u << 0x00a3 << "") + ("<".to_u << 0x20a8 << "") + ("<".to_u << 0x20aa << "") + ("<".to_u << 0x20a9 << "") + ("<".to_u << 0x00a5 << "") + ("<'".to_u << 0x002a << "'") + "<'\\'" + ("<'".to_u << 0x0026 << "'") + ("<'".to_u << 0x0023 << "'") + ("<'".to_u << 0x0025 << "'") + ("<'".to_u << 0x002b << "'") + ("<".to_u << 0x00b1 << "") + ("<".to_u << 0x00f7 << "") + ("<".to_u << 0x00d7 << "") + ("<'".to_u << 0x003c << "'") + ("<'".to_u << 0x003d << "'") + ("<'".to_u << 0x003e << "'") + ("<".to_u << 0x00ac << "") + ("<'".to_u << 0x007c << "'") + ("<".to_u << 0x00a6 << "") + ("<".to_u << 0x00b0 << "") + ("<".to_u << 0x00b5 << "") + "<0<1<2<3<4<5<6<7<8<9" + ("<".to_u << 0x00bc << "<".to_u << 0x00bd << "<".to_u << 0x00be << "") + "<a,A" + "<b,B" + "<c,C" + "<d,D" + ("<".to_u << 0x00F0 << ",".to_u << 0x00D0 << "") + "<e,E" + "<f,F" + "<g,G" + "<h,H" + "<i,I" + "<j,J" + "<k,K" + "<l,L" + "<m,M" + "<n,N" + "<o,O" + "<p,P" + "<q,Q" + "<r,R" + ("<s, S & SS,".to_u << 0x00DF << "") + "<t,T" + ("& TH, ".to_u << 0x00DE << " &TH, ".to_u << 0x00FE << " ") + "<u,U" + "<v,V" + "<w,W" + "<x,X" + "<y,Y" + "<z,Z" + ("&AE,".to_u << 0x00C6 << "") + ("&AE,".to_u << 0x00E6 << "") + ("&OE,".to_u << 0x0152 << "") + ("&OE,".to_u << 0x0153 << "")) }
      const_attr_reader  :DEFAULTRULES
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__collation_rules, :initialize
  end
  
end
