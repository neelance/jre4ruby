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
module Java::Util::Jar
  module AttributesImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Jar
      include_const ::Java::Io, :DataInputStream
      include_const ::Java::Io, :DataOutputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :AbstractSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util::Logging, :Logger
      include_const ::Java::Util, :Comparator
      include_const ::Sun::Misc, :ASCIICaseInsensitiveComparator
    }
  end
  
  # The Attributes class maps Manifest attribute names to associated string
  # values. Valid attribute names are case-insensitive, are restricted to
  # the ASCII characters in the set [0-9a-zA-Z_-], and cannot exceed 70
  # characters in length. Attribute values can contain any characters and
  # will be UTF8-encoded when written to the output stream.  See the
  # <a href="../../../../technotes/guides/jar/jar.html">JAR File Specification</a>
  # for more information about valid attribute names and values.
  # 
  # @author  David Connelly
  # @see     Manifest
  # @since   1.2
  class Attributes 
    include_class_members AttributesImports
    include Map
    include Cloneable
    
    # The attribute name-value mappings.
    attr_accessor :map
    alias_method :attr_map, :map
    undef_method :map
    alias_method :attr_map=, :map=
    undef_method :map=
    
    typesig { [] }
    # Constructs a new, empty Attributes object with default size.
    def initialize
      initialize__attributes(11)
    end
    
    typesig { [::Java::Int] }
    # Constructs a new, empty Attributes object with the specified
    # initial size.
    # 
    # @param size the initial number of attributes
    def initialize(size)
      @map = nil
      @map = HashMap.new(size)
    end
    
    typesig { [Attributes] }
    # Constructs a new Attributes object with the same attribute name-value
    # mappings as in the specified Attributes.
    # 
    # @param attr the specified Attributes
    def initialize(attr)
      @map = nil
      @map = HashMap.new(attr)
    end
    
    typesig { [Object] }
    # Returns the value of the specified attribute name, or null if the
    # attribute name was not found.
    # 
    # @param name the attribute name
    # @return the value of the specified attribute name, or null if
    # not found.
    def get(name)
      return @map.get(name)
    end
    
    typesig { [String] }
    # Returns the value of the specified attribute name, specified as
    # a string, or null if the attribute was not found. The attribute
    # name is case-insensitive.
    # <p>
    # This method is defined as:
    # <pre>
    # return (String)get(new Attributes.Name((String)name));
    # </pre>
    # 
    # @param name the attribute name as a string
    # @return the String value of the specified attribute name, or null if
    # not found.
    # @throws IllegalArgumentException if the attribute name is invalid
    def get_value(name)
      return get(Attributes::Name.new(name))
    end
    
    typesig { [Name] }
    # Returns the value of the specified Attributes.Name, or null if the
    # attribute was not found.
    # <p>
    # This method is defined as:
    # <pre>
    # return (String)get(name);
    # </pre>
    # 
    # @param name the Attributes.Name object
    # @return the String value of the specified Attribute.Name, or null if
    # not found.
    def get_value(name)
      return get(name)
    end
    
    typesig { [Object, Object] }
    # Associates the specified value with the specified attribute name
    # (key) in this Map. If the Map previously contained a mapping for
    # the attribute name, the old value is replaced.
    # 
    # @param name the attribute name
    # @param value the attribute value
    # @return the previous value of the attribute, or null if none
    # @exception ClassCastException if the name is not a Attributes.Name
    # or the value is not a String
    def put(name, value)
      return @map.put(name, value)
    end
    
    typesig { [String, String] }
    # Associates the specified value with the specified attribute name,
    # specified as a String. The attributes name is case-insensitive.
    # If the Map previously contained a mapping for the attribute name,
    # the old value is replaced.
    # <p>
    # This method is defined as:
    # <pre>
    # return (String)put(new Attributes.Name(name), value);
    # </pre>
    # 
    # @param name the attribute name as a string
    # @param value the attribute value
    # @return the previous value of the attribute, or null if none
    # @exception IllegalArgumentException if the attribute name is invalid
    def put_value(name, value)
      return put(Name.new(name), value)
    end
    
    typesig { [Object] }
    # Removes the attribute with the specified name (key) from this Map.
    # Returns the previous attribute value, or null if none.
    # 
    # @param name attribute name
    # @return the previous value of the attribute, or null if none
    def remove(name)
      return @map.remove(name)
    end
    
    typesig { [Object] }
    # Returns true if this Map maps one or more attribute names (keys)
    # to the specified value.
    # 
    # @param value the attribute value
    # @return true if this Map maps one or more attribute names to
    # the specified value
    def contains_value(value)
      return @map.contains_value(value)
    end
    
    typesig { [Object] }
    # Returns true if this Map contains the specified attribute name (key).
    # 
    # @param name the attribute name
    # @return true if this Map contains the specified attribute name
    def contains_key(name)
      return @map.contains_key(name)
    end
    
    typesig { [Map] }
    # Copies all of the attribute name-value mappings from the specified
    # Attributes to this Map. Duplicate mappings will be replaced.
    # 
    # @param attr the Attributes to be stored in this map
    # @exception ClassCastException if attr is not an Attributes
    def put_all(attr)
      # ## javac bug?
      if (!Attributes.class.is_instance(attr))
        raise ClassCastException.new
      end
      (attr).entry_set.each do |me|
        put(me.get_key, me.get_value)
      end
    end
    
    typesig { [] }
    # Removes all attributes from this Map.
    def clear
      @map.clear
    end
    
    typesig { [] }
    # Returns the number of attributes in this Map.
    def size
      return @map.size
    end
    
    typesig { [] }
    # Returns true if this Map contains no attributes.
    def is_empty
      return @map.is_empty
    end
    
    typesig { [] }
    # Returns a Set view of the attribute names (keys) contained in this Map.
    def key_set
      return @map.key_set
    end
    
    typesig { [] }
    # Returns a Collection view of the attribute values contained in this Map.
    def values
      return @map.values
    end
    
    typesig { [] }
    # Returns a Collection view of the attribute name-value mappings
    # contained in this Map.
    def entry_set
      return @map.entry_set
    end
    
    typesig { [Object] }
    # Compares the specified Attributes object with this Map for equality.
    # Returns true if the given object is also an instance of Attributes
    # and the two Attributes objects represent the same mappings.
    # 
    # @param o the Object to be compared
    # @return true if the specified Object is equal to this Map
    def equals(o)
      return (@map == o)
    end
    
    typesig { [] }
    # Returns the hash code value for this Map.
    def hash_code
      return @map.hash_code
    end
    
    typesig { [] }
    # Returns a copy of the Attributes, implemented as follows:
    # <pre>
    # public Object clone() { return new Attributes(this); }
    # </pre>
    # Since the attribute names and values are themselves immutable,
    # the Attributes returned can be safely modified without affecting
    # the original.
    def clone
      return Attributes.new(self)
    end
    
    typesig { [DataOutputStream] }
    # Writes the current attributes to the specified data output stream.
    # XXX Need to handle UTF8 values and break up lines longer than 72 bytes
    def write(os)
      it = entry_set.iterator
      while (it.has_next)
        e = it.next
        buffer = StringBuffer.new((e.get_key).to_s)
        buffer.append(": ")
        value = e.get_value
        if (!(value).nil?)
          vb = value.get_bytes("UTF8")
          value = (String.new(vb, 0, 0, vb.attr_length)).to_s
        end
        buffer.append(value)
        buffer.append("\r\n")
        Manifest.make72_safe(buffer)
        os.write_bytes(buffer.to_s)
      end
      os.write_bytes("\r\n")
    end
    
    typesig { [DataOutputStream] }
    # Writes the current attributes to the specified data output stream,
    # make sure to write out the MANIFEST_VERSION or SIGNATURE_VERSION
    # attributes first.
    # 
    # XXX Need to handle UTF8 values and break up lines longer than 72 bytes
    def write_main(out)
      # write out the *-Version header first, if it exists
      vername = Name::MANIFEST_VERSION.to_s
      version = get_value(vername)
      if ((version).nil?)
        vername = (Name::SIGNATURE_VERSION.to_s).to_s
        version = (get_value(vername)).to_s
      end
      if (!(version).nil?)
        out.write_bytes(vername + ": " + version + "\r\n")
      end
      # write out all attributes except for the version
      # we wrote out earlier
      it = entry_set.iterator
      while (it.has_next)
        e = it.next
        name = (e.get_key).to_s
        if ((!(version).nil?) && !(name.equals_ignore_case(vername)))
          buffer = StringBuffer.new(name)
          buffer.append(": ")
          value = e.get_value
          if (!(value).nil?)
            vb = value.get_bytes("UTF8")
            value = (String.new(vb, 0, 0, vb.attr_length)).to_s
          end
          buffer.append(value)
          buffer.append("\r\n")
          Manifest.make72_safe(buffer)
          out.write_bytes(buffer.to_s)
        end
      end
      out.write_bytes("\r\n")
    end
    
    typesig { [Manifest::FastInputStream, Array.typed(::Java::Byte)] }
    # Reads attributes from the specified input stream.
    # XXX Need to handle UTF8 values.
    def read(is, lbuf)
      name = nil
      value = nil
      lastline = nil
      len = 0
      while (!((len = is.read_line(lbuf))).equal?(-1))
        line_continued = false
        if (!(lbuf[(len -= 1)]).equal?(Character.new(?\n.ord)))
          raise IOException.new("line too long")
        end
        if (len > 0 && (lbuf[len - 1]).equal?(Character.new(?\r.ord)))
          (len -= 1)
        end
        if ((len).equal?(0))
          break
        end
        i = 0
        if ((lbuf[0]).equal?(Character.new(?\s.ord)))
          # continuation of previous line
          if ((name).nil?)
            raise IOException.new("misplaced continuation line")
          end
          line_continued = true
          buf = Array.typed(::Java::Byte).new(lastline.attr_length + len - 1) { 0 }
          System.arraycopy(lastline, 0, buf, 0, lastline.attr_length)
          System.arraycopy(lbuf, 1, buf, lastline.attr_length, len - 1)
          if ((is.peek).equal?(Character.new(?\s.ord)))
            lastline = buf
            next
          end
          value = (String.new(buf, 0, buf.attr_length, "UTF8")).to_s
          lastline = nil
        else
          while (!(lbuf[((i += 1) - 1)]).equal?(Character.new(?:.ord)))
            if (i >= len)
              raise IOException.new("invalid header field")
            end
          end
          if (!(lbuf[((i += 1) - 1)]).equal?(Character.new(?\s.ord)))
            raise IOException.new("invalid header field")
          end
          name = (String.new(lbuf, 0, 0, i - 2)).to_s
          if ((is.peek).equal?(Character.new(?\s.ord)))
            lastline = Array.typed(::Java::Byte).new(len - i) { 0 }
            System.arraycopy(lbuf, i, lastline, 0, len - i)
            next
          end
          value = (String.new(lbuf, i, len - i, "UTF8")).to_s
        end
        begin
          if ((!(put_value(name, value)).nil?) && (!line_continued))
            Logger.get_logger("java.util.jar").warning("Duplicate name in Manifest: " + name + ".\n" + "Ensure that the manifest does not " + "have duplicate entries, and\n" + "that blank lines separate " + "individual sections in both your\n" + "manifest and in the META-INF/MANIFEST.MF " + "entry in the jar file.")
          end
        rescue IllegalArgumentException => e
          raise IOException.new("invalid header field name: " + name)
        end
      end
    end
    
    class_module.module_eval {
      # The Attributes.Name class represents an attribute name stored in
      # this Map. Valid attribute names are case-insensitive, are restricted
      # to the ASCII characters in the set [0-9a-zA-Z_-], and cannot exceed
      # 70 characters in length. Attribute values can contain any characters
      # and will be UTF8-encoded when written to the output stream.  See the
      # <a href="../../../../technotes/guides/jar/jar.html">JAR File Specification</a>
      # for more information about valid attribute names and values.
      const_set_lazy(:Name) { Class.new do
        include_class_members Attributes
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :hash_code
        alias_method :attr_hash_code, :hash_code
        undef_method :hash_code
        alias_method :attr_hash_code=, :hash_code=
        undef_method :hash_code=
        
        typesig { [String] }
        # Constructs a new attribute name using the given string name.
        # 
        # @param name the attribute string name
        # @exception IllegalArgumentException if the attribute name was
        # invalid
        # @exception NullPointerException if the attribute name was null
        def initialize(name)
          @name = nil
          @hash_code = -1
          if ((name).nil?)
            raise NullPointerException.new("name")
          end
          if (!is_valid(name))
            raise IllegalArgumentException.new(name)
          end
          @name = name.intern
        end
        
        class_module.module_eval {
          typesig { [String] }
          def is_valid(name)
            len = name.length
            if (len > 70 || (len).equal?(0))
              return false
            end
            i = 0
            while i < len
              if (!is_valid(name.char_at(i)))
                return false
              end
              ((i += 1) - 1)
            end
            return true
          end
          
          typesig { [::Java::Char] }
          def is_valid(c)
            return is_alpha(c) || is_digit(c) || (c).equal?(Character.new(?_.ord)) || (c).equal?(Character.new(?-.ord))
          end
          
          typesig { [::Java::Char] }
          def is_alpha(c)
            return (c >= Character.new(?a.ord) && c <= Character.new(?z.ord)) || (c >= Character.new(?A.ord) && c <= Character.new(?Z.ord))
          end
          
          typesig { [::Java::Char] }
          def is_digit(c)
            return c >= Character.new(?0.ord) && c <= Character.new(?9.ord)
          end
        }
        
        typesig { [Object] }
        # Compares this attribute name to another for equality.
        # @param o the object to compare
        # @return true if this attribute name is equal to the
        # specified attribute object
        def equals(o)
          if (o.is_a?(Name))
            c = ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER
            return (c.compare(@name, (o).attr_name)).equal?(0)
          else
            return false
          end
        end
        
        typesig { [] }
        # Computes the hash value for this attribute name.
        def hash_code
          if ((@hash_code).equal?(-1))
            @hash_code = ASCIICaseInsensitiveComparator.lower_case_hash_code(@name)
          end
          return @hash_code
        end
        
        typesig { [] }
        # Returns the attribute name as a String.
        def to_s
          return @name
        end
        
        class_module.module_eval {
          # <code>Name</code> object for <code>Manifest-Version</code>
          # manifest attribute. This attribute indicates the version number
          # of the manifest standard to which a JAR file's manifest conforms.
          # @see <a href="../../../../technotes/guides/jar/jar.html#JAR Manifest">
          # Manifest and Signature Specification</a>
          const_set_lazy(:MANIFEST_VERSION) { Name.new("Manifest-Version") }
          const_attr_reader  :MANIFEST_VERSION
          
          # <code>Name</code> object for <code>Signature-Version</code>
          # manifest attribute used when signing JAR files.
          # @see <a href="../../../../technotes/guides/jar/jar.html#JAR Manifest">
          # Manifest and Signature Specification</a>
          const_set_lazy(:SIGNATURE_VERSION) { Name.new("Signature-Version") }
          const_attr_reader  :SIGNATURE_VERSION
          
          # <code>Name</code> object for <code>Content-Type</code>
          # manifest attribute.
          const_set_lazy(:CONTENT_TYPE) { Name.new("Content-Type") }
          const_attr_reader  :CONTENT_TYPE
          
          # <code>Name</code> object for <code>Class-Path</code>
          # manifest attribute. Bundled extensions can use this attribute
          # to find other JAR files containing needed classes.
          # @see <a href="../../../../technotes/guides/extensions/spec.html#bundled">
          # Extensions Specification</a>
          const_set_lazy(:CLASS_PATH) { Name.new("Class-Path") }
          const_attr_reader  :CLASS_PATH
          
          # <code>Name</code> object for <code>Main-Class</code> manifest
          # attribute used for launching applications packaged in JAR files.
          # The <code>Main-Class</code> attribute is used in conjunction
          # with the <code>-jar</code> command-line option of the
          # <tt>java</tt> application launcher.
          const_set_lazy(:MAIN_CLASS) { Name.new("Main-Class") }
          const_attr_reader  :MAIN_CLASS
          
          # <code>Name</code> object for <code>Sealed</code> manifest attribute
          # used for sealing.
          # @see <a href="../../../../technotes/guides/extensions/spec.html#sealing">
          # Extension Sealing</a>
          const_set_lazy(:SEALED) { Name.new("Sealed") }
          const_attr_reader  :SEALED
          
          # <code>Name</code> object for <code>Extension-List</code> manifest attribute
          # used for declaring dependencies on installed extensions.
          # @see <a href="../../../../technotes/guides/extensions/spec.html#dependency">
          # Installed extension dependency</a>
          const_set_lazy(:EXTENSION_LIST) { Name.new("Extension-List") }
          const_attr_reader  :EXTENSION_LIST
          
          # <code>Name</code> object for <code>Extension-Name</code> manifest attribute
          # used for declaring dependencies on installed extensions.
          # @see <a href="../../../../technotes/guides/extensions/spec.html#dependency">
          # Installed extension dependency</a>
          const_set_lazy(:EXTENSION_NAME) { Name.new("Extension-Name") }
          const_attr_reader  :EXTENSION_NAME
          
          # <code>Name</code> object for <code>Extension-Name</code> manifest attribute
          # used for declaring dependencies on installed extensions.
          # @see <a href="../../../../technotes/guides/extensions/spec.html#dependency">
          # Installed extension dependency</a>
          const_set_lazy(:EXTENSION_INSTALLATION) { Name.new("Extension-Installation") }
          const_attr_reader  :EXTENSION_INSTALLATION
          
          # <code>Name</code> object for <code>Implementation-Title</code>
          # manifest attribute used for package versioning.
          # @see <a href="../../../../technotes/guides/versioning/spec/versioning2.html#wp90779">
          # Java Product Versioning Specification</a>
          const_set_lazy(:IMPLEMENTATION_TITLE) { Name.new("Implementation-Title") }
          const_attr_reader  :IMPLEMENTATION_TITLE
          
          # <code>Name</code> object for <code>Implementation-Version</code>
          # manifest attribute used for package versioning.
          # @see <a href="../../../../technotes/guides/versioning/spec/versioning2.html#wp90779">
          # Java Product Versioning Specification</a>
          const_set_lazy(:IMPLEMENTATION_VERSION) { Name.new("Implementation-Version") }
          const_attr_reader  :IMPLEMENTATION_VERSION
          
          # <code>Name</code> object for <code>Implementation-Vendor</code>
          # manifest attribute used for package versioning.
          # @see <a href="../../../../technotes/guides/versioning/spec/versioning2.html#wp90779">
          # Java Product Versioning Specification</a>
          const_set_lazy(:IMPLEMENTATION_VENDOR) { Name.new("Implementation-Vendor") }
          const_attr_reader  :IMPLEMENTATION_VENDOR
          
          # <code>Name</code> object for <code>Implementation-Vendor-Id</code>
          # manifest attribute used for package versioning.
          # @see <a href="../../../../technotes/guides/versioning/spec/versioning2.html#wp90779">
          # Java Product Versioning Specification</a>
          const_set_lazy(:IMPLEMENTATION_VENDOR_ID) { Name.new("Implementation-Vendor-Id") }
          const_attr_reader  :IMPLEMENTATION_VENDOR_ID
          
          # <code>Name</code> object for <code>Implementation-Vendor-URL</code>
          # manifest attribute used for package versioning.
          # @see <a href="../../../../technotes/guides/versioning/spec/versioning2.html#wp90779">
          # Java Product Versioning Specification</a>
          const_set_lazy(:IMPLEMENTATION_URL) { Name.new("Implementation-URL") }
          const_attr_reader  :IMPLEMENTATION_URL
          
          # <code>Name</code> object for <code>Specification-Title</code>
          # manifest attribute used for package versioning.
          # @see <a href="../../../../technotes/guides/versioning/spec/versioning2.html#wp90779">
          # Java Product Versioning Specification</a>
          const_set_lazy(:SPECIFICATION_TITLE) { Name.new("Specification-Title") }
          const_attr_reader  :SPECIFICATION_TITLE
          
          # <code>Name</code> object for <code>Specification-Version</code>
          # manifest attribute used for package versioning.
          # @see <a href="../../../../technotes/guides/versioning/spec/versioning2.html#wp90779">
          # Java Product Versioning Specification</a>
          const_set_lazy(:SPECIFICATION_VERSION) { Name.new("Specification-Version") }
          const_attr_reader  :SPECIFICATION_VERSION
          
          # <code>Name</code> object for <code>Specification-Vendor</code>
          # manifest attribute used for package versioning.
          # @see <a href="../../../../technotes/guides/versioning/spec/versioning2.html#wp90779">
          # Java Product Versioning Specification</a>
          const_set_lazy(:SPECIFICATION_VENDOR) { Name.new("Specification-Vendor") }
          const_attr_reader  :SPECIFICATION_VENDOR
        }
        
        private
        alias_method :initialize__name, :initialize
      end }
    }
    
    private
    alias_method :initialize__attributes, :initialize
  end
  
end
