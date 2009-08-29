require "rjava"

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
module Java::Lang
  module AssertionStatusDirectivesImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
    }
  end
  
  # A collection of assertion status directives (such as "enable assertions
  # in package p" or "disable assertions in class c").  This class is used by
  # the JVM to communicate the assertion status directives implied by
  # the <tt>java</tt> command line flags <tt>-enableassertions</tt>
  # (<tt>-ea</tt>) and <tt>-disableassertions</tt> (<tt>-da</tt>).
  # 
  # @since  1.4
  # @author Josh Bloch
  class AssertionStatusDirectives 
    include_class_members AssertionStatusDirectivesImports
    
    # The classes for which assertions are to be enabled or disabled.
    # The strings in this array are fully qualified class names (for
    # example,"com.xyz.foo.Bar").
    attr_accessor :classes
    alias_method :attr_classes, :classes
    undef_method :classes
    alias_method :attr_classes=, :classes=
    undef_method :classes=
    
    # A parallel array to <tt>classes</tt>, indicating whether each class
    # is to have assertions enabled or disabled.  A value of <tt>true</tt>
    # for <tt>classEnabled[i]</tt> indicates that the class named by
    # <tt>classes[i]</tt> should have assertions enabled; a value of
    # <tt>false</tt> indicates that it should have classes disabled.
    # This array must have the same number of elements as <tt>classes</tt>.
    # 
    # <p>In the case of conflicting directives for the same class, the
    # last directive for a given class wins.  In other words, if a string
    # <tt>s</tt> appears multiple times in the <tt>classes</tt> array
    # and <tt>i</tt> is the highest integer for which
    # <tt>classes[i].equals(s)</tt>, then <tt>classEnabled[i]</tt>
    # indicates whether assertions are to be enabled in class <tt>s</tt>.
    attr_accessor :class_enabled
    alias_method :attr_class_enabled, :class_enabled
    undef_method :class_enabled
    alias_method :attr_class_enabled=, :class_enabled=
    undef_method :class_enabled=
    
    # The package-trees for which assertions are to be enabled or disabled.
    # The strings in this array are compete or partial package names
    # (for example, "com.xyz" or "com.xyz.foo").
    attr_accessor :packages
    alias_method :attr_packages, :packages
    undef_method :packages
    alias_method :attr_packages=, :packages=
    undef_method :packages=
    
    # A parallel array to <tt>packages</tt>, indicating whether each
    # package-tree is to have assertions enabled or disabled.  A value of
    # <tt>true</tt> for <tt>packageEnabled[i]</tt> indicates that the
    # package-tree named by <tt>packages[i]</tt> should have assertions
    # enabled; a value of <tt>false</tt> indicates that it should have
    # assertions disabled.  This array must have the same number of
    # elements as <tt>packages</tt>.
    # 
    # In the case of conflicting directives for the same package-tree, the
    # last directive for a given package-tree wins.  In other words, if a
    # string <tt>s</tt> appears multiple times in the <tt>packages</tt> array
    # and <tt>i</tt> is the highest integer for which
    # <tt>packages[i].equals(s)</tt>, then <tt>packageEnabled[i]</tt>
    # indicates whether assertions are to be enabled in package-tree
    # <tt>s</tt>.
    attr_accessor :package_enabled
    alias_method :attr_package_enabled, :package_enabled
    undef_method :package_enabled
    alias_method :attr_package_enabled=, :package_enabled=
    undef_method :package_enabled=
    
    # Whether or not assertions in non-system classes are to be enabled
    # by default.
    attr_accessor :deflt
    alias_method :attr_deflt, :deflt
    undef_method :deflt
    alias_method :attr_deflt=, :deflt=
    undef_method :deflt=
    
    typesig { [] }
    def initialize
      @classes = nil
      @class_enabled = nil
      @packages = nil
      @package_enabled = nil
      @deflt = false
    end
    
    private
    alias_method :initialize__assertion_status_directives, :initialize
  end
  
end
