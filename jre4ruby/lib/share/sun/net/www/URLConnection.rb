require "rjava"

# Copyright 1995-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Net::Www
  module URLConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Net::Www
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :ContentHandler
      include ::Java::Util
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Net, :UnknownServiceException
    }
  end
  
  # A class to represent an active connection to an object
  # represented by a URL.
  # @author  James Gosling
  class URLConnection < Java::Net::URLConnection
    include_class_members URLConnectionImports
    
    # The URL that it is connected to
    attr_accessor :content_type
    alias_method :attr_content_type, :content_type
    undef_method :content_type
    alias_method :attr_content_type=, :content_type=
    undef_method :content_type=
    
    attr_accessor :content_length
    alias_method :attr_content_length, :content_length
    undef_method :content_length
    alias_method :attr_content_length=, :content_length=
    undef_method :content_length=
    
    attr_accessor :properties
    alias_method :attr_properties, :properties
    undef_method :properties
    alias_method :attr_properties=, :properties=
    undef_method :properties=
    
    typesig { [URL] }
    # Create a URLConnection object.  These should not be created directly:
    # instead they should be created by protocol handers in response to
    # URL.openConnection.
    # @param  u       The URL that this connects to.
    def initialize(u)
      @content_type = nil
      @content_length = 0
      @properties = nil
      super(u)
      @content_length = -1
      @properties = MessageHeader.new
    end
    
    typesig { [] }
    # Call this routine to get the property list for this object.
    # Properties (like content-type) that have explicit getXX() methods
    # associated with them should be accessed using those methods.
    def get_properties
      return @properties
    end
    
    typesig { [MessageHeader] }
    # Call this routine to set the property list for this object.
    def set_properties(properties)
      @properties = properties
    end
    
    typesig { [String, String] }
    def set_request_property(key, value)
      if (self.attr_connected)
        raise IllegalAccessError.new("Already connected")
      end
      if ((key).nil?)
        raise NullPointerException.new("key cannot be null")
      end
      @properties.set(key, value)
    end
    
    typesig { [String, String] }
    # The following three methods addRequestProperty, getRequestProperty,
    # and getRequestProperties were copied from the superclass implementation
    # before it was changed by CR:6230836, to maintain backward compatibility.
    def add_request_property(key, value)
      if (self.attr_connected)
        raise IllegalStateException.new("Already connected")
      end
      if ((key).nil?)
        raise NullPointerException.new("key is null")
      end
    end
    
    typesig { [String] }
    def get_request_property(key)
      if (self.attr_connected)
        raise IllegalStateException.new("Already connected")
      end
      return nil
    end
    
    typesig { [] }
    def get_request_properties
      if (self.attr_connected)
        raise IllegalStateException.new("Already connected")
      end
      return Collections::EMPTY_MAP
    end
    
    typesig { [String] }
    def get_header_field(name)
      begin
        get_input_stream
      rescue JavaException => e
        return nil
      end
      return (@properties).nil? ? nil : @properties.find_value(name)
    end
    
    typesig { [::Java::Int] }
    # Return the key for the nth header field. Returns null if
    # there are fewer than n fields.  This can be used to iterate
    # through all the headers in the message.
    def get_header_field_key(n)
      begin
        get_input_stream
      rescue JavaException => e
        return nil
      end
      props = @properties
      return (props).nil? ? nil : props.get_key(n)
    end
    
    typesig { [::Java::Int] }
    # Return the value for the nth header field. Returns null if
    # there are fewer than n fields.  This can be used in conjunction
    # with getHeaderFieldKey to iterate through all the headers in the message.
    def get_header_field(n)
      begin
        get_input_stream
      rescue JavaException => e
        return nil
      end
      props = @properties
      return (props).nil? ? nil : props.get_value(n)
    end
    
    typesig { [] }
    # Call this routine to get the content-type associated with this
    # object.
    def get_content_type
      if ((@content_type).nil?)
        @content_type = RJava.cast_to_string(get_header_field("content-type"))
      end
      if ((@content_type).nil?)
        ct = nil
        begin
          ct = RJava.cast_to_string(guess_content_type_from_stream(get_input_stream))
        rescue Java::Io::IOException => e
        end
        ce = @properties.find_value("content-encoding")
        if ((ct).nil?)
          ct = RJava.cast_to_string(@properties.find_value("content-type"))
          if ((ct).nil?)
            if (self.attr_url.get_file.ends_with("/"))
              ct = "text/html"
            else
              ct = RJava.cast_to_string(guess_content_type_from_name(self.attr_url.get_file))
            end
          end
        end
        # If the Mime header had a Content-encoding field and its value
        # was not one of the values that essentially indicate no
        # encoding, we force the content type to be unknown. This will
        # cause a save dialog to be presented to the user.  It is not
        # ideal but is better than what we were previously doing, namely
        # bringing up an image tool for compressed tar files.
        if ((ct).nil? || !(ce).nil? && !(ce.equals_ignore_case("7bit") || ce.equals_ignore_case("8bit") || ce.equals_ignore_case("binary")))
          ct = "content/unknown"
        end
        set_content_type(ct)
      end
      return @content_type
    end
    
    typesig { [String] }
    # Set the content type of this URL to a specific value.
    # @param   type    The content type to use.  One of the
    # content_* static variables in this
    # class should be used.
    # eg. setType(URL.content_html);
    def set_content_type(type)
      @content_type = type
      @properties.set("content-type", type)
    end
    
    typesig { [] }
    # Call this routine to get the content-length associated with this
    # object.
    def get_content_length
      begin
        get_input_stream
      rescue JavaException => e
        return -1
      end
      l = @content_length
      if (l < 0)
        begin
          l = JavaInteger.parse_int(@properties.find_value("content-length"))
          set_content_length(l)
        rescue JavaException => e
        end
      end
      return l
    end
    
    typesig { [::Java::Int] }
    # Call this routine to set the content-length associated with this
    # object.
    def set_content_length(length)
      @content_length = length
      @properties.set("content-length", String.value_of(length))
    end
    
    typesig { [] }
    # Returns true if the data associated with this URL can be cached.
    def can_cache
      return self.attr_url.get_file.index_of(Character.new(??.ord)) < 0
      # && url.postData == null
      # REMIND
    end
    
    typesig { [] }
    # Call this to close the connection and flush any remaining data.
    # Overriders must remember to call super.close()
    def close
      self.attr_url = nil
    end
    
    class_module.module_eval {
      
      def proxied_hosts
        defined?(@@proxied_hosts) ? @@proxied_hosts : @@proxied_hosts= HashMap.new
      end
      alias_method :attr_proxied_hosts, :proxied_hosts
      
      def proxied_hosts=(value)
        @@proxied_hosts = value
      end
      alias_method :attr_proxied_hosts=, :proxied_hosts=
      
      typesig { [String] }
      def set_proxied_host(host)
        synchronized(self) do
          self.attr_proxied_hosts.put(host.to_lower_case, nil)
        end
      end
      
      typesig { [String] }
      def is_proxied_host(host)
        synchronized(self) do
          return self.attr_proxied_hosts.contains_key(host.to_lower_case)
        end
      end
    }
    
    private
    alias_method :initialize__urlconnection, :initialize
  end
  
end
