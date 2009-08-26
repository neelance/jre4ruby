require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module FormattableImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Java::Io, :IOException
    }
  end
  
  # The <tt>Formattable</tt> interface must be implemented by any class that
  # needs to perform custom formatting using the <tt>'s'</tt> conversion
  # specifier of {@link java.util.Formatter}.  This interface allows basic
  # control for formatting arbitrary objects.
  # 
  # For example, the following class prints out different representations of a
  # stock's name depending on the flags and length constraints:
  # 
  # <blockquote><pre>
  # import java.nio.CharBuffer;
  # import java.util.Formatter;
  # import java.util.Formattable;
  # import java.util.Locale;
  # import static java.util.FormattableFlags.*;
  # 
  # ...
  # 
  # public class StockName implements Formattable {
  # private String symbol, companyName, frenchCompanyName;
  # public StockName(String symbol, String companyName,
  # String frenchCompanyName) {
  # ...
  # }
  # 
  # ...
  # 
  # public void formatTo(Formatter fmt, int f, int width, int precision) {
  # StringBuilder sb = new StringBuilder();
  # 
  # // decide form of name
  # String name = companyName;
  # if (fmt.locale().equals(Locale.FRANCE))
  # name = frenchCompanyName;
  # boolean alternate = (f & ALTERNATE) == ALTERNATE;
  # boolean usesymbol = alternate || (precision != -1 && precision < 10);
  # String out = (usesymbol ? symbol : name);
  # 
  # // apply precision
  # if (precision == -1 || out.length() < precision) {
  # // write it all
  # sb.append(out);
  # } else {
  # sb.append(out.substring(0, precision - 1)).append('*');
  # }
  # 
  # // apply width and justification
  # int len = sb.length();
  # if (len < width)
  # for (int i = 0; i < width - len; i++)
  # if ((f & LEFT_JUSTIFY) == LEFT_JUSTIFY)
  # sb.append(' ');
  # else
  # sb.insert(0, ' ');
  # 
  # fmt.format(sb.toString());
  # }
  # 
  # public String toString() {
  # return String.format("%s - %s", symbol, companyName);
  # }
  # }
  # </pre></blockquote>
  # 
  # <p> When used in conjunction with the {@link java.util.Formatter}, the above
  # class produces the following output for various format strings.
  # 
  # <blockquote><pre>
  # Formatter fmt = new Formatter();
  # StockName sn = new StockName("HUGE", "Huge Fruit, Inc.",
  # "Fruit Titanesque, Inc.");
  # fmt.format("%s", sn);                   //   -> "Huge Fruit, Inc."
  # fmt.format("%s", sn.toString());        //   -> "HUGE - Huge Fruit, Inc."
  # fmt.format("%#s", sn);                  //   -> "HUGE"
  # fmt.format("%-10.8s", sn);              //   -> "HUGE      "
  # fmt.format("%.12s", sn);                //   -> "Huge Fruit,*"
  # fmt.format(Locale.FRANCE, "%25s", sn);  //   -> "   Fruit Titanesque, Inc."
  # </pre></blockquote>
  # 
  # <p> Formattables are not necessarily safe for multithreaded access.  Thread
  # safety is optional and may be enforced by classes that extend and implement
  # this interface.
  # 
  # <p> Unless otherwise specified, passing a <tt>null</tt> argument to
  # any method in this interface will cause a {@link
  # NullPointerException} to be thrown.
  # 
  # @since  1.5
  module Formattable
    include_class_members FormattableImports
    
    typesig { [Formatter, ::Java::Int, ::Java::Int, ::Java::Int] }
    # Formats the object using the provided {@link Formatter formatter}.
    # 
    # @param  formatter
    # The {@link Formatter formatter}.  Implementing classes may call
    # {@link Formatter#out() formatter.out()} or {@link
    # Formatter#locale() formatter.locale()} to obtain the {@link
    # Appendable} or {@link Locale} used by this
    # <tt>formatter</tt> respectively.
    # 
    # @param  flags
    # The flags modify the output format.  The value is interpreted as
    # a bitmask.  Any combination of the following flags may be set:
    # {@link FormattableFlags#LEFT_JUSTIFY}, {@link
    # FormattableFlags#UPPERCASE}, and {@link
    # FormattableFlags#ALTERNATE}.  If no flags are set, the default
    # formatting of the implementing class will apply.
    # 
    # @param  width
    # The minimum number of characters to be written to the output.
    # If the length of the converted value is less than the
    # <tt>width</tt> then the output will be padded by
    # <tt>'&nbsp;&nbsp;'</tt> until the total number of characters
    # equals width.  The padding is at the beginning by default.  If
    # the {@link FormattableFlags#LEFT_JUSTIFY} flag is set then the
    # padding will be at the end.  If <tt>width</tt> is <tt>-1</tt>
    # then there is no minimum.
    # 
    # @param  precision
    # The maximum number of characters to be written to the output.
    # The precision is applied before the width, thus the output will
    # be truncated to <tt>precision</tt> characters even if the
    # <tt>width</tt> is greater than the <tt>precision</tt>.  If
    # <tt>precision</tt> is <tt>-1</tt> then there is no explicit
    # limit on the number of characters.
    # 
    # @throws  IllegalFormatException
    # If any of the parameters are invalid.  For specification of all
    # possible formatting errors, see the <a
    # href="../util/Formatter.html#detail">Details</a> section of the
    # formatter class specification.
    def format_to(formatter, flags, width, precision)
      raise NotImplementedError
    end
  end
  
end