require "rjava"

# 
# Portions Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Krb5::Internal::Ktab
  module KeyTabImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Ktab
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Crypto
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileInputStream
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Util, :StringTokenizer
    }
  end
  
  # 
  # This class represents key table. The key table functions deal with storing
  # and retrieving service keys for use in authentication exchanges.
  # 
  # @author Yanni Zhang
  class KeyTab 
    include_class_members KeyTabImports
    include KeyTabConstants
    
    attr_accessor :kt_vno
    alias_method :attr_kt_vno, :kt_vno
    undef_method :kt_vno
    alias_method :attr_kt_vno=, :kt_vno=
    undef_method :kt_vno=
    
    class_module.module_eval {
      
      def singleton
        defined?(@@singleton) ? @@singleton : @@singleton= nil
      end
      alias_method :attr_singleton, :singleton
      
      def singleton=(value)
        @@singleton = value
      end
      alias_method :attr_singleton=, :singleton=
      
      const_set_lazy(:DEBUG) { Krb5::DEBUG }
      const_attr_reader  :DEBUG
      
      
      def name
        defined?(@@name) ? @@name : @@name= nil
      end
      alias_method :attr_name, :name
      
      def name=(value)
        @@name = value
      end
      alias_method :attr_name=, :name=
    }
    
    attr_accessor :entries
    alias_method :attr_entries, :entries
    undef_method :entries
    alias_method :attr_entries=, :entries=
    undef_method :entries=
    
    typesig { [String] }
    def initialize(filename)
      @kt_vno = 0
      @entries = Vector.new
      init(filename)
    end
    
    class_module.module_eval {
      typesig { [String] }
      def get_instance(s)
        self.attr_name = (parse(s)).to_s
        if ((self.attr_name).nil?)
          return get_instance
        end
        return get_instance(JavaFile.new(self.attr_name))
      end
      
      typesig { [JavaFile] }
      # 
      # Gets the single instance of KeyTab class.
      # @param file the key tab file.
      # @return single instance of KeyTab;
      # return null if error occurs while reading data out of the file.
      def get_instance(file)
        begin
          if (!(file.exists))
            self.attr_singleton = nil
          else
            fname = file.get_absolute_path
            # Since this class deals with file I/O operations,
            # we want only one class instance existing.
            if (!(self.attr_singleton).nil?)
              kfile = JavaFile.new(self.attr_singleton.attr_name)
              kname = kfile.get_absolute_path
              if (kname.equals_ignore_case(fname))
                if (DEBUG)
                  System.out.println("KeyTab instance already exists")
                end
              end
            else
              self.attr_singleton = KeyTab.new(fname)
            end
          end
        rescue Exception => e
          self.attr_singleton = nil
          if (DEBUG)
            System.out.println("Could not obtain an instance of KeyTab" + (e.get_message).to_s)
          end
        end
        return self.attr_singleton
      end
      
      typesig { [] }
      # 
      # Gets the single instance of KeyTab class.
      # @return single instance of KeyTab; return null if default keytab file
      # does not exist, or error occurs while reading data from the file.
      def get_instance
        begin
          self.attr_name = (get_default_key_tab).to_s
          if (!(self.attr_name).nil?)
            self.attr_singleton = get_instance(JavaFile.new(self.attr_name))
          end
        rescue Exception => e
          self.attr_singleton = nil
          if (DEBUG)
            System.out.println("Could not obtain an instance of KeyTab" + (e.get_message).to_s)
          end
        end
        return self.attr_singleton
      end
      
      typesig { [] }
      # 
      # The location of keytab file will be read from the configuration file
      # If it is not specified, consider user.home as the keytab file's
      # default location.
      def get_default_key_tab
        if (!(self.attr_name).nil?)
          return self.attr_name
        else
          kname = nil
          begin
            keytab_names = Config.get_instance.get_default("default_keytab_name", "libdefaults")
            if (!(keytab_names).nil?)
              st = StringTokenizer.new(keytab_names, " ")
              while (st.has_more_tokens)
                kname = (parse(st.next_token)).to_s
                if (!(kname).nil?)
                  break
                end
              end
            end
          rescue KrbException => e
            kname = (nil).to_s
          end
          if ((kname).nil?)
            user_home = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.home"))
            if ((user_home).nil?)
              user_home = (Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.dir"))).to_s
            end
            if (!(user_home).nil?)
              kname = user_home + (JavaFile.attr_separator).to_s + "krb5.keytab"
            end
          end
          return kname
        end
      end
      
      typesig { [String] }
      def parse(name)
        kname = nil
        if ((name).nil?)
          return nil
        end
        if ((name.length >= 5) && (name.substring(0, 5).equals_ignore_case("FILE:")))
          kname = (name.substring(5)).to_s
        else
          if ((name.length >= 9) && (name.substring(0, 9).equals_ignore_case("ANY:FILE:")))
            # this format found in MIT's krb5.ini.
            kname = (name.substring(9)).to_s
          else
            if ((name.length >= 7) && (name.substring(0, 7).equals_ignore_case("SRVTAB:")))
              # this format found in MIT's krb5.ini.
              kname = (name.substring(7)).to_s
            else
              kname = name
            end
          end
        end
        return kname
      end
    }
    
    typesig { [String] }
    def init(filename)
      synchronized(self) do
        if (!(filename).nil?)
          kis = KeyTabInputStream.new(FileInputStream.new(filename))
          load(kis)
          kis.close
          self.attr_name = filename
        end
      end
    end
    
    typesig { [KeyTabInputStream] }
    def load(kis)
      @entries.clear
      @kt_vno = kis.read_version
      if ((@kt_vno).equal?(KRB5_KT_VNO_1))
        kis.set_native_byte_order
      end
      entry_length = 0
      entry = nil
      while (kis.available > 0)
        entry_length = kis.read_entry_length
        entry = kis.read_entry(entry_length, @kt_vno)
        if (DEBUG)
          System.out.println(">>> KeyTab: load() entry length: " + (entry_length).to_s + "; type: " + ((!(entry).nil? ? entry.attr_key_type : 0)).to_s)
        end
        if (!(entry).nil?)
          @entries.add_element(entry)
        end
      end
    end
    
    typesig { [PrincipalName] }
    # 
    # Reads the service key from the keytab file.
    # @param service the PrincipalName of the requested service.
    # @return the last service key in the keytab
    def read_service_key(service)
      entry = nil
      if (!(@entries).nil?)
        # Find latest entry for this service that has an etype
        # that has been configured for use
        i = @entries.size - 1
        while i >= 0
          entry = @entries.element_at(i)
          if (entry.attr_service.match(service))
            if (EType.is_supported(entry.attr_key_type))
              return EncryptionKey.new(entry.attr_keyblock, entry.attr_key_type, entry.attr_key_version)
            else
              if (DEBUG)
                System.out.println("Found unsupported keytype (" + (entry.attr_key_type).to_s + ") for " + (service).to_s)
              end
            end
          end
          ((i -= 1) + 1)
        end
      end
      return nil
    end
    
    typesig { [PrincipalName] }
    # 
    # Reads all keys for a service from the keytab file that have
    # etypes that have been configured for use.
    # @param service the PrincipalName of the requested service
    # @return an array containing all the service keys
    def read_service_keys(service)
      entry = nil
      key = nil
      size_ = @entries.size
      keys = ArrayList.new(size_)
      if (!(@entries).nil?)
        i = size_ - 1
        while i >= 0
          entry = @entries.element_at(i)
          if (entry.attr_service.match(service))
            if (EType.is_supported(entry.attr_key_type))
              key = EncryptionKey.new(entry.attr_keyblock, entry.attr_key_type, entry.attr_key_version)
              keys.add(key)
              if (DEBUG)
                System.out.println("Added key: " + (entry.attr_key_type).to_s + "version: " + (entry.attr_key_version).to_s)
              end
            else
              if (DEBUG)
                System.out.println("Found unsupported keytype (" + (entry.attr_key_type).to_s + ") for " + (service).to_s)
              end
            end
          end
          ((i -= 1) + 1)
        end
      end
      size_ = keys.size
      if ((size_).equal?(0))
        return nil
      end
      ret_val = Array.typed(EncryptionKey).new(size_) { nil }
      # Sort keys according to default_tkt_enctypes
      pos = 0
      k = nil
      if (DEBUG)
        System.out.println("Ordering keys wrt default_tkt_enctypes list")
      end
      etypes = EType.get_defaults("default_tkt_enctypes")
      if ((etypes).nil? || (etypes).equal?(EType.get_built_in_defaults))
        # Either no supported types specified in default_tkt_enctypes
        # or no default_tkt_enctypes entry at all. For both cases,
        # just return supported keys in the order retrieved
        i_ = 0
        while i_ < size_
          ret_val[((pos += 1) - 1)] = keys.get(i_)
          ((i_ += 1) - 1)
        end
      else
        j = 0
        while j < etypes.attr_length && pos < size_
          target = etypes[j]
          i__ = 0
          while i__ < size_ && pos < size_
            k = keys.get(i__)
            if (!(k).nil? && (k.get_etype).equal?(target))
              if (DEBUG)
                System.out.println((pos).to_s + ": " + (k).to_s)
              end
              ret_val[((pos += 1) - 1)] = k
              keys.set(i__, nil) # Cleared from consideration
            end
            ((i__ += 1) - 1)
          end
          ((j += 1) - 1)
        end
        # copy the rest
        i___ = 0
        while i___ < size_ && pos < size_
          k = keys.get(i___)
          if (!(k).nil?)
            ret_val[((pos += 1) - 1)] = k
          end
          ((i___ += 1) - 1)
        end
      end
      if (!(pos).equal?(size_))
        raise RuntimeException.new("Internal Error: did not copy all keys;expecting " + (size_).to_s + "; got " + (pos).to_s)
      end
      return ret_val
    end
    
    typesig { [PrincipalName] }
    # 
    # Searches for the service entry in the keytab file.
    # The etype of the key must be one that has been configured
    # to be used.
    # @param service the PrincipalName of the requested service.
    # @return true if the entry is found, otherwise, return false.
    def find_service_entry(service)
      entry = nil
      if (!(@entries).nil?)
        i = 0
        while i < @entries.size
          entry = @entries.element_at(i)
          if (entry.attr_service.match(service))
            if (EType.is_supported(entry.attr_key_type))
              return true
            else
              if (DEBUG)
                System.out.println("Found unsupported keytype (" + (entry.attr_key_type).to_s + ") for " + (service).to_s)
              end
            end
          end
          ((i += 1) - 1)
        end
      end
      return false
    end
    
    class_module.module_eval {
      typesig { [] }
      def tab_name
        return self.attr_name
      end
    }
    
    typesig { [PrincipalName, Array.typed(::Java::Char)] }
    # 
    # Adds a new entry in the key table.
    # @param service the service which will have a new entry in the key table.
    # @param psswd the password which generates the key.
    def add_entry(service, psswd)
      enc_keys = EncryptionKey.acquire_secret_keys(psswd, service.get_salt)
      i = 0
      while !(enc_keys).nil? && i < enc_keys.attr_length
        key_type = enc_keys[i].get_etype
        key_value = enc_keys[i].get_bytes
        result = retrieve_entry(service, key_type)
        kvno = 1
        if (!(result).equal?(-1))
          old_entry = @entries.element_at(result)
          kvno = old_entry.attr_key_version
          @entries.remove_element_at(result)
          kvno += 1
        else
          kvno = 1
        end
        new_entry = KeyTabEntry.new(service, service.get_realm, KerberosTime.new(System.current_time_millis), kvno, key_type, key_value)
        if ((@entries).nil?)
          @entries = Vector.new
        end
        @entries.add_element(new_entry)
        ((i += 1) - 1)
      end
    end
    
    typesig { [PrincipalName, ::Java::Int] }
    # 
    # Retrieves the key table entry with the specified service name.
    # @param service the service which may have an entry in the key table.
    # @return -1 if the entry is not found, else return the entry index
    # in the list.
    def retrieve_entry(service, key_type)
      found = -1
      e = nil
      if (!(@entries).nil?)
        i = 0
        while i < @entries.size
          e = @entries.element_at(i)
          if (service.match(e.get_service) && ((key_type).equal?(-1) || (e.attr_key_type).equal?(key_type)))
            return i
          end
          ((i += 1) - 1)
        end
      end
      return found
    end
    
    typesig { [] }
    # 
    # Gets the list of service entries in key table.
    # @return array of <code>KeyTabEntry</code>.
    def get_entries
      if (!(@entries).nil?)
        kentries = Array.typed(KeyTabEntry).new(@entries.size) { nil }
        i = 0
        while i < kentries.attr_length
          kentries[i] = @entries.element_at(i)
          ((i += 1) - 1)
        end
        return kentries
      else
        return nil
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      # 
      # Creates a new default key table.
      def create
        synchronized(self) do
          dname = get_default_key_tab
          return create(dname)
        end
      end
      
      typesig { [String] }
      # 
      # Creates a new default key table.
      def create(name)
        synchronized(self) do
          kos = KeyTabOutputStream.new(FileOutputStream.new(name))
          kos.write_version(KRB5_KT_VNO)
          kos.close
          self.attr_singleton = KeyTab.new(name)
          return self.attr_singleton
        end
      end
    }
    
    typesig { [] }
    # 
    # Saves the file at the directory.
    def save
      synchronized(self) do
        kos = KeyTabOutputStream.new(FileOutputStream.new(self.attr_name))
        kos.write_version(@kt_vno)
        i = 0
        while i < @entries.size
          kos.write_entry(@entries.element_at(i))
          ((i += 1) - 1)
        end
        kos.close
      end
    end
    
    typesig { [PrincipalName] }
    # 
    # Removes an entry from the key table.
    # @param service the service <code>PrincipalName</code>.
    def delete_entry(service)
      result = retrieve_entry(service, -1)
      if (!(result).equal?(-1))
        @entries.remove_element_at(result)
      end
    end
    
    typesig { [JavaFile] }
    # 
    # Creates key table file version.
    # @param file the key table file.
    # @exception IOException.
    def create_version(file)
      synchronized(self) do
        kos = KeyTabOutputStream.new(FileOutputStream.new(file))
        kos.write16(KRB5_KT_VNO)
        kos.close
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      def refresh
        if (!(self.attr_singleton).nil?)
          if (DEBUG)
            System.out.println("Refreshing Keytab")
          end
          self.attr_singleton = nil
        end
      end
    }
    
    private
    alias_method :initialize__key_tab, :initialize
  end
  
end
