require "rjava"

# 
# Copyright 1996-1998 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module EntryPairImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
    }
  end
  
  # 
  # This is used for building contracting character tables.  entryName
  # is the contracting character name and value is its collation
  # order.
  class EntryPair 
    include_class_members EntryPairImports
    
    attr_accessor :entry_name
    alias_method :attr_entry_name, :entry_name
    undef_method :entry_name
    alias_method :attr_entry_name=, :entry_name=
    undef_method :entry_name=
    
    attr_accessor :value
    alias_method :attr_value, :value
    undef_method :value
    alias_method :attr_value=, :value=
    undef_method :value=
    
    attr_accessor :fwd
    alias_method :attr_fwd, :fwd
    undef_method :fwd
    alias_method :attr_fwd=, :fwd=
    undef_method :fwd=
    
    typesig { [String, ::Java::Int] }
    def initialize(name, value)
      initialize__entry_pair(name, value, true)
    end
    
    typesig { [String, ::Java::Int, ::Java::Boolean] }
    def initialize(name, value, fwd)
      @entry_name = nil
      @value = 0
      @fwd = false
      @entry_name = name
      @value = value
      @fwd = fwd
    end
    
    private
    alias_method :initialize__entry_pair, :initialize
  end
  
end
