require "rjava"

# Copyright 1997-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
  module JarSignerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Tools
      include ::Java::Io
      include ::Java::Util
      include ::Java::Util::Zip
      include ::Java::Util::Jar
      include_const ::Java::Math, :BigInteger
      include_const ::Java::Net, :URI
      include_const ::Java::Net, :URISyntaxException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLClassLoader
      include_const ::Java::Net, :SocketTimeoutException
      include_const ::Java::Text, :Collator
      include_const ::Java::Text, :MessageFormat
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateExpiredException
      include_const ::Java::Security::Cert, :CertificateNotYetValidException
      include ::Java::Security
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Com::Sun::Jarsigner, :ContentSigner
      include_const ::Com::Sun::Jarsigner, :ContentSignerParameters
      include ::Sun::Security::X509
      include ::Sun::Security::Util
      include_const ::Sun::Misc, :BASE64Encoder
    }
  end
  
  # <p>The jarsigner utility.
  # 
  # @author Roland Schemers
  # @author Jan Luehe
  class JarSigner 
    include_class_members JarSignerImports
    
    class_module.module_eval {
      # for i18n
      const_set_lazy(:Rb) { Java::Util::ResourceBundle.get_bundle("sun.security.tools.JarSignerResources") }
      const_attr_reader  :Rb
      
      const_set_lazy(:Collator) { Collator.get_instance }
      const_attr_reader  :Collator
      
      when_class_loaded do
        # this is for case insensitive string comparisions
        Collator.set_strength(Collator::PRIMARY)
      end
      
      const_set_lazy(:META_INF) { "META-INF/" }
      const_attr_reader  :META_INF
      
      # prefix for new signature-related files in META-INF directory
      const_set_lazy(:SIG_PREFIX) { META_INF + "SIG-" }
      const_attr_reader  :SIG_PREFIX
      
      const_set_lazy(:PARAM_STRING) { Array.typed(Class).new([String]) }
      const_attr_reader  :PARAM_STRING
      
      const_set_lazy(:NONE) { "NONE" }
      const_attr_reader  :NONE
      
      const_set_lazy(:P11KEYSTORE) { "PKCS11" }
      const_attr_reader  :P11KEYSTORE
      
      const_set_lazy(:SIX_MONTHS) { 180 * 24 * 60 * 60 * 1000 }
      const_attr_reader  :SIX_MONTHS
      
      typesig { [Array.typed(String)] }
      # milliseconds
      # Attention:
      # This is the entry that get launched by the security tool jarsigner.
      # It's marked as exported private per AppServer Team's request.
      # See http://ccc.sfbay/6428446
      def main(args)
        js = JarSigner.new
        js.run(args)
      end
      
      const_set_lazy(:VERSION) { "1.0" }
      const_attr_reader  :VERSION
      
      const_set_lazy(:IN_KEYSTORE) { 0x1 }
      const_attr_reader  :IN_KEYSTORE
      
      const_set_lazy(:IN_SCOPE) { 0x2 }
      const_attr_reader  :IN_SCOPE
    }
    
    # signer's certificate chain (when composing)
    attr_accessor :cert_chain
    alias_method :attr_cert_chain, :cert_chain
    undef_method :cert_chain
    alias_method :attr_cert_chain=, :cert_chain=
    undef_method :cert_chain=
    
    # private key
    attr_accessor :private_key
    alias_method :attr_private_key, :private_key
    undef_method :private_key
    alias_method :attr_private_key=, :private_key=
    undef_method :private_key=
    
    attr_accessor :store
    alias_method :attr_store, :store
    undef_method :store
    alias_method :attr_store=, :store=
    undef_method :store=
    
    attr_accessor :scope
    alias_method :attr_scope, :scope
    undef_method :scope
    alias_method :attr_scope=, :scope=
    undef_method :scope=
    
    attr_accessor :keystore
    alias_method :attr_keystore, :keystore
    undef_method :keystore
    alias_method :attr_keystore=, :keystore=
    undef_method :keystore=
    
    # key store file
    attr_accessor :null_stream
    alias_method :attr_null_stream, :null_stream
    undef_method :null_stream
    alias_method :attr_null_stream=, :null_stream=
    undef_method :null_stream=
    
    # null keystore input stream (NONE)
    attr_accessor :token
    alias_method :attr_token, :token
    undef_method :token
    alias_method :attr_token=, :token=
    undef_method :token=
    
    # token-based keystore
    attr_accessor :jarfile
    alias_method :attr_jarfile, :jarfile
    undef_method :jarfile
    alias_method :attr_jarfile=, :jarfile=
    undef_method :jarfile=
    
    # jar file to sign
    attr_accessor :alias
    alias_method :attr_alias, :alias
    undef_method :alias
    alias_method :attr_alias=, :alias=
    undef_method :alias=
    
    # alias to sign jar with
    attr_accessor :storepass
    alias_method :attr_storepass, :storepass
    undef_method :storepass
    alias_method :attr_storepass=, :storepass=
    undef_method :storepass=
    
    # keystore password
    attr_accessor :protected_path
    alias_method :attr_protected_path, :protected_path
    undef_method :protected_path
    alias_method :attr_protected_path=, :protected_path=
    undef_method :protected_path=
    
    # protected authentication path
    attr_accessor :storetype
    alias_method :attr_storetype, :storetype
    undef_method :storetype
    alias_method :attr_storetype=, :storetype=
    undef_method :storetype=
    
    # keystore type
    attr_accessor :provider_name
    alias_method :attr_provider_name, :provider_name
    undef_method :provider_name
    alias_method :attr_provider_name=, :provider_name=
    undef_method :provider_name=
    
    # provider name
    attr_accessor :providers
    alias_method :attr_providers, :providers
    undef_method :providers
    alias_method :attr_providers=, :providers=
    undef_method :providers=
    
    # list of providers
    attr_accessor :provider_args
    alias_method :attr_provider_args, :provider_args
    undef_method :provider_args
    alias_method :attr_provider_args=, :provider_args=
    undef_method :provider_args=
    
    # arguments for provider constructors
    attr_accessor :keypass
    alias_method :attr_keypass, :keypass
    undef_method :keypass
    alias_method :attr_keypass=, :keypass=
    undef_method :keypass=
    
    # private key password
    attr_accessor :sigfile
    alias_method :attr_sigfile, :sigfile
    undef_method :sigfile
    alias_method :attr_sigfile=, :sigfile=
    undef_method :sigfile=
    
    # name of .SF file
    attr_accessor :sigalg
    alias_method :attr_sigalg, :sigalg
    undef_method :sigalg
    alias_method :attr_sigalg=, :sigalg=
    undef_method :sigalg=
    
    # name of signature algorithm
    attr_accessor :digestalg
    alias_method :attr_digestalg, :digestalg
    undef_method :digestalg
    alias_method :attr_digestalg=, :digestalg=
    undef_method :digestalg=
    
    # name of digest algorithm
    attr_accessor :signedjar
    alias_method :attr_signedjar, :signedjar
    undef_method :signedjar
    alias_method :attr_signedjar=, :signedjar=
    undef_method :signedjar=
    
    # output filename
    attr_accessor :tsa_url
    alias_method :attr_tsa_url, :tsa_url
    undef_method :tsa_url
    alias_method :attr_tsa_url=, :tsa_url=
    undef_method :tsa_url=
    
    # location of the Timestamping Authority
    attr_accessor :tsa_alias
    alias_method :attr_tsa_alias, :tsa_alias
    undef_method :tsa_alias
    alias_method :attr_tsa_alias=, :tsa_alias=
    undef_method :tsa_alias=
    
    # alias for the Timestamping Authority's certificate
    attr_accessor :verify
    alias_method :attr_verify, :verify
    undef_method :verify
    alias_method :attr_verify=, :verify=
    undef_method :verify=
    
    # verify the jar
    attr_accessor :verbose
    alias_method :attr_verbose, :verbose
    undef_method :verbose
    alias_method :attr_verbose=, :verbose=
    undef_method :verbose=
    
    # verbose output when signing/verifying
    attr_accessor :showcerts
    alias_method :attr_showcerts, :showcerts
    undef_method :showcerts
    alias_method :attr_showcerts=, :showcerts=
    undef_method :showcerts=
    
    # show certs when verifying
    attr_accessor :debug
    alias_method :attr_debug, :debug
    undef_method :debug
    alias_method :attr_debug=, :debug=
    undef_method :debug=
    
    # debug
    attr_accessor :sign_manifest
    alias_method :attr_sign_manifest, :sign_manifest
    undef_method :sign_manifest
    alias_method :attr_sign_manifest=, :sign_manifest=
    undef_method :sign_manifest=
    
    # "sign" the whole manifest
    attr_accessor :external_sf
    alias_method :attr_external_sf, :external_sf
    undef_method :external_sf
    alias_method :attr_external_sf=, :external_sf=
    undef_method :external_sf=
    
    # leave the .SF out of the PKCS7 block
    # read zip entry raw bytes
    attr_accessor :baos
    alias_method :attr_baos, :baos
    undef_method :baos
    alias_method :attr_baos=, :baos=
    undef_method :baos=
    
    attr_accessor :buffer
    alias_method :attr_buffer, :buffer
    undef_method :buffer
    alias_method :attr_buffer=, :buffer=
    undef_method :buffer=
    
    attr_accessor :signing_mechanism
    alias_method :attr_signing_mechanism, :signing_mechanism
    undef_method :signing_mechanism
    alias_method :attr_signing_mechanism=, :signing_mechanism=
    undef_method :signing_mechanism=
    
    attr_accessor :alt_signer_class
    alias_method :attr_alt_signer_class, :alt_signer_class
    undef_method :alt_signer_class
    alias_method :attr_alt_signer_class=, :alt_signer_class=
    undef_method :alt_signer_class=
    
    attr_accessor :alt_signer_classpath
    alias_method :attr_alt_signer_classpath, :alt_signer_classpath
    undef_method :alt_signer_classpath
    alias_method :attr_alt_signer_classpath=, :alt_signer_classpath=
    undef_method :alt_signer_classpath=
    
    attr_accessor :zip_file
    alias_method :attr_zip_file, :zip_file
    undef_method :zip_file
    alias_method :attr_zip_file=, :zip_file=
    undef_method :zip_file=
    
    attr_accessor :has_expired_cert
    alias_method :attr_has_expired_cert, :has_expired_cert
    undef_method :has_expired_cert
    alias_method :attr_has_expired_cert=, :has_expired_cert=
    undef_method :has_expired_cert=
    
    attr_accessor :has_expiring_cert
    alias_method :attr_has_expiring_cert, :has_expiring_cert
    undef_method :has_expiring_cert
    alias_method :attr_has_expiring_cert=, :has_expiring_cert=
    undef_method :has_expiring_cert=
    
    attr_accessor :not_yet_valid_cert
    alias_method :attr_not_yet_valid_cert, :not_yet_valid_cert
    undef_method :not_yet_valid_cert
    alias_method :attr_not_yet_valid_cert=, :not_yet_valid_cert=
    undef_method :not_yet_valid_cert=
    
    attr_accessor :bad_key_usage
    alias_method :attr_bad_key_usage, :bad_key_usage
    undef_method :bad_key_usage
    alias_method :attr_bad_key_usage=, :bad_key_usage=
    undef_method :bad_key_usage=
    
    attr_accessor :bad_extended_key_usage
    alias_method :attr_bad_extended_key_usage, :bad_extended_key_usage
    undef_method :bad_extended_key_usage
    alias_method :attr_bad_extended_key_usage=, :bad_extended_key_usage=
    undef_method :bad_extended_key_usage=
    
    attr_accessor :bad_netscape_cert_type
    alias_method :attr_bad_netscape_cert_type, :bad_netscape_cert_type
    undef_method :bad_netscape_cert_type
    alias_method :attr_bad_netscape_cert_type=, :bad_netscape_cert_type=
    undef_method :bad_netscape_cert_type=
    
    typesig { [Array.typed(String)] }
    def run(args)
      begin
        parse_args(args)
        # Try to load and install the specified providers
        if (!(@providers).nil?)
          cl = ClassLoader.get_system_class_loader
          e = @providers.elements
          while (e.has_more_elements)
            prov_name = e.next_element
            prov_class = nil
            if (!(cl).nil?)
              prov_class = cl.load_class(prov_name)
            else
              prov_class = Class.for_name(prov_name)
            end
            prov_arg = @provider_args.get(prov_name)
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
        @has_expired_cert = false
        @has_expiring_cert = false
        @not_yet_valid_cert = false
        @bad_key_usage = false
        @bad_extended_key_usage = false
        @bad_netscape_cert_type = false
        if (@verify)
          begin
            load_key_store(@keystore, false)
            @scope = IdentityScope.get_system_scope
          rescue JavaException => e
            if ((!(@keystore).nil?) || (!(@storepass).nil?))
              System.out.println(Rb.get_string("jarsigner error: ") + e.get_message)
              System.exit(1)
            end
          end
          # if (debug) {
          # SignatureFileVerifier.setDebug(true);
          # ManifestEntryVerifier.setDebug(true);
          # }
          verify_jar(@jarfile)
        else
          load_key_store(@keystore, true)
          get_alias_info(@alias)
          # load the alternative signing mechanism
          if (!(@alt_signer_class).nil?)
            @signing_mechanism = load_signing_mechanism(@alt_signer_class, @alt_signer_classpath)
          end
          sign_jar(@jarfile, @alias, args)
        end
      rescue JavaException => e
        System.out.println(Rb.get_string("jarsigner error: ") + e)
        if (@debug)
          e.print_stack_trace
        end
        System.exit(1)
      ensure
        # zero-out private key password
        if (!(@keypass).nil?)
          Arrays.fill(@keypass, Character.new(?\s.ord))
          @keypass = nil
        end
        # zero-out keystore password
        if (!(@storepass).nil?)
          Arrays.fill(@storepass, Character.new(?\s.ord))
          @storepass = nil
        end
      end
    end
    
    typesig { [Array.typed(String)] }
    # Parse command line arguments.
    def parse_args(args)
      # parse flags
      n = 0
      n = 0
      while (n < args.attr_length) && args[n].starts_with("-")
        flags = args[n]
        if ((Collator.compare(flags, "-keystore")).equal?(0))
          if (((n += 1)).equal?(args.attr_length))
            usage
          end
          @keystore = RJava.cast_to_string(args[n])
        else
          if ((Collator.compare(flags, "-storepass")).equal?(0))
            if (((n += 1)).equal?(args.attr_length))
              usage
            end
            @storepass = args[n].to_char_array
          else
            if ((Collator.compare(flags, "-storetype")).equal?(0))
              if (((n += 1)).equal?(args.attr_length))
                usage
              end
              @storetype = RJava.cast_to_string(args[n])
            else
              if ((Collator.compare(flags, "-providerName")).equal?(0))
                if (((n += 1)).equal?(args.attr_length))
                  usage
                end
                @provider_name = RJava.cast_to_string(args[n])
              else
                if (((Collator.compare(flags, "-provider")).equal?(0)) || ((Collator.compare(flags, "-providerClass")).equal?(0)))
                  if (((n += 1)).equal?(args.attr_length))
                    usage
                  end
                  if ((@providers).nil?)
                    @providers = Vector.new(3)
                  end
                  @providers.add(args[n])
                  if (args.attr_length > (n + 1))
                    flags = RJava.cast_to_string(args[n + 1])
                    if ((Collator.compare(flags, "-providerArg")).equal?(0))
                      if ((args.attr_length).equal?((n + 2)))
                        usage
                      end
                      @provider_args.put(args[n], args[n + 2])
                      n += 2
                    end
                  end
                else
                  if ((Collator.compare(flags, "-protected")).equal?(0))
                    @protected_path = true
                  else
                    if ((Collator.compare(flags, "-debug")).equal?(0))
                      @debug = true
                    else
                      if ((Collator.compare(flags, "-keypass")).equal?(0))
                        if (((n += 1)).equal?(args.attr_length))
                          usage
                        end
                        @keypass = args[n].to_char_array
                      else
                        if ((Collator.compare(flags, "-sigfile")).equal?(0))
                          if (((n += 1)).equal?(args.attr_length))
                            usage
                          end
                          @sigfile = RJava.cast_to_string(args[n])
                        else
                          if ((Collator.compare(flags, "-signedjar")).equal?(0))
                            if (((n += 1)).equal?(args.attr_length))
                              usage
                            end
                            @signedjar = RJava.cast_to_string(args[n])
                          else
                            if ((Collator.compare(flags, "-tsa")).equal?(0))
                              if (((n += 1)).equal?(args.attr_length))
                                usage
                              end
                              @tsa_url = RJava.cast_to_string(args[n])
                            else
                              if ((Collator.compare(flags, "-tsacert")).equal?(0))
                                if (((n += 1)).equal?(args.attr_length))
                                  usage
                                end
                                @tsa_alias = RJava.cast_to_string(args[n])
                              else
                                if ((Collator.compare(flags, "-altsigner")).equal?(0))
                                  if (((n += 1)).equal?(args.attr_length))
                                    usage
                                  end
                                  @alt_signer_class = RJava.cast_to_string(args[n])
                                else
                                  if ((Collator.compare(flags, "-altsignerpath")).equal?(0))
                                    if (((n += 1)).equal?(args.attr_length))
                                      usage
                                    end
                                    @alt_signer_classpath = RJava.cast_to_string(args[n])
                                  else
                                    if ((Collator.compare(flags, "-sectionsonly")).equal?(0))
                                      @sign_manifest = false
                                    else
                                      if ((Collator.compare(flags, "-internalsf")).equal?(0))
                                        @external_sf = false
                                      else
                                        if ((Collator.compare(flags, "-verify")).equal?(0))
                                          @verify = true
                                        else
                                          if ((Collator.compare(flags, "-verbose")).equal?(0))
                                            @verbose = true
                                          else
                                            if ((Collator.compare(flags, "-sigalg")).equal?(0))
                                              if (((n += 1)).equal?(args.attr_length))
                                                usage
                                              end
                                              @sigalg = RJava.cast_to_string(args[n])
                                            else
                                              if ((Collator.compare(flags, "-digestalg")).equal?(0))
                                                if (((n += 1)).equal?(args.attr_length))
                                                  usage
                                                end
                                                @digestalg = RJava.cast_to_string(args[n])
                                              else
                                                if ((Collator.compare(flags, "-certs")).equal?(0))
                                                  @showcerts = true
                                                else
                                                  if ((Collator.compare(flags, "-h")).equal?(0) || (Collator.compare(flags, "-help")).equal?(0))
                                                    usage
                                                  else
                                                    System.err.println(RJava.cast_to_string(Rb.get_string("Illegal option: ")) + flags)
                                                    usage
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
        n += 1
      end
      if ((n).equal?(args.attr_length))
        usage
      end
      @jarfile = RJava.cast_to_string(args[((n += 1) - 1)])
      if (!@verify)
        if ((n).equal?(args.attr_length))
          usage
        end
        @alias = RJava.cast_to_string(args[((n += 1) - 1)])
      end
      if ((@storetype).nil?)
        @storetype = RJava.cast_to_string(KeyStore.get_default_type)
      end
      @storetype = RJava.cast_to_string(KeyStoreUtil.nice_store_type_name(@storetype))
      if (P11KEYSTORE.equals_ignore_case(@storetype) || KeyStoreUtil.is_windows_key_store(@storetype))
        @token = true
        if ((@keystore).nil?)
          @keystore = NONE
        end
      end
      if ((NONE == @keystore))
        @null_stream = true
      end
      if (@token && !@null_stream)
        System.err.println(MessageFormat.format(Rb.get_string("-keystore must be NONE if -storetype is {0}"), @storetype))
        System.err.println
        usage
      end
      if (@token && !(@keypass).nil?)
        System.err.println(MessageFormat.format(Rb.get_string("-keypass can not be specified " + "if -storetype is {0}"), @storetype))
        System.err.println
        usage
      end
      if (@protected_path)
        if (!(@storepass).nil? || !(@keypass).nil?)
          System.err.println(Rb.get_string("If -protected is specified, " + "then -storepass and -keypass must not be specified"))
          System.err.println
          usage
        end
      end
      if (KeyStoreUtil.is_windows_key_store(@storetype))
        if (!(@storepass).nil? || !(@keypass).nil?)
          System.err.println(Rb.get_string("If keystore is not password protected, " + "then -storepass and -keypass must not be specified"))
          System.err.println
          usage
        end
      end
    end
    
    typesig { [] }
    def usage
      System.out.println(Rb.get_string("Usage: jarsigner [options] jar-file alias"))
      System.out.println(Rb.get_string("       jarsigner -verify [options] jar-file"))
      System.out.println
      System.out.println(Rb.get_string("[-keystore <url>]           keystore location"))
      System.out.println
      System.out.println(Rb.get_string("[-storepass <password>]     password for keystore integrity"))
      System.out.println
      System.out.println(Rb.get_string("[-storetype <type>]         keystore type"))
      System.out.println
      System.out.println(Rb.get_string("[-keypass <password>]       password for private key (if different)"))
      System.out.println
      System.out.println(Rb.get_string("[-sigfile <file>]           name of .SF/.DSA file"))
      System.out.println
      System.out.println(Rb.get_string("[-signedjar <file>]         name of signed JAR file"))
      System.out.println
      System.out.println(Rb.get_string("[-digestalg <algorithm>]    name of digest algorithm"))
      System.out.println
      System.out.println(Rb.get_string("[-sigalg <algorithm>]       name of signature algorithm"))
      System.out.println
      System.out.println(Rb.get_string("[-verify]                   verify a signed JAR file"))
      System.out.println
      System.out.println(Rb.get_string("[-verbose]                  verbose output when signing/verifying"))
      System.out.println
      System.out.println(Rb.get_string("[-certs]                    display certificates when verbose and verifying"))
      System.out.println
      System.out.println(Rb.get_string("[-tsa <url>]                location of the Timestamping Authority"))
      System.out.println
      System.out.println(Rb.get_string("[-tsacert <alias>]          public key certificate for Timestamping Authority"))
      System.out.println
      System.out.println(Rb.get_string("[-altsigner <class>]        class name of an alternative signing mechanism"))
      System.out.println
      System.out.println(Rb.get_string("[-altsignerpath <pathlist>] location of an alternative signing mechanism"))
      System.out.println
      System.out.println(Rb.get_string("[-internalsf]               include the .SF file inside the signature block"))
      System.out.println
      System.out.println(Rb.get_string("[-sectionsonly]             don't compute hash of entire manifest"))
      System.out.println
      System.out.println(Rb.get_string("[-protected]                keystore has protected authentication path"))
      System.out.println
      System.out.println(Rb.get_string("[-providerName <name>]      provider name"))
      System.out.println
      System.out.println(Rb.get_string("[-providerClass <class>     name of cryptographic service provider's"))
      System.out.println(Rb.get_string("  [-providerArg <arg>]] ... master class file and constructor argument"))
      System.out.println
      System.exit(1)
    end
    
    typesig { [String] }
    def verify_jar(jar_name)
      any_signed = false
      has_unsigned_entry = false
      jf = nil
      begin
        jf = JarFile.new(jar_name, true)
        entries_vec = Vector.new
        buffer = Array.typed(::Java::Byte).new(8192) { 0 }
        entries_ = jf.entries
        while (entries_.has_more_elements)
          je = entries_.next_element
          entries_vec.add_element(je)
          is = nil
          begin
            is = jf.get_input_stream(je)
            n = 0
            while (!((n = is.read(buffer, 0, buffer.attr_length))).equal?(-1))
            end
          ensure
            if (!(is).nil?)
              is.close
            end
          end
        end
        man = jf.get_manifest
        if (!(man).nil?)
          if (@verbose)
            System.out.println
          end
          e = entries_vec.elements
          now = System.current_time_millis
          while (e.has_more_elements)
            je = e.next_element
            name = je.get_name
            signers = je.get_code_signers
            is_signed = (!(signers).nil?)
            any_signed |= is_signed
            has_unsigned_entry |= !je.is_directory && !is_signed && !signature_related(name)
            if (@verbose)
              in_store_or_scope = in_key_store(signers)
              in_store = !((in_store_or_scope & IN_KEYSTORE)).equal?(0)
              in_scope = !((in_store_or_scope & IN_SCOPE)).equal?(0)
              in_manifest = ((!(man.get_attributes(name)).nil?) || (!(man.get_attributes("./" + name)).nil?) || (!(man.get_attributes("/" + name)).nil?))
              System.out.print((is_signed ? Rb.get_string("s") : Rb.get_string(" ")) + (in_manifest ? Rb.get_string("m") : Rb.get_string(" ")) + (in_store ? Rb.get_string("k") : Rb.get_string(" ")) + (in_scope ? Rb.get_string("i") : Rb.get_string(" ")) + Rb.get_string("  "))
              sb = StringBuffer.new
              s = Long.to_s(je.get_size)
              i = 6 - s.length
              while i > 0
                sb.append(Character.new(?\s.ord))
                (i -= 1)
              end
              sb.append(s).append(Character.new(?\s.ord)).append(JavaDate.new(je.get_time).to_s)
              sb.append(Character.new(?\s.ord)).append(je.get_name)
              System.out.println(sb.to_s)
              if (!(signers).nil? && @showcerts)
                tab = Rb.get_string("      ")
                i_ = 0
                while i_ < signers.attr_length
                  System.out.println
                  certs = signers[i_].get_signer_cert_path.get_certificates
                  # display the signature timestamp, if present
                  timestamp = signers[i_].get_timestamp
                  if (!(timestamp).nil?)
                    System.out.println(print_timestamp(tab, timestamp))
                  end
                  # display the certificate(s)
                  certs.each do |c|
                    System.out.println(print_cert(tab, c, true, now))
                  end
                  i_ += 1
                end
                System.out.println
              end
            end
            if (is_signed)
              i = 0
              while i < signers.attr_length
                cert = signers[i].get_signer_cert_path.get_certificates.get(0)
                if (cert.is_a?(X509Certificate))
                  check_cert_usage(cert, nil)
                  if (!@showcerts)
                    not_after = (cert).get_not_after.get_time
                    if (not_after < now)
                      @has_expired_cert = true
                    else
                      if (not_after < now + SIX_MONTHS)
                        @has_expiring_cert = true
                      end
                    end
                  end
                end
                i += 1
              end
            end
          end
        end
        if (@verbose)
          System.out.println
          System.out.println(Rb.get_string("  s = signature was verified "))
          System.out.println(Rb.get_string("  m = entry is listed in manifest"))
          System.out.println(Rb.get_string("  k = at least one certificate was found in keystore"))
          System.out.println(Rb.get_string("  i = at least one certificate was found in identity scope"))
          System.out.println
        end
        if ((man).nil?)
          System.out.println(Rb.get_string("no manifest."))
        end
        if (!any_signed)
          System.out.println(Rb.get_string("jar is unsigned. (signatures missing or not parsable)"))
        else
          System.out.println(Rb.get_string("jar verified."))
          if (has_unsigned_entry || @has_expired_cert || @has_expiring_cert || @bad_key_usage || @bad_extended_key_usage || @bad_netscape_cert_type || @not_yet_valid_cert)
            System.out.println
            System.out.println(Rb.get_string("Warning: "))
            if (@bad_key_usage)
              System.out.println(Rb.get_string("This jar contains entries whose signer certificate's KeyUsage extension doesn't allow code signing."))
            end
            if (@bad_extended_key_usage)
              System.out.println(Rb.get_string("This jar contains entries whose signer certificate's ExtendedKeyUsage extension doesn't allow code signing."))
            end
            if (@bad_netscape_cert_type)
              System.out.println(Rb.get_string("This jar contains entries whose signer certificate's NetscapeCertType extension doesn't allow code signing."))
            end
            if (has_unsigned_entry)
              System.out.println(Rb.get_string("This jar contains unsigned entries which have not been integrity-checked. "))
            end
            if (@has_expired_cert)
              System.out.println(Rb.get_string("This jar contains entries whose signer certificate has expired. "))
            end
            if (@has_expiring_cert)
              System.out.println(Rb.get_string("This jar contains entries whose signer certificate will expire within six months. "))
            end
            if (@not_yet_valid_cert)
              System.out.println(Rb.get_string("This jar contains entries whose signer certificate is not yet valid. "))
            end
            if (!(@verbose && @showcerts))
              System.out.println
              System.out.println(Rb.get_string("Re-run with the -verbose and -certs options for more details."))
            end
          end
        end
        System.exit(0)
      rescue JavaException => e
        System.out.println(Rb.get_string("jarsigner: ") + e)
        if (@debug)
          e.print_stack_trace
        end
      ensure
        # close the resource
        if (!(jf).nil?)
          jf.close
        end
      end
      System.exit(1)
    end
    
    typesig { [Certificate] }
    # Display some details about a certificate:
    # 
    # <cert-type> [", " <subject-DN>] [" (" <keystore-entry-alias> ")"]
    def print_cert(c)
      return print_cert("", c, false, 0)
    end
    
    class_module.module_eval {
      
      def validity_time_form
        defined?(@@validity_time_form) ? @@validity_time_form : @@validity_time_form= nil
      end
      alias_method :attr_validity_time_form, :validity_time_form
      
      def validity_time_form=(value)
        @@validity_time_form = value
      end
      alias_method :attr_validity_time_form=, :validity_time_form=
      
      
      def not_yet_time_form
        defined?(@@not_yet_time_form) ? @@not_yet_time_form : @@not_yet_time_form= nil
      end
      alias_method :attr_not_yet_time_form, :not_yet_time_form
      
      def not_yet_time_form=(value)
        @@not_yet_time_form = value
      end
      alias_method :attr_not_yet_time_form=, :not_yet_time_form=
      
      
      def expired_time_form
        defined?(@@expired_time_form) ? @@expired_time_form : @@expired_time_form= nil
      end
      alias_method :attr_expired_time_form, :expired_time_form
      
      def expired_time_form=(value)
        @@expired_time_form = value
      end
      alias_method :attr_expired_time_form=, :expired_time_form=
      
      
      def expiring_time_form
        defined?(@@expiring_time_form) ? @@expiring_time_form : @@expiring_time_form= nil
      end
      alias_method :attr_expiring_time_form, :expiring_time_form
      
      def expiring_time_form=(value)
        @@expiring_time_form = value
      end
      alias_method :attr_expiring_time_form=, :expiring_time_form=
    }
    
    typesig { [String, Certificate, ::Java::Boolean, ::Java::Long] }
    # Display some details about a certificate:
    # 
    # [<tab>] <cert-type> [", " <subject-DN>] [" (" <keystore-entry-alias> ")"]
    # [<validity-period> | <expiry-warning>]
    def print_cert(tab, c, check_validity_period, now)
      cert_str = StringBuilder.new
      space = Rb.get_string(" ")
      x509cert = nil
      if (c.is_a?(X509Certificate))
        x509cert = c
        cert_str.append(tab).append(x509cert.get_type).append(Rb.get_string(", ")).append(x509cert.get_subject_dn.get_name)
      else
        cert_str.append(tab).append(c.get_type)
      end
      alias_ = @store_hash.get(c)
      if (!(alias_).nil?)
        cert_str.append(space).append(alias_)
      end
      if (check_validity_period && !(x509cert).nil?)
        cert_str.append("\n").append(tab).append("[")
        not_after = x509cert.get_not_after
        begin
          x509cert.check_validity
          # test if cert will expire within six months
          if ((now).equal?(0))
            now = System.current_time_millis
          end
          if (not_after.get_time < now + SIX_MONTHS)
            @has_expiring_cert = true
            if ((self.attr_expiring_time_form).nil?)
              self.attr_expiring_time_form = MessageFormat.new(Rb.get_string("certificate will expire on"))
            end
            source = Array.typed(Object).new([not_after])
            cert_str.append(self.attr_expiring_time_form.format(source))
          else
            if ((self.attr_validity_time_form).nil?)
              self.attr_validity_time_form = MessageFormat.new(Rb.get_string("certificate is valid from"))
            end
            source = Array.typed(Object).new([x509cert.get_not_before, not_after])
            cert_str.append(self.attr_validity_time_form.format(source))
          end
        rescue CertificateExpiredException => cee
          @has_expired_cert = true
          if ((self.attr_expired_time_form).nil?)
            self.attr_expired_time_form = MessageFormat.new(Rb.get_string("certificate expired on"))
          end
          source = Array.typed(Object).new([not_after])
          cert_str.append(self.attr_expired_time_form.format(source))
        rescue CertificateNotYetValidException => cnyve
          @not_yet_valid_cert = true
          if ((self.attr_not_yet_time_form).nil?)
            self.attr_not_yet_time_form = MessageFormat.new(Rb.get_string("certificate is not valid until"))
          end
          source = Array.typed(Object).new([x509cert.get_not_before])
          cert_str.append(self.attr_not_yet_time_form.format(source))
        end
        cert_str.append("]")
        bad = Array.typed(::Java::Boolean).new(3) { false }
        check_cert_usage(x509cert, bad)
        if (bad[0] || bad[1] || bad[2])
          x = ""
          if (bad[0])
            x = "KeyUsage"
          end
          if (bad[1])
            if (x.length > 0)
              x = x + ", "
            end
            x = x + "ExtendedKeyUsage"
          end
          if (bad[2])
            if (x.length > 0)
              x = x + ", "
            end
            x = x + "NetscapeCertType"
          end
          cert_str.append("\n").append(tab).append(MessageFormat.format(Rb.get_string("[{0} extension does not support code signing]"), x))
        end
      end
      return cert_str.to_s
    end
    
    class_module.module_eval {
      
      def sign_time_form
        defined?(@@sign_time_form) ? @@sign_time_form : @@sign_time_form= nil
      end
      alias_method :attr_sign_time_form, :sign_time_form
      
      def sign_time_form=(value)
        @@sign_time_form = value
      end
      alias_method :attr_sign_time_form=, :sign_time_form=
    }
    
    typesig { [String, Timestamp] }
    def print_timestamp(tab, timestamp)
      if ((self.attr_sign_time_form).nil?)
        self.attr_sign_time_form = MessageFormat.new(Rb.get_string("entry was signed on"))
      end
      source = Array.typed(Object).new([timestamp.get_timestamp])
      return StringBuilder.new.append(tab).append("[").append(self.attr_sign_time_form.format(source)).append("]").to_s
    end
    
    attr_accessor :store_hash
    alias_method :attr_store_hash, :store_hash
    undef_method :store_hash
    alias_method :attr_store_hash=, :store_hash=
    undef_method :store_hash=
    
    typesig { [Array.typed(CodeSigner)] }
    def in_key_store(signers)
      result = 0
      if ((signers).nil?)
        return 0
      end
      found = false
      i = 0
      while i < signers.attr_length
        found = false
        certs = signers[i].get_signer_cert_path.get_certificates
        certs.each do |c|
          alias_ = @store_hash.get(c)
          if (!(alias_).nil?)
            if (alias_.starts_with("("))
              result |= IN_KEYSTORE
            else
              if (alias_.starts_with("["))
                result |= IN_SCOPE
              end
            end
          else
            if (!(@store).nil?)
              begin
                alias_ = RJava.cast_to_string(@store.get_certificate_alias(c))
              rescue KeyStoreException => kse
                # never happens, because keystore has been loaded
              end
              if (!(alias_).nil?)
                @store_hash.put(c, "(" + alias_ + ")")
                found = true
                result |= IN_KEYSTORE
              end
            end
            if (!found && (!(@scope).nil?))
              id = @scope.get_identity(c.get_public_key)
              if (!(id).nil?)
                result |= IN_SCOPE
                @store_hash.put(c, "[" + RJava.cast_to_string(id.get_name) + "]")
              end
            end
          end
        end
        i += 1
      end
      return result
    end
    
    typesig { [String, String, Array.typed(String)] }
    def sign_jar(jar_name, alias_, args)
      alias_used = false
      tsa_cert = nil
      if ((@sigfile).nil?)
        @sigfile = alias_
        alias_used = true
      end
      if (@sigfile.length > 8)
        @sigfile = RJava.cast_to_string(@sigfile.substring(0, 8).to_upper_case)
      else
        @sigfile = RJava.cast_to_string(@sigfile.to_upper_case)
      end
      tmp_sig_file = StringBuilder.new(@sigfile.length)
      j = 0
      while j < @sigfile.length
        c = @sigfile.char_at(j)
        if (!((c >= Character.new(?A.ord) && c <= Character.new(?Z.ord)) || (c >= Character.new(?0.ord) && c <= Character.new(?9.ord)) || ((c).equal?(Character.new(?-.ord))) || ((c).equal?(Character.new(?_.ord)))))
          if (alias_used)
            # convert illegal characters from the alias to be _'s
            c = Character.new(?_.ord)
          else
            raise RuntimeException.new(Rb.get_string("signature filename must consist of the following characters: A-Z, 0-9, _ or -"))
          end
        end
        tmp_sig_file.append(c)
        j += 1
      end
      @sigfile = RJava.cast_to_string(tmp_sig_file.to_s)
      tmp_jar_name = nil
      if ((@signedjar).nil?)
        tmp_jar_name = jar_name + ".sig"
      else
        tmp_jar_name = @signedjar
      end
      jar_file = JavaFile.new(jar_name)
      signed_jar_file = JavaFile.new(tmp_jar_name)
      # Open the jar (zip) file
      begin
        @zip_file = ZipFile.new(jar_name)
      rescue IOException => ioe
        error(RJava.cast_to_string(Rb.get_string("unable to open jar file: ")) + jar_name, ioe)
      end
      fos = nil
      begin
        fos = FileOutputStream.new(signed_jar_file)
      rescue IOException => ioe
        error(RJava.cast_to_string(Rb.get_string("unable to create: ")) + tmp_jar_name, ioe)
      end
      ps = PrintStream.new(fos)
      zos = ZipOutputStream.new(ps)
      # First guess at what they might be - we don't xclude RSA ones.
      sf_filename = (META_INF + @sigfile + ".SF").to_upper_case
      bk_filename = (META_INF + @sigfile + ".DSA").to_upper_case
      manifest = Manifest.new
      mf_entries = manifest.get_entries
      # The Attributes of manifest before updating
      old_attr = nil
      mf_modified = false
      mf_created = false
      mf_raw_bytes = nil
      begin
        digests = Array.typed(MessageDigest).new([MessageDigest.get_instance(@digestalg)])
        # Check if manifest exists
        mf_file = nil
        if (!((mf_file = get_manifest_file(@zip_file))).nil?)
          # Manifest exists. Read its raw bytes.
          mf_raw_bytes = get_bytes(@zip_file, mf_file)
          manifest.read(ByteArrayInputStream.new(mf_raw_bytes))
          old_attr = (manifest.get_main_attributes.clone)
        else
          # Create new manifest
          mattr = manifest.get_main_attributes
          mattr.put_value(Attributes::Name::MANIFEST_VERSION.to_s, "1.0")
          java_vendor = System.get_property("java.vendor")
          jdk_version = System.get_property("java.version")
          mattr.put_value("Created-By", jdk_version + " (" + java_vendor + ")")
          mf_file = ZipEntry.new(JarFile::MANIFEST_NAME)
          mf_created = true
        end
        # For each entry in jar
        # (except for signature-related META-INF entries),
        # do the following:
        # 
        # - if entry is not contained in manifest, add it to manifest;
        # - if entry is contained in manifest, calculate its hash and
        # compare it with the one in the manifest; if they are
        # different, replace the hash in the manifest with the newly
        # generated one. (This may invalidate existing signatures!)
        encoder = JarBASE64Encoder.new
        mf_files = Vector.new
        enum_ = @zip_file.entries
        while enum_.has_more_elements
          ze = enum_.next_element
          if (ze.get_name.starts_with(META_INF))
            # Store META-INF files in vector, so they can be written
            # out first
            mf_files.add_element(ze)
            if (signature_related(ze.get_name))
              # ignore signature-related and manifest files
              next
            end
          end
          if (!(manifest.get_attributes(ze.get_name)).nil?)
            # jar entry is contained in manifest, check and
            # possibly update its digest attributes
            if ((update_digests(ze, @zip_file, digests, encoder, manifest)).equal?(true))
              mf_modified = true
            end
          else
            if (!ze.is_directory)
              # Add entry to manifest
              attrs = get_digest_attributes(ze, @zip_file, digests, encoder)
              mf_entries.put(ze.get_name, attrs)
              mf_modified = true
            end
          end
        end
        # Recalculate the manifest raw bytes if necessary
        if (mf_modified)
          baos = ByteArrayOutputStream.new
          manifest.write(baos)
          new_bytes = baos.to_byte_array
          if (!(mf_raw_bytes).nil? && (old_attr == manifest.get_main_attributes))
            # Note:
            # 
            # The Attributes object is based on HashMap and can handle
            # continuation columns. Therefore, even if the contents are
            # not changed (in a Map view), the bytes that it write()
            # may be different from the original bytes that it read()
            # from. Since the signature on the main attributes is based
            # on raw bytes, we must retain the exact bytes.
            new_pos = find_header_end(new_bytes)
            old_pos = find_header_end(mf_raw_bytes)
            if ((new_pos).equal?(old_pos))
              System.arraycopy(mf_raw_bytes, 0, new_bytes, 0, old_pos)
            else
              # cat oldHead newTail > newBytes
              last_bytes = Array.typed(::Java::Byte).new(old_pos + new_bytes.attr_length - new_pos) { 0 }
              System.arraycopy(mf_raw_bytes, 0, last_bytes, 0, old_pos)
              System.arraycopy(new_bytes, new_pos, last_bytes, old_pos, new_bytes.attr_length - new_pos)
              new_bytes = last_bytes
            end
          end
          mf_raw_bytes = new_bytes
        end
        # Write out the manifest
        if (mf_modified)
          # manifest file has new length
          mf_file = ZipEntry.new(JarFile::MANIFEST_NAME)
        end
        if (@verbose)
          if (mf_created)
            System.out.println(Rb.get_string("   adding: ") + mf_file.get_name)
          else
            if (mf_modified)
              System.out.println(Rb.get_string(" updating: ") + mf_file.get_name)
            end
          end
        end
        zos.put_next_entry(mf_file)
        zos.write(mf_raw_bytes)
        # Calculate SignatureFile (".SF") and SignatureBlockFile
        man_dig = ManifestDigester.new(mf_raw_bytes)
        sf = SignatureFile.new(digests, manifest, man_dig, @sigfile, @sign_manifest)
        if (!(@tsa_alias).nil?)
          tsa_cert = get_tsa_cert(@tsa_alias)
        end
        block = nil
        begin
          block = sf.generate_block(@private_key, @sigalg, @cert_chain, @external_sf, @tsa_url, tsa_cert, @signing_mechanism, args, @zip_file)
        rescue SocketTimeoutException => e
          # Provide a helpful message when TSA is beyond a firewall
          error(RJava.cast_to_string(Rb.get_string("unable to sign jar: ") + Rb.get_string("no response from the Timestamping Authority. ") + Rb.get_string("When connecting from behind a firewall then an HTTP proxy may need to be specified. ") + Rb.get_string("Supply the following options to jarsigner: ")) + "\n  -J-Dhttp.proxyHost=<hostname> " + "\n  -J-Dhttp.proxyPort=<portnumber> ", e)
        end
        sf_filename = RJava.cast_to_string(sf.get_meta_name)
        bk_filename = RJava.cast_to_string(block.get_meta_name)
        sf_file = ZipEntry.new(sf_filename)
        bk_file = ZipEntry.new(bk_filename)
        time = System.current_time_millis
        sf_file.set_time(time)
        bk_file.set_time(time)
        # signature file
        zos.put_next_entry(sf_file)
        sf.write(zos)
        if (@verbose)
          if (!(@zip_file.get_entry(sf_filename)).nil?)
            System.out.println(RJava.cast_to_string(Rb.get_string(" updating: ")) + sf_filename)
          else
            System.out.println(RJava.cast_to_string(Rb.get_string("   adding: ")) + sf_filename)
          end
        end
        if (@verbose)
          if (!(@tsa_url).nil? || !(tsa_cert).nil?)
            System.out.println(Rb.get_string("requesting a signature timestamp"))
          end
          if (!(@tsa_url).nil?)
            System.out.println(RJava.cast_to_string(Rb.get_string("TSA location: ")) + @tsa_url)
          end
          if (!(tsa_cert).nil?)
            cert_url = TimestampedSigner.get_timestamping_url(tsa_cert)
            if (!(cert_url).nil?)
              System.out.println(RJava.cast_to_string(Rb.get_string("TSA location: ")) + cert_url)
            end
            System.out.println(Rb.get_string("TSA certificate: ") + print_cert(tsa_cert))
          end
          if (!(@signing_mechanism).nil?)
            System.out.println(Rb.get_string("using an alternative signing mechanism"))
          end
        end
        # signature block file
        zos.put_next_entry(bk_file)
        block.write(zos)
        if (@verbose)
          if (!(@zip_file.get_entry(bk_filename)).nil?)
            System.out.println(RJava.cast_to_string(Rb.get_string(" updating: ")) + bk_filename)
          else
            System.out.println(RJava.cast_to_string(Rb.get_string("   adding: ")) + bk_filename)
          end
        end
        # Write out all other META-INF files that we stored in the
        # vector
        i = 0
        while i < mf_files.size
          ze = mf_files.element_at(i)
          if (!ze.get_name.equals_ignore_case(JarFile::MANIFEST_NAME) && !ze.get_name.equals_ignore_case(sf_filename) && !ze.get_name.equals_ignore_case(bk_filename))
            write_entry(@zip_file, zos, ze)
          end
          i += 1
        end
        # Write out all other files
        enum__ = @zip_file.entries
        while enum__.has_more_elements
          ze = enum__.next_element
          if (!ze.get_name.starts_with(META_INF))
            if (@verbose)
              if (!(manifest.get_attributes(ze.get_name)).nil?)
                System.out.println(Rb.get_string("  signing: ") + ze.get_name)
              else
                System.out.println(Rb.get_string("   adding: ") + ze.get_name)
              end
            end
            write_entry(@zip_file, zos, ze)
          end
        end
      rescue IOException => ioe
        error(Rb.get_string("unable to sign jar: ") + ioe, ioe)
      ensure
        # close the resouces
        if (!(@zip_file).nil?)
          @zip_file.close
          @zip_file = nil
        end
        if (!(zos).nil?)
          zos.close
        end
      end
      # no IOException thrown in the follow try clause, so disable
      # the try clause.
      # try {
      if ((@signedjar).nil?)
        # attempt an atomic rename. If that fails,
        # rename the original jar file, then the signed
        # one, then delete the original.
        if (!signed_jar_file.rename_to(jar_file))
          orig_jar = JavaFile.new(jar_name + ".orig")
          if (jar_file.rename_to(orig_jar))
            if (signed_jar_file.rename_to(jar_file))
              orig_jar.delete
            else
              form = MessageFormat.new(Rb.get_string("attempt to rename signedJarFile to jarFile failed"))
              source = Array.typed(Object).new([signed_jar_file, jar_file])
              error(form.format(source))
            end
          else
            form = MessageFormat.new(Rb.get_string("attempt to rename jarFile to origJar failed"))
            source = Array.typed(Object).new([jar_file, orig_jar])
            error(form.format(source))
          end
        end
      end
      if (@has_expired_cert || @has_expiring_cert || @not_yet_valid_cert || @bad_key_usage || @bad_extended_key_usage || @bad_netscape_cert_type)
        System.out.println
        System.out.println(Rb.get_string("Warning: "))
        if (@bad_key_usage)
          System.out.println(Rb.get_string("The signer certificate's KeyUsage extension doesn't allow code signing."))
        end
        if (@bad_extended_key_usage)
          System.out.println(Rb.get_string("The signer certificate's ExtendedKeyUsage extension doesn't allow code signing."))
        end
        if (@bad_netscape_cert_type)
          System.out.println(Rb.get_string("The signer certificate's NetscapeCertType extension doesn't allow code signing."))
        end
        if (@has_expired_cert)
          System.out.println(Rb.get_string("The signer certificate has expired."))
        else
          if (@has_expiring_cert)
            System.out.println(Rb.get_string("The signer certificate will expire within six months."))
          else
            if (@not_yet_valid_cert)
              System.out.println(Rb.get_string("The signer certificate is not yet valid."))
            end
          end
        end
      end
      # no IOException thrown in the above try clause, so disable
      # the catch clause.
      # } catch(IOException ioe) {
      # error(rb.getString("unable to sign jar: ")+ioe, ioe);
      # }
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Find the position of \r\n\r\n inside bs
    def find_header_end(bs)
      i = 0
      while i < bs.attr_length - 3
        if ((bs[i]).equal?(Character.new(?\r.ord)) && (bs[i + 1]).equal?(Character.new(?\n.ord)) && (bs[i + 2]).equal?(Character.new(?\r.ord)) && (bs[i + 3]).equal?(Character.new(?\n.ord)))
          return i
        end
        i += 1
      end
      # If header end is not found, return 0,
      # which means no behavior change.
      return 0
    end
    
    typesig { [String] }
    # signature-related files include:
    # . META-INF/MANIFEST.MF
    # . META-INF/SIG-*
    # . META-INF/*.SF
    # . META-INF/*.DSA
    # . META-INF/*.RSA
    def signature_related(name)
      uc_name = name.to_upper_case
      if ((uc_name == JarFile::MANIFEST_NAME) || (uc_name == META_INF) || (uc_name.starts_with(SIG_PREFIX) && (uc_name.index_of("/")).equal?(uc_name.last_index_of("/"))))
        return true
      end
      if (uc_name.starts_with(META_INF) && SignatureFileVerifier.is_block_or_sf(uc_name))
        # .SF/.DSA/.RSA files in META-INF subdirs
        # are not considered signature-related
        return ((uc_name.index_of("/")).equal?(uc_name.last_index_of("/")))
      end
      return false
    end
    
    typesig { [ZipFile, ZipOutputStream, ZipEntry] }
    def write_entry(zf, os, ze)
      ze2 = ZipEntry.new(ze.get_name)
      ze2.set_method(ze.get_method)
      ze2.set_time(ze.get_time)
      ze2.set_comment(ze.get_comment)
      ze2.set_extra(ze.get_extra)
      if ((ze.get_method).equal?(ZipEntry::STORED))
        ze2.set_size(ze.get_size)
        ze2.set_crc(ze.get_crc)
      end
      os.put_next_entry(ze2)
      write_bytes(zf, ze, os)
    end
    
    typesig { [ZipFile, ZipEntry, ZipOutputStream] }
    # Writes all the bytes for a given entry to the specified output stream.
    def write_bytes(zf, ze, os)
      synchronized(self) do
        n = 0
        is = nil
        begin
          is = zf.get_input_stream(ze)
          left = ze.get_size
          while ((left > 0) && !((n = is.read(@buffer, 0, @buffer.attr_length))).equal?(-1))
            os.write(@buffer, 0, n)
            left -= n
          end
        ensure
          if (!(is).nil?)
            is.close
          end
        end
      end
    end
    
    typesig { [String, ::Java::Boolean] }
    def load_key_store(key_store_name, prompt)
      if (!@null_stream && (key_store_name).nil?)
        key_store_name = RJava.cast_to_string(System.get_property("user.home") + JavaFile.attr_separator) + ".keystore"
      end
      begin
        if ((@provider_name).nil?)
          @store = KeyStore.get_instance(@storetype)
        else
          @store = KeyStore.get_instance(@storetype, @provider_name)
        end
        # Get pass phrase
        # XXX need to disable echo; on UNIX, call getpass(char *prompt)Z
        # and on NT call ??
        if (@token && (@storepass).nil? && !@protected_path && !KeyStoreUtil.is_windows_key_store(@storetype))
          @storepass = get_pass(Rb.get_string("Enter Passphrase for keystore: "))
        else
          if (!@token && (@storepass).nil? && prompt)
            @storepass = get_pass(Rb.get_string("Enter Passphrase for keystore: "))
          end
        end
        if (@null_stream)
          @store.load(nil, @storepass)
        else
          key_store_name = RJava.cast_to_string(key_store_name.replace(JavaFile.attr_separator_char, Character.new(?/.ord)))
          url = nil
          begin
            url = URL.new(key_store_name)
          rescue Java::Net::MalformedURLException => e
            # try as file
            url = JavaFile.new(key_store_name).to_uri.to_url
          end
          is = nil
          begin
            is = url.open_stream
            @store.load(is, @storepass)
          ensure
            if (!(is).nil?)
              is.close
            end
          end
        end
      rescue IOException => ioe
        raise RuntimeException.new(Rb.get_string("keystore load: ") + ioe.get_message)
      rescue Java::Security::Cert::CertificateException => ce
        raise RuntimeException.new(Rb.get_string("certificate exception: ") + ce.get_message)
      rescue NoSuchProviderException => pe
        raise RuntimeException.new(Rb.get_string("keystore load: ") + pe.get_message)
      rescue NoSuchAlgorithmException => nsae
        raise RuntimeException.new(Rb.get_string("keystore load: ") + nsae.get_message)
      rescue KeyStoreException => kse
        raise RuntimeException.new(Rb.get_string("unable to instantiate keystore class: ") + kse.get_message)
      end
    end
    
    typesig { [String] }
    def get_tsa_cert(alias_)
      cs = nil
      begin
        cs = @store.get_certificate(alias_)
      rescue KeyStoreException => kse
        # this never happens, because keystore has been loaded
      end
      if ((cs).nil? || (!(cs.is_a?(X509Certificate))))
        form = MessageFormat.new(Rb.get_string("Certificate not found for: alias.  alias must reference a valid KeyStore entry containing an X.509 public key certificate for the Timestamping Authority."))
        source = Array.typed(Object).new([alias_, alias_])
        error(form.format(source))
      end
      return cs
    end
    
    typesig { [X509Certificate, Array.typed(::Java::Boolean)] }
    # Check if userCert is designed to be a code signer
    # @param userCert the certificate to be examined
    # @param bad 3 booleans to show if the KeyUsage, ExtendedKeyUsage,
    # NetscapeCertType has codeSigning flag turned on.
    # If null, the class field badKeyUsage, badExtendedKeyUsage,
    # badNetscapeCertType will be set.
    def check_cert_usage(user_cert, bad)
      # Can act as a signer?
      # 1. if KeyUsage, then [0] should be true
      # 2. if ExtendedKeyUsage, then should contains ANY or CODE_SIGNING
      # 3. if NetscapeCertType, then should contains OBJECT_SIGNING
      # 1,2,3 must be true
      if (!(bad).nil?)
        bad[0] = bad[1] = bad[2] = false
      end
      key_usage = user_cert.get_key_usage
      if (!(key_usage).nil?)
        if (key_usage.attr_length < 1 || !key_usage[0])
          if (!(bad).nil?)
            bad[0] = true
          else
            @bad_key_usage = true
          end
        end
      end
      begin
        x_key_usage = user_cert.get_extended_key_usage
        if (!(x_key_usage).nil?)
          # anyExtendedKeyUsage
          if (!x_key_usage.contains("2.5.29.37.0") && !x_key_usage.contains("1.3.6.1.5.5.7.3.3"))
            # codeSigning
            if (!(bad).nil?)
              bad[1] = true
            else
              @bad_extended_key_usage = true
            end
          end
        end
      rescue Java::Security::Cert::CertificateParsingException => e
        # shouldn't happen
      end
      begin
        # OID_NETSCAPE_CERT_TYPE
        netscape_ex = user_cert.get_extension_value("2.16.840.1.113730.1.1")
        if (!(netscape_ex).nil?)
          in_ = DerInputStream.new(netscape_ex)
          encoded = in_.get_octet_string
          encoded = DerValue.new(encoded).get_unaligned_bit_string.to_byte_array
          extn = NetscapeCertTypeExtension.new(encoded)
          val = extn.get(NetscapeCertTypeExtension::OBJECT_SIGNING)
          if (!val)
            if (!(bad).nil?)
              bad[2] = true
            else
              @bad_netscape_cert_type = true
            end
          end
        end
      rescue IOException => e
      end
    end
    
    typesig { [String] }
    def get_alias_info(alias_)
      key = nil
      begin
        cs = nil
        begin
          cs = @store.get_certificate_chain(alias_)
        rescue KeyStoreException => kse
          # this never happens, because keystore has been loaded
        end
        if ((cs).nil?)
          form = MessageFormat.new(Rb.get_string("Certificate chain not found for: alias.  alias must reference a valid KeyStore key entry containing a private key and corresponding public key certificate chain."))
          source = Array.typed(Object).new([alias_, alias_])
          error(form.format(source))
        end
        @cert_chain = Array.typed(X509Certificate).new(cs.attr_length) { nil }
        i = 0
        while i < cs.attr_length
          if (!(cs[i].is_a?(X509Certificate)))
            error(Rb.get_string("found non-X.509 certificate in signer's chain"))
          end
          @cert_chain[i] = cs[i]
          i += 1
        end
        # order the cert chain if necessary (put user cert first,
        # root-cert last in the chain)
        user_cert = @store.get_certificate(alias_)
        # check validity of signer certificate
        begin
          user_cert.check_validity
          if (user_cert.get_not_after.get_time < System.current_time_millis + SIX_MONTHS)
            @has_expiring_cert = true
          end
        rescue CertificateExpiredException => cee
          @has_expired_cert = true
        rescue CertificateNotYetValidException => cnyve
          @not_yet_valid_cert = true
        end
        check_cert_usage(user_cert, nil)
        if (!(user_cert == @cert_chain[0]))
          # need to order ...
          cert_chain_tmp = Array.typed(X509Certificate).new(@cert_chain.attr_length) { nil }
          cert_chain_tmp[0] = user_cert
          issuer = user_cert.get_issuer_dn
          i_ = 1
          while i_ < @cert_chain.attr_length
            j = 0
            # look for the cert whose subject corresponds to the
            # given issuer
            j = 0
            while j < cert_chain_tmp.attr_length
              if ((cert_chain_tmp[j]).nil?)
                j += 1
                next
              end
              subject = cert_chain_tmp[j].get_subject_dn
              if ((issuer == subject))
                @cert_chain[i_] = cert_chain_tmp[j]
                issuer = cert_chain_tmp[j].get_issuer_dn
                cert_chain_tmp[j] = nil
                break
              end
              j += 1
            end
            if ((j).equal?(cert_chain_tmp.attr_length))
              error(Rb.get_string("incomplete certificate chain"))
            end
            i_ += 1
          end
          @cert_chain = cert_chain_tmp # ordered
        end
        begin
          if (!@token && (@keypass).nil?)
            key = @store.get_key(alias_, @storepass)
          else
            key = @store.get_key(alias_, @keypass)
          end
        rescue UnrecoverableKeyException => e
          if (@token)
            raise e
          else
            if ((@keypass).nil?)
              # Did not work out, so prompt user for key password
              form = MessageFormat.new(Rb.get_string("Enter key password for alias: "))
              source = Array.typed(Object).new([alias_])
              @keypass = get_pass(form.format(source))
              key = @store.get_key(alias_, @keypass)
            end
          end
        end
      rescue NoSuchAlgorithmException => e
        error(e.get_message)
      rescue UnrecoverableKeyException => e
        error(Rb.get_string("unable to recover key from keystore"))
      rescue KeyStoreException => kse
        # this never happens, because keystore has been loaded
      end
      if (!(key.is_a?(PrivateKey)))
        form = MessageFormat.new(Rb.get_string("key associated with alias not a private key"))
        source = Array.typed(Object).new([alias_])
        error(form.format(source))
      else
        @private_key = key
      end
    end
    
    typesig { [String] }
    def error(message)
      System.out.println(RJava.cast_to_string(Rb.get_string("jarsigner: ")) + message)
      System.exit(1)
    end
    
    typesig { [String, JavaException] }
    def error(message, e)
      System.out.println(RJava.cast_to_string(Rb.get_string("jarsigner: ")) + message)
      if (@debug)
        e.print_stack_trace
      end
      System.exit(1)
    end
    
    typesig { [String] }
    def get_pass(prompt)
      System.err.print(prompt)
      System.err.flush
      begin
        pass = Password.read_password(System.in)
        if ((pass).nil?)
          error(Rb.get_string("you must enter key password"))
        else
          return pass
        end
      rescue IOException => ioe
        error(Rb.get_string("unable to read password: ") + ioe.get_message)
      end
      # this shouldn't happen
      return nil
    end
    
    typesig { [ZipFile, ZipEntry] }
    # Reads all the bytes for a given zip entry.
    def get_bytes(zf, ze)
      synchronized(self) do
        n = 0
        is = nil
        begin
          is = zf.get_input_stream(ze)
          @baos.reset
          left = ze.get_size
          while ((left > 0) && !((n = is.read(@buffer, 0, @buffer.attr_length))).equal?(-1))
            @baos.write(@buffer, 0, n)
            left -= n
          end
        ensure
          if (!(is).nil?)
            is.close
          end
        end
        return @baos.to_byte_array
      end
    end
    
    typesig { [ZipFile] }
    # Returns manifest entry from given jar file, or null if given jar file
    # does not have a manifest entry.
    def get_manifest_file(zf)
      ze = zf.get_entry(JarFile::MANIFEST_NAME)
      if ((ze).nil?)
        # Check all entries for matching name
        enum_ = zf.entries
        while (enum_.has_more_elements && (ze).nil?)
          ze = enum_.next_element
          if (!JarFile::MANIFEST_NAME.equals_ignore_case(ze.get_name))
            ze = nil
          end
        end
      end
      return ze
    end
    
    typesig { [ZipEntry, ZipFile, Array.typed(MessageDigest), BASE64Encoder] }
    # Computes the digests of a zip entry, and returns them as an array
    # of base64-encoded strings.
    def get_digests(ze, zf, digests, encoder)
      synchronized(self) do
        n = 0
        i = 0
        is = nil
        begin
          is = zf.get_input_stream(ze)
          left = ze.get_size
          while ((left > 0) && !((n = is.read(@buffer, 0, @buffer.attr_length))).equal?(-1))
            i = 0
            while i < digests.attr_length
              digests[i].update(@buffer, 0, n)
              i += 1
            end
            left -= n
          end
        ensure
          if (!(is).nil?)
            is.close
          end
        end
        # complete the digests
        base64digests = Array.typed(String).new(digests.attr_length) { nil }
        i = 0
        while i < digests.attr_length
          base64digests[i] = encoder.encode(digests[i].digest)
          i += 1
        end
        return base64digests
      end
    end
    
    typesig { [ZipEntry, ZipFile, Array.typed(MessageDigest), BASE64Encoder] }
    # Computes the digests of a zip entry, and returns them as a list of
    # attributes
    def get_digest_attributes(ze, zf, digests, encoder)
      base64digests = get_digests(ze, zf, digests, encoder)
      attrs = Attributes.new
      i = 0
      while i < digests.attr_length
        attrs.put_value(RJava.cast_to_string(digests[i].get_algorithm) + "-Digest", base64digests[i])
        i += 1
      end
      return attrs
    end
    
    typesig { [ZipEntry, ZipFile, Array.typed(MessageDigest), BASE64Encoder, Manifest] }
    # Updates the digest attributes of a manifest entry, by adding or
    # replacing digest values.
    # A digest value is added if the manifest entry does not contain a digest
    # for that particular algorithm.
    # A digest value is replaced if it is obsolete.
    # 
    # Returns true if the manifest entry has been changed, and false
    # otherwise.
    def update_digests(ze, zf, digests, encoder, mf)
      update = false
      attrs = mf.get_attributes(ze.get_name)
      base64digests = get_digests(ze, zf, digests, encoder)
      i = 0
      while i < digests.attr_length
        name = RJava.cast_to_string(digests[i].get_algorithm) + "-Digest"
        mf_digest = attrs.get_value(name)
        if ((mf_digest).nil? && digests[i].get_algorithm.equals_ignore_case("SHA"))
          # treat "SHA" and "SHA1" the same
          mf_digest = RJava.cast_to_string(attrs.get_value("SHA-Digest"))
        end
        if ((mf_digest).nil?)
          # compute digest and add it to list of attributes
          attrs.put_value(name, base64digests[i])
          update = true
        else
          # compare digests, and replace the one in the manifest
          # if they are different
          if (!mf_digest.equals_ignore_case(base64digests[i]))
            attrs.put_value(name, base64digests[i])
            update = true
          end
        end
        i += 1
      end
      return update
    end
    
    typesig { [String, String] }
    # Try to load the specified signing mechanism.
    # The URL class loader is used.
    def load_signing_mechanism(signer_class_name, signer_class_path)
      # construct class loader
      cp_string = nil # make sure env.class.path defaults to dot
      # do prepends to get correct ordering
      cp_string = RJava.cast_to_string(PathList.append_path(System.get_property("env.class.path"), cp_string))
      cp_string = RJava.cast_to_string(PathList.append_path(System.get_property("java.class.path"), cp_string))
      cp_string = RJava.cast_to_string(PathList.append_path(signer_class_path, cp_string))
      urls = PathList.path_to_urls(cp_string)
      app_class_loader = URLClassLoader.new(urls)
      # attempt to find signer
      signer_class = app_class_loader.load_class(signer_class_name)
      # Check that it implements ContentSigner
      signer = signer_class.new_instance
      if (!(signer.is_a?(ContentSigner)))
        form = MessageFormat.new(Rb.get_string("signerClass is not a signing mechanism"))
        source = Array.typed(Object).new([signer_class.get_name])
        raise IllegalArgumentException.new(form.format(source))
      end
      return signer
    end
    
    typesig { [] }
    def initialize
      @cert_chain = nil
      @private_key = nil
      @store = nil
      @scope = nil
      @keystore = nil
      @null_stream = false
      @token = false
      @jarfile = nil
      @alias = nil
      @storepass = nil
      @protected_path = false
      @storetype = nil
      @provider_name = nil
      @providers = nil
      @provider_args = HashMap.new
      @keypass = nil
      @sigfile = nil
      @sigalg = nil
      @digestalg = "SHA1"
      @signedjar = nil
      @tsa_url = nil
      @tsa_alias = nil
      @verify = false
      @verbose = false
      @showcerts = false
      @debug = false
      @sign_manifest = true
      @external_sf = true
      @baos = ByteArrayOutputStream.new(2048)
      @buffer = Array.typed(::Java::Byte).new(8192) { 0 }
      @signing_mechanism = nil
      @alt_signer_class = nil
      @alt_signer_classpath = nil
      @zip_file = nil
      @has_expired_cert = false
      @has_expiring_cert = false
      @not_yet_valid_cert = false
      @bad_key_usage = false
      @bad_extended_key_usage = false
      @bad_netscape_cert_type = false
      @store_hash = Hashtable.new
    end
    
    private
    alias_method :initialize__jar_signer, :initialize
  end
  
  # This is a BASE64Encoder that does not insert a default newline at the end of
  # every output line. This is necessary because java.util.jar does its own
  # line management (see Manifest.make72Safe()). Inserting additional new lines
  # can cause line-wrapping problems (see CR 6219522).
  class JarBASE64Encoder < JarSignerImports.const_get :BASE64Encoder
    include_class_members JarSignerImports
    
    typesig { [OutputStream] }
    # Encode the suffix that ends every output line.
    def encode_line_suffix(a_stream)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__jar_base64encoder, :initialize
  end
  
  class SignatureFile 
    include_class_members JarSignerImports
    
    # SignatureFile
    attr_accessor :sf
    alias_method :attr_sf, :sf
    undef_method :sf
    alias_method :attr_sf=, :sf=
    undef_method :sf=
    
    # .SF base name
    attr_accessor :base_name
    alias_method :attr_base_name, :base_name
    undef_method :base_name
    alias_method :attr_base_name=, :base_name=
    undef_method :base_name=
    
    typesig { [Array.typed(MessageDigest), Manifest, ManifestDigester, String, ::Java::Boolean] }
    def initialize(digests, mf, md, base_name, sign_manifest)
      @sf = nil
      @base_name = nil
      @base_name = base_name
      version = System.get_property("java.version")
      java_vendor = System.get_property("java.vendor")
      @sf = Manifest.new
      mattr = @sf.get_main_attributes
      encoder = JarBASE64Encoder.new
      mattr.put_value(Attributes::Name::SIGNATURE_VERSION.to_s, "1.0")
      mattr.put_value("Created-By", version + " (" + java_vendor + ")")
      if (sign_manifest)
        # sign the whole manifest
        i = 0
        while i < digests.attr_length
          mattr.put_value(RJava.cast_to_string(digests[i].get_algorithm) + "-Digest-Manifest", encoder.encode(md.manifest_digest(digests[i])))
          i += 1
        end
      end
      # create digest of the manifest main attributes
      mde = md.get(ManifestDigester::MF_MAIN_ATTRS, false)
      if (!(mde).nil?)
        i = 0
        while i < digests.attr_length
          mattr.put_value(RJava.cast_to_string(digests[i].get_algorithm) + "-Digest-" + RJava.cast_to_string(ManifestDigester::MF_MAIN_ATTRS), encoder.encode(mde.digest(digests[i])))
          i += 1
        end
      else
        raise IllegalStateException.new("ManifestDigester failed to create " + "Manifest-Main-Attribute entry")
      end
      # go through the manifest entries and create the digests
      entries = @sf.get_entries
      mit = mf.get_entries.entry_set.iterator
      while (mit.has_next)
        e = mit.next_
        name = e.get_key
        mde = md.get(name, false)
        if (!(mde).nil?)
          attr = Attributes.new
          i = 0
          while i < digests.attr_length
            attr.put_value(RJava.cast_to_string(digests[i].get_algorithm) + "-Digest", encoder.encode(mde.digest(digests[i])))
            i += 1
          end
          entries.put(name, attr)
        end
      end
    end
    
    typesig { [OutputStream] }
    # Writes the SignatureFile to the specified OutputStream.
    # 
    # @param out the output stream
    # @exception IOException if an I/O error has occurred
    def write(out)
      @sf.write(out)
    end
    
    typesig { [] }
    # get .SF file name
    def get_meta_name
      return "META-INF/" + @base_name + ".SF"
    end
    
    typesig { [] }
    # get base file name
    def get_base_name
      return @base_name
    end
    
    typesig { [PrivateKey, String, Array.typed(X509Certificate), ::Java::Boolean, String, X509Certificate, ContentSigner, Array.typed(String), ZipFile] }
    # Generate a signed data block.
    # If a URL or a certificate (containing a URL) for a Timestamping
    # Authority is supplied then a signature timestamp is generated and
    # inserted into the signed data block.
    # 
    # @param sigalg signature algorithm to use, or null to use default
    # @param tsaUrl The location of the Timestamping Authority. If null
    # then no timestamp is requested.
    # @param tsaCert The certificate for the Timestamping Authority. If null
    # then no timestamp is requested.
    # @param signingMechanism The signing mechanism to use.
    # @param args The command-line arguments to jarsigner.
    # @param zipFile The original source Zip file.
    def generate_block(private_key, sigalg, cert_chain, external_sf, tsa_url, tsa_cert, signing_mechanism, args, zip_file)
      return Block.new(self, private_key, sigalg, cert_chain, external_sf, tsa_url, tsa_cert, signing_mechanism, args, zip_file)
    end
    
    class_module.module_eval {
      const_set_lazy(:Block) { Class.new do
        include_class_members SignatureFile
        
        attr_accessor :block
        alias_method :attr_block, :block
        undef_method :block
        alias_method :attr_block=, :block=
        undef_method :block=
        
        attr_accessor :block_file_name
        alias_method :attr_block_file_name, :block_file_name
        undef_method :block_file_name
        alias_method :attr_block_file_name=, :block_file_name=
        undef_method :block_file_name=
        
        typesig { [class_self::SignatureFile, class_self::PrivateKey, String, Array.typed(class_self::X509Certificate), ::Java::Boolean, String, class_self::X509Certificate, class_self::ContentSigner, Array.typed(String), class_self::ZipFile] }
        # Construct a new signature block.
        def initialize(sfg, private_key, sigalg, cert_chain, external_sf, tsa_url, tsa_cert, signing_mechanism, args, zip_file)
          @block = nil
          @block_file_name = nil
          issuer_name = cert_chain[0].get_issuer_dn
          if (!(issuer_name.is_a?(self.class::X500Name)))
            # must extract the original encoded form of DN for subsequent
            # name comparison checks (converting to a String and back to
            # an encoded DN could cause the types of String attribute
            # values to be changed)
            tbs_cert = self.class::X509CertInfo.new(cert_chain[0].get_tbscertificate)
            issuer_name = tbs_cert.get(RJava.cast_to_string(CertificateIssuerName::NAME) + "." + RJava.cast_to_string(CertificateIssuerName::DN_NAME))
          end
          serial = cert_chain[0].get_serial_number
          digest_algorithm = nil
          signature_algorithm = nil
          key_algorithm = private_key.get_algorithm
          # If no signature algorithm was specified, we choose a
          # default that is compatible with the private key algorithm.
          if ((sigalg).nil?)
            if (key_algorithm.equals_ignore_case("DSA"))
              digest_algorithm = "SHA1"
            else
              if (key_algorithm.equals_ignore_case("RSA"))
                digest_algorithm = "SHA1"
              else
                raise self.class::RuntimeException.new("private key is not a DSA or " + "RSA key")
              end
            end
            signature_algorithm = digest_algorithm + "with" + key_algorithm
          else
            signature_algorithm = sigalg
          end
          # check common invalid key/signature algorithm combinations
          sig_alg_upper_case = signature_algorithm.to_upper_case
          if ((sig_alg_upper_case.ends_with("WITHRSA") && !key_algorithm.equals_ignore_case("RSA")) || (sig_alg_upper_case.ends_with("WITHDSA") && !key_algorithm.equals_ignore_case("DSA")))
            raise self.class::SignatureException.new("private key algorithm is not compatible with signature algorithm")
          end
          @block_file_name = "META-INF/" + RJava.cast_to_string(sfg.get_base_name) + "." + key_algorithm
          sig_alg = AlgorithmId.get(signature_algorithm)
          dig_encr_alg = AlgorithmId.get(key_algorithm)
          sig = Signature.get_instance(signature_algorithm)
          sig.init_sign(private_key)
          baos = self.class::ByteArrayOutputStream.new
          sfg.write(baos)
          content = baos.to_byte_array
          sig.update(content)
          signature = sig.sign
          # Timestamp the signature and generate the signature block file
          if ((signing_mechanism).nil?)
            signing_mechanism = self.class::TimestampedSigner.new
          end
          tsa_uri = nil
          begin
            if (!(tsa_url).nil?)
              tsa_uri = self.class::URI.new(tsa_url)
            end
          rescue self.class::URISyntaxException => e
            ioe = self.class::IOException.new
            ioe.init_cause(e)
            raise ioe
          end
          # Assemble parameters for the signing mechanism
          params = self.class::JarSignerParameters.new(args, tsa_uri, tsa_cert, signature, signature_algorithm, cert_chain, content, zip_file)
          # Generate the signature block
          @block = signing_mechanism.generate_signed_data(params, external_sf, (!(tsa_url).nil? || !(tsa_cert).nil?))
        end
        
        typesig { [] }
        # get block file name.
        def get_meta_name
          return @block_file_name
        end
        
        typesig { [class_self::OutputStream] }
        # Writes the block file to the specified OutputStream.
        # 
        # @param out the output stream
        # @exception IOException if an I/O error has occurred
        def write(out)
          out.write(@block)
        end
        
        private
        alias_method :initialize__block, :initialize
      end }
    }
    
    private
    alias_method :initialize__signature_file, :initialize
  end
  
  # This object encapsulates the parameters used to perform content signing.
  class JarSignerParameters 
    include_class_members JarSignerImports
    include ContentSignerParameters
    
    attr_accessor :args
    alias_method :attr_args, :args
    undef_method :args
    alias_method :attr_args=, :args=
    undef_method :args=
    
    attr_accessor :tsa
    alias_method :attr_tsa, :tsa
    undef_method :tsa
    alias_method :attr_tsa=, :tsa=
    undef_method :tsa=
    
    attr_accessor :tsa_certificate
    alias_method :attr_tsa_certificate, :tsa_certificate
    undef_method :tsa_certificate
    alias_method :attr_tsa_certificate=, :tsa_certificate=
    undef_method :tsa_certificate=
    
    attr_accessor :signature
    alias_method :attr_signature, :signature
    undef_method :signature
    alias_method :attr_signature=, :signature=
    undef_method :signature=
    
    attr_accessor :signature_algorithm
    alias_method :attr_signature_algorithm, :signature_algorithm
    undef_method :signature_algorithm
    alias_method :attr_signature_algorithm=, :signature_algorithm=
    undef_method :signature_algorithm=
    
    attr_accessor :signer_certificate_chain
    alias_method :attr_signer_certificate_chain, :signer_certificate_chain
    undef_method :signer_certificate_chain
    alias_method :attr_signer_certificate_chain=, :signer_certificate_chain=
    undef_method :signer_certificate_chain=
    
    attr_accessor :content
    alias_method :attr_content, :content
    undef_method :content
    alias_method :attr_content=, :content=
    undef_method :content=
    
    attr_accessor :source
    alias_method :attr_source, :source
    undef_method :source
    alias_method :attr_source=, :source=
    undef_method :source=
    
    typesig { [Array.typed(String), URI, X509Certificate, Array.typed(::Java::Byte), String, Array.typed(X509Certificate), Array.typed(::Java::Byte), ZipFile] }
    # Create a new object.
    def initialize(args, tsa, tsa_certificate, signature, signature_algorithm, signer_certificate_chain, content, source)
      @args = nil
      @tsa = nil
      @tsa_certificate = nil
      @signature = nil
      @signature_algorithm = nil
      @signer_certificate_chain = nil
      @content = nil
      @source = nil
      if ((signature).nil? || (signature_algorithm).nil? || (signer_certificate_chain).nil?)
        raise NullPointerException.new
      end
      @args = args
      @tsa = tsa
      @tsa_certificate = tsa_certificate
      @signature = signature
      @signature_algorithm = signature_algorithm
      @signer_certificate_chain = signer_certificate_chain
      @content = content
      @source = source
    end
    
    typesig { [] }
    # Retrieves the command-line arguments.
    # 
    # @return The command-line arguments. May be null.
    def get_command_line
      return @args
    end
    
    typesig { [] }
    # Retrieves the identifier for a Timestamping Authority (TSA).
    # 
    # @return The TSA identifier. May be null.
    def get_timestamping_authority
      return @tsa
    end
    
    typesig { [] }
    # Retrieves the certificate for a Timestamping Authority (TSA).
    # 
    # @return The TSA certificate. May be null.
    def get_timestamping_authority_certificate
      return @tsa_certificate
    end
    
    typesig { [] }
    # Retrieves the signature.
    # 
    # @return The non-null signature bytes.
    def get_signature
      return @signature
    end
    
    typesig { [] }
    # Retrieves the name of the signature algorithm.
    # 
    # @return The non-null string name of the signature algorithm.
    def get_signature_algorithm
      return @signature_algorithm
    end
    
    typesig { [] }
    # Retrieves the signer's X.509 certificate chain.
    # 
    # @return The non-null array of X.509 public-key certificates.
    def get_signer_certificate_chain
      return @signer_certificate_chain
    end
    
    typesig { [] }
    # Retrieves the content that was signed.
    # 
    # @return The content bytes. May be null.
    def get_content
      return @content
    end
    
    typesig { [] }
    # Retrieves the original source ZIP file before it was signed.
    # 
    # @return The original ZIP file. May be null.
    def get_source
      return @source
    end
    
    private
    alias_method :initialize__jar_signer_parameters, :initialize
  end
  
  JarSigner.main($*) if $0 == __FILE__
end
