require "rjava"

# Copyright 2004-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Util
  module PolicyUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include ::Java::Io
      include ::Java::Net
      include ::Java::Security
      include_const ::Java::Util, :Arrays
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # A utility class for getting a KeyStore instance from policy information.
  # In addition, a supporting getInputStream method.
  class PolicyUtil 
    include_class_members PolicyUtilImports
    
    class_module.module_eval {
      # standard PKCS11 KeyStore type
      const_set_lazy(:P11KEYSTORE) { "PKCS11" }
      const_attr_reader  :P11KEYSTORE
      
      # reserved word
      const_set_lazy(:NONE) { "NONE" }
      const_attr_reader  :NONE
      
      typesig { [URL] }
      # Fast path reading from file urls in order to avoid calling
      # FileURLConnection.connect() which can be quite slow the first time
      # it is called. We really should clean up FileURLConnection so that
      # this is not a problem but in the meantime this fix helps reduce
      # start up time noticeably for the new launcher. -- DAC
      def get_input_stream(url)
        if (("file" == url.get_protocol))
          path = url.get_file.replace(Character.new(?/.ord), JavaFile.attr_separator_char)
          path = (ParseUtil.decode(path)).to_s
          return FileInputStream.new(path)
        else
          return url.open_stream
        end
      end
      
      typesig { [URL, String, String, String, String, Debug] }
      # this is intended for use by policytool and the policy parser to
      # instantiate a KeyStore from the information in the GUI/policy file
      # 
      # URL of policy file
      # input: keyStore URL
      # input: keyStore type
      # input: keyStore provider
      # input: keyStore password
      def get_key_store(policy_url, key_store_name, key_store_type, key_store_provider, store_pass_url, debug)
        if ((key_store_name).nil?)
          raise IllegalArgumentException.new("null KeyStore name")
        end
        key_store_password = nil
        begin
          ks = nil
          if ((key_store_type).nil?)
            key_store_type = (KeyStore.get_default_type).to_s
          end
          if (P11KEYSTORE.equals_ignore_case(key_store_type) && !(NONE == key_store_name))
            raise IllegalArgumentException.new("Invalid value (" + key_store_name + ") for keystore URL.  If the keystore type is \"" + P11KEYSTORE + "\", the keystore url must be \"" + NONE + "\"")
          end
          if (!(key_store_provider).nil?)
            ks = KeyStore.get_instance(key_store_type, key_store_provider)
          else
            ks = KeyStore.get_instance(key_store_type)
          end
          if (!(store_pass_url).nil?)
            pass_url = nil
            begin
              pass_url = URL.new(store_pass_url)
              # absolute URL
            rescue MalformedURLException => e
              # relative URL
              if ((policy_url).nil?)
                raise e
              end
              pass_url = URL.new(policy_url, store_pass_url)
            end
            if (!(debug).nil?)
              debug.println("reading password" + (pass_url).to_s)
            end
            in_ = nil
            begin
              in_ = pass_url.open_stream
              key_store_password = Password.read_password(in_)
            ensure
              if (!(in_).nil?)
                in_.close
              end
            end
          end
          if ((NONE == key_store_name))
            ks.load(nil, key_store_password)
            return ks
          else
            # location of keystore is specified as absolute URL in policy
            # file, or is relative to URL of policy file
            key_store_url = nil
            begin
              key_store_url = URL.new(key_store_name)
              # absolute URL
            rescue MalformedURLException => e
              # relative URL
              if ((policy_url).nil?)
                raise e
              end
              key_store_url = URL.new(policy_url, key_store_name)
            end
            if (!(debug).nil?)
              debug.println("reading keystore" + (key_store_url).to_s)
            end
            in_stream = nil
            begin
              in_stream = BufferedInputStream.new(get_input_stream(key_store_url))
              ks.load(in_stream, key_store_password)
            ensure
              in_stream.close
            end
            return ks
          end
        ensure
          if (!(key_store_password).nil?)
            Arrays.fill(key_store_password, Character.new(?\s.ord))
          end
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__policy_util, :initialize
  end
  
end
