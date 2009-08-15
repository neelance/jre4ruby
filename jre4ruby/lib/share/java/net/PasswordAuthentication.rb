require "rjava"

# Copyright 1997-2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Net
  module PasswordAuthenticationImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
    }
  end
  
  # The class PasswordAuthentication is a data holder that is used by
  # Authenticator.  It is simply a repository for a user name and a password.
  # 
  # @see java.net.Authenticator
  # @see java.net.Authenticator#getPasswordAuthentication()
  # 
  # @author  Bill Foote
  # @since   1.2
  class PasswordAuthentication 
    include_class_members PasswordAuthenticationImports
    
    attr_accessor :user_name
    alias_method :attr_user_name, :user_name
    undef_method :user_name
    alias_method :attr_user_name=, :user_name=
    undef_method :user_name=
    
    attr_accessor :password
    alias_method :attr_password, :password
    undef_method :password
    alias_method :attr_password=, :password=
    undef_method :password=
    
    typesig { [String, Array.typed(::Java::Char)] }
    # Creates a new <code>PasswordAuthentication</code> object from the given
    # user name and password.
    # 
    # <p> Note that the given user password is cloned before it is stored in
    # the new <code>PasswordAuthentication</code> object.
    # 
    # @param userName the user name
    # @param password the user's password
    def initialize(user_name, password)
      @user_name = nil
      @password = nil
      @user_name = user_name
      @password = password.clone
    end
    
    typesig { [] }
    # Returns the user name.
    # 
    # @return the user name
    def get_user_name
      return @user_name
    end
    
    typesig { [] }
    # Returns the user password.
    # 
    # <p> Note that this method returns a reference to the password. It is
    # the caller's responsibility to zero out the password information after
    # it is no longer needed.
    # 
    # @return the password
    def get_password
      return @password
    end
    
    private
    alias_method :initialize__password_authentication, :initialize
  end
  
end
