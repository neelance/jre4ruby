require "rjava"

# Copyright 1995-1996 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Zip
  module ZipConstantsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Zip
    }
  end
  
  # zip file comment length
  # 
  # This interface defines the constants that are used by the classes
  # which manipulate ZIP files.
  # 
  # @author      David Connelly
  module ZipConstants
    include_class_members ZipConstantsImports
    
    class_module.module_eval {
      # Header signatures
      const_set_lazy(:LOCSIG) { 0x4034b50 }
      const_attr_reader  :LOCSIG
      
      # "PK\003\004"
      const_set_lazy(:EXTSIG) { 0x8074b50 }
      const_attr_reader  :EXTSIG
      
      # "PK\007\008"
      const_set_lazy(:CENSIG) { 0x2014b50 }
      const_attr_reader  :CENSIG
      
      # "PK\001\002"
      const_set_lazy(:ENDSIG) { 0x6054b50 }
      const_attr_reader  :ENDSIG
      
      # "PK\005\006"
      # 
      # Header sizes in bytes (including signatures)
      const_set_lazy(:LOCHDR) { 30 }
      const_attr_reader  :LOCHDR
      
      # LOC header size
      const_set_lazy(:EXTHDR) { 16 }
      const_attr_reader  :EXTHDR
      
      # EXT header size
      const_set_lazy(:CENHDR) { 46 }
      const_attr_reader  :CENHDR
      
      # CEN header size
      const_set_lazy(:ENDHDR) { 22 }
      const_attr_reader  :ENDHDR
      
      # END header size
      # 
      # Local file (LOC) header field offsets
      const_set_lazy(:LOCVER) { 4 }
      const_attr_reader  :LOCVER
      
      # version needed to extract
      const_set_lazy(:LOCFLG) { 6 }
      const_attr_reader  :LOCFLG
      
      # general purpose bit flag
      const_set_lazy(:LOCHOW) { 8 }
      const_attr_reader  :LOCHOW
      
      # compression method
      const_set_lazy(:LOCTIM) { 10 }
      const_attr_reader  :LOCTIM
      
      # modification time
      const_set_lazy(:LOCCRC) { 14 }
      const_attr_reader  :LOCCRC
      
      # uncompressed file crc-32 value
      const_set_lazy(:LOCSIZ) { 18 }
      const_attr_reader  :LOCSIZ
      
      # compressed size
      const_set_lazy(:LOCLEN) { 22 }
      const_attr_reader  :LOCLEN
      
      # uncompressed size
      const_set_lazy(:LOCNAM) { 26 }
      const_attr_reader  :LOCNAM
      
      # filename length
      const_set_lazy(:LOCEXT) { 28 }
      const_attr_reader  :LOCEXT
      
      # extra field length
      # 
      # Extra local (EXT) header field offsets
      const_set_lazy(:EXTCRC) { 4 }
      const_attr_reader  :EXTCRC
      
      # uncompressed file crc-32 value
      const_set_lazy(:EXTSIZ) { 8 }
      const_attr_reader  :EXTSIZ
      
      # compressed size
      const_set_lazy(:EXTLEN) { 12 }
      const_attr_reader  :EXTLEN
      
      # uncompressed size
      # 
      # Central directory (CEN) header field offsets
      const_set_lazy(:CENVEM) { 4 }
      const_attr_reader  :CENVEM
      
      # version made by
      const_set_lazy(:CENVER) { 6 }
      const_attr_reader  :CENVER
      
      # version needed to extract
      const_set_lazy(:CENFLG) { 8 }
      const_attr_reader  :CENFLG
      
      # encrypt, decrypt flags
      const_set_lazy(:CENHOW) { 10 }
      const_attr_reader  :CENHOW
      
      # compression method
      const_set_lazy(:CENTIM) { 12 }
      const_attr_reader  :CENTIM
      
      # modification time
      const_set_lazy(:CENCRC) { 16 }
      const_attr_reader  :CENCRC
      
      # uncompressed file crc-32 value
      const_set_lazy(:CENSIZ) { 20 }
      const_attr_reader  :CENSIZ
      
      # compressed size
      const_set_lazy(:CENLEN) { 24 }
      const_attr_reader  :CENLEN
      
      # uncompressed size
      const_set_lazy(:CENNAM) { 28 }
      const_attr_reader  :CENNAM
      
      # filename length
      const_set_lazy(:CENEXT) { 30 }
      const_attr_reader  :CENEXT
      
      # extra field length
      const_set_lazy(:CENCOM) { 32 }
      const_attr_reader  :CENCOM
      
      # comment length
      const_set_lazy(:CENDSK) { 34 }
      const_attr_reader  :CENDSK
      
      # disk number start
      const_set_lazy(:CENATT) { 36 }
      const_attr_reader  :CENATT
      
      # internal file attributes
      const_set_lazy(:CENATX) { 38 }
      const_attr_reader  :CENATX
      
      # external file attributes
      const_set_lazy(:CENOFF) { 42 }
      const_attr_reader  :CENOFF
      
      # LOC header offset
      # 
      # End of central directory (END) header field offsets
      const_set_lazy(:ENDSUB) { 8 }
      const_attr_reader  :ENDSUB
      
      # number of entries on this disk
      const_set_lazy(:ENDTOT) { 10 }
      const_attr_reader  :ENDTOT
      
      # total number of entries
      const_set_lazy(:ENDSIZ) { 12 }
      const_attr_reader  :ENDSIZ
      
      # central directory size in bytes
      const_set_lazy(:ENDOFF) { 16 }
      const_attr_reader  :ENDOFF
      
      # offset of first CEN header
      const_set_lazy(:ENDCOM) { 20 }
      const_attr_reader  :ENDCOM
    }
  end
  
end
