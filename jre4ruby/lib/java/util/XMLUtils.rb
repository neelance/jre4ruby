require "rjava"

# Copyright 2003-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Util
  module XMLUtilsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util
      include ::Java::Io
      include ::Org::Xml::Sax
      include ::Org::Xml::Sax::Helpers
      include ::Org::W3c::Dom
      include ::Javax::Xml::Parsers
      include ::Javax::Xml::Transform
      include ::Javax::Xml::Transform::Dom
      include ::Javax::Xml::Transform::Stream
    }
  end
  
  # A class used to aid in Properties load and save in XML. Keeping this
  # code outside of Properties helps reduce the number of classes loaded
  # when Properties is loaded.
  # 
  # @author  Michael McCloskey
  # @since   1.3
  class XMLUtils 
    include_class_members XMLUtilsImports
    
    class_module.module_eval {
      # XML loading and saving methods for Properties
      # The required DTD URI for exported properties
      const_set_lazy(:PROPS_DTD_URI) { "http://java.sun.com/dtd/properties.dtd" }
      const_attr_reader  :PROPS_DTD_URI
      
      const_set_lazy(:PROPS_DTD) { "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "<!-- DTD for properties -->" + "<!ELEMENT properties ( comment?, entry* ) >" + "<!ATTLIST properties" + " version CDATA #FIXED \"1.0\">" + "<!ELEMENT comment (#PCDATA) >" + "<!ELEMENT entry (#PCDATA) >" + "<!ATTLIST entry " + " key CDATA #REQUIRED>" }
      const_attr_reader  :PROPS_DTD
      
      # Version number for the format of exported properties files.
      const_set_lazy(:EXTERNAL_XML_VERSION) { "1.0" }
      const_attr_reader  :EXTERNAL_XML_VERSION
      
      typesig { [Properties, InputStream] }
      def load(props, in_)
        doc = nil
        begin
          doc = get_loading_doc(in_)
        rescue SAXException => saxe
          raise InvalidPropertiesFormatException.new(saxe)
        end
        properties_element = doc.get_child_nodes.item(1)
        xml_version = properties_element.get_attribute("version")
        if ((xml_version <=> EXTERNAL_XML_VERSION) > 0)
          raise InvalidPropertiesFormatException.new("Exported Properties file format version " + xml_version + " is not supported. This java installation can read" + " versions " + EXTERNAL_XML_VERSION + " or older. You" + " may need to install a newer version of JDK.")
        end
        import_properties(props, properties_element)
      end
      
      typesig { [InputStream] }
      def get_loading_doc(in_)
        dbf = DocumentBuilderFactory.new_instance
        dbf.set_ignoring_element_content_whitespace(true)
        dbf.set_validating(true)
        dbf.set_coalescing(true)
        dbf.set_ignoring_comments(true)
        begin
          db = dbf.new_document_builder
          db.set_entity_resolver(Resolver.new)
          db.set_error_handler(EH.new)
          is = InputSource.new(in_)
          return db.parse(is)
        rescue ParserConfigurationException => x
          raise JavaError.new(x)
        end
      end
      
      typesig { [Properties, Element] }
      def import_properties(props, properties_element)
        entries = properties_element.get_child_nodes
        num_entries = entries.get_length
        start = num_entries > 0 && (entries.item(0).get_node_name == "comment") ? 1 : 0
        i = start
        while i < num_entries
          entry = entries.item(i)
          if (entry.has_attribute("key"))
            n = entry.get_first_child
            val = ((n).nil?) ? "" : n.get_node_value
            props.set_property(entry.get_attribute("key"), val)
          end
          i += 1
        end
      end
      
      typesig { [Properties, OutputStream, String, String] }
      def save(props, os, comment, encoding)
        dbf = DocumentBuilderFactory.new_instance
        db = nil
        begin
          db = dbf.new_document_builder
        rescue ParserConfigurationException => pce
          raise AssertError if not ((false))
        end
        doc = db.new_document
        properties = doc.append_child(doc.create_element("properties"))
        if (!(comment).nil?)
          comments = properties.append_child(doc.create_element("comment"))
          comments.append_child(doc.create_text_node(comment))
        end
        keys = props.key_set
        i = keys.iterator
        while (i.has_next)
          key = i.next
          entry = properties.append_child(doc.create_element("entry"))
          entry.set_attribute("key", key)
          entry.append_child(doc.create_text_node(props.get_property(key)))
        end
        emit_document(doc, os, encoding)
      end
      
      typesig { [Document, OutputStream, String] }
      def emit_document(doc, os, encoding)
        tf = TransformerFactory.new_instance
        t = nil
        begin
          t = tf.new_transformer
          t.set_output_property(OutputKeys::DOCTYPE_SYSTEM, PROPS_DTD_URI)
          t.set_output_property(OutputKeys::INDENT, "yes")
          t.set_output_property(OutputKeys::METHOD, "xml")
          t.set_output_property(OutputKeys::ENCODING, encoding)
        rescue TransformerConfigurationException => tce
          raise AssertError if not ((false))
        end
        doms = DOMSource.new(doc)
        sr = StreamResult.new(os)
        begin
          t.transform(doms, sr)
        rescue TransformerException => te
          ioe = IOException.new
          ioe.init_cause(te)
          raise ioe
        end
      end
      
      const_set_lazy(:Resolver) { Class.new do
        include_class_members XMLUtils
        include EntityResolver
        
        typesig { [String, String] }
        def resolve_entity(pid, sid)
          if ((sid == PROPS_DTD_URI))
            is = nil
            is = InputSource.new(StringReader.new(PROPS_DTD))
            is.set_system_id(PROPS_DTD_URI)
            return is
          end
          raise SAXException.new("Invalid system identifier: " + sid)
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__resolver, :initialize
      end }
      
      const_set_lazy(:EH) { Class.new do
        include_class_members XMLUtils
        include ErrorHandler
        
        typesig { [SAXParseException] }
        def error(x)
          raise x
        end
        
        typesig { [SAXParseException] }
        def fatal_error(x)
          raise x
        end
        
        typesig { [SAXParseException] }
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
    alias_method :initialize__xmlutils, :initialize
  end
  
end
