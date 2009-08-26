require "rjava"

# Copyright 2002-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util::Prefs
  module XmlSupportImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
      include ::Java::Util
      include ::Java::Io
      include ::Javax::Xml::Parsers
      include ::Javax::Xml::Transform
      include ::Javax::Xml::Transform::Dom
      include ::Javax::Xml::Transform::Stream
      include ::Org::Xml::Sax
      include ::Org::W3c::Dom
    }
  end
  
  # XML Support for java.util.prefs. Methods to import and export preference
  # nodes and subtrees.
  # 
  # @author  Josh Bloch and Mark Reinhold
  # @see     Preferences
  # @since   1.4
  class XmlSupport 
    include_class_members XmlSupportImports
    
    class_module.module_eval {
      # The required DTD URI for exported preferences
      const_set_lazy(:PREFS_DTD_URI) { "http://java.sun.com/dtd/preferences.dtd" }
      const_attr_reader  :PREFS_DTD_URI
      
      # The actual DTD corresponding to the URI
      const_set_lazy(:PREFS_DTD) { "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "<!-- DTD for preferences -->" + "<!ELEMENT preferences (root) >" + "<!ATTLIST preferences" + " EXTERNAL_XML_VERSION CDATA \"0.0\"  >" + "<!ELEMENT root (map, node*) >" + "<!ATTLIST root" + "          type (system|user) #REQUIRED >" + "<!ELEMENT node (map, node*) >" + "<!ATTLIST node" + "          name CDATA #REQUIRED >" + "<!ELEMENT map (entry*) >" + "<!ATTLIST map" + "  MAP_XML_VERSION CDATA \"0.0\"  >" + "<!ELEMENT entry EMPTY >" + "<!ATTLIST entry" + "          key CDATA #REQUIRED" + "          value CDATA #REQUIRED >" }
      const_attr_reader  :PREFS_DTD
      
      # Version number for the format exported preferences files.
      const_set_lazy(:EXTERNAL_XML_VERSION) { "1.0" }
      const_attr_reader  :EXTERNAL_XML_VERSION
      
      # Version number for the internal map files.
      const_set_lazy(:MAP_XML_VERSION) { "1.0" }
      const_attr_reader  :MAP_XML_VERSION
      
      typesig { [OutputStream, Preferences, ::Java::Boolean] }
      # Export the specified preferences node and, if subTree is true, all
      # subnodes, to the specified output stream.  Preferences are exported as
      # an XML document conforming to the definition in the Preferences spec.
      # 
      # @throws IOException if writing to the specified output stream
      # results in an <tt>IOException</tt>.
      # @throws BackingStoreException if preference data cannot be read from
      # backing store.
      # @throws IllegalStateException if this node (or an ancestor) has been
      # removed with the {@link #removeNode()} method.
      def export(os, p, sub_tree)
        if ((p).is_removed)
          raise IllegalStateException.new("Node has been removed")
        end
        doc = create_prefs_doc("preferences")
        preferences = doc.get_document_element
        preferences.set_attribute("EXTERNAL_XML_VERSION", EXTERNAL_XML_VERSION)
        xml_root = preferences.append_child(doc.create_element("root"))
        xml_root.set_attribute("type", (p.is_user_node ? "user" : "system"))
        # Get bottom-up list of nodes from p to root, excluding root
        ancestors = ArrayList.new
        kid = p
        dad = kid.parent
        while !(dad).nil?
          ancestors.add(kid)
          kid = dad
          dad = kid.parent
        end
        e = xml_root
        i = ancestors.size - 1
        while i >= 0
          e.append_child(doc.create_element("map"))
          e = e.append_child(doc.create_element("node"))
          e.set_attribute("name", (ancestors.get(i)).name)
          i -= 1
        end
        put_preferences_in_xml(e, doc, p, sub_tree)
        write_doc(doc, os)
      end
      
      typesig { [Element, Document, Preferences, ::Java::Boolean] }
      # Put the preferences in the specified Preferences node into the
      # specified XML element which is assumed to represent a node
      # in the specified XML document which is assumed to conform to
      # PREFS_DTD.  If subTree is true, create children of the specified
      # XML node conforming to all of the children of the specified
      # Preferences node and recurse.
      # 
      # @throws BackingStoreException if it is not possible to read
      # the preferences or children out of the specified
      # preferences node.
      def put_preferences_in_xml(elt, doc, prefs, sub_tree)
        kids_copy = nil
        kid_names = nil
        # Node is locked to export its contents and get a
        # copy of children, then lock is released,
        # and, if subTree = true, recursive calls are made on children
        synchronized(((prefs).attr_lock)) do
          # Check if this node was concurrently removed. If yes
          # remove it from XML Document and return.
          if ((prefs).is_removed)
            elt.get_parent_node.remove_child(elt)
            return
          end
          # Put map in xml element
          keys_ = prefs.keys
          map = elt.append_child(doc.create_element("map"))
          i = 0
          while i < keys_.attr_length
            entry = map.append_child(doc.create_element("entry"))
            entry.set_attribute("key", keys_[i])
            # NEXT STATEMENT THROWS NULL PTR EXC INSTEAD OF ASSERT FAIL
            entry.set_attribute("value", prefs.get(keys_[i], nil))
            i += 1
          end
          # Recurse if appropriate
          if (sub_tree)
            # Get a copy of kids while lock is held
            kid_names = prefs.children_names
            kids_copy = Array.typed(Preferences).new(kid_names.attr_length) { nil }
            i_ = 0
            while i_ < kid_names.attr_length
              kids_copy[i_] = prefs.node(kid_names[i_])
              i_ += 1
            end
          end
          # release lock
        end
        if (sub_tree)
          i_ = 0
          while i_ < kid_names.attr_length
            xml_kid = elt.append_child(doc.create_element("node"))
            xml_kid.set_attribute("name", kid_names[i_])
            put_preferences_in_xml(xml_kid, doc, kids_copy[i_], sub_tree)
            i_ += 1
          end
        end
      end
      
      typesig { [InputStream] }
      # Import preferences from the specified input stream, which is assumed
      # to contain an XML document in the format described in the Preferences
      # spec.
      # 
      # @throws IOException if reading from the specified output stream
      # results in an <tt>IOException</tt>.
      # @throws InvalidPreferencesFormatException Data on input stream does not
      # constitute a valid XML document with the mandated document type.
      def import_preferences(is)
        begin
          doc = load_prefs_doc(is)
          xml_version = doc.get_document_element.get_attribute("EXTERNAL_XML_VERSION")
          if ((xml_version <=> EXTERNAL_XML_VERSION) > 0)
            raise InvalidPreferencesFormatException.new("Exported preferences file format version " + xml_version + " is not supported. This java installation can read" + " versions " + EXTERNAL_XML_VERSION + " or older. You may need" + " to install a newer version of JDK.")
          end
          xml_root = doc.get_document_element.get_child_nodes.item(0)
          prefs_root = ((xml_root.get_attribute("type") == "user") ? Preferences.user_root : Preferences.system_root)
          _import_subtree(prefs_root, xml_root)
        rescue SAXException => e
          raise InvalidPreferencesFormatException.new(e)
        end
      end
      
      typesig { [String] }
      # Create a new prefs XML document.
      def create_prefs_doc(qname)
        begin
          di = DocumentBuilderFactory.new_instance.new_document_builder.get_domimplementation
          dt = di.create_document_type(qname, nil, PREFS_DTD_URI)
          return di.create_document(nil, qname, dt)
        rescue ParserConfigurationException => e
          raise AssertionError.new(e)
        end
      end
      
      typesig { [InputStream] }
      # Load an XML document from specified input stream, which must
      # have the requisite DTD URI.
      def load_prefs_doc(in_)
        dbf = DocumentBuilderFactory.new_instance
        dbf.set_ignoring_element_content_whitespace(true)
        dbf.set_validating(true)
        dbf.set_coalescing(true)
        dbf.set_ignoring_comments(true)
        begin
          db = dbf.new_document_builder
          db.set_entity_resolver(Resolver.new)
          db.set_error_handler(EH.new)
          return db.parse(InputSource.new(in_))
        rescue ParserConfigurationException => e
          raise AssertionError.new(e)
        end
      end
      
      typesig { [Document, OutputStream] }
      # Write XML document to the specified output stream.
      def write_doc(doc, out)
        begin
          tf = TransformerFactory.new_instance
          begin
            tf.set_attribute("indent-number", 2)
          rescue IllegalArgumentException => iae
            # Ignore the IAE. Should not fail the writeout even the
            # transformer provider does not support "indent-number".
          end
          t = tf.new_transformer
          t.set_output_property(OutputKeys::DOCTYPE_SYSTEM, doc.get_doctype.get_system_id)
          t.set_output_property(OutputKeys::INDENT, "yes")
          # Transformer resets the "indent" info if the "result" is a StreamResult with
          # an OutputStream object embedded, creating a Writer object on top of that
          # OutputStream object however works.
          t.transform(DOMSource.new(doc), StreamResult.new(BufferedWriter.new(OutputStreamWriter.new(out, "UTF-8"))))
        rescue TransformerException => e
          raise AssertionError.new(e)
        end
      end
      
      typesig { [Preferences, Element] }
      # Recursively traverse the specified preferences node and store
      # the described preferences into the system or current user
      # preferences tree, as appropriate.
      def _import_subtree(prefs_node, xml_node)
        xml_kids = xml_node.get_child_nodes
        num_xml_kids = xml_kids.get_length
        # We first lock the node, import its contents and get
        # child nodes. Then we unlock the node and go to children
        # Since some of the children might have been concurrently
        # deleted we check for this.
        prefs_kids = nil
        # Lock the node
        synchronized(((prefs_node).attr_lock)) do
          # If removed, return silently
          if ((prefs_node).is_removed)
            return
          end
          # Import any preferences at this node
          first_xml_kid = xml_kids.item(0)
          _import_prefs(prefs_node, first_xml_kid)
          prefs_kids = Array.typed(Preferences).new(num_xml_kids - 1) { nil }
          # Get involved children
          i = 1
          while i < num_xml_kids
            xml_kid = xml_kids.item(i)
            prefs_kids[i - 1] = prefs_node.node(xml_kid.get_attribute("name"))
            i += 1
          end
        end # unlocked the node
        # import children
        i_ = 1
        while i_ < num_xml_kids
          _import_subtree(prefs_kids[i_ - 1], xml_kids.item(i_))
          i_ += 1
        end
      end
      
      typesig { [Preferences, Element] }
      # Import the preferences described by the specified XML element
      # (a map from a preferences document) into the specified
      # preferences node.
      def _import_prefs(prefs_node, map)
        entries = map.get_child_nodes
        i = 0
        num_entries = entries.get_length
        while i < num_entries
          entry = entries.item(i)
          prefs_node.put(entry.get_attribute("key"), entry.get_attribute("value"))
          i += 1
        end
      end
      
      typesig { [OutputStream, Map] }
      # Export the specified Map<String,String> to a map document on
      # the specified OutputStream as per the prefs DTD.  This is used
      # as the internal (undocumented) format for FileSystemPrefs.
      # 
      # @throws IOException if writing to the specified output stream
      # results in an <tt>IOException</tt>.
      def export_map(os, map)
        doc = create_prefs_doc("map")
        xml_map = doc.get_document_element
        xml_map.set_attribute("MAP_XML_VERSION", MAP_XML_VERSION)
        i = map.entry_set.iterator
        while i.has_next
          e = i.next_
          xe = xml_map.append_child(doc.create_element("entry"))
          xe.set_attribute("key", e.get_key)
          xe.set_attribute("value", e.get_value)
        end
        write_doc(doc, os)
      end
      
      typesig { [InputStream, Map] }
      # Import Map from the specified input stream, which is assumed
      # to contain a map document as per the prefs DTD.  This is used
      # as the internal (undocumented) format for FileSystemPrefs.  The
      # key-value pairs specified in the XML document will be put into
      # the specified Map.  (If this Map is empty, it will contain exactly
      # the key-value pairs int the XML-document when this method returns.)
      # 
      # @throws IOException if reading from the specified output stream
      # results in an <tt>IOException</tt>.
      # @throws InvalidPreferencesFormatException Data on input stream does not
      # constitute a valid XML document with the mandated document type.
      def import_map(is, m)
        begin
          doc = load_prefs_doc(is)
          xml_map = doc.get_document_element
          # check version
          map_version = xml_map.get_attribute("MAP_XML_VERSION")
          if ((map_version <=> MAP_XML_VERSION) > 0)
            raise InvalidPreferencesFormatException.new("Preferences map file format version " + map_version + " is not supported. This java installation can read" + " versions " + MAP_XML_VERSION + " or older. You may need" + " to install a newer version of JDK.")
          end
          entries = xml_map.get_child_nodes
          i = 0
          num_entries = entries.get_length
          while i < num_entries
            entry = entries.item(i)
            m.put(entry.get_attribute("key"), entry.get_attribute("value"))
            i += 1
          end
        rescue SAXException => e
          raise InvalidPreferencesFormatException.new(e)
        end
      end
      
      const_set_lazy(:Resolver) { Class.new do
        include_class_members XmlSupport
        include EntityResolver
        
        typesig { [String, String] }
        def resolve_entity(pid, sid)
          if ((sid == PREFS_DTD_URI))
            is = nil
            is = self.class::InputSource.new(self.class::StringReader.new(PREFS_DTD))
            is.set_system_id(PREFS_DTD_URI)
            return is
          end
          raise self.class::SAXException.new("Invalid system identifier: " + sid)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__resolver, :initialize
      end }
      
      const_set_lazy(:EH) { Class.new do
        include_class_members XmlSupport
        include ErrorHandler
        
        typesig { [self::SAXParseException] }
        def error(x)
          raise x
        end
        
        typesig { [self::SAXParseException] }
        def fatal_error(x)
          raise x
        end
        
        typesig { [self::SAXParseException] }
        def warning(x)
          raise x
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__eh, :initialize
      end }
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__xml_support, :initialize
  end
  
end
