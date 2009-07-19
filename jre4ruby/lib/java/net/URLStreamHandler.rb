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
module Java::Net
  module URLStreamHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :JavaFile
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Util, :Hashtable
      include_const ::Sun::Net::Util, :IPAddressUtil
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # The abstract class <code>URLStreamHandler</code> is the common
  # superclass for all stream protocol handlers. A stream protocol
  # handler knows how to make a connection for a particular protocol
  # type, such as <code>http</code>, <code>ftp</code>, or
  # <code>gopher</code>.
  # <p>
  # In most cases, an instance of a <code>URLStreamHandler</code>
  # subclass is not created directly by an application. Rather, the
  # first time a protocol name is encountered when constructing a
  # <code>URL</code>, the appropriate stream protocol handler is
  # automatically loaded.
  # 
  # @author  James Gosling
  # @see     java.net.URL#URL(java.lang.String, java.lang.String, int, java.lang.String)
  # @since   JDK1.0
  class URLStreamHandler 
    include_class_members URLStreamHandlerImports
    
    typesig { [URL] }
    # Opens a connection to the object referenced by the
    # <code>URL</code> argument.
    # This method should be overridden by a subclass.
    # 
    # <p>If for the handler's protocol (such as HTTP or JAR), there
    # exists a public, specialized URLConnection subclass belonging
    # to one of the following packages or one of their subpackages:
    # java.lang, java.io, java.util, java.net, the connection
    # returned will be of that subclass. For example, for HTTP an
    # HttpURLConnection will be returned, and for JAR a
    # JarURLConnection will be returned.
    # 
    # @param      u   the URL that this connects to.
    # @return     a <code>URLConnection</code> object for the <code>URL</code>.
    # @exception  IOException  if an I/O error occurs while opening the
    # connection.
    def open_connection(u)
      raise NotImplementedError
    end
    
    typesig { [URL, Proxy] }
    # Same as openConnection(URL), except that the connection will be
    # made through the specified proxy; Protocol handlers that do not
    # support proxying will ignore the proxy parameter and make a
    # normal connection.
    # 
    # Calling this method preempts the system's default ProxySelector
    # settings.
    # 
    # @param      u   the URL that this connects to.
    # @param      p   the proxy through which the connection will be made.
    # If direct connection is desired, Proxy.NO_PROXY
    # should be specified.
    # @return     a <code>URLConnection</code> object for the <code>URL</code>.
    # @exception  IOException  if an I/O error occurs while opening the
    # connection.
    # @exception  IllegalArgumentException if either u or p is null,
    # or p has the wrong type.
    # @exception  UnsupportedOperationException if the subclass that
    # implements the protocol doesn't support this method.
    # @since      1.5
    def open_connection(u, p)
      raise UnsupportedOperationException.new("Method not implemented.")
    end
    
    typesig { [URL, String, ::Java::Int, ::Java::Int] }
    # Parses the string representation of a <code>URL</code> into a
    # <code>URL</code> object.
    # <p>
    # If there is any inherited context, then it has already been
    # copied into the <code>URL</code> argument.
    # <p>
    # The <code>parseURL</code> method of <code>URLStreamHandler</code>
    # parses the string representation as if it were an
    # <code>http</code> specification. Most URL protocol families have a
    # similar parsing. A stream protocol handler for a protocol that has
    # a different syntax must override this routine.
    # 
    # @param   u       the <code>URL</code> to receive the result of parsing
    # the spec.
    # @param   spec    the <code>String</code> representing the URL that
    # must be parsed.
    # @param   start   the character index at which to begin parsing. This is
    # just past the '<code>:</code>' (if there is one) that
    # specifies the determination of the protocol name.
    # @param   limit   the character position to stop parsing at. This is the
    # end of the string or the position of the
    # "<code>#</code>" character, if present. All information
    # after the sharp sign indicates an anchor.
    def parse_url(u, spec, start, limit)
      # These fields may receive context content if this was relative URL
      protocol = u.get_protocol
      authority = u.get_authority
      user_info = u.get_user_info
      host = u.get_host
      port = u.get_port
      path = u.get_path
      query = u.get_query
      # This field has already been parsed
      ref = u.get_ref
      is_rel_path = false
      query_only = false
      # FIX: should not assume query if opaque
      # Strip off the query part
      if (start < limit)
        query_start = spec.index_of(Character.new(??.ord))
        query_only = (query_start).equal?(start)
        if ((!(query_start).equal?(-1)) && (query_start < limit))
          query = (spec.substring(query_start + 1, limit)).to_s
          if (limit > query_start)
            limit = query_start
          end
          spec = (spec.substring(0, query_start)).to_s
        end
      end
      i = 0
      # Parse the authority part if any
      is_uncname = (start <= limit - 4) && ((spec.char_at(start)).equal?(Character.new(?/.ord))) && ((spec.char_at(start + 1)).equal?(Character.new(?/.ord))) && ((spec.char_at(start + 2)).equal?(Character.new(?/.ord))) && ((spec.char_at(start + 3)).equal?(Character.new(?/.ord)))
      if (!is_uncname && (start <= limit - 2) && ((spec.char_at(start)).equal?(Character.new(?/.ord))) && ((spec.char_at(start + 1)).equal?(Character.new(?/.ord))))
        start += 2
        i = spec.index_of(Character.new(?/.ord), start)
        if (i < 0)
          i = spec.index_of(Character.new(??.ord), start)
          if (i < 0)
            i = limit
          end
        end
        host = (authority = (spec.substring(start, i)).to_s).to_s
        ind = authority.index_of(Character.new(?@.ord))
        if (!(ind).equal?(-1))
          user_info = (authority.substring(0, ind)).to_s
          host = (authority.substring(ind + 1)).to_s
        else
          user_info = (nil).to_s
        end
        if (!(host).nil?)
          # If the host is surrounded by [ and ] then its an IPv6
          # literal address as specified in RFC2732
          if (host.length > 0 && ((host.char_at(0)).equal?(Character.new(?[.ord))))
            if ((ind = host.index_of(Character.new(?].ord))) > 2)
              nhost = host
              host = (nhost.substring(0, ind + 1)).to_s
              if (!IPAddressUtil.is_ipv6literal_address(host.substring(1, ind)))
                raise IllegalArgumentException.new("Invalid host: " + host)
              end
              port = -1
              if (nhost.length > ind + 1)
                if ((nhost.char_at(ind + 1)).equal?(Character.new(?:.ord)))
                  (ind += 1)
                  # port can be null according to RFC2396
                  if (nhost.length > (ind + 1))
                    port = JavaInteger.parse_int(nhost.substring(ind + 1))
                  end
                else
                  raise IllegalArgumentException.new("Invalid authority field: " + authority)
                end
              end
            else
              raise IllegalArgumentException.new("Invalid authority field: " + authority)
            end
          else
            ind = host.index_of(Character.new(?:.ord))
            port = -1
            if (ind >= 0)
              # port can be null according to RFC2396
              if (host.length > (ind + 1))
                port = JavaInteger.parse_int(host.substring(ind + 1))
              end
              host = (host.substring(0, ind)).to_s
            end
          end
        else
          host = ""
        end
        if (port < -1)
          raise IllegalArgumentException.new("Invalid port number :" + (port).to_s)
        end
        start = i
        # If the authority is defined then the path is defined by the
        # spec only; See RFC 2396 Section 5.2.4.
        if (!(authority).nil? && authority.length > 0)
          path = ""
        end
      end
      if ((host).nil?)
        host = ""
      end
      # Parse the file path if any
      if (start < limit)
        if ((spec.char_at(start)).equal?(Character.new(?/.ord)))
          path = (spec.substring(start, limit)).to_s
        else
          if (!(path).nil? && path.length > 0)
            is_rel_path = true
            ind = path.last_index_of(Character.new(?/.ord))
            seperator = ""
            if ((ind).equal?(-1) && !(authority).nil?)
              seperator = "/"
            end
            path = (path.substring(0, ind + 1)).to_s + seperator + (spec.substring(start, limit)).to_s
          else
            seperator = (!(authority).nil?) ? "/" : ""
            path = seperator + (spec.substring(start, limit)).to_s
          end
        end
      else
        if (query_only && !(path).nil?)
          ind = path.last_index_of(Character.new(?/.ord))
          if (ind < 0)
            ind = 0
          end
          path = (path.substring(0, ind)).to_s + "/"
        end
      end
      if ((path).nil?)
        path = ""
      end
      if (is_rel_path)
        # Remove embedded /./
        while ((i = path.index_of("/./")) >= 0)
          path = (path.substring(0, i) + path.substring(i + 2)).to_s
        end
        # Remove embedded /../ if possible
        i = 0
        while ((i = path.index_of("/../", i)) >= 0)
          # A "/../" will cancel the previous segment and itself,
          # unless that segment is a "/../" itself
          # i.e. "/a/b/../c" becomes "/a/c"
          # but "/../../a" should stay unchanged
          if (i > 0 && (limit = path.last_index_of(Character.new(?/.ord), i - 1)) >= 0 && (!(path.index_of("/../", limit)).equal?(0)))
            path = (path.substring(0, limit) + path.substring(i + 3)).to_s
            i = 0
          else
            i = i + 3
          end
        end
        # Remove trailing .. if possible
        while (path.ends_with("/.."))
          i = path.index_of("/..")
          if ((limit = path.last_index_of(Character.new(?/.ord), i - 1)) >= 0)
            path = (path.substring(0, limit + 1)).to_s
          else
            break
          end
        end
        # Remove starting .
        if (path.starts_with("./") && path.length > 2)
          path = (path.substring(2)).to_s
        end
        # Remove trailing .
        if (path.ends_with("/."))
          path = (path.substring(0, path.length - 1)).to_s
        end
      end
      set_url(u, protocol, host, port, authority, user_info, path, query, ref)
    end
    
    typesig { [] }
    # Returns the default port for a URL parsed by this handler. This method
    # is meant to be overidden by handlers with default port numbers.
    # @return the default port for a <code>URL</code> parsed by this handler.
    # @since 1.3
    def get_default_port
      return -1
    end
    
    typesig { [URL, URL] }
    # Provides the default equals calculation. May be overidden by handlers
    # for other protocols that have different requirements for equals().
    # This method requires that none of its arguments is null. This is
    # guaranteed by the fact that it is only called by java.net.URL class.
    # @param u1 a URL object
    # @param u2 a URL object
    # @return <tt>true</tt> if the two urls are
    # considered equal, ie. they refer to the same
    # fragment in the same file.
    # @since 1.3
    def equals(u1, u2)
      ref1 = u1.get_ref
      ref2 = u2.get_ref
      return ((ref1).equal?(ref2) || (!(ref1).nil? && (ref1 == ref2))) && same_file(u1, u2)
    end
    
    typesig { [URL] }
    # Provides the default hash calculation. May be overidden by handlers for
    # other protocols that have different requirements for hashCode
    # calculation.
    # @param u a URL object
    # @return an <tt>int</tt> suitable for hash table indexing
    # @since 1.3
    def hash_code(u)
      h = 0
      # Generate the protocol part.
      protocol = u.get_protocol
      if (!(protocol).nil?)
        h += protocol.hash_code
      end
      # Generate the host part.
      addr = get_host_address(u)
      if (!(addr).nil?)
        h += addr.hash_code
      else
        host = u.get_host
        if (!(host).nil?)
          h += host.to_lower_case.hash_code
        end
      end
      # Generate the file part.
      file = u.get_file
      if (!(file).nil?)
        h += file.hash_code
      end
      # Generate the port part.
      if ((u.get_port).equal?(-1))
        h += get_default_port
      else
        h += u.get_port
      end
      # Generate the ref part.
      ref = u.get_ref
      if (!(ref).nil?)
        h += ref.hash_code
      end
      return h
    end
    
    typesig { [URL, URL] }
    # Compare two urls to see whether they refer to the same file,
    # i.e., having the same protocol, host, port, and path.
    # This method requires that none of its arguments is null. This is
    # guaranteed by the fact that it is only called indirectly
    # by java.net.URL class.
    # @param u1 a URL object
    # @param u2 a URL object
    # @return true if u1 and u2 refer to the same file
    # @since 1.3
    def same_file(u1, u2)
      # Compare the protocols.
      if (!(((u1.get_protocol).equal?(u2.get_protocol)) || (!(u1.get_protocol).nil? && u1.get_protocol.equals_ignore_case(u2.get_protocol))))
        return false
      end
      # Compare the files.
      if (!((u1.get_file).equal?(u2.get_file) || (!(u1.get_file).nil? && (u1.get_file == u2.get_file))))
        return false
      end
      # Compare the ports.
      port1 = 0
      port2 = 0
      port1 = (!(u1.get_port).equal?(-1)) ? u1.get_port : u1.attr_handler.get_default_port
      port2 = (!(u2.get_port).equal?(-1)) ? u2.get_port : u2.attr_handler.get_default_port
      if (!(port1).equal?(port2))
        return false
      end
      # Compare the hosts.
      if (!hosts_equal(u1, u2))
        return false
      end
      return true
    end
    
    typesig { [URL] }
    # Get the IP address of our host. An empty host field or a DNS failure
    # will result in a null return.
    # 
    # @param u a URL object
    # @return an <code>InetAddress</code> representing the host
    # IP address.
    # @since 1.3
    def get_host_address(u)
      synchronized(self) do
        if (!(u.attr_host_address).nil?)
          return u.attr_host_address
        end
        host = u.get_host
        if ((host).nil? || (host == ""))
          return nil
        else
          begin
            u.attr_host_address = InetAddress.get_by_name(host)
          rescue UnknownHostException => ex
            return nil
          rescue SecurityException => se
            return nil
          end
        end
        return u.attr_host_address
      end
    end
    
    typesig { [URL, URL] }
    # Compares the host components of two URLs.
    # @param u1 the URL of the first host to compare
    # @param u2 the URL of the second host to compare
    # @return  <tt>true</tt> if and only if they
    # are equal, <tt>false</tt> otherwise.
    # @since 1.3
    def hosts_equal(u1, u2)
      a1 = get_host_address(u1)
      a2 = get_host_address(u2)
      # if we have internet address for both, compare them
      if (!(a1).nil? && !(a2).nil?)
        return (a1 == a2)
        # else, if both have host names, compare them
      else
        if (!(u1.get_host).nil? && !(u2.get_host).nil?)
          return u1.get_host.equals_ignore_case(u2.get_host)
        else
          return (u1.get_host).nil? && (u2.get_host).nil?
        end
      end
    end
    
    typesig { [URL] }
    # Converts a <code>URL</code> of a specific protocol to a
    # <code>String</code>.
    # 
    # @param   u   the URL.
    # @return  a string representation of the <code>URL</code> argument.
    def to_external_form(u)
      # pre-compute length of StringBuffer
      len = u.get_protocol.length + 1
      if (!(u.get_authority).nil? && u.get_authority.length > 0)
        len += 2 + u.get_authority.length
      end
      if (!(u.get_path).nil?)
        len += u.get_path.length
      end
      if (!(u.get_query).nil?)
        len += 1 + u.get_query.length
      end
      if (!(u.get_ref).nil?)
        len += 1 + u.get_ref.length
      end
      result = StringBuffer.new(len)
      result.append(u.get_protocol)
      result.append(":")
      if (!(u.get_authority).nil? && u.get_authority.length > 0)
        result.append("//")
        result.append(u.get_authority)
      end
      if (!(u.get_path).nil?)
        result.append(u.get_path)
      end
      if (!(u.get_query).nil?)
        result.append(Character.new(??.ord))
        result.append(u.get_query)
      end
      if (!(u.get_ref).nil?)
        result.append("#")
        result.append(u.get_ref)
      end
      return result.to_s
    end
    
    typesig { [URL, String, String, ::Java::Int, String, String, String, String, String] }
    # Sets the fields of the <code>URL</code> argument to the indicated values.
    # Only classes derived from URLStreamHandler are supposed to be able
    # to call the set method on a URL.
    # 
    # @param   u         the URL to modify.
    # @param   protocol  the protocol name.
    # @param   host      the remote host value for the URL.
    # @param   port      the port on the remote machine.
    # @param   authority the authority part for the URL.
    # @param   userInfo the userInfo part of the URL.
    # @param   path      the path component of the URL.
    # @param   query     the query part for the URL.
    # @param   ref       the reference.
    # @exception       SecurityException       if the protocol handler of the URL is
    # different from this one
    # @see     java.net.URL#set(java.lang.String, java.lang.String, int, java.lang.String, java.lang.String)
    # @since 1.3
    def set_url(u, protocol, host, port, authority, user_info, path, query, ref)
      if (!(self).equal?(u.attr_handler))
        raise SecurityException.new("handler for url different from " + "this handler")
      end
      # ensure that no one can reset the protocol on a given URL.
      u.set(u.get_protocol, host, port, authority, user_info, path, query, ref)
    end
    
    typesig { [URL, String, String, ::Java::Int, String, String] }
    # Sets the fields of the <code>URL</code> argument to the indicated values.
    # Only classes derived from URLStreamHandler are supposed to be able
    # to call the set method on a URL.
    # 
    # @param   u         the URL to modify.
    # @param   protocol  the protocol name. This value is ignored since 1.2.
    # @param   host      the remote host value for the URL.
    # @param   port      the port on the remote machine.
    # @param   file      the file.
    # @param   ref       the reference.
    # @exception       SecurityException       if the protocol handler of the URL is
    # different from this one
    # @deprecated Use setURL(URL, String, String, int, String, String, String,
    # String);
    def set_url(u, protocol, host, port, file, ref)
      # Only old URL handlers call this, so assume that the host
      # field might contain "user:passwd@host". Fix as necessary.
      authority = nil
      user_info = nil
      if (!(host).nil? && !(host.length).equal?(0))
        authority = (((port).equal?(-1)) ? host : host + ":" + (port).to_s).to_s
        at = host.last_index_of(Character.new(?@.ord))
        if (!(at).equal?(-1))
          user_info = (host.substring(0, at)).to_s
          host = (host.substring(at + 1)).to_s
        end
      end
      # Assume file might contain query part. Fix as necessary.
      path = nil
      query = nil
      if (!(file).nil?)
        q = file.last_index_of(Character.new(??.ord))
        if (!(q).equal?(-1))
          query = (file.substring(q + 1)).to_s
          path = (file.substring(0, q)).to_s
        else
          path = file
        end
      end
      set_url(u, protocol, host, port, authority, user_info, path, query, ref)
    end
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__urlstream_handler, :initialize
  end
  
end
