require "rjava"

# Copyright 1996-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# 
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Util
  module ListResourceBundleImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include_const ::Sun::Util, :ResourceBundleEnumeration
    }
  end
  
  # <code>ListResourceBundle</code> is an abstract subclass of
  # <code>ResourceBundle</code> that manages resources for a locale
  # in a convenient and easy to use list. See <code>ResourceBundle</code> for
  # more information about resource bundles in general.
  # 
  # <P>
  # Subclasses must override <code>getContents</code> and provide an array,
  # where each item in the array is a pair of objects.
  # The first element of each pair is the key, which must be a
  # <code>String</code>, and the second element is the value associated with
  # that key.
  # 
  # <p>
  # The following <a name="sample">example</a> shows two members of a resource
  # bundle family with the base name "MyResources".
  # "MyResources" is the default member of the bundle family, and
  # "MyResources_fr" is the French member.
  # These members are based on <code>ListResourceBundle</code>
  # (a related <a href="PropertyResourceBundle.html#sample">example</a> shows
  # how you can add a bundle to this family that's based on a properties file).
  # The keys in this example are of the form "s1" etc. The actual
  # keys are entirely up to your choice, so long as they are the same as
  # the keys you use in your program to retrieve the objects from the bundle.
  # Keys are case-sensitive.
  # <blockquote>
  # <pre>
  # 
  # public class MyResources extends ListResourceBundle {
  # protected Object[][] getContents() {
  # return new Object[][] = {
  # // LOCALIZE THIS
  # {"s1", "The disk \"{1}\" contains {0}."},  // MessageFormat pattern
  # {"s2", "1"},                               // location of {0} in pattern
  # {"s3", "My Disk"},                         // sample disk name
  # {"s4", "no files"},                        // first ChoiceFormat choice
  # {"s5", "one file"},                        // second ChoiceFormat choice
  # {"s6", "{0,number} files"},                // third ChoiceFormat choice
  # {"s7", "3 Mar 96"},                        // sample date
  # {"s8", new Dimension(1,5)}                 // real object, not just string
  # // END OF MATERIAL TO LOCALIZE
  # };
  # }
  # }
  # 
  # public class MyResources_fr extends ListResourceBundle {
  # protected Object[][] getContents() {
  # return new Object[][] = {
  # // LOCALIZE THIS
  # {"s1", "Le disque \"{1}\" {0}."},          // MessageFormat pattern
  # {"s2", "1"},                               // location of {0} in pattern
  # {"s3", "Mon disque"},                      // sample disk name
  # {"s4", "ne contient pas de fichiers"},     // first ChoiceFormat choice
  # {"s5", "contient un fichier"},             // second ChoiceFormat choice
  # {"s6", "contient {0,number} fichiers"},    // third ChoiceFormat choice
  # {"s7", "3 mars 1996"},                     // sample date
  # {"s8", new Dimension(1,3)}                 // real object, not just string
  # // END OF MATERIAL TO LOCALIZE
  # };
  # }
  # }
  # </pre>
  # </blockquote>
  # @see ResourceBundle
  # @see PropertyResourceBundle
  # @since JDK1.1
  class ListResourceBundle < ListResourceBundleImports.const_get :ResourceBundle
    include_class_members ListResourceBundleImports
    
    typesig { [] }
    # Sole constructor.  (For invocation by subclass constructors, typically
    # implicit.)
    def initialize
      @lookup = nil
      super()
      @lookup = nil
    end
    
    typesig { [String] }
    # Implements java.util.ResourceBundle.handleGetObject; inherits javadoc specification.
    def handle_get_object(key)
      # lazily load the lookup hashtable.
      if ((@lookup).nil?)
        load_lookup
      end
      if ((key).nil?)
        raise NullPointerException.new
      end
      return @lookup.get(key) # this class ignores locales
    end
    
    typesig { [] }
    # Returns an <code>Enumeration</code> of the keys contained in
    # this <code>ResourceBundle</code> and its parent bundles.
    # 
    # @return an <code>Enumeration</code> of the keys contained in
    # this <code>ResourceBundle</code> and its parent bundles.
    # @see #keySet()
    def get_keys
      # lazily load the lookup hashtable.
      if ((@lookup).nil?)
        load_lookup
      end
      parent = self.attr_parent
      return ResourceBundleEnumeration.new(@lookup.key_set, (!(parent).nil?) ? parent.get_keys : nil)
    end
    
    typesig { [] }
    # Returns a <code>Set</code> of the keys contained
    # <em>only</em> in this <code>ResourceBundle</code>.
    # 
    # @return a <code>Set</code> of the keys contained only in this
    # <code>ResourceBundle</code>
    # @since 1.6
    # @see #keySet()
    def handle_key_set
      if ((@lookup).nil?)
        load_lookup
      end
      return @lookup.key_set
    end
    
    typesig { [] }
    # Returns an array in which each item is a pair of objects in an
    # <code>Object</code> array. The first element of each pair is
    # the key, which must be a <code>String</code>, and the second
    # element is the value associated with that key.  See the class
    # description for details.
    # 
    # @return an array of an <code>Object</code> array representing a
    # key-value pair.
    def get_contents
      raise NotImplementedError
    end
    
    typesig { [] }
    # ==================privates====================
    # 
    # We lazily load the lookup hashtable.  This function does the
    # loading.
    def load_lookup
      synchronized(self) do
        if (!(@lookup).nil?)
          return
        end
        contents = get_contents
        temp = HashMap.new(contents.attr_length)
        i = 0
        while i < contents.attr_length
          # key must be non-null String, value must be non-null
          key = contents[i][0]
          value = contents[i][1]
          if ((key).nil? || (value).nil?)
            raise NullPointerException.new
          end
          temp.put(key, value)
          (i += 1)
        end
        @lookup = temp
      end
    end
    
    attr_accessor :lookup
    alias_method :attr_lookup, :lookup
    undef_method :lookup
    alias_method :attr_lookup=, :lookup=
    undef_method :lookup=
    
    private
    alias_method :initialize__list_resource_bundle, :initialize
  end
  
end
