require "rjava"

# Copyright 1996 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net
  module URLCanonicalizerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net
    }
  end
  
  # Helper class to map URL "abbreviations" to real URLs.
  # The default implementation supports the following mappings:
  # ftp.mumble.bar/... => ftp://ftp.mumble.bar/...
  # gopher.mumble.bar/... => gopher://gopher.mumble.bar/...
  # other.name.dom/... => http://other.name.dom/...
  # /foo/... => file:/foo/...
  # 
  # Full URLs (those including a protocol name) are passed through unchanged.
  # 
  # Subclassers can override or extend this behavior to support different
  # or additional canonicalization policies.
  # 
  # @author      Steve Byrne
  class URLCanonicalizer 
    include_class_members URLCanonicalizerImports
    
    typesig { [] }
    # Creates the default canonicalizer instance.
    def initialize
    end
    
    typesig { [String] }
    # Given a possibly abbreviated URL (missing a protocol name, typically),
    # this method's job is to transform that URL into a canonical form,
    # by including a protocol name and additional syntax, if necessary.
    # 
    # For a correctly formed URL, this method should just return its argument.
    def canonicalize(simple_url)
      result_url = simple_url
      if (simple_url.starts_with("ftp."))
        result_url = "ftp://" + simple_url
      else
        if (simple_url.starts_with("gopher."))
          result_url = "gopher://" + simple_url
        else
          if (simple_url.starts_with("/"))
            result_url = "file:" + simple_url
          else
            if (!has_protocol_name(simple_url))
              if (is_simple_host_name(simple_url))
                simple_url = "www." + simple_url + ".com"
              end
              result_url = "http://" + simple_url
            end
          end
        end
      end
      return result_url
    end
    
    typesig { [String] }
    # Given a possibly abbreviated URL, this predicate function returns
    # true if it appears that the URL contains a protocol name
    def has_protocol_name(url)
      index = url.index_of(Character.new(?:.ord))
      if (index <= 0)
        # treat ":foo" as not having a protocol spec
        return false
      end
      i = 0
      while i < index
        c = url.char_at(i)
        # REMIND: this is a guess at legal characters in a protocol --
        # need to be verified
        if ((c >= Character.new(?A.ord) && c <= Character.new(?Z.ord)) || (c >= Character.new(?a.ord) && c <= Character.new(?z.ord)) || ((c).equal?(Character.new(?-.ord))))
          i += 1
          next
        end
        # found an illegal character
        return false
        i += 1
      end
      return true
    end
    
    typesig { [String] }
    # Returns true if the URL is just a single name, no periods or
    # slashes, false otherwise
    def is_simple_host_name(url)
      i = 0
      while i < url.length
        c = url.char_at(i)
        # REMIND: this is a guess at legal characters in a protocol --
        # need to be verified
        if ((c >= Character.new(?A.ord) && c <= Character.new(?Z.ord)) || (c >= Character.new(?a.ord) && c <= Character.new(?z.ord)) || (c >= Character.new(?0.ord) && c <= Character.new(?9.ord)) || ((c).equal?(Character.new(?-.ord))))
          i += 1
          next
        end
        # found an illegal character
        return false
        i += 1
      end
      return true
    end
    
    private
    alias_method :initialize__urlcanonicalizer, :initialize
  end
  
end
