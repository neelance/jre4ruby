require "rjava"

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
module Sun::Security::Krb5
  module RealmImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Krb5
      include_const ::Sun::Security::Krb5, :Config
      include_const ::Sun::Security::Krb5, :PrincipalName
      include_const ::Sun::Security::Krb5, :KrbException
      include_const ::Sun::Security::Krb5, :Asn1Exception
      include_const ::Sun::Security::Krb5, :RealmException
      include_const ::Sun::Security::Krb5::Internal, :Krb5
      include ::Sun::Security::Util
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :StringTokenizer
      include_const ::Java::Util, :Vector
      include_const ::Java::Util, :Stack
      include_const ::Java::Util, :EmptyStackException
    }
  end
  
  # Implements the ASN.1 Realm type.
  # 
  # <xmp>
  # Realm ::= GeneralString
  # </xmp>
  class Realm 
    include_class_members RealmImports
    include Cloneable
    
    attr_accessor :realm
    alias_method :attr_realm, :realm
    undef_method :realm
    alias_method :attr_realm=, :realm=
    undef_method :realm=
    
    class_module.module_eval {
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= Krb5.attr_debug
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
    }
    
    typesig { [] }
    def initialize
      @realm = nil
    end
    
    typesig { [String] }
    def initialize(name)
      @realm = nil
      @realm = RJava.cast_to_string(parse_realm(name))
    end
    
    typesig { [] }
    def clone
      new_realm = Realm.new
      if (!(@realm).nil?)
        new_realm.attr_realm = String.new(@realm)
      end
      return new_realm
    end
    
    typesig { [Object] }
    def ==(obj)
      if ((self).equal?(obj))
        return true
      end
      if (!(obj.is_a?(Realm)))
        return false
      end
      that = obj
      if (!(@realm).nil? && !(that.attr_realm).nil?)
        return (@realm == that.attr_realm)
      else
        return ((@realm).nil? && (that.attr_realm).nil?)
      end
    end
    
    typesig { [] }
    def hash_code
      result = 17
      if (!(@realm).nil?)
        result = 37 * result + @realm.hash_code
      end
      return result
    end
    
    typesig { [DerValue] }
    # Constructs a Realm object.
    # @param encoding a Der-encoded data.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    # @exception RealmException if an error occurs while parsing a Realm object.
    def initialize(encoding)
      @realm = nil
      if ((encoding).nil?)
        raise IllegalArgumentException.new("encoding can not be null")
      end
      @realm = RJava.cast_to_string(encoding.get_general_string)
      if ((@realm).nil? || (@realm.length).equal?(0))
        raise RealmException.new(Krb5::REALM_NULL)
      end
      if (!is_valid_realm_string(@realm))
        raise RealmException.new(Krb5::REALM_ILLCHAR)
      end
    end
    
    typesig { [] }
    def to_s
      return @realm
    end
    
    class_module.module_eval {
      typesig { [String] }
      def parse_realm_at_separator(name)
        if ((name).nil?)
          raise IllegalArgumentException.new("null input name is not allowed")
        end
        temp = String.new(name)
        result = nil
        i = 0
        while (i < temp.length)
          if ((temp.char_at(i)).equal?(PrincipalName::NAME_REALM_SEPARATOR))
            if ((i).equal?(0) || !(temp.char_at(i - 1)).equal?(Character.new(?\\.ord)))
              if (i + 1 < temp.length)
                result = RJava.cast_to_string(temp.substring(i + 1, temp.length))
              end
              break
            end
          end
          i += 1
        end
        if (!(result).nil?)
          if ((result.length).equal?(0))
            raise RealmException.new(Krb5::REALM_NULL)
          end
          if (!is_valid_realm_string(result))
            raise RealmException.new(Krb5::REALM_ILLCHAR)
          end
        end
        return result
      end
      
      typesig { [String] }
      def parse_realm(name)
        result = parse_realm_at_separator(name)
        if ((result).nil?)
          result = name
        end
        if ((result).nil? || (result.length).equal?(0))
          raise RealmException.new(Krb5::REALM_NULL)
        end
        if (!is_valid_realm_string(result))
          raise RealmException.new(Krb5::REALM_ILLCHAR)
        end
        return result
      end
      
      typesig { [String] }
      # This is protected because the definition of a realm
      # string is fixed
      def is_valid_realm_string(name)
        if ((name).nil?)
          return false
        end
        if ((name.length).equal?(0))
          return false
        end
        i = 0
        while i < name.length
          if ((name.char_at(i)).equal?(Character.new(?/.ord)) || (name.char_at(i)).equal?(Character.new(?:.ord)) || (name.char_at(i)).equal?(Character.new(?\0.ord)))
            return false
          end
          i += 1
        end
        return true
      end
    }
    
    typesig { [] }
    # Encodes a Realm object.
    # @return the byte array of encoded KrbCredInfo object.
    # @exception Asn1Exception if an error occurs while decoding an ASN1 encoded data.
    # @exception IOException if an I/O error occurs while reading encoded data.
    def asn1_encode
      out = DerOutputStream.new
      out.put_general_string(@realm)
      return out.to_byte_array
    end
    
    class_module.module_eval {
      typesig { [DerInputStream, ::Java::Byte, ::Java::Boolean] }
      # Parse (unmarshal) a realm from a DER input stream.  This form
      # parsing might be used when expanding a value which is part of
      # a constructed sequence and uses explicitly tagged type.
      # 
      # @exception Asn1Exception on error.
      # @param data the Der input stream value, which contains one or more marshaled value.
      # @param explicitTag tag number.
      # @param optional indicate if this data field is optional
      # @return an instance of Realm.
      def parse(data, explicit_tag, optional)
        if ((optional) && (!((data.peek_byte & 0x1f)).equal?(explicit_tag)))
          return nil
        end
        der = data.get_der_value
        if (!(explicit_tag).equal?((der.get_tag & 0x1f)))
          raise Asn1Exception.new(Krb5::ASN1_BAD_ID)
        else
          sub_der = der.get_data.get_der_value
          return Realm.new(sub_der)
        end
      end
      
      typesig { [String, String] }
      # First leg of realms parsing. Used by getRealmsList.
      def do_initial_parse(c_realm, s_realm)
        if ((c_realm).nil? || (s_realm).nil?)
          raise KrbException.new(Krb5::API_INVALID_ARG)
        end
        if (self.attr_debug)
          System.out.println(">>> Realm doInitialParse: cRealm=[" + c_realm + "], sRealm=[" + s_realm + "]")
        end
        if ((c_realm == s_realm))
          ret_list = nil
          ret_list = Array.typed(String).new(1) { nil }
          ret_list[0] = String.new(c_realm)
          if (self.attr_debug)
            System.out.println(">>> Realm doInitialParse: " + RJava.cast_to_string(ret_list[0]))
          end
          return ret_list
        end
        return nil
      end
      
      typesig { [String, String] }
      # Returns an array of realms that may be traversed to obtain
      # a TGT from the initiating realm cRealm to the target realm
      # sRealm.
      # <br>
      # There may be an arbitrary number of intermediate realms
      # between cRealm and sRealm. The realms may be organized
      # organized hierarchically, or the paths between them may be
      # specified in the [capaths] stanza of the caller's
      # Kerberos configuration file. The configuration file is consulted
      # first. Then a hirarchical organization is assumed if no realms
      # are found in the configuration file.
      # <br>
      # The returned list, if not null, contains cRealm as the first
      # entry. sRealm is not included unless it is mistakenly listed
      # in the configuration file as an intermediary realm.
      # 
      # @param cRealm the initiating realm
      # @param sRealm the target realm
      # @returns array of realms
      # @thows KrbException
      def get_realms_list(c_realm, s_realm)
        ret_list = do_initial_parse(c_realm, s_realm)
        if (!(ret_list).nil? && !(ret_list.attr_length).equal?(0))
          return ret_list
        end
        # Try [capaths].
        ret_list = parse_capaths(c_realm, s_realm)
        if (!(ret_list).nil? && !(ret_list.attr_length).equal?(0))
          return ret_list
        end
        # Now assume the realms are organized hierarchically.
        ret_list = parse_hierarchy(c_realm, s_realm)
        return ret_list
      end
      
      typesig { [String, String] }
      # Parses the [capaths] stanza of the configuration file
      # for a list of realms to traverse
      # to obtain credentials from the initiating realm cRealm to
      # the target realm sRealm.
      # @param cRealm the initiating realm
      # @param sRealm the target realm
      # @returns array of realms
      # @ throws KrbException
      # 
      # 
      # parseCapaths works for a capaths organized such that
      # for a given client realm C there is a tag C that
      # contains subtags Ci ... Cn that completely define intermediate
      # realms from C to target T. For example:
      # 
      # [capaths]
      # TIVOLI.COM = {
      # IBM.COM = IBM_LDAPCENTRAL.COM MOONLITE.ORG
      # IBM_LDAPCENTRAL.COM = LDAPCENTRAL.NET
      # LDAPCENTRAL.NET = .
      # }
      # 
      # The tag TIVOLI.COM contains subtags IBM.COM, IBM_LDAPCENTRAL.COM
      # and LDAPCENTRAL.NET that completely define the path from TIVOLI.COM
      # to IBM.COM (TIVOLI.COM->LADAPCENTRAL.NET->IBM_LDAPCENTRAL.COM->IBM
      # or TIVOLI.COM->MOONLITE.ORG->IBM.COM).
      # 
      # A direct path is assumed for an intermediary whose entry is not
      # "closed" by a "." In the above example, TIVOLI.COM is assumed
      # to have a direct path to MOONLITE.ORG and MOONLITE.COM
      # in turn to IBM.COM.
      def parse_capaths(c_realm, s_realm)
        ret_list = nil
        cfg = nil
        begin
          cfg = Config.get_instance
        rescue JavaException => exc
          if (self.attr_debug)
            System.out.println("Configuration information can not be " + "obtained " + RJava.cast_to_string(exc.get_message))
          end
          return nil
        end
        intermediaries = cfg.get_default(s_realm, c_realm)
        if ((intermediaries).nil?)
          if (self.attr_debug)
            System.out.println(">>> Realm parseCapaths: no cfg entry")
          end
          return nil
        end
        temp_target = nil
        temp_realm = nil
        str_tok = nil
        i_stack = Stack.new
        # I don't expect any more than a handful of intermediaries.
        temp_list = Vector.new(8, 8)
        # The initiator at first location.
        temp_list.add(c_realm)
        count = 0 # For debug only
        if (self.attr_debug)
          temp_target = s_realm
        end
        begin
          if (self.attr_debug)
            count += 1
            System.out.println(">>> Realm parseCapaths: loop " + RJava.cast_to_string(count) + ": target=" + temp_target)
          end
          if (!(intermediaries).nil? && !(intermediaries == PrincipalName::REALM_COMPONENT_SEPARATOR_STR))
            if (self.attr_debug)
              System.out.println(">>> Realm parseCapaths: loop " + RJava.cast_to_string(count) + ": intermediaries=[" + intermediaries + "]")
            end
            # We have one or more space-separated intermediary realms.
            # Stack them.
            str_tok = StringTokenizer.new(intermediaries, " ")
            while (str_tok.has_more_tokens)
              temp_realm = RJava.cast_to_string(str_tok.next_token)
              if (!(temp_realm == PrincipalName::REALM_COMPONENT_SEPARATOR_STR) && !i_stack.contains(temp_realm))
                i_stack.push(temp_realm)
                if (self.attr_debug)
                  System.out.println(">>> Realm parseCapaths: loop " + RJava.cast_to_string(count) + ": pushed realm on to stack: " + temp_realm)
                end
              else
                if (self.attr_debug)
                  System.out.println(">>> Realm parseCapaths: loop " + RJava.cast_to_string(count) + ": ignoring realm: [" + temp_realm + "]")
                end
              end
            end
          else
            if (self.attr_debug)
              System.out.println(">>> Realm parseCapaths: loop " + RJava.cast_to_string(count) + ": no intermediaries")
            end
          end
          # Get next intermediary realm from the stack
          begin
            temp_target = RJava.cast_to_string(i_stack.pop)
          rescue EmptyStackException => exc
            temp_target = RJava.cast_to_string(nil)
          end
          if ((temp_target).nil?)
            # No more intermediaries. We're done.
            break
          end
          temp_list.add(temp_target)
          if (self.attr_debug)
            System.out.println(">>> Realm parseCapaths: loop " + RJava.cast_to_string(count) + ": added intermediary to list: " + temp_target)
          end
          intermediaries = RJava.cast_to_string(cfg.get_default(temp_target, c_realm))
        end while (true)
        ret_list = Array.typed(String).new(temp_list.size) { nil }
        begin
          ret_list = temp_list.to_array(ret_list)
        rescue ArrayStoreException => exc
          ret_list = nil
        end
        if (self.attr_debug && !(ret_list).nil?)
          i = 0
          while i < ret_list.attr_length
            System.out.println(">>> Realm parseCapaths [" + RJava.cast_to_string(i) + "]=" + RJava.cast_to_string(ret_list[i]))
            i += 1
          end
        end
        return ret_list
      end
      
      typesig { [String, String] }
      # Build a list of realm that can be traversed
      # to obtain credentials from the initiating realm cRealm
      # for a service in the target realm sRealm.
      # @param cRealm the initiating realm
      # @param sRealm the target realm
      # @returns array of realms
      # @throws KrbException
      def parse_hierarchy(c_realm, s_realm)
        ret_list = nil
        # Parse the components and determine common part, if any.
        c_components = nil
        s_components = nil
        str_tok = StringTokenizer.new(c_realm, PrincipalName::REALM_COMPONENT_SEPARATOR_STR)
        # Parse cRealm
        c_count = str_tok.count_tokens
        c_components = Array.typed(String).new(c_count) { nil }
        c_count = 0
        while str_tok.has_more_tokens
          c_components[c_count] = str_tok.next_token
          c_count += 1
        end
        if (self.attr_debug)
          System.out.println(">>> Realm parseHierarchy: cRealm has " + RJava.cast_to_string(c_count) + " components:")
          j = 0
          while (j < c_count)
            System.out.println(">>> Realm parseHierarchy: " + "cComponents[" + RJava.cast_to_string(j) + "]=" + RJava.cast_to_string(c_components[((j += 1) - 1)]))
          end
        end
        # Parse sRealm
        str_tok = StringTokenizer.new(s_realm, PrincipalName::REALM_COMPONENT_SEPARATOR_STR)
        s_count = str_tok.count_tokens
        s_components = Array.typed(String).new(s_count) { nil }
        s_count = 0
        while str_tok.has_more_tokens
          s_components[s_count] = str_tok.next_token
          s_count += 1
        end
        if (self.attr_debug)
          System.out.println(">>> Realm parseHierarchy: sRealm has " + RJava.cast_to_string(s_count) + " components:")
          j = 0
          while (j < s_count)
            System.out.println(">>> Realm parseHierarchy: sComponents[" + RJava.cast_to_string(j) + "]=" + RJava.cast_to_string(s_components[((j += 1) - 1)]))
          end
        end
        # Determine common components, if any.
        common_components = 0
        # while (sCount > 0 && cCount > 0 &&
        # sComponents[--sCount].equals(cComponents[--cCount]))
        s_count -= 1
        c_count -= 1
        while s_count >= 0 && c_count >= 0 && (s_components[s_count] == c_components[c_count])
          common_components += 1
          s_count -= 1
          c_count -= 1
        end
        c_common_start = -1
        s_common_start = -1
        links = 0
        if (common_components > 0)
          s_common_start = s_count + 1
          c_common_start = c_count + 1
          # components from common to ancestors
          links += s_common_start
          links += c_common_start
        else
          links += 1
        end
        if (self.attr_debug)
          if (common_components > 0)
            System.out.println(">>> Realm parseHierarchy: " + RJava.cast_to_string(common_components) + " common component" + RJava.cast_to_string((common_components > 1 ? "s" : " ")))
            System.out.println(">>> Realm parseHierarchy: common part " + "in cRealm (starts at index " + RJava.cast_to_string(c_common_start) + ")")
            System.out.println(">>> Realm parseHierarchy: common part in sRealm (starts at index " + RJava.cast_to_string(s_common_start) + ")")
            common_part = substring(c_realm, c_common_start)
            System.out.println(">>> Realm parseHierarchy: common part in cRealm=" + common_part)
            common_part = RJava.cast_to_string(substring(s_realm, s_common_start))
            System.out.println(">>> Realm parseHierarchy: common part in sRealm=" + common_part)
          else
            System.out.println(">>> Realm parseHierarchy: no common part")
          end
        end
        if (self.attr_debug)
          System.out.println(">>> Realm parseHierarchy: total links=" + RJava.cast_to_string(links))
        end
        ret_list = Array.typed(String).new(links) { nil }
        ret_list[0] = String.new(c_realm)
        if (self.attr_debug)
          System.out.println(">>> Realm parseHierarchy A: retList[0]=" + RJava.cast_to_string(ret_list[0]))
        end
        # For an initiator realm A.B.C.D.COM,
        # build a list krbtgt/B.C.D.COM@A.B.C.D.COM up to the common part,
        # ie the issuer realm is the immediate descendant
        # of the target realm.
        c_temp = nil
        s_temp = nil
        i = 0
        i = 1
        c_count = 0
        while i < links && c_count < c_common_start
          s_temp = RJava.cast_to_string(substring(c_realm, c_count + 1))
          # cTemp = substring(cRealm, cCount);
          ret_list[((i += 1) - 1)] = String.new(s_temp)
          if (self.attr_debug)
            System.out.println(">>> Realm parseHierarchy B: retList[" + RJava.cast_to_string((i - 1)) + "]=" + RJava.cast_to_string(ret_list[i - 1]))
          end
          c_count += 1
        end
        s_count = s_common_start
        while i < links && s_count - 1 > 0
          s_temp = RJava.cast_to_string(substring(s_realm, s_count - 1))
          # cTemp = substring(sRealm, sCount);
          ret_list[((i += 1) - 1)] = String.new(s_temp)
          if (self.attr_debug)
            System.out.println(">>> Realm parseHierarchy D: retList[" + RJava.cast_to_string((i - 1)) + "]=" + RJava.cast_to_string(ret_list[i - 1]))
          end
          s_count -= 1
        end
        return ret_list
      end
      
      typesig { [String, ::Java::Int] }
      def substring(realm, component_index)
        i = 0
        j = 0
        len = realm.length
        while (i < len && !(j).equal?(component_index))
          if (!(realm.char_at(((i += 1) - 1))).equal?(PrincipalName::REALM_COMPONENT_SEPARATOR))
            next
          end
          j += 1
        end
        return realm.substring(i)
      end
      
      typesig { [::Java::Int] }
      def get_rand_index(array_size)
        return RJava.cast_to_int((Math.random * 16384.0)) % array_size
      end
      
      typesig { [Array.typed(String)] }
      def print_names(names)
        if ((names).nil? || (names.attr_length).equal?(0))
          return
        end
        len = names.attr_length
        i = 0
        System.out.println("List length = " + RJava.cast_to_string(len))
        while (i < names.attr_length)
          System.out.println("[" + RJava.cast_to_string(i) + "]=" + RJava.cast_to_string(names[i]))
          i += 1
        end
      end
    }
    
    private
    alias_method :initialize__realm, :initialize
  end
  
end
