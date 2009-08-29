require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Httpserver
  module ContextListImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Httpserver
      include ::Java::Util
      include ::Com::Sun::Net::Httpserver
      include ::Com::Sun::Net::Httpserver::Spi
    }
  end
  
  class ContextList 
    include_class_members ContextListImports
    
    class_module.module_eval {
      const_set_lazy(:MAX_CONTEXTS) { 50 }
      const_attr_reader  :MAX_CONTEXTS
    }
    
    attr_accessor :list
    alias_method :attr_list, :list
    undef_method :list
    alias_method :attr_list=, :list=
    undef_method :list=
    
    typesig { [HttpContextImpl] }
    def add(ctx)
      synchronized(self) do
        raise AssertError if not (!(ctx.get_path).nil?)
        @list.add(ctx)
      end
    end
    
    typesig { [] }
    def size
      synchronized(self) do
        return @list.size
      end
    end
    
    typesig { [String, String] }
    # initially contexts are located only by protocol:path.
    # Context with longest prefix matches (currently case-sensitive)
    def find_context(protocol, path)
      synchronized(self) do
        return find_context(protocol, path, false)
      end
    end
    
    typesig { [String, String, ::Java::Boolean] }
    def find_context(protocol, path, exact)
      synchronized(self) do
        protocol = RJava.cast_to_string(protocol.to_lower_case)
        longest = ""
        lc = nil
        @list.each do |ctx|
          if (!(ctx.get_protocol == protocol))
            next
          end
          cpath = ctx.get_path
          if (exact && !(cpath == path))
            next
          else
            if (!exact && !path.starts_with(cpath))
              next
            end
          end
          if (cpath.length > longest.length)
            longest = cpath
            lc = ctx
          end
        end
        return lc
      end
    end
    
    typesig { [String, String] }
    def remove(protocol, path)
      synchronized(self) do
        ctx = find_context(protocol, path, true)
        if ((ctx).nil?)
          raise IllegalArgumentException.new("cannot remove element from list")
        end
        @list.remove(ctx)
      end
    end
    
    typesig { [HttpContextImpl] }
    def remove(context)
      synchronized(self) do
        @list.each do |ctx|
          if ((ctx == context))
            @list.remove(ctx)
            return
          end
        end
        raise IllegalArgumentException.new("no such context in list")
      end
    end
    
    typesig { [] }
    def initialize
      @list = LinkedList.new
    end
    
    private
    alias_method :initialize__context_list, :initialize
  end
  
end
