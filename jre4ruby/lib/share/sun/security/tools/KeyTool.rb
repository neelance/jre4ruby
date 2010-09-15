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
  module KeyToolImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Tools
      include ::Java::Io
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Java::Security, :InvalidParameterException
      include_const ::Java::Security, :KeyStore
      include_const ::Java::Security, :KeyStoreException
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :Key
      include_const ::Java::Security, :PublicKey
      include_const ::Java::Security, :PrivateKey
      include_const ::Java::Security, :Security
      include_const ::Java::Security, :Signature
      include_const ::Java::Security, :SignatureException
      include_const ::Java::Security, :UnrecoverableEntryException
      include_const ::Java::Security, :UnrecoverableKeyException
      include_const ::Java::Security, :Principal
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :Identity
      include_const ::Java::Security, :Signer
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :CertificateFactory
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Interfaces, :DSAParams
      include_const ::Java::Security::Interfaces, :DSAPrivateKey
      include_const ::Java::Security::Interfaces, :DSAPublicKey
      include_const ::Java::Security::Interfaces, :RSAPrivateCrtKey
      include_const ::Java::Security::Interfaces, :RSAPrivateKey
      include_const ::Java::Security::Interfaces, :RSAPublicKey
      include_const ::Java::Text, :Collator
      include_const ::Java::Text, :MessageFormat
      include ::Java::Util
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLClassLoader
      include_const ::Sun::Misc, :BASE64Decoder
      include_const ::Sun::Misc, :BASE64Encoder
      include_const ::Sun::Security::Util, :ObjectIdentifier
      include_const ::Sun::Security::Pkcs, :PKCS10
      include_const ::Sun::Security::Provider, :IdentityDatabase
      include_const ::Sun::Security::Provider, :SystemSigner
      include_const ::Sun::Security::Provider, :SystemIdentity
      include_const ::Sun::Security::Provider, :X509Factory
      include_const ::Sun::Security::Util, :DerOutputStream
      include_const ::Sun::Security::Util, :Password
      include_const ::Sun::Security::Util, :Resources
      include_const ::Sun::Security::Util, :PathList
      include_const ::Javax::Crypto, :KeyGenerator
      include_const ::Javax::Crypto, :SecretKey
      include ::Sun::Security::X509
    }
  end
  
  # This tool manages keystores.
  # 
  # @author Jan Luehe
  # 
  # 
  # @see java.security.KeyStore
  # @see sun.security.provider.KeyProtector
  # @see sun.security.provider.JavaKeyStore
  # 
  # @since 1.2
  class KeyTool 
    include_class_members KeyToolImports
    
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    attr_accessor :command
    alias_method :attr_command, :command
    undef_method :command
    alias_method :attr_command=, :command=
    undef_method :command=
    
    attr_accessor :sig_alg_name
    alias_method :attr_sig_alg_name, :sig_alg_name
    undef_method :sig_alg_name
    alias_method :attr_sig_alg_name=, :sig_alg_name=
    undef_method :sig_alg_name=
    
    attr_accessor :key_alg_name
    alias_method :attr_key_alg_name, :key_alg_name
    undef_method :key_alg_name
    alias_method :attr_key_alg_name=, :key_alg_name=
    undef_method :key_alg_name=
    
    attr_accessor :verbose
    alias_method :attr_verbose, :verbose
    undef_method :verbose
    alias_method :attr_verbose=, :verbose=
    undef_method :verbose=
    
    attr_accessor :keysize
    alias_method :attr_keysize, :keysize
    undef_method :keysize
    alias_method :attr_keysize=, :keysize=
    undef_method :keysize=
    
    attr_accessor :rfc
    alias_method :attr_rfc, :rfc
    undef_method :rfc
    alias_method :attr_rfc=, :rfc=
    undef_method :rfc=
    
    attr_accessor :validity
    alias_method :attr_validity, :validity
    undef_method :validity
    alias_method :attr_validity=, :validity=
    undef_method :validity=
    
    attr_accessor :alias
    alias_method :attr_alias, :alias
    undef_method :alias
    alias_method :attr_alias=, :alias=
    undef_method :alias=
    
    attr_accessor :dname
    alias_method :attr_dname, :dname
    undef_method :dname
    alias_method :attr_dname=, :dname=
    undef_method :dname=
    
    attr_accessor :dest
    alias_method :attr_dest, :dest
    undef_method :dest
    alias_method :attr_dest=, :dest=
    undef_method :dest=
    
    attr_accessor :filename
    alias_method :attr_filename, :filename
    undef_method :filename
    alias_method :attr_filename=, :filename=
    undef_method :filename=
    
    attr_accessor :srcksfname
    alias_method :attr_srcksfname, :srcksfname
    undef_method :srcksfname
    alias_method :attr_srcksfname=, :srcksfname=
    undef_method :srcksfname=
    
    # User-specified providers are added before any command is called.
    # However, they are not removed before the end of the main() method.
    # If you're calling KeyTool.main() directly in your own Java program,
    # please programtically add any providers you need and do not specify
    # them through the command line.
    attr_accessor :providers
    alias_method :attr_providers, :providers
    undef_method :providers
    alias_method :attr_providers=, :providers=
    undef_method :providers=
    
    attr_accessor :storetype
    alias_method :attr_storetype, :storetype
    undef_method :storetype
    alias_method :attr_storetype=, :storetype=
    undef_method :storetype=
    
    attr_accessor :src_provider_name
    alias_method :attr_src_provider_name, :src_provider_name
    undef_method :src_provider_name
    alias_method :attr_src_provider_name=, :src_provider_name=
    undef_method :src_provider_name=
    
    attr_accessor :provider_name
    alias_method :attr_provider_name, :provider_name
    undef_method :provider_name
    alias_method :attr_provider_name=, :provider_name=
    undef_method :provider_name=
    
    attr_accessor :pathlist
    alias_method :attr_pathlist, :pathlist
    undef_method :pathlist
    alias_method :attr_pathlist=, :pathlist=
    undef_method :pathlist=
    
    attr_accessor :store_pass
    alias_method :attr_store_pass, :store_pass
    undef_method :store_pass
    alias_method :attr_store_pass=, :store_pass=
    undef_method :store_pass=
    
    attr_accessor :store_pass_new
    alias_method :attr_store_pass_new, :store_pass_new
    undef_method :store_pass_new
    alias_method :attr_store_pass_new=, :store_pass_new=
    undef_method :store_pass_new=
    
    attr_accessor :key_pass
    alias_method :attr_key_pass, :key_pass
    undef_method :key_pass
    alias_method :attr_key_pass=, :key_pass=
    undef_method :key_pass=
    
    attr_accessor :key_pass_new
    alias_method :attr_key_pass_new, :key_pass_new
    undef_method :key_pass_new
    alias_method :attr_key_pass_new=, :key_pass_new=
    undef_method :key_pass_new=
    
    attr_accessor :old_pass
    alias_method :attr_old_pass, :old_pass
    undef_method :old_pass
    alias_method :attr_old_pass=, :old_pass=
    undef_method :old_pass=
    
    attr_accessor :new_pass
    alias_method :attr_new_pass, :new_pass
    undef_method :new_pass
    alias_method :attr_new_pass=, :new_pass=
    undef_method :new_pass=
    
    attr_accessor :dest_key_pass
    alias_method :attr_dest_key_pass, :dest_key_pass
    undef_method :dest_key_pass
    alias_method :attr_dest_key_pass=, :dest_key_pass=
    undef_method :dest_key_pass=
    
    attr_accessor :srckey_pass
    alias_method :attr_srckey_pass, :srckey_pass
    undef_method :srckey_pass
    alias_method :attr_srckey_pass=, :srckey_pass=
    undef_method :srckey_pass=
    
    attr_accessor :ksfname
    alias_method :attr_ksfname, :ksfname
    undef_method :ksfname
    alias_method :attr_ksfname=, :ksfname=
    undef_method :ksfname=
    
    attr_accessor :ksfile
    alias_method :attr_ksfile, :ksfile
    undef_method :ksfile
    alias_method :attr_ksfile=, :ksfile=
    undef_method :ksfile=
    
    attr_accessor :ks_stream
    alias_method :attr_ks_stream, :ks_stream
    undef_method :ks_stream
    alias_method :attr_ks_stream=, :ks_stream=
    undef_method :ks_stream=
    
    # keystore stream
    attr_accessor :key_store
    alias_method :attr_key_store, :key_store
    undef_method :key_store
    alias_method :attr_key_store=, :key_store=
    undef_method :key_store=
    
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    attr_accessor :null_stream
    alias_method :attr_null_stream, :null_stream
    undef_method :null_stream
    alias_method :attr_null_stream=, :null_stream=
    undef_method :null_stream=
    
    attr_accessor :kssave
    alias_method :attr_kssave, :kssave
    undef_method :kssave
    alias_method :attr_kssave=, :kssave=
    undef_method :kssave=
    
    attr_accessor :noprompt
    alias_method :attr_noprompt, :noprompt
    undef_method :noprompt
    alias_method :attr_noprompt=, :noprompt=
    undef_method :noprompt=
    
    attr_accessor :trustcacerts
    alias_method :attr_trustcacerts, :trustcacerts
    undef_method :trustcacerts
    alias_method :attr_trustcacerts=, :trustcacerts=
    undef_method :trustcacerts=
    
    attr_accessor :protected_path
    alias_method :attr_protected_path, :protected_path
    undef_method :protected_path
    alias_method :attr_protected_path=, :protected_path=
    undef_method :protected_path=
    
    attr_accessor :srcprotected_path
    alias_method :attr_srcprotected_path, :srcprotected_path
    undef_method :srcprotected_path
    alias_method :attr_srcprotected_path=, :srcprotected_path=
    undef_method :srcprotected_path=
    
    attr_accessor :cf
    alias_method :attr_cf, :cf
    undef_method :cf
    alias_method :attr_cf=, :cf=
    undef_method :cf=
    
    attr_accessor :caks
    alias_method :attr_caks, :caks
    undef_method :caks
    alias_method :attr_caks=, :caks=
    undef_method :caks=
    
    # "cacerts" keystore
    attr_accessor :srcstore_pass
    alias_method :attr_srcstore_pass, :srcstore_pass
    undef_method :srcstore_pass
    alias_method :attr_srcstore_pass=, :srcstore_pass=
    undef_method :srcstore_pass=
    
    attr_accessor :srcstoretype
    alias_method :attr_srcstoretype, :srcstoretype
    undef_method :srcstoretype
    alias_method :attr_srcstoretype=, :srcstoretype=
    undef_method :srcstoretype=
    
    attr_accessor :passwords
    alias_method :attr_passwords, :passwords
    undef_method :passwords
    alias_method :attr_passwords=, :passwords=
    undef_method :passwords=
    
    attr_accessor :start_date
    alias_method :attr_start_date, :start_date
    undef_method :start_date
    alias_method :attr_start_date=, :start_date=
    undef_method :start_date=
    
    class_module.module_eval {
      const_set_lazy(:CERTREQ) { 1 }
      const_attr_reader  :CERTREQ
      
      const_set_lazy(:CHANGEALIAS) { 2 }
      const_attr_reader  :CHANGEALIAS
      
      const_set_lazy(:DELETE) { 3 }
      const_attr_reader  :DELETE
      
      const_set_lazy(:EXPORTCERT) { 4 }
      const_attr_reader  :EXPORTCERT
      
      const_set_lazy(:GENKEYPAIR) { 5 }
      const_attr_reader  :GENKEYPAIR
      
      const_set_lazy(:GENSECKEY) { 6 }
      const_attr_reader  :GENSECKEY
      
      # there is no HELP
      const_set_lazy(:IDENTITYDB) { 7 }
      const_attr_reader  :IDENTITYDB
      
      const_set_lazy(:IMPORTCERT) { 8 }
      const_attr_reader  :IMPORTCERT
      
      const_set_lazy(:IMPORTKEYSTORE) { 9 }
      const_attr_reader  :IMPORTKEYSTORE
      
      const_set_lazy(:KEYCLONE) { 10 }
      const_attr_reader  :KEYCLONE
      
      const_set_lazy(:KEYPASSWD) { 11 }
      const_attr_reader  :KEYPASSWD
      
      const_set_lazy(:LIST) { 12 }
      const_attr_reader  :LIST
      
      const_set_lazy(:PRINTCERT) { 13 }
      const_attr_reader  :PRINTCERT
      
      const_set_lazy(:SELFCERT) { 14 }
      const_attr_reader  :SELFCERT
      
      const_set_lazy(:STOREPASSWD) { 15 }
      const_attr_reader  :STOREPASSWD
      
      const_set_lazy(:PARAM_STRING) { Array.typed(Class).new([String]) }
      const_attr_reader  :PARAM_STRING
      
      const_set_lazy(:JKS) { "jks" }
      const_attr_reader  :JKS
      
      const_set_lazy(:NONE) { "NONE" }
      const_attr_reader  :NONE
      
      const_set_lazy(:P11KEYSTORE) { "PKCS11" }
      const_attr_reader  :P11KEYSTORE
      
      const_set_lazy(:P12KEYSTORE) { "PKCS12" }
      const_attr_reader  :P12KEYSTORE
    }
    
    attr_accessor :key_alias
    alias_method :attr_key_alias, :key_alias
    undef_method :key_alias
    alias_method :attr_key_alias=, :key_alias=
    undef_method :key_alias=
    
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
    
    typesig { [] }
    def initialize
      @debug = false
      @command = -1
      @sig_alg_name = nil
      @key_alg_name = nil
      @verbose = false
      @keysize = -1
      @rfc = false
      @validity = 90
      @alias = nil
      @dname = nil
      @dest = nil
      @filename = nil
      @srcksfname = nil
      @providers = nil
      @storetype = nil
      @src_provider_name = nil
      @provider_name = nil
      @pathlist = nil
      @store_pass = nil
      @store_pass_new = nil
      @key_pass = nil
      @key_pass_new = nil
      @old_pass = nil
      @new_pass = nil
      @dest_key_pass = nil
      @srckey_pass = nil
      @ksfname = nil
      @ksfile = nil
      @ks_stream = nil
      @key_store = nil
      @token = false
      @null_stream = false
      @kssave = false
      @noprompt = false
      @trustcacerts = false
      @protected_path = false
      @srcprotected_path = false
      @cf = nil
      @caks = nil
      @srcstore_pass = nil
      @srcstoretype = nil
      @passwords = HashSet.new
      @start_date = nil
      @key_alias = "mykey"
    end
    
    class_module.module_eval {
      typesig { [Array.typed(String)] }
      def main(args)
        kt = KeyTool.new
        kt.run(args, System.out)
      end
    }
    
    typesig { [Array.typed(String), PrintStream] }
    def run(args, out)
      begin
        parse_args(args)
        do_commands(out)
      rescue JavaException => e
        System.out.println(Rb.get_string("keytool error: ") + e)
        if (@verbose)
          e.print_stack_trace(System.out)
        end
        if (!@debug)
          System.exit(1)
        else
          raise e
        end
      ensure
        @passwords.each do |pass|
          if (!(pass).nil?)
            Arrays.fill(pass, Character.new(?\s.ord))
            pass = nil
          end
        end
        if (!(@ks_stream).nil?)
          @ks_stream.close
        end
      end
    end
    
    typesig { [Array.typed(String)] }
    # Parse command line arguments.
    def parse_args(args)
      if ((args.attr_length).equal?(0))
        usage
      end
      i = 0
      i = 0
      while (i < args.attr_length) && args[i].starts_with("-")
        flags = args[i]
        # command modes
        if ((Collator.compare(flags, "-certreq")).equal?(0))
          @command = CERTREQ
        else
          if ((Collator.compare(flags, "-delete")).equal?(0))
            @command = DELETE
          else
            if ((Collator.compare(flags, "-export")).equal?(0) || (Collator.compare(flags, "-exportcert")).equal?(0))
              @command = EXPORTCERT
            else
              if ((Collator.compare(flags, "-genkey")).equal?(0) || (Collator.compare(flags, "-genkeypair")).equal?(0))
                @command = GENKEYPAIR
              else
                if ((Collator.compare(flags, "-help")).equal?(0))
                  usage
                  return
                else
                  if ((Collator.compare(flags, "-identitydb")).equal?(0))
                    # obsolete
                    @command = IDENTITYDB
                  else
                    if ((Collator.compare(flags, "-import")).equal?(0) || (Collator.compare(flags, "-importcert")).equal?(0))
                      @command = IMPORTCERT
                    else
                      if ((Collator.compare(flags, "-keyclone")).equal?(0))
                        # obsolete
                        @command = KEYCLONE
                      else
                        if ((Collator.compare(flags, "-changealias")).equal?(0))
                          @command = CHANGEALIAS
                        else
                          if ((Collator.compare(flags, "-keypasswd")).equal?(0))
                            @command = KEYPASSWD
                          else
                            if ((Collator.compare(flags, "-list")).equal?(0))
                              @command = LIST
                            else
                              if ((Collator.compare(flags, "-printcert")).equal?(0))
                                @command = PRINTCERT
                              else
                                if ((Collator.compare(flags, "-selfcert")).equal?(0))
                                  # obsolete
                                  @command = SELFCERT
                                else
                                  if ((Collator.compare(flags, "-storepasswd")).equal?(0))
                                    @command = STOREPASSWD
                                  else
                                    if ((Collator.compare(flags, "-importkeystore")).equal?(0))
                                      @command = IMPORTKEYSTORE
                                    else
                                      if ((Collator.compare(flags, "-genseckey")).equal?(0))
                                        @command = GENSECKEY
                                      # specifiers
                                      else
                                        if ((Collator.compare(flags, "-keystore")).equal?(0) || (Collator.compare(flags, "-destkeystore")).equal?(0))
                                          if (((i += 1)).equal?(args.attr_length))
                                            error_need_argument(flags)
                                          end
                                          @ksfname = RJava.cast_to_string(args[i])
                                        else
                                          if ((Collator.compare(flags, "-storepass")).equal?(0) || (Collator.compare(flags, "-deststorepass")).equal?(0))
                                            if (((i += 1)).equal?(args.attr_length))
                                              error_need_argument(flags)
                                            end
                                            @store_pass = args[i].to_char_array
                                            @passwords.add(@store_pass)
                                          else
                                            if ((Collator.compare(flags, "-storetype")).equal?(0) || (Collator.compare(flags, "-deststoretype")).equal?(0))
                                              if (((i += 1)).equal?(args.attr_length))
                                                error_need_argument(flags)
                                              end
                                              @storetype = RJava.cast_to_string(args[i])
                                            else
                                              if ((Collator.compare(flags, "-srcstorepass")).equal?(0))
                                                if (((i += 1)).equal?(args.attr_length))
                                                  error_need_argument(flags)
                                                end
                                                @srcstore_pass = args[i].to_char_array
                                                @passwords.add(@srcstore_pass)
                                              else
                                                if ((Collator.compare(flags, "-srcstoretype")).equal?(0))
                                                  if (((i += 1)).equal?(args.attr_length))
                                                    error_need_argument(flags)
                                                  end
                                                  @srcstoretype = RJava.cast_to_string(args[i])
                                                else
                                                  if ((Collator.compare(flags, "-srckeypass")).equal?(0))
                                                    if (((i += 1)).equal?(args.attr_length))
                                                      error_need_argument(flags)
                                                    end
                                                    @srckey_pass = args[i].to_char_array
                                                    @passwords.add(@srckey_pass)
                                                  else
                                                    if ((Collator.compare(flags, "-srcprovidername")).equal?(0))
                                                      if (((i += 1)).equal?(args.attr_length))
                                                        error_need_argument(flags)
                                                      end
                                                      @src_provider_name = RJava.cast_to_string(args[i])
                                                    else
                                                      if ((Collator.compare(flags, "-providername")).equal?(0) || (Collator.compare(flags, "-destprovidername")).equal?(0))
                                                        if (((i += 1)).equal?(args.attr_length))
                                                          error_need_argument(flags)
                                                        end
                                                        @provider_name = RJava.cast_to_string(args[i])
                                                      else
                                                        if ((Collator.compare(flags, "-providerpath")).equal?(0))
                                                          if (((i += 1)).equal?(args.attr_length))
                                                            error_need_argument(flags)
                                                          end
                                                          @pathlist = RJava.cast_to_string(args[i])
                                                        else
                                                          if ((Collator.compare(flags, "-keypass")).equal?(0))
                                                            if (((i += 1)).equal?(args.attr_length))
                                                              error_need_argument(flags)
                                                            end
                                                            @key_pass = args[i].to_char_array
                                                            @passwords.add(@key_pass)
                                                          else
                                                            if ((Collator.compare(flags, "-new")).equal?(0))
                                                              if (((i += 1)).equal?(args.attr_length))
                                                                error_need_argument(flags)
                                                              end
                                                              @new_pass = args[i].to_char_array
                                                              @passwords.add(@new_pass)
                                                            else
                                                              if ((Collator.compare(flags, "-destkeypass")).equal?(0))
                                                                if (((i += 1)).equal?(args.attr_length))
                                                                  error_need_argument(flags)
                                                                end
                                                                @dest_key_pass = args[i].to_char_array
                                                                @passwords.add(@dest_key_pass)
                                                              else
                                                                if ((Collator.compare(flags, "-alias")).equal?(0) || (Collator.compare(flags, "-srcalias")).equal?(0))
                                                                  if (((i += 1)).equal?(args.attr_length))
                                                                    error_need_argument(flags)
                                                                  end
                                                                  @alias = RJava.cast_to_string(args[i])
                                                                else
                                                                  if ((Collator.compare(flags, "-dest")).equal?(0) || (Collator.compare(flags, "-destalias")).equal?(0))
                                                                    if (((i += 1)).equal?(args.attr_length))
                                                                      error_need_argument(flags)
                                                                    end
                                                                    @dest = RJava.cast_to_string(args[i])
                                                                  else
                                                                    if ((Collator.compare(flags, "-dname")).equal?(0))
                                                                      if (((i += 1)).equal?(args.attr_length))
                                                                        error_need_argument(flags)
                                                                      end
                                                                      @dname = RJava.cast_to_string(args[i])
                                                                    else
                                                                      if ((Collator.compare(flags, "-keysize")).equal?(0))
                                                                        if (((i += 1)).equal?(args.attr_length))
                                                                          error_need_argument(flags)
                                                                        end
                                                                        @keysize = JavaInteger.parse_int(args[i])
                                                                      else
                                                                        if ((Collator.compare(flags, "-keyalg")).equal?(0))
                                                                          if (((i += 1)).equal?(args.attr_length))
                                                                            error_need_argument(flags)
                                                                          end
                                                                          @key_alg_name = RJava.cast_to_string(args[i])
                                                                        else
                                                                          if ((Collator.compare(flags, "-sigalg")).equal?(0))
                                                                            if (((i += 1)).equal?(args.attr_length))
                                                                              error_need_argument(flags)
                                                                            end
                                                                            @sig_alg_name = RJava.cast_to_string(args[i])
                                                                          else
                                                                            if ((Collator.compare(flags, "-startdate")).equal?(0))
                                                                              if (((i += 1)).equal?(args.attr_length))
                                                                                error_need_argument(flags)
                                                                              end
                                                                              @start_date = RJava.cast_to_string(args[i])
                                                                            else
                                                                              if ((Collator.compare(flags, "-validity")).equal?(0))
                                                                                if (((i += 1)).equal?(args.attr_length))
                                                                                  error_need_argument(flags)
                                                                                end
                                                                                @validity = Long.parse_long(args[i])
                                                                              else
                                                                                if ((Collator.compare(flags, "-file")).equal?(0))
                                                                                  if (((i += 1)).equal?(args.attr_length))
                                                                                    error_need_argument(flags)
                                                                                  end
                                                                                  @filename = RJava.cast_to_string(args[i])
                                                                                else
                                                                                  if ((Collator.compare(flags, "-srckeystore")).equal?(0))
                                                                                    if (((i += 1)).equal?(args.attr_length))
                                                                                      error_need_argument(flags)
                                                                                    end
                                                                                    @srcksfname = RJava.cast_to_string(args[i])
                                                                                  else
                                                                                    if (((Collator.compare(flags, "-provider")).equal?(0)) || ((Collator.compare(flags, "-providerclass")).equal?(0)))
                                                                                      if (((i += 1)).equal?(args.attr_length))
                                                                                        error_need_argument(flags)
                                                                                      end
                                                                                      if ((@providers).nil?)
                                                                                        @providers = HashSet.new(3)
                                                                                      end
                                                                                      provider_class = args[i]
                                                                                      provider_arg = nil
                                                                                      if (args.attr_length > (i + 1))
                                                                                        flags = RJava.cast_to_string(args[i + 1])
                                                                                        if ((Collator.compare(flags, "-providerarg")).equal?(0))
                                                                                          if ((args.attr_length).equal?((i + 2)))
                                                                                            error_need_argument(flags)
                                                                                          end
                                                                                          provider_arg = RJava.cast_to_string(args[i + 2])
                                                                                          i += 2
                                                                                        end
                                                                                      end
                                                                                      @providers.add(Pair.new(provider_class, provider_arg))
                                                                                    # options
                                                                                    else
                                                                                      if ((Collator.compare(flags, "-v")).equal?(0))
                                                                                        @verbose = true
                                                                                      else
                                                                                        if ((Collator.compare(flags, "-debug")).equal?(0))
                                                                                          @debug = true
                                                                                        else
                                                                                          if ((Collator.compare(flags, "-rfc")).equal?(0))
                                                                                            @rfc = true
                                                                                          else
                                                                                            if ((Collator.compare(flags, "-noprompt")).equal?(0))
                                                                                              @noprompt = true
                                                                                            else
                                                                                              if ((Collator.compare(flags, "-trustcacerts")).equal?(0))
                                                                                                @trustcacerts = true
                                                                                              else
                                                                                                if ((Collator.compare(flags, "-protected")).equal?(0) || (Collator.compare(flags, "-destprotected")).equal?(0))
                                                                                                  @protected_path = true
                                                                                                else
                                                                                                  if ((Collator.compare(flags, "-srcprotected")).equal?(0))
                                                                                                    @srcprotected_path = true
                                                                                                  else
                                                                                                    System.err.println(RJava.cast_to_string(Rb.get_string("Illegal option:  ")) + flags)
                                                                                                    tiny_help
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
        i += 1
      end
      if (i < args.attr_length)
        form = MessageFormat.new(Rb.get_string("Usage error, <arg> is not a legal command"))
        source = Array.typed(Object).new([args[i]])
        raise RuntimeException.new(form.format(source))
      end
      if ((@command).equal?(-1))
        System.err.println(Rb.get_string("Usage error: no command provided"))
        tiny_help
      end
    end
    
    typesig { [PrintStream] }
    # Execute the commands.
    def do_commands(out)
      if ((@storetype).nil?)
        @storetype = RJava.cast_to_string(KeyStore.get_default_type)
      end
      @storetype = RJava.cast_to_string(KeyStoreUtil.nice_store_type_name(@storetype))
      if ((@srcstoretype).nil?)
        @srcstoretype = RJava.cast_to_string(KeyStore.get_default_type)
      end
      @srcstoretype = RJava.cast_to_string(KeyStoreUtil.nice_store_type_name(@srcstoretype))
      if (P11KEYSTORE.equals_ignore_case(@storetype) || KeyStoreUtil.is_windows_key_store(@storetype))
        @token = true
        if ((@ksfname).nil?)
          @ksfname = NONE
        end
      end
      if ((NONE == @ksfname))
        @null_stream = true
      end
      if (@token && !@null_stream)
        System.err.println(MessageFormat.format(Rb.get_string("-keystore must be NONE if -storetype is {0}"), @storetype))
        System.err.println
        tiny_help
      end
      if (@token && ((@command).equal?(KEYPASSWD) || (@command).equal?(STOREPASSWD)))
        raise UnsupportedOperationException.new(MessageFormat.format(Rb.get_string("-storepasswd and -keypasswd commands not supported " + "if -storetype is {0}"), @storetype))
      end
      if (P12KEYSTORE.equals_ignore_case(@storetype) && (@command).equal?(KEYPASSWD))
        raise UnsupportedOperationException.new(Rb.get_string("-keypasswd commands not supported " + "if -storetype is PKCS12"))
      end
      if (@token && (!(@key_pass).nil? || !(@new_pass).nil? || !(@dest_key_pass).nil?))
        raise IllegalArgumentException.new(MessageFormat.format(Rb.get_string("-keypass and -new " + "can not be specified if -storetype is {0}"), @storetype))
      end
      if (@protected_path)
        if (!(@store_pass).nil? || !(@key_pass).nil? || !(@new_pass).nil? || !(@dest_key_pass).nil?)
          raise IllegalArgumentException.new(Rb.get_string("if -protected is specified, " + "then -storepass, -keypass, and -new " + "must not be specified"))
        end
      end
      if (@srcprotected_path)
        if (!(@srcstore_pass).nil? || !(@srckey_pass).nil?)
          raise IllegalArgumentException.new(Rb.get_string("if -srcprotected is specified, " + "then -srcstorepass and -srckeypass " + "must not be specified"))
        end
      end
      if (KeyStoreUtil.is_windows_key_store(@storetype))
        if (!(@store_pass).nil? || !(@key_pass).nil? || !(@new_pass).nil? || !(@dest_key_pass).nil?)
          raise IllegalArgumentException.new(Rb.get_string("if keystore is not password protected, " + "then -storepass, -keypass, and -new " + "must not be specified"))
        end
      end
      if (KeyStoreUtil.is_windows_key_store(@srcstoretype))
        if (!(@srcstore_pass).nil? || !(@srckey_pass).nil?)
          raise IllegalArgumentException.new(Rb.get_string("if source keystore is not password protected, " + "then -srcstorepass and -srckeypass " + "must not be specified"))
        end
      end
      if (@validity <= 0)
        raise JavaException.new(Rb.get_string("Validity must be greater than zero"))
      end
      # Try to load and install specified provider
      if (!(@providers).nil?)
        cl = nil
        if (!(@pathlist).nil?)
          path = nil
          path = RJava.cast_to_string(PathList.append_path(path, System.get_property("java.class.path")))
          path = RJava.cast_to_string(PathList.append_path(path, System.get_property("env.class.path")))
          path = RJava.cast_to_string(PathList.append_path(path, @pathlist))
          urls = PathList.path_to_urls(path)
          cl = URLClassLoader.new(urls)
        else
          cl = ClassLoader.get_system_class_loader
        end
        @providers.each do |provider|
          prov_name = provider.attr_fst
          prov_class = nil
          if (!(cl).nil?)
            prov_class = cl.load_class(prov_name)
          else
            prov_class = Class.for_name(prov_name)
          end
          prov_arg = provider.attr_snd
          obj = nil
          if ((prov_arg).nil?)
            obj = prov_class.new_instance
          else
            c = prov_class.get_constructor(PARAM_STRING)
            obj = c.new_instance(prov_arg)
          end
          if (!(obj.is_a?(Provider)))
            form = MessageFormat.new(Rb.get_string("provName not a provider"))
            source = Array.typed(Object).new([prov_name])
            raise JavaException.new(form.format(source))
          end
          Security.add_provider(obj)
        end
      end
      if ((@command).equal?(LIST) && @verbose && @rfc)
        System.err.println(Rb.get_string("Must not specify both -v and -rfc with 'list' command"))
        tiny_help
      end
      # Make sure provided passwords are at least 6 characters long
      if ((@command).equal?(GENKEYPAIR) && !(@key_pass).nil? && @key_pass.attr_length < 6)
        raise JavaException.new(Rb.get_string("Key password must be at least 6 characters"))
      end
      if (!(@new_pass).nil? && @new_pass.attr_length < 6)
        raise JavaException.new(Rb.get_string("New password must be at least 6 characters"))
      end
      if (!(@dest_key_pass).nil? && @dest_key_pass.attr_length < 6)
        raise JavaException.new(Rb.get_string("New password must be at least 6 characters"))
      end
      # Check if keystore exists.
      # If no keystore has been specified at the command line, try to use
      # the default, which is located in $HOME/.keystore.
      # If the command is "genkey", "identitydb", "import", or "printcert",
      # it is OK not to have a keystore.
      if (!(@command).equal?(PRINTCERT))
        if ((@ksfname).nil?)
          @ksfname = RJava.cast_to_string(System.get_property("user.home") + JavaFile.attr_separator) + ".keystore"
        end
        if (!@null_stream)
          begin
            @ksfile = JavaFile.new(@ksfname)
            # Check if keystore file is empty
            if (@ksfile.exists && (@ksfile.length).equal?(0))
              raise JavaException.new(RJava.cast_to_string(Rb.get_string("Keystore file exists, but is empty: ")) + @ksfname)
            end
            @ks_stream = FileInputStream.new(@ksfile)
          rescue FileNotFoundException => e
            if (!(@command).equal?(GENKEYPAIR) && !(@command).equal?(GENSECKEY) && !(@command).equal?(IDENTITYDB) && !(@command).equal?(IMPORTCERT) && !(@command).equal?(IMPORTKEYSTORE))
              raise JavaException.new(RJava.cast_to_string(Rb.get_string("Keystore file does not exist: ")) + @ksfname)
            end
          end
        end
      end
      if (((@command).equal?(KEYCLONE) || (@command).equal?(CHANGEALIAS)) && (@dest).nil?)
        @dest = RJava.cast_to_string(get_alias("destination"))
        if (("" == @dest))
          raise JavaException.new(Rb.get_string("Must specify destination alias"))
        end
      end
      if ((@command).equal?(DELETE) && (@alias).nil?)
        @alias = RJava.cast_to_string(get_alias(nil))
        if (("" == @alias))
          raise JavaException.new(Rb.get_string("Must specify alias"))
        end
      end
      # Create new keystore
      if ((@provider_name).nil?)
        @key_store = KeyStore.get_instance(@storetype)
      else
        @key_store = KeyStore.get_instance(@storetype, @provider_name)
      end
      # Load the keystore data.
      # 
      # At this point, it's OK if no keystore password has been provided.
      # We want to make sure that we can load the keystore data, i.e.,
      # the keystore data has the right format. If we cannot load the
      # keystore, why bother asking the user for his or her password?
      # Only if we were able to load the keystore, and no keystore
      # password has been provided, will we prompt the user for the
      # keystore password to verify the keystore integrity.
      # This means that the keystore is loaded twice: first load operation
      # checks the keystore format, second load operation verifies the
      # keystore integrity.
      # 
      # If the keystore password has already been provided (at the
      # command line), however, the keystore is loaded only once, and the
      # keystore format and integrity are checked "at the same time".
      # 
      # Null stream keystores are loaded later.
      if (!@null_stream)
        @key_store.load(@ks_stream, @store_pass)
        if (!(@ks_stream).nil?)
          @ks_stream.close
        end
      end
      # All commands that create or modify the keystore require a keystore
      # password.
      if (@null_stream && !(@store_pass).nil?)
        @key_store.load(nil, @store_pass)
      else
        if (!@null_stream && !(@store_pass).nil?)
          # If we are creating a new non nullStream-based keystore,
          # insist that the password be at least 6 characters
          if ((@ks_stream).nil? && @store_pass.attr_length < 6)
            raise JavaException.new(Rb.get_string("Keystore password must be at least 6 characters"))
          end
        else
          if ((@store_pass).nil?)
            # only prompt if (protectedPath == false)
            if (!@protected_path && !KeyStoreUtil.is_windows_key_store(@storetype) && ((@command).equal?(CERTREQ) || (@command).equal?(DELETE) || (@command).equal?(GENKEYPAIR) || (@command).equal?(GENSECKEY) || (@command).equal?(IMPORTCERT) || (@command).equal?(IMPORTKEYSTORE) || (@command).equal?(KEYCLONE) || (@command).equal?(CHANGEALIAS) || (@command).equal?(SELFCERT) || (@command).equal?(STOREPASSWD) || (@command).equal?(KEYPASSWD) || (@command).equal?(IDENTITYDB)))
              count = 0
              begin
                if ((@command).equal?(IMPORTKEYSTORE))
                  System.err.print(Rb.get_string("Enter destination keystore password:  "))
                else
                  System.err.print(Rb.get_string("Enter keystore password:  "))
                end
                System.err.flush
                @store_pass = Password.read_password(System.in)
                @passwords.add(@store_pass)
                # If we are creating a new non nullStream-based keystore,
                # insist that the password be at least 6 characters
                if (!@null_stream && ((@store_pass).nil? || @store_pass.attr_length < 6))
                  System.err.println(Rb.get_string("Keystore password is too short - " + "must be at least 6 characters"))
                  @store_pass = nil
                end
                # If the keystore file does not exist and needs to be
                # created, the storepass should be prompted twice.
                if (!(@store_pass).nil? && !@null_stream && (@ks_stream).nil?)
                  System.err.print(Rb.get_string("Re-enter new password: "))
                  store_pass_again = Password.read_password(System.in)
                  @passwords.add(store_pass_again)
                  if (!Arrays.==(@store_pass, store_pass_again))
                    System.err.println(Rb.get_string("They don't match. Try again"))
                    @store_pass = nil
                  end
                end
                count += 1
              end while (((@store_pass).nil?) && count < 3)
              if ((@store_pass).nil?)
                System.err.println(Rb.get_string("Too many failures - try later"))
                return
              end
            else
              if (!@protected_path && !KeyStoreUtil.is_windows_key_store(@storetype) && !((@command).equal?(PRINTCERT)))
                # here we have EXPORTCERT and LIST (info valid until STOREPASSWD)
                System.err.print(Rb.get_string("Enter keystore password:  "))
                System.err.flush
                @store_pass = Password.read_password(System.in)
                @passwords.add(@store_pass)
              end
            end
            # Now load a nullStream-based keystore,
            # or verify the integrity of an input stream-based keystore
            if (@null_stream)
              @key_store.load(nil, @store_pass)
            else
              if (!(@ks_stream).nil?)
                @ks_stream = FileInputStream.new(@ksfile)
                @key_store.load(@ks_stream, @store_pass)
                @ks_stream.close
              end
            end
          end
        end
      end
      if (!(@store_pass).nil? && P12KEYSTORE.equals_ignore_case(@storetype))
        form = MessageFormat.new(Rb.get_string("Warning:  Different store and key passwords not supported " + "for PKCS12 KeyStores. Ignoring user-specified <command> value."))
        if (!(@key_pass).nil? && !Arrays.==(@store_pass, @key_pass))
          source = Array.typed(Object).new(["-keypass"])
          System.err.println(form.format(source))
          @key_pass = @store_pass
        end
        if (!(@new_pass).nil? && !Arrays.==(@store_pass, @new_pass))
          source = Array.typed(Object).new(["-new"])
          System.err.println(form.format(source))
          @new_pass = @store_pass
        end
        if (!(@dest_key_pass).nil? && !Arrays.==(@store_pass, @dest_key_pass))
          source = Array.typed(Object).new(["-destkeypass"])
          System.err.println(form.format(source))
          @dest_key_pass = @store_pass
        end
      end
      # Create a certificate factory
      if ((@command).equal?(PRINTCERT) || (@command).equal?(IMPORTCERT) || (@command).equal?(IDENTITYDB))
        @cf = CertificateFactory.get_instance("X509")
      end
      if (@trustcacerts)
        @caks = get_cacerts_key_store
      end
      # Perform the specified command
      if ((@command).equal?(CERTREQ))
        ps = nil
        if (!(@filename).nil?)
          ps = PrintStream.new(FileOutputStream.new(@filename))
          out = ps
        end
        begin
          do_cert_req(@alias, @sig_alg_name, out)
        ensure
          if (!(ps).nil?)
            ps.close
          end
        end
        if (@verbose && !(@filename).nil?)
          form = MessageFormat.new(Rb.get_string("Certification request stored in file <filename>"))
          source = Array.typed(Object).new([@filename])
          System.err.println(form.format(source))
          System.err.println(Rb.get_string("Submit this to your CA"))
        end
      else
        if ((@command).equal?(DELETE))
          do_delete_entry(@alias)
          @kssave = true
        else
          if ((@command).equal?(EXPORTCERT))
            ps = nil
            if (!(@filename).nil?)
              ps = PrintStream.new(FileOutputStream.new(@filename))
              out = ps
            end
            begin
              do_export_cert(@alias, out)
            ensure
              if (!(ps).nil?)
                ps.close
              end
            end
            if (!(@filename).nil?)
              form = MessageFormat.new(Rb.get_string("Certificate stored in file <filename>"))
              source = Array.typed(Object).new([@filename])
              System.err.println(form.format(source))
            end
          else
            if ((@command).equal?(GENKEYPAIR))
              if ((@key_alg_name).nil?)
                @key_alg_name = "DSA"
              end
              do_gen_key_pair(@alias, @dname, @key_alg_name, @keysize, @sig_alg_name)
              @kssave = true
            else
              if ((@command).equal?(GENSECKEY))
                if ((@key_alg_name).nil?)
                  @key_alg_name = "DES"
                end
                do_gen_secret_key(@alias, @key_alg_name, @keysize)
                @kssave = true
              else
                if ((@command).equal?(IDENTITYDB))
                  in_stream = System.in
                  if (!(@filename).nil?)
                    in_stream = FileInputStream.new(@filename)
                  end
                  begin
                    do_import_identity_database(in_stream)
                  ensure
                    if (!(in_stream).equal?(System.in))
                      in_stream.close
                    end
                  end
                else
                  if ((@command).equal?(IMPORTCERT))
                    in_stream = System.in
                    if (!(@filename).nil?)
                      in_stream = FileInputStream.new(@filename)
                    end
                    begin
                      import_alias = (!(@alias).nil?) ? @alias : @key_alias
                      if (@key_store.entry_instance_of(import_alias, KeyStore::PrivateKeyEntry))
                        @kssave = install_reply(import_alias, in_stream)
                        if (@kssave)
                          System.err.println(Rb.get_string("Certificate reply was installed in keystore"))
                        else
                          System.err.println(Rb.get_string("Certificate reply was not installed in keystore"))
                        end
                      else
                        if (!@key_store.contains_alias(import_alias) || @key_store.entry_instance_of(import_alias, KeyStore::TrustedCertificateEntry))
                          @kssave = add_trusted_cert(import_alias, in_stream)
                          if (@kssave)
                            System.err.println(Rb.get_string("Certificate was added to keystore"))
                          else
                            System.err.println(Rb.get_string("Certificate was not added to keystore"))
                          end
                        end
                      end
                    ensure
                      if (!(in_stream).equal?(System.in))
                        in_stream.close
                      end
                    end
                  else
                    if ((@command).equal?(IMPORTKEYSTORE))
                      do_import_key_store
                      @kssave = true
                    else
                      if ((@command).equal?(KEYCLONE))
                        @key_pass_new = @new_pass
                        # added to make sure only key can go thru
                        if ((@alias).nil?)
                          @alias = @key_alias
                        end
                        if ((@key_store.contains_alias(@alias)).equal?(false))
                          form = MessageFormat.new(Rb.get_string("Alias <alias> does not exist"))
                          source = Array.typed(Object).new([@alias])
                          raise JavaException.new(form.format(source))
                        end
                        if (!@key_store.entry_instance_of(@alias, KeyStore::PrivateKeyEntry))
                          form = MessageFormat.new(Rb.get_string("Alias <alias> references an entry type that is not a private key entry.  " + "The -keyclone command only supports cloning of private key entries"))
                          source = Array.typed(Object).new([@alias])
                          raise JavaException.new(form.format(source))
                        end
                        do_clone_entry(@alias, @dest, true) # Now everything can be cloned
                        @kssave = true
                      else
                        if ((@command).equal?(CHANGEALIAS))
                          if ((@alias).nil?)
                            @alias = @key_alias
                          end
                          do_clone_entry(@alias, @dest, false)
                          # in PKCS11, clone a PrivateKeyEntry will delete the old one
                          if (@key_store.contains_alias(@alias))
                            do_delete_entry(@alias)
                          end
                          @kssave = true
                        else
                          if ((@command).equal?(KEYPASSWD))
                            @key_pass_new = @new_pass
                            do_change_key_passwd(@alias)
                            @kssave = true
                          else
                            if ((@command).equal?(LIST))
                              if (!(@alias).nil?)
                                do_print_entry(@alias, out, true)
                              else
                                do_print_entries(out)
                              end
                            else
                              if ((@command).equal?(PRINTCERT))
                                in_stream = System.in
                                if (!(@filename).nil?)
                                  in_stream = FileInputStream.new(@filename)
                                end
                                begin
                                  do_print_cert(in_stream, out)
                                ensure
                                  if (!(in_stream).equal?(System.in))
                                    in_stream.close
                                  end
                                end
                              else
                                if ((@command).equal?(SELFCERT))
                                  do_self_cert(@alias, @dname, @sig_alg_name)
                                  @kssave = true
                                else
                                  if ((@command).equal?(STOREPASSWD))
                                    @store_pass_new = @new_pass
                                    if ((@store_pass_new).nil?)
                                      @store_pass_new = get_new_passwd("keystore password", @store_pass)
                                    end
                                    @kssave = true
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
      # If we need to save the keystore, do so.
      if (@kssave)
        if (@verbose)
          form = MessageFormat.new(Rb.get_string("[Storing ksfname]"))
          source = Array.typed(Object).new([@null_stream ? "keystore" : @ksfname])
          System.err.println(form.format(source))
        end
        if (@token)
          @key_store.store(nil, nil)
        else
          fout = nil
          begin
            fout = (@null_stream ? nil : FileOutputStream.new(@ksfname))
            @key_store.store(fout, (!(@store_pass_new).nil?) ? @store_pass_new : @store_pass)
          ensure
            if (!(fout).nil?)
              fout.close
            end
          end
        end
      end
    end
    
    typesig { [String, String, PrintStream] }
    # Creates a PKCS#10 cert signing request, corresponding to the
    # keys (and name) associated with a given alias.
    def do_cert_req(alias_, sig_alg_name, out)
      if ((alias_).nil?)
        alias_ = @key_alias
      end
      objs = recover_key(alias_, @store_pass, @key_pass)
      priv_key = objs[0]
      if ((@key_pass).nil?)
        @key_pass = objs[1]
      end
      cert = @key_store.get_certificate(alias_)
      if ((cert).nil?)
        form = MessageFormat.new(Rb.get_string("alias has no public key (certificate)"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      request = PKCS10.new(cert.get_public_key)
      # Construct an X500Signer object, so that we can sign the request
      if ((sig_alg_name).nil?)
        # If no signature algorithm was specified at the command line,
        # we choose one that is compatible with the selected private key
        key_alg_name = priv_key.get_algorithm
        if ("DSA".equals_ignore_case(key_alg_name) || "DSS".equals_ignore_case(key_alg_name))
          sig_alg_name = "SHA1WithDSA"
        else
          if ("RSA".equals_ignore_case(key_alg_name))
            sig_alg_name = "SHA1WithRSA"
          else
            raise JavaException.new(Rb.get_string("Cannot derive signature algorithm"))
          end
        end
      end
      signature = Signature.get_instance(sig_alg_name)
      signature.init_sign(priv_key)
      subject = X500Name.new((cert).get_subject_dn.to_s)
      signer = X500Signer.new(signature, subject)
      # Sign the request and base-64 encode it
      request.encode_and_sign(signer)
      request.print(out)
    end
    
    typesig { [String] }
    # Deletes an entry from the keystore.
    def do_delete_entry(alias_)
      if ((@key_store.contains_alias(alias_)).equal?(false))
        form = MessageFormat.new(Rb.get_string("Alias <alias> does not exist"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      @key_store.delete_entry(alias_)
    end
    
    typesig { [String, PrintStream] }
    # Exports a certificate from the keystore.
    def do_export_cert(alias_, out)
      if ((@store_pass).nil? && !KeyStoreUtil.is_windows_key_store(@storetype))
        print_warning
      end
      if ((alias_).nil?)
        alias_ = @key_alias
      end
      if ((@key_store.contains_alias(alias_)).equal?(false))
        form = MessageFormat.new(Rb.get_string("Alias <alias> does not exist"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      cert = @key_store.get_certificate(alias_)
      if ((cert).nil?)
        form = MessageFormat.new(Rb.get_string("Alias <alias> has no certificate"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      dump_cert(cert, out)
    end
    
    typesig { [String, String, Array.typed(::Java::Char)] }
    # Prompt the user for a keypass when generating a key entry.
    # @param alias the entry we will set password for
    # @param orig the original entry of doing a dup, null if generate new
    # @param origPass the password to copy from if user press ENTER
    def prompt_for_key_pass(alias_, orig, orig_pass)
      if (P12KEYSTORE.equals_ignore_case(@storetype))
        return orig_pass
      else
        if (!@token)
          # Prompt for key password
          count = 0
          count = 0
          while count < 3
            form = MessageFormat.new(Rb.get_string("Enter key password for <alias>"))
            source = Array.typed(Object).new([alias_])
            System.err.println(form.format(source))
            if ((orig).nil?)
              System.err.print(Rb.get_string("\t(RETURN if same as keystore password):  "))
            else
              form = MessageFormat.new(Rb.get_string("\t(RETURN if same as for <otherAlias>)"))
              src = Array.typed(Object).new([orig])
              System.err.print(form.format(src))
            end
            System.err.flush
            entered = Password.read_password(System.in)
            @passwords.add(entered)
            if ((entered).nil?)
              return orig_pass
            else
              if (entered.attr_length >= 6)
                System.err.print(Rb.get_string("Re-enter new password: "))
                pass_again = Password.read_password(System.in)
                @passwords.add(pass_again)
                if (!Arrays.==(entered, pass_again))
                  System.err.println(Rb.get_string("They don't match. Try again"))
                  count += 1
                  next
                end
                return entered
              else
                System.err.println(Rb.get_string("Key password is too short - must be at least 6 characters"))
              end
            end
            count += 1
          end
          if ((count).equal?(3))
            if ((@command).equal?(KEYCLONE))
              raise JavaException.new(Rb.get_string("Too many failures. Key entry not cloned"))
            else
              raise JavaException.new(Rb.get_string("Too many failures - key not added to keystore"))
            end
          end
        end
      end
      return nil # PKCS11
    end
    
    typesig { [String, String, ::Java::Int] }
    # Creates a new secret key.
    def do_gen_secret_key(alias_, key_alg_name, keysize)
      if ((alias_).nil?)
        alias_ = @key_alias
      end
      if (@key_store.contains_alias(alias_))
        form = MessageFormat.new(Rb.get_string("Secret key not generated, alias <alias> already exists"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      sec_key = nil
      keygen = KeyGenerator.get_instance(key_alg_name)
      if (!(keysize).equal?(-1))
        keygen.init(keysize)
      else
        if ("DES".equals_ignore_case(key_alg_name))
          keygen.init(56)
        else
          if ("DESede".equals_ignore_case(key_alg_name))
            keygen.init(168)
          else
            raise JavaException.new(Rb.get_string("Please provide -keysize for secret key generation"))
          end
        end
      end
      sec_key = keygen.generate_key
      if ((@key_pass).nil?)
        @key_pass = prompt_for_key_pass(alias_, nil, @store_pass)
      end
      @key_store.set_key_entry(alias_, sec_key, @key_pass, nil)
    end
    
    typesig { [String, String, String, ::Java::Int, String] }
    # Creates a new key pair and self-signed certificate.
    def do_gen_key_pair(alias_, dname, key_alg_name, keysize, sig_alg_name)
      if ((keysize).equal?(-1))
        if ("EC".equals_ignore_case(key_alg_name))
          keysize = 256
        else
          keysize = 1024
        end
      end
      if ((alias_).nil?)
        alias_ = @key_alias
      end
      if (@key_store.contains_alias(alias_))
        form = MessageFormat.new(Rb.get_string("Key pair not generated, alias <alias> already exists"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      if ((sig_alg_name).nil?)
        if ("DSA".equals_ignore_case(key_alg_name))
          sig_alg_name = "SHA1WithDSA"
        else
          if ("RSA".equals_ignore_case(key_alg_name))
            sig_alg_name = "SHA1WithRSA"
          else
            if ("EC".equals_ignore_case(key_alg_name))
              sig_alg_name = "SHA1withECDSA"
            else
              raise JavaException.new(Rb.get_string("Cannot derive signature algorithm"))
            end
          end
        end
      end
      keypair = CertAndKeyGen.new(key_alg_name, sig_alg_name, @provider_name)
      # If DN is provided, parse it. Otherwise, prompt the user for it.
      x500name = nil
      if ((dname).nil?)
        x500name = get_x500name
      else
        x500name = X500Name.new(dname)
      end
      keypair.generate(keysize)
      priv_key = keypair.get_private_key
      chain = Array.typed(X509Certificate).new(1) { nil }
      chain[0] = keypair.get_self_certificate(x500name, get_start_date(@start_date), @validity * 24 * 60 * 60)
      if (@verbose)
        form = MessageFormat.new(Rb.get_string("Generating keysize bit keyAlgName key pair and self-signed certificate " + "(sigAlgName) with a validity of validality days\n\tfor: x500Name"))
        source = Array.typed(Object).new([keysize, priv_key.get_algorithm, chain[0].get_sig_alg_name, Long.new(@validity), x500name])
        System.err.println(form.format(source))
      end
      if ((@key_pass).nil?)
        @key_pass = prompt_for_key_pass(alias_, nil, @store_pass)
      end
      @key_store.set_key_entry(alias_, priv_key, @key_pass, chain)
    end
    
    typesig { [String, String, ::Java::Boolean] }
    # Clones an entry
    # @param orig original alias
    # @param dest destination alias
    # @changePassword if the password can be changed
    def do_clone_entry(orig, dest, change_password)
      if ((orig).nil?)
        orig = @key_alias
      end
      if (@key_store.contains_alias(dest))
        form = MessageFormat.new(Rb.get_string("Destination alias <dest> already exists"))
        source = Array.typed(Object).new([dest])
        raise JavaException.new(form.format(source))
      end
      objs = recover_entry(@key_store, orig, @store_pass, @key_pass)
      entry = objs[0]
      @key_pass = objs[1]
      pp = nil
      if (!(@key_pass).nil?)
        # protected
        if (!change_password || P12KEYSTORE.equals_ignore_case(@storetype))
          @key_pass_new = @key_pass
        else
          if ((@key_pass_new).nil?)
            @key_pass_new = prompt_for_key_pass(dest, orig, @key_pass)
          end
        end
        pp = PasswordProtection.new(@key_pass_new)
      end
      @key_store.set_entry(dest, entry, pp)
    end
    
    typesig { [String] }
    # Changes a key password.
    def do_change_key_passwd(alias_)
      if ((alias_).nil?)
        alias_ = @key_alias
      end
      objs = recover_key(alias_, @store_pass, @key_pass)
      priv_key = objs[0]
      if ((@key_pass).nil?)
        @key_pass = objs[1]
      end
      if ((@key_pass_new).nil?)
        form = MessageFormat.new(Rb.get_string("key password for <alias>"))
        source = Array.typed(Object).new([alias_])
        @key_pass_new = get_new_passwd(form.format(source), @key_pass)
      end
      @key_store.set_key_entry(alias_, priv_key, @key_pass_new, @key_store.get_certificate_chain(alias_))
    end
    
    typesig { [InputStream] }
    # Imports a JDK 1.1-style identity database. We can only store one
    # certificate per identity, because we use the identity's name as the
    # alias (which references a keystore entry), and aliases must be unique.
    def do_import_identity_database(in_)
      encoded = nil
      bais = nil
      new_cert = nil
      chain = nil
      priv_key = nil
      modified = false
      idb = IdentityDatabase.from_stream(in_)
      enum_ = idb.identities
      while enum_.has_more_elements
        id = enum_.next_element
        new_cert = nil
        # only store trusted identities in keystore
        if ((id.is_a?(SystemSigner) && (id).is_trusted) || (id.is_a?(SystemIdentity) && (id).is_trusted))
          # ignore if keystore entry with same alias name already exists
          if (@key_store.contains_alias(id.get_name))
            form = MessageFormat.new(Rb.get_string("Keystore entry for <id.getName()> already exists"))
            source = Array.typed(Object).new([id.get_name])
            System.err.println(form.format(source))
            next
          end
          certs = id.certificates
          if (!(certs).nil? && certs.attr_length > 0)
            # we can only store one user cert per identity.
            # convert old-style to new-style cert via the encoding
            dos = DerOutputStream.new
            certs[0].encode(dos)
            encoded = dos.to_byte_array
            bais = ByteArrayInputStream.new(encoded)
            new_cert = @cf.generate_certificate(bais)
            bais.close
            # if certificate is self-signed, make sure it verifies
            if (is_self_signed(new_cert))
              pub_key = new_cert.get_public_key
              begin
                new_cert.verify(pub_key)
              rescue JavaException => e
                # ignore this cert
                next
              end
            end
            if (id.is_a?(SystemSigner))
              form = MessageFormat.new(Rb.get_string("Creating keystore entry for <id.getName()> ..."))
              source = Array.typed(Object).new([id.get_name])
              System.err.println(form.format(source))
              if ((chain).nil?)
                chain = Array.typed(Java::Security::Cert::Certificate).new(1) { nil }
              end
              chain[0] = new_cert
              priv_key = (id).get_private_key
              @key_store.set_key_entry(id.get_name, priv_key, @store_pass, chain)
            else
              @key_store.set_certificate_entry(id.get_name, new_cert)
            end
            @kssave = true
          end
        end
      end
      if (!@kssave)
        System.err.println(Rb.get_string("No entries from identity database added"))
      end
    end
    
    typesig { [String, PrintStream, ::Java::Boolean] }
    # Prints a single keystore entry.
    def do_print_entry(alias_, out, print_warning_)
      if ((@store_pass).nil? && print_warning_ && !KeyStoreUtil.is_windows_key_store(@storetype))
        print_warning
      end
      if ((@key_store.contains_alias(alias_)).equal?(false))
        form = MessageFormat.new(Rb.get_string("Alias <alias> does not exist"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      if (@verbose || @rfc || @debug)
        form = MessageFormat.new(Rb.get_string("Alias name: alias"))
        source = Array.typed(Object).new([alias_])
        out.println(form.format(source))
        if (!@token)
          form = MessageFormat.new(Rb.get_string("Creation date: keyStore.getCreationDate(alias)"))
          src = Array.typed(Object).new([@key_store.get_creation_date(alias_)])
          out.println(form.format(src))
        end
      else
        if (!@token)
          form = MessageFormat.new(Rb.get_string("alias, keyStore.getCreationDate(alias), "))
          source = Array.typed(Object).new([alias_, @key_store.get_creation_date(alias_)])
          out.print(form.format(source))
        else
          form = MessageFormat.new(Rb.get_string("alias, "))
          source = Array.typed(Object).new([alias_])
          out.print(form.format(source))
        end
      end
      if (@key_store.entry_instance_of(alias_, KeyStore::SecretKeyEntry))
        if (@verbose || @rfc || @debug)
          source = Array.typed(Object).new(["SecretKeyEntry"])
          out.println(MessageFormat.new(Rb.get_string("Entry type: <type>")).format(source))
        else
          out.println("SecretKeyEntry, ")
        end
      else
        if (@key_store.entry_instance_of(alias_, KeyStore::PrivateKeyEntry))
          if (@verbose || @rfc || @debug)
            source = Array.typed(Object).new(["PrivateKeyEntry"])
            out.println(MessageFormat.new(Rb.get_string("Entry type: <type>")).format(source))
          else
            out.println("PrivateKeyEntry, ")
          end
          # Get the chain
          chain = @key_store.get_certificate_chain(alias_)
          if (!(chain).nil?)
            if (@verbose || @rfc || @debug)
              out.println(Rb.get_string("Certificate chain length: ") + chain.attr_length)
              i = 0
              while i < chain.attr_length
                form = MessageFormat.new(Rb.get_string("Certificate[(i + 1)]:"))
                source = Array.typed(Object).new([(i + 1)])
                out.println(form.format(source))
                if (@verbose && (chain[i].is_a?(X509Certificate)))
                  print_x509cert((chain[i]), out)
                else
                  if (@debug)
                    out.println(chain[i].to_s)
                  else
                    dump_cert(chain[i], out)
                  end
                end
                i += 1
              end
            else
              # Print the digest of the user cert only
              out.println(Rb.get_string("Certificate fingerprint (MD5): ") + get_cert_finger_print("MD5", chain[0]))
            end
          end
        else
          if (@key_store.entry_instance_of(alias_, KeyStore::TrustedCertificateEntry))
            # We have a trusted certificate entry
            cert = @key_store.get_certificate(alias_)
            if (@verbose && (cert.is_a?(X509Certificate)))
              out.println(Rb.get_string("Entry type: trustedCertEntry\n"))
              print_x509cert(cert, out)
            else
              if (@rfc)
                out.println(Rb.get_string("Entry type: trustedCertEntry\n"))
                dump_cert(cert, out)
              else
                if (@debug)
                  out.println(cert.to_s)
                else
                  out.println(Rb.get_string("trustedCertEntry,"))
                  out.println(Rb.get_string("Certificate fingerprint (MD5): ") + get_cert_finger_print("MD5", cert))
                end
              end
            end
          else
            out.println(Rb.get_string("Unknown Entry Type"))
          end
        end
      end
    end
    
    typesig { [] }
    # Load the srckeystore from a stream, used in -importkeystore
    # @returns the src KeyStore
    def load_source_key_store
      is_pkcs11 = false
      is = nil
      if (P11KEYSTORE.equals_ignore_case(@srcstoretype) || KeyStoreUtil.is_windows_key_store(@srcstoretype))
        if (!(NONE == @srcksfname))
          System.err.println(MessageFormat.format(Rb.get_string("-keystore must be NONE if -storetype is {0}"), @srcstoretype))
          System.err.println
          tiny_help
        end
        is_pkcs11 = true
      else
        if (!(@srcksfname).nil?)
          srcksfile = JavaFile.new(@srcksfname)
          if (srcksfile.exists && (srcksfile.length).equal?(0))
            raise JavaException.new(RJava.cast_to_string(Rb.get_string("Source keystore file exists, but is empty: ")) + @srcksfname)
          end
          is = FileInputStream.new(srcksfile)
        else
          raise JavaException.new(Rb.get_string("Please specify -srckeystore"))
        end
      end
      store_ = nil
      begin
        if ((@src_provider_name).nil?)
          store_ = KeyStore.get_instance(@srcstoretype)
        else
          store_ = KeyStore.get_instance(@srcstoretype, @src_provider_name)
        end
        if ((@srcstore_pass).nil? && !@srcprotected_path && !KeyStoreUtil.is_windows_key_store(@srcstoretype))
          System.err.print(Rb.get_string("Enter source keystore password:  "))
          System.err.flush
          @srcstore_pass = Password.read_password(System.in)
          @passwords.add(@srcstore_pass)
        end
        # always let keypass be storepass when using pkcs12
        if (P12KEYSTORE.equals_ignore_case(@srcstoretype))
          if (!(@srckey_pass).nil? && !(@srcstore_pass).nil? && !Arrays.==(@srcstore_pass, @srckey_pass))
            form = MessageFormat.new(Rb.get_string("Warning:  Different store and key passwords not supported " + "for PKCS12 KeyStores. Ignoring user-specified <command> value."))
            source = Array.typed(Object).new(["-srckeypass"])
            System.err.println(form.format(source))
            @srckey_pass = @srcstore_pass
          end
        end
        store_.load(is, @srcstore_pass) # "is" already null in PKCS11
      ensure
        if (!(is).nil?)
          is.close
        end
      end
      if ((@srcstore_pass).nil? && !KeyStoreUtil.is_windows_key_store(@srcstoretype))
        # anti refactoring, copied from printWarning(),
        # but change 2 lines
        System.err.println
        System.err.println(Rb.get_string("*****************  WARNING WARNING WARNING  *****************"))
        System.err.println(Rb.get_string("* The integrity of the information stored in the srckeystore*"))
        System.err.println(Rb.get_string("* has NOT been verified!  In order to verify its integrity, *"))
        System.err.println(Rb.get_string("* you must provide the srckeystore password.                *"))
        System.err.println(Rb.get_string("*****************  WARNING WARNING WARNING  *****************"))
        System.err.println
      end
      return store_
    end
    
    typesig { [] }
    # import all keys and certs from importkeystore.
    # keep alias unchanged if no name conflict, otherwise, prompt.
    # keep keypass unchanged for keys
    def do_import_key_store
      if (!(@alias).nil?)
        do_import_key_store_single(load_source_key_store, @alias)
      else
        if (!(@dest).nil? || !(@srckey_pass).nil? || !(@dest_key_pass).nil?)
          raise JavaException.new(Rb.get_string("if alias not specified, destalias, srckeypass, " + "and destkeypass must not be specified"))
        end
        do_import_key_store_all(load_source_key_store)
      end
      # Information display rule of -importkeystore
      # 1. inside single, shows failure
      # 2. inside all, shows sucess
      # 3. inside all where there is a failure, prompt for continue
      # 4. at the final of all, shows summary
    end
    
    typesig { [KeyStore, String] }
    # Import a single entry named alias from srckeystore
    # @returns 1 if the import action succeed
    # 0 if user choose to ignore an alias-dumplicated entry
    # 2 if setEntry throws Exception
    def do_import_key_store_single(srckeystore, alias_)
      new_alias = ((@dest).nil?) ? alias_ : @dest
      if (@key_store.contains_alias(new_alias))
        source = Array.typed(Object).new([alias_])
        if (@noprompt)
          System.err.println(MessageFormat.new(Rb.get_string("Warning: Overwriting existing alias <alias> in destination keystore")).format(source))
        else
          reply = get_yes_no_reply(MessageFormat.new(Rb.get_string("Existing entry alias <alias> exists, overwrite? [no]:  ")).format(source))
          if (("NO" == reply))
            new_alias = RJava.cast_to_string(input_string_from_stdin(Rb.get_string("Enter new alias name\t(RETURN to cancel import for this entry):  ")))
            if (("" == new_alias))
              System.err.println(MessageFormat.new(Rb.get_string("Entry for alias <alias> not imported.")).format(source))
              return 0
            end
          end
        end
      end
      objs = recover_entry(srckeystore, alias_, @srcstore_pass, @srckey_pass)
      entry = objs[0]
      pp = nil
      # According to keytool.html, "The destination entry will be protected
      # using destkeypass. If destkeypass is not provided, the destination
      # entry will be protected with the source entry password."
      # so always try to protect with destKeyPass.
      if (!(@dest_key_pass).nil?)
        pp = PasswordProtection.new(@dest_key_pass)
      else
        if (!(objs[1]).nil?)
          pp = PasswordProtection.new(objs[1])
        end
      end
      begin
        @key_store.set_entry(new_alias, entry, pp)
        return 1
      rescue KeyStoreException => kse
        source2 = Array.typed(Object).new([alias_, kse.to_s])
        form = MessageFormat.new(Rb.get_string("Problem importing entry for alias <alias>: <exception>.\nEntry for alias <alias> not imported."))
        System.err.println(form.format(source2))
        return 2
      end
    end
    
    typesig { [KeyStore] }
    def do_import_key_store_all(srckeystore)
      ok = 0
      count = srckeystore.size
      e = srckeystore.aliases
      while e.has_more_elements
        alias_ = e.next_element
        result = do_import_key_store_single(srckeystore, alias_)
        if ((result).equal?(1))
          ok += 1
          source = Array.typed(Object).new([alias_])
          form = MessageFormat.new(Rb.get_string("Entry for alias <alias> successfully imported."))
          System.err.println(form.format(source))
        else
          if ((result).equal?(2))
            if (!@noprompt)
              reply = get_yes_no_reply("Do you want to quit the import process? [no]:  ")
              if (("YES" == reply))
                break
              end
            end
          end
        end
      end
      source = Array.typed(Object).new([ok, count - ok])
      form = MessageFormat.new(Rb.get_string("Import command completed:  <ok> entries successfully imported, <fail> entries failed or cancelled"))
      System.err.println(form.format(source))
    end
    
    typesig { [PrintStream] }
    # Prints all keystore entries.
    def do_print_entries(out)
      if ((@store_pass).nil? && !KeyStoreUtil.is_windows_key_store(@storetype))
        print_warning
      else
        out.println
      end
      out.println(Rb.get_string("Keystore type: ") + @key_store.get_type)
      out.println(Rb.get_string("Keystore provider: ") + @key_store.get_provider.get_name)
      out.println
      form = nil
      form = ((@key_store.size).equal?(1)) ? MessageFormat.new(Rb.get_string("Your keystore contains keyStore.size() entry")) : MessageFormat.new(Rb.get_string("Your keystore contains keyStore.size() entries"))
      source = Array.typed(Object).new([@key_store.size])
      out.println(form.format(source))
      out.println
      e = @key_store.aliases
      while e.has_more_elements
        alias_ = e.next_element
        do_print_entry(alias_, out, false)
        if (@verbose || @rfc)
          out.println(Rb.get_string("\n"))
          out.println(Rb.get_string("*******************************************"))
          out.println(Rb.get_string("*******************************************\n\n"))
        end
      end
    end
    
    typesig { [InputStream, PrintStream] }
    # Reads a certificate (or certificate chain) and prints its contents in
    # a human readbable format.
    def do_print_cert(in_, out)
      c = nil
      begin
        c = @cf.generate_certificates(in_)
      rescue CertificateException => ce
        raise JavaException.new(Rb.get_string("Failed to parse input"), ce)
      end
      if (c.is_empty)
        raise JavaException.new(Rb.get_string("Empty input"))
      end
      certs = c.to_array(Array.typed(Certificate).new(c.size) { nil })
      i = 0
      while i < certs.attr_length
        x509cert = nil
        begin
          x509cert = certs[i]
        rescue ClassCastException => cce
          raise JavaException.new(Rb.get_string("Not X.509 certificate"))
        end
        if (certs.attr_length > 1)
          form = MessageFormat.new(Rb.get_string("Certificate[(i + 1)]:"))
          source = Array.typed(Object).new([i + 1])
          out.println(form.format(source))
        end
        print_x509cert(x509cert, out)
        if (i < (certs.attr_length - 1))
          out.println
        end
        i += 1
      end
    end
    
    typesig { [String, String, String] }
    # Creates a self-signed certificate, and stores it as a single-element
    # certificate chain.
    def do_self_cert(alias_, dname, sig_alg_name)
      if ((alias_).nil?)
        alias_ = @key_alias
      end
      objs = recover_key(alias_, @store_pass, @key_pass)
      priv_key = objs[0]
      if ((@key_pass).nil?)
        @key_pass = objs[1]
      end
      # Determine the signature algorithm
      if ((sig_alg_name).nil?)
        # If no signature algorithm was specified at the command line,
        # we choose one that is compatible with the selected private key
        key_alg_name = priv_key.get_algorithm
        if ("DSA".equals_ignore_case(key_alg_name) || "DSS".equals_ignore_case(key_alg_name))
          sig_alg_name = "SHA1WithDSA"
        else
          if ("RSA".equals_ignore_case(key_alg_name))
            sig_alg_name = "SHA1WithRSA"
          else
            if ("EC".equals_ignore_case(key_alg_name))
              sig_alg_name = "SHA1withECDSA"
            else
              raise JavaException.new(Rb.get_string("Cannot derive signature algorithm"))
            end
          end
        end
      end
      # Get the old certificate
      old_cert = @key_store.get_certificate(alias_)
      if ((old_cert).nil?)
        form = MessageFormat.new(Rb.get_string("alias has no public key"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      if (!(old_cert.is_a?(X509Certificate)))
        form = MessageFormat.new(Rb.get_string("alias has no X.509 certificate"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      # convert to X509CertImpl, so that we can modify selected fields
      # (no public APIs available yet)
      encoded = old_cert.get_encoded
      cert_impl = X509CertImpl.new(encoded)
      cert_info = cert_impl.get(RJava.cast_to_string(X509CertImpl::NAME) + "." + RJava.cast_to_string(X509CertImpl::INFO))
      # Extend its validity
      first_date = get_start_date(@start_date)
      last_date = JavaDate.new
      last_date.set_time(first_date.get_time + @validity * 1000 * 24 * 60 * 60)
      interval = CertificateValidity.new(first_date, last_date)
      cert_info.set(X509CertInfo::VALIDITY, interval)
      # Make new serial number
      cert_info.set(X509CertInfo::SERIAL_NUMBER, CertificateSerialNumber.new(RJava.cast_to_int((first_date.get_time / 1000))))
      # Set owner and issuer fields
      owner = nil
      if ((dname).nil?)
        # Get the owner name from the certificate
        owner = cert_info.get(RJava.cast_to_string(X509CertInfo::SUBJECT) + "." + RJava.cast_to_string(CertificateSubjectName::DN_NAME))
      else
        # Use the owner name specified at the command line
        owner = X500Name.new(dname)
        cert_info.set(RJava.cast_to_string(X509CertInfo::SUBJECT) + "." + RJava.cast_to_string(CertificateSubjectName::DN_NAME), owner)
      end
      # Make issuer same as owner (self-signed!)
      cert_info.set(RJava.cast_to_string(X509CertInfo::ISSUER) + "." + RJava.cast_to_string(CertificateIssuerName::DN_NAME), owner)
      # The inner and outer signature algorithms have to match.
      # The way we achieve that is really ugly, but there seems to be no
      # other solution: We first sign the cert, then retrieve the
      # outer sigalg and use it to set the inner sigalg
      new_cert = X509CertImpl.new(cert_info)
      new_cert.sign(priv_key, sig_alg_name)
      sig_algid = new_cert.get(X509CertImpl::SIG_ALG)
      cert_info.set(RJava.cast_to_string(CertificateAlgorithmId::NAME) + "." + RJava.cast_to_string(CertificateAlgorithmId::ALGORITHM), sig_algid)
      # first upgrade to version 3
      cert_info.set(X509CertInfo::VERSION, CertificateVersion.new(CertificateVersion::V3))
      # Sign the new certificate
      new_cert = X509CertImpl.new(cert_info)
      new_cert.sign(priv_key, sig_alg_name)
      # Store the new certificate as a single-element certificate chain
      @key_store.set_key_entry(alias_, priv_key, (!(@key_pass).nil?) ? @key_pass : @store_pass, Array.typed(Certificate).new([new_cert]))
      if (@verbose)
        System.err.println(Rb.get_string("New certificate (self-signed):"))
        System.err.print(new_cert.to_s)
        System.err.println
      end
    end
    
    typesig { [String, InputStream] }
    # Processes a certificate reply from a certificate authority.
    # 
    # <p>Builds a certificate chain on top of the certificate reply,
    # using trusted certificates from the keystore. The chain is complete
    # after a self-signed certificate has been encountered. The self-signed
    # certificate is considered a root certificate authority, and is stored
    # at the end of the chain.
    # 
    # <p>The newly generated chain replaces the old chain associated with the
    # key entry.
    # 
    # @return true if the certificate reply was installed, otherwise false.
    def install_reply(alias_, in_)
      if ((alias_).nil?)
        alias_ = @key_alias
      end
      objs = recover_key(alias_, @store_pass, @key_pass)
      priv_key = objs[0]
      if ((@key_pass).nil?)
        @key_pass = objs[1]
      end
      user_cert = @key_store.get_certificate(alias_)
      if ((user_cert).nil?)
        form = MessageFormat.new(Rb.get_string("alias has no public key (certificate)"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      # Read the certificates in the reply
      c = @cf.generate_certificates(in_)
      if (c.is_empty)
        raise JavaException.new(Rb.get_string("Reply has no certificates"))
      end
      reply_certs = c.to_array(Array.typed(Certificate).new(c.size) { nil })
      new_chain = nil
      if ((reply_certs.attr_length).equal?(1))
        # single-cert reply
        new_chain = establish_cert_chain(user_cert, reply_certs[0])
      else
        # cert-chain reply (e.g., PKCS#7)
        new_chain = validate_reply(alias_, user_cert, reply_certs)
      end
      # Now store the newly established chain in the keystore. The new
      # chain replaces the old one.
      if (!(new_chain).nil?)
        @key_store.set_key_entry(alias_, priv_key, (!(@key_pass).nil?) ? @key_pass : @store_pass, new_chain)
        return true
      else
        return false
      end
    end
    
    typesig { [String, InputStream] }
    # Imports a certificate and adds it to the list of trusted certificates.
    # 
    # @return true if the certificate was added, otherwise false.
    def add_trusted_cert(alias_, in_)
      if ((alias_).nil?)
        raise JavaException.new(Rb.get_string("Must specify alias"))
      end
      if (@key_store.contains_alias(alias_))
        form = MessageFormat.new(Rb.get_string("Certificate not imported, alias <alias> already exists"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      # Read the certificate
      cert = nil
      begin
        cert = @cf.generate_certificate(in_)
      rescue ClassCastException => cce
        raise JavaException.new(Rb.get_string("Input not an X.509 certificate"))
      rescue CertificateException => ce
        raise JavaException.new(Rb.get_string("Input not an X.509 certificate"))
      end
      # if certificate is self-signed, make sure it verifies
      self_signed = false
      if (is_self_signed(cert))
        cert.verify(cert.get_public_key)
        self_signed = true
      end
      if (@noprompt)
        @key_store.set_certificate_entry(alias_, cert)
        return true
      end
      # check if cert already exists in keystore
      reply = nil
      trustalias = @key_store.get_certificate_alias(cert)
      if (!(trustalias).nil?)
        form = MessageFormat.new(Rb.get_string("Certificate already exists in keystore under alias <trustalias>"))
        source = Array.typed(Object).new([trustalias])
        System.err.println(form.format(source))
        reply = RJava.cast_to_string(get_yes_no_reply(Rb.get_string("Do you still want to add it? [no]:  ")))
      else
        if (self_signed)
          if (@trustcacerts && (!(@caks).nil?) && (!((trustalias = RJava.cast_to_string(@caks.get_certificate_alias(cert)))).nil?))
            form = MessageFormat.new(Rb.get_string("Certificate already exists in system-wide CA keystore under alias <trustalias>"))
            source = Array.typed(Object).new([trustalias])
            System.err.println(form.format(source))
            reply = RJava.cast_to_string(get_yes_no_reply(Rb.get_string("Do you still want to add it to your own keystore? [no]:  ")))
          end
          if ((trustalias).nil?)
            # Print the cert and ask user if they really want to add
            # it to their keystore
            print_x509cert(cert, System.out)
            reply = RJava.cast_to_string(get_yes_no_reply(Rb.get_string("Trust this certificate? [no]:  ")))
          end
        end
      end
      if (!(reply).nil?)
        if (("YES" == reply))
          @key_store.set_certificate_entry(alias_, cert)
          return true
        else
          return false
        end
      end
      # Try to establish trust chain
      begin
        chain = establish_cert_chain(nil, cert)
        if (!(chain).nil?)
          @key_store.set_certificate_entry(alias_, cert)
          return true
        end
      rescue JavaException => e
        # Print the cert and ask user if they really want to add it to
        # their keystore
        print_x509cert(cert, System.out)
        reply = RJava.cast_to_string(get_yes_no_reply(Rb.get_string("Trust this certificate? [no]:  ")))
        if (("YES" == reply))
          @key_store.set_certificate_entry(alias_, cert)
          return true
        else
          return false
        end
      end
      return false
    end
    
    typesig { [String, Array.typed(::Java::Char)] }
    # Prompts user for new password. New password must be different from
    # old one.
    # 
    # @param prompt the message that gets prompted on the screen
    # @param oldPasswd the current (i.e., old) password
    def get_new_passwd(prompt, old_passwd)
      entered = nil
      reentered = nil
      count = 0
      while count < 3
        form = MessageFormat.new(Rb.get_string("New prompt: "))
        source = Array.typed(Object).new([prompt])
        System.err.print(form.format(source))
        entered = Password.read_password(System.in)
        @passwords.add(entered)
        if ((entered).nil? || entered.attr_length < 6)
          System.err.println(Rb.get_string("Password is too short - must be at least 6 characters"))
        else
          if (Arrays.==(entered, old_passwd))
            System.err.println(Rb.get_string("Passwords must differ"))
          else
            form = MessageFormat.new(Rb.get_string("Re-enter new prompt: "))
            src = Array.typed(Object).new([prompt])
            System.err.print(form.format(src))
            reentered = Password.read_password(System.in)
            @passwords.add(reentered)
            if (!Arrays.==(entered, reentered))
              System.err.println(Rb.get_string("They don't match. Try again"))
            else
              Arrays.fill(reentered, Character.new(?\s.ord))
              return entered
            end
          end
        end
        if (!(entered).nil?)
          Arrays.fill(entered, Character.new(?\s.ord))
          entered = nil
        end
        if (!(reentered).nil?)
          Arrays.fill(reentered, Character.new(?\s.ord))
          reentered = nil
        end
        count += 1
      end
      raise JavaException.new(Rb.get_string("Too many failures - try later"))
    end
    
    typesig { [String] }
    # Prompts user for alias name.
    # @param prompt the {0} of "Enter {0} alias name:  " in prompt line
    # @returns the string entered by the user, without the \n at the end
    def get_alias(prompt)
      if (!(prompt).nil?)
        form = MessageFormat.new(Rb.get_string("Enter prompt alias name:  "))
        source = Array.typed(Object).new([prompt])
        System.err.print(form.format(source))
      else
        System.err.print(Rb.get_string("Enter alias name:  "))
      end
      return (BufferedReader.new(InputStreamReader.new(System.in))).read_line
    end
    
    typesig { [String] }
    # Prompts user for an input string from the command line (System.in)
    # @prompt the prompt string printed
    # @returns the string entered by the user, without the \n at the end
    def input_string_from_stdin(prompt)
      System.err.print(prompt)
      return (BufferedReader.new(InputStreamReader.new(System.in))).read_line
    end
    
    typesig { [String, String, Array.typed(::Java::Char)] }
    # Prompts user for key password. User may select to choose the same
    # password (<code>otherKeyPass</code>) as for <code>otherAlias</code>.
    def get_key_passwd(alias_, other_alias, other_key_pass)
      count = 0
      key_pass = nil
      begin
        if (!(other_key_pass).nil?)
          form = MessageFormat.new(Rb.get_string("Enter key password for <alias>"))
          source = Array.typed(Object).new([alias_])
          System.err.println(form.format(source))
          form = MessageFormat.new(Rb.get_string("\t(RETURN if same as for <otherAlias>)"))
          src = Array.typed(Object).new([other_alias])
          System.err.print(form.format(src))
        else
          form = MessageFormat.new(Rb.get_string("Enter key password for <alias>"))
          source = Array.typed(Object).new([alias_])
          System.err.print(form.format(source))
        end
        System.err.flush
        key_pass = Password.read_password(System.in)
        @passwords.add(key_pass)
        if ((key_pass).nil?)
          key_pass = other_key_pass
        end
        count += 1
      end while (((key_pass).nil?) && count < 3)
      if ((key_pass).nil?)
        raise JavaException.new(Rb.get_string("Too many failures - try later"))
      end
      return key_pass
    end
    
    typesig { [X509Certificate, PrintStream] }
    # Prints a certificate in a human readable format.
    def print_x509cert(cert, out)
      # out.println("Owner: "
      # + cert.getSubjectDN().toString()
      # + "\n"
      # + "Issuer: "
      # + cert.getIssuerDN().toString()
      # + "\n"
      # + "Serial number: " + cert.getSerialNumber().toString(16)
      # + "\n"
      # + "Valid from: " + cert.getNotBefore().toString()
      # + " until: " + cert.getNotAfter().toString()
      # + "\n"
      # + "Certificate fingerprints:\n"
      # + "\t MD5:  " + getCertFingerPrint("MD5", cert)
      # + "\n"
      # + "\t SHA1: " + getCertFingerPrint("SHA1", cert));
      form = MessageFormat.new(Rb.get_string("*PATTERN* printX509Cert"))
      source = Array.typed(Object).new([cert.get_subject_dn.to_s, cert.get_issuer_dn.to_s, cert.get_serial_number.to_s(16), cert.get_not_before.to_s, cert.get_not_after.to_s, get_cert_finger_print("MD5", cert), get_cert_finger_print("SHA1", cert), cert.get_sig_alg_name, cert.get_version])
      out.println(form.format(source))
      extnum = 0
      if (cert.is_a?(X509CertImpl))
        impl = cert
        if (!(cert.get_critical_extension_oids).nil?)
          cert.get_critical_extension_oids.each do |extOID|
            if ((extnum).equal?(0))
              out.println
              out.println(Rb.get_string("Extensions: "))
              out.println
            end
            out.println("#" + RJava.cast_to_string(((extnum += 1))) + ": " + RJava.cast_to_string(impl.get_extension(ObjectIdentifier.new(ext_oid))))
          end
        end
        if (!(cert.get_non_critical_extension_oids).nil?)
          cert.get_non_critical_extension_oids.each do |extOID|
            if ((extnum).equal?(0))
              out.println
              out.println(Rb.get_string("Extensions: "))
              out.println
            end
            ext = impl.get_extension(ObjectIdentifier.new(ext_oid))
            if (!(ext).nil?)
              out.println("#" + RJava.cast_to_string(((extnum += 1))) + ": " + RJava.cast_to_string(ext))
            else
              out.println("#" + RJava.cast_to_string(((extnum += 1))) + ": " + RJava.cast_to_string(impl.get_unparseable_extension(ObjectIdentifier.new(ext_oid))))
            end
          end
        end
      end
    end
    
    typesig { [X509Certificate] }
    # Returns true if the certificate is self-signed, false otherwise.
    def is_self_signed(cert)
      return (cert.get_subject_dn == cert.get_issuer_dn)
    end
    
    typesig { [Certificate] }
    # Returns true if the given certificate is trusted, false otherwise.
    def is_trusted(cert)
      if (!(@key_store.get_certificate_alias(cert)).nil?)
        return true # found in own keystore
      end
      if (@trustcacerts && (!(@caks).nil?) && (!(@caks.get_certificate_alias(cert)).nil?))
        return true # found in CA keystore
      end
      return false
    end
    
    typesig { [] }
    # Gets an X.500 name suitable for inclusion in a certification request.
    def get_x500name
      in_ = nil
      in_ = BufferedReader.new(InputStreamReader.new(System.in))
      common_name = "Unknown"
      organizational_unit = "Unknown"
      organization = "Unknown"
      city = "Unknown"
      state = "Unknown"
      country = "Unknown"
      name = nil
      user_input = nil
      max_retry = 20
      begin
        if (((max_retry -= 1) + 1) < 0)
          raise RuntimeException.new(Rb.get_string("Too may retries, program terminated"))
        end
        common_name = RJava.cast_to_string(input_string(in_, Rb.get_string("What is your first and last name?"), common_name))
        organizational_unit = RJava.cast_to_string(input_string(in_, Rb.get_string("What is the name of your organizational unit?"), organizational_unit))
        organization = RJava.cast_to_string(input_string(in_, Rb.get_string("What is the name of your organization?"), organization))
        city = RJava.cast_to_string(input_string(in_, Rb.get_string("What is the name of your City or Locality?"), city))
        state = RJava.cast_to_string(input_string(in_, Rb.get_string("What is the name of your State or Province?"), state))
        country = RJava.cast_to_string(input_string(in_, Rb.get_string("What is the two-letter country code for this unit?"), country))
        name = X500Name.new(common_name, organizational_unit, organization, city, state, country)
        form = MessageFormat.new(Rb.get_string("Is <name> correct?"))
        source = Array.typed(Object).new([name])
        user_input = RJava.cast_to_string(input_string(in_, form.format(source), Rb.get_string("no")))
      end while (!(Collator.compare(user_input, Rb.get_string("yes"))).equal?(0) && !(Collator.compare(user_input, Rb.get_string("y"))).equal?(0))
      System.err.println
      return name
    end
    
    typesig { [BufferedReader, String, String] }
    def input_string(in_, prompt, default_value)
      System.err.println(prompt)
      form = MessageFormat.new(Rb.get_string("  [defaultValue]:  "))
      source = Array.typed(Object).new([default_value])
      System.err.print(form.format(source))
      System.err.flush
      value = in_.read_line
      if ((value).nil? || (Collator.compare(value, "")).equal?(0))
        value = default_value
      end
      return value
    end
    
    typesig { [Certificate, PrintStream] }
    # Writes an X.509 certificate in base64 or binary encoding to an output
    # stream.
    def dump_cert(cert, out)
      if (@rfc)
        encoder = BASE64Encoder.new
        out.println(X509Factory::BEGIN_CERT)
        encoder.encode_buffer(cert.get_encoded, out)
        out.println(X509Factory::END_CERT)
      else
        out.write(cert.get_encoded) # binary
      end
    end
    
    typesig { [::Java::Byte, StringBuffer] }
    # Converts a byte to hex digit and writes to the supplied buffer
    def byte2hex(b, buf)
      hex_chars = Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord)])
      high = ((b & 0xf0) >> 4)
      low = (b & 0xf)
      buf.append(hex_chars[high])
      buf.append(hex_chars[low])
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Converts a byte array to hex string
    def to_hex_string(block)
      buf = StringBuffer.new
      len = block.attr_length
      i = 0
      while i < len
        byte2hex(block[i], buf)
        if (i < len - 1)
          buf.append(":")
        end
        i += 1
      end
      return buf.to_s
    end
    
    typesig { [String, Array.typed(::Java::Char), Array.typed(::Java::Char)] }
    # Recovers (private) key associated with given alias.
    # 
    # @return an array of objects, where the 1st element in the array is the
    # recovered private key, and the 2nd element is the password used to
    # recover it.
    def recover_key(alias_, store_pass, key_pass)
      key = nil
      if ((@key_store.contains_alias(alias_)).equal?(false))
        form = MessageFormat.new(Rb.get_string("Alias <alias> does not exist"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      if (!@key_store.entry_instance_of(alias_, KeyStore::PrivateKeyEntry) && !@key_store.entry_instance_of(alias_, KeyStore::SecretKeyEntry))
        form = MessageFormat.new(Rb.get_string("Alias <alias> has no key"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      if ((key_pass).nil?)
        # Try to recover the key using the keystore password
        begin
          key = @key_store.get_key(alias_, store_pass)
          key_pass = store_pass
          @passwords.add(key_pass)
        rescue UnrecoverableKeyException => e
          # Did not work out, so prompt user for key password
          if (!@token)
            key_pass = get_key_passwd(alias_, nil, nil)
            key = @key_store.get_key(alias_, key_pass)
          else
            raise e
          end
        end
      else
        key = @key_store.get_key(alias_, key_pass)
      end
      return Array.typed(Object).new([key, key_pass])
    end
    
    typesig { [KeyStore, String, Array.typed(::Java::Char), Array.typed(::Java::Char)] }
    # Recovers entry associated with given alias.
    # 
    # @return an array of objects, where the 1st element in the array is the
    # recovered entry, and the 2nd element is the password used to
    # recover it (null if no password).
    def recover_entry(ks, alias_, pstore, pkey)
      if ((ks.contains_alias(alias_)).equal?(false))
        form = MessageFormat.new(Rb.get_string("Alias <alias> does not exist"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      pp = nil
      entry = nil
      begin
        # First attempt to access entry without key password
        # (PKCS11 entry or trusted certificate entry, for example)
        entry = ks.get_entry(alias_, pp)
        pkey = nil
      rescue UnrecoverableEntryException => une
        if (P11KEYSTORE.equals_ignore_case(ks.get_type) || KeyStoreUtil.is_windows_key_store(ks.get_type))
          # should not happen, but a possibility
          raise une
        end
        # entry is protected
        if (!(pkey).nil?)
          # try provided key password
          pp = PasswordProtection.new(pkey)
          entry = ks.get_entry(alias_, pp)
        else
          # try store pass
          begin
            pp = PasswordProtection.new(pstore)
            entry = ks.get_entry(alias_, pp)
            pkey = pstore
          rescue UnrecoverableEntryException => une2
            if (P12KEYSTORE.equals_ignore_case(ks.get_type))
              # P12 keystore currently does not support separate
              # store and entry passwords
              raise une2
            else
              # prompt for entry password
              pkey = get_key_passwd(alias_, nil, nil)
              pp = PasswordProtection.new(pkey)
              entry = ks.get_entry(alias_, pp)
            end
          end
        end
      end
      return Array.typed(Object).new([entry, pkey])
    end
    
    typesig { [String, Certificate] }
    # Gets the requested finger print of the certificate.
    def get_cert_finger_print(md_alg, cert)
      enc_cert_info = cert.get_encoded
      md = MessageDigest.get_instance(md_alg)
      digest_ = md.digest(enc_cert_info)
      return to_hex_string(digest_)
    end
    
    typesig { [] }
    # Prints warning about missing integrity check.
    def print_warning
      System.err.println
      System.err.println(Rb.get_string("*****************  WARNING WARNING WARNING  *****************"))
      System.err.println(Rb.get_string("* The integrity of the information stored in your keystore  *"))
      System.err.println(Rb.get_string("* has NOT been verified!  In order to verify its integrity, *"))
      System.err.println(Rb.get_string("* you must provide your keystore password.                  *"))
      System.err.println(Rb.get_string("*****************  WARNING WARNING WARNING  *****************"))
      System.err.println
    end
    
    typesig { [String, Certificate, Array.typed(Certificate)] }
    # Validates chain in certification reply, and returns the ordered
    # elements of the chain (with user certificate first, and root
    # certificate last in the array).
    # 
    # @param alias the alias name
    # @param userCert the user certificate of the alias
    # @param replyCerts the chain provided in the reply
    def validate_reply(alias_, user_cert, reply_certs)
      # order the certs in the reply (bottom-up).
      # we know that all certs in the reply are of type X.509, because
      # we parsed them using an X.509 certificate factory
      i = 0
      user_pub_key = user_cert.get_public_key
      i = 0
      while i < reply_certs.attr_length
        if ((user_pub_key == reply_certs[i].get_public_key))
          break
        end
        i += 1
      end
      if ((i).equal?(reply_certs.attr_length))
        form = MessageFormat.new(Rb.get_string("Certificate reply does not contain public key for <alias>"))
        source = Array.typed(Object).new([alias_])
        raise JavaException.new(form.format(source))
      end
      tmp_cert = reply_certs[0]
      reply_certs[0] = reply_certs[i]
      reply_certs[i] = tmp_cert
      issuer = (reply_certs[0]).get_issuer_dn
      i = 1
      while i < reply_certs.attr_length - 1
        # find a cert in the reply whose "subject" is the same as the
        # given "issuer"
        j = 0
        j = i
        while j < reply_certs.attr_length
          subject = nil
          subject = (reply_certs[j]).get_subject_dn
          if ((subject == issuer))
            tmp_cert = reply_certs[i]
            reply_certs[i] = reply_certs[j]
            reply_certs[j] = tmp_cert
            issuer = (reply_certs[i]).get_issuer_dn
            break
          end
          j += 1
        end
        if ((j).equal?(reply_certs.attr_length))
          raise JavaException.new(Rb.get_string("Incomplete certificate chain in reply"))
        end
        i += 1
      end
      # now verify each cert in the ordered chain
      i = 0
      while i < reply_certs.attr_length - 1
        pub_key = reply_certs[i + 1].get_public_key
        begin
          reply_certs[i].verify(pub_key)
        rescue JavaException => e
          raise JavaException.new(Rb.get_string("Certificate chain in reply does not verify: ") + e.get_message)
        end
        i += 1
      end
      if (@noprompt)
        return reply_certs
      end
      # do we trust the (root) cert at the top?
      top_cert = reply_certs[reply_certs.attr_length - 1]
      if (!is_trusted(top_cert))
        verified = false
        root_cert = nil
        if (@trustcacerts && (!(@caks).nil?))
          aliases_ = @caks.aliases
          while aliases_.has_more_elements
            name = aliases_.next_element
            root_cert = @caks.get_certificate(name)
            if (!(root_cert).nil?)
              begin
                top_cert.verify(root_cert.get_public_key)
                verified = true
                break
              rescue JavaException => e
              end
            end
          end
        end
        if (!verified)
          System.err.println
          System.err.println(Rb.get_string("Top-level certificate in reply:\n"))
          print_x509cert(top_cert, System.out)
          System.err.println
          System.err.print(Rb.get_string("... is not trusted. "))
          reply = get_yes_no_reply(Rb.get_string("Install reply anyway? [no]:  "))
          if (("NO" == reply))
            return nil
          end
        else
          if (!is_self_signed(top_cert))
            # append the (self-signed) root CA cert to the chain
            tmp_certs = Array.typed(Certificate).new(reply_certs.attr_length + 1) { nil }
            System.arraycopy(reply_certs, 0, tmp_certs, 0, reply_certs.attr_length)
            tmp_certs[tmp_certs.attr_length - 1] = root_cert
            reply_certs = tmp_certs
          end
        end
      end
      return reply_certs
    end
    
    typesig { [Certificate, Certificate] }
    # Establishes a certificate chain (using trusted certificates in the
    # keystore), starting with the user certificate
    # and ending at a self-signed certificate found in the keystore.
    # 
    # @param userCert the user certificate of the alias
    # @param certToVerify the single certificate provided in the reply
    def establish_cert_chain(user_cert, cert_to_verify)
      if (!(user_cert).nil?)
        # Make sure that the public key of the certificate reply matches
        # the original public key in the keystore
        orig_pub_key = user_cert.get_public_key
        reply_pub_key = cert_to_verify.get_public_key
        if (!(orig_pub_key == reply_pub_key))
          raise JavaException.new(Rb.get_string("Public keys in reply and keystore don't match"))
        end
        # If the two certs are identical, we're done: no need to import
        # anything
        if ((cert_to_verify == user_cert))
          raise JavaException.new(Rb.get_string("Certificate reply and certificate in keystore are identical"))
        end
      end
      # Build a hash table of all certificates in the keystore.
      # Use the subject distinguished name as the key into the hash table.
      # All certificates associated with the same subject distinguished
      # name are stored in the same hash table entry as a vector.
      certs = nil
      if (@key_store.size > 0)
        certs = Hashtable.new(11)
        keystorecerts2_hashtable(@key_store, certs)
      end
      if (@trustcacerts)
        if (!(@caks).nil? && @caks.size > 0)
          if ((certs).nil?)
            certs = Hashtable.new(11)
          end
          keystorecerts2_hashtable(@caks, certs)
        end
      end
      # start building chain
      chain = Vector.new(2)
      if (build_chain(cert_to_verify, chain, certs))
        new_chain = Array.typed(Certificate).new(chain.size) { nil }
        # buildChain() returns chain with self-signed root-cert first and
        # user-cert last, so we need to invert the chain before we store
        # it
        j = 0
        i = chain.size - 1
        while i >= 0
          new_chain[j] = chain.element_at(i)
          j += 1
          i -= 1
        end
        return new_chain
      else
        raise JavaException.new(Rb.get_string("Failed to establish chain from reply"))
      end
    end
    
    typesig { [X509Certificate, Vector, Hashtable] }
    # Recursively tries to establish chain from pool of trusted certs.
    # 
    # @param certToVerify the cert that needs to be verified.
    # @param chain the chain that's being built.
    # @param certs the pool of trusted certs
    # 
    # @return true if successful, false otherwise.
    def build_chain(cert_to_verify, chain, certs)
      subject = cert_to_verify.get_subject_dn
      issuer = cert_to_verify.get_issuer_dn
      if ((subject == issuer))
        # reached self-signed root cert;
        # no verification needed because it's trusted.
        chain.add_element(cert_to_verify)
        return true
      end
      # Get the issuer's certificate(s)
      vec = certs.get(issuer)
      if ((vec).nil?)
        return false
      end
      # Try out each certificate in the vector, until we find one
      # whose public key verifies the signature of the certificate
      # in question.
      issuer_certs = vec.elements
      while issuer_certs.has_more_elements
        issuer_cert = issuer_certs.next_element
        issuer_pub_key = issuer_cert.get_public_key
        begin
          cert_to_verify.verify(issuer_pub_key)
        rescue JavaException => e
          next
        end
        if (build_chain(issuer_cert, chain, certs))
          chain.add_element(cert_to_verify)
          return true
        end
      end
      return false
    end
    
    typesig { [String] }
    # Prompts user for yes/no decision.
    # 
    # @return the user's decision, can only be "YES" or "NO"
    def get_yes_no_reply(prompt)
      reply = nil
      max_retry = 20
      begin
        if (((max_retry -= 1) + 1) < 0)
          raise RuntimeException.new(Rb.get_string("Too may retries, program terminated"))
        end
        System.err.print(prompt)
        System.err.flush
        reply = RJava.cast_to_string((BufferedReader.new(InputStreamReader.new(System.in))).read_line)
        if ((Collator.compare(reply, "")).equal?(0) || (Collator.compare(reply, Rb.get_string("n"))).equal?(0) || (Collator.compare(reply, Rb.get_string("no"))).equal?(0))
          reply = "NO"
        else
          if ((Collator.compare(reply, Rb.get_string("y"))).equal?(0) || (Collator.compare(reply, Rb.get_string("yes"))).equal?(0))
            reply = "YES"
          else
            System.err.println(Rb.get_string("Wrong answer, try again"))
            reply = RJava.cast_to_string(nil)
          end
        end
      end while ((reply).nil?)
      return reply
    end
    
    typesig { [] }
    # Returns the keystore with the configured CA certificates.
    def get_cacerts_key_store
      sep = JavaFile.attr_separator
      file = JavaFile.new(RJava.cast_to_string(System.get_property("java.home")) + sep + "lib" + sep + "security" + sep + "cacerts")
      if (!file.exists)
        return nil
      end
      fis = nil
      caks = nil
      begin
        fis = FileInputStream.new(file)
        caks = KeyStore.get_instance(JKS)
        caks.load(fis, nil)
      ensure
        if (!(fis).nil?)
          fis.close
        end
      end
      return caks
    end
    
    typesig { [KeyStore, Hashtable] }
    # Stores the (leaf) certificates of a keystore in a hashtable.
    # All certs belonging to the same CA are stored in a vector that
    # in turn is stored in the hashtable, keyed by the CA's subject DN
    def keystorecerts2_hashtable(ks, hash)
      aliases_ = ks.aliases
      while aliases_.has_more_elements
        alias_ = aliases_.next_element
        cert = ks.get_certificate(alias_)
        if (!(cert).nil?)
          subject_dn = (cert).get_subject_dn
          vec = hash.get(subject_dn)
          if ((vec).nil?)
            vec = Vector.new
            vec.add_element(cert)
          else
            if (!vec.contains(cert))
              vec.add_element(cert)
            end
          end
          hash.put(subject_dn, vec)
        end
      end
    end
    
    class_module.module_eval {
      typesig { [String] }
      # Returns the issue time that's specified the -startdate option
      # @param s the value of -startdate option
      def get_start_date(s)
        c = GregorianCalendar.new
        if (!(s).nil?)
          ioe = IOException.new("Illegal startdate value")
          len = s.length
          if ((len).equal?(0))
            raise ioe
          end
          if ((s.char_at(0)).equal?(Character.new(?-.ord)) || (s.char_at(0)).equal?(Character.new(?+.ord)))
            # Form 1: ([+-]nnn[ymdHMS])+
            start = 0
            while (start < len)
              sign_ = 0
              case (s.char_at(start))
              when Character.new(?+.ord)
                sign_ = 1
              when Character.new(?-.ord)
                sign_ = -1
              else
                raise ioe
              end
              i = start + 1
              while i < len
                ch = s.char_at(i)
                if (ch < Character.new(?0.ord) || ch > Character.new(?9.ord))
                  break
                end
                i += 1
              end
              if ((i).equal?(start + 1))
                raise ioe
              end
              number = JavaInteger.parse_int(s.substring(start + 1, i))
              if (i >= len)
                raise ioe
              end
              unit = 0
              case (s.char_at(i))
              when Character.new(?y.ord)
                unit = Calendar::YEAR
              when Character.new(?m.ord)
                unit = Calendar::MONTH
              when Character.new(?d.ord)
                unit = Calendar::DATE
              when Character.new(?H.ord)
                unit = Calendar::HOUR
              when Character.new(?M.ord)
                unit = Calendar::MINUTE
              when Character.new(?S.ord)
                unit = Calendar::SECOND
              else
                raise ioe
              end
              c.add(unit, sign_ * number)
              start = i + 1
            end
          else
            # Form 2: [yyyy/mm/dd] [HH:MM:SS]
            date = nil
            time = nil
            if ((len).equal?(19))
              date = RJava.cast_to_string(s.substring(0, 10))
              time = RJava.cast_to_string(s.substring(11))
              if (!(s.char_at(10)).equal?(Character.new(?\s.ord)))
                raise ioe
              end
            else
              if ((len).equal?(10))
                date = s
              else
                if ((len).equal?(8))
                  time = s
                else
                  raise ioe
                end
              end
            end
            if (!(date).nil?)
              if (date.matches("\\d\\d\\d\\d\\/\\d\\d\\/\\d\\d"))
                c.set(JavaInteger.value_of(date.substring(0, 4)), JavaInteger.value_of(date.substring(5, 7)) - 1, JavaInteger.value_of(date.substring(8, 10)))
              else
                raise ioe
              end
            end
            if (!(time).nil?)
              if (time.matches("\\d\\d:\\d\\d:\\d\\d"))
                c.set(Calendar::HOUR_OF_DAY, JavaInteger.value_of(time.substring(0, 2)))
                c.set(Calendar::MINUTE, JavaInteger.value_of(time.substring(0, 2)))
                c.set(Calendar::SECOND, JavaInteger.value_of(time.substring(0, 2)))
                c.set(Calendar::MILLISECOND, 0)
              else
                raise ioe
              end
            end
          end
        end
        return c.get_time
      end
    }
    
    typesig { [] }
    # Prints the usage of this tool.
    def usage
      System.err.println(Rb.get_string("keytool usage:\n"))
      System.err.println(Rb.get_string("-certreq     [-v] [-protected]"))
      System.err.println(Rb.get_string("\t     [-alias <alias>] [-sigalg <sigalg>]"))
      System.err.println(Rb.get_string("\t     [-file <csr_file>] [-keypass <keypass>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-changealias [-v] [-protected] -alias <alias> -destalias <destalias>"))
      System.err.println(Rb.get_string("\t     [-keypass <keypass>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-delete      [-v] [-protected] -alias <alias>"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-exportcert  [-v] [-rfc] [-protected]"))
      System.err.println(Rb.get_string("\t     [-alias <alias>] [-file <cert_file>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-genkeypair  [-v] [-protected]"))
      System.err.println(Rb.get_string("\t     [-alias <alias>]"))
      System.err.println(Rb.get_string("\t     [-keyalg <keyalg>] [-keysize <keysize>]"))
      System.err.println(Rb.get_string("\t     [-sigalg <sigalg>] [-dname <dname>]"))
      System.err.println(Rb.get_string("\t     [-validity <valDays>] [-keypass <keypass>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-genseckey   [-v] [-protected]"))
      System.err.println(Rb.get_string("\t     [-alias <alias>] [-keypass <keypass>]"))
      System.err.println(Rb.get_string("\t     [-keyalg <keyalg>] [-keysize <keysize>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-help"))
      System.err.println
      System.err.println(Rb.get_string("-importcert  [-v] [-noprompt] [-trustcacerts] [-protected]"))
      System.err.println(Rb.get_string("\t     [-alias <alias>]"))
      System.err.println(Rb.get_string("\t     [-file <cert_file>] [-keypass <keypass>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-importkeystore [-v] "))
      System.err.println(Rb.get_string("\t     [-srckeystore <srckeystore>] [-destkeystore <destkeystore>]"))
      System.err.println(Rb.get_string("\t     [-srcstoretype <srcstoretype>] [-deststoretype <deststoretype>]"))
      System.err.println(Rb.get_string("\t     [-srcstorepass <srcstorepass>] [-deststorepass <deststorepass>]"))
      System.err.println(Rb.get_string("\t     [-srcprotected] [-destprotected]"))
      System.err.println(Rb.get_string("\t     [-srcprovidername <srcprovidername>]\n\t     [-destprovidername <destprovidername>]"))
      System.err.println(Rb.get_string("\t     [-srcalias <srcalias> [-destalias <destalias>]"))
      System.err.println(Rb.get_string("\t       [-srckeypass <srckeypass>] [-destkeypass <destkeypass>]]"))
      System.err.println(Rb.get_string("\t     [-noprompt]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-keypasswd   [-v] [-alias <alias>]"))
      System.err.println(Rb.get_string("\t     [-keypass <old_keypass>] [-new <new_keypass>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-list        [-v | -rfc] [-protected]"))
      System.err.println(Rb.get_string("\t     [-alias <alias>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      System.err.println
      System.err.println(Rb.get_string("-printcert   [-v] [-file <cert_file>]"))
      System.err.println
      System.err.println(Rb.get_string("-storepasswd [-v] [-new <new_storepass>]"))
      System.err.println(Rb.get_string("\t     [-keystore <keystore>] [-storepass <storepass>]"))
      System.err.println(Rb.get_string("\t     [-storetype <storetype>] [-providername <name>]"))
      System.err.println(Rb.get_string("\t     [-providerclass <provider_class_name> [-providerarg <arg>]] ..."))
      System.err.println(Rb.get_string("\t     [-providerpath <pathlist>]"))
      if (@debug)
        raise RuntimeException.new("NO ERROR, SORRY")
      else
        System.exit(1)
      end
    end
    
    typesig { [] }
    def tiny_help
      System.err.println(Rb.get_string("Try keytool -help"))
      # do not drown user with the help lines.
      if (@debug)
        raise RuntimeException.new("NO BIG ERROR, SORRY")
      else
        System.exit(1)
      end
    end
    
    typesig { [String] }
    def error_need_argument(flag)
      source = Array.typed(Object).new([flag])
      System.err.println(MessageFormat.new(Rb.get_string("Command option <flag> needs an argument.")).format(source))
      tiny_help
    end
    
    private
    alias_method :initialize__key_tool, :initialize
  end
  
  # This class is exactly the same as com.sun.tools.javac.util.Pair,
  # it's copied here since the original one is not included in JRE.
  class Pair 
    include_class_members KeyToolImports
    
    attr_accessor :fst
    alias_method :attr_fst, :fst
    undef_method :fst
    alias_method :attr_fst=, :fst=
    undef_method :fst=
    
    attr_accessor :snd
    alias_method :attr_snd, :snd
    undef_method :snd
    alias_method :attr_snd=, :snd=
    undef_method :snd=
    
    typesig { [Object, Object] }
    def initialize(fst, snd)
      @fst = nil
      @snd = nil
      @fst = fst
      @snd = snd
    end
    
    typesig { [] }
    def to_s
      return "Pair[" + RJava.cast_to_string(@fst) + "," + RJava.cast_to_string(@snd) + "]"
    end
    
    class_module.module_eval {
      typesig { [Object, Object] }
      def ==(x, y)
        return ((x).nil? && (y).nil?) || (!(x).nil? && (x == y))
      end
    }
    
    typesig { [Object] }
    def ==(other)
      return other.is_a?(Pair) && self.==(@fst, (other).attr_fst) && self.==(@snd, (other).attr_snd)
    end
    
    typesig { [] }
    def hash_code
      if ((@fst).nil?)
        return ((@snd).nil?) ? 0 : @snd.hash_code + 1
      else
        if ((@snd).nil?)
          return @fst.hash_code + 2
        else
          return @fst.hash_code * 17 + @snd.hash_code
        end
      end
    end
    
    private
    alias_method :initialize__pair, :initialize
  end
  
  KeyTool.main($*) if $0 == __FILE__
end
