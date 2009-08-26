require "rjava"

# Copyright 2000-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio::Charset
  module CharsetImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Charset
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset::Spi, :CharsetProvider
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :AccessControlException
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :Iterator
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :Map
      include_const ::Java::Util, :NoSuchElementException
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util, :ServiceLoader
      include_const ::Java::Util, :ServiceConfigurationError
      include_const ::Java::Util, :SortedMap
      include_const ::Java::Util, :TreeMap
      include_const ::Sun::Misc, :ASCIICaseInsensitiveComparator
      include_const ::Sun::Nio::Cs, :StandardCharsets
      include_const ::Sun::Nio::Cs, :ThreadLocalCoders
      include_const ::Sun::Security::Action, :GetPropertyAction
    }
  end
  
  # A named mapping between sequences of sixteen-bit Unicode <a
  # href="../../lang/Character.html#unicode">code units</a> and sequences of
  # bytes.  This class defines methods for creating decoders and encoders and
  # for retrieving the various names associated with a charset.  Instances of
  # this class are immutable.
  # 
  # <p> This class also defines static methods for testing whether a particular
  # charset is supported, for locating charset instances by name, and for
  # constructing a map that contains every charset for which support is
  # available in the current Java virtual machine.  Support for new charsets can
  # be added via the service-provider interface defined in the {@link
  # java.nio.charset.spi.CharsetProvider} class.
  # 
  # <p> All of the methods defined in this class are safe for use by multiple
  # concurrent threads.
  # 
  # 
  # <a name="names"><a name="charenc">
  # <h4>Charset names</h4>
  # 
  # <p> Charsets are named by strings composed of the following characters:
  # 
  # <ul>
  # 
  # <li> The uppercase letters <tt>'A'</tt> through <tt>'Z'</tt>
  # (<tt>'&#92;u0041'</tt>&nbsp;through&nbsp;<tt>'&#92;u005a'</tt>),
  # 
  # <li> The lowercase letters <tt>'a'</tt> through <tt>'z'</tt>
  # (<tt>'&#92;u0061'</tt>&nbsp;through&nbsp;<tt>'&#92;u007a'</tt>),
  # 
  # <li> The digits <tt>'0'</tt> through <tt>'9'</tt>
  # (<tt>'&#92;u0030'</tt>&nbsp;through&nbsp;<tt>'&#92;u0039'</tt>),
  # 
  # <li> The dash character <tt>'-'</tt>
  # (<tt>'&#92;u002d'</tt>,&nbsp;<small>HYPHEN-MINUS</small>),
  # 
  # <li> The period character <tt>'.'</tt>
  # (<tt>'&#92;u002e'</tt>,&nbsp;<small>FULL STOP</small>),
  # 
  # <li> The colon character <tt>':'</tt>
  # (<tt>'&#92;u003a'</tt>,&nbsp;<small>COLON</small>), and
  # 
  # <li> The underscore character <tt>'_'</tt>
  # (<tt>'&#92;u005f'</tt>,&nbsp;<small>LOW&nbsp;LINE</small>).
  # 
  # </ul>
  # 
  # A charset name must begin with either a letter or a digit.  The empty string
  # is not a legal charset name.  Charset names are not case-sensitive; that is,
  # case is always ignored when comparing charset names.  Charset names
  # generally follow the conventions documented in <a
  # href="http://www.ietf.org/rfc/rfc2278.txt"><i>RFC&nbsp;2278:&nbsp;IANA Charset
  # Registration Procedures</i></a>.
  # 
  # <p> Every charset has a <i>canonical name</i> and may also have one or more
  # <i>aliases</i>.  The canonical name is returned by the {@link #name() name} method
  # of this class.  Canonical names are, by convention, usually in upper case.
  # The aliases of a charset are returned by the {@link #aliases() aliases}
  # method.
  # 
  # <a name="hn">
  # 
  # <p> Some charsets have an <i>historical name</i> that is defined for
  # compatibility with previous versions of the Java platform.  A charset's
  # historical name is either its canonical name or one of its aliases.  The
  # historical name is returned by the <tt>getEncoding()</tt> methods of the
  # {@link java.io.InputStreamReader#getEncoding InputStreamReader} and {@link
  # java.io.OutputStreamWriter#getEncoding OutputStreamWriter} classes.
  # 
  # <a name="iana">
  # 
  # <p> If a charset listed in the <a
  # href="http://www.iana.org/assignments/character-sets"><i>IANA Charset
  # Registry</i></a> is supported by an implementation of the Java platform then
  # its canonical name must be the name listed in the registry.  Many charsets
  # are given more than one name in the registry, in which case the registry
  # identifies one of the names as <i>MIME-preferred</i>.  If a charset has more
  # than one registry name then its canonical name must be the MIME-preferred
  # name and the other names in the registry must be valid aliases.  If a
  # supported charset is not listed in the IANA registry then its canonical name
  # must begin with one of the strings <tt>"X-"</tt> or <tt>"x-"</tt>.
  # 
  # <p> The IANA charset registry does change over time, and so the canonical
  # name and the aliases of a particular charset may also change over time.  To
  # ensure compatibility it is recommended that no alias ever be removed from a
  # charset, and that if the canonical name of a charset is changed then its
  # previous canonical name be made into an alias.
  # 
  # 
  # <h4>Standard charsets</h4>
  # 
  # <p> Every implementation of the Java platform is required to support the
  # following standard charsets.  Consult the release documentation for your
  # implementation to see if any other charsets are supported.  The behavior
  # of such optional charsets may differ between implementations.
  # 
  # <blockquote><table width="80%" summary="Description of standard charsets">
  # <tr><th><p align="left">Charset</p></th><th><p align="left">Description</p></th></tr>
  # <tr><td valign=top><tt>US-ASCII</tt></td>
  # <td>Seven-bit ASCII, a.k.a. <tt>ISO646-US</tt>,
  # a.k.a. the Basic Latin block of the Unicode character set</td></tr>
  # <tr><td valign=top><tt>ISO-8859-1&nbsp;&nbsp;</tt></td>
  # <td>ISO Latin Alphabet No. 1, a.k.a. <tt>ISO-LATIN-1</tt></td></tr>
  # <tr><td valign=top><tt>UTF-8</tt></td>
  # <td>Eight-bit UCS Transformation Format</td></tr>
  # <tr><td valign=top><tt>UTF-16BE</tt></td>
  # <td>Sixteen-bit UCS Transformation Format,
  # big-endian byte&nbsp;order</td></tr>
  # <tr><td valign=top><tt>UTF-16LE</tt></td>
  # <td>Sixteen-bit UCS Transformation Format,
  # little-endian byte&nbsp;order</td></tr>
  # <tr><td valign=top><tt>UTF-16</tt></td>
  # <td>Sixteen-bit UCS Transformation Format,
  # byte&nbsp;order identified by an optional byte-order mark</td></tr>
  # </table></blockquote>
  # 
  # <p> The <tt>UTF-8</tt> charset is specified by <a
  # href="http://www.ietf.org/rfc/rfc2279.txt"><i>RFC&nbsp;2279</i></a>; the
  # transformation format upon which it is based is specified in
  # Amendment&nbsp;2 of ISO&nbsp;10646-1 and is also described in the <a
  # href="http://www.unicode.org/unicode/standard/standard.html"><i>Unicode
  # Standard</i></a>.
  # 
  # <p> The <tt>UTF-16</tt> charsets are specified by <a
  # href="http://www.ietf.org/rfc/rfc2781.txt"><i>RFC&nbsp;2781</i></a>; the
  # transformation formats upon which they are based are specified in
  # Amendment&nbsp;1 of ISO&nbsp;10646-1 and are also described in the <a
  # href="http://www.unicode.org/unicode/standard/standard.html"><i>Unicode
  # Standard</i></a>.
  # 
  # <p> The <tt>UTF-16</tt> charsets use sixteen-bit quantities and are
  # therefore sensitive to byte order.  In these encodings the byte order of a
  # stream may be indicated by an initial <i>byte-order mark</i> represented by
  # the Unicode character <tt>'&#92;uFEFF'</tt>.  Byte-order marks are handled
  # as follows:
  # 
  # <ul>
  # 
  # <li><p> When decoding, the <tt>UTF-16BE</tt> and <tt>UTF-16LE</tt>
  # charsets ignore byte-order marks; when encoding, they do not write
  # byte-order marks. </p></li>
  # 
  # <li><p> When decoding, the <tt>UTF-16</tt> charset interprets a byte-order
  # mark to indicate the byte order of the stream but defaults to big-endian
  # if there is no byte-order mark; when encoding, it uses big-endian byte
  # order and writes a big-endian byte-order mark. </p></li>
  # 
  # </ul>
  # 
  # In any case, when a byte-order mark is read at the beginning of a decoding
  # operation it is omitted from the resulting sequence of characters.  Byte
  # order marks occuring after the first element of an input sequence are not
  # omitted since the same code is used to represent <small>ZERO-WIDTH
  # NON-BREAKING SPACE</small>.
  # 
  # <p> Every instance of the Java virtual machine has a default charset, which
  # may or may not be one of the standard charsets.  The default charset is
  # determined during virtual-machine startup and typically depends upon the
  # locale and charset being used by the underlying operating system. </p>
  # 
  # 
  # <h4>Terminology</h4>
  # 
  # <p> The name of this class is taken from the terms used in <a
  # href="http://www.ietf.org/rfc/rfc2278.txt""><i>RFC&nbsp;2278</i></a>.  In that
  # document a <i>charset</i> is defined as the combination of a coded character
  # set and a character-encoding scheme.
  # 
  # <p> A <i>coded character set</i> is a mapping between a set of abstract
  # characters and a set of integers.  US-ASCII, ISO&nbsp;8859-1,
  # JIS&nbsp;X&nbsp;0201, and full Unicode, which is the same as
  # ISO&nbsp;10646-1, are examples of coded character sets.
  # 
  # <p> A <i>character-encoding scheme</i> is a mapping between a coded
  # character set and a set of octet (eight-bit byte) sequences.  UTF-8, UCS-2,
  # UTF-16, ISO&nbsp;2022, and EUC are examples of character-encoding schemes.
  # Encoding schemes are often associated with a particular coded character set;
  # UTF-8, for example, is used only to encode Unicode.  Some schemes, however,
  # are associated with multiple character sets; EUC, for example, can be used
  # to encode characters in a variety of Asian character sets.
  # 
  # <p> When a coded character set is used exclusively with a single
  # character-encoding scheme then the corresponding charset is usually named
  # for the character set; otherwise a charset is usually named for the encoding
  # scheme and, possibly, the locale of the character sets that it supports.
  # Hence <tt>US-ASCII</tt> is the name of the charset for US-ASCII while
  # <tt>EUC-JP</tt> is the name of the charset that encodes the
  # JIS&nbsp;X&nbsp;0201, JIS&nbsp;X&nbsp;0208, and JIS&nbsp;X&nbsp;0212
  # character sets.
  # 
  # <p> The native character encoding of the Java programming language is
  # UTF-16.  A charset in the Java platform therefore defines a mapping between
  # sequences of sixteen-bit UTF-16 code units and sequences of bytes. </p>
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  # 
  # @see CharsetDecoder
  # @see CharsetEncoder
  # @see java.nio.charset.spi.CharsetProvider
  # @see java.lang.Character
  class Charset 
    include_class_members CharsetImports
    include JavaComparable
    
    class_module.module_eval {
      # -- Static methods --
      
      def bug_level
        defined?(@@bug_level) ? @@bug_level : @@bug_level= nil
      end
      alias_method :attr_bug_level, :bug_level
      
      def bug_level=(value)
        @@bug_level = value
      end
      alias_method :attr_bug_level=, :bug_level=
      
      typesig { [String] }
      def at_bug_level(bl)
        # package-private
        if ((self.attr_bug_level).nil?)
          if (!Sun::Misc::VM.is_booted)
            return false
          end
          self.attr_bug_level = RJava.cast_to_string(AccessController.do_privileged(GetPropertyAction.new("sun.nio.cs.bugLevel")))
          if ((self.attr_bug_level).nil?)
            self.attr_bug_level = ""
          end
        end
        return (!(self.attr_bug_level).nil?) && (self.attr_bug_level == bl)
      end
      
      typesig { [String] }
      # Checks that the given string is a legal charset name. </p>
      # 
      # @param  s
      # A purported charset name
      # 
      # @throws  IllegalCharsetNameException
      # If the given name is not a legal charset name
      def check_name(s)
        n = s.length
        if (!at_bug_level("1.4"))
          if ((n).equal?(0))
            raise IllegalCharsetNameException.new(s)
          end
        end
        i = 0
        while i < n
          c = s.char_at(i)
          if (c >= Character.new(?A.ord) && c <= Character.new(?Z.ord))
            i += 1
            next
          end
          if (c >= Character.new(?a.ord) && c <= Character.new(?z.ord))
            i += 1
            next
          end
          if (c >= Character.new(?0.ord) && c <= Character.new(?9.ord))
            i += 1
            next
          end
          if ((c).equal?(Character.new(?-.ord)) && !(i).equal?(0))
            i += 1
            next
          end
          if ((c).equal?(Character.new(?:.ord)) && !(i).equal?(0))
            i += 1
            next
          end
          if ((c).equal?(Character.new(?_.ord)) && !(i).equal?(0))
            i += 1
            next
          end
          if ((c).equal?(Character.new(?..ord)) && !(i).equal?(0))
            i += 1
            next
          end
          raise IllegalCharsetNameException.new(s)
          i += 1
        end
      end
      
      # The standard set of charsets
      
      def standard_provider
        defined?(@@standard_provider) ? @@standard_provider : @@standard_provider= StandardCharsets.new
      end
      alias_method :attr_standard_provider, :standard_provider
      
      def standard_provider=(value)
        @@standard_provider = value
      end
      alias_method :attr_standard_provider=, :standard_provider=
      
      # Cache of the most-recently-returned charsets,
      # along with the names that were used to find them
      
      def cache1
        defined?(@@cache1) ? @@cache1 : @@cache1= nil
      end
      alias_method :attr_cache1, :cache1
      
      def cache1=(value)
        @@cache1 = value
      end
      alias_method :attr_cache1=, :cache1=
      
      # "Level 1" cache
      
      def cache2
        defined?(@@cache2) ? @@cache2 : @@cache2= nil
      end
      alias_method :attr_cache2, :cache2
      
      def cache2=(value)
        @@cache2 = value
      end
      alias_method :attr_cache2=, :cache2=
      
      typesig { [String, Charset] }
      # "Level 2" cache
      def cache(charset_name, cs)
        self.attr_cache2 = self.attr_cache1
        self.attr_cache1 = Array.typed(Object).new([charset_name, cs])
      end
      
      typesig { [] }
      # Creates an iterator that walks over the available providers, ignoring
      # those whose lookup or instantiation causes a security exception to be
      # thrown.  Should be invoked with full privileges.
      def providers
        return Class.new(Iterator.class == Class ? Iterator : Object) do
          extend LocalClass
          include_class_members Charset
          include Iterator if Iterator.class == Module
          
          attr_accessor :cl
          alias_method :attr_cl, :cl
          undef_method :cl
          alias_method :attr_cl=, :cl=
          undef_method :cl=
          
          attr_accessor :sl
          alias_method :attr_sl, :sl
          undef_method :sl
          alias_method :attr_sl=, :sl=
          undef_method :sl=
          
          attr_accessor :i
          alias_method :attr_i, :i
          undef_method :i
          alias_method :attr_i=, :i=
          undef_method :i=
          
          attr_accessor :next
          alias_method :attr_next, :next
          undef_method :next
          alias_method :attr_next=, :next=
          undef_method :next=
          
          typesig { [] }
          define_method :get_next do
            while ((@next).nil?)
              begin
                if (!@i.has_next)
                  return false
                end
                @next = @i.next_
              rescue self.class::ServiceConfigurationError => sce
                if (sce.get_cause.is_a?(self.class::SecurityException))
                  # Ignore security exceptions
                  next
                end
                raise sce
              end
            end
            return true
          end
          
          typesig { [] }
          define_method :has_next do
            return get_next
          end
          
          typesig { [] }
          define_method :next_ do
            if (!get_next)
              raise self.class::NoSuchElementException.new
            end
            n = @next
            @next = nil
            return n
          end
          
          typesig { [] }
          define_method :remove do
            raise self.class::UnsupportedOperationException.new
          end
          
          typesig { [] }
          define_method :initialize do
            @cl = nil
            @sl = nil
            @i = nil
            @next = nil
            super()
            @cl = ClassLoader.get_system_class_loader
            @sl = ServiceLoader.load(CharsetProvider, @cl)
            @i = @sl.iterator
            @next = nil
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self)
      end
      
      # Thread-local gate to prevent recursive provider lookups
      
      def gate
        defined?(@@gate) ? @@gate : @@gate= ThreadLocal.new
      end
      alias_method :attr_gate, :gate
      
      def gate=(value)
        @@gate = value
      end
      alias_method :attr_gate=, :gate=
      
      typesig { [String] }
      def lookup_via_providers(charset_name)
        # The runtime startup sequence looks up standard charsets as a
        # consequence of the VM's invocation of System.initializeSystemClass
        # in order to, e.g., set system properties and encode filenames.  At
        # that point the application class loader has not been initialized,
        # however, so we can't look for providers because doing so will cause
        # that loader to be prematurely initialized with incomplete
        # information.
        if (!Sun::Misc::VM.is_booted)
          return nil
        end
        if (!(self.attr_gate.get).nil?)
          # Avoid recursive provider lookups
          return nil
        end
        begin
          self.attr_gate.set(self.attr_gate)
          return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members Charset
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              i = providers
              while i.has_next
                cp = i.next_
                cs = cp.charset_for_name(charset_name)
                if (!(cs).nil?)
                  return cs
                end
              end
              return nil
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        ensure
          self.attr_gate.set(nil)
        end
      end
      
      # The extended set of charsets
      
      def extended_provider_lock
        defined?(@@extended_provider_lock) ? @@extended_provider_lock : @@extended_provider_lock= Object.new
      end
      alias_method :attr_extended_provider_lock, :extended_provider_lock
      
      def extended_provider_lock=(value)
        @@extended_provider_lock = value
      end
      alias_method :attr_extended_provider_lock=, :extended_provider_lock=
      
      
      def extended_provider_probed
        defined?(@@extended_provider_probed) ? @@extended_provider_probed : @@extended_provider_probed= false
      end
      alias_method :attr_extended_provider_probed, :extended_provider_probed
      
      def extended_provider_probed=(value)
        @@extended_provider_probed = value
      end
      alias_method :attr_extended_provider_probed=, :extended_provider_probed=
      
      
      def extended_provider
        defined?(@@extended_provider) ? @@extended_provider : @@extended_provider= nil
      end
      alias_method :attr_extended_provider, :extended_provider
      
      def extended_provider=(value)
        @@extended_provider = value
      end
      alias_method :attr_extended_provider=, :extended_provider=
      
      typesig { [] }
      def probe_extended_provider
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Charset
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            begin
              epc = Class.for_name("sun.nio.cs.ext.ExtendedCharsets")
              self.attr_extended_provider = epc.new_instance
            rescue self.class::ClassNotFoundException => x
              # Extended charsets not available
              # (charsets.jar not present)
            rescue self.class::InstantiationException => x
              raise self.class::JavaError.new(x)
            rescue self.class::IllegalAccessException => x
              raise self.class::JavaError.new(x)
            end
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [String] }
      def lookup_extended_charset(charset_name)
        ecp = nil
        synchronized((self.attr_extended_provider_lock)) do
          if (!self.attr_extended_provider_probed)
            probe_extended_provider
            self.attr_extended_provider_probed = true
          end
          ecp = self.attr_extended_provider
        end
        return (!(ecp).nil?) ? ecp.charset_for_name(charset_name) : nil
      end
      
      typesig { [String] }
      def lookup(charset_name)
        if ((charset_name).nil?)
          raise IllegalArgumentException.new("Null charset name")
        end
        a = nil
        if (!((a = self.attr_cache1)).nil? && (charset_name == a[0]))
          return a[1]
        end
        # We expect most programs to use one Charset repeatedly.
        # We convey a hint to this effect to the VM by putting the
        # level 1 cache miss code in a separate method.
        return lookup2(charset_name)
      end
      
      typesig { [String] }
      def lookup2(charset_name)
        a = nil
        if (!((a = self.attr_cache2)).nil? && (charset_name == a[0]))
          self.attr_cache2 = self.attr_cache1
          self.attr_cache1 = a
          return a[1]
        end
        cs = nil
        if (!((cs = self.attr_standard_provider.charset_for_name(charset_name))).nil? || !((cs = lookup_extended_charset(charset_name))).nil? || !((cs = lookup_via_providers(charset_name))).nil?)
          cache(charset_name, cs)
          return cs
        end
        # Only need to check the name if we didn't find a charset for it
        check_name(charset_name)
        return nil
      end
      
      typesig { [String] }
      # Tells whether the named charset is supported. </p>
      # 
      # @param  charsetName
      # The name of the requested charset; may be either
      # a canonical name or an alias
      # 
      # @return  <tt>true</tt> if, and only if, support for the named charset
      # is available in the current Java virtual machine
      # 
      # @throws IllegalCharsetNameException
      # If the given charset name is illegal
      # 
      # @throws  IllegalArgumentException
      # If the given <tt>charsetName</tt> is null
      def is_supported(charset_name)
        return (!(lookup(charset_name)).nil?)
      end
      
      typesig { [String] }
      # Returns a charset object for the named charset. </p>
      # 
      # @param  charsetName
      # The name of the requested charset; may be either
      # a canonical name or an alias
      # 
      # @return  A charset object for the named charset
      # 
      # @throws  IllegalCharsetNameException
      # If the given charset name is illegal
      # 
      # @throws  IllegalArgumentException
      # If the given <tt>charsetName</tt> is null
      # 
      # @throws  UnsupportedCharsetException
      # If no support for the named charset is available
      # in this instance of the Java virtual machine
      def for_name(charset_name)
        cs = lookup(charset_name)
        if (!(cs).nil?)
          return cs
        end
        raise UnsupportedCharsetException.new(charset_name)
      end
      
      typesig { [Iterator, Map] }
      # Fold charsets from the given iterator into the given map, ignoring
      # charsets whose names already have entries in the map.
      def put(i, m)
        while (i.has_next)
          cs = i.next_
          if (!m.contains_key(cs.name))
            m.put(cs.name, cs)
          end
        end
      end
      
      typesig { [] }
      # Constructs a sorted map from canonical charset names to charset objects.
      # 
      # <p> The map returned by this method will have one entry for each charset
      # for which support is available in the current Java virtual machine.  If
      # two or more supported charsets have the same canonical name then the
      # resulting map will contain just one of them; which one it will contain
      # is not specified. </p>
      # 
      # <p> The invocation of this method, and the subsequent use of the
      # resulting map, may cause time-consuming disk or network I/O operations
      # to occur.  This method is provided for applications that need to
      # enumerate all of the available charsets, for example to allow user
      # charset selection.  This method is not used by the {@link #forName
      # forName} method, which instead employs an efficient incremental lookup
      # algorithm.
      # 
      # <p> This method may return different results at different times if new
      # charset providers are dynamically made available to the current Java
      # virtual machine.  In the absence of such changes, the charsets returned
      # by this method are exactly those that can be retrieved via the {@link
      # #forName forName} method.  </p>
      # 
      # @return An immutable, case-insensitive map from canonical charset names
      # to charset objects
      def available_charsets
        return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members Charset
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            m = self.class::TreeMap.new(ASCIICaseInsensitiveComparator::CASE_INSENSITIVE_ORDER)
            put(self.attr_standard_provider.charsets, m)
            i = providers
            while i.has_next
              cp = i.next_
              put(cp.charsets, m)
            end
            return Collections.unmodifiable_sorted_map(m)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      
      def default_charset
        defined?(@@default_charset) ? @@default_charset : @@default_charset= nil
      end
      alias_method :attr_default_charset, :default_charset
      
      def default_charset=(value)
        @@default_charset = value
      end
      alias_method :attr_default_charset=, :default_charset=
      
      typesig { [] }
      # Returns the default charset of this Java virtual machine.
      # 
      # <p> The default charset is determined during virtual-machine startup and
      # typically depends upon the locale and charset of the underlying
      # operating system.
      # 
      # @return  A charset object for the default charset
      # 
      # @since 1.5
      def default_charset
        if ((self.attr_default_charset).nil?)
          synchronized((Charset)) do
            csn = AccessController.do_privileged(GetPropertyAction.new("file.encoding"))
            cs = lookup(csn)
            if (!(cs).nil?)
              self.attr_default_charset = cs
            else
              self.attr_default_charset = for_name("UTF-8")
            end
          end
        end
        return self.attr_default_charset
      end
    }
    
    # -- Instance fields and methods --
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # tickles a bug in oldjavac
    attr_accessor :aliases
    alias_method :attr_aliases, :aliases
    undef_method :aliases
    alias_method :attr_aliases=, :aliases=
    undef_method :aliases=
    
    # tickles a bug in oldjavac
    attr_accessor :alias_set
    alias_method :attr_alias_set, :alias_set
    undef_method :alias_set
    alias_method :attr_alias_set=, :alias_set=
    undef_method :alias_set=
    
    typesig { [String, Array.typed(String)] }
    # Initializes a new charset with the given canonical name and alias
    # set. </p>
    # 
    # @param  canonicalName
    # The canonical name of this charset
    # 
    # @param  aliases
    # An array of this charset's aliases, or null if it has no aliases
    # 
    # @throws IllegalCharsetNameException
    # If the canonical name or any of the aliases are illegal
    def initialize(canonical_name, aliases)
      @name = nil
      @aliases = nil
      @alias_set = nil
      check_name(canonical_name)
      as = ((aliases).nil?) ? Array.typed(String).new(0) { nil } : aliases
      i = 0
      while i < as.attr_length
        check_name(as[i])
        i += 1
      end
      @name = canonical_name
      @aliases = as
    end
    
    typesig { [] }
    # Returns this charset's canonical name. </p>
    # 
    # @return  The canonical name of this charset
    def name
      return @name
    end
    
    typesig { [] }
    # Returns a set containing this charset's aliases. </p>
    # 
    # @return  An immutable set of this charset's aliases
    def aliases
      if (!(@alias_set).nil?)
        return @alias_set
      end
      n = @aliases.attr_length
      hs = HashSet.new(n)
      i = 0
      while i < n
        hs.add(@aliases[i])
        i += 1
      end
      @alias_set = Collections.unmodifiable_set(hs)
      return @alias_set
    end
    
    typesig { [] }
    # Returns this charset's human-readable name for the default locale.
    # 
    # <p> The default implementation of this method simply returns this
    # charset's canonical name.  Concrete subclasses of this class may
    # override this method in order to provide a localized display name. </p>
    # 
    # @return  The display name of this charset in the default locale
    def display_name
      return @name
    end
    
    typesig { [] }
    # Tells whether or not this charset is registered in the <a
    # href="http://www.iana.org/assignments/character-sets">IANA Charset
    # Registry</a>.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this charset is known by its
    # implementor to be registered with the IANA
    def is_registered
      return !@name.starts_with("X-") && !@name.starts_with("x-")
    end
    
    typesig { [Locale] }
    # Returns this charset's human-readable name for the given locale.
    # 
    # <p> The default implementation of this method simply returns this
    # charset's canonical name.  Concrete subclasses of this class may
    # override this method in order to provide a localized display name. </p>
    # 
    # @param  locale
    # The locale for which the display name is to be retrieved
    # 
    # @return  The display name of this charset in the given locale
    def display_name(locale)
      return @name
    end
    
    typesig { [Charset] }
    # Tells whether or not this charset contains the given charset.
    # 
    # <p> A charset <i>C</i> is said to <i>contain</i> a charset <i>D</i> if,
    # and only if, every character representable in <i>D</i> is also
    # representable in <i>C</i>.  If this relationship holds then it is
    # guaranteed that every string that can be encoded in <i>D</i> can also be
    # encoded in <i>C</i> without performing any replacements.
    # 
    # <p> That <i>C</i> contains <i>D</i> does not imply that each character
    # representable in <i>C</i> by a particular byte sequence is represented
    # in <i>D</i> by the same byte sequence, although sometimes this is the
    # case.
    # 
    # <p> Every charset contains itself.
    # 
    # <p> This method computes an approximation of the containment relation:
    # If it returns <tt>true</tt> then the given charset is known to be
    # contained by this charset; if it returns <tt>false</tt>, however, then
    # it is not necessarily the case that the given charset is not contained
    # in this charset.
    # 
    # @return  <tt>true</tt> if the given charset is contained in this charset
    def contains(cs)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Constructs a new decoder for this charset. </p>
    # 
    # @return  A new decoder for this charset
    def new_decoder
      raise NotImplementedError
    end
    
    typesig { [] }
    # Constructs a new encoder for this charset. </p>
    # 
    # @return  A new encoder for this charset
    # 
    # @throws  UnsupportedOperationException
    # If this charset does not support encoding
    def new_encoder
      raise NotImplementedError
    end
    
    typesig { [] }
    # Tells whether or not this charset supports encoding.
    # 
    # <p> Nearly all charsets support encoding.  The primary exceptions are
    # special-purpose <i>auto-detect</i> charsets whose decoders can determine
    # which of several possible encoding schemes is in use by examining the
    # input byte sequence.  Such charsets do not support encoding because
    # there is no way to determine which encoding should be used on output.
    # Implementations of such charsets should override this method to return
    # <tt>false</tt>. </p>
    # 
    # @return  <tt>true</tt> if, and only if, this charset supports encoding
    def can_encode
      return true
    end
    
    typesig { [ByteBuffer] }
    # Convenience method that decodes bytes in this charset into Unicode
    # characters.
    # 
    # <p> An invocation of this method upon a charset <tt>cs</tt> returns the
    # same result as the expression
    # 
    # <pre>
    # cs.newDecoder()
    # .onMalformedInput(CodingErrorAction.REPLACE)
    # .onUnmappableCharacter(CodingErrorAction.REPLACE)
    # .decode(bb); </pre>
    # 
    # except that it is potentially more efficient because it can cache
    # decoders between successive invocations.
    # 
    # <p> This method always replaces malformed-input and unmappable-character
    # sequences with this charset's default replacement byte array.  In order
    # to detect such sequences, use the {@link
    # CharsetDecoder#decode(java.nio.ByteBuffer)} method directly.  </p>
    # 
    # @param  bb  The byte buffer to be decoded
    # 
    # @return  A char buffer containing the decoded characters
    def decode(bb)
      begin
        return ThreadLocalCoders.decoder_for(self).on_malformed_input(CodingErrorAction::REPLACE).on_unmappable_character(CodingErrorAction::REPLACE).decode(bb)
      rescue CharacterCodingException => x
        raise JavaError.new(x) # Can't happen
      end
    end
    
    typesig { [CharBuffer] }
    # Convenience method that encodes Unicode characters into bytes in this
    # charset.
    # 
    # <p> An invocation of this method upon a charset <tt>cs</tt> returns the
    # same result as the expression
    # 
    # <pre>
    # cs.newEncoder()
    # .onMalformedInput(CodingErrorAction.REPLACE)
    # .onUnmappableCharacter(CodingErrorAction.REPLACE)
    # .encode(bb); </pre>
    # 
    # except that it is potentially more efficient because it can cache
    # encoders between successive invocations.
    # 
    # <p> This method always replaces malformed-input and unmappable-character
    # sequences with this charset's default replacement string.  In order to
    # detect such sequences, use the {@link
    # CharsetEncoder#encode(java.nio.CharBuffer)} method directly.  </p>
    # 
    # @param  cb  The char buffer to be encoded
    # 
    # @return  A byte buffer containing the encoded characters
    def encode(cb)
      begin
        return ThreadLocalCoders.encoder_for(self).on_malformed_input(CodingErrorAction::REPLACE).on_unmappable_character(CodingErrorAction::REPLACE).encode(cb)
      rescue CharacterCodingException => x
        raise JavaError.new(x) # Can't happen
      end
    end
    
    typesig { [String] }
    # Convenience method that encodes a string into bytes in this charset.
    # 
    # <p> An invocation of this method upon a charset <tt>cs</tt> returns the
    # same result as the expression
    # 
    # <pre>
    # cs.encode(CharBuffer.wrap(s)); </pre>
    # 
    # @param  str  The string to be encoded
    # 
    # @return  A byte buffer containing the encoded characters
    def encode(str)
      return encode(CharBuffer.wrap(str))
    end
    
    typesig { [Charset] }
    # Compares this charset to another.
    # 
    # <p> Charsets are ordered by their canonical names, without regard to
    # case. </p>
    # 
    # @param  that
    # The charset to which this charset is to be compared
    # 
    # @return A negative integer, zero, or a positive integer as this charset
    # is less than, equal to, or greater than the specified charset
    def compare_to(that)
      return (name.compare_to_ignore_case(that.name))
    end
    
    typesig { [] }
    # Computes a hashcode for this charset. </p>
    # 
    # @return  An integer hashcode
    def hash_code
      return name.hash_code
    end
    
    typesig { [Object] }
    # Tells whether or not this object is equal to another.
    # 
    # <p> Two charsets are equal if, and only if, they have the same canonical
    # names.  A charset is never equal to any other type of object.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this charset is equal to the
    # given object
    def ==(ob)
      if (!(ob.is_a?(Charset)))
        return false
      end
      if ((self).equal?(ob))
        return true
      end
      return (@name == (ob).name)
    end
    
    typesig { [] }
    # Returns a string describing this charset. </p>
    # 
    # @return  A string describing this charset
    def to_s
      return name
    end
    
    private
    alias_method :initialize__charset, :initialize
  end
  
end
