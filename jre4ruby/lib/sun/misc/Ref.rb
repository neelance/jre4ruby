require "rjava"

# Copyright 1995-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module RefImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Lang::Ref, :SoftReference
    }
  end
  
  # A "Ref" is an indirect reference to an object that the garbage collector
  # knows about.  An application should override the reconstitute() method with one
  # that will construct the object based on information in the Ref, often by
  # reading from a file.  The get() method retains a cache of the result of the last call to
  # reconstitute() in the Ref.  When space gets tight, the garbage collector
  # will clear old Ref cache entries when there are no other pointers to the
  # object.  In normal usage, Ref will always be subclassed.  The subclass will add the
  # instance variables necessary for the reconstitute() method to work.  It will also add a
  # constructor to set them up, and write a version of reconstitute().
  # 
  # @deprecated This class has been replaced by
  # <code>java.util.SoftReference</code>.
  # 
  # @see java.util.SoftReference
  class Ref 
    include_class_members RefImports
    
    attr_accessor :soft
    alias_method :attr_soft, :soft
    undef_method :soft
    alias_method :attr_soft=, :soft=
    undef_method :soft=
    
    typesig { [] }
    # Returns a pointer to the object referenced by this Ref.  If the object
    # has been thrown away by the garbage collector, it will be
    # reconstituted. This method does everything necessary to ensure that the garbage
    # collector throws things away in Least Recently Used(LRU) order.  Applications should
    # never override this method. The get() method effectively caches calls to
    # reconstitute().
    def get
      synchronized(self) do
        t = check
        if ((t).nil?)
          t = reconstitute
          set_thing(t)
        end
        return t
      end
    end
    
    typesig { [] }
    # Returns a pointer to the object referenced by this Ref by
    # reconstituting it from some external source (such as a file).  This method should not
    # bother with caching since the method get() will deal with that.
    # <p>
    # In normal usage, Ref will always be subclassed.  The subclass will add
    # the instance variables necessary for reconstitute() to work.  It will
    # also add a constructor to set them up, and write a version of
    # reconstitute().
    def reconstitute
      raise NotImplementedError
    end
    
    typesig { [] }
    # Flushes the cached object.  Forces the next invocation of get() to
    # invoke reconstitute().
    def flush
      synchronized(self) do
        s = @soft
        if (!(s).nil?)
          s.clear
        end
        @soft = nil
      end
    end
    
    typesig { [Object] }
    # Sets the thing to the specified object.
    # @param thing the specified object
    def set_thing(thing)
      synchronized(self) do
        flush
        @soft = SoftReference.new(thing)
      end
    end
    
    typesig { [] }
    # Checks to see what object is being pointed at by this Ref and returns it.
    def check
      synchronized(self) do
        s = @soft
        if ((s).nil?)
          return nil
        end
        return s.get
      end
    end
    
    typesig { [] }
    # Constructs a new Ref.
    def initialize
      @soft = nil
    end
    
    typesig { [Object] }
    # Constructs a new Ref that initially points to thing.
    def initialize(thing)
      @soft = nil
      set_thing(thing)
    end
    
    private
    alias_method :initialize__ref, :initialize
  end
  
end
