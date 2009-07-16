require "rjava"

# 
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
module Java::Net
  module URIImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Net
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :InvalidObjectException
      include_const ::Java::Io, :ObjectInputStream
      include_const ::Java::Io, :ObjectOutputStream
      include_const ::Java::Io, :Serializable
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :CharBuffer
      include_const ::Java::Nio::Charset, :CharsetDecoder
      include_const ::Java::Nio::Charset, :CharsetEncoder
      include_const ::Java::Nio::Charset, :CoderResult
      include_const ::Java::Nio::Charset, :CodingErrorAction
      include_const ::Java::Nio::Charset, :CharacterCodingException
      include_const ::Java::Text, :Normalizer
      include_const ::Sun::Nio::Cs, :ThreadLocalCoders
      include_const ::Java::Lang, :Character
      include_const ::Java::Lang, :NullPointerException
    }
  end
  
  # for javadoc
  # for javadoc
  # 
  # Represents a Uniform Resource Identifier (URI) reference.
  # 
  # <p> Aside from some minor deviations noted below, an instance of this
  # class represents a URI reference as defined by
  # <a href="http://www.ietf.org/rfc/rfc2396.txt""><i>RFC&nbsp;2396: Uniform
  # Resource Identifiers (URI): Generic Syntax</i></a>, amended by <a
  # href="http://www.ietf.org/rfc/rfc2732.txt"><i>RFC&nbsp;2732: Format for
  # Literal IPv6 Addresses in URLs</i></a>. The Literal IPv6 address format
  # also supports scope_ids. The syntax and usage of scope_ids is described
  # <a href="Inet6Address.html#scoped">here</a>.
  # This class provides constructors for creating URI instances from
  # their components or by parsing their string forms, methods for accessing the
  # various components of an instance, and methods for normalizing, resolving,
  # and relativizing URI instances.  Instances of this class are immutable.
  # 
  # 
  # <h4> URI syntax and components </h4>
  # 
  # At the highest level a URI reference (hereinafter simply "URI") in string
  # form has the syntax
  # 
  # <blockquote>
  # [<i>scheme</i><tt><b>:</b></tt><i></i>]<i>scheme-specific-part</i>[<tt><b>#</b></tt><i>fragment</i>]
  # </blockquote>
  # 
  # where square brackets [...] delineate optional components and the characters
  # <tt><b>:</b></tt> and <tt><b>#</b></tt> stand for themselves.
  # 
  # <p> An <i>absolute</i> URI specifies a scheme; a URI that is not absolute is
  # said to be <i>relative</i>.  URIs are also classified according to whether
  # they are <i>opaque</i> or <i>hierarchical</i>.
  # 
  # <p> An <i>opaque</i> URI is an absolute URI whose scheme-specific part does
  # not begin with a slash character (<tt>'/'</tt>).  Opaque URIs are not
  # subject to further parsing.  Some examples of opaque URIs are:
  # 
  # <blockquote><table cellpadding=0 cellspacing=0 summary="layout">
  # <tr><td><tt>mailto:java-net@java.sun.com</tt><td></tr>
  # <tr><td><tt>news:comp.lang.java</tt><td></tr>
  # <tr><td><tt>urn:isbn:096139210x</tt></td></tr>
  # </table></blockquote>
  # 
  # <p> A <i>hierarchical</i> URI is either an absolute URI whose
  # scheme-specific part begins with a slash character, or a relative URI, that
  # is, a URI that does not specify a scheme.  Some examples of hierarchical
  # URIs are:
  # 
  # <blockquote>
  # <tt>http://java.sun.com/j2se/1.3/</tt><br>
  # <tt>docs/guide/collections/designfaq.html#28</tt><br>
  # <tt>../../../demo/jfc/SwingSet2/src/SwingSet2.java</tt><br>
  # <tt>file:///~/calendar</tt>
  # </blockquote>
  # 
  # <p> A hierarchical URI is subject to further parsing according to the syntax
  # 
  # <blockquote>
  # [<i>scheme</i><tt><b>:</b></tt>][<tt><b>//</b></tt><i>authority</i>][<i>path</i>][<tt><b>?</b></tt><i>query</i>][<tt><b>#</b></tt><i>fragment</i>]
  # </blockquote>
  # 
  # where the characters <tt><b>:</b></tt>, <tt><b>/</b></tt>,
  # <tt><b>?</b></tt>, and <tt><b>#</b></tt> stand for themselves.  The
  # scheme-specific part of a hierarchical URI consists of the characters
  # between the scheme and fragment components.
  # 
  # <p> The authority component of a hierarchical URI is, if specified, either
  # <i>server-based</i> or <i>registry-based</i>.  A server-based authority
  # parses according to the familiar syntax
  # 
  # <blockquote>
  # [<i>user-info</i><tt><b>@</b></tt>]<i>host</i>[<tt><b>:</b></tt><i>port</i>]
  # </blockquote>
  # 
  # where the characters <tt><b>@</b></tt> and <tt><b>:</b></tt> stand for
  # themselves.  Nearly all URI schemes currently in use are server-based.  An
  # authority component that does not parse in this way is considered to be
  # registry-based.
  # 
  # <p> The path component of a hierarchical URI is itself said to be absolute
  # if it begins with a slash character (<tt>'/'</tt>); otherwise it is
  # relative.  The path of a hierarchical URI that is either absolute or
  # specifies an authority is always absolute.
  # 
  # <p> All told, then, a URI instance has the following nine components:
  # 
  # <blockquote><table summary="Describes the components of a URI:scheme,scheme-specific-part,authority,user-info,host,port,path,query,fragment">
  # <tr><th><i>Component</i></th><th><i>Type</i></th></tr>
  # <tr><td>scheme</td><td><tt>String</tt></td></tr>
  # <tr><td>scheme-specific-part&nbsp;&nbsp;&nbsp;&nbsp;</td><td><tt>String</tt></td></tr>
  # <tr><td>authority</td><td><tt>String</tt></td></tr>
  # <tr><td>user-info</td><td><tt>String</tt></td></tr>
  # <tr><td>host</td><td><tt>String</tt></td></tr>
  # <tr><td>port</td><td><tt>int</tt></td></tr>
  # <tr><td>path</td><td><tt>String</tt></td></tr>
  # <tr><td>query</td><td><tt>String</tt></td></tr>
  # <tr><td>fragment</td><td><tt>String</tt></td></tr>
  # </table></blockquote>
  # 
  # In a given instance any particular component is either <i>undefined</i> or
  # <i>defined</i> with a distinct value.  Undefined string components are
  # represented by <tt>null</tt>, while undefined integer components are
  # represented by <tt>-1</tt>.  A string component may be defined to have the
  # empty string as its value; this is not equivalent to that component being
  # undefined.
  # 
  # <p> Whether a particular component is or is not defined in an instance
  # depends upon the type of the URI being represented.  An absolute URI has a
  # scheme component.  An opaque URI has a scheme, a scheme-specific part, and
  # possibly a fragment, but has no other components.  A hierarchical URI always
  # has a path (though it may be empty) and a scheme-specific-part (which at
  # least contains the path), and may have any of the other components.  If the
  # authority component is present and is server-based then the host component
  # will be defined and the user-information and port components may be defined.
  # 
  # 
  # <h4> Operations on URI instances </h4>
  # 
  # The key operations supported by this class are those of
  # <i>normalization</i>, <i>resolution</i>, and <i>relativization</i>.
  # 
  # <p> <i>Normalization</i> is the process of removing unnecessary <tt>"."</tt>
  # and <tt>".."</tt> segments from the path component of a hierarchical URI.
  # Each <tt>"."</tt> segment is simply removed.  A <tt>".."</tt> segment is
  # removed only if it is preceded by a non-<tt>".."</tt> segment.
  # Normalization has no effect upon opaque URIs.
  # 
  # <p> <i>Resolution</i> is the process of resolving one URI against another,
  # <i>base</i> URI.  The resulting URI is constructed from components of both
  # URIs in the manner specified by RFC&nbsp;2396, taking components from the
  # base URI for those not specified in the original.  For hierarchical URIs,
  # the path of the original is resolved against the path of the base and then
  # normalized.  The result, for example, of resolving
  # 
  # <blockquote>
  # <tt>docs/guide/collections/designfaq.html#28&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt>(1)
  # </blockquote>
  # 
  # against the base URI <tt>http://java.sun.com/j2se/1.3/</tt> is the result
  # URI
  # 
  # <blockquote>
  # <tt>http://java.sun.com/j2se/1.3/docs/guide/collections/designfaq.html#28</tt>
  # </blockquote>
  # 
  # Resolving the relative URI
  # 
  # <blockquote>
  # <tt>../../../demo/jfc/SwingSet2/src/SwingSet2.java&nbsp;&nbsp;&nbsp;&nbsp;</tt>(2)
  # </blockquote>
  # 
  # against this result yields, in turn,
  # 
  # <blockquote>
  # <tt>http://java.sun.com/j2se/1.3/demo/jfc/SwingSet2/src/SwingSet2.java</tt>
  # </blockquote>
  # 
  # Resolution of both absolute and relative URIs, and of both absolute and
  # relative paths in the case of hierarchical URIs, is supported.  Resolving
  # the URI <tt>file:///~calendar</tt> against any other URI simply yields the
  # original URI, since it is absolute.  Resolving the relative URI (2) above
  # against the relative base URI (1) yields the normalized, but still relative,
  # URI
  # 
  # <blockquote>
  # <tt>demo/jfc/SwingSet2/src/SwingSet2.java</tt>
  # </blockquote>
  # 
  # <p> <i>Relativization</i>, finally, is the inverse of resolution: For any
  # two normalized URIs <i>u</i> and&nbsp;<i>v</i>,
  # 
  # <blockquote>
  # <i>u</i><tt>.relativize(</tt><i>u</i><tt>.resolve(</tt><i>v</i><tt>)).equals(</tt><i>v</i><tt>)</tt>&nbsp;&nbsp;and<br>
  # <i>u</i><tt>.resolve(</tt><i>u</i><tt>.relativize(</tt><i>v</i><tt>)).equals(</tt><i>v</i><tt>)</tt>&nbsp;&nbsp;.<br>
  # </blockquote>
  # 
  # This operation is often useful when constructing a document containing URIs
  # that must be made relative to the base URI of the document wherever
  # possible.  For example, relativizing the URI
  # 
  # <blockquote>
  # <tt>http://java.sun.com/j2se/1.3/docs/guide/index.html</tt>
  # </blockquote>
  # 
  # against the base URI
  # 
  # <blockquote>
  # <tt>http://java.sun.com/j2se/1.3</tt>
  # </blockquote>
  # 
  # yields the relative URI <tt>docs/guide/index.html</tt>.
  # 
  # 
  # <h4> Character categories </h4>
  # 
  # RFC&nbsp;2396 specifies precisely which characters are permitted in the
  # various components of a URI reference.  The following categories, most of
  # which are taken from that specification, are used below to describe these
  # constraints:
  # 
  # <blockquote><table cellspacing=2 summary="Describes categories alpha,digit,alphanum,unreserved,punct,reserved,escaped,and other">
  # <tr><th valign=top><i>alpha</i></th>
  # <td>The US-ASCII alphabetic characters,
  # <tt>'A'</tt>&nbsp;through&nbsp;<tt>'Z'</tt>
  # and <tt>'a'</tt>&nbsp;through&nbsp;<tt>'z'</tt></td></tr>
  # <tr><th valign=top><i>digit</i></th>
  # <td>The US-ASCII decimal digit characters,
  # <tt>'0'</tt>&nbsp;through&nbsp;<tt>'9'</tt></td></tr>
  # <tr><th valign=top><i>alphanum</i></th>
  # <td>All <i>alpha</i> and <i>digit</i> characters</td></tr>
  # <tr><th valign=top><i>unreserved</i>&nbsp;&nbsp;&nbsp;&nbsp;</th>
  # <td>All <i>alphanum</i> characters together with those in the string
  # <tt>"_-!.~'()*"</tt></td></tr>
  # <tr><th valign=top><i>punct</i></th>
  # <td>The characters in the string <tt>",;:$&+="</tt></td></tr>
  # <tr><th valign=top><i>reserved</i></th>
  # <td>All <i>punct</i> characters together with those in the string
  # <tt>"?/[]@"</tt></td></tr>
  # <tr><th valign=top><i>escaped</i></th>
  # <td>Escaped octets, that is, triplets consisting of the percent
  # character (<tt>'%'</tt>) followed by two hexadecimal digits
  # (<tt>'0'</tt>-<tt>'9'</tt>, <tt>'A'</tt>-<tt>'F'</tt>, and
  # <tt>'a'</tt>-<tt>'f'</tt>)</td></tr>
  # <tr><th valign=top><i>other</i></th>
  # <td>The Unicode characters that are not in the US-ASCII character set,
  # are not control characters (according to the {@link
  # java.lang.Character#isISOControl(char) Character.isISOControl}
  # method), and are not space characters (according to the {@link
  # java.lang.Character#isSpaceChar(char) Character.isSpaceChar}
  # method)&nbsp;&nbsp;<i>(<b>Deviation from RFC 2396</b>, which is
  # limited to US-ASCII)</i></td></tr>
  # </table></blockquote>
  # 
  # <p><a name="legal-chars"></a> The set of all legal URI characters consists of
  # the <i>unreserved</i>, <i>reserved</i>, <i>escaped</i>, and <i>other</i>
  # characters.
  # 
  # 
  # <h4> Escaped octets, quotation, encoding, and decoding </h4>
  # 
  # RFC 2396 allows escaped octets to appear in the user-info, path, query, and
  # fragment components.  Escaping serves two purposes in URIs:
  # 
  # <ul>
  # 
  # <li><p> To <i>encode</i> non-US-ASCII characters when a URI is required to
  # conform strictly to RFC&nbsp;2396 by not containing any <i>other</i>
  # characters.  </p></li>
  # 
  # <li><p> To <i>quote</i> characters that are otherwise illegal in a
  # component.  The user-info, path, query, and fragment components differ
  # slightly in terms of which characters are considered legal and illegal.
  # </p></li>
  # 
  # </ul>
  # 
  # These purposes are served in this class by three related operations:
  # 
  # <ul>
  # 
  # <li><p><a name="encode"></a> A character is <i>encoded</i> by replacing it
  # with the sequence of escaped octets that represent that character in the
  # UTF-8 character set.  The Euro currency symbol (<tt>'&#92;u20AC'</tt>),
  # for example, is encoded as <tt>"%E2%82%AC"</tt>.  <i>(<b>Deviation from
  # RFC&nbsp;2396</b>, which does not specify any particular character
  # set.)</i> </p></li>
  # 
  # <li><p><a name="quote"></a> An illegal character is <i>quoted</i> simply by
  # encoding it.  The space character, for example, is quoted by replacing it
  # with <tt>"%20"</tt>.  UTF-8 contains US-ASCII, hence for US-ASCII
  # characters this transformation has exactly the effect required by
  # RFC&nbsp;2396. </p></li>
  # 
  # <li><p><a name="decode"></a>
  # A sequence of escaped octets is <i>decoded</i> by
  # replacing it with the sequence of characters that it represents in the
  # UTF-8 character set.  UTF-8 contains US-ASCII, hence decoding has the
  # effect of de-quoting any quoted US-ASCII characters as well as that of
  # decoding any encoded non-US-ASCII characters.  If a <a
  # href="../nio/charset/CharsetDecoder.html#ce">decoding error</a> occurs
  # when decoding the escaped octets then the erroneous octets are replaced by
  # <tt>'&#92;uFFFD'</tt>, the Unicode replacement character.  </p></li>
  # 
  # </ul>
  # 
  # These operations are exposed in the constructors and methods of this class
  # as follows:
  # 
  # <ul>
  # 
  # <li><p> The {@link #URI(java.lang.String) <code>single-argument
  # constructor</code>} requires any illegal characters in its argument to be
  # quoted and preserves any escaped octets and <i>other</i> characters that
  # are present.  </p></li>
  # 
  # <li><p> The {@link
  # #URI(java.lang.String,java.lang.String,java.lang.String,int,java.lang.String,java.lang.String,java.lang.String)
  # <code>multi-argument constructors</code>} quote illegal characters as
  # required by the components in which they appear.  The percent character
  # (<tt>'%'</tt>) is always quoted by these constructors.  Any <i>other</i>
  # characters are preserved.  </p></li>
  # 
  # <li><p> The {@link #getRawUserInfo() getRawUserInfo}, {@link #getRawPath()
  # getRawPath}, {@link #getRawQuery() getRawQuery}, {@link #getRawFragment()
  # getRawFragment}, {@link #getRawAuthority() getRawAuthority}, and {@link
  # #getRawSchemeSpecificPart() getRawSchemeSpecificPart} methods return the
  # values of their corresponding components in raw form, without interpreting
  # any escaped octets.  The strings returned by these methods may contain
  # both escaped octets and <i>other</i> characters, and will not contain any
  # illegal characters.  </p></li>
  # 
  # <li><p> The {@link #getUserInfo() getUserInfo}, {@link #getPath()
  # getPath}, {@link #getQuery() getQuery}, {@link #getFragment()
  # getFragment}, {@link #getAuthority() getAuthority}, and {@link
  # #getSchemeSpecificPart() getSchemeSpecificPart} methods decode any escaped
  # octets in their corresponding components.  The strings returned by these
  # methods may contain both <i>other</i> characters and illegal characters,
  # and will not contain any escaped octets.  </p></li>
  # 
  # <li><p> The {@link #toString() toString} method returns a URI string with
  # all necessary quotation but which may contain <i>other</i> characters.
  # </p></li>
  # 
  # <li><p> The {@link #toASCIIString() toASCIIString} method returns a fully
  # quoted and encoded URI string that does not contain any <i>other</i>
  # characters.  </p></li>
  # 
  # </ul>
  # 
  # 
  # <h4> Identities </h4>
  # 
  # For any URI <i>u</i>, it is always the case that
  # 
  # <blockquote>
  # <tt>new URI(</tt><i>u</i><tt>.toString()).equals(</tt><i>u</i><tt>)</tt>&nbsp;.
  # </blockquote>
  # 
  # For any URI <i>u</i> that does not contain redundant syntax such as two
  # slashes before an empty authority (as in <tt>file:///tmp/</tt>&nbsp;) or a
  # colon following a host name but no port (as in
  # <tt>http://java.sun.com:</tt>&nbsp;), and that does not encode characters
  # except those that must be quoted, the following identities also hold:
  # 
  # <blockquote>
  # <tt>new URI(</tt><i>u</i><tt>.getScheme(),<br>
  # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt><i>u</i><tt>.getSchemeSpecificPart(),<br>
  # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt><i>u</i><tt>.getFragment())<br>
  # .equals(</tt><i>u</i><tt>)</tt>
  # </blockquote>
  # 
  # in all cases,
  # 
  # <blockquote>
  # <tt>new URI(</tt><i>u</i><tt>.getScheme(),<br>
  # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt><i>u</i><tt>.getUserInfo(),&nbsp;</tt><i>u</i><tt>.getAuthority(),<br>
  # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt><i>u</i><tt>.getPath(),&nbsp;</tt><i>u</i><tt>.getQuery(),<br>
  # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt><i>u</i><tt>.getFragment())<br>
  # .equals(</tt><i>u</i><tt>)</tt>
  # </blockquote>
  # 
  # if <i>u</i> is hierarchical, and
  # 
  # <blockquote>
  # <tt>new URI(</tt><i>u</i><tt>.getScheme(),<br>
  # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt><i>u</i><tt>.getUserInfo(),&nbsp;</tt><i>u</i><tt>.getHost(),&nbsp;</tt><i>u</i><tt>.getPort(),<br>
  # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt><i>u</i><tt>.getPath(),&nbsp;</tt><i>u</i><tt>.getQuery(),<br>
  # &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</tt><i>u</i><tt>.getFragment())<br>
  # .equals(</tt><i>u</i><tt>)</tt>
  # </blockquote>
  # 
  # if <i>u</i> is hierarchical and has either no authority or a server-based
  # authority.
  # 
  # 
  # <h4> URIs, URLs, and URNs </h4>
  # 
  # A URI is a uniform resource <i>identifier</i> while a URL is a uniform
  # resource <i>locator</i>.  Hence every URL is a URI, abstractly speaking, but
  # not every URI is a URL.  This is because there is another subcategory of
  # URIs, uniform resource <i>names</i> (URNs), which name resources but do not
  # specify how to locate them.  The <tt>mailto</tt>, <tt>news</tt>, and
  # <tt>isbn</tt> URIs shown above are examples of URNs.
  # 
  # <p> The conceptual distinction between URIs and URLs is reflected in the
  # differences between this class and the {@link URL} class.
  # 
  # <p> An instance of this class represents a URI reference in the syntactic
  # sense defined by RFC&nbsp;2396.  A URI may be either absolute or relative.
  # A URI string is parsed according to the generic syntax without regard to the
  # scheme, if any, that it specifies.  No lookup of the host, if any, is
  # performed, and no scheme-dependent stream handler is constructed.  Equality,
  # hashing, and comparison are defined strictly in terms of the character
  # content of the instance.  In other words, a URI instance is little more than
  # a structured string that supports the syntactic, scheme-independent
  # operations of comparison, normalization, resolution, and relativization.
  # 
  # <p> An instance of the {@link URL} class, by contrast, represents the
  # syntactic components of a URL together with some of the information required
  # to access the resource that it describes.  A URL must be absolute, that is,
  # it must always specify a scheme.  A URL string is parsed according to its
  # scheme.  A stream handler is always established for a URL, and in fact it is
  # impossible to create a URL instance for a scheme for which no handler is
  # available.  Equality and hashing depend upon both the scheme and the
  # Internet address of the host, if any; comparison is not defined.  In other
  # words, a URL is a structured string that supports the syntactic operation of
  # resolution as well as the network I/O operations of looking up the host and
  # opening a connection to the specified resource.
  # 
  # 
  # @author Mark Reinhold
  # @since 1.4
  # 
  # @see <a href="http://ietf.org/rfc/rfc2279.txt"><i>RFC&nbsp;2279: UTF-8, a
  # transformation format of ISO 10646</i></a>, <br><a
  # href="http://www.ietf.org/rfc/rfc2373.txt"><i>RFC&nbsp;2373: IPv6 Addressing
  # Architecture</i></a>, <br><a
  # href="http://www.ietf.org/rfc/rfc2396.txt""><i>RFC&nbsp;2396: Uniform
  # Resource Identifiers (URI): Generic Syntax</i></a>, <br><a
  # href="http://www.ietf.org/rfc/rfc2732.txt"><i>RFC&nbsp;2732: Format for
  # Literal IPv6 Addresses in URLs</i></a>, <br><a
  # href="URISyntaxException.html">URISyntaxException</a>
  class URI 
    include_class_members URIImports
    include JavaComparable
    include Serializable
    
    class_module.module_eval {
      # Note: Comments containing the word "ASSERT" indicate places where a
      # throw of an InternalError should be replaced by an appropriate assertion
      # statement once asserts are enabled in the build.
      const_set_lazy(:SerialVersionUID) { -6052424284110960213 }
      const_attr_reader  :SerialVersionUID
    }
    
    # -- Properties and components of this instance --
    # Components of all URIs: [<scheme>:]<scheme-specific-part>[#<fragment>]
    attr_accessor :scheme
    alias_method :attr_scheme, :scheme
    undef_method :scheme
    alias_method :attr_scheme=, :scheme=
    undef_method :scheme=
    
    # null ==> relative URI
    attr_accessor :fragment
    alias_method :attr_fragment, :fragment
    undef_method :fragment
    alias_method :attr_fragment=, :fragment=
    undef_method :fragment=
    
    # Hierarchical URI components: [//<authority>]<path>[?<query>]
    attr_accessor :authority
    alias_method :attr_authority, :authority
    undef_method :authority
    alias_method :attr_authority=, :authority=
    undef_method :authority=
    
    # Registry or server
    # Server-based authority: [<userInfo>@]<host>[:<port>]
    attr_accessor :user_info
    alias_method :attr_user_info, :user_info
    undef_method :user_info
    alias_method :attr_user_info=, :user_info=
    undef_method :user_info=
    
    attr_accessor :host
    alias_method :attr_host, :host
    undef_method :host
    alias_method :attr_host=, :host=
    undef_method :host=
    
    # null ==> registry-based
    attr_accessor :port
    alias_method :attr_port, :port
    undef_method :port
    alias_method :attr_port=, :port=
    undef_method :port=
    
    # -1 ==> undefined
    # Remaining components of hierarchical URIs
    attr_accessor :path
    alias_method :attr_path, :path
    undef_method :path
    alias_method :attr_path=, :path=
    undef_method :path=
    
    # null ==> opaque
    attr_accessor :query
    alias_method :attr_query, :query
    undef_method :query
    alias_method :attr_query=, :query=
    undef_method :query=
    
    # The remaining fields may be computed on demand
    attr_accessor :scheme_specific_part
    alias_method :attr_scheme_specific_part, :scheme_specific_part
    undef_method :scheme_specific_part
    alias_method :attr_scheme_specific_part=, :scheme_specific_part=
    undef_method :scheme_specific_part=
    
    attr_accessor :hash
    alias_method :attr_hash, :hash
    undef_method :hash
    alias_method :attr_hash=, :hash=
    undef_method :hash=
    
    # Zero ==> undefined
    attr_accessor :decoded_user_info
    alias_method :attr_decoded_user_info, :decoded_user_info
    undef_method :decoded_user_info
    alias_method :attr_decoded_user_info=, :decoded_user_info=
    undef_method :decoded_user_info=
    
    attr_accessor :decoded_authority
    alias_method :attr_decoded_authority, :decoded_authority
    undef_method :decoded_authority
    alias_method :attr_decoded_authority=, :decoded_authority=
    undef_method :decoded_authority=
    
    attr_accessor :decoded_path
    alias_method :attr_decoded_path, :decoded_path
    undef_method :decoded_path
    alias_method :attr_decoded_path=, :decoded_path=
    undef_method :decoded_path=
    
    attr_accessor :decoded_query
    alias_method :attr_decoded_query, :decoded_query
    undef_method :decoded_query
    alias_method :attr_decoded_query=, :decoded_query=
    undef_method :decoded_query=
    
    attr_accessor :decoded_fragment
    alias_method :attr_decoded_fragment, :decoded_fragment
    undef_method :decoded_fragment
    alias_method :attr_decoded_fragment=, :decoded_fragment=
    undef_method :decoded_fragment=
    
    attr_accessor :decoded_scheme_specific_part
    alias_method :attr_decoded_scheme_specific_part, :decoded_scheme_specific_part
    undef_method :decoded_scheme_specific_part
    alias_method :attr_decoded_scheme_specific_part=, :decoded_scheme_specific_part=
    undef_method :decoded_scheme_specific_part=
    
    # 
    # The string form of this URI.
    # 
    # @serial
    attr_accessor :string
    alias_method :attr_string, :string
    undef_method :string
    alias_method :attr_string=, :string=
    undef_method :string=
    
    typesig { [] }
    # The only serializable field
    # -- Constructors and factories --
    def initialize
      @scheme = nil
      @fragment = nil
      @authority = nil
      @user_info = nil
      @host = nil
      @port = -1
      @path = nil
      @query = nil
      @scheme_specific_part = nil
      @hash = 0
      @decoded_user_info = nil
      @decoded_authority = nil
      @decoded_path = nil
      @decoded_query = nil
      @decoded_fragment = nil
      @decoded_scheme_specific_part = nil
      @string = nil
    end
    
    typesig { [String] }
    # Used internally
    # 
    # Constructs a URI by parsing the given string.
    # 
    # <p> This constructor parses the given string exactly as specified by the
    # grammar in <a
    # href="http://www.ietf.org/rfc/rfc2396.txt">RFC&nbsp;2396</a>,
    # Appendix&nbsp;A, <b><i>except for the following deviations:</i></b> </p>
    # 
    # <ul type=disc>
    # 
    # <li><p> An empty authority component is permitted as long as it is
    # followed by a non-empty path, a query component, or a fragment
    # component.  This allows the parsing of URIs such as
    # <tt>"file:///foo/bar"</tt>, which seems to be the intent of
    # RFC&nbsp;2396 although the grammar does not permit it.  If the
    # authority component is empty then the user-information, host, and port
    # components are undefined. </p></li>
    # 
    # <li><p> Empty relative paths are permitted; this seems to be the
    # intent of RFC&nbsp;2396 although the grammar does not permit it.  The
    # primary consequence of this deviation is that a standalone fragment
    # such as <tt>"#foo"</tt> parses as a relative URI with an empty path
    # and the given fragment, and can be usefully <a
    # href="#resolve-frag">resolved</a> against a base URI.
    # 
    # <li><p> IPv4 addresses in host components are parsed rigorously, as
    # specified by <a
    # href="http://www.ietf.org/rfc/rfc2732.txt">RFC&nbsp;2732</a>: Each
    # element of a dotted-quad address must contain no more than three
    # decimal digits.  Each element is further constrained to have a value
    # no greater than 255. </p></li>
    # 
    # <li> <p> Hostnames in host components that comprise only a single
    # domain label are permitted to start with an <i>alphanum</i>
    # character. This seems to be the intent of <a
    # href="http://www.ietf.org/rfc/rfc2396.txt">RFC&nbsp;2396</a>
    # section&nbsp;3.2.2 although the grammar does not permit it. The
    # consequence of this deviation is that the authority component of a
    # hierarchical URI such as <tt>s://123</tt>, will parse as a server-based
    # authority. </p></li>
    # 
    # <li><p> IPv6 addresses are permitted for the host component.  An IPv6
    # address must be enclosed in square brackets (<tt>'['</tt> and
    # <tt>']'</tt>) as specified by <a
    # href="http://www.ietf.org/rfc/rfc2732.txt">RFC&nbsp;2732</a>.  The
    # IPv6 address itself must parse according to <a
    # href="http://www.ietf.org/rfc/rfc2373.txt">RFC&nbsp;2373</a>.  IPv6
    # addresses are further constrained to describe no more than sixteen
    # bytes of address information, a constraint implicit in RFC&nbsp;2373
    # but not expressible in the grammar. </p></li>
    # 
    # <li><p> Characters in the <i>other</i> category are permitted wherever
    # RFC&nbsp;2396 permits <i>escaped</i> octets, that is, in the
    # user-information, path, query, and fragment components, as well as in
    # the authority component if the authority is registry-based.  This
    # allows URIs to contain Unicode characters beyond those in the US-ASCII
    # character set. </p></li>
    # 
    # </ul>
    # 
    # @param  str   The string to be parsed into a URI
    # 
    # @throws  NullPointerException
    # If <tt>str</tt> is <tt>null</tt>
    # 
    # @throws  URISyntaxException
    # If the given string violates RFC&nbsp;2396, as augmented
    # by the above deviations
    def initialize(str)
      @scheme = nil
      @fragment = nil
      @authority = nil
      @user_info = nil
      @host = nil
      @port = -1
      @path = nil
      @query = nil
      @scheme_specific_part = nil
      @hash = 0
      @decoded_user_info = nil
      @decoded_authority = nil
      @decoded_path = nil
      @decoded_query = nil
      @decoded_fragment = nil
      @decoded_scheme_specific_part = nil
      @string = nil
      Parser.new_local(self, str).parse(false)
    end
    
    typesig { [String, String, String, ::Java::Int, String, String, String] }
    # 
    # Constructs a hierarchical URI from the given components.
    # 
    # <p> If a scheme is given then the path, if also given, must either be
    # empty or begin with a slash character (<tt>'/'</tt>).  Otherwise a
    # component of the new URI may be left undefined by passing <tt>null</tt>
    # for the corresponding parameter or, in the case of the <tt>port</tt>
    # parameter, by passing <tt>-1</tt>.
    # 
    # <p> This constructor first builds a URI string from the given components
    # according to the rules specified in <a
    # href="http://www.ietf.org/rfc/rfc2396.txt">RFC&nbsp;2396</a>,
    # section&nbsp;5.2, step&nbsp;7: </p>
    # 
    # <ol>
    # 
    # <li><p> Initially, the result string is empty. </p></li>
    # 
    # <li><p> If a scheme is given then it is appended to the result,
    # followed by a colon character (<tt>':'</tt>).  </p></li>
    # 
    # <li><p> If user information, a host, or a port are given then the
    # string <tt>"//"</tt> is appended.  </p></li>
    # 
    # <li><p> If user information is given then it is appended, followed by
    # a commercial-at character (<tt>'@'</tt>).  Any character not in the
    # <i>unreserved</i>, <i>punct</i>, <i>escaped</i>, or <i>other</i>
    # categories is <a href="#quote">quoted</a>.  </p></li>
    # 
    # <li><p> If a host is given then it is appended.  If the host is a
    # literal IPv6 address but is not enclosed in square brackets
    # (<tt>'['</tt> and <tt>']'</tt>) then the square brackets are added.
    # </p></li>
    # 
    # <li><p> If a port number is given then a colon character
    # (<tt>':'</tt>) is appended, followed by the port number in decimal.
    # </p></li>
    # 
    # <li><p> If a path is given then it is appended.  Any character not in
    # the <i>unreserved</i>, <i>punct</i>, <i>escaped</i>, or <i>other</i>
    # categories, and not equal to the slash character (<tt>'/'</tt>) or the
    # commercial-at character (<tt>'@'</tt>), is quoted.  </p></li>
    # 
    # <li><p> If a query is given then a question-mark character
    # (<tt>'?'</tt>) is appended, followed by the query.  Any character that
    # is not a <a href="#legal-chars">legal URI character</a> is quoted.
    # </p></li>
    # 
    # <li><p> Finally, if a fragment is given then a hash character
    # (<tt>'#'</tt>) is appended, followed by the fragment.  Any character
    # that is not a legal URI character is quoted.  </p></li>
    # 
    # </ol>
    # 
    # <p> The resulting URI string is then parsed as if by invoking the {@link
    # #URI(String)} constructor and then invoking the {@link
    # #parseServerAuthority()} method upon the result; this may cause a {@link
    # URISyntaxException} to be thrown.  </p>
    # 
    # @param   scheme    Scheme name
    # @param   userInfo  User name and authorization information
    # @param   host      Host name
    # @param   port      Port number
    # @param   path      Path
    # @param   query     Query
    # @param   fragment  Fragment
    # 
    # @throws URISyntaxException
    # If both a scheme and a path are given but the path is relative,
    # if the URI string constructed from the given components violates
    # RFC&nbsp;2396, or if the authority component of the string is
    # present but cannot be parsed as a server-based authority
    def initialize(scheme, user_info, host, port, path, query, fragment)
      @scheme = nil
      @fragment = nil
      @authority = nil
      @user_info = nil
      @host = nil
      @port = -1
      @path = nil
      @query = nil
      @scheme_specific_part = nil
      @hash = 0
      @decoded_user_info = nil
      @decoded_authority = nil
      @decoded_path = nil
      @decoded_query = nil
      @decoded_fragment = nil
      @decoded_scheme_specific_part = nil
      @string = nil
      s = to_s(scheme, nil, nil, user_info, host, port, path, query, fragment)
      check_path(s, scheme, path)
      Parser.new_local(self, s).parse(true)
    end
    
    typesig { [String, String, String, String, String] }
    # 
    # Constructs a hierarchical URI from the given components.
    # 
    # <p> If a scheme is given then the path, if also given, must either be
    # empty or begin with a slash character (<tt>'/'</tt>).  Otherwise a
    # component of the new URI may be left undefined by passing <tt>null</tt>
    # for the corresponding parameter.
    # 
    # <p> This constructor first builds a URI string from the given components
    # according to the rules specified in <a
    # href="http://www.ietf.org/rfc/rfc2396.txt">RFC&nbsp;2396</a>,
    # section&nbsp;5.2, step&nbsp;7: </p>
    # 
    # <ol>
    # 
    # <li><p> Initially, the result string is empty.  </p></li>
    # 
    # <li><p> If a scheme is given then it is appended to the result,
    # followed by a colon character (<tt>':'</tt>).  </p></li>
    # 
    # <li><p> If an authority is given then the string <tt>"//"</tt> is
    # appended, followed by the authority.  If the authority contains a
    # literal IPv6 address then the address must be enclosed in square
    # brackets (<tt>'['</tt> and <tt>']'</tt>).  Any character not in the
    # <i>unreserved</i>, <i>punct</i>, <i>escaped</i>, or <i>other</i>
    # categories, and not equal to the commercial-at character
    # (<tt>'@'</tt>), is <a href="#quote">quoted</a>.  </p></li>
    # 
    # <li><p> If a path is given then it is appended.  Any character not in
    # the <i>unreserved</i>, <i>punct</i>, <i>escaped</i>, or <i>other</i>
    # categories, and not equal to the slash character (<tt>'/'</tt>) or the
    # commercial-at character (<tt>'@'</tt>), is quoted.  </p></li>
    # 
    # <li><p> If a query is given then a question-mark character
    # (<tt>'?'</tt>) is appended, followed by the query.  Any character that
    # is not a <a href="#legal-chars">legal URI character</a> is quoted.
    # </p></li>
    # 
    # <li><p> Finally, if a fragment is given then a hash character
    # (<tt>'#'</tt>) is appended, followed by the fragment.  Any character
    # that is not a legal URI character is quoted.  </p></li>
    # 
    # </ol>
    # 
    # <p> The resulting URI string is then parsed as if by invoking the {@link
    # #URI(String)} constructor and then invoking the {@link
    # #parseServerAuthority()} method upon the result; this may cause a {@link
    # URISyntaxException} to be thrown.  </p>
    # 
    # @param   scheme     Scheme name
    # @param   authority  Authority
    # @param   path       Path
    # @param   query      Query
    # @param   fragment   Fragment
    # 
    # @throws URISyntaxException
    # If both a scheme and a path are given but the path is relative,
    # if the URI string constructed from the given components violates
    # RFC&nbsp;2396, or if the authority component of the string is
    # present but cannot be parsed as a server-based authority
    def initialize(scheme, authority, path, query, fragment)
      @scheme = nil
      @fragment = nil
      @authority = nil
      @user_info = nil
      @host = nil
      @port = -1
      @path = nil
      @query = nil
      @scheme_specific_part = nil
      @hash = 0
      @decoded_user_info = nil
      @decoded_authority = nil
      @decoded_path = nil
      @decoded_query = nil
      @decoded_fragment = nil
      @decoded_scheme_specific_part = nil
      @string = nil
      s = to_s(scheme, nil, authority, nil, nil, -1, path, query, fragment)
      check_path(s, scheme, path)
      Parser.new_local(self, s).parse(false)
    end
    
    typesig { [String, String, String, String] }
    # 
    # Constructs a hierarchical URI from the given components.
    # 
    # <p> A component may be left undefined by passing <tt>null</tt>.
    # 
    # <p> This convenience constructor works as if by invoking the
    # seven-argument constructor as follows:
    # 
    # <blockquote><tt>
    # new&nbsp;{@link #URI(String, String, String, int, String, String, String)
    # URI}(scheme,&nbsp;null,&nbsp;host,&nbsp;-1,&nbsp;path,&nbsp;null,&nbsp;fragment);
    # </tt></blockquote>
    # 
    # @param   scheme    Scheme name
    # @param   host      Host name
    # @param   path      Path
    # @param   fragment  Fragment
    # 
    # @throws  URISyntaxException
    # If the URI string constructed from the given components
    # violates RFC&nbsp;2396
    def initialize(scheme, host, path, fragment)
      initialize__uri(scheme, nil, host, -1, path, nil, fragment)
    end
    
    typesig { [String, String, String] }
    # 
    # Constructs a URI from the given components.
    # 
    # <p> A component may be left undefined by passing <tt>null</tt>.
    # 
    # <p> This constructor first builds a URI in string form using the given
    # components as follows:  </p>
    # 
    # <ol>
    # 
    # <li><p> Initially, the result string is empty.  </p></li>
    # 
    # <li><p> If a scheme is given then it is appended to the result,
    # followed by a colon character (<tt>':'</tt>).  </p></li>
    # 
    # <li><p> If a scheme-specific part is given then it is appended.  Any
    # character that is not a <a href="#legal-chars">legal URI character</a>
    # is <a href="#quote">quoted</a>.  </p></li>
    # 
    # <li><p> Finally, if a fragment is given then a hash character
    # (<tt>'#'</tt>) is appended to the string, followed by the fragment.
    # Any character that is not a legal URI character is quoted.  </p></li>
    # 
    # </ol>
    # 
    # <p> The resulting URI string is then parsed in order to create the new
    # URI instance as if by invoking the {@link #URI(String)} constructor;
    # this may cause a {@link URISyntaxException} to be thrown.  </p>
    # 
    # @param   scheme    Scheme name
    # @param   ssp       Scheme-specific part
    # @param   fragment  Fragment
    # 
    # @throws  URISyntaxException
    # If the URI string constructed from the given components
    # violates RFC&nbsp;2396
    def initialize(scheme, ssp, fragment)
      @scheme = nil
      @fragment = nil
      @authority = nil
      @user_info = nil
      @host = nil
      @port = -1
      @path = nil
      @query = nil
      @scheme_specific_part = nil
      @hash = 0
      @decoded_user_info = nil
      @decoded_authority = nil
      @decoded_path = nil
      @decoded_query = nil
      @decoded_fragment = nil
      @decoded_scheme_specific_part = nil
      @string = nil
      Parser.new_local(self, to_s(scheme, ssp, nil, nil, nil, -1, nil, nil, fragment)).parse(false)
    end
    
    class_module.module_eval {
      typesig { [String] }
      # 
      # Creates a URI by parsing the given string.
      # 
      # <p> This convenience factory method works as if by invoking the {@link
      # #URI(String)} constructor; any {@link URISyntaxException} thrown by the
      # constructor is caught and wrapped in a new {@link
      # IllegalArgumentException} object, which is then thrown.
      # 
      # <p> This method is provided for use in situations where it is known that
      # the given string is a legal URI, for example for URI constants declared
      # within in a program, and so it would be considered a programming error
      # for the string not to parse as such.  The constructors, which throw
      # {@link URISyntaxException} directly, should be used situations where a
      # URI is being constructed from user input or from some other source that
      # may be prone to errors.  </p>
      # 
      # @param  str   The string to be parsed into a URI
      # @return The new URI
      # 
      # @throws  NullPointerException
      # If <tt>str</tt> is <tt>null</tt>
      # 
      # @throws  IllegalArgumentException
      # If the given string violates RFC&nbsp;2396
      def create(str)
        begin
          return URI.new(str)
        rescue URISyntaxException => x
          y = IllegalArgumentException.new
          y.init_cause(x)
          raise y
        end
      end
    }
    
    typesig { [] }
    # -- Operations --
    # 
    # Attempts to parse this URI's authority component, if defined, into
    # user-information, host, and port components.
    # 
    # <p> If this URI's authority component has already been recognized as
    # being server-based then it will already have been parsed into
    # user-information, host, and port components.  In this case, or if this
    # URI has no authority component, this method simply returns this URI.
    # 
    # <p> Otherwise this method attempts once more to parse the authority
    # component into user-information, host, and port components, and throws
    # an exception describing why the authority component could not be parsed
    # in that way.
    # 
    # <p> This method is provided because the generic URI syntax specified in
    # <a href="http://www.ietf.org/rfc/rfc2396.txt">RFC&nbsp;2396</a>
    # cannot always distinguish a malformed server-based authority from a
    # legitimate registry-based authority.  It must therefore treat some
    # instances of the former as instances of the latter.  The authority
    # component in the URI string <tt>"//foo:bar"</tt>, for example, is not a
    # legal server-based authority but it is legal as a registry-based
    # authority.
    # 
    # <p> In many common situations, for example when working URIs that are
    # known to be either URNs or URLs, the hierarchical URIs being used will
    # always be server-based.  They therefore must either be parsed as such or
    # treated as an error.  In these cases a statement such as
    # 
    # <blockquote>
    # <tt>URI </tt><i>u</i><tt> = new URI(str).parseServerAuthority();</tt>
    # </blockquote>
    # 
    # <p> can be used to ensure that <i>u</i> always refers to a URI that, if
    # it has an authority component, has a server-based authority with proper
    # user-information, host, and port components.  Invoking this method also
    # ensures that if the authority could not be parsed in that way then an
    # appropriate diagnostic message can be issued based upon the exception
    # that is thrown. </p>
    # 
    # @return  A URI whose authority field has been parsed
    # as a server-based authority
    # 
    # @throws  URISyntaxException
    # If the authority component of this URI is defined
    # but cannot be parsed as a server-based authority
    # according to RFC&nbsp;2396
    def parse_server_authority
      # We could be clever and cache the error message and index from the
      # exception thrown during the original parse, but that would require
      # either more fields or a more-obscure representation.
      if ((!(@host).nil?) || ((@authority).nil?))
        return self
      end
      define_string
      Parser.new_local(self, @string).parse(true)
      return self
    end
    
    typesig { [] }
    # 
    # Normalizes this URI's path.
    # 
    # <p> If this URI is opaque, or if its path is already in normal form,
    # then this URI is returned.  Otherwise a new URI is constructed that is
    # identical to this URI except that its path is computed by normalizing
    # this URI's path in a manner consistent with <a
    # href="http://www.ietf.org/rfc/rfc2396.txt">RFC&nbsp;2396</a>,
    # section&nbsp;5.2, step&nbsp;6, sub-steps&nbsp;c through&nbsp;f; that is:
    # </p>
    # 
    # <ol>
    # 
    # <li><p> All <tt>"."</tt> segments are removed. </p></li>
    # 
    # <li><p> If a <tt>".."</tt> segment is preceded by a non-<tt>".."</tt>
    # segment then both of these segments are removed.  This step is
    # repeated until it is no longer applicable. </p></li>
    # 
    # <li><p> If the path is relative, and if its first segment contains a
    # colon character (<tt>':'</tt>), then a <tt>"."</tt> segment is
    # prepended.  This prevents a relative URI with a path such as
    # <tt>"a:b/c/d"</tt> from later being re-parsed as an opaque URI with a
    # scheme of <tt>"a"</tt> and a scheme-specific part of <tt>"b/c/d"</tt>.
    # <b><i>(Deviation from RFC&nbsp;2396)</i></b> </p></li>
    # 
    # </ol>
    # 
    # <p> A normalized path will begin with one or more <tt>".."</tt> segments
    # if there were insufficient non-<tt>".."</tt> segments preceding them to
    # allow their removal.  A normalized path will begin with a <tt>"."</tt>
    # segment if one was inserted by step 3 above.  Otherwise, a normalized
    # path will not contain any <tt>"."</tt> or <tt>".."</tt> segments. </p>
    # 
    # @return  A URI equivalent to this URI,
    # but whose path is in normal form
    def normalize
      return normalize(self)
    end
    
    typesig { [URI] }
    # 
    # Resolves the given URI against this URI.
    # 
    # <p> If the given URI is already absolute, or if this URI is opaque, then
    # the given URI is returned.
    # 
    # <p><a name="resolve-frag"></a> If the given URI's fragment component is
    # defined, its path component is empty, and its scheme, authority, and
    # query components are undefined, then a URI with the given fragment but
    # with all other components equal to those of this URI is returned.  This
    # allows a URI representing a standalone fragment reference, such as
    # <tt>"#foo"</tt>, to be usefully resolved against a base URI.
    # 
    # <p> Otherwise this method constructs a new hierarchical URI in a manner
    # consistent with <a
    # href="http://www.ietf.org/rfc/rfc2396.txt">RFC&nbsp;2396</a>,
    # section&nbsp;5.2; that is: </p>
    # 
    # <ol>
    # 
    # <li><p> A new URI is constructed with this URI's scheme and the given
    # URI's query and fragment components. </p></li>
    # 
    # <li><p> If the given URI has an authority component then the new URI's
    # authority and path are taken from the given URI. </p></li>
    # 
    # <li><p> Otherwise the new URI's authority component is copied from
    # this URI, and its path is computed as follows: </p></li>
    # 
    # <ol type=a>
    # 
    # <li><p> If the given URI's path is absolute then the new URI's path
    # is taken from the given URI. </p></li>
    # 
    # <li><p> Otherwise the given URI's path is relative, and so the new
    # URI's path is computed by resolving the path of the given URI
    # against the path of this URI.  This is done by concatenating all but
    # the last segment of this URI's path, if any, with the given URI's
    # path and then normalizing the result as if by invoking the {@link
    # #normalize() normalize} method. </p></li>
    # 
    # </ol>
    # 
    # </ol>
    # 
    # <p> The result of this method is absolute if, and only if, either this
    # URI is absolute or the given URI is absolute.  </p>
    # 
    # @param  uri  The URI to be resolved against this URI
    # @return The resulting URI
    # 
    # @throws  NullPointerException
    # If <tt>uri</tt> is <tt>null</tt>
    def resolve(uri)
      return resolve(self, uri)
    end
    
    typesig { [String] }
    # 
    # Constructs a new URI by parsing the given string and then resolving it
    # against this URI.
    # 
    # <p> This convenience method works as if invoking it were equivalent to
    # evaluating the expression <tt>{@link #resolve(java.net.URI)
    # resolve}(URI.{@link #create(String) create}(str))</tt>. </p>
    # 
    # @param  str   The string to be parsed into a URI
    # @return The resulting URI
    # 
    # @throws  NullPointerException
    # If <tt>str</tt> is <tt>null</tt>
    # 
    # @throws  IllegalArgumentException
    # If the given string violates RFC&nbsp;2396
    def resolve(str)
      return resolve(URI.create(str))
    end
    
    typesig { [URI] }
    # 
    # Relativizes the given URI against this URI.
    # 
    # <p> The relativization of the given URI against this URI is computed as
    # follows: </p>
    # 
    # <ol>
    # 
    # <li><p> If either this URI or the given URI are opaque, or if the
    # scheme and authority components of the two URIs are not identical, or
    # if the path of this URI is not a prefix of the path of the given URI,
    # then the given URI is returned. </p></li>
    # 
    # <li><p> Otherwise a new relative hierarchical URI is constructed with
    # query and fragment components taken from the given URI and with a path
    # component computed by removing this URI's path from the beginning of
    # the given URI's path. </p></li>
    # 
    # </ol>
    # 
    # @param  uri  The URI to be relativized against this URI
    # @return The resulting URI
    # 
    # @throws  NullPointerException
    # If <tt>uri</tt> is <tt>null</tt>
    def relativize(uri)
      return relativize(self, uri)
    end
    
    typesig { [] }
    # 
    # Constructs a URL from this URI.
    # 
    # <p> This convenience method works as if invoking it were equivalent to
    # evaluating the expression <tt>new&nbsp;URL(this.toString())</tt> after
    # first checking that this URI is absolute. </p>
    # 
    # @return  A URL constructed from this URI
    # 
    # @throws  IllegalArgumentException
    # If this URL is not absolute
    # 
    # @throws  MalformedURLException
    # If a protocol handler for the URL could not be found,
    # or if some other error occurred while constructing the URL
    def to_url
      if (!is_absolute)
        raise IllegalArgumentException.new("URI is not absolute")
      end
      return URL.new(to_s)
    end
    
    typesig { [] }
    # -- Component access methods --
    # 
    # Returns the scheme component of this URI.
    # 
    # <p> The scheme component of a URI, if defined, only contains characters
    # in the <i>alphanum</i> category and in the string <tt>"-.+"</tt>.  A
    # scheme always starts with an <i>alpha</i> character. <p>
    # 
    # The scheme component of a URI cannot contain escaped octets, hence this
    # method does not perform any decoding.
    # 
    # @return  The scheme component of this URI,
    # or <tt>null</tt> if the scheme is undefined
    def get_scheme
      return @scheme
    end
    
    typesig { [] }
    # 
    # Tells whether or not this URI is absolute.
    # 
    # <p> A URI is absolute if, and only if, it has a scheme component. </p>
    # 
    # @return  <tt>true</tt> if, and only if, this URI is absolute
    def is_absolute
      return !(@scheme).nil?
    end
    
    typesig { [] }
    # 
    # Tells whether or not this URI is opaque.
    # 
    # <p> A URI is opaque if, and only if, it is absolute and its
    # scheme-specific part does not begin with a slash character ('/').
    # An opaque URI has a scheme, a scheme-specific part, and possibly
    # a fragment; all other components are undefined. </p>
    # 
    # @return  <tt>true</tt> if, and only if, this URI is opaque
    def is_opaque
      return (@path).nil?
    end
    
    typesig { [] }
    # 
    # Returns the raw scheme-specific part of this URI.  The scheme-specific
    # part is never undefined, though it may be empty.
    # 
    # <p> The scheme-specific part of a URI only contains legal URI
    # characters. </p>
    # 
    # @return  The raw scheme-specific part of this URI
    # (never <tt>null</tt>)
    def get_raw_scheme_specific_part
      define_scheme_specific_part
      return @scheme_specific_part
    end
    
    typesig { [] }
    # 
    # Returns the decoded scheme-specific part of this URI.
    # 
    # <p> The string returned by this method is equal to that returned by the
    # {@link #getRawSchemeSpecificPart() getRawSchemeSpecificPart} method
    # except that all sequences of escaped octets are <a
    # href="#decode">decoded</a>.  </p>
    # 
    # @return  The decoded scheme-specific part of this URI
    # (never <tt>null</tt>)
    def get_scheme_specific_part
      if ((@decoded_scheme_specific_part).nil?)
        @decoded_scheme_specific_part = (decode(get_raw_scheme_specific_part)).to_s
      end
      return @decoded_scheme_specific_part
    end
    
    typesig { [] }
    # 
    # Returns the raw authority component of this URI.
    # 
    # <p> The authority component of a URI, if defined, only contains the
    # commercial-at character (<tt>'@'</tt>) and characters in the
    # <i>unreserved</i>, <i>punct</i>, <i>escaped</i>, and <i>other</i>
    # categories.  If the authority is server-based then it is further
    # constrained to have valid user-information, host, and port
    # components. </p>
    # 
    # @return  The raw authority component of this URI,
    # or <tt>null</tt> if the authority is undefined
    def get_raw_authority
      return @authority
    end
    
    typesig { [] }
    # 
    # Returns the decoded authority component of this URI.
    # 
    # <p> The string returned by this method is equal to that returned by the
    # {@link #getRawAuthority() getRawAuthority} method except that all
    # sequences of escaped octets are <a href="#decode">decoded</a>.  </p>
    # 
    # @return  The decoded authority component of this URI,
    # or <tt>null</tt> if the authority is undefined
    def get_authority
      if ((@decoded_authority).nil?)
        @decoded_authority = (decode(@authority)).to_s
      end
      return @decoded_authority
    end
    
    typesig { [] }
    # 
    # Returns the raw user-information component of this URI.
    # 
    # <p> The user-information component of a URI, if defined, only contains
    # characters in the <i>unreserved</i>, <i>punct</i>, <i>escaped</i>, and
    # <i>other</i> categories. </p>
    # 
    # @return  The raw user-information component of this URI,
    # or <tt>null</tt> if the user information is undefined
    def get_raw_user_info
      return @user_info
    end
    
    typesig { [] }
    # 
    # Returns the decoded user-information component of this URI.
    # 
    # <p> The string returned by this method is equal to that returned by the
    # {@link #getRawUserInfo() getRawUserInfo} method except that all
    # sequences of escaped octets are <a href="#decode">decoded</a>.  </p>
    # 
    # @return  The decoded user-information component of this URI,
    # or <tt>null</tt> if the user information is undefined
    def get_user_info
      if (((@decoded_user_info).nil?) && (!(@user_info).nil?))
        @decoded_user_info = (decode(@user_info)).to_s
      end
      return @decoded_user_info
    end
    
    typesig { [] }
    # 
    # Returns the host component of this URI.
    # 
    # <p> The host component of a URI, if defined, will have one of the
    # following forms: </p>
    # 
    # <ul type=disc>
    # 
    # <li><p> A domain name consisting of one or more <i>labels</i>
    # separated by period characters (<tt>'.'</tt>), optionally followed by
    # a period character.  Each label consists of <i>alphanum</i> characters
    # as well as hyphen characters (<tt>'-'</tt>), though hyphens never
    # occur as the first or last characters in a label. The rightmost
    # label of a domain name consisting of two or more labels, begins
    # with an <i>alpha</i> character. </li>
    # 
    # <li><p> A dotted-quad IPv4 address of the form
    # <i>digit</i><tt>+.</tt><i>digit</i><tt>+.</tt><i>digit</i><tt>+.</tt><i>digit</i><tt>+</tt>,
    # where no <i>digit</i> sequence is longer than three characters and no
    # sequence has a value larger than 255. </p></li>
    # 
    # <li><p> An IPv6 address enclosed in square brackets (<tt>'['</tt> and
    # <tt>']'</tt>) and consisting of hexadecimal digits, colon characters
    # (<tt>':'</tt>), and possibly an embedded IPv4 address.  The full
    # syntax of IPv6 addresses is specified in <a
    # href="http://www.ietf.org/rfc/rfc2373.txt"><i>RFC&nbsp;2373: IPv6
    # Addressing Architecture</i></a>.  </p></li>
    # 
    # </ul>
    # 
    # The host component of a URI cannot contain escaped octets, hence this
    # method does not perform any decoding.
    # 
    # @return  The host component of this URI,
    # or <tt>null</tt> if the host is undefined
    def get_host
      return @host
    end
    
    typesig { [] }
    # 
    # Returns the port number of this URI.
    # 
    # <p> The port component of a URI, if defined, is a non-negative
    # integer. </p>
    # 
    # @return  The port component of this URI,
    # or <tt>-1</tt> if the port is undefined
    def get_port
      return @port
    end
    
    typesig { [] }
    # 
    # Returns the raw path component of this URI.
    # 
    # <p> The path component of a URI, if defined, only contains the slash
    # character (<tt>'/'</tt>), the commercial-at character (<tt>'@'</tt>),
    # and characters in the <i>unreserved</i>, <i>punct</i>, <i>escaped</i>,
    # and <i>other</i> categories. </p>
    # 
    # @return  The path component of this URI,
    # or <tt>null</tt> if the path is undefined
    def get_raw_path
      return @path
    end
    
    typesig { [] }
    # 
    # Returns the decoded path component of this URI.
    # 
    # <p> The string returned by this method is equal to that returned by the
    # {@link #getRawPath() getRawPath} method except that all sequences of
    # escaped octets are <a href="#decode">decoded</a>.  </p>
    # 
    # @return  The decoded path component of this URI,
    # or <tt>null</tt> if the path is undefined
    def get_path
      if (((@decoded_path).nil?) && (!(@path).nil?))
        @decoded_path = (decode(@path)).to_s
      end
      return @decoded_path
    end
    
    typesig { [] }
    # 
    # Returns the raw query component of this URI.
    # 
    # <p> The query component of a URI, if defined, only contains legal URI
    # characters. </p>
    # 
    # @return  The raw query component of this URI,
    # or <tt>null</tt> if the query is undefined
    def get_raw_query
      return @query
    end
    
    typesig { [] }
    # 
    # Returns the decoded query component of this URI.
    # 
    # <p> The string returned by this method is equal to that returned by the
    # {@link #getRawQuery() getRawQuery} method except that all sequences of
    # escaped octets are <a href="#decode">decoded</a>.  </p>
    # 
    # @return  The decoded query component of this URI,
    # or <tt>null</tt> if the query is undefined
    def get_query
      if (((@decoded_query).nil?) && (!(@query).nil?))
        @decoded_query = (decode(@query)).to_s
      end
      return @decoded_query
    end
    
    typesig { [] }
    # 
    # Returns the raw fragment component of this URI.
    # 
    # <p> The fragment component of a URI, if defined, only contains legal URI
    # characters. </p>
    # 
    # @return  The raw fragment component of this URI,
    # or <tt>null</tt> if the fragment is undefined
    def get_raw_fragment
      return @fragment
    end
    
    typesig { [] }
    # 
    # Returns the decoded fragment component of this URI.
    # 
    # <p> The string returned by this method is equal to that returned by the
    # {@link #getRawFragment() getRawFragment} method except that all
    # sequences of escaped octets are <a href="#decode">decoded</a>.  </p>
    # 
    # @return  The decoded fragment component of this URI,
    # or <tt>null</tt> if the fragment is undefined
    def get_fragment
      if (((@decoded_fragment).nil?) && (!(@fragment).nil?))
        @decoded_fragment = (decode(@fragment)).to_s
      end
      return @decoded_fragment
    end
    
    typesig { [Object] }
    # -- Equality, comparison, hash code, toString, and serialization --
    # 
    # Tests this URI for equality with another object.
    # 
    # <p> If the given object is not a URI then this method immediately
    # returns <tt>false</tt>.
    # 
    # <p> For two URIs to be considered equal requires that either both are
    # opaque or both are hierarchical.  Their schemes must either both be
    # undefined or else be equal without regard to case. Their fragments
    # must either both be undefined or else be equal.
    # 
    # <p> For two opaque URIs to be considered equal, their scheme-specific
    # parts must be equal.
    # 
    # <p> For two hierarchical URIs to be considered equal, their paths must
    # be equal and their queries must either both be undefined or else be
    # equal.  Their authorities must either both be undefined, or both be
    # registry-based, or both be server-based.  If their authorities are
    # defined and are registry-based, then they must be equal.  If their
    # authorities are defined and are server-based, then their hosts must be
    # equal without regard to case, their port numbers must be equal, and
    # their user-information components must be equal.
    # 
    # <p> When testing the user-information, path, query, fragment, authority,
    # or scheme-specific parts of two URIs for equality, the raw forms rather
    # than the encoded forms of these components are compared and the
    # hexadecimal digits of escaped octets are compared without regard to
    # case.
    # 
    # <p> This method satisfies the general contract of the {@link
    # java.lang.Object#equals(Object) Object.equals} method. </p>
    # 
    # @param   ob   The object to which this object is to be compared
    # 
    # @return  <tt>true</tt> if, and only if, the given object is a URI that
    # is identical to this URI
    def equals(ob)
      if ((ob).equal?(self))
        return true
      end
      if (!(ob.is_a?(URI)))
        return false
      end
      that = ob
      if (!(self.is_opaque).equal?(that.is_opaque))
        return false
      end
      if (!equal_ignoring_case(@scheme, that.attr_scheme))
        return false
      end
      if (!equal(@fragment, that.attr_fragment))
        return false
      end
      # Opaque
      if (self.is_opaque)
        return equal(@scheme_specific_part, that.attr_scheme_specific_part)
      end
      # Hierarchical
      if (!equal(@path, that.attr_path))
        return false
      end
      if (!equal(@query, that.attr_query))
        return false
      end
      # Authorities
      if ((@authority).equal?(that.attr_authority))
        return true
      end
      if (!(@host).nil?)
        # Server-based
        if (!equal(@user_info, that.attr_user_info))
          return false
        end
        if (!equal_ignoring_case(@host, that.attr_host))
          return false
        end
        if (!(@port).equal?(that.attr_port))
          return false
        end
      else
        if (!(@authority).nil?)
          # Registry-based
          if (!equal(@authority, that.attr_authority))
            return false
          end
        else
          if (!(@authority).equal?(that.attr_authority))
            return false
          end
        end
      end
      return true
    end
    
    typesig { [] }
    # 
    # Returns a hash-code value for this URI.  The hash code is based upon all
    # of the URI's components, and satisfies the general contract of the
    # {@link java.lang.Object#hashCode() Object.hashCode} method.
    # 
    # @return  A hash-code value for this URI
    def hash_code
      if (!(@hash).equal?(0))
        return @hash
      end
      h = hash_ignoring_case(0, @scheme)
      h = hash(h, @fragment)
      if (is_opaque)
        h = hash(h, @scheme_specific_part)
      else
        h = hash(h, @path)
        h = hash(h, @query)
        if (!(@host).nil?)
          h = hash(h, @user_info)
          h = hash_ignoring_case(h, @host)
          h += 1949 * @port
        else
          h = hash(h, @authority)
        end
      end
      @hash = h
      return h
    end
    
    typesig { [URI] }
    # 
    # Compares this URI to another object, which must be a URI.
    # 
    # <p> When comparing corresponding components of two URIs, if one
    # component is undefined but the other is defined then the first is
    # considered to be less than the second.  Unless otherwise noted, string
    # components are ordered according to their natural, case-sensitive
    # ordering as defined by the {@link java.lang.String#compareTo(Object)
    # String.compareTo} method.  String components that are subject to
    # encoding are compared by comparing their raw forms rather than their
    # encoded forms.
    # 
    # <p> The ordering of URIs is defined as follows: </p>
    # 
    # <ul type=disc>
    # 
    # <li><p> Two URIs with different schemes are ordered according the
    # ordering of their schemes, without regard to case. </p></li>
    # 
    # <li><p> A hierarchical URI is considered to be less than an opaque URI
    # with an identical scheme. </p></li>
    # 
    # <li><p> Two opaque URIs with identical schemes are ordered according
    # to the ordering of their scheme-specific parts. </p></li>
    # 
    # <li><p> Two opaque URIs with identical schemes and scheme-specific
    # parts are ordered according to the ordering of their
    # fragments. </p></li>
    # 
    # <li><p> Two hierarchical URIs with identical schemes are ordered
    # according to the ordering of their authority components: </p></li>
    # 
    # <ul type=disc>
    # 
    # <li><p> If both authority components are server-based then the URIs
    # are ordered according to their user-information components; if these
    # components are identical then the URIs are ordered according to the
    # ordering of their hosts, without regard to case; if the hosts are
    # identical then the URIs are ordered according to the ordering of
    # their ports. </p></li>
    # 
    # <li><p> If one or both authority components are registry-based then
    # the URIs are ordered according to the ordering of their authority
    # components. </p></li>
    # 
    # </ul>
    # 
    # <li><p> Finally, two hierarchical URIs with identical schemes and
    # authority components are ordered according to the ordering of their
    # paths; if their paths are identical then they are ordered according to
    # the ordering of their queries; if the queries are identical then they
    # are ordered according to the order of their fragments. </p></li>
    # 
    # </ul>
    # 
    # <p> This method satisfies the general contract of the {@link
    # java.lang.Comparable#compareTo(Object) Comparable.compareTo}
    # method. </p>
    # 
    # @param   that
    # The object to which this URI is to be compared
    # 
    # @return  A negative integer, zero, or a positive integer as this URI is
    # less than, equal to, or greater than the given URI
    # 
    # @throws  ClassCastException
    # If the given object is not a URI
    def compare_to(that)
      c = 0
      if (!((c = compare_ignoring_case(@scheme, that.attr_scheme))).equal?(0))
        return c
      end
      if (self.is_opaque)
        if (that.is_opaque)
          # Both opaque
          if (!((c = compare(@scheme_specific_part, that.attr_scheme_specific_part))).equal?(0))
            return c
          end
          return compare(@fragment, that.attr_fragment)
        end
        return +1 # Opaque > hierarchical
      else
        if (that.is_opaque)
          return -1 # Hierarchical < opaque
        end
      end
      # Hierarchical
      if ((!(@host).nil?) && (!(that.attr_host).nil?))
        # Both server-based
        if (!((c = compare(@user_info, that.attr_user_info))).equal?(0))
          return c
        end
        if (!((c = compare_ignoring_case(@host, that.attr_host))).equal?(0))
          return c
        end
        if (!((c = @port - that.attr_port)).equal?(0))
          return c
        end
      else
        # If one or both authorities are registry-based then we simply
        # compare them in the usual, case-sensitive way.  If one is
        # registry-based and one is server-based then the strings are
        # guaranteed to be unequal, hence the comparison will never return
        # zero and the compareTo and equals methods will remain
        # consistent.
        if (!((c = compare(@authority, that.attr_authority))).equal?(0))
          return c
        end
      end
      if (!((c = compare(@path, that.attr_path))).equal?(0))
        return c
      end
      if (!((c = compare(@query, that.attr_query))).equal?(0))
        return c
      end
      return compare(@fragment, that.attr_fragment)
    end
    
    typesig { [] }
    # 
    # Returns the content of this URI as a string.
    # 
    # <p> If this URI was created by invoking one of the constructors in this
    # class then a string equivalent to the original input string, or to the
    # string computed from the originally-given components, as appropriate, is
    # returned.  Otherwise this URI was created by normalization, resolution,
    # or relativization, and so a string is constructed from this URI's
    # components according to the rules specified in <a
    # href="http://www.ietf.org/rfc/rfc2396.txt">RFC&nbsp;2396</a>,
    # section&nbsp;5.2, step&nbsp;7. </p>
    # 
    # @return  The string form of this URI
    def to_s
      define_string
      return @string
    end
    
    typesig { [] }
    # 
    # Returns the content of this URI as a US-ASCII string.
    # 
    # <p> If this URI does not contain any characters in the <i>other</i>
    # category then an invocation of this method will return the same value as
    # an invocation of the {@link #toString() toString} method.  Otherwise
    # this method works as if by invoking that method and then <a
    # href="#encode">encoding</a> the result.  </p>
    # 
    # @return  The string form of this URI, encoded as needed
    # so that it only contains characters in the US-ASCII
    # charset
    def to_asciistring
      define_string
      return encode(@string)
    end
    
    typesig { [ObjectOutputStream] }
    # -- Serialization support --
    # 
    # Saves the content of this URI to the given serial stream.
    # 
    # <p> The only serializable field of a URI instance is its <tt>string</tt>
    # field.  That field is given a value, if it does not have one already,
    # and then the {@link java.io.ObjectOutputStream#defaultWriteObject()}
    # method of the given object-output stream is invoked. </p>
    # 
    # @param  os  The object-output stream to which this object
    # is to be written
    def write_object(os)
      define_string
      os.default_write_object # Writes the string field only
    end
    
    typesig { [ObjectInputStream] }
    # 
    # Reconstitutes a URI from the given serial stream.
    # 
    # <p> The {@link java.io.ObjectInputStream#defaultReadObject()} method is
    # invoked to read the value of the <tt>string</tt> field.  The result is
    # then parsed in the usual way.
    # 
    # @param  is  The object-input stream from which this object
    # is being read
    def read_object(is)
      @port = -1 # Argh
      is.default_read_object
      begin
        Parser.new_local(self, @string).parse(false)
      rescue URISyntaxException => x
        y = InvalidObjectException.new("Invalid URI")
        y.init_cause(x)
        raise y
      end
    end
    
    class_module.module_eval {
      typesig { [::Java::Char] }
      # -- End of public methods --
      # -- Utility methods for string-field comparison and hashing --
      # These methods return appropriate values for null string arguments,
      # thereby simplifying the equals, hashCode, and compareTo methods.
      # 
      # The case-ignoring methods should only be applied to strings whose
      # characters are all known to be US-ASCII.  Because of this restriction,
      # these methods are faster than the similar methods in the String class.
      # US-ASCII only
      def to_lower(c)
        if ((c >= Character.new(?A.ord)) && (c <= Character.new(?Z.ord)))
          return c + (Character.new(?a.ord) - Character.new(?A.ord))
        end
        return c
      end
      
      typesig { [String, String] }
      def equal(s, t)
        if ((s).equal?(t))
          return true
        end
        if ((!(s).nil?) && (!(t).nil?))
          if (!(s.length).equal?(t.length))
            return false
          end
          if (s.index_of(Character.new(?%.ord)) < 0)
            return (s == t)
          end
          n = s.length
          i = 0
          while i < n
            c = s.char_at(i)
            d = t.char_at(i)
            if (!(c).equal?(Character.new(?%.ord)))
              if (!(c).equal?(d))
                return false
              end
              ((i += 1) - 1)
              next
            end
            ((i += 1) - 1)
            if (!(to_lower(s.char_at(i))).equal?(to_lower(t.char_at(i))))
              return false
            end
            ((i += 1) - 1)
            if (!(to_lower(s.char_at(i))).equal?(to_lower(t.char_at(i))))
              return false
            end
            ((i += 1) - 1)
          end
          return true
        end
        return false
      end
      
      typesig { [String, String] }
      # US-ASCII only
      def equal_ignoring_case(s, t)
        if ((s).equal?(t))
          return true
        end
        if ((!(s).nil?) && (!(t).nil?))
          n = s.length
          if (!(t.length).equal?(n))
            return false
          end
          i = 0
          while i < n
            if (!(to_lower(s.char_at(i))).equal?(to_lower(t.char_at(i))))
              return false
            end
            ((i += 1) - 1)
          end
          return true
        end
        return false
      end
      
      typesig { [::Java::Int, String] }
      def hash(hash_, s)
        if ((s).nil?)
          return hash_
        end
        return hash_ * 127 + s.hash_code
      end
      
      typesig { [::Java::Int, String] }
      # US-ASCII only
      def hash_ignoring_case(hash_, s)
        if ((s).nil?)
          return hash_
        end
        h = hash_
        n = s.length
        i = 0
        while i < n
          h = 31 * h + to_lower(s.char_at(i))
          ((i += 1) - 1)
        end
        return h
      end
      
      typesig { [String, String] }
      def compare(s, t)
        if ((s).equal?(t))
          return 0
        end
        if (!(s).nil?)
          if (!(t).nil?)
            return (s <=> t)
          else
            return +1
          end
        else
          return -1
        end
      end
      
      typesig { [String, String] }
      # US-ASCII only
      def compare_ignoring_case(s, t)
        if ((s).equal?(t))
          return 0
        end
        if (!(s).nil?)
          if (!(t).nil?)
            sn = s.length
            tn = t.length
            n = sn < tn ? sn : tn
            i = 0
            while i < n
              c = to_lower(s.char_at(i)) - to_lower(t.char_at(i))
              if (!(c).equal?(0))
                return c
              end
              ((i += 1) - 1)
            end
            return sn - tn
          end
          return +1
        else
          return -1
        end
      end
      
      typesig { [String, String, String] }
      # -- String construction --
      # If a scheme is given then the path, if given, must be absolute
      def check_path(s, scheme, path)
        if (!(scheme).nil?)
          if ((!(path).nil?) && ((path.length > 0) && (!(path.char_at(0)).equal?(Character.new(?/.ord)))))
            raise URISyntaxException.new(s, "Relative path in absolute URI")
          end
        end
      end
    }
    
    typesig { [StringBuffer, String, String, String, ::Java::Int] }
    def append_authority(sb, authority, user_info, host, port)
      if (!(host).nil?)
        sb.append("//")
        if (!(user_info).nil?)
          sb.append(quote(user_info, L_USERINFO, H_USERINFO))
          sb.append(Character.new(?@.ord))
        end
        need_brackets = ((host.index_of(Character.new(?:.ord)) >= 0) && !host.starts_with("[") && !host.ends_with("]"))
        if (need_brackets)
          sb.append(Character.new(?[.ord))
        end
        sb.append(host)
        if (need_brackets)
          sb.append(Character.new(?].ord))
        end
        if (!(port).equal?(-1))
          sb.append(Character.new(?:.ord))
          sb.append(port)
        end
      else
        if (!(authority).nil?)
          sb.append("//")
          if (authority.starts_with("["))
            end_ = authority.index_of("]")
            if (!(end_).equal?(-1) && !(authority.index_of(":")).equal?(-1))
              doquote = nil
              dontquote = nil
              if ((end_).equal?(authority.length))
                dontquote = authority
                doquote = ""
              else
                dontquote = (authority.substring(0, end_ + 1)).to_s
                doquote = (authority.substring(end_ + 1)).to_s
              end
              sb.append(dontquote)
              sb.append(quote(doquote, L_REG_NAME | L_SERVER, H_REG_NAME | H_SERVER))
            end
          else
            sb.append(quote(authority, L_REG_NAME | L_SERVER, H_REG_NAME | H_SERVER))
          end
        end
      end
    end
    
    typesig { [StringBuffer, String, String, String, String, ::Java::Int, String, String] }
    def append_scheme_specific_part(sb, opaque_part, authority, user_info, host, port, path, query)
      if (!(opaque_part).nil?)
        # check if SSP begins with an IPv6 address
        # because we must not quote a literal IPv6 address
        if (opaque_part.starts_with("//["))
          end_ = opaque_part.index_of("]")
          if (!(end_).equal?(-1) && !(opaque_part.index_of(":")).equal?(-1))
            doquote = nil
            dontquote = nil
            if ((end_).equal?(opaque_part.length))
              dontquote = opaque_part
              doquote = ""
            else
              dontquote = (opaque_part.substring(0, end_ + 1)).to_s
              doquote = (opaque_part.substring(end_ + 1)).to_s
            end
            sb.append(dontquote)
            sb.append(quote(doquote, L_URIC, H_URIC))
          end
        else
          sb.append(quote(opaque_part, L_URIC, H_URIC))
        end
      else
        append_authority(sb, authority, user_info, host, port)
        if (!(path).nil?)
          sb.append(quote(path, L_PATH, H_PATH))
        end
        if (!(query).nil?)
          sb.append(Character.new(??.ord))
          sb.append(quote(query, L_URIC, H_URIC))
        end
      end
    end
    
    typesig { [StringBuffer, String] }
    def append_fragment(sb, fragment)
      if (!(fragment).nil?)
        sb.append(Character.new(?#.ord))
        sb.append(quote(fragment, L_URIC, H_URIC))
      end
    end
    
    typesig { [String, String, String, String, String, ::Java::Int, String, String, String] }
    def to_s(scheme, opaque_part, authority, user_info, host, port, path, query, fragment)
      sb = StringBuffer.new
      if (!(scheme).nil?)
        sb.append(scheme)
        sb.append(Character.new(?:.ord))
      end
      append_scheme_specific_part(sb, opaque_part, authority, user_info, host, port, path, query)
      append_fragment(sb, fragment)
      return sb.to_s
    end
    
    typesig { [] }
    def define_scheme_specific_part
      if (!(@scheme_specific_part).nil?)
        return
      end
      sb = StringBuffer.new
      append_scheme_specific_part(sb, nil, get_authority, get_user_info, @host, @port, get_path, get_query)
      if ((sb.length).equal?(0))
        return
      end
      @scheme_specific_part = (sb.to_s).to_s
    end
    
    typesig { [] }
    def define_string
      if (!(@string).nil?)
        return
      end
      sb = StringBuffer.new
      if (!(@scheme).nil?)
        sb.append(@scheme)
        sb.append(Character.new(?:.ord))
      end
      if (is_opaque)
        sb.append(@scheme_specific_part)
      else
        if (!(@host).nil?)
          sb.append("//")
          if (!(@user_info).nil?)
            sb.append(@user_info)
            sb.append(Character.new(?@.ord))
          end
          need_brackets = ((@host.index_of(Character.new(?:.ord)) >= 0) && !@host.starts_with("[") && !@host.ends_with("]"))
          if (need_brackets)
            sb.append(Character.new(?[.ord))
          end
          sb.append(@host)
          if (need_brackets)
            sb.append(Character.new(?].ord))
          end
          if (!(@port).equal?(-1))
            sb.append(Character.new(?:.ord))
            sb.append(@port)
          end
        else
          if (!(@authority).nil?)
            sb.append("//")
            sb.append(@authority)
          end
        end
        if (!(@path).nil?)
          sb.append(@path)
        end
        if (!(@query).nil?)
          sb.append(Character.new(??.ord))
          sb.append(@query)
        end
      end
      if (!(@fragment).nil?)
        sb.append(Character.new(?#.ord))
        sb.append(@fragment)
      end
      @string = (sb.to_s).to_s
    end
    
    class_module.module_eval {
      typesig { [String, String, ::Java::Boolean] }
      # -- Normalization, resolution, and relativization --
      # RFC2396 5.2 (6)
      def resolve_path(base, child, absolute)
        i = base.last_index_of(Character.new(?/.ord))
        cn = child.length
        path = ""
        if ((cn).equal?(0))
          # 5.2 (6a)
          if (i >= 0)
            path = (base.substring(0, i + 1)).to_s
          end
        else
          sb = StringBuffer.new(base.length + cn)
          # 5.2 (6a)
          if (i >= 0)
            sb.append(base.substring(0, i + 1))
          end
          # 5.2 (6b)
          sb.append(child)
          path = (sb.to_s).to_s
        end
        # 5.2 (6c-f)
        np = normalize(path)
        # 5.2 (6g): If the result is absolute but the path begins with "../",
        # then we simply leave the path as-is
        return np
      end
      
      typesig { [URI, URI] }
      # RFC2396 5.2
      def resolve(base, child)
        # check if child if opaque first so that NPE is thrown
        # if child is null.
        if (child.is_opaque || base.is_opaque)
          return child
        end
        # 5.2 (2): Reference to current document (lone fragment)
        if (((child.attr_scheme).nil?) && ((child.attr_authority).nil?) && (child.attr_path == "") && (!(child.attr_fragment).nil?) && ((child.attr_query).nil?))
          if ((!(base.attr_fragment).nil?) && (child.attr_fragment == base.attr_fragment))
            return base
          end
          ru = URI.new
          ru.attr_scheme = base.attr_scheme
          ru.attr_authority = base.attr_authority
          ru.attr_user_info = base.attr_user_info
          ru.attr_host = base.attr_host
          ru.attr_port = base.attr_port
          ru.attr_path = base.attr_path
          ru.attr_fragment = child.attr_fragment
          ru.attr_query = base.attr_query
          return ru
        end
        # 5.2 (3): Child is absolute
        if (!(child.attr_scheme).nil?)
          return child
        end
        ru_ = URI.new # Resolved URI
        ru_.attr_scheme = base.attr_scheme
        ru_.attr_query = child.attr_query
        ru_.attr_fragment = child.attr_fragment
        # 5.2 (4): Authority
        if ((child.attr_authority).nil?)
          ru_.attr_authority = base.attr_authority
          ru_.attr_host = base.attr_host
          ru_.attr_user_info = base.attr_user_info
          ru_.attr_port = base.attr_port
          cp = ((child.attr_path).nil?) ? "" : child.attr_path
          if ((cp.length > 0) && ((cp.char_at(0)).equal?(Character.new(?/.ord))))
            # 5.2 (5): Child path is absolute
            ru_.attr_path = child.attr_path
          else
            # 5.2 (6): Resolve relative path
            ru_.attr_path = resolve_path(base.attr_path, cp, base.is_absolute)
          end
        else
          ru_.attr_authority = child.attr_authority
          ru_.attr_host = child.attr_host
          ru_.attr_user_info = child.attr_user_info
          ru_.attr_host = child.attr_host
          ru_.attr_port = child.attr_port
          ru_.attr_path = child.attr_path
        end
        # 5.2 (7): Recombine (nothing to do here)
        return ru_
      end
      
      typesig { [URI] }
      # If the given URI's path is normal then return the URI;
      # o.w., return a new URI containing the normalized path.
      def normalize(u)
        if (u.is_opaque || ((u.attr_path).nil?) || ((u.attr_path.length).equal?(0)))
          return u
        end
        np = normalize(u.attr_path)
        if ((np).equal?(u.attr_path))
          return u
        end
        v = URI.new
        v.attr_scheme = u.attr_scheme
        v.attr_fragment = u.attr_fragment
        v.attr_authority = u.attr_authority
        v.attr_user_info = u.attr_user_info
        v.attr_host = u.attr_host
        v.attr_port = u.attr_port
        v.attr_path = np
        v.attr_query = u.attr_query
        return v
      end
      
      typesig { [URI, URI] }
      # If both URIs are hierarchical, their scheme and authority components are
      # identical, and the base path is a prefix of the child's path, then
      # return a relative URI that, when resolved against the base, yields the
      # child; otherwise, return the child.
      def relativize(base, child)
        # check if child if opaque first so that NPE is thrown
        # if child is null.
        if (child.is_opaque || base.is_opaque)
          return child
        end
        if (!equal_ignoring_case(base.attr_scheme, child.attr_scheme) || !equal(base.attr_authority, child.attr_authority))
          return child
        end
        bp = normalize(base.attr_path)
        cp = normalize(child.attr_path)
        if (!(bp == cp))
          if (!bp.ends_with("/"))
            bp = bp + "/"
          end
          if (!cp.starts_with(bp))
            return child
          end
        end
        v = URI.new
        v.attr_path = cp.substring(bp.length)
        v.attr_query = child.attr_query
        v.attr_fragment = child.attr_fragment
        return v
      end
      
      typesig { [String] }
      # -- Path normalization --
      # The following algorithm for path normalization avoids the creation of a
      # string object for each segment, as well as the use of a string buffer to
      # compute the final result, by using a single char array and editing it in
      # place.  The array is first split into segments, replacing each slash
      # with '\0' and creating a segment-index array, each element of which is
      # the index of the first char in the corresponding segment.  We then walk
      # through both arrays, removing ".", "..", and other segments as necessary
      # by setting their entries in the index array to -1.  Finally, the two
      # arrays are used to rejoin the segments and compute the final result.
      # 
      # This code is based upon src/solaris/native/java/io/canonicalize_md.c
      # Check the given path to see if it might need normalization.  A path
      # might need normalization if it contains duplicate slashes, a "."
      # segment, or a ".." segment.  Return -1 if no further normalization is
      # possible, otherwise return the number of segments found.
      # 
      # This method takes a string argument rather than a char array so that
      # this test can be performed without invoking path.toCharArray().
      def needs_normalization(path)
        normal = true
        ns = 0 # Number of segments
        end_ = path.length - 1 # Index of last char in path
        p = 0 # Index of next char in path
        # Skip initial slashes
        while (p <= end_)
          if (!(path.char_at(p)).equal?(Character.new(?/.ord)))
            break
          end
          ((p += 1) - 1)
        end
        if (p > 1)
          normal = false
        end
        # Scan segments
        while (p <= end_)
          # Looking at "." or ".." ?
          if (((path.char_at(p)).equal?(Character.new(?..ord))) && (((p).equal?(end_)) || (((path.char_at(p + 1)).equal?(Character.new(?/.ord))) || (((path.char_at(p + 1)).equal?(Character.new(?..ord))) && (((p + 1).equal?(end_)) || ((path.char_at(p + 2)).equal?(Character.new(?/.ord))))))))
            normal = false
          end
          ((ns += 1) - 1)
          # Find beginning of next segment
          while (p <= end_)
            if (!(path.char_at(((p += 1) - 1))).equal?(Character.new(?/.ord)))
              next
            end
            # Skip redundant slashes
            while (p <= end_)
              if (!(path.char_at(p)).equal?(Character.new(?/.ord)))
                break
              end
              normal = false
              ((p += 1) - 1)
            end
            break
          end
        end
        return normal ? -1 : ns
      end
      
      typesig { [Array.typed(::Java::Char), Array.typed(::Java::Int)] }
      # Split the given path into segments, replacing slashes with nulls and
      # filling in the given segment-index array.
      # 
      # Preconditions:
      # segs.length == Number of segments in path
      # 
      # Postconditions:
      # All slashes in path replaced by '\0'
      # segs[i] == Index of first char in segment i (0 <= i < segs.length)
      def split(path, segs)
        end_ = path.attr_length - 1 # Index of last char in path
        p = 0 # Index of next char in path
        i = 0 # Index of current segment
        # Skip initial slashes
        while (p <= end_)
          if (!(path[p]).equal?(Character.new(?/.ord)))
            break
          end
          path[p] = Character.new(?\0.ord)
          ((p += 1) - 1)
        end
        while (p <= end_)
          # Note start of segment
          segs[((i += 1) - 1)] = ((p += 1) - 1)
          # Find beginning of next segment
          while (p <= end_)
            if (!(path[((p += 1) - 1)]).equal?(Character.new(?/.ord)))
              next
            end
            path[p - 1] = Character.new(?\0.ord)
            # Skip redundant slashes
            while (p <= end_)
              if (!(path[p]).equal?(Character.new(?/.ord)))
                break
              end
              path[((p += 1) - 1)] = Character.new(?\0.ord)
            end
            break
          end
        end
        if (!(i).equal?(segs.attr_length))
          raise InternalError.new
        end # ASSERT
      end
      
      typesig { [Array.typed(::Java::Char), Array.typed(::Java::Int)] }
      # Join the segments in the given path according to the given segment-index
      # array, ignoring those segments whose index entries have been set to -1,
      # and inserting slashes as needed.  Return the length of the resulting
      # path.
      # 
      # Preconditions:
      # segs[i] == -1 implies segment i is to be ignored
      # path computed by split, as above, with '\0' having replaced '/'
      # 
      # Postconditions:
      # path[0] .. path[return value] == Resulting path
      def join(path, segs)
        ns = segs.attr_length # Number of segments
        end_ = path.attr_length - 1 # Index of last char in path
        p = 0 # Index of next path char to write
        if ((path[p]).equal?(Character.new(?\0.ord)))
          # Restore initial slash for absolute paths
          path[((p += 1) - 1)] = Character.new(?/.ord)
        end
        i = 0
        while i < ns
          q = segs[i] # Current segment
          if ((q).equal?(-1))
            # Ignore this segment
            ((i += 1) - 1)
            next
          end
          if ((p).equal?(q))
            # We're already at this segment, so just skip to its end
            while ((p <= end_) && (!(path[p]).equal?(Character.new(?\0.ord))))
              ((p += 1) - 1)
            end
            if (p <= end_)
              # Preserve trailing slash
              path[((p += 1) - 1)] = Character.new(?/.ord)
            end
          else
            if (p < q)
              # Copy q down to p
              while ((q <= end_) && (!(path[q]).equal?(Character.new(?\0.ord))))
                path[((p += 1) - 1)] = path[((q += 1) - 1)]
              end
              if (q <= end_)
                # Preserve trailing slash
                path[((p += 1) - 1)] = Character.new(?/.ord)
              end
            else
              raise InternalError.new
            end
          end # ASSERT false
          ((i += 1) - 1)
        end
        return p
      end
      
      typesig { [Array.typed(::Java::Char), Array.typed(::Java::Int)] }
      # Remove "." segments from the given path, and remove segment pairs
      # consisting of a non-".." segment followed by a ".." segment.
      def remove_dots(path, segs)
        ns = segs.attr_length
        end_ = path.attr_length - 1
        i = 0
        while i < ns
          dots = 0 # Number of dots found (0, 1, or 2)
          # Find next occurrence of "." or ".."
          begin
            p = segs[i]
            if ((path[p]).equal?(Character.new(?..ord)))
              if ((p).equal?(end_))
                dots = 1
                break
              else
                if ((path[p + 1]).equal?(Character.new(?\0.ord)))
                  dots = 1
                  break
                else
                  if (((path[p + 1]).equal?(Character.new(?..ord))) && (((p + 1).equal?(end_)) || ((path[p + 2]).equal?(Character.new(?\0.ord)))))
                    dots = 2
                    break
                  end
                end
              end
            end
            ((i += 1) - 1)
          end while (i < ns)
          if ((i > ns) || ((dots).equal?(0)))
            break
          end
          if ((dots).equal?(1))
            # Remove this occurrence of "."
            segs[i] = -1
          else
            # If there is a preceding non-".." segment, remove both that
            # segment and this occurrence of ".."; otherwise, leave this
            # ".." segment as-is.
            j = 0
            j = i - 1
            while j >= 0
              if (!(segs[j]).equal?(-1))
                break
              end
              ((j -= 1) + 1)
            end
            if (j >= 0)
              q = segs[j]
              if (!(((path[q]).equal?(Character.new(?..ord))) && ((path[q + 1]).equal?(Character.new(?..ord))) && ((path[q + 2]).equal?(Character.new(?\0.ord)))))
                segs[i] = -1
                segs[j] = -1
              end
            end
          end
          ((i += 1) - 1)
        end
      end
      
      typesig { [Array.typed(::Java::Char), Array.typed(::Java::Int)] }
      # DEVIATION: If the normalized path is relative, and if the first
      # segment could be parsed as a scheme name, then prepend a "." segment
      def maybe_add_leading_dot(path, segs)
        if ((path[0]).equal?(Character.new(?\0.ord)))
          # The path is absolute
          return
        end
        ns = segs.attr_length
        f = 0 # Index of first segment
        while (f < ns)
          if (segs[f] >= 0)
            break
          end
          ((f += 1) - 1)
        end
        if ((f >= ns) || ((f).equal?(0)))
          # The path is empty, or else the original first segment survived,
          # in which case we already know that no leading "." is needed
          return
        end
        p = segs[f]
        while ((p < path.attr_length) && (!(path[p]).equal?(Character.new(?:.ord))) && (!(path[p]).equal?(Character.new(?\0.ord))))
          ((p += 1) - 1)
        end
        if (p >= path.attr_length || (path[p]).equal?(Character.new(?\0.ord)))
          # No colon in first segment, so no "." needed
          return
        end
        # At this point we know that the first segment is unused,
        # hence we can insert a "." segment at that position
        path[0] = Character.new(?..ord)
        path[1] = Character.new(?\0.ord)
        segs[0] = 0
      end
      
      typesig { [String] }
      # Normalize the given path string.  A normal path string has no empty
      # segments (i.e., occurrences of "//"), no segments equal to ".", and no
      # segments equal to ".." that are preceded by a segment not equal to "..".
      # In contrast to Unix-style pathname normalization, for URI paths we
      # always retain trailing slashes.
      def normalize(ps)
        # Does this path need normalization?
        ns = needs_normalization(ps) # Number of segments
        if (ns < 0)
          # Nope -- just return it
          return ps
        end
        path = ps.to_char_array # Path in char-array form
        # Split path into segments
        segs = Array.typed(::Java::Int).new(ns) { 0 } # Segment-index array
        split(path, segs)
        # Remove dots
        remove_dots(path, segs)
        # Prevent scheme-name confusion
        maybe_add_leading_dot(path, segs)
        # Join the remaining segments and return the result
        s = String.new(path, 0, join(path, segs))
        if ((s == ps))
          # string was already normalized
          return ps
        end
        return s
      end
      
      typesig { [String] }
      # -- Character classes for parsing --
      # RFC2396 precisely specifies which characters in the US-ASCII charset are
      # permissible in the various components of a URI reference.  We here
      # define a set of mask pairs to aid in enforcing these restrictions.  Each
      # mask pair consists of two longs, a low mask and a high mask.  Taken
      # together they represent a 128-bit mask, where bit i is set iff the
      # character with value i is permitted.
      # 
      # This approach is more efficient than sequentially searching arrays of
      # permitted characters.  It could be made still more efficient by
      # precompiling the mask information so that a character's presence in a
      # given mask could be determined by a single table lookup.
      # Compute the low-order mask for the characters in the given string
      def low_mask(chars)
        n = chars.length
        m = 0
        i = 0
        while i < n
          c = chars.char_at(i)
          if (c < 64)
            m |= (1 << c)
          end
          ((i += 1) - 1)
        end
        return m
      end
      
      typesig { [String] }
      # Compute the high-order mask for the characters in the given string
      def high_mask(chars)
        n = chars.length
        m = 0
        i = 0
        while i < n
          c = chars.char_at(i)
          if ((c >= 64) && (c < 128))
            m |= (1 << (c - 64))
          end
          ((i += 1) - 1)
        end
        return m
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # Compute a low-order mask for the characters
      # between first and last, inclusive
      def low_mask(first, last)
        m = 0
        f = Math.max(Math.min(first, 63), 0)
        l = Math.max(Math.min(last, 63), 0)
        i = f
        while i <= l
          m |= 1 << i
          ((i += 1) - 1)
        end
        return m
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      # Compute a high-order mask for the characters
      # between first and last, inclusive
      def high_mask(first, last)
        m = 0
        f = Math.max(Math.min(first, 127), 64) - 64
        l = Math.max(Math.min(last, 127), 64) - 64
        i = f
        while i <= l
          m |= 1 << i
          ((i += 1) - 1)
        end
        return m
      end
      
      typesig { [::Java::Char, ::Java::Long, ::Java::Long] }
      # Tell whether the given character is permitted by the given mask pair
      def match(c, low_mask, high_mask)
        if (c < 64)
          return !(((1 << c) & low_mask)).equal?(0)
        end
        if (c < 128)
          return !(((1 << (c - 64)) & high_mask)).equal?(0)
        end
        return false
      end
      
      # Character-class masks, in reverse order from RFC2396 because
      # initializers for static fields cannot make forward references.
      # digit    = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" |
      # "8" | "9"
      const_set_lazy(:L_DIGIT) { low_mask(Character.new(?0.ord), Character.new(?9.ord)) }
      const_attr_reader  :L_DIGIT
      
      const_set_lazy(:H_DIGIT) { 0 }
      const_attr_reader  :H_DIGIT
      
      # upalpha  = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" |
      # "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" |
      # "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
      const_set_lazy(:L_UPALPHA) { 0 }
      const_attr_reader  :L_UPALPHA
      
      const_set_lazy(:H_UPALPHA) { high_mask(Character.new(?A.ord), Character.new(?Z.ord)) }
      const_attr_reader  :H_UPALPHA
      
      # lowalpha = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" |
      # "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r" |
      # "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
      const_set_lazy(:L_LOWALPHA) { 0 }
      const_attr_reader  :L_LOWALPHA
      
      const_set_lazy(:H_LOWALPHA) { high_mask(Character.new(?a.ord), Character.new(?z.ord)) }
      const_attr_reader  :H_LOWALPHA
      
      # alpha         = lowalpha | upalpha
      const_set_lazy(:L_ALPHA) { L_LOWALPHA | L_UPALPHA }
      const_attr_reader  :L_ALPHA
      
      const_set_lazy(:H_ALPHA) { H_LOWALPHA | H_UPALPHA }
      const_attr_reader  :H_ALPHA
      
      # alphanum      = alpha | digit
      const_set_lazy(:L_ALPHANUM) { L_DIGIT | L_ALPHA }
      const_attr_reader  :L_ALPHANUM
      
      const_set_lazy(:H_ALPHANUM) { H_DIGIT | H_ALPHA }
      const_attr_reader  :H_ALPHANUM
      
      # hex           = digit | "A" | "B" | "C" | "D" | "E" | "F" |
      # "a" | "b" | "c" | "d" | "e" | "f"
      const_set_lazy(:L_HEX) { L_DIGIT }
      const_attr_reader  :L_HEX
      
      const_set_lazy(:H_HEX) { high_mask(Character.new(?A.ord), Character.new(?F.ord)) | high_mask(Character.new(?a.ord), Character.new(?f.ord)) }
      const_attr_reader  :H_HEX
      
      # mark          = "-" | "_" | "." | "!" | "~" | "*" | "'" |
      # "(" | ")"
      const_set_lazy(:L_MARK) { low_mask("-_.!~*'()") }
      const_attr_reader  :L_MARK
      
      const_set_lazy(:H_MARK) { high_mask("-_.!~*'()") }
      const_attr_reader  :H_MARK
      
      # unreserved    = alphanum | mark
      const_set_lazy(:L_UNRESERVED) { L_ALPHANUM | L_MARK }
      const_attr_reader  :L_UNRESERVED
      
      const_set_lazy(:H_UNRESERVED) { H_ALPHANUM | H_MARK }
      const_attr_reader  :H_UNRESERVED
      
      # reserved      = ";" | "/" | "?" | ":" | "@" | "&" | "=" | "+" |
      # "$" | "," | "[" | "]"
      # Added per RFC2732: "[", "]"
      const_set_lazy(:L_RESERVED) { low_mask(";/?:@&=+$,[]") }
      const_attr_reader  :L_RESERVED
      
      const_set_lazy(:H_RESERVED) { high_mask(";/?:@&=+$,[]") }
      const_attr_reader  :H_RESERVED
      
      # The zero'th bit is used to indicate that escape pairs and non-US-ASCII
      # characters are allowed; this is handled by the scanEscape method below.
      const_set_lazy(:L_ESCAPED) { 1 }
      const_attr_reader  :L_ESCAPED
      
      const_set_lazy(:H_ESCAPED) { 0 }
      const_attr_reader  :H_ESCAPED
      
      # uric          = reserved | unreserved | escaped
      const_set_lazy(:L_URIC) { L_RESERVED | L_UNRESERVED | L_ESCAPED }
      const_attr_reader  :L_URIC
      
      const_set_lazy(:H_URIC) { H_RESERVED | H_UNRESERVED | H_ESCAPED }
      const_attr_reader  :H_URIC
      
      # pchar         = unreserved | escaped |
      # ":" | "@" | "&" | "=" | "+" | "$" | ","
      const_set_lazy(:L_PCHAR) { L_UNRESERVED | L_ESCAPED | low_mask(":@&=+$,") }
      const_attr_reader  :L_PCHAR
      
      const_set_lazy(:H_PCHAR) { H_UNRESERVED | H_ESCAPED | high_mask(":@&=+$,") }
      const_attr_reader  :H_PCHAR
      
      # All valid path characters
      const_set_lazy(:L_PATH) { L_PCHAR | low_mask(";/") }
      const_attr_reader  :L_PATH
      
      const_set_lazy(:H_PATH) { H_PCHAR | high_mask(";/") }
      const_attr_reader  :H_PATH
      
      # Dash, for use in domainlabel and toplabel
      const_set_lazy(:L_DASH) { low_mask("-") }
      const_attr_reader  :L_DASH
      
      const_set_lazy(:H_DASH) { high_mask("-") }
      const_attr_reader  :H_DASH
      
      # Dot, for use in hostnames
      const_set_lazy(:L_DOT) { low_mask(".") }
      const_attr_reader  :L_DOT
      
      const_set_lazy(:H_DOT) { high_mask(".") }
      const_attr_reader  :H_DOT
      
      # userinfo      = *( unreserved | escaped |
      # ";" | ":" | "&" | "=" | "+" | "$" | "," )
      const_set_lazy(:L_USERINFO) { L_UNRESERVED | L_ESCAPED | low_mask(";:&=+$,") }
      const_attr_reader  :L_USERINFO
      
      const_set_lazy(:H_USERINFO) { H_UNRESERVED | H_ESCAPED | high_mask(";:&=+$,") }
      const_attr_reader  :H_USERINFO
      
      # reg_name      = 1*( unreserved | escaped | "$" | "," |
      # ";" | ":" | "@" | "&" | "=" | "+" )
      const_set_lazy(:L_REG_NAME) { L_UNRESERVED | L_ESCAPED | low_mask("$,;:@&=+") }
      const_attr_reader  :L_REG_NAME
      
      const_set_lazy(:H_REG_NAME) { H_UNRESERVED | H_ESCAPED | high_mask("$,;:@&=+") }
      const_attr_reader  :H_REG_NAME
      
      # All valid characters for server-based authorities
      const_set_lazy(:L_SERVER) { L_USERINFO | L_ALPHANUM | L_DASH | low_mask(".:@[]") }
      const_attr_reader  :L_SERVER
      
      const_set_lazy(:H_SERVER) { H_USERINFO | H_ALPHANUM | H_DASH | high_mask(".:@[]") }
      const_attr_reader  :H_SERVER
      
      # Special case of server authority that represents an IPv6 address
      # In this case, a % does not signify an escape sequence
      const_set_lazy(:L_SERVER_PERCENT) { L_SERVER | low_mask("%") }
      const_attr_reader  :L_SERVER_PERCENT
      
      const_set_lazy(:H_SERVER_PERCENT) { H_SERVER | high_mask("%") }
      const_attr_reader  :H_SERVER_PERCENT
      
      const_set_lazy(:L_LEFT_BRACKET) { low_mask("[") }
      const_attr_reader  :L_LEFT_BRACKET
      
      const_set_lazy(:H_LEFT_BRACKET) { high_mask("[") }
      const_attr_reader  :H_LEFT_BRACKET
      
      # scheme        = alpha *( alpha | digit | "+" | "-" | "." )
      const_set_lazy(:L_SCHEME) { L_ALPHA | L_DIGIT | low_mask("+-.") }
      const_attr_reader  :L_SCHEME
      
      const_set_lazy(:H_SCHEME) { H_ALPHA | H_DIGIT | high_mask("+-.") }
      const_attr_reader  :H_SCHEME
      
      # uric_no_slash = unreserved | escaped | ";" | "?" | ":" | "@" |
      # "&" | "=" | "+" | "$" | ","
      const_set_lazy(:L_URIC_NO_SLASH) { L_UNRESERVED | L_ESCAPED | low_mask(";?:@&=+$,") }
      const_attr_reader  :L_URIC_NO_SLASH
      
      const_set_lazy(:H_URIC_NO_SLASH) { H_UNRESERVED | H_ESCAPED | high_mask(";?:@&=+$,") }
      const_attr_reader  :H_URIC_NO_SLASH
      
      # -- Escaping and encoding --
      const_set_lazy(:HexDigits) { Array.typed(::Java::Char).new([Character.new(?0.ord), Character.new(?1.ord), Character.new(?2.ord), Character.new(?3.ord), Character.new(?4.ord), Character.new(?5.ord), Character.new(?6.ord), Character.new(?7.ord), Character.new(?8.ord), Character.new(?9.ord), Character.new(?A.ord), Character.new(?B.ord), Character.new(?C.ord), Character.new(?D.ord), Character.new(?E.ord), Character.new(?F.ord)]) }
      const_attr_reader  :HexDigits
      
      typesig { [StringBuffer, ::Java::Byte] }
      def append_escape(sb, b)
        sb.append(Character.new(?%.ord))
        sb.append(HexDigits[(b >> 4) & 0xf])
        sb.append(HexDigits[(b >> 0) & 0xf])
      end
      
      typesig { [StringBuffer, ::Java::Char] }
      def append_encoded(sb, c)
        bb = nil
        begin
          bb = ThreadLocalCoders.encoder_for("UTF-8").encode(CharBuffer.wrap("" + (c).to_s))
        rescue CharacterCodingException => x
          raise AssertError if not (false)
        end
        while (bb.has_remaining)
          b = bb.get & 0xff
          if (b >= 0x80)
            append_escape(sb, b)
          else
            sb.append(RJava.cast_to_char(b))
          end
        end
      end
      
      typesig { [String, ::Java::Long, ::Java::Long] }
      # Quote any characters in s that are not permitted
      # by the given mask pair
      def quote(s, low_mask_, high_mask_)
        n = s.length
        sb = nil
        allow_non_ascii = (!((low_mask_ & L_ESCAPED)).equal?(0))
        i = 0
        while i < s.length
          c = s.char_at(i)
          if (c < Character.new(0x0080))
            if (!match(c, low_mask_, high_mask_))
              if ((sb).nil?)
                sb = StringBuffer.new
                sb.append(s.substring(0, i))
              end
              append_escape(sb, c)
            else
              if (!(sb).nil?)
                sb.append(c)
              end
            end
          else
            if (allow_non_ascii && (Character.is_space_char(c) || Character.is_isocontrol(c)))
              if ((sb).nil?)
                sb = StringBuffer.new
                sb.append(s.substring(0, i))
              end
              append_encoded(sb, c)
            else
              if (!(sb).nil?)
                sb.append(c)
              end
            end
          end
          ((i += 1) - 1)
        end
        return ((sb).nil?) ? s : sb.to_s
      end
      
      typesig { [String] }
      # Encodes all characters >= \u0080 into escaped, normalized UTF-8 octets,
      # assuming that s is otherwise legal
      def encode(s)
        n = s.length
        if ((n).equal?(0))
          return s
        end
        # First check whether we actually need to encode
        i = 0
        loop do
          if (s.char_at(i) >= Character.new(0x0080))
            break
          end
          if ((i += 1) >= n)
            return s
          end
        end
        ns = Normalizer.normalize(s, Normalizer::Form::NFC)
        bb = nil
        begin
          bb = ThreadLocalCoders.encoder_for("UTF-8").encode(CharBuffer.wrap(ns))
        rescue CharacterCodingException => x
          raise AssertError if not (false)
        end
        sb = StringBuffer.new
        while (bb.has_remaining)
          b = bb.get & 0xff
          if (b >= 0x80)
            append_escape(sb, b)
          else
            sb.append(RJava.cast_to_char(b))
          end
        end
        return sb.to_s
      end
      
      typesig { [::Java::Char] }
      def decode(c)
        if ((c >= Character.new(?0.ord)) && (c <= Character.new(?9.ord)))
          return c - Character.new(?0.ord)
        end
        if ((c >= Character.new(?a.ord)) && (c <= Character.new(?f.ord)))
          return c - Character.new(?a.ord) + 10
        end
        if ((c >= Character.new(?A.ord)) && (c <= Character.new(?F.ord)))
          return c - Character.new(?A.ord) + 10
        end
        raise AssertError if not (false)
        return -1
      end
      
      typesig { [::Java::Char, ::Java::Char] }
      def decode(c1, c2)
        return (((decode(c1) & 0xf) << 4) | ((decode(c2) & 0xf) << 0))
      end
      
      typesig { [String] }
      # Evaluates all escapes in s, applying UTF-8 decoding if needed.  Assumes
      # that escapes are well-formed syntactically, i.e., of the form %XX.  If a
      # sequence of escaped octets is not valid UTF-8 then the erroneous octets
      # are replaced with '\uFFFD'.
      # Exception: any "%" found between "[]" is left alone. It is an IPv6 literal
      # with a scope_id
      def decode(s)
        if ((s).nil?)
          return s
        end
        n = s.length
        if ((n).equal?(0))
          return s
        end
        if (s.index_of(Character.new(?%.ord)) < 0)
          return s
        end
        sb = StringBuffer.new(n)
        bb = ByteBuffer.allocate(n)
        cb = CharBuffer.allocate(n)
        dec = ThreadLocalCoders.decoder_for("UTF-8").on_malformed_input(CodingErrorAction::REPLACE).on_unmappable_character(CodingErrorAction::REPLACE)
        # This is not horribly efficient, but it will do for now
        c = s.char_at(0)
        between_brackets = false
        i = 0
        while i < n
          raise AssertError if not ((c).equal?(s.char_at(i))) # Loop invariant
          if ((c).equal?(Character.new(?[.ord)))
            between_brackets = true
          else
            if (between_brackets && (c).equal?(Character.new(?].ord)))
              between_brackets = false
            end
          end
          if (!(c).equal?(Character.new(?%.ord)) || between_brackets)
            sb.append(c)
            if ((i += 1) >= n)
              break
            end
            c = s.char_at(i)
            next
          end
          bb.clear
          ui = i
          loop do
            raise AssertError if not ((n - i >= 2))
            bb.put(decode(s.char_at((i += 1)), s.char_at((i += 1))))
            if ((i += 1) >= n)
              break
            end
            c = s.char_at(i)
            if (!(c).equal?(Character.new(?%.ord)))
              break
            end
          end
          bb.flip
          cb.clear
          dec.reset
          cr = dec.decode(bb, cb, true)
          raise AssertError if not (cr.is_underflow)
          cr = dec.flush(cb)
          raise AssertError if not (cr.is_underflow)
          sb.append(cb.flip.to_s)
        end
        return sb.to_s
      end
      
      # -- Parsing --
      # For convenience we wrap the input URI string in a new instance of the
      # following internal class.  This saves always having to pass the input
      # string as an argument to each internal scan/parse method.
      const_set_lazy(:Parser) { Class.new do
        extend LocalClass
        include_class_members URI
        
        attr_accessor :input
        alias_method :attr_input, :input
        undef_method :input
        alias_method :attr_input=, :input=
        undef_method :input=
        
        # URI input string
        attr_accessor :require_server_authority
        alias_method :attr_require_server_authority, :require_server_authority
        undef_method :require_server_authority
        alias_method :attr_require_server_authority=, :require_server_authority=
        undef_method :require_server_authority=
        
        typesig { [String] }
        def initialize(s)
          @input = nil
          @require_server_authority = false
          @ipv6byte_count = 0
          @input = s
          self.attr_string = s
        end
        
        typesig { [String] }
        # -- Methods for throwing URISyntaxException in various ways --
        def fail(reason)
          raise URISyntaxException.new(@input, reason)
        end
        
        typesig { [String, ::Java::Int] }
        def fail(reason, p)
          raise URISyntaxException.new(@input, reason, p)
        end
        
        typesig { [String, ::Java::Int] }
        def fail_expecting(expected, p)
          fail("Expected " + expected, p)
        end
        
        typesig { [String, String, ::Java::Int] }
        def fail_expecting(expected, prior, p)
          fail("Expected " + expected + " following " + prior, p)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # -- Simple access to the input string --
        # Return a substring of the input string
        def substring(start, end_)
          return @input.substring(start, end_)
        end
        
        typesig { [::Java::Int] }
        # Return the char at position p,
        # assuming that p < input.length()
        def char_at(p)
          return @input.char_at(p)
        end
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Char] }
        # Tells whether start < end and, if so, whether charAt(start) == c
        def at(start, end_, c)
          return (start < end_) && ((char_at(start)).equal?(c))
        end
        
        typesig { [::Java::Int, ::Java::Int, String] }
        # Tells whether start + s.length() < end and, if so,
        # whether the chars at the start position match s exactly
        def at(start, end_, s)
          p = start
          sn = s.length
          if (sn > end_ - p)
            return false
          end
          i = 0
          while (i < sn)
            if (!(char_at(((p += 1) - 1))).equal?(s.char_at(i)))
              break
            end
            ((i += 1) - 1)
          end
          return ((i).equal?(sn))
        end
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Char] }
        # -- Scanning --
        # The various scan and parse methods that follow use a uniform
        # convention of taking the current start position and end index as
        # their first two arguments.  The start is inclusive while the end is
        # exclusive, just as in the String class, i.e., a start/end pair
        # denotes the left-open interval [start, end) of the input string.
        # 
        # These methods never proceed past the end position.  They may return
        # -1 to indicate outright failure, but more often they simply return
        # the position of the first char after the last char scanned.  Thus
        # a typical idiom is
        # 
        # int p = start;
        # int q = scan(p, end, ...);
        # if (q > p)
        # // We scanned something
        # ...;
        # else if (q == p)
        # // We scanned nothing
        # ...;
        # else if (q == -1)
        # // Something went wrong
        # ...;
        # Scan a specific char: If the char at the given start position is
        # equal to c, return the index of the next char; otherwise, return the
        # start position.
        def scan(start, end_, c)
          if ((start < end_) && ((char_at(start)).equal?(c)))
            return start + 1
          end
          return start
        end
        
        typesig { [::Java::Int, ::Java::Int, String, String] }
        # Scan forward from the given start position.  Stop at the first char
        # in the err string (in which case -1 is returned), or the first char
        # in the stop string (in which case the index of the preceding char is
        # returned), or the end of the input string (in which case the length
        # of the input string is returned).  May return the start position if
        # nothing matches.
        def scan(start, end_, err, stop)
          p = start
          while (p < end_)
            c = char_at(p)
            if (err.index_of(c) >= 0)
              return -1
            end
            if (stop.index_of(c) >= 0)
              break
            end
            ((p += 1) - 1)
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Char] }
        # Scan a potential escape sequence, starting at the given position,
        # with the given first char (i.e., charAt(start) == c).
        # 
        # This method assumes that if escapes are allowed then visible
        # non-US-ASCII chars are also allowed.
        def scan_escape(start, n, first)
          p = start
          c = first
          if ((c).equal?(Character.new(?%.ord)))
            # Process escape pair
            if ((p + 3 <= n) && match(char_at(p + 1), L_HEX, H_HEX) && match(char_at(p + 2), L_HEX, H_HEX))
              return p + 3
            end
            fail("Malformed escape pair", p)
          else
            if ((c > 128) && !Character.is_space_char(c) && !Character.is_isocontrol(c))
              # Allow unescaped but visible non-US-ASCII chars
              return p + 1
            end
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Long, ::Java::Long] }
        # Scan chars that match the given mask pair
        def scan(start, n, low_mask, high_mask)
          p = start
          while (p < n)
            c = char_at(p)
            if (match(c, low_mask, high_mask))
              ((p += 1) - 1)
              next
            end
            if (!((low_mask & L_ESCAPED)).equal?(0))
              q = scan_escape(p, n, c)
              if (q > p)
                p = q
                next
              end
            end
            break
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Long, ::Java::Long, String] }
        # Check that each of the chars in [start, end) matches the given mask
        def check_chars(start, end_, low_mask, high_mask, what)
          p = scan(start, end_, low_mask, high_mask)
          if (p < end_)
            fail("Illegal character in " + what, p)
          end
        end
        
        typesig { [::Java::Int, ::Java::Long, ::Java::Long, String] }
        # Check that the char at position p matches the given mask
        def check_char(p, low_mask, high_mask, what)
          check_chars(p, p + 1, low_mask, high_mask, what)
        end
        
        typesig { [::Java::Boolean] }
        # -- Parsing --
        # [<scheme>:]<scheme-specific-part>[#<fragment>]
        def parse(rsa)
          @require_server_authority = rsa
          ssp = 0 # Start of scheme-specific part
          n = @input.length
          p = scan(0, n, "/?#", ":")
          if ((p >= 0) && at(p, n, Character.new(?:.ord)))
            if ((p).equal?(0))
              fail_expecting("scheme name", 0)
            end
            check_char(0, L_ALPHA, H_ALPHA, "scheme name")
            check_chars(1, p, L_SCHEME, H_SCHEME, "scheme name")
            self.attr_scheme = substring(0, p)
            ((p += 1) - 1) # Skip ':'
            ssp = p
            if (at(p, n, Character.new(?/.ord)))
              p = parse_hierarchical(p, n)
            else
              q = scan(p, n, "", "#")
              if (q <= p)
                fail_expecting("scheme-specific part", p)
              end
              check_chars(p, q, L_URIC, H_URIC, "opaque part")
              p = q
            end
          else
            ssp = 0
            p = parse_hierarchical(0, n)
          end
          self.attr_scheme_specific_part = substring(ssp, p)
          if (at(p, n, Character.new(?#.ord)))
            check_chars(p + 1, n, L_URIC, H_URIC, "fragment")
            self.attr_fragment = substring(p + 1, n)
            p = n
          end
          if (p < n)
            fail("end of URI", p)
          end
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # [//authority]<path>[?<query>]
        # 
        # DEVIATION from RFC2396: We allow an empty authority component as
        # long as it's followed by a non-empty path, query component, or
        # fragment component.  This is so that URIs such as "file:///foo/bar"
        # will parse.  This seems to be the intent of RFC2396, though the
        # grammar does not permit it.  If the authority is empty then the
        # userInfo, host, and port components are undefined.
        # 
        # DEVIATION from RFC2396: We allow empty relative paths.  This seems
        # to be the intent of RFC2396, but the grammar does not permit it.
        # The primary consequence of this deviation is that "#f" parses as a
        # relative URI with an empty path.
        def parse_hierarchical(start, n)
          p = start
          if (at(p, n, Character.new(?/.ord)) && at(p + 1, n, Character.new(?/.ord)))
            p += 2
            q = scan(p, n, "", "/?#")
            if (q > p)
              p = parse_authority(p, q)
            else
              if (q < n)
                # DEVIATION: Allow empty authority prior to non-empty
                # path, query component or fragment identifier
              else
                fail_expecting("authority", p)
              end
            end
          end
          q_ = scan(p, n, "", "?#") # DEVIATION: May be empty
          check_chars(p, q_, L_PATH, H_PATH, "path")
          self.attr_path = substring(p, q_)
          p = q_
          if (at(p, n, Character.new(??.ord)))
            ((p += 1) - 1)
            q_ = scan(p, n, "", "#")
            check_chars(p, q_, L_URIC, H_URIC, "query")
            self.attr_query = substring(p, q_)
            p = q_
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # authority     = server | reg_name
        # 
        # Ambiguity: An authority that is a registry name rather than a server
        # might have a prefix that parses as a server.  We use the fact that
        # the authority component is always followed by '/' or the end of the
        # input string to resolve this: If the complete authority did not
        # parse as a server then we try to parse it as a registry name.
        def parse_authority(start, n)
          p = start
          q = p
          ex = nil
          server_chars = false
          reg_chars = false
          if (scan(p, n, "", "]") > p)
            # contains a literal IPv6 address, therefore % is allowed
            server_chars = ((scan(p, n, L_SERVER_PERCENT, H_SERVER_PERCENT)).equal?(n))
          else
            server_chars = ((scan(p, n, L_SERVER, H_SERVER)).equal?(n))
          end
          reg_chars = ((scan(p, n, L_REG_NAME, H_REG_NAME)).equal?(n))
          if (reg_chars && !server_chars)
            # Must be a registry-based authority
            self.attr_authority = substring(p, n)
            return n
          end
          if (server_chars)
            # Might be (probably is) a server-based authority, so attempt
            # to parse it as such.  If the attempt fails, try to treat it
            # as a registry-based authority.
            begin
              q = parse_server(p, n)
              if (q < n)
                fail_expecting("end of authority", q)
              end
              self.attr_authority = substring(p, n)
            rescue URISyntaxException => x
              # Undo results of failed parse
              self.attr_user_info = nil
              self.attr_host = nil
              self.attr_port = -1
              if (@require_server_authority)
                # If we're insisting upon a server-based authority,
                # then just re-throw the exception
                raise x
              else
                # Save the exception in case it doesn't parse as a
                # registry either
                ex = x
                q = p
              end
            end
          end
          if (q < n)
            if (reg_chars)
              # Registry-based authority
              self.attr_authority = substring(p, n)
            else
              if (!(ex).nil?)
                # Re-throw exception; it was probably due to
                # a malformed IPv6 address
                raise ex
              else
                fail("Illegal character in authority", q)
              end
            end
          end
          return n
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # [<userinfo>@]<host>[:<port>]
        def parse_server(start, n)
          p = start
          q = 0
          # userinfo
          q = scan(p, n, "/?#", "@")
          if ((q >= p) && at(q, n, Character.new(?@.ord)))
            check_chars(p, q, L_USERINFO, H_USERINFO, "user info")
            self.attr_user_info = substring(p, q)
            p = q + 1 # Skip '@'
          end
          # hostname, IPv4 address, or IPv6 address
          if (at(p, n, Character.new(?[.ord)))
            # DEVIATION from RFC2396: Support IPv6 addresses, per RFC2732
            ((p += 1) - 1)
            q = scan(p, n, "/?#", "]")
            if ((q > p) && at(q, n, Character.new(?].ord)))
              # look for a "%" scope id
              r = scan(p, q, "", "%")
              if (r > p)
                parse_ipv6reference(p, r)
                if ((r + 1).equal?(q))
                  fail("scope id expected")
                end
                check_chars(r + 1, q, L_ALPHANUM, H_ALPHANUM, "scope id")
              else
                parse_ipv6reference(p, q)
              end
              self.attr_host = substring(p - 1, q + 1)
              p = q + 1
            else
              fail_expecting("closing bracket for IPv6 address", q)
            end
          else
            q = parse_ipv4address(p, n)
            if (q <= p)
              q = parse_hostname(p, n)
            end
            p = q
          end
          # port
          if (at(p, n, Character.new(?:.ord)))
            ((p += 1) - 1)
            q = scan(p, n, "", "/")
            if (q > p)
              check_chars(p, q, L_DIGIT, H_DIGIT, "port number")
              begin
                self.attr_port = JavaInteger.parse_int(substring(p, q))
              rescue NumberFormatException => x
                fail("Malformed port number", p)
              end
              p = q
            end
          end
          if (p < n)
            fail_expecting("port number", p)
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Scan a string of decimal digits whose value fits in a byte
        def scan_byte(start, n)
          p = start
          q = scan(p, n, L_DIGIT, H_DIGIT)
          if (q <= p)
            return q
          end
          if (JavaInteger.parse_int(substring(p, q)) > 255)
            return p
          end
          return q
        end
        
        typesig { [::Java::Int, ::Java::Int, ::Java::Boolean] }
        # Scan an IPv4 address.
        # 
        # If the strict argument is true then we require that the given
        # interval contain nothing besides an IPv4 address; if it is false
        # then we only require that it start with an IPv4 address.
        # 
        # If the interval does not contain or start with (depending upon the
        # strict argument) a legal IPv4 address characters then we return -1
        # immediately; otherwise we insist that these characters parse as a
        # legal IPv4 address and throw an exception on failure.
        # 
        # We assume that any string of decimal digits and dots must be an IPv4
        # address.  It won't parse as a hostname anyway, so making that
        # assumption here allows more meaningful exceptions to be thrown.
        def scan_ipv4address(start, n, strict)
          p = start
          q = 0
          m = scan(p, n, L_DIGIT | L_DOT, H_DIGIT | H_DOT)
          if ((m <= p) || (strict && (!(m).equal?(n))))
            return -1
          end
          loop do
            # Per RFC2732: At most three digits per byte
            # Further constraint: Each element fits in a byte
            if ((q = scan_byte(p, m)) <= p)
              break
            end
            p = q
            if ((q = scan(p, m, Character.new(?..ord))) <= p)
              break
            end
            p = q
            if ((q = scan_byte(p, m)) <= p)
              break
            end
            p = q
            if ((q = scan(p, m, Character.new(?..ord))) <= p)
              break
            end
            p = q
            if ((q = scan_byte(p, m)) <= p)
              break
            end
            p = q
            if ((q = scan(p, m, Character.new(?..ord))) <= p)
              break
            end
            p = q
            if ((q = scan_byte(p, m)) <= p)
              break
            end
            p = q
            if (q < m)
              break
            end
            return q
          end
          fail("Malformed IPv4 address", q)
          return -1
        end
        
        typesig { [::Java::Int, ::Java::Int, String] }
        # Take an IPv4 address: Throw an exception if the given interval
        # contains anything except an IPv4 address
        def take_ipv4address(start, n, expected)
          p = scan_ipv4address(start, n, true)
          if (p <= start)
            fail_expecting(expected, start)
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Attempt to parse an IPv4 address, returning -1 on failure but
        # allowing the given interval to contain [:<characters>] after
        # the IPv4 address.
        def parse_ipv4address(start, n)
          p = 0
          begin
            p = scan_ipv4address(start, n, false)
          rescue URISyntaxException => x
            return -1
          rescue NumberFormatException => nfe
            return -1
          end
          if (p > start && p < n)
            # IPv4 address is followed by something - check that
            # it's a ":" as this is the only valid character to
            # follow an address.
            if (!(char_at(p)).equal?(Character.new(?:.ord)))
              p = -1
            end
          end
          if (p > start)
            self.attr_host = substring(start, p)
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # hostname      = domainlabel [ "." ] | 1*( domainlabel "." ) toplabel [ "." ]
        # domainlabel   = alphanum | alphanum *( alphanum | "-" ) alphanum
        # toplabel      = alpha | alpha *( alphanum | "-" ) alphanum
        def parse_hostname(start, n)
          p = start
          q = 0
          l = -1 # Start of last parsed label
          begin
            # domainlabel = alphanum [ *( alphanum | "-" ) alphanum ]
            q = scan(p, n, L_ALPHANUM, H_ALPHANUM)
            if (q <= p)
              break
            end
            l = p
            if (q > p)
              p = q
              q = scan(p, n, L_ALPHANUM | L_DASH, H_ALPHANUM | H_DASH)
              if (q > p)
                if ((char_at(q - 1)).equal?(Character.new(?-.ord)))
                  fail("Illegal character in hostname", q - 1)
                end
                p = q
              end
            end
            q = scan(p, n, Character.new(?..ord))
            if (q <= p)
              break
            end
            p = q
          end while (p < n)
          if ((p < n) && !at(p, n, Character.new(?:.ord)))
            fail("Illegal character in hostname", p)
          end
          if (l < 0)
            fail_expecting("hostname", start)
          end
          # for a fully qualified hostname check that the rightmost
          # label starts with an alpha character.
          if (l > start && !match(char_at(l), L_ALPHA, H_ALPHA))
            fail("Illegal character in hostname", l)
          end
          self.attr_host = substring(start, p)
          return p
        end
        
        # IPv6 address parsing, from RFC2373: IPv6 Addressing Architecture
        # 
        # Bug: The grammar in RFC2373 Appendix B does not allow addresses of
        # the form ::12.34.56.78, which are clearly shown in the examples
        # earlier in the document.  Here is the original grammar:
        # 
        # IPv6address = hexpart [ ":" IPv4address ]
        # hexpart     = hexseq | hexseq "::" [ hexseq ] | "::" [ hexseq ]
        # hexseq      = hex4 *( ":" hex4)
        # hex4        = 1*4HEXDIG
        # 
        # We therefore use the following revised grammar:
        # 
        # IPv6address = hexseq [ ":" IPv4address ]
        # | hexseq [ "::" [ hexpost ] ]
        # | "::" [ hexpost ]
        # hexpost     = hexseq | hexseq ":" IPv4address | IPv4address
        # hexseq      = hex4 *( ":" hex4)
        # hex4        = 1*4HEXDIG
        # 
        # This covers all and only the following cases:
        # 
        # hexseq
        # hexseq : IPv4address
        # hexseq ::
        # hexseq :: hexseq
        # hexseq :: hexseq : IPv4address
        # hexseq :: IPv4address
        # :: hexseq
        # :: hexseq : IPv4address
        # :: IPv4address
        # ::
        # 
        # Additionally we constrain the IPv6 address as follows :-
        # 
        # i.  IPv6 addresses without compressed zeros should contain
        # exactly 16 bytes.
        # 
        # ii. IPv6 addresses with compressed zeros should contain
        # less than 16 bytes.
        attr_accessor :ipv6byte_count
        alias_method :attr_ipv6byte_count, :ipv6byte_count
        undef_method :ipv6byte_count
        alias_method :attr_ipv6byte_count=, :ipv6byte_count=
        undef_method :ipv6byte_count=
        
        typesig { [::Java::Int, ::Java::Int] }
        def parse_ipv6reference(start, n)
          p = start
          q = 0
          compressed_zeros = false
          q = scan_hex_seq(p, n)
          if (q > p)
            p = q
            if (at(p, n, "::"))
              compressed_zeros = true
              p = scan_hex_post(p + 2, n)
            else
              if (at(p, n, Character.new(?:.ord)))
                p = take_ipv4address(p + 1, n, "IPv4 address")
                @ipv6byte_count += 4
              end
            end
          else
            if (at(p, n, "::"))
              compressed_zeros = true
              p = scan_hex_post(p + 2, n)
            end
          end
          if (p < n)
            fail("Malformed IPv6 address", start)
          end
          if (@ipv6byte_count > 16)
            fail("IPv6 address too long", start)
          end
          if (!compressed_zeros && @ipv6byte_count < 16)
            fail("IPv6 address too short", start)
          end
          if (compressed_zeros && (@ipv6byte_count).equal?(16))
            fail("Malformed IPv6 address", start)
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        def scan_hex_post(start, n)
          p = start
          q = 0
          if ((p).equal?(n))
            return p
          end
          q = scan_hex_seq(p, n)
          if (q > p)
            p = q
            if (at(p, n, Character.new(?:.ord)))
              ((p += 1) - 1)
              p = take_ipv4address(p, n, "hex digits or IPv4 address")
              @ipv6byte_count += 4
            end
          else
            p = take_ipv4address(p, n, "hex digits or IPv4 address")
            @ipv6byte_count += 4
          end
          return p
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Scan a hex sequence; return -1 if one could not be scanned
        def scan_hex_seq(start, n)
          p = start
          q = 0
          q = scan(p, n, L_HEX, H_HEX)
          if (q <= p)
            return -1
          end
          if (at(q, n, Character.new(?..ord)))
            # Beginning of IPv4 address
            return -1
          end
          if (q > p + 4)
            fail("IPv6 hexadecimal digit sequence too long", p)
          end
          @ipv6byte_count += 2
          p = q
          while (p < n)
            if (!at(p, n, Character.new(?:.ord)))
              break
            end
            if (at(p + 1, n, Character.new(?:.ord)))
              break
            end # "::"
            ((p += 1) - 1)
            q = scan(p, n, L_HEX, H_HEX)
            if (q <= p)
              fail_expecting("digits for an IPv6 address", p)
            end
            if (at(q, n, Character.new(?..ord)))
              # Beginning of IPv4 address
              ((p -= 1) + 1)
              break
            end
            if (q > p + 4)
              fail("IPv6 hexadecimal digit sequence too long", p)
            end
            @ipv6byte_count += 2
            p = q
          end
          return p
        end
        
        private
        alias_method :initialize__parser, :initialize
      end }
    }
    
    private
    alias_method :initialize__uri, :initialize
  end
  
end
