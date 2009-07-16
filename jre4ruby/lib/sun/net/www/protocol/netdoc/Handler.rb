require "rjava"

# 
# Copyright 1996-1998 Sun Microsystems, Inc.  All Rights Reserved.
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
# -
# netdoc urls point either into the local filesystem or externally
# through an http url, with network documents being preferred.  Useful for
# FAQs & other documents which are likely to be changing over time at the
# central site, and where the user will want the most recent edition.
# 
# @author Steven B. Byrne
module Sun::Net::Www::Protocol::Netdoc
  module HandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Netdoc
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :URLStreamHandler
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
    }
  end
  
  class Handler < HandlerImports.const_get :URLStreamHandler
    include_class_members HandlerImports
    
    class_module.module_eval {
      
      def base
        defined?(@@base) ? @@base : @@base= nil
      end
      alias_method :attr_base, :base
      
      def base=(value)
        @@base = value
      end
      alias_method :attr_base=, :base=
    }
    
    typesig { [URL] }
    # 
    # Attempt to find a load the given url using the default (network)
    # documentation location.  If that fails, use the local copy
    def open_connection(u)
      synchronized(self) do
        uc = nil
        ru = nil
        tmp = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("newdoc.localonly"))
        localonly = tmp.boolean_value
        docurl = Java::Security::AccessController.do_privileged(Sun::Security::Action::GetPropertyAction.new("doc.url"))
        file = u.get_file
        if (!localonly)
          begin
            if ((self.attr_base).nil?)
              self.attr_base = URL.new(docurl)
            end
            ru = URL.new(self.attr_base, file)
          rescue MalformedURLException => e
            ru = nil
          end
          if (!(ru).nil?)
            uc = ru.open_connection
          end
        end
        if ((uc).nil?)
          begin
            ru = URL.new("file", "~", file)
            uc = ru.open_connection
            is = uc.get_input_stream # Check for success.
          rescue MalformedURLException => e
            uc = nil
          rescue IOException => e
            uc = nil
          end
        end
        if ((uc).nil?)
          raise IOException.new("Can't find file for URL: " + (u.to_external_form).to_s)
        end
        return uc
      end
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__handler, :initialize
  end
  
end
