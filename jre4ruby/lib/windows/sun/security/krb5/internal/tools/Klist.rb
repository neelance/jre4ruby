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
# 
# 
# (C) Copyright IBM Corp. 1999 All Rights Reserved.
# Copyright 1997 The Open Group Research Institute.  All rights reserved.
module Sun::Security::Krb5::Internal::Tools
  module KlistImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5::Internal::Tools
      include ::Sun::Security::Krb5
      include ::Sun::Security::Krb5::Internal
      include ::Sun::Security::Krb5::Internal::Ccache
      include ::Sun::Security::Krb5::Internal::Ktab
      include_const ::Sun::Security::Krb5::Internal::Crypto, :EType
      include_const ::Sun::Security::Krb5, :KrbCryptoException
      include_const ::Java::Lang, :RuntimeException
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :BufferedReader
      include_const ::Java::Io, :InputStreamReader
      include_const ::Java::Io, :JavaFile
    }
  end
  
  # This class can execute as a command-line tool to list entries in
  # credential cache and key tab.
  # 
  # @author Yanni Zhang
  # @author Ram Marti
  class Klist 
    include_class_members KlistImports
    
    attr_accessor :target
    alias_method :attr_target, :target
    undef_method :target
    alias_method :attr_target=, :target=
    undef_method :target=
    
    # for credentials cache, options are 'f'  and 'e';
    # for  keytab, optionsare 't' and 'K' and 'e'
    attr_accessor :options
    alias_method :attr_options, :options
    undef_method :options
    alias_method :attr_options=, :options=
    undef_method :options=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # the name of credentials cache and keytable.
    attr_accessor :action
    alias_method :attr_action, :action
    undef_method :action
    alias_method :attr_action=, :action=
    undef_method :action=
    
    class_module.module_eval {
      # actions would be 'c' for credentials cache
      # and 'k' for keytable.
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5::DEBUG
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      typesig { [Array.typed(String)] }
      # The main program that can be invoked at command line.
      # <br>Usage: klist
      # [[-c] [-f] [-e]] [-k [-t] [-K]] [name]
      # -c specifes that credential cache is to be listed
      # -k specifies that key tab is to be listed
      # name name of the credentials cache or keytab
      # <br>available options for credential caches:
      # <ul>
      # <li><b>-f</b>  shows credentials flags
      # <li><b>-e</b>  shows the encryption type
      # </ul>
      # available options for keytabs:
      # <li><b>-t</b> shows keytab entry timestamps
      # <li><b>-K</b> shows keytab entry DES keys
      def main(args)
        klist = Klist.new
        if (((args).nil?) || ((args.attr_length).equal?(0)))
          klist.attr_action = Character.new(?c.ord) # default will list default credentials cache.
        else
          klist.process_args(args)
        end
        case (klist.attr_action)
        when Character.new(?c.ord)
          if ((klist.attr_name).nil?)
            klist.attr_target = CredentialsCache.get_instance
            klist.attr_name = CredentialsCache.cache_name
          else
            klist.attr_target = CredentialsCache.get_instance(klist.attr_name)
          end
          if (!(klist.attr_target).nil?)
            klist.display_cache
          else
            klist.display_message("Credentials cache")
            System.exit(-1)
          end
        when Character.new(?k.ord)
          if ((klist.attr_name).nil?)
            klist.attr_target = KeyTab.get_instance
            klist.attr_name = KeyTab.tab_name
          else
            klist.attr_target = KeyTab.get_instance(klist.attr_name)
          end
          if (!(klist.attr_target).nil?)
            klist.display_tab
          else
            klist.display_message("KeyTab")
            System.exit(-1)
          end
        else
          if (!(klist.attr_name).nil?)
            klist.print_help
            System.exit(-1)
          else
            klist.attr_target = CredentialsCache.get_instance
            klist.attr_name = CredentialsCache.cache_name
            if (!(klist.attr_target).nil?)
              klist.display_cache
            else
              klist.display_message("Credentials cache")
              System.exit(-1)
            end
          end
        end
      end
    }
    
    typesig { [Array.typed(String)] }
    # Parses the command line arguments.
    def process_args(args)
      arg = nil
      i = 0
      while i < args.attr_length
        if ((args[i].length >= 2) && (args[i].starts_with("-")))
          arg = Character.new(args[i].char_at(1))
          case (arg.char_value)
          when Character.new(?c.ord)
            @action = Character.new(?c.ord)
          when Character.new(?k.ord)
            @action = Character.new(?k.ord)
          when Character.new(?f.ord)
            @options[1] = Character.new(?f.ord)
          when Character.new(?e.ord)
            @options[0] = Character.new(?e.ord)
          when Character.new(?K.ord)
            @options[1] = Character.new(?K.ord)
          when Character.new(?t.ord)
            @options[2] = Character.new(?t.ord)
          else
            print_help
            System.exit(-1)
          end
        else
          if (!args[i].starts_with("-") && ((i).equal?(args.attr_length - 1)))
            # the argument is the last one.
            @name = RJava.cast_to_string(args[i])
            arg = nil
          else
            print_help # incorrect input format.
            System.exit(-1)
          end
        end
        i += 1
      end
    end
    
    typesig { [] }
    def display_tab
      table = @target
      entries = table.get_entries
      if ((entries.attr_length).equal?(0))
        System.out.println("\nKey tab: " + @name + ", " + " 0 entries found.\n")
      else
        if ((entries.attr_length).equal?(1))
          System.out.println("\nKey tab: " + @name + ", " + RJava.cast_to_string(entries.attr_length) + " entry found.\n")
        else
          System.out.println("\nKey tab: " + @name + ", " + RJava.cast_to_string(entries.attr_length) + " entries found.\n")
        end
        i = 0
        while i < entries.attr_length
          System.out.println("[" + RJava.cast_to_string((i + 1)) + "] " + "Service principal: " + RJava.cast_to_string(entries[i].get_service.to_s))
          System.out.println("\t KVNO: " + RJava.cast_to_string(entries[i].get_key.get_key_version_number))
          if ((@options[0]).equal?(Character.new(?e.ord)))
            key = entries[i].get_key
            System.out.println("\t Key type: " + RJava.cast_to_string(key.get_etype))
          end
          if ((@options[1]).equal?(Character.new(?K.ord)))
            key = entries[i].get_key
            System.out.println("\t Key: " + RJava.cast_to_string(entries[i].get_key_string))
          end
          if ((@options[2]).equal?(Character.new(?t.ord)))
            System.out.println("\t Time stamp: " + RJava.cast_to_string(reformat(entries[i].get_time_stamp.to_date.to_s)))
          end
          i += 1
        end
      end
    end
    
    typesig { [] }
    def display_cache
      cache = @target
      creds = cache.get_creds_list
      if ((creds).nil?)
        System.out.println("No credentials available in the cache " + @name)
        System.exit(-1)
      end
      System.out.println("\nCredentials cache: " + @name)
      default_principal = cache.get_primary_principal.to_s
      num = creds.attr_length
      if ((num).equal?(1))
        System.out.println("\nDefault principal: " + default_principal + ", " + RJava.cast_to_string(creds.attr_length) + " entry found.\n")
      else
        System.out.println("\nDefault principal: " + default_principal + ", " + RJava.cast_to_string(creds.attr_length) + " entries found.\n")
      end
      starttime = nil
      endtime = nil
      service_principal = nil
      etype = nil
      if (!(creds).nil?)
        i = 0
        while i < creds.attr_length
          begin
            starttime = RJava.cast_to_string(reformat(creds[i].get_auth_time.to_date.to_s))
            endtime = RJava.cast_to_string(reformat(creds[i].get_end_time.to_date.to_s))
            service_principal = RJava.cast_to_string(creds[i].get_service_principal.to_s)
            System.out.println("[" + RJava.cast_to_string((i + 1)) + "] " + " Service Principal:  " + service_principal)
            System.out.println("     Valid starting:  " + starttime)
            System.out.println("     Expires:         " + endtime)
            if ((@options[0]).equal?(Character.new(?e.ord)))
              etype = RJava.cast_to_string(EType.to_s(creds[i].get_etype))
              System.out.println("\t Encryption type: " + etype)
            end
            if ((@options[1]).equal?(Character.new(?f.ord)))
              System.out.println("\t Flags:           " + RJava.cast_to_string(creds[i].get_ticket_flags.to_s))
            end
          rescue RealmException => e
            System.out.println("Error reading principal from " + "the entry.")
            if (self.attr_debug)
              e.print_stack_trace
            end
            System.exit(-1)
          end
          i += 1
        end
      else
        System.out.println("\nNo entries found.")
      end
    end
    
    typesig { [String] }
    def display_message(target)
      if ((@name).nil?)
        @name = ""
      end
      System.out.println(target + " " + @name + " not found.")
    end
    
    typesig { [String] }
    # Reformats the date from the form -
    # dow mon dd hh:mm:ss zzz yyyy to mon/dd/yyyy hh:mm
    # where dow is the day of the week, mon is the month,
    # dd is the day of the month, hh is the hour of
    # the day, mm is the minute within the hour,
    # ss is the second within the minute, zzz is the time zone,
    # and yyyy is the year.
    # @param date the string form of Date object.
    def reformat(date)
      return (RJava.cast_to_string(date.substring(4, 7)) + " " + RJava.cast_to_string(date.substring(8, 10)) + ", " + RJava.cast_to_string(date.substring(24)) + " " + RJava.cast_to_string(date.substring(11, 16)))
    end
    
    typesig { [] }
    # Printes out the help information.
    def print_help
      System.out.println("\nUsage: klist " + "[[-c] [-f] [-e]] [-k [-t] [-K]] [name]")
      System.out.println("   name\t name of credentials cache or " + " keytab with the prefix. File-based cache or " + "keytab's prefix is FILE:.")
      System.out.println("   -c specifes that credential cache is to be " + "listed")
      System.out.println("   -k specifies that key tab is to be listed")
      System.out.println("   options for credentials caches:")
      System.out.println("\t-f \t shows credentials flags")
      System.out.println("\t-e \t shows the encryption type")
      System.out.println("   options for keytabs:")
      System.out.println("\t-t \t shows keytab entry timestamps")
      System.out.println("\t-K \t shows keytab entry key value")
      System.out.println("\t-e \t shows keytab entry key type")
      System.out.println("\nUsage: java sun.security.krb5.tools.Klist " + "-help for help.")
    end
    
    typesig { [] }
    def initialize
      @target = nil
      @options = CharArray.new(3)
      @name = nil
      @action = 0
    end
    
    private
    alias_method :initialize__klist, :initialize
  end
  
  Klist.main($*) if $0 == __FILE__
end
