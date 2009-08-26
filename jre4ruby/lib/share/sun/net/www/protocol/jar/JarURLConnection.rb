require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
  module JarURLConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www::Protocol::Jar
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :FileNotFoundException
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Net, :MalformedURLException
      include_const ::Java::Net, :UnknownServiceException
      include_const ::Java::Util, :Enumeration
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util::Jar, :JarEntry
      include_const ::Java::Util::Jar, :JarFile
      include_const ::Java::Util::Jar, :Manifest
      include_const ::Java::Security, :Permission
    }
  end
  
  # @author Benjamin Renaud
  # @since 1.2
  class JarURLConnection < Java::Net::JarURLConnection
    include_class_members JarURLConnectionImports
    
    class_module.module_eval {
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
      
      # the Jar file factory. It handles both retrieval and caching.
      
      def factory
        defined?(@@factory) ? @@factory : @@factory= JarFileFactory.new
      end
      alias_method :attr_factory, :factory
      
      def factory=(value)
        @@factory = value
      end
      alias_method :attr_factory=, :factory=
    }
    
    # the url for the Jar file
    attr_accessor :jar_file_url
    alias_method :attr_jar_file_url, :jar_file_url
    undef_method :jar_file_url
    alias_method :attr_jar_file_url=, :jar_file_url=
    undef_method :jar_file_url=
    
    # the permission to get this JAR file. This is the actual, ultimate,
    # permission, returned by the jar file factory.
    attr_accessor :permission
    alias_method :attr_permission, :permission
    undef_method :permission
    alias_method :attr_permission=, :permission=
    undef_method :permission=
    
    # the url connection for the JAR file
    attr_accessor :jar_file_urlconnection
    alias_method :attr_jar_file_urlconnection, :jar_file_urlconnection
    undef_method :jar_file_urlconnection
    alias_method :attr_jar_file_urlconnection=, :jar_file_urlconnection=
    undef_method :jar_file_urlconnection=
    
    # the entry name, if any
    attr_accessor :entry_name
    alias_method :attr_entry_name, :entry_name
    undef_method :entry_name
    alias_method :attr_entry_name=, :entry_name=
    undef_method :entry_name=
    
    # the JarEntry
    attr_accessor :jar_entry
    alias_method :attr_jar_entry, :jar_entry
    undef_method :jar_entry
    alias_method :attr_jar_entry=, :jar_entry=
    undef_method :jar_entry=
    
    # the jar file corresponding to this connection
    attr_accessor :jar_file
    alias_method :attr_jar_file, :jar_file
    undef_method :jar_file
    alias_method :attr_jar_file=, :jar_file=
    undef_method :jar_file=
    
    # the content type for this connection
    attr_accessor :content_type
    alias_method :attr_content_type, :content_type
    undef_method :content_type
    alias_method :attr_content_type=, :content_type=
    undef_method :content_type=
    
    typesig { [URL, Handler] }
    def initialize(url, handler)
      @jar_file_url = nil
      @permission = nil
      @jar_file_urlconnection = nil
      @entry_name = nil
      @jar_entry = nil
      @jar_file = nil
      @content_type = nil
      super(url)
      @jar_file_url = get_jar_file_url
      @jar_file_urlconnection = @jar_file_url.open_connection
      @entry_name = RJava.cast_to_string(get_entry_name)
    end
    
    typesig { [] }
    def get_jar_file
      connect
      return @jar_file
    end
    
    typesig { [] }
    def get_jar_entry
      connect
      return @jar_entry
    end
    
    typesig { [] }
    def get_permission
      return @jar_file_urlconnection.get_permission
    end
    
    class_module.module_eval {
      const_set_lazy(:JarURLInputStream) { Class.new(Java::Io::FilterInputStream) do
        extend LocalClass
        include_class_members JarURLConnection
        
        typesig { [self::InputStream] }
        def initialize(src)
          super(src)
        end
        
        typesig { [] }
        def close
          begin
            super
          ensure
            if (!get_use_caches)
              self.attr_jar_file.close
            end
          end
        end
        
        private
        alias_method :initialize__jar_urlinput_stream, :initialize
      end }
    }
    
    typesig { [] }
    def connect
      if (!self.attr_connected)
        # the factory call will do the security checks
        @jar_file = self.attr_factory.get(get_jar_file_url, get_use_caches)
        # we also ask the factory the permission that was required
        # to get the jarFile, and set it as our permission.
        if (get_use_caches)
          @jar_file_urlconnection = self.attr_factory.get_connection(@jar_file)
        end
        if ((!(@entry_name).nil?))
          @jar_entry = @jar_file.get_entry(@entry_name)
          if ((@jar_entry).nil?)
            begin
              if (!get_use_caches)
                @jar_file.close
              end
            rescue JavaException => e
            end
            raise FileNotFoundException.new("JAR entry " + @entry_name + " not found in " + RJava.cast_to_string(@jar_file.get_name))
          end
        end
        self.attr_connected = true
      end
    end
    
    typesig { [] }
    def get_input_stream
      connect
      result = nil
      if ((@entry_name).nil?)
        raise IOException.new("no entry name specified")
      else
        if ((@jar_entry).nil?)
          raise FileNotFoundException.new("JAR entry " + @entry_name + " not found in " + RJava.cast_to_string(@jar_file.get_name))
        end
        result = JarURLInputStream.new_local(self, @jar_file.get_input_stream(@jar_entry))
      end
      return result
    end
    
    typesig { [] }
    def get_content_length
      result = -1
      begin
        connect
        if ((@jar_entry).nil?)
          # if the URL referes to an archive
          result = @jar_file_urlconnection.get_content_length
        else
          # if the URL referes to an archive entry
          result = RJava.cast_to_int(get_jar_entry.get_size)
        end
      rescue IOException => e
      end
      return result
    end
    
    typesig { [] }
    def get_content
      result = nil
      connect
      if ((@entry_name).nil?)
        result = @jar_file
      else
        result = super
      end
      return result
    end
    
    typesig { [] }
    def get_content_type
      if ((@content_type).nil?)
        if ((@entry_name).nil?)
          @content_type = "x-java/jar"
        else
          begin
            connect
            in_ = @jar_file.get_input_stream(@jar_entry)
            @content_type = RJava.cast_to_string(guess_content_type_from_stream(BufferedInputStream.new(in_)))
            in_.close
          rescue IOException => e
            # don't do anything
          end
        end
        if ((@content_type).nil?)
          @content_type = RJava.cast_to_string(guess_content_type_from_name(@entry_name))
        end
        if ((@content_type).nil?)
          @content_type = "content/unknown"
        end
      end
      return @content_type
    end
    
    typesig { [String] }
    def get_header_field(name)
      return @jar_file_urlconnection.get_header_field(name)
    end
    
    typesig { [String, String] }
    # Sets the general request property.
    # 
    # @param   key     the keyword by which the request is known
    # (e.g., "<code>accept</code>").
    # @param   value   the value associated with it.
    def set_request_property(key, value)
      @jar_file_urlconnection.set_request_property(key, value)
    end
    
    typesig { [String] }
    # Returns the value of the named general request property for this
    # connection.
    # 
    # @return  the value of the named general request property for this
    # connection.
    def get_request_property(key)
      return @jar_file_urlconnection.get_request_property(key)
    end
    
    typesig { [String, String] }
    # Adds a general request property specified by a
    # key-value pair.  This method will not overwrite
    # existing values associated with the same key.
    # 
    # @param   key     the keyword by which the request is known
    # (e.g., "<code>accept</code>").
    # @param   value   the value associated with it.
    def add_request_property(key, value)
      @jar_file_urlconnection.add_request_property(key, value)
    end
    
    typesig { [] }
    # Returns an unmodifiable Map of general request
    # properties for this connection. The Map keys
    # are Strings that represent the request-header
    # field names. Each Map value is a unmodifiable List
    # of Strings that represents the corresponding
    # field values.
    # 
    # @return  a Map of the general request properties for this connection.
    def get_request_properties
      return @jar_file_urlconnection.get_request_properties
    end
    
    typesig { [::Java::Boolean] }
    # Set the value of the <code>allowUserInteraction</code> field of
    # this <code>URLConnection</code>.
    # 
    # @param   allowuserinteraction   the new value.
    # @see     java.net.URLConnection#allowUserInteraction
    def set_allow_user_interaction(allowuserinteraction)
      @jar_file_urlconnection.set_allow_user_interaction(allowuserinteraction)
    end
    
    typesig { [] }
    # Returns the value of the <code>allowUserInteraction</code> field for
    # this object.
    # 
    # @return  the value of the <code>allowUserInteraction</code> field for
    # this object.
    # @see     java.net.URLConnection#allowUserInteraction
    def get_allow_user_interaction
      return @jar_file_urlconnection.get_allow_user_interaction
    end
    
    typesig { [::Java::Boolean] }
    # cache control
    # 
    # 
    # Sets the value of the <code>useCaches</code> field of this
    # <code>URLConnection</code> to the specified value.
    # <p>
    # Some protocols do caching of documents.  Occasionally, it is important
    # to be able to "tunnel through" and ignore the caches (e.g., the
    # "reload" button in a browser).  If the UseCaches flag on a connection
    # is true, the connection is allowed to use whatever caches it can.
    # If false, caches are to be ignored.
    # The default value comes from DefaultUseCaches, which defaults to
    # true.
    # 
    # @see     java.net.URLConnection#useCaches
    def set_use_caches(usecaches)
      @jar_file_urlconnection.set_use_caches(usecaches)
    end
    
    typesig { [] }
    # Returns the value of this <code>URLConnection</code>'s
    # <code>useCaches</code> field.
    # 
    # @return  the value of this <code>URLConnection</code>'s
    # <code>useCaches</code> field.
    # @see     java.net.URLConnection#useCaches
    def get_use_caches
      return @jar_file_urlconnection.get_use_caches
    end
    
    typesig { [::Java::Long] }
    # Sets the value of the <code>ifModifiedSince</code> field of
    # this <code>URLConnection</code> to the specified value.
    # 
    # @param   value   the new value.
    # @see     java.net.URLConnection#ifModifiedSince
    def set_if_modified_since(ifmodifiedsince)
      @jar_file_urlconnection.set_if_modified_since(ifmodifiedsince)
    end
    
    typesig { [::Java::Boolean] }
    # Sets the default value of the <code>useCaches</code> field to the
    # specified value.
    # 
    # @param   defaultusecaches   the new value.
    # @see     java.net.URLConnection#useCaches
    def set_default_use_caches(defaultusecaches)
      @jar_file_urlconnection.set_default_use_caches(defaultusecaches)
    end
    
    typesig { [] }
    # Returns the default value of a <code>URLConnection</code>'s
    # <code>useCaches</code> flag.
    # <p>
    # Ths default is "sticky", being a part of the static state of all
    # URLConnections.  This flag applies to the next, and all following
    # URLConnections that are created.
    # 
    # @return  the default value of a <code>URLConnection</code>'s
    # <code>useCaches</code> flag.
    # @see     java.net.URLConnection#useCaches
    def get_default_use_caches
      return @jar_file_urlconnection.get_default_use_caches
    end
    
    private
    alias_method :initialize__jar_urlconnection, :initialize
  end
  
end
