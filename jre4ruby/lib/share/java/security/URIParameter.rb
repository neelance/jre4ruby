require "rjava"

# Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module URIParameterImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
    }
  end
  
  # A parameter that contains a URI pointing to data intended for a
  # PolicySpi or ConfigurationSpi implementation.
  # 
  # @since 1.6
  class URIParameter 
    include_class_members URIParameterImports
    include Policy::Parameters
    include Javax::Security::Auth::Login::Configuration::Parameters
    
    attr_accessor :uri
    alias_method :attr_uri, :uri
    undef_method :uri
    alias_method :attr_uri=, :uri=
    undef_method :uri=
    
    typesig { [Java::Net::URI] }
    # Constructs a URIParameter with the URI pointing to
    # data intended for an SPI implementation.
    # 
    # @param uri the URI pointing to the data.
    # 
    # @exception NullPointerException if the specified URI is null.
    def initialize(uri)
      @uri = nil
      if ((uri).nil?)
        raise NullPointerException.new("invalid null URI")
      end
      @uri = uri
    end
    
    typesig { [] }
    # Returns the URI.
    # 
    # @return uri the URI.
    def get_uri
      return @uri
    end
    
    private
    alias_method :initialize__uriparameter, :initialize
  end
  
end
