require "rjava"

# Copyright 2002-2007 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ssl
  module EphemeralKeyManagerImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ssl
      include ::Java::Security
    }
  end
  
  # The "KeyManager" for ephemeral RSA keys. Ephemeral DH and ECDH keys
  # are handled by the DHCrypt and ECDHCrypt classes, respectively.
  # 
  # @author  Andreas Sterbenz
  class EphemeralKeyManager 
    include_class_members EphemeralKeyManagerImports
    
    class_module.module_eval {
      # indices for the keys array below
      const_set_lazy(:INDEX_RSA512) { 0 }
      const_attr_reader  :INDEX_RSA512
      
      const_set_lazy(:INDEX_RSA1024) { 1 }
      const_attr_reader  :INDEX_RSA1024
    }
    
    # Current cached RSA KeyPairs. Elements are never null.
    # Indexed via the the constants above.
    attr_accessor :keys
    alias_method :attr_keys, :keys
    undef_method :keys
    alias_method :attr_keys=, :keys=
    undef_method :keys=
    
    typesig { [] }
    def initialize
      @keys = Array.typed(EphemeralKeyPair).new([EphemeralKeyPair.new(nil), EphemeralKeyPair.new(nil)])
      # empty
    end
    
    typesig { [::Java::Boolean, SecureRandom] }
    # Get a temporary RSA KeyPair.
    def get_rsakey_pair(export, random)
      length = 0
      index = 0
      if (export)
        length = 512
        index = INDEX_RSA512
      else
        length = 1024
        index = INDEX_RSA1024
      end
      synchronized((@keys)) do
        kp = @keys[index].get_key_pair
        if ((kp).nil?)
          begin
            kgen = JsseJce.get_key_pair_generator("RSA")
            kgen.initialize_(length, random)
            @keys[index] = EphemeralKeyPair.new(kgen.gen_key_pair)
            kp = @keys[index].get_key_pair
          rescue JavaException => e
            # ignore
          end
        end
        return kp
      end
    end
    
    class_module.module_eval {
      # Inner class to handle storage of ephemeral KeyPairs.
      const_set_lazy(:EphemeralKeyPair) { Class.new do
        include_class_members EphemeralKeyManager
        
        class_module.module_eval {
          # maximum number of times a KeyPair is used
          const_set_lazy(:MAX_USE) { 200 }
          const_attr_reader  :MAX_USE
          
          # maximum time interval in which the keypair is used (1 hour in ms)
          const_set_lazy(:USE_INTERVAL) { 3600 * 1000 }
          const_attr_reader  :USE_INTERVAL
        }
        
        attr_accessor :key_pair
        alias_method :attr_key_pair, :key_pair
        undef_method :key_pair
        alias_method :attr_key_pair=, :key_pair=
        undef_method :key_pair=
        
        attr_accessor :uses
        alias_method :attr_uses, :uses
        undef_method :uses
        alias_method :attr_uses=, :uses=
        undef_method :uses=
        
        attr_accessor :expiration_time
        alias_method :attr_expiration_time, :expiration_time
        undef_method :expiration_time
        alias_method :attr_expiration_time=, :expiration_time=
        undef_method :expiration_time=
        
        typesig { [class_self::KeyPair] }
        def initialize(key_pair)
          @key_pair = nil
          @uses = 0
          @expiration_time = 0
          @key_pair = key_pair
          @expiration_time = System.current_time_millis + self.class::USE_INTERVAL
        end
        
        typesig { [] }
        # Check if the KeyPair can still be used.
        def is_valid
          return (!(@key_pair).nil?) && (@uses < self.class::MAX_USE) && (System.current_time_millis < @expiration_time)
        end
        
        typesig { [] }
        # Return the KeyPair or null if it is invalid.
        def get_key_pair
          if ((is_valid).equal?(false))
            @key_pair = nil
            return nil
          end
          @uses += 1
          return @key_pair
        end
        
        private
        alias_method :initialize__ephemeral_key_pair, :initialize
      end }
    }
    
    private
    alias_method :initialize__ephemeral_key_manager, :initialize
  end
  
end
