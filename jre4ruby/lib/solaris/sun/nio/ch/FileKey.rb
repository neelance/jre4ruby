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
module Sun::Nio::Ch
  module FileKeyImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Nio::Ch
      include_const ::Java::Io, :FileDescriptor
      include_const ::Java::Io, :IOException
    }
  end
  
  # Represents a key to a specific file on Solaris or Linux
  class FileKey 
    include_class_members FileKeyImports
    
    attr_accessor :st_dev
    alias_method :attr_st_dev, :st_dev
    undef_method :st_dev
    alias_method :attr_st_dev=, :st_dev=
    undef_method :st_dev=
    
    # ID of device
    attr_accessor :st_ino
    alias_method :attr_st_ino, :st_ino
    undef_method :st_ino
    alias_method :attr_st_ino=, :st_ino=
    undef_method :st_ino=
    
    typesig { [] }
    # Inode number
    def initialize
      @st_dev = 0
      @st_ino = 0
    end
    
    class_module.module_eval {
      typesig { [FileDescriptor] }
      def create(fd)
        fk = FileKey.new
        begin
          fk.init(fd)
        rescue IOException => ioe
          raise JavaError.new(ioe)
        end
        return fk
      end
    }
    
    typesig { [] }
    def hash_code
      return RJava.cast_to_int((@st_dev ^ (@st_dev >> 32))) + RJava.cast_to_int((@st_ino ^ (@st_ino >> 32)))
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(FileKey)))
        return false
      end
      other = obj
      if ((!(@st_dev).equal?(other.attr_st_dev)) || (!(@st_ino).equal?(other.attr_st_ino)))
        return false
      end
      return true
    end
    
    JNI.native_method :Java_sun_nio_ch_FileKey_init, [:pointer, :long, :long], :void
    typesig { [FileDescriptor] }
    def init(fd)
      JNI.__send__(:Java_sun_nio_ch_FileKey_init, JNI.env, self.jni_id, fd.jni_id)
    end
    
    class_module.module_eval {
      JNI.native_method :Java_sun_nio_ch_FileKey_initIDs, [:pointer, :long], :void
      typesig { [] }
      def init_ids
        JNI.__send__(:Java_sun_nio_ch_FileKey_initIDs, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        init_ids
      end
    }
    
    private
    alias_method :initialize__file_key, :initialize
  end
  
end
