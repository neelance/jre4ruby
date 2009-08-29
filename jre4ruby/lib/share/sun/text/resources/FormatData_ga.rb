require "rjava"

# Portions Copyright 2005-2007 Sun Microsystems, Inc.  All Rights Reserved.
# 
# 
# COPYRIGHT AND PERMISSION NOTICE
# 
# Copyright (C) 1991-2007 Unicode, Inc. All rights reserved.
# Distributed under the Terms of Use in http://www.unicode.org/copyright.html.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of the Unicode data files and any associated documentation (the "Data
# Files") or Unicode software and any associated documentation (the
# "Software") to deal in the Data Files or Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, and/or sell copies of the Data Files or Software, and
# to permit persons to whom the Data Files or Software are furnished to do
# so, provided that (a) the above copyright notice(s) and this permission
# notice appear with all copies of the Data Files or Software, (b) both the
# above copyright notice(s) and this permission notice appear in associated
# documentation, and (c) there is clear notice in each modified Data File or
# in the Software as well as in the documentation associated with the Data
# File(s) or Software that the data or software has been modified.
# 
# THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
# KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
# THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
# INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR
# CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THE DATA FILES OR SOFTWARE.
# 
# Except as contained in this notice, the name of a copyright holder shall not
# be used in advertising or otherwise to promote the sale, use or other
# dealings in these Data Files or Software without prior written
# authorization of the copyright holder.
# 
# Generated automatically from the Common Locale Data Repository. DO NOT EDIT!
module Sun::Text::Resources
  module FormatData_gaImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_ga < FormatData_gaImports.const_get :ListResourceBundle
    include_class_members FormatData_gaImports
    
    typesig { [] }
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["MonthNames", Array.typed(String).new([("Ean".to_u << 0x00e1 << "ir"), "Feabhra", ("M".to_u << 0x00e1 << "rta"), ("Aibre".to_u << 0x00e1 << "n"), "Bealtaine", "Meitheamh", ("I".to_u << 0x00fa << "il"), ("L".to_u << 0x00fa << "nasa"), ("Me".to_u << 0x00e1 << "n F".to_u << 0x00f3 << "mhair"), ("Deireadh F".to_u << 0x00f3 << "mhair"), "Samhain", "Nollaig", "", ])]), Array.typed(Object).new(["MonthAbbreviations", Array.typed(String).new(["Ean", "Feabh", ("M".to_u << 0x00e1 << "rta"), "Aib", "Beal", "Meith", ("I".to_u << 0x00fa << "il"), ("L".to_u << 0x00fa << "n"), ("MF".to_u << 0x00f3 << "mh"), ("DF".to_u << 0x00f3 << "mh"), "Samh", "Noll", "", ])]), Array.typed(Object).new(["DayNames", Array.typed(String).new([("D".to_u << 0x00e9 << " Domhnaigh"), ("D".to_u << 0x00e9 << " Luain"), ("D".to_u << 0x00e9 << " M".to_u << 0x00e1 << "irt"), ("D".to_u << 0x00e9 << " C".to_u << 0x00e9 << "adaoin"), ("D".to_u << 0x00e9 << "ardaoin"), ("D".to_u << 0x00e9 << " hAoine"), ("D".to_u << 0x00e9 << " Sathairn"), ])]), Array.typed(Object).new(["DayAbbreviations", Array.typed(String).new(["Domh", "Luan", ("M".to_u << 0x00e1 << "irt"), ("C".to_u << 0x00e9 << "ad"), ("D".to_u << 0x00e9 << "ar"), "Aoine", "Sath", ])]), Array.typed(Object).new(["AmPmMarkers", Array.typed(String).new(["a.m.", "p.m.", ])]), Array.typed(Object).new(["Eras", Array.typed(String).new(["RC", "AD", ])]), Array.typed(Object).new(["NumberPatterns", Array.typed(String).new(["#,##0.###", ("".to_u << 0x00a4 << " #,##0.00"), "#,##0%", ])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([".", ",", ";", "%", "0", "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), "NaN", ])]), Array.typed(Object).new(["DateTimePatterns", Array.typed(String).new(["HH:mm:ss z", "HH:mm:ss z", "HH:mm:ss", "HH:mm", "EEEE, yyyy MMMM dd", "yyyy MMMM d", "yyyy MMM d", "yy/MM/dd", "{1} {0}", ])]), Array.typed(Object).new(["DateTimePatternChars", "RbMLkUnsSElFtTauKcZ"]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_ga, :initialize
  end
  
end
