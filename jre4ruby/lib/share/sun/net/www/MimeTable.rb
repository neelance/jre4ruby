require "rjava"

# Copyright 1994-1999 Sun Microsystems, Inc.  All Rights Reserved.
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
  module MimeTableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www
      include ::Java::Io
      include_const ::Java::Util, :Calendar
      include_const ::Java::Util, :JavaDate
      include_const ::Java::Text, :SimpleDateFormat
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :FileNameMap
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Properties
      include_const ::Java::Util, :StringTokenizer
    }
  end
  
  # Debugging utilities
  # 
  # public void list(PrintStream out) {
  # Enumeration keys = entries.keys();
  # while (keys.hasMoreElements()) {
  # String key = (String)keys.nextElement();
  # MimeEntry entry = (MimeEntry)entries.get(key);
  # out.println(key + ": " + entry);
  # }
  # }
  # 
  # public static void main(String[] args) {
  # MimeTable testTable = MimeTable.getDefaultTable();
  # 
  # Enumeration e = testTable.elements();
  # while (e.hasMoreElements()) {
  # MimeEntry entry = (MimeEntry)e.nextElement();
  # System.out.println(entry);
  # }
  # 
  # testTable.save(File.separator + "tmp" +
  # File.separator + "mime_table.save");
  # }
  class MimeTable 
    include_class_members MimeTableImports
    include FileNameMap
    
    # Keyed by content type, returns MimeEntries
    attr_accessor :entries
    alias_method :attr_entries, :entries
    undef_method :entries
    alias_method :attr_entries=, :entries=
    undef_method :entries=
    
    # Keyed by file extension (with the .), returns MimeEntries
    attr_accessor :extension_map
    alias_method :attr_extension_map, :extension_map
    undef_method :extension_map
    alias_method :attr_extension_map=, :extension_map=
    undef_method :extension_map=
    
    class_module.module_eval {
      # Will be reset if in the platform-specific data file
      
      def temp_file_template
        defined?(@@temp_file_template) ? @@temp_file_template : @@temp_file_template= nil
      end
      alias_method :attr_temp_file_template, :temp_file_template
      
      def temp_file_template=(value)
        @@temp_file_template = value
      end
      alias_method :attr_temp_file_template=, :temp_file_template=
      
      when_class_loaded do
        Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          extend LocalClass
          include_class_members MimeTable
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            self.attr_temp_file_template = RJava.cast_to_string(System.get_property("content.types.temp.file.template", "/tmp/%s"))
            self.attr_mailcap_locations = Array.typed(String).new([System.get_property("user.mailcap"), RJava.cast_to_string(System.get_property("user.home")) + "/.mailcap", "/etc/mailcap", "/usr/etc/mailcap", "/usr/local/etc/mailcap", RJava.cast_to_string(System.get_property("hotjava.home", "/usr/local/hotjava")) + "/lib/mailcap", ])
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      const_set_lazy(:FilePreamble) { "sun.net.www MIME content-types table" }
      const_attr_reader  :FilePreamble
      
      const_set_lazy(:FileMagic) { "#" + FilePreamble }
      const_attr_reader  :FileMagic
      
      
      def default_instance
        defined?(@@default_instance) ? @@default_instance : @@default_instance= nil
      end
      alias_method :attr_default_instance, :default_instance
      
      def default_instance=(value)
        @@default_instance = value
      end
      alias_method :attr_default_instance=, :default_instance=
    }
    
    typesig { [] }
    def initialize
      @entries = Hashtable.new
      @extension_map = Hashtable.new
      load
    end
    
    class_module.module_eval {
      typesig { [] }
      # Get the single instance of this class.  First use will load the
      # table from a data file.
      def get_default_table
        if ((self.attr_default_instance).nil?)
          Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members MimeTable
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              self.attr_default_instance = self.class::MimeTable.new
              URLConnection.set_file_name_map(self.attr_default_instance)
              return nil
            end
            
            typesig { [Vararg.new(Object)] }
            define_method :initialize do |*args|
              super(*args)
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        end
        return self.attr_default_instance
      end
      
      typesig { [] }
      def load_table
        mt = get_default_table
        return mt
      end
    }
    
    typesig { [] }
    def get_size
      synchronized(self) do
        return @entries.size
      end
    end
    
    typesig { [String] }
    def get_content_type_for(file_name)
      synchronized(self) do
        entry = find_by_file_name(file_name)
        if (!(entry).nil?)
          return entry.get_type
        else
          return nil
        end
      end
    end
    
    typesig { [MimeEntry] }
    def add(m)
      synchronized(self) do
        @entries.put(m.get_type, m)
        exts = m.get_extensions
        if ((exts).nil?)
          return
        end
        i = 0
        while i < exts.attr_length
          @extension_map.put(exts[i], m)
          i += 1
        end
      end
    end
    
    typesig { [String] }
    def remove(type)
      synchronized(self) do
        entry = @entries.get(type)
        return remove(entry)
      end
    end
    
    typesig { [MimeEntry] }
    def remove(entry)
      synchronized(self) do
        extension_keys = entry.get_extensions
        if (!(extension_keys).nil?)
          i = 0
          while i < extension_keys.attr_length
            @extension_map.remove(extension_keys[i])
            i += 1
          end
        end
        return @entries.remove(entry.get_type)
      end
    end
    
    typesig { [String] }
    def find(type)
      synchronized(self) do
        entry = @entries.get(type)
        if ((entry).nil?)
          # try a wildcard lookup
          e = @entries.elements
          while (e.has_more_elements)
            wild = e.next_element
            if (wild.matches(type))
              return wild
            end
          end
        end
        return entry
      end
    end
    
    typesig { [String] }
    # Locate a MimeEntry by the file extension that has been associated
    # with it. Parses general file names, and URLs.
    def find_by_file_name(fname)
      ext = ""
      i = fname.last_index_of(Character.new(?#.ord))
      if (i > 0)
        fname = RJava.cast_to_string(fname.substring(0, i - 1))
      end
      i = fname.last_index_of(Character.new(?..ord))
      # REMIND: OS specific delimters appear here
      i = Math.max(i, fname.last_index_of(Character.new(?/.ord)))
      i = Math.max(i, fname.last_index_of(Character.new(??.ord)))
      if (!(i).equal?(-1) && (fname.char_at(i)).equal?(Character.new(?..ord)))
        ext = RJava.cast_to_string(fname.substring(i).to_lower_case)
      end
      return find_by_ext(ext)
    end
    
    typesig { [String] }
    # Locate a MimeEntry by the file extension that has been associated
    # with it.
    def find_by_ext(file_extension)
      synchronized(self) do
        return @extension_map.get(file_extension)
      end
    end
    
    typesig { [String] }
    def find_by_description(description)
      synchronized(self) do
        e = elements
        while (e.has_more_elements)
          entry = e.next_element
          if ((description == entry.get_description))
            return entry
          end
        end
        # We failed, now try treating description as type
        return find(description)
      end
    end
    
    typesig { [] }
    def get_temp_file_template
      return self.attr_temp_file_template
    end
    
    typesig { [] }
    def elements
      synchronized(self) do
        return @entries.elements
      end
    end
    
    class_module.module_eval {
      # For backward compatibility -- mailcap format files
      # This is not currently used, but may in the future when we add ability
      # to read BOTH the properties format and the mailcap format.
      
      def mailcap_locations
        defined?(@@mailcap_locations) ? @@mailcap_locations : @@mailcap_locations= nil
      end
      alias_method :attr_mailcap_locations, :mailcap_locations
      
      def mailcap_locations=(value)
        @@mailcap_locations = value
      end
      alias_method :attr_mailcap_locations=, :mailcap_locations=
    }
    
    typesig { [] }
    def load
      synchronized(self) do
        entries = Properties.new
        file = nil
        begin
          is = nil
          # First try to load the user-specific table, if it exists
          user_table_path = System.get_property("content.types.user.table")
          if (!(user_table_path).nil?)
            file = JavaFile.new(user_table_path)
            if (!file.exists)
              # No user-table, try to load the default built-in table.
              file = JavaFile.new(RJava.cast_to_string(System.get_property("java.home") + JavaFile.attr_separator) + "lib" + RJava.cast_to_string(JavaFile.attr_separator) + "content-types.properties")
            end
          else
            # No user table, try to load the default built-in table.
            file = JavaFile.new(RJava.cast_to_string(System.get_property("java.home") + JavaFile.attr_separator) + "lib" + RJava.cast_to_string(JavaFile.attr_separator) + "content-types.properties")
          end
          is = BufferedInputStream.new(FileInputStream.new(file))
          entries.load(is)
          is.close
        rescue IOException => e
          System.err.println("Warning: default mime table not found: " + RJava.cast_to_string(file.get_path))
          return
        end
        parse(entries)
      end
    end
    
    typesig { [Properties] }
    def parse(entries)
      # first, strip out the platform-specific temp file template
      temp_file_template = entries.get("temp.file.template")
      if (!(temp_file_template).nil?)
        entries.remove("temp.file.template")
        self.attr_temp_file_template = temp_file_template
      end
      # now, parse the mime-type spec's
      types = entries.property_names
      while (types.has_more_elements)
        type = types.next_element
        attrs = entries.get_property(type)
        parse(type, attrs)
      end
    end
    
    typesig { [String, String] }
    # Table format:
    # 
    # <entry> ::= <table_tag> | <type_entry>
    # 
    # <table_tag> ::= <table_format_version> | <temp_file_template>
    # 
    # <type_entry> ::= <type_subtype_pair> '=' <type_attrs_list>
    # 
    # <type_subtype_pair> ::= <type> '/' <subtype>
    # 
    # <type_attrs_list> ::= <attr_value_pair> [ ';' <attr_value_pair> ]*
    # | [ <attr_value_pair> ]+
    # 
    # <attr_value_pair> ::= <attr_name> '=' <attr_value>
    # 
    # <attr_name> ::= 'description' | 'action' | 'application'
    # | 'file_extensions' | 'icon'
    # 
    # <attr_value> ::= <legal_char>*
    # 
    # Embedded ';' in an <attr_value> are quoted with leading '\' .
    # 
    # Interpretation of <attr_value> depends on the <attr_name> it is
    # associated with.
    def parse(type, attrs)
      new_entry = MimeEntry.new(type)
      # REMIND handle embedded ';' and '|' and literal '"'
      tokenizer = StringTokenizer.new(attrs, ";")
      while (tokenizer.has_more_tokens)
        pair = tokenizer.next_token
        parse(pair, new_entry)
      end
      add(new_entry)
    end
    
    typesig { [String, MimeEntry] }
    def parse(pair, entry)
      # REMIND add exception handling...
      name = nil
      value = nil
      got_name = false
      tokenizer = StringTokenizer.new(pair, "=")
      while (tokenizer.has_more_tokens)
        if (got_name)
          value = RJava.cast_to_string(tokenizer.next_token.trim)
        else
          name = RJava.cast_to_string(tokenizer.next_token.trim)
          got_name = true
        end
      end
      fill(entry, name, value)
    end
    
    typesig { [MimeEntry, String, String] }
    def fill(entry, name, value)
      if ("description".equals_ignore_case(name))
        entry.set_description(value)
      else
        if ("action".equals_ignore_case(name))
          entry.set_action(get_action_code(value))
        else
          if ("application".equals_ignore_case(name))
            entry.set_command(value)
          else
            if ("icon".equals_ignore_case(name))
              entry.set_image_file_name(value)
            else
              if ("file_extensions".equals_ignore_case(name))
                entry.set_extensions(value)
              end
            end
          end
        end
      end
      # else illegal name exception
    end
    
    typesig { [String] }
    def get_extensions(list)
      tokenizer = StringTokenizer.new(list, ",")
      n = tokenizer.count_tokens
      extensions = Array.typed(String).new(n) { nil }
      i = 0
      while i < n
        extensions[i] = tokenizer.next_token
        i += 1
      end
      return extensions
    end
    
    typesig { [String] }
    def get_action_code(action)
      i = 0
      while i < MimeEntry.attr_action_keywords.attr_length
        if (action.equals_ignore_case(MimeEntry.attr_action_keywords[i]))
          return i
        end
        i += 1
      end
      return MimeEntry::UNKNOWN
    end
    
    typesig { [String] }
    def save(filename)
      synchronized(self) do
        if ((filename).nil?)
          filename = RJava.cast_to_string(System.get_property("user.home" + RJava.cast_to_string(JavaFile.attr_separator) + "lib" + RJava.cast_to_string(JavaFile.attr_separator) + "content-types.properties"))
        end
        return save_as_properties(JavaFile.new(filename))
      end
    end
    
    typesig { [] }
    def get_as_properties
      properties = Properties.new
      e = elements
      while (e.has_more_elements)
        entry = e.next_element
        properties.put(entry.get_type, entry.to_property)
      end
      return properties
    end
    
    typesig { [JavaFile] }
    def save_as_properties(file)
      os = nil
      begin
        os = FileOutputStream.new(file)
        properties = get_as_properties
        properties.put("temp.file.template", self.attr_temp_file_template)
        tag = nil
        user = System.get_property("user.name")
        if (!(user).nil?)
          tag = "; customized for " + user
          properties.save(os, FilePreamble + tag)
        else
          properties.save(os, FilePreamble)
        end
      rescue IOException => e
        e.print_stack_trace
        return false
      ensure
        if (!(os).nil?)
          begin
            os.close
          rescue IOException => e
          end
        end
      end
      return true
    end
    
    private
    alias_method :initialize__mime_table, :initialize
  end
  
end
