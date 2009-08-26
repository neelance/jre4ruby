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
module Sun::Security::Krb5
  module ConfigImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :StringTokenizer
      include_const ::Sun::Security::Krb5::Internal::Crypto, :EType
      include ::Sun::Security::Krb5::Internal::Ktab
    }
  end
  
  # This class maintains key-value pairs of Kerberos configurable constants
  # from configuration file or from user specified system properties.
  class Config 
    include_class_members ConfigImports
    
    class_module.module_eval {
      # Only allow a single instance of Config.
      
      def singleton
        defined?(@@singleton) ? @@singleton : @@singleton= nil
      end
      alias_method :attr_singleton, :singleton
      
      def singleton=(value)
        @@singleton = value
      end
      alias_method :attr_singleton=, :singleton=
    }
    
    # Hashtable used to store configuration infomation.
    attr_accessor :stanza_table
    alias_method :attr_stanza_table, :stanza_table
    undef_method :stanza_table
    alias_method :attr_stanza_table=, :stanza_table=
    undef_method :stanza_table=
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Sun::Security::Krb5::Internal::Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      # these are used for hexdecimal calculation.
      const_set_lazy(:BASE16_0) { 1 }
      const_attr_reader  :BASE16_0
      
      const_set_lazy(:BASE16_1) { 16 }
      const_attr_reader  :BASE16_1
      
      const_set_lazy(:BASE16_2) { 16 * 16 }
      const_attr_reader  :BASE16_2
      
      const_set_lazy(:BASE16_3) { 16 * 16 * 16 }
      const_attr_reader  :BASE16_3
    }
    
    attr_accessor :default_realm
    alias_method :attr_default_realm, :default_realm
    undef_method :default_realm
    alias_method :attr_default_realm=, :default_realm=
    undef_method :default_realm=
    
    class_module.module_eval {
      JNI.native_method :Java_sun_security_krb5_Config_getWindowsDirectory, [:pointer, :long], :long
      typesig { [] }
      # default kdc realm.
      # used for native interface
      def get_windows_directory
        JNI.__send__(:Java_sun_security_krb5_Config_getWindowsDirectory, JNI.env, self.jni_id)
      end
      
      typesig { [] }
      # Gets an instance of Config class. One and only one instance (the
      # singleton) is returned.
      # 
      # @exception KrbException if error occurs when constructing a Config
      # instance. Possible causes would be configuration file not
      # found, either of java.security.krb5.realm or java.security.krb5.kdc
      # not specified, error reading configuration file.
      def get_instance
        synchronized(self) do
          if ((self.attr_singleton).nil?)
            self.attr_singleton = Config.new
          end
          return self.attr_singleton
        end
      end
      
      typesig { [] }
      # Refresh and reload the Configuration. This could involve,
      # for example reading the Configuration file again or getting
      # the java.security.krb5.* system properties again.
      # 
      # @exception KrbException if error occurs when constructing a Config
      # instance. Possible causes would be configuration file not
      # found, either of java.security.krb5.realm or java.security.krb5.kdc
      # not specified, error reading configuration file.
      def refresh
        synchronized(self) do
          self.attr_singleton = Config.new
          KeyTab.refresh
        end
      end
    }
    
    typesig { [] }
    # Private constructor - can not be instantiated externally.
    def initialize
      @stanza_table = nil
      @default_realm = nil
      # If these two system properties are being specified by the user,
      # we ignore configuration file. If either one system property is
      # specified, we throw exception. If neither of them are specified,
      # we load the information from configuration file.
      kdchost = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.security.krb5.kdc"))
      @default_realm = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.security.krb5.realm")))
      if (((kdchost).nil? && !(@default_realm).nil?) || ((@default_realm).nil? && !(kdchost).nil?))
        raise KrbException.new("System property java.security.krb5.kdc and " + "java.security.krb5.realm both must be set or " + "neither must be set.")
      end
      if (!(kdchost).nil?)
        # If configuration information is only specified by
        # properties java.security.krb5.kdc and
        # java.security.krb5.realm, we put both in the hashtable
        # under [libdefaults].
        kdcs = Hashtable.new
        kdcs.put("default_realm", @default_realm)
        # The user can specify a list of kdc hosts separated by ":"
        kdchost = RJava.cast_to_string(kdchost.replace(Character.new(?:.ord), Character.new(?\s.ord)))
        kdcs.put("kdc", kdchost)
        @stanza_table = Hashtable.new
        @stanza_table.put("libdefaults", kdcs)
      else
        # Read the Kerberos configuration file
        begin
          config_file = nil
          config_file = load_config_file
          @stanza_table = parse_stanza_table(config_file)
        rescue IOException => ioe
          ke = KrbException.new("Could not load " + "configuration file " + RJava.cast_to_string(ioe.get_message))
          ke.init_cause(ioe)
          raise (ke)
        end
      end
    end
    
    typesig { [String] }
    # Gets the default int value for the specified name.
    # @param name the name.
    # @return the default Integer, null is returned if no such name and
    # value are found in configuration file, or error occurs when parsing
    # string to integer.
    def get_default_int_value(name)
      result = nil
      value = JavaInteger::MIN_VALUE
      result = RJava.cast_to_string(get_default(name))
      if (!(result).nil?)
        begin
          value = parse_int_value(result)
        rescue NumberFormatException => e
          if (self.attr_debug)
            System.out.println("Exception in getting value of " + name + " " + RJava.cast_to_string(e.get_message))
            System.out.println("Setting " + name + " to minimum value")
          end
          value = JavaInteger::MIN_VALUE
        end
      end
      return value
    end
    
    typesig { [String, String] }
    # Gets the default int value for the specified name in the specified
    # section. <br>This method is quicker by using section name as the
    # search key.
    # @param name the name.
    # @param sectio the name string of the section.
    # @return the default Integer, null is returned if no such name and
    # value are found in configuration file, or error occurs when parsing
    # string to integer.
    def get_default_int_value(name, section)
      result = nil
      value = JavaInteger::MIN_VALUE
      result = RJava.cast_to_string(get_default(name, section))
      if (!(result).nil?)
        begin
          value = parse_int_value(result)
        rescue NumberFormatException => e
          if (self.attr_debug)
            System.out.println("Exception in getting value of " + name + " in section " + section + " " + RJava.cast_to_string(e.get_message))
            System.out.println("Setting " + name + " to minimum value")
          end
          value = JavaInteger::MIN_VALUE
        end
      end
      return value
    end
    
    typesig { [String] }
    # Gets the default string value for the specified name.
    # @param name the name.
    # @return the default value, null is returned if it cannot be found.
    def get_default(name)
      if ((@stanza_table).nil?)
        return nil
      else
        return get_default(name, @stanza_table)
      end
    end
    
    typesig { [String, Hashtable] }
    # This method does the real job to recursively search through the
    # stanzaTable.
    # @param k the key string.
    # @param t stanzaTable or sub hashtable within it.
    # @return the value found in config file, returns null if no value
    # matched with the key is found.
    def get_default(k, t)
      result = nil
      key = nil
      if (!(@stanza_table).nil?)
        e = t.keys
        while e.has_more_elements
          key = RJava.cast_to_string(e.next_element)
          ob = t.get(key)
          if (ob.is_a?(Hashtable))
            result = RJava.cast_to_string(get_default(k, ob))
            if (!(result).nil?)
              return result
            end
          else
            if (key.equals_ignore_case(k))
              if (ob.is_a?(String))
                return (t.get(key))
              else
                if (ob.is_a?(Vector))
                  result = ""
                  length = (ob).size
                  i = 0
                  while i < length
                    if ((i).equal?(length - 1))
                      result += RJava.cast_to_string(((ob).element_at(i)))
                    else
                      result += RJava.cast_to_string(((ob).element_at(i))) + " "
                    end
                    i += 1
                  end
                  return result
                end
              end
            end
          end
        end
      end
      return result
    end
    
    typesig { [String, String] }
    # Gets the default string value for the specified name in the
    # specified section.
    # <br>This method is quicker by using the section name as the search key.
    # @param name the name.
    # @param section the name of the section.
    # @return the default value, null is returned if it cannot be found.
    def get_default(name, section)
      stanza_name = nil
      result = nil
      sub_table = nil
      # In the situation when kdc is specified by
      # java.security.krb5.kdc, we get the kdc from [libdefaults] in
      # hashtable.
      if (name.equals_ignore_case("kdc") && (!section.equals_ignore_case("libdefaults")) && (!(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.security.krb5.kdc"))).nil?))
        result = RJava.cast_to_string(get_default("kdc", "libdefaults"))
        return result
      end
      if (!(@stanza_table).nil?)
        e = @stanza_table.keys
        while e.has_more_elements
          stanza_name = RJava.cast_to_string(e.next_element)
          sub_table = @stanza_table.get(stanza_name)
          if (stanza_name.equals_ignore_case(section))
            if (sub_table.contains_key(name))
              return (sub_table.get(name))
            end
          else
            if (sub_table.contains_key(section))
              ob = sub_table.get(section)
              if (ob.is_a?(Hashtable))
                temp = ob
                if (temp.contains_key(name))
                  object = temp.get(name)
                  if (object.is_a?(Vector))
                    result = ""
                    length = (object).size
                    i = 0
                    while i < length
                      if ((i).equal?(length - 1))
                        result += RJava.cast_to_string(((object).element_at(i)))
                      else
                        result += RJava.cast_to_string(((object).element_at(i))) + " "
                      end
                      i += 1
                    end
                  else
                    result = RJava.cast_to_string(object)
                  end
                end
              end
            end
          end
        end
      end
      return result
    end
    
    typesig { [String] }
    # Gets the default boolean value for the specified name.
    # @param name the name.
    # @return the default boolean value, false is returned if it cannot be
    # found.
    def get_default_boolean_value(name)
      val = nil
      if ((@stanza_table).nil?)
        val = RJava.cast_to_string(nil)
      else
        val = RJava.cast_to_string(get_default(name, @stanza_table))
      end
      if (!(val).nil? && val.equals_ignore_case("true"))
        return true
      else
        return false
      end
    end
    
    typesig { [String, String] }
    # Gets the default boolean value for the specified name in the
    # specified section.
    # <br>This method is quicker by using the section name as the search key.
    # @param name the name.
    # @param section the name of the section.
    # @return the default boolean value, false is returned if it cannot be
    # found.
    def get_default_boolean_value(name, section)
      val = get_default(name, section)
      if (!(val).nil? && val.equals_ignore_case("true"))
        return true
      else
        return false
      end
    end
    
    typesig { [String] }
    # Parses a string to an integer. The convertible strings include the
    # string representations of positive integers, negative integers, and
    # hex decimal integers.  Valid inputs are, e.g., -1234, +1234,
    # 0x40000.
    # 
    # @param input the String to be converted to an Integer.
    # @return an numeric value represented by the string
    # @exception NumberFormationException if the String does not contain a
    # parsable integer.
    def parse_int_value(input)
      value = 0
      if (input.starts_with("+"))
        temp = input.substring(1)
        return JavaInteger.parse_int(temp)
      else
        if (input.starts_with("0x"))
          temp = input.substring(2)
          chars = temp.to_char_array
          if (chars.attr_length > 8)
            raise NumberFormatException.new
          else
            i = 0
            while i < chars.attr_length
              index = chars.attr_length - i - 1
              case (chars[i])
              when Character.new(?0.ord)
                value += 0
              when Character.new(?1.ord)
                value += 1 * get_base(index)
              when Character.new(?2.ord)
                value += 2 * get_base(index)
              when Character.new(?3.ord)
                value += 3 * get_base(index)
              when Character.new(?4.ord)
                value += 4 * get_base(index)
              when Character.new(?5.ord)
                value += 5 * get_base(index)
              when Character.new(?6.ord)
                value += 6 * get_base(index)
              when Character.new(?7.ord)
                value += 7 * get_base(index)
              when Character.new(?8.ord)
                value += 8 * get_base(index)
              when Character.new(?9.ord)
                value += 9 * get_base(index)
              when Character.new(?a.ord), Character.new(?A.ord)
                value += 10 * get_base(index)
              when Character.new(?b.ord), Character.new(?B.ord)
                value += 11 * get_base(index)
              when Character.new(?c.ord), Character.new(?C.ord)
                value += 12 * get_base(index)
              when Character.new(?d.ord), Character.new(?D.ord)
                value += 13 * get_base(index)
              when Character.new(?e.ord), Character.new(?E.ord)
                value += 14 * get_base(index)
              when Character.new(?f.ord), Character.new(?F.ord)
                value += 15 * get_base(index)
              else
                raise NumberFormatException.new("Invalid numerical format")
              end
              i += 1
            end
          end
          if (value < 0)
            raise NumberFormatException.new("Data overflow.")
          end
        else
          value = JavaInteger.parse_int(input)
        end
      end
      return value
    end
    
    typesig { [::Java::Int] }
    def get_base(i)
      result = 16
      case (i)
      when 0
        result = BASE16_0
      when 1
        result = BASE16_1
      when 2
        result = BASE16_2
      when 3
        result = BASE16_3
      else
        j = 1
        while j < i
          result *= 16
          j += 1
        end
      end
      return result
    end
    
    typesig { [String, String] }
    # Finds the matching value in the hashtable.
    def find(key1, key2)
      result = nil
      if ((!(@stanza_table).nil?) && (!((result = RJava.cast_to_string((((@stanza_table.get(key1))).get(key2))))).nil?))
        return result
      else
        return ""
      end
    end
    
    typesig { [] }
    # Reads name/value pairs to the memory from the configuration
    # file. The default location of the configuration file is in java home
    # directory.
    # 
    # Configuration file contains information about the default realm,
    # ticket parameters, location of the KDC and the admin server for
    # known realms, etc. The file is divided into sections. Each section
    # contains one or more name/value pairs with one pair per line. A
    # typical file would be:
    # [libdefaults]
    # default_realm = EXAMPLE.COM
    # default_tgs_enctypes = des-cbc-md5
    # default_tkt_enctypes = des-cbc-md5
    # [realms]
    # EXAMPLE.COM = {
    # kdc = kerberos.example.com
    # kdc = kerberos-1.example.com
    # admin_server = kerberos.example.com
    # }
    # SAMPLE_COM = {
    # kdc = orange.sample.com
    # admin_server = orange.sample.com
    # }
    # [domain_realm]
    # blue.sample.com = TEST.SAMPLE.COM
    # .backup.com     = EXAMPLE.COM
    def load_config_file
      begin
        file_name = get_file_name
        if (!(file_name == ""))
          br = BufferedReader.new(InputStreamReader.new(Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedExceptionAction.class == Class ? Java::Security::PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members Config
            include Java::Security::PrivilegedExceptionAction if Java::Security::PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              return self.class::FileInputStream.new(file_name)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))))
          line = nil
          v = Vector.new
          previous = nil
          while (!((line = RJava.cast_to_string(br.read_line))).nil?)
            # ignore comments and blank line in the configuration file.
            # Comments start with #.
            if (!(line.starts_with("#") || line.trim.is_empty))
              current = line.trim
              # In practice, a subsection might look like:
              # EXAMPLE.COM =
              # {
              # kdc = kerberos.example.com
              # ...
              # }
              # Before parsed into stanza table, it needs to be
              # converted into formal style:
              # EXAMPLE.COM = {
              # kdc = kerberos.example.com
              # ...
              # }
              # 
              # So, if a line is "{", adhere to the previous line.
              if ((current == "{"))
                if ((previous).nil?)
                  raise IOException.new("Config file should not start with \"{\"")
                end
                previous += " " + current
              else
                if (!(previous).nil?)
                  v.add_element(previous)
                end
                previous = current
              end
            end
          end
          if (!(previous).nil?)
            v.add_element(previous)
          end
          br.close
          return v
        end
        return nil
      rescue Java::Security::PrivilegedActionException => pe
        raise pe.get_exception
      end
    end
    
    typesig { [Vector] }
    # Parses stanza names and values from configuration file to
    # stanzaTable (Hashtable). Hashtable key would be stanza names,
    # (libdefaults, realms, domain_realms, etc), and the hashtable value
    # would be another hashtable which contains the key-value pairs under
    # a stanza name.
    def parse_stanza_table(v)
      if ((v).nil?)
        raise KrbException.new("I/O error while reading" + " configuration file.")
      end
      table = Hashtable.new
      i = 0
      while i < v.size
        line = v.element_at(i).trim
        if (line.equals_ignore_case("[realms]"))
          count = i + 1
          while count < v.size + 1
            # find the next stanza name
            if (((count).equal?(v.size)) || (v.element_at(count).starts_with("[")))
              temp = Hashtable.new
              temp = parse_realm_field(v, i + 1, count)
              table.put("realms", temp)
              i = count - 1
              break
            end
            count += 1
          end
        else
          if (line.equals_ignore_case("[capaths]"))
            count = i + 1
            while count < v.size + 1
              # find the next stanza name
              if (((count).equal?(v.size)) || (v.element_at(count).starts_with("[")))
                temp = Hashtable.new
                temp = parse_realm_field(v, i + 1, count)
                table.put("capaths", temp)
                i = count - 1
                break
              end
              count += 1
            end
          else
            if (line.starts_with("[") && line.ends_with("]"))
              key = line.substring(1, line.length - 1)
              count = i + 1
              while count < v.size + 1
                # find the next stanza name
                if (((count).equal?(v.size)) || (v.element_at(count).starts_with("[")))
                  temp = parse_field(v, i + 1, count)
                  table.put(key, temp)
                  i = count - 1
                  break
                end
                count += 1
              end
            end
          end
        end
        i += 1
      end
      return table
    end
    
    typesig { [] }
    # Gets the default configuration file name. The file will be searched
    # in a list of possible loations in the following order:
    # 1. the location and file name defined by system property
    # "java.security.krb5.conf",
    # 2. at Java home lib\security directory with "krb5.conf" name,
    # 3. "krb5.ini" at Java home,
    # 4. at windows directory with the name of "krb5.ini" for Windows,
    # /etc/krb5/krb5.conf for Solaris, /etc/krb5.conf for Linux.
    def get_file_name
      name = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.security.krb5.conf"))
      if (!(name).nil?)
        temp = Java::Security::AccessController.do_privileged(FileExistsAction.new(name))
        if (temp)
          return name
        end
      else
        name = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("java.home")) + JavaFile.attr_separator) + "lib" + RJava.cast_to_string(JavaFile.attr_separator) + "security" + RJava.cast_to_string(JavaFile.attr_separator) + "krb5.conf"
        temp = Java::Security::AccessController.do_privileged(FileExistsAction.new(name))
        if (temp)
          return name
        else
          osname = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("os.name"))
          if (osname.starts_with("Windows"))
            begin
              Credentials.ensure_loaded
            rescue JavaException => e
              # ignore exceptions
            end
            if (Credentials.attr_already_loaded)
              if (((name = RJava.cast_to_string(get_windows_directory))).nil?)
                name = "c:\\winnt\\krb5.ini"
              else
                if (name.ends_with("\\"))
                  name += "krb5.ini"
                else
                  name += "\\krb5.ini"
                end
              end
            else
              name = "c:\\winnt\\krb5.ini"
            end
          else
            if (osname.starts_with("SunOS"))
              name = "/etc/krb5/krb5.conf"
            else
              if (osname.starts_with("Linux"))
                name = "/etc/krb5.conf"
              end
            end
          end
        end
      end
      if (self.attr_debug)
        System.out.println("Config name: " + name)
      end
      return name
    end
    
    typesig { [Vector, ::Java::Int, ::Java::Int] }
    # Parses key-value pairs under a stanza name.
    def parse_field(v, start, end_)
      table = Hashtable.new
      line = nil
      i = start
      while i < end_
        line = RJava.cast_to_string(v.element_at(i))
        j = 0
        while j < line.length
          if ((line.char_at(j)).equal?(Character.new(?=.ord)))
            key = (line.substring(0, j)).trim
            value = (line.substring(j + 1)).trim
            table.put(key, value)
            break
          end
          j += 1
        end
        i += 1
      end
      return table
    end
    
    typesig { [Vector, ::Java::Int, ::Java::Int] }
    # Parses key-value pairs under [realms].  The key would be the realm
    # name, the value would be another hashtable which contains
    # information for the realm given within a pair of braces.
    def parse_realm_field(v, start, end_)
      table = Hashtable.new
      line = nil
      i = start
      while i < end_
        line = RJava.cast_to_string(v.element_at(i).trim)
        if (line.ends_with("{"))
          key = ""
          j = 0
          while j < line.length
            if ((line.char_at(j)).equal?(Character.new(?=.ord)))
              key = RJava.cast_to_string(line.substring(0, j).trim)
              # get the key
              break
            end
            j += 1
          end
          k = i + 1
          while k < end_
            found = false
            line = RJava.cast_to_string(v.element_at(k).trim)
            l = 0
            while l < line.length
              if ((line.char_at(l)).equal?(Character.new(?}.ord)))
                found = true
                break
              end
              l += 1
            end
            if ((found).equal?(true))
              temp = parse_realm_field_ex(v, i + 1, k)
              table.put(key, temp)
              i = k
              found = false
              break
            end
            k += 1
          end
        end
        i += 1
      end
      return table
    end
    
    typesig { [Vector, ::Java::Int, ::Java::Int] }
    # Parses key-value pairs within each braces under [realms].
    def parse_realm_field_ex(v, start, end_)
      table = Hashtable.new
      key_vector = Vector.new
      name_vector = Vector.new
      line = ""
      key = nil
      i = start
      while i < end_
        line = RJava.cast_to_string(v.element_at(i))
        j = 0
        while j < line.length
          if ((line.char_at(j)).equal?(Character.new(?=.ord)))
            index = 0
            key = RJava.cast_to_string(line.substring(0, j - 1).trim)
            if (!exists(key, key_vector))
              key_vector.add_element(key)
              name_vector = Vector.new
            else
              name_vector = table.get(key)
            end
            name_vector.add_element((line.substring(j + 1)).trim)
            table.put(key, name_vector)
            break
          end
          j += 1
        end
        i += 1
      end
      return table
    end
    
    typesig { [String, Vector] }
    # Compares the key with the known keys to see if it exists.
    def exists(key, v)
      exists_ = false
      i = 0
      while i < v.size
        if ((((v.element_at(i))) == key))
          exists_ = true
        end
        i += 1
      end
      return exists_
    end
    
    typesig { [] }
    # For testing purpose. This method lists all information being parsed from
    # the configuration file to the hashtable.
    def list_table
      list_table(@stanza_table)
    end
    
    typesig { [Hashtable] }
    def list_table(table)
      v = Vector.new
      key = nil
      if (!(@stanza_table).nil?)
        e = table.keys
        while e.has_more_elements
          key = RJava.cast_to_string(e.next_element)
          object = table.get(key)
          if ((table).equal?(@stanza_table))
            System.out.println("[" + key + "]")
          end
          if (object.is_a?(Hashtable))
            if (!(table).equal?(@stanza_table))
              System.out.println("\t" + key + " = {")
            end
            list_table(object)
            if (!(table).equal?(@stanza_table))
              System.out.println("\t}")
            end
          else
            if (object.is_a?(String))
              System.out.println("\t" + key + " = " + RJava.cast_to_string(table.get(key)))
            else
              if (object.is_a?(Vector))
                v = object
                i = 0
                while i < v.size
                  System.out.println("\t" + key + " = " + RJava.cast_to_string(v.element_at(i)))
                  i += 1
                end
              end
            end
          end
        end
      else
        System.out.println("Configuration file not found.")
      end
    end
    
    typesig { [String] }
    # Returns the default encryption types.
    def default_etype(enctypes)
      default_enctypes = nil
      default_enctypes = RJava.cast_to_string(get_default(enctypes, "libdefaults"))
      delim = " "
      st = nil
      etype = nil
      if ((default_enctypes).nil?)
        if (self.attr_debug)
          System.out.println("Using builtin default etypes for " + enctypes)
        end
        etype = EType.get_built_in_defaults
      else
        j = 0
        while j < default_enctypes.length
          if ((default_enctypes.substring(j, j + 1) == ","))
            # only two delimiters are allowed to use
            # according to Kerberos DCE doc.
            delim = ","
            break
          end
          j += 1
        end
        st = StringTokenizer.new(default_enctypes, delim)
        len = st.count_tokens
        ls = ArrayList.new(len)
        type = 0
        i = 0
        while i < len
          type = get_type(st.next_token)
          if ((!(type).equal?(-1)) && (EType.is_supported(type)))
            ls.add(type)
          end
          i += 1
        end
        if ((ls.size).equal?(0))
          if (self.attr_debug)
            System.out.println("no supported default etypes for " + enctypes)
          end
          return nil
        else
          etype = Array.typed(::Java::Int).new(ls.size) { 0 }
          i_ = 0
          while i_ < etype.attr_length
            etype[i_] = ls.get(i_)
            i_ += 1
          end
        end
      end
      if (self.attr_debug)
        System.out.print("default etypes for " + enctypes + ":")
        i = 0
        while i < etype.attr_length
          System.out.print(" " + RJava.cast_to_string(etype[i]))
          i += 1
        end
        System.out.println(".")
      end
      return etype
    end
    
    typesig { [String] }
    # Get the etype and checksum value for the specified encryption and
    # checksum type.
    # 
    # 
    # 
    # This method converts the string representation of encryption type and
    # checksum type to int value that can be later used by EType and
    # Checksum classes.
    def get_type(input)
      result = -1
      if ((input).nil?)
        return result
      end
      if (input.starts_with("d") || (input.starts_with("D")))
        if (input.equals_ignore_case("des-cbc-crc"))
          result = EncryptedData::ETYPE_DES_CBC_CRC
        else
          if (input.equals_ignore_case("des-cbc-md5"))
            result = EncryptedData::ETYPE_DES_CBC_MD5
          else
            if (input.equals_ignore_case("des-mac"))
              result = Checksum::CKSUMTYPE_DES_MAC
            else
              if (input.equals_ignore_case("des-mac-k"))
                result = Checksum::CKSUMTYPE_DES_MAC_K
              else
                if (input.equals_ignore_case("des-cbc-md4"))
                  result = EncryptedData::ETYPE_DES_CBC_MD4
                else
                  if (input.equals_ignore_case("des3-cbc-sha1") || input.equals_ignore_case("des3-hmac-sha1") || input.equals_ignore_case("des3-cbc-sha1-kd") || input.equals_ignore_case("des3-cbc-hmac-sha1-kd"))
                    result = EncryptedData::ETYPE_DES3_CBC_HMAC_SHA1_KD
                  end
                end
              end
            end
          end
        end
      else
        if (input.starts_with("a") || (input.starts_with("A")))
          # AES
          if (input.equals_ignore_case("aes128-cts") || input.equals_ignore_case("aes128-cts-hmac-sha1-96"))
            result = EncryptedData::ETYPE_AES128_CTS_HMAC_SHA1_96
          else
            if (input.equals_ignore_case("aes256-cts") || input.equals_ignore_case("aes256-cts-hmac-sha1-96"))
              result = EncryptedData::ETYPE_AES256_CTS_HMAC_SHA1_96
              # ARCFOUR-HMAC
            else
              if (input.equals_ignore_case("arcfour-hmac") || input.equals_ignore_case("arcfour-hmac-md5"))
                result = EncryptedData::ETYPE_ARCFOUR_HMAC
              end
            end
          end
          # RC4-HMAC
        else
          if (input.equals_ignore_case("rc4-hmac"))
            result = EncryptedData::ETYPE_ARCFOUR_HMAC
          else
            if (input.equals_ignore_case("CRC32"))
              result = Checksum::CKSUMTYPE_CRC32
            else
              if (input.starts_with("r") || (input.starts_with("R")))
                if (input.equals_ignore_case("rsa-md5"))
                  result = Checksum::CKSUMTYPE_RSA_MD5
                else
                  if (input.equals_ignore_case("rsa-md5-des"))
                    result = Checksum::CKSUMTYPE_RSA_MD5_DES
                  end
                end
              else
                if (input.equals_ignore_case("hmac-sha1-des3-kd"))
                  result = Checksum::CKSUMTYPE_HMAC_SHA1_DES3_KD
                else
                  if (input.equals_ignore_case("hmac-sha1-96-aes128"))
                    result = Checksum::CKSUMTYPE_HMAC_SHA1_96_AES128
                  else
                    if (input.equals_ignore_case("hmac-sha1-96-aes256"))
                      result = Checksum::CKSUMTYPE_HMAC_SHA1_96_AES256
                    else
                      if (input.equals_ignore_case("hmac-md5-rc4") || input.equals_ignore_case("hmac-md5-arcfour") || input.equals_ignore_case("hmac-md5-enc"))
                        result = Checksum::CKSUMTYPE_HMAC_MD5_ARCFOUR
                      else
                        if (input.equals_ignore_case("NULL"))
                          result = EncryptedData::ETYPE_NULL
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      return result
    end
    
    typesig { [String] }
    # Resets the default kdc realm.
    # We do not need to synchronize these methods since assignments are atomic
    def reset_default_realm(realm)
      @default_realm = realm
      if (self.attr_debug)
        System.out.println(">>> Config reset default kdc " + @default_realm)
      end
    end
    
    typesig { [] }
    # Check to use addresses in tickets
    # use addresses if "no_addresses" or "noaddresses" is set to false
    def use_addresses
      use_addr = false
      # use addresses if "no_addresses" is set to false
      value = get_default("no_addresses", "libdefaults")
      use_addr = (!(value).nil? && value.equals_ignore_case("false"))
      if ((use_addr).equal?(false))
        # use addresses if "noaddresses" is set to false
        value = RJava.cast_to_string(get_default("noaddresses", "libdefaults"))
        use_addr = (!(value).nil? && value.equals_ignore_case("false"))
      end
      return use_addr
    end
    
    typesig { [] }
    # Gets default realm.
    def get_default_realm
      return get_default("default_realm", "libdefaults")
    end
    
    typesig { [String] }
    # Returns a list of KDC's with each KDC separated by a space
    # 
    # @param realm the realm for which the master KDC is desired
    # @return the list of KDCs
    def get_kdclist(realm)
      if ((realm).nil?)
        realm = RJava.cast_to_string(get_default_realm)
      end
      kdcs = get_default("kdc", realm)
      if ((kdcs).nil?)
        return nil
      end
      return kdcs
    end
    
    class_module.module_eval {
      const_set_lazy(:FileExistsAction) { Class.new do
        include_class_members Config
        include Java::Security::PrivilegedAction
        
        attr_accessor :file_name
        alias_method :attr_file_name, :file_name
        undef_method :file_name
        alias_method :attr_file_name=, :file_name=
        undef_method :file_name=
        
        typesig { [self::String] }
        def initialize(file_name)
          @file_name = nil
          @file_name = file_name
        end
        
        typesig { [] }
        def run
          return self.class::JavaFile.new(@file_name).exists
        end
        
        private
        alias_method :initialize__file_exists_action, :initialize
      end }
    }
    
    private
    alias_method :initialize__config, :initialize
  end
  
end
