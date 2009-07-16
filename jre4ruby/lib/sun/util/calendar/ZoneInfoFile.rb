require "rjava"

# 
# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Util::Calendar
  module ZoneInfoFileImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util::Calendar
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileNotFoundException
      include_const ::Java::Io, :IOException
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Map
    }
  end
  
  # 
  # <code>ZoneInfoFile</code> reads Zone information files in the
  # &lt;java.home&gt;/lib/zi directory and provides time zone
  # information in the form of a {@link ZoneInfo} object. Also, it
  # reads the ZoneInfoMappings file to obtain time zone IDs information
  # that is used by the {@link ZoneInfo} class. The directory layout
  # and data file formats are as follows.
  # 
  # <p><strong>Directory layout</strong><p>
  # 
  # All zone data files and ZoneInfoMappings are put under the
  # &lt;java.home&gt;/lib/zi directory. A path name for a given time
  # zone ID is a concatenation of &lt;java.home&gt;/lib/zi/ and the
  # time zone ID. (The file separator is replaced with the platform
  # dependent value. e.g., '\' for Win32.) An example layout will look
  # like as follows.
  # <blockquote>
  # <pre>
  # &lt;java.home&gt;/lib/zi/Africa/Addis_Ababa
  # /Africa/Dakar
  # /America/Los_Angeles
  # /Asia/Singapore
  # /EET
  # /Europe/Oslo
  # /GMT
  # /Pacific/Galapagos
  # ...
  # /ZoneInfoMappings
  # </pre>
  # </blockquote>
  # 
  # A zone data file has specific information of each zone.
  # <code>ZoneInfoMappings</code> has global information of zone IDs so
  # that the information can be obtained without instantiating all time
  # zones.
  # 
  # <p><strong>File format</strong><p>
  # 
  # Two binary-file formats based on a simple Tag-Length-Value format are used
  # to describe TimeZone information. The generic format of a data file is:
  # <blockquote>
  # <pre>
  # DataFile {
  # u1              magic[7];
  # u1              version;
  # data_item       data[];
  # }
  # </pre>
  # </blockquote>
  # where <code>magic</code> is a magic number identifying a file
  # format, <code>version</code> is the format version number, and
  # <code>data</code> is one or more <code>data_item</code>s. The
  # <code>data_item</code> structure is:
  # <blockquote>
  # <pre>
  # data_item {
  # u1              tag;
  # u2              length;
  # u1              value[length];
  # }
  # </pre>
  # </blockquote>
  # where <code>tag</code> indicates the data type of the item,
  # <code>length</code> is a byte count of the following
  # <code>value</code> that is the content of item data.
  # <p>
  # All data is stored in the big-endian order. There is no boundary
  # alignment between date items.
  # 
  # <p><strong>1. ZoneInfo data file</strong><p>
  # 
  # Each ZoneInfo data file consists of the following members.
  # <br>
  # <blockquote>
  # <pre>
  # ZoneInfoDataFile {
  # u1              magic[7];
  # u1              version;
  # SET OF<sup>1</sup> {
  # transition            transitions<sup>2</sup>;
  # offset_table          offsets<sup>2</sup>;
  # simpletimezone        stzparams<sup>2</sup>;
  # raw_offset            rawoffset;
  # dstsaving             dst;
  # checksum              crc32;
  # gmtoffsetwillchange   gmtflag<sup>2</sup>;
  # }
  # }
  # 1: an unordered collection of zero or one occurrences of each item
  # 2: optional item
  # </pre>
  # </blockquote>
  # <code>magic</code> is a byte-string constant identifying the
  # ZoneInfo data file.  This field must be <code>"javazi&#92;0"</code>
  # defined as {@link #JAVAZI_LABEL}.
  # <p>
  # <code>version</code> is the version number of the file format. This
  # will be used for compatibility check. This field must be
  # <code>0x01</code> in this version.
  # <p>
  # <code>transition</code>, <code>offset_table</code> and
  # <code>simpletimezone</code> have information of time transition
  # from the past to the future.  Therefore, these structures don't
  # exist if the zone didn't change zone names and haven't applied DST in
  # the past, and haven't planned to apply it.  (e.g. Asia/Tokyo zone)
  # <p>
  # <code>raw_offset</code>, <code>dstsaving</code> and <code>checksum</code>
  # exist in every zoneinfo file. They are used by TimeZone.class indirectly.
  # 
  # <p><strong>1.1 <code>transition</code> structure</strong><p><a name="transition"></a>
  # <blockquote>
  # <pre>
  # transition {
  # u1      tag;              // 0x04 : constant
  # u2      length;           // byte length of whole values
  # s8      value[length/8];  // transitions in `long'
  # }
  # </pre>
  # </blockquote>
  # See {@link ZoneInfo#transitions ZoneInfo.transitions} about the value.
  # 
  # <p><strong>1.2 <code>offset_table</code> structure</strong><p>
  # <blockquote>
  # <pre>
  # offset_table {
  # u1      tag;              // 0x05 : constant
  # u2      length;           // byte length of whole values
  # s4      value[length/4];  // offset values in `int'
  # }
  # </pre>
  # </blockquote>
  # 
  # <p><strong>1.3 <code>simpletimezone</code> structure</strong><p>
  # See {@link ZoneInfo#simpleTimeZoneParams ZoneInfo.simpleTimeZoneParams}
  # about the value.
  # <blockquote>
  # <pre>
  # simpletimezone {
  # u1      tag;              // 0x06 : constant
  # u2      length;           // byte length of whole values
  # s4      value[length/4];  // SimpleTimeZone parameters
  # }
  # </pre>
  # </blockquote>
  # See {@link ZoneInfo#offsets ZoneInfo.offsets} about the value.
  # 
  # <p><strong>1.4 <code>raw_offset</code> structure</strong><p>
  # <blockquote>
  # <pre>
  # raw_offset {
  # u1      tag;              // 0x01 : constant
  # u2      length;           // must be 4.
  # s4      value;            // raw GMT offset [millisecond]
  # }
  # </pre>
  # </blockquote>
  # See {@link ZoneInfo#rawOffset ZoneInfo.rawOffset} about the value.
  # 
  # <p><strong>1.5 <code>dstsaving</code> structure</strong><p>
  # Value has dstSaving in seconds.
  # <blockquote>
  # <pre>
  # dstsaving {
  # u1      tag;              // 0x02 : constant
  # u2      length;           // must be 2.
  # s2      value;            // DST save value [second]
  # }
  # </pre>
  # </blockquote>
  # See {@link ZoneInfo#dstSavings ZoneInfo.dstSavings} about value.
  # 
  # <p><strong>1.6 <code>checksum</code> structure</strong><p>
  # <blockquote>
  # <pre>
  # checksum {
  # u1      tag;              // 0x03 : constant
  # u2      length;           // must be 4.
  # s4      value;            // CRC32 value of transitions
  # }
  # </pre>
  # </blockquote>
  # See {@link ZoneInfo#checksum ZoneInfo.checksum}.
  # 
  # <p><strong>1.7 <code>gmtoffsetwillchange</code> structure</strong><p>
  # This record has a flag value for {@link ZoneInfo#rawOffsetWillChange}.
  # If this record is not present in a zoneinfo file, 0 is assumed for
  # the value.
  # <blockquote>
  # <pre>
  # gmtoffsetwillchange {
  # u1      tag;             // 0x07 : constant
  # u2      length;          // must be 1.
  # u1      value;           // 1: if the GMT raw offset will change
  # // in the future, 0, otherwise.
  # }
  # </pre>
  # </blockquote>
  # 
  # 
  # <p><strong>2. ZoneInfoMappings file</strong><p>
  # 
  # The ZoneInfoMappings file consists of the following members.
  # <br>
  # <blockquote>
  # <pre>
  # ZoneInfoMappings {
  # u1      magic[7];
  # u1      version;
  # SET OF {
  # versionName                   version;
  # zone_id_table                 zoneIDs;
  # raw_offset_table              rawoffsets;
  # raw_offset_index_table        rawoffsetindices;
  # alias_table                   aliases;
  # excluded_list                 excludedList;
  # }
  # }
  # </pre>
  # </blockquote>
  # 
  # <code>magic</code> is a byte-string constant which has the file type.
  # This field must be <code>"javazm&#92;0"</code> defined as {@link #JAVAZM_LABEL}.
  # <p>
  # <code>version</code> is the version number of this file
  # format. This will be used for compatibility check. This field must
  # be <code>0x01</code> in this version.
  # <p>
  # <code>versionName</code> shows which version of Olson's data has been used
  # to generate this ZoneInfoMappings. (e.g. <code>tzdata2000g</code>) <br>
  # This field is for trouble-shooting and isn't usually used in runtime.
  # <p>
  # <code>zone_id_table</code>, <code>raw_offset_index_table</code> and
  # <code>alias_table</code> are general information of supported
  # zones.
  # 
  # <p><strong>2.1 <code>zone_id_table</code> structure</strong><p>
  # The list of zone IDs included in the zi database. The list does
  # <em>not</em> include zone IDs, if any, listed in excludedList.
  # <br>
  # <blockquote>
  # <pre>
  # zone_id_table {
  # u1      tag;              // 0x40 : constant
  # u2      length;           // byte length of whole values
  # u2      zone_id_count;
  # zone_id value[zone_id_count];
  # }
  # 
  # zone_id {
  # u1      byte_length;      // byte length of id
  # u1      id[byte_length];  // zone name string
  # }
  # </pre>
  # </blockquote>
  # 
  # <p><strong>2.2 <code>raw_offset_table</code> structure</strong><p>
  # <br>
  # <blockquote>
  # <pre>
  # raw_offset_table {
  # u1      tag;              // 0x41 : constant
  # u2      length;           // byte length of whole values
  # s4      value[length/4];  // raw GMT offset in milliseconds
  # }
  # </pre>
  # </blockquote>
  # 
  # <p><strong>2.3 <code>raw_offset_index_table</code> structure</strong><p>
  # <br>
  # <blockquote>
  # <pre>
  # raw_offset_index_table {
  # u1      tag;              // 0x42 : constant
  # u2      length;           // byte length of whole values
  # u1      value[length];
  # }
  # </pre>
  # </blockquote>
  # 
  # <p><strong>2.4 <code>alias_table</code> structure</strong><p>
  # <br>
  # <blockquote>
  # <pre>
  # alias_table {
  # u1      tag;              // 0x43 : constant
  # u2      length;           // byte length of whole values
  # u2      nentries;         // number of id-pairs
  # id_pair value[nentries];
  # }
  # 
  # id_pair {
  # zone_id aliasname;
  # zone_id ID;
  # }
  # </pre>
  # </blockquote>
  # 
  # <p><strong>2.5 <code>versionName</code> structure</strong><p>
  # <br>
  # <blockquote>
  # <pre>
  # versionName {
  # u1      tag;              // 0x44 : constant
  # u2      length;           // byte length of whole values
  # u1      value[length];
  # }
  # </pre>
  # </blockquote>
  # 
  # <p><strong>2.6 <code>excludeList</code> structure</strong><p>
  # The list of zone IDs whose zones will change their GMT offsets
  # (a.k.a. raw offsets) some time in the future. Those IDs must be
  # added to the list of zone IDs for getAvailableIDs(). Also they must
  # be examined for getAvailableIDs(int) to determine the
  # <em>current</em> GMT offsets.
  # <br>
  # <blockquote>
  # <pre>
  # excluded_list {
  # u1      tag;              // 0x45 : constant
  # u2      length;           // byte length of whole values
  # u2      nentries;         // number of zone_ids
  # zone_id value[nentries];  // excluded zone IDs
  # }
  # </pre>
  # </blockquote>
  # 
  # @since 1.4
  class ZoneInfoFile 
    include_class_members ZoneInfoFileImports
    
    class_module.module_eval {
      # 
      # The magic number for the ZoneInfo data file format.
      const_set_lazy(:JAVAZI_LABEL) { Array.typed(::Java::Byte).new([Character.new(?j.ord), Character.new(?a.ord), Character.new(?v.ord), Character.new(?a.ord), Character.new(?z.ord), Character.new(?i.ord), Character.new(?\0.ord)]) }
      const_attr_reader  :JAVAZI_LABEL
      
      const_set_lazy(:JAVAZI_LABEL_LENGTH) { JAVAZI_LABEL.attr_length }
      const_attr_reader  :JAVAZI_LABEL_LENGTH
      
      # 
      # The ZoneInfo data file format version number. Must increase
      # one when any incompatible change has been made.
      const_set_lazy(:JAVAZI_VERSION) { 0x1 }
      const_attr_reader  :JAVAZI_VERSION
      
      # 
      # Raw offset data item tag.
      const_set_lazy(:TAG_RawOffset) { 1 }
      const_attr_reader  :TAG_RawOffset
      
      # 
      # Known last Daylight Saving Time save value data item tag.
      const_set_lazy(:TAG_LastDSTSaving) { 2 }
      const_attr_reader  :TAG_LastDSTSaving
      
      # 
      # Checksum data item tag.
      const_set_lazy(:TAG_CRC32) { 3 }
      const_attr_reader  :TAG_CRC32
      
      # 
      # Transition data item tag.
      const_set_lazy(:TAG_Transition) { 4 }
      const_attr_reader  :TAG_Transition
      
      # 
      # Offset table data item tag.
      const_set_lazy(:TAG_Offset) { 5 }
      const_attr_reader  :TAG_Offset
      
      # 
      # SimpleTimeZone parameters data item tag.
      const_set_lazy(:TAG_SimpleTimeZone) { 6 }
      const_attr_reader  :TAG_SimpleTimeZone
      
      # 
      # Raw GMT offset will change in the future.
      const_set_lazy(:TAG_GMTOffsetWillChange) { 7 }
      const_attr_reader  :TAG_GMTOffsetWillChange
      
      # 
      # The ZoneInfoMappings file name.
      const_set_lazy(:JAVAZM_FILE_NAME) { "ZoneInfoMappings" }
      const_attr_reader  :JAVAZM_FILE_NAME
      
      # 
      # The magic number for the ZoneInfoMappings file format.
      const_set_lazy(:JAVAZM_LABEL) { Array.typed(::Java::Byte).new([Character.new(?j.ord), Character.new(?a.ord), Character.new(?v.ord), Character.new(?a.ord), Character.new(?z.ord), Character.new(?m.ord), Character.new(?\0.ord)]) }
      const_attr_reader  :JAVAZM_LABEL
      
      const_set_lazy(:JAVAZM_LABEL_LENGTH) { JAVAZM_LABEL.attr_length }
      const_attr_reader  :JAVAZM_LABEL_LENGTH
      
      # 
      # The ZoneInfoMappings file format version number. Must increase
      # one when any incompatible change has been made.
      const_set_lazy(:JAVAZM_VERSION) { 0x1 }
      const_attr_reader  :JAVAZM_VERSION
      
      # 
      # Time zone IDs data item tag.
      const_set_lazy(:TAG_ZoneIDs) { 64 }
      const_attr_reader  :TAG_ZoneIDs
      
      # 
      # Raw GMT offsets table data item tag.
      const_set_lazy(:TAG_RawOffsets) { 65 }
      const_attr_reader  :TAG_RawOffsets
      
      # 
      # Indices to the raw GMT offset table data item tag.
      const_set_lazy(:TAG_RawOffsetIndices) { 66 }
      const_attr_reader  :TAG_RawOffsetIndices
      
      # 
      # Time zone aliases table data item tag.
      const_set_lazy(:TAG_ZoneAliases) { 67 }
      const_attr_reader  :TAG_ZoneAliases
      
      # 
      # Olson's public zone information version tag.
      const_set_lazy(:TAG_TZDataVersion) { 68 }
      const_attr_reader  :TAG_TZDataVersion
      
      # 
      # Excluded zones item tag. (Added in Mustang)
      const_set_lazy(:TAG_ExcludedZones) { 69 }
      const_attr_reader  :TAG_ExcludedZones
      
      
      def zone_info_objects
        defined?(@@zone_info_objects) ? @@zone_info_objects : @@zone_info_objects= nil
      end
      alias_method :attr_zone_info_objects, :zone_info_objects
      
      def zone_info_objects=(value)
        @@zone_info_objects = value
      end
      alias_method :attr_zone_info_objects=, :zone_info_objects=
      
      typesig { [String] }
      # 
      # Converts the given time zone ID to a platform dependent path
      # name. For example, "America/Los_Angeles" is converted to
      # "America\Los_Angeles" on Win32.
      # @return a modified ID replacing '/' with {@link
      # java.io.File#separatorChar File.separatorChar} if needed.
      def get_file_name(id)
        if ((JavaFile.attr_separator_char).equal?(Character.new(?/.ord)))
          return id
        end
        return id.replace(Character.new(?/.ord), JavaFile.attr_separator_char)
      end
      
      typesig { [String, ::Java::Int] }
      # 
      # Gets a ZoneInfo with the given GMT offset. The object
      # has its ID in the format of GMT{+|-}hh:mm.
      # 
      # @param originalId the given custom id (before normalized such as "GMT+9")
      # @param gmtOffset GMT offset <em>in milliseconds</em>
      # @return a ZoneInfo constructed with the given GMT offset
      def get_custom_time_zone(original_id, gmt_offset)
        id = to_custom_id(gmt_offset)
        zi = get_from_cache(id)
        if ((zi).nil?)
          zi = ZoneInfo.new(id, gmt_offset)
          zi = add_to_cache(id, zi)
          if (!(id == original_id))
            zi = add_to_cache(original_id, zi)
          end
        end
        return zi.clone
      end
      
      typesig { [::Java::Int] }
      def to_custom_id(gmt_offset)
        sign = 0
        offset = gmt_offset / 60000
        if (offset >= 0)
          sign = Character.new(?+.ord)
        else
          sign = Character.new(?-.ord)
          offset = -offset
        end
        hh = offset / 60
        mm = offset % 60
        buf = Array.typed(::Java::Char).new([Character.new(?G.ord), Character.new(?M.ord), Character.new(?T.ord), sign, Character.new(?0.ord), Character.new(?0.ord), Character.new(?:.ord), Character.new(?0.ord), Character.new(?0.ord)])
        if (hh >= 10)
          buf[4] += hh / 10
        end
        buf[5] += hh % 10
        if (!(mm).equal?(0))
          buf[7] += mm / 10
          buf[8] += mm % 10
        end
        return String.new(buf)
      end
      
      typesig { [String] }
      # 
      # @return a ZoneInfo instance created for the specified id, or
      # null if there is no time zone data file found for the specified
      # id.
      def get_zone_info(id)
        zi = get_from_cache(id)
        if ((zi).nil?)
          zi = create_zone_info(id)
          if ((zi).nil?)
            return nil
          end
          zi = add_to_cache(id, zi)
        end
        return zi.clone
      end
      
      typesig { [String] }
      def get_from_cache(id)
        synchronized(self) do
          if ((self.attr_zone_info_objects).nil?)
            return nil
          end
          return self.attr_zone_info_objects.get(id)
        end
      end
      
      typesig { [String, ZoneInfo] }
      def add_to_cache(id, zi)
        synchronized(self) do
          if ((self.attr_zone_info_objects).nil?)
            self.attr_zone_info_objects = HashMap.new
          else
            zone = self.attr_zone_info_objects.get(id)
            if (!(zone).nil?)
              return zone
            end
          end
          self.attr_zone_info_objects.put(id, zi)
          return zi
        end
      end
      
      typesig { [String] }
      def create_zone_info(id)
        buf = read_zone_info_file(get_file_name(id))
        if ((buf).nil?)
          return nil
        end
        index = 0
        index = 0
        while index < JAVAZI_LABEL.attr_length
          if (!(buf[index]).equal?(JAVAZI_LABEL[index]))
            System.err.println("ZoneInfo: wrong magic number: " + id)
            return nil
          end
          ((index += 1) - 1)
        end
        if (buf[((index += 1) - 1)] > JAVAZI_VERSION)
          System.err.println("ZoneInfo: incompatible version (" + (buf[index - 1]).to_s + "): " + id)
          return nil
        end
        filesize = buf.attr_length
        raw_offset = 0
        dst_savings = 0
        checksum = 0
        will_gmtoffset_change = false
        transitions = nil
        offsets = nil
        simple_time_zone_params = nil
        begin
          while (index < filesize)
            tag = buf[((index += 1) - 1)]
            len = ((buf[((index += 1) - 1)] & 0xff) << 8) + (buf[((index += 1) - 1)] & 0xff)
            if (filesize < index + len)
              break
            end
            case (tag)
            when TAG_CRC32
              val = buf[((index += 1) - 1)] & 0xff
              val = (val << 8) + (buf[((index += 1) - 1)] & 0xff)
              val = (val << 8) + (buf[((index += 1) - 1)] & 0xff)
              val = (val << 8) + (buf[((index += 1) - 1)] & 0xff)
              checksum = val
            when TAG_LastDSTSaving
              val_ = RJava.cast_to_short((buf[((index += 1) - 1)] & 0xff))
              val_ = RJava.cast_to_short(((val_ << 8) + (buf[((index += 1) - 1)] & 0xff)))
              dst_savings = val_ * 1000
            when TAG_RawOffset
              val__ = buf[((index += 1) - 1)] & 0xff
              val__ = (val__ << 8) + (buf[((index += 1) - 1)] & 0xff)
              val__ = (val__ << 8) + (buf[((index += 1) - 1)] & 0xff)
              val__ = (val__ << 8) + (buf[((index += 1) - 1)] & 0xff)
              raw_offset = val__
            when TAG_Transition
              n = len / 8
              transitions = Array.typed(::Java::Long).new(n) { 0 }
              i = 0
              while i < n
                val___ = buf[((index += 1) - 1)] & 0xff
                val___ = (val___ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val___ = (val___ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val___ = (val___ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val___ = (val___ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val___ = (val___ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val___ = (val___ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val___ = (val___ << 8) + (buf[((index += 1) - 1)] & 0xff)
                transitions[i] = val___
                ((i += 1) - 1)
              end
            when TAG_Offset
              n_ = len / 4
              offsets = Array.typed(::Java::Int).new(n_) { 0 }
              i_ = 0
              while i_ < n_
                val____ = buf[((index += 1) - 1)] & 0xff
                val____ = (val____ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val____ = (val____ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val____ = (val____ << 8) + (buf[((index += 1) - 1)] & 0xff)
                offsets[i_] = val____
                ((i_ += 1) - 1)
              end
            when TAG_SimpleTimeZone
              if (!(len).equal?(32) && !(len).equal?(40))
                System.err.println("ZoneInfo: wrong SimpleTimeZone parameter size")
                return nil
              end
              n__ = len / 4
              simple_time_zone_params = Array.typed(::Java::Int).new(n__) { 0 }
              i__ = 0
              while i__ < n__
                val_____ = buf[((index += 1) - 1)] & 0xff
                val_____ = (val_____ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val_____ = (val_____ << 8) + (buf[((index += 1) - 1)] & 0xff)
                val_____ = (val_____ << 8) + (buf[((index += 1) - 1)] & 0xff)
                simple_time_zone_params[i__] = val_____
                ((i__ += 1) - 1)
              end
            when TAG_GMTOffsetWillChange
              if (!(len).equal?(1))
                System.err.println("ZoneInfo: wrong byte length for TAG_GMTOffsetWillChange")
              end
              will_gmtoffset_change = (buf[((index += 1) - 1)]).equal?(1)
            else
              System.err.println("ZoneInfo: unknown tag < " + (tag).to_s + ">. ignored.")
              index += len
            end
          end
        rescue Exception => e
          System.err.println("ZoneInfo: corrupted zoneinfo file: " + id)
          return nil
        end
        if (!(index).equal?(filesize))
          System.err.println("ZoneInfo: wrong file size: " + id)
          return nil
        end
        return ZoneInfo.new(id, raw_offset, dst_savings, checksum, transitions, offsets, simple_time_zone_params, will_gmtoffset_change)
      end
      
      
      def zone_ids
        defined?(@@zone_ids) ? @@zone_ids : @@zone_ids= nil
      end
      alias_method :attr_zone_ids, :zone_ids
      
      def zone_ids=(value)
        @@zone_ids = value
      end
      alias_method :attr_zone_ids=, :zone_ids=
      
      typesig { [] }
      def get_zone_ids
        ids = nil
        cache = self.attr_zone_ids
        if (!(cache).nil?)
          ids = cache.get
          if (!(ids).nil?)
            return ids
          end
        end
        buf = nil
        buf = get_zone_info_mappings
        index = JAVAZM_LABEL_LENGTH + 1
        filesize = buf.attr_length
        begin
          while (index < filesize)
            tag = buf[((index += 1) - 1)]
            len = ((buf[((index += 1) - 1)] & 0xff) << 8) + (buf[((index += 1) - 1)] & 0xff)
            case (tag)
            when TAG_ZoneIDs
              n = (buf[((index += 1) - 1)] << 8) + (buf[((index += 1) - 1)] & 0xff)
              ids = ArrayList.new(n)
              i = 0
              while i < n
                m = buf[((index += 1) - 1)]
                ids.add(String.new(buf, index, m, "UTF-8"))
                index += m
                ((i += 1) - 1)
              end
              break
            else
              index += len
            end
          end
        rescue Exception => e
          System.err.println("ZoneInfo: corrupted " + JAVAZM_FILE_NAME)
        end
        self.attr_zone_ids = SoftReference.new(ids)
        return ids
      end
      
      typesig { [] }
      # 
      # @return an alias table in HashMap where a key is an alias ID
      # (e.g., "PST") and its value is a real time zone ID (e.g.,
      # "America/Los_Angeles").
      def get_zone_aliases
        buf = get_zone_info_mappings
        index = JAVAZM_LABEL_LENGTH + 1
        filesize = buf.attr_length
        aliases = nil
        begin
          while (index < filesize)
            tag = buf[((index += 1) - 1)]
            len = ((buf[((index += 1) - 1)] & 0xff) << 8) + (buf[((index += 1) - 1)] & 0xff)
            case (tag)
            when TAG_ZoneAliases
              n = (buf[((index += 1) - 1)] << 8) + (buf[((index += 1) - 1)] & 0xff)
              aliases = HashMap.new(n)
              i = 0
              while i < n
                m = buf[((index += 1) - 1)]
                name = String.new(buf, index, m, "UTF-8")
                index += m
                m = buf[((index += 1) - 1)]
                real_name = String.new(buf, index, m, "UTF-8")
                index += m
                aliases.put(name, real_name)
                ((i += 1) - 1)
              end
              break
            else
              index += len
            end
          end
        rescue Exception => e
          System.err.println("ZoneInfo: corrupted " + JAVAZM_FILE_NAME)
          return nil
        end
        return aliases
      end
      
      
      def excluded_ids
        defined?(@@excluded_ids) ? @@excluded_ids : @@excluded_ids= nil
      end
      alias_method :attr_excluded_ids, :excluded_ids
      
      def excluded_ids=(value)
        @@excluded_ids = value
      end
      alias_method :attr_excluded_ids=, :excluded_ids=
      
      
      def has_no_exclude_list
        defined?(@@has_no_exclude_list) ? @@has_no_exclude_list : @@has_no_exclude_list= false
      end
      alias_method :attr_has_no_exclude_list, :has_no_exclude_list
      
      def has_no_exclude_list=(value)
        @@has_no_exclude_list = value
      end
      alias_method :attr_has_no_exclude_list=, :has_no_exclude_list=
      
      typesig { [] }
      # 
      # @return a List of zone IDs for zones that will change their GMT
      # offsets in some future time.
      # 
      # @since 1.6
      def get_excluded_zones
        if (self.attr_has_no_exclude_list)
          return nil
        end
        exclude_list = nil
        cache = self.attr_excluded_ids
        if (!(cache).nil?)
          exclude_list = cache.get
          if (!(exclude_list).nil?)
            return exclude_list
          end
        end
        buf = get_zone_info_mappings
        index = JAVAZM_LABEL_LENGTH + 1
        filesize = buf.attr_length
        begin
          while (index < filesize)
            tag = buf[((index += 1) - 1)]
            len = ((buf[((index += 1) - 1)] & 0xff) << 8) + (buf[((index += 1) - 1)] & 0xff)
            case (tag)
            when TAG_ExcludedZones
              n = (buf[((index += 1) - 1)] << 8) + (buf[((index += 1) - 1)] & 0xff)
              exclude_list = ArrayList.new
              i = 0
              while i < n
                m = buf[((index += 1) - 1)]
                name = String.new(buf, index, m, "UTF-8")
                index += m
                exclude_list.add(name)
                ((i += 1) - 1)
              end
              break
            else
              index += len
            end
          end
        rescue Exception => e
          System.err.println("ZoneInfo: corrupted " + JAVAZM_FILE_NAME)
          return nil
        end
        if (!(exclude_list).nil?)
          self.attr_excluded_ids = SoftReference.new(exclude_list)
        else
          self.attr_has_no_exclude_list = true
        end
        return exclude_list
      end
      
      
      def raw_offset_indices
        defined?(@@raw_offset_indices) ? @@raw_offset_indices : @@raw_offset_indices= nil
      end
      alias_method :attr_raw_offset_indices, :raw_offset_indices
      
      def raw_offset_indices=(value)
        @@raw_offset_indices = value
      end
      alias_method :attr_raw_offset_indices=, :raw_offset_indices=
      
      typesig { [] }
      def get_raw_offset_indices
        indices = nil
        cache = self.attr_raw_offset_indices
        if (!(cache).nil?)
          indices = cache.get
          if (!(indices).nil?)
            return indices
          end
        end
        buf = get_zone_info_mappings
        index = JAVAZM_LABEL_LENGTH + 1
        filesize = buf.attr_length
        begin
          while (index < filesize)
            tag = buf[((index += 1) - 1)]
            len = ((buf[((index += 1) - 1)] & 0xff) << 8) + (buf[((index += 1) - 1)] & 0xff)
            case (tag)
            when TAG_RawOffsetIndices
              indices = Array.typed(::Java::Byte).new(len) { 0 }
              i = 0
              while i < len
                indices[i] = buf[((index += 1) - 1)]
                ((i += 1) - 1)
              end
              break
            else
              index += len
            end
          end
        rescue ArrayIndexOutOfBoundsException => e
          System.err.println("ZoneInfo: corrupted " + JAVAZM_FILE_NAME)
        end
        self.attr_raw_offset_indices = SoftReference.new(indices)
        return indices
      end
      
      
      def raw_offsets
        defined?(@@raw_offsets) ? @@raw_offsets : @@raw_offsets= nil
      end
      alias_method :attr_raw_offsets, :raw_offsets
      
      def raw_offsets=(value)
        @@raw_offsets = value
      end
      alias_method :attr_raw_offsets=, :raw_offsets=
      
      typesig { [] }
      def get_raw_offsets
        offsets = nil
        cache = self.attr_raw_offsets
        if (!(cache).nil?)
          offsets = cache.get
          if (!(offsets).nil?)
            return offsets
          end
        end
        buf = get_zone_info_mappings
        index = JAVAZM_LABEL_LENGTH + 1
        filesize = buf.attr_length
        begin
          while (index < filesize)
            tag = buf[((index += 1) - 1)]
            len = ((buf[((index += 1) - 1)] & 0xff) << 8) + (buf[((index += 1) - 1)] & 0xff)
            case (tag)
            when TAG_RawOffsets
              n = len / 4
              offsets = Array.typed(::Java::Int).new(n) { 0 }
              i = 0
              while i < n
                val = buf[((index += 1) - 1)] & 0xff
                val = (val << 8) + (buf[((index += 1) - 1)] & 0xff)
                val = (val << 8) + (buf[((index += 1) - 1)] & 0xff)
                val = (val << 8) + (buf[((index += 1) - 1)] & 0xff)
                offsets[i] = val
                ((i += 1) - 1)
              end
              break
            else
              index += len
            end
          end
        rescue ArrayIndexOutOfBoundsException => e
          System.err.println("ZoneInfo: corrupted " + JAVAZM_FILE_NAME)
        end
        self.attr_raw_offsets = SoftReference.new(offsets)
        return offsets
      end
      
      
      def zone_info_mappings
        defined?(@@zone_info_mappings) ? @@zone_info_mappings : @@zone_info_mappings= nil
      end
      alias_method :attr_zone_info_mappings, :zone_info_mappings
      
      def zone_info_mappings=(value)
        @@zone_info_mappings = value
      end
      alias_method :attr_zone_info_mappings=, :zone_info_mappings=
      
      typesig { [] }
      def get_zone_info_mappings
        data = nil
        cache = self.attr_zone_info_mappings
        if (!(cache).nil?)
          data = cache.get
          if (!(data).nil?)
            return data
          end
        end
        data = read_zone_info_file(JAVAZM_FILE_NAME)
        if ((data).nil?)
          return nil
        end
        index = 0
        index = 0
        while index < JAVAZM_LABEL.attr_length
          if (!(data[index]).equal?(JAVAZM_LABEL[index]))
            System.err.println("ZoneInfo: wrong magic number: " + JAVAZM_FILE_NAME)
            return nil
          end
          ((index += 1) - 1)
        end
        if (data[((index += 1) - 1)] > JAVAZM_VERSION)
          System.err.println("ZoneInfo: incompatible version (" + (data[index - 1]).to_s + "): " + JAVAZM_FILE_NAME)
          return nil
        end
        self.attr_zone_info_mappings = SoftReference.new(data)
        return data
      end
      
      typesig { [String] }
      # 
      # Reads the specified file under &lt;java.home&gt;/lib/zi into a buffer.
      # @return the buffer, or null if any I/O error occurred.
      def read_zone_info_file(file_name)
        buffer = nil
        begin
          home_dir = AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.home"))
          fname = home_dir + (JavaFile.attr_separator).to_s + "lib" + (JavaFile.attr_separator).to_s + "zi" + (JavaFile.attr_separator).to_s + file_name
          buffer = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members ZoneInfoFile
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              file = JavaFile.new(fname)
              if (!file.can_read)
                return nil
              end
              filesize = RJava.cast_to_int(file.length)
              buf = Array.typed(::Java::Byte).new(filesize) { 0 }
              fis = FileInputStream.new(file)
              if (!(fis.read(buf)).equal?(filesize))
                fis.close
                raise IOException.new("read error on " + fname)
              end
              fis.close
              return buf
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue PrivilegedActionException => e
          ex = e.get_exception
          if (!(ex.is_a?(FileNotFoundException)) || (JAVAZM_FILE_NAME == file_name))
            System.err.println("ZoneInfo: " + (ex.get_message).to_s)
          end
        end
        return buffer
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__zone_info_file, :initialize
  end
  
end
