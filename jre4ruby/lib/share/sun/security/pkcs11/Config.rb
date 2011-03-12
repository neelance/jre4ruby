require "rjava"

# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module ConfigImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include ::Java::Util
      include ::Java::Security
      include_const ::Sun::Security::Action, :GetPropertyAction
      include_const ::Sun::Security::Util, :PropertyExpander
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # Configuration container and file parsing.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class Config 
    include_class_members ConfigImports
    
    class_module.module_eval {
      const_set_lazy(:ERR_HALT) { 1 }
      const_attr_reader  :ERR_HALT
      
      const_set_lazy(:ERR_IGNORE_ALL) { 2 }
      const_attr_reader  :ERR_IGNORE_ALL
      
      const_set_lazy(:ERR_IGNORE_LIB) { 3 }
      const_attr_reader  :ERR_IGNORE_LIB
      
      when_class_loaded do
        p = "sun.security.pkcs11.allowSingleThreadedModules"
        s = AccessController.do_privileged(GetPropertyAction.new(p))
        if ("false".equals_ignore_case(s))
          const_set :StaticAllowSingleThreadedModules, false
        else
          const_set :StaticAllowSingleThreadedModules, true
        end
      end
      
      # temporary storage for configurations
      # needed because the SunPKCS11 needs to call the superclass constructor
      # in provider before accessing any instance variables
      const_set_lazy(:ConfigMap) { HashMap.new }
      const_attr_reader  :ConfigMap
      
      typesig { [String, InputStream] }
      def get_config(name, stream)
        config = ConfigMap.get(name)
        if (!(config).nil?)
          return config
        end
        begin
          config = Config.new(name, stream)
          ConfigMap.put(name, config)
          return config
        rescue JavaException => e
          raise ProviderException.new("Error parsing configuration", e)
        end
      end
      
      typesig { [String] }
      def remove_config(name)
        return ConfigMap.remove(name)
      end
      
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
      
      typesig { [Object] }
      def debug(o)
        if (DEBUG)
          System.out.println(o)
        end
      end
    }
    
    # Reader and StringTokenizer used during parsing
    attr_accessor :reader
    alias_method :attr_reader, :reader
    undef_method :reader
    alias_method :attr_reader=, :reader=
    undef_method :reader=
    
    attr_accessor :st
    alias_method :attr_st, :st
    undef_method :st
    alias_method :attr_st=, :st=
    undef_method :st=
    
    attr_accessor :parsed_keywords
    alias_method :attr_parsed_keywords, :parsed_keywords
    undef_method :parsed_keywords
    alias_method :attr_parsed_keywords=, :parsed_keywords=
    undef_method :parsed_keywords=
    
    # name suffix of the provider
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # name of the PKCS#11 library
    attr_accessor :library
    alias_method :attr_library, :library
    undef_method :library
    alias_method :attr_library=, :library=
    undef_method :library=
    
    # description to pass to the provider class
    attr_accessor :description
    alias_method :attr_description, :description
    undef_method :description
    alias_method :attr_description=, :description=
    undef_method :description=
    
    # slotID of the slot to use
    attr_accessor :slot_id
    alias_method :attr_slot_id, :slot_id
    undef_method :slot_id
    alias_method :attr_slot_id=, :slot_id=
    undef_method :slot_id=
    
    # slot to use, specified as index in the slotlist
    attr_accessor :slot_list_index
    alias_method :attr_slot_list_index, :slot_list_index
    undef_method :slot_list_index
    alias_method :attr_slot_list_index=, :slot_list_index=
    undef_method :slot_list_index=
    
    # set of enabled mechanisms (or null to use default)
    attr_accessor :enabled_mechanisms
    alias_method :attr_enabled_mechanisms, :enabled_mechanisms
    undef_method :enabled_mechanisms
    alias_method :attr_enabled_mechanisms=, :enabled_mechanisms=
    undef_method :enabled_mechanisms=
    
    # set of disabled mechanisms
    attr_accessor :disabled_mechanisms
    alias_method :attr_disabled_mechanisms, :disabled_mechanisms
    undef_method :disabled_mechanisms
    alias_method :attr_disabled_mechanisms=, :disabled_mechanisms=
    undef_method :disabled_mechanisms=
    
    # whether to print debug info during startup
    attr_accessor :show_info
    alias_method :attr_show_info, :show_info
    undef_method :show_info
    alias_method :attr_show_info=, :show_info=
    undef_method :show_info=
    
    # template manager, initialized from parsed attributes
    attr_accessor :template_manager
    alias_method :attr_template_manager, :template_manager
    undef_method :template_manager
    alias_method :attr_template_manager=, :template_manager=
    undef_method :template_manager=
    
    # how to handle error during startup, one of ERR_
    attr_accessor :handle_startup_errors
    alias_method :attr_handle_startup_errors, :handle_startup_errors
    undef_method :handle_startup_errors
    alias_method :attr_handle_startup_errors=, :handle_startup_errors=
    undef_method :handle_startup_errors=
    
    # flag indicating whether the P11KeyStore should
    # be more tolerant of input parameters
    attr_accessor :key_store_compatibility_mode
    alias_method :attr_key_store_compatibility_mode, :key_store_compatibility_mode
    undef_method :key_store_compatibility_mode
    alias_method :attr_key_store_compatibility_mode=, :key_store_compatibility_mode=
    undef_method :key_store_compatibility_mode=
    
    # flag indicating whether we need to explicitly cancel operations
    # see Token
    attr_accessor :explicit_cancel
    alias_method :attr_explicit_cancel, :explicit_cancel
    undef_method :explicit_cancel
    alias_method :attr_explicit_cancel=, :explicit_cancel=
    undef_method :explicit_cancel=
    
    # how often to test for token insertion, if no token is present
    attr_accessor :insertion_check_interval
    alias_method :attr_insertion_check_interval, :insertion_check_interval
    undef_method :insertion_check_interval
    alias_method :attr_insertion_check_interval=, :insertion_check_interval=
    undef_method :insertion_check_interval=
    
    # flag inidicating whether to omit the call to C_Initialize()
    # should be used only if we are running within a process that
    # has already called it (e.g. Plugin inside of Mozilla/NSS)
    attr_accessor :omit_initialize
    alias_method :attr_omit_initialize, :omit_initialize
    undef_method :omit_initialize
    alias_method :attr_omit_initialize=, :omit_initialize=
    undef_method :omit_initialize=
    
    # whether to allow modules that only support single threaded access.
    # they cannot be used safely from multiple PKCS#11 consumers in the
    # same process, for example NSS and SunPKCS11
    attr_accessor :allow_single_threaded_modules
    alias_method :attr_allow_single_threaded_modules, :allow_single_threaded_modules
    undef_method :allow_single_threaded_modules
    alias_method :attr_allow_single_threaded_modules=, :allow_single_threaded_modules=
    undef_method :allow_single_threaded_modules=
    
    # name of the C function that returns the PKCS#11 functionlist
    # This option primarily exists for the deprecated
    # Secmod.Module.getProvider() method.
    attr_accessor :function_list
    alias_method :attr_function_list, :function_list
    undef_method :function_list
    alias_method :attr_function_list=, :function_list=
    undef_method :function_list=
    
    # whether to use NSS secmod mode. Implicitly set if nssLibraryDirectory,
    # nssSecmodDirectory, or nssModule is specified.
    attr_accessor :nss_use_secmod
    alias_method :attr_nss_use_secmod, :nss_use_secmod
    undef_method :nss_use_secmod
    alias_method :attr_nss_use_secmod=, :nss_use_secmod=
    undef_method :nss_use_secmod=
    
    # location of the NSS library files (libnss3.so, etc.)
    attr_accessor :nss_library_directory
    alias_method :attr_nss_library_directory, :nss_library_directory
    undef_method :nss_library_directory
    alias_method :attr_nss_library_directory=, :nss_library_directory=
    undef_method :nss_library_directory=
    
    # location of secmod.db
    attr_accessor :nss_secmod_directory
    alias_method :attr_nss_secmod_directory, :nss_secmod_directory
    undef_method :nss_secmod_directory
    alias_method :attr_nss_secmod_directory=, :nss_secmod_directory=
    undef_method :nss_secmod_directory=
    
    # which NSS module to use
    attr_accessor :nss_module
    alias_method :attr_nss_module, :nss_module
    undef_method :nss_module
    alias_method :attr_nss_module=, :nss_module=
    undef_method :nss_module=
    
    attr_accessor :nss_db_mode
    alias_method :attr_nss_db_mode, :nss_db_mode
    undef_method :nss_db_mode
    alias_method :attr_nss_db_mode=, :nss_db_mode=
    undef_method :nss_db_mode=
    
    # Whether the P11KeyStore should specify the CKA_NETSCAPE_DB attribute
    # when creating private keys. Only valid if nssUseSecmod is true.
    attr_accessor :nss_netscape_db_workaround
    alias_method :attr_nss_netscape_db_workaround, :nss_netscape_db_workaround
    undef_method :nss_netscape_db_workaround
    alias_method :attr_nss_netscape_db_workaround=, :nss_netscape_db_workaround=
    undef_method :nss_netscape_db_workaround=
    
    # Special init argument string for the NSS softtoken.
    # This is used when using the NSS softtoken directly without secmod mode.
    attr_accessor :nss_args
    alias_method :attr_nss_args, :nss_args
    undef_method :nss_args
    alias_method :attr_nss_args=, :nss_args=
    undef_method :nss_args=
    
    # whether to use NSS trust attributes for the KeyStore of this provider
    # this option is for internal use by the SunPKCS11 code only and
    # works only for NSS providers created via the Secmod API
    attr_accessor :nss_use_secmod_trust
    alias_method :attr_nss_use_secmod_trust, :nss_use_secmod_trust
    undef_method :nss_use_secmod_trust
    alias_method :attr_nss_use_secmod_trust=, :nss_use_secmod_trust=
    undef_method :nss_use_secmod_trust=
    
    typesig { [String, InputStream] }
    def initialize(filename, in_)
      @reader = nil
      @st = nil
      @parsed_keywords = nil
      @name = nil
      @library = nil
      @description = nil
      @slot_id = -1
      @slot_list_index = -1
      @enabled_mechanisms = nil
      @disabled_mechanisms = nil
      @show_info = false
      @template_manager = nil
      @handle_startup_errors = ERR_HALT
      @key_store_compatibility_mode = true
      @explicit_cancel = true
      @insertion_check_interval = 2000
      @omit_initialize = false
      @allow_single_threaded_modules = true
      @function_list = "C_GetFunctionList"
      @nss_use_secmod = false
      @nss_library_directory = nil
      @nss_secmod_directory = nil
      @nss_module = nil
      @nss_db_mode = Secmod::DbMode::READ_WRITE
      @nss_netscape_db_workaround = true
      @nss_args = nil
      @nss_use_secmod_trust = false
      if ((in_).nil?)
        if (filename.starts_with("--"))
          # inline config
          config = filename.substring(2).replace("\\n", "\n")
          @reader = StringReader.new(config)
        else
          in_ = FileInputStream.new(expand(filename))
        end
      end
      if ((@reader).nil?)
        @reader = BufferedReader.new(InputStreamReader.new(in_))
      end
      @parsed_keywords = HashSet.new
      @st = StreamTokenizer.new(@reader)
      setup_tokenizer
      parse
    end
    
    typesig { [] }
    def get_name
      return @name
    end
    
    typesig { [] }
    def get_library
      return @library
    end
    
    typesig { [] }
    def get_description
      if (!(@description).nil?)
        return @description
      end
      return "SunPKCS11-" + @name + " using library " + @library
    end
    
    typesig { [] }
    def get_slot_id
      return @slot_id
    end
    
    typesig { [] }
    def get_slot_list_index
      if (((@slot_id).equal?(-1)) && ((@slot_list_index).equal?(-1)))
        # if neither is set, default to first slot
        return 0
      else
        return @slot_list_index
      end
    end
    
    typesig { [] }
    def get_show_info
      return (!(SunPKCS11.attr_debug).nil?) || @show_info
    end
    
    typesig { [] }
    def get_template_manager
      if ((@template_manager).nil?)
        @template_manager = TemplateManager.new
      end
      return @template_manager
    end
    
    typesig { [::Java::Long] }
    def is_enabled(m)
      if (!(@enabled_mechanisms).nil?)
        return @enabled_mechanisms.contains(Long.value_of(m))
      end
      if (!(@disabled_mechanisms).nil?)
        return !@disabled_mechanisms.contains(Long.value_of(m))
      end
      return true
    end
    
    typesig { [] }
    def get_handle_startup_errors
      return @handle_startup_errors
    end
    
    typesig { [] }
    def get_key_store_compatibility_mode
      return @key_store_compatibility_mode
    end
    
    typesig { [] }
    def get_explicit_cancel
      return @explicit_cancel
    end
    
    typesig { [] }
    def get_insertion_check_interval
      return @insertion_check_interval
    end
    
    typesig { [] }
    def get_omit_initialize
      return @omit_initialize
    end
    
    typesig { [] }
    def get_allow_single_threaded_modules
      return StaticAllowSingleThreadedModules && @allow_single_threaded_modules
    end
    
    typesig { [] }
    def get_function_list
      return @function_list
    end
    
    typesig { [] }
    def get_nss_use_secmod
      return @nss_use_secmod
    end
    
    typesig { [] }
    def get_nss_library_directory
      return @nss_library_directory
    end
    
    typesig { [] }
    def get_nss_secmod_directory
      return @nss_secmod_directory
    end
    
    typesig { [] }
    def get_nss_module
      return @nss_module
    end
    
    typesig { [] }
    def get_nss_db_mode
      return @nss_db_mode
    end
    
    typesig { [] }
    def get_nss_netscape_db_workaround
      return @nss_use_secmod && @nss_netscape_db_workaround
    end
    
    typesig { [] }
    def get_nss_args
      return @nss_args
    end
    
    typesig { [] }
    def get_nss_use_secmod_trust
      return @nss_use_secmod_trust
    end
    
    class_module.module_eval {
      typesig { [String] }
      def expand(s)
        begin
          return PropertyExpander.expand(s)
        rescue JavaException => e
          raise RuntimeException.new(e.get_message)
        end
      end
    }
    
    typesig { [] }
    def setup_tokenizer
      @st.reset_syntax
      @st.word_chars(Character.new(?a.ord), Character.new(?z.ord))
      @st.word_chars(Character.new(?A.ord), Character.new(?Z.ord))
      @st.word_chars(Character.new(?0.ord), Character.new(?9.ord))
      @st.word_chars(Character.new(?:.ord), Character.new(?:.ord))
      @st.word_chars(Character.new(?..ord), Character.new(?..ord))
      @st.word_chars(Character.new(?_.ord), Character.new(?_.ord))
      @st.word_chars(Character.new(?-.ord), Character.new(?-.ord))
      @st.word_chars(Character.new(?/.ord), Character.new(?/.ord))
      @st.word_chars(Character.new(?\\.ord), Character.new(?\\.ord))
      @st.word_chars(Character.new(?$.ord), Character.new(?$.ord))
      @st.word_chars(Character.new(?{.ord), Character.new(?{.ord)) # need {} for property subst
      @st.word_chars(Character.new(?}.ord), Character.new(?}.ord))
      @st.word_chars(Character.new(?*.ord), Character.new(?*.ord))
      # XXX check ASCII table and add all other characters except special
      # special: #="(),
      @st.whitespace_chars(0, Character.new(?\s.ord))
      @st.comment_char(Character.new(?#.ord))
      @st.eol_is_significant(true)
      @st.quote_char(Character.new(?\".ord))
    end
    
    typesig { [String] }
    def exc_token(msg)
      return ConfigurationException.new(msg + " " + RJava.cast_to_string(@st))
    end
    
    typesig { [String] }
    def exc_line(msg)
      return ConfigurationException.new(msg + ", line " + RJava.cast_to_string(@st.lineno))
    end
    
    typesig { [] }
    def parse
      while (true)
        token = next_token
        if ((token).equal?(TT_EOF))
          break
        end
        if ((token).equal?(TT_EOL))
          next
        end
        if (!(token).equal?(TT_WORD))
          raise exc_token("Unexpected token:")
        end
        word = @st.attr_sval
        if ((word == "name"))
          @name = RJava.cast_to_string(parse_string_entry(word))
        else
          if ((word == "library"))
            @library = RJava.cast_to_string(parse_library(word))
          else
            if ((word == "description"))
              parse_description(word)
            else
              if ((word == "slot"))
                parse_slot_id(word)
              else
                if ((word == "slotListIndex"))
                  parse_slot_list_index(word)
                else
                  if ((word == "enabledMechanisms"))
                    parse_enabled_mechanisms(word)
                  else
                    if ((word == "disabledMechanisms"))
                      parse_disabled_mechanisms(word)
                    else
                      if ((word == "attributes"))
                        parse_attributes(word)
                      else
                        if ((word == "handleStartupErrors"))
                          parse_handle_startup_errors(word)
                        else
                          if (word.ends_with("insertionCheckInterval"))
                            @insertion_check_interval = parse_integer_entry(word)
                            if (@insertion_check_interval < 100)
                              raise exc_line(word + " must be at least 100 ms")
                            end
                          else
                            if ((word == "showInfo"))
                              @show_info = parse_boolean_entry(word)
                            else
                              if ((word == "keyStoreCompatibilityMode"))
                                @key_store_compatibility_mode = parse_boolean_entry(word)
                              else
                                if ((word == "explicitCancel"))
                                  @explicit_cancel = parse_boolean_entry(word)
                                else
                                  if ((word == "omitInitialize"))
                                    @omit_initialize = parse_boolean_entry(word)
                                  else
                                    if ((word == "allowSingleThreadedModules"))
                                      @allow_single_threaded_modules = parse_boolean_entry(word)
                                    else
                                      if ((word == "functionList"))
                                        @function_list = RJava.cast_to_string(parse_string_entry(word))
                                      else
                                        if ((word == "nssUseSecmod"))
                                          @nss_use_secmod = parse_boolean_entry(word)
                                        else
                                          if ((word == "nssLibraryDirectory"))
                                            @nss_library_directory = RJava.cast_to_string(parse_library(word))
                                            @nss_use_secmod = true
                                          else
                                            if ((word == "nssSecmodDirectory"))
                                              @nss_secmod_directory = RJava.cast_to_string(expand(parse_string_entry(word)))
                                              @nss_use_secmod = true
                                            else
                                              if ((word == "nssModule"))
                                                @nss_module = RJava.cast_to_string(parse_string_entry(word))
                                                @nss_use_secmod = true
                                              else
                                                if ((word == "nssDbMode"))
                                                  mode = parse_string_entry(word)
                                                  if ((mode == "readWrite"))
                                                    @nss_db_mode = Secmod::DbMode::READ_WRITE
                                                  else
                                                    if ((mode == "readOnly"))
                                                      @nss_db_mode = Secmod::DbMode::READ_ONLY
                                                    else
                                                      if ((mode == "noDb"))
                                                        @nss_db_mode = Secmod::DbMode::NO_DB
                                                      else
                                                        raise exc_token("nssDbMode must be one of readWrite, readOnly, and noDb:")
                                                      end
                                                    end
                                                  end
                                                  @nss_use_secmod = true
                                                else
                                                  if ((word == "nssNetscapeDbWorkaround"))
                                                    @nss_netscape_db_workaround = parse_boolean_entry(word)
                                                    @nss_use_secmod = true
                                                  else
                                                    if ((word == "nssArgs"))
                                                      parse_nssargs(word)
                                                    else
                                                      if ((word == "nssUseSecmodTrust"))
                                                        @nss_use_secmod_trust = parse_boolean_entry(word)
                                                      else
                                                        raise ConfigurationException.new("Unknown keyword '" + word + "', line " + RJava.cast_to_string(@st.lineno))
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
              end
            end
          end
        end
        @parsed_keywords.add(word)
      end
      @reader.close
      @reader = nil
      @st = nil
      @parsed_keywords = nil
      if ((@name).nil?)
        raise ConfigurationException.new("name must be specified")
      end
      if ((@nss_use_secmod).equal?(false))
        if ((@library).nil?)
          raise ConfigurationException.new("library must be specified")
        end
      else
        if (!(@library).nil?)
          raise ConfigurationException.new("library must not be specified in NSS mode")
        end
        if ((!(@slot_id).equal?(-1)) || (!(@slot_list_index).equal?(-1)))
          raise ConfigurationException.new("slot and slotListIndex must not be specified in NSS mode")
        end
        if (!(@nss_args).nil?)
          raise ConfigurationException.new("nssArgs must not be specified in NSS mode")
        end
        if (!(@nss_use_secmod_trust).equal?(false))
          raise ConfigurationException.new("nssUseSecmodTrust is an " + "internal option and must not be specified in NSS mode")
        end
      end
    end
    
    typesig { [] }
    # 
    # Parsing helper methods
    # 
    def next_token
      token = @st.next_token
      debug(@st)
      return token
    end
    
    typesig { [] }
    def parse_equals
      token = next_token
      if (!(token).equal?(Character.new(?=.ord)))
        raise exc_token("Expected '=', read")
      end
    end
    
    typesig { [] }
    def parse_open_braces
      while (true)
        token = next_token
        if ((token).equal?(TT_EOL))
          next
        end
        if (((token).equal?(TT_WORD)) && (@st.attr_sval == "{"))
          return
        end
        raise exc_token("Expected '{', read")
      end
    end
    
    typesig { [::Java::Int] }
    def is_close_braces(token)
      return ((token).equal?(TT_WORD)) && (@st.attr_sval == "}")
    end
    
    typesig { [] }
    def parse_word
      token = next_token
      if (!(token).equal?(TT_WORD))
        raise exc_token("Unexpected value:")
      end
      return @st.attr_sval
    end
    
    typesig { [String] }
    def parse_string_entry(keyword)
      check_dup(keyword)
      parse_equals
      token = next_token
      if (!(token).equal?(TT_WORD) && !(token).equal?(Character.new(?\".ord)))
        # not a word token nor a string enclosed by double quotes
        raise exc_token("Unexpected value:")
      end
      value = @st.attr_sval
      debug(keyword + ": " + value)
      return value
    end
    
    typesig { [String] }
    def parse_boolean_entry(keyword)
      check_dup(keyword)
      parse_equals
      value = parse_boolean
      debug(keyword + ": " + RJava.cast_to_string(value))
      return value
    end
    
    typesig { [String] }
    def parse_integer_entry(keyword)
      check_dup(keyword)
      parse_equals
      value = decode_number(parse_word)
      debug(keyword + ": " + RJava.cast_to_string(value))
      return value
    end
    
    typesig { [] }
    def parse_boolean
      val = parse_word
      if ((val == "true"))
        return true
      else
        if ((val == "false"))
          return false
        else
          raise exc_token("Expected boolean value, read:")
        end
      end
    end
    
    typesig { [] }
    def parse_line
      s = parse_word
      while (true)
        token = next_token
        if (((token).equal?(TT_EOL)) || ((token).equal?(TT_EOF)))
          break
        end
        if (!(token).equal?(TT_WORD))
          raise exc_token("Unexpected value")
        end
        s = s + " " + RJava.cast_to_string(@st.attr_sval)
      end
      return s
    end
    
    typesig { [String] }
    def decode_number(str)
      begin
        if (str.starts_with("0x") || str.starts_with("0X"))
          return JavaInteger.parse_int(str.substring(2), 16)
        else
          return JavaInteger.parse_int(str)
        end
      rescue NumberFormatException => e
        raise exc_token("Expected number, read")
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      def is_number(s)
        if ((s.length).equal?(0))
          return false
        end
        ch = s.char_at(0)
        return ((ch >= Character.new(?0.ord)) && (ch <= Character.new(?9.ord)))
      end
    }
    
    typesig { [] }
    def parse_comma
      token = next_token
      if (!(token).equal?(Character.new(?,.ord)))
        raise exc_token("Expected ',', read")
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      def is_byte_array(val)
        return val.starts_with("0h")
      end
    }
    
    typesig { [String] }
    def decode_byte_array(str)
      if ((str.starts_with("0h")).equal?(false))
        raise exc_token("Expected byte array value, read")
      end
      str = RJava.cast_to_string(str.substring(2))
      # XXX proper hex parsing
      begin
        return BigInteger.new(str, 16).to_byte_array
      rescue NumberFormatException => e
        raise exc_token("Expected byte array value, read")
      end
    end
    
    typesig { [String] }
    def check_dup(keyword)
      if (@parsed_keywords.contains(keyword))
        raise exc_line(keyword + " must only be specified once")
      end
    end
    
    typesig { [String] }
    # 
    # individual entry parsing methods
    # 
    def parse_library(keyword)
      check_dup(keyword)
      parse_equals
      lib = parse_line
      lib = RJava.cast_to_string(expand(lib))
      i = lib.index_of("/$ISA/")
      if (!(i).equal?(-1))
        # replace "/$ISA/" with "/sparcv9/" on 64-bit Solaris SPARC
        # and with "/amd64/" on Solaris AMD64.
        # On all other platforms, just turn it into a "/"
        os_name = System.get_property("os.name", "")
        os_arch = System.get_property("os.arch", "")
        prefix = lib.substring(0, i)
        suffix = lib.substring(i + 5)
        if ((os_name == "SunOS") && (os_arch == "sparcv9"))
          lib = prefix + "/sparcv9" + suffix
        else
          if ((os_name == "SunOS") && (os_arch == "amd64"))
            lib = prefix + "/amd64" + suffix
          else
            lib = prefix + suffix
          end
        end
      end
      debug(keyword + ": " + lib)
      return lib
    end
    
    typesig { [String] }
    def parse_description(keyword)
      check_dup(keyword)
      parse_equals
      @description = RJava.cast_to_string(parse_line)
      debug("description: " + @description)
    end
    
    typesig { [String] }
    def parse_slot_id(keyword)
      if (@slot_id >= 0)
        raise exc_line("Duplicate slot definition")
      end
      if (@slot_list_index >= 0)
        raise exc_line("Only one of slot and slotListIndex must be specified")
      end
      parse_equals
      slot_string = parse_word
      @slot_id = decode_number(slot_string)
      debug("slot: " + RJava.cast_to_string(@slot_id))
    end
    
    typesig { [String] }
    def parse_slot_list_index(keyword)
      if (@slot_list_index >= 0)
        raise exc_line("Duplicate slotListIndex definition")
      end
      if (@slot_id >= 0)
        raise exc_line("Only one of slot and slotListIndex must be specified")
      end
      parse_equals
      slot_string = parse_word
      @slot_list_index = decode_number(slot_string)
      debug("slotListIndex: " + RJava.cast_to_string(@slot_list_index))
    end
    
    typesig { [String] }
    def parse_enabled_mechanisms(keyword)
      @enabled_mechanisms = parse_mechanisms(keyword)
    end
    
    typesig { [String] }
    def parse_disabled_mechanisms(keyword)
      @disabled_mechanisms = parse_mechanisms(keyword)
    end
    
    typesig { [String] }
    def parse_mechanisms(keyword)
      check_dup(keyword)
      mechs = HashSet.new
      parse_equals
      parse_open_braces
      while (true)
        token = next_token
        if (is_close_braces(token))
          break
        end
        if ((token).equal?(TT_EOL))
          next
        end
        if (!(token).equal?(TT_WORD))
          raise exc_token("Expected mechanism, read")
        end
        mech = parse_mechanism(@st.attr_sval)
        mechs.add(Long.value_of(mech))
      end
      if (DEBUG)
        System.out.print("mechanisms: [")
        mechs.each do |mech|
          System.out.print(Functions.get_mechanism_name(mech))
          System.out.print(", ")
        end
        System.out.println("]")
      end
      return mechs
    end
    
    typesig { [String] }
    def parse_mechanism(mech)
      if (is_number(mech))
        return decode_number(mech)
      else
        begin
          return Functions.get_mechanism_id(mech)
        rescue IllegalArgumentException => e
          raise exc_line("Unknown mechanism: " + mech)
        end
      end
    end
    
    typesig { [String] }
    def parse_attributes(keyword)
      if ((@template_manager).nil?)
        @template_manager = TemplateManager.new
      end
      token = next_token
      if ((token).equal?(Character.new(?=.ord)))
        s = parse_word
        if (((s == "compatibility")).equal?(false))
          raise exc_line("Expected 'compatibility', read " + s)
        end
        set_compatibility_attributes
        return
      end
      if (!(token).equal?(Character.new(?(.ord)))
        raise exc_token("Expected '(' or '=', read")
      end
      op = parse_operation
      parse_comma
      object_class = parse_object_class
      parse_comma
      key_alg = parse_key_algorithm
      token = next_token
      if (!(token).equal?(Character.new(?).ord)))
        raise exc_token("Expected ')', read")
      end
      parse_equals
      parse_open_braces
      attributes = ArrayList.new
      while (true)
        token = next_token
        if (is_close_braces(token))
          break
        end
        if ((token).equal?(TT_EOL))
          next
        end
        if (!(token).equal?(TT_WORD))
          raise exc_token("Expected mechanism, read")
        end
        attribute_name = @st.attr_sval
        attribute_id = decode_attribute_name(attribute_name)
        parse_equals
        attribute_value = parse_word
        attributes.add(decode_attribute_value(attribute_id, attribute_value))
      end
      @template_manager.add_template(op, object_class, key_alg, attributes.to_array(CK_A0))
    end
    
    typesig { [] }
    def set_compatibility_attributes
      # all secret keys
      @template_manager.add_template(O_ANY, CKO_SECRET_KEY, PCKK_ANY, Array.typed(CK_ATTRIBUTE).new([TOKEN_FALSE, SENSITIVE_FALSE, EXTRACTABLE_TRUE, ENCRYPT_TRUE, DECRYPT_TRUE, WRAP_TRUE, UNWRAP_TRUE]))
      # generic secret keys are special
      # They are used as MAC keys plus for the SSL/TLS (pre)master secrets
      @template_manager.add_template(O_ANY, CKO_SECRET_KEY, CKK_GENERIC_SECRET, Array.typed(CK_ATTRIBUTE).new([SIGN_TRUE, VERIFY_TRUE, ENCRYPT_NULL, DECRYPT_NULL, WRAP_NULL, UNWRAP_NULL, DERIVE_TRUE]))
      # all private and public keys
      @template_manager.add_template(O_ANY, CKO_PRIVATE_KEY, PCKK_ANY, Array.typed(CK_ATTRIBUTE).new([TOKEN_FALSE, SENSITIVE_FALSE, EXTRACTABLE_TRUE]))
      @template_manager.add_template(O_ANY, CKO_PUBLIC_KEY, PCKK_ANY, Array.typed(CK_ATTRIBUTE).new([TOKEN_FALSE]))
      # additional attributes for RSA private keys
      @template_manager.add_template(O_ANY, CKO_PRIVATE_KEY, CKK_RSA, Array.typed(CK_ATTRIBUTE).new([DECRYPT_TRUE, SIGN_TRUE, SIGN_RECOVER_TRUE, UNWRAP_TRUE]))
      # additional attributes for RSA public keys
      @template_manager.add_template(O_ANY, CKO_PUBLIC_KEY, CKK_RSA, Array.typed(CK_ATTRIBUTE).new([ENCRYPT_TRUE, VERIFY_TRUE, VERIFY_RECOVER_TRUE, WRAP_TRUE]))
      # additional attributes for DSA private keys
      @template_manager.add_template(O_ANY, CKO_PRIVATE_KEY, CKK_DSA, Array.typed(CK_ATTRIBUTE).new([SIGN_TRUE]))
      # additional attributes for DSA public keys
      @template_manager.add_template(O_ANY, CKO_PUBLIC_KEY, CKK_DSA, Array.typed(CK_ATTRIBUTE).new([VERIFY_TRUE]))
      # additional attributes for DH private keys
      @template_manager.add_template(O_ANY, CKO_PRIVATE_KEY, CKK_DH, Array.typed(CK_ATTRIBUTE).new([DERIVE_TRUE]))
      # additional attributes for EC private keys
      @template_manager.add_template(O_ANY, CKO_PRIVATE_KEY, CKK_EC, Array.typed(CK_ATTRIBUTE).new([SIGN_TRUE, DERIVE_TRUE]))
      # additional attributes for EC public keys
      @template_manager.add_template(O_ANY, CKO_PUBLIC_KEY, CKK_EC, Array.typed(CK_ATTRIBUTE).new([VERIFY_TRUE]))
    end
    
    class_module.module_eval {
      const_set_lazy(:CK_A0) { Array.typed(CK_ATTRIBUTE).new(0) { nil } }
      const_attr_reader  :CK_A0
    }
    
    typesig { [] }
    def parse_operation
      op = parse_word
      if ((op == "*"))
        return TemplateManager::O_ANY
      else
        if ((op == "generate"))
          return TemplateManager::O_GENERATE
        else
          if ((op == "import"))
            return TemplateManager::O_IMPORT
          else
            raise exc_line("Unknown operation " + op)
          end
        end
      end
    end
    
    typesig { [] }
    def parse_object_class
      name = parse_word
      begin
        return Functions.get_object_class_id(name)
      rescue IllegalArgumentException => e
        raise exc_line("Unknown object class " + name)
      end
    end
    
    typesig { [] }
    def parse_key_algorithm
      name = parse_word
      if (is_number(name))
        return decode_number(name)
      else
        begin
          return Functions.get_key_id(name)
        rescue IllegalArgumentException => e
          raise exc_line("Unknown key algorithm " + name)
        end
      end
    end
    
    typesig { [String] }
    def decode_attribute_name(name)
      if (is_number(name))
        return decode_number(name)
      else
        begin
          return Functions.get_attribute_id(name)
        rescue IllegalArgumentException => e
          raise exc_line("Unknown attribute name " + name)
        end
      end
    end
    
    typesig { [::Java::Long, String] }
    def decode_attribute_value(id, value)
      if ((value == "null"))
        return CK_ATTRIBUTE.new(id)
      else
        if ((value == "true"))
          return CK_ATTRIBUTE.new(id, true)
        else
          if ((value == "false"))
            return CK_ATTRIBUTE.new(id, false)
          else
            if (is_byte_array(value))
              return CK_ATTRIBUTE.new(id, decode_byte_array(value))
            else
              if (is_number(value))
                return CK_ATTRIBUTE.new(id, JavaInteger.value_of(decode_number(value)))
              else
                raise exc_line("Unknown attribute value " + value)
              end
            end
          end
        end
      end
    end
    
    typesig { [String] }
    def parse_nssargs(keyword)
      check_dup(keyword)
      parse_equals
      token = next_token
      if (!(token).equal?(Character.new(?".ord)))
        raise exc_token("Expected quoted string")
      end
      @nss_args = RJava.cast_to_string(expand(@st.attr_sval))
      debug("nssArgs: " + @nss_args)
    end
    
    typesig { [String] }
    def parse_handle_startup_errors(keyword)
      check_dup(keyword)
      parse_equals
      val = parse_word
      if ((val == "ignoreAll"))
        @handle_startup_errors = ERR_IGNORE_ALL
      else
        if ((val == "ignoreMissingLibrary"))
          @handle_startup_errors = ERR_IGNORE_LIB
        else
          if ((val == "halt"))
            @handle_startup_errors = ERR_HALT
          else
            raise exc_token("Invalid value for handleStartupErrors:")
          end
        end
      end
      debug("handleStartupErrors: " + RJava.cast_to_string(@handle_startup_errors))
    end
    
    private
    alias_method :initialize__config, :initialize
  end
  
  class ConfigurationException < ConfigImports.const_get :IOException
    include_class_members ConfigImports
    
    typesig { [String] }
    def initialize(msg)
      super(msg)
    end
    
    private
    alias_method :initialize__configuration_exception, :initialize
  end
  
end
