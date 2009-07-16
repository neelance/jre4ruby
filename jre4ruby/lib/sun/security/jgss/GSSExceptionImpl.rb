require "rjava"

# 
# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jgss
  module GSSExceptionImplImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jgss
      include ::Org::Ietf::Jgss
    }
  end
  
  # 
  # This class helps overcome a limitation of the org.ietf.jgss.GSSException
  # class that does not allow the thrower to set a string corresponding to
  # the major code.
  class GSSExceptionImpl < GSSExceptionImplImports.const_get :GSSException
    include_class_members GSSExceptionImplImports
    
    class_module.module_eval {
      const_set_lazy(:SerialVersionUID) { 4251197939069005575 }
      const_attr_reader  :SerialVersionUID
    }
    
    attr_accessor :major_message
    alias_method :attr_major_message, :major_message
    undef_method :major_message
    alias_method :attr_major_message=, :major_message=
    undef_method :major_message=
    
    typesig { [::Java::Int, Oid] }
    # 
    # A constructor that takes the majorCode as well as the mech oid that
    # will be appended to the standard message defined in its super class.
    def initialize(major_code, mech)
      @major_message = nil
      super(major_code)
      @major_message = (GSSException.instance_method(:get_major_string).bind(self).call).to_s + ": " + (mech).to_s
    end
    
    typesig { [::Java::Int, String] }
    # 
    # A constructor that takes the majorCode as well as the message that
    # corresponds to it.
    def initialize(major_code, major_message)
      @major_message = nil
      super(major_code)
      @major_message = major_message
    end
    
    typesig { [::Java::Int, Exception] }
    # 
    # A constructor that takes the majorCode and the exception cause.
    def initialize(major_code, cause)
      @major_message = nil
      super(major_code)
      init_cause(cause)
    end
    
    typesig { [::Java::Int, String, Exception] }
    # 
    # A constructor that takes the majorCode, the message that
    # corresponds to it, and the exception cause.
    def initialize(major_code, major_message, cause)
      initialize__gssexception_impl(major_code, major_message)
      init_cause(cause)
    end
    
    typesig { [] }
    # 
    # Returns the message that was embedded in this object, otherwise it
    # returns the default message that an org.ietf.jgss.GSSException
    # generates.
    def get_message
      if (!(@major_message).nil?)
        return @major_message
      else
        return super
      end
    end
    
    private
    alias_method :initialize__gssexception_impl, :initialize
  end
  
end
