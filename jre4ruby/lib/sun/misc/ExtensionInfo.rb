require "rjava"

# Copyright 1999-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Misc
  module ExtensionInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Misc
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util::Jar, :Attributes
      include_const ::Java::Util::Jar::Attributes, :Name
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Text, :MessageFormat
      include ::Java::Lang::Character
    }
  end
  
  # This class holds all necessary information to install or
  # upgrade a extension on the user's disk
  # 
  # @author  Jerome Dochez
  class ExtensionInfo 
    include_class_members ExtensionInfoImports
    
    class_module.module_eval {
      # <p>
      # public static values returned by the isCompatible method
      # </p>
      const_set_lazy(:COMPATIBLE) { 0 }
      const_attr_reader  :COMPATIBLE
      
      const_set_lazy(:REQUIRE_SPECIFICATION_UPGRADE) { 1 }
      const_attr_reader  :REQUIRE_SPECIFICATION_UPGRADE
      
      const_set_lazy(:REQUIRE_IMPLEMENTATION_UPGRADE) { 2 }
      const_attr_reader  :REQUIRE_IMPLEMENTATION_UPGRADE
      
      const_set_lazy(:REQUIRE_VENDOR_SWITCH) { 3 }
      const_attr_reader  :REQUIRE_VENDOR_SWITCH
      
      const_set_lazy(:INCOMPATIBLE) { 4 }
      const_attr_reader  :INCOMPATIBLE
    }
    
    # <p>
    # attributes fully describer an extension. The underlying described
    # extension may be installed and requested.
    # <p>
    attr_accessor :title
    alias_method :attr_title, :title
    undef_method :title
    alias_method :attr_title=, :title=
    undef_method :title=
    
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    attr_accessor :spec_version
    alias_method :attr_spec_version, :spec_version
    undef_method :spec_version
    alias_method :attr_spec_version=, :spec_version=
    undef_method :spec_version=
    
    attr_accessor :spec_vendor
    alias_method :attr_spec_vendor, :spec_vendor
    undef_method :spec_vendor
    alias_method :attr_spec_vendor=, :spec_vendor=
    undef_method :spec_vendor=
    
    attr_accessor :implementation_version
    alias_method :attr_implementation_version, :implementation_version
    undef_method :implementation_version
    alias_method :attr_implementation_version=, :implementation_version=
    undef_method :implementation_version=
    
    attr_accessor :vendor
    alias_method :attr_vendor, :vendor
    undef_method :vendor
    alias_method :attr_vendor=, :vendor=
    undef_method :vendor=
    
    attr_accessor :vendor_id
    alias_method :attr_vendor_id, :vendor_id
    undef_method :vendor_id
    alias_method :attr_vendor_id=, :vendor_id=
    undef_method :vendor_id=
    
    attr_accessor :url
    alias_method :attr_url, :url
    undef_method :url
    alias_method :attr_url=, :url=
    undef_method :url=
    
    class_module.module_eval {
      # For I18N support
      const_set_lazy(:Rb) { ResourceBundle.get_bundle("sun.misc.resources.Messages") }
      const_attr_reader  :Rb
    }
    
    typesig { [] }
    # <p>
    # Create a new uninitialized extension information object
    # </p>
    def initialize
      @title = nil
      @name = nil
      @spec_version = nil
      @spec_vendor = nil
      @implementation_version = nil
      @vendor = nil
      @vendor_id = nil
      @url = nil
    end
    
    typesig { [String, Attributes] }
    # <p>
    # Create and initialize an extension information object.
    # The initialization uses the attributes passed as being
    # the content of a manifest file to load the extension
    # information from.
    # Since manifest file may contain information on several
    # extension they may depend on, the extension key parameter
    # is prepanded to the attribute name to make the key used
    # to retrieve the attribute from the manifest file
    # <p>
    # @param extensionKey unique extension key in the manifest
    # @param attr Attributes of a manifest file
    def initialize(extension_key, attr)
      @title = nil
      @name = nil
      @spec_version = nil
      @spec_vendor = nil
      @implementation_version = nil
      @vendor = nil
      @vendor_id = nil
      @url = nil
      s = nil
      if (!(extension_key).nil?)
        s = extension_key + "-"
      else
        s = ""
      end
      attr_key = s + (Name::EXTENSION_NAME.to_s).to_s
      @name = (attr.get_value(attr_key)).to_s
      if (!(@name).nil?)
        @name = (@name.trim).to_s
      end
      attr_key = s + (Name::SPECIFICATION_TITLE.to_s).to_s
      @title = (attr.get_value(attr_key)).to_s
      if (!(@title).nil?)
        @title = (@title.trim).to_s
      end
      attr_key = s + (Name::SPECIFICATION_VERSION.to_s).to_s
      @spec_version = (attr.get_value(attr_key)).to_s
      if (!(@spec_version).nil?)
        @spec_version = (@spec_version.trim).to_s
      end
      attr_key = s + (Name::SPECIFICATION_VENDOR.to_s).to_s
      @spec_vendor = (attr.get_value(attr_key)).to_s
      if (!(@spec_vendor).nil?)
        @spec_vendor = (@spec_vendor.trim).to_s
      end
      attr_key = s + (Name::IMPLEMENTATION_VERSION.to_s).to_s
      @implementation_version = (attr.get_value(attr_key)).to_s
      if (!(@implementation_version).nil?)
        @implementation_version = (@implementation_version.trim).to_s
      end
      attr_key = s + (Name::IMPLEMENTATION_VENDOR.to_s).to_s
      @vendor = (attr.get_value(attr_key)).to_s
      if (!(@vendor).nil?)
        @vendor = (@vendor.trim).to_s
      end
      attr_key = s + (Name::IMPLEMENTATION_VENDOR_ID.to_s).to_s
      @vendor_id = (attr.get_value(attr_key)).to_s
      if (!(@vendor_id).nil?)
        @vendor_id = (@vendor_id.trim).to_s
      end
      attr_key = s + (Name::IMPLEMENTATION_URL.to_s).to_s
      @url = (attr.get_value(attr_key)).to_s
      if (!(@url).nil?)
        @url = (@url.trim).to_s
      end
    end
    
    typesig { [ExtensionInfo] }
    # <p>
    # @return true if the extension described by this extension information
    # is compatible with the extension described by the extension
    # information passed as a parameter
    # </p>
    # 
    # @param the requested extension information to compare to
    def is_compatible_with(ei)
      if ((@name).nil? || (ei.attr_name).nil?)
        return INCOMPATIBLE
      end
      if (((@name <=> ei.attr_name)).equal?(0))
        # is this true, if not spec version is specified, we consider
        # the value as being "any".
        if ((@spec_version).nil? || (ei.attr_spec_version).nil?)
          return COMPATIBLE
        end
        version = compare_extension_version(@spec_version, ei.attr_spec_version)
        if (version < 0)
          # this extension specification is "older"
          if (!(@vendor_id).nil? && !(ei.attr_vendor_id).nil?)
            if (!((@vendor_id <=> ei.attr_vendor_id)).equal?(0))
              return REQUIRE_VENDOR_SWITCH
            end
          end
          return REQUIRE_SPECIFICATION_UPGRADE
        else
          # the extension spec is compatible, let's look at the
          # implementation attributes
          if (!(@vendor_id).nil? && !(ei.attr_vendor_id).nil?)
            # They care who provides the extension
            if (!((@vendor_id <=> ei.attr_vendor_id)).equal?(0))
              # They want to use another vendor implementation
              return REQUIRE_VENDOR_SWITCH
            else
              # Vendor matches, let's see the implementation version
              if (!(@implementation_version).nil? && !(ei.attr_implementation_version).nil?)
                # they care about the implementation version
                version = compare_extension_version(@implementation_version, ei.attr_implementation_version)
                if (version < 0)
                  # This extension is an older implementation
                  return REQUIRE_IMPLEMENTATION_UPGRADE
                end
              end
            end
          end
          # All othe cases, we consider the extensions to be compatible
          return COMPATIBLE
        end
      end
      return INCOMPATIBLE
    end
    
    typesig { [] }
    # <p>
    # helper method to print sensible information on the undelying described
    # extension
    # </p>
    def to_s
      return "Extension : title(" + @title + "), name(" + @name + "), spec vendor(" + @spec_vendor + "), spec version(" + @spec_version + "), impl vendor(" + @vendor + "), impl vendor id(" + @vendor_id + "), impl version(" + @implementation_version + "), impl url(" + @url + ")"
    end
    
    typesig { [String, String] }
    # <p>
    # helper method to compare two versions.
    # version are in the x.y.z.t pattern.
    # </p>
    # @param source version to compare to
    # @param target version used to compare against
    # @return < 0 if source < version
    # > 0 if source > version
    # = 0 if source = version
    def compare_extension_version(source, target)
      source = (source.to_lower_case).to_s
      target = (target.to_lower_case).to_s
      return strict_compare_extension_version(source, target)
    end
    
    typesig { [String, String] }
    # <p>
    # helper method to compare two versions.
    # version are in the x.y.z.t pattern.
    # </p>
    # @param source version to compare to
    # @param target version used to compare against
    # @return < 0 if source < version
    # > 0 if source > version
    # = 0 if source = version
    def strict_compare_extension_version(source, target)
      if ((source == target))
        return 0
      end
      stk = StringTokenizer.new(source, ".,")
      ttk = StringTokenizer.new(target, ".,")
      # Compare number
      n = 0
      m = 0
      result = 0
      # Convert token into meaning number for comparision
      if (stk.has_more_tokens)
        n = convert_token(stk.next_token.to_s)
      end
      # Convert token into meaning number for comparision
      if (ttk.has_more_tokens)
        m = convert_token(ttk.next_token.to_s)
      end
      if (n > m)
        return 1
      else
        if (m > n)
          return -1
        else
          # Look for index of "." in the string
          s_idx = source.index_of(".")
          t_idx = target.index_of(".")
          if ((s_idx).equal?(-1))
            s_idx = source.length - 1
          end
          if ((t_idx).equal?(-1))
            t_idx = target.length - 1
          end
          return strict_compare_extension_version(source.substring(s_idx + 1), target.substring(t_idx + 1))
        end
      end
    end
    
    typesig { [String] }
    def convert_token(token)
      if ((token).nil? || (token == ""))
        return 0
      end
      char_value = 0
      char_version = 0
      patch_version = 0
      str_length = token.length
      end_index = str_length
      last_char = 0
      args = Array.typed(Object).new([@name])
      mf = MessageFormat.new(Rb.get_string("optpkg.versionerror"))
      version_error = mf.format(args)
      # Look for "-" for pre-release
      pr_index = token.index_of("-")
      # Look for "_" for patch release
      patch_index = token.index_of("_")
      if ((pr_index).equal?(-1) && (patch_index).equal?(-1))
        # This is a FCS release
        begin
          return JavaInteger.parse_int(token) * 100
        rescue NumberFormatException => e
          System.out.println(version_error)
          return 0
        end
      else
        if (!(patch_index).equal?(-1))
          # This is a patch (update) release
          prversion = 0
          begin
            # Obtain the version
            prversion = JavaInteger.parse_int(token.substring(0, patch_index))
            # Check to see if the patch version is in the n.n.n_nnl format (special release)
            last_char = token.char_at(str_length - 1)
            if (Character.is_letter(last_char))
              # letters a-z have values from 10-35
              char_value = Character.get_numeric_value(last_char)
              end_index = str_length - 1
              # Obtain the patch version id
              patch_version = JavaInteger.parse_int(token.substring(patch_index + 1, end_index))
              if (char_value >= Character.get_numeric_value(Character.new(?a.ord)) && char_value <= Character.get_numeric_value(Character.new(?z.ord)))
                # This is a special release
                char_version = (patch_version * 100) + char_value
              else
                # character is not a a-z letter, ignore
                char_version = 0
                System.out.println(version_error)
              end
            else
              # This is a regular update release. Obtain the patch version id
              patch_version = JavaInteger.parse_int(token.substring(patch_index + 1, end_index))
            end
          rescue NumberFormatException => e
            System.out.println(version_error)
            return 0
          end
          return prversion * 100 + (patch_version + char_version)
        else
          # This is a milestone release, either a early access, alpha, beta, or RC
          # Obtain the version
          mrversion = 0
          begin
            mrversion = JavaInteger.parse_int(token.substring(0, pr_index))
          rescue NumberFormatException => e
            System.out.println(version_error)
            return 0
          end
          # Obtain the patch version string, including the milestone + version
          pr_string = token.substring(pr_index + 1)
          # Milestone version
          ms_version = ""
          delta = 0
          if (!(pr_string.index_of("ea")).equal?(-1))
            ms_version = (pr_string.substring(2)).to_s
            delta = 50
          else
            if (!(pr_string.index_of("alpha")).equal?(-1))
              ms_version = (pr_string.substring(5)).to_s
              delta = 40
            else
              if (!(pr_string.index_of("beta")).equal?(-1))
                ms_version = (pr_string.substring(4)).to_s
                delta = 30
              else
                if (!(pr_string.index_of("rc")).equal?(-1))
                  ms_version = (pr_string.substring(2)).to_s
                  delta = 20
                end
              end
            end
          end
          if ((ms_version).nil? || (ms_version == ""))
            # No version after the milestone, assume 0
            return mrversion * 100 - delta
          else
            # Convert the milestone version
            begin
              return mrversion * 100 - delta + JavaInteger.parse_int(ms_version)
            rescue NumberFormatException => e
              System.out.println(version_error)
              return 0
            end
          end
        end
      end
    end
    
    private
    alias_method :initialize__extension_info, :initialize
  end
  
end
