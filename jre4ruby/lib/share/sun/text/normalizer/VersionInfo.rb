require "rjava"

# Portions Copyright 2005 Sun Microsystems, Inc.  All Rights Reserved.
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
# 
# (C) Copyright IBM Corp. 1996-2005 - All Rights Reserved                     *
# *
# The original version of this source code and documentation is copyrighted   *
# and owned by IBM, These materials are provided under terms of a License     *
# Agreement between IBM and Sun. This technology is protected by multiple     *
# US and International patents. This notice and attribution to IBM may not    *
# to removed.                                                                 *
module Sun::Text::Normalizer
  module VersionInfoImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Text::Normalizer
      include_const ::Java::Util, :HashMap
    }
  end
  
  # Class to store version numbers of the form major.minor.milli.micro.
  # @author synwee
  # @stable ICU 2.6
  class VersionInfo 
    include_class_members VersionInfoImports
    
    class_module.module_eval {
      typesig { [String] }
      # public methods ------------------------------------------------------
      # 
      # Returns an instance of VersionInfo with the argument version.
      # @param version version String in the format of "major.minor.milli.micro"
      # or "major.minor.milli" or "major.minor" or "major",
      # where major, minor, milli, micro are non-negative numbers
      # <= 255. If the trailing version numbers are
      # not specified they are taken as 0s. E.g. Version "3.1" is
      # equivalent to "3.1.0.0".
      # @return an instance of VersionInfo with the argument version.
      # @exception throws an IllegalArgumentException when the argument version
      # is not in the right format
      # @stable ICU 2.6
      def get_instance(version)
        length_ = version.length
        array = Array.typed(::Java::Int).new([0, 0, 0, 0])
        count = 0
        index = 0
        while (count < 4 && index < length_)
          c = version.char_at(index)
          if ((c).equal?(Character.new(?..ord)))
            count += 1
          else
            c -= Character.new(?0.ord)
            if (c < 0 || c > 9)
              raise IllegalArgumentException.new(INVALID_VERSION_NUMBER_)
            end
            array[count] *= 10
            array[count] += c
          end
          index += 1
        end
        if (!(index).equal?(length_))
          raise IllegalArgumentException.new("Invalid version number: String '" + version + "' exceeds version format")
        end
        i = 0
        while i < 4
          if (array[i] < 0 || array[i] > 255)
            raise IllegalArgumentException.new(INVALID_VERSION_NUMBER_)
          end
          i += 1
        end
        return get_instance(array[0], array[1], array[2], array[3])
      end
      
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Returns an instance of VersionInfo with the argument version.
      # @param major major version, non-negative number <= 255.
      # @param minor minor version, non-negative number <= 255.
      # @param milli milli version, non-negative number <= 255.
      # @param micro micro version, non-negative number <= 255.
      # @exception throws an IllegalArgumentException when either arguments are
      # negative or > 255
      # @stable ICU 2.6
      def get_instance(major, minor, milli, micro)
        # checks if it is in the hashmap
        # else
        if (major < 0 || major > 255 || minor < 0 || minor > 255 || milli < 0 || milli > 255 || micro < 0 || micro > 255)
          raise IllegalArgumentException.new(INVALID_VERSION_NUMBER_)
        end
        version = get_int(major, minor, milli, micro)
        key = version
        result = MAP_.get(key)
        if ((result).nil?)
          result = VersionInfo.new(version)
          MAP_.put(key, result)
        end
        return result
      end
    }
    
    typesig { [VersionInfo] }
    # Compares other with this VersionInfo.
    # @param other VersionInfo to be compared
    # @return 0 if the argument is a VersionInfo object that has version
    # information equals to this object.
    # Less than 0 if the argument is a VersionInfo object that has
    # version information greater than this object.
    # Greater than 0 if the argument is a VersionInfo object that
    # has version information less than this object.
    # @stable ICU 2.6
    def compare_to(other)
      return @m_version_ - other.attr_m_version_
    end
    
    # private data members ----------------------------------------------
    # 
    # Version number stored as a byte for each of the major, minor, milli and
    # micro numbers in the 32 bit int.
    # Most significant for the major and the least significant contains the
    # micro numbers.
    attr_accessor :m_version_
    alias_method :attr_m_version_, :m_version_
    undef_method :m_version_
    alias_method :attr_m_version_=, :m_version_=
    undef_method :m_version_=
    
    class_module.module_eval {
      # Map of singletons
      const_set_lazy(:MAP_) { HashMap.new }
      const_attr_reader  :MAP_
      
      # Error statement string
      const_set_lazy(:INVALID_VERSION_NUMBER_) { "Invalid version number: Version number may be negative or greater than 255" }
      const_attr_reader  :INVALID_VERSION_NUMBER_
    }
    
    typesig { [::Java::Int] }
    # private constructor -----------------------------------------------
    # 
    # Constructor with int
    # @param compactversion a 32 bit int with each byte representing a number
    def initialize(compactversion)
      @m_version_ = 0
      @m_version_ = compactversion
    end
    
    class_module.module_eval {
      typesig { [::Java::Int, ::Java::Int, ::Java::Int, ::Java::Int] }
      # Gets the int from the version numbers
      # @param major non-negative version number
      # @param minor non-negativeversion number
      # @param milli non-negativeversion number
      # @param micro non-negativeversion number
      def get_int(major, minor, milli, micro)
        return (major << 24) | (minor << 16) | (milli << 8) | micro
      end
    }
    
    private
    alias_method :initialize__version_info, :initialize
  end
  
end
