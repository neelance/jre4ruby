require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Io
  module ObjectStreamConstantsImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # Constants written into the Object Serialization Stream.
  # 
  # @author  unascribed
  # @since JDK 1.1
  module ObjectStreamConstants
    include_class_members ObjectStreamConstantsImports
    
    class_module.module_eval {
      # Magic number that is written to the stream header.
      const_set_lazy(:STREAM_MAGIC) { RJava.cast_to_short(0xaced) }
      const_attr_reader  :STREAM_MAGIC
      
      # Version number that is written to the stream header.
      const_set_lazy(:STREAM_VERSION) { 5 }
      const_attr_reader  :STREAM_VERSION
      
      # Each item in the stream is preceded by a tag
      # 
      # 
      # First tag value.
      const_set_lazy(:TC_BASE) { 0x70 }
      const_attr_reader  :TC_BASE
      
      # Null object reference.
      const_set_lazy(:TC_NULL) { 0x70 }
      const_attr_reader  :TC_NULL
      
      # Reference to an object already written into the stream.
      const_set_lazy(:TC_REFERENCE) { 0x71 }
      const_attr_reader  :TC_REFERENCE
      
      # new Class Descriptor.
      const_set_lazy(:TC_CLASSDESC) { 0x72 }
      const_attr_reader  :TC_CLASSDESC
      
      # new Object.
      const_set_lazy(:TC_OBJECT) { 0x73 }
      const_attr_reader  :TC_OBJECT
      
      # new String.
      const_set_lazy(:TC_STRING) { 0x74 }
      const_attr_reader  :TC_STRING
      
      # new Array.
      const_set_lazy(:TC_ARRAY) { 0x75 }
      const_attr_reader  :TC_ARRAY
      
      # Reference to Class.
      const_set_lazy(:TC_CLASS) { 0x76 }
      const_attr_reader  :TC_CLASS
      
      # Block of optional data. Byte following tag indicates number
      # of bytes in this block data.
      const_set_lazy(:TC_BLOCKDATA) { 0x77 }
      const_attr_reader  :TC_BLOCKDATA
      
      # End of optional block data blocks for an object.
      const_set_lazy(:TC_ENDBLOCKDATA) { 0x78 }
      const_attr_reader  :TC_ENDBLOCKDATA
      
      # Reset stream context. All handles written into stream are reset.
      const_set_lazy(:TC_RESET) { 0x79 }
      const_attr_reader  :TC_RESET
      
      # long Block data. The long following the tag indicates the
      # number of bytes in this block data.
      const_set_lazy(:TC_BLOCKDATALONG) { 0x7a }
      const_attr_reader  :TC_BLOCKDATALONG
      
      # Exception during write.
      const_set_lazy(:TC_EXCEPTION) { 0x7b }
      const_attr_reader  :TC_EXCEPTION
      
      # Long string.
      const_set_lazy(:TC_LONGSTRING) { 0x7c }
      const_attr_reader  :TC_LONGSTRING
      
      # new Proxy Class Descriptor.
      const_set_lazy(:TC_PROXYCLASSDESC) { 0x7d }
      const_attr_reader  :TC_PROXYCLASSDESC
      
      # new Enum constant.
      # @since 1.5
      const_set_lazy(:TC_ENUM) { 0x7e }
      const_attr_reader  :TC_ENUM
      
      # Last tag value.
      const_set_lazy(:TC_MAX) { 0x7e }
      const_attr_reader  :TC_MAX
      
      # First wire handle to be assigned.
      const_set_lazy(:BaseWireHandle) { 0x7e0000 }
      const_attr_reader  :BaseWireHandle
      
      # Bit masks for ObjectStreamClass flag.
      # 
      # Bit mask for ObjectStreamClass flag. Indicates a Serializable class
      # defines its own writeObject method.
      const_set_lazy(:SC_WRITE_METHOD) { 0x1 }
      const_attr_reader  :SC_WRITE_METHOD
      
      # Bit mask for ObjectStreamClass flag. Indicates Externalizable data
      # written in Block Data mode.
      # Added for PROTOCOL_VERSION_2.
      # 
      # @see #PROTOCOL_VERSION_2
      # @since 1.2
      const_set_lazy(:SC_BLOCK_DATA) { 0x8 }
      const_attr_reader  :SC_BLOCK_DATA
      
      # Bit mask for ObjectStreamClass flag. Indicates class is Serializable.
      const_set_lazy(:SC_SERIALIZABLE) { 0x2 }
      const_attr_reader  :SC_SERIALIZABLE
      
      # Bit mask for ObjectStreamClass flag. Indicates class is Externalizable.
      const_set_lazy(:SC_EXTERNALIZABLE) { 0x4 }
      const_attr_reader  :SC_EXTERNALIZABLE
      
      # Bit mask for ObjectStreamClass flag. Indicates class is an enum type.
      # @since 1.5
      const_set_lazy(:SC_ENUM) { 0x10 }
      const_attr_reader  :SC_ENUM
      
      # ******************************************************************
      # Security permissions
      # 
      # Enable substitution of one object for another during
      # serialization/deserialization.
      # 
      # @see java.io.ObjectOutputStream#enableReplaceObject(boolean)
      # @see java.io.ObjectInputStream#enableResolveObject(boolean)
      # @since 1.2
      const_set_lazy(:SUBSTITUTION_PERMISSION) { SerializablePermission.new("enableSubstitution") }
      const_attr_reader  :SUBSTITUTION_PERMISSION
      
      # Enable overriding of readObject and writeObject.
      # 
      # @see java.io.ObjectOutputStream#writeObjectOverride(Object)
      # @see java.io.ObjectInputStream#readObjectOverride()
      # @since 1.2
      const_set_lazy(:SUBCLASS_IMPLEMENTATION_PERMISSION) { SerializablePermission.new("enableSubclassImplementation") }
      const_attr_reader  :SUBCLASS_IMPLEMENTATION_PERMISSION
      
      # A Stream Protocol Version. <p>
      # 
      # All externalizable data is written in JDK 1.1 external data
      # format after calling this method. This version is needed to write
      # streams containing Externalizable data that can be read by
      # pre-JDK 1.1.6 JVMs.
      # 
      # @see java.io.ObjectOutputStream#useProtocolVersion(int)
      # @since 1.2
      const_set_lazy(:PROTOCOL_VERSION_1) { 1 }
      const_attr_reader  :PROTOCOL_VERSION_1
      
      # A Stream Protocol Version. <p>
      # 
      # This protocol is written by JVM 1.2.
      # 
      # Externalizable data is written in block data mode and is
      # terminated with TC_ENDBLOCKDATA. Externalizable classdescriptor
      # flags has SC_BLOCK_DATA enabled. JVM 1.1.6 and greater can
      # read this format change.
      # 
      # Enables writing a nonSerializable class descriptor into the
      # stream. The serialVersionUID of a nonSerializable class is
      # set to 0L.
      # 
      # @see java.io.ObjectOutputStream#useProtocolVersion(int)
      # @see #SC_BLOCK_DATA
      # @since 1.2
      const_set_lazy(:PROTOCOL_VERSION_2) { 2 }
      const_attr_reader  :PROTOCOL_VERSION_2
    }
  end
  
end
