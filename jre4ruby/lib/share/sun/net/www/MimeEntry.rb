require "rjava"

# Copyright 1994-2002 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www
  module MimeEntryImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www
      include_const ::Java::Net, :URL
      include ::Java::Io
      include_const ::Java::Util, :StringTokenizer
    }
  end
  
  class MimeEntry 
    include_class_members MimeEntryImports
    include Cloneable
    
    attr_accessor :type_name
    alias_method :attr_type_name, :type_name
    undef_method :type_name
    alias_method :attr_type_name=, :type_name=
    undef_method :type_name=
    
    # of the form: "type/subtype"
    attr_accessor :temp_file_name_template
    alias_method :attr_temp_file_name_template, :temp_file_name_template
    undef_method :temp_file_name_template
    alias_method :attr_temp_file_name_template=, :temp_file_name_template=
    undef_method :temp_file_name_template=
    
    attr_accessor :action
    alias_method :attr_action, :action
    undef_method :action
    alias_method :attr_action=, :action=
    undef_method :action=
    
    attr_accessor :command
    alias_method :attr_command, :command
    undef_method :command
    alias_method :attr_command=, :command=
    undef_method :command=
    
    attr_accessor :description
    alias_method :attr_description, :description
    undef_method :description
    alias_method :attr_description=, :description=
    undef_method :description=
    
    attr_accessor :image_file_name
    alias_method :attr_image_file_name, :image_file_name
    undef_method :image_file_name
    alias_method :attr_image_file_name=, :image_file_name=
    undef_method :image_file_name=
    
    attr_accessor :file_extensions
    alias_method :attr_file_extensions, :file_extensions
    undef_method :file_extensions
    alias_method :attr_file_extensions=, :file_extensions=
    undef_method :file_extensions=
    
    attr_accessor :starred
    alias_method :attr_starred, :starred
    undef_method :starred
    alias_method :attr_starred=, :starred=
    undef_method :starred=
    
    class_module.module_eval {
      # Actions
      const_set_lazy(:UNKNOWN) { 0 }
      const_attr_reader  :UNKNOWN
      
      const_set_lazy(:LOAD_INTO_BROWSER) { 1 }
      const_attr_reader  :LOAD_INTO_BROWSER
      
      const_set_lazy(:SAVE_TO_FILE) { 2 }
      const_attr_reader  :SAVE_TO_FILE
      
      const_set_lazy(:LAUNCH_APPLICATION) { 3 }
      const_attr_reader  :LAUNCH_APPLICATION
      
      const_set_lazy(:ActionKeywords) { Array.typed(String).new(["unknown", "browser", "save", "application", ]) }
      const_attr_reader  :ActionKeywords
    }
    
    typesig { [String] }
    # Construct an empty entry of the given type and subtype.
    def initialize(type)
      # Default action is UNKNOWN so clients can decide what the default
      # should be, typically save to file or ask user.
      initialize__mime_entry(type, UNKNOWN, nil, nil, nil)
    end
    
    typesig { [String, String, String] }
    # The next two constructors are used only by the deprecated
    # PlatformMimeTable classes or, in last case, is called by the public
    # constructor.  They are kept here anticipating putting support for
    # mailcap formatted config files back in (so BOTH the properties format
    # and the mailcap formats are supported).
    def initialize(type, image_file_name, extension_string)
      @type_name = nil
      @temp_file_name_template = nil
      @action = 0
      @command = nil
      @description = nil
      @image_file_name = nil
      @file_extensions = nil
      @starred = false
      @type_name = RJava.cast_to_string(type.to_lower_case)
      @action = UNKNOWN
      @command = RJava.cast_to_string(nil)
      @image_file_name = image_file_name
      set_extensions(extension_string)
      @starred = is_starred(@type_name)
    end
    
    typesig { [String, ::Java::Int, String, String] }
    # For use with MimeTable::parseMailCap
    def initialize(type_name, action, command, temp_file_name_template)
      @type_name = nil
      @temp_file_name_template = nil
      @action = 0
      @command = nil
      @description = nil
      @image_file_name = nil
      @file_extensions = nil
      @starred = false
      @type_name = type_name.to_lower_case
      @action = action
      @command = command
      @image_file_name = nil
      @file_extensions = nil
      @temp_file_name_template = temp_file_name_template
    end
    
    typesig { [String, ::Java::Int, String, String, Array.typed(String)] }
    # This is the one called by the public constructor.
    def initialize(type_name, action, command, image_file_name, file_extensions)
      @type_name = nil
      @temp_file_name_template = nil
      @action = 0
      @command = nil
      @description = nil
      @image_file_name = nil
      @file_extensions = nil
      @starred = false
      @type_name = type_name.to_lower_case
      @action = action
      @command = command
      @image_file_name = image_file_name
      @file_extensions = file_extensions
      @starred = is_starred(type_name)
    end
    
    typesig { [] }
    def get_type
      synchronized(self) do
        return @type_name
      end
    end
    
    typesig { [String] }
    def set_type(type)
      synchronized(self) do
        @type_name = RJava.cast_to_string(type.to_lower_case)
      end
    end
    
    typesig { [] }
    def get_action
      synchronized(self) do
        return @action
      end
    end
    
    typesig { [::Java::Int, String] }
    def set_action(action, command)
      synchronized(self) do
        @action = action
        @command = command
      end
    end
    
    typesig { [::Java::Int] }
    def set_action(action)
      synchronized(self) do
        @action = action
      end
    end
    
    typesig { [] }
    def get_launch_string
      synchronized(self) do
        return @command
      end
    end
    
    typesig { [String] }
    def set_command(command)
      synchronized(self) do
        @command = command
      end
    end
    
    typesig { [] }
    def get_description
      synchronized(self) do
        return (!(@description).nil? ? @description : @type_name)
      end
    end
    
    typesig { [String] }
    def set_description(description)
      synchronized(self) do
        @description = description
      end
    end
    
    typesig { [] }
    # ??? what to return for the image -- the file name or should this return
    # something more advanced like an image source or something?
    # returning the name has the least policy associated with it.
    # pro tempore, we'll use the name
    def get_image_file_name
      return @image_file_name
    end
    
    typesig { [String] }
    def set_image_file_name(filename)
      synchronized(self) do
        file = JavaFile.new(filename)
        if ((file.get_parent).nil?)
          @image_file_name = RJava.cast_to_string(System.get_property("java.net.ftp.imagepath." + filename))
        else
          @image_file_name = filename
        end
        if (filename.last_index_of(Character.new(?..ord)) < 0)
          @image_file_name = @image_file_name + ".gif"
        end
      end
    end
    
    typesig { [] }
    def get_temp_file_template
      return @temp_file_name_template
    end
    
    typesig { [] }
    def get_extensions
      synchronized(self) do
        return @file_extensions
      end
    end
    
    typesig { [] }
    def get_extensions_as_list
      synchronized(self) do
        extensions_as_string = ""
        if (!(@file_extensions).nil?)
          i = 0
          while i < @file_extensions.attr_length
            extensions_as_string += RJava.cast_to_string(@file_extensions[i])
            if (i < (@file_extensions.attr_length - 1))
              extensions_as_string += ","
            end
            i += 1
          end
        end
        return extensions_as_string
      end
    end
    
    typesig { [String] }
    def set_extensions(extension_string)
      synchronized(self) do
        ext_tokens = StringTokenizer.new(extension_string, ",")
        num_exts = ext_tokens.count_tokens
        extension_strings = Array.typed(String).new(num_exts) { nil }
        i = 0
        while i < num_exts
          ext = ext_tokens.next_element
          extension_strings[i] = ext.trim
          i += 1
        end
        @file_extensions = extension_strings
      end
    end
    
    typesig { [String] }
    def is_starred(type_name)
      return (!(type_name).nil?) && (type_name.length > 0) && (type_name.ends_with("/*"))
    end
    
    typesig { [Java::Net::URLConnection, InputStream, MimeTable] }
    # Invoke the MIME type specific behavior for this MIME type.
    # Returned value can be one of several types:
    # <ol>
    # <li>A thread -- the caller can choose when to launch this thread.
    # <li>A string -- the string is loaded into the browser directly.
    # <li>An input stream -- the caller can read from this byte stream and
    # will typically store the results in a file.
    # <li>A document (?) --
    # </ol>
    def launch(urlc, is, mt)
      case (@action)
      when SAVE_TO_FILE
        # REMIND: is this really the right thing to do?
        begin
          return is
        rescue JavaException => e
          # I18N
          return "Load to file failed:\n" + RJava.cast_to_string(e)
        end
        # REMIND: invoke the content handler?
        # may be the right thing to do, may not be -- short term
        # where docs are not loaded asynch, loading and returning
        # the content is the right thing to do.
        begin
          return urlc.get_content
        rescue JavaException => e
          return nil
        end
        thread_name = @command
        fst = thread_name.index_of(Character.new(?\s.ord))
        if (fst > 0)
          thread_name = RJava.cast_to_string(thread_name.substring(0, fst))
        end
        return MimeLauncher.new(self, urlc, is, mt.get_temp_file_template, thread_name)
      when LOAD_INTO_BROWSER
        # REMIND: invoke the content handler?
        # may be the right thing to do, may not be -- short term
        # where docs are not loaded asynch, loading and returning
        # the content is the right thing to do.
        begin
          return urlc.get_content
        rescue JavaException => e
          return nil
        end
        thread_name = @command
        fst = thread_name.index_of(Character.new(?\s.ord))
        if (fst > 0)
          thread_name = RJava.cast_to_string(thread_name.substring(0, fst))
        end
        return MimeLauncher.new(self, urlc, is, mt.get_temp_file_template, thread_name)
      when LAUNCH_APPLICATION
        thread_name = @command
        fst = thread_name.index_of(Character.new(?\s.ord))
        if (fst > 0)
          thread_name = RJava.cast_to_string(thread_name.substring(0, fst))
        end
        return MimeLauncher.new(self, urlc, is, mt.get_temp_file_template, thread_name)
      when UNKNOWN
        # REMIND: What do do here?
        return nil
      end
      return nil
    end
    
    typesig { [String] }
    def matches(type)
      if (@starred)
        # REMIND: is this the right thing or not?
        return type.starts_with(@type_name)
      else
        return (type == @type_name)
      end
    end
    
    typesig { [] }
    def clone
      # return a shallow copy of this.
      the_clone = MimeEntry.new(@type_name)
      the_clone.attr_action = @action
      the_clone.attr_command = @command
      the_clone.attr_description = @description
      the_clone.attr_image_file_name = @image_file_name
      the_clone.attr_temp_file_name_template = @temp_file_name_template
      the_clone.attr_file_extensions = @file_extensions
      return the_clone
    end
    
    typesig { [] }
    def to_property
      synchronized(self) do
        buf = StringBuffer.new
        separator = "; "
        need_separator = false
        action = get_action
        if (!(action).equal?(MimeEntry::UNKNOWN))
          buf.append("action=" + RJava.cast_to_string(ActionKeywords[action]))
          need_separator = true
        end
        command = get_launch_string
        if (!(command).nil? && command.length > 0)
          if (need_separator)
            buf.append(separator)
          end
          buf.append("application=" + command)
          need_separator = true
        end
        if (!(get_image_file_name).nil?)
          if (need_separator)
            buf.append(separator)
          end
          buf.append("icon=" + RJava.cast_to_string(get_image_file_name))
          need_separator = true
        end
        extensions = get_extensions_as_list
        if (extensions.length > 0)
          if (need_separator)
            buf.append(separator)
          end
          buf.append("file_extensions=" + extensions)
          need_separator = true
        end
        description = get_description
        if (!(description).nil? && !(description == get_type))
          if (need_separator)
            buf.append(separator)
          end
          buf.append("description=" + description)
        end
        return buf.to_s
      end
    end
    
    typesig { [] }
    def to_s
      return "MimeEntry[contentType=" + @type_name + ", image=" + @image_file_name + ", action=" + RJava.cast_to_string(@action) + ", command=" + @command + ", extensions=" + RJava.cast_to_string(get_extensions_as_list) + "]"
    end
    
    private
    alias_method :initialize__mime_entry, :initialize
  end
  
end
