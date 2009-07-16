require "rjava"

# 
# Copyright 2003-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Instrument
  module ClassDefinitionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Instrument
    }
  end
  
  # 
  # Copyright 2003 Wily Technology, Inc.
  # 
  # 
  # This class serves as a parameter block to the <code>Instrumentation.redefineClasses</code> method.
  # Serves to bind the <code>Class</code> that needs redefining together with the new class file bytes.
  # 
  # @see     java.lang.instrument.Instrumentation#redefineClasses
  # @since   1.5
  class ClassDefinition 
    include_class_members ClassDefinitionImports
    
    # 
    # The class to redefine
    attr_accessor :m_class
    alias_method :attr_m_class, :m_class
    undef_method :m_class
    alias_method :attr_m_class=, :m_class=
    undef_method :m_class=
    
    # 
    # The replacement class file bytes
    attr_accessor :m_class_file
    alias_method :attr_m_class_file, :m_class_file
    undef_method :m_class_file
    alias_method :attr_m_class_file=, :m_class_file=
    undef_method :m_class_file=
    
    typesig { [Class, Array.typed(::Java::Byte)] }
    # 
    # Creates a new <code>ClassDefinition</code> binding using the supplied
    # class and class file bytes. Does not copy the supplied buffer, just captures a reference to it.
    # 
    # @param theClass the <code>Class</code> that needs redefining
    # @param theClassFile the new class file bytes
    # 
    # @throws java.lang.NullPointerException if the supplied class or array is <code>null</code>.
    def initialize(the_class, the_class_file)
      @m_class = nil
      @m_class_file = nil
      if ((the_class).nil? || (the_class_file).nil?)
        raise NullPointerException.new
      end
      @m_class = the_class
      @m_class_file = the_class_file
    end
    
    typesig { [] }
    # 
    # Returns the class.
    # 
    # @return    the <code>Class</code> object referred to.
    def get_definition_class
      return @m_class
    end
    
    typesig { [] }
    # 
    # Returns the array of bytes that contains the new class file.
    # 
    # @return    the class file bytes.
    def get_definition_class_file
      return @m_class_file
    end
    
    private
    alias_method :initialize__class_definition, :initialize
  end
  
end
