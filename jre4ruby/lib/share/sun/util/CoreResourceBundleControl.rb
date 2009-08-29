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
# 
# -- This file was mechanically generated: Do not edit! -- //
module Sun::Util
  module CoreResourceBundleControlImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Util
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util::ResourceBundle, :Control
    }
  end
  
  # This is a convenient class for loading some of internal resources faster
  # if they are built with Resources.gmk defined in J2SE workspace. Also,
  # they have to be in class file format.
  # 
  # "LOCALE_LIST" will be replaced at built time by a list of locales we
  # defined in Defs.gmk. We want to exclude these locales from search to
  # gain better performance. For example, since we know if the resource
  # is built with Resources.gmk, they are not going to provide basename_en.class
  # & basename_en_US.class resources, in that case, continuing searching them
  # is expensive. By excluding them from the candidate locale list, these
  # resources won't be searched.
  # 
  # @since 1.6.
  class CoreResourceBundleControl < CoreResourceBundleControlImports.const_get :ResourceBundle::Control
    include_class_members CoreResourceBundleControlImports
    
    # the candidate locale list to search
    attr_accessor :excluded_jdklocales
    alias_method :attr_excluded_jdklocales, :excluded_jdklocales
    undef_method :excluded_jdklocales
    alias_method :attr_excluded_jdklocales=, :excluded_jdklocales=
    undef_method :excluded_jdklocales=
    
    class_module.module_eval {
      # singlton instance of the resource bundle control.
      
      def resource_bundle_control_instance
        defined?(@@resource_bundle_control_instance) ? @@resource_bundle_control_instance : @@resource_bundle_control_instance= CoreResourceBundleControl.new
      end
      alias_method :attr_resource_bundle_control_instance, :resource_bundle_control_instance
      
      def resource_bundle_control_instance=(value)
        @@resource_bundle_control_instance = value
      end
      alias_method :attr_resource_bundle_control_instance=, :resource_bundle_control_instance=
    }
    
    typesig { [] }
    def initialize
      @excluded_jdklocales = nil
      super()
      @excluded_jdklocales = Arrays.as_list(Locale::GERMANY, Locale::ENGLISH, Locale::US, Locale.new("es", "ES"), Locale::FRANCE, Locale::ITALY, Locale::JAPAN, Locale::KOREA, Locale.new("sv", "SE"), Locale::CHINESE)
    end
    
    class_module.module_eval {
      typesig { [] }
      # This method is to provide a customized ResourceBundle.Control to speed
      # up the search of resources in JDK.
      # 
      # @return the instance of resource bundle control.
      def get_rbcontrol_instance
        return self.attr_resource_bundle_control_instance
      end
      
      typesig { [String] }
      # This method is to provide a customized ResourceBundle.Control to speed
      # up the search of resources in JDK, with the bundle's package name check.
      # 
      # @param bundleName bundle name to check
      # @return the instance of resource bundle control if the bundle is JDK's,
      # otherwise returns null.
      def get_rbcontrol_instance(bundle_name)
        if (bundle_name.starts_with("com.sun.") || bundle_name.starts_with("java.") || bundle_name.starts_with("javax.") || bundle_name.starts_with("sun."))
          return self.attr_resource_bundle_control_instance
        else
          return nil
        end
      end
    }
    
    typesig { [String, Locale] }
    # @returns a list of candidate locales to search from.
    # @exception NullPointerException if baseName or locale is null.
    def get_candidate_locales(base_name, locale)
      candidates = super(base_name, locale)
      candidates.remove_all(@excluded_jdklocales)
      return candidates
    end
    
    typesig { [String, Locale] }
    # @ returns TTL_DONT_CACHE so that ResourceBundle instance won't be cached.
    # User of this CoreResourceBundleControl should probably maintain a hard reference
    # to the ResourceBundle object themselves.
    def get_time_to_live(base_name, locale)
      return ResourceBundle::Control::TTL_DONT_CACHE
    end
    
    private
    alias_method :initialize__core_resource_bundle_control, :initialize
  end
  
end
