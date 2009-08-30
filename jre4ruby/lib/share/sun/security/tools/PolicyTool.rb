require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Tools
  module PolicyToolImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Tools
      include ::Java::Io
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :MalformedURLException
      include ::Java::Lang::Reflect
      include_const ::Java::Text, :Collator
      include_const ::Java::Text, :MessageFormat
      include_const ::Sun::Misc, :BASE64Decoder
      include_const ::Sun::Security::Provider::PolicyParser, :PermissionEntry
      include_const ::Sun::Security::Util, :PropertyExpander
      include_const ::Sun::Security::Util::PropertyExpander, :ExpandException
      include ::Java::Awt
      include ::Java::Awt::Event
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include ::Java::Security
      include ::Sun::Security::Provider
      include_const ::Sun::Security::Util, :PolicyUtil
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Java::Util, :HashSet
    }
  end
  
  # PolicyTool may be used by users and administrators to configure the
  # overall java security policy (currently stored in the policy file).
  # Using PolicyTool administators may add and remove policies from
  # the policy file. <p>
  # 
  # @see java.security.Policy
  # @since   1.2
  class PolicyTool 
    include_class_members PolicyToolImports
    
    class_module.module_eval {
      # for i18n
      const_set_lazy(:Rb) { Java::Util::ResourceBundle.get_bundle("sun.security.util.Resources") }
      const_attr_reader  :Rb
      
      const_set_lazy(:Collator) { Collator.get_instance }
      const_attr_reader  :Collator
      
      when_class_loaded do
        # this is for case insensitive string comparisons
        Collator.set_strength(Collator::PRIMARY)
      end
    }
    
    # anyone can add warnings
    attr_accessor :warnings
    alias_method :attr_warnings, :warnings
    undef_method :warnings
    alias_method :attr_warnings=, :warnings=
    undef_method :warnings=
    
    attr_accessor :new_warning
    alias_method :attr_new_warning, :new_warning
    undef_method :new_warning
    alias_method :attr_new_warning=, :new_warning=
    undef_method :new_warning=
    
    # set to true if policy modified.
    # this way upon exit we know if to ask the user to save changes
    attr_accessor :modified
    alias_method :attr_modified, :modified
    undef_method :modified
    alias_method :attr_modified=, :modified=
    undef_method :modified=
    
    class_module.module_eval {
      const_set_lazy(:Testing) { false }
      const_attr_reader  :Testing
      
      const_set_lazy(:TWOPARAMS) { Array.typed(Class).new([String, String]) }
      const_attr_reader  :TWOPARAMS
      
      const_set_lazy(:ONEPARAMS) { Array.typed(Class).new([String]) }
      const_attr_reader  :ONEPARAMS
      
      const_set_lazy(:NOPARAMS) { Array.typed(Class).new([]) }
      const_attr_reader  :NOPARAMS
      
      # All of the policy entries are read in from the
      # policy file and stored here.  Updates to the policy entries
      # using addEntry() and removeEntry() are made here.  To ultimately save
      # the policy entries back to the policy file, the SavePolicy button
      # must be clicked.
      
      def policy_file_name
        defined?(@@policy_file_name) ? @@policy_file_name : @@policy_file_name= nil
      end
      alias_method :attr_policy_file_name, :policy_file_name
      
      def policy_file_name=(value)
        @@policy_file_name = value
      end
      alias_method :attr_policy_file_name=, :policy_file_name=
    }
    
    attr_accessor :policy_entries
    alias_method :attr_policy_entries, :policy_entries
    undef_method :policy_entries
    alias_method :attr_policy_entries=, :policy_entries=
    undef_method :policy_entries=
    
    attr_accessor :parser
    alias_method :attr_parser, :parser
    undef_method :parser
    alias_method :attr_parser=, :parser=
    undef_method :parser=
    
    # The public key alias information is stored here.
    attr_accessor :key_store
    alias_method :attr_key_store, :key_store
    undef_method :key_store
    alias_method :attr_key_store=, :key_store=
    undef_method :key_store=
    
    attr_accessor :key_store_name
    alias_method :attr_key_store_name, :key_store_name
    undef_method :key_store_name
    alias_method :attr_key_store_name=, :key_store_name=
    undef_method :key_store_name=
    
    attr_accessor :key_store_type
    alias_method :attr_key_store_type, :key_store_type
    undef_method :key_store_type
    alias_method :attr_key_store_type=, :key_store_type=
    undef_method :key_store_type=
    
    attr_accessor :key_store_provider
    alias_method :attr_key_store_provider, :key_store_provider
    undef_method :key_store_provider
    alias_method :attr_key_store_provider=, :key_store_provider=
    undef_method :key_store_provider=
    
    attr_accessor :key_store_pwd_url
    alias_method :attr_key_store_pwd_url, :key_store_pwd_url
    undef_method :key_store_pwd_url
    alias_method :attr_key_store_pwd_url=, :key_store_pwd_url=
    undef_method :key_store_pwd_url=
    
    class_module.module_eval {
      # standard PKCS11 KeyStore type
      const_set_lazy(:P11KEYSTORE) { "PKCS11" }
      const_attr_reader  :P11KEYSTORE
      
      # reserved word for PKCS11 KeyStores
      const_set_lazy(:NONE) { "NONE" }
      const_attr_reader  :NONE
    }
    
    typesig { [] }
    # default constructor
    def initialize
      @warnings = nil
      @new_warning = false
      @modified = false
      @policy_entries = nil
      @parser = nil
      @key_store = nil
      @key_store_name = " "
      @key_store_type = " "
      @key_store_provider = " "
      @key_store_pwd_url = " "
      @policy_entries = Vector.new
      @parser = PolicyParser.new
      @warnings = Vector.new
    end
    
    typesig { [] }
    # get the PolicyFileName
    def get_policy_file_name
      return self.attr_policy_file_name
    end
    
    typesig { [String] }
    # set the PolicyFileName
    def set_policy_file_name(policy_file_name)
      self.attr_policy_file_name = policy_file_name
    end
    
    typesig { [] }
    # clear keyStore info
    def clear_key_store_info
      @key_store_name = nil
      @key_store_type = nil
      @key_store_provider = nil
      @key_store_pwd_url = nil
      @key_store = nil
    end
    
    typesig { [] }
    # get the keyStore URL name
    def get_key_store_name
      return @key_store_name
    end
    
    typesig { [] }
    # get the keyStore Type
    def get_key_store_type
      return @key_store_type
    end
    
    typesig { [] }
    # get the keyStore Provider
    def get_key_store_provider
      return @key_store_provider
    end
    
    typesig { [] }
    # get the keyStore password URL
    def get_key_store_pwd_url
      return @key_store_pwd_url
    end
    
    typesig { [String] }
    # Open and read a policy file
    def open_policy(filename)
      @new_warning = false
      # start fresh - blow away the current state
      @policy_entries = Vector.new
      @parser = PolicyParser.new
      @warnings = Vector.new
      set_policy_file_name(nil)
      clear_key_store_info
      # see if user is opening a NEW policy file
      if ((filename).nil?)
        @modified = false
        return
      end
      # Read in the policy entries from the file and
      # populate the parser vector table.  The parser vector
      # table only holds the entries as strings, so it only
      # guarantees that the policies are syntactically
      # correct.
      set_policy_file_name(filename)
      @parser.read(FileReader.new(filename))
      # open the keystore
      open_key_store(@parser.get_key_store_url, @parser.get_key_store_type, @parser.get_key_store_provider, @parser.get_store_pass_url)
      # Update the local vector with the same policy entries.
      # This guarantees that the policy entries are not only
      # syntactically correct, but semantically valid as well.
      enum_ = @parser.grant_elements
      while (enum_.has_more_elements)
        ge = enum_.next_element
        # see if all the signers have public keys
        if (!(ge.attr_signed_by).nil?)
          signers = parse_signers(ge.attr_signed_by)
          i = 0
          while i < signers.attr_length
            pub_key = get_public_key_alias(signers[i])
            if ((pub_key).nil?)
              @new_warning = true
              form = MessageFormat.new(Rb.get_string("Warning: A public key for alias " + "'signers[i]' does not exist.  " + "Make sure a KeyStore is properly configured."))
              source = Array.typed(Object).new([signers[i]])
              @warnings.add_element(form.format(source))
            end
            i += 1
          end
        end
        # check to see if the Principals are valid
        prin_list = ge.attr_principals.list_iterator(0)
        while (prin_list.has_next)
          pe = prin_list.next_
          begin
            verify_principal(pe.get_principal_class, pe.get_principal_name)
          rescue ClassNotFoundException => fnfe
            @new_warning = true
            form = MessageFormat.new(Rb.get_string("Warning: Class not found: class"))
            source = Array.typed(Object).new([pe.get_principal_class])
            @warnings.add_element(form.format(source))
          end
        end
        # check to see if the Permissions are valid
        perms = ge.permission_elements
        while (perms.has_more_elements)
          pe = perms.next_element
          begin
            verify_permission(pe.attr_permission, pe.attr_name, pe.attr_action)
          rescue ClassNotFoundException => fnfe
            @new_warning = true
            form = MessageFormat.new(Rb.get_string("Warning: Class not found: class"))
            source = Array.typed(Object).new([pe.attr_permission])
            @warnings.add_element(form.format(source))
          rescue InvocationTargetException => ite
            @new_warning = true
            form = MessageFormat.new(Rb.get_string("Warning: Invalid argument(s) for constructor: arg"))
            source = Array.typed(Object).new([pe.attr_permission])
            @warnings.add_element(form.format(source))
          end
          # see if all the permission signers have public keys
          if (!(pe.attr_signed_by).nil?)
            signers = parse_signers(pe.attr_signed_by)
            i = 0
            while i < signers.attr_length
              pub_key = get_public_key_alias(signers[i])
              if ((pub_key).nil?)
                @new_warning = true
                form = MessageFormat.new(Rb.get_string("Warning: A public key for alias " + "'signers[i]' does not exist.  " + "Make sure a KeyStore is properly configured."))
                source = Array.typed(Object).new([signers[i]])
                @warnings.add_element(form.format(source))
              end
              i += 1
            end
          end
        end
        p_entry = PolicyEntry.new(self, ge)
        @policy_entries.add_element(p_entry)
      end
      # just read in the policy -- nothing has been modified yet
      @modified = false
    end
    
    typesig { [String] }
    # Save a policy to a file
    def save_policy(filename)
      # save the policy entries to a file
      @parser.set_key_store_url(@key_store_name)
      @parser.set_key_store_type(@key_store_type)
      @parser.set_key_store_provider(@key_store_provider)
      @parser.set_store_pass_url(@key_store_pwd_url)
      @parser.write(FileWriter.new(filename))
      @modified = false
    end
    
    typesig { [String, String, String, String] }
    # Open the KeyStore
    def open_key_store(name, type, provider, pwd_url)
      if ((name).nil? && (type).nil? && (provider).nil? && (pwd_url).nil?)
        # policy did not specify a keystore during open
        # or use wants to reset keystore values
        @key_store_name = nil
        @key_store_type = nil
        @key_store_provider = nil
        @key_store_pwd_url = nil
        # caller will set (tool.modified = true) if appropriate
        return
      end
      policy_url = nil
      if (!(self.attr_policy_file_name).nil?)
        pfile = JavaFile.new(self.attr_policy_file_name)
        policy_url = URL.new("file:" + RJava.cast_to_string(pfile.get_canonical_path))
      end
      # although PolicyUtil.getKeyStore may properly handle
      # defaults and property expansion, we do it here so that
      # if the call is successful, we can set the proper values
      # (PolicyUtil.getKeyStore does not return expanded values)
      if (!(name).nil? && name.length > 0)
        name = RJava.cast_to_string(PropertyExpander.expand(name).replace(JavaFile.attr_separator_char, Character.new(?/.ord)))
      end
      if ((type).nil? || (type.length).equal?(0))
        type = RJava.cast_to_string(KeyStore.get_default_type)
      end
      if (!(pwd_url).nil? && pwd_url.length > 0)
        pwd_url = RJava.cast_to_string(PropertyExpander.expand(pwd_url).replace(JavaFile.attr_separator_char, Character.new(?/.ord)))
      end
      begin
        @key_store = PolicyUtil.get_key_store(policy_url, name, type, provider, pwd_url, nil)
      rescue IOException => ioe
        # copied from sun.security.pkcs11.SunPKCS11
        msg = "no password provided, and no callback handler " + "available for retrieving password"
        cause = ioe.get_cause
        if (!(cause).nil? && cause.is_a?(Javax::Security::Auth::Login::LoginException) && (msg == cause.get_message))
          # throw a more friendly exception message
          raise IOException.new(msg)
        else
          raise ioe
        end
      end
      @key_store_name = name
      @key_store_type = type
      @key_store_provider = provider
      @key_store_pwd_url = pwd_url
      # caller will set (tool.modified = true)
    end
    
    typesig { [PolicyEntry, ::Java::Int] }
    # Add a Grant entry to the overall policy at the specified index.
    # A policy entry consists of a CodeSource.
    def add_entry(pe, index)
      if (index < 0)
        # new entry -- just add it to the end
        @policy_entries.add_element(pe)
        @parser.add(pe.get_grant_entry)
      else
        # existing entry -- replace old one
        orig_pe = @policy_entries.element_at(index)
        @parser.replace(orig_pe.get_grant_entry, pe.get_grant_entry)
        @policy_entries.set_element_at(pe, index)
      end
      return true
    end
    
    typesig { [PolicyEntry, PolicyParser::PrincipalEntry, ::Java::Int] }
    # Add a Principal entry to an existing PolicyEntry at the specified index.
    # A Principal entry consists of a class, and name.
    # 
    # If the principal already exists, it is not added again.
    def add_prin_entry(pe, new_prin, index)
      # first add the principal to the Policy Parser entry
      grant_entry = pe.get_grant_entry
      if ((grant_entry.contains(new_prin)).equal?(true))
        return false
      end
      prin_list = grant_entry.attr_principals
      if (!(index).equal?(-1))
        prin_list.set(index, new_prin)
      else
        prin_list.add(new_prin)
      end
      @modified = true
      return true
    end
    
    typesig { [PolicyEntry, PolicyParser::PermissionEntry, ::Java::Int] }
    # Add a Permission entry to an existing PolicyEntry at the specified index.
    # A Permission entry consists of a permission, name, and actions.
    # 
    # If the permission already exists, it is not added again.
    def add_perm_entry(pe, new_perm, index)
      # first add the permission to the Policy Parser Vector
      grant_entry = pe.get_grant_entry
      if ((grant_entry.contains(new_perm)).equal?(true))
        return false
      end
      perm_list = grant_entry.attr_permission_entries
      if (!(index).equal?(-1))
        perm_list.set_element_at(new_perm, index)
      else
        perm_list.add_element(new_perm)
      end
      @modified = true
      return true
    end
    
    typesig { [PolicyEntry, PolicyParser::PermissionEntry] }
    # Remove a Permission entry from an existing PolicyEntry.
    def remove_perm_entry(pe, perm)
      # remove the Permission from the GrantEntry
      ppge = pe.get_grant_entry
      @modified = ppge.remove(perm)
      return @modified
    end
    
    typesig { [PolicyEntry] }
    # remove an entry from the overall policy
    def remove_entry(pe)
      @parser.remove(pe.get_grant_entry)
      @modified = true
      return (@policy_entries.remove_element(pe))
    end
    
    typesig { [] }
    # retrieve all Policy Entries
    def get_entry
      if (@policy_entries.size > 0)
        entries = Array.typed(PolicyEntry).new(@policy_entries.size) { nil }
        i = 0
        while i < @policy_entries.size
          entries[i] = @policy_entries.element_at(i)
          i += 1
        end
        return entries
      end
      return nil
    end
    
    typesig { [String] }
    # Retrieve the public key mapped to a particular name.
    # If the key has expired, a KeyException is thrown.
    def get_public_key_alias(name)
      if ((@key_store).nil?)
        return nil
      end
      cert = @key_store.get_certificate(name)
      if ((cert).nil?)
        return nil
      end
      pub_key = cert.get_public_key
      return pub_key
    end
    
    typesig { [] }
    # Retrieve all the alias names stored in the certificate database
    def get_public_key_alias
      num_aliases = 0
      aliases = nil
      if ((@key_store).nil?)
        return nil
      end
      enum_ = @key_store.aliases
      # first count the number of elements
      while (enum_.has_more_elements)
        enum_.next_element
        num_aliases += 1
      end
      if (num_aliases > 0)
        # now copy them into an array
        aliases = Array.typed(String).new(num_aliases) { nil }
        num_aliases = 0
        enum_ = @key_store.aliases
        while (enum_.has_more_elements)
          aliases[num_aliases] = String.new(enum_.next_element)
          num_aliases += 1
        end
      end
      return aliases
    end
    
    typesig { [String] }
    # This method parses a single string of signers separated by commas
    # ("jordan, duke, pippen") into an array of individual strings.
    def parse_signers(signed_by)
      signers = nil
      num_signers = 1
      signed_by_index = 0
      comma_index = 0
      signer_num = 0
      # first pass thru "signedBy" counts the number of signers
      while (comma_index >= 0)
        comma_index = signed_by.index_of(Character.new(?,.ord), signed_by_index)
        if (comma_index >= 0)
          num_signers += 1
          signed_by_index = comma_index + 1
        end
      end
      signers = Array.typed(String).new(num_signers) { nil }
      # second pass thru "signedBy" transfers signers to array
      comma_index = 0
      signed_by_index = 0
      while (comma_index >= 0)
        if ((comma_index = signed_by.index_of(Character.new(?,.ord), signed_by_index)) >= 0)
          # transfer signer and ignore trailing part of the string
          signers[signer_num] = signed_by.substring(signed_by_index, comma_index).trim
          signer_num += 1
          signed_by_index = comma_index + 1
        else
          # we are at the end of the string -- transfer signer
          signers[signer_num] = signed_by.substring(signed_by_index).trim
        end
      end
      return signers
    end
    
    typesig { [String, String] }
    # Check to see if the Principal contents are OK
    def verify_principal(type, name)
      if ((type == PolicyParser::PrincipalEntry::WILDCARD_CLASS) || (type == PolicyParser::REPLACE_NAME))
        return
      end
      prin = Class.for_name("java.security.Principal")
      pc = Class.for_name(type, true, JavaThread.current_thread.get_context_class_loader)
      if (!prin.is_assignable_from(pc))
        form = MessageFormat.new(Rb.get_string("Illegal Principal Type: type"))
        source = Array.typed(Object).new([type])
        raise InstantiationException.new(form.format(source))
      end
      if ((ToolDialog::X500_PRIN_CLASS == pc.get_name))
        # PolicyParser checks validity of X500Principal name
        # - PolicyTool needs to as well so that it doesn't store
        # an invalid name that can't be read in later
        # 
        # this can throw an IllegalArgumentException
        new_p = X500Principal.new(name)
      end
    end
    
    typesig { [String, String, String] }
    # Check to see if the Permission contents are OK
    def verify_permission(type, name, actions)
      # XXX we might want to keep a hash of created factories...
      pc = Class.for_name(type, true, JavaThread.current_thread.get_context_class_loader)
      c = nil
      objects = Vector.new(2)
      if (!(name).nil?)
        objects.add(name)
      end
      if (!(actions).nil?)
        objects.add(actions)
      end
      catch(:break_case) do
        case (objects.size)
        when 0
          begin
            c = pc.get_constructor(NOPARAMS)
            throw :break_case, :thrown
          rescue NoSuchMethodException => ex
            # proceed to the one-param constructor
            objects.add(nil)
          end
          begin
            c = pc.get_constructor(ONEPARAMS)
            throw :break_case, :thrown
          rescue NoSuchMethodException => ex
            # proceed to the two-param constructor
            objects.add(nil)
          end
          c = pc.get_constructor(TWOPARAMS)
        when 1
          begin
            c = pc.get_constructor(ONEPARAMS)
            throw :break_case, :thrown
          rescue NoSuchMethodException => ex
            # proceed to the two-param constructor
            objects.add(nil)
          end
          c = pc.get_constructor(TWOPARAMS)
        when 2
          c = pc.get_constructor(TWOPARAMS)
        end
      end
      parameters = objects.to_array
      p = c.new_instance(parameters)
    end
    
    class_module.module_eval {
      typesig { [Array.typed(String)] }
      # Parse command line arguments.
      def parse_args(args)
        # parse flags
        n = 0
        n = 0
        while (n < args.attr_length) && args[n].starts_with("-")
          flags = args[n]
          if ((Collator.compare(flags, "-file")).equal?(0))
            if (((n += 1)).equal?(args.attr_length))
              usage
            end
            self.attr_policy_file_name = RJava.cast_to_string(args[n])
          else
            form = MessageFormat.new(Rb.get_string("Illegal option: option"))
            source = Array.typed(Object).new([flags])
            System.err.println(form.format(source))
            usage
          end
          n += 1
        end
      end
      
      typesig { [] }
      def usage
        System.out.println(Rb.get_string("Usage: policytool [options]"))
        System.out.println
        System.out.println(Rb.get_string("  [-file <file>]    policy file location"))
        System.out.println
        System.exit(1)
      end
      
      typesig { [Array.typed(String)] }
      # run the PolicyTool
      def main(args)
        parse_args(args)
        tw = ToolWindow.new(PolicyTool.new)
        tw.display_tool_window(args)
      end
      
      typesig { [String] }
      # split instr to words according to capitalization,
      # like, AWTControl -> A W T Control
      # this method is for easy pronounciation
      def split_to_words(instr)
        return instr.replace_all("([A-Z])", " $1")
      end
    }
    
    private
    alias_method :initialize__policy_tool, :initialize
  end
  
  # Each entry in the policy configuration file is represented by a
  # PolicyEntry object.
  # 
  # A PolicyEntry is a (CodeSource,Permission) pair.  The
  # CodeSource contains the (URL, PublicKey) that together identify
  # where the Java bytecodes come from and who (if anyone) signed
  # them.  The URL could refer to localhost.  The URL could also be
  # null, meaning that this policy entry is given to all comers, as
  # long as they match the signer field.  The signer could be null,
  # meaning the code is not signed.
  # 
  # The Permission contains the (Type, Name, Action) triplet.
  class PolicyEntry 
    include_class_members PolicyToolImports
    
    attr_accessor :codesource
    alias_method :attr_codesource, :codesource
    undef_method :codesource
    alias_method :attr_codesource=, :codesource=
    undef_method :codesource=
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :grant_entry
    alias_method :attr_grant_entry, :grant_entry
    undef_method :grant_entry
    alias_method :attr_grant_entry=, :grant_entry=
    undef_method :grant_entry=
    
    attr_accessor :testing
    alias_method :attr_testing, :testing
    undef_method :testing
    alias_method :attr_testing=, :testing=
    undef_method :testing=
    
    typesig { [PolicyTool, PolicyParser::GrantEntry] }
    # Create a PolicyEntry object from the information read in
    # from a policy file.
    def initialize(tool, ge)
      @codesource = nil
      @tool = nil
      @grant_entry = nil
      @testing = false
      @tool = tool
      location = nil
      # construct the CodeSource
      if (!(ge.attr_code_base).nil?)
        location = URL.new(ge.attr_code_base)
      end
      @codesource = CodeSource.new(location, nil)
      if (@testing)
        System.out.println("Adding Policy Entry:")
        System.out.println("    CodeBase = " + RJava.cast_to_string(location))
        System.out.println("    Signers = " + RJava.cast_to_string(ge.attr_signed_by))
        System.out.println("    with " + RJava.cast_to_string(ge.attr_principals.size) + " Principals")
      end
      @grant_entry = ge
    end
    
    typesig { [] }
    # get the codesource associated with this PolicyEntry
    def get_code_source
      return @codesource
    end
    
    typesig { [] }
    # get the GrantEntry associated with this PolicyEntry
    def get_grant_entry
      return @grant_entry
    end
    
    typesig { [] }
    # convert the header portion, i.e. codebase, signer, principals, of
    # this policy entry into a string
    def header_to_string
      p_string = principals_to_string
      if ((p_string.length).equal?(0))
        return codebase_to_string
      else
        return RJava.cast_to_string(codebase_to_string) + ", " + p_string
      end
    end
    
    typesig { [] }
    # convert the Codebase/signer portion of this policy entry into a string
    def codebase_to_string
      string_entry = String.new
      if (!(@grant_entry.attr_code_base).nil? && ((@grant_entry.attr_code_base == "")).equal?(false))
        string_entry = RJava.cast_to_string(string_entry.concat("CodeBase \"" + RJava.cast_to_string(@grant_entry.attr_code_base) + "\""))
      end
      if (!(@grant_entry.attr_signed_by).nil? && ((@grant_entry.attr_signed_by == "")).equal?(false))
        string_entry = RJava.cast_to_string(((string_entry.length > 0) ? string_entry.concat(", SignedBy \"" + RJava.cast_to_string(@grant_entry.attr_signed_by) + "\"") : string_entry.concat("SignedBy \"" + RJava.cast_to_string(@grant_entry.attr_signed_by) + "\"")))
      end
      if ((string_entry.length).equal?(0))
        return String.new("CodeBase <ALL>")
      end
      return string_entry
    end
    
    typesig { [] }
    # convert the Principals portion of this policy entry into a string
    def principals_to_string
      result = ""
      if ((!(@grant_entry.attr_principals).nil?) && (!@grant_entry.attr_principals.is_empty))
        buffer = StringBuffer.new(200)
        list = @grant_entry.attr_principals.list_iterator
        while (list.has_next)
          pppe = list.next_
          buffer.append(" Principal " + RJava.cast_to_string(pppe.get_display_class) + " " + RJava.cast_to_string(pppe.get_display_name(true)))
          if (list.has_next)
            buffer.append(", ")
          end
        end
        result = RJava.cast_to_string(buffer.to_s)
      end
      return result
    end
    
    typesig { [Permission] }
    # convert this policy entry into a PolicyParser.PermissionEntry
    def to_permission_entry(perm)
      actions = nil
      # get the actions
      if (!(perm.get_actions).nil? && !(perm.get_actions.trim).equal?(""))
        actions = RJava.cast_to_string(perm.get_actions)
      end
      pe = PolicyParser::PermissionEntry.new(perm.get_class.get_name, perm.get_name, actions)
      return pe
    end
    
    private
    alias_method :initialize__policy_entry, :initialize
  end
  
  # The main window for the PolicyTool
  class ToolWindow < PolicyToolImports.const_get :Frame
    include_class_members PolicyToolImports
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.2.2 for interoperability
      const_set_lazy(:SerialVersionUID) { 5682568601210376777 }
      const_attr_reader  :SerialVersionUID
      
      # external paddings
      const_set_lazy(:TOP_PADDING) { Insets.new(25, 0, 0, 0) }
      const_attr_reader  :TOP_PADDING
      
      const_set_lazy(:BOTTOM_PADDING) { Insets.new(0, 0, 25, 0) }
      const_attr_reader  :BOTTOM_PADDING
      
      const_set_lazy(:LITE_BOTTOM_PADDING) { Insets.new(0, 0, 10, 0) }
      const_attr_reader  :LITE_BOTTOM_PADDING
      
      const_set_lazy(:LR_PADDING) { Insets.new(0, 10, 0, 10) }
      const_attr_reader  :LR_PADDING
      
      const_set_lazy(:TOP_BOTTOM_PADDING) { Insets.new(15, 0, 15, 0) }
      const_attr_reader  :TOP_BOTTOM_PADDING
      
      const_set_lazy(:L_TOP_BOTTOM_PADDING) { Insets.new(5, 10, 15, 0) }
      const_attr_reader  :L_TOP_BOTTOM_PADDING
      
      const_set_lazy(:LR_BOTTOM_PADDING) { Insets.new(0, 10, 5, 10) }
      const_attr_reader  :LR_BOTTOM_PADDING
      
      const_set_lazy(:L_BOTTOM_PADDING) { Insets.new(0, 10, 5, 0) }
      const_attr_reader  :L_BOTTOM_PADDING
      
      const_set_lazy(:R_BOTTOM_PADDING) { Insets.new(0, 0, 5, 10) }
      const_attr_reader  :R_BOTTOM_PADDING
      
      # buttons and menus
      const_set_lazy(:NEW_POLICY_FILE) { PolicyTool.attr_rb.get_string("New") }
      const_attr_reader  :NEW_POLICY_FILE
      
      const_set_lazy(:OPEN_POLICY_FILE) { PolicyTool.attr_rb.get_string("Open") }
      const_attr_reader  :OPEN_POLICY_FILE
      
      const_set_lazy(:SAVE_POLICY_FILE) { PolicyTool.attr_rb.get_string("Save") }
      const_attr_reader  :SAVE_POLICY_FILE
      
      const_set_lazy(:SAVE_AS_POLICY_FILE) { PolicyTool.attr_rb.get_string("Save As") }
      const_attr_reader  :SAVE_AS_POLICY_FILE
      
      const_set_lazy(:VIEW_WARNINGS) { PolicyTool.attr_rb.get_string("View Warning Log") }
      const_attr_reader  :VIEW_WARNINGS
      
      const_set_lazy(:QUIT) { PolicyTool.attr_rb.get_string("Exit") }
      const_attr_reader  :QUIT
      
      const_set_lazy(:ADD_POLICY_ENTRY) { PolicyTool.attr_rb.get_string("Add Policy Entry") }
      const_attr_reader  :ADD_POLICY_ENTRY
      
      const_set_lazy(:EDIT_POLICY_ENTRY) { PolicyTool.attr_rb.get_string("Edit Policy Entry") }
      const_attr_reader  :EDIT_POLICY_ENTRY
      
      const_set_lazy(:REMOVE_POLICY_ENTRY) { PolicyTool.attr_rb.get_string("Remove Policy Entry") }
      const_attr_reader  :REMOVE_POLICY_ENTRY
      
      const_set_lazy(:EDIT_KEYSTORE) { PolicyTool.attr_rb.get_string("Edit") }
      const_attr_reader  :EDIT_KEYSTORE
      
      const_set_lazy(:ADD_PUBKEY_ALIAS) { PolicyTool.attr_rb.get_string("Add Public Key Alias") }
      const_attr_reader  :ADD_PUBKEY_ALIAS
      
      const_set_lazy(:REMOVE_PUBKEY_ALIAS) { PolicyTool.attr_rb.get_string("Remove Public Key Alias") }
      const_attr_reader  :REMOVE_PUBKEY_ALIAS
      
      # gridbag index for components in the main window (MW)
      const_set_lazy(:MW_FILENAME_LABEL) { 0 }
      const_attr_reader  :MW_FILENAME_LABEL
      
      const_set_lazy(:MW_FILENAME_TEXTFIELD) { 1 }
      const_attr_reader  :MW_FILENAME_TEXTFIELD
      
      const_set_lazy(:MW_PANEL) { 2 }
      const_attr_reader  :MW_PANEL
      
      const_set_lazy(:MW_ADD_BUTTON) { 0 }
      const_attr_reader  :MW_ADD_BUTTON
      
      const_set_lazy(:MW_EDIT_BUTTON) { 1 }
      const_attr_reader  :MW_EDIT_BUTTON
      
      const_set_lazy(:MW_REMOVE_BUTTON) { 2 }
      const_attr_reader  :MW_REMOVE_BUTTON
      
      const_set_lazy(:MW_POLICY_LIST) { 3 }
      const_attr_reader  :MW_POLICY_LIST
    }
    
    # follows MW_PANEL
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    typesig { [PolicyTool] }
    # Constructor
    def initialize(tool)
      @tool = nil
      super()
      @tool = tool
    end
    
    typesig { [] }
    # Initialize the PolicyTool window with the necessary components
    def init_window
      # create the top menu bar
      menu_bar = MenuBar.new
      # create a File menu
      menu = Menu.new(PolicyTool.attr_rb.get_string("File"))
      menu.add(NEW_POLICY_FILE)
      menu.add(OPEN_POLICY_FILE)
      menu.add(SAVE_POLICY_FILE)
      menu.add(SAVE_AS_POLICY_FILE)
      menu.add(VIEW_WARNINGS)
      menu.add(QUIT)
      menu.add_action_listener(FileMenuListener.new(@tool, self))
      menu_bar.add(menu)
      set_menu_bar(menu_bar)
      # create a KeyStore menu
      menu = Menu.new(PolicyTool.attr_rb.get_string("KeyStore"))
      menu.add(EDIT_KEYSTORE)
      menu.add_action_listener(MainWindowListener.new(@tool, self))
      menu_bar.add(menu)
      set_menu_bar(menu_bar)
      # policy entry listing
      label = Label.new(PolicyTool.attr_rb.get_string("Policy File:"))
      add_new_component(self, label, MW_FILENAME_LABEL, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, TOP_BOTTOM_PADDING)
      tf = TextField.new(50)
      tf.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("Policy File:"))
      tf.set_editable(false)
      add_new_component(self, tf, MW_FILENAME_TEXTFIELD, 1, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, TOP_BOTTOM_PADDING)
      # add ADD/REMOVE/EDIT buttons in a new panel
      panel = Panel.new
      panel.set_layout(GridBagLayout.new)
      button = Button.new(ADD_POLICY_ENTRY)
      button.add_action_listener(MainWindowListener.new(@tool, self))
      add_new_component(panel, button, MW_ADD_BUTTON, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, LR_PADDING)
      button = Button.new(EDIT_POLICY_ENTRY)
      button.add_action_listener(MainWindowListener.new(@tool, self))
      add_new_component(panel, button, MW_EDIT_BUTTON, 1, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, LR_PADDING)
      button = Button.new(REMOVE_POLICY_ENTRY)
      button.add_action_listener(MainWindowListener.new(@tool, self))
      add_new_component(panel, button, MW_REMOVE_BUTTON, 2, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, LR_PADDING)
      add_new_component(self, panel, MW_PANEL, 0, 2, 2, 1, 0.0, 0.0, GridBagConstraints::BOTH, BOTTOM_PADDING)
      policy_file = @tool.get_policy_file_name
      if ((policy_file).nil?)
        user_home = nil
        user_home = RJava.cast_to_string(Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("user.home")))
        policy_file = user_home + RJava.cast_to_string(JavaFile.attr_separator_char) + ".java.policy"
      end
      begin
        # open the policy file
        @tool.open_policy(policy_file)
        # display the policy entries via the policy list textarea
        list = JavaList.new(40, false)
        list.add_action_listener(PolicyListListener.new(@tool, self))
        entries = @tool.get_entry
        if (!(entries).nil?)
          i = 0
          while i < entries.attr_length
            list.add(entries[i].header_to_string)
            i += 1
          end
        end
        new_filename = get_component(MW_FILENAME_TEXTFIELD)
        new_filename.set_text(policy_file)
        init_policy_list(list)
      rescue FileNotFoundException => fnfe
        # add blank policy listing
        list_ = JavaList.new(40, false)
        list_.add_action_listener(PolicyListListener.new(@tool, self))
        init_policy_list(list_)
        @tool.set_policy_file_name(nil)
        @tool.attr_modified = false
        set_visible(true)
        # just add warning
        @tool.attr_warnings.add_element(fnfe.to_s)
      rescue JavaException => e
        # add blank policy listing
        list_ = JavaList.new(40, false)
        list_.add_action_listener(PolicyListListener.new(@tool, self))
        init_policy_list(list_)
        @tool.set_policy_file_name(nil)
        @tool.attr_modified = false
        set_visible(true)
        # display the error
        form = MessageFormat.new(PolicyTool.attr_rb.get_string("Could not open policy file: policyFile: e.toString()"))
        source = Array.typed(Object).new([policy_file, e.to_s])
        display_error_dialog(nil, form.format(source))
      end
    end
    
    typesig { [Container, Component, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Double, ::Java::Double, ::Java::Int, Insets] }
    # Add a component to the PolicyTool window
    def add_new_component(container, component, index, gridx, gridy, gridwidth, gridheight, weightx, weighty, fill, is)
      # add the component at the specified gridbag index
      container.add(component, index)
      # set the constraints
      gbl = container.get_layout
      gbc = GridBagConstraints.new
      gbc.attr_gridx = gridx
      gbc.attr_gridy = gridy
      gbc.attr_gridwidth = gridwidth
      gbc.attr_gridheight = gridheight
      gbc.attr_weightx = weightx
      gbc.attr_weighty = weighty
      gbc.attr_fill = fill
      if (!(is).nil?)
        gbc.attr_insets = is
      end
      gbl.set_constraints(component, gbc)
    end
    
    typesig { [Container, Component, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int, ::Java::Double, ::Java::Double, ::Java::Int] }
    # Add a component to the PolicyTool window without external padding
    def add_new_component(container, component, index, gridx, gridy, gridwidth, gridheight, weightx, weighty, fill)
      # delegate with "null" external padding
      add_new_component(container, component, index, gridx, gridy, gridwidth, gridheight, weightx, weighty, fill, nil)
    end
    
    typesig { [JavaList] }
    # Init the policy_entry_list TEXTAREA component in the
    # PolicyTool window
    def init_policy_list(policy_list)
      # add the policy list to the window
      add_new_component(self, policy_list, MW_POLICY_LIST, 0, 3, 2, 1, 1.0, 1.0, GridBagConstraints::BOTH)
    end
    
    typesig { [JavaList] }
    # Replace the policy_entry_list TEXTAREA component in the
    # PolicyTool window with an updated one.
    def replace_policy_list(policy_list)
      # remove the original list of Policy Entries
      # and add the new list of entries
      list = get_component(MW_POLICY_LIST)
      list.remove_all
      new_items = policy_list.get_items
      i = 0
      while i < new_items.attr_length
        list.add(new_items[i])
        i += 1
      end
    end
    
    typesig { [Array.typed(String)] }
    # display the main PolicyTool window
    def display_tool_window(args)
      set_title(PolicyTool.attr_rb.get_string("Policy Tool"))
      set_resizable(true)
      add_window_listener(ToolWindowListener.new(self))
      set_bounds(135, 80, 500, 500)
      set_layout(GridBagLayout.new)
      init_window
      # display it
      set_visible(true)
      if ((@tool.attr_new_warning).equal?(true))
        display_status_dialog(self, PolicyTool.attr_rb.get_string("Errors have occurred while opening the " + "policy configuration.  View the Warning Log " + "for more information."))
      end
    end
    
    typesig { [Window, String] }
    # displays a dialog box describing an error which occurred.
    def display_error_dialog(w, error)
      ed = ToolDialog.new(PolicyTool.attr_rb.get_string("Error"), @tool, self, true)
      # find where the PolicyTool gui is
      location = (((w).nil?) ? get_location_on_screen : w.get_location_on_screen)
      ed.set_bounds(location.attr_x + 50, location.attr_y + 50, 600, 100)
      ed.set_layout(GridBagLayout.new)
      label = Label.new(error)
      add_new_component(ed, label, 0, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      ok_button = Button.new(PolicyTool.attr_rb.get_string("OK"))
      ok_button.add_action_listener(ErrorOKButtonListener.new(ed))
      add_new_component(ed, ok_button, 1, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL)
      ed.pack
      ed.set_visible(true)
    end
    
    typesig { [Window, JavaThrowable] }
    # displays a dialog box describing an error which occurred.
    def display_error_dialog(w, t)
      if (t.is_a?(NoDisplayException))
        return
      end
      display_error_dialog(w, t.to_s)
    end
    
    typesig { [Window, String] }
    # displays a dialog box describing the status of an event
    def display_status_dialog(w, status)
      sd = ToolDialog.new(PolicyTool.attr_rb.get_string("Status"), @tool, self, true)
      # find the location of the PolicyTool gui
      location = (((w).nil?) ? get_location_on_screen : w.get_location_on_screen)
      sd.set_bounds(location.attr_x + 50, location.attr_y + 50, 500, 100)
      sd.set_layout(GridBagLayout.new)
      label = Label.new(status)
      add_new_component(sd, label, 0, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      ok_button = Button.new(PolicyTool.attr_rb.get_string("OK"))
      ok_button.add_action_listener(StatusOKButtonListener.new(sd))
      add_new_component(sd, ok_button, 1, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL)
      sd.pack
      sd.set_visible(true)
    end
    
    typesig { [Window] }
    # display the warning log
    def display_warning_log(w)
      wd = ToolDialog.new(PolicyTool.attr_rb.get_string("Warning"), @tool, self, true)
      # find the location of the PolicyTool gui
      location = (((w).nil?) ? get_location_on_screen : w.get_location_on_screen)
      wd.set_bounds(location.attr_x + 50, location.attr_y + 50, 500, 100)
      wd.set_layout(GridBagLayout.new)
      ta = TextArea.new
      ta.set_editable(false)
      i = 0
      while i < @tool.attr_warnings.size
        ta.append(@tool.attr_warnings.element_at(i))
        ta.append(PolicyTool.attr_rb.get_string("\n"))
        i += 1
      end
      add_new_component(wd, ta, 0, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, BOTTOM_PADDING)
      ta.set_focusable(false)
      ok_button = Button.new(PolicyTool.attr_rb.get_string("OK"))
      ok_button.add_action_listener(CancelButtonListener.new(wd))
      add_new_component(wd, ok_button, 1, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, LR_PADDING)
      wd.pack
      wd.set_visible(true)
    end
    
    typesig { [Window, String, String, String, String] }
    def display_yes_no_dialog(w, title, prompt, yes, no)
      tw = ToolDialog.new(title, @tool, self, true)
      location = (((w).nil?) ? get_location_on_screen : w.get_location_on_screen)
      tw.set_bounds(location.attr_x + 75, location.attr_y + 100, 400, 150)
      tw.set_layout(GridBagLayout.new)
      ta = TextArea.new(prompt, 10, 50, TextArea::SCROLLBARS_VERTICAL_ONLY)
      ta.set_editable(false)
      add_new_component(tw, ta, 0, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      ta.set_focusable(false)
      panel = Panel.new
      panel.set_layout(GridBagLayout.new)
      # StringBuffer to store button press. Must be final.
      choose_result = StringBuffer.new
      button = Button.new(yes)
      button.add_action_listener(Class.new(ActionListener.class == Class ? ActionListener : Object) do
        extend LocalClass
        include_class_members ToolWindow
        include ActionListener if ActionListener.class == Module
        
        typesig { [ActionEvent] }
        define_method :action_performed do |e|
          choose_result.append(Character.new(?Y.ord))
          tw.set_visible(false)
          tw.dispose
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      add_new_component(panel, button, 0, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, LR_PADDING)
      button = Button.new(no)
      button.add_action_listener(Class.new(ActionListener.class == Class ? ActionListener : Object) do
        extend LocalClass
        include_class_members ToolWindow
        include ActionListener if ActionListener.class == Module
        
        typesig { [ActionEvent] }
        define_method :action_performed do |e|
          choose_result.append(Character.new(?N.ord))
          tw.set_visible(false)
          tw.dispose
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      add_new_component(panel, button, 1, 1, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, LR_PADDING)
      add_new_component(tw, panel, 1, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL)
      tw.pack
      tw.set_visible(true)
      if (choose_result.length > 0)
        return choose_result.char_at(0)
      else
        # I did encounter this once, don't why.
        return Character.new(?N.ord)
      end
    end
    
    private
    alias_method :initialize__tool_window, :initialize
  end
  
  # General dialog window
  class ToolDialog < PolicyToolImports.const_get :Dialog
    include_class_members PolicyToolImports
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.2.2 for interoperability
      const_set_lazy(:SerialVersionUID) { -372244357011301190 }
      const_attr_reader  :SerialVersionUID
      
      # necessary constants
      const_set_lazy(:NOACTION) { 0 }
      const_attr_reader  :NOACTION
      
      const_set_lazy(:QUIT) { 1 }
      const_attr_reader  :QUIT
      
      const_set_lazy(:NEW) { 2 }
      const_attr_reader  :NEW
      
      const_set_lazy(:OPEN) { 3 }
      const_attr_reader  :OPEN
      
      const_set_lazy(:ALL_PERM_CLASS) { "java.security.AllPermission" }
      const_attr_reader  :ALL_PERM_CLASS
      
      const_set_lazy(:FILE_PERM_CLASS) { "java.io.FilePermission" }
      const_attr_reader  :FILE_PERM_CLASS
      
      const_set_lazy(:X500_PRIN_CLASS) { "javax.security.auth.x500.X500Principal" }
      const_attr_reader  :X500_PRIN_CLASS
      
      # popup menus
      const_set_lazy(:PERM) { PolicyTool.attr_rb.get_string("Permission:                                                       ") }
      const_attr_reader  :PERM
      
      const_set_lazy(:PRIN_TYPE) { PolicyTool.attr_rb.get_string("Principal Type:") }
      const_attr_reader  :PRIN_TYPE
      
      const_set_lazy(:PRIN_NAME) { PolicyTool.attr_rb.get_string("Principal Name:") }
      const_attr_reader  :PRIN_NAME
      
      # more popu menus
      const_set_lazy(:PERM_NAME) { PolicyTool.attr_rb.get_string("Target Name:                                                    ") }
      const_attr_reader  :PERM_NAME
      
      # and more popup menus
      const_set_lazy(:PERM_ACTIONS) { PolicyTool.attr_rb.get_string("Actions:                                                             ") }
      const_attr_reader  :PERM_ACTIONS
      
      # gridbag index for display OverWriteFile (OW) components
      const_set_lazy(:OW_LABEL) { 0 }
      const_attr_reader  :OW_LABEL
      
      const_set_lazy(:OW_OK_BUTTON) { 1 }
      const_attr_reader  :OW_OK_BUTTON
      
      const_set_lazy(:OW_CANCEL_BUTTON) { 2 }
      const_attr_reader  :OW_CANCEL_BUTTON
      
      # gridbag index for display PolicyEntry (PE) components
      const_set_lazy(:PE_CODEBASE_LABEL) { 0 }
      const_attr_reader  :PE_CODEBASE_LABEL
      
      const_set_lazy(:PE_CODEBASE_TEXTFIELD) { 1 }
      const_attr_reader  :PE_CODEBASE_TEXTFIELD
      
      const_set_lazy(:PE_SIGNEDBY_LABEL) { 2 }
      const_attr_reader  :PE_SIGNEDBY_LABEL
      
      const_set_lazy(:PE_SIGNEDBY_TEXTFIELD) { 3 }
      const_attr_reader  :PE_SIGNEDBY_TEXTFIELD
      
      const_set_lazy(:PE_PANEL0) { 4 }
      const_attr_reader  :PE_PANEL0
      
      const_set_lazy(:PE_ADD_PRIN_BUTTON) { 0 }
      const_attr_reader  :PE_ADD_PRIN_BUTTON
      
      const_set_lazy(:PE_EDIT_PRIN_BUTTON) { 1 }
      const_attr_reader  :PE_EDIT_PRIN_BUTTON
      
      const_set_lazy(:PE_REMOVE_PRIN_BUTTON) { 2 }
      const_attr_reader  :PE_REMOVE_PRIN_BUTTON
      
      const_set_lazy(:PE_PRIN_LABEL) { 5 }
      const_attr_reader  :PE_PRIN_LABEL
      
      const_set_lazy(:PE_PRIN_LIST) { 6 }
      const_attr_reader  :PE_PRIN_LIST
      
      const_set_lazy(:PE_PANEL1) { 7 }
      const_attr_reader  :PE_PANEL1
      
      const_set_lazy(:PE_ADD_PERM_BUTTON) { 0 }
      const_attr_reader  :PE_ADD_PERM_BUTTON
      
      const_set_lazy(:PE_EDIT_PERM_BUTTON) { 1 }
      const_attr_reader  :PE_EDIT_PERM_BUTTON
      
      const_set_lazy(:PE_REMOVE_PERM_BUTTON) { 2 }
      const_attr_reader  :PE_REMOVE_PERM_BUTTON
      
      const_set_lazy(:PE_PERM_LIST) { 8 }
      const_attr_reader  :PE_PERM_LIST
      
      const_set_lazy(:PE_PANEL2) { 9 }
      const_attr_reader  :PE_PANEL2
      
      const_set_lazy(:PE_CANCEL_BUTTON) { 1 }
      const_attr_reader  :PE_CANCEL_BUTTON
      
      const_set_lazy(:PE_DONE_BUTTON) { 0 }
      const_attr_reader  :PE_DONE_BUTTON
      
      # the gridbag index for components in the Principal Dialog (PRD)
      const_set_lazy(:PRD_DESC_LABEL) { 0 }
      const_attr_reader  :PRD_DESC_LABEL
      
      const_set_lazy(:PRD_PRIN_CHOICE) { 1 }
      const_attr_reader  :PRD_PRIN_CHOICE
      
      const_set_lazy(:PRD_PRIN_TEXTFIELD) { 2 }
      const_attr_reader  :PRD_PRIN_TEXTFIELD
      
      const_set_lazy(:PRD_NAME_LABEL) { 3 }
      const_attr_reader  :PRD_NAME_LABEL
      
      const_set_lazy(:PRD_NAME_TEXTFIELD) { 4 }
      const_attr_reader  :PRD_NAME_TEXTFIELD
      
      const_set_lazy(:PRD_CANCEL_BUTTON) { 6 }
      const_attr_reader  :PRD_CANCEL_BUTTON
      
      const_set_lazy(:PRD_OK_BUTTON) { 5 }
      const_attr_reader  :PRD_OK_BUTTON
      
      # the gridbag index for components in the Permission Dialog (PD)
      const_set_lazy(:PD_DESC_LABEL) { 0 }
      const_attr_reader  :PD_DESC_LABEL
      
      const_set_lazy(:PD_PERM_CHOICE) { 1 }
      const_attr_reader  :PD_PERM_CHOICE
      
      const_set_lazy(:PD_PERM_TEXTFIELD) { 2 }
      const_attr_reader  :PD_PERM_TEXTFIELD
      
      const_set_lazy(:PD_NAME_CHOICE) { 3 }
      const_attr_reader  :PD_NAME_CHOICE
      
      const_set_lazy(:PD_NAME_TEXTFIELD) { 4 }
      const_attr_reader  :PD_NAME_TEXTFIELD
      
      const_set_lazy(:PD_ACTIONS_CHOICE) { 5 }
      const_attr_reader  :PD_ACTIONS_CHOICE
      
      const_set_lazy(:PD_ACTIONS_TEXTFIELD) { 6 }
      const_attr_reader  :PD_ACTIONS_TEXTFIELD
      
      const_set_lazy(:PD_SIGNEDBY_LABEL) { 7 }
      const_attr_reader  :PD_SIGNEDBY_LABEL
      
      const_set_lazy(:PD_SIGNEDBY_TEXTFIELD) { 8 }
      const_attr_reader  :PD_SIGNEDBY_TEXTFIELD
      
      const_set_lazy(:PD_CANCEL_BUTTON) { 10 }
      const_attr_reader  :PD_CANCEL_BUTTON
      
      const_set_lazy(:PD_OK_BUTTON) { 9 }
      const_attr_reader  :PD_OK_BUTTON
      
      # modes for KeyStore
      const_set_lazy(:EDIT_KEYSTORE) { 0 }
      const_attr_reader  :EDIT_KEYSTORE
      
      # the gridbag index for components in the Change KeyStore Dialog (KSD)
      const_set_lazy(:KSD_NAME_LABEL) { 0 }
      const_attr_reader  :KSD_NAME_LABEL
      
      const_set_lazy(:KSD_NAME_TEXTFIELD) { 1 }
      const_attr_reader  :KSD_NAME_TEXTFIELD
      
      const_set_lazy(:KSD_TYPE_LABEL) { 2 }
      const_attr_reader  :KSD_TYPE_LABEL
      
      const_set_lazy(:KSD_TYPE_TEXTFIELD) { 3 }
      const_attr_reader  :KSD_TYPE_TEXTFIELD
      
      const_set_lazy(:KSD_PROVIDER_LABEL) { 4 }
      const_attr_reader  :KSD_PROVIDER_LABEL
      
      const_set_lazy(:KSD_PROVIDER_TEXTFIELD) { 5 }
      const_attr_reader  :KSD_PROVIDER_TEXTFIELD
      
      const_set_lazy(:KSD_PWD_URL_LABEL) { 6 }
      const_attr_reader  :KSD_PWD_URL_LABEL
      
      const_set_lazy(:KSD_PWD_URL_TEXTFIELD) { 7 }
      const_attr_reader  :KSD_PWD_URL_TEXTFIELD
      
      const_set_lazy(:KSD_CANCEL_BUTTON) { 9 }
      const_attr_reader  :KSD_CANCEL_BUTTON
      
      const_set_lazy(:KSD_OK_BUTTON) { 8 }
      const_attr_reader  :KSD_OK_BUTTON
      
      # the gridbag index for components in the User Save Changes Dialog (USC)
      const_set_lazy(:USC_LABEL) { 0 }
      const_attr_reader  :USC_LABEL
      
      const_set_lazy(:USC_PANEL) { 1 }
      const_attr_reader  :USC_PANEL
      
      const_set_lazy(:USC_YES_BUTTON) { 0 }
      const_attr_reader  :USC_YES_BUTTON
      
      const_set_lazy(:USC_NO_BUTTON) { 1 }
      const_attr_reader  :USC_NO_BUTTON
      
      const_set_lazy(:USC_CANCEL_BUTTON) { 2 }
      const_attr_reader  :USC_CANCEL_BUTTON
      
      # gridbag index for the ConfirmRemovePolicyEntryDialog (CRPE)
      const_set_lazy(:CRPE_LABEL1) { 0 }
      const_attr_reader  :CRPE_LABEL1
      
      const_set_lazy(:CRPE_LABEL2) { 1 }
      const_attr_reader  :CRPE_LABEL2
      
      const_set_lazy(:CRPE_PANEL) { 2 }
      const_attr_reader  :CRPE_PANEL
      
      const_set_lazy(:CRPE_PANEL_OK) { 0 }
      const_attr_reader  :CRPE_PANEL_OK
      
      const_set_lazy(:CRPE_PANEL_CANCEL) { 1 }
      const_attr_reader  :CRPE_PANEL_CANCEL
      
      # some private static finals
      const_set_lazy(:PERMISSION) { 0 }
      const_attr_reader  :PERMISSION
      
      const_set_lazy(:PERMISSION_NAME) { 1 }
      const_attr_reader  :PERMISSION_NAME
      
      const_set_lazy(:PERMISSION_ACTIONS) { 2 }
      const_attr_reader  :PERMISSION_ACTIONS
      
      const_set_lazy(:PERMISSION_SIGNEDBY) { 3 }
      const_attr_reader  :PERMISSION_SIGNEDBY
      
      const_set_lazy(:PRINCIPAL_TYPE) { 4 }
      const_attr_reader  :PRINCIPAL_TYPE
      
      const_set_lazy(:PRINCIPAL_NAME) { 5 }
      const_attr_reader  :PRINCIPAL_NAME
      
      
      def perm_array
        defined?(@@perm_array) ? @@perm_array : @@perm_array= nil
      end
      alias_method :attr_perm_array, :perm_array
      
      def perm_array=(value)
        @@perm_array = value
      end
      alias_method :attr_perm_array=, :perm_array=
      
      
      def prin_array
        defined?(@@prin_array) ? @@prin_array : @@prin_array= nil
      end
      alias_method :attr_prin_array, :prin_array
      
      def prin_array=(value)
        @@prin_array = value
      end
      alias_method :attr_prin_array=, :prin_array=
    }
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    class_module.module_eval {
      when_class_loaded do
        # set up permission objects
        self.attr_perm_array = Java::Util::ArrayList.new
        self.attr_perm_array.add(AllPerm.new)
        self.attr_perm_array.add(AudioPerm.new)
        self.attr_perm_array.add(AuthPerm.new)
        self.attr_perm_array.add(AWTPerm.new)
        self.attr_perm_array.add(DelegationPerm.new)
        self.attr_perm_array.add(FilePerm.new)
        self.attr_perm_array.add(LogPerm.new)
        self.attr_perm_array.add(MgmtPerm.new)
        self.attr_perm_array.add(MBeanPerm.new)
        self.attr_perm_array.add(MBeanSvrPerm.new)
        self.attr_perm_array.add(MBeanTrustPerm.new)
        self.attr_perm_array.add(NetPerm.new)
        self.attr_perm_array.add(PrivCredPerm.new)
        self.attr_perm_array.add(PropPerm.new)
        self.attr_perm_array.add(ReflectPerm.new)
        self.attr_perm_array.add(RuntimePerm.new)
        self.attr_perm_array.add(SecurityPerm.new)
        self.attr_perm_array.add(SerialPerm.new)
        self.attr_perm_array.add(ServicePerm.new)
        self.attr_perm_array.add(SocketPerm.new)
        self.attr_perm_array.add(SQLPerm.new)
        self.attr_perm_array.add(SSLPerm.new)
        self.attr_perm_array.add(SubjDelegPerm.new)
        # set up principal objects
        self.attr_prin_array = Java::Util::ArrayList.new
        self.attr_prin_array.add(KrbPrin.new)
        self.attr_prin_array.add(X500Prin.new)
      end
    }
    
    typesig { [String, PolicyTool, ToolWindow, ::Java::Boolean] }
    def initialize(title, tool, tw, modal)
      @tool = nil
      @tw = nil
      super(tw, modal)
      set_title(title)
      @tool = tool
      @tw = tw
      add_window_listener(ChildWindowListener.new(self))
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Boolean] }
      # get the Perm instance based on either the (shortened) class name
      # or the fully qualified class name
      def get_perm(clazz, full_class_name)
        i = 0
        while i < self.attr_perm_array.size
          next_ = self.attr_perm_array.get(i)
          if (full_class_name)
            if ((next_.attr_full_class == clazz))
              return next_
            end
          else
            if ((next_.attr_class == clazz))
              return next_
            end
          end
          i += 1
        end
        return nil
      end
      
      typesig { [String, ::Java::Boolean] }
      # get the Prin instance based on either the (shortened) class name
      # or the fully qualified class name
      def get_prin(clazz, full_class_name)
        i = 0
        while i < self.attr_prin_array.size
          next_ = self.attr_prin_array.get(i)
          if (full_class_name)
            if ((next_.attr_full_class == clazz))
              return next_
            end
          else
            if ((next_.attr_class == clazz))
              return next_
            end
          end
          i += 1
        end
        return nil
      end
    }
    
    typesig { [String, ::Java::Int] }
    # ask user if they want to overwrite an existing file
    def display_over_write_file_dialog(filename, next_event)
      # find where the PolicyTool gui is
      location = @tw.get_location_on_screen
      set_bounds(location.attr_x + 75, location.attr_y + 100, 400, 150)
      set_layout(GridBagLayout.new)
      # ask the user if they want to over write the existing file
      form = MessageFormat.new(PolicyTool.attr_rb.get_string("OK to overwrite existing file filename?"))
      source = Array.typed(Object).new([filename])
      label = Label.new(form.format(source))
      @tw.add_new_component(self, label, OW_LABEL, 0, 0, 2, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_top_padding)
      # OK button
      button = Button.new(PolicyTool.attr_rb.get_string("OK"))
      button.add_action_listener(OverWriteFileOKButtonListener.new(@tool, @tw, self, filename, next_event))
      @tw.add_new_component(self, button, OW_OK_BUTTON, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_top_padding)
      # Cancel button
      # -- if the user hits cancel, do NOT go on to the next event
      button = Button.new(PolicyTool.attr_rb.get_string("Cancel"))
      button.add_action_listener(CancelButtonListener.new(self))
      @tw.add_new_component(self, button, OW_CANCEL_BUTTON, 1, 1, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_top_padding)
      set_visible(true)
    end
    
    typesig { [::Java::Boolean] }
    # pop up a dialog so the user can enter info to add a new PolicyEntry
    # - if edit is TRUE, then the user is editing an existing entry
    # and we should display the original info as well.
    # 
    # - the other reason we need the 'edit' boolean is we need to know
    # when we are adding a NEW policy entry.  in this case, we can
    # not simply update the existing entry, because it doesn't exist.
    # we ONLY update the GUI listing/info, and then when the user
    # finally clicks 'OK' or 'DONE', then we can collect that info
    # and add it to the policy.
    def display_policy_entry_dialog(edit)
      list_index = 0
      entries = nil
      prin_list = TaggedList.new(3, false)
      prin_list.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("Principal List"))
      prin_list.add_action_listener(EditPrinButtonListener.new(@tool, @tw, self, edit))
      perm_list = TaggedList.new(10, false)
      perm_list.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("Permission List"))
      perm_list.add_action_listener(EditPermButtonListener.new(@tool, @tw, self, edit))
      # find where the PolicyTool gui is
      location = @tw.get_location_on_screen
      set_bounds(location.attr_x + 75, location.attr_y + 200, 650, 500)
      set_layout(GridBagLayout.new)
      set_resizable(true)
      if (edit)
        # get the selected item
        entries = @tool.get_entry
        policy_list = @tw.get_component(@tw.attr_mw_policy_list)
        list_index = policy_list.get_selected_index
        # get principal list
        principals = entries[list_index].get_grant_entry.attr_principals
        i = 0
        while i < principals.size
          prin_string = nil
          next_prin = principals.get(i)
          prin_list.add_tagged_item(_principal_entry_to_user_friendly_string(next_prin), next_prin)
          i += 1
        end
        # get permission list
        permissions = entries[list_index].get_grant_entry.attr_permission_entries
        i_ = 0
        while i_ < permissions.size
          perm_string = nil
          next_perm = permissions.element_at(i_)
          perm_list.add_tagged_item(ToolDialog._permission_entry_to_user_friendly_string(next_perm), next_perm)
          i_ += 1
        end
      end
      # codebase label and textfield
      label = Label.new(PolicyTool.attr_rb.get_string("CodeBase:"))
      @tw.add_new_component(self, label, PE_CODEBASE_LABEL, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      tf = nil
      tf = (edit ? TextField.new(entries[list_index].get_grant_entry.attr_code_base, 60) : TextField.new(60))
      tf.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("Code Base"))
      @tw.add_new_component(self, tf, PE_CODEBASE_TEXTFIELD, 1, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      # signedby label and textfield
      label = Label.new(PolicyTool.attr_rb.get_string("SignedBy:"))
      @tw.add_new_component(self, label, PE_SIGNEDBY_LABEL, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      tf = (edit ? TextField.new(entries[list_index].get_grant_entry.attr_signed_by, 60) : TextField.new(60))
      tf.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("Signed By:"))
      @tw.add_new_component(self, tf, PE_SIGNEDBY_TEXTFIELD, 1, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      # panel for principal buttons
      panel = Panel.new
      panel.set_layout(GridBagLayout.new)
      button = Button.new(PolicyTool.attr_rb.get_string("Add Principal"))
      button.add_action_listener(AddPrinButtonListener.new(@tool, @tw, self, edit))
      @tw.add_new_component(panel, button, PE_ADD_PRIN_BUTTON, 0, 0, 1, 1, 100.0, 0.0, GridBagConstraints::HORIZONTAL)
      button = Button.new(PolicyTool.attr_rb.get_string("Edit Principal"))
      button.add_action_listener(EditPrinButtonListener.new(@tool, @tw, self, edit))
      @tw.add_new_component(panel, button, PE_EDIT_PRIN_BUTTON, 1, 0, 1, 1, 100.0, 0.0, GridBagConstraints::HORIZONTAL)
      button = Button.new(PolicyTool.attr_rb.get_string("Remove Principal"))
      button.add_action_listener(RemovePrinButtonListener.new(@tool, @tw, self, edit))
      @tw.add_new_component(panel, button, PE_REMOVE_PRIN_BUTTON, 2, 0, 1, 1, 100.0, 0.0, GridBagConstraints::HORIZONTAL)
      @tw.add_new_component(self, panel, PE_PANEL0, 1, 2, 1, 1, 0.0, 0.0, GridBagConstraints::HORIZONTAL)
      # principal label and list
      label = Label.new(PolicyTool.attr_rb.get_string("Principals:"))
      @tw.add_new_component(self, label, PE_PRIN_LABEL, 0, 3, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
      @tw.add_new_component(self, prin_list, PE_PRIN_LIST, 1, 3, 3, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
      # panel for permission buttons
      panel = Panel.new
      panel.set_layout(GridBagLayout.new)
      button = Button.new(PolicyTool.attr_rb.get_string("  Add Permission"))
      button.add_action_listener(AddPermButtonListener.new(@tool, @tw, self, edit))
      @tw.add_new_component(panel, button, PE_ADD_PERM_BUTTON, 0, 0, 1, 1, 100.0, 0.0, GridBagConstraints::HORIZONTAL)
      button = Button.new(PolicyTool.attr_rb.get_string("  Edit Permission"))
      button.add_action_listener(EditPermButtonListener.new(@tool, @tw, self, edit))
      @tw.add_new_component(panel, button, PE_EDIT_PERM_BUTTON, 1, 0, 1, 1, 100.0, 0.0, GridBagConstraints::HORIZONTAL)
      button = Button.new(PolicyTool.attr_rb.get_string("Remove Permission"))
      button.add_action_listener(RemovePermButtonListener.new(@tool, @tw, self, edit))
      @tw.add_new_component(panel, button, PE_REMOVE_PERM_BUTTON, 2, 0, 1, 1, 100.0, 0.0, GridBagConstraints::HORIZONTAL)
      @tw.add_new_component(self, panel, PE_PANEL1, 0, 4, 2, 1, 0.0, 0.0, GridBagConstraints::HORIZONTAL, @tw.attr_lite_bottom_padding)
      # permission list
      @tw.add_new_component(self, perm_list, PE_PERM_LIST, 0, 5, 3, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
      # panel for Done and Cancel buttons
      panel = Panel.new
      panel.set_layout(GridBagLayout.new)
      # Done Button
      button = Button.new(PolicyTool.attr_rb.get_string("Done"))
      button.add_action_listener(AddEntryDoneButtonListener.new(@tool, @tw, self, edit))
      @tw.add_new_component(panel, button, PE_DONE_BUTTON, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_lr_padding)
      # Cancel Button
      button = Button.new(PolicyTool.attr_rb.get_string("Cancel"))
      button.add_action_listener(CancelButtonListener.new(self))
      @tw.add_new_component(panel, button, PE_CANCEL_BUTTON, 1, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_lr_padding)
      # add the panel
      @tw.add_new_component(self, panel, PE_PANEL2, 0, 6, 2, 1, 0.0, 0.0, GridBagConstraints::VERTICAL)
      set_visible(true)
    end
    
    typesig { [] }
    # Read all the Policy information data in the dialog box
    # and construct a PolicyEntry object with it.
    def get_policy_entry_from_dialog
      # get the Codebase
      tf = get_component(PE_CODEBASE_TEXTFIELD)
      codebase = nil
      if (((tf.get_text.trim == "")).equal?(false))
        codebase = RJava.cast_to_string(String.new(tf.get_text.trim))
      end
      # get the SignedBy
      tf = get_component(PE_SIGNEDBY_TEXTFIELD)
      signedby = nil
      if (((tf.get_text.trim == "")).equal?(false))
        signedby = RJava.cast_to_string(String.new(tf.get_text.trim))
      end
      # construct a new GrantEntry
      ge = PolicyParser::GrantEntry.new(signedby, codebase)
      # get the new Principals
      prins = LinkedList.new
      prin_list = get_component(PE_PRIN_LIST)
      i = 0
      while i < prin_list.get_item_count
        prins.add(prin_list.get_object(i))
        i += 1
      end
      ge.attr_principals = prins
      # get the new Permissions
      perms = Vector.new
      perm_list = get_component(PE_PERM_LIST)
      i_ = 0
      while i_ < perm_list.get_item_count
        perms.add_element(perm_list.get_object(i_))
        i_ += 1
      end
      ge.attr_permission_entries = perms
      # construct a new PolicyEntry object
      entry = PolicyEntry.new(@tool, ge)
      return entry
    end
    
    typesig { [::Java::Int] }
    # display a dialog box for the user to enter KeyStore information
    def key_store_dialog(mode)
      # find where the PolicyTool gui is
      location = @tw.get_location_on_screen
      set_bounds(location.attr_x + 25, location.attr_y + 100, 500, 300)
      set_layout(GridBagLayout.new)
      if ((mode).equal?(EDIT_KEYSTORE))
        # KeyStore label and textfield
        label = Label.new(PolicyTool.attr_rb.get_string("KeyStore URL:"))
        @tw.add_new_component(self, label, KSD_NAME_LABEL, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        tf = TextField.new(@tool.get_key_store_name, 30)
        # URL to U R L, so that accessibility reader will pronounce well
        tf.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("KeyStore U R L:"))
        @tw.add_new_component(self, tf, KSD_NAME_TEXTFIELD, 1, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        # KeyStore type and textfield
        label = Label.new(PolicyTool.attr_rb.get_string("KeyStore Type:"))
        @tw.add_new_component(self, label, KSD_TYPE_LABEL, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        tf = TextField.new(@tool.get_key_store_type, 30)
        tf.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("KeyStore Type:"))
        @tw.add_new_component(self, tf, KSD_TYPE_TEXTFIELD, 1, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        # KeyStore provider and textfield
        label = Label.new(PolicyTool.attr_rb.get_string("KeyStore Provider:"))
        @tw.add_new_component(self, label, KSD_PROVIDER_LABEL, 0, 2, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        tf = TextField.new(@tool.get_key_store_provider, 30)
        tf.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("KeyStore Provider:"))
        @tw.add_new_component(self, tf, KSD_PROVIDER_TEXTFIELD, 1, 2, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        # KeyStore password URL and textfield
        label = Label.new(PolicyTool.attr_rb.get_string("KeyStore Password URL:"))
        @tw.add_new_component(self, label, KSD_PWD_URL_LABEL, 0, 3, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        tf = TextField.new(@tool.get_key_store_pwd_url, 30)
        tf.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("KeyStore Password U R L:"))
        @tw.add_new_component(self, tf, KSD_PWD_URL_TEXTFIELD, 1, 3, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        # OK button
        ok_button = Button.new(PolicyTool.attr_rb.get_string("OK"))
        ok_button.add_action_listener(ChangeKeyStoreOKButtonListener.new(@tool, @tw, self))
        @tw.add_new_component(self, ok_button, KSD_OK_BUTTON, 0, 4, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL)
        # cancel button
        cancel_button = Button.new(PolicyTool.attr_rb.get_string("Cancel"))
        cancel_button.add_action_listener(CancelButtonListener.new(self))
        @tw.add_new_component(self, cancel_button, KSD_CANCEL_BUTTON, 1, 4, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL)
      end
      set_visible(true)
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # display a dialog box for the user to input Principal info
    # 
    # if editPolicyEntry is false, then we are adding Principals to
    # a new PolicyEntry, and we only update the GUI listing
    # with the new Principal.
    # 
    # if edit is true, then we are editing an existing Policy entry.
    def display_principal_dialog(edit_policy_entry, edit)
      edit_me = nil
      # get the Principal selected from the Principal List
      prin_list = get_component(PE_PRIN_LIST)
      prin_index = prin_list.get_selected_index
      if (edit)
        edit_me = prin_list.get_object(prin_index)
      end
      new_td = ToolDialog.new(PolicyTool.attr_rb.get_string("Principals"), @tool, @tw, true)
      new_td.add_window_listener(ChildWindowListener.new(new_td))
      # find where the PolicyTool gui is
      location = get_location_on_screen
      new_td.set_bounds(location.attr_x + 50, location.attr_y + 100, 650, 190)
      new_td.set_layout(GridBagLayout.new)
      new_td.set_resizable(true)
      # description label
      label = (edit ? Label.new(PolicyTool.attr_rb.get_string("  Edit Principal:")) : Label.new(PolicyTool.attr_rb.get_string("  Add New Principal:")))
      @tw.add_new_component(new_td, label, PRD_DESC_LABEL, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_top_bottom_padding)
      # principal choice
      choice = Choice.new
      choice.add(PRIN_TYPE)
      choice.get_accessible_context.set_accessible_name(PRIN_TYPE)
      i = 0
      while i < self.attr_prin_array.size
        next_ = self.attr_prin_array.get(i)
        choice.add(next_.attr_class)
        i += 1
      end
      choice.add_item_listener(PrincipalTypeMenuListener.new(new_td))
      if (edit)
        if ((PolicyParser::PrincipalEntry::WILDCARD_CLASS == edit_me.get_principal_class))
          choice.select(PRIN_TYPE)
        else
          input_prin = get_prin(edit_me.get_principal_class, true)
          if (!(input_prin).nil?)
            choice.select(input_prin.attr_class)
          end
        end
      end
      @tw.add_new_component(new_td, choice, PRD_PRIN_CHOICE, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      # principal textfield
      tf = nil
      tf = (edit ? TextField.new(edit_me.get_display_class, 30) : TextField.new(30))
      tf.get_accessible_context.set_accessible_name(PRIN_TYPE)
      @tw.add_new_component(new_td, tf, PRD_PRIN_TEXTFIELD, 1, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      # name label and textfield
      label = Label.new(PRIN_NAME)
      tf = (edit ? TextField.new(edit_me.get_display_name, 40) : TextField.new(40))
      tf.get_accessible_context.set_accessible_name(PRIN_NAME)
      @tw.add_new_component(new_td, label, PRD_NAME_LABEL, 0, 2, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      @tw.add_new_component(new_td, tf, PRD_NAME_TEXTFIELD, 1, 2, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      # OK button
      ok_button = Button.new(PolicyTool.attr_rb.get_string("OK"))
      ok_button.add_action_listener(NewPolicyPrinOKButtonListener.new(@tool, @tw, self, new_td, edit))
      @tw.add_new_component(new_td, ok_button, PRD_OK_BUTTON, 0, 3, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_top_bottom_padding)
      # cancel button
      cancel_button = Button.new(PolicyTool.attr_rb.get_string("Cancel"))
      cancel_button.add_action_listener(CancelButtonListener.new(new_td))
      @tw.add_new_component(new_td, cancel_button, PRD_CANCEL_BUTTON, 1, 3, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_top_bottom_padding)
      new_td.set_visible(true)
    end
    
    typesig { [::Java::Boolean, ::Java::Boolean] }
    # display a dialog box for the user to input Permission info
    # 
    # if editPolicyEntry is false, then we are adding Permissions to
    # a new PolicyEntry, and we only update the GUI listing
    # with the new Permission.
    # 
    # if edit is true, then we are editing an existing Permission entry.
    def display_permission_dialog(edit_policy_entry, edit)
      edit_me = nil
      # get the Permission selected from the Permission List
      perm_list = get_component(PE_PERM_LIST)
      perm_index = perm_list.get_selected_index
      if (edit)
        edit_me = perm_list.get_object(perm_index)
      end
      new_td = ToolDialog.new(PolicyTool.attr_rb.get_string("Permissions"), @tool, @tw, true)
      new_td.add_window_listener(ChildWindowListener.new(new_td))
      # find where the PolicyTool gui is
      location = get_location_on_screen
      new_td.set_bounds(location.attr_x + 50, location.attr_y + 100, 700, 250)
      new_td.set_layout(GridBagLayout.new)
      new_td.set_resizable(true)
      # description label
      label = (edit ? Label.new(PolicyTool.attr_rb.get_string("  Edit Permission:")) : Label.new(PolicyTool.attr_rb.get_string("  Add New Permission:")))
      @tw.add_new_component(new_td, label, PD_DESC_LABEL, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_top_bottom_padding)
      # permission choice (added in alphabetical order)
      choice = Choice.new
      choice.add(PERM)
      choice.get_accessible_context.set_accessible_name(PERM)
      i = 0
      while i < self.attr_perm_array.size
        next_ = self.attr_perm_array.get(i)
        choice.add(next_.attr_class)
        i += 1
      end
      choice.add_item_listener(PermissionMenuListener.new(new_td))
      @tw.add_new_component(new_td, choice, PD_PERM_CHOICE, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      # permission textfield
      tf = nil
      tf = (edit ? TextField.new(edit_me.attr_permission, 30) : TextField.new(30))
      tf.get_accessible_context.set_accessible_name(PERM)
      if (edit)
        input_perm = get_perm(edit_me.attr_permission, true)
        if (!(input_perm).nil?)
          choice.select(input_perm.attr_class)
        end
      end
      @tw.add_new_component(new_td, tf, PD_PERM_TEXTFIELD, 1, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      # name label and textfield
      choice = Choice.new
      choice.add(PERM_NAME)
      choice.get_accessible_context.set_accessible_name(PERM_NAME)
      choice.add_item_listener(PermissionNameMenuListener.new(new_td))
      tf = (edit ? TextField.new(edit_me.attr_name, 40) : TextField.new(40))
      tf.get_accessible_context.set_accessible_name(PERM_NAME)
      if (edit)
        set_permission_names(get_perm(edit_me.attr_permission, true), choice, tf)
      end
      @tw.add_new_component(new_td, choice, PD_NAME_CHOICE, 0, 2, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      @tw.add_new_component(new_td, tf, PD_NAME_TEXTFIELD, 1, 2, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      # actions label and textfield
      choice = Choice.new
      choice.add(PERM_ACTIONS)
      choice.get_accessible_context.set_accessible_name(PERM_ACTIONS)
      choice.add_item_listener(PermissionActionsMenuListener.new(new_td))
      tf = (edit ? TextField.new(edit_me.attr_action, 40) : TextField.new(40))
      tf.get_accessible_context.set_accessible_name(PERM_ACTIONS)
      if (edit)
        set_permission_actions(get_perm(edit_me.attr_permission, true), choice, tf)
      end
      @tw.add_new_component(new_td, choice, PD_ACTIONS_CHOICE, 0, 3, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      @tw.add_new_component(new_td, tf, PD_ACTIONS_TEXTFIELD, 1, 3, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      # signedby label and textfield
      label = Label.new(PolicyTool.attr_rb.get_string("Signed By:"))
      @tw.add_new_component(new_td, label, PD_SIGNEDBY_LABEL, 0, 4, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      tf = (edit ? TextField.new(edit_me.attr_signed_by, 40) : TextField.new(40))
      tf.get_accessible_context.set_accessible_name(PolicyTool.attr_rb.get_string("Signed By:"))
      @tw.add_new_component(new_td, tf, PD_SIGNEDBY_TEXTFIELD, 1, 4, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_lr_padding)
      # OK button
      ok_button = Button.new(PolicyTool.attr_rb.get_string("OK"))
      ok_button.add_action_listener(NewPolicyPermOKButtonListener.new(@tool, @tw, self, new_td, edit))
      @tw.add_new_component(new_td, ok_button, PD_OK_BUTTON, 0, 5, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_top_bottom_padding)
      # cancel button
      cancel_button = Button.new(PolicyTool.attr_rb.get_string("Cancel"))
      cancel_button.add_action_listener(CancelButtonListener.new(new_td))
      @tw.add_new_component(new_td, cancel_button, PD_CANCEL_BUTTON, 1, 5, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_top_bottom_padding)
      new_td.set_visible(true)
    end
    
    typesig { [] }
    # construct a Principal object from the Principal Info Dialog Box
    def get_prin_from_dialog
      tf = get_component(PRD_PRIN_TEXTFIELD)
      pclass = String.new(tf.get_text.trim)
      tf = get_component(PRD_NAME_TEXTFIELD)
      pname = String.new(tf.get_text.trim)
      if ((pclass == "*"))
        pclass = RJava.cast_to_string(PolicyParser::PrincipalEntry::WILDCARD_CLASS)
      end
      if ((pname == "*"))
        pname = RJava.cast_to_string(PolicyParser::PrincipalEntry::WILDCARD_NAME)
      end
      pppe = nil
      if (((pclass == PolicyParser::PrincipalEntry::WILDCARD_CLASS)) && (!(pname == PolicyParser::PrincipalEntry::WILDCARD_NAME)))
        raise JavaException.new(PolicyTool.attr_rb.get_string("Cannot Specify Principal " + "with a Wildcard Class without a Wildcard Name"))
      else
        if ((pname == ""))
          raise JavaException.new(PolicyTool.attr_rb.get_string("Cannot Specify Principal " + "without a Name"))
        else
          if ((pclass == ""))
            # make this consistent with what PolicyParser does
            # when it sees an empty principal class
            pclass = RJava.cast_to_string(PolicyParser::REPLACE_NAME)
            @tool.attr_warnings.add_element("Warning: Principal name '" + pname + "' specified without a Principal class.\n" + "\t'" + pname + "' will be interpreted " + "as a key store alias.\n" + "\tThe final principal class will be " + RJava.cast_to_string(ToolDialog::X500_PRIN_CLASS) + ".\n" + "\tThe final principal name will be " + "determined by the following:\n" + "\n" + "\tIf the key store entry identified by '" + pname + "'\n" + "\tis a key entry, then the principal name will be\n" + "\tthe subject distinguished name from the first\n" + "\tcertificate in the entry's certificate chain.\n" + "\n" + "\tIf the key store entry identified by '" + pname + "'\n" + "\tis a trusted certificate entry, then the\n" + "\tprincipal name will be the subject distinguished\n" + "\tname from the trusted public key certificate.")
            @tw.display_status_dialog(self, "'" + pname + "' will be interpreted as a key " + "store alias.  View Warning Log for details.")
          end
        end
      end
      return PolicyParser::PrincipalEntry.new(pclass, pname)
    end
    
    typesig { [] }
    # construct a Permission object from the Permission Info Dialog Box
    def get_perm_from_dialog
      tf = get_component(PD_PERM_TEXTFIELD)
      permission = String.new(tf.get_text.trim)
      tf = get_component(PD_NAME_TEXTFIELD)
      name = nil
      if (((tf.get_text.trim == "")).equal?(false))
        name = RJava.cast_to_string(String.new(tf.get_text.trim))
      end
      if ((permission == "") || (!(permission == ALL_PERM_CLASS) && (name).nil?))
        raise InvalidParameterException.new(PolicyTool.attr_rb.get_string("Permission and Target Name must have a value"))
      end
      # When the permission is FilePermission, we need to check the name
      # to make sure it's not escaped. We believe --
      # 
      # String             name.lastIndexOf("\\\\")
      # ----------------   ------------------------
      # c:\foo\bar         -1, legal
      # c:\\foo\\bar       2, illegal
      # \\server\share     0, legal
      # \\\\server\share   2, illegal
      if ((permission == FILE_PERM_CLASS) && name.last_index_of("\\\\") > 0)
        result = @tw.display_yes_no_dialog(self, PolicyTool.attr_rb.get_string("Warning"), PolicyTool.attr_rb.get_string("Warning: File name may include escaped backslash characters. " + "It is not necessary to escape backslash characters " + "(the tool escapes characters as necessary when writing " + "the policy contents to the persistent store).\n\n" + "Click on Retain to retain the entered name, or click on " + "Edit to edit the name."), PolicyTool.attr_rb.get_string("Retain"), PolicyTool.attr_rb.get_string("Edit"))
        if (!(result).equal?(Character.new(?Y.ord)))
          # an invisible exception
          raise NoDisplayException.new
        end
      end
      # get the Actions
      tf = get_component(PD_ACTIONS_TEXTFIELD)
      actions = nil
      if (((tf.get_text.trim == "")).equal?(false))
        actions = RJava.cast_to_string(String.new(tf.get_text.trim))
      end
      # get the Signed By
      tf = get_component(PD_SIGNEDBY_TEXTFIELD)
      signed_by = nil
      if (((tf.get_text.trim == "")).equal?(false))
        signed_by = RJava.cast_to_string(String.new(tf.get_text.trim))
      end
      pppe = PolicyParser::PermissionEntry.new(permission, name, actions)
      pppe.attr_signed_by = signed_by
      # see if the signers have public keys
      if (!(signed_by).nil?)
        signers = @tool.parse_signers(pppe.attr_signed_by)
        i = 0
        while i < signers.attr_length
          begin
            pub_key = @tool.get_public_key_alias(signers[i])
            if ((pub_key).nil?)
              form = MessageFormat.new(PolicyTool.attr_rb.get_string("Warning: A public key for alias " + "'signers[i]' does not exist.  " + "Make sure a KeyStore is properly configured."))
              source = Array.typed(Object).new([signers[i]])
              @tool.attr_warnings.add_element(form.format(source))
              @tw.display_status_dialog(self, form.format(source))
            end
          rescue JavaException => e
            @tw.display_error_dialog(self, e)
          end
          i += 1
        end
      end
      return pppe
    end
    
    typesig { [] }
    # confirm that the user REALLY wants to remove the Policy Entry
    def display_confirm_remove_policy_entry
      # find the entry to be removed
      list = @tw.get_component(@tw.attr_mw_policy_list)
      index = list.get_selected_index
      entries = @tool.get_entry
      # find where the PolicyTool gui is
      location = @tw.get_location_on_screen
      set_bounds(location.attr_x + 25, location.attr_y + 100, 600, 400)
      set_layout(GridBagLayout.new)
      # ask the user do they really want to do this?
      label = Label.new(PolicyTool.attr_rb.get_string("Remove this Policy Entry?"))
      @tw.add_new_component(self, label, CRPE_LABEL1, 0, 0, 2, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
      # display the policy entry
      label = Label.new(entries[index].codebase_to_string)
      @tw.add_new_component(self, label, CRPE_LABEL2, 0, 1, 2, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      label = Label.new(entries[index].principals_to_string.trim)
      @tw.add_new_component(self, label, CRPE_LABEL2 + 1, 0, 2, 2, 1, 0.0, 0.0, GridBagConstraints::BOTH)
      perms = entries[index].get_grant_entry.attr_permission_entries
      i = 0
      while i < perms.size
        next_perm = perms.element_at(i)
        perm_string = ToolDialog._permission_entry_to_user_friendly_string(next_perm)
        label = Label.new("    " + perm_string)
        if ((i).equal?((perms.size - 1)))
          @tw.add_new_component(self, label, CRPE_LABEL2 + 2 + i, 1, 3 + i, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_bottom_padding)
        else
          @tw.add_new_component(self, label, CRPE_LABEL2 + 2 + i, 1, 3 + i, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
        end
        i += 1
      end
      # add OK/CANCEL buttons in a new panel
      panel = Panel.new
      panel.set_layout(GridBagLayout.new)
      # OK button
      ok_button = Button.new(PolicyTool.attr_rb.get_string("OK"))
      ok_button.add_action_listener(ConfirmRemovePolicyEntryOKButtonListener.new(@tool, @tw, self))
      @tw.add_new_component(panel, ok_button, CRPE_PANEL_OK, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_lr_padding)
      # cancel button
      cancel_button = Button.new(PolicyTool.attr_rb.get_string("Cancel"))
      cancel_button.add_action_listener(CancelButtonListener.new(self))
      @tw.add_new_component(panel, cancel_button, CRPE_PANEL_CANCEL, 1, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_lr_padding)
      @tw.add_new_component(self, panel, CRPE_LABEL2 + 2 + perms.size, 0, 3 + perms.size, 2, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_top_bottom_padding)
      pack
      set_visible(true)
    end
    
    typesig { [::Java::Int] }
    # perform SAVE AS
    def display_save_as_dialog(next_event)
      # pop up a dialog box for the user to enter a filename.
      fd = FileDialog.new(@tw, PolicyTool.attr_rb.get_string("Save As"), FileDialog::SAVE)
      fd.add_window_listener(Class.new(WindowAdapter.class == Class ? WindowAdapter : Object) do
        extend LocalClass
        include_class_members ToolDialog
        include WindowAdapter if WindowAdapter.class == Module
        
        typesig { [WindowEvent] }
        define_method :window_closing do |e|
          e.get_window.set_visible(false)
        end
        
        typesig { [Object] }
        define_method :initialize do |*args|
          super(*args)
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      fd.set_visible(true)
      # see if the user hit cancel
      if ((fd.get_file).nil? || (fd.get_file == ""))
        return
      end
      # get the entered filename
      filename = String.new(fd.get_directory + fd.get_file)
      fd.dispose
      # see if the file already exists
      save_as_file = JavaFile.new(filename)
      if (save_as_file.exists)
        # display a dialog box for the user to enter policy info
        td = ToolDialog.new(PolicyTool.attr_rb.get_string("Overwrite File"), @tool, @tw, true)
        td.display_over_write_file_dialog(filename, next_event)
      else
        begin
          # save the policy entries to a file
          @tool.save_policy(filename)
          # display status
          form = MessageFormat.new(PolicyTool.attr_rb.get_string("Policy successfully written to filename"))
          source = Array.typed(Object).new([filename])
          @tw.display_status_dialog(nil, form.format(source))
          # display the new policy filename
          new_filename = @tw.get_component(@tw.attr_mw_filename_textfield)
          new_filename.set_text(filename)
          @tw.set_visible(true)
          # now continue with the originally requested command
          # (QUIT, NEW, or OPEN)
          user_save_continue(@tool, @tw, self, next_event)
        rescue FileNotFoundException => fnfe
          if ((filename).nil? || (filename == ""))
            @tw.display_error_dialog(nil, FileNotFoundException.new(PolicyTool.attr_rb.get_string("null filename")))
          else
            @tw.display_error_dialog(nil, fnfe)
          end
        rescue JavaException => ee
          @tw.display_error_dialog(nil, ee)
        end
      end
    end
    
    typesig { [::Java::Int] }
    # ask user if they want to save changes
    def display_user_save(select_)
      if ((@tool.attr_modified).equal?(true))
        # find where the PolicyTool gui is
        location = @tw.get_location_on_screen
        set_bounds(location.attr_x + 75, location.attr_y + 100, 400, 150)
        set_layout(GridBagLayout.new)
        label = Label.new(PolicyTool.attr_rb.get_string("Save changes?"))
        @tw.add_new_component(self, label, USC_LABEL, 0, 0, 3, 1, 0.0, 0.0, GridBagConstraints::BOTH, @tw.attr_l_top_bottom_padding)
        panel = Panel.new
        panel.set_layout(GridBagLayout.new)
        yes_button = Button.new(PolicyTool.attr_rb.get_string("Yes"))
        yes_button.add_action_listener(UserSaveYesButtonListener.new(self, @tool, @tw, select_))
        @tw.add_new_component(panel, yes_button, USC_YES_BUTTON, 0, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_lr_bottom_padding)
        no_button = Button.new(PolicyTool.attr_rb.get_string("No"))
        no_button.add_action_listener(UserSaveNoButtonListener.new(self, @tool, @tw, select_))
        @tw.add_new_component(panel, no_button, USC_NO_BUTTON, 1, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_lr_bottom_padding)
        cancel_button = Button.new(PolicyTool.attr_rb.get_string("Cancel"))
        cancel_button.add_action_listener(UserSaveCancelButtonListener.new(self))
        @tw.add_new_component(panel, cancel_button, USC_CANCEL_BUTTON, 2, 0, 1, 1, 0.0, 0.0, GridBagConstraints::VERTICAL, @tw.attr_lr_bottom_padding)
        @tw.add_new_component(self, panel, USC_PANEL, 0, 1, 1, 1, 0.0, 0.0, GridBagConstraints::BOTH)
        pack
        set_visible(true)
      else
        # just do the original request (QUIT, NEW, or OPEN)
        user_save_continue(@tool, @tw, self, select_)
      end
    end
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ::Java::Int] }
    # when the user sees the 'YES', 'NO', 'CANCEL' buttons on the
    # displayUserSave dialog, and the click on one of them,
    # we need to continue the originally requested action
    # (either QUITting, opening NEW policy file, or OPENing an existing
    # policy file.  do that now.
    def user_save_continue(tool, tw, us, select_)
      # now either QUIT, open a NEW policy file, or OPEN an existing policy
      case (select_)
      when ToolDialog::QUIT
        tw.set_visible(false)
        tw.dispose
        System.exit(0)
        begin
          tool.open_policy(nil)
        rescue JavaException => ee
          tool.attr_modified = false
          tw.display_error_dialog(nil, ee)
        end
        # display the policy entries via the policy list textarea
        list = JavaList.new(40, false)
        list.add_action_listener(PolicyListListener.new(tool, tw))
        tw.replace_policy_list(list)
        # display null policy filename and keystore
        new_filename = tw.get_component(tw.attr_mw_filename_textfield)
        new_filename.set_text("")
        tw.set_visible(true)
      when ToolDialog::NEW
        begin
          tool.open_policy(nil)
        rescue JavaException => ee
          tool.attr_modified = false
          tw.display_error_dialog(nil, ee)
        end
        # display the policy entries via the policy list textarea
        list = JavaList.new(40, false)
        list.add_action_listener(PolicyListListener.new(tool, tw))
        tw.replace_policy_list(list)
        # display null policy filename and keystore
        new_filename = tw.get_component(tw.attr_mw_filename_textfield)
        new_filename.set_text("")
        tw.set_visible(true)
      when ToolDialog::OPEN
        # pop up a dialog box for the user to enter a filename.
        fd = FileDialog.new(tw, PolicyTool.attr_rb.get_string("Open"), FileDialog::LOAD)
        fd.add_window_listener(Class.new(WindowAdapter.class == Class ? WindowAdapter : Object) do
          extend LocalClass
          include_class_members ToolDialog
          include WindowAdapter if WindowAdapter.class == Module
          
          typesig { [WindowEvent] }
          define_method :window_closing do |e|
            e.get_window.set_visible(false)
          end
          
          typesig { [Object] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        fd.set_visible(true)
        # see if the user hit 'cancel'
        if ((fd.get_file).nil? || (fd.get_file == ""))
          return
        end
        # get the entered filename
        policy_file = String.new(fd.get_directory + fd.get_file)
        begin
          # open the policy file
          tool.open_policy(policy_file)
          # display the policy entries via the policy list textarea
          self.attr_list = JavaList.new(40, false)
          self.attr_list.add_action_listener(PolicyListListener.new(tool, tw))
          entries = tool.get_entry
          if (!(entries).nil?)
            i = 0
            while i < entries.attr_length
              self.attr_list.add(entries[i].header_to_string)
              i += 1
            end
          end
          tw.replace_policy_list(self.attr_list)
          tool.attr_modified = false
          # display the new policy filename
          self.attr_new_filename = tw.get_component(tw.attr_mw_filename_textfield)
          self.attr_new_filename.set_text(policy_file)
          tw.set_visible(true)
          # inform user of warnings
          if ((tool.attr_new_warning).equal?(true))
            tw.display_status_dialog(nil, PolicyTool.attr_rb.get_string("Errors have occurred while opening the " + "policy configuration.  View the Warning Log " + "for more information."))
          end
        rescue JavaException => e
          # add blank policy listing
          self.attr_list = JavaList.new(40, false)
          self.attr_list.add_action_listener(PolicyListListener.new(tool, tw))
          tw.replace_policy_list(self.attr_list)
          tool.set_policy_file_name(nil)
          tool.attr_modified = false
          # display a null policy filename
          self.attr_new_filename = tw.get_component(tw.attr_mw_filename_textfield)
          self.attr_new_filename.set_text("")
          tw.set_visible(true)
          # display the error
          form = MessageFormat.new(PolicyTool.attr_rb.get_string("Could not open policy file: policyFile: e.toString()"))
          source = Array.typed(Object).new([policy_file, e.to_s])
          tw.display_error_dialog(nil, form.format(source))
        end
      end
    end
    
    typesig { [Perm, Choice, TextField] }
    # Return a Menu list of names for a given permission
    # 
    # If inputPerm's TARGETS are null, then this means TARGETS are
    # not allowed to be entered (and the TextField is set to be
    # non-editable).
    # 
    # If TARGETS are valid but there are no standard ones
    # (user must enter them by hand) then the TARGETS array may be empty
    # (and of course non-null).
    def set_permission_names(input_perm, names, field)
      names.remove_all
      names.add(PERM_NAME)
      if ((input_perm).nil?)
        # custom permission
        field.set_editable(true)
      else
        if ((input_perm.attr_targets).nil?)
          # standard permission with no targets
          field.set_editable(false)
        else
          # standard permission with standard targets
          field.set_editable(true)
          i = 0
          while i < input_perm.attr_targets.attr_length
            names.add(input_perm.attr_targets[i])
            i += 1
          end
        end
      end
    end
    
    typesig { [Perm, Choice, TextField] }
    # Return a Menu list of actions for a given permission
    # 
    # If inputPerm's ACTIONS are null, then this means ACTIONS are
    # not allowed to be entered (and the TextField is set to be
    # non-editable).  This is typically true for BasicPermissions.
    # 
    # If ACTIONS are valid but there are no standard ones
    # (user must enter them by hand) then the ACTIONS array may be empty
    # (and of course non-null).
    def set_permission_actions(input_perm, actions, field)
      actions.remove_all
      actions.add(PERM_ACTIONS)
      if ((input_perm).nil?)
        # custom permission
        field.set_editable(true)
      else
        if ((input_perm.attr_actions).nil?)
          # standard permission with no actions
          field.set_editable(false)
        else
          # standard permission with standard actions
          field.set_editable(true)
          i = 0
          while i < input_perm.attr_actions.attr_length
            actions.add(input_perm.attr_actions[i])
            i += 1
          end
        end
      end
    end
    
    class_module.module_eval {
      typesig { [PolicyParser::PermissionEntry] }
      def _permission_entry_to_user_friendly_string(pppe)
        result = pppe.attr_permission
        if (!(pppe.attr_name).nil?)
          result += " " + RJava.cast_to_string(pppe.attr_name)
        end
        if (!(pppe.attr_action).nil?)
          result += ", \"" + RJava.cast_to_string(pppe.attr_action) + "\""
        end
        if (!(pppe.attr_signed_by).nil?)
          result += ", signedBy " + RJava.cast_to_string(pppe.attr_signed_by)
        end
        return result
      end
      
      typesig { [PolicyParser::PrincipalEntry] }
      def _principal_entry_to_user_friendly_string(pppe)
        sw = StringWriter.new
        pw = PrintWriter.new(sw)
        pppe.write(pw)
        return sw.to_s
      end
    }
    
    private
    alias_method :initialize__tool_dialog, :initialize
  end
  
  # Event handler for the PolicyTool window
  class ToolWindowListener 
    include_class_members PolicyToolImports
    include WindowListener
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    typesig { [ToolWindow] }
    def initialize(tw)
      @tw = nil
      @tw = tw
    end
    
    typesig { [WindowEvent] }
    def window_opened(we)
    end
    
    typesig { [WindowEvent] }
    def window_closing(we)
      # XXX
      # should we ask user if they want to save changes?
      # (we do if they choose the Menu->Exit)
      # seems that if they kill the application by hand,
      # we don't have to ask.
      @tw.set_visible(false)
      @tw.dispose
      System.exit(0)
    end
    
    typesig { [WindowEvent] }
    def window_closed(we)
      System.exit(0)
    end
    
    typesig { [WindowEvent] }
    def window_iconified(we)
    end
    
    typesig { [WindowEvent] }
    def window_deiconified(we)
    end
    
    typesig { [WindowEvent] }
    def window_activated(we)
    end
    
    typesig { [WindowEvent] }
    def window_deactivated(we)
    end
    
    private
    alias_method :initialize__tool_window_listener, :initialize
  end
  
  # Event handler for the Policy List
  class PolicyListListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    typesig { [PolicyTool, ToolWindow] }
    def initialize(tool, tw)
      @tool = nil
      @tw = nil
      @tool = tool
      @tw = tw
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # display the permission list for a policy entry
      td = ToolDialog.new(PolicyTool.attr_rb.get_string("Policy Entry"), @tool, @tw, true)
      td.display_policy_entry_dialog(true)
    end
    
    private
    alias_method :initialize__policy_list_listener, :initialize
  end
  
  # Event handler for the File Menu
  class FileMenuListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    typesig { [PolicyTool, ToolWindow] }
    def initialize(tool, tw)
      @tool = nil
      @tw = nil
      @tool = tool
      @tw = tw
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_quit)).equal?(0))
        # ask user if they want to save changes
        td = ToolDialog.new(PolicyTool.attr_rb.get_string("Save Changes"), @tool, @tw, true)
        td.display_user_save(td.attr_quit)
        # the above method will perform the QUIT as long as the
        # user does not CANCEL the request
      else
        if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_new_policy_file)).equal?(0))
          # ask user if they want to save changes
          td = ToolDialog.new(PolicyTool.attr_rb.get_string("Save Changes"), @tool, @tw, true)
          td.display_user_save(td.attr_new)
          # the above method will perform the NEW as long as the
          # user does not CANCEL the request
        else
          if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_open_policy_file)).equal?(0))
            # ask user if they want to save changes
            td = ToolDialog.new(PolicyTool.attr_rb.get_string("Save Changes"), @tool, @tw, true)
            td.display_user_save(td.attr_open)
            # the above method will perform the OPEN as long as the
            # user does not CANCEL the request
          else
            if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_save_policy_file)).equal?(0))
              # get the previously entered filename
              filename = (@tw.get_component(@tw.attr_mw_filename_textfield)).get_text
              # if there is no filename, do a SAVE_AS
              if ((filename).nil? || (filename.length).equal?(0))
                # user wants to SAVE AS
                td = ToolDialog.new(PolicyTool.attr_rb.get_string("Save As"), @tool, @tw, true)
                td.display_save_as_dialog(td.attr_noaction)
              else
                begin
                  # save the policy entries to a file
                  @tool.save_policy(filename)
                  # display status
                  form = MessageFormat.new(PolicyTool.attr_rb.get_string("Policy successfully written to filename"))
                  source = Array.typed(Object).new([filename])
                  @tw.display_status_dialog(nil, form.format(source))
                rescue FileNotFoundException => fnfe
                  if ((filename).nil? || (filename == ""))
                    @tw.display_error_dialog(nil, FileNotFoundException.new(PolicyTool.attr_rb.get_string("null filename")))
                  else
                    @tw.display_error_dialog(nil, fnfe)
                  end
                rescue JavaException => ee
                  @tw.display_error_dialog(nil, ee)
                end
              end
            else
              if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_save_as_policy_file)).equal?(0))
                # user wants to SAVE AS
                td = ToolDialog.new(PolicyTool.attr_rb.get_string("Save As"), @tool, @tw, true)
                td.display_save_as_dialog(td.attr_noaction)
              else
                if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_view_warnings)).equal?(0))
                  @tw.display_warning_log(nil)
                end
              end
            end
          end
        end
      end
    end
    
    private
    alias_method :initialize__file_menu_listener, :initialize
  end
  
  # Event handler for the main window buttons and Edit Menu
  class MainWindowListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    typesig { [PolicyTool, ToolWindow] }
    def initialize(tool, tw)
      @tool = nil
      @tw = nil
      @tool = tool
      @tw = tw
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_add_policy_entry)).equal?(0))
        # display a dialog box for the user to enter policy info
        td = ToolDialog.new(PolicyTool.attr_rb.get_string("Policy Entry"), @tool, @tw, true)
        td.display_policy_entry_dialog(false)
      else
        if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_remove_policy_entry)).equal?(0))
          # get the selected entry
          list = @tw.get_component(@tw.attr_mw_policy_list)
          index = list.get_selected_index
          if (index < 0)
            @tw.display_error_dialog(nil, JavaException.new(PolicyTool.attr_rb.get_string("No Policy Entry selected")))
            return
          end
          # ask the user if they really want to remove the policy entry
          td = ToolDialog.new(PolicyTool.attr_rb.get_string("Remove Policy Entry"), @tool, @tw, true)
          td.display_confirm_remove_policy_entry
        else
          if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_edit_policy_entry)).equal?(0))
            # get the selected entry
            list = @tw.get_component(@tw.attr_mw_policy_list)
            index = list.get_selected_index
            if (index < 0)
              @tw.display_error_dialog(nil, JavaException.new(PolicyTool.attr_rb.get_string("No Policy Entry selected")))
              return
            end
            # display the permission list for a policy entry
            td = ToolDialog.new(PolicyTool.attr_rb.get_string("Policy Entry"), @tool, @tw, true)
            td.display_policy_entry_dialog(true)
          else
            if ((PolicyTool.attr_collator.compare(e.get_action_command, @tw.attr_edit_keystore)).equal?(0))
              # display a dialog box for the user to enter keystore info
              td = ToolDialog.new(PolicyTool.attr_rb.get_string("KeyStore"), @tool, @tw, true)
              td.key_store_dialog(td.attr_edit_keystore)
            end
          end
        end
      end
    end
    
    private
    alias_method :initialize__main_window_listener, :initialize
  end
  
  # Event handler for OverWriteFileOKButton button
  class OverWriteFileOKButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    attr_accessor :filename
    alias_method :attr_filename, :filename
    undef_method :filename
    alias_method :attr_filename=, :filename=
    undef_method :filename=
    
    attr_accessor :next_event
    alias_method :attr_next_event, :next_event
    undef_method :next_event
    alias_method :attr_next_event=, :next_event=
    undef_method :next_event=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, String, ::Java::Int] }
    def initialize(tool, tw, td, filename, next_event)
      @tool = nil
      @tw = nil
      @td = nil
      @filename = nil
      @next_event = 0
      @tool = tool
      @tw = tw
      @td = td
      @filename = filename
      @next_event = next_event
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      begin
        # save the policy entries to a file
        @tool.save_policy(@filename)
        # display status
        form = MessageFormat.new(PolicyTool.attr_rb.get_string("Policy successfully written to filename"))
        source = Array.typed(Object).new([@filename])
        @tw.display_status_dialog(nil, form.format(source))
        # display the new policy filename
        new_filename = @tw.get_component(@tw.attr_mw_filename_textfield)
        new_filename.set_text(@filename)
        @tw.set_visible(true)
        # now continue with the originally requested command
        # (QUIT, NEW, or OPEN)
        @td.set_visible(false)
        @td.dispose
        @td.user_save_continue(@tool, @tw, @td, @next_event)
      rescue FileNotFoundException => fnfe
        if ((@filename).nil? || (@filename == ""))
          @tw.display_error_dialog(nil, FileNotFoundException.new(PolicyTool.attr_rb.get_string("null filename")))
        else
          @tw.display_error_dialog(nil, fnfe)
        end
        @td.set_visible(false)
        @td.dispose
      rescue JavaException => ee
        @tw.display_error_dialog(nil, ee)
        @td.set_visible(false)
        @td.dispose
      end
    end
    
    private
    alias_method :initialize__over_write_file_okbutton_listener, :initialize
  end
  
  # Event handler for AddEntryDoneButton button
  # 
  # -- if edit is TRUE, then we are EDITing an existing PolicyEntry
  # and we need to update both the policy and the GUI listing.
  # if edit is FALSE, then we are ADDing a new PolicyEntry,
  # so we only need to update the GUI listing.
  class AddEntryDoneButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    attr_accessor :edit
    alias_method :attr_edit, :edit
    undef_method :edit
    alias_method :attr_edit=, :edit=
    undef_method :edit=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, td, edit)
      @tool = nil
      @tw = nil
      @td = nil
      @edit = false
      @tool = tool
      @tw = tw
      @td = td
      @edit = edit
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      begin
        # get a PolicyEntry object from the dialog policy info
        new_entry = @td.get_policy_entry_from_dialog
        new_ge = new_entry.get_grant_entry
        # see if all the signers have public keys
        if (!(new_ge.attr_signed_by).nil?)
          signers = @tool.parse_signers(new_ge.attr_signed_by)
          i = 0
          while i < signers.attr_length
            pub_key = @tool.get_public_key_alias(signers[i])
            if ((pub_key).nil?)
              form = MessageFormat.new(PolicyTool.attr_rb.get_string("Warning: A public key for alias " + "'signers[i]' does not exist.  " + "Make sure a KeyStore is properly configured."))
              source = Array.typed(Object).new([signers[i]])
              @tool.attr_warnings.add_element(form.format(source))
              @tw.display_status_dialog(@td, form.format(source))
            end
            i += 1
          end
        end
        # add the entry
        policy_list = @tw.get_component(@tw.attr_mw_policy_list)
        if (@edit)
          list_index = policy_list.get_selected_index
          @tool.add_entry(new_entry, list_index)
          new_code_base_str = new_entry.header_to_string
          if (!(PolicyTool.attr_collator.compare(new_code_base_str, policy_list.get_item(list_index))).equal?(0))
            @tool.attr_modified = true
          end
          policy_list.replace_item(new_code_base_str, list_index)
        else
          @tool.add_entry(new_entry, -1)
          policy_list.add(new_entry.header_to_string)
          @tool.attr_modified = true
        end
        @td.set_visible(false)
        @td.dispose
      rescue JavaException => eee
        @tw.display_error_dialog(@td, eee)
      end
    end
    
    private
    alias_method :initialize__add_entry_done_button_listener, :initialize
  end
  
  # Event handler for ChangeKeyStoreOKButton button
  class ChangeKeyStoreOKButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog] }
    def initialize(tool, tw, td)
      @tool = nil
      @tw = nil
      @td = nil
      @tool = tool
      @tw = tw
      @td = td
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      urlstring = (@td.get_component(@td.attr_ksd_name_textfield)).get_text.trim
      type = (@td.get_component(@td.attr_ksd_type_textfield)).get_text.trim
      provider = (@td.get_component(@td.attr_ksd_provider_textfield)).get_text.trim
      pwd_url = (@td.get_component(@td.attr_ksd_pwd_url_textfield)).get_text.trim
      begin
        @tool.open_key_store(((urlstring.length).equal?(0) ? nil : urlstring), ((type.length).equal?(0) ? nil : type), ((provider.length).equal?(0) ? nil : provider), ((pwd_url.length).equal?(0) ? nil : pwd_url))
        @tool.attr_modified = true
      rescue JavaException => ex
        form = MessageFormat.new(PolicyTool.attr_rb.get_string("Unable to open KeyStore: ex.toString()"))
        source = Array.typed(Object).new([ex.to_s])
        @tw.display_error_dialog(@td, form.format(source))
        return
      end
      @td.dispose
    end
    
    private
    alias_method :initialize__change_key_store_okbutton_listener, :initialize
  end
  
  # Event handler for AddPrinButton button
  class AddPrinButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    attr_accessor :edit_policy_entry
    alias_method :attr_edit_policy_entry, :edit_policy_entry
    undef_method :edit_policy_entry
    alias_method :attr_edit_policy_entry=, :edit_policy_entry=
    undef_method :edit_policy_entry=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, td, edit_policy_entry)
      @tool = nil
      @tw = nil
      @td = nil
      @edit_policy_entry = false
      @tool = tool
      @tw = tw
      @td = td
      @edit_policy_entry = edit_policy_entry
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # display a dialog box for the user to enter principal info
      @td.display_principal_dialog(@edit_policy_entry, false)
    end
    
    private
    alias_method :initialize__add_prin_button_listener, :initialize
  end
  
  # Event handler for AddPermButton button
  class AddPermButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    attr_accessor :edit_policy_entry
    alias_method :attr_edit_policy_entry, :edit_policy_entry
    undef_method :edit_policy_entry
    alias_method :attr_edit_policy_entry=, :edit_policy_entry=
    undef_method :edit_policy_entry=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, td, edit_policy_entry)
      @tool = nil
      @tw = nil
      @td = nil
      @edit_policy_entry = false
      @tool = tool
      @tw = tw
      @td = td
      @edit_policy_entry = edit_policy_entry
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # display a dialog box for the user to enter permission info
      @td.display_permission_dialog(@edit_policy_entry, false)
    end
    
    private
    alias_method :initialize__add_perm_button_listener, :initialize
  end
  
  # Event handler for AddPrinOKButton button
  class NewPolicyPrinOKButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :list_dialog
    alias_method :attr_list_dialog, :list_dialog
    undef_method :list_dialog
    alias_method :attr_list_dialog=, :list_dialog=
    undef_method :list_dialog=
    
    attr_accessor :info_dialog
    alias_method :attr_info_dialog, :info_dialog
    undef_method :info_dialog
    alias_method :attr_info_dialog=, :info_dialog=
    undef_method :info_dialog=
    
    attr_accessor :edit
    alias_method :attr_edit, :edit
    undef_method :edit
    alias_method :attr_edit=, :edit=
    undef_method :edit=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, list_dialog, info_dialog, edit)
      @tool = nil
      @tw = nil
      @list_dialog = nil
      @info_dialog = nil
      @edit = false
      @tool = tool
      @tw = tw
      @list_dialog = list_dialog
      @info_dialog = info_dialog
      @edit = edit
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      begin
        # read in the new principal info from Dialog Box
        pppe = @info_dialog.get_prin_from_dialog
        if (!(pppe).nil?)
          begin
            @tool.verify_principal(pppe.get_principal_class, pppe.get_principal_name)
          rescue ClassNotFoundException => cnfe
            form = MessageFormat.new(PolicyTool.attr_rb.get_string("Warning: Class not found: class"))
            source = Array.typed(Object).new([pppe.get_principal_class])
            @tool.attr_warnings.add_element(form.format(source))
            @tw.display_status_dialog(@info_dialog, form.format(source))
          end
          # add the principal to the GUI principal list
          prin_list = @list_dialog.get_component(@list_dialog.attr_pe_prin_list)
          prin_string = ToolDialog._principal_entry_to_user_friendly_string(pppe)
          if (@edit)
            # if editing, replace the original principal
            index = prin_list.get_selected_index
            prin_list.replace_tagged_item(prin_string, pppe, index)
          else
            # if adding, just add it to the end
            prin_list.add_tagged_item(prin_string, pppe)
          end
        end
        @info_dialog.dispose
      rescue JavaException => ee
        @tw.display_error_dialog(@info_dialog, ee)
      end
    end
    
    private
    alias_method :initialize__new_policy_prin_okbutton_listener, :initialize
  end
  
  # Event handler for AddPermOKButton button
  class NewPolicyPermOKButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :list_dialog
    alias_method :attr_list_dialog, :list_dialog
    undef_method :list_dialog
    alias_method :attr_list_dialog=, :list_dialog=
    undef_method :list_dialog=
    
    attr_accessor :info_dialog
    alias_method :attr_info_dialog, :info_dialog
    undef_method :info_dialog
    alias_method :attr_info_dialog=, :info_dialog=
    undef_method :info_dialog=
    
    attr_accessor :edit
    alias_method :attr_edit, :edit
    undef_method :edit
    alias_method :attr_edit=, :edit=
    undef_method :edit=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, list_dialog, info_dialog, edit)
      @tool = nil
      @tw = nil
      @list_dialog = nil
      @info_dialog = nil
      @edit = false
      @tool = tool
      @tw = tw
      @list_dialog = list_dialog
      @info_dialog = info_dialog
      @edit = edit
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      begin
        # read in the new permission info from Dialog Box
        pppe = @info_dialog.get_perm_from_dialog
        begin
          @tool.verify_permission(pppe.attr_permission, pppe.attr_name, pppe.attr_action)
        rescue ClassNotFoundException => cnfe
          form = MessageFormat.new(PolicyTool.attr_rb.get_string("Warning: Class not found: class"))
          source = Array.typed(Object).new([pppe.attr_permission])
          @tool.attr_warnings.add_element(form.format(source))
          @tw.display_status_dialog(@info_dialog, form.format(source))
        end
        # add the permission to the GUI permission list
        perm_list = @list_dialog.get_component(@list_dialog.attr_pe_perm_list)
        perm_string = ToolDialog._permission_entry_to_user_friendly_string(pppe)
        if (@edit)
          # if editing, replace the original permission
          which = perm_list.get_selected_index
          perm_list.replace_tagged_item(perm_string, pppe, which)
        else
          # if adding, just add it to the end
          perm_list.add_tagged_item(perm_string, pppe)
        end
        @info_dialog.dispose
      rescue InvocationTargetException => ite
        @tw.display_error_dialog(@info_dialog, ite.get_target_exception)
      rescue JavaException => ee
        @tw.display_error_dialog(@info_dialog, ee)
      end
    end
    
    private
    alias_method :initialize__new_policy_perm_okbutton_listener, :initialize
  end
  
  # Event handler for RemovePrinButton button
  class RemovePrinButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    attr_accessor :edit
    alias_method :attr_edit, :edit
    undef_method :edit
    alias_method :attr_edit=, :edit=
    undef_method :edit=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, td, edit)
      @tool = nil
      @tw = nil
      @td = nil
      @edit = false
      @tool = tool
      @tw = tw
      @td = td
      @edit = edit
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # get the Principal selected from the Principal List
      prin_list = @td.get_component(@td.attr_pe_prin_list)
      prin_index = prin_list.get_selected_index
      if (prin_index < 0)
        @tw.display_error_dialog(@td, JavaException.new(PolicyTool.attr_rb.get_string("No principal selected")))
        return
      end
      # remove the principal from the display
      prin_list.remove_tagged_item(prin_index)
    end
    
    private
    alias_method :initialize__remove_prin_button_listener, :initialize
  end
  
  # Event handler for RemovePermButton button
  class RemovePermButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    attr_accessor :edit
    alias_method :attr_edit, :edit
    undef_method :edit
    alias_method :attr_edit=, :edit=
    undef_method :edit=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, td, edit)
      @tool = nil
      @tw = nil
      @td = nil
      @edit = false
      @tool = tool
      @tw = tw
      @td = td
      @edit = edit
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # get the Permission selected from the Permission List
      perm_list = @td.get_component(@td.attr_pe_perm_list)
      perm_index = perm_list.get_selected_index
      if (perm_index < 0)
        @tw.display_error_dialog(@td, JavaException.new(PolicyTool.attr_rb.get_string("No permission selected")))
        return
      end
      # remove the permission from the display
      perm_list.remove_tagged_item(perm_index)
    end
    
    private
    alias_method :initialize__remove_perm_button_listener, :initialize
  end
  
  # Event handler for Edit Principal button
  # 
  # We need the editPolicyEntry boolean to tell us if the user is
  # adding a new PolicyEntry at this time, or editing an existing entry.
  # If the user is adding a new PolicyEntry, we ONLY update the
  # GUI listing.  If the user is editing an existing PolicyEntry, we
  # update both the GUI listing and the actual PolicyEntry.
  class EditPrinButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    attr_accessor :edit_policy_entry
    alias_method :attr_edit_policy_entry, :edit_policy_entry
    undef_method :edit_policy_entry
    alias_method :attr_edit_policy_entry=, :edit_policy_entry=
    undef_method :edit_policy_entry=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, td, edit_policy_entry)
      @tool = nil
      @tw = nil
      @td = nil
      @edit_policy_entry = false
      @tool = tool
      @tw = tw
      @td = td
      @edit_policy_entry = edit_policy_entry
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # get the Principal selected from the Principal List
      list = @td.get_component(@td.attr_pe_prin_list)
      prin_index = list.get_selected_index
      if (prin_index < 0)
        @tw.display_error_dialog(@td, JavaException.new(PolicyTool.attr_rb.get_string("No principal selected")))
        return
      end
      @td.display_principal_dialog(@edit_policy_entry, true)
    end
    
    private
    alias_method :initialize__edit_prin_button_listener, :initialize
  end
  
  # Event handler for Edit Permission button
  # 
  # We need the editPolicyEntry boolean to tell us if the user is
  # adding a new PolicyEntry at this time, or editing an existing entry.
  # If the user is adding a new PolicyEntry, we ONLY update the
  # GUI listing.  If the user is editing an existing PolicyEntry, we
  # update both the GUI listing and the actual PolicyEntry.
  class EditPermButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    attr_accessor :edit_policy_entry
    alias_method :attr_edit_policy_entry, :edit_policy_entry
    undef_method :edit_policy_entry
    alias_method :attr_edit_policy_entry=, :edit_policy_entry=
    undef_method :edit_policy_entry=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog, ::Java::Boolean] }
    def initialize(tool, tw, td, edit_policy_entry)
      @tool = nil
      @tw = nil
      @td = nil
      @edit_policy_entry = false
      @tool = tool
      @tw = tw
      @td = td
      @edit_policy_entry = edit_policy_entry
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # get the Permission selected from the Permission List
      list = @td.get_component(@td.attr_pe_perm_list)
      perm_index = list.get_selected_index
      if (perm_index < 0)
        @tw.display_error_dialog(@td, JavaException.new(PolicyTool.attr_rb.get_string("No permission selected")))
        return
      end
      @td.display_permission_dialog(@edit_policy_entry, true)
    end
    
    private
    alias_method :initialize__edit_perm_button_listener, :initialize
  end
  
  # Event handler for Principal Popup Menu
  class PrincipalTypeMenuListener 
    include_class_members PolicyToolImports
    include ItemListener
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    typesig { [ToolDialog] }
    def initialize(td)
      @td = nil
      @td = td
    end
    
    typesig { [ItemEvent] }
    def item_state_changed(e)
      prin = @td.get_component(@td.attr_prd_prin_choice)
      prin_field = @td.get_component(@td.attr_prd_prin_textfield)
      name_field = @td.get_component(@td.attr_prd_name_textfield)
      prin.get_accessible_context.set_accessible_name(PolicyTool.split_to_words(e.get_item))
      if (((e.get_item) == @td.attr_prin_type))
        # ignore if they choose "Principal Type:" item
        if (!(prin_field.get_text).nil? && prin_field.get_text.length > 0)
          input_prin = @td.get_prin(prin_field.get_text, true)
          prin.select(input_prin.attr_class)
        end
        return
      end
      # if you change the principal, clear the name
      if ((prin_field.get_text.index_of(e.get_item)).equal?(-1))
        name_field.set_text("")
      end
      # set the text in the textfield and also modify the
      # pull-down choice menus to reflect the correct possible
      # set of names and actions
      input_prin = @td.get_prin(e.get_item, false)
      if (!(input_prin).nil?)
        prin_field.set_text(input_prin.attr_full_class)
      end
    end
    
    private
    alias_method :initialize__principal_type_menu_listener, :initialize
  end
  
  # Event handler for Permission Popup Menu
  class PermissionMenuListener 
    include_class_members PolicyToolImports
    include ItemListener
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    typesig { [ToolDialog] }
    def initialize(td)
      @td = nil
      @td = td
    end
    
    typesig { [ItemEvent] }
    def item_state_changed(e)
      perms = @td.get_component(@td.attr_pd_perm_choice)
      names = @td.get_component(@td.attr_pd_name_choice)
      actions = @td.get_component(@td.attr_pd_actions_choice)
      name_field = @td.get_component(@td.attr_pd_name_textfield)
      actions_field = @td.get_component(@td.attr_pd_actions_textfield)
      perm_field = @td.get_component(@td.attr_pd_perm_textfield)
      signedby_field = @td.get_component(@td.attr_pd_signedby_textfield)
      perms.get_accessible_context.set_accessible_name(PolicyTool.split_to_words(e.get_item))
      # ignore if they choose the 'Permission:' item
      if ((PolicyTool.attr_collator.compare(e.get_item, @td.attr_perm)).equal?(0))
        if (!(perm_field.get_text).nil? && perm_field.get_text.length > 0)
          input_perm = @td.get_perm(perm_field.get_text, true)
          if (!(input_perm).nil?)
            perms.select(input_perm.attr_class)
          end
        end
        return
      end
      # if you change the permission, clear the name, actions, and signedBy
      if ((perm_field.get_text.index_of(e.get_item)).equal?(-1))
        name_field.set_text("")
        actions_field.set_text("")
        signedby_field.set_text("")
      end
      # set the text in the textfield and also modify the
      # pull-down choice menus to reflect the correct possible
      # set of names and actions
      input_perm = @td.get_perm(e.get_item, false)
      if ((input_perm).nil?)
        perm_field.set_text("")
      else
        perm_field.set_text(input_perm.attr_full_class)
      end
      @td.set_permission_names(input_perm, names, name_field)
      @td.set_permission_actions(input_perm, actions, actions_field)
    end
    
    private
    alias_method :initialize__permission_menu_listener, :initialize
  end
  
  # Event handler for Permission Name Popup Menu
  class PermissionNameMenuListener 
    include_class_members PolicyToolImports
    include ItemListener
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    typesig { [ToolDialog] }
    def initialize(td)
      @td = nil
      @td = td
    end
    
    typesig { [ItemEvent] }
    def item_state_changed(e)
      names = @td.get_component(@td.attr_pd_name_choice)
      names.get_accessible_context.set_accessible_name(PolicyTool.split_to_words(e.get_item))
      if (!((e.get_item).index_of(@td.attr_perm_name)).equal?(-1))
        return
      end
      tf = @td.get_component(@td.attr_pd_name_textfield)
      tf.set_text(e.get_item)
    end
    
    private
    alias_method :initialize__permission_name_menu_listener, :initialize
  end
  
  # Event handler for Permission Actions Popup Menu
  class PermissionActionsMenuListener 
    include_class_members PolicyToolImports
    include ItemListener
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    typesig { [ToolDialog] }
    def initialize(td)
      @td = nil
      @td = td
    end
    
    typesig { [ItemEvent] }
    def item_state_changed(e)
      actions = @td.get_component(@td.attr_pd_actions_choice)
      actions.get_accessible_context.set_accessible_name(e.get_item)
      if (!((e.get_item).index_of(@td.attr_perm_actions)).equal?(-1))
        return
      end
      tf = @td.get_component(@td.attr_pd_actions_textfield)
      if ((tf.get_text).nil? || (tf.get_text == ""))
        tf.set_text(e.get_item)
      else
        if ((tf.get_text.index_of(e.get_item)).equal?(-1))
          tf.set_text(RJava.cast_to_string(tf.get_text) + ", " + RJava.cast_to_string(e.get_item))
        end
      end
    end
    
    private
    alias_method :initialize__permission_actions_menu_listener, :initialize
  end
  
  # Event handler for all the children dialogs/windows
  class ChildWindowListener 
    include_class_members PolicyToolImports
    include WindowListener
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    typesig { [ToolDialog] }
    def initialize(td)
      @td = nil
      @td = td
    end
    
    typesig { [WindowEvent] }
    def window_opened(we)
    end
    
    typesig { [WindowEvent] }
    def window_closing(we)
      # same as pressing the "cancel" button
      @td.set_visible(false)
      @td.dispose
    end
    
    typesig { [WindowEvent] }
    def window_closed(we)
    end
    
    typesig { [WindowEvent] }
    def window_iconified(we)
    end
    
    typesig { [WindowEvent] }
    def window_deiconified(we)
    end
    
    typesig { [WindowEvent] }
    def window_activated(we)
    end
    
    typesig { [WindowEvent] }
    def window_deactivated(we)
    end
    
    private
    alias_method :initialize__child_window_listener, :initialize
  end
  
  # Event handler for CancelButton button
  class CancelButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :td
    alias_method :attr_td, :td
    undef_method :td
    alias_method :attr_td=, :td=
    undef_method :td=
    
    typesig { [ToolDialog] }
    def initialize(td)
      @td = nil
      @td = td
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      @td.set_visible(false)
      @td.dispose
    end
    
    private
    alias_method :initialize__cancel_button_listener, :initialize
  end
  
  # Event handler for ErrorOKButton button
  class ErrorOKButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :ed
    alias_method :attr_ed, :ed
    undef_method :ed
    alias_method :attr_ed=, :ed=
    undef_method :ed=
    
    typesig { [ToolDialog] }
    def initialize(ed)
      @ed = nil
      @ed = ed
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      @ed.set_visible(false)
      @ed.dispose
    end
    
    private
    alias_method :initialize__error_okbutton_listener, :initialize
  end
  
  # Event handler for StatusOKButton button
  class StatusOKButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :sd
    alias_method :attr_sd, :sd
    undef_method :sd
    alias_method :attr_sd=, :sd=
    undef_method :sd=
    
    typesig { [ToolDialog] }
    def initialize(sd)
      @sd = nil
      @sd = sd
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      @sd.set_visible(false)
      @sd.dispose
    end
    
    private
    alias_method :initialize__status_okbutton_listener, :initialize
  end
  
  # Event handler for UserSaveYes button
  class UserSaveYesButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :us
    alias_method :attr_us, :us
    undef_method :us
    alias_method :attr_us=, :us=
    undef_method :us=
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :select
    alias_method :attr_select, :select
    undef_method :select
    alias_method :attr_select=, :select=
    undef_method :select=
    
    typesig { [ToolDialog, PolicyTool, ToolWindow, ::Java::Int] }
    def initialize(us, tool, tw, select)
      @us = nil
      @tool = nil
      @tw = nil
      @select = 0
      @us = us
      @tool = tool
      @tw = tw
      @select = select
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # first get rid of the window
      @us.set_visible(false)
      @us.dispose
      begin
        filename = (@tw.get_component(@tw.attr_mw_filename_textfield)).get_text
        if ((filename).nil? || (filename == ""))
          @us.display_save_as_dialog(@select)
          # the above dialog will continue with the originally
          # requested command if necessary
        else
          # save the policy entries to a file
          @tool.save_policy(filename)
          # display status
          form = MessageFormat.new(PolicyTool.attr_rb.get_string("Policy successfully written to filename"))
          source = Array.typed(Object).new([filename])
          @tw.display_status_dialog(nil, form.format(source))
          # now continue with the originally requested command
          # (QUIT, NEW, or OPEN)
          @us.user_save_continue(@tool, @tw, @us, @select)
        end
      rescue JavaException => ee
        # error -- just report it and bail
        @tw.display_error_dialog(nil, ee)
      end
    end
    
    private
    alias_method :initialize__user_save_yes_button_listener, :initialize
  end
  
  # Event handler for UserSaveNoButton
  class UserSaveNoButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :us
    alias_method :attr_us, :us
    undef_method :us
    alias_method :attr_us=, :us=
    undef_method :us=
    
    attr_accessor :select
    alias_method :attr_select, :select
    undef_method :select
    alias_method :attr_select=, :select=
    undef_method :select=
    
    typesig { [ToolDialog, PolicyTool, ToolWindow, ::Java::Int] }
    def initialize(us, tool, tw, select)
      @tool = nil
      @tw = nil
      @us = nil
      @select = 0
      @us = us
      @tool = tool
      @tw = tw
      @select = select
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      @us.set_visible(false)
      @us.dispose
      # now continue with the originally requested command
      # (QUIT, NEW, or OPEN)
      @us.user_save_continue(@tool, @tw, @us, @select)
    end
    
    private
    alias_method :initialize__user_save_no_button_listener, :initialize
  end
  
  # Event handler for UserSaveCancelButton
  class UserSaveCancelButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :us
    alias_method :attr_us, :us
    undef_method :us
    alias_method :attr_us=, :us=
    undef_method :us=
    
    typesig { [ToolDialog] }
    def initialize(us)
      @us = nil
      @us = us
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      @us.set_visible(false)
      @us.dispose
      # do NOT continue with the originally requested command
      # (QUIT, NEW, or OPEN)
    end
    
    private
    alias_method :initialize__user_save_cancel_button_listener, :initialize
  end
  
  # Event handler for ConfirmRemovePolicyEntryOKButtonListener
  class ConfirmRemovePolicyEntryOKButtonListener 
    include_class_members PolicyToolImports
    include ActionListener
    
    attr_accessor :tool
    alias_method :attr_tool, :tool
    undef_method :tool
    alias_method :attr_tool=, :tool=
    undef_method :tool=
    
    attr_accessor :tw
    alias_method :attr_tw, :tw
    undef_method :tw
    alias_method :attr_tw=, :tw=
    undef_method :tw=
    
    attr_accessor :us
    alias_method :attr_us, :us
    undef_method :us
    alias_method :attr_us=, :us=
    undef_method :us=
    
    typesig { [PolicyTool, ToolWindow, ToolDialog] }
    def initialize(tool, tw, us)
      @tool = nil
      @tw = nil
      @us = nil
      @tool = tool
      @tw = tw
      @us = us
    end
    
    typesig { [ActionEvent] }
    def action_performed(e)
      # remove the entry
      list = @tw.get_component(@tw.attr_mw_policy_list)
      index = list.get_selected_index
      entries = @tool.get_entry
      @tool.remove_entry(entries[index])
      # redraw the window listing
      list = JavaList.new(40, false)
      list.add_action_listener(PolicyListListener.new(@tool, @tw))
      entries = @tool.get_entry
      if (!(entries).nil?)
        i = 0
        while i < entries.attr_length
          list.add(entries[i].header_to_string)
          i += 1
        end
      end
      @tw.replace_policy_list(list)
      @us.set_visible(false)
      @us.dispose
    end
    
    private
    alias_method :initialize__confirm_remove_policy_entry_okbutton_listener, :initialize
  end
  
  # Just a special name, so that the codes dealing with this exception knows
  # it's special, and does not pop out a warning box.
  class NoDisplayException < PolicyToolImports.const_get :RuntimeException
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__no_display_exception, :initialize
  end
  
  # This is a java.awt.List that bind an Object to each String it holds.
  class TaggedList < PolicyToolImports.const_get :JavaList
    include_class_members PolicyToolImports
    
    attr_accessor :data
    alias_method :attr_data, :data
    undef_method :data
    alias_method :attr_data=, :data=
    undef_method :data=
    
    typesig { [::Java::Int, ::Java::Boolean] }
    def initialize(i, b)
      @data = nil
      super(i, b)
      @data = LinkedList.new
    end
    
    typesig { [::Java::Int] }
    def get_object(index)
      return @data.get(index)
    end
    
    typesig { [String] }
    def add(string)
      raise AssertionError.new("should not call add in TaggedList")
    end
    
    typesig { [String, Object] }
    def add_tagged_item(string, object)
      JavaList.instance_method(:add).bind(self).call(string)
      @data.add(object)
    end
    
    typesig { [String, ::Java::Int] }
    def replace_item(string, index)
      raise AssertionError.new("should not call replaceItem in TaggedList")
    end
    
    typesig { [String, Object, ::Java::Int] }
    def replace_tagged_item(string, object, index)
      JavaList.instance_method(:replace_item).bind(self).call(string, index)
      @data.set(index, object)
    end
    
    typesig { [::Java::Int] }
    def remove(index)
      # Cannot throw AssertionError, because replaceItem() call remove() internally
      super(index)
    end
    
    typesig { [::Java::Int] }
    def remove_tagged_item(index)
      JavaList.instance_method(:remove).bind(self).call(index)
      @data.remove(index)
    end
    
    private
    alias_method :initialize__tagged_list, :initialize
  end
  
  # Convenience Principal Classes
  class Prin 
    include_class_members PolicyToolImports
    
    attr_accessor :class
    alias_method :attr_class, :class
    undef_method :class
    alias_method :attr_class=, :class=
    undef_method :class=
    
    attr_accessor :full_class
    alias_method :attr_full_class, :full_class
    undef_method :full_class
    alias_method :attr_full_class=, :full_class=
    undef_method :full_class=
    
    typesig { [String, String] }
    def initialize(clazz, full_class)
      @class = nil
      @full_class = nil
      @class = clazz
      @full_class = full_class
    end
    
    private
    alias_method :initialize__prin, :initialize
  end
  
  class KrbPrin < PolicyToolImports.const_get :Prin
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("KerberosPrincipal", "javax.security.auth.kerberos.KerberosPrincipal")
    end
    
    private
    alias_method :initialize__krb_prin, :initialize
  end
  
  class X500Prin < PolicyToolImports.const_get :Prin
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("X500Principal", "javax.security.auth.x500.X500Principal")
    end
    
    private
    alias_method :initialize__x500prin, :initialize
  end
  
  # Convenience Permission Classes
  class Perm 
    include_class_members PolicyToolImports
    
    attr_accessor :class
    alias_method :attr_class, :class
    undef_method :class
    alias_method :attr_class=, :class=
    undef_method :class=
    
    attr_accessor :full_class
    alias_method :attr_full_class, :full_class
    undef_method :full_class
    alias_method :attr_full_class=, :full_class=
    undef_method :full_class=
    
    attr_accessor :targets
    alias_method :attr_targets, :targets
    undef_method :targets
    alias_method :attr_targets=, :targets=
    undef_method :targets=
    
    attr_accessor :actions
    alias_method :attr_actions, :actions
    undef_method :actions
    alias_method :attr_actions=, :actions=
    undef_method :actions=
    
    typesig { [String, String, Array.typed(String), Array.typed(String)] }
    def initialize(clazz, full_class, targets, actions)
      @class = nil
      @full_class = nil
      @targets = nil
      @actions = nil
      @class = clazz
      @full_class = full_class
      @targets = targets
      @actions = actions
    end
    
    private
    alias_method :initialize__perm, :initialize
  end
  
  class AllPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("AllPermission", "java.security.AllPermission", nil, nil)
    end
    
    private
    alias_method :initialize__all_perm, :initialize
  end
  
  class AudioPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("AudioPermission", "javax.sound.sampled.AudioPermission", Array.typed(String).new(["play", "record"]), nil)
    end
    
    private
    alias_method :initialize__audio_perm, :initialize
  end
  
  class AuthPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("AuthPermission", "javax.security.auth.AuthPermission", Array.typed(String).new(["doAs", "doAsPrivileged", "getSubject", "getSubjectFromDomainCombiner", "setReadOnly", "modifyPrincipals", "modifyPublicCredentials", "modifyPrivateCredentials", "refreshCredential", "destroyCredential", "createLoginContext.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("name")) + ">", "getLoginConfiguration", "setLoginConfiguration", "createLoginConfiguration.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("configuration type")) + ">", "refreshLoginConfiguration"]), nil)
    end
    
    private
    alias_method :initialize__auth_perm, :initialize
  end
  
  class AWTPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("AWTPermission", "java.awt.AWTPermission", Array.typed(String).new(["accessClipboard", "accessEventQueue", "accessSystemTray", "createRobot", "fullScreenExclusive", "listenToAllAWTEvents", "readDisplayPixels", "replaceKeyboardFocusManager", "setAppletStub", "setWindowAlwaysOnTop", "showWindowWithoutWarningBanner", "toolkitModality", "watchMousePointer"]), nil)
    end
    
    private
    alias_method :initialize__awtperm, :initialize
  end
  
  class DelegationPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # allow user input
      super("DelegationPermission", "javax.security.auth.kerberos.DelegationPermission", Array.typed(String).new([]), nil)
    end
    
    private
    alias_method :initialize__delegation_perm, :initialize
  end
  
  class FilePerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("FilePermission", "java.io.FilePermission", Array.typed(String).new(["<<ALL FILES>>"]), Array.typed(String).new(["read", "write", "delete", "execute"]))
    end
    
    private
    alias_method :initialize__file_perm, :initialize
  end
  
  class LogPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("LoggingPermission", "java.util.logging.LoggingPermission", Array.typed(String).new(["control"]), nil)
    end
    
    private
    alias_method :initialize__log_perm, :initialize
  end
  
  class MgmtPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("ManagementPermission", "java.lang.management.ManagementPermission", Array.typed(String).new(["control", "monitor"]), nil)
    end
    
    private
    alias_method :initialize__mgmt_perm, :initialize
  end
  
  class MBeanPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # allow user input
      super("MBeanPermission", "javax.management.MBeanPermission", Array.typed(String).new([]), Array.typed(String).new(["addNotificationListener", "getAttribute", "getClassLoader", "getClassLoaderFor", "getClassLoaderRepository", "getDomains", "getMBeanInfo", "getObjectInstance", "instantiate", "invoke", "isInstanceOf", "queryMBeans", "queryNames", "registerMBean", "removeNotificationListener", "setAttribute", "unregisterMBean"]))
    end
    
    private
    alias_method :initialize__mbean_perm, :initialize
  end
  
  class MBeanSvrPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("MBeanServerPermission", "javax.management.MBeanServerPermission", Array.typed(String).new(["createMBeanServer", "findMBeanServer", "newMBeanServer", "releaseMBeanServer"]), nil)
    end
    
    private
    alias_method :initialize__mbean_svr_perm, :initialize
  end
  
  class MBeanTrustPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("MBeanTrustPermission", "javax.management.MBeanTrustPermission", Array.typed(String).new(["register"]), nil)
    end
    
    private
    alias_method :initialize__mbean_trust_perm, :initialize
  end
  
  class NetPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("NetPermission", "java.net.NetPermission", Array.typed(String).new(["setDefaultAuthenticator", "requestPasswordAuthentication", "specifyStreamHandler", "setProxySelector", "getProxySelector", "setCookieHandler", "getCookieHandler", "setResponseCache", "getResponseCache"]), nil)
    end
    
    private
    alias_method :initialize__net_perm, :initialize
  end
  
  class PrivCredPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # allow user input
      super("PrivateCredentialPermission", "javax.security.auth.PrivateCredentialPermission", Array.typed(String).new([]), Array.typed(String).new(["read"]))
    end
    
    private
    alias_method :initialize__priv_cred_perm, :initialize
  end
  
  class PropPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # allow user input
      super("PropertyPermission", "java.util.PropertyPermission", Array.typed(String).new([]), Array.typed(String).new(["read", "write"]))
    end
    
    private
    alias_method :initialize__prop_perm, :initialize
  end
  
  class ReflectPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("ReflectPermission", "java.lang.reflect.ReflectPermission", Array.typed(String).new(["suppressAccessChecks"]), nil)
    end
    
    private
    alias_method :initialize__reflect_perm, :initialize
  end
  
  class RuntimePerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # "inheritedChannel"
      super("RuntimePermission", "java.lang.RuntimePermission", Array.typed(String).new(["createClassLoader", "getClassLoader", "setContextClassLoader", "enableContextClassLoaderOverride", "setSecurityManage", "createSecurityManager", "getenv.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("environment variable name")) + ">", "exitVM", "shutdownHooks", "setFactory", "setIO", "modifyThread", "stopThread", "modifyThreadGroup", "getProtectionDomain", "readFileDescriptor", "writeFileDescriptor", "loadLibrary.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("library name")) + ">", "accessClassInPackage.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("package name")) + ">", "defineClassInPackage.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("package name")) + ">", "accessDeclaredMembers", "queuePrintJob", "getStackTrace", "setDefaultUncaughtExceptionHandler", "preferences", "usePolicy", ]), nil)
    end
    
    private
    alias_method :initialize__runtime_perm, :initialize
  end
  
  class SecurityPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # "setSystemScope",
      # "setIdentityPublicKey",
      # "setIdentityInfo",
      # "addIdentityCertificate",
      # "removeIdentityCertificate",
      # "printIdentity",
      # "getSignerPrivateKey",
      # "setSignerKeyPair"
      super("SecurityPermission", "java.security.SecurityPermission", Array.typed(String).new(["createAccessControlContext", "getDomainCombiner", "getPolicy", "setPolicy", "createPolicy.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("policy type")) + ">", "getProperty.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("property name")) + ">", "setProperty.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("property name")) + ">", "insertProvider.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("provider name")) + ">", "removeProvider.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("provider name")) + ">", "clearProviderProperties.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("provider name")) + ">", "putProviderProperty.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("provider name")) + ">", "removeProviderProperty.<" + RJava.cast_to_string(PolicyTool.attr_rb.get_string("provider name")) + ">", ]), nil)
    end
    
    private
    alias_method :initialize__security_perm, :initialize
  end
  
  class SerialPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("SerializablePermission", "java.io.SerializablePermission", Array.typed(String).new(["enableSubclassImplementation", "enableSubstitution"]), nil)
    end
    
    private
    alias_method :initialize__serial_perm, :initialize
  end
  
  class ServicePerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # allow user input
      super("ServicePermission", "javax.security.auth.kerberos.ServicePermission", Array.typed(String).new([]), Array.typed(String).new(["initiate", "accept"]))
    end
    
    private
    alias_method :initialize__service_perm, :initialize
  end
  
  class SocketPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # allow user input
      super("SocketPermission", "java.net.SocketPermission", Array.typed(String).new([]), Array.typed(String).new(["accept", "connect", "listen", "resolve"]))
    end
    
    private
    alias_method :initialize__socket_perm, :initialize
  end
  
  class SQLPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("SQLPermission", "java.sql.SQLPermission", Array.typed(String).new(["setLog"]), nil)
    end
    
    private
    alias_method :initialize__sqlperm, :initialize
  end
  
  class SSLPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      super("SSLPermission", "javax.net.ssl.SSLPermission", Array.typed(String).new(["setHostnameVerifier", "getSSLSessionContext"]), nil)
    end
    
    private
    alias_method :initialize__sslperm, :initialize
  end
  
  class SubjDelegPerm < PolicyToolImports.const_get :Perm
    include_class_members PolicyToolImports
    
    typesig { [] }
    def initialize
      # allow user input
      super("SubjectDelegationPermission", "javax.management.remote.SubjectDelegationPermission", Array.typed(String).new([]), nil)
    end
    
    private
    alias_method :initialize__subj_deleg_perm, :initialize
  end
  
  PolicyTool.main($*) if $0 == __FILE__
end
