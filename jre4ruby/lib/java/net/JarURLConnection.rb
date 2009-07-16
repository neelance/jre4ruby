require "rjava"

# 
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
module Java::Net
  module JarURLConnectionImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Util::Jar, :JarFile
      include_const ::Java::Util::Jar, :JarEntry
      include_const ::Java::Util::Jar, :Attributes
      include_const ::Java::Util::Jar, :Manifest
      include_const ::Java::Security, :Permission
      include_const ::Sun::Net::Www, :ParseUtil
    }
  end
  
  # 
  # A URL Connection to a Java ARchive (JAR) file or an entry in a JAR
  # file.
  # 
  # <p>The syntax of a JAR URL is:
  # 
  # <pre>
  # jar:&lt;url&gt;!/{entry}
  # </pre>
  # 
  # <p>for example:
  # 
  # <p><code>
  # jar:http://www.foo.com/bar/baz.jar!/COM/foo/Quux.class<br>
  # </code>
  # 
  # <p>Jar URLs should be used to refer to a JAR file or entries in
  # a JAR file. The example above is a JAR URL which refers to a JAR
  # entry. If the entry name is omitted, the URL refers to the whole
  # JAR file:
  # 
  # <code>
  # jar:http://www.foo.com/bar/baz.jar!/
  # </code>
  # 
  # <p>Users should cast the generic URLConnection to a
  # JarURLConnection when they know that the URL they created is a JAR
  # URL, and they need JAR-specific functionality. For example:
  # 
  # <pre>
  # URL url = new URL("jar:file:/home/duke/duke.jar!/");
  # JarURLConnection jarConnection = (JarURLConnection)url.openConnection();
  # Manifest manifest = jarConnection.getManifest();
  # </pre>
  # 
  # <p>JarURLConnection instances can only be used to read from JAR files.
  # It is not possible to get a {@link java.io.OutputStream} to modify or write
  # to the underlying JAR file using this class.
  # <p>Examples:
  # 
  # <dl>
  # 
  # <dt>A Jar entry
  # <dd><code>jar:http://www.foo.com/bar/baz.jar!/COM/foo/Quux.class</code>
  # 
  # <dt>A Jar file
  # <dd><code>jar:http://www.foo.com/bar/baz.jar!/</code>
  # 
  # <dt>A Jar directory
  # <dd><code>jar:http://www.foo.com/bar/baz.jar!/COM/foo/</code>
  # 
  # </dl>
  # 
  # <p><code>!/</code> is refered to as the <em>separator</em>.
  # 
  # <p>When constructing a JAR url via <code>new URL(context, spec)</code>,
  # the following rules apply:
  # 
  # <ul>
  # 
  # <li>if there is no context URL and the specification passed to the
  # URL constructor doesn't contain a separator, the URL is considered
  # to refer to a JarFile.
  # 
  # <li>if there is a context URL, the context URL is assumed to refer
  # to a JAR file or a Jar directory.
  # 
  # <li>if the specification begins with a '/', the Jar directory is
  # ignored, and the spec is considered to be at the root of the Jar
  # file.
  # 
  # <p>Examples:
  # 
  # <dl>
  # 
  # <dt>context: <b>jar:http://www.foo.com/bar/jar.jar!/</b>,
  # spec:<b>baz/entry.txt</b>
  # 
  # <dd>url:<b>jar:http://www.foo.com/bar/jar.jar!/baz/entry.txt</b>
  # 
  # <dt>context: <b>jar:http://www.foo.com/bar/jar.jar!/baz</b>,
  # spec:<b>entry.txt</b>
  # 
  # <dd>url:<b>jar:http://www.foo.com/bar/jar.jar!/baz/entry.txt</b>
  # 
  # <dt>context: <b>jar:http://www.foo.com/bar/jar.jar!/baz</b>,
  # spec:<b>/entry.txt</b>
  # 
  # <dd>url:<b>jar:http://www.foo.com/bar/jar.jar!/entry.txt</b>
  # 
  # </dl>
  # 
  # </ul>
  # 
  # @see java.net.URL
  # @see java.net.URLConnection
  # 
  # @see java.util.jar.JarFile
  # @see java.util.jar.JarInputStream
  # @see java.util.jar.Manifest
  # @see java.util.zip.ZipEntry
  # 
  # @author Benjamin Renaud
  # @since 1.2
  class JarURLConnection < JarURLConnectionImports.const_get :URLConnection
    include_class_members JarURLConnectionImports
    
    attr_accessor :jar_file_url
    alias_method :attr_jar_file_url, :jar_file_url
    undef_method :jar_file_url
    alias_method :attr_jar_file_url=, :jar_file_url=
    undef_method :jar_file_url=
    
    attr_accessor :entry_name
    alias_method :attr_entry_name, :entry_name
    undef_method :entry_name
    alias_method :attr_entry_name=, :entry_name=
    undef_method :entry_name=
    
    # 
    # The connection to the JAR file URL, if the connection has been
    # initiated. This should be set by connect.
    attr_accessor :jar_file_urlconnection
    alias_method :attr_jar_file_urlconnection, :jar_file_urlconnection
    undef_method :jar_file_urlconnection
    alias_method :attr_jar_file_urlconnection=, :jar_file_urlconnection=
    undef_method :jar_file_urlconnection=
    
    typesig { [URL] }
    # 
    # Creates the new JarURLConnection to the specified URL.
    # @param url the URL
    # @throws MalformedURLException if no legal protocol
    # could be found in a specification string or the
    # string could not be parsed.
    def initialize(url)
      @jar_file_url = nil
      @entry_name = nil
      @jar_file_urlconnection = nil
      super(url)
      parse_specs(url)
    end
    
    typesig { [URL] }
    # get the specs for a given url out of the cache, and compute and
    # cache them if they're not there.
    def parse_specs(url)
      spec = url.get_file
      separator = spec.index_of("!/")
      # 
      # REMIND: we don't handle nested JAR URLs
      if ((separator).equal?(-1))
        raise MalformedURLException.new("no !/ found in url spec:" + spec)
      end
      @jar_file_url = URL.new(spec.substring(0, ((separator += 1) - 1)))
      @entry_name = (nil).to_s
      # if ! is the last letter of the innerURL, entryName is null
      if (!((separator += 1)).equal?(spec.length))
        @entry_name = (spec.substring(separator, spec.length)).to_s
        @entry_name = (ParseUtil.decode(@entry_name)).to_s
      end
    end
    
    typesig { [] }
    # 
    # Returns the URL for the Jar file for this connection.
    # 
    # @return the URL for the Jar file for this connection.
    def get_jar_file_url
      return @jar_file_url
    end
    
    typesig { [] }
    # 
    # Return the entry name for this connection. This method
    # returns null if the JAR file URL corresponding to this
    # connection points to a JAR file and not a JAR file entry.
    # 
    # @return the entry name for this connection, if any.
    def get_entry_name
      return @entry_name
    end
    
    typesig { [] }
    # 
    # Return the JAR file for this connection.
    # 
    # @return the JAR file for this connection. If the connection is
    # a connection to an entry of a JAR file, the JAR file object is
    # returned
    # 
    # @exception IOException if an IOException occurs while trying to
    # connect to the JAR file for this connection.
    # 
    # @see #connect
    def get_jar_file
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the Manifest for this connection, or null if none.
    # 
    # @return the manifest object corresponding to the JAR file object
    # for this connection.
    # 
    # @exception IOException if getting the JAR file for this
    # connection causes an IOException to be trown.
    # 
    # @see #getJarFile
    def get_manifest
      return get_jar_file.get_manifest
    end
    
    typesig { [] }
    # 
    # Return the JAR entry object for this connection, if any. This
    # method returns null if the JAR file URL corresponding to this
    # connection points to a JAR file and not a JAR file entry.
    # 
    # @return the JAR entry object for this connection, or null if
    # the JAR URL for this connection points to a JAR file.
    # 
    # @exception IOException if getting the JAR file for this
    # connection causes an IOException to be trown.
    # 
    # @see #getJarFile
    # @see #getJarEntry
    def get_jar_entry
      return get_jar_file.get_jar_entry(@entry_name)
    end
    
    typesig { [] }
    # 
    # Return the Attributes object for this connection if the URL
    # for it points to a JAR file entry, null otherwise.
    # 
    # @return the Attributes object for this connection if the URL
    # for it points to a JAR file entry, null otherwise.
    # 
    # @exception IOException if getting the JAR entry causes an
    # IOException to be thrown.
    # 
    # @see #getJarEntry
    def get_attributes
      e = get_jar_entry
      return !(e).nil? ? e.get_attributes : nil
    end
    
    typesig { [] }
    # 
    # Returns the main Attributes for the JAR file for this
    # connection.
    # 
    # @return the main Attributes for the JAR file for this
    # connection.
    # 
    # @exception IOException if getting the manifest causes an
    # IOException to be thrown.
    # 
    # @see #getJarFile
    # @see #getManifest
    def get_main_attributes
      man = get_manifest
      return !(man).nil? ? man.get_main_attributes : nil
    end
    
    typesig { [] }
    # 
    # Return the Certificate object for this connection if the URL
    # for it points to a JAR file entry, null otherwise. This method
    # can only be called once
    # the connection has been completely verified by reading
    # from the input stream until the end of the stream has been
    # reached. Otherwise, this method will return <code>null</code>
    # 
    # @return the Certificate object for this connection if the URL
    # for it points to a JAR file entry, null otherwise.
    # 
    # @exception IOException if getting the JAR entry causes an
    # IOException to be thrown.
    # 
    # @see #getJarEntry
    def get_certificates
      e = get_jar_entry
      return !(e).nil? ? e.get_certificates : nil
    end
    
    private
    alias_method :initialize__jar_urlconnection, :initialize
  end
  
end
