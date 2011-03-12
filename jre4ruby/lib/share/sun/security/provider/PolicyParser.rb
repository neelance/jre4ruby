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
module Sun::Security::Provider
  module PolicyParserImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Io
      include_const ::Java::Lang, :RuntimePermission
      include_const ::Java::Net, :SocketPermission
      include_const ::Java::Net, :URL
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Hashtable
      include_const ::Java::Util, :LinkedList
      include_const ::Java::Util, :ListIterator
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Text, :MessageFormat
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include_const ::Java::Security, :GeneralSecurityException
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :PropertyExpander
      include_const ::Sun::Security::Util, :ResourcesMgr
    }
  end
  
  # The policy for a Java runtime (specifying
  # which permissions are available for code from various principals)
  # is represented as a separate
  # persistent configuration.  The configuration may be stored as a
  # flat ASCII file, as a serialized binary file of
  # the Policy class, or as a database. <p>
  # 
  # <p>The Java runtime creates one global Policy object, which is used to
  # represent the static policy configuration file.  It is consulted by
  # a ProtectionDomain when the protection domain initializes its set of
  # permissions. <p>
  # 
  # <p>The Policy <code>init</code> method parses the policy
  # configuration file, and then
  # populates the Policy object.  The Policy object is agnostic in that
  # it is not involved in making policy decisions.  It is merely the
  # Java runtime representation of the persistent policy configuration
  # file. <p>
  # 
  # <p>When a protection domain needs to initialize its set of
  # permissions, it executes code such as the following
  # to ask the global Policy object to populate a
  # Permissions object with the appropriate permissions:
  # <pre>
  #  policy = Policy.getPolicy();
  #  Permissions perms = policy.getPermissions(protectiondomain)
  # </pre>
  # 
  # <p>The protection domain contains CodeSource
  # object, which encapsulates its codebase (URL) and public key attributes.
  # It also contains the principals associated with the domain.
  # The Policy object evaluates the global policy in light of who the
  # principal is and what the code source is and returns an appropriate
  # Permissions object.
  # 
  # @author Roland Schemers
  # @author Ram Marti
  # 
  # @since 1.2
  class PolicyParser 
    include_class_members PolicyParserImports
    
    class_module.module_eval {
      # needs to be public for PolicyTool
      const_set_lazy(:REPLACE_NAME) { "PolicyParser.REPLACE_NAME" }
      const_attr_reader  :REPLACE_NAME
      
      const_set_lazy(:EXTDIRS_PROPERTY) { "java.ext.dirs" }
      const_attr_reader  :EXTDIRS_PROPERTY
      
      const_set_lazy(:OLD_EXTDIRS_EXPANSION) { "${" + EXTDIRS_PROPERTY + "}" }
      const_attr_reader  :OLD_EXTDIRS_EXPANSION
      
      # package-private: used by PolicyFile for static policy
      const_set_lazy(:EXTDIRS_EXPANSION) { "${{" + EXTDIRS_PROPERTY + "}}" }
      const_attr_reader  :EXTDIRS_EXPANSION
    }
    
    attr_accessor :grant_entries
    alias_method :attr_grant_entries, :grant_entries
    undef_method :grant_entries
    alias_method :attr_grant_entries=, :grant_entries=
    undef_method :grant_entries=
    
    class_module.module_eval {
      # Convenience variables for parsing
      const_set_lazy(:Debug) { Debug.get_instance("parser", "\t[Policy Parser]") }
      const_attr_reader  :Debug
    }
    
    attr_accessor :st
    alias_method :attr_st, :st
    undef_method :st
    alias_method :attr_st=, :st=
    undef_method :st=
    
    attr_accessor :lookahead
    alias_method :attr_lookahead, :lookahead
    undef_method :lookahead
    alias_method :attr_lookahead=, :lookahead=
    undef_method :lookahead=
    
    attr_accessor :expand_prop
    alias_method :attr_expand_prop, :expand_prop
    undef_method :expand_prop
    alias_method :attr_expand_prop=, :expand_prop=
    undef_method :expand_prop=
    
    attr_accessor :key_store_url_string
    alias_method :attr_key_store_url_string, :key_store_url_string
    undef_method :key_store_url_string
    alias_method :attr_key_store_url_string=, :key_store_url_string=
    undef_method :key_store_url_string=
    
    # unexpanded
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
    
    attr_accessor :store_pass_url
    alias_method :attr_store_pass_url, :store_pass_url
    undef_method :store_pass_url
    alias_method :attr_store_pass_url=, :store_pass_url=
    undef_method :store_pass_url=
    
    typesig { [String] }
    def expand(value)
      return expand(value, false)
    end
    
    typesig { [String, ::Java::Boolean] }
    def expand(value, encode_url)
      if (!@expand_prop)
        return value
      else
        return PropertyExpander.expand(value, encode_url)
      end
    end
    
    typesig { [] }
    # Creates a PolicyParser object.
    def initialize
      @grant_entries = nil
      @st = nil
      @lookahead = 0
      @expand_prop = false
      @key_store_url_string = nil
      @key_store_type = nil
      @key_store_provider = nil
      @store_pass_url = nil
      @grant_entries = Vector.new
    end
    
    typesig { [::Java::Boolean] }
    def initialize(expand_prop)
      initialize__policy_parser()
      @expand_prop = expand_prop
    end
    
    typesig { [Reader] }
    # Reads a policy configuration into the Policy object using a
    # Reader object. <p>
    # 
    # @param policy the policy Reader object.
    # 
    # @exception ParsingException if the policy configuration contains
    #          a syntax error.
    # 
    # @exception IOException if an error occurs while reading the policy
    #          configuration.
    def read(policy)
      if (!(policy.is_a?(BufferedReader)))
        policy = BufferedReader.new(policy)
      end
      # Configure the stream tokenizer:
      #      Recognize strings between "..."
      #      Don't convert words to lowercase
      #      Recognize both C-style and C++-style comments
      #      Treat end-of-line as white space, not as a token
      @st = StreamTokenizer.new(policy)
      @st.reset_syntax
      @st.word_chars(Character.new(?a.ord), Character.new(?z.ord))
      @st.word_chars(Character.new(?A.ord), Character.new(?Z.ord))
      @st.word_chars(Character.new(?..ord), Character.new(?..ord))
      @st.word_chars(Character.new(?0.ord), Character.new(?9.ord))
      @st.word_chars(Character.new(?_.ord), Character.new(?_.ord))
      @st.word_chars(Character.new(?$.ord), Character.new(?$.ord))
      @st.word_chars(128 + 32, 255)
      @st.whitespace_chars(0, Character.new(?\s.ord))
      @st.comment_char(Character.new(?/.ord))
      @st.quote_char(Character.new(?\'.ord))
      @st.quote_char(Character.new(?".ord))
      @st.lower_case_mode(false)
      @st.ordinary_char(Character.new(?/.ord))
      @st.slash_slash_comments(true)
      @st.slash_star_comments(true)
      # The main parsing loop.  The loop is executed once
      # for each entry in the config file.      The entries
      # are delimited by semicolons.   Once we've read in
      # the information for an entry, go ahead and try to
      # add it to the policy vector.
      @lookahead = @st.next_token
      while (!(@lookahead).equal?(StreamTokenizer::TT_EOF))
        if (peek("grant"))
          ge = parse_grant_entry
          # could be null if we couldn't expand a property
          if (!(ge).nil?)
            add(ge)
          end
        else
          if (peek("keystore") && (@key_store_url_string).nil?)
            # only one keystore entry per policy file, others will be
            # ignored
            parse_key_store_entry
          else
            if (peek("keystorePasswordURL") && (@store_pass_url).nil?)
              # only one keystore passwordURL per policy file, others will be
              # ignored
              parse_store_pass_url
            else
              # error?
            end
          end
        end
        match(";")
      end
      if ((@key_store_url_string).nil? && !(@store_pass_url).nil?)
        raise ParsingException.new(ResourcesMgr.get_string("keystorePasswordURL can not be specified without also " + "specifying keystore"))
      end
    end
    
    typesig { [GrantEntry] }
    def add(ge)
      @grant_entries.add_element(ge)
    end
    
    typesig { [GrantEntry, GrantEntry] }
    def replace(orig_ge, new_ge)
      @grant_entries.set_element_at(new_ge, @grant_entries.index_of(orig_ge))
    end
    
    typesig { [GrantEntry] }
    def remove(ge)
      return @grant_entries.remove_element(ge)
    end
    
    typesig { [] }
    # Returns the (possibly expanded) keystore location, or null if the
    # expansion fails.
    def get_key_store_url
      begin
        if (!(@key_store_url_string).nil? && !(@key_store_url_string.length).equal?(0))
          return expand(@key_store_url_string, true).replace(JavaFile.attr_separator_char, Character.new(?/.ord))
        end
      rescue PropertyExpander::ExpandException => peee
        if (!(Debug).nil?)
          Debug.println(peee.to_s)
        end
        return nil
      end
      return nil
    end
    
    typesig { [String] }
    def set_key_store_url(url)
      @key_store_url_string = url
    end
    
    typesig { [] }
    def get_key_store_type
      return @key_store_type
    end
    
    typesig { [String] }
    def set_key_store_type(type)
      @key_store_type = type
    end
    
    typesig { [] }
    def get_key_store_provider
      return @key_store_provider
    end
    
    typesig { [String] }
    def set_key_store_provider(provider)
      @key_store_provider = provider
    end
    
    typesig { [] }
    def get_store_pass_url
      begin
        if (!(@store_pass_url).nil? && !(@store_pass_url.length).equal?(0))
          return expand(@store_pass_url, true).replace(JavaFile.attr_separator_char, Character.new(?/.ord))
        end
      rescue PropertyExpander::ExpandException => peee
        if (!(Debug).nil?)
          Debug.println(peee.to_s)
        end
        return nil
      end
      return nil
    end
    
    typesig { [String] }
    def set_store_pass_url(store_pass_url)
      @store_pass_url = store_pass_url
    end
    
    typesig { [] }
    # Enumerate all the entries in the global policy object.
    # This method is used by policy admin tools.   The tools
    # should use the Enumeration methods on the returned object
    # to fetch the elements sequentially.
    def grant_elements
      return @grant_entries.elements
    end
    
    typesig { [Writer] }
    # write out the policy
    def write(policy)
      out = PrintWriter.new(BufferedWriter.new(policy))
      enum_ = grant_elements
      out.println("/* AUTOMATICALLY GENERATED ON " + RJava.cast_to_string((Java::Util::JavaDate.new)) + "*/")
      out.println("/* DO NOT EDIT */")
      out.println
      # write the (unexpanded) keystore entry as the first entry of the
      # policy file
      if (!(@key_store_url_string).nil?)
        write_key_store_entry(out)
      end
      if (!(@store_pass_url).nil?)
        write_store_pass_url(out)
      end
      # write "grant" entries
      while (enum_.has_more_elements)
        ge = enum_.next_element
        ge.write(out)
        out.println
      end
      out.flush
    end
    
    typesig { [] }
    # parses a keystore entry
    def parse_key_store_entry
      match("keystore")
      @key_store_url_string = RJava.cast_to_string(match("quoted string"))
      # parse keystore type
      if (!peek(","))
        return # default type
      end
      match(",")
      if (peek("\""))
        @key_store_type = RJava.cast_to_string(match("quoted string"))
      else
        raise ParsingException.new(@st.lineno, ResourcesMgr.get_string("expected keystore type"))
      end
      # parse keystore provider
      if (!peek(","))
        return # provider optional
      end
      match(",")
      if (peek("\""))
        @key_store_provider = RJava.cast_to_string(match("quoted string"))
      else
        raise ParsingException.new(@st.lineno, ResourcesMgr.get_string("expected keystore provider"))
      end
    end
    
    typesig { [] }
    def parse_store_pass_url
      match("keyStorePasswordURL")
      @store_pass_url = RJava.cast_to_string(match("quoted string"))
    end
    
    typesig { [PrintWriter] }
    # writes the (unexpanded) keystore entry
    def write_key_store_entry(out)
      out.print("keystore \"")
      out.print(@key_store_url_string)
      out.print(Character.new(?".ord))
      if (!(@key_store_type).nil? && @key_store_type.length > 0)
        out.print(", \"" + @key_store_type + "\"")
      end
      if (!(@key_store_provider).nil? && @key_store_provider.length > 0)
        out.print(", \"" + @key_store_provider + "\"")
      end
      out.println(";")
      out.println
    end
    
    typesig { [PrintWriter] }
    def write_store_pass_url(out)
      out.print("keystorePasswordURL \"")
      out.print(@store_pass_url)
      out.print(Character.new(?".ord))
      out.println(";")
      out.println
    end
    
    typesig { [] }
    # parse a Grant entry
    def parse_grant_entry
      e = GrantEntry.new
      principals = nil
      ignore_entry = false
      match("grant")
      while (!peek("{"))
        if (peek_and_match("Codebase"))
          if (!(e.attr_code_base).nil?)
            raise ParsingException.new(@st.lineno, ResourcesMgr.get_string("multiple Codebase expressions"))
          end
          e.attr_code_base = match("quoted string")
          peek_and_match(",")
        else
          if (peek_and_match("SignedBy"))
            if (!(e.attr_signed_by).nil?)
              raise ParsingException.new(@st.lineno, ResourcesMgr.get_string("multiple SignedBy expressions"))
            end
            e.attr_signed_by = match("quoted string")
            # verify syntax of the aliases
            aliases = StringTokenizer.new(e.attr_signed_by, ",", true)
            actr = 0
            cctr = 0
            while (aliases.has_more_tokens)
              alias_ = aliases.next_token.trim
              if ((alias_ == ","))
                cctr += 1
              else
                if (alias_.length > 0)
                  actr += 1
                end
              end
            end
            if (actr <= cctr)
              raise ParsingException.new(@st.lineno, ResourcesMgr.get_string("SignedBy has empty alias"))
            end
            peek_and_match(",")
          else
            if (peek_and_match("Principal"))
              if ((principals).nil?)
                principals = LinkedList.new
              end
              principal_class = nil
              principal_name = nil
              if (peek("\""))
                # both the principalClass and principalName
                # will be replaced later
                principal_class = REPLACE_NAME
                principal_name = RJava.cast_to_string(match("principal type"))
              else
                # check for principalClass wildcard
                if (peek("*"))
                  match("*")
                  principal_class = RJava.cast_to_string(PrincipalEntry::WILDCARD_CLASS)
                else
                  principal_class = RJava.cast_to_string(match("principal type"))
                end
                # check for principalName wildcard
                if (peek("*"))
                  match("*")
                  principal_name = RJava.cast_to_string(PrincipalEntry::WILDCARD_NAME)
                else
                  principal_name = RJava.cast_to_string(match("quoted string"))
                end
                # disallow WILDCARD_CLASS && actual name
                if ((principal_class == PrincipalEntry::WILDCARD_CLASS) && !(principal_name == PrincipalEntry::WILDCARD_NAME))
                  if (!(Debug).nil?)
                    Debug.println("disallowing principal that " + "has WILDCARD class but no WILDCARD name")
                  end
                  raise ParsingException.new(@st.lineno, ResourcesMgr.get_string("can not specify Principal with a " + "wildcard class without a wildcard name"))
                end
              end
              begin
                principal_name = RJava.cast_to_string(expand(principal_name))
                if ((principal_class == "javax.security.auth.x500.X500Principal") && !(principal_name == PrincipalEntry::WILDCARD_NAME))
                  # 4702543:  X500 names with an EmailAddress
                  # were encoded incorrectly.  construct a new
                  # X500Principal with correct encoding.
                  p = X500Principal.new((X500Principal.new(principal_name)).to_s)
                  principal_name = RJava.cast_to_string(p.get_name)
                end
                principals.add(PrincipalEntry.new(principal_class, principal_name))
              rescue PropertyExpander::ExpandException => peee
                # ignore the entire policy entry
                # but continue parsing all the info
                # so we can get to the next entry
                if (!(Debug).nil?)
                  Debug.println("principal name expansion failed: " + principal_name)
                end
                ignore_entry = true
              end
              peek_and_match(",")
            else
              raise ParsingException.new(@st.lineno, ResourcesMgr.get_string("expected codeBase or SignedBy or " + "Principal"))
            end
          end
        end
      end
      if (!(principals).nil?)
        e.attr_principals = principals
      end
      match("{")
      while (!peek("}"))
        if (peek("Permission"))
          begin
            pe = parse_permission_entry
            e.add(pe)
          rescue PropertyExpander::ExpandException => peee
            # ignore. The add never happened
            if (!(Debug).nil?)
              Debug.println(peee.to_s)
            end
            skip_entry # BugId 4219343
          end
          match(";")
        else
          raise ParsingException.new(@st.lineno, ResourcesMgr.get_string("expected permission entry"))
        end
      end
      match("}")
      begin
        if (!(e.attr_signed_by).nil?)
          e.attr_signed_by = expand(e.attr_signed_by)
        end
        if (!(e.attr_code_base).nil?)
          # For backward compatibility with 1.4
          if ((e.attr_code_base == OLD_EXTDIRS_EXPANSION))
            e.attr_code_base = EXTDIRS_EXPANSION
          end
          es = 0
          if ((es = e.attr_code_base.index_of(EXTDIRS_EXPANSION)) < 0)
            e.attr_code_base = expand(e.attr_code_base, true).replace(JavaFile.attr_separator_char, Character.new(?/.ord))
          else
            # expand the system property "java.ext.dirs",
            # parse it into its path components,
            # and then create a grant entry for each component
            ext_dirs = parse_ext_dirs(e.attr_code_base, es)
            if (!(ext_dirs).nil? && ext_dirs.attr_length > 0)
              i = 0
              while i < ext_dirs.attr_length
                new_ge = e.clone
                new_ge.attr_code_base = ext_dirs[i]
                add(new_ge)
                if (!(Debug).nil?)
                  Debug.println("creating policy entry for " + "expanded java.ext.dirs path:\n\t\t" + RJava.cast_to_string(ext_dirs[i]))
                end
                i += 1
              end
            end
            ignore_entry = true
          end
        end
      rescue PropertyExpander::ExpandException => peee
        if (!(Debug).nil?)
          Debug.println(peee.to_s)
        end
        return nil
      end
      return ((ignore_entry).equal?(true)) ? nil : e
    end
    
    typesig { [] }
    # parse a Permission entry
    def parse_permission_entry
      e = PermissionEntry.new
      # Permission
      match("Permission")
      e.attr_permission = match("permission type")
      if (peek("\""))
        # Permission name
        e.attr_name = expand(match("quoted string"))
      end
      if (!peek(","))
        return e
      end
      match(",")
      if (peek("\""))
        e.attr_action = expand(match("quoted string"))
        if (!peek(","))
          return e
        end
        match(",")
      end
      if (peek_and_match("SignedBy"))
        e.attr_signed_by = expand(match("quoted string"))
      end
      return e
    end
    
    class_module.module_eval {
      typesig { [String, ::Java::Int] }
      # package-private: used by PolicyFile for static policy
      def parse_ext_dirs(codebase, start)
        s = System.get_property(EXTDIRS_PROPERTY)
        global_prefix = (start > 0 ? codebase.substring(0, start) : "file:")
        end_ = start + EXTDIRS_EXPANSION.length
        global_suffix = (end_ < codebase.length ? codebase.substring(end_) : nil)
        dirs = nil
        local_suffix = nil
        if (!(s).nil?)
          st = StringTokenizer.new(s, JavaFile.attr_path_separator)
          count = st.count_tokens
          dirs = Array.typed(String).new(count) { nil }
          i = 0
          while i < count
            file = JavaFile.new(st.next_token)
            dirs[i] = Sun::Net::Www::ParseUtil.encode_path(file.get_absolute_path)
            if (!dirs[i].starts_with("/"))
              dirs[i] = "/" + RJava.cast_to_string(dirs[i])
            end
            local_suffix = RJava.cast_to_string(((global_suffix).nil? ? (dirs[i].ends_with("/") ? "*" : "/*") : global_suffix))
            dirs[i] = global_prefix + RJava.cast_to_string(dirs[i]) + local_suffix
            i += 1
          end
        end
        return dirs
      end
    }
    
    typesig { [String] }
    def peek_and_match(expect)
      if (peek(expect))
        match(expect)
        return true
      else
        return false
      end
    end
    
    typesig { [String] }
    def peek(expect)
      found = false
      case (@lookahead)
      when StreamTokenizer::TT_WORD
        if (expect.equals_ignore_case(@st.attr_sval))
          found = true
        end
      when Character.new(?,.ord)
        if (expect.equals_ignore_case(","))
          found = true
        end
      when Character.new(?{.ord)
        if (expect.equals_ignore_case("{"))
          found = true
        end
      when Character.new(?}.ord)
        if (expect.equals_ignore_case("}"))
          found = true
        end
      when Character.new(?".ord)
        if (expect.equals_ignore_case("\""))
          found = true
        end
      when Character.new(?*.ord)
        if (expect.equals_ignore_case("*"))
          found = true
        end
      else
      end
      return found
    end
    
    typesig { [String] }
    def match(expect)
      value = nil
      case (@lookahead)
      when StreamTokenizer::TT_NUMBER
        raise ParsingException.new(@st.lineno, expect, ResourcesMgr.get_string("number ") + String.value_of(@st.attr_nval))
      when StreamTokenizer::TT_EOF
        form = MessageFormat.new(ResourcesMgr.get_string("expected [expect], read [end of file]"))
        source = Array.typed(Object).new([expect])
        raise ParsingException.new(form.format(source))
      when StreamTokenizer::TT_WORD
        if (expect.equals_ignore_case(@st.attr_sval))
          @lookahead = @st.next_token
        else
          if (expect.equals_ignore_case("permission type"))
            value = RJava.cast_to_string(@st.attr_sval)
            @lookahead = @st.next_token
          else
            if (expect.equals_ignore_case("principal type"))
              value = RJava.cast_to_string(@st.attr_sval)
              @lookahead = @st.next_token
            else
              raise ParsingException.new(@st.lineno, expect, @st.attr_sval)
            end
          end
        end
      when Character.new(?".ord)
        if (expect.equals_ignore_case("quoted string"))
          value = RJava.cast_to_string(@st.attr_sval)
          @lookahead = @st.next_token
        else
          if (expect.equals_ignore_case("permission type"))
            value = RJava.cast_to_string(@st.attr_sval)
            @lookahead = @st.next_token
          else
            if (expect.equals_ignore_case("principal type"))
              value = RJava.cast_to_string(@st.attr_sval)
              @lookahead = @st.next_token
            else
              raise ParsingException.new(@st.lineno, expect, @st.attr_sval)
            end
          end
        end
      when Character.new(?,.ord)
        if (expect.equals_ignore_case(","))
          @lookahead = @st.next_token
        else
          raise ParsingException.new(@st.lineno, expect, ",")
        end
      when Character.new(?{.ord)
        if (expect.equals_ignore_case("{"))
          @lookahead = @st.next_token
        else
          raise ParsingException.new(@st.lineno, expect, "{")
        end
      when Character.new(?}.ord)
        if (expect.equals_ignore_case("}"))
          @lookahead = @st.next_token
        else
          raise ParsingException.new(@st.lineno, expect, "}")
        end
      when Character.new(?;.ord)
        if (expect.equals_ignore_case(";"))
          @lookahead = @st.next_token
        else
          raise ParsingException.new(@st.lineno, expect, ";")
        end
      when Character.new(?*.ord)
        if (expect.equals_ignore_case("*"))
          @lookahead = @st.next_token
        else
          raise ParsingException.new(@st.lineno, expect, "*")
        end
      else
        raise ParsingException.new(@st.lineno, expect, String.new(Array.typed(::Java::Char).new([RJava.cast_to_char(@lookahead)])))
      end
      return value
    end
    
    typesig { [] }
    # skip all tokens for this entry leaving the delimiter ";"
    # in the stream.
    def skip_entry
      while (!(@lookahead).equal?(Character.new(?;.ord)))
        case (@lookahead)
        when StreamTokenizer::TT_NUMBER
          raise ParsingException.new(@st.lineno, ";", ResourcesMgr.get_string("number ") + String.value_of(@st.attr_nval))
        when StreamTokenizer::TT_EOF
          raise ParsingException.new(ResourcesMgr.get_string("expected [;], read [end of file]"))
        else
          @lookahead = @st.next_token
        end
      end
    end
    
    class_module.module_eval {
      # Each grant entry in the policy configuration file is
      # represented by a
      # GrantEntry object.  <p>
      # 
      # <p>
      # For example, the entry
      # <pre>
      #      grant signedBy "Duke" {
      #          permission java.io.FilePermission "/tmp", "read,write";
      #      };
      # 
      # </pre>
      # is represented internally
      # <pre>
      # 
      # pe = new PermissionEntry("java.io.FilePermission",
      #                           "/tmp", "read,write");
      # 
      # ge = new GrantEntry("Duke", null);
      # 
      # ge.add(pe);
      # 
      # </pre>
      # 
      # @author Roland Schemers
      # 
      # version 1.19, 05/21/98
      const_set_lazy(:GrantEntry) { Class.new do
        include_class_members PolicyParser
        
        attr_accessor :signed_by
        alias_method :attr_signed_by, :signed_by
        undef_method :signed_by
        alias_method :attr_signed_by=, :signed_by=
        undef_method :signed_by=
        
        attr_accessor :code_base
        alias_method :attr_code_base, :code_base
        undef_method :code_base
        alias_method :attr_code_base=, :code_base=
        undef_method :code_base=
        
        attr_accessor :principals
        alias_method :attr_principals, :principals
        undef_method :principals
        alias_method :attr_principals=, :principals=
        undef_method :principals=
        
        attr_accessor :permission_entries
        alias_method :attr_permission_entries, :permission_entries
        undef_method :permission_entries
        alias_method :attr_permission_entries=, :permission_entries=
        undef_method :permission_entries=
        
        typesig { [] }
        def initialize
          @signed_by = nil
          @code_base = nil
          @principals = nil
          @permission_entries = nil
          @principals = self.class::LinkedList.new
          @permission_entries = self.class::Vector.new
        end
        
        typesig { [String, String] }
        def initialize(signed_by, code_base)
          @signed_by = nil
          @code_base = nil
          @principals = nil
          @permission_entries = nil
          @code_base = code_base
          @signed_by = signed_by
          @principals = self.class::LinkedList.new
          @permission_entries = self.class::Vector.new
        end
        
        typesig { [class_self::PermissionEntry] }
        def add(pe)
          @permission_entries.add_element(pe)
        end
        
        typesig { [class_self::PrincipalEntry] }
        def remove(pe)
          return @principals.remove(pe)
        end
        
        typesig { [class_self::PermissionEntry] }
        def remove(pe)
          return @permission_entries.remove_element(pe)
        end
        
        typesig { [class_self::PrincipalEntry] }
        def contains(pe)
          return @principals.contains(pe)
        end
        
        typesig { [class_self::PermissionEntry] }
        def contains(pe)
          return @permission_entries.contains(pe)
        end
        
        typesig { [] }
        # Enumerate all the permission entries in this GrantEntry.
        def permission_elements
          return @permission_entries.elements
        end
        
        typesig { [class_self::PrintWriter] }
        def write(out)
          out.print("grant")
          if (!(@signed_by).nil?)
            out.print(" signedBy \"")
            out.print(@signed_by)
            out.print(Character.new(?".ord))
            if (!(@code_base).nil?)
              out.print(", ")
            end
          end
          if (!(@code_base).nil?)
            out.print(" codeBase \"")
            out.print(@code_base)
            out.print(Character.new(?".ord))
            if (!(@principals).nil? && @principals.size > 0)
              out.print(",\n")
            end
          end
          if (!(@principals).nil? && @principals.size > 0)
            pli = @principals.list_iterator
            while (pli.has_next)
              out.print("      ")
              pe = pli.next_
              pe.write(out)
              if (pli.has_next)
                out.print(",\n")
              end
            end
          end
          out.println(" {")
          enum_ = @permission_entries.elements
          while (enum_.has_more_elements)
            pe = enum_.next_element
            out.write("  ")
            pe.write(out)
          end
          out.println("};")
        end
        
        typesig { [] }
        def clone
          ge = self.class::GrantEntry.new
          ge.attr_code_base = @code_base
          ge.attr_signed_by = @signed_by
          ge.attr_principals = self.class::LinkedList.new(@principals)
          ge.attr_permission_entries = self.class::Vector.new(@permission_entries)
          return ge
        end
        
        private
        alias_method :initialize__grant_entry, :initialize
      end }
      
      # Principal info (class and name) in a grant entry
      const_set_lazy(:PrincipalEntry) { Class.new do
        include_class_members PolicyParser
        
        class_module.module_eval {
          const_set_lazy(:WILDCARD_CLASS) { "WILDCARD_PRINCIPAL_CLASS" }
          const_attr_reader  :WILDCARD_CLASS
          
          const_set_lazy(:WILDCARD_NAME) { "WILDCARD_PRINCIPAL_NAME" }
          const_attr_reader  :WILDCARD_NAME
        }
        
        attr_accessor :principal_class
        alias_method :attr_principal_class, :principal_class
        undef_method :principal_class
        alias_method :attr_principal_class=, :principal_class=
        undef_method :principal_class=
        
        attr_accessor :principal_name
        alias_method :attr_principal_name, :principal_name
        undef_method :principal_name
        alias_method :attr_principal_name=, :principal_name=
        undef_method :principal_name=
        
        typesig { [String, String] }
        # A PrincipalEntry consists of the <code>Principal</code>
        # class and <code>Principal</code> name.
        # 
        # <p>
        # 
        # @param principalClass the <code>Principal</code> class. <p>
        # 
        # @param principalName the <code>Principal</code> name. <p>
        def initialize(principal_class, principal_name)
          @principal_class = nil
          @principal_name = nil
          if ((principal_class).nil? || (principal_name).nil?)
            raise self.class::NullPointerException.new(ResourcesMgr.get_string("null principalClass or principalName"))
          end
          @principal_class = principal_class
          @principal_name = principal_name
        end
        
        typesig { [] }
        def get_principal_class
          return @principal_class
        end
        
        typesig { [] }
        def get_principal_name
          return @principal_name
        end
        
        typesig { [] }
        def get_display_class
          if ((@principal_class == self.class::WILDCARD_CLASS))
            return "*"
          else
            if ((@principal_class == REPLACE_NAME))
              return ""
            else
              return @principal_class
            end
          end
        end
        
        typesig { [] }
        def get_display_name
          return get_display_name(false)
        end
        
        typesig { [::Java::Boolean] }
        def get_display_name(add_quote)
          if ((@principal_name == self.class::WILDCARD_NAME))
            return "*"
          else
            if (add_quote)
              return "\"" + @principal_name + "\""
            else
              return @principal_name
            end
          end
        end
        
        typesig { [] }
        def to_s
          if (!(@principal_class == REPLACE_NAME))
            return RJava.cast_to_string(get_display_class) + "/" + RJava.cast_to_string(get_display_name)
          else
            return get_display_name
          end
        end
        
        typesig { [Object] }
        # Test for equality between the specified object and this object.
        # Two PrincipalEntries are equal if their PrincipalClass and
        # PrincipalName values are equal.
        # 
        # <p>
        # 
        # @param obj the object to test for equality with this object.
        # 
        # @return true if the objects are equal, false otherwise.
        def ==(obj)
          if ((self).equal?(obj))
            return true
          end
          if (!(obj.is_a?(self.class::PrincipalEntry)))
            return false
          end
          that = obj
          if ((@principal_class == that.attr_principal_class) && (@principal_name == that.attr_principal_name))
            return true
          end
          return false
        end
        
        typesig { [] }
        # Return a hashcode for this <code>PrincipalEntry</code>.
        # 
        # <p>
        # 
        # @return a hashcode for this <code>PrincipalEntry</code>.
        def hash_code
          return @principal_class.hash_code
        end
        
        typesig { [class_self::PrintWriter] }
        def write(out)
          out.print("principal " + RJava.cast_to_string(get_display_class) + " " + RJava.cast_to_string(get_display_name(true)))
        end
        
        private
        alias_method :initialize__principal_entry, :initialize
      end }
      
      # Each permission entry in the policy configuration file is
      # represented by a
      # PermissionEntry object.  <p>
      # 
      # <p>
      # For example, the entry
      # <pre>
      #          permission java.io.FilePermission "/tmp", "read,write";
      # </pre>
      # is represented internally
      # <pre>
      # 
      # pe = new PermissionEntry("java.io.FilePermission",
      #                           "/tmp", "read,write");
      # </pre>
      # 
      # @author Roland Schemers
      # 
      # version 1.19, 05/21/98
      const_set_lazy(:PermissionEntry) { Class.new do
        include_class_members PolicyParser
        
        attr_accessor :permission
        alias_method :attr_permission, :permission
        undef_method :permission
        alias_method :attr_permission=, :permission=
        undef_method :permission=
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :action
        alias_method :attr_action, :action
        undef_method :action
        alias_method :attr_action=, :action=
        undef_method :action=
        
        attr_accessor :signed_by
        alias_method :attr_signed_by, :signed_by
        undef_method :signed_by
        alias_method :attr_signed_by=, :signed_by=
        undef_method :signed_by=
        
        typesig { [] }
        def initialize
          @permission = nil
          @name = nil
          @action = nil
          @signed_by = nil
        end
        
        typesig { [String, String, String] }
        def initialize(permission, name, action)
          @permission = nil
          @name = nil
          @action = nil
          @signed_by = nil
          @permission = permission
          @name = name
          @action = action
        end
        
        typesig { [] }
        # Calculates a hash code value for the object.  Objects
        # which are equal will also have the same hashcode.
        def hash_code
          retval = @permission.hash_code
          if (!(@name).nil?)
            retval ^= @name.hash_code
          end
          if (!(@action).nil?)
            retval ^= @action.hash_code
          end
          return retval
        end
        
        typesig { [Object] }
        def ==(obj)
          if ((obj).equal?(self))
            return true
          end
          if (!(obj.is_a?(self.class::PermissionEntry)))
            return false
          end
          that = obj
          if ((@permission).nil?)
            if (!(that.attr_permission).nil?)
              return false
            end
          else
            if (!(@permission == that.attr_permission))
              return false
            end
          end
          if ((@name).nil?)
            if (!(that.attr_name).nil?)
              return false
            end
          else
            if (!(@name == that.attr_name))
              return false
            end
          end
          if ((@action).nil?)
            if (!(that.attr_action).nil?)
              return false
            end
          else
            if (!(@action == that.attr_action))
              return false
            end
          end
          if ((@signed_by).nil?)
            if (!(that.attr_signed_by).nil?)
              return false
            end
          else
            if (!(@signed_by == that.attr_signed_by))
              return false
            end
          end
          # everything matched -- the 2 objects are equal
          return true
        end
        
        typesig { [class_self::PrintWriter] }
        def write(out)
          out.print("permission ")
          out.print(@permission)
          if (!(@name).nil?)
            out.print(" \"")
            # ATTENTION: regex with double escaping,
            # the normal forms look like:
            # $name =~ s/\\/\\\\/g; and
            # $name =~ s/\"/\\\"/g;
            # and then in a java string, it's escaped again
            out.print(@name.replace_all("\\\\", "\\\\\\\\").replace_all("\\\"", "\\\\\\\""))
            out.print(Character.new(?".ord))
          end
          if (!(@action).nil?)
            out.print(", \"")
            out.print(@action)
            out.print(Character.new(?".ord))
          end
          if (!(@signed_by).nil?)
            out.print(", signedBy \"")
            out.print(@signed_by)
            out.print(Character.new(?".ord))
          end
          out.println(";")
        end
        
        private
        alias_method :initialize__permission_entry, :initialize
      end }
      
      const_set_lazy(:ParsingException) { Class.new(GeneralSecurityException) do
        include_class_members PolicyParser
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -4330692689482574072 }
          const_attr_reader  :SerialVersionUID
        }
        
        attr_accessor :i18n_message
        alias_method :attr_i18n_message, :i18n_message
        undef_method :i18n_message
        alias_method :attr_i18n_message=, :i18n_message=
        undef_method :i18n_message=
        
        typesig { [String] }
        # Constructs a ParsingException with the specified
        # detail message. A detail message is a String that describes
        # this particular exception, which may, for example, specify which
        # algorithm is not available.
        # 
        # @param msg the detail message.
        def initialize(msg)
          @i18n_message = nil
          super(msg)
          @i18n_message = msg
        end
        
        typesig { [::Java::Int, String] }
        def initialize(line, msg)
          @i18n_message = nil
          super("line " + RJava.cast_to_string(line) + ": " + msg)
          form = self.class::MessageFormat.new(ResourcesMgr.get_string("line number: msg"))
          source = Array.typed(Object).new([line, msg])
          @i18n_message = RJava.cast_to_string(form.format(source))
        end
        
        typesig { [::Java::Int, String, String] }
        def initialize(line, expect, actual)
          @i18n_message = nil
          super("line " + RJava.cast_to_string(line) + ": expected [" + expect + "], found [" + actual + "]")
          form = self.class::MessageFormat.new(ResourcesMgr.get_string("line number: expected [expect], found [actual]"))
          source = Array.typed(Object).new([line, expect, actual])
          @i18n_message = RJava.cast_to_string(form.format(source))
        end
        
        typesig { [] }
        def get_localized_message
          return @i18n_message
        end
        
        private
        alias_method :initialize__parsing_exception, :initialize
      end }
      
      typesig { [Array.typed(String)] }
      def main(arg)
        fr = nil
        fw = nil
        begin
          pp = PolicyParser.new(true)
          fr = FileReader.new(arg[0])
          pp.read(fr)
          fw = FileWriter.new(arg[1])
          pp.write(fw)
        ensure
          if (!(fr).nil?)
            fr.close
          end
          if (!(fw).nil?)
            fw.close
          end
        end
      end
    }
    
    private
    alias_method :initialize__policy_parser, :initialize
  end
  
end

Sun::Security::Provider::PolicyParser.main($*) if $0 == __FILE__
