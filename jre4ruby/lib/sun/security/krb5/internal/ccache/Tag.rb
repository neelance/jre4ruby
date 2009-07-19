require "rjava"

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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Ccache
  module TagImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ccache
      include ::Sun::Security::Krb5
      include_const ::Java::Io, :ByteArrayOutputStream
    }
  end
  
  # tag field introduced in KRB5_FCC_FVNO_4
  # 
  # @author Yanni Zhang
  class Tag 
    include_class_members TagImports
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    attr_accessor :tag
    alias_method :attr_tag, :tag
    undef_method :tag
    alias_method :attr_tag=, :tag=
    undef_method :tag=
    
    attr_accessor :tag_len
    alias_method :attr_tag_len, :tag_len
    undef_method :tag_len
    alias_method :attr_tag_len=, :tag_len=
    undef_method :tag_len=
    
    attr_accessor :time_offset
    alias_method :attr_time_offset, :time_offset
    undef_method :time_offset
    alias_method :attr_time_offset=, :time_offset=
    undef_method :time_offset=
    
    attr_accessor :usec_offset
    alias_method :attr_usec_offset, :usec_offset
    undef_method :usec_offset
    alias_method :attr_usec_offset=, :usec_offset=
    undef_method :usec_offset=
    
    typesig { [::Java::Int, ::Java::Int, JavaInteger, JavaInteger] }
    def initialize(len, new_tag, new_time, new_usec)
      @length = 0
      @tag = 0
      @tag_len = 0
      @time_offset = nil
      @usec_offset = nil
      @tag = new_tag
      @tag_len = 8
      @time_offset = new_time
      @usec_offset = new_usec
      @length = 4 + @tag_len
    end
    
    typesig { [::Java::Int] }
    def initialize(new_tag)
      @length = 0
      @tag = 0
      @tag_len = 0
      @time_offset = nil
      @usec_offset = nil
      @tag = new_tag
      @tag_len = 0
      @length = 4 + @tag_len
    end
    
    typesig { [] }
    def to_byte_array
      os = ByteArrayOutputStream.new
      os.write(@length)
      os.write(@tag)
      os.write(@tag_len)
      if (!(@time_offset).nil?)
        os.write(@time_offset.int_value)
      end
      if (!(@usec_offset).nil?)
        os.write(@usec_offset.int_value)
      end
      return os.to_byte_array
    end
    
    private
    alias_method :initialize__tag, :initialize
  end
  
end
