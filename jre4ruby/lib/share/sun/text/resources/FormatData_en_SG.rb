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
  module FormatData_en_SGImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Resources
      include_const ::Java::Util, :ListResourceBundle
    }
  end
  
  class FormatData_en_SG < FormatData_en_SGImports.const_get :ListResourceBundle
    include_class_members FormatData_en_SGImports
    
    typesig { [] }
    def get_contents
      return Array.typed(Array.typed(Object)).new([Array.typed(Object).new(["NumberPatterns", Array.typed(String).new(["#,##0.###", ("".to_u << 0x00a4 << "#,##0.00"), "#,##0%", ])]), Array.typed(Object).new(["NumberElements", Array.typed(String).new([".", ",", ";", "%", "0", "#", "-", "E", ("".to_u << 0x2030 << ""), ("".to_u << 0x221e << ""), "NaN", ])]), ])
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__format_data_en_sg, :initialize
  end
  
end
