require "rjava"

# Portions Copyright 1999-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# IBM Confidential
# OCO Source Materials
# 
# IBM Java(tm)2 SDK, Standard Edition, v 1.2
# 
# (C) Copyright IBM Corp. 1999
# 
# The source code for this program is not published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with the U.S.
# Copyright office.
# Since JDK 1.5.0, this file no longer goes to runtime and is used at J2SE
# build phase in order to create [Word|Line]BreakIteratorData_th files which
# are used on runtime instead.
module Sun::Text::Resources
  module BreakIteratorRules_thImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Net, :URL
    }
  end
  
  class BreakIteratorRules_th < BreakIteratorRules_thImports.const_get :ListResourceBundle
    include_class_members BreakIteratorRules_thImports
    
    typesig { [] }
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["WordBreakRules", ("<dictionary>=[".to_u << 0x0e01 << "-".to_u << 0x0e2e << "".to_u << 0x0e30 << "-".to_u << 0x0e3a << "".to_u << 0x0e40 << "-".to_u << 0x0e44 << "".to_u << 0x0e47 << "-".to_u << 0x0e4e << "];") + "<ignore>=[:Mn::Me::Cf:^<dictionary>];" + ("<paiyannoi>=[".to_u << 0x0e2f << "];") + ("<maiyamok>=[".to_u << 0x0e46 << "];") + ("<danda>=[".to_u << 0x0964 << "".to_u << 0x0965 << "];") + ("<kanji>=[".to_u << 0x3005 << "".to_u << 0x4e00 << "-".to_u << 0x9fa5 << "".to_u << 0xf900 << "-".to_u << 0xfa2d << "];") + ("<kata>=[".to_u << 0x30a1 << "-".to_u << 0x30fa << "];") + ("<hira>=[".to_u << 0x3041 << "-".to_u << 0x3094 << "];") + ("<cjk-diacrit>=[".to_u << 0x3099 << "-".to_u << 0x309c << "];") + "<let>=[:L::Mc:^[<kanji><kata><hira><cjk-diacrit><dictionary>]];" + "<dgt>=[:N:];" + ("<mid-word>=[:Pd:".to_u << 0x00ad << "".to_u << 0x2027 << "\\\"\\\'\\.];") + ("<mid-num>=[\\\"\\\'\\,".to_u << 0x066b << "\\.];") + ("<pre-num>=[:Sc:\\#\\.^".to_u << 0x00a2 << "];") + ("<post-num>=[\\%\\&".to_u << 0x00a2 << "".to_u << 0x066a << "".to_u << 0x2030 << "".to_u << 0x2031 << "];") + ("<ls>=[\n".to_u << 0x000c << "".to_u << 0x2028 << "".to_u << 0x2029 << "];") + "<ws>=[:Zs:\t];" + "<word>=((<let><let>*(<mid-word><let><let>*)*){<danda>});" + "<number>=(<dgt><dgt>*(<mid-num><dgt><dgt>*)*);" + ("<thai-etc>=<paiyannoi>".to_u << 0x0e25 << "<paiyannoi>;") + ".;" + "{<word>}(<number><word>)*{<number>{<post-num>}};" + "<pre-num>(<number><word>)*{<number>{<post-num>}};" + "<dictionary><dictionary>*{{<paiyannoi>}<maiyamok>};" + ("<dictionary><dictionary>*<paiyannoi>/([^[".to_u << 0x0e25 << "<ignore>]]") + ("|".to_u << 0x0e25 << "[^[<paiyannoi><ignore>]]);") + "<thai-etc>;" + "<ws>*{\r}{<ls>};" + "[<kata><cjk-diacrit>]*;" + "[<hira><cjk-diacrit>]*;" + "<kanji>*;"]), Array.typed(Object).new(["LineBreakRules", ("<dictionary>=[".to_u << 0x0e01 << "-".to_u << 0x0e2e << "".to_u << 0x0e30 << "-".to_u << 0x0e3a << "".to_u << 0x0e40 << "-".to_u << 0x0e44 << "".to_u << 0x0e47 << "-".to_u << 0x0e4e << "];") + "<ignore>=[:Mn::Me::Cf:^[<dictionary>]];" + ("<danda>=[".to_u << 0x0964 << "".to_u << 0x0965 << "];") + ("<break>=[".to_u << 0x0003 << "\t\n\f".to_u << 0x2028 << "".to_u << 0x2029 << "];") + ("<nbsp>=[".to_u << 0x00a0 << "".to_u << 0x0f0c << "".to_u << 0x2007 << "".to_u << 0x2011 << "".to_u << 0x202f << "".to_u << 0xfeff << "];") + "<space>=[:Zs::Cc:^[<nbsp><break>\r]];" + ("<dash>=[:Pd:".to_u << 0x00ad << "^<nbsp>];") + ("<paiyannoi>=[".to_u << 0x0e2f << "];") + ("<maiyamok>=[".to_u << 0x0e46 << "];") + ("<thai-etc>=(<paiyannoi>".to_u << 0x0e25 << "<paiyannoi>);") + ("<pre-word>=[:Sc::Ps::Pi:^".to_u << 0x00a2 << "\\\"];") + ("<post-word>=[:Pe::Pf:\\!\\%\\.\\,\\:\\;\\?\\\"".to_u << 0x00a2 << "".to_u << 0x00b0 << "".to_u << 0x066a << "".to_u << 0x2030 << "-".to_u << 0x2034 << "".to_u << 0x2103 << "") + ("".to_u << 0x2105 << "".to_u << 0x2109 << "".to_u << 0x3001 << "".to_u << 0x3002 << "".to_u << 0x3005 << "".to_u << 0x3041 << "".to_u << 0x3043 << "".to_u << 0x3045 << "".to_u << 0x3047 << "".to_u << 0x3049 << "".to_u << 0x3063 << "") + ("".to_u << 0x3083 << "".to_u << 0x3085 << "".to_u << 0x3087 << "".to_u << 0x308e << "".to_u << 0x3099 << "-".to_u << 0x309e << "".to_u << 0x30a1 << "".to_u << 0x30a3 << "".to_u << 0x30a5 << "".to_u << 0x30a7 << "".to_u << 0x30a9 << "") + ("".to_u << 0x30c3 << "".to_u << 0x30e3 << "".to_u << 0x30e5 << "".to_u << 0x30e7 << "".to_u << 0x30ee << "".to_u << 0x30f5 << "".to_u << 0x30f6 << "".to_u << 0x30fc << "-".to_u << 0x30fe << "".to_u << 0xff01 << "".to_u << 0xff0e << "") + ("".to_u << 0xff1f << "<maiyamok>];") + ("<kanji>=[".to_u << 0x4e00 << "-".to_u << 0x9fa5 << "".to_u << 0xf900 << "-".to_u << 0xfa2d << "".to_u << 0x3041 << "-".to_u << 0x3094 << "".to_u << 0x30a1 << "-".to_u << 0x30fa << "^[<post-word><ignore>]];") + "<digit>=[:Nd::No:];" + "<mid-num>=[\\.\\,];" + "<char>=[^[<break><space><dash><kanji><nbsp><ignore><pre-word><post-word>" + "<mid-num>\r<danda><dictionary><paiyannoi><maiyamok>]];" + "<number>=([<pre-word><dash>]*<digit><digit>*(<mid-num><digit><digit>*)*);" + "<word-core>=(<char>*|<kanji>|<number>|<dictionary><dictionary>*|<thai-etc>);" + "<word-suffix>=((<dash><dash>*|<post-word>*)<space>*);" + "<word>=(<pre-word>*<word-core><word-suffix>);" + "<word>(<nbsp><nbsp>*<word>)*{({\r}{<break>}|<paiyannoi>\r{break}|<paiyannoi><break>)};" + ("<word>(<nbsp><nbsp>*<word>)*<paiyannoi>/([^[".to_u << 0x0e25 << "<ignore>]]|") + ("".to_u << 0x0e25 << "[^[<paiyannoi><ignore>]]);")])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__break_iterator_rules_th, :initialize
  end
  
end
