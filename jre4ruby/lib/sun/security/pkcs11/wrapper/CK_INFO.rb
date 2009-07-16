require "rjava"

# 
# reserved comment block
# DO NOT REMOVE OR ALTER!
# 
# Copyright  (c) 2002 Graz University of Technology. All rights reserved.
# 
# Redistribution and use in  source and binary forms, with or without
# modification, are permitted  provided that the following conditions are met:
# 
# 1. Redistributions of  source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 2. Redistributions in  binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# 3. The end-user documentation included with the redistribution, if any, must
# include the following acknowledgment:
# 
# "This product includes software developed by IAIK of Graz University of
# Technology."
# 
# Alternately, this acknowledgment may appear in the software itself, if
# and wherever such third-party acknowledgments normally appear.
# 
# 4. The names "Graz University of Technology" and "IAIK of Graz University of
# Technology" must not be used to endorse or promote products derived from
# this software without prior written permission.
# 
# 5. Products derived from this software may not be called
# "IAIK PKCS Wrapper", nor may "IAIK" appear in their name, without prior
# written permission of Graz University of Technology.
# 
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESSED OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE LICENSOR BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY  OF SUCH DAMAGE.
module Sun::Security::Pkcs11::Wrapper
  module CK_INFOImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # class  CK_INFO provides general information about Cryptoki.<p>
  # <B>PKCS#11 structure:</B>
  # <PRE>
  # typedef struct CK_INFO {&nbsp;&nbsp;
  # CK_VERSION cryptokiVersion;&nbsp;&nbsp;
  # CK_UTF8CHAR manufacturerID[32];&nbsp;&nbsp;
  # CK_FLAGS flags;&nbsp;&nbsp;
  # CK_UTF8CHAR libraryDescription[32];&nbsp;&nbsp;
  # CK_VERSION libraryVersion;&nbsp;&nbsp;
  # } CK_INFO;
  # </PRE>
  # 
  # @author Karl Scheibelhofer <Karl.Scheibelhofer@iaik.at>
  # @author Martin Schlaeffer <schlaeff@sbox.tugraz.at>
  class CK_INFO 
    include_class_members CK_INFOImports
    
    # 
    # Cryptoki interface version number<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VERSION cryptokiVersion;
    # </PRE>
    attr_accessor :cryptoki_version
    alias_method :attr_cryptoki_version, :cryptoki_version
    undef_method :cryptoki_version
    alias_method :attr_cryptoki_version=, :cryptoki_version=
    undef_method :cryptoki_version=
    
    # 
    # ID of the Cryptoki library manufacturer. must be blank
    # padded - only the first 32 chars will be used<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_UTF8CHAR manufacturerID[32];
    # </PRE>
    attr_accessor :manufacturer_id
    alias_method :attr_manufacturer_id, :manufacturer_id
    undef_method :manufacturer_id
    alias_method :attr_manufacturer_id=, :manufacturer_id=
    undef_method :manufacturer_id=
    
    # 
    # bit flags reserved for future versions. must be zero<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_FLAGS flags;
    # </PRE>
    attr_accessor :flags
    alias_method :attr_flags, :flags
    undef_method :flags
    alias_method :attr_flags=, :flags=
    undef_method :flags=
    
    # libraryDescription and libraryVersion are new for v2.0
    # 
    # must be blank padded - only the first 32 chars will be used<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_UTF8CHAR libraryDescription[32];
    # </PRE>
    attr_accessor :library_description
    alias_method :attr_library_description, :library_description
    undef_method :library_description
    alias_method :attr_library_description=, :library_description=
    undef_method :library_description=
    
    # 
    # Cryptoki library version number<p>
    # <B>PKCS#11:</B>
    # <PRE>
    # CK_VERSION libraryVersion;
    # </PRE>
    attr_accessor :library_version
    alias_method :attr_library_version, :library_version
    undef_method :library_version
    alias_method :attr_library_version=, :library_version=
    undef_method :library_version=
    
    typesig { [CK_VERSION, Array.typed(::Java::Char), ::Java::Long, Array.typed(::Java::Char), CK_VERSION] }
    def initialize(crypto_ver, vendor, flags, lib_desc, lib_ver)
      @cryptoki_version = nil
      @manufacturer_id = nil
      @flags = 0
      @library_description = nil
      @library_version = nil
      @cryptoki_version = crypto_ver
      @manufacturer_id = vendor
      @flags = flags
      @library_description = lib_desc
      @library_version = lib_ver
    end
    
    typesig { [] }
    # 
    # Returns the string representation of CK_INFO.
    # 
    # @return the string representation of CK_INFO
    def to_s
      buffer = StringBuffer.new
      buffer.append(Constants::INDENT)
      buffer.append("cryptokiVersion: ")
      buffer.append(@cryptoki_version.to_s)
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("manufacturerID: ")
      buffer.append(String.new(@manufacturer_id))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("flags: ")
      buffer.append(Functions.to_binary_string(@flags))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("libraryDescription: ")
      buffer.append(String.new(@library_description))
      buffer.append(Constants::NEWLINE)
      buffer.append(Constants::INDENT)
      buffer.append("libraryVersion: ")
      buffer.append(@library_version.to_s)
      # buffer.append(Constants.NEWLINE);
      return buffer.to_s
    end
    
    private
    alias_method :initialize__ck_info, :initialize
  end
  
end
