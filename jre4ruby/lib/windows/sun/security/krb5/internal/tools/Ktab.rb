require "rjava"

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
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Tools
  module KtabImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Tools
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Ktab
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include_const ::Java::Lang, :RuntimeException
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :FileOutputStream
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Util, :Arrays
    }
  end
  
  # This class can execute as a command-line tool to help the user manage
  # entires in the key table.
  # Available functions include list/add/update/delete service key(s).
  # 
  # @author Yanni Zhang
  # @author Ram Marti
  class Ktab 
    include_class_members KtabImports
    
    # KeyTabAdmin admin;
    attr_accessor :table
    alias_method :attr_table, :table
    undef_method :table
    alias_method :attr_table=, :table=
    undef_method :table=
    
    attr_accessor :action
    alias_method :attr_action, :action
    undef_method :action
    alias_method :attr_action=, :action=
    undef_method :action=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # name and directory of key table
    attr_accessor :principal
    alias_method :attr_principal, :principal
    undef_method :principal
    alias_method :attr_principal=, :principal=
    undef_method :principal=
    
    attr_accessor :password
    alias_method :attr_password, :password
    undef_method :password
    alias_method :attr_password=, :password=
    undef_method :password=
    
    class_module.module_eval {
      typesig { [Array.typed(String)] }
      # The main program that can be invoked at command line.
      # <br>Usage: ktab <options>
      # <br>available options to Ktab:
      # <ul>
      # <li><b>-l</b>  list the keytab name and entries
      # <li><b>-a</b>  &lt;<i>principal name</i>&gt;
      # (&lt;<i>password</i>&gt;)  add an entry to the keytab.
      # The entry is added only to the keytab. No changes are made to the
      # Kerberos database.
      # <li><b>-d</b>  &lt;<i>principal name</i>&gt;
      # delete an entry from the keytab
      # The entry is deleted only from the keytab. No changes are made to the
      # Kerberos database.
      # <li><b>-k</b>  &lt;<i>keytab name</i> &gt;
      # specify keytab name and path with prefix FILE:
      # <li><b>-help</b> display instructions.
      def main(args)
        ktab = Ktab.new
        if (((args.attr_length).equal?(1)) && (args[0].equals_ignore_case("-help")))
          ktab.print_help
          System.exit(0)
        else
          if (((args).nil?) || ((args.attr_length).equal?(0)))
            ktab.attr_action = Character.new(?l.ord)
          else
            ktab.process_args(args)
          end
        end
        begin
          if ((ktab.attr_name).nil?)
            #  ktab.admin = new KeyTabAdmin();    // use the default keytab.
            ktab.attr_table = KeyTab.get_instance
            if ((ktab.attr_table).nil?)
              if ((ktab.attr_action).equal?(Character.new(?a.ord)))
                ktab.attr_table = KeyTab.create
              else
                System.out.println("No default key table exists.")
                System.exit(-1)
              end
            end
          else
            if ((!(ktab.attr_action).equal?(Character.new(?a.ord))) && !(JavaFile.new(ktab.attr_name)).exists)
              System.out.println("Key table " + RJava.cast_to_string(ktab.attr_name) + " does not exist.")
              System.exit(-1)
            else
              ktab.attr_table = KeyTab.get_instance(ktab.attr_name)
            end
            if ((ktab.attr_table).nil?)
              if ((ktab.attr_action).equal?(Character.new(?a.ord)))
                ktab.attr_table = KeyTab.create(ktab.attr_name)
              else
                System.out.println("The format of key table " + RJava.cast_to_string(ktab.attr_name) + " is incorrect.")
                System.exit(-1)
              end
            end
          end
        rescue RealmException => e
          System.err.println("Error loading key table.")
          System.exit(-1)
        rescue IOException => e
          System.err.println("Error loading key table.")
          System.exit(-1)
        end
        case (ktab.attr_action)
        when Character.new(?l.ord)
          ktab.list_kt
        when Character.new(?a.ord)
          ktab.add_entry
        when Character.new(?d.ord)
          ktab.delete_entry
        else
          ktab.print_help
          System.exit(-1)
        end
      end
    }
    
    typesig { [Array.typed(String)] }
    # Parses the command line arguments.
    def process_args(args)
      arg = nil
      i = 0
      while i < args.attr_length
        if (((args[i].length).equal?(2)) && (args[i].starts_with("-")))
          arg = Character.new(args[i].char_at(1))
        else
          print_help
          System.exit(-1)
        end
        case (arg.char_value)
        when Character.new(?l.ord), Character.new(?L.ord)
          @action = Character.new(?l.ord) # list keytab location, name and entries
        when Character.new(?a.ord), Character.new(?A.ord)
          @action = Character.new(?a.ord) # add a new entry to keytab.
          i += 1
          if ((i < args.attr_length) && (!args[i].starts_with("-")))
            @principal = RJava.cast_to_string(args[i])
          else
            System.out.println("Please specify the principal name" + " after -a option.")
            print_help
            System.exit(-1)
          end
          if ((i + 1 < args.attr_length) && (!args[i + 1].starts_with("-")))
            @password = args[i + 1].to_char_array
            i += 1
          else
            @password = nil # prompt user for password later.
          end
        when Character.new(?d.ord), Character.new(?D.ord)
          @action = Character.new(?d.ord) # delete an entry.
          i += 1
          if ((i < args.attr_length) && (!args[i].starts_with("-")))
            @principal = RJava.cast_to_string(args[i])
          else
            System.out.println("Please specify the principal" + "name of the entry you want to " + " delete after -d option.")
            print_help
            System.exit(-1)
          end
        when Character.new(?k.ord), Character.new(?K.ord)
          i += 1
          if ((i < args.attr_length) && (!args[i].starts_with("-")))
            if (args[i].length >= 5 && args[i].substring(0, 5).equals_ignore_case("FILE:"))
              @name = RJava.cast_to_string(args[i].substring(5))
            else
              @name = RJava.cast_to_string(args[i])
            end
          else
            System.out.println("Please specify the keytab " + "file name and location " + "after -k option")
            print_help
            System.exit(-1)
          end
        else
          print_help
          System.exit(-1)
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Adds a service key to key table. If the specified key table does not
    # exist, the program will automatically generate
    # a new key table.
    def add_entry
      pname = nil
      begin
        pname = PrincipalName.new(@principal)
        if ((pname.get_realm).nil?)
          pname.set_realm(Config.get_instance.get_default_realm)
        end
      rescue KrbException => e
        System.err.println("Failed to add " + @principal + " to keytab.")
        e.print_stack_trace
        System.exit(-1)
      end
      if ((@password).nil?)
        begin
          cis = BufferedReader.new(InputStreamReader.new(System.in))
          System.out.print("Password for " + RJava.cast_to_string(pname.to_s) + ":")
          System.out.flush
          @password = cis.read_line.to_char_array
        rescue IOException => e
          System.err.println("Failed to read the password.")
          e.print_stack_trace
          System.exit(-1)
        end
      end
      begin
        # admin.addEntry(pname, password);
        @table.add_entry(pname, @password)
        Arrays.fill(@password, Character.new(?0.ord)) # clear password
        # admin.save();
        @table.save
        System.out.println("Done!")
        System.out.println("Service key for " + @principal + " is saved in " + RJava.cast_to_string(@table.tab_name))
      rescue KrbException => e
        System.err.println("Failed to add " + @principal + " to keytab.")
        e.print_stack_trace
        System.exit(-1)
      rescue IOException => e
        System.err.println("Failed to save new entry.")
        e.print_stack_trace
        System.exit(-1)
      end
    end
    
    typesig { [] }
    # Lists key table name and entries in it.
    def list_kt
      version = 0
      principal = nil
      # System.out.println("Keytab name: " + admin.getKeyTabName());
      System.out.println("Keytab name: " + RJava.cast_to_string(@table.tab_name))
      # KeyTabEntry[] entries = admin.getEntries();
      entries = @table.get_entries
      if ((!(entries).nil?) && (entries.attr_length > 0))
        System.out.println("KVNO    Principal")
        i = 0
        while i < entries.attr_length
          version = entries[i].get_key.get_key_version_number.int_value
          principal = RJava.cast_to_string(entries[i].get_service.to_s)
          if ((i).equal?(0))
            separator = StringBuffer.new
            j = 0
            while j < 9 + principal.length
              separator.append("-")
              j += 1
            end
            System.out.println(separator.to_s)
          end
          System.out.println("  " + RJava.cast_to_string(version) + "     " + principal)
          i += 1
        end
      else
        System.out.println("0 entry.")
      end
    end
    
    typesig { [] }
    # Deletes an entry from the key table.
    def delete_entry
      pname = nil
      begin
        pname = PrincipalName.new(@principal)
        if ((pname.get_realm).nil?)
          pname.set_realm(Config.get_instance.get_default_realm)
        end
        answer = nil
        cis = BufferedReader.new(InputStreamReader.new(System.in))
        System.out.print("Are you sure you want to " + " delete service key for " + RJava.cast_to_string(pname.to_s) + " in " + RJava.cast_to_string(@table.tab_name) + "?(Y/N) :")
        System.out.flush
        answer = RJava.cast_to_string(cis.read_line)
        if (answer.equals_ignore_case("Y") || answer.equals_ignore_case("Yes"))
        else
          # no error, the user did not want to delete the entry
          System.exit(0)
        end
      rescue KrbException => e
        System.err.println("Error occured while deleting the entry. " + "Deletion failed.")
        e.print_stack_trace
        System.exit(-1)
      rescue IOException => e
        System.err.println("Error occured while deleting the entry. " + " Deletion failed.")
        e.print_stack_trace
        System.exit(-1)
      end
      # admin.deleteEntry(pname);
      @table.delete_entry(pname)
      begin
        @table.save
      rescue IOException => e
        System.err.println("Error occurs while saving the keytab." + "Deletion fails.")
        e.print_stack_trace
        System.exit(-1)
      end
      System.out.println("Done!")
    end
    
    typesig { [] }
    # Prints out the help information.
    def print_help
      System.out.println("\nUsage: ktab " + "<options>")
      System.out.println("available options to Ktab:")
      System.out.println("-l\t\t\t\tlist the keytab name and entries")
      System.out.println("-a <principal name> (<password>)add an entry " + "to the keytab")
      System.out.println("-d <principal name>\t\tdelete an entry from " + "the keytab")
      System.out.println("-k <keytab name>\t\tspecify keytab name and " + " path with prefix FILE:")
    end
    
    typesig { [] }
    def initialize
      @table = nil
      @action = 0
      @name = nil
      @principal = nil
      @password = nil
    end
    
    private
    alias_method :initialize__ktab, :initialize
  end
  
end

Sun::Security::Krb5::Internal::Tools::Ktab.main($*) if $0 == __FILE__
