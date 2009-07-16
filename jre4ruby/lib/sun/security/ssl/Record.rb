require "rjava"

# 
# Copyright 1996-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module RecordImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
    }
  end
  
  # 
  # SSL/TLS records, as pulled off (and put onto) a TCP stream.  This is
  # the base interface, which defines common information and interfaces
  # used by both Input and Output records.
  # 
  # @author David Brownell
  module Record
    include_class_members RecordImports
    
    class_module.module_eval {
      # 
      # There are four SSL record types, which are part of the interface
      # to this level (along with the maximum record size)
      # 
      # enum { change_cipher_spec(20), alert(21), handshake(22),
      # application_data(23), (255) } ContentType;
      const_set_lazy(:Ct_change_cipher_spec) { 20 }
      const_attr_reader  :Ct_change_cipher_spec
      
      const_set_lazy(:Ct_alert) { 21 }
      const_attr_reader  :Ct_alert
      
      const_set_lazy(:Ct_handshake) { 22 }
      const_attr_reader  :Ct_handshake
      
      const_set_lazy(:Ct_application_data) { 23 }
      const_attr_reader  :Ct_application_data
      
      const_set_lazy(:HeaderSize) { 5 }
      const_attr_reader  :HeaderSize
      
      # SSLv3 record header
      const_set_lazy(:MaxExpansion) { 1024 }
      const_attr_reader  :MaxExpansion
      
      # for bad compression
      const_set_lazy(:TrailerSize) { 20 }
      const_attr_reader  :TrailerSize
      
      # SHA1 hash size
      const_set_lazy(:MaxDataSize) { 16384 }
      const_attr_reader  :MaxDataSize
      
      # 2^14 bytes of data
      const_set_lazy(:MaxPadding) { 256 }
      const_attr_reader  :MaxPadding
      
      # block cipher padding
      # 
      # SSL has a maximum record size.  It's header, (compressed) data,
      # padding, and a trailer for the MAC.
      # Some compression algorithms have rare cases where they expand the data.
      # As we don't support compression at this time, leave that out.
      # 
      # header
      # data
      # padding
      const_set_lazy(:MaxRecordSize) { HeaderSize + MaxDataSize + MaxPadding + TrailerSize }
      const_attr_reader  :MaxRecordSize
      
      # MAC
      # 
      # The maximum large record size.
      # 
      # Some SSL/TLS implementations support large fragment upto 2^15 bytes,
      # such as Microsoft. We support large incoming fragments.
      # 
      # The maximum large record size is defined as maxRecordSize plus 2^14,
      # this is the amount OpenSSL is using.
      # 
      # Max size with a conforming implemenation
      const_set_lazy(:MaxLargeRecordSize) { MaxRecordSize + MaxDataSize }
      const_attr_reader  :MaxLargeRecordSize
      
      # extra 2^14 bytes for large data packets.
      # 
      # Maximum record size for alert and change cipher spec records.
      # They only contain 2 and 1 bytes of data, respectively.
      # Allocate a smaller array.
      const_set_lazy(:MaxAlertRecordSize) { HeaderSize + 2 + MaxPadding + TrailerSize }
      const_attr_reader  :MaxAlertRecordSize
    }
  end
  
end
