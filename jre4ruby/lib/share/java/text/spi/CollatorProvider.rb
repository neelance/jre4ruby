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
module Java::Text::Spi
  module CollatorProviderImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text::Spi
      include_const ::Java::Text, :Collator
      include_const ::Java::Util, :Locale
      include_const ::Java::Util::Spi, :LocaleServiceProvider
    }
  end
  
  # An abstract class for service providers that
  # provide concrete implementations of the
  # {@link java.text.Collator Collator} class.
  # 
  # @since        1.6
  class CollatorProvider < CollatorProviderImports.const_get :LocaleServiceProvider
    include_class_members CollatorProviderImports
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      super()
    end
    
    typesig { [Locale] }
    # Returns a new <code>Collator</code> instance for the specified locale.
    # @param locale the desired locale.
    # @return the <code>Collator</code> for the desired locale.
    # @exception NullPointerException if
    # <code>locale</code> is null
    # @exception IllegalArgumentException if <code>locale</code> isn't
    #     one of the locales returned from
    #     {@link java.util.spi.LocaleServiceProvider#getAvailableLocales()
    #     getAvailableLocales()}.
    # @see java.text.Collator#getInstance(java.util.Locale)
    def get_instance(locale)
      raise NotImplementedError
    end
    
    private
    alias_method :initialize__collator_provider, :initialize
  end
  
end
