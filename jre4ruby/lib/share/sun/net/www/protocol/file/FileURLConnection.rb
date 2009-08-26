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
# 
# 
# Open an file input stream given a URL.
# @author      James Gosling
# @author      Steven B. Byrne
module Sun::Net::Www::Protocol::JavaFile
  module FileURLConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::JavaFile
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :FileNameMap
      include ::Java::Io
      include_const ::Java::Text, :Collator
      include_const ::Java::Security, :Permission
      include ::Sun::Net
      include ::Sun::Net::Www
      include ::Java::Util
      include_const ::Java::Text, :SimpleDateFormat
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Security::Action, :GetIntegerAction
      include_const ::Sun::Security::Action, :GetBooleanAction
    }
  end
  
  class FileURLConnection < FileURLConnectionImports.const_get :URLConnection
    include_class_members FileURLConnectionImports
    
    class_module.module_eval {
      
      def content_length
        defined?(@@content_length) ? @@content_length : @@content_length= "content-length"
      end
      alias_method :attr_content_length, :content_length
      
      def content_length=(value)
        @@content_length = value
      end
      alias_method :attr_content_length=, :content_length=
      
      
      def content_type
        defined?(@@content_type) ? @@content_type : @@content_type= "content-type"
      end
      alias_method :attr_content_type, :content_type
      
      def content_type=(value)
        @@content_type = value
      end
      alias_method :attr_content_type=, :content_type=
      
      
      def text_plain
        defined?(@@text_plain) ? @@text_plain : @@text_plain= "text/plain"
      end
      alias_method :attr_text_plain, :text_plain
      
      def text_plain=(value)
        @@text_plain = value
      end
      alias_method :attr_text_plain=, :text_plain=
      
      
      def last_modified
        defined?(@@last_modified) ? @@last_modified : @@last_modified= "last-modified"
      end
      alias_method :attr_last_modified, :last_modified
      
      def last_modified=(value)
        @@last_modified = value
      end
      alias_method :attr_last_modified=, :last_modified=
    }
    
    attr_accessor :content_type
    alias_method :attr_content_type, :content_type
    undef_method :content_type
    alias_method :attr_content_type=, :content_type=
    undef_method :content_type=
    
    attr_accessor :is
    alias_method :attr_is, :is
    undef_method :is
    alias_method :attr_is=, :is=
    undef_method :is=
    
    attr_accessor :file
    alias_method :attr_file, :file
    undef_method :file
    alias_method :attr_file=, :file=
    undef_method :file=
    
    attr_accessor :filename
    alias_method :attr_filename, :filename
    undef_method :filename
    alias_method :attr_filename=, :filename=
    undef_method :filename=
    
    attr_accessor :is_directory
    alias_method :attr_is_directory, :is_directory
    undef_method :is_directory
    alias_method :attr_is_directory=, :is_directory=
    undef_method :is_directory=
    
    attr_accessor :exists
    alias_method :attr_exists, :exists
    undef_method :exists
    alias_method :attr_exists=, :exists=
    undef_method :exists=
    
    attr_accessor :files
    alias_method :attr_files, :files
    undef_method :files
    alias_method :attr_files=, :files=
    undef_method :files=
    
    attr_accessor :length
    alias_method :attr_length, :length
    undef_method :length
    alias_method :attr_length=, :length=
    undef_method :length=
    
    attr_accessor :last_modified
    alias_method :attr_last_modified, :last_modified
    undef_method :last_modified
    alias_method :attr_last_modified=, :last_modified=
    undef_method :last_modified=
    
    typesig { [URL, JavaFile] }
    def initialize(u, file)
      @content_type = nil
      @is = nil
      @file = nil
      @filename = nil
      @is_directory = false
      @exists = false
      @files = nil
      @length = 0
      @last_modified = 0
      @initialized_headers = false
      @permission = nil
      super(u)
      @is_directory = false
      @exists = false
      @length = -1
      @last_modified = 0
      @initialized_headers = false
      @file = file
    end
    
    typesig { [] }
    # Note: the semantics of FileURLConnection object is that the
    # results of the various URLConnection calls, such as
    # getContentType, getInputStream or getContentLength reflect
    # whatever was true when connect was called.
    def connect
      if (!self.attr_connected)
        begin
          @filename = RJava.cast_to_string(@file.to_s)
          @is_directory = @file.is_directory
          if (@is_directory)
            @files = Arrays.as_list(@file.list)
          else
            @is = BufferedInputStream.new(FileInputStream.new(@filename))
            # Check if URL should be metered
            metered_input = ProgressMonitor.get_default.should_meter_input(self.attr_url, "GET")
            if (metered_input)
              pi = ProgressSource.new(self.attr_url, "GET", RJava.cast_to_int(@file.length))
              @is = MeteredStream.new(@is, pi, RJava.cast_to_int(@file.length))
            end
          end
        rescue IOException => e
          raise e
        end
        self.attr_connected = true
      end
    end
    
    attr_accessor :initialized_headers
    alias_method :attr_initialized_headers, :initialized_headers
    undef_method :initialized_headers
    alias_method :attr_initialized_headers=, :initialized_headers=
    undef_method :initialized_headers=
    
    typesig { [] }
    def initialize_headers
      begin
        connect
        @exists = @file.exists
      rescue IOException => e
      end
      if (!@initialized_headers || !@exists)
        @length = @file.length
        @last_modified = @file.last_modified
        if (!@is_directory)
          map = Java::Net::URLConnection.get_file_name_map
          @content_type = RJava.cast_to_string(map.get_content_type_for(@filename))
          if (!(@content_type).nil?)
            self.attr_properties.add(self.attr_content_type, @content_type)
          end
          self.attr_properties.add(self.attr_content_length, String.value_of(@length))
          # Format the last-modified field into the preferred
          # Internet standard - ie: fixed-length subset of that
          # defined by RFC 1123
          if (!(@last_modified).equal?(0))
            date = JavaDate.new(@last_modified)
            fo = SimpleDateFormat.new("EEE, dd MMM yyyy HH:mm:ss 'GMT'", Locale::US)
            fo.set_time_zone(TimeZone.get_time_zone("GMT"))
            self.attr_properties.add(self.attr_last_modified, fo.format(date))
          end
        else
          self.attr_properties.add(self.attr_content_type, self.attr_text_plain)
        end
        @initialized_headers = true
      end
    end
    
    typesig { [String] }
    def get_header_field(name)
      initialize_headers
      return super(name)
    end
    
    typesig { [::Java::Int] }
    def get_header_field(n)
      initialize_headers
      return super(n)
    end
    
    typesig { [] }
    def get_content_length
      initialize_headers
      return RJava.cast_to_int(@length)
    end
    
    typesig { [::Java::Int] }
    def get_header_field_key(n)
      initialize_headers
      return super(n)
    end
    
    typesig { [] }
    def get_properties
      initialize_headers
      return super
    end
    
    typesig { [] }
    def get_last_modified
      initialize_headers
      return @last_modified
    end
    
    typesig { [] }
    def get_input_stream
      synchronized(self) do
        icon_height = 0
        icon_width = 0
        connect
        if ((@is).nil?)
          if (@is_directory)
            map = Java::Net::URLConnection.get_file_name_map
            buf = StringBuffer.new
            if ((@files).nil?)
              raise FileNotFoundException.new(@filename)
            end
            Collections.sort(@files, Collator.get_instance)
            i = 0
            while i < @files.size
              file_name = @files.get(i)
              buf.append(file_name)
              buf.append("\n")
              i += 1
            end
            # Put it into a (default) locale-specific byte-stream.
            @is = ByteArrayInputStream.new(buf.to_s.get_bytes)
          else
            raise FileNotFoundException.new(@filename)
          end
        end
        return @is
      end
    end
    
    attr_accessor :permission
    alias_method :attr_permission, :permission
    undef_method :permission
    alias_method :attr_permission=, :permission=
    undef_method :permission=
    
    typesig { [] }
    # since getOutputStream isn't supported, only read permission is
    # relevant
    def get_permission
      if ((@permission).nil?)
        decoded_path = ParseUtil.decode(self.attr_url.get_path)
        if ((JavaFile.attr_separator_char).equal?(Character.new(?/.ord)))
          @permission = FilePermission.new(decoded_path, "read")
        else
          @permission = FilePermission.new(decoded_path.replace(Character.new(?/.ord), JavaFile.attr_separator_char), "read")
        end
      end
      return @permission
    end
    
    private
    alias_method :initialize__file_urlconnection, :initialize
  end
  
end
