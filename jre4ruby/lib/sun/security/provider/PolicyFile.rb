require "rjava"

# 
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
module Sun::Security::Provider
  module PolicyFileImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Io
      include_const ::Java::Lang, :RuntimePermission
      include ::Java::Lang::Reflect
      include ::Java::Lang::Ref
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URI
      include ::Java::Util
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :PropertyPermission
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :WeakHashMap
      include_const ::Java::Text, :MessageFormat
      include_const ::Com::Sun::Security::Auth, :PrincipalComparator
      include ::Java::Security
      include_const ::Java::Security::Cert, :Certificate
      include_const ::Java::Security::Cert, :X509Certificate
      include_const ::Javax::Security::Auth, :PrivateCredentialPermission
      include_const ::Javax::Security::Auth, :Subject
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Java::Io, :FilePermission
      include_const ::Java::Net, :SocketPermission
      include_const ::Java::Net, :NetPermission
      include_const ::Java::Util, :PropertyPermission
      include_const ::Java::Util::Concurrent::Atomic, :AtomicReference
      include_const ::Java::Awt, :AWTPermission
      include_const ::Sun::Security::Util, :Password
      include_const ::Sun::Security::Util, :PolicyUtil
      include_const ::Sun::Security::Util, :PropertyExpander
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :ResourcesMgr
      include_const ::Sun::Security::Util, :SecurityConstants
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # 
  # import javax.security.auth.AuthPermission;
  # import javax.security.auth.kerberos.ServicePermission;
  # import javax.security.auth.kerberos.DelegationPermission;
  # import java.io.SerializablePermission;
  # import java.util.logging.LoggingPermission;
  # import java.sql.SQLPermission;
  # import java.lang.reflect.ReflectPermission;
  # import javax.sound.sampled.AudioPermission;
  # import javax.net.ssl.SSLPermission;
  # 
  # 
  # This class represents a default implementation for
  # <code>java.security.Policy</code>.
  # 
  # Note:
  # For backward compatibility with JAAS 1.0 it loads
  # both java.auth.policy and java.policy. However it
  # is recommended that java.auth.policy be not used
  # and the java.policy contain all grant entries including
  # that contain principal-based entries.
  # 
  # 
  # <p> This object stores the policy for entire Java runtime,
  # and is the amalgamation of multiple static policy
  # configurations that resides in files.
  # The algorithm for locating the policy file(s) and reading their
  # information into this <code>Policy</code> object is:
  # 
  # <ol>
  # <li>
  # Loop through the <code>java.security.Security</code> properties,
  # <i>policy.url.1</i>, <i>policy.url.2</i>, ...,
  # <i>policy.url.X</i>" and
  # <i>auth.policy.url.1</i>, <i>auth.policy.url.2</i>, ...,
  # <i>auth.policy.url.X</i>".  These properties are set
  # in the Java security properties file, which is located in the file named
  # &lt;JAVA_HOME&gt;/lib/security/java.security.
  # &lt;JAVA_HOME&gt; refers to the value of the java.home system property,
  # and specifies the directory where the JRE is installed.
  # Each property value specifies a <code>URL</code> pointing to a
  # policy file to be loaded.  Read in and load each policy.
  # 
  # <i>auth.policy.url</i> is supported only for backward compatibility.
  # 
  # <li>
  # The <code>java.lang.System</code> property <i>java.security.policy</i>
  # may also be set to a <code>URL</code> pointing to another policy file
  # (which is the case when a user uses the -D switch at runtime).
  # If this property is defined, and its use is allowed by the
  # security property file (the Security property,
  # <i>policy.allowSystemProperty</i> is set to <i>true</i>),
  # also load that policy.
  # 
  # <li>
  # The <code>java.lang.System</code> property
  # <i>java.security.auth.policy</i> may also be set to a
  # <code>URL</code> pointing to another policy file
  # (which is the case when a user uses the -D switch at runtime).
  # If this property is defined, and its use is allowed by the
  # security property file (the Security property,
  # <i>policy.allowSystemProperty</i> is set to <i>true</i>),
  # also load that policy.
  # 
  # <i>java.security.auth.policy</i> is supported only for backward
  # compatibility.
  # 
  # If the  <i>java.security.policy</i> or
  # <i>java.security.auth.policy</i> property is defined using
  # "==" (rather than "="), then ignore all other specified
  # policies and only load this policy.
  # </ol>
  # 
  # Each policy file consists of one or more grant entries, each of
  # which consists of a number of permission entries.
  # 
  # <pre>
  # grant signedBy "<b>alias</b>", codeBase "<b>URL</b>",
  # principal <b>principalClass</b> "<b>principalName</b>",
  # principal <b>principalClass</b> "<b>principalName</b>",
  # ... {
  # 
  # permission <b>Type</b> "<b>name</b> "<b>action</b>",
  # signedBy "<b>alias</b>";
  # permission <b>Type</b> "<b>name</b> "<b>action</b>",
  # signedBy "<b>alias</b>";
  # ....
  # };
  # </pre>
  # 
  # All non-bold items above must appear as is (although case
  # doesn't matter and some are optional, as noted below).
  # principal entries are optional and need not be present.
  # Italicized items represent variable values.
  # 
  # <p> A grant entry must begin with the word <code>grant</code>.
  # The <code>signedBy</code>,<code>codeBase</code> and <code>principal</code>
  # name/value pairs are optional.
  # If they are not present, then any signer (including unsigned code)
  # will match, and any codeBase will match.
  # Note that the <i>principalClass</i>
  # may be set to the wildcard value, *, which allows it to match
  # any <code>Principal</code> class.  In addition, the <i>principalName</i>
  # may also be set to the wildcard value, *, allowing it to match
  # any <code>Principal</code> name.  When setting the <i>principalName</i>
  # to the *, do not surround the * with quotes.
  # 
  # <p> A permission entry must begin with the word <code>permission</code>.
  # The word <code><i>Type</i></code> in the template above is
  # a specific permission type, such as <code>java.io.FilePermission</code>
  # or <code>java.lang.RuntimePermission</code>.
  # 
  # <p> The "<i>action</i>" is required for
  # many permission types, such as <code>java.io.FilePermission</code>
  # (where it specifies what type of file access that is permitted).
  # It is not required for categories such as
  # <code>java.lang.RuntimePermission</code>
  # where it is not necessary - you either have the
  # permission specified by the <code>"<i>name</i>"</code>
  # value following the type name or you don't.
  # 
  # <p> The <code>signedBy</code> name/value pair for a permission entry
  # is optional. If present, it indicates a signed permission. That is,
  # the permission class itself must be signed by the given alias in
  # order for it to be granted. For example,
  # suppose you have the following grant entry:
  # 
  # <pre>
  # grant principal foo.com.Principal "Duke" {
  # permission Foo "foobar", signedBy "FooSoft";
  # }
  # </pre>
  # 
  # <p> Then this permission of type <i>Foo</i> is granted if the
  # <code>Foo.class</code> permission has been signed by the
  # "FooSoft" alias, or if XXX <code>Foo.class</code> is a
  # system class (i.e., is found on the CLASSPATH).
  # 
  # 
  # <p> Items that appear in an entry must appear in the specified order
  # (<code>permission</code>, <i>Type</i>, "<i>name</i>", and
  # "<i>action</i>"). An entry is terminated with a semicolon.
  # 
  # <p> Case is unimportant for the identifiers (<code>permission</code>,
  # <code>signedBy</code>, <code>codeBase</code>, etc.) but is
  # significant for the <i>Type</i>
  # or for any string that is passed in as a value. <p>
  # 
  # <p> An example of two entries in a policy configuration file is
  # <pre>
  # // if the code is comes from "foo.com" and is running as "Duke",
  # // grant it read/write to all files in /tmp.
  # 
  # grant codeBase "foo.com", principal foo.com.Principal "Duke" {
  # permission java.io.FilePermission "/tmp/*", "read,write";
  # };
  # 
  # // grant any code running as "Duke" permission to read
  # // the "java.vendor" Property.
  # 
  # grant principal foo.com.Principal "Duke" {
  # permission java.util.PropertyPermission "java.vendor";
  # 
  # 
  # </pre>
  # This Policy implementation supports special handling of any
  # permission that contains the string, "<b>${{self}}</b>", as part of
  # its target name.  When such a permission is evaluated
  # (such as during a security check), <b>${{self}}</b> is replaced
  # with one or more Principal class/name pairs.  The exact
  # replacement performed depends upon the contents of the
  # grant clause to which the permission belongs.
  # <p>
  # 
  # If the grant clause does not contain any principal information,
  # the permission will be ignored (permissions containing
  # <b>${{self}}</b> in their target names are only valid in the context
  # of a principal-based grant clause).  For example, BarPermission
  # will always be ignored in the following grant clause:
  # 
  # <pre>
  # grant codebase "www.foo.com", signedby "duke" {
  # permission BarPermission "... ${{self}} ...";
  # };
  # </pre>
  # 
  # If the grant clause contains principal information, <b>${{self}}</b>
  # will be replaced with that same principal information.
  # For example, <b>${{self}}</b> in BarPermission will be replaced by
  # <b>javax.security.auth.x500.X500Principal "cn=Duke"</b>
  # in the following grant clause:
  # 
  # <pre>
  # grant principal javax.security.auth.x500.X500Principal "cn=Duke" {
  # permission BarPermission "... ${{self}} ...";
  # };
  # </pre>
  # 
  # If there is a comma-separated list of principals in the grant
  # clause, then <b>${{self}}</b> will be replaced by the same
  # comma-separated list or principals.
  # In the case where both the principal class and name are
  # wildcarded in the grant clause, <b>${{self}}</b> is replaced
  # with all the principals associated with the <code>Subject</code>
  # in the current <code>AccessControlContext</code>.
  # 
  # 
  # <p> For PrivateCredentialPermissions, you can also use "<b>self</b>"
  # instead of "<b>${{self}}</b>". However the use of "<b>self</b>" is
  # deprecated in favour of "<b>${{self}}</b>".
  # 
  # @see java.security.CodeSource
  # @see java.security.Permissions
  # @see java.security.ProtectionDomain
  class PolicyFile < Java::Security::Policy
    include_class_members PolicyFileImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { Debug.get_instance("policy") }
      const_attr_reader  :Debug
      
      const_set_lazy(:NONE) { "NONE" }
      const_attr_reader  :NONE
      
      const_set_lazy(:P11KEYSTORE) { "PKCS11" }
      const_attr_reader  :P11KEYSTORE
      
      const_set_lazy(:SELF) { "${{self}}" }
      const_attr_reader  :SELF
      
      const_set_lazy(:X500PRINCIPAL) { "javax.security.auth.x500.X500Principal" }
      const_attr_reader  :X500PRINCIPAL
      
      const_set_lazy(:POLICY) { "java.security.policy" }
      const_attr_reader  :POLICY
      
      const_set_lazy(:SECURITY_MANAGER) { "java.security.manager" }
      const_attr_reader  :SECURITY_MANAGER
      
      const_set_lazy(:POLICY_URL) { "policy.url." }
      const_attr_reader  :POLICY_URL
      
      const_set_lazy(:AUTH_POLICY) { "java.security.auth.policy" }
      const_attr_reader  :AUTH_POLICY
      
      const_set_lazy(:AUTH_POLICY_URL) { "auth.policy.url." }
      const_attr_reader  :AUTH_POLICY_URL
      
      const_set_lazy(:DEFAULT_CACHE_SIZE) { 1 }
      const_attr_reader  :DEFAULT_CACHE_SIZE
      
      # the scope to check
      
      def scope
        defined?(@@scope) ? @@scope : @@scope= nil
      end
      alias_method :attr_scope, :scope
      
      def scope=(value)
        @@scope = value
      end
      alias_method :attr_scope=, :scope=
    }
    
    # contains the policy grant entries, PD cache, and alias mapping
    attr_accessor :policy_info
    alias_method :attr_policy_info, :policy_info
    undef_method :policy_info
    alias_method :attr_policy_info=, :policy_info=
    undef_method :policy_info=
    
    attr_accessor :constructed
    alias_method :attr_constructed, :constructed
    undef_method :constructed
    alias_method :attr_constructed=, :constructed=
    undef_method :constructed=
    
    attr_accessor :expand_properties
    alias_method :attr_expand_properties, :expand_properties
    undef_method :expand_properties
    alias_method :attr_expand_properties=, :expand_properties=
    undef_method :expand_properties=
    
    attr_accessor :ignore_identity_scope
    alias_method :attr_ignore_identity_scope, :ignore_identity_scope
    undef_method :ignore_identity_scope
    alias_method :attr_ignore_identity_scope=, :ignore_identity_scope=
    undef_method :ignore_identity_scope=
    
    attr_accessor :allow_system_properties
    alias_method :attr_allow_system_properties, :allow_system_properties
    undef_method :allow_system_properties
    alias_method :attr_allow_system_properties=, :allow_system_properties=
    undef_method :allow_system_properties=
    
    attr_accessor :not_utf8
    alias_method :attr_not_utf8, :not_utf8
    undef_method :not_utf8
    alias_method :attr_not_utf8=, :not_utf8=
    undef_method :not_utf8=
    
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    class_module.module_eval {
      # for use with the reflection API
      const_set_lazy(:PARAMS0) { Array.typed(Class).new([]) }
      const_attr_reader  :PARAMS0
      
      const_set_lazy(:PARAMS1) { Array.typed(Class).new([String.class]) }
      const_attr_reader  :PARAMS1
      
      const_set_lazy(:PARAMS2) { Array.typed(Class).new([String.class, String.class]) }
      const_attr_reader  :PARAMS2
    }
    
    typesig { [] }
    # 
    # Initializes the Policy object and reads the default policy
    # configuration file(s) into the Policy object.
    def initialize
      @policy_info = nil
      @constructed = false
      @expand_properties = false
      @ignore_identity_scope = false
      @allow_system_properties = false
      @not_utf8 = false
      @url = nil
      super()
      @policy_info = AtomicReference.new
      @constructed = false
      @expand_properties = true
      @ignore_identity_scope = false
      @allow_system_properties = true
      @not_utf8 = false
      init(nil)
    end
    
    typesig { [URL] }
    # 
    # Initializes the Policy object and reads the default policy
    # from the specified URL only.
    def initialize(url)
      @policy_info = nil
      @constructed = false
      @expand_properties = false
      @ignore_identity_scope = false
      @allow_system_properties = false
      @not_utf8 = false
      @url = nil
      super()
      @policy_info = AtomicReference.new
      @constructed = false
      @expand_properties = true
      @ignore_identity_scope = false
      @allow_system_properties = true
      @not_utf8 = false
      @url = url
      init(url)
    end
    
    typesig { [URL] }
    # 
    # Initializes the Policy object and reads the default policy
    # configuration file(s) into the Policy object.
    # 
    # The algorithm for locating the policy file(s) and reading their
    # information into the Policy object is:
    # <pre>
    # loop through the Security Properties named "policy.url.1",
    # ""policy.url.2", "auth.policy.url.1",  "auth.policy.url.2" etc, until
    # you don't find one. Each of these specify a policy file.
    # 
    # if none of these could be loaded, use a builtin static policy
    # equivalent to the default lib/security/java.policy file.
    # 
    # if the system property "java.policy" or "java.auth.policy" is defined
    # (which is the
    # case when the user uses the -D switch at runtime), and
    # its use is allowed by the security property file,
    # also load it.
    # </pre>
    # 
    # Each policy file consists of one or more grant entries, each of
    # which consists of a number of permission entries.
    # <pre>
    # grant signedBy "<i>alias</i>", codeBase "<i>URL</i>" {
    # permission <i>Type</i> "<i>name</i>", "<i>action</i>",
    # signedBy "<i>alias</i>";
    # ....
    # permission <i>Type</i> "<i>name</i>", "<i>action</i>",
    # signedBy "<i>alias</i>";
    # };
    # 
    # </pre>
    # 
    # All non-italicized items above must appear as is (although case
    # doesn't matter and some are optional, as noted below).
    # Italicized items represent variable values.
    # 
    # <p> A grant entry must begin with the word <code>grant</code>.
    # The <code>signedBy</code> and <code>codeBase</code> name/value
    # pairs are optional.
    # If they are not present, then any signer (including unsigned code)
    # will match, and any codeBase will match.
    # 
    # <p> A permission entry must begin with the word <code>permission</code>.
    # The word <code><i>Type</i></code> in the template above would actually
    # be a specific permission type, such as
    # <code>java.io.FilePermission</code> or
    # <code>java.lang.RuntimePermission</code>.
    # 
    # <p>The "<i>action</i>" is required for
    # many permission types, such as <code>java.io.FilePermission</code>
    # (where it specifies what type of file access is permitted).
    # It is not required for categories such as
    # <code>java.lang.RuntimePermission</code>
    # where it is not necessary - you either have the
    # permission specified by the <code>"<i>name</i>"</code>
    # value following the type name or you don't.
    # 
    # <p>The <code>signedBy</code> name/value pair for a permission entry
    # is optional. If present, it indicates a signed permission. That is,
    # the permission class itself must be signed by the given alias in
    # order for it to be granted. For example,
    # suppose you have the following grant entry:
    # 
    # <pre>
    # grant {
    # permission Foo "foobar", signedBy "FooSoft";
    # }
    # </pre>
    # 
    # <p>Then this permission of type <i>Foo</i> is granted if the
    # <code>Foo.class</code> permission has been signed by the
    # "FooSoft" alias, or if <code>Foo.class</code> is a
    # system class (i.e., is found on the CLASSPATH).
    # 
    # <p>Items that appear in an entry must appear in the specified order
    # (<code>permission</code>, <i>Type</i>, "<i>name</i>", and
    # "<i>action</i>"). An entry is terminated with a semicolon.
    # 
    # <p>Case is unimportant for the identifiers (<code>permission</code>,
    # <code>signedBy</code>, <code>codeBase</code>, etc.) but is
    # significant for the <i>Type</i>
    # or for any string that is passed in as a value. <p>
    # 
    # <p>An example of two entries in a policy configuration file is
    # <pre>
    # //  if the code is signed by "Duke", grant it read/write to all
    # // files in /tmp.
    # 
    # grant signedBy "Duke" {
    # permission java.io.FilePermission "/tmp/*", "read,write";
    # };
    # <p>
    # // grant everyone the following permission
    # 
    # grant {
    # permission java.util.PropertyPermission "java.vendor";
    # };
    # </pre>
    def init(url)
      num_cache_str = AccessController.do_privileged(# Properties are set once for each init(); ignore changes between
      # between diff invocations of initPolicyFile(policy, url, info).
      Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members PolicyFile
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          self.attr_expand_properties = "true".equals_ignore_case(Security.get_property("policy.expandProperties"))
          self.attr_ignore_identity_scope = "true".equals_ignore_case(Security.get_property("policy.ignoreIdentityScope"))
          self.attr_allow_system_properties = "true".equals_ignore_case(Security.get_property("policy.allowSystemProperty"))
          self.attr_not_utf8 = "false".equals_ignore_case(System.get_property("sun.security.policy.utf8"))
          return System.get_property("sun.security.policy.numcaches")
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      num_caches = 0
      if (!(num_cache_str).nil?)
        begin
          num_caches = JavaInteger.parse_int(num_cache_str)
        rescue NumberFormatException => e
          num_caches = DEFAULT_CACHE_SIZE
        end
      else
        num_caches = DEFAULT_CACHE_SIZE
      end
      # System.out.println("number caches=" + numCaches);
      new_info = PolicyInfo.new(num_caches)
      init_policy_file(new_info, url)
      @policy_info.set(new_info)
    end
    
    typesig { [PolicyInfo, URL] }
    def init_policy_file(new_info, url)
      if (!(url).nil?)
        # 
        # If the caller specified a URL via Policy.getInstance,
        # we only read from that URL
        if (!(Debug).nil?)
          Debug.println("reading " + (url).to_s)
        end
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members PolicyFile
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            if ((init(url, new_info)).equal?(false))
              # use static policy if all else fails
              init_static_policy(new_info)
            end
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        # 
        # Caller did not specify URL via Policy.getInstance.
        # Read from URLs listed in the java.security properties file.
        # 
        # We call initPolicyFile with POLICY , POLICY_URL and then
        # call it with AUTH_POLICY and AUTH_POLICY_URL
        # So first we will process the JAVA standard policy
        # and then process the JAVA AUTH Policy.
        # This is for backward compatibility as well as to handle
        # cases where the user has a single unified policyfile
        # with both java policy entries and auth entries
        loaded_one = init_policy_file(POLICY, POLICY_URL, new_info)
        # To maintain strict backward compatibility
        # we load the static policy only if POLICY load failed
        if (!loaded_one)
          # use static policy if all else fails
          init_static_policy(new_info)
        end
        init_policy_file(AUTH_POLICY, AUTH_POLICY_URL, new_info)
      end
    end
    
    typesig { [String, String, PolicyInfo] }
    def init_policy_file(propname, urlname, new_info)
      loaded_policy = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members PolicyFile
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          loaded_policy = false
          if (self.attr_allow_system_properties)
            extra_policy = System.get_property(propname)
            if (!(extra_policy).nil?)
              override_all = false
              if (extra_policy.starts_with("="))
                override_all = true
                extra_policy = (extra_policy.substring(1)).to_s
              end
              begin
                extra_policy = (PropertyExpander.expand(extra_policy)).to_s
                policy_url = nil
                policy_file = JavaFile.new(extra_policy)
                if (policy_file.exists)
                  policy_url = ParseUtil.file_to_encoded_url(JavaFile.new(policy_file.get_canonical_path))
                else
                  policy_url = URL.new(extra_policy)
                end
                if (!(Debug).nil?)
                  Debug.println("reading " + (policy_url).to_s)
                end
                if (init(policy_url, new_info))
                  loaded_policy = true
                end
              rescue Exception => e
                # ignore.
                if (!(Debug).nil?)
                  Debug.println("caught exception: " + (e).to_s)
                end
              end
              if (override_all)
                if (!(Debug).nil?)
                  Debug.println("overriding other policies!")
                end
                return Boolean.value_of(loaded_policy)
              end
            end
          end
          n = 1
          policy_uri = nil
          while (!((policy_uri = (Security.get_property(urlname + (n).to_s)).to_s)).nil?)
            begin
              policy_url_ = nil
              expanded_uri = PropertyExpander.expand(policy_uri).replace(JavaFile.attr_separator_char, Character.new(?/.ord))
              if (policy_uri.starts_with("file:${java.home}/") || policy_uri.starts_with("file:${user.home}/"))
                # this special case accommodates
                # the situation java.home/user.home
                # expand to a single slash, resulting in
                # a file://foo URI
                policy_url_ = JavaFile.new(expanded_uri.substring(5)).to_uri.to_url
              else
                policy_url_ = URI.new(expanded_uri).to_url
              end
              if (!(Debug).nil?)
                Debug.println("reading " + (policy_url_).to_s)
              end
              if (init(policy_url_, new_info))
                loaded_policy = true
              end
            rescue Exception => e
              if (!(Debug).nil?)
                Debug.println("error reading policy " + (e_).to_s)
                e_.print_stack_trace
              end
              # ignore that policy
            end
            ((n += 1) - 1)
          end
          return Boolean.value_of(loaded_policy)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return loaded_policy.boolean_value
    end
    
    typesig { [URL, PolicyInfo] }
    # 
    # Reads a policy configuration into the Policy object using a
    # Reader object.
    # 
    # @param policyFile the policy Reader object.
    def init(policy, new_info)
      success = false
      pp = PolicyParser.new(@expand_properties)
      isr = nil
      begin
        # read in policy using UTF-8 by default
        # 
        # check non-standard system property to see if
        # the default encoding should be used instead
        if (@not_utf8)
          isr = InputStreamReader.new(PolicyUtil.get_input_stream(policy))
        else
          isr = InputStreamReader.new(PolicyUtil.get_input_stream(policy), "UTF-8")
        end
        pp.read(isr)
        key_store = nil
        begin
          key_store = PolicyUtil.get_key_store(policy, pp.get_key_store_url, pp.get_key_store_type, pp.get_key_store_provider, pp.get_store_pass_url, Debug)
        rescue Exception => e
          # ignore, treat it like we have no keystore
          if (!(Debug).nil?)
            e.print_stack_trace
          end
        end
        enum_ = pp.grant_elements
        while (enum_.has_more_elements)
          ge = enum_.next_element
          add_grant_entry(ge, key_store, new_info)
        end
      rescue PolicyParser::ParsingException => pe
        form = MessageFormat.new(ResourcesMgr.get_string(POLICY + ": error parsing policy:\n\tmessage"))
        source = Array.typed(Object).new([policy, pe.get_localized_message])
        System.err.println(form.format(source))
        if (!(Debug).nil?)
          pe.print_stack_trace
        end
      rescue Exception => e
        if (!(Debug).nil?)
          Debug.println("error parsing " + (policy).to_s)
          Debug.println(e_.to_s)
          e_.print_stack_trace
        end
      ensure
        if (!(isr).nil?)
          begin
            isr.close
            success = true
          rescue IOException => e
            # ignore the exception
          end
        else
          success = true
        end
      end
      return success
    end
    
    typesig { [PolicyInfo] }
    def init_static_policy(new_info)
      AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members PolicyFile
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          pe = PolicyEntry.new(CodeSource.new(nil, nil))
          pe.add(SecurityConstants::LOCAL_LISTEN_PERMISSION)
          pe.add(PropertyPermission.new("java.version", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.vendor", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.vendor.url", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.class.version", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("os.name", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("os.version", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("os.arch", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("file.separator", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("path.separator", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("line.separator", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.specification.version", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.specification.vendor", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.specification.name", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.vm.specification.version", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.vm.specification.vendor", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.vm.specification.name", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.vm.version", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.vm.vendor", SecurityConstants::PROPERTY_READ_ACTION))
          pe.add(PropertyPermission.new("java.vm.name", SecurityConstants::PROPERTY_READ_ACTION))
          # No need to sync because noone has access to newInfo yet
          new_info.attr_policy_entries.add(pe)
          # Add AllPermissions for standard extensions
          ext_codebases = PolicyParser.parse_ext_dirs(PolicyParser::EXTDIRS_EXPANSION, 0)
          if (!(ext_codebases).nil? && ext_codebases.attr_length > 0)
            i = 0
            while i < ext_codebases.attr_length
              begin
                pe = PolicyEntry.new(canonicalize_codebase(CodeSource.new(URL.new(ext_codebases[i]), nil), false))
                pe.add(SecurityConstants::ALL_PERMISSION)
                # No need to sync because noone has access to
                # newInfo yet
                new_info.attr_policy_entries.add(pe)
              rescue Exception => e
                # this is probably bad (though not dangerous).
                # What should we do?
              end
              ((i += 1) - 1)
            end
          end
          return nil
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
    end
    
    typesig { [PolicyParser::GrantEntry, KeyStore, PolicyInfo] }
    # 
    # Given a GrantEntry, create a codeSource.
    # 
    # @return null if signedBy alias is not recognized
    def get_code_source(ge, key_store, new_info)
      certs = nil
      if (!(ge.attr_signed_by).nil?)
        certs = get_certificates(key_store, ge.attr_signed_by, new_info)
        if ((certs).nil?)
          # we don't have a key for this alias,
          # just return
          if (!(Debug).nil?)
            Debug.println("  -- No certs for alias '" + (ge.attr_signed_by).to_s + "' - ignoring entry")
          end
          return nil
        end
      end
      location = nil
      if (!(ge.attr_code_base).nil?)
        location = URL.new(ge.attr_code_base)
      else
        location = nil
      end
      return (canonicalize_codebase(CodeSource.new(location, certs), false))
    end
    
    typesig { [PolicyParser::GrantEntry, KeyStore, PolicyInfo] }
    # 
    # Add one policy entry to the list.
    def add_grant_entry(ge, key_store, new_info)
      if (!(Debug).nil?)
        Debug.println("Adding policy entry: ")
        Debug.println("  signedBy " + (ge.attr_signed_by).to_s)
        Debug.println("  codeBase " + (ge.attr_code_base).to_s)
        if (!(ge.attr_principals).nil? && ge.attr_principals.size > 0)
          li = ge.attr_principals.list_iterator
          while (li.has_next)
            pppe = li.next
            Debug.println("  " + (pppe.to_s).to_s)
          end
        end
      end
      begin
        codesource = get_code_source(ge, key_store, new_info)
        # skip if signedBy alias was unknown...
        if ((codesource).nil?)
          return
        end
        # perform keystore alias principal replacement.
        # for example, if alias resolves to X509 certificate,
        # replace principal with:  <X500Principal class>  <SubjectDN>
        # -- skip if alias is unknown
        if ((replace_principals(ge.attr_principals, key_store)).equal?(false))
          return
        end
        entry = PolicyEntry.new(codesource, ge.attr_principals)
        enum_ = ge.permission_elements
        while (enum_.has_more_elements)
          pe = enum_.next_element
          begin
            # perform ${{ ... }} expansions within permission name
            expand_permission_name(pe, key_store)
            # XXX special case PrivateCredentialPermission-SELF
            perm = nil
            if ((pe.attr_permission == "javax.security.auth.PrivateCredentialPermission") && pe.attr_name.ends_with(" self"))
              pe.attr_name = (pe.attr_name.substring(0, pe.attr_name.index_of("self"))).to_s + SELF
            end
            # check for self
            if (!(pe.attr_name).nil? && !(pe.attr_name.index_of(SELF)).equal?(-1))
              # Create a "SelfPermission" , it could be an
              # an unresolved permission which will be resolved
              # when implies is called
              # Add it to entry
              certs = nil
              if (!(pe.attr_signed_by).nil?)
                certs = get_certificates(key_store, pe.attr_signed_by, new_info)
              else
                certs = nil
              end
              perm = SelfPermission.new(pe.attr_permission, pe.attr_name, pe.attr_action, certs)
            else
              perm = get_instance(pe.attr_permission, pe.attr_name, pe.attr_action)
            end
            entry.add(perm)
            if (!(Debug).nil?)
              Debug.println("  " + (perm).to_s)
            end
          rescue ClassNotFoundException => cnfe
            certs_ = nil
            if (!(pe.attr_signed_by).nil?)
              certs_ = get_certificates(key_store, pe.attr_signed_by, new_info)
            else
              certs_ = nil
            end
            # only add if we had no signer or we had a
            # a signer and found the keys for it.
            if (!(certs_).nil? || (pe.attr_signed_by).nil?)
              perm_ = UnresolvedPermission.new(pe.attr_permission, pe.attr_name, pe.attr_action, certs_)
              entry.add(perm_)
              if (!(Debug).nil?)
                Debug.println("  " + (perm_).to_s)
              end
            end
          rescue Java::Lang::Reflect::InvocationTargetException => ite
            form = MessageFormat.new(ResourcesMgr.get_string(POLICY + ": error adding Permission, perm:\n\tmessage"))
            source = Array.typed(Object).new([pe.attr_permission, ite.get_target_exception.to_s])
            System.err.println(form.format(source))
          rescue Exception => e
            form_ = MessageFormat.new(ResourcesMgr.get_string(POLICY + ": error adding Permission, perm:\n\tmessage"))
            source_ = Array.typed(Object).new([pe.attr_permission, e.to_s])
            System.err.println(form_.format(source_))
          end
        end
        # No need to sync because noone has access to newInfo yet
        new_info.attr_policy_entries.add(entry)
      rescue Exception => e
        form__ = MessageFormat.new(ResourcesMgr.get_string(POLICY + ": error adding Entry:\n\tmessage"))
        source__ = Array.typed(Object).new([e_.to_s])
        System.err.println(form__.format(source__))
      end
      if (!(Debug).nil?)
        Debug.println
      end
    end
    
    class_module.module_eval {
      typesig { [String, String, String] }
      # 
      # Returns a new Permission object of the given Type. The Permission is
      # created by getting the
      # Class object using the <code>Class.forName</code> method, and using
      # the reflection API to invoke the (String name, String actions)
      # constructor on the
      # object.
      # 
      # @param type the type of Permission being created.
      # @param name the name of the Permission being created.
      # @param actions the actions of the Permission being created.
      # 
      # @exception  ClassNotFoundException  if the particular Permission
      # class could not be found.
      # 
      # @exception  IllegalAccessException  if the class or initializer is
      # not accessible.
      # 
      # @exception  InstantiationException  if getInstance tries to
      # instantiate an abstract class or an interface, or if the
      # instantiation fails for some other reason.
      # 
      # @exception  NoSuchMethodException if the (String, String) constructor
      # is not found.
      # 
      # @exception  InvocationTargetException if the underlying Permission
      # constructor throws an exception.
      def get_instance(type, name, actions)
        # XXX we might want to keep a hash of created factories...
        pc = Class.for_name(type)
        answer = get_known_instance(pc, name, actions)
        if (!(answer).nil?)
          return answer
        end
        if ((name).nil? && (actions).nil?)
          begin
            c = pc.get_constructor(PARAMS0)
            return c.new_instance(Array.typed(Object).new([]))
          rescue NoSuchMethodException => ne
            begin
              c_ = pc.get_constructor(PARAMS1)
              return c_.new_instance(Array.typed(Object).new([name]))
            rescue NoSuchMethodException => ne1
              c__ = pc.get_constructor(PARAMS2)
              return c__.new_instance(Array.typed(Object).new([name, actions]))
            end
          end
        else
          if (!(name).nil? && (actions).nil?)
            begin
              c___ = pc.get_constructor(PARAMS1)
              return c___.new_instance(Array.typed(Object).new([name]))
            rescue NoSuchMethodException => ne
              c____ = pc.get_constructor(PARAMS2)
              return c____.new_instance(Array.typed(Object).new([name, actions]))
            end
          else
            c_____ = pc.get_constructor(PARAMS2)
            return c_____.new_instance(Array.typed(Object).new([name, actions]))
          end
        end
      end
      
      typesig { [Class, String, String] }
      # 
      # Creates one of the well-known permissions directly instead of
      # via reflection. Keep list short to not penalize non-JDK-defined
      # permissions.
      def get_known_instance(claz, name, actions)
        # XXX shorten list to most popular ones?
        if ((claz == FilePermission.class))
          return FilePermission.new(name, actions)
        else
          if ((claz == SocketPermission.class))
            return SocketPermission.new(name, actions)
          else
            if ((claz == RuntimePermission.class))
              return RuntimePermission.new(name, actions)
            else
              if ((claz == PropertyPermission.class))
                return PropertyPermission.new(name, actions)
              else
                if ((claz == NetPermission.class))
                  return NetPermission.new(name, actions)
                else
                  if ((claz == AllPermission.class))
                    return SecurityConstants::ALL_PERMISSION
                  else
                    if ((claz == AWTPermission.class))
                      return AWTPermission.new(name, actions)
                      # 
                      # } else if (claz.equals(ReflectPermission.class)) {
                      # return new ReflectPermission(name, actions);
                      # } else if (claz.equals(SecurityPermission.class)) {
                      # return new SecurityPermission(name, actions);
                      # } else if (claz.equals(PrivateCredentialPermission.class)) {
                      # return new PrivateCredentialPermission(name, actions);
                      # } else if (claz.equals(AuthPermission.class)) {
                      # return new AuthPermission(name, actions);
                      # } else if (claz.equals(ServicePermission.class)) {
                      # return new ServicePermission(name, actions);
                      # } else if (claz.equals(DelegationPermission.class)) {
                      # return new DelegationPermission(name, actions);
                      # } else if (claz.equals(SerializablePermission.class)) {
                      # return new SerializablePermission(name, actions);
                      # } else if (claz.equals(AudioPermission.class)) {
                      # return new AudioPermission(name, actions);
                      # } else if (claz.equals(SSLPermission.class)) {
                      # return new SSLPermission(name, actions);
                      # } else if (claz.equals(LoggingPermission.class)) {
                      # return new LoggingPermission(name, actions);
                      # } else if (claz.equals(SQLPermission.class)) {
                      # return new SQLPermission(name, actions);
                    else
                      return nil
                    end
                  end
                end
              end
            end
          end
        end
      end
    }
    
    typesig { [KeyStore, String, PolicyInfo] }
    # 
    # Fetch all certs associated with this alias.
    def get_certificates(key_store, aliases, new_info)
      vcerts = nil
      st = StringTokenizer.new(aliases, ",")
      n = 0
      while (st.has_more_tokens)
        alias_ = st.next_token.trim
        ((n += 1) - 1)
        cert = nil
        # See if this alias's cert has already been cached
        synchronized((new_info.attr_alias_mapping)) do
          cert = new_info.attr_alias_mapping.get(alias_)
          if ((cert).nil? && !(key_store).nil?)
            begin
              cert = key_store.get_certificate(alias_)
            rescue KeyStoreException => kse
              # never happens, because keystore has already been loaded
              # when we call this
            end
            if (!(cert).nil?)
              new_info.attr_alias_mapping.put(alias_, cert)
              new_info.attr_alias_mapping.put(cert, alias_)
            end
          end
        end
        if (!(cert).nil?)
          if ((vcerts).nil?)
            vcerts = ArrayList.new
          end
          vcerts.add(cert)
        end
      end
      # make sure n == vcerts.size, since we are doing a logical *and*
      if (!(vcerts).nil? && (n).equal?(vcerts.size))
        certs = Array.typed(Certificate).new(vcerts.size) { nil }
        vcerts.to_array(certs)
        return certs
      else
        return nil
      end
    end
    
    typesig { [] }
    # 
    # Refreshes the policy object by re-reading all the policy files.
    def refresh
      init(@url)
    end
    
    typesig { [ProtectionDomain, Permission] }
    # 
    # Evaluates the the global policy for the permissions granted to
    # the ProtectionDomain and tests whether the permission is
    # granted.
    # 
    # @param domain the ProtectionDomain to test
    # @param permission the Permission object to be tested for implication.
    # 
    # @return true if "permission" is a proper subset of a permission
    # granted to this ProtectionDomain.
    # 
    # @see java.security.ProtectionDomain
    def implies(pd, p)
      pi = @policy_info.get
      pd_map = pi.get_pd_mapping
      pc = pd_map.get(pd)
      if (!(pc).nil?)
        return pc.implies(p)
      end
      pc = get_permissions(pd)
      if ((pc).nil?)
        return false
      end
      # cache mapping of protection domain to its PermissionCollection
      pd_map.put(pd, pc)
      return pc.implies(p)
    end
    
    typesig { [ProtectionDomain] }
    # 
    # Examines this <code>Policy</code> and returns the permissions granted
    # to the specified <code>ProtectionDomain</code>.  This includes
    # the permissions currently associated with the domain as well
    # as the policy permissions granted to the domain's
    # CodeSource, ClassLoader, and Principals.
    # 
    # <p> Note that this <code>Policy</code> implementation has
    # special handling for PrivateCredentialPermissions.
    # When this method encounters a <code>PrivateCredentialPermission</code>
    # which specifies "self" as the <code>Principal</code> class and name,
    # it does not add that <code>Permission</code> to the returned
    # <code>PermissionCollection</code>.  Instead, it builds
    # a new <code>PrivateCredentialPermission</code>
    # for each <code>Principal</code> associated with the provided
    # <code>Subject</code>.  Each new <code>PrivateCredentialPermission</code>
    # contains the same Credential class as specified in the
    # originally granted permission, as well as the Class and name
    # for the respective <code>Principal</code>.
    # 
    # <p>
    # 
    # @param domain the Permissions granted to this
    # <code>ProtectionDomain</code> are returned.
    # 
    # @return the Permissions granted to the provided
    # <code>ProtectionDomain</code>.
    def get_permissions(domain)
      perms = Permissions.new
      if ((domain).nil?)
        return perms
      end
      # first get policy perms
      get_permissions(perms, domain)
      # add static perms
      # - adding static perms after policy perms is necessary
      # to avoid a regression for 4301064
      pc = domain.get_permissions
      if (!(pc).nil?)
        synchronized((pc)) do
          e = pc.elements
          while (e.has_more_elements)
            perms.add(e.next_element)
          end
        end
      end
      return perms
    end
    
    typesig { [CodeSource] }
    # 
    # Examines this Policy and creates a PermissionCollection object with
    # the set of permissions for the specified CodeSource.
    # 
    # @param CodeSource the codesource associated with the caller.
    # This encapsulates the original location of the code (where the code
    # came from) and the public key(s) of its signer.
    # 
    # @return the set of permissions according to the policy.
    def get_permissions(codesource)
      return get_permissions(Permissions.new, codesource)
    end
    
    typesig { [Permissions, ProtectionDomain] }
    # 
    # Examines the global policy and returns the provided Permissions
    # object with additional permissions granted to the specified
    # ProtectionDomain.
    # 
    # @param perm the Permissions to populate
    # @param pd the ProtectionDomain associated with the caller.
    # 
    # @return the set of Permissions according to the policy.
    def get_permissions(perms, pd)
      if (!(Debug).nil?)
        Debug.println("getPermissions:\n\t" + (print_pd(pd)).to_s)
      end
      cs = pd.get_code_source
      if ((cs).nil?)
        return perms
      end
      canon_code_source = AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members PolicyFile
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return canonicalize_codebase(cs, true)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return get_permissions(perms, canon_code_source, pd.get_principals)
    end
    
    typesig { [Permissions, CodeSource] }
    # 
    # Examines the global policy and returns the provided Permissions
    # object with additional permissions granted to the specified
    # CodeSource.
    # 
    # @param permissions the permissions to populate
    # @param codesource the codesource associated with the caller.
    # This encapsulates the original location of the code (where the code
    # came from) and the public key(s) of its signer.
    # 
    # @return the set of permissions according to the policy.
    def get_permissions(perms, cs)
      canon_code_source = AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members PolicyFile
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return canonicalize_codebase(cs, true)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      return get_permissions(perms, canon_code_source, nil)
    end
    
    typesig { [Permissions, CodeSource, Array.typed(Principal)] }
    def get_permissions(perms, cs, principals)
      pi = @policy_info.get
      pi.attr_policy_entries.each do |entry|
        add_permissions(perms, cs, principals, entry)
      end
      # Go through policyEntries gotten from identity db; sync required
      # because checkForTrustedIdentity (below) might update list
      synchronized((pi.attr_identity_policy_entries)) do
        pi.attr_identity_policy_entries.each do |entry|
          add_permissions(perms, cs, principals, entry_)
        end
      end
      # now see if any of the keys are trusted ids.
      if (!@ignore_identity_scope)
        certs = cs.get_certificates
        if (!(certs).nil?)
          k = 0
          while k < certs.attr_length
            id_map = pi.attr_alias_mapping.get(certs[k])
            if ((id_map).nil? && check_for_trusted_identity(certs[k], pi))
              # checkForTrustedIdentity added it
              # to the policy for us. next time
              # around we'll find it. This time
              # around we need to add it.
              perms.add(SecurityConstants::ALL_PERMISSION)
            end
            ((k += 1) - 1)
          end
        end
      end
      return perms
    end
    
    typesig { [Permissions, CodeSource, Array.typed(Principal), PolicyEntry] }
    def add_permissions(perms, cs, principals, entry)
      if (!(Debug).nil?)
        Debug.println("evaluate codesources:\n" + "\tPolicy CodeSource: " + (entry.get_code_source).to_s + "\n" + "\tActive CodeSource: " + (cs).to_s)
      end
      imp = AccessController.do_privileged(# check to see if the CodeSource implies
      Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members PolicyFile
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return Boolean.new(entry.get_code_source.implies(cs))
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (!imp.boolean_value)
        if (!(Debug).nil?)
          Debug.println("evaluation (codesource) failed")
        end
        # CodeSource does not imply - return and try next policy entry
        return
      end
      # check to see if the Principals imply
      entry_ps = entry.get_principals
      if (!(Debug).nil?)
        acc_ps = ArrayList.new
        if (!(principals).nil?)
          i = 0
          while i < principals.attr_length
            acc_ps.add(PolicyParser::PrincipalEntry.new(principals[i].get_class.get_name, principals[i].get_name))
            ((i += 1) - 1)
          end
        end
        Debug.println("evaluate principals:\n" + "\tPolicy Principals: " + (entry_ps).to_s + "\n" + "\tActive Principals: " + (acc_ps).to_s)
      end
      if ((entry_ps).nil? || (entry_ps.size).equal?(0))
        # policy entry has no principals -
        # add perms regardless of principals in current ACC
        add_perms(perms, principals, entry)
        if (!(Debug).nil?)
          Debug.println("evaluation (codesource/principals) passed")
        end
        return
      else
        if ((principals).nil? || (principals.attr_length).equal?(0))
          # current thread has no principals but this policy entry
          # has principals - perms are not added
          if (!(Debug).nil?)
            Debug.println("evaluation (principals) failed")
          end
          return
        end
      end
      # current thread has principals and this policy entry
      # has principals.  see if policy entry principals match
      # principals in current ACC
      i_ = 0
      while i_ < entry_ps.size
        pppe = entry_ps.get(i_)
        # see if principal entry is a PrincipalComparator
        begin
          p_class = Class.for_name(pppe.attr_principal_class, true, JavaThread.current_thread.get_context_class_loader)
          if (!PrincipalComparator.class.is_assignable_from(p_class))
            # common case - dealing with regular Principal class.
            # see if policy entry principal is in current ACC
            if (!check_entry_ps(principals, pppe))
              if (!(Debug).nil?)
                Debug.println("evaluation (principals) failed")
              end
              # policy entry principal not in current ACC -
              # immediately return and go to next policy entry
              return
            end
          else
            # dealing with a PrincipalComparator
            c = p_class.get_constructor(PARAMS1)
            pc = c.new_instance(Array.typed(Object).new([pppe.attr_principal_name]))
            if (!(Debug).nil?)
              Debug.println("found PrincipalComparator " + (pc.get_class.get_name).to_s)
            end
            # check if the PrincipalComparator
            # implies the current thread's principals
            p_set = HashSet.new(principals.attr_length)
            j = 0
            while j < principals.attr_length
              p_set.add(principals[j])
              ((j += 1) - 1)
            end
            subject = Subject.new(true, p_set, Collections::EMPTY_SET, Collections::EMPTY_SET)
            if (!pc.implies(subject))
              if (!(Debug).nil?)
                Debug.println("evaluation (principal comparator) failed")
              end
              # policy principal does not imply the current Subject -
              # immediately return and go to next policy entry
              return
            end
          end
        rescue Exception => e
          # fall back to regular principal comparison.
          # see if policy entry principal is in current ACC
          if (!(Debug).nil?)
            e.print_stack_trace
          end
          if (!check_entry_ps(principals, pppe))
            if (!(Debug).nil?)
              Debug.println("evaluation (principals) failed")
            end
            # policy entry principal not in current ACC -
            # immediately return and go to next policy entry
            return
          end
        end
        ((i_ += 1) - 1)
      end
      # all policy entry principals were found in the current ACC -
      # grant the policy permissions
      if (!(Debug).nil?)
        Debug.println("evaluation (codesource/principals) passed")
      end
      add_perms(perms, principals, entry)
    end
    
    typesig { [Permissions, Array.typed(Principal), PolicyEntry] }
    def add_perms(perms, acc_ps, entry)
      i = 0
      while i < entry.attr_permissions.size
        p = entry.attr_permissions.get(i)
        if (!(Debug).nil?)
          Debug.println("  granting " + (p).to_s)
        end
        if (p.is_a?(SelfPermission))
          # handle "SELF" permissions
          expand_self(p, entry.get_principals, acc_ps, perms)
        else
          perms.add(p)
        end
        ((i += 1) - 1)
      end
    end
    
    typesig { [Array.typed(Principal), PolicyParser::PrincipalEntry] }
    # 
    # This method returns, true, if the principal in the policy entry,
    # pppe, is part of the current thread's principal array, pList.
    # This method also returns, true, if the policy entry's principal
    # is appropriately wildcarded.
    # 
    # Note that the provided <i>pppe</i> argument may have
    # wildcards (*) for both the <code>Principal</code> class and name.
    # 
    # @param pList an array of principals from the current thread's
    # AccessControlContext.
    # 
    # @param pppe a Principal specified in a policy grant entry.
    # 
    # @return true if the current thread's pList "contains" the
    # principal in the policy entry, pppe.  This method
    # also returns true if the policy entry's principal
    # appropriately wildcarded.
    def check_entry_ps(p_list, pppe)
      i = 0
      while i < p_list.attr_length
        if ((pppe.attr_principal_class == PolicyParser::PrincipalEntry::WILDCARD_CLASS) || (pppe.attr_principal_class == p_list[i].get_class.get_name))
          if ((pppe.attr_principal_name == PolicyParser::PrincipalEntry::WILDCARD_NAME) || (pppe.attr_principal_name == p_list[i].get_name))
            return true
          end
        end
        ((i += 1) - 1)
      end
      return false
    end
    
    typesig { [SelfPermission, JavaList, Array.typed(Principal), Permissions] }
    # 
    # <p>
    # 
    # @param sp the SelfPermission that needs to be expanded <p>
    # 
    # @param entryPs list of principals for the Policy entry.
    # 
    # @param pdp Principal array from the current ProtectionDomain.
    # 
    # @param perms the PermissionCollection where the individual
    # Permissions will be added after expansion.
    def expand_self(sp, entry_ps, pdp, perms)
      if ((entry_ps).nil? || (entry_ps.size).equal?(0))
        # No principals in the grant to substitute
        if (!(Debug).nil?)
          Debug.println("Ignoring permission " + (sp.get_self_type).to_s + " with target name (" + (sp.get_self_name).to_s + ").  " + "No Principal(s) specified " + "in the grant clause.  " + "SELF-based target names are " + "only valid in the context " + "of a Principal-based grant entry.")
        end
        return
      end
      start_index = 0
      v = 0
      sb = StringBuilder.new
      while (!((v = sp.get_self_name.index_of(SELF, start_index))).equal?(-1))
        # add non-SELF string
        sb.append(sp.get_self_name.substring(start_index, v))
        # expand SELF
        pli = entry_ps.list_iterator
        while (pli.has_next)
          pppe = pli.next
          principal_info = get_principal_info(pppe, pdp)
          i = 0
          while i < principal_info.attr_length
            if (!(i).equal?(0))
              sb.append(", ")
            end
            sb.append((principal_info[i][0]).to_s + " " + "\"" + (principal_info[i][1]).to_s + "\"")
            ((i += 1) - 1)
          end
          if (pli.has_next)
            sb.append(", ")
          end
        end
        start_index = v + SELF.length
      end
      # add remaining string (might be the entire string)
      sb.append(sp.get_self_name.substring(start_index))
      if (!(Debug).nil?)
        Debug.println("  expanded:\n\t" + (sp.get_self_name).to_s + "\n  into:\n\t" + (sb.to_s).to_s)
      end
      begin
        # first try to instantiate the permission
        perms.add(get_instance(sp.get_self_type, sb.to_s, sp.get_self_actions))
      rescue ClassNotFoundException => cnfe
        # ok, the permission is not in the bootclasspath.
        # before we add an UnresolvedPermission, check to see
        # whether this perm already belongs to the collection.
        # if so, use that perm's ClassLoader to create a new
        # one.
        pc = nil
        synchronized((perms)) do
          e = perms.elements
          while (e.has_more_elements)
            p_element = e.next_element
            if ((p_element.get_class.get_name == sp.get_self_type))
              pc = p_element.get_class
              break
            end
          end
        end
        if ((pc).nil?)
          # create an UnresolvedPermission
          perms.add(UnresolvedPermission.new(sp.get_self_type, sb.to_s, sp.get_self_actions, sp.get_certs))
        else
          begin
            # we found an instantiated permission.
            # use its class loader to instantiate a new permission.
            c = nil
            # name parameter can not be null
            if ((sp.get_self_actions).nil?)
              begin
                c = pc.get_constructor(PARAMS1)
                perms.add(c.new_instance(Array.typed(Object).new([sb.to_s])))
              rescue NoSuchMethodException => ne
                c = pc.get_constructor(PARAMS2)
                perms.add(c.new_instance(Array.typed(Object).new([sb.to_s, sp.get_self_actions])))
              end
            else
              c = pc.get_constructor(PARAMS2)
              perms.add(c.new_instance(Array.typed(Object).new([sb.to_s, sp.get_self_actions])))
            end
          rescue Exception => nme
            if (!(Debug).nil?)
              Debug.println("self entry expansion " + " instantiation failed: " + (nme.to_s).to_s)
            end
          end
        end
      rescue Exception => e
        if (!(Debug).nil?)
          Debug.println(e_.to_s)
        end
      end
    end
    
    typesig { [PolicyParser::PrincipalEntry, Array.typed(Principal)] }
    # 
    # return the principal class/name pair in the 2D array.
    # array[x][y]:     x corresponds to the array length.
    # if (y == 0), it's the principal class.
    # if (y == 1), it's the principal name.
    def get_principal_info(pe, pdp)
      # there are 3 possibilities:
      # 1) the entry's Principal class and name are not wildcarded
      # 2) the entry's Principal name is wildcarded only
      # 3) the entry's Principal class and name are wildcarded
      if (!(pe.attr_principal_class == PolicyParser::PrincipalEntry::WILDCARD_CLASS) && !(pe.attr_principal_name == PolicyParser::PrincipalEntry::WILDCARD_NAME))
        # build an info array for the principal
        # from the Policy entry
        info = Array.typed(String).new(1) { Array.typed(String).new(2) { nil } }
        info[0][0] = pe.attr_principal_class
        info[0][1] = pe.attr_principal_name
        return info
      else
        if (!(pe.attr_principal_class == PolicyParser::PrincipalEntry::WILDCARD_CLASS) && (pe.attr_principal_name == PolicyParser::PrincipalEntry::WILDCARD_NAME))
          # build an info array for every principal
          # in the current domain which has a principal class
          # that is equal to policy entry principal class name
          plist = ArrayList.new
          i = 0
          while i < pdp.attr_length
            if ((pe.attr_principal_class == pdp[i].get_class.get_name))
              plist.add(pdp[i])
            end
            ((i += 1) - 1)
          end
          info_ = Array.typed(String).new(plist.size) { Array.typed(String).new(2) { nil } }
          i_ = 0
          p_iterator = plist.iterator
          while (p_iterator.has_next)
            p = p_iterator.next
            info_[i_][0] = p.get_class.get_name
            info_[i_][1] = p.get_name
            ((i_ += 1) - 1)
          end
          return info_
        else
          # build an info array for every
          # one of the current Domain's principals
          info__ = Array.typed(String).new(pdp.attr_length) { Array.typed(String).new(2) { nil } }
          i__ = 0
          while i__ < pdp.attr_length
            info__[i__][0] = pdp[i__].get_class.get_name
            info__[i__][1] = pdp[i__].get_name
            ((i__ += 1) - 1)
          end
          return info__
        end
      end
    end
    
    typesig { [CodeSource] }
    # 
    # Returns the signer certificates from the list of certificates
    # associated with the given code source.
    # 
    # The signer certificates are those certificates that were used
    # to verifysigned code originating from the codesource location.
    # 
    # This method assumes that in the given code source, each signer
    # certificate is followed by its supporting certificate chain
    # (which may be empty), and that the signer certificate and its
    # supporting certificate chain are ordered bottom-to-top
    # (i.e., with the signer certificate first and the (root) certificate
    # authority last).
    def get_signer_certificates(cs)
      certs = nil
      if (((certs = cs.get_certificates)).nil?)
        return nil
      end
      i = 0
      while i < certs.attr_length
        if (!(certs[i].is_a?(X509Certificate)))
          return cs.get_certificates
        end
        ((i += 1) - 1)
      end
      # Do we have to do anything?
      i_ = 0
      count = 0
      while (i_ < certs.attr_length)
        ((count += 1) - 1)
        while (((i_ + 1) < certs.attr_length) && ((certs[i_]).get_issuer_dn == (certs[i_ + 1]).get_subject_dn))
          ((i_ += 1) - 1)
        end
        ((i_ += 1) - 1)
      end
      if ((count).equal?(certs.attr_length))
        # Done
        return certs
      end
      user_cert_list = ArrayList.new
      i_ = 0
      while (i_ < certs.attr_length)
        user_cert_list.add(certs[i_])
        while (((i_ + 1) < certs.attr_length) && ((certs[i_]).get_issuer_dn == (certs[i_ + 1]).get_subject_dn))
          ((i_ += 1) - 1)
        end
        ((i_ += 1) - 1)
      end
      user_certs = Array.typed(Certificate).new(user_cert_list.size) { nil }
      user_cert_list.to_array(user_certs)
      return user_certs
    end
    
    typesig { [CodeSource, ::Java::Boolean] }
    def canonicalize_codebase(cs, extract_signer_certs)
      path = nil
      canon_cs = cs
      u = cs.get_location
      if (!(u).nil? && (u.get_protocol == "file"))
        is_local_file = false
        host = u.get_host
        is_local_file = ((host).nil? || (host == "") || (host == "~") || host.equals_ignore_case("localhost"))
        if (is_local_file)
          path = (u.get_file.replace(Character.new(?/.ord), JavaFile.attr_separator_char)).to_s
          path = (ParseUtil.decode(path)).to_s
        end
      end
      if (!(path).nil?)
        begin
          cs_url = nil
          path = (canon_path(path)).to_s
          cs_url = ParseUtil.file_to_encoded_url(JavaFile.new(path))
          if (extract_signer_certs)
            canon_cs = CodeSource.new(cs_url, get_signer_certificates(cs))
          else
            canon_cs = CodeSource.new(cs_url, cs.get_certificates)
          end
        rescue IOException => ioe
          # leave codesource as it is, unless we have to extract its
          # signer certificates
          if (extract_signer_certs)
            canon_cs = CodeSource.new(cs.get_location, get_signer_certificates(cs))
          end
        end
      else
        if (extract_signer_certs)
          canon_cs = CodeSource.new(cs.get_location, get_signer_certificates(cs))
        end
      end
      return canon_cs
    end
    
    class_module.module_eval {
      typesig { [String] }
      # public for java.io.FilePermission
      def canon_path(path)
        if (path.ends_with("*"))
          path = (path.substring(0, path.length - 1)).to_s + "-"
          path = (JavaFile.new(path).get_canonical_path).to_s
          return (path.substring(0, path.length - 1)).to_s + "*"
        else
          return JavaFile.new(path).get_canonical_path
        end
      end
    }
    
    typesig { [ProtectionDomain] }
    def print_pd(pd)
      principals = pd.get_principals
      pals = "<no principals>"
      if (!(principals).nil? && principals.attr_length > 0)
        pal_buf = StringBuilder.new("(principals ")
        i = 0
        while i < principals.attr_length
          pal_buf.append((principals[i].get_class.get_name).to_s + " \"" + (principals[i].get_name).to_s + "\"")
          if (i < principals.attr_length - 1)
            pal_buf.append(", ")
          else
            pal_buf.append(")")
          end
          ((i += 1) - 1)
        end
        pals = (pal_buf.to_s).to_s
      end
      return "PD CodeSource: " + (pd.get_code_source).to_s + "\n\t" + "PD ClassLoader: " + (pd.get_class_loader).to_s + "\n\t" + "PD Principals: " + pals
    end
    
    typesig { [JavaList, KeyStore] }
    # 
    # return true if no replacement was performed,
    # or if replacement succeeded.
    def replace_principals(principals, keystore)
      if ((principals).nil? || (principals.size).equal?(0) || (keystore).nil?)
        return true
      end
      i = principals.list_iterator
      while (i.has_next)
        pppe = i.next
        if ((pppe.attr_principal_class == PolicyParser::REPLACE_NAME))
          # perform replacement
          # (only X509 replacement is possible now)
          name = nil
          if (((name = (get_dn(pppe.attr_principal_name, keystore)).to_s)).nil?)
            return false
          end
          if (!(Debug).nil?)
            Debug.println("  Replacing \"" + (pppe.attr_principal_name).to_s + "\" with " + X500PRINCIPAL + "/\"" + name + "\"")
          end
          pppe.attr_principal_class = X500PRINCIPAL
          pppe.attr_principal_name = name
        end
      end
      # return true if no replacement was performed,
      # or if replacement succeeded
      return true
    end
    
    typesig { [PolicyParser::PermissionEntry, KeyStore] }
    def expand_permission_name(pe, keystore)
      # short cut the common case
      if ((pe.attr_name).nil? || (pe.attr_name.index_of("${{", 0)).equal?(-1))
        return
      end
      start_index = 0
      b = 0
      e = 0
      sb = StringBuilder.new
      while (!((b = pe.attr_name.index_of("${{", start_index))).equal?(-1))
        e = pe.attr_name.index_of("}}", b)
        if (e < 1)
          break
        end
        sb.append(pe.attr_name.substring(start_index, b))
        # get the value in ${{...}}
        value = pe.attr_name.substring(b + 3, e)
        # parse up to the first ':'
        colon_index = 0
        prefix = value
        suffix = nil
        if (!((colon_index = value.index_of(":"))).equal?(-1))
          prefix = (value.substring(0, colon_index)).to_s
        end
        # handle different prefix possibilities
        if (prefix.equals_ignore_case("self"))
          # do nothing - handled later
          sb.append(pe.attr_name.substring(b, e + 2))
          start_index = e + 2
          next
        else
          if (prefix.equals_ignore_case("alias"))
            # get the suffix and perform keystore alias replacement
            if ((colon_index).equal?(-1))
              form = MessageFormat.new(ResourcesMgr.get_string("alias name not provided (pe.name)"))
              source = Array.typed(Object).new([pe.attr_name])
              raise Exception.new(form.format(source))
            end
            suffix = (value.substring(colon_index + 1)).to_s
            if (((suffix = (get_dn(suffix, keystore)).to_s)).nil?)
              form_ = MessageFormat.new(ResourcesMgr.get_string("unable to perform substitution on alias, suffix"))
              source_ = Array.typed(Object).new([value.substring(colon_index + 1)])
              raise Exception.new(form_.format(source_))
            end
            sb.append(X500PRINCIPAL + " \"" + suffix + "\"")
            start_index = e + 2
          else
            form__ = MessageFormat.new(ResourcesMgr.get_string("substitution value, prefix, unsupported"))
            source__ = Array.typed(Object).new([prefix])
            raise Exception.new(form__.format(source__))
          end
        end
      end
      # copy the rest of the value
      sb.append(pe.attr_name.substring(start_index))
      # replace the name with expanded value
      if (!(Debug).nil?)
        Debug.println("  Permission name expanded from:\n\t" + (pe.attr_name).to_s + "\nto\n\t" + (sb.to_s).to_s)
      end
      pe.attr_name = sb.to_s
    end
    
    typesig { [String, KeyStore] }
    def get_dn(alias_, keystore)
      cert = nil
      begin
        cert = keystore.get_certificate(alias_)
      rescue Exception => e
        if (!(Debug).nil?)
          Debug.println("  Error retrieving certificate for '" + alias_ + "': " + (e.to_s).to_s)
        end
        return nil
      end
      if ((cert).nil? || !(cert.is_a?(X509Certificate)))
        if (!(Debug).nil?)
          Debug.println("  -- No certificate for '" + alias_ + "' - ignoring entry")
        end
        return nil
      else
        x509cert = cert
        # 4702543:  X500 names with an EmailAddress
        # were encoded incorrectly.  create new
        # X500Principal name with correct encoding
        p = X500Principal.new(x509cert.get_subject_x500principal.to_s)
        return p.get_name
      end
    end
    
    typesig { [Certificate, PolicyInfo] }
    # 
    # Checks public key. If it is marked as trusted in
    # the identity database, add it to the policy
    # with the AllPermission.
    def check_for_trusted_identity(cert, my_info)
      if ((cert).nil?)
        return false
      end
      # see if we are ignoring the identity scope or not
      if (@ignore_identity_scope)
        return false
      end
      # try to initialize scope
      synchronized((PolicyFile.class)) do
        if ((self.attr_scope).nil?)
          is = IdentityScope.get_system_scope
          if (is.is_a?(Sun::Security::Provider::IdentityDatabase))
            self.attr_scope = is
          else
            # leave scope null
          end
        end
      end
      if ((self.attr_scope).nil?)
        @ignore_identity_scope = true
        return false
      end
      id = AccessController.do_privileged(# need privileged block for getIdentity in case we are trying
      # to get a signer
      Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
        extend LocalClass
        include_class_members PolicyFile
        include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return self.attr_scope.get_identity(cert.get_public_key)
        end
        
        typesig { [] }
        define_method :initialize do
          super()
        end
        
        private
        alias_method :initialize_anonymous, :initialize
      end.new_local(self))
      if (is_trusted(id))
        if (!(Debug).nil?)
          Debug.println("Adding policy entry for trusted Identity: ")
          AccessController.do_privileged(# needed for identity toString!
          Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
            extend LocalClass
            include_class_members PolicyFile
            include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              Debug.println("  identity = " + (id).to_s)
              return nil
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          Debug.println("")
        end
        # add it to the policy for future reference
        certs = Array.typed(Certificate).new([cert])
        pe = PolicyEntry.new(CodeSource.new(nil, certs))
        pe.add(SecurityConstants::ALL_PERMISSION)
        my_info.attr_identity_policy_entries.add(pe)
        # add it to the mapping as well so
        # we don't have to go through this again
        my_info.attr_alias_mapping.put(cert, id.get_name)
        return true
      end
      return false
    end
    
    class_module.module_eval {
      typesig { [Identity] }
      def is_trusted(id)
        if (id.is_a?(SystemIdentity))
          sysid = id
          if (sysid.is_trusted)
            return true
          end
        else
          if (id.is_a?(SystemSigner))
            sysid_ = id
            if (sysid_.is_trusted)
              return true
            end
          end
        end
        return false
      end
      
      # 
      # Each entry in the policy configuration file is represented by a
      # PolicyEntry object.  <p>
      # 
      # A PolicyEntry is a (CodeSource,Permission) pair.  The
      # CodeSource contains the (URL, PublicKey) that together identify
      # where the Java bytecodes come from and who (if anyone) signed
      # them.  The URL could refer to localhost.  The URL could also be
      # null, meaning that this policy entry is given to all comers, as
      # long as they match the signer field.  The signer could be null,
      # meaning the code is not signed. <p>
      # 
      # The Permission contains the (Type, Name, Action) triplet. <p>
      # 
      # For now, the Policy object retrieves the public key from the
      # X.509 certificate on disk that corresponds to the signedBy
      # alias specified in the Policy config file.  For reasons of
      # efficiency, the Policy object keeps a hashtable of certs already
      # read in.  This could be replaced by a secure internal key
      # store.
      # 
      # <p>
      # For example, the entry
      # <pre>
      # permission java.io.File "/tmp", "read,write",
      # signedBy "Duke";
      # </pre>
      # is represented internally
      # <pre>
      # 
      # FilePermission f = new FilePermission("/tmp", "read,write");
      # PublicKey p = publickeys.get("Duke");
      # URL u = InetAddress.getLocalHost();
      # CodeBase c = new CodeBase( p, u );
      # pe = new PolicyEntry(f, c);
      # </pre>
      # 
      # @author Marianne Mueller
      # @author Roland Schemers
      # @see java.security.CodeSource
      # @see java.security.Policy
      # @see java.security.Permissions
      # @see java.security.ProtectionDomain
      const_set_lazy(:PolicyEntry) { Class.new do
        include_class_members PolicyFile
        
        attr_accessor :codesource
        alias_method :attr_codesource, :codesource
        undef_method :codesource
        alias_method :attr_codesource=, :codesource=
        undef_method :codesource=
        
        attr_accessor :permissions
        alias_method :attr_permissions, :permissions
        undef_method :permissions
        alias_method :attr_permissions=, :permissions=
        undef_method :permissions=
        
        attr_accessor :principals
        alias_method :attr_principals, :principals
        undef_method :principals
        alias_method :attr_principals=, :principals=
        undef_method :principals=
        
        typesig { [CodeSource, JavaList] }
        # 
        # Given a Permission and a CodeSource, create a policy entry.
        # 
        # XXX Decide if/how to add validity fields and "purpose" fields to
        # XXX policy entries
        # 
        # @param cs the CodeSource, which encapsulates the URL and the
        # public key
        # attributes from the policy config file. Validity checks
        # are performed on the public key before PolicyEntry is
        # called.
        def initialize(cs, principals)
          @codesource = nil
          @permissions = nil
          @principals = nil
          @codesource = cs
          @permissions = ArrayList.new
          @principals = principals # can be null
        end
        
        typesig { [CodeSource] }
        def initialize(cs)
          initialize__policy_entry(cs, nil)
        end
        
        typesig { [] }
        def get_principals
          return @principals # can be null
        end
        
        typesig { [Permission] }
        # 
        # add a Permission object to this entry.
        # No need to sync add op because perms are added to entry only
        # while entry is being initialized
        def add(p)
          @permissions.add(p)
        end
        
        typesig { [] }
        # 
        # Return the CodeSource for this policy entry
        def get_code_source
          return @codesource
        end
        
        typesig { [] }
        def to_s
          sb = StringBuilder.new
          sb.append(ResourcesMgr.get_string("("))
          sb.append(get_code_source)
          sb.append("\n")
          j = 0
          while j < @permissions.size
            p = @permissions.get(j)
            sb.append(ResourcesMgr.get_string(" "))
            sb.append(ResourcesMgr.get_string(" "))
            sb.append(p)
            sb.append(ResourcesMgr.get_string("\n"))
            ((j += 1) - 1)
          end
          sb.append(ResourcesMgr.get_string(")"))
          sb.append(ResourcesMgr.get_string("\n"))
          return sb.to_s
        end
        
        private
        alias_method :initialize__policy_entry, :initialize
      end }
      
      const_set_lazy(:SelfPermission) { Class.new(Permission) do
        include_class_members PolicyFile
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -8315562579967246806 }
          const_attr_reader  :SerialVersionUID
        }
        
        # 
        # The class name of the Permission class that will be
        # created when this self permission is expanded .
        # 
        # @serial
        attr_accessor :type
        alias_method :attr_type, :type
        undef_method :type
        alias_method :attr_type=, :type=
        undef_method :type=
        
        # 
        # The permission name.
        # 
        # @serial
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        # 
        # The actions of the permission.
        # 
        # @serial
        attr_accessor :actions
        alias_method :attr_actions, :actions
        undef_method :actions
        alias_method :attr_actions=, :actions=
        undef_method :actions=
        
        # 
        # The certs of the permission.
        # 
        # @serial
        attr_accessor :certs
        alias_method :attr_certs, :certs
        undef_method :certs
        alias_method :attr_certs=, :certs=
        undef_method :certs=
        
        typesig { [String, String, String, Array.typed(Certificate)] }
        # 
        # Creates a new SelfPermission containing the permission
        # information needed later to expand the self
        # @param type the class name of the Permission class that will be
        # created when this permission is expanded and if necessary resolved.
        # @param name the name of the permission.
        # @param actions the actions of the permission.
        # @param certs the certificates the permission's class was signed with.
        # This is a list of certificate chains, where each chain is composed of
        # a signer certificate and optionally its supporting certificate chain.
        # Each chain is ordered bottom-to-top (i.e., with the signer
        # certificate first and the (root) certificate authority last).
        def initialize(type, name, actions, certs)
          @type = nil
          @name = nil
          @actions = nil
          @certs = nil
          super(type)
          if ((type).nil?)
            raise NullPointerException.new(ResourcesMgr.get_string("type can't be null"))
          end
          @type = type
          @name = name
          @actions = actions
          if (!(certs).nil?)
            # Extract the signer certs from the list of certificates.
            i = 0
            while i < certs.attr_length
              if (!(certs[i].is_a?(X509Certificate)))
                # there is no concept of signer certs, so we store the
                # entire cert array
                @certs = certs.clone
                break
              end
              ((i += 1) - 1)
            end
            if ((@certs).nil?)
              # Go through the list of certs and see if all the certs are
              # signer certs.
              i_ = 0
              count = 0
              while (i_ < certs.attr_length)
                ((count += 1) - 1)
                while (((i_ + 1) < certs.attr_length) && ((certs[i_]).get_issuer_dn == (certs[i_ + 1]).get_subject_dn))
                  ((i_ += 1) - 1)
                end
                ((i_ += 1) - 1)
              end
              if ((count).equal?(certs.attr_length))
                # All the certs are signer certs, so we store the
                # entire array
                @certs = certs.clone
              end
              if ((@certs).nil?)
                # extract the signer certs
                signer_certs = ArrayList.new
                i_ = 0
                while (i_ < certs.attr_length)
                  signer_certs.add(certs[i_])
                  while (((i_ + 1) < certs.attr_length) && ((certs[i_]).get_issuer_dn == (certs[i_ + 1]).get_subject_dn))
                    ((i_ += 1) - 1)
                  end
                  ((i_ += 1) - 1)
                end
                @certs = Array.typed(Certificate).new(signer_certs.size) { nil }
                signer_certs.to_array(@certs)
              end
            end
          end
        end
        
        typesig { [Permission] }
        # 
        # This method always returns false for SelfPermission permissions.
        # That is, an SelfPermission never considered to
        # imply another permission.
        # 
        # @param p the permission to check against.
        # 
        # @return false.
        def implies(p)
          return false
        end
        
        typesig { [Object] }
        # 
        # Checks two SelfPermission objects for equality.
        # 
        # Checks that <i>obj</i> is an SelfPermission, and has
        # the same type (class) name, permission name, actions, and
        # certificates as this object.
        # 
        # @param obj the object we are testing for equality with this object.
        # 
        # @return true if obj is an SelfPermission, and has the same
        # type (class) name, permission name, actions, and
        # certificates as this object.
        def equals(obj)
          if ((obj).equal?(self))
            return true
          end
          if (!(obj.is_a?(SelfPermission)))
            return false
          end
          that = obj
          if (!((@type == that.attr_type) && (@name == that.attr_name) && (@actions == that.attr_actions)))
            return false
          end
          if (!(@certs.attr_length).equal?(that.attr_certs.attr_length))
            return false
          end
          i = 0
          j = 0
          match = false
          i = 0
          while i < @certs.attr_length
            match = false
            j = 0
            while j < that.attr_certs.attr_length
              if ((@certs[i] == that.attr_certs[j]))
                match = true
                break
              end
              ((j += 1) - 1)
            end
            if (!match)
              return false
            end
            ((i += 1) - 1)
          end
          i = 0
          while i < that.attr_certs.attr_length
            match = false
            j = 0
            while j < @certs.attr_length
              if ((that.attr_certs[i] == @certs[j]))
                match = true
                break
              end
              ((j += 1) - 1)
            end
            if (!match)
              return false
            end
            ((i += 1) - 1)
          end
          return true
        end
        
        typesig { [] }
        # 
        # Returns the hash code value for this object.
        # 
        # @return a hash code value for this object.
        def hash_code
          hash = @type.hash_code
          if (!(@name).nil?)
            hash ^= @name.hash_code
          end
          if (!(@actions).nil?)
            hash ^= @actions.hash_code
          end
          return hash
        end
        
        typesig { [] }
        # 
        # Returns the canonical string representation of the actions,
        # which currently is the empty string "", since there are no actions
        # for an SelfPermission. That is, the actions for the
        # permission that will be created when this SelfPermission
        # is resolved may be non-null, but an SelfPermission
        # itself is never considered to have any actions.
        # 
        # @return the empty string "".
        def get_actions
          return ""
        end
        
        typesig { [] }
        def get_self_type
          return @type
        end
        
        typesig { [] }
        def get_self_name
          return @name
        end
        
        typesig { [] }
        def get_self_actions
          return @actions
        end
        
        typesig { [] }
        def get_certs
          return @certs
        end
        
        typesig { [] }
        # 
        # Returns a string describing this SelfPermission.  The convention
        # is to specify the class name, the permission name, and the actions,
        # in the following format: '(unresolved "ClassName" "name" "actions")'.
        # 
        # @return information about this SelfPermission.
        def to_s
          return "(SelfPermission " + @type + " " + @name + " " + @actions + ")"
        end
        
        private
        alias_method :initialize__self_permission, :initialize
      end }
      
      # 
      # holds policy information that we need to synch on
      const_set_lazy(:PolicyInfo) { Class.new do
        include_class_members PolicyFile
        
        class_module.module_eval {
          const_set_lazy(:Verbose) { false }
          const_attr_reader  :Verbose
        }
        
        # Stores grant entries in the policy
        attr_accessor :policy_entries
        alias_method :attr_policy_entries, :policy_entries
        undef_method :policy_entries
        alias_method :attr_policy_entries=, :policy_entries=
        undef_method :policy_entries=
        
        # Stores grant entries gotten from identity database
        # Use separate lists to avoid sync on policyEntries
        attr_accessor :identity_policy_entries
        alias_method :attr_identity_policy_entries, :identity_policy_entries
        undef_method :identity_policy_entries
        alias_method :attr_identity_policy_entries=, :identity_policy_entries=
        undef_method :identity_policy_entries=
        
        # Maps aliases to certs
        attr_accessor :alias_mapping
        alias_method :attr_alias_mapping, :alias_mapping
        undef_method :alias_mapping
        alias_method :attr_alias_mapping=, :alias_mapping=
        undef_method :alias_mapping=
        
        # Maps ProtectionDomain to PermissionCollection
        attr_accessor :pd_mapping
        alias_method :attr_pd_mapping, :pd_mapping
        undef_method :pd_mapping
        alias_method :attr_pd_mapping=, :pd_mapping=
        undef_method :pd_mapping=
        
        attr_accessor :random
        alias_method :attr_random, :random
        undef_method :random
        alias_method :attr_random=, :random=
        undef_method :random=
        
        typesig { [::Java::Int] }
        def initialize(num_caches)
          @policy_entries = nil
          @identity_policy_entries = nil
          @alias_mapping = nil
          @pd_mapping = nil
          @random = nil
          @policy_entries = ArrayList.new
          @identity_policy_entries = Collections.synchronized_list(ArrayList.new(2))
          @alias_mapping = Collections.synchronized_map(HashMap.new(11))
          @pd_mapping = Array.typed(Map).new(num_caches) { nil }
          i = 0
          while i < num_caches
            @pd_mapping[i] = Collections.synchronized_map(WeakHashMap.new)
            ((i += 1) - 1)
          end
          if (num_caches > 1)
            @random = Java::Util::Random.new
          end
        end
        
        typesig { [] }
        def get_pd_mapping
          if ((@pd_mapping.attr_length).equal?(1))
            return @pd_mapping[0]
          else
            i = Java::Lang::Math.abs(@random.next_int % @pd_mapping.attr_length)
            return @pd_mapping[i]
          end
        end
        
        private
        alias_method :initialize__policy_info, :initialize
      end }
    }
    
    private
    alias_method :initialize__policy_file, :initialize
  end
  
end
