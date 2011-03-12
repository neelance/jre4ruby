require "rjava"

# Portions Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
# Licensed Materials - Property of IBM
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# (C) IBM Corp. 1997-1998.  All Rights Reserved.
# 
# The program is provided "as is" without any warranty express or
# implied, including the warranty of non-infringement and the implied
# warranties of merchantibility and fitness for a particular purpose.
# IBM will not be liable for any damages suffered by you as a result
# of using the Program. In no event will IBM be liable for any
# special, indirect or consequential damages or lost profits even if
# IBM has been advised of the possibility of their occurrence. IBM
# will not be liable for any third party claims against you.
module Sun::Text::Resources
  module BreakIteratorRulesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  # Default break-iterator rules.  These rules are more or less general for
  # all locales, although there are probably a few we're missing.  The
  # behavior currently mimics the behavior of BreakIterator in JDK 1.2.
  # There are known deficiencies in this behavior, including the fact that
  # the logic for handling CJK characters works for Japanese but not for
  # Chinese, and that we don't currently have an appropriate locale for
  # Thai.  The resources will eventually be updated to fix these problems.
  # Modified for Hindi 3/1/99.
  # Since JDK 1.5.0, this file no longer goes to runtime and is used at J2SE
  # build phase in order to create [Character|Word|Line|Sentence]BreakIteratorData
  # files which are used on runtime instead.
  class BreakIteratorRules < BreakIteratorRulesImports.const_get :ListResourceBundle
    include_class_members BreakIteratorRulesImports
    
    typesig { [] }
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["CharacterBreakRules", "<enclosing>=[:Mn::Me:];" + ("<choseong>=[".to_u << 0x1100 << "-".to_u << 0x115f << "];") + ("<jungseong>=[".to_u << 0x1160 << "-".to_u << 0x11a7 << "];") + ("<jongseong>=[".to_u << 0x11a8 << "-".to_u << 0x11ff << "];") + ("<surr-hi>=[".to_u << 0xd800 << "-".to_u << 0xdbff << "];") + ("<surr-lo>=[".to_u << 0xdc00 << "-".to_u << 0xdfff << "];") + ".;" + "<base>=[^<enclosing>^[:Cc::Cf::Zl::Zp:]];" + "<base><enclosing><enclosing>*;" + "\r\n;" + "<surr-hi><surr-lo>;" + "<choseong>*<jungseong>*<jongseong>*;" + ("<nukta>=[".to_u << 0x093c << "];") + ("<danda>=[".to_u << 0x0964 << "".to_u << 0x0965 << "];") + ("<virama>=[".to_u << 0x094d << "];") + ("<devVowelSign>=[".to_u << 0x093e << "-".to_u << 0x094c << "".to_u << 0x0962 << "".to_u << 0x0963 << "];") + ("<devConsonant>=[".to_u << 0x0915 << "-".to_u << 0x0939 << "];") + ("<devNuktaConsonant>=[".to_u << 0x0958 << "-".to_u << 0x095f << "];") + ("<devCharEnd>=[".to_u << 0x0902 << "".to_u << 0x0903 << "".to_u << 0x0951 << "-".to_u << 0x0954 << "];") + "<devCAMN>=(<devConsonant>{<nukta>});" + "<devConsonant1>=(<devNuktaConsonant>|<devCAMN>);" + ("<zwj>=[".to_u << 0x200d << "];") + "<devConjunct>=({<devConsonant1><virama>{<zwj>}}<devConsonant1>);" + "<devConjunct>{<devVowelSign>}{<devCharEnd>};" + "<danda><nukta>;"]), Array.typed(Object).new(["WordBreakRules", "<ignore>=[:Cf:];" + "<enclosing>=[:Mn::Me:];" + ("<danda>=[".to_u << 0x0964 << "".to_u << 0x0965 << "];") + ("<kanji>=[".to_u << 0x3005 << "".to_u << 0x4e00 << "-".to_u << 0x9fa5 << "".to_u << 0xf900 << "-".to_u << 0xfa2d << "];") + ("<kata>=[".to_u << 0x30a1 << "-".to_u << 0x30fa << "".to_u << 0x30fd << "".to_u << 0x30fe << "];") + ("<hira>=[".to_u << 0x3041 << "-".to_u << 0x3094 << "".to_u << 0x309d << "".to_u << 0x309e << "];") + ("<cjk-diacrit>=[".to_u << 0x3099 << "-".to_u << 0x309c << "".to_u << 0x30fb << "".to_u << 0x30fc << "];") + "<letter-base>=[:L::Mc:^[<kanji><kata><hira><cjk-diacrit>]];" + "<let>=(<letter-base><enclosing>*);" + "<digit-base>=[:N:];" + "<dgt>=(<digit-base><enclosing>*);" + ("<mid-word>=[:Pd::Pc:".to_u << 0x00ad << "".to_u << 0x2027 << "\\\"\\\'\\.];") + ("<mid-num>=[\\\"\\\'\\,".to_u << 0x066b << "\\.];") + ("<pre-num>=[:Sc:\\#\\.^".to_u << 0x00a2 << "];") + ("<post-num>=[\\%\\&".to_u << 0x00a2 << "".to_u << 0x066a << "".to_u << 0x2030 << "".to_u << 0x2031 << "];") + ("<ls>=[\n".to_u << 0x000c << "".to_u << 0x2028 << "".to_u << 0x2029 << "];") + "<ws-base>=[:Zs:\t];" + "<ws>=(<ws-base><enclosing>*);" + "<word>=((<let><let>*(<mid-word><let><let>*)*){<danda>});" + "<number>=(<dgt><dgt>*(<mid-num><dgt><dgt>*)*);" + ".;" + "{<word>}(<number><word>)*{<number>{<post-num>}};" + "<pre-num>(<number><word>)*{<number>{<post-num>}};" + "<ws>*{\r}{<ls>};" + "[<kata><cjk-diacrit>]*;" + "[<hira><cjk-diacrit>]*;" + "<kanji>*;" + "<base>=[^<enclosing>^[:Cc::Cf::Zl::Zp:]];" + "<base><enclosing><enclosing>*;"]), Array.typed(Object).new(["LineBreakRules", ("<break>=[".to_u << 0x0003 << "\t\n\f".to_u << 0x2028 << "".to_u << 0x2029 << "];") + "<ignore>=[:Cf:[:Cc:^[<break>\r]]];" + "<enclosing>=[:Mn::Me:];" + ("<danda>=[".to_u << 0x0964 << "".to_u << 0x0965 << "];") + ("<glue>=[".to_u << 0x00a0 << "".to_u << 0x0f0c << "".to_u << 0x2007 << "".to_u << 0x2011 << "".to_u << 0x202f << "".to_u << 0xfeff << "];") + "<space>=[:Zs::Cc:^[<glue><break>\r]];" + ("<dash>=[:Pd:".to_u << 0x00ad << "^<glue>];") + ("<pre-word>=[:Sc::Ps::Pi:^[".to_u << 0x00a2 << "]\\\"\\\'];") + ("<post-word>=[\\\":Pe::Pf:\\!\\%\\.\\,\\:\\;\\?".to_u << 0x00a2 << "".to_u << 0x00b0 << "".to_u << 0x066a << "".to_u << 0x2030 << "-".to_u << 0x2034 << "".to_u << 0x2103 << "") + ("".to_u << 0x2105 << "".to_u << 0x2109 << "".to_u << 0x3001 << "".to_u << 0x3002 << "".to_u << 0x3005 << "".to_u << 0x3041 << "".to_u << 0x3043 << "".to_u << 0x3045 << "".to_u << 0x3047 << "".to_u << 0x3049 << "".to_u << 0x3063 << "") + ("".to_u << 0x3083 << "".to_u << 0x3085 << "".to_u << 0x3087 << "".to_u << 0x308e << "".to_u << 0x3099 << "-".to_u << 0x309e << "".to_u << 0x30a1 << "".to_u << 0x30a3 << "".to_u << 0x30a5 << "".to_u << 0x30a7 << "".to_u << 0x30a9 << "") + ("".to_u << 0x30c3 << "".to_u << 0x30e3 << "".to_u << 0x30e5 << "".to_u << 0x30e7 << "".to_u << 0x30ee << "".to_u << 0x30f5 << "".to_u << 0x30f6 << "".to_u << 0x30fc << "-".to_u << 0x30fe << "".to_u << 0xff01 << "".to_u << 0xff05 << "") + ("".to_u << 0xff0c << "".to_u << 0xff0e << "".to_u << 0xff1a << "".to_u << 0xff1b << "".to_u << 0xff1f << "];") + ("<kanji>=[".to_u << 0x4e00 << "-".to_u << 0x9fa5 << "".to_u << 0xac00 << "-".to_u << 0xd7a3 << "".to_u << 0xf900 << "-".to_u << 0xfa2d << "".to_u << 0xfa30 << "-".to_u << 0xfa6a << "".to_u << 0x3041 << "-".to_u << 0x3094 << "".to_u << 0x30a1 << "-".to_u << 0x30fa << "^[<post-word><ignore>]];") + "<digit>=[:Nd::No:];" + "<mid-num>=[\\.\\,];" + "<char>=[^[<break><space><dash><kanji><glue><ignore><pre-word><post-word><mid-num>\r<danda>]];" + "<number>=([<pre-word><dash>]*<digit><digit>*(<mid-num><digit><digit>*)*);" + "<word-core>=(<char>*|<kanji>|<number>);" + "<word-suffix>=((<dash><dash>*|<post-word>*));" + "<word>=(<pre-word>*<word-core><word-suffix>);" + "<hack1>=[\\(];" + "<hack2>=[\\)];" + "<hack3>=[\\$\\'];" + "<word>(((<space>*<glue><glue>*{<space>})|<hack3>)<word>)*<space>*{<enclosing>*}{<hack1><hack2><post-word>*}{<enclosing>*}{\r}{<break>};" + "\r<break>;"]), Array.typed(Object).new(["SentenceBreakRules", "<ignore>=[:Mn::Me::Cf:];" + "<letter>=[:L:];" + "<lc>=[:Ll:];" + "<uc>=[:Lu:];" + "<notlc>=[<letter>^<lc>];" + ("<space>=[\t\r\f\n".to_u << 0x2028 << ":Zs:];") + "<start-punctuation>=[:Ps::Pi:\\\"\\\'];" + "<end>=[:Pe::Pf:\\\"\\\'];" + "<digit>=[:N:];" + ("<term>=[\\!\\?".to_u << 0x3002 << "".to_u << 0xff01 << "".to_u << 0xff1f << "];") + ("<period>=[\\.".to_u << 0xff0e << "];") + ("<sent-start>=[^[:L:<space><start-punctuation><end><digit><term><period>".to_u << 0x2029 << "<ignore>]];") + ("<danda>=[".to_u << 0x0964 << "".to_u << 0x0965 << "];") + (".*?{".to_u << 0x2029 << "};") + ".*?<danda><space>*;" + ".*?<period>[<period><end>]*<space><space>*/<notlc>;" + ".*?<period>[<period><end>]*<space>*/[<start-punctuation><sent-start>][<start-punctuation><sent-start>]*<letter>;" + (".*?<term>[<term><period><end>]*<space>*{".to_u << 0x2029 << "};") + "!<sent-start><start-punctuation>*<space>*<end>*<period>;" + "![<sent-start><lc><digit>]<start-punctuation>*<space>*<end>*<term>;"])])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__break_iterator_rules, :initialize
  end
  
end
