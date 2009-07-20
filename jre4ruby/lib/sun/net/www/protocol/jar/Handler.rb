require "rjava"

# Copyright 1997-2000 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www::Protocol::Jar
  module HandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Jar
      include ::Java::Io
      include ::Java::Net
      include ::Java::Util
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # Jar URL Handler
  class Handler < Java::Net::URLStreamHandler
    include_class_members HandlerImports
    
    class_module.module_eval {
      const_set_lazy(:Separator) { "!/" }
      const_attr_reader  :Separator
    }
    
    typesig { [URL] }
    def open_connection(u)
      return JarURLConnection.new(u, self)
    end
    
    typesig { [String] }
    def index_of_bang_slash(spec)
      index_of_bang = spec.length
      while (!((index_of_bang = spec.last_index_of(Character.new(?!.ord), index_of_bang))).equal?(-1))
        if ((!(index_of_bang).equal?((spec.length - 1))) && ((spec.char_at(index_of_bang + 1)).equal?(Character.new(?/.ord))))
          return index_of_bang + 1
        else
          index_of_bang -= 1
        end
      end
      return -1
    end
    
    typesig { [URL, String, ::Java::Int, ::Java::Int] }
    def parse_url(url, spec, start, limit)
      file = nil
      ref = nil
      # first figure out if there is an anchor
      ref_pos = spec.index_of(Character.new(?#.ord), limit)
      ref_only = (ref_pos).equal?(start)
      if (ref_pos > -1)
        ref = (spec.substring(ref_pos + 1, spec.length)).to_s
        if (ref_only)
          file = (url.get_file).to_s
        end
      end
      # then figure out if the spec is
      # 1. absolute (jar:)
      # 2. relative (i.e. url + foo/bar/baz.ext)
      # 3. anchor-only (i.e. url + #foo), which we already did (refOnly)
      absolute_spec = false
      if (spec.length >= 4)
        absolute_spec = spec.substring(0, 4).equals_ignore_case("jar:")
      end
      spec = (spec.substring(start, limit)).to_s
      if (absolute_spec)
        file = (parse_absolute_spec(spec)).to_s
      else
        if (!ref_only)
          file = (parse_context_spec(url, spec)).to_s
          # Canonize the result after the bangslash
          bang_slash = index_of_bang_slash(file)
          to_bang_slash = file.substring(0, bang_slash)
          after_bang_slash = file.substring(bang_slash)
          canonizer = ParseUtil.new
          after_bang_slash = (canonizer.canonize_string(after_bang_slash)).to_s
          file = to_bang_slash + after_bang_slash
        end
      end
      set_url(url, "jar", "", -1, file, ref)
    end
    
    typesig { [String] }
    def parse_absolute_spec(spec)
      url = nil
      index = -1
      # check for !/
      if (((index = index_of_bang_slash(spec))).equal?(-1))
        raise NullPointerException.new("no !/ in spec")
      end
      # test the inner URL
      begin
        inner_spec = spec.substring(0, index - 1)
        url = URL.new(inner_spec)
      rescue MalformedURLException => e
        raise NullPointerException.new("invalid url: " + spec + " (" + (e).to_s + ")")
      end
      return spec
    end
    
    typesig { [URL, String] }
    def parse_context_spec(url, spec)
      ctx_file = url.get_file
      # if the spec begins with /, chop up the jar back !/
      if (spec.starts_with("/"))
        bang_slash = index_of_bang_slash(ctx_file)
        if ((bang_slash).equal?(-1))
          raise NullPointerException.new("malformed " + "context url:" + (url).to_s + ": no !/")
        end
        ctx_file = (ctx_file.substring(0, bang_slash)).to_s
      end
      if (!ctx_file.ends_with("/") && (!spec.starts_with("/")))
        # chop up the last component
        last_slash = ctx_file.last_index_of(Character.new(?/.ord))
        if ((last_slash).equal?(-1))
          raise NullPointerException.new("malformed " + "context url:" + (url).to_s)
        end
        ctx_file = (ctx_file.substring(0, last_slash + 1)).to_s
      end
      return (ctx_file + spec)
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__handler, :initialize
  end
  
end
