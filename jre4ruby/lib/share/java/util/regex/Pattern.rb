require "rjava"

# Copyright 1999-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Regex
  module PatternImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Regex
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Text, :CharacterIterator
      include_const ::Java::Text, :Normalizer
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Arrays
    }
  end
  
  # A compiled representation of a regular expression.
  # 
  # <p> A regular expression, specified as a string, must first be compiled into
  # an instance of this class.  The resulting pattern can then be used to create
  # a {@link Matcher} object that can match arbitrary {@link
  # java.lang.CharSequence </code>character sequences<code>} against the regular
  # expression.  All of the state involved in performing a match resides in the
  # matcher, so many matchers can share the same pattern.
  # 
  # <p> A typical invocation sequence is thus
  # 
  # <blockquote><pre>
  # Pattern p = Pattern.{@link #compile compile}("a*b");
  # Matcher m = p.{@link #matcher matcher}("aaaaab");
  # boolean b = m.{@link Matcher#matches matches}();</pre></blockquote>
  # 
  # <p> A {@link #matches matches} method is defined by this class as a
  # convenience for when a regular expression is used just once.  This method
  # compiles an expression and matches an input sequence against it in a single
  # invocation.  The statement
  # 
  # <blockquote><pre>
  # boolean b = Pattern.matches("a*b", "aaaaab");</pre></blockquote>
  # 
  # is equivalent to the three statements above, though for repeated matches it
  # is less efficient since it does not allow the compiled pattern to be reused.
  # 
  # <p> Instances of this class are immutable and are safe for use by multiple
  # concurrent threads.  Instances of the {@link Matcher} class are not safe for
  # such use.
  # 
  # 
  # <a name="sum">
  # <h4> Summary of regular-expression constructs </h4>
  # 
  # <table border="0" cellpadding="1" cellspacing="0"
  # summary="Regular expression constructs, and what they match">
  # 
  # <tr align="left">
  # <th bgcolor="#CCCCFF" align="left" id="construct">Construct</th>
  # <th bgcolor="#CCCCFF" align="left" id="matches">Matches</th>
  # </tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="characters">Characters</th></tr>
  # 
  # <tr><td valign="top" headers="construct characters"><i>x</i></td>
  # <td headers="matches">The character <i>x</i></td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\\</tt></td>
  # <td headers="matches">The backslash character</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\0</tt><i>n</i></td>
  # <td headers="matches">The character with octal value <tt>0</tt><i>n</i>
  # (0&nbsp;<tt>&lt;=</tt>&nbsp;<i>n</i>&nbsp;<tt>&lt;=</tt>&nbsp;7)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\0</tt><i>nn</i></td>
  # <td headers="matches">The character with octal value <tt>0</tt><i>nn</i>
  # (0&nbsp;<tt>&lt;=</tt>&nbsp;<i>n</i>&nbsp;<tt>&lt;=</tt>&nbsp;7)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\0</tt><i>mnn</i></td>
  # <td headers="matches">The character with octal value <tt>0</tt><i>mnn</i>
  # (0&nbsp;<tt>&lt;=</tt>&nbsp;<i>m</i>&nbsp;<tt>&lt;=</tt>&nbsp;3,
  # 0&nbsp;<tt>&lt;=</tt>&nbsp;<i>n</i>&nbsp;<tt>&lt;=</tt>&nbsp;7)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\x</tt><i>hh</i></td>
  # <td headers="matches">The character with hexadecimal&nbsp;value&nbsp;<tt>0x</tt><i>hh</i></td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>&#92;u</tt><i>hhhh</i></td>
  # <td headers="matches">The character with hexadecimal&nbsp;value&nbsp;<tt>0x</tt><i>hhhh</i></td></tr>
  # <tr><td valign="top" headers="matches"><tt>\t</tt></td>
  # <td headers="matches">The tab character (<tt>'&#92;u0009'</tt>)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\n</tt></td>
  # <td headers="matches">The newline (line feed) character (<tt>'&#92;u000A'</tt>)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\r</tt></td>
  # <td headers="matches">The carriage-return character (<tt>'&#92;u000D'</tt>)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\f</tt></td>
  # <td headers="matches">The form-feed character (<tt>'&#92;u000C'</tt>)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\a</tt></td>
  # <td headers="matches">The alert (bell) character (<tt>'&#92;u0007'</tt>)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\e</tt></td>
  # <td headers="matches">The escape character (<tt>'&#92;u001B'</tt>)</td></tr>
  # <tr><td valign="top" headers="construct characters"><tt>\c</tt><i>x</i></td>
  # <td headers="matches">The control character corresponding to <i>x</i></td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="classes">Character classes</th></tr>
  # 
  # <tr><td valign="top" headers="construct classes"><tt>[abc]</tt></td>
  # <td headers="matches"><tt>a</tt>, <tt>b</tt>, or <tt>c</tt> (simple class)</td></tr>
  # <tr><td valign="top" headers="construct classes"><tt>[^abc]</tt></td>
  # <td headers="matches">Any character except <tt>a</tt>, <tt>b</tt>, or <tt>c</tt> (negation)</td></tr>
  # <tr><td valign="top" headers="construct classes"><tt>[a-zA-Z]</tt></td>
  # <td headers="matches"><tt>a</tt> through <tt>z</tt>
  # or <tt>A</tt> through <tt>Z</tt>, inclusive (range)</td></tr>
  # <tr><td valign="top" headers="construct classes"><tt>[a-d[m-p]]</tt></td>
  # <td headers="matches"><tt>a</tt> through <tt>d</tt>,
  # or <tt>m</tt> through <tt>p</tt>: <tt>[a-dm-p]</tt> (union)</td></tr>
  # <tr><td valign="top" headers="construct classes"><tt>[a-z&&[def]]</tt></td>
  # <td headers="matches"><tt>d</tt>, <tt>e</tt>, or <tt>f</tt> (intersection)</tr>
  # <tr><td valign="top" headers="construct classes"><tt>[a-z&&[^bc]]</tt></td>
  # <td headers="matches"><tt>a</tt> through <tt>z</tt>,
  # except for <tt>b</tt> and <tt>c</tt>: <tt>[ad-z]</tt> (subtraction)</td></tr>
  # <tr><td valign="top" headers="construct classes"><tt>[a-z&&[^m-p]]</tt></td>
  # <td headers="matches"><tt>a</tt> through <tt>z</tt>,
  # and not <tt>m</tt> through <tt>p</tt>: <tt>[a-lq-z]</tt>(subtraction)</td></tr>
  # <tr><th>&nbsp;</th></tr>
  # 
  # <tr align="left"><th colspan="2" id="predef">Predefined character classes</th></tr>
  # 
  # <tr><td valign="top" headers="construct predef"><tt>.</tt></td>
  # <td headers="matches">Any character (may or may not match <a href="#lt">line terminators</a>)</td></tr>
  # <tr><td valign="top" headers="construct predef"><tt>\d</tt></td>
  # <td headers="matches">A digit: <tt>[0-9]</tt></td></tr>
  # <tr><td valign="top" headers="construct predef"><tt>\D</tt></td>
  # <td headers="matches">A non-digit: <tt>[^0-9]</tt></td></tr>
  # <tr><td valign="top" headers="construct predef"><tt>\s</tt></td>
  # <td headers="matches">A whitespace character: <tt>[ \t\n\x0B\f\r]</tt></td></tr>
  # <tr><td valign="top" headers="construct predef"><tt>\S</tt></td>
  # <td headers="matches">A non-whitespace character: <tt>[^\s]</tt></td></tr>
  # <tr><td valign="top" headers="construct predef"><tt>\w</tt></td>
  # <td headers="matches">A word character: <tt>[a-zA-Z_0-9]</tt></td></tr>
  # <tr><td valign="top" headers="construct predef"><tt>\W</tt></td>
  # <td headers="matches">A non-word character: <tt>[^\w]</tt></td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="posix">POSIX character classes</b> (US-ASCII only)<b></th></tr>
  # 
  # <tr><td valign="top" headers="construct posix"><tt>\p{Lower}</tt></td>
  # <td headers="matches">A lower-case alphabetic character: <tt>[a-z]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Upper}</tt></td>
  # <td headers="matches">An upper-case alphabetic character:<tt>[A-Z]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{ASCII}</tt></td>
  # <td headers="matches">All ASCII:<tt>[\x00-\x7F]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Alpha}</tt></td>
  # <td headers="matches">An alphabetic character:<tt>[\p{Lower}\p{Upper}]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Digit}</tt></td>
  # <td headers="matches">A decimal digit: <tt>[0-9]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Alnum}</tt></td>
  # <td headers="matches">An alphanumeric character:<tt>[\p{Alpha}\p{Digit}]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Punct}</tt></td>
  # <td headers="matches">Punctuation: One of <tt>!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~</tt></td></tr>
  # <!-- <tt>[\!"#\$%&'\(\)\*\+,\-\./:;\<=\>\?@\[\\\]\^_`\{\|\}~]</tt>
  # <tt>[\X21-\X2F\X31-\X40\X5B-\X60\X7B-\X7E]</tt> -->
  # <tr><td valign="top" headers="construct posix"><tt>\p{Graph}</tt></td>
  # <td headers="matches">A visible character: <tt>[\p{Alnum}\p{Punct}]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Print}</tt></td>
  # <td headers="matches">A printable character: <tt>[\p{Graph}\x20]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Blank}</tt></td>
  # <td headers="matches">A space or a tab: <tt>[ \t]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Cntrl}</tt></td>
  # <td headers="matches">A control character: <tt>[\x00-\x1F\x7F]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{XDigit}</tt></td>
  # <td headers="matches">A hexadecimal digit: <tt>[0-9a-fA-F]</tt></td></tr>
  # <tr><td valign="top" headers="construct posix"><tt>\p{Space}</tt></td>
  # <td headers="matches">A whitespace character: <tt>[ \t\n\x0B\f\r]</tt></td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2">java.lang.Character classes (simple <a href="#jcc">java character type</a>)</th></tr>
  # 
  # <tr><td valign="top"><tt>\p{javaLowerCase}</tt></td>
  # <td>Equivalent to java.lang.Character.isLowerCase()</td></tr>
  # <tr><td valign="top"><tt>\p{javaUpperCase}</tt></td>
  # <td>Equivalent to java.lang.Character.isUpperCase()</td></tr>
  # <tr><td valign="top"><tt>\p{javaWhitespace}</tt></td>
  # <td>Equivalent to java.lang.Character.isWhitespace()</td></tr>
  # <tr><td valign="top"><tt>\p{javaMirrored}</tt></td>
  # <td>Equivalent to java.lang.Character.isMirrored()</td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="unicode">Classes for Unicode blocks and categories</th></tr>
  # 
  # <tr><td valign="top" headers="construct unicode"><tt>\p{InGreek}</tt></td>
  # <td headers="matches">A character in the Greek&nbsp;block (simple <a href="#ubc">block</a>)</td></tr>
  # <tr><td valign="top" headers="construct unicode"><tt>\p{Lu}</tt></td>
  # <td headers="matches">An uppercase letter (simple <a href="#ubc">category</a>)</td></tr>
  # <tr><td valign="top" headers="construct unicode"><tt>\p{Sc}</tt></td>
  # <td headers="matches">A currency symbol</td></tr>
  # <tr><td valign="top" headers="construct unicode"><tt>\P{InGreek}</tt></td>
  # <td headers="matches">Any character except one in the Greek block (negation)</td></tr>
  # <tr><td valign="top" headers="construct unicode"><tt>[\p{L}&&[^\p{Lu}]]&nbsp;</tt></td>
  # <td headers="matches">Any letter except an uppercase letter (subtraction)</td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="bounds">Boundary matchers</th></tr>
  # 
  # <tr><td valign="top" headers="construct bounds"><tt>^</tt></td>
  # <td headers="matches">The beginning of a line</td></tr>
  # <tr><td valign="top" headers="construct bounds"><tt>$</tt></td>
  # <td headers="matches">The end of a line</td></tr>
  # <tr><td valign="top" headers="construct bounds"><tt>\b</tt></td>
  # <td headers="matches">A word boundary</td></tr>
  # <tr><td valign="top" headers="construct bounds"><tt>\B</tt></td>
  # <td headers="matches">A non-word boundary</td></tr>
  # <tr><td valign="top" headers="construct bounds"><tt>\A</tt></td>
  # <td headers="matches">The beginning of the input</td></tr>
  # <tr><td valign="top" headers="construct bounds"><tt>\G</tt></td>
  # <td headers="matches">The end of the previous match</td></tr>
  # <tr><td valign="top" headers="construct bounds"><tt>\Z</tt></td>
  # <td headers="matches">The end of the input but for the final
  # <a href="#lt">terminator</a>, if&nbsp;any</td></tr>
  # <tr><td valign="top" headers="construct bounds"><tt>\z</tt></td>
  # <td headers="matches">The end of the input</td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="greedy">Greedy quantifiers</th></tr>
  # 
  # <tr><td valign="top" headers="construct greedy"><i>X</i><tt>?</tt></td>
  # <td headers="matches"><i>X</i>, once or not at all</td></tr>
  # <tr><td valign="top" headers="construct greedy"><i>X</i><tt>*</tt></td>
  # <td headers="matches"><i>X</i>, zero or more times</td></tr>
  # <tr><td valign="top" headers="construct greedy"><i>X</i><tt>+</tt></td>
  # <td headers="matches"><i>X</i>, one or more times</td></tr>
  # <tr><td valign="top" headers="construct greedy"><i>X</i><tt>{</tt><i>n</i><tt>}</tt></td>
  # <td headers="matches"><i>X</i>, exactly <i>n</i> times</td></tr>
  # <tr><td valign="top" headers="construct greedy"><i>X</i><tt>{</tt><i>n</i><tt>,}</tt></td>
  # <td headers="matches"><i>X</i>, at least <i>n</i> times</td></tr>
  # <tr><td valign="top" headers="construct greedy"><i>X</i><tt>{</tt><i>n</i><tt>,</tt><i>m</i><tt>}</tt></td>
  # <td headers="matches"><i>X</i>, at least <i>n</i> but not more than <i>m</i> times</td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="reluc">Reluctant quantifiers</th></tr>
  # 
  # <tr><td valign="top" headers="construct reluc"><i>X</i><tt>??</tt></td>
  # <td headers="matches"><i>X</i>, once or not at all</td></tr>
  # <tr><td valign="top" headers="construct reluc"><i>X</i><tt>*?</tt></td>
  # <td headers="matches"><i>X</i>, zero or more times</td></tr>
  # <tr><td valign="top" headers="construct reluc"><i>X</i><tt>+?</tt></td>
  # <td headers="matches"><i>X</i>, one or more times</td></tr>
  # <tr><td valign="top" headers="construct reluc"><i>X</i><tt>{</tt><i>n</i><tt>}?</tt></td>
  # <td headers="matches"><i>X</i>, exactly <i>n</i> times</td></tr>
  # <tr><td valign="top" headers="construct reluc"><i>X</i><tt>{</tt><i>n</i><tt>,}?</tt></td>
  # <td headers="matches"><i>X</i>, at least <i>n</i> times</td></tr>
  # <tr><td valign="top" headers="construct reluc"><i>X</i><tt>{</tt><i>n</i><tt>,</tt><i>m</i><tt>}?</tt></td>
  # <td headers="matches"><i>X</i>, at least <i>n</i> but not more than <i>m</i> times</td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="poss">Possessive quantifiers</th></tr>
  # 
  # <tr><td valign="top" headers="construct poss"><i>X</i><tt>?+</tt></td>
  # <td headers="matches"><i>X</i>, once or not at all</td></tr>
  # <tr><td valign="top" headers="construct poss"><i>X</i><tt>*+</tt></td>
  # <td headers="matches"><i>X</i>, zero or more times</td></tr>
  # <tr><td valign="top" headers="construct poss"><i>X</i><tt>++</tt></td>
  # <td headers="matches"><i>X</i>, one or more times</td></tr>
  # <tr><td valign="top" headers="construct poss"><i>X</i><tt>{</tt><i>n</i><tt>}+</tt></td>
  # <td headers="matches"><i>X</i>, exactly <i>n</i> times</td></tr>
  # <tr><td valign="top" headers="construct poss"><i>X</i><tt>{</tt><i>n</i><tt>,}+</tt></td>
  # <td headers="matches"><i>X</i>, at least <i>n</i> times</td></tr>
  # <tr><td valign="top" headers="construct poss"><i>X</i><tt>{</tt><i>n</i><tt>,</tt><i>m</i><tt>}+</tt></td>
  # <td headers="matches"><i>X</i>, at least <i>n</i> but not more than <i>m</i> times</td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="logical">Logical operators</th></tr>
  # 
  # <tr><td valign="top" headers="construct logical"><i>XY</i></td>
  # <td headers="matches"><i>X</i> followed by <i>Y</i></td></tr>
  # <tr><td valign="top" headers="construct logical"><i>X</i><tt>|</tt><i>Y</i></td>
  # <td headers="matches">Either <i>X</i> or <i>Y</i></td></tr>
  # <tr><td valign="top" headers="construct logical"><tt>(</tt><i>X</i><tt>)</tt></td>
  # <td headers="matches">X, as a <a href="#cg">capturing group</a></td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="backref">Back references</th></tr>
  # 
  # <tr><td valign="bottom" headers="construct backref"><tt>\</tt><i>n</i></td>
  # <td valign="bottom" headers="matches">Whatever the <i>n</i><sup>th</sup>
  # <a href="#cg">capturing group</a> matched</td></tr>
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="quot">Quotation</th></tr>
  # 
  # <tr><td valign="top" headers="construct quot"><tt>\</tt></td>
  # <td headers="matches">Nothing, but quotes the following character</td></tr>
  # <tr><td valign="top" headers="construct quot"><tt>\Q</tt></td>
  # <td headers="matches">Nothing, but quotes all characters until <tt>\E</tt></td></tr>
  # <tr><td valign="top" headers="construct quot"><tt>\E</tt></td>
  # <td headers="matches">Nothing, but ends quoting started by <tt>\Q</tt></td></tr>
  # <!-- Metachars: !$()*+.<>?[\]^{|} -->
  # 
  # <tr><th>&nbsp;</th></tr>
  # <tr align="left"><th colspan="2" id="special">Special constructs (non-capturing)</th></tr>
  # 
  # <tr><td valign="top" headers="construct special"><tt>(?:</tt><i>X</i><tt>)</tt></td>
  # <td headers="matches"><i>X</i>, as a non-capturing group</td></tr>
  # <tr><td valign="top" headers="construct special"><tt>(?idmsux-idmsux)&nbsp;</tt></td>
  # <td headers="matches">Nothing, but turns match flags <a href="#CASE_INSENSITIVE">i</a>
  # <a href="#UNIX_LINES">d</a> <a href="#MULTILINE">m</a> <a href="#DOTALL">s</a>
  # <a href="#UNICODE_CASE">u</a> <a href="#COMMENTS">x</a> on - off</td></tr>
  # <tr><td valign="top" headers="construct special"><tt>(?idmsux-idmsux:</tt><i>X</i><tt>)</tt>&nbsp;&nbsp;</td>
  # <td headers="matches"><i>X</i>, as a <a href="#cg">non-capturing group</a> with the
  # given flags <a href="#CASE_INSENSITIVE">i</a> <a href="#UNIX_LINES">d</a>
  # <a href="#MULTILINE">m</a> <a href="#DOTALL">s</a> <a href="#UNICODE_CASE">u</a >
  # <a href="#COMMENTS">x</a> on - off</td></tr>
  # <tr><td valign="top" headers="construct special"><tt>(?=</tt><i>X</i><tt>)</tt></td>
  # <td headers="matches"><i>X</i>, via zero-width positive lookahead</td></tr>
  # <tr><td valign="top" headers="construct special"><tt>(?!</tt><i>X</i><tt>)</tt></td>
  # <td headers="matches"><i>X</i>, via zero-width negative lookahead</td></tr>
  # <tr><td valign="top" headers="construct special"><tt>(?&lt;=</tt><i>X</i><tt>)</tt></td>
  # <td headers="matches"><i>X</i>, via zero-width positive lookbehind</td></tr>
  # <tr><td valign="top" headers="construct special"><tt>(?&lt;!</tt><i>X</i><tt>)</tt></td>
  # <td headers="matches"><i>X</i>, via zero-width negative lookbehind</td></tr>
  # <tr><td valign="top" headers="construct special"><tt>(?&gt;</tt><i>X</i><tt>)</tt></td>
  # <td headers="matches"><i>X</i>, as an independent, non-capturing group</td></tr>
  # 
  # </table>
  # 
  # <hr>
  # 
  # 
  # <a name="bs">
  # <h4> Backslashes, escapes, and quoting </h4>
  # 
  # <p> The backslash character (<tt>'\'</tt>) serves to introduce escaped
  # constructs, as defined in the table above, as well as to quote characters
  # that otherwise would be interpreted as unescaped constructs.  Thus the
  # expression <tt>\\</tt> matches a single backslash and <tt>\{</tt> matches a
  # left brace.
  # 
  # <p> It is an error to use a backslash prior to any alphabetic character that
  # does not denote an escaped construct; these are reserved for future
  # extensions to the regular-expression language.  A backslash may be used
  # prior to a non-alphabetic character regardless of whether that character is
  # part of an unescaped construct.
  # 
  # <p> Backslashes within string literals in Java source code are interpreted
  # as required by the <a
  # href="http://java.sun.com/docs/books/jls">Java Language
  # Specification</a> as either <a
  # href="http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#100850">Unicode
  # escapes</a> or other <a
  # href="http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#101089">character
  # escapes</a>.  It is therefore necessary to double backslashes in string
  # literals that represent regular expressions to protect them from
  # interpretation by the Java bytecode compiler.  The string literal
  # <tt>"&#92;b"</tt>, for example, matches a single backspace character when
  # interpreted as a regular expression, while <tt>"&#92;&#92;b"</tt> matches a
  # word boundary.  The string literal <tt>"&#92;(hello&#92;)"</tt> is illegal
  # and leads to a compile-time error; in order to match the string
  # <tt>(hello)</tt> the string literal <tt>"&#92;&#92;(hello&#92;&#92;)"</tt>
  # must be used.
  # 
  # <a name="cc">
  # <h4> Character Classes </h4>
  # 
  # <p> Character classes may appear within other character classes, and
  # may be composed by the union operator (implicit) and the intersection
  # operator (<tt>&amp;&amp;</tt>).
  # The union operator denotes a class that contains every character that is
  # in at least one of its operand classes.  The intersection operator
  # denotes a class that contains every character that is in both of its
  # operand classes.
  # 
  # <p> The precedence of character-class operators is as follows, from
  # highest to lowest:
  # 
  # <blockquote><table border="0" cellpadding="1" cellspacing="0"
  # summary="Precedence of character class operators.">
  # <tr><th>1&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td>Literal escape&nbsp;&nbsp;&nbsp;&nbsp;</td>
  # <td><tt>\x</tt></td></tr>
  # <tr><th>2&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td>Grouping</td>
  # <td><tt>[...]</tt></td></tr>
  # <tr><th>3&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td>Range</td>
  # <td><tt>a-z</tt></td></tr>
  # <tr><th>4&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td>Union</td>
  # <td><tt>[a-e][i-u]</tt></td></tr>
  # <tr><th>5&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td>Intersection</td>
  # <td><tt>[a-z&&[aeiou]]</tt></td></tr>
  # </table></blockquote>
  # 
  # <p> Note that a different set of metacharacters are in effect inside
  # a character class than outside a character class. For instance, the
  # regular expression <tt>.</tt> loses its special meaning inside a
  # character class, while the expression <tt>-</tt> becomes a range
  # forming metacharacter.
  # 
  # <a name="lt">
  # <h4> Line terminators </h4>
  # 
  # <p> A <i>line terminator</i> is a one- or two-character sequence that marks
  # the end of a line of the input character sequence.  The following are
  # recognized as line terminators:
  # 
  # <ul>
  # 
  # <li> A newline (line feed) character&nbsp;(<tt>'\n'</tt>),
  # 
  # <li> A carriage-return character followed immediately by a newline
  # character&nbsp;(<tt>"\r\n"</tt>),
  # 
  # <li> A standalone carriage-return character&nbsp;(<tt>'\r'</tt>),
  # 
  # <li> A next-line character&nbsp;(<tt>'&#92;u0085'</tt>),
  # 
  # <li> A line-separator character&nbsp;(<tt>'&#92;u2028'</tt>), or
  # 
  # <li> A paragraph-separator character&nbsp;(<tt>'&#92;u2029</tt>).
  # 
  # </ul>
  # <p>If {@link #UNIX_LINES} mode is activated, then the only line terminators
  # recognized are newline characters.
  # 
  # <p> The regular expression <tt>.</tt> matches any character except a line
  # terminator unless the {@link #DOTALL} flag is specified.
  # 
  # <p> By default, the regular expressions <tt>^</tt> and <tt>$</tt> ignore
  # line terminators and only match at the beginning and the end, respectively,
  # of the entire input sequence. If {@link #MULTILINE} mode is activated then
  # <tt>^</tt> matches at the beginning of input and after any line terminator
  # except at the end of input. When in {@link #MULTILINE} mode <tt>$</tt>
  # matches just before a line terminator or the end of the input sequence.
  # 
  # <a name="cg">
  # <h4> Groups and capturing </h4>
  # 
  # <p> Capturing groups are numbered by counting their opening parentheses from
  # left to right.  In the expression <tt>((A)(B(C)))</tt>, for example, there
  # are four such groups: </p>
  # 
  # <blockquote><table cellpadding=1 cellspacing=0 summary="Capturing group numberings">
  # <tr><th>1&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td><tt>((A)(B(C)))</tt></td></tr>
  # <tr><th>2&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td><tt>(A)</tt></td></tr>
  # <tr><th>3&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td><tt>(B(C))</tt></td></tr>
  # <tr><th>4&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td><tt>(C)</tt></td></tr>
  # </table></blockquote>
  # 
  # <p> Group zero always stands for the entire expression.
  # 
  # <p> Capturing groups are so named because, during a match, each subsequence
  # of the input sequence that matches such a group is saved.  The captured
  # subsequence may be used later in the expression, via a back reference, and
  # may also be retrieved from the matcher once the match operation is complete.
  # 
  # <p> The captured input associated with a group is always the subsequence
  # that the group most recently matched.  If a group is evaluated a second time
  # because of quantification then its previously-captured value, if any, will
  # be retained if the second evaluation fails.  Matching the string
  # <tt>"aba"</tt> against the expression <tt>(a(b)?)+</tt>, for example, leaves
  # group two set to <tt>"b"</tt>.  All captured input is discarded at the
  # beginning of each match.
  # 
  # <p> Groups beginning with <tt>(?</tt> are pure, <i>non-capturing</i> groups
  # that do not capture text and do not count towards the group total.
  # 
  # 
  # <h4> Unicode support </h4>
  # 
  # <p> This class is in conformance with Level 1 of <a
  # href="http://www.unicode.org/reports/tr18/"><i>Unicode Technical
  # Standard #18: Unicode Regular Expression Guidelines</i></a>, plus RL2.1
  # Canonical Equivalents.
  # 
  # <p> Unicode escape sequences such as <tt>&#92;u2014</tt> in Java source code
  # are processed as described in <a
  # href="http://java.sun.com/docs/books/jls/third_edition/html/lexical.html#100850">\u00A73.3</a>
  # of the Java Language Specification.  Such escape sequences are also
  # implemented directly by the regular-expression parser so that Unicode
  # escapes can be used in expressions that are read from files or from the
  # keyboard.  Thus the strings <tt>"&#92;u2014"</tt> and <tt>"\\u2014"</tt>,
  # while not equal, compile into the same pattern, which matches the character
  # with hexadecimal value <tt>0x2014</tt>.
  # 
  # <a name="ubc"> <p>Unicode blocks and categories are written with the
  # <tt>\p</tt> and <tt>\P</tt> constructs as in
  # Perl. <tt>\p{</tt><i>prop</i><tt>}</tt> matches if the input has the
  # property <i>prop</i>, while <tt>\P{</tt><i>prop</i><tt>}</tt> does not match if
  # the input has that property.  Blocks are specified with the prefix
  # <tt>In</tt>, as in <tt>InMongolian</tt>.  Categories may be specified with
  # the optional prefix <tt>Is</tt>: Both <tt>\p{L}</tt> and <tt>\p{IsL}</tt>
  # denote the category of Unicode letters.  Blocks and categories can be used
  # both inside and outside of a character class.
  # 
  # <p> The supported categories are those of
  # <a href="http://www.unicode.org/unicode/standard/standard.html">
  # <i>The Unicode Standard</i></a> in the version specified by the
  # {@link java.lang.Character Character} class. The category names are those
  # defined in the Standard, both normative and informative.
  # The block names supported by <code>Pattern</code> are the valid block names
  # accepted and defined by
  # {@link java.lang.Character.UnicodeBlock#forName(String) UnicodeBlock.forName}.
  # 
  # <a name="jcc"> <p>Categories that behave like the java.lang.Character
  # boolean is<i>methodname</i> methods (except for the deprecated ones) are
  # available through the same <tt>\p{</tt><i>prop</i><tt>}</tt> syntax where
  # the specified property has the name <tt>java<i>methodname</i></tt>.
  # 
  # <h4> Comparison to Perl 5 </h4>
  # 
  # <p>The <code>Pattern</code> engine performs traditional NFA-based matching
  # with ordered alternation as occurs in Perl 5.
  # 
  # <p> Perl constructs not supported by this class: </p>
  # 
  # <ul>
  # 
  # <li><p> The conditional constructs <tt>(?{</tt><i>X</i><tt>})</tt> and
  # <tt>(?(</tt><i>condition</i><tt>)</tt><i>X</i><tt>|</tt><i>Y</i><tt>)</tt>,
  # </p></li>
  # 
  # <li><p> The embedded code constructs <tt>(?{</tt><i>code</i><tt>})</tt>
  # and <tt>(??{</tt><i>code</i><tt>})</tt>,</p></li>
  # 
  # <li><p> The embedded comment syntax <tt>(?#comment)</tt>, and </p></li>
  # 
  # <li><p> The preprocessing operations <tt>\l</tt> <tt>&#92;u</tt>,
  # <tt>\L</tt>, and <tt>\U</tt>.  </p></li>
  # 
  # </ul>
  # 
  # <p> Constructs supported by this class but not by Perl: </p>
  # 
  # <ul>
  # 
  # <li><p> Possessive quantifiers, which greedily match as much as they can
  # and do not back off, even when doing so would allow the overall match to
  # succeed.  </p></li>
  # 
  # <li><p> Character-class union and intersection as described
  # <a href="#cc">above</a>.</p></li>
  # 
  # </ul>
  # 
  # <p> Notable differences from Perl: </p>
  # 
  # <ul>
  # 
  # <li><p> In Perl, <tt>\1</tt> through <tt>\9</tt> are always interpreted
  # as back references; a backslash-escaped number greater than <tt>9</tt> is
  # treated as a back reference if at least that many subexpressions exist,
  # otherwise it is interpreted, if possible, as an octal escape.  In this
  # class octal escapes must always begin with a zero. In this class,
  # <tt>\1</tt> through <tt>\9</tt> are always interpreted as back
  # references, and a larger number is accepted as a back reference if at
  # least that many subexpressions exist at that point in the regular
  # expression, otherwise the parser will drop digits until the number is
  # smaller or equal to the existing number of groups or it is one digit.
  # </p></li>
  # 
  # <li><p> Perl uses the <tt>g</tt> flag to request a match that resumes
  # where the last match left off.  This functionality is provided implicitly
  # by the {@link Matcher} class: Repeated invocations of the {@link
  # Matcher#find find} method will resume where the last match left off,
  # unless the matcher is reset.  </p></li>
  # 
  # <li><p> In Perl, embedded flags at the top level of an expression affect
  # the whole expression.  In this class, embedded flags always take effect
  # at the point at which they appear, whether they are at the top level or
  # within a group; in the latter case, flags are restored at the end of the
  # group just as in Perl.  </p></li>
  # 
  # <li><p> Perl is forgiving about malformed matching constructs, as in the
  # expression <tt>*a</tt>, as well as dangling brackets, as in the
  # expression <tt>abc]</tt>, and treats them as literals.  This
  # class also accepts dangling brackets but is strict about dangling
  # metacharacters like +, ? and *, and will throw a
  # {@link PatternSyntaxException} if it encounters them. </p></li>
  # 
  # </ul>
  # 
  # 
  # <p> For a more precise description of the behavior of regular expression
  # constructs, please see <a href="http://www.oreilly.com/catalog/regex3/">
  # <i>Mastering Regular Expressions, 3nd Edition</i>, Jeffrey E. F. Friedl,
  # O'Reilly and Associates, 2006.</a>
  # </p>
  # 
  # @see java.lang.String#split(String, int)
  # @see java.lang.String#split(String)
  # 
  # @author      Mike McCloskey
  # @author      Mark Reinhold
  # @author      JSR-51 Expert Group
  # @since       1.4
  # @spec        JSR-51
  class Pattern 
    include_class_members PatternImports
    include Java::Io::Serializable
    
    class_module.module_eval {
      # Regular expression modifier values.  Instead of being passed as
      # arguments, they can also be passed as inline modifiers.
      # For example, the following statements have the same effect.
      # <pre>
      # RegExp r1 = RegExp.compile("abc", Pattern.I|Pattern.M);
      # RegExp r2 = RegExp.compile("(?im)abc", 0);
      # </pre>
      # 
      # The flags are duplicated so that the familiar Perl match flag
      # names are available.
      # 
      # 
      # Enables Unix lines mode.
      # 
      # <p> In this mode, only the <tt>'\n'</tt> line terminator is recognized
      # in the behavior of <tt>.</tt>, <tt>^</tt>, and <tt>$</tt>.
      # 
      # <p> Unix lines mode can also be enabled via the embedded flag
      # expression&nbsp;<tt>(?d)</tt>.
      const_set_lazy(:UNIX_LINES) { 0x1 }
      const_attr_reader  :UNIX_LINES
      
      # Enables case-insensitive matching.
      # 
      # <p> By default, case-insensitive matching assumes that only characters
      # in the US-ASCII charset are being matched.  Unicode-aware
      # case-insensitive matching can be enabled by specifying the {@link
      # #UNICODE_CASE} flag in conjunction with this flag.
      # 
      # <p> Case-insensitive matching can also be enabled via the embedded flag
      # expression&nbsp;<tt>(?i)</tt>.
      # 
      # <p> Specifying this flag may impose a slight performance penalty.  </p>
      const_set_lazy(:CASE_INSENSITIVE) { 0x2 }
      const_attr_reader  :CASE_INSENSITIVE
      
      # Permits whitespace and comments in pattern.
      # 
      # <p> In this mode, whitespace is ignored, and embedded comments starting
      # with <tt>#</tt> are ignored until the end of a line.
      # 
      # <p> Comments mode can also be enabled via the embedded flag
      # expression&nbsp;<tt>(?x)</tt>.
      const_set_lazy(:COMMENTS) { 0x4 }
      const_attr_reader  :COMMENTS
      
      # Enables multiline mode.
      # 
      # <p> In multiline mode the expressions <tt>^</tt> and <tt>$</tt> match
      # just after or just before, respectively, a line terminator or the end of
      # the input sequence.  By default these expressions only match at the
      # beginning and the end of the entire input sequence.
      # 
      # <p> Multiline mode can also be enabled via the embedded flag
      # expression&nbsp;<tt>(?m)</tt>.  </p>
      const_set_lazy(:MULTILINE) { 0x8 }
      const_attr_reader  :MULTILINE
      
      # Enables literal parsing of the pattern.
      # 
      # <p> When this flag is specified then the input string that specifies
      # the pattern is treated as a sequence of literal characters.
      # Metacharacters or escape sequences in the input sequence will be
      # given no special meaning.
      # 
      # <p>The flags CASE_INSENSITIVE and UNICODE_CASE retain their impact on
      # matching when used in conjunction with this flag. The other flags
      # become superfluous.
      # 
      # <p> There is no embedded flag character for enabling literal parsing.
      # @since 1.5
      const_set_lazy(:LITERAL) { 0x10 }
      const_attr_reader  :LITERAL
      
      # Enables dotall mode.
      # 
      # <p> In dotall mode, the expression <tt>.</tt> matches any character,
      # including a line terminator.  By default this expression does not match
      # line terminators.
      # 
      # <p> Dotall mode can also be enabled via the embedded flag
      # expression&nbsp;<tt>(?s)</tt>.  (The <tt>s</tt> is a mnemonic for
      # "single-line" mode, which is what this is called in Perl.)  </p>
      const_set_lazy(:DOTALL) { 0x20 }
      const_attr_reader  :DOTALL
      
      # Enables Unicode-aware case folding.
      # 
      # <p> When this flag is specified then case-insensitive matching, when
      # enabled by the {@link #CASE_INSENSITIVE} flag, is done in a manner
      # consistent with the Unicode Standard.  By default, case-insensitive
      # matching assumes that only characters in the US-ASCII charset are being
      # matched.
      # 
      # <p> Unicode-aware case folding can also be enabled via the embedded flag
      # expression&nbsp;<tt>(?u)</tt>.
      # 
      # <p> Specifying this flag may impose a performance penalty.  </p>
      const_set_lazy(:UNICODE_CASE) { 0x40 }
      const_attr_reader  :UNICODE_CASE
      
      # Enables canonical equivalence.
      # 
      # <p> When this flag is specified then two characters will be considered
      # to match if, and only if, their full canonical decompositions match.
      # The expression <tt>"a&#92;u030A"</tt>, for example, will match the
      # string <tt>"&#92;u00E5"</tt> when this flag is specified.  By default,
      # matching does not take canonical equivalence into account.
      # 
      # <p> There is no embedded flag character for enabling canonical
      # equivalence.
      # 
      # <p> Specifying this flag may impose a performance penalty.  </p>
      const_set_lazy(:CANON_EQ) { 0x80 }
      const_attr_reader  :CANON_EQ
      
      # Pattern has only two serialized components: The pattern string
      # and the flags, which are all that is needed to recompile the pattern
      # when it is deserialized.
      # 
      # use serialVersionUID from Merlin b59 for interoperability
      const_set_lazy(:SerialVersionUID) { 5073258162644648461 }
      const_attr_reader  :SerialVersionUID
    }
    
    # The original regular-expression pattern string.
    # 
    # @serial
    attr_accessor :pattern
    alias_method :attr_pattern, :pattern
    undef_method :pattern
    alias_method :attr_pattern=, :pattern=
    undef_method :pattern=
    
    # The original pattern flags.
    # 
    # @serial
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    # Boolean indicating this Pattern is compiled; this is necessary in order
    # to lazily compile deserialized Patterns.
    attr_accessor :compiled
    alias_method :attr_compiled, :compiled
    undef_method :compiled
    alias_method :attr_compiled=, :compiled=
    undef_method :compiled=
    
    # The normalized pattern string.
    attr_accessor :normalized_pattern
    alias_method :attr_normalized_pattern, :normalized_pattern
    undef_method :normalized_pattern
    alias_method :attr_normalized_pattern=, :normalized_pattern=
    undef_method :normalized_pattern=
    
    # The starting point of state machine for the find operation.  This allows
    # a match to start anywhere in the input.
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    # The root of object tree for a match operation.  The pattern is matched
    # at the beginning.  This may include a find that uses BnM or a First
    # node.
    attr_accessor :match_root
    alias_method :attr_match_root, :match_root
    undef_method :match_root
    alias_method :attr_match_root=, :match_root=
    undef_method :match_root=
    
    # Temporary storage used by parsing pattern slice.
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    # Temporary storage used while parsing group references.
    attr_accessor :group_nodes
    alias_method :attr_group_nodes, :group_nodes
    undef_method :group_nodes
    alias_method :attr_group_nodes=, :group_nodes=
    undef_method :group_nodes=
    
    # Temporary null terminated code point array used by pattern compiling.
    attr_accessor :temp
    alias_method :attr_temp, :temp
    undef_method :temp
    alias_method :attr_temp=, :temp=
    undef_method :temp=
    
    # The number of capturing groups in this Pattern. Used by matchers to
    # allocate storage needed to perform a match.
    attr_accessor :capturing_group_count
    alias_method :attr_capturing_group_count, :capturing_group_count
    undef_method :capturing_group_count
    alias_method :attr_capturing_group_count=, :capturing_group_count=
    undef_method :capturing_group_count=
    
    # The local variable count used by parsing tree. Used by matchers to
    # allocate storage needed to perform a match.
    attr_accessor :local_count
    alias_method :attr_local_count, :local_count
    undef_method :local_count
    alias_method :attr_local_count=, :local_count=
    undef_method :local_count=
    
    # Index into the pattern string that keeps track of how much has been
    # parsed.
    attr_accessor :cursor
    alias_method :attr_cursor, :cursor
    undef_method :cursor
    alias_method :attr_cursor=, :cursor=
    undef_method :cursor=
    
    # Holds the length of the pattern string.
    attr_accessor :pattern_length
    alias_method :attr_pattern_length, :pattern_length
    undef_method :pattern_length
    alias_method :attr_pattern_length=, :pattern_length=
    undef_method :pattern_length=
    
    class_module.module_eval {
      typesig { [String] }
      # Compiles the given regular expression into a pattern.  </p>
      # 
      # @param  regex
      # The expression to be compiled
      # 
      # @throws  PatternSyntaxException
      # If the expression's syntax is invalid
      def compile(regex)
        return Pattern.new(regex, 0)
      end
      
      typesig { [String, ::Java::Int] }
      # Compiles the given regular expression into a pattern with the given
      # flags.  </p>
      # 
      # @param  regex
      # The expression to be compiled
      # 
      # @param  flags
      # Match flags, a bit mask that may include
      # {@link #CASE_INSENSITIVE}, {@link #MULTILINE}, {@link #DOTALL},
      # {@link #UNICODE_CASE}, {@link #CANON_EQ}, {@link #UNIX_LINES},
      # {@link #LITERAL} and {@link #COMMENTS}
      # 
      # @throws  IllegalArgumentException
      # If bit values other than those corresponding to the defined
      # match flags are set in <tt>flags</tt>
      # 
      # @throws  PatternSyntaxException
      # If the expression's syntax is invalid
      def compile(regex, flags)
        return Pattern.new(regex, flags)
      end
    }
    
    typesig { [] }
    # Returns the regular expression from which this pattern was compiled.
    # </p>
    # 
    # @return  The source of this pattern
    def pattern
      return @pattern
    end
    
    typesig { [] }
    # <p>Returns the string representation of this pattern. This
    # is the regular expression from which this pattern was
    # compiled.</p>
    # 
    # @return  The string representation of this pattern
    # @since 1.5
    def to_s
      return @pattern
    end
    
    typesig { [CharSequence] }
    # Creates a matcher that will match the given input against this pattern.
    # </p>
    # 
    # @param  input
    # The character sequence to be matched
    # 
    # @return  A new matcher for this pattern
    def matcher(input)
      if (!@compiled)
        synchronized((self)) do
          if (!@compiled)
            compile
          end
        end
      end
      m = Matcher.new(self, input)
      return m
    end
    
    typesig { [] }
    # Returns this pattern's match flags.  </p>
    # 
    # @return  The match flags specified when this pattern was compiled
    def flags
      return @flags
    end
    
    class_module.module_eval {
      typesig { [String, CharSequence] }
      # Compiles the given regular expression and attempts to match the given
      # input against it.
      # 
      # <p> An invocation of this convenience method of the form
      # 
      # <blockquote><pre>
      # Pattern.matches(regex, input);</pre></blockquote>
      # 
      # behaves in exactly the same way as the expression
      # 
      # <blockquote><pre>
      # Pattern.compile(regex).matcher(input).matches()</pre></blockquote>
      # 
      # <p> If a pattern is to be used multiple times, compiling it once and reusing
      # it will be more efficient than invoking this method each time.  </p>
      # 
      # @param  regex
      # The expression to be compiled
      # 
      # @param  input
      # The character sequence to be matched
      # 
      # @throws  PatternSyntaxException
      # If the expression's syntax is invalid
      def matches(regex, input)
        p = Pattern.compile(regex)
        m = p.matcher(input)
        return m.matches
      end
    }
    
    typesig { [CharSequence, ::Java::Int] }
    # Splits the given input sequence around matches of this pattern.
    # 
    # <p> The array returned by this method contains each substring of the
    # input sequence that is terminated by another subsequence that matches
    # this pattern or is terminated by the end of the input sequence.  The
    # substrings in the array are in the order in which they occur in the
    # input.  If this pattern does not match any subsequence of the input then
    # the resulting array has just one element, namely the input sequence in
    # string form.
    # 
    # <p> The <tt>limit</tt> parameter controls the number of times the
    # pattern is applied and therefore affects the length of the resulting
    # array.  If the limit <i>n</i> is greater than zero then the pattern
    # will be applied at most <i>n</i>&nbsp;-&nbsp;1 times, the array's
    # length will be no greater than <i>n</i>, and the array's last entry
    # will contain all input beyond the last matched delimiter.  If <i>n</i>
    # is non-positive then the pattern will be applied as many times as
    # possible and the array can have any length.  If <i>n</i> is zero then
    # the pattern will be applied as many times as possible, the array can
    # have any length, and trailing empty strings will be discarded.
    # 
    # <p> The input <tt>"boo:and:foo"</tt>, for example, yields the following
    # results with these parameters:
    # 
    # <blockquote><table cellpadding=1 cellspacing=0
    # summary="Split examples showing regex, limit, and result">
    # <tr><th><P align="left"><i>Regex&nbsp;&nbsp;&nbsp;&nbsp;</i></th>
    # <th><P align="left"><i>Limit&nbsp;&nbsp;&nbsp;&nbsp;</i></th>
    # <th><P align="left"><i>Result&nbsp;&nbsp;&nbsp;&nbsp;</i></th></tr>
    # <tr><td align=center>:</td>
    # <td align=center>2</td>
    # <td><tt>{ "boo", "and:foo" }</tt></td></tr>
    # <tr><td align=center>:</td>
    # <td align=center>5</td>
    # <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
    # <tr><td align=center>:</td>
    # <td align=center>-2</td>
    # <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
    # <tr><td align=center>o</td>
    # <td align=center>5</td>
    # <td><tt>{ "b", "", ":and:f", "", "" }</tt></td></tr>
    # <tr><td align=center>o</td>
    # <td align=center>-2</td>
    # <td><tt>{ "b", "", ":and:f", "", "" }</tt></td></tr>
    # <tr><td align=center>o</td>
    # <td align=center>0</td>
    # <td><tt>{ "b", "", ":and:f" }</tt></td></tr>
    # </table></blockquote>
    # 
    # 
    # @param  input
    # The character sequence to be split
    # 
    # @param  limit
    # The result threshold, as described above
    # 
    # @return  The array of strings computed by splitting the input
    # around matches of this pattern
    def split(input, limit)
      index = 0
      match_limited = limit > 0
      match_list = ArrayList.new
      m = matcher(input)
      # Add segments before each match found
      while (m.find)
        if (!match_limited || match_list.size < limit - 1)
          match = input.sub_sequence(index, m.start).to_s
          match_list.add(match)
          index = m.end_
        else
          if ((match_list.size).equal?(limit - 1))
            # last one
            match = input.sub_sequence(index, input.length).to_s
            match_list.add(match)
            index = m.end_
          end
        end
      end
      # If no match was found, return this
      if ((index).equal?(0))
        return Array.typed(String).new([input.to_s])
      end
      # Add remaining segment
      if (!match_limited || match_list.size < limit)
        match_list.add(input.sub_sequence(index, input.length).to_s)
      end
      # Construct result
      result_size = match_list.size
      if ((limit).equal?(0))
        while (result_size > 0 && (match_list.get(result_size - 1) == ""))
          result_size -= 1
        end
      end
      result = Array.typed(String).new(result_size) { nil }
      return match_list.sub_list(0, result_size).to_array(result)
    end
    
    typesig { [CharSequence] }
    # Splits the given input sequence around matches of this pattern.
    # 
    # <p> This method works as if by invoking the two-argument {@link
    # #split(java.lang.CharSequence, int) split} method with the given input
    # sequence and a limit argument of zero.  Trailing empty strings are
    # therefore not included in the resulting array. </p>
    # 
    # <p> The input <tt>"boo:and:foo"</tt>, for example, yields the following
    # results with these expressions:
    # 
    # <blockquote><table cellpadding=1 cellspacing=0
    # summary="Split examples showing regex and result">
    # <tr><th><P align="left"><i>Regex&nbsp;&nbsp;&nbsp;&nbsp;</i></th>
    # <th><P align="left"><i>Result</i></th></tr>
    # <tr><td align=center>:</td>
    # <td><tt>{ "boo", "and", "foo" }</tt></td></tr>
    # <tr><td align=center>o</td>
    # <td><tt>{ "b", "", ":and:f" }</tt></td></tr>
    # </table></blockquote>
    # 
    # 
    # @param  input
    # The character sequence to be split
    # 
    # @return  The array of strings computed by splitting the input
    # around matches of this pattern
    def split(input)
      return split(input, 0)
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns a literal pattern <code>String</code> for the specified
      # <code>String</code>.
      # 
      # <p>This method produces a <code>String</code> that can be used to
      # create a <code>Pattern</code> that would match the string
      # <code>s</code> as if it were a literal pattern.</p> Metacharacters
      # or escape sequences in the input sequence will be given no special
      # meaning.
      # 
      # @param  s The string to be literalized
      # @return  A literal string replacement
      # @since 1.5
      def quote(s)
        slash_eindex = s.index_of("\\E")
        if ((slash_eindex).equal?(-1))
          return "\\Q" + s + "\\E"
        end
        sb = StringBuilder.new(s.length * 2)
        sb.append("\\Q")
        slash_eindex = 0
        current = 0
        while (!((slash_eindex = s.index_of("\\E", current))).equal?(-1))
          sb.append(s.substring(current, slash_eindex))
          current = slash_eindex + 2
          sb.append("\\E\\\\E\\Q")
        end
        sb.append(s.substring(current, s.length))
        sb.append("\\E")
        return sb.to_s
      end
    }
    
    typesig { [Java::Io::ObjectInputStream] }
    # Recompile the Pattern instance from a stream.  The original pattern
    # string is read in and the object tree is recompiled from it.
    def read_object(s)
      # Read in all fields
      s.default_read_object
      # Initialize counts
      @capturing_group_count = 1
      @local_count = 0
      # if length > 0, the Pattern is lazily compiled
      @compiled = false
      if ((@pattern.length).equal?(0))
        @root = Start.new(self.attr_last_accept)
        @match_root = self.attr_last_accept
        @compiled = true
      end
    end
    
    typesig { [String, ::Java::Int] }
    # This private constructor is used to create all Patterns. The pattern
    # string and match flags are all that is needed to completely describe
    # a Pattern. An empty pattern string results in an object tree with
    # only a Start node and a LastNode node.
    def initialize(p, f)
      @pattern = nil
      @flags = 0
      @compiled = false
      @normalized_pattern = nil
      @root = nil
      @match_root = nil
      @buffer = nil
      @group_nodes = nil
      @temp = nil
      @capturing_group_count = 0
      @local_count = 0
      @cursor = 0
      @pattern_length = 0
      @pattern = p
      @flags = f
      # Reset group index count
      @capturing_group_count = 1
      @local_count = 0
      if (@pattern.length > 0)
        compile
      else
        @root = Start.new(self.attr_last_accept)
        @match_root = self.attr_last_accept
      end
    end
    
    typesig { [] }
    # The pattern is converted to normalizedD form and then a pure group
    # is constructed to match canonical equivalences of the characters.
    def normalize
      in_char_class = false
      last_code_point = -1
      # Convert pattern into normalizedD form
      @normalized_pattern = RJava.cast_to_string(Normalizer.normalize(@pattern, Normalizer::Form::NFD))
      @pattern_length = @normalized_pattern.length
      # Modify pattern to match canonical equivalences
      new_pattern = StringBuilder.new(@pattern_length)
      i = 0
      while i < @pattern_length
        c = @normalized_pattern.code_point_at(i)
        sequence_buffer = nil
        if (((Character.get_type(c)).equal?(Character::NON_SPACING_MARK)) && (!(last_code_point).equal?(-1)))
          sequence_buffer = StringBuilder.new
          sequence_buffer.append_code_point(last_code_point)
          sequence_buffer.append_code_point(c)
          while ((Character.get_type(c)).equal?(Character::NON_SPACING_MARK))
            i += Character.char_count(c)
            if (i >= @pattern_length)
              break
            end
            c = @normalized_pattern.code_point_at(i)
            sequence_buffer.append_code_point(c)
          end
          ea = produce_equivalent_alternation(sequence_buffer.to_s)
          new_pattern.set_length(new_pattern.length - Character.char_count(last_code_point))
          new_pattern.append("(?:").append(ea).append(")")
        else
          if ((c).equal?(Character.new(?[.ord)) && !(last_code_point).equal?(Character.new(?\\.ord)))
            i = normalize_char_class(new_pattern, i)
          else
            new_pattern.append_code_point(c)
          end
        end
        last_code_point = c
        i += Character.char_count(c)
      end
      @normalized_pattern = RJava.cast_to_string(new_pattern.to_s)
    end
    
    typesig { [StringBuilder, ::Java::Int] }
    # Complete the character class being parsed and add a set
    # of alternations to it that will match the canonical equivalences
    # of the characters within the class.
    def normalize_char_class(new_pattern, i)
      char_class = StringBuilder.new
      eq = nil
      last_code_point = -1
      result = nil
      i += 1
      char_class.append("[")
      while (true)
        c = @normalized_pattern.code_point_at(i)
        sequence_buffer = nil
        if ((c).equal?(Character.new(?].ord)) && !(last_code_point).equal?(Character.new(?\\.ord)))
          char_class.append(RJava.cast_to_char(c))
          break
        else
          if ((Character.get_type(c)).equal?(Character::NON_SPACING_MARK))
            sequence_buffer = StringBuilder.new
            sequence_buffer.append_code_point(last_code_point)
            while ((Character.get_type(c)).equal?(Character::NON_SPACING_MARK))
              sequence_buffer.append_code_point(c)
              i += Character.char_count(c)
              if (i >= @normalized_pattern.length)
                break
              end
              c = @normalized_pattern.code_point_at(i)
            end
            ea = produce_equivalent_alternation(sequence_buffer.to_s)
            char_class.set_length(char_class.length - Character.char_count(last_code_point))
            if ((eq).nil?)
              eq = StringBuilder.new
            end
            eq.append(Character.new(?|.ord))
            eq.append(ea)
          else
            char_class.append_code_point(c)
            i += 1
          end
        end
        if ((i).equal?(@normalized_pattern.length))
          raise error("Unclosed character class")
        end
        last_code_point = c
      end
      if (!(eq).nil?)
        result = "(?:" + RJava.cast_to_string(char_class.to_s) + RJava.cast_to_string(eq.to_s) + ")"
      else
        result = RJava.cast_to_string(char_class.to_s)
      end
      new_pattern.append(result)
      return i
    end
    
    typesig { [String] }
    # Given a specific sequence composed of a regular character and
    # combining marks that follow it, produce the alternation that will
    # match all canonical equivalences of that sequence.
    def produce_equivalent_alternation(source)
      len = count_chars(source, 0, 1)
      if ((source.length).equal?(len))
        # source has one character.
        return source
      end
      base = source.substring(0, len)
      combining_marks = source.substring(len)
      perms = produce_permutations(combining_marks)
      result = StringBuilder.new(source)
      # Add combined permutations
      x = 0
      while x < perms.attr_length
        next_ = base + RJava.cast_to_string(perms[x])
        if (x > 0)
          result.append("|" + next_)
        end
        next_ = RJava.cast_to_string(compose_one_step(next_))
        if (!(next_).nil?)
          result.append("|" + RJava.cast_to_string(produce_equivalent_alternation(next_)))
        end
        x += 1
      end
      return result.to_s
    end
    
    typesig { [String] }
    # Returns an array of strings that have all the possible
    # permutations of the characters in the input string.
    # This is used to get a list of all possible orderings
    # of a set of combining marks. Note that some of the permutations
    # are invalid because of combining class collisions, and these
    # possibilities must be removed because they are not canonically
    # equivalent.
    def produce_permutations(input)
      if ((input.length).equal?(count_chars(input, 0, 1)))
        return Array.typed(String).new([input])
      end
      if ((input.length).equal?(count_chars(input, 0, 2)))
        c0 = Character.code_point_at(input, 0)
        c1 = Character.code_point_at(input, Character.char_count(c0))
        if ((get_class(c1)).equal?(get_class(c0)))
          return Array.typed(String).new([input])
        end
        result = Array.typed(String).new(2) { nil }
        result[0] = input
        sb = StringBuilder.new(2)
        sb.append_code_point(c1)
        sb.append_code_point(c0)
        result[1] = sb.to_s
        return result
      end
      length_ = 1
      n_code_points = count_code_points(input)
      x = 1
      while x < n_code_points
        length_ = length_ * (x + 1)
        x += 1
      end
      temp = Array.typed(String).new(length_) { nil }
      comb_class = Array.typed(::Java::Int).new(n_code_points) { 0 }
      x_ = 0
      i = 0
      while x_ < n_code_points
        c = Character.code_point_at(input, i)
        comb_class[x_] = get_class(c)
        i += Character.char_count(c)
        x_ += 1
      end
      # For each char, take it out and add the permutations
      # of the remaining chars
      index = 0
      len = 0
      # offset maintains the index in code units.
      x__ = 0
      offset = 0
      while x__ < n_code_points
        catch(:next_loop) do
          len = count_chars(input, offset, 1)
          skip = false
          y = x__ - 1
          while y >= 0
            if ((comb_class[y]).equal?(comb_class[x__]))
              throw :next_loop, :thrown
            end
            y -= 1
          end
          sb = StringBuilder.new(input)
          other_chars = sb.delete(offset, offset + len).to_s
          sub_result = produce_permutations(other_chars)
          prefix = input.substring(offset, offset + len)
          y_ = 0
          while y_ < sub_result.attr_length
            temp[((index += 1) - 1)] = prefix + RJava.cast_to_string(sub_result[y_])
            y_ += 1
          end
        end
        x__ += 1
        offset += len
      end
      result = Array.typed(String).new(index) { nil }
      x___ = 0
      while x___ < index
        result[x___] = temp[x___]
        x___ += 1
      end
      return result
    end
    
    typesig { [::Java::Int] }
    def get_class(c)
      return Sun::Text::Normalizer.get_combining_class(c)
    end
    
    typesig { [String] }
    # Attempts to compose input by combining the first character
    # with the first combining mark following it. Returns a String
    # that is the composition of the leading character with its first
    # combining mark followed by the remaining combining marks. Returns
    # null if the first two characters cannot be further composed.
    def compose_one_step(input)
      len = count_chars(input, 0, 2)
      first_two_characters = input.substring(0, len)
      result = Normalizer.normalize(first_two_characters, Normalizer::Form::NFC)
      if ((result == first_two_characters))
        return nil
      else
        remainder = input.substring(len)
        return result + remainder
      end
    end
    
    typesig { [] }
    # Preprocess any \Q...\E sequences in `temp', meta-quoting them.
    # See the description of `quotemeta' in perlfunc(1).
    def _remove_qequoting
      p_len = @pattern_length
      i = 0
      while (i < p_len - 1)
        if (!(@temp[i]).equal?(Character.new(?\\.ord)))
          i += 1
        else
          if (!(@temp[i + 1]).equal?(Character.new(?Q.ord)))
            i += 2
          else
            break
          end
        end
      end
      if (i >= p_len - 1)
        # No \Q sequence found
        return
      end
      j = i
      i += 2
      newtemp = Array.typed(::Java::Int).new(j + 2 * (p_len - i) + 2) { 0 }
      System.arraycopy(@temp, 0, newtemp, 0, j)
      in_quote = true
      while (i < p_len)
        c = @temp[((i += 1) - 1)]
        if (!ASCII.is_ascii(c) || ASCII.is_alnum(c))
          newtemp[((j += 1) - 1)] = c
        else
          if (!(c).equal?(Character.new(?\\.ord)))
            if (in_quote)
              newtemp[((j += 1) - 1)] = Character.new(?\\.ord)
            end
            newtemp[((j += 1) - 1)] = c
          else
            if (in_quote)
              if ((@temp[i]).equal?(Character.new(?E.ord)))
                i += 1
                in_quote = false
              else
                newtemp[((j += 1) - 1)] = Character.new(?\\.ord)
                newtemp[((j += 1) - 1)] = Character.new(?\\.ord)
              end
            else
              if ((@temp[i]).equal?(Character.new(?Q.ord)))
                i += 1
                in_quote = true
              else
                newtemp[((j += 1) - 1)] = c
                if (!(i).equal?(p_len))
                  newtemp[((j += 1) - 1)] = @temp[((i += 1) - 1)]
                end
              end
            end
          end
        end
      end
      @pattern_length = j
      @temp = Arrays.copy_of(newtemp, j + 2) # double zero termination
    end
    
    typesig { [] }
    # Copies regular expression to an int array and invokes the parsing
    # of the expression which will create the object tree.
    def compile
      # Handle canonical equivalences
      if (has(CANON_EQ) && !has(LITERAL))
        normalize
      else
        @normalized_pattern = @pattern
      end
      @pattern_length = @normalized_pattern.length
      # Copy pattern to int array for convenience
      # Use double zero to terminate pattern
      @temp = Array.typed(::Java::Int).new(@pattern_length + 2) { 0 }
      has_supplementary = false
      c = 0
      count = 0
      # Convert all chars into code points
      x = 0
      while x < @pattern_length
        c = @normalized_pattern.code_point_at(x)
        if (is_supplementary(c))
          has_supplementary = true
        end
        @temp[((count += 1) - 1)] = c
        x += Character.char_count(c)
      end
      @pattern_length = count # patternLength now in code points
      if (!has(LITERAL))
        _remove_qequoting
      end
      # Allocate all temporary objects here.
      @buffer = Array.typed(::Java::Int).new(32) { 0 }
      @group_nodes = Array.typed(GroupHead).new(10) { nil }
      if (has(LITERAL))
        # Literal pattern handling
        @match_root = new_slice(@temp, @pattern_length, has_supplementary)
        @match_root.attr_next = self.attr_last_accept
      else
        # Start recursive descent parsing
        @match_root = expr(self.attr_last_accept)
        # Check extra pattern characters
        if (!(@pattern_length).equal?(@cursor))
          if ((peek).equal?(Character.new(?).ord)))
            raise error("Unmatched closing ')'")
          else
            raise error("Unexpected internal error")
          end
        end
      end
      # Peephole optimization
      if (@match_root.is_a?(Slice))
        @root = BnM.optimize(@match_root)
        if ((@root).equal?(@match_root))
          @root = has_supplementary ? StartS.new(@match_root) : Start.new(@match_root)
        end
      else
        if (@match_root.is_a?(Begin) || @match_root.is_a?(First))
          @root = @match_root
        else
          @root = has_supplementary ? StartS.new(@match_root) : Start.new(@match_root)
        end
      end
      # Release temporary storage
      @temp = nil
      @buffer = nil
      @group_nodes = nil
      @pattern_length = 0
      @compiled = true
    end
    
    class_module.module_eval {
      typesig { [Node] }
      # Used to print out a subtree of the Pattern to help with debugging.
      def print_object_tree(node)
        while (!(node).nil?)
          if (node.is_a?(Prolog))
            System.out.println(node)
            print_object_tree((node).attr_loop)
            System.out.println("**** end contents prolog loop")
          else
            if (node.is_a?(Loop))
              System.out.println(node)
              print_object_tree((node).attr_body)
              System.out.println("**** end contents Loop body")
            else
              if (node.is_a?(Curly))
                System.out.println(node)
                print_object_tree((node).attr_atom)
                System.out.println("**** end contents Curly body")
              else
                if (node.is_a?(GroupCurly))
                  System.out.println(node)
                  print_object_tree((node).attr_atom)
                  System.out.println("**** end contents GroupCurly body")
                else
                  if (node.is_a?(GroupTail))
                    System.out.println(node)
                    System.out.println("Tail next is " + RJava.cast_to_string(node.attr_next))
                    return
                  else
                    System.out.println(node)
                  end
                end
              end
            end
          end
          node = node.attr_next
          if (!(node).nil?)
            System.out.println("->next:")
          end
          if ((node).equal?(self.attr_accept))
            System.out.println("Accept Node")
            node = nil
          end
        end
      end
      
      # Used to accumulate information about a subtree of the object graph
      # so that optimizations can be applied to the subtree.
      const_set_lazy(:TreeInfo) { Class.new do
        include_class_members Pattern
        
        attr_accessor :min_length
        alias_method :attr_min_length, :min_length
        undef_method :min_length
        alias_method :attr_min_length=, :min_length=
        undef_method :min_length=
        
        attr_accessor :max_length
        alias_method :attr_max_length, :max_length
        undef_method :max_length
        alias_method :attr_max_length=, :max_length=
        undef_method :max_length=
        
        attr_accessor :max_valid
        alias_method :attr_max_valid, :max_valid
        undef_method :max_valid
        alias_method :attr_max_valid=, :max_valid=
        undef_method :max_valid=
        
        attr_accessor :deterministic
        alias_method :attr_deterministic, :deterministic
        undef_method :deterministic
        alias_method :attr_deterministic=, :deterministic=
        undef_method :deterministic=
        
        typesig { [] }
        def initialize
          @min_length = 0
          @max_length = 0
          @max_valid = false
          @deterministic = false
          reset
        end
        
        typesig { [] }
        def reset
          @min_length = 0
          @max_length = 0
          @max_valid = true
          @deterministic = true
        end
        
        private
        alias_method :initialize__tree_info, :initialize
      end }
    }
    
    typesig { [::Java::Int] }
    # The following private methods are mainly used to improve the
    # readability of the code. In order to let the Java compiler easily
    # inline them, we should not put many assertions or error checks in them.
    # 
    # 
    # Indicates whether a particular flag is set or not.
    def has(f)
      return !((@flags & f)).equal?(0)
    end
    
    typesig { [::Java::Int, String] }
    # Match next character, signal error if failed.
    def accept(ch, s)
      test_char = @temp[((@cursor += 1) - 1)]
      if (has(COMMENTS))
        test_char = parse_past_whitespace(test_char)
      end
      if (!(ch).equal?(test_char))
        raise error(s)
      end
    end
    
    typesig { [::Java::Int] }
    # Mark the end of pattern with a specific character.
    def mark(c)
      @temp[@pattern_length] = c
    end
    
    typesig { [] }
    # Peek the next character, and do not advance the cursor.
    def peek
      ch = @temp[@cursor]
      if (has(COMMENTS))
        ch = peek_past_whitespace(ch)
      end
      return ch
    end
    
    typesig { [] }
    # Read the next character, and advance the cursor by one.
    def read
      ch = @temp[((@cursor += 1) - 1)]
      if (has(COMMENTS))
        ch = parse_past_whitespace(ch)
      end
      return ch
    end
    
    typesig { [] }
    # Read the next character, and advance the cursor by one,
    # ignoring the COMMENTS setting
    def read_escaped
      ch = @temp[((@cursor += 1) - 1)]
      return ch
    end
    
    typesig { [] }
    # Advance the cursor by one, and peek the next character.
    def next_
      ch = @temp[(@cursor += 1)]
      if (has(COMMENTS))
        ch = peek_past_whitespace(ch)
      end
      return ch
    end
    
    typesig { [] }
    # Advance the cursor by one, and peek the next character,
    # ignoring the COMMENTS setting
    def next_escaped
      ch = @temp[(@cursor += 1)]
      return ch
    end
    
    typesig { [::Java::Int] }
    # If in xmode peek past whitespace and comments.
    def peek_past_whitespace(ch)
      while (ASCII.is_space(ch) || (ch).equal?(Character.new(?#.ord)))
        while (ASCII.is_space(ch))
          ch = @temp[(@cursor += 1)]
        end
        if ((ch).equal?(Character.new(?#.ord)))
          ch = peek_past_line
        end
      end
      return ch
    end
    
    typesig { [::Java::Int] }
    # If in xmode parse past whitespace and comments.
    def parse_past_whitespace(ch)
      while (ASCII.is_space(ch) || (ch).equal?(Character.new(?#.ord)))
        while (ASCII.is_space(ch))
          ch = @temp[((@cursor += 1) - 1)]
        end
        if ((ch).equal?(Character.new(?#.ord)))
          ch = parse_past_line
        end
      end
      return ch
    end
    
    typesig { [] }
    # xmode parse past comment to end of line.
    def parse_past_line
      ch = @temp[((@cursor += 1) - 1)]
      while (!(ch).equal?(0) && !is_line_separator(ch))
        ch = @temp[((@cursor += 1) - 1)]
      end
      return ch
    end
    
    typesig { [] }
    # xmode peek past comment to end of line.
    def peek_past_line
      ch = @temp[(@cursor += 1)]
      while (!(ch).equal?(0) && !is_line_separator(ch))
        ch = @temp[(@cursor += 1)]
      end
      return ch
    end
    
    typesig { [::Java::Int] }
    # Determines if character is a line separator in the current mode
    def is_line_separator(ch)
      if (has(UNIX_LINES))
        return (ch).equal?(Character.new(?\n.ord))
      else
        return ((ch).equal?(Character.new(?\n.ord)) || (ch).equal?(Character.new(?\r.ord)) || ((ch | 1)).equal?(Character.new(0x2029)) || (ch).equal?(Character.new(0x0085)))
      end
    end
    
    typesig { [] }
    # Read the character after the next one, and advance the cursor by two.
    def skip
      i = @cursor
      ch = @temp[i + 1]
      @cursor = i + 2
      return ch
    end
    
    typesig { [] }
    # Unread one next character, and retreat cursor by one.
    def unread
      @cursor -= 1
    end
    
    typesig { [String] }
    # Internal method used for handling all syntax errors. The pattern is
    # displayed with a pointer to aid in locating the syntax error.
    def error(s)
      return PatternSyntaxException.new(s, @normalized_pattern, @cursor - 1)
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    # Determines if there is any supplementary character or unpaired
    # surrogate in the specified range.
    def find_supplementary(start_, end__)
      i = start_
      while i < end__
        if (is_supplementary(@temp[i]))
          return true
        end
        i += 1
      end
      return false
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Determines if the specified code point is a supplementary
      # character or unpaired surrogate.
      def is_supplementary(ch)
        return ch >= Character::MIN_SUPPLEMENTARY_CODE_POINT || is_surrogate(ch)
      end
    }
    
    typesig { [Node] }
    # The following methods handle the main parsing. They are sorted
    # according to their precedence order, the lowest one first.
    # 
    # 
    # The expression is parsed with branch nodes added for alternations.
    # This may be called recursively to parse sub expressions that may
    # contain alternations.
    def expr(end__)
      prev = nil
      first_tail = nil
      branch_conn = nil
      loop do
        node = sequence(end__)
        node_tail = @root # double return
        if ((prev).nil?)
          prev = node
          first_tail = node_tail
        else
          # Branch
          if ((branch_conn).nil?)
            branch_conn = BranchConn.new
            branch_conn.attr_next = end__
          end
          if ((node).equal?(end__))
            # if the node returned from sequence() is "end"
            # we have an empty expr, set a null atom into
            # the branch to indicate to go "next" directly.
            node = nil
          else
            # the "tail.next" of each atom goes to branchConn
            node_tail.attr_next = branch_conn
          end
          if (prev.is_a?(Branch))
            (prev).add(node)
          else
            if ((prev).equal?(end__))
              prev = nil
            else
              # replace the "end" with "branchConn" at its tail.next
              # when put the "prev" into the branch as the first atom.
              first_tail.attr_next = branch_conn
            end
            prev = Branch.new(prev, node, branch_conn)
          end
        end
        if (!(peek).equal?(Character.new(?|.ord)))
          return prev
        end
        next_
      end
    end
    
    typesig { [Node] }
    # Parsing of sequences between alternations.
    def sequence(end__)
      head = nil
      tail = nil
      node = nil
      loop do
        ch = peek
        case (ch)
        # Now interpreting dangling ] and } as literals
        # Fall through
        when Character.new(?(.ord)
          # Because group handles its own closure,
          # we need to treat it differently
          node = group0
          # Check for comment or flag group
          if ((node).nil?)
            next
          end
          if ((head).nil?)
            head = node
          else
            tail.attr_next = node
          end
          # Double return: Tail was returned in root
          tail = @root
          next
          node = clazz(true)
        when Character.new(?[.ord)
          node = clazz(true)
        when Character.new(?\\.ord)
          ch = next_escaped
          if ((ch).equal?(Character.new(?p.ord)) || (ch).equal?(Character.new(?P.ord)))
            one_letter = true
            comp = ((ch).equal?(Character.new(?P.ord)))
            ch = next_ # Consume { if present
            if (!(ch).equal?(Character.new(?{.ord)))
              unread
            else
              one_letter = false
            end
            node = family(one_letter).maybe_complement(comp)
          else
            unread
            node = atom
          end
        when Character.new(?^.ord)
          next_
          if (has(MULTILINE))
            if (has(UNIX_LINES))
              node = UnixCaret.new
            else
              node = Caret.new
            end
          else
            node = Begin.new
          end
        when Character.new(?$.ord)
          next_
          if (has(UNIX_LINES))
            node = UnixDollar.new(has(MULTILINE))
          else
            node = Dollar.new(has(MULTILINE))
          end
        when Character.new(?..ord)
          next_
          if (has(DOTALL))
            node = All.new
          else
            if (has(UNIX_LINES))
              node = UnixDot.new
            else
              node = Dot.new
            end
          end
        when Character.new(?|.ord), Character.new(?).ord)
          break
        when Character.new(?].ord), Character.new(?}.ord)
          node = atom
        when Character.new(??.ord), Character.new(?*.ord), Character.new(?+.ord)
          next_
          raise error("Dangling meta character '" + RJava.cast_to_string((RJava.cast_to_char(ch))) + "'")
        when 0
          if (@cursor >= @pattern_length)
            break
          end
        else
          node = atom
        end
        node = closure(node)
        if ((head).nil?)
          head = tail = node
        else
          tail.attr_next = node
          tail = node
        end
      end
      if ((head).nil?)
        return end__
      end
      tail.attr_next = end__
      @root = tail # double return
      return head
    end
    
    typesig { [] }
    # Parse and add a new Single or Slice.
    def atom
      first = 0
      prev = -1
      has_supplementary = false
      ch = peek
      loop do
        catch(:break_case) do
          case (ch)
          # Fall through
          when Character.new(?*.ord), Character.new(?+.ord), Character.new(??.ord), Character.new(?{.ord)
            if (first > 1)
              @cursor = prev # Unwind one character
              first -= 1
            end
          when Character.new(?$.ord), Character.new(?..ord), Character.new(?^.ord), Character.new(?(.ord), Character.new(?[.ord), Character.new(?|.ord), Character.new(?).ord)
          when Character.new(?\\.ord)
            ch = next_escaped
            if ((ch).equal?(Character.new(?p.ord)) || (ch).equal?(Character.new(?P.ord)))
              # Property
              if (first > 0)
                # Slice is waiting; handle it first
                unread
                throw :break_case, :thrown
              else
                # No slice; just return the family node
                comp = ((ch).equal?(Character.new(?P.ord)))
                one_letter = true
                ch = next_ # Consume { if present
                if (!(ch).equal?(Character.new(?{.ord)))
                  unread
                else
                  one_letter = false
                end
                return family(one_letter).maybe_complement(comp)
              end
            end
            unread
            prev = @cursor
            ch = escape(false, (first).equal?(0))
            if (ch >= 0)
              append(ch, first)
              first += 1
              if (is_supplementary(ch))
                has_supplementary = true
              end
              ch = peek
              next
            else
              if ((first).equal?(0))
                return @root
              end
            end
            # Unwind meta escape sequence
            @cursor = prev
          when 0
            if (@cursor >= @pattern_length)
            end
          else
            prev = @cursor
            append(ch, first)
            first += 1
            if (is_supplementary(ch))
              has_supplementary = true
            end
            ch = next_
            next
          end
        end == :thrown or break
        break
      end
      if ((first).equal?(1))
        return new_single(@buffer[0])
      else
        return new_slice(@buffer, first, has_supplementary)
      end
    end
    
    typesig { [::Java::Int, ::Java::Int] }
    def append(ch, len)
      if (len >= @buffer.attr_length)
        tmp = Array.typed(::Java::Int).new(len + len) { 0 }
        System.arraycopy(@buffer, 0, tmp, 0, len)
        @buffer = tmp
      end
      @buffer[len] = ch
    end
    
    typesig { [::Java::Int] }
    # Parses a backref greedily, taking as many numbers as it
    # can. The first digit is always treated as a backref, but
    # multi digit numbers are only treated as a backref if at
    # least that many backrefs exist at this point in the regex.
    def ref(ref_num)
      done = false
      while (!done)
        ch = peek
        catch(:break_case) do
          case (ch)
          when Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord)
            new_ref_num = (ref_num * 10) + (ch - Character.new(?0.ord))
            # Add another number if it doesn't make a group
            # that doesn't exist
            if (@capturing_group_count - 1 < new_ref_num)
              done = true
              throw :break_case, :thrown
            end
            ref_num = new_ref_num
            read
          else
            done = true
          end
        end == :thrown or break
      end
      if (has(CASE_INSENSITIVE))
        return CIBackRef.new(ref_num, has(UNICODE_CASE))
      else
        return BackRef.new(ref_num)
      end
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # Parses an escape sequence to determine the actual value that needs
    # to be matched.
    # If -1 is returned and create was true a new object was added to the tree
    # to handle the escape sequence.
    # If the returned value is greater than zero, it is the value that
    # matches the escape sequence.
    def escape(inclass, create)
      ch = skip
      catch(:break_case) do
        case (ch)
        when Character.new(?0.ord)
          return o
        when Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord)
          if (inclass)
            throw :break_case, :thrown
          end
          if (create)
            @root = ref((ch - Character.new(?0.ord)))
          end
          return -1
        when Character.new(?A.ord)
          if (inclass)
            throw :break_case, :thrown
          end
          if (create)
            @root = Begin.new
          end
          return -1
        when Character.new(?B.ord)
          if (inclass)
            throw :break_case, :thrown
          end
          if (create)
            @root = Bound.new(Bound::NONE)
          end
          return -1
        when Character.new(?C.ord)
        when Character.new(?D.ord)
          if (create)
            @root = Ctype.new(ASCII::DIGIT).complement
          end
          return -1
        when Character.new(?E.ord), Character.new(?F.ord)
        when Character.new(?G.ord)
          if (inclass)
            throw :break_case, :thrown
          end
          if (create)
            @root = LastMatch.new
          end
          return -1
        when Character.new(?H.ord), Character.new(?I.ord), Character.new(?J.ord), Character.new(?K.ord), Character.new(?L.ord), Character.new(?M.ord), Character.new(?N.ord), Character.new(?O.ord), Character.new(?P.ord), Character.new(?Q.ord), Character.new(?R.ord)
        when Character.new(?S.ord)
          if (create)
            @root = Ctype.new(ASCII::SPACE).complement
          end
          return -1
        when Character.new(?T.ord), Character.new(?U.ord), Character.new(?V.ord)
        when Character.new(?W.ord)
          if (create)
            @root = Ctype.new(ASCII::WORD).complement
          end
          return -1
        when Character.new(?X.ord), Character.new(?Y.ord)
        when Character.new(?Z.ord)
          if (inclass)
            throw :break_case, :thrown
          end
          if (create)
            if (has(UNIX_LINES))
              @root = UnixDollar.new(false)
            else
              @root = Dollar.new(false)
            end
          end
          return -1
        when Character.new(?a.ord)
          return Character.new(?\007.ord)
        when Character.new(?b.ord)
          if (inclass)
            throw :break_case, :thrown
          end
          if (create)
            @root = Bound.new(Bound::BOTH)
          end
          return -1
        when Character.new(?c.ord)
          return c
        when Character.new(?d.ord)
          if (create)
            @root = Ctype.new(ASCII::DIGIT)
          end
          return -1
        when Character.new(?e.ord)
          return Character.new(?\033.ord)
        when Character.new(?f.ord)
          return Character.new(?\f.ord)
        when Character.new(?g.ord), Character.new(?h.ord), Character.new(?i.ord), Character.new(?j.ord), Character.new(?k.ord), Character.new(?l.ord), Character.new(?m.ord)
        when Character.new(?n.ord)
          return Character.new(?\n.ord)
        when Character.new(?o.ord), Character.new(?p.ord), Character.new(?q.ord)
        when Character.new(?r.ord)
          return Character.new(?\r.ord)
        when Character.new(?s.ord)
          if (create)
            @root = Ctype.new(ASCII::SPACE)
          end
          return -1
        when Character.new(?t.ord)
          return Character.new(?\t.ord)
        when Character.new(?u.ord)
          return u
        when Character.new(?v.ord)
          return Character.new(?\013.ord)
        when Character.new(?w.ord)
          if (create)
            @root = Ctype.new(ASCII::WORD)
          end
          return -1
        when Character.new(?x.ord)
          return x
        when Character.new(?y.ord)
        when Character.new(?z.ord)
          if (inclass)
            throw :break_case, :thrown
          end
          if (create)
            @root = End.new
          end
          return -1
        else
          return ch
        end
      end
      raise error("Illegal/unsupported escape sequence")
    end
    
    typesig { [::Java::Boolean] }
    # Parse a character class, and return the node that matches it.
    # 
    # Consumes a ] on the way out if consume is true. Usually consume
    # is true except for the case of [abc&&def] where def is a separate
    # right hand node with "understood" brackets.
    def clazz(consume)
      prev = nil
      node = nil
      bits = BitClass.new
      include = true
      first_in_class = true
      ch = next_
      loop do
        catch(:break_case) do
          case (ch)
          when Character.new(?^.ord)
            # Negates if first char in a class, otherwise literal
            if (first_in_class)
              if (!(@temp[@cursor - 1]).equal?(Character.new(?[.ord)))
                throw :break_case, :thrown
              end
              ch = next_
              include = !include
              next
            else
              # ^ not first in class, treat as literal
              throw :break_case, :thrown
            end
            first_in_class = false
            node = clazz(true)
            if ((prev).nil?)
              prev = node
            else
              prev = union(prev, node)
            end
            ch = peek
            next
            first_in_class = false
            ch = next_
            if ((ch).equal?(Character.new(?&.ord)))
              ch = next_
              right_node = nil
              while (!(ch).equal?(Character.new(?].ord)) && !(ch).equal?(Character.new(?&.ord)))
                if ((ch).equal?(Character.new(?[.ord)))
                  if ((right_node).nil?)
                    right_node = clazz(true)
                  else
                    right_node = union(right_node, clazz(true))
                  end
                else
                  # abc&&def
                  unread
                  right_node = clazz(false)
                end
                ch = peek
              end
              if (!(right_node).nil?)
                node = right_node
              end
              if ((prev).nil?)
                if ((right_node).nil?)
                  raise error("Bad class syntax")
                else
                  prev = right_node
                end
              else
                prev = intersection(prev, node)
              end
            else
              # treat as a literal &
              unread
              throw :break_case, :thrown
            end
            next
            first_in_class = false
            if (@cursor >= @pattern_length)
              raise error("Unclosed character class")
            end
          when Character.new(?[.ord)
            first_in_class = false
            node = clazz(true)
            if ((prev).nil?)
              prev = node
            else
              prev = union(prev, node)
            end
            ch = peek
            next
            first_in_class = false
            ch = next_
            if ((ch).equal?(Character.new(?&.ord)))
              ch = next_
              right_node = nil
              while (!(ch).equal?(Character.new(?].ord)) && !(ch).equal?(Character.new(?&.ord)))
                if ((ch).equal?(Character.new(?[.ord)))
                  if ((right_node).nil?)
                    right_node = clazz(true)
                  else
                    right_node = union(right_node, clazz(true))
                  end
                else
                  # abc&&def
                  unread
                  right_node = clazz(false)
                end
                ch = peek
              end
              if (!(right_node).nil?)
                node = right_node
              end
              if ((prev).nil?)
                if ((right_node).nil?)
                  raise error("Bad class syntax")
                else
                  prev = right_node
                end
              else
                prev = intersection(prev, node)
              end
            else
              # treat as a literal &
              unread
              throw :break_case, :thrown
            end
            next
            first_in_class = false
            if (@cursor >= @pattern_length)
              raise error("Unclosed character class")
            end
          when Character.new(?&.ord)
            first_in_class = false
            ch = next_
            if ((ch).equal?(Character.new(?&.ord)))
              ch = next_
              right_node = nil
              while (!(ch).equal?(Character.new(?].ord)) && !(ch).equal?(Character.new(?&.ord)))
                if ((ch).equal?(Character.new(?[.ord)))
                  if ((right_node).nil?)
                    right_node = clazz(true)
                  else
                    right_node = union(right_node, clazz(true))
                  end
                else
                  # abc&&def
                  unread
                  right_node = clazz(false)
                end
                ch = peek
              end
              if (!(right_node).nil?)
                node = right_node
              end
              if ((prev).nil?)
                if ((right_node).nil?)
                  raise error("Bad class syntax")
                else
                  prev = right_node
                end
              else
                prev = intersection(prev, node)
              end
            else
              # treat as a literal &
              unread
              throw :break_case, :thrown
            end
            next
            first_in_class = false
            if (@cursor >= @pattern_length)
              raise error("Unclosed character class")
            end
          when 0
            first_in_class = false
            if (@cursor >= @pattern_length)
              raise error("Unclosed character class")
            end
          when Character.new(?].ord)
            first_in_class = false
            if (!(prev).nil?)
              if (consume)
                next_
              end
              return prev
            end
          else
            first_in_class = false
          end
        end == :thrown or break
        node = range(bits)
        if (include)
          if ((prev).nil?)
            prev = node
          else
            if (!(prev).equal?(node))
              prev = union(prev, node)
            end
          end
        else
          if ((prev).nil?)
            prev = node.complement
          else
            if (!(prev).equal?(node))
              prev = set_difference(prev, node)
            end
          end
        end
        ch = peek
      end
    end
    
    typesig { [BitClass, ::Java::Int] }
    def bits_or_single(bits, ch)
      # Bits can only handle codepoints in [u+0000-u+00ff] range.
      # Use "single" node instead of bits when dealing with unicode
      # case folding for codepoints listed below.
      # (1)Uppercase out of range: u+00ff, u+00b5
      # toUpperCase(u+00ff) -> u+0178
      # toUpperCase(u+00b5) -> u+039c
      # (2)LatinSmallLetterLongS u+17f
      # toUpperCase(u+017f) -> u+0053
      # (3)LatinSmallLetterDotlessI u+131
      # toUpperCase(u+0131) -> u+0049
      # (4)LatinCapitalLetterIWithDotAbove u+0130
      # toLowerCase(u+0130) -> u+0069
      # (5)KelvinSign u+212a
      # toLowerCase(u+212a) ==> u+006B
      # (6)AngstromSign u+212b
      # toLowerCase(u+212b) ==> u+00e5
      d = 0
      # I and i
      # S and s
      # K and k
      if (ch < 256 && !(has(CASE_INSENSITIVE) && has(UNICODE_CASE) && ((ch).equal?(0xff) || (ch).equal?(0xb5) || (ch).equal?(0x49) || (ch).equal?(0x69) || (ch).equal?(0x53) || (ch).equal?(0x73) || (ch).equal?(0x4b) || (ch).equal?(0x6b) || (ch).equal?(0xc5) || (ch).equal?(0xe5))))
        # A+ring
        return bits.add(ch, flags)
      end
      return new_single(ch)
    end
    
    typesig { [BitClass] }
    # Parse a single character or a character range in a character class
    # and return its representative node.
    def range(bits)
      ch = peek
      if ((ch).equal?(Character.new(?\\.ord)))
        ch = next_escaped
        if ((ch).equal?(Character.new(?p.ord)) || (ch).equal?(Character.new(?P.ord)))
          # A property
          comp = ((ch).equal?(Character.new(?P.ord)))
          one_letter = true
          # Consume { if present
          ch = next_
          if (!(ch).equal?(Character.new(?{.ord)))
            unread
          else
            one_letter = false
          end
          return family(one_letter).maybe_complement(comp)
        else
          # ordinary escape
          unread
          ch = escape(true, true)
          if ((ch).equal?(-1))
            return @root
          end
        end
      else
        ch = single
      end
      if (ch >= 0)
        if ((peek).equal?(Character.new(?-.ord)))
          end_range = @temp[@cursor + 1]
          if ((end_range).equal?(Character.new(?[.ord)))
            return bits_or_single(bits, ch)
          end
          if (!(end_range).equal?(Character.new(?].ord)))
            next_
            m = single
            if (m < ch)
              raise error("Illegal character range")
            end
            if (has(CASE_INSENSITIVE))
              return case_insensitive_range_for(ch, m)
            else
              return range_for(ch, m)
            end
          end
        end
        return bits_or_single(bits, ch)
      end
      raise error("Unexpected character '" + RJava.cast_to_string((RJava.cast_to_char(ch))) + "'")
    end
    
    typesig { [] }
    def single
      ch = peek
      case (ch)
      when Character.new(?\\.ord)
        return escape(true, false)
      else
        next_
        return ch
      end
    end
    
    typesig { [::Java::Boolean] }
    # Parses a Unicode character family and returns its representative node.
    def family(single_letter)
      next_
      name = nil
      if (single_letter)
        c_ = @temp[@cursor]
        if (!Character.is_supplementary_code_point(c_))
          name = RJava.cast_to_string(String.value_of(RJava.cast_to_char(c_)))
        else
          name = RJava.cast_to_string(String.new(@temp, @cursor, 1))
        end
        read
      else
        i = @cursor
        mark(Character.new(?}.ord))
        while (!(read).equal?(Character.new(?}.ord)))
        end
        mark(Character.new(?\000.ord))
        j = @cursor
        if (j > @pattern_length)
          raise error("Unclosed character family")
        end
        if (i + 1 >= j)
          raise error("Empty character family")
        end
        name = RJava.cast_to_string(String.new(@temp, i, j - i - 1))
      end
      if (name.starts_with("In"))
        return unicode_block_property_for(name.substring(2))
      else
        if (name.starts_with("Is"))
          name = RJava.cast_to_string(name.substring(2))
        end
        return char_property_node_for(name)
      end
    end
    
    typesig { [String] }
    # Returns a CharProperty matching all characters in a UnicodeBlock.
    def unicode_block_property_for(name)
      block = nil
      begin
        block = Character::UnicodeBlock.for_name(name)
      rescue IllegalArgumentException => iae
        raise error("Unknown character block name {" + name + "}")
      end
      return Class.new(CharProperty.class == Class ? CharProperty : Object) do
        extend LocalClass
        include_class_members Pattern
        include CharProperty if CharProperty.class == Module
        
        typesig { [::Java::Int] }
        define_method :is_satisfied_by do |ch|
          return (block).equal?(Character::UnicodeBlock.of(ch))
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    typesig { [String] }
    # Returns a CharProperty matching all characters in a named property.
    def char_property_node_for(name)
      p = CharPropertyNames.char_property_for(name)
      if ((p).nil?)
        raise error("Unknown character property name {" + name + "}")
      end
      return p
    end
    
    typesig { [] }
    # Parses a group and returns the head node of a set of nodes that process
    # the group. Sometimes a double return system is used where the tail is
    # returned in root.
    def group0
      capturing_group = false
      head = nil
      tail = nil
      save = @flags
      @root = nil
      ch = next_
      if ((ch).equal?(Character.new(??.ord)))
        ch = skip
        case (ch)
        # (?=xxx) and (?!xxx) lookahead
        when Character.new(?:.ord)
          # (?:xxx) pure group
          head = create_group(true)
          tail = @root
          head.attr_next = expr(tail)
        when Character.new(?=.ord), Character.new(?!.ord)
          head = create_group(true)
          tail = @root
          head.attr_next = expr(tail)
          if ((ch).equal?(Character.new(?=.ord)))
            head = tail = Pos.new(head)
          else
            head = tail = Neg.new(head)
          end
        when Character.new(?>.ord)
          # (?>xxx)  independent group
          head = create_group(true)
          tail = @root
          head.attr_next = expr(tail)
          head = tail = Ques.new(head, INDEPENDENT)
        when Character.new(?<.ord)
          # (?<xxx)  look behind
          ch = read
          start_ = @cursor
          head = create_group(true)
          tail = @root
          head.attr_next = expr(tail)
          tail.attr_next = self.attr_lookbehind_end
          info = TreeInfo.new
          head.study(info)
          if ((info.attr_max_valid).equal?(false))
            raise error("Look-behind group does not have " + "an obvious maximum length")
          end
          has_supplementary = find_supplementary(start_, @pattern_length)
          if ((ch).equal?(Character.new(?=.ord)))
            head = tail = (has_supplementary ? BehindS.new(head, info.attr_max_length, info.attr_min_length) : Behind.new(head, info.attr_max_length, info.attr_min_length))
          else
            if ((ch).equal?(Character.new(?!.ord)))
              head = tail = (has_supplementary ? NotBehindS.new(head, info.attr_max_length, info.attr_min_length) : NotBehind.new(head, info.attr_max_length, info.attr_min_length))
            else
              raise error("Unknown look-behind group")
            end
          end
        when Character.new(?$.ord), Character.new(?@.ord)
          raise error("Unknown group type")
        else
          # (?xxx:) inlined match flags
          unread
          add_flag
          ch = read
          if ((ch).equal?(Character.new(?).ord)))
            return nil # Inline modifier only
          end
          if (!(ch).equal?(Character.new(?:.ord)))
            raise error("Unknown inline modifier")
          end
          head = create_group(true)
          tail = @root
          head.attr_next = expr(tail)
        end
      else
        # (xxx) a regular group
        capturing_group = true
        head = create_group(false)
        tail = @root
        head.attr_next = expr(tail)
      end
      accept(Character.new(?).ord), "Unclosed group")
      @flags = save
      # Check for quantifiers
      node = closure(head)
      if ((node).equal?(head))
        # No closure
        @root = tail
        return node # Dual return
      end
      if ((head).equal?(tail))
        # Zero length assertion
        @root = node
        return node # Dual return
      end
      if (node.is_a?(Ques))
        ques = node
        if ((ques.attr_type).equal?(POSSESSIVE))
          @root = node
          return node
        end
        tail.attr_next = BranchConn.new
        tail = tail.attr_next
        if ((ques.attr_type).equal?(GREEDY))
          head = Branch.new(head, nil, tail)
        else
          # Reluctant quantifier
          head = Branch.new(nil, head, tail)
        end
        @root = tail
        return head
      else
        if (node.is_a?(Curly))
          curly = node
          if ((curly.attr_type).equal?(POSSESSIVE))
            @root = node
            return node
          end
          # Discover if the group is deterministic
          info = TreeInfo.new
          if (head.study(info))
            # Deterministic
            temp = tail
            head = @root = GroupCurly.new(head.attr_next, curly.attr_cmin, curly.attr_cmax, curly.attr_type, (tail).attr_local_index, (tail).attr_group_index, capturing_group)
            return head
          else
            # Non-deterministic
            temp = (head).attr_local_index
            loop = nil
            if ((curly.attr_type).equal?(GREEDY))
              loop = Loop.new(@local_count, temp)
            else
              # Reluctant Curly
              loop = LazyLoop.new(@local_count, temp)
            end
            prolog = Prolog.new(loop)
            @local_count += 1
            loop.attr_cmin = curly.attr_cmin
            loop.attr_cmax = curly.attr_cmax
            loop.attr_body = head
            tail.attr_next = loop
            @root = loop
            return prolog # Dual return
          end
        end
      end
      raise error("Internal logic error")
    end
    
    typesig { [::Java::Boolean] }
    # Create group head and tail nodes using double return. If the group is
    # created with anonymous true then it is a pure group and should not
    # affect group counting.
    def create_group(anonymous)
      local_index = ((@local_count += 1) - 1)
      group_index = 0
      if (!anonymous)
        group_index = ((@capturing_group_count += 1) - 1)
      end
      head = GroupHead.new(local_index)
      @root = GroupTail.new(local_index, group_index)
      if (!anonymous && group_index < 10)
        @group_nodes[group_index] = head
      end
      return head
    end
    
    typesig { [] }
    # Parses inlined match flags and set them appropriately.
    def add_flag
      ch = peek
      loop do
        case (ch)
        when Character.new(?i.ord)
          @flags |= CASE_INSENSITIVE
        when Character.new(?m.ord)
          @flags |= MULTILINE
        when Character.new(?s.ord)
          @flags |= DOTALL
        when Character.new(?d.ord)
          @flags |= UNIX_LINES
        when Character.new(?u.ord)
          @flags |= UNICODE_CASE
        when Character.new(?c.ord)
          @flags |= CANON_EQ
        when Character.new(?x.ord)
          @flags |= COMMENTS
        when Character.new(?-.ord)
          # subFlag then fall through
          ch = next_
          sub_flag
          return
        else
          return
        end
        ch = next_
      end
    end
    
    typesig { [] }
    # Parses the second part of inlined match flags and turns off
    # flags appropriately.
    def sub_flag
      ch = peek
      loop do
        case (ch)
        when Character.new(?i.ord)
          @flags &= ~CASE_INSENSITIVE
        when Character.new(?m.ord)
          @flags &= ~MULTILINE
        when Character.new(?s.ord)
          @flags &= ~DOTALL
        when Character.new(?d.ord)
          @flags &= ~UNIX_LINES
        when Character.new(?u.ord)
          @flags &= ~UNICODE_CASE
        when Character.new(?c.ord)
          @flags &= ~CANON_EQ
        when Character.new(?x.ord)
          @flags &= ~COMMENTS
        else
          return
        end
        ch = next_
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:MAX_REPS) { 0x7fffffff }
      const_attr_reader  :MAX_REPS
      
      const_set_lazy(:GREEDY) { 0 }
      const_attr_reader  :GREEDY
      
      const_set_lazy(:LAZY) { 1 }
      const_attr_reader  :LAZY
      
      const_set_lazy(:POSSESSIVE) { 2 }
      const_attr_reader  :POSSESSIVE
      
      const_set_lazy(:INDEPENDENT) { 3 }
      const_attr_reader  :INDEPENDENT
    }
    
    typesig { [Node] }
    # Processes repetition. If the next character peeked is a quantifier
    # then new nodes must be appended to handle the repetition.
    # Prev could be a single or a group, so it could be a chain of nodes.
    def closure(prev)
      atom_ = nil
      ch = peek
      case (ch)
      when Character.new(??.ord)
        ch = next_
        if ((ch).equal?(Character.new(??.ord)))
          next_
          return Ques.new(prev, LAZY)
        else
          if ((ch).equal?(Character.new(?+.ord)))
            next_
            return Ques.new(prev, POSSESSIVE)
          end
        end
        return Ques.new(prev, GREEDY)
      when Character.new(?*.ord)
        ch = next_
        if ((ch).equal?(Character.new(??.ord)))
          next_
          return Curly.new(prev, 0, MAX_REPS, LAZY)
        else
          if ((ch).equal?(Character.new(?+.ord)))
            next_
            return Curly.new(prev, 0, MAX_REPS, POSSESSIVE)
          end
        end
        return Curly.new(prev, 0, MAX_REPS, GREEDY)
      when Character.new(?+.ord)
        ch = next_
        if ((ch).equal?(Character.new(??.ord)))
          next_
          return Curly.new(prev, 1, MAX_REPS, LAZY)
        else
          if ((ch).equal?(Character.new(?+.ord)))
            next_
            return Curly.new(prev, 1, MAX_REPS, POSSESSIVE)
          end
        end
        return Curly.new(prev, 1, MAX_REPS, GREEDY)
      when Character.new(?{.ord)
        ch = @temp[@cursor + 1]
        if (ASCII.is_digit(ch))
          skip
          cmin = 0
          begin
            cmin = cmin * 10 + (ch - Character.new(?0.ord))
          end while (ASCII.is_digit(ch = read))
          cmax = cmin
          if ((ch).equal?(Character.new(?,.ord)))
            ch = read
            cmax = MAX_REPS
            if (!(ch).equal?(Character.new(?}.ord)))
              cmax = 0
              while (ASCII.is_digit(ch))
                cmax = cmax * 10 + (ch - Character.new(?0.ord))
                ch = read
              end
            end
          end
          if (!(ch).equal?(Character.new(?}.ord)))
            raise error("Unclosed counted closure")
          end
          if (((cmin) | (cmax) | (cmax - cmin)) < 0)
            raise error("Illegal repetition range")
          end
          curly = nil
          ch = peek
          if ((ch).equal?(Character.new(??.ord)))
            next_
            curly = Curly.new(prev, cmin, cmax, LAZY)
          else
            if ((ch).equal?(Character.new(?+.ord)))
              next_
              curly = Curly.new(prev, cmin, cmax, POSSESSIVE)
            else
              curly = Curly.new(prev, cmin, cmax, GREEDY)
            end
          end
          return curly
        else
          raise error("Illegal repetition")
        end
      else
        return prev
      end
    end
    
    typesig { [] }
    # Utility method for parsing control escape sequences.
    def c
      if (@cursor < @pattern_length)
        return read ^ 64
      end
      raise error("Illegal control escape sequence")
    end
    
    typesig { [] }
    # Utility method for parsing octal escape sequences.
    def o
      n = read
      if (((n - Character.new(?0.ord)) | (Character.new(?7.ord) - n)) >= 0)
        m = read
        if (((m - Character.new(?0.ord)) | (Character.new(?7.ord) - m)) >= 0)
          o_ = read
          if ((((o_ - Character.new(?0.ord)) | (Character.new(?7.ord) - o_)) >= 0) && (((n - Character.new(?0.ord)) | (Character.new(?3.ord) - n)) >= 0))
            return (n - Character.new(?0.ord)) * 64 + (m - Character.new(?0.ord)) * 8 + (o_ - Character.new(?0.ord))
          end
          unread
          return (n - Character.new(?0.ord)) * 8 + (m - Character.new(?0.ord))
        end
        unread
        return (n - Character.new(?0.ord))
      end
      raise error("Illegal octal escape sequence")
    end
    
    typesig { [] }
    # Utility method for parsing hexadecimal escape sequences.
    def x
      n = read
      if (ASCII.is_hex_digit(n))
        m = read
        if (ASCII.is_hex_digit(m))
          return ASCII.to_digit(n) * 16 + ASCII.to_digit(m)
        end
      end
      raise error("Illegal hexadecimal escape sequence")
    end
    
    typesig { [] }
    # Utility method for parsing unicode escape sequences.
    def u
      n = 0
      i = 0
      while i < 4
        ch = read
        if (!ASCII.is_hex_digit(ch))
          raise error("Illegal Unicode escape sequence")
        end
        n = n * 16 + ASCII.to_digit(ch)
        i += 1
      end
      return n
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Utility methods for code point support
      # 
      # 
      # Tests a surrogate value.
      def is_surrogate(c_)
        return c_ >= Character::MIN_HIGH_SURROGATE && c_ <= Character::MAX_LOW_SURROGATE
      end
      
      typesig { [CharSequence, ::Java::Int, ::Java::Int] }
      def count_chars(seq, index, length_in_code_points)
        # optimization
        if ((length_in_code_points).equal?(1) && !Character.is_high_surrogate(seq.char_at(index)))
          raise AssertError if not ((index >= 0 && index < seq.length))
          return 1
        end
        length_ = seq.length
        x_ = index
        if (length_in_code_points >= 0)
          raise AssertError if not ((index >= 0 && index < length_))
          i = 0
          while x_ < length_ && i < length_in_code_points
            if (Character.is_high_surrogate(seq.char_at(((x_ += 1) - 1))))
              if (x_ < length_ && Character.is_low_surrogate(seq.char_at(x_)))
                x_ += 1
              end
            end
            i += 1
          end
          return x_ - index
        end
        raise AssertError if not ((index >= 0 && index <= length_))
        if ((index).equal?(0))
          return 0
        end
        len = -length_in_code_points
        i = 0
        while x_ > 0 && i < len
          if (Character.is_low_surrogate(seq.char_at((x_ -= 1))))
            if (x_ > 0 && Character.is_high_surrogate(seq.char_at(x_ - 1)))
              x_ -= 1
            end
          end
          i += 1
        end
        return index - x_
      end
      
      typesig { [CharSequence] }
      def count_code_points(seq)
        length_ = seq.length
        n = 0
        i = 0
        while i < length_
          n += 1
          if (Character.is_high_surrogate(seq.char_at(((i += 1) - 1))))
            if (i < length_ && Character.is_low_surrogate(seq.char_at(i)))
              i += 1
            end
          end
        end
        return n
      end
      
      # Creates a bit vector for matching Latin-1 values. A normal BitClass
      # never matches values above Latin-1, and a complemented BitClass always
      # matches values above Latin-1.
      const_set_lazy(:BitClass) { Class.new(BmpCharProperty) do
        include_class_members Pattern
        
        attr_accessor :bits
        alias_method :attr_bits, :bits
        undef_method :bits
        alias_method :attr_bits=, :bits=
        undef_method :bits=
        
        typesig { [] }
        def initialize
          @bits = nil
          super()
          @bits = Array.typed(::Java::Boolean).new(256) { false }
        end
        
        typesig { [Array.typed(::Java::Boolean)] }
        def initialize(bits)
          @bits = nil
          super()
          @bits = bits
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def add(c, flags)
          raise AssertError if not (c >= 0 && c <= 255)
          if (!((flags & CASE_INSENSITIVE)).equal?(0))
            if (ASCII.is_ascii(c))
              @bits[ASCII.to_upper(c)] = true
              @bits[ASCII.to_lower(c)] = true
            else
              if (!((flags & UNICODE_CASE)).equal?(0))
                @bits[Character.to_lower_case(c)] = true
                @bits[Character.to_upper_case(c)] = true
              end
            end
          end
          @bits[c] = true
          return self
        end
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return ch < 256 && @bits[ch]
        end
        
        private
        alias_method :initialize__bit_class, :initialize
      end }
    }
    
    typesig { [::Java::Int] }
    # Returns a suitably optimized, single character matcher.
    def new_single(ch)
      if (has(CASE_INSENSITIVE))
        lower = 0
        upper = 0
        if (has(UNICODE_CASE))
          upper = Character.to_upper_case(ch)
          lower = Character.to_lower_case(upper)
          if (!(upper).equal?(lower))
            return SingleU.new(lower)
          end
        else
          if (ASCII.is_ascii(ch))
            lower = ASCII.to_lower(ch)
            upper = ASCII.to_upper(ch)
            if (!(lower).equal?(upper))
              return SingleI.new(lower, upper)
            end
          end
        end
      end
      if (is_supplementary(ch))
        return SingleS.new(ch)
      end # Match a given Unicode character
      return Single.new(ch) # Match a given BMP character
    end
    
    typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Boolean] }
    # Utility method for creating a string slice matcher.
    def new_slice(buf, count, has_supplementary)
      tmp = Array.typed(::Java::Int).new(count) { 0 }
      if (has(CASE_INSENSITIVE))
        if (has(UNICODE_CASE))
          i = 0
          while i < count
            tmp[i] = Character.to_lower_case(Character.to_upper_case(buf[i]))
            i += 1
          end
          return has_supplementary ? SliceUS.new(tmp) : SliceU.new(tmp)
        end
        i = 0
        while i < count
          tmp[i] = ASCII.to_lower(buf[i])
          i += 1
        end
        return has_supplementary ? SliceIS.new(tmp) : SliceI.new(tmp)
      end
      i = 0
      while i < count
        tmp[i] = buf[i]
        i += 1
      end
      return has_supplementary ? SliceS.new(tmp) : Slice.new(tmp)
    end
    
    class_module.module_eval {
      # The following classes are the building components of the object
      # tree that represents a compiled regular expression. The object tree
      # is made of individual elements that handle constructs in the Pattern.
      # Each type of object knows how to match its equivalent construct with
      # the match() method.
      # 
      # 
      # Base class for all node classes. Subclasses should override the match()
      # method as appropriate. This class is an accepting node, so its match()
      # always returns true.
      const_set_lazy(:Node) { Class.new(Object) do
        include_class_members Pattern
        
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        typesig { [] }
        def initialize
          @next = nil
          super()
          @next = Pattern.attr_accept
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        # This method implements the classic accept node.
        def match(matcher, i, seq)
          matcher.attr_last = i
          matcher.attr_groups[0] = matcher.attr_first
          matcher.attr_groups[1] = matcher.attr_last
          return true
        end
        
        typesig { [class_self::TreeInfo] }
        # This method is good for all zero length assertions.
        def study(info)
          if (!(@next).nil?)
            return @next.study(info)
          else
            return info.attr_deterministic
          end
        end
        
        private
        alias_method :initialize__node, :initialize
      end }
      
      const_set_lazy(:LastNode) { Class.new(Node) do
        include_class_members Pattern
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        # This method implements the classic accept node with
        # the addition of a check to see if the match occurred
        # using all of the input.
        def match(matcher, i, seq)
          if ((matcher.attr_accept_mode).equal?(Matcher::ENDANCHOR) && !(i).equal?(matcher.attr_to))
            return false
          end
          matcher.attr_last = i
          matcher.attr_groups[0] = matcher.attr_first
          matcher.attr_groups[1] = matcher.attr_last
          return true
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__last_node, :initialize
      end }
      
      # Used for REs that can start anywhere within the input string.
      # This basically tries to match repeatedly at each spot in the
      # input string, moving forward after each try. An anchored search
      # or a BnM will bypass this node completely.
      const_set_lazy(:Start) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :min_length
        alias_method :attr_min_length, :min_length
        undef_method :min_length
        alias_method :attr_min_length=, :min_length=
        undef_method :min_length=
        
        typesig { [class_self::Node] }
        def initialize(node)
          @min_length = 0
          super()
          self.attr_next = node
          info = self.class::TreeInfo.new
          self.attr_next.study(info)
          @min_length = info.attr_min_length
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          if (i > matcher.attr_to - @min_length)
            matcher.attr_hit_end = true
            return false
          end
          ret = false
          guard = matcher.attr_to - @min_length
          while i <= guard
            if (ret = self.attr_next.match(matcher, i, seq))
              break
            end
            if ((i).equal?(guard))
              matcher.attr_hit_end = true
            end
            i += 1
          end
          if (ret)
            matcher.attr_first = i
            matcher.attr_groups[0] = matcher.attr_first
            matcher.attr_groups[1] = matcher.attr_last
          end
          return ret
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          self.attr_next.study(info)
          info.attr_max_valid = false
          info.attr_deterministic = false
          return false
        end
        
        private
        alias_method :initialize__start, :initialize
      end }
      
      # StartS supports supplementary characters, including unpaired surrogates.
      const_set_lazy(:StartS) { Class.new(Start) do
        include_class_members Pattern
        
        typesig { [class_self::Node] }
        def initialize(node)
          super(node)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          if (i > matcher.attr_to - self.attr_min_length)
            matcher.attr_hit_end = true
            return false
          end
          ret = false
          guard = matcher.attr_to - self.attr_min_length
          while (i <= guard)
            if ((ret = self.attr_next.match(matcher, i, seq)) || (i).equal?(guard))
              break
            end
            # Optimization to move to the next character. This is
            # faster than countChars(seq, i, 1).
            if (Character.is_high_surrogate(seq.char_at(((i += 1) - 1))))
              if (i < seq.length && Character.is_low_surrogate(seq.char_at(i)))
                i += 1
              end
            end
            if ((i).equal?(guard))
              matcher.attr_hit_end = true
            end
          end
          if (ret)
            matcher.attr_first = i
            matcher.attr_groups[0] = matcher.attr_first
            matcher.attr_groups[1] = matcher.attr_last
          end
          return ret
        end
        
        private
        alias_method :initialize__start_s, :initialize
      end }
      
      # Node to anchor at the beginning of input. This object implements the
      # match for a \A sequence, and the caret anchor will use this if not in
      # multiline mode.
      const_set_lazy(:Begin) { Class.new(Node) do
        include_class_members Pattern
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          from_index = (matcher.attr_anchoring_bounds) ? matcher.attr_from : 0
          if ((i).equal?(from_index) && self.attr_next.match(matcher, i, seq))
            matcher.attr_first = i
            matcher.attr_groups[0] = i
            matcher.attr_groups[1] = matcher.attr_last
            return true
          else
            return false
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__begin, :initialize
      end }
      
      # Node to anchor at the end of input. This is the absolute end, so this
      # should not match at the last newline before the end as $ will.
      const_set_lazy(:End) { Class.new(Node) do
        include_class_members Pattern
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          end_index = (matcher.attr_anchoring_bounds) ? matcher.attr_to : matcher.get_text_length
          if ((i).equal?(end_index))
            matcher.attr_hit_end = true
            return self.attr_next.match(matcher, i, seq)
          end
          return false
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__end, :initialize
      end }
      
      # Node to anchor at the beginning of a line. This is essentially the
      # object to match for the multiline ^.
      const_set_lazy(:Caret) { Class.new(Node) do
        include_class_members Pattern
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          start_index = matcher.attr_from
          end_index = matcher.attr_to
          if (!matcher.attr_anchoring_bounds)
            start_index = 0
            end_index = matcher.get_text_length
          end
          # Perl does not match ^ at end of input even after newline
          if ((i).equal?(end_index))
            matcher.attr_hit_end = true
            return false
          end
          if (i > start_index)
            ch = seq.char_at(i - 1)
            if (!(ch).equal?(Character.new(?\n.ord)) && !(ch).equal?(Character.new(?\r.ord)) && !((ch | 1)).equal?(Character.new(0x2029)) && !(ch).equal?(Character.new(0x0085)))
              return false
            end
            # Should treat /r/n as one newline
            if ((ch).equal?(Character.new(?\r.ord)) && (seq.char_at(i)).equal?(Character.new(?\n.ord)))
              return false
            end
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__caret, :initialize
      end }
      
      # Node to anchor at the beginning of a line when in unixdot mode.
      const_set_lazy(:UnixCaret) { Class.new(Node) do
        include_class_members Pattern
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          start_index = matcher.attr_from
          end_index = matcher.attr_to
          if (!matcher.attr_anchoring_bounds)
            start_index = 0
            end_index = matcher.get_text_length
          end
          # Perl does not match ^ at end of input even after newline
          if ((i).equal?(end_index))
            matcher.attr_hit_end = true
            return false
          end
          if (i > start_index)
            ch = seq.char_at(i - 1)
            if (!(ch).equal?(Character.new(?\n.ord)))
              return false
            end
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__unix_caret, :initialize
      end }
      
      # Node to match the location where the last match ended.
      # This is used for the \G construct.
      const_set_lazy(:LastMatch) { Class.new(Node) do
        include_class_members Pattern
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          if (!(i).equal?(matcher.attr_old_last))
            return false
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__last_match, :initialize
      end }
      
      # Node to anchor at the end of a line or the end of input based on the
      # multiline mode.
      # 
      # When not in multiline mode, the $ can only match at the very end
      # of the input, unless the input ends in a line terminator in which
      # it matches right before the last line terminator.
      # 
      # Note that \r\n is considered an atomic line terminator.
      # 
      # Like ^ the $ operator matches at a position, it does not match the
      # line terminators themselves.
      const_set_lazy(:Dollar) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :multiline
        alias_method :attr_multiline, :multiline
        undef_method :multiline
        alias_method :attr_multiline=, :multiline=
        undef_method :multiline=
        
        typesig { [::Java::Boolean] }
        def initialize(mul)
          @multiline = false
          super()
          @multiline = mul
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          end_index = (matcher.attr_anchoring_bounds) ? matcher.attr_to : matcher.get_text_length
          if (!@multiline)
            if (i < end_index - 2)
              return false
            end
            if ((i).equal?(end_index - 2))
              ch = seq.char_at(i)
              if (!(ch).equal?(Character.new(?\r.ord)))
                return false
              end
              ch = seq.char_at(i + 1)
              if (!(ch).equal?(Character.new(?\n.ord)))
                return false
              end
            end
          end
          # Matches before any line terminator; also matches at the
          # end of input
          # Before line terminator:
          # If multiline, we match here no matter what
          # If not multiline, fall through so that the end
          # is marked as hit; this must be a /r/n or a /n
          # at the very end so the end was hit; more input
          # could make this not match here
          if (i < end_index)
            ch = seq.char_at(i)
            if ((ch).equal?(Character.new(?\n.ord)))
              # No match between \r\n
              if (i > 0 && (seq.char_at(i - 1)).equal?(Character.new(?\r.ord)))
                return false
              end
              if (@multiline)
                return self.attr_next.match(matcher, i, seq)
              end
            else
              if ((ch).equal?(Character.new(?\r.ord)) || (ch).equal?(Character.new(0x0085)) || ((ch | 1)).equal?(Character.new(0x2029)))
                if (@multiline)
                  return self.attr_next.match(matcher, i, seq)
                end
              else
                # No line terminator, no match
                return false
              end
            end
          end
          # Matched at current end so hit end
          matcher.attr_hit_end = true
          # If a $ matches because of end of input, then more input
          # could cause it to fail!
          matcher.attr_require_end = true
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          self.attr_next.study(info)
          return info.attr_deterministic
        end
        
        private
        alias_method :initialize__dollar, :initialize
      end }
      
      # Node to anchor at the end of a line or the end of input based on the
      # multiline mode when in unix lines mode.
      const_set_lazy(:UnixDollar) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :multiline
        alias_method :attr_multiline, :multiline
        undef_method :multiline
        alias_method :attr_multiline=, :multiline=
        undef_method :multiline=
        
        typesig { [::Java::Boolean] }
        def initialize(mul)
          @multiline = false
          super()
          @multiline = mul
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          end_index = (matcher.attr_anchoring_bounds) ? matcher.attr_to : matcher.get_text_length
          if (i < end_index)
            ch = seq.char_at(i)
            if ((ch).equal?(Character.new(?\n.ord)))
              # If not multiline, then only possible to
              # match at very end or one before end
              if ((@multiline).equal?(false) && !(i).equal?(end_index - 1))
                return false
              end
              # If multiline return next.match without setting
              # matcher.hitEnd
              if (@multiline)
                return self.attr_next.match(matcher, i, seq)
              end
            else
              return false
            end
          end
          # Matching because at the end or 1 before the end;
          # more input could change this so set hitEnd
          matcher.attr_hit_end = true
          # If a $ matches because of end of input, then more input
          # could cause it to fail!
          matcher.attr_require_end = true
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          self.attr_next.study(info)
          return info.attr_deterministic
        end
        
        private
        alias_method :initialize__unix_dollar, :initialize
      end }
      
      # Abstract node class to match one character satisfying some
      # boolean property.
      const_set_lazy(:CharProperty) { Class.new(Node) do
        include_class_members Pattern
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          raise NotImplementedError
        end
        
        typesig { [] }
        def complement
          return Class.new(self.class::CharProperty.class == Class ? self.class::CharProperty : Object) do
            extend LocalClass
            include_class_members CharProperty
            include class_self::CharProperty if class_self::CharProperty.class == Module
            
            typesig { [::Java::Int] }
            define_method :is_satisfied_by do |ch|
              return !@local_class_parent.is_satisfied_by(ch)
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self)
        end
        
        typesig { [::Java::Boolean] }
        def maybe_complement(complement)
          return complement ? complement : self
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          if (i < matcher.attr_to)
            ch = Character.code_point_at(seq, i)
            return is_satisfied_by(ch) && self.attr_next.match(matcher, i + Character.char_count(ch), seq)
          else
            matcher.attr_hit_end = true
            return false
          end
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          info.attr_min_length += 1
          info.attr_max_length += 1
          return self.attr_next.study(info)
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__char_property, :initialize
      end }
      
      # Optimized version of CharProperty that works only for
      # properties never satisfied by Supplementary characters.
      const_set_lazy(:BmpCharProperty) { Class.new(CharProperty) do
        include_class_members Pattern
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          if (i < matcher.attr_to)
            return is_satisfied_by(seq.char_at(i)) && self.attr_next.match(matcher, i + 1, seq)
          else
            matcher.attr_hit_end = true
            return false
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__bmp_char_property, :initialize
      end }
      
      # Node class that matches a Supplementary Unicode character
      const_set_lazy(:SingleS) { Class.new(CharProperty) do
        include_class_members Pattern
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        typesig { [::Java::Int] }
        def initialize(c)
          @c = 0
          super()
          @c = c
        end
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return (ch).equal?(@c)
        end
        
        private
        alias_method :initialize__single_s, :initialize
      end }
      
      # Optimization -- matches a given BMP character
      const_set_lazy(:Single) { Class.new(BmpCharProperty) do
        include_class_members Pattern
        
        attr_accessor :c
        alias_method :attr_c, :c
        undef_method :c
        alias_method :attr_c=, :c=
        undef_method :c=
        
        typesig { [::Java::Int] }
        def initialize(c)
          @c = 0
          super()
          @c = c
        end
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return (ch).equal?(@c)
        end
        
        private
        alias_method :initialize__single, :initialize
      end }
      
      # Case insensitive matches a given BMP character
      const_set_lazy(:SingleI) { Class.new(BmpCharProperty) do
        include_class_members Pattern
        
        attr_accessor :lower
        alias_method :attr_lower, :lower
        undef_method :lower
        alias_method :attr_lower=, :lower=
        undef_method :lower=
        
        attr_accessor :upper
        alias_method :attr_upper, :upper
        undef_method :upper
        alias_method :attr_upper=, :upper=
        undef_method :upper=
        
        typesig { [::Java::Int, ::Java::Int] }
        def initialize(lower, upper)
          @lower = 0
          @upper = 0
          super()
          @lower = lower
          @upper = upper
        end
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return (ch).equal?(@lower) || (ch).equal?(@upper)
        end
        
        private
        alias_method :initialize__single_i, :initialize
      end }
      
      # Unicode case insensitive matches a given Unicode character
      const_set_lazy(:SingleU) { Class.new(CharProperty) do
        include_class_members Pattern
        
        attr_accessor :lower
        alias_method :attr_lower, :lower
        undef_method :lower
        alias_method :attr_lower=, :lower=
        undef_method :lower=
        
        typesig { [::Java::Int] }
        def initialize(lower)
          @lower = 0
          super()
          @lower = lower
        end
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return (@lower).equal?(ch) || (@lower).equal?(Character.to_lower_case(Character.to_upper_case(ch)))
        end
        
        private
        alias_method :initialize__single_u, :initialize
      end }
      
      # Node class that matches a Unicode category.
      const_set_lazy(:Category) { Class.new(CharProperty) do
        include_class_members Pattern
        
        attr_accessor :type_mask
        alias_method :attr_type_mask, :type_mask
        undef_method :type_mask
        alias_method :attr_type_mask=, :type_mask=
        undef_method :type_mask=
        
        typesig { [::Java::Int] }
        def initialize(type_mask)
          @type_mask = 0
          super()
          @type_mask = type_mask
        end
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return !((@type_mask & (1 << Character.get_type(ch)))).equal?(0)
        end
        
        private
        alias_method :initialize__category, :initialize
      end }
      
      # Node class that matches a POSIX type.
      const_set_lazy(:Ctype) { Class.new(BmpCharProperty) do
        include_class_members Pattern
        
        attr_accessor :ctype
        alias_method :attr_ctype, :ctype
        undef_method :ctype
        alias_method :attr_ctype=, :ctype=
        undef_method :ctype=
        
        typesig { [::Java::Int] }
        def initialize(ctype)
          @ctype = 0
          super()
          @ctype = ctype
        end
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return ch < 128 && ASCII.is_type(ch, @ctype)
        end
        
        private
        alias_method :initialize__ctype, :initialize
      end }
      
      # Base class for all Slice nodes
      const_set_lazy(:SliceNode) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :buffer
        alias_method :attr_buffer, :buffer
        undef_method :buffer
        alias_method :attr_buffer=, :buffer=
        undef_method :buffer=
        
        typesig { [Array.typed(::Java::Int)] }
        def initialize(buf)
          @buffer = nil
          super()
          @buffer = buf
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          info.attr_min_length += @buffer.attr_length
          info.attr_max_length += @buffer.attr_length
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__slice_node, :initialize
      end }
      
      # Node class for a case sensitive/BMP-only sequence of literal
      # characters.
      const_set_lazy(:Slice) { Class.new(SliceNode) do
        include_class_members Pattern
        
        typesig { [Array.typed(::Java::Int)] }
        def initialize(buf)
          super(buf)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          buf = self.attr_buffer
          len = buf.attr_length
          j = 0
          while j < len
            if ((i + j) >= matcher.attr_to)
              matcher.attr_hit_end = true
              return false
            end
            if (!(buf[j]).equal?(seq.char_at(i + j)))
              return false
            end
            j += 1
          end
          return self.attr_next.match(matcher, i + len, seq)
        end
        
        private
        alias_method :initialize__slice, :initialize
      end }
      
      # Node class for a case_insensitive/BMP-only sequence of literal
      # characters.
      const_set_lazy(:SliceI) { Class.new(SliceNode) do
        include_class_members Pattern
        
        typesig { [Array.typed(::Java::Int)] }
        def initialize(buf)
          super(buf)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          buf = self.attr_buffer
          len = buf.attr_length
          j = 0
          while j < len
            if ((i + j) >= matcher.attr_to)
              matcher.attr_hit_end = true
              return false
            end
            c = seq.char_at(i + j)
            if (!(buf[j]).equal?(c) && !(buf[j]).equal?(ASCII.to_lower(c)))
              return false
            end
            j += 1
          end
          return self.attr_next.match(matcher, i + len, seq)
        end
        
        private
        alias_method :initialize__slice_i, :initialize
      end }
      
      # Node class for a unicode_case_insensitive/BMP-only sequence of
      # literal characters. Uses unicode case folding.
      const_set_lazy(:SliceU) { Class.new(SliceNode) do
        include_class_members Pattern
        
        typesig { [Array.typed(::Java::Int)] }
        def initialize(buf)
          super(buf)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          buf = self.attr_buffer
          len = buf.attr_length
          j = 0
          while j < len
            if ((i + j) >= matcher.attr_to)
              matcher.attr_hit_end = true
              return false
            end
            c = seq.char_at(i + j)
            if (!(buf[j]).equal?(c) && !(buf[j]).equal?(Character.to_lower_case(Character.to_upper_case(c))))
              return false
            end
            j += 1
          end
          return self.attr_next.match(matcher, i + len, seq)
        end
        
        private
        alias_method :initialize__slice_u, :initialize
      end }
      
      # Node class for a case sensitive sequence of literal characters
      # including supplementary characters.
      const_set_lazy(:SliceS) { Class.new(SliceNode) do
        include_class_members Pattern
        
        typesig { [Array.typed(::Java::Int)] }
        def initialize(buf)
          super(buf)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          buf = self.attr_buffer
          x = i
          j = 0
          while j < buf.attr_length
            if (x >= matcher.attr_to)
              matcher.attr_hit_end = true
              return false
            end
            c = Character.code_point_at(seq, x)
            if (!(buf[j]).equal?(c))
              return false
            end
            x += Character.char_count(c)
            if (x > matcher.attr_to)
              matcher.attr_hit_end = true
              return false
            end
            j += 1
          end
          return self.attr_next.match(matcher, x, seq)
        end
        
        private
        alias_method :initialize__slice_s, :initialize
      end }
      
      # Node class for a case insensitive sequence of literal characters
      # including supplementary characters.
      const_set_lazy(:SliceIS) { Class.new(SliceNode) do
        include_class_members Pattern
        
        typesig { [Array.typed(::Java::Int)] }
        def initialize(buf)
          super(buf)
        end
        
        typesig { [::Java::Int] }
        def to_lower(c)
          return ASCII.to_lower(c)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          buf = self.attr_buffer
          x = i
          j = 0
          while j < buf.attr_length
            if (x >= matcher.attr_to)
              matcher.attr_hit_end = true
              return false
            end
            c = Character.code_point_at(seq, x)
            if (!(buf[j]).equal?(c) && !(buf[j]).equal?(to_lower(c)))
              return false
            end
            x += Character.char_count(c)
            if (x > matcher.attr_to)
              matcher.attr_hit_end = true
              return false
            end
            j += 1
          end
          return self.attr_next.match(matcher, x, seq)
        end
        
        private
        alias_method :initialize__slice_is, :initialize
      end }
      
      # Node class for a case insensitive sequence of literal characters.
      # Uses unicode case folding.
      const_set_lazy(:SliceUS) { Class.new(SliceIS) do
        include_class_members Pattern
        
        typesig { [Array.typed(::Java::Int)] }
        def initialize(buf)
          super(buf)
        end
        
        typesig { [::Java::Int] }
        def to_lower(c)
          return Character.to_lower_case(Character.to_upper_case(c))
        end
        
        private
        alias_method :initialize__slice_us, :initialize
      end }
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int] }
      def in_range(lower, ch, upper)
        return lower <= ch && ch <= upper
      end
      
      typesig { [::Java::Int, ::Java::Int] }
      # Returns node for matching characters within an explicit value range.
      def range_for(lower, upper)
        return Class.new(CharProperty.class == Class ? CharProperty : Object) do
          extend LocalClass
          include_class_members Pattern
          include CharProperty if CharProperty.class == Module
          
          typesig { [::Java::Int] }
          define_method :is_satisfied_by do |ch|
            return in_range(lower, ch, upper)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
    }
    
    typesig { [::Java::Int, ::Java::Int] }
    # Returns node for matching characters within an explicit value
    # range in a case insensitive manner.
    def case_insensitive_range_for(lower, upper)
      if (has(UNICODE_CASE))
        return Class.new(CharProperty.class == Class ? CharProperty : Object) do
          extend LocalClass
          include_class_members Pattern
          include CharProperty if CharProperty.class == Module
          
          typesig { [::Java::Int] }
          define_method :is_satisfied_by do |ch|
            if (in_range(lower, ch, upper))
              return true
            end
            up = Character.to_upper_case(ch)
            return in_range(lower, up, upper) || in_range(lower, Character.to_lower_case(up), upper)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      return Class.new(CharProperty.class == Class ? CharProperty : Object) do
        extend LocalClass
        include_class_members Pattern
        include CharProperty if CharProperty.class == Module
        
        typesig { [::Java::Int] }
        define_method :is_satisfied_by do |ch|
          return in_range(lower, ch, upper) || ASCII.is_ascii(ch) && (in_range(lower, ASCII.to_upper(ch), upper) || in_range(lower, ASCII.to_lower(ch), upper))
        end
        
        typesig { [Vararg.new(Object)] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self)
    end
    
    class_module.module_eval {
      # Implements the Unicode category ALL and the dot metacharacter when
      # in dotall mode.
      const_set_lazy(:All) { Class.new(CharProperty) do
        include_class_members Pattern
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return true
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__all, :initialize
      end }
      
      # Node class for the dot metacharacter when dotall is not enabled.
      const_set_lazy(:Dot) { Class.new(CharProperty) do
        include_class_members Pattern
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return (!(ch).equal?(Character.new(?\n.ord)) && !(ch).equal?(Character.new(?\r.ord)) && !((ch | 1)).equal?(Character.new(0x2029)) && !(ch).equal?(Character.new(0x0085)))
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__dot, :initialize
      end }
      
      # Node class for the dot metacharacter when dotall is not enabled
      # but UNIX_LINES is enabled.
      const_set_lazy(:UnixDot) { Class.new(CharProperty) do
        include_class_members Pattern
        
        typesig { [::Java::Int] }
        def is_satisfied_by(ch)
          return !(ch).equal?(Character.new(?\n.ord))
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__unix_dot, :initialize
      end }
      
      # The 0 or 1 quantifier. This one class implements all three types.
      const_set_lazy(:Ques) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :atom
        alias_method :attr_atom, :atom
        undef_method :atom
        alias_method :attr_atom=, :atom=
        undef_method :atom=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        typesig { [class_self::Node, ::Java::Int] }
        def initialize(node, type)
          @atom = nil
          @type = 0
          super()
          @atom = node
          @type = type
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          case (@type)
          when GREEDY
            return (@atom.match(matcher, i, seq) && self.attr_next.match(matcher, matcher.attr_last, seq)) || self.attr_next.match(matcher, i, seq)
          when LAZY
            return self.attr_next.match(matcher, i, seq) || (@atom.match(matcher, i, seq) && self.attr_next.match(matcher, matcher.attr_last, seq))
          when POSSESSIVE
            if (@atom.match(matcher, i, seq))
              i = matcher.attr_last
            end
            return self.attr_next.match(matcher, i, seq)
          else
            return @atom.match(matcher, i, seq) && self.attr_next.match(matcher, matcher.attr_last, seq)
          end
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          if (!(@type).equal?(INDEPENDENT))
            min_l = info.attr_min_length
            @atom.study(info)
            info.attr_min_length = min_l
            info.attr_deterministic = false
            return self.attr_next.study(info)
          else
            @atom.study(info)
            return self.attr_next.study(info)
          end
        end
        
        private
        alias_method :initialize__ques, :initialize
      end }
      
      # Handles the curly-brace style repetition with a specified minimum and
      # maximum occurrences. The * quantifier is handled as a special case.
      # This class handles the three types.
      const_set_lazy(:Curly) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :atom
        alias_method :attr_atom, :atom
        undef_method :atom
        alias_method :attr_atom=, :atom=
        undef_method :atom=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :cmin
        alias_method :attr_cmin, :cmin
        undef_method :cmin
        alias_method :attr_cmin=, :cmin=
        undef_method :cmin=
        
        attr_accessor :cmax
        alias_method :attr_cmax, :cmax
        undef_method :cmax
        alias_method :attr_cmax=, :cmax=
        undef_method :cmax=
        
        typesig { [class_self::Node, ::Java::Int, ::Java::Int, ::Java::Int] }
        def initialize(node, cmin, cmax, type)
          @atom = nil
          @type = 0
          @cmin = 0
          @cmax = 0
          super()
          @atom = node
          @type = type
          @cmin = cmin
          @cmax = cmax
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          j = 0
          j = 0
          while j < @cmin
            if (@atom.match(matcher, i, seq))
              i = matcher.attr_last
              j += 1
              next
            end
            return false
            j += 1
          end
          if ((@type).equal?(GREEDY))
            return match0(matcher, i, j, seq)
          else
            if ((@type).equal?(LAZY))
              return match1(matcher, i, j, seq)
            else
              return match2(matcher, i, j, seq)
            end
          end
        end
        
        typesig { [class_self::Matcher, ::Java::Int, ::Java::Int, class_self::CharSequence] }
        # Greedy match.
        # i is the index to start matching at
        # j is the number of atoms that have matched
        def match0(matcher, i, j, seq)
          if (j >= @cmax)
            # We have matched the maximum... continue with the rest of
            # the regular expression
            return self.attr_next.match(matcher, i, seq)
          end
          back_limit = j
          while (@atom.match(matcher, i, seq))
            # k is the length of this match
            k = matcher.attr_last - i
            if ((k).equal?(0))
              # Zero length match
              break
            end
            # Move up index and number matched
            i = matcher.attr_last
            j += 1
            # We are greedy so match as many as we can
            while (j < @cmax)
              if (!@atom.match(matcher, i, seq))
                break
              end
              if (!(i + k).equal?(matcher.attr_last))
                if (match0(matcher, matcher.attr_last, j + 1, seq))
                  return true
                end
                break
              end
              i += k
              j += 1
            end
            # Handle backing off if match fails
            while (j >= back_limit)
              if (self.attr_next.match(matcher, i, seq))
                return true
              end
              i -= k
              j -= 1
            end
            return false
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, ::Java::Int, class_self::CharSequence] }
        # Reluctant match. At this point, the minimum has been satisfied.
        # i is the index to start matching at
        # j is the number of atoms that have matched
        def match1(matcher, i, j, seq)
          loop do
            # Try finishing match without consuming any more
            if (self.attr_next.match(matcher, i, seq))
              return true
            end
            # At the maximum, no match found
            if (j >= @cmax)
              return false
            end
            # Okay, must try one more atom
            if (!@atom.match(matcher, i, seq))
              return false
            end
            # If we haven't moved forward then must break out
            if ((i).equal?(matcher.attr_last))
              return false
            end
            # Move up index and number matched
            i = matcher.attr_last
            j += 1
          end
        end
        
        typesig { [class_self::Matcher, ::Java::Int, ::Java::Int, class_self::CharSequence] }
        def match2(matcher, i, j, seq)
          while j < @cmax
            if (!@atom.match(matcher, i, seq))
              break
            end
            if ((i).equal?(matcher.attr_last))
              break
            end
            i = matcher.attr_last
            j += 1
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          # Save original info
          min_l = info.attr_min_length
          max_l = info.attr_max_length
          max_v = info.attr_max_valid
          detm = info.attr_deterministic
          info.reset
          @atom.study(info)
          temp = info.attr_min_length * @cmin + min_l
          if (temp < min_l)
            temp = 0xfffffff # arbitrary large number
          end
          info.attr_min_length = temp
          if (max_v & info.attr_max_valid)
            temp = info.attr_max_length * @cmax + max_l
            info.attr_max_length = temp
            if (temp < max_l)
              info.attr_max_valid = false
            end
          else
            info.attr_max_valid = false
          end
          if (info.attr_deterministic && (@cmin).equal?(@cmax))
            info.attr_deterministic = detm
          else
            info.attr_deterministic = false
          end
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__curly, :initialize
      end }
      
      # Handles the curly-brace style repetition with a specified minimum and
      # maximum occurrences in deterministic cases. This is an iterative
      # optimization over the Prolog and Loop system which would handle this
      # in a recursive way. The * quantifier is handled as a special case.
      # If capture is true then this class saves group settings and ensures
      # that groups are unset when backing off of a group match.
      const_set_lazy(:GroupCurly) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :atom
        alias_method :attr_atom, :atom
        undef_method :atom
        alias_method :attr_atom=, :atom=
        undef_method :atom=
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        attr_accessor :cmin
        alias_method :attr_cmin, :cmin
        undef_method :cmin
        alias_method :attr_cmin=, :cmin=
        undef_method :cmin=
        
        attr_accessor :cmax
        alias_method :attr_cmax, :cmax
        undef_method :cmax
        alias_method :attr_cmax=, :cmax=
        undef_method :cmax=
        
        attr_accessor :local_index
        alias_method :attr_local_index, :local_index
        undef_method :local_index
        alias_method :attr_local_index=, :local_index=
        undef_method :local_index=
        
        attr_accessor :group_index
        alias_method :attr_group_index, :group_index
        undef_method :group_index
        alias_method :attr_group_index=, :group_index=
        undef_method :group_index=
        
        attr_accessor :capture
        alias_method :attr_capture, :capture
        undef_method :capture
        alias_method :attr_capture=, :capture=
        undef_method :capture=
        
        typesig { [class_self::Node, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def initialize(node, cmin, cmax, type, local, group, capture)
          @atom = nil
          @type = 0
          @cmin = 0
          @cmax = 0
          @local_index = 0
          @group_index = 0
          @capture = false
          super()
          @atom = node
          @type = type
          @cmin = cmin
          @cmax = cmax
          @local_index = local
          @group_index = group
          @capture = capture
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          groups = matcher.attr_groups
          locals = matcher.attr_locals
          save0 = locals[@local_index]
          save1 = 0
          save2 = 0
          if (@capture)
            save1 = groups[@group_index]
            save2 = groups[@group_index + 1]
          end
          # Notify GroupTail there is no need to setup group info
          # because it will be set here
          locals[@local_index] = -1
          ret = true
          j = 0
          while j < @cmin
            if (@atom.match(matcher, i, seq))
              if (@capture)
                groups[@group_index] = i
                groups[@group_index + 1] = matcher.attr_last
              end
              i = matcher.attr_last
            else
              ret = false
              break
            end
            j += 1
          end
          if (ret)
            if ((@type).equal?(GREEDY))
              ret = match0(matcher, i, @cmin, seq)
            else
              if ((@type).equal?(LAZY))
                ret = match1(matcher, i, @cmin, seq)
              else
                ret = match2(matcher, i, @cmin, seq)
              end
            end
          end
          if (!ret)
            locals[@local_index] = save0
            if (@capture)
              groups[@group_index] = save1
              groups[@group_index + 1] = save2
            end
          end
          return ret
        end
        
        typesig { [class_self::Matcher, ::Java::Int, ::Java::Int, class_self::CharSequence] }
        # Aggressive group match
        def match0(matcher, i, j, seq)
          groups = matcher.attr_groups
          save0 = 0
          save1 = 0
          if (@capture)
            save0 = groups[@group_index]
            save1 = groups[@group_index + 1]
          end
          loop do
            if (j >= @cmax)
              break
            end
            if (!@atom.match(matcher, i, seq))
              break
            end
            k = matcher.attr_last - i
            if (k <= 0)
              if (@capture)
                groups[@group_index] = i
                groups[@group_index + 1] = i + k
              end
              i = i + k
              break
            end
            loop do
              if (@capture)
                groups[@group_index] = i
                groups[@group_index + 1] = i + k
              end
              i = i + k
              if ((j += 1) >= @cmax)
                break
              end
              if (!@atom.match(matcher, i, seq))
                break
              end
              if (!(i + k).equal?(matcher.attr_last))
                if (match0(matcher, i, j, seq))
                  return true
                end
                break
              end
            end
            while (j > @cmin)
              if (self.attr_next.match(matcher, i, seq))
                if (@capture)
                  groups[@group_index + 1] = i
                  groups[@group_index] = i - k
                end
                i = i - k
                return true
              end
              # backing off
              if (@capture)
                groups[@group_index + 1] = i
                groups[@group_index] = i - k
              end
              i = i - k
              j -= 1
            end
            break
          end
          if (@capture)
            groups[@group_index] = save0
            groups[@group_index + 1] = save1
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, ::Java::Int, class_self::CharSequence] }
        # Reluctant matching
        def match1(matcher, i, j, seq)
          loop do
            if (self.attr_next.match(matcher, i, seq))
              return true
            end
            if (j >= @cmax)
              return false
            end
            if (!@atom.match(matcher, i, seq))
              return false
            end
            if ((i).equal?(matcher.attr_last))
              return false
            end
            if (@capture)
              matcher.attr_groups[@group_index] = i
              matcher.attr_groups[@group_index + 1] = matcher.attr_last
            end
            i = matcher.attr_last
            j += 1
          end
        end
        
        typesig { [class_self::Matcher, ::Java::Int, ::Java::Int, class_self::CharSequence] }
        # Possessive matching
        def match2(matcher, i, j, seq)
          while j < @cmax
            if (!@atom.match(matcher, i, seq))
              break
            end
            if (@capture)
              matcher.attr_groups[@group_index] = i
              matcher.attr_groups[@group_index + 1] = matcher.attr_last
            end
            if ((i).equal?(matcher.attr_last))
              break
            end
            i = matcher.attr_last
            j += 1
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          # Save original info
          min_l = info.attr_min_length
          max_l = info.attr_max_length
          max_v = info.attr_max_valid
          detm = info.attr_deterministic
          info.reset
          @atom.study(info)
          temp = info.attr_min_length * @cmin + min_l
          if (temp < min_l)
            temp = 0xfffffff # Arbitrary large number
          end
          info.attr_min_length = temp
          if (max_v & info.attr_max_valid)
            temp = info.attr_max_length * @cmax + max_l
            info.attr_max_length = temp
            if (temp < max_l)
              info.attr_max_valid = false
            end
          else
            info.attr_max_valid = false
          end
          if (info.attr_deterministic && (@cmin).equal?(@cmax))
            info.attr_deterministic = detm
          else
            info.attr_deterministic = false
          end
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__group_curly, :initialize
      end }
      
      # A Guard node at the end of each atom node in a Branch. It
      # serves the purpose of chaining the "match" operation to
      # "next" but not the "study", so we can collect the TreeInfo
      # of each atom node without including the TreeInfo of the
      # "next".
      const_set_lazy(:BranchConn) { Class.new(Node) do
        include_class_members Pattern
        
        typesig { [] }
        def initialize
          super()
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          return info.attr_deterministic
        end
        
        private
        alias_method :initialize__branch_conn, :initialize
      end }
      
      # Handles the branching of alternations. Note this is also used for
      # the ? quantifier to branch between the case where it matches once
      # and where it does not occur.
      const_set_lazy(:Branch) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :atoms
        alias_method :attr_atoms, :atoms
        undef_method :atoms
        alias_method :attr_atoms=, :atoms=
        undef_method :atoms=
        
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        attr_accessor :conn
        alias_method :attr_conn, :conn
        undef_method :conn
        alias_method :attr_conn=, :conn=
        undef_method :conn=
        
        typesig { [class_self::Node, class_self::Node, class_self::Node] }
        def initialize(first, second, branch_conn)
          @atoms = nil
          @size = 0
          @conn = nil
          super()
          @atoms = Array.typed(self.class::Node).new(2) { nil }
          @size = 2
          @conn = branch_conn
          @atoms[0] = first
          @atoms[1] = second
        end
        
        typesig { [class_self::Node] }
        def add(node)
          if (@size >= @atoms.attr_length)
            tmp = Array.typed(self.class::Node).new(@atoms.attr_length * 2) { nil }
            System.arraycopy(@atoms, 0, tmp, 0, @atoms.attr_length)
            @atoms = tmp
          end
          @atoms[((@size += 1) - 1)] = node
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          n = 0
          while n < @size
            if ((@atoms[n]).nil?)
              if (@conn.attr_next.match(matcher, i, seq))
                return true
              end
            else
              if (@atoms[n].match(matcher, i, seq))
                return true
              end
            end
            n += 1
          end
          return false
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          min_l = info.attr_min_length
          max_l = info.attr_max_length
          max_v = info.attr_max_valid
          min_l2 = JavaInteger::MAX_VALUE # arbitrary large enough num
          max_l2 = -1
          n = 0
          while n < @size
            info.reset
            if (!(@atoms[n]).nil?)
              @atoms[n].study(info)
            end
            min_l2 = Math.min(min_l2, info.attr_min_length)
            max_l2 = Math.max(max_l2, info.attr_max_length)
            max_v = (max_v & info.attr_max_valid)
            n += 1
          end
          min_l += min_l2
          max_l += max_l2
          info.reset
          @conn.attr_next.study(info)
          info.attr_min_length += min_l
          info.attr_max_length += max_l
          info.attr_max_valid &= max_v
          info.attr_deterministic = false
          return false
        end
        
        private
        alias_method :initialize__branch, :initialize
      end }
      
      # The GroupHead saves the location where the group begins in the locals
      # and restores them when the match is done.
      # 
      # The matchRef is used when a reference to this group is accessed later
      # in the expression. The locals will have a negative value in them to
      # indicate that we do not want to unset the group if the reference
      # doesn't match.
      const_set_lazy(:GroupHead) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :local_index
        alias_method :attr_local_index, :local_index
        undef_method :local_index
        alias_method :attr_local_index=, :local_index=
        undef_method :local_index=
        
        typesig { [::Java::Int] }
        def initialize(local_count)
          @local_index = 0
          super()
          @local_index = local_count
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          save = matcher.attr_locals[@local_index]
          matcher.attr_locals[@local_index] = i
          ret = self.attr_next.match(matcher, i, seq)
          matcher.attr_locals[@local_index] = save
          return ret
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match_ref(matcher, i, seq)
          save = matcher.attr_locals[@local_index]
          matcher.attr_locals[@local_index] = ~i # HACK
          ret = self.attr_next.match(matcher, i, seq)
          matcher.attr_locals[@local_index] = save
          return ret
        end
        
        private
        alias_method :initialize__group_head, :initialize
      end }
      
      # Recursive reference to a group in the regular expression. It calls
      # matchRef because if the reference fails to match we would not unset
      # the group.
      const_set_lazy(:GroupRef) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :head
        alias_method :attr_head, :head
        undef_method :head
        alias_method :attr_head=, :head=
        undef_method :head=
        
        typesig { [class_self::GroupHead] }
        def initialize(head)
          @head = nil
          super()
          @head = head
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          return @head.match_ref(matcher, i, seq) && self.attr_next.match(matcher, matcher.attr_last, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          info.attr_max_valid = false
          info.attr_deterministic = false
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__group_ref, :initialize
      end }
      
      # The GroupTail handles the setting of group beginning and ending
      # locations when groups are successfully matched. It must also be able to
      # unset groups that have to be backed off of.
      # 
      # The GroupTail node is also used when a previous group is referenced,
      # and in that case no group information needs to be set.
      const_set_lazy(:GroupTail) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :local_index
        alias_method :attr_local_index, :local_index
        undef_method :local_index
        alias_method :attr_local_index=, :local_index=
        undef_method :local_index=
        
        attr_accessor :group_index
        alias_method :attr_group_index, :group_index
        undef_method :group_index
        alias_method :attr_group_index=, :group_index=
        undef_method :group_index=
        
        typesig { [::Java::Int, ::Java::Int] }
        def initialize(local_count, group_count)
          @local_index = 0
          @group_index = 0
          super()
          @local_index = local_count
          @group_index = group_count + group_count
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          tmp = matcher.attr_locals[@local_index]
          if (tmp >= 0)
            # This is the normal group case.
            # Save the group so we can unset it if it
            # backs off of a match.
            group_start = matcher.attr_groups[@group_index]
            group_end = matcher.attr_groups[@group_index + 1]
            matcher.attr_groups[@group_index] = tmp
            matcher.attr_groups[@group_index + 1] = i
            if (self.attr_next.match(matcher, i, seq))
              return true
            end
            matcher.attr_groups[@group_index] = group_start
            matcher.attr_groups[@group_index + 1] = group_end
            return false
          else
            # This is a group reference case. We don't need to save any
            # group info because it isn't really a group.
            matcher.attr_last = i
            return true
          end
        end
        
        private
        alias_method :initialize__group_tail, :initialize
      end }
      
      # This sets up a loop to handle a recursive quantifier structure.
      const_set_lazy(:Prolog) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :loop
        alias_method :attr_loop, :loop
        undef_method :loop
        alias_method :attr_loop=, :loop=
        undef_method :loop=
        
        typesig { [class_self::Loop] }
        def initialize(loop)
          @loop = nil
          super()
          @loop = loop
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          return @loop.match_init(matcher, i, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          return @loop.study(info)
        end
        
        private
        alias_method :initialize__prolog, :initialize
      end }
      
      # Handles the repetition count for a greedy Curly. The matchInit
      # is called from the Prolog to save the index of where the group
      # beginning is stored. A zero length group check occurs in the
      # normal match but is skipped in the matchInit.
      const_set_lazy(:Loop) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :body
        alias_method :attr_body, :body
        undef_method :body
        alias_method :attr_body=, :body=
        undef_method :body=
        
        attr_accessor :count_index
        alias_method :attr_count_index, :count_index
        undef_method :count_index
        alias_method :attr_count_index=, :count_index=
        undef_method :count_index=
        
        # local count index in matcher locals
        attr_accessor :begin_index
        alias_method :attr_begin_index, :begin_index
        undef_method :begin_index
        alias_method :attr_begin_index=, :begin_index=
        undef_method :begin_index=
        
        # group beginning index
        attr_accessor :cmin
        alias_method :attr_cmin, :cmin
        undef_method :cmin
        alias_method :attr_cmin=, :cmin=
        undef_method :cmin=
        
        attr_accessor :cmax
        alias_method :attr_cmax, :cmax
        undef_method :cmax
        alias_method :attr_cmax=, :cmax=
        undef_method :cmax=
        
        typesig { [::Java::Int, ::Java::Int] }
        def initialize(count_index, begin_index)
          @body = nil
          @count_index = 0
          @begin_index = 0
          @cmin = 0
          @cmax = 0
          super()
          @count_index = count_index
          @begin_index = begin_index
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          # Avoid infinite loop in zero-length case.
          if (i > matcher.attr_locals[@begin_index])
            count = matcher.attr_locals[@count_index]
            # This block is for before we reach the minimum
            # iterations required for the loop to match
            if (count < @cmin)
              matcher.attr_locals[@count_index] = count + 1
              b = @body.match(matcher, i, seq)
              # If match failed we must backtrack, so
              # the loop count should NOT be incremented
              if (!b)
                matcher.attr_locals[@count_index] = count
              end
              # Return success or failure since we are under
              # minimum
              return b
            end
            # This block is for after we have the minimum
            # iterations required for the loop to match
            if (count < @cmax)
              matcher.attr_locals[@count_index] = count + 1
              b = @body.match(matcher, i, seq)
              # If match failed we must backtrack, so
              # the loop count should NOT be incremented
              if (!b)
                matcher.attr_locals[@count_index] = count
              else
                return true
              end
            end
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match_init(matcher, i, seq)
          save = matcher.attr_locals[@count_index]
          ret = false
          if (0 < @cmin)
            matcher.attr_locals[@count_index] = 1
            ret = @body.match(matcher, i, seq)
          else
            if (0 < @cmax)
              matcher.attr_locals[@count_index] = 1
              ret = @body.match(matcher, i, seq)
              if ((ret).equal?(false))
                ret = self.attr_next.match(matcher, i, seq)
              end
            else
              ret = self.attr_next.match(matcher, i, seq)
            end
          end
          matcher.attr_locals[@count_index] = save
          return ret
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          info.attr_max_valid = false
          info.attr_deterministic = false
          return false
        end
        
        private
        alias_method :initialize__loop, :initialize
      end }
      
      # Handles the repetition count for a reluctant Curly. The matchInit
      # is called from the Prolog to save the index of where the group
      # beginning is stored. A zero length group check occurs in the
      # normal match but is skipped in the matchInit.
      const_set_lazy(:LazyLoop) { Class.new(Loop) do
        include_class_members Pattern
        
        typesig { [::Java::Int, ::Java::Int] }
        def initialize(count_index, begin_index)
          super(count_index, begin_index)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          # Check for zero length group
          if (i > matcher.attr_locals[self.attr_begin_index])
            count = matcher.attr_locals[self.attr_count_index]
            if (count < self.attr_cmin)
              matcher.attr_locals[self.attr_count_index] = count + 1
              result = self.attr_body.match(matcher, i, seq)
              # If match failed we must backtrack, so
              # the loop count should NOT be incremented
              if (!result)
                matcher.attr_locals[self.attr_count_index] = count
              end
              return result
            end
            if (self.attr_next.match(matcher, i, seq))
              return true
            end
            if (count < self.attr_cmax)
              matcher.attr_locals[self.attr_count_index] = count + 1
              result = self.attr_body.match(matcher, i, seq)
              # If match failed we must backtrack, so
              # the loop count should NOT be incremented
              if (!result)
                matcher.attr_locals[self.attr_count_index] = count
              end
              return result
            end
            return false
          end
          return self.attr_next.match(matcher, i, seq)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match_init(matcher, i, seq)
          save = matcher.attr_locals[self.attr_count_index]
          ret = false
          if (0 < self.attr_cmin)
            matcher.attr_locals[self.attr_count_index] = 1
            ret = self.attr_body.match(matcher, i, seq)
          else
            if (self.attr_next.match(matcher, i, seq))
              ret = true
            else
              if (0 < self.attr_cmax)
                matcher.attr_locals[self.attr_count_index] = 1
                ret = self.attr_body.match(matcher, i, seq)
              end
            end
          end
          matcher.attr_locals[self.attr_count_index] = save
          return ret
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          info.attr_max_valid = false
          info.attr_deterministic = false
          return false
        end
        
        private
        alias_method :initialize__lazy_loop, :initialize
      end }
      
      # Refers to a group in the regular expression. Attempts to match
      # whatever the group referred to last matched.
      const_set_lazy(:BackRef) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :group_index
        alias_method :attr_group_index, :group_index
        undef_method :group_index
        alias_method :attr_group_index=, :group_index=
        undef_method :group_index=
        
        typesig { [::Java::Int] }
        def initialize(group_count)
          @group_index = 0
          super()
          @group_index = group_count + group_count
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          j = matcher.attr_groups[@group_index]
          k = matcher.attr_groups[@group_index + 1]
          group_size = k - j
          # If the referenced group didn't match, neither can this
          if (j < 0)
            return false
          end
          # If there isn't enough input left no match
          if (i + group_size > matcher.attr_to)
            matcher.attr_hit_end = true
            return false
          end
          # Check each new char to make sure it matches what the group
          # referenced matched last time around
          index = 0
          while index < group_size
            if (!(seq.char_at(i + index)).equal?(seq.char_at(j + index)))
              return false
            end
            index += 1
          end
          return self.attr_next.match(matcher, i + group_size, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          info.attr_max_valid = false
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__back_ref, :initialize
      end }
      
      const_set_lazy(:CIBackRef) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :group_index
        alias_method :attr_group_index, :group_index
        undef_method :group_index
        alias_method :attr_group_index=, :group_index=
        undef_method :group_index=
        
        attr_accessor :do_unicode_case
        alias_method :attr_do_unicode_case, :do_unicode_case
        undef_method :do_unicode_case
        alias_method :attr_do_unicode_case=, :do_unicode_case=
        undef_method :do_unicode_case=
        
        typesig { [::Java::Int, ::Java::Boolean] }
        def initialize(group_count, do_unicode_case)
          @group_index = 0
          @do_unicode_case = false
          super()
          @group_index = group_count + group_count
          @do_unicode_case = do_unicode_case
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          j = matcher.attr_groups[@group_index]
          k = matcher.attr_groups[@group_index + 1]
          group_size = k - j
          # If the referenced group didn't match, neither can this
          if (j < 0)
            return false
          end
          # If there isn't enough input left no match
          if (i + group_size > matcher.attr_to)
            matcher.attr_hit_end = true
            return false
          end
          # Check each new char to make sure it matches what the group
          # referenced matched last time around
          x = i
          index = 0
          while index < group_size
            c1 = Character.code_point_at(seq, x)
            c2 = Character.code_point_at(seq, j)
            if (!(c1).equal?(c2))
              if (@do_unicode_case)
                cc1 = Character.to_upper_case(c1)
                cc2 = Character.to_upper_case(c2)
                if (!(cc1).equal?(cc2) && !(Character.to_lower_case(cc1)).equal?(Character.to_lower_case(cc2)))
                  return false
                end
              else
                if (!(ASCII.to_lower(c1)).equal?(ASCII.to_lower(c2)))
                  return false
                end
              end
            end
            x += Character.char_count(c1)
            j += Character.char_count(c2)
            index += 1
          end
          return self.attr_next.match(matcher, i + group_size, seq)
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          info.attr_max_valid = false
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__ciback_ref, :initialize
      end }
      
      # Searches until the next instance of its atom. This is useful for
      # finding the atom efficiently without passing an instance of it
      # (greedy problem) and without a lot of wasted search time (reluctant
      # problem).
      const_set_lazy(:First) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :atom
        alias_method :attr_atom, :atom
        undef_method :atom
        alias_method :attr_atom=, :atom=
        undef_method :atom=
        
        typesig { [class_self::Node] }
        def initialize(node)
          @atom = nil
          super()
          @atom = BnM.optimize(node)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          if (@atom.is_a?(self.class::BnM))
            return @atom.match(matcher, i, seq) && self.attr_next.match(matcher, matcher.attr_last, seq)
          end
          loop do
            if (i > matcher.attr_to)
              matcher.attr_hit_end = true
              return false
            end
            if (@atom.match(matcher, i, seq))
              return self.attr_next.match(matcher, matcher.attr_last, seq)
            end
            i += count_chars(seq, i, 1)
            matcher.attr_first += 1
          end
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          @atom.study(info)
          info.attr_max_valid = false
          info.attr_deterministic = false
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__first, :initialize
      end }
      
      const_set_lazy(:Conditional) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :cond
        alias_method :attr_cond, :cond
        undef_method :cond
        alias_method :attr_cond=, :cond=
        undef_method :cond=
        
        attr_accessor :yes
        alias_method :attr_yes, :yes
        undef_method :yes
        alias_method :attr_yes=, :yes=
        undef_method :yes=
        
        attr_accessor :not
        alias_method :attr_not, :not
        undef_method :not
        alias_method :attr_not=, :not=
        undef_method :not=
        
        typesig { [class_self::Node, class_self::Node, class_self::Node] }
        def initialize(cond, yes, not_)
          @cond = nil
          @yes = nil
          @not = nil
          super()
          @cond = cond
          @yes = yes
          @not = not_
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          if (@cond.match(matcher, i, seq))
            return @yes.match(matcher, i, seq)
          else
            return @not.match(matcher, i, seq)
          end
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          min_l = info.attr_min_length
          max_l = info.attr_max_length
          max_v = info.attr_max_valid
          info.reset
          @yes.study(info)
          min_l2 = info.attr_min_length
          max_l2 = info.attr_max_length
          max_v2 = info.attr_max_valid
          info.reset
          @not.study(info)
          info.attr_min_length = min_l + Math.min(min_l2, info.attr_min_length)
          info.attr_max_length = max_l + Math.max(max_l2, info.attr_max_length)
          info.attr_max_valid = (max_v & max_v2 & info.attr_max_valid)
          info.attr_deterministic = false
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__conditional, :initialize
      end }
      
      # Zero width positive lookahead.
      const_set_lazy(:Pos) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :cond
        alias_method :attr_cond, :cond
        undef_method :cond
        alias_method :attr_cond=, :cond=
        undef_method :cond=
        
        typesig { [class_self::Node] }
        def initialize(cond)
          @cond = nil
          super()
          @cond = cond
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          saved_to = matcher.attr_to
          condition_matched = false
          # Relax transparent region boundaries for lookahead
          if (matcher.attr_transparent_bounds)
            matcher.attr_to = matcher.get_text_length
          end
          begin
            condition_matched = @cond.match(matcher, i, seq)
          ensure
            # Reinstate region boundaries
            matcher.attr_to = saved_to
          end
          return condition_matched && self.attr_next.match(matcher, i, seq)
        end
        
        private
        alias_method :initialize__pos, :initialize
      end }
      
      # Zero width negative lookahead.
      const_set_lazy(:Neg) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :cond
        alias_method :attr_cond, :cond
        undef_method :cond
        alias_method :attr_cond=, :cond=
        undef_method :cond=
        
        typesig { [class_self::Node] }
        def initialize(cond)
          @cond = nil
          super()
          @cond = cond
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          saved_to = matcher.attr_to
          condition_matched = false
          # Relax transparent region boundaries for lookahead
          if (matcher.attr_transparent_bounds)
            matcher.attr_to = matcher.get_text_length
          end
          begin
            if (i < matcher.attr_to)
              condition_matched = !@cond.match(matcher, i, seq)
            else
              # If a negative lookahead succeeds then more input
              # could cause it to fail!
              matcher.attr_require_end = true
              condition_matched = !@cond.match(matcher, i, seq)
            end
          ensure
            # Reinstate region boundaries
            matcher.attr_to = saved_to
          end
          return condition_matched && self.attr_next.match(matcher, i, seq)
        end
        
        private
        alias_method :initialize__neg, :initialize
      end }
      
      
      def lookbehind_end
        defined?(@@lookbehind_end) ? @@lookbehind_end : @@lookbehind_end= # For use with lookbehinds; matches the position where the lookbehind
        # was encountered.
        Class.new(Node.class == Class ? Node : Object) do
          extend LocalClass
          include_class_members Pattern
          include Node if Node.class == Module
          
          typesig { [Matcher, ::Java::Int, CharSequence] }
          define_method :match do |matcher, i, seq|
            return (i).equal?(matcher.attr_lookbehind_to)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      alias_method :attr_lookbehind_end, :lookbehind_end
      
      def lookbehind_end=(value)
        @@lookbehind_end = value
      end
      alias_method :attr_lookbehind_end=, :lookbehind_end=
      
      # Zero width positive lookbehind.
      const_set_lazy(:Behind) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :cond
        alias_method :attr_cond, :cond
        undef_method :cond
        alias_method :attr_cond=, :cond=
        undef_method :cond=
        
        attr_accessor :rmax
        alias_method :attr_rmax, :rmax
        undef_method :rmax
        alias_method :attr_rmax=, :rmax=
        undef_method :rmax=
        
        attr_accessor :rmin
        alias_method :attr_rmin, :rmin
        undef_method :rmin
        alias_method :attr_rmin=, :rmin=
        undef_method :rmin=
        
        typesig { [class_self::Node, ::Java::Int, ::Java::Int] }
        def initialize(cond, rmax, rmin)
          @cond = nil
          @rmax = 0
          @rmin = 0
          super()
          @cond = cond
          @rmax = rmax
          @rmin = rmin
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          saved_from = matcher.attr_from
          condition_matched = false
          start_index = (!matcher.attr_transparent_bounds) ? matcher.attr_from : 0
          from = Math.max(i - @rmax, start_index)
          # Set end boundary
          saved_lbt = matcher.attr_lookbehind_to
          matcher.attr_lookbehind_to = i
          # Relax transparent region boundaries for lookbehind
          if (matcher.attr_transparent_bounds)
            matcher.attr_from = 0
          end
          j = i - @rmin
          while !condition_matched && j >= from
            condition_matched = @cond.match(matcher, j, seq)
            j -= 1
          end
          matcher.attr_from = saved_from
          matcher.attr_lookbehind_to = saved_lbt
          return condition_matched && self.attr_next.match(matcher, i, seq)
        end
        
        private
        alias_method :initialize__behind, :initialize
      end }
      
      # Zero width positive lookbehind, including supplementary
      # characters or unpaired surrogates.
      const_set_lazy(:BehindS) { Class.new(Behind) do
        include_class_members Pattern
        
        typesig { [class_self::Node, ::Java::Int, ::Java::Int] }
        def initialize(cond, rmax, rmin)
          super(cond, rmax, rmin)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          rmax_chars = count_chars(seq, i, -self.attr_rmax)
          rmin_chars = count_chars(seq, i, -self.attr_rmin)
          saved_from = matcher.attr_from
          start_index = (!matcher.attr_transparent_bounds) ? matcher.attr_from : 0
          condition_matched = false
          from = Math.max(i - rmax_chars, start_index)
          # Set end boundary
          saved_lbt = matcher.attr_lookbehind_to
          matcher.attr_lookbehind_to = i
          # Relax transparent region boundaries for lookbehind
          if (matcher.attr_transparent_bounds)
            matcher.attr_from = 0
          end
          j = i - rmin_chars
          while !condition_matched && j >= from
            condition_matched = self.attr_cond.match(matcher, j, seq)
            j -= j > from ? count_chars(seq, j, -1) : 1
          end
          matcher.attr_from = saved_from
          matcher.attr_lookbehind_to = saved_lbt
          return condition_matched && self.attr_next.match(matcher, i, seq)
        end
        
        private
        alias_method :initialize__behind_s, :initialize
      end }
      
      # Zero width negative lookbehind.
      const_set_lazy(:NotBehind) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :cond
        alias_method :attr_cond, :cond
        undef_method :cond
        alias_method :attr_cond=, :cond=
        undef_method :cond=
        
        attr_accessor :rmax
        alias_method :attr_rmax, :rmax
        undef_method :rmax
        alias_method :attr_rmax=, :rmax=
        undef_method :rmax=
        
        attr_accessor :rmin
        alias_method :attr_rmin, :rmin
        undef_method :rmin
        alias_method :attr_rmin=, :rmin=
        undef_method :rmin=
        
        typesig { [class_self::Node, ::Java::Int, ::Java::Int] }
        def initialize(cond, rmax, rmin)
          @cond = nil
          @rmax = 0
          @rmin = 0
          super()
          @cond = cond
          @rmax = rmax
          @rmin = rmin
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          saved_lbt = matcher.attr_lookbehind_to
          saved_from = matcher.attr_from
          condition_matched = false
          start_index = (!matcher.attr_transparent_bounds) ? matcher.attr_from : 0
          from = Math.max(i - @rmax, start_index)
          matcher.attr_lookbehind_to = i
          # Relax transparent region boundaries for lookbehind
          if (matcher.attr_transparent_bounds)
            matcher.attr_from = 0
          end
          j = i - @rmin
          while !condition_matched && j >= from
            condition_matched = @cond.match(matcher, j, seq)
            j -= 1
          end
          # Reinstate region boundaries
          matcher.attr_from = saved_from
          matcher.attr_lookbehind_to = saved_lbt
          return !condition_matched && self.attr_next.match(matcher, i, seq)
        end
        
        private
        alias_method :initialize__not_behind, :initialize
      end }
      
      # Zero width negative lookbehind, including supplementary
      # characters or unpaired surrogates.
      const_set_lazy(:NotBehindS) { Class.new(NotBehind) do
        include_class_members Pattern
        
        typesig { [class_self::Node, ::Java::Int, ::Java::Int] }
        def initialize(cond, rmax, rmin)
          super(cond, rmax, rmin)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          rmax_chars = count_chars(seq, i, -self.attr_rmax)
          rmin_chars = count_chars(seq, i, -self.attr_rmin)
          saved_from = matcher.attr_from
          saved_lbt = matcher.attr_lookbehind_to
          condition_matched = false
          start_index = (!matcher.attr_transparent_bounds) ? matcher.attr_from : 0
          from = Math.max(i - rmax_chars, start_index)
          matcher.attr_lookbehind_to = i
          # Relax transparent region boundaries for lookbehind
          if (matcher.attr_transparent_bounds)
            matcher.attr_from = 0
          end
          j = i - rmin_chars
          while !condition_matched && j >= from
            condition_matched = self.attr_cond.match(matcher, j, seq)
            j -= j > from ? count_chars(seq, j, -1) : 1
          end
          # Reinstate region boundaries
          matcher.attr_from = saved_from
          matcher.attr_lookbehind_to = saved_lbt
          return !condition_matched && self.attr_next.match(matcher, i, seq)
        end
        
        private
        alias_method :initialize__not_behind_s, :initialize
      end }
      
      typesig { [CharProperty, CharProperty] }
      # Returns the set union of two CharProperty nodes.
      def union(lhs, rhs)
        return Class.new(CharProperty.class == Class ? CharProperty : Object) do
          extend LocalClass
          include_class_members Pattern
          include CharProperty if CharProperty.class == Module
          
          typesig { [::Java::Int] }
          define_method :is_satisfied_by do |ch|
            return lhs.is_satisfied_by(ch) || rhs.is_satisfied_by(ch)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [CharProperty, CharProperty] }
      # Returns the set intersection of two CharProperty nodes.
      def intersection(lhs, rhs)
        return Class.new(CharProperty.class == Class ? CharProperty : Object) do
          extend LocalClass
          include_class_members Pattern
          include CharProperty if CharProperty.class == Module
          
          typesig { [::Java::Int] }
          define_method :is_satisfied_by do |ch|
            return lhs.is_satisfied_by(ch) && rhs.is_satisfied_by(ch)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      typesig { [CharProperty, CharProperty] }
      # Returns the set difference of two CharProperty nodes.
      def set_difference(lhs, rhs)
        return Class.new(CharProperty.class == Class ? CharProperty : Object) do
          extend LocalClass
          include_class_members Pattern
          include CharProperty if CharProperty.class == Module
          
          typesig { [::Java::Int] }
          define_method :is_satisfied_by do |ch|
            return !rhs.is_satisfied_by(ch) && lhs.is_satisfied_by(ch)
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      # Handles word boundaries. Includes a field to allow this one class to
      # deal with the different types of word boundaries we can match. The word
      # characters include underscores, letters, and digits. Non spacing marks
      # can are also part of a word if they have a base character, otherwise
      # they are ignored for purposes of finding word boundaries.
      const_set_lazy(:Bound) { Class.new(Node) do
        include_class_members Pattern
        
        class_module.module_eval {
          
          def left
            defined?(@@left) ? @@left : @@left= 0x1
          end
          alias_method :attr_left, :left
          
          def left=(value)
            @@left = value
          end
          alias_method :attr_left=, :left=
          
          
          def right
            defined?(@@right) ? @@right : @@right= 0x2
          end
          alias_method :attr_right, :right
          
          def right=(value)
            @@right = value
          end
          alias_method :attr_right=, :right=
          
          
          def both
            defined?(@@both) ? @@both : @@both= 0x3
          end
          alias_method :attr_both, :both
          
          def both=(value)
            @@both = value
          end
          alias_method :attr_both=, :both=
          
          
          def none
            defined?(@@none) ? @@none : @@none= 0x4
          end
          alias_method :attr_none, :none
          
          def none=(value)
            @@none = value
          end
          alias_method :attr_none=, :none=
        }
        
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        typesig { [::Java::Int] }
        def initialize(n)
          @type = 0
          super()
          @type = n
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def check(matcher, i, seq)
          ch = 0
          left = false
          start_index = matcher.attr_from
          end_index = matcher.attr_to
          if (matcher.attr_transparent_bounds)
            start_index = 0
            end_index = matcher.get_text_length
          end
          if (i > start_index)
            ch = Character.code_point_before(seq, i)
            left = ((ch).equal?(Character.new(?_.ord)) || Character.is_letter_or_digit(ch) || (((Character.get_type(ch)).equal?(Character::NON_SPACING_MARK)) && has_base_character(matcher, i - 1, seq)))
          end
          right = false
          if (i < end_index)
            ch = Character.code_point_at(seq, i)
            right = ((ch).equal?(Character.new(?_.ord)) || Character.is_letter_or_digit(ch) || (((Character.get_type(ch)).equal?(Character::NON_SPACING_MARK)) && has_base_character(matcher, i, seq)))
          else
            # Tried to access char past the end
            matcher.attr_hit_end = true
            # The addition of another char could wreck a boundary
            matcher.attr_require_end = true
          end
          return ((left ^ right) ? (right ? self.attr_left : self.attr_right) : self.attr_none)
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          return (check(matcher, i, seq) & @type) > 0 && self.attr_next.match(matcher, i, seq)
        end
        
        private
        alias_method :initialize__bound, :initialize
      end }
      
      typesig { [Matcher, ::Java::Int, CharSequence] }
      # Non spacing marks only count as word characters in bounds calculations
      # if they have a base character.
      def has_base_character(matcher_, i, seq)
        start_ = (!matcher_.attr_transparent_bounds) ? matcher_.attr_from : 0
        x_ = i
        while x_ >= start_
          ch = Character.code_point_at(seq, x_)
          if (Character.is_letter_or_digit(ch))
            return true
          end
          if ((Character.get_type(ch)).equal?(Character::NON_SPACING_MARK))
            x_ -= 1
            next
          end
          return false
          x_ -= 1
        end
        return false
      end
      
      # Attempts to match a slice in the input using the Boyer-Moore string
      # matching algorithm. The algorithm is based on the idea that the
      # pattern can be shifted farther ahead in the search text if it is
      # matched right to left.
      # <p>
      # The pattern is compared to the input one character at a time, from
      # the rightmost character in the pattern to the left. If the characters
      # all match the pattern has been found. If a character does not match,
      # the pattern is shifted right a distance that is the maximum of two
      # functions, the bad character shift and the good suffix shift. This
      # shift moves the attempted match position through the input more
      # quickly than a naive one position at a time check.
      # <p>
      # The bad character shift is based on the character from the text that
      # did not match. If the character does not appear in the pattern, the
      # pattern can be shifted completely beyond the bad character. If the
      # character does occur in the pattern, the pattern can be shifted to
      # line the pattern up with the next occurrence of that character.
      # <p>
      # The good suffix shift is based on the idea that some subset on the right
      # side of the pattern has matched. When a bad character is found, the
      # pattern can be shifted right by the pattern length if the subset does
      # not occur again in pattern, or by the amount of distance to the
      # next occurrence of the subset in the pattern.
      # 
      # Boyer-Moore search methods adapted from code by Amy Yu.
      const_set_lazy(:BnM) { Class.new(Node) do
        include_class_members Pattern
        
        attr_accessor :buffer
        alias_method :attr_buffer, :buffer
        undef_method :buffer
        alias_method :attr_buffer=, :buffer=
        undef_method :buffer=
        
        attr_accessor :last_occ
        alias_method :attr_last_occ, :last_occ
        undef_method :last_occ
        alias_method :attr_last_occ=, :last_occ=
        undef_method :last_occ=
        
        attr_accessor :opto_sft
        alias_method :attr_opto_sft, :opto_sft
        undef_method :opto_sft
        alias_method :attr_opto_sft=, :opto_sft=
        undef_method :opto_sft=
        
        class_module.module_eval {
          typesig { [class_self::Node] }
          # Pre calculates arrays needed to generate the bad character
          # shift and the good suffix shift. Only the last seven bits
          # are used to see if chars match; This keeps the tables small
          # and covers the heavily used ASCII range, but occasionally
          # results in an aliased match for the bad character shift.
          def optimize(node)
            if (!(node.is_a?(class_self::Slice)))
              return node
            end
            src = (node).attr_buffer
            pattern_length = src.attr_length
            # The BM algorithm requires a bit of overhead;
            # If the pattern is short don't use it, since
            # a shift larger than the pattern length cannot
            # be used anyway.
            if (pattern_length < 4)
              return node
            end
            i = 0
            j = 0
            k = 0
            last_occ = Array.typed(::Java::Int).new(128) { 0 }
            opto_sft = Array.typed(::Java::Int).new(pattern_length) { 0 }
            # Precalculate part of the bad character shift
            # It is a table for where in the pattern each
            # lower 7-bit value occurs
            i = 0
            while i < pattern_length
              last_occ[src[i] & 0x7f] = i + 1
              i += 1
            end
            # Precalculate the good suffix shift
            # i is the shift amount being considered
            i = pattern_length
            while i > 0
              catch(:next_next) do
                # j is the beginning index of suffix being considered
                j = pattern_length - 1
                while j >= i
                  # Testing for good suffix
                  if ((src[j]).equal?(src[j - i]))
                    # src[j..len] is a good suffix
                    opto_sft[j - 1] = i
                  else
                    # No match. The array has already been
                    # filled up with correct values before.
                    throw :next_next, :thrown
                  end
                  j -= 1
                end
                # This fills up the remaining of optoSft
                # any suffix can not have larger shift amount
                # then its sub-suffix. Why???
                while (j > 0)
                  opto_sft[(j -= 1)] = i
                end
              end
              i -= 1
            end
            # Set the guard value because of unicode compression
            opto_sft[pattern_length - 1] = 1
            if (node.is_a?(class_self::SliceS))
              return class_self::BnMS.new(src, last_occ, opto_sft, node.attr_next)
            end
            return class_self::BnM.new(src, last_occ, opto_sft, node.attr_next)
          end
        }
        
        typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int), Array.typed(::Java::Int), class_self::Node] }
        def initialize(src, last_occ, opto_sft, next_)
          @buffer = nil
          @last_occ = nil
          @opto_sft = nil
          super()
          @buffer = src
          @last_occ = last_occ
          @opto_sft = opto_sft
          self.attr_next = next_
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          src = @buffer
          pattern_length = src.attr_length
          last = matcher.attr_to - pattern_length
          # Loop over all possible match positions in text
          while (i <= last)
            catch(:next_next) do
              # Loop over pattern from right to left
              j = pattern_length - 1
              while j >= 0
                ch = seq.char_at(i + j)
                if (!(ch).equal?(src[j]))
                  # Shift search to the right by the maximum of the
                  # bad character shift and the good suffix shift
                  i += Math.max(j + 1 - @last_occ[ch & 0x7f], @opto_sft[j])
                  throw :next_next, :thrown
                end
                j -= 1
              end
              # Entire pattern matched starting at i
              matcher.attr_first = i
              ret = self.attr_next.match(matcher, i + pattern_length, seq)
              if (ret)
                matcher.attr_first = i
                matcher.attr_groups[0] = matcher.attr_first
                matcher.attr_groups[1] = matcher.attr_last
                return true
              end
              i += 1
            end
          end
          # BnM is only used as the leading node in the unanchored case,
          # and it replaced its Start() which always searches to the end
          # if it doesn't find what it's looking for, so hitEnd is true.
          matcher.attr_hit_end = true
          return false
        end
        
        typesig { [class_self::TreeInfo] }
        def study(info)
          info.attr_min_length += @buffer.attr_length
          info.attr_max_valid = false
          return self.attr_next.study(info)
        end
        
        private
        alias_method :initialize__bn_m, :initialize
      end }
      
      # Supplementary support version of BnM(). Unpaired surrogates are
      # also handled by this class.
      const_set_lazy(:BnMS) { Class.new(BnM) do
        include_class_members Pattern
        
        attr_accessor :length_in_chars
        alias_method :attr_length_in_chars, :length_in_chars
        undef_method :length_in_chars
        alias_method :attr_length_in_chars=, :length_in_chars=
        undef_method :length_in_chars=
        
        typesig { [Array.typed(::Java::Int), Array.typed(::Java::Int), Array.typed(::Java::Int), class_self::Node] }
        def initialize(src, last_occ, opto_sft, next_)
          @length_in_chars = 0
          super(src, last_occ, opto_sft, next_)
          x = 0
          while x < self.attr_buffer.attr_length
            @length_in_chars += Character.char_count(self.attr_buffer[x])
            x += 1
          end
        end
        
        typesig { [class_self::Matcher, ::Java::Int, class_self::CharSequence] }
        def match(matcher, i, seq)
          src = self.attr_buffer
          pattern_length = src.attr_length
          last = matcher.attr_to - @length_in_chars
          # Loop over all possible match positions in text
          while (i <= last)
            catch(:next_next) do
              # Loop over pattern from right to left
              ch = 0
              j = count_chars(seq, i, pattern_length)
              x = pattern_length - 1
              while j > 0
                ch = Character.code_point_before(seq, i + j)
                if (!(ch).equal?(src[x]))
                  # Shift search to the right by the maximum of the
                  # bad character shift and the good suffix shift
                  n = Math.max(x + 1 - self.attr_last_occ[ch & 0x7f], self.attr_opto_sft[x])
                  i += count_chars(seq, i, n)
                  throw :next_next, :thrown
                end
                j -= Character.char_count(ch)
                x -= 1
              end
              # Entire pattern matched starting at i
              matcher.attr_first = i
              ret = self.attr_next.match(matcher, i + @length_in_chars, seq)
              if (ret)
                matcher.attr_first = i
                matcher.attr_groups[0] = matcher.attr_first
                matcher.attr_groups[1] = matcher.attr_last
                return true
              end
              i += count_chars(seq, i, 1)
            end
          end
          matcher.attr_hit_end = true
          return false
        end
        
        private
        alias_method :initialize__bn_ms, :initialize
      end }
      
      # /////////////////////////////////////////////////////////////////////////////
      # /////////////////////////////////////////////////////////////////////////////
      # 
      # This must be the very first initializer.
      
      def accept
        defined?(@@accept) ? @@accept : @@accept= Node.new
      end
      alias_method :attr_accept, :accept
      
      def accept=(value)
        @@accept = value
      end
      alias_method :attr_accept=, :accept=
      
      
      def last_accept
        defined?(@@last_accept) ? @@last_accept : @@last_accept= LastNode.new
      end
      alias_method :attr_last_accept, :last_accept
      
      def last_accept=(value)
        @@last_accept = value
      end
      alias_method :attr_last_accept=, :last_accept=
      
      const_set_lazy(:CharPropertyNames) { Class.new do
        include_class_members Pattern
        
        class_module.module_eval {
          typesig { [String] }
          def char_property_for(name)
            m = self.class::Map.get(name)
            return (m).nil? ? nil : m.make
          end
          
          const_set_lazy(:CharPropertyFactory) { Class.new do
            include_class_members CharPropertyNames
            
            typesig { [] }
            def make
              raise NotImplementedError
            end
            
            typesig { [] }
            def initialize
            end
            
            private
            alias_method :initialize__char_property_factory, :initialize
          end }
          
          typesig { [String, ::Java::Int] }
          def def_category(name, type_mask)
            self.class::Map.put(name, Class.new(class_self::CharPropertyFactory.class == Class ? class_self::CharPropertyFactory : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CharPropertyFactory if class_self::CharPropertyFactory.class == Module
              
              typesig { [] }
              define_method :make do
                return self.class::Category.new(type_mask)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
          
          typesig { [String, ::Java::Int, ::Java::Int] }
          def def_range(name, lower, upper)
            self.class::Map.put(name, Class.new(class_self::CharPropertyFactory.class == Class ? class_self::CharPropertyFactory : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CharPropertyFactory if class_self::CharPropertyFactory.class == Module
              
              typesig { [] }
              define_method :make do
                return range_for(lower, upper)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
          
          typesig { [String, ::Java::Int] }
          def def_ctype(name, ctype)
            self.class::Map.put(name, Class.new(class_self::CharPropertyFactory.class == Class ? class_self::CharPropertyFactory : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CharPropertyFactory if class_self::CharPropertyFactory.class == Module
              
              typesig { [] }
              define_method :make do
                return self.class::Ctype.new(ctype)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
          
          const_set_lazy(:CloneableProperty) { Class.new(class_self::CharProperty) do
            include_class_members CharPropertyNames
            overload_protected {
              include class_self::Cloneable
            }
            
            typesig { [] }
            def clone
              begin
                return super
              rescue self.class::CloneNotSupportedException => e
                raise self.class::AssertionError.new(e)
              end
            end
            
            typesig { [] }
            def initialize
              super()
            end
            
            private
            alias_method :initialize__cloneable_property, :initialize
          end }
          
          typesig { [String, class_self::CloneableProperty] }
          def def_clone(name, p)
            self.class::Map.put(name, Class.new(class_self::CharPropertyFactory.class == Class ? class_self::CharPropertyFactory : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CharPropertyFactory if class_self::CharPropertyFactory.class == Module
              
              typesig { [] }
              define_method :make do
                return p.clone
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
          
          const_set_lazy(:Map) { class_self::HashMap.new }
          const_attr_reader  :Map
          
          when_class_loaded do
            # Unicode character property aliases, defined in
            # http://www.unicode.org/Public/UNIDATA/PropertyValueAliases.txt
            def_category("Cn", 1 << Character::UNASSIGNED)
            def_category("Lu", 1 << Character::UPPERCASE_LETTER)
            def_category("Ll", 1 << Character::LOWERCASE_LETTER)
            def_category("Lt", 1 << Character::TITLECASE_LETTER)
            def_category("Lm", 1 << Character::MODIFIER_LETTER)
            def_category("Lo", 1 << Character::OTHER_LETTER)
            def_category("Mn", 1 << Character::NON_SPACING_MARK)
            def_category("Me", 1 << Character::ENCLOSING_MARK)
            def_category("Mc", 1 << Character::COMBINING_SPACING_MARK)
            def_category("Nd", 1 << Character::DECIMAL_DIGIT_NUMBER)
            def_category("Nl", 1 << Character::LETTER_NUMBER)
            def_category("No", 1 << Character::OTHER_NUMBER)
            def_category("Zs", 1 << Character::SPACE_SEPARATOR)
            def_category("Zl", 1 << Character::LINE_SEPARATOR)
            def_category("Zp", 1 << Character::PARAGRAPH_SEPARATOR)
            def_category("Cc", 1 << Character::CONTROL)
            def_category("Cf", 1 << Character::FORMAT)
            def_category("Co", 1 << Character::PRIVATE_USE)
            def_category("Cs", 1 << Character::SURROGATE)
            def_category("Pd", 1 << Character::DASH_PUNCTUATION)
            def_category("Ps", 1 << Character::START_PUNCTUATION)
            def_category("Pe", 1 << Character::END_PUNCTUATION)
            def_category("Pc", 1 << Character::CONNECTOR_PUNCTUATION)
            def_category("Po", 1 << Character::OTHER_PUNCTUATION)
            def_category("Sm", 1 << Character::MATH_SYMBOL)
            def_category("Sc", 1 << Character::CURRENCY_SYMBOL)
            def_category("Sk", 1 << Character::MODIFIER_SYMBOL)
            def_category("So", 1 << Character::OTHER_SYMBOL)
            def_category("Pi", 1 << Character::INITIAL_QUOTE_PUNCTUATION)
            def_category("Pf", 1 << Character::FINAL_QUOTE_PUNCTUATION)
            def_category("L", ((1 << Character::UPPERCASE_LETTER) | (1 << Character::LOWERCASE_LETTER) | (1 << Character::TITLECASE_LETTER) | (1 << Character::MODIFIER_LETTER) | (1 << Character::OTHER_LETTER)))
            def_category("M", ((1 << Character::NON_SPACING_MARK) | (1 << Character::ENCLOSING_MARK) | (1 << Character::COMBINING_SPACING_MARK)))
            def_category("N", ((1 << Character::DECIMAL_DIGIT_NUMBER) | (1 << Character::LETTER_NUMBER) | (1 << Character::OTHER_NUMBER)))
            def_category("Z", ((1 << Character::SPACE_SEPARATOR) | (1 << Character::LINE_SEPARATOR) | (1 << Character::PARAGRAPH_SEPARATOR)))
            def_category("C", ((1 << Character::CONTROL) | (1 << Character::FORMAT) | (1 << Character::PRIVATE_USE) | (1 << Character::SURROGATE))) # Other
            def_category("P", ((1 << Character::DASH_PUNCTUATION) | (1 << Character::START_PUNCTUATION) | (1 << Character::END_PUNCTUATION) | (1 << Character::CONNECTOR_PUNCTUATION) | (1 << Character::OTHER_PUNCTUATION) | (1 << Character::INITIAL_QUOTE_PUNCTUATION) | (1 << Character::FINAL_QUOTE_PUNCTUATION)))
            def_category("S", ((1 << Character::MATH_SYMBOL) | (1 << Character::CURRENCY_SYMBOL) | (1 << Character::MODIFIER_SYMBOL) | (1 << Character::OTHER_SYMBOL)))
            def_category("LC", ((1 << Character::UPPERCASE_LETTER) | (1 << Character::LOWERCASE_LETTER) | (1 << Character::TITLECASE_LETTER)))
            def_category("LD", ((1 << Character::UPPERCASE_LETTER) | (1 << Character::LOWERCASE_LETTER) | (1 << Character::TITLECASE_LETTER) | (1 << Character::MODIFIER_LETTER) | (1 << Character::OTHER_LETTER) | (1 << Character::DECIMAL_DIGIT_NUMBER)))
            def_range("L1", 0x0, 0xff) # Latin-1
            self.class::Map.put("all", Class.new(class_self::CharPropertyFactory.class == Class ? class_self::CharPropertyFactory : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CharPropertyFactory if class_self::CharPropertyFactory.class == Module
              
              typesig { [] }
              define_method :make do
                return self.class::All.new
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            # Posix regular expression character classes, defined in
            # http://www.unix.org/onlinepubs/009695399/basedefs/xbd_chap09.html
            def_range("ASCII", 0x0, 0x7f) # ASCII
            def_ctype("Alnum", ASCII::ALNUM) # Alphanumeric characters
            def_ctype("Alpha", ASCII::ALPHA) # Alphabetic characters
            def_ctype("Blank", ASCII::BLANK) # Space and tab characters
            def_ctype("Cntrl", ASCII::CNTRL) # Control characters
            def_range("Digit", Character.new(?0.ord), Character.new(?9.ord)) # Numeric characters
            def_ctype("Graph", ASCII::GRAPH) # printable and visible
            def_range("Lower", Character.new(?a.ord), Character.new(?z.ord)) # Lower-case alphabetic
            def_range("Print", 0x20, 0x7e) # Printable characters
            def_ctype("Punct", ASCII::PUNCT) # Punctuation characters
            def_ctype("Space", ASCII::SPACE) # Space characters
            def_range("Upper", Character.new(?A.ord), Character.new(?Z.ord)) # Upper-case alphabetic
            def_ctype("XDigit", ASCII::XDIGIT) # hexadecimal digits
            def_clone("javaLowerCase", # Java character properties, defined by methods in Character.java
            Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_lower_case(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaUpperCase", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_upper_case(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaTitleCase", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_title_case(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaDigit", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_digit(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaDefined", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_defined(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaLetter", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_letter(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaLetterOrDigit", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_letter_or_digit(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaJavaIdentifierStart", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_java_identifier_start(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaJavaIdentifierPart", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_java_identifier_part(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaUnicodeIdentifierStart", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_unicode_identifier_start(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaUnicodeIdentifierPart", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_unicode_identifier_part(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaIdentifierIgnorable", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_identifier_ignorable(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaSpaceChar", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_space_char(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaWhitespace", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_whitespace(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaISOControl", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_isocontrol(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
            def_clone("javaMirrored", Class.new(class_self::CloneableProperty.class == Class ? class_self::CloneableProperty : Object) do
              extend LocalClass
              include_class_members CharPropertyNames
              include class_self::CloneableProperty if class_self::CloneableProperty.class == Module
              
              typesig { [::Java::Int] }
              define_method :is_satisfied_by do |ch|
                return Character.is_mirrored(ch)
              end
              
              typesig { [Vararg.new(Object)] }
              define_method :initialize do |*args|
                super(*args)
              end
              
              private
              alias_method :initialize_anonymous, :initialize
            end.new_local(self))
          end
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__char_property_names, :initialize
      end }
    }
    
    private
    alias_method :initialize__pattern, :initialize
  end
  
end
