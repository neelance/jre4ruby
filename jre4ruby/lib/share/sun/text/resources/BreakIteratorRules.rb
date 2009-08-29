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
# 
# 
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
  # 
  # Modified for Hindi 3/1/99.
  # 
  # Since JDK 1.5.0, this file no longer goes to runtime and is used at J2SE
  # build phase in order to create [Character|Word|Line|Sentence]BreakIteratorData
  # files which are used on runtime instead.
  class BreakIteratorRules < BreakIteratorRulesImports.const_get :ListResourceBundle
    include_class_members BreakIteratorRulesImports
    
    typesig { [] }
    def get_contents
      # rules describing how to break between logical characters
      # ignore non-spacing marks and enclosing marks (since we never
      # put a break before ignore characters, this keeps combining
      # accents with the base characters they modify)
      # other category definitions
      # break after every character, except as follows:
      # keep base and combining characters togethers
      # keep CRLF sequences together
      # keep surrogate pairs together
      # keep Hangul syllables spelled out using conjoining jamo together
      # various additions for Hindi support
      # default rules for finding word boundaries
      # ignore non-spacing marks, enclosing marks, and format characters,
      # all of which should not influence the algorithm
      # "<ignore>=[:Mn::Me::Cf:];"
      # Hindi phrase separator, kanji, katakana, hiragana, CJK diacriticals,
      # other letters, and digits
      # punctuation that can occur in the middle of a word: currently
      # dashes, apostrophes, quotation marks, and periods
      # punctuation that can occur in the middle of a number: currently
      # apostrophes, qoutation marks, periods, commas, and the Arabic
      # decimal point
      # punctuation that can occur at the beginning of a number: currently
      # the period, the number sign, and all currency symbols except the cents sign
      # punctuation that can occur at the end of a number: currently
      # the percent, per-thousand, per-ten-thousand, and Arabic percent
      # signs, the cents sign, and the ampersand
      # line separators: currently LF, FF, PS, and LS
      # whitespace: all space separators and the tab character
      # a word is a sequence of letters that may contain internal
      # punctuation, as long as it begins and ends with a letter and
      # never contains two punctuation marks in a row
      # a number is a sequence of digits that may contain internal
      # punctuation, as long as it begins and ends with a digit and
      # never contains two punctuation marks in a row.
      # break after every character, with the following exceptions
      # (this will cause punctuation marks that aren't considered
      # part of words or numbers to be treated as words unto themselves)
      # keep together any sequence of contiguous words and numbers
      # (including just one of either), plus an optional trailing
      # number-suffix character
      # keep together and sequence of contiguous words and numbers
      # that starts with a number-prefix character and a number,
      # and may end with a number-suffix character
      # keep together runs of whitespace (optionally with a single trailing
      # line separator or CRLF sequence)
      # keep together runs of Katakana and CJK diacritical marks
      # keep together runs of Hiragana and CJK diacritical marks
      # keep together runs of Kanji
      # keep together anything else and an enclosing mark
      # default rules for determining legal line-breaking positions
      # characters that always cause a break: ETX, tab, LF, FF, LS, and PS
      # ignore format characters and control characters EXCEPT for breaking chars
      # enclosing marks
      # Hindi phrase separators
      # characters that always prevent a break: the non-breaking space
      # and similar characters
      # whitespace: space separators and control characters, except for
      # CR and the other characters mentioned above
      # dashes: dash punctuation and the discretionary hyphen, except for
      # non-breaking hyphens
      # characters that stick to a word if they precede it: currency symbols
      # (except the cents sign) and starting punctuation
      # characters that stick to a word if they follow it: ending punctuation,
      # other punctuation that usually occurs at the end of a sentence,
      # small Kana characters, some CJK diacritics, etc.
      # Kanji: actually includes Kanji,Kana and Hangul syllables,
      # except for small Kana and CJK diacritics
      # digits
      # punctuation that can occur in the middle of a number: periods and commas
      # everything not mentioned above
      # a "number" is a run of prefix characters and dashes, followed by one or
      # more digits with isolated number-punctuation characters interspersed
      # the basic core of a word can be either a "number" as defined above, a single
      # "Kanji" character, or a run of any number of not-explicitly-mentioned
      # characters (this includes Latin letters)
      # a word may end with an optional suffix that be either a run of one or
      # more dashes or a run of word-suffix characters
      # a word, thus, is an optional run of word-prefix characters, followed by
      # a word core and a word suffix (the syntax of <word-core> and <word-suffix>
      # actually allows either of them to match the empty string, putting a break
      # between things like ")(" or "aaa(aaa"
      # finally, the rule that does the work: Keep together any run of words that
      # are joined by runs of one of more non-spacing mark.  Also keep a trailing
      # line-break character or CRLF combination with the word.  (line separators
      # "win" over nbsp's)
      # default rules for finding sentence boundaries
      # ignore non-spacing marks, enclosing marks, and format characters
      # letters
      # lowercase letters
      # uppercase letters
      # NOT lowercase letters
      # whitespace (line separators are treated as whitespace)
      # punctuation which may occur at the beginning of a sentence: "starting
      # punctuation" and quotation marks
      # punctuation with may occur at the end of a sentence: "ending punctuation"
      # and quotation marks
      # digits
      # characters that unambiguously signal the end of a sentence
      # periods, which MAY signal the end of a sentence
      # characters that may occur at the beginning of a sentence: basically anything
      # not mentioned above (letters and digits are specifically excluded)
      # Hindi phrase separator
      # always break sentences after paragraph separators
      # always break after a danda, if it's followed by whitespace
      # if you see a period, skip over additional periods and ending punctuation
      # and if the next character is a paragraph separator, break after the
      # paragraph separator
      # + ".*?<period>[<period><end>]*<space>*\u2029;"
      # + ".*?[<period><end>]*<space>*\u2029;"
      # if you see a period, skip over additional periods and ending punctuation,
      # followed by optional whitespace, followed by optional starting punctuation,
      # and if the next character is something that can start a sentence
      # (basically, a capital letter), then put the sentence break between the
      # whitespace and the opening punctuation
      # if you see a sentence-terminating character, skip over any additional
      # terminators, periods, or ending punctuation, followed by any whitespace,
      # followed by a SINGLE optional paragraph separator, and put the break there
      # The following rules are here to aid in backwards iteration.  The automatically
      # generated backwards state table will rewind to the beginning of the
      # paragraph all the time (or all the way to the beginning of the document
      # if the document doesn't use the Unicode PS character) because the only
      # unambiguous character pairs are those involving paragraph separators.
      # These specify a few more unambiguous breaking situations.
      # if you see a sentence-starting character, followed by starting punctuation
      # (remember, we're iterating backwards), followed by an optional run of
      # whitespace, followed by an optional run of ending punctuation, followed
      # by a period, this is a safe place to turn around
      # if you see a letter or a digit, followed by an optional run of
      # starting punctuation, followed by an optional run of whitespace,
      # followed by an optional run of ending punctuation, followed by
      # a sentence terminator, this is a safe place to turn around
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
