require "rjava"

# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
  module ParameterCacheImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Util
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include_const ::Java::Security, :SecureRandom
      include ::Java::Security::Spec
      include_const ::Javax::Crypto::Spec, :DHParameterSpec
    }
  end
  
  # Cache for DSA and DH parameter specs. Used by the KeyPairGenerators
  # in the Sun, SunJCE, and SunPKCS11 provider if no parameters have been
  # explicitly specified by the application.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class ParameterCache 
    include_class_members ParameterCacheImports
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      typesig { [::Java::Int] }
      # Return cached DSA parameters for the given keylength, or null if none
      # are available in the cache.
      def get_cached_dsaparameter_spec(key_length)
        return DsaCache.get(JavaInteger.value_of(key_length))
      end
      
      typesig { [::Java::Int] }
      # Return cached DH parameters for the given keylength, or null if none
      # are available in the cache.
      def get_cached_dhparameter_spec(key_length)
        return DhCache.get(JavaInteger.value_of(key_length))
      end
      
      typesig { [::Java::Int, SecureRandom] }
      # Return DSA parameters for the given keylength. Uses cache if possible,
      # generates new parameters and adds them to the cache otherwise.
      def get_dsaparameter_spec(key_length, random)
        spec = get_cached_dsaparameter_spec(key_length)
        if (!(spec).nil?)
          return spec
        end
        spec = get_new_dsaparameter_spec(key_length, random)
        DsaCache.put(JavaInteger.value_of(key_length), spec)
        return spec
      end
      
      typesig { [::Java::Int, SecureRandom] }
      # Return DH parameters for the given keylength. Uses cache if possible,
      # generates new parameters and adds them to the cache otherwise.
      def get_dhparameter_spec(key_length, random)
        spec = get_cached_dhparameter_spec(key_length)
        if (!(spec).nil?)
          return spec
        end
        gen = AlgorithmParameterGenerator.get_instance("DH")
        gen.init(key_length, random)
        params = gen.generate_parameters
        spec = params.get_parameter_spec(DHParameterSpec)
        DhCache.put(JavaInteger.value_of(key_length), spec)
        return spec
      end
      
      typesig { [::Java::Int, SecureRandom] }
      # Return new DSA parameters for the given keylength. Do not lookup in
      # cache and do not cache the newly generated parameters. This method
      # really only exists for the legacy method
      # DSAKeyPairGenerator.initialize(int, boolean, SecureRandom).
      def get_new_dsaparameter_spec(key_length, random)
        gen = AlgorithmParameterGenerator.get_instance("DSA")
        gen.init(key_length, random)
        params = gen.generate_parameters
        spec = params.get_parameter_spec(DSAParameterSpec)
        return spec
      end
      
      when_class_loaded do
        # XXX change to ConcurrentHashMap once available
        const_set :DhCache, Collections.synchronized_map(HashMap.new)
        const_set :DsaCache, Collections.synchronized_map(HashMap.new)
        # We support precomputed parameter for 512, 768 and 1024 bit
        # moduli. In this file we provide both the seed and counter
        # value of the generation process for each of these seeds,
        # for validation purposes. We also include the test vectors
        # from the DSA specification, FIPS 186, and the FIPS 186
        # Change No 1, which updates the test vector using SHA-1
        # instead of SHA (for both the G function and the message
        # hash.
        # 
        # 
        # L = 512
        # SEED = b869c82b35d70e1b1ff91b28e37a62ecdc34409b
        # counter = 123
        p512 = BigInteger.new("fca682ce8e12caba26efccf7110e526db078b05edecb" + "cd1eb4a208f3ae1617ae01f35b91a47e6df63413c5e1" + "2ed0899bcd132acd50d99151bdc43ee737592e17", 16)
        q512 = BigInteger.new("962eddcc369cba8ebb260ee6b6a126d9346e38c5", 16)
        g512 = BigInteger.new("678471b27a9cf44ee91a49c5147db1a9aaf244f05a43" + "4d6486931d2d14271b9e35030b71fd73da179069b32e" + "2935630e1c2062354d0da20a6c416e50be794ca4", 16)
        # L = 768
        # SEED = 77d0f8c4dad15eb8c4f2f8d6726cefd96d5bb399
        # counter = 263
        p768 = BigInteger.new("e9e642599d355f37c97ffd3567120b8e25c9cd43e" + "927b3a9670fbec5d890141922d2c3b3ad24800937" + "99869d1e846aab49fab0ad26d2ce6a22219d470bc" + "e7d777d4a21fbe9c270b57f607002f3cef8393694" + "cf45ee3688c11a8c56ab127a3daf", 16)
        q768 = BigInteger.new("9cdbd84c9f1ac2f38d0f80f42ab952e7338bf511", 16)
        g768 = BigInteger.new("30470ad5a005fb14ce2d9dcd87e38bc7d1b1c5fac" + "baecbe95f190aa7a31d23c4dbbcbe06174544401a" + "5b2c020965d8c2bd2171d3668445771f74ba084d2" + "029d83c1c158547f3a9f1a2715be23d51ae4d3e5a" + "1f6a7064f316933a346d3f529252", 16)
        # L = 1024
        # SEED = 8d5155894229d5e689ee01e6018a237e2cae64cd
        # counter = 92
        p1024 = BigInteger.new("fd7f53811d75122952df4a9c2eece4e7f611b7523c" + "ef4400c31e3f80b6512669455d402251fb593d8d58" + "fabfc5f5ba30f6cb9b556cd7813b801d346ff26660" + "b76b9950a5a49f9fe8047b1022c24fbba9d7feb7c6" + "1bf83b57e7c6a8a6150f04fb83f6d3c51ec3023554" + "135a169132f675f3ae2b61d72aeff22203199dd148" + "01c7", 16)
        q1024 = BigInteger.new("9760508f15230bccb292b982a2eb840bf0581cf5", 16)
        g1024 = BigInteger.new("f7e1a085d69b3ddecbbcab5c36b857b97994afbbfa" + "3aea82f9574c0b3d0782675159578ebad4594fe671" + "07108180b449167123e84c281613b7cf09328cc8a6" + "e13c167a8b547c8d28e0a3ae1e2bb3a675916ea37f" + "0bfa213562f1fb627a01243bcca4f1bea8519089a8" + "83dfe15ae59f06928b665e807b552564014c3bfecf" + "492a", 16)
        DsaCache.put(JavaInteger.value_of(512), DSAParameterSpec.new(p512, q512, g512))
        DsaCache.put(JavaInteger.value_of(768), DSAParameterSpec.new(p768, q768, g768))
        DsaCache.put(JavaInteger.value_of(1024), DSAParameterSpec.new(p1024, q1024, g1024))
        # use DSA parameters for DH as well
        DhCache.put(JavaInteger.value_of(512), DHParameterSpec.new(p512, g512))
        DhCache.put(JavaInteger.value_of(768), DHParameterSpec.new(p768, g768))
        DhCache.put(JavaInteger.value_of(1024), DHParameterSpec.new(p1024, g1024))
      end
    }
    
    private
    alias_method :initialize__parameter_cache, :initialize
  end
  
end
