require "rjava"

# Portions Copyright 2000-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5::Internal
  module LocalSeqNumberImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal
      include_const ::Sun::Security::Krb5, :Confounder
    }
  end
  
  class LocalSeqNumber 
    include_class_members LocalSeqNumberImports
    include SeqNumber
    
    attr_accessor :last_seq_number
    alias_method :attr_last_seq_number, :last_seq_number
    undef_method :last_seq_number
    alias_method :attr_last_seq_number=, :last_seq_number=
    undef_method :last_seq_number=
    
    typesig { [] }
    def initialize
      @last_seq_number = 0
      rand_init
    end
    
    typesig { [::Java::Int] }
    def initialize(start)
      @last_seq_number = 0
      init(start)
    end
    
    typesig { [JavaInteger] }
    def initialize(start)
      @last_seq_number = 0
      init(start.int_value)
    end
    
    typesig { [] }
    def rand_init
      synchronized(self) do
        # Sequence numbers fall in the range 0 through 2^32 - 1 and wrap
        # to zero following the value 2^32 - 1.
        # Previous implementations used signed sequence numbers.
        # Workaround implementation incompatibilities by not generating
        # initial sequence numbers greater than 2^30, as done
        # in MIT distribution.
        # 
        # get the random confounder
        data = Confounder.bytes(4)
        data[0] = (data[0] & 0x3f)
        result = ((data[3] & 0xff) | ((data[2] & 0xff) << 8) | ((data[1] & 0xff) << 16) | ((data[0] & 0xff) << 24))
        if ((result).equal?(0))
          result = 1
        end
        @last_seq_number = result
      end
    end
    
    typesig { [::Java::Int] }
    def init(start)
      synchronized(self) do
        @last_seq_number = start
      end
    end
    
    typesig { [] }
    def current
      synchronized(self) do
        return @last_seq_number
      end
    end
    
    typesig { [] }
    def next
      synchronized(self) do
        return @last_seq_number + 1
      end
    end
    
    typesig { [] }
    def step
      synchronized(self) do
        return (@last_seq_number += 1)
      end
    end
    
    private
    alias_method :initialize__local_seq_number, :initialize
  end
  
end
