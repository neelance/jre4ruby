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
  module ObjectOutputStreamImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Io::ObjectStreamClass, :WeakClassKey
      include_const ::Java::Lang::Ref, :ReferenceQueue
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :JavaList
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Util::Concurrent, :ConcurrentMap
      include_const ::Java::Io::ObjectStreamClass, :ProcessQueue
    }
  end
  
  # An ObjectOutputStream writes primitive data types and graphs of Java objects
  # to an OutputStream.  The objects can be read (reconstituted) using an
  # ObjectInputStream.  Persistent storage of objects can be accomplished by
  # using a file for the stream.  If the stream is a network socket stream, the
  # objects can be reconstituted on another host or in another process.
  # 
  # <p>Only objects that support the java.io.Serializable interface can be
  # written to streams.  The class of each serializable object is encoded
  # including the class name and signature of the class, the values of the
  # object's fields and arrays, and the closure of any other objects referenced
  # from the initial objects.
  # 
  # <p>The method writeObject is used to write an object to the stream.  Any
  # object, including Strings and arrays, is written with writeObject. Multiple
  # objects or primitives can be written to the stream.  The objects must be
  # read back from the corresponding ObjectInputstream with the same types and
  # in the same order as they were written.
  # 
  # <p>Primitive data types can also be written to the stream using the
  # appropriate methods from DataOutput. Strings can also be written using the
  # writeUTF method.
  # 
  # <p>The default serialization mechanism for an object writes the class of the
  # object, the class signature, and the values of all non-transient and
  # non-static fields.  References to other objects (except in transient or
  # static fields) cause those objects to be written also. Multiple references
  # to a single object are encoded using a reference sharing mechanism so that
  # graphs of objects can be restored to the same shape as when the original was
  # written.
  # 
  # <p>For example to write an object that can be read by the example in
  # ObjectInputStream:
  # <br>
  # <pre>
  # FileOutputStream fos = new FileOutputStream("t.tmp");
  # ObjectOutputStream oos = new ObjectOutputStream(fos);
  # 
  # oos.writeInt(12345);
  # oos.writeObject("Today");
  # oos.writeObject(new Date());
  # 
  # oos.close();
  # </pre>
  # 
  # <p>Classes that require special handling during the serialization and
  # deserialization process must implement special methods with these exact
  # signatures:
  # <br>
  # <pre>
  # private void readObject(java.io.ObjectInputStream stream)
  # throws IOException, ClassNotFoundException;
  # private void writeObject(java.io.ObjectOutputStream stream)
  # throws IOException
  # private void readObjectNoData()
  # throws ObjectStreamException;
  # </pre>
  # 
  # <p>The writeObject method is responsible for writing the state of the object
  # for its particular class so that the corresponding readObject method can
  # restore it.  The method does not need to concern itself with the state
  # belonging to the object's superclasses or subclasses.  State is saved by
  # writing the individual fields to the ObjectOutputStream using the
  # writeObject method or by using the methods for primitive data types
  # supported by DataOutput.
  # 
  # <p>Serialization does not write out the fields of any object that does not
  # implement the java.io.Serializable interface.  Subclasses of Objects that
  # are not serializable can be serializable. In this case the non-serializable
  # class must have a no-arg constructor to allow its fields to be initialized.
  # In this case it is the responsibility of the subclass to save and restore
  # the state of the non-serializable class. It is frequently the case that the
  # fields of that class are accessible (public, package, or protected) or that
  # there are get and set methods that can be used to restore the state.
  # 
  # <p>Serialization of an object can be prevented by implementing writeObject
  # and readObject methods that throw the NotSerializableException.  The
  # exception will be caught by the ObjectOutputStream and abort the
  # serialization process.
  # 
  # <p>Implementing the Externalizable interface allows the object to assume
  # complete control over the contents and format of the object's serialized
  # form.  The methods of the Externalizable interface, writeExternal and
  # readExternal, are called to save and restore the objects state.  When
  # implemented by a class they can write and read their own state using all of
  # the methods of ObjectOutput and ObjectInput.  It is the responsibility of
  # the objects to handle any versioning that occurs.
  # 
  # <p>Enum constants are serialized differently than ordinary serializable or
  # externalizable objects.  The serialized form of an enum constant consists
  # solely of its name; field values of the constant are not transmitted.  To
  # serialize an enum constant, ObjectOutputStream writes the string returned by
  # the constant's name method.  Like other serializable or externalizable
  # objects, enum constants can function as the targets of back references
  # appearing subsequently in the serialization stream.  The process by which
  # enum constants are serialized cannot be customized; any class-specific
  # writeObject and writeReplace methods defined by enum types are ignored
  # during serialization.  Similarly, any serialPersistentFields or
  # serialVersionUID field declarations are also ignored--all enum types have a
  # fixed serialVersionUID of 0L.
  # 
  # <p>Primitive data, excluding serializable fields and externalizable data, is
  # written to the ObjectOutputStream in block-data records. A block data record
  # is composed of a header and data. The block data header consists of a marker
  # and the number of bytes to follow the header.  Consecutive primitive data
  # writes are merged into one block-data record.  The blocking factor used for
  # a block-data record will be 1024 bytes.  Each block-data record will be
  # filled up to 1024 bytes, or be written whenever there is a termination of
  # block-data mode.  Calls to the ObjectOutputStream methods writeObject,
  # defaultWriteObject and writeFields initially terminate any existing
  # block-data record.
  # 
  # @author      Mike Warres
  # @author      Roger Riggs
  # @see java.io.DataOutput
  # @see java.io.ObjectInputStream
  # @see java.io.Serializable
  # @see java.io.Externalizable
  # @see <a href="../../../platform/serialization/spec/output.html">Object Serialization Specification, Section 2, Object Output Classes</a>
  # @since       JDK1.1
  class ObjectOutputStream < ObjectOutputStreamImports.const_get :OutputStream
    include_class_members ObjectOutputStreamImports
    include ObjectOutput
    include ObjectStreamConstants
    
    class_module.module_eval {
      const_set_lazy(:Caches) { Class.new do
        include_class_members ObjectOutputStream
        
        class_module.module_eval {
          # cache of subclass security audit results
          const_set_lazy(:SubclassAudits) { ConcurrentHashMap.new }
          const_attr_reader  :SubclassAudits
          
          # queue for WeakReferences to audited subclasses
          const_set_lazy(:SubclassAuditsQueue) { ReferenceQueue.new }
          const_attr_reader  :SubclassAuditsQueue
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__caches, :initialize
      end }
    }
    
    # filter stream for handling block data conversion
    attr_accessor :bout
    alias_method :attr_bout, :bout
    undef_method :bout
    alias_method :attr_bout=, :bout=
    undef_method :bout=
    
    # obj -> wire handle map
    attr_accessor :handles
    alias_method :attr_handles, :handles
    undef_method :handles
    alias_method :attr_handles=, :handles=
    undef_method :handles=
    
    # obj -> replacement obj map
    attr_accessor :subs
    alias_method :attr_subs, :subs
    undef_method :subs
    alias_method :attr_subs=, :subs=
    undef_method :subs=
    
    # stream protocol version
    attr_accessor :protocol
    alias_method :attr_protocol, :protocol
    undef_method :protocol
    alias_method :attr_protocol=, :protocol=
    undef_method :protocol=
    
    # recursion depth
    attr_accessor :depth
    alias_method :attr_depth, :depth
    undef_method :depth
    alias_method :attr_depth=, :depth=
    undef_method :depth=
    
    # buffer for writing primitive field values
    attr_accessor :prim_vals
    alias_method :attr_prim_vals, :prim_vals
    undef_method :prim_vals
    alias_method :attr_prim_vals=, :prim_vals=
    undef_method :prim_vals=
    
    # if true, invoke writeObjectOverride() instead of writeObject()
    attr_accessor :enable_override
    alias_method :attr_enable_override, :enable_override
    undef_method :enable_override
    alias_method :attr_enable_override=, :enable_override=
    undef_method :enable_override=
    
    # if true, invoke replaceObject()
    attr_accessor :enable_replace
    alias_method :attr_enable_replace, :enable_replace
    undef_method :enable_replace
    alias_method :attr_enable_replace=, :enable_replace=
    undef_method :enable_replace=
    
    # values below valid only during upcalls to writeObject()/writeExternal()
    # object currently being serialized
    attr_accessor :cur_obj
    alias_method :attr_cur_obj, :cur_obj
    undef_method :cur_obj
    alias_method :attr_cur_obj=, :cur_obj=
    undef_method :cur_obj=
    
    # descriptor for current class (null if in writeExternal())
    attr_accessor :cur_desc
    alias_method :attr_cur_desc, :cur_desc
    undef_method :cur_desc
    alias_method :attr_cur_desc=, :cur_desc=
    undef_method :cur_desc=
    
    # current PutField object
    attr_accessor :cur_put
    alias_method :attr_cur_put, :cur_put
    undef_method :cur_put
    alias_method :attr_cur_put=, :cur_put=
    undef_method :cur_put=
    
    # custom storage for debug trace info
    attr_accessor :debug_info_stack
    alias_method :attr_debug_info_stack, :debug_info_stack
    undef_method :debug_info_stack
    alias_method :attr_debug_info_stack=, :debug_info_stack=
    undef_method :debug_info_stack=
    
    class_module.module_eval {
      # value of "sun.io.serialization.extendedDebugInfo" property,
      # as true or false for extended information about exception's place
      const_set_lazy(:ExtendedDebugInfo) { Java::Security::AccessController.do_privileged(Sun::Security::Action::GetBooleanAction.new("sun.io.serialization.extendedDebugInfo")).boolean_value }
      const_attr_reader  :ExtendedDebugInfo
    }
    
    typesig { [OutputStream] }
    # Creates an ObjectOutputStream that writes to the specified OutputStream.
    # This constructor writes the serialization stream header to the
    # underlying stream; callers may wish to flush the stream immediately to
    # ensure that constructors for receiving ObjectInputStreams will not block
    # when reading the header.
    # 
    # <p>If a security manager is installed, this constructor will check for
    # the "enableSubclassImplementation" SerializablePermission when invoked
    # directly or indirectly by the constructor of a subclass which overrides
    # the ObjectOutputStream.putFields or ObjectOutputStream.writeUnshared
    # methods.
    # 
    # @param   out output stream to write to
    # @throws  IOException if an I/O error occurs while writing stream header
    # @throws  SecurityException if untrusted subclass illegally overrides
    # security-sensitive methods
    # @throws  NullPointerException if <code>out</code> is <code>null</code>
    # @since   1.4
    # @see     ObjectOutputStream#ObjectOutputStream()
    # @see     ObjectOutputStream#putFields()
    # @see     ObjectInputStream#ObjectInputStream(InputStream)
    def initialize(out)
      @bout = nil
      @handles = nil
      @subs = nil
      @protocol = 0
      @depth = 0
      @prim_vals = nil
      @enable_override = false
      @enable_replace = false
      @cur_obj = nil
      @cur_desc = nil
      @cur_put = nil
      @debug_info_stack = nil
      super()
      @protocol = PROTOCOL_VERSION_2
      verify_subclass
      @bout = BlockDataOutputStream.new(out)
      @handles = HandleTable.new(10, (3.00).to_f)
      @subs = ReplaceTable.new(10, (3.00).to_f)
      @enable_override = false
      write_stream_header
      @bout.set_block_data_mode(true)
      if (ExtendedDebugInfo)
        @debug_info_stack = DebugTraceInfoStack.new
      else
        @debug_info_stack = nil
      end
    end
    
    typesig { [] }
    # Provide a way for subclasses that are completely reimplementing
    # ObjectOutputStream to not have to allocate private data just used by
    # this implementation of ObjectOutputStream.
    # 
    # <p>If there is a security manager installed, this method first calls the
    # security manager's <code>checkPermission</code> method with a
    # <code>SerializablePermission("enableSubclassImplementation")</code>
    # permission to ensure it's ok to enable subclassing.
    # 
    # @throws  SecurityException if a security manager exists and its
    # <code>checkPermission</code> method denies enabling
    # subclassing.
    # @see SecurityManager#checkPermission
    # @see java.io.SerializablePermission
    def initialize
      @bout = nil
      @handles = nil
      @subs = nil
      @protocol = 0
      @depth = 0
      @prim_vals = nil
      @enable_override = false
      @enable_replace = false
      @cur_obj = nil
      @cur_desc = nil
      @cur_put = nil
      @debug_info_stack = nil
      super()
      @protocol = PROTOCOL_VERSION_2
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(SUBCLASS_IMPLEMENTATION_PERMISSION)
      end
      @bout = nil
      @handles = nil
      @subs = nil
      @enable_override = true
      @debug_info_stack = nil
    end
    
    typesig { [::Java::Int] }
    # Specify stream protocol version to use when writing the stream.
    # 
    # <p>This routine provides a hook to enable the current version of
    # Serialization to write in a format that is backwards compatible to a
    # previous version of the stream format.
    # 
    # <p>Every effort will be made to avoid introducing additional
    # backwards incompatibilities; however, sometimes there is no
    # other alternative.
    # 
    # @param   version use ProtocolVersion from java.io.ObjectStreamConstants.
    # @throws  IllegalStateException if called after any objects
    # have been serialized.
    # @throws  IllegalArgumentException if invalid version is passed in.
    # @throws  IOException if I/O errors occur
    # @see java.io.ObjectStreamConstants#PROTOCOL_VERSION_1
    # @see java.io.ObjectStreamConstants#PROTOCOL_VERSION_2
    # @since   1.2
    def use_protocol_version(version)
      if (!(@handles.size).equal?(0))
        # REMIND: implement better check for pristine stream?
        raise IllegalStateException.new("stream non-empty")
      end
      case (version)
      when PROTOCOL_VERSION_1, PROTOCOL_VERSION_2
        @protocol = version
      else
        raise IllegalArgumentException.new("unknown version: " + (version).to_s)
      end
    end
    
    typesig { [Object] }
    # Write the specified object to the ObjectOutputStream.  The class of the
    # object, the signature of the class, and the values of the non-transient
    # and non-static fields of the class and all of its supertypes are
    # written.  Default serialization for a class can be overridden using the
    # writeObject and the readObject methods.  Objects referenced by this
    # object are written transitively so that a complete equivalent graph of
    # objects can be reconstructed by an ObjectInputStream.
    # 
    # <p>Exceptions are thrown for problems with the OutputStream and for
    # classes that should not be serialized.  All exceptions are fatal to the
    # OutputStream, which is left in an indeterminate state, and it is up to
    # the caller to ignore or recover the stream state.
    # 
    # @throws  InvalidClassException Something is wrong with a class used by
    # serialization.
    # @throws  NotSerializableException Some object to be serialized does not
    # implement the java.io.Serializable interface.
    # @throws  IOException Any exception thrown by the underlying
    # OutputStream.
    def write_object(obj)
      if (@enable_override)
        write_object_override(obj)
        return
      end
      begin
        write_object0(obj, false)
      rescue IOException => ex
        if ((@depth).equal?(0))
          write_fatal_exception(ex)
        end
        raise ex
      end
    end
    
    typesig { [Object] }
    # Method used by subclasses to override the default writeObject method.
    # This method is called by trusted subclasses of ObjectInputStream that
    # constructed ObjectInputStream using the protected no-arg constructor.
    # The subclass is expected to provide an override method with the modifier
    # "final".
    # 
    # @param   obj object to be written to the underlying stream
    # @throws  IOException if there are I/O errors while writing to the
    # underlying stream
    # @see #ObjectOutputStream()
    # @see #writeObject(Object)
    # @since 1.2
    def write_object_override(obj)
    end
    
    typesig { [Object] }
    # Writes an "unshared" object to the ObjectOutputStream.  This method is
    # identical to writeObject, except that it always writes the given object
    # as a new, unique object in the stream (as opposed to a back-reference
    # pointing to a previously serialized instance).  Specifically:
    # <ul>
    # <li>An object written via writeUnshared is always serialized in the
    # same manner as a newly appearing object (an object that has not
    # been written to the stream yet), regardless of whether or not the
    # object has been written previously.
    # 
    # <li>If writeObject is used to write an object that has been previously
    # written with writeUnshared, the previous writeUnshared operation
    # is treated as if it were a write of a separate object.  In other
    # words, ObjectOutputStream will never generate back-references to
    # object data written by calls to writeUnshared.
    # </ul>
    # While writing an object via writeUnshared does not in itself guarantee a
    # unique reference to the object when it is deserialized, it allows a
    # single object to be defined multiple times in a stream, so that multiple
    # calls to readUnshared by the receiver will not conflict.  Note that the
    # rules described above only apply to the base-level object written with
    # writeUnshared, and not to any transitively referenced sub-objects in the
    # object graph to be serialized.
    # 
    # <p>ObjectOutputStream subclasses which override this method can only be
    # constructed in security contexts possessing the
    # "enableSubclassImplementation" SerializablePermission; any attempt to
    # instantiate such a subclass without this permission will cause a
    # SecurityException to be thrown.
    # 
    # @param   obj object to write to stream
    # @throws  NotSerializableException if an object in the graph to be
    # serialized does not implement the Serializable interface
    # @throws  InvalidClassException if a problem exists with the class of an
    # object to be serialized
    # @throws  IOException if an I/O error occurs during serialization
    # @since 1.4
    def write_unshared(obj)
      begin
        write_object0(obj, true)
      rescue IOException => ex
        if ((@depth).equal?(0))
          write_fatal_exception(ex)
        end
        raise ex
      end
    end
    
    typesig { [] }
    # Write the non-static and non-transient fields of the current class to
    # this stream.  This may only be called from the writeObject method of the
    # class being serialized. It will throw the NotActiveException if it is
    # called otherwise.
    # 
    # @throws  IOException if I/O errors occur while writing to the underlying
    # <code>OutputStream</code>
    def default_write_object
      if ((@cur_obj).nil? || (@cur_desc).nil?)
        raise NotActiveException.new("not in call to writeObject")
      end
      @bout.set_block_data_mode(false)
      default_write_fields(@cur_obj, @cur_desc)
      @bout.set_block_data_mode(true)
    end
    
    typesig { [] }
    # Retrieve the object used to buffer persistent fields to be written to
    # the stream.  The fields will be written to the stream when writeFields
    # method is called.
    # 
    # @return  an instance of the class Putfield that holds the serializable
    # fields
    # @throws  IOException if I/O errors occur
    # @since 1.2
    def put_fields
      if ((@cur_put).nil?)
        if ((@cur_obj).nil? || (@cur_desc).nil?)
          raise NotActiveException.new("not in call to writeObject")
        end
        @cur_put = PutFieldImpl.new_local(self, @cur_desc)
      end
      return @cur_put
    end
    
    typesig { [] }
    # Write the buffered fields to the stream.
    # 
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    # @throws  NotActiveException Called when a classes writeObject method was
    # not called to write the state of the object.
    # @since 1.2
    def write_fields
      if ((@cur_put).nil?)
        raise NotActiveException.new("no current PutField object")
      end
      @bout.set_block_data_mode(false)
      @cur_put.write_fields
      @bout.set_block_data_mode(true)
    end
    
    typesig { [] }
    # Reset will disregard the state of any objects already written to the
    # stream.  The state is reset to be the same as a new ObjectOutputStream.
    # The current point in the stream is marked as reset so the corresponding
    # ObjectInputStream will be reset at the same point.  Objects previously
    # written to the stream will not be refered to as already being in the
    # stream.  They will be written to the stream again.
    # 
    # @throws  IOException if reset() is invoked while serializing an object.
    def reset
      if (!(@depth).equal?(0))
        raise IOException.new("stream active")
      end
      @bout.set_block_data_mode(false)
      @bout.write_byte(TC_RESET)
      clear
      @bout.set_block_data_mode(true)
    end
    
    typesig { [Class] }
    # Subclasses may implement this method to allow class data to be stored in
    # the stream. By default this method does nothing.  The corresponding
    # method in ObjectInputStream is resolveClass.  This method is called
    # exactly once for each unique class in the stream.  The class name and
    # signature will have already been written to the stream.  This method may
    # make free use of the ObjectOutputStream to save any representation of
    # the class it deems suitable (for example, the bytes of the class file).
    # The resolveClass method in the corresponding subclass of
    # ObjectInputStream must read and use any data or objects written by
    # annotateClass.
    # 
    # @param   cl the class to annotate custom data for
    # @throws  IOException Any exception thrown by the underlying
    # OutputStream.
    def annotate_class(cl)
    end
    
    typesig { [Class] }
    # Subclasses may implement this method to store custom data in the stream
    # along with descriptors for dynamic proxy classes.
    # 
    # <p>This method is called exactly once for each unique proxy class
    # descriptor in the stream.  The default implementation of this method in
    # <code>ObjectOutputStream</code> does nothing.
    # 
    # <p>The corresponding method in <code>ObjectInputStream</code> is
    # <code>resolveProxyClass</code>.  For a given subclass of
    # <code>ObjectOutputStream</code> that overrides this method, the
    # <code>resolveProxyClass</code> method in the corresponding subclass of
    # <code>ObjectInputStream</code> must read any data or objects written by
    # <code>annotateProxyClass</code>.
    # 
    # @param   cl the proxy class to annotate custom data for
    # @throws  IOException any exception thrown by the underlying
    # <code>OutputStream</code>
    # @see ObjectInputStream#resolveProxyClass(String[])
    # @since   1.3
    def annotate_proxy_class(cl)
    end
    
    typesig { [Object] }
    # This method will allow trusted subclasses of ObjectOutputStream to
    # substitute one object for another during serialization. Replacing
    # objects is disabled until enableReplaceObject is called. The
    # enableReplaceObject method checks that the stream requesting to do
    # replacement can be trusted.  The first occurrence of each object written
    # into the serialization stream is passed to replaceObject.  Subsequent
    # references to the object are replaced by the object returned by the
    # original call to replaceObject.  To ensure that the private state of
    # objects is not unintentionally exposed, only trusted streams may use
    # replaceObject.
    # 
    # <p>The ObjectOutputStream.writeObject method takes a parameter of type
    # Object (as opposed to type Serializable) to allow for cases where
    # non-serializable objects are replaced by serializable ones.
    # 
    # <p>When a subclass is replacing objects it must insure that either a
    # complementary substitution must be made during deserialization or that
    # the substituted object is compatible with every field where the
    # reference will be stored.  Objects whose type is not a subclass of the
    # type of the field or array element abort the serialization by raising an
    # exception and the object is not be stored.
    # 
    # <p>This method is called only once when each object is first
    # encountered.  All subsequent references to the object will be redirected
    # to the new object. This method should return the object to be
    # substituted or the original object.
    # 
    # <p>Null can be returned as the object to be substituted, but may cause
    # NullReferenceException in classes that contain references to the
    # original object since they may be expecting an object instead of
    # null.
    # 
    # @param   obj the object to be replaced
    # @return  the alternate object that replaced the specified one
    # @throws  IOException Any exception thrown by the underlying
    # OutputStream.
    def replace_object(obj)
      return obj
    end
    
    typesig { [::Java::Boolean] }
    # Enable the stream to do replacement of objects in the stream.  When
    # enabled, the replaceObject method is called for every object being
    # serialized.
    # 
    # <p>If <code>enable</code> is true, and there is a security manager
    # installed, this method first calls the security manager's
    # <code>checkPermission</code> method with a
    # <code>SerializablePermission("enableSubstitution")</code> permission to
    # ensure it's ok to enable the stream to do replacement of objects in the
    # stream.
    # 
    # @param   enable boolean parameter to enable replacement of objects
    # @return  the previous setting before this method was invoked
    # @throws  SecurityException if a security manager exists and its
    # <code>checkPermission</code> method denies enabling the stream
    # to do replacement of objects in the stream.
    # @see SecurityManager#checkPermission
    # @see java.io.SerializablePermission
    def enable_replace_object(enable)
      if ((enable).equal?(@enable_replace))
        return enable
      end
      if (enable)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(SUBSTITUTION_PERMISSION)
        end
      end
      @enable_replace = enable
      return !@enable_replace
    end
    
    typesig { [] }
    # The writeStreamHeader method is provided so subclasses can append or
    # prepend their own header to the stream.  It writes the magic number and
    # version to the stream.
    # 
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_stream_header
      @bout.write_short(STREAM_MAGIC)
      @bout.write_short(STREAM_VERSION)
    end
    
    typesig { [ObjectStreamClass] }
    # Write the specified class descriptor to the ObjectOutputStream.  Class
    # descriptors are used to identify the classes of objects written to the
    # stream.  Subclasses of ObjectOutputStream may override this method to
    # customize the way in which class descriptors are written to the
    # serialization stream.  The corresponding method in ObjectInputStream,
    # <code>readClassDescriptor</code>, should then be overridden to
    # reconstitute the class descriptor from its custom stream representation.
    # By default, this method writes class descriptors according to the format
    # defined in the Object Serialization specification.
    # 
    # <p>Note that this method will only be called if the ObjectOutputStream
    # is not using the old serialization stream format (set by calling
    # ObjectOutputStream's <code>useProtocolVersion</code> method).  If this
    # serialization stream is using the old format
    # (<code>PROTOCOL_VERSION_1</code>), the class descriptor will be written
    # internally in a manner that cannot be overridden or customized.
    # 
    # @param   desc class descriptor to write to the stream
    # @throws  IOException If an I/O error has occurred.
    # @see java.io.ObjectInputStream#readClassDescriptor()
    # @see #useProtocolVersion(int)
    # @see java.io.ObjectStreamConstants#PROTOCOL_VERSION_1
    # @since 1.3
    def write_class_descriptor(desc)
      desc.write_non_proxy(self)
    end
    
    typesig { [::Java::Int] }
    # Writes a byte. This method will block until the byte is actually
    # written.
    # 
    # @param   val the byte to be written to the stream
    # @throws  IOException If an I/O error has occurred.
    def write(val)
      @bout.write(val)
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Writes an array of bytes. This method will block until the bytes are
    # actually written.
    # 
    # @param   buf the data to be written
    # @throws  IOException If an I/O error has occurred.
    def write(buf)
      @bout.write(buf, 0, buf.attr_length, false)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Writes a sub array of bytes.
    # 
    # @param   buf the data to be written
    # @param   off the start offset in the data
    # @param   len the number of bytes that are written
    # @throws  IOException If an I/O error has occurred.
    def write(buf, off, len)
      if ((buf).nil?)
        raise NullPointerException.new
      end
      endoff = off + len
      if (off < 0 || len < 0 || endoff > buf.attr_length || endoff < 0)
        raise IndexOutOfBoundsException.new
      end
      @bout.write(buf, off, len, false)
    end
    
    typesig { [] }
    # Flushes the stream. This will write any buffered output bytes and flush
    # through to the underlying stream.
    # 
    # @throws  IOException If an I/O error has occurred.
    def flush
      @bout.flush
    end
    
    typesig { [] }
    # Drain any buffered data in ObjectOutputStream.  Similar to flush but
    # does not propagate the flush to the underlying stream.
    # 
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def drain
      @bout.drain
    end
    
    typesig { [] }
    # Closes the stream. This method must be called to release any resources
    # associated with the stream.
    # 
    # @throws  IOException If an I/O error has occurred.
    def close
      flush
      clear
      @bout.close
    end
    
    typesig { [::Java::Boolean] }
    # Writes a boolean.
    # 
    # @param   val the boolean to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_boolean(val)
      @bout.write_boolean(val)
    end
    
    typesig { [::Java::Int] }
    # Writes an 8 bit byte.
    # 
    # @param   val the byte value to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_byte(val)
      @bout.write_byte(val)
    end
    
    typesig { [::Java::Int] }
    # Writes a 16 bit short.
    # 
    # @param   val the short value to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_short(val)
      @bout.write_short(val)
    end
    
    typesig { [::Java::Int] }
    # Writes a 16 bit char.
    # 
    # @param   val the char value to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_char(val)
      @bout.write_char(val)
    end
    
    typesig { [::Java::Int] }
    # Writes a 32 bit int.
    # 
    # @param   val the integer value to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_int(val)
      @bout.write_int(val)
    end
    
    typesig { [::Java::Long] }
    # Writes a 64 bit long.
    # 
    # @param   val the long value to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_long(val)
      @bout.write_long(val)
    end
    
    typesig { [::Java::Float] }
    # Writes a 32 bit float.
    # 
    # @param   val the float value to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_float(val)
      @bout.write_float(val)
    end
    
    typesig { [::Java::Double] }
    # Writes a 64 bit double.
    # 
    # @param   val the double value to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_double(val)
      @bout.write_double(val)
    end
    
    typesig { [String] }
    # Writes a String as a sequence of bytes.
    # 
    # @param   str the String of bytes to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_bytes(str)
      @bout.write_bytes(str)
    end
    
    typesig { [String] }
    # Writes a String as a sequence of chars.
    # 
    # @param   str the String of chars to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_chars(str)
      @bout.write_chars(str)
    end
    
    typesig { [String] }
    # Primitive data write of this String in
    # <a href="DataInput.html#modified-utf-8">modified UTF-8</a>
    # format.  Note that there is a
    # significant difference between writing a String into the stream as
    # primitive data or as an Object. A String instance written by writeObject
    # is written into the stream as a String initially. Future writeObject()
    # calls write references to the string into the stream.
    # 
    # @param   str the String to be written
    # @throws  IOException if I/O errors occur while writing to the underlying
    # stream
    def write_utf(str)
      @bout.write_utf(str)
    end
    
    class_module.module_eval {
      # Provide programmatic access to the persistent fields to be written
      # to ObjectOutput.
      # 
      # @since 1.2
      const_set_lazy(:PutField) { Class.new do
        include_class_members ObjectOutputStream
        
        typesig { [String, ::Java::Boolean] }
        # Put the value of the named boolean field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not
        # <code>boolean</code>
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Byte] }
        # Put the value of the named byte field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not
        # <code>byte</code>
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Char] }
        # Put the value of the named char field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not
        # <code>char</code>
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Short] }
        # Put the value of the named short field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not
        # <code>short</code>
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Int] }
        # Put the value of the named int field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not
        # <code>int</code>
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Long] }
        # Put the value of the named long field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not
        # <code>long</code>
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Float] }
        # Put the value of the named float field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not
        # <code>float</code>
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Double] }
        # Put the value of the named double field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not
        # <code>double</code>
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, Object] }
        # Put the value of the named Object field into the persistent field.
        # 
        # @param  name the name of the serializable field
        # @param  val the value to assign to the field
        # (which may be <code>null</code>)
        # @throws IllegalArgumentException if <code>name</code> does not
        # match the name of a serializable field for the class whose fields
        # are being written, or if the type of the named field is not a
        # reference type
        def put(name, val)
          raise NotImplementedError
        end
        
        typesig { [ObjectOutput] }
        # Write the data and fields to the specified ObjectOutput stream,
        # which must be the same stream that produced this
        # <code>PutField</code> object.
        # 
        # @param  out the stream to write the data and fields to
        # @throws IOException if I/O errors occur while writing to the
        # underlying stream
        # @throws IllegalArgumentException if the specified stream is not
        # the same stream that produced this <code>PutField</code>
        # object
        # @deprecated This method does not write the values contained by this
        # <code>PutField</code> object in a proper format, and may
        # result in corruption of the serialization stream.  The
        # correct way to write <code>PutField</code> data is by
        # calling the {@link java.io.ObjectOutputStream#writeFields()}
        # method.
        def write(out)
          raise NotImplementedError
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__put_field, :initialize
      end }
    }
    
    typesig { [] }
    # Returns protocol version in use.
    def get_protocol_version
      return @protocol
    end
    
    typesig { [String] }
    # Writes string without allowing it to be replaced in stream.  Used by
    # ObjectStreamClass to write class descriptor type strings.
    def write_type_string(str)
      handle = 0
      if ((str).nil?)
        write_null
      else
        if (!((handle = @handles.lookup(str))).equal?(-1))
          write_handle(handle)
        else
          write_string(str, false)
        end
      end
    end
    
    typesig { [] }
    # Verifies that this (possibly subclass) instance can be constructed
    # without violating security constraints: the subclass must not override
    # security-sensitive non-final methods, or else the
    # "enableSubclassImplementation" SerializablePermission is checked.
    def verify_subclass
      cl = get_class
      if ((cl).equal?(ObjectOutputStream.class))
        return
      end
      sm = System.get_security_manager
      if ((sm).nil?)
        return
      end
      process_queue(Caches.attr_subclass_audits_queue, Caches.attr_subclass_audits)
      key = WeakClassKey.new(cl, Caches.attr_subclass_audits_queue)
      result = Caches.attr_subclass_audits.get(key)
      if ((result).nil?)
        result = Boolean.value_of(audit_subclass(cl))
        Caches.attr_subclass_audits.put_if_absent(key, result)
      end
      if (result.boolean_value)
        return
      end
      sm.check_permission(SUBCLASS_IMPLEMENTATION_PERMISSION)
    end
    
    class_module.module_eval {
      typesig { [Class] }
      # Performs reflective checks on given subclass to verify that it doesn't
      # override security-sensitive non-final methods.  Returns true if subclass
      # is "safe", false otherwise.
      def audit_subclass(subcl)
        result = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ObjectOutputStream
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            cl = subcl
            while !(cl).equal?(ObjectOutputStream.class)
              begin
                cl.get_declared_method("writeUnshared", Array.typed(Class).new([Object.class]))
                return Boolean::FALSE
              rescue NoSuchMethodException => ex
              end
              begin
                cl.get_declared_method("putFields", nil)
                return Boolean::FALSE
              rescue NoSuchMethodException => ex
              end
              cl = cl.get_superclass
            end
            return Boolean::TRUE
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
        return result.boolean_value
      end
    }
    
    typesig { [] }
    # Clears internal data structures.
    def clear
      @subs.clear
      @handles.clear
    end
    
    typesig { [Object, ::Java::Boolean] }
    # Underlying writeObject/writeUnshared implementation.
    def write_object0(obj, unshared)
      old_mode = @bout.set_block_data_mode(false)
      @depth += 1
      begin
        # handle previously written and non-replaceable objects
        h = 0
        if (((obj = @subs.lookup(obj))).nil?)
          write_null
          return
        else
          if (!unshared && !((h = @handles.lookup(obj))).equal?(-1))
            write_handle(h)
            return
          else
            if (obj.is_a?(Class))
              write_class(obj, unshared)
              return
            else
              if (obj.is_a?(ObjectStreamClass))
                write_class_desc(obj, unshared)
                return
              end
            end
          end
        end
        # check for replacement object
        orig = obj
        cl = obj.get_class
        desc = nil
        loop do
          # REMIND: skip this check for strings/arrays?
          rep_cl = nil
          desc = ObjectStreamClass.lookup(cl, true)
          if (!desc.has_write_replace_method || ((obj = desc.invoke_write_replace(obj))).nil? || ((rep_cl = obj.get_class)).equal?(cl))
            break
          end
          cl = rep_cl
        end
        if (@enable_replace)
          rep = replace_object(obj)
          if (!(rep).equal?(obj) && !(rep).nil?)
            cl = rep.get_class
            desc = ObjectStreamClass.lookup(cl, true)
          end
          obj = rep
        end
        # if object replaced, run through original checks a second time
        if (!(obj).equal?(orig))
          @subs.assign(orig, obj)
          if ((obj).nil?)
            write_null
            return
          else
            if (!unshared && !((h = @handles.lookup(obj))).equal?(-1))
              write_handle(h)
              return
            else
              if (obj.is_a?(Class))
                write_class(obj, unshared)
                return
              else
                if (obj.is_a?(ObjectStreamClass))
                  write_class_desc(obj, unshared)
                  return
                end
              end
            end
          end
        end
        # remaining cases
        if (obj.is_a?(String))
          write_string(obj, unshared)
        else
          if (cl.is_array)
            write_array(obj, desc, unshared)
          else
            if (obj.is_a?(Enum))
              write_enum(obj, desc, unshared)
            else
              if (obj.is_a?(Serializable))
                write_ordinary_object(obj, desc, unshared)
              else
                if (ExtendedDebugInfo)
                  raise NotSerializableException.new((cl.get_name).to_s + "\n" + (@debug_info_stack.to_s).to_s)
                else
                  raise NotSerializableException.new(cl.get_name)
                end
              end
            end
          end
        end
      ensure
        @depth -= 1
        @bout.set_block_data_mode(old_mode)
      end
    end
    
    typesig { [] }
    # Writes null code to stream.
    def write_null
      @bout.write_byte(TC_NULL)
    end
    
    typesig { [::Java::Int] }
    # Writes given object handle to stream.
    def write_handle(handle)
      @bout.write_byte(TC_REFERENCE)
      @bout.write_int(self.attr_base_wire_handle + handle)
    end
    
    typesig { [Class, ::Java::Boolean] }
    # Writes representation of given class to stream.
    def write_class(cl, unshared)
      @bout.write_byte(TC_CLASS)
      write_class_desc(ObjectStreamClass.lookup(cl, true), false)
      @handles.assign(unshared ? nil : cl)
    end
    
    typesig { [ObjectStreamClass, ::Java::Boolean] }
    # Writes representation of given class descriptor to stream.
    def write_class_desc(desc, unshared)
      handle = 0
      if ((desc).nil?)
        write_null
      else
        if (!unshared && !((handle = @handles.lookup(desc))).equal?(-1))
          write_handle(handle)
        else
          if (desc.is_proxy)
            write_proxy_desc(desc, unshared)
          else
            write_non_proxy_desc(desc, unshared)
          end
        end
      end
    end
    
    typesig { [ObjectStreamClass, ::Java::Boolean] }
    # Writes class descriptor representing a dynamic proxy class to stream.
    def write_proxy_desc(desc, unshared)
      @bout.write_byte(TC_PROXYCLASSDESC)
      @handles.assign(unshared ? nil : desc)
      cl = desc.for_class
      ifaces = cl.get_interfaces
      @bout.write_int(ifaces.attr_length)
      i = 0
      while i < ifaces.attr_length
        @bout.write_utf(ifaces[i].get_name)
        i += 1
      end
      @bout.set_block_data_mode(true)
      annotate_proxy_class(cl)
      @bout.set_block_data_mode(false)
      @bout.write_byte(TC_ENDBLOCKDATA)
      write_class_desc(desc.get_super_desc, false)
    end
    
    typesig { [ObjectStreamClass, ::Java::Boolean] }
    # Writes class descriptor representing a standard (i.e., not a dynamic
    # proxy) class to stream.
    def write_non_proxy_desc(desc, unshared)
      @bout.write_byte(TC_CLASSDESC)
      @handles.assign(unshared ? nil : desc)
      if ((@protocol).equal?(PROTOCOL_VERSION_1))
        # do not invoke class descriptor write hook with old protocol
        desc.write_non_proxy(self)
      else
        write_class_descriptor(desc)
      end
      cl = desc.for_class
      @bout.set_block_data_mode(true)
      annotate_class(cl)
      @bout.set_block_data_mode(false)
      @bout.write_byte(TC_ENDBLOCKDATA)
      write_class_desc(desc.get_super_desc, false)
    end
    
    typesig { [String, ::Java::Boolean] }
    # Writes given string to stream, using standard or long UTF format
    # depending on string length.
    def write_string(str, unshared)
      @handles.assign(unshared ? nil : str)
      utflen = @bout.get_utflength(str)
      if (utflen <= 0xffff)
        @bout.write_byte(TC_STRING)
        @bout.write_utf(str, utflen)
      else
        @bout.write_byte(TC_LONGSTRING)
        @bout.write_long_utf(str, utflen)
      end
    end
    
    typesig { [Object, ObjectStreamClass, ::Java::Boolean] }
    # Writes given array object to stream.
    def write_array(array, desc, unshared)
      @bout.write_byte(TC_ARRAY)
      write_class_desc(desc, false)
      @handles.assign(unshared ? nil : array)
      ccl = desc.for_class.get_component_type
      if (ccl.is_primitive)
        if ((ccl).equal?(JavaInteger::TYPE))
          ia = array
          @bout.write_int(ia.attr_length)
          @bout.write_ints(ia, 0, ia.attr_length)
        else
          if ((ccl).equal?(Byte::TYPE))
            ba = array
            @bout.write_int(ba.attr_length)
            @bout.write(ba, 0, ba.attr_length, true)
          else
            if ((ccl).equal?(Long::TYPE))
              ja = array
              @bout.write_int(ja.attr_length)
              @bout.write_longs(ja, 0, ja.attr_length)
            else
              if ((ccl).equal?(Float::TYPE))
                fa = array
                @bout.write_int(fa.attr_length)
                @bout.write_floats(fa, 0, fa.attr_length)
              else
                if ((ccl).equal?(Double::TYPE))
                  da = array
                  @bout.write_int(da.attr_length)
                  @bout.write_doubles(da, 0, da.attr_length)
                else
                  if ((ccl).equal?(Short::TYPE))
                    sa = array
                    @bout.write_int(sa.attr_length)
                    @bout.write_shorts(sa, 0, sa.attr_length)
                  else
                    if ((ccl).equal?(Character::TYPE))
                      ca = array
                      @bout.write_int(ca.attr_length)
                      @bout.write_chars(ca, 0, ca.attr_length)
                    else
                      if ((ccl).equal?(Boolean::TYPE))
                        za = array
                        @bout.write_int(za.attr_length)
                        @bout.write_booleans(za, 0, za.attr_length)
                      else
                        raise InternalError.new
                      end
                    end
                  end
                end
              end
            end
          end
        end
      else
        objs = array
        len = objs.attr_length
        @bout.write_int(len)
        if (ExtendedDebugInfo)
          @debug_info_stack.push("array (class \"" + (array.get_class.get_name).to_s + "\", size: " + (len).to_s + ")")
        end
        begin
          i = 0
          while i < len
            if (ExtendedDebugInfo)
              @debug_info_stack.push("element of array (index: " + (i).to_s + ")")
            end
            begin
              write_object0(objs[i], false)
            ensure
              if (ExtendedDebugInfo)
                @debug_info_stack.pop
              end
            end
            i += 1
          end
        ensure
          if (ExtendedDebugInfo)
            @debug_info_stack.pop
          end
        end
      end
    end
    
    typesig { [Enum, ObjectStreamClass, ::Java::Boolean] }
    # Writes given enum constant to stream.
    def write_enum(en, desc, unshared)
      @bout.write_byte(TC_ENUM)
      sdesc = desc.get_super_desc
      write_class_desc(((sdesc.for_class).equal?(Enum.class)) ? desc : sdesc, false)
      @handles.assign(unshared ? nil : en)
      write_string(en.name, false)
    end
    
    typesig { [Object, ObjectStreamClass, ::Java::Boolean] }
    # Writes representation of a "ordinary" (i.e., not a String, Class,
    # ObjectStreamClass, array, or enum constant) serializable object to the
    # stream.
    def write_ordinary_object(obj, desc, unshared)
      if (ExtendedDebugInfo)
        @debug_info_stack.push((((@depth).equal?(1) ? "root " : "")).to_s + "object (class \"" + (obj.get_class.get_name).to_s + "\", " + (obj.to_s).to_s + ")")
      end
      begin
        desc.check_serialize
        @bout.write_byte(TC_OBJECT)
        write_class_desc(desc, false)
        @handles.assign(unshared ? nil : obj)
        if (desc.is_externalizable && !desc.is_proxy)
          write_external_data(obj)
        else
          write_serial_data(obj, desc)
        end
      ensure
        if (ExtendedDebugInfo)
          @debug_info_stack.pop
        end
      end
    end
    
    typesig { [Externalizable] }
    # Writes externalizable data of given object by invoking its
    # writeExternal() method.
    def write_external_data(obj)
      old_obj = @cur_obj
      old_desc = @cur_desc
      old_put = @cur_put
      @cur_obj = obj
      @cur_desc = nil
      @cur_put = nil
      if (ExtendedDebugInfo)
        @debug_info_stack.push("writeExternal data")
      end
      begin
        if ((@protocol).equal?(PROTOCOL_VERSION_1))
          obj.write_external(self)
        else
          @bout.set_block_data_mode(true)
          obj.write_external(self)
          @bout.set_block_data_mode(false)
          @bout.write_byte(TC_ENDBLOCKDATA)
        end
      ensure
        if (ExtendedDebugInfo)
          @debug_info_stack.pop
        end
      end
      @cur_obj = old_obj
      @cur_desc = old_desc
      @cur_put = old_put
    end
    
    typesig { [Object, ObjectStreamClass] }
    # Writes instance data for each serializable class of given object, from
    # superclass to subclass.
    def write_serial_data(obj, desc)
      slots = desc.get_class_data_layout
      i = 0
      while i < slots.attr_length
        slot_desc = slots[i].attr_desc
        if (slot_desc.has_write_object_method)
          old_obj = @cur_obj
          old_desc = @cur_desc
          old_put = @cur_put
          @cur_obj = obj
          @cur_desc = slot_desc
          @cur_put = nil
          if (ExtendedDebugInfo)
            @debug_info_stack.push("custom writeObject data (class \"" + (slot_desc.get_name).to_s + "\")")
          end
          begin
            @bout.set_block_data_mode(true)
            slot_desc.invoke_write_object(obj, self)
            @bout.set_block_data_mode(false)
            @bout.write_byte(TC_ENDBLOCKDATA)
          ensure
            if (ExtendedDebugInfo)
              @debug_info_stack.pop
            end
          end
          @cur_obj = old_obj
          @cur_desc = old_desc
          @cur_put = old_put
        else
          default_write_fields(obj, slot_desc)
        end
        i += 1
      end
    end
    
    typesig { [Object, ObjectStreamClass] }
    # Fetches and writes values of serializable fields of given object to
    # stream.  The given class descriptor specifies which field values to
    # write, and in which order they should be written.
    def default_write_fields(obj, desc)
      # REMIND: perform conservative isInstance check here?
      desc.check_default_serialize
      prim_data_size = desc.get_prim_data_size
      if ((@prim_vals).nil? || @prim_vals.attr_length < prim_data_size)
        @prim_vals = Array.typed(::Java::Byte).new(prim_data_size) { 0 }
      end
      desc.get_prim_field_values(obj, @prim_vals)
      @bout.write(@prim_vals, 0, prim_data_size, false)
      fields = desc.get_fields(false)
      obj_vals = Array.typed(Object).new(desc.get_num_obj_fields) { nil }
      num_prim_fields = fields.attr_length - obj_vals.attr_length
      desc.get_obj_field_values(obj, obj_vals)
      i = 0
      while i < obj_vals.attr_length
        if (ExtendedDebugInfo)
          @debug_info_stack.push("field (class \"" + (desc.get_name).to_s + "\", name: \"" + (fields[num_prim_fields + i].get_name).to_s + "\", type: \"" + (fields[num_prim_fields + i].get_type).to_s + "\")")
        end
        begin
          write_object0(obj_vals[i], fields[num_prim_fields + i].is_unshared)
        ensure
          if (ExtendedDebugInfo)
            @debug_info_stack.pop
          end
        end
        i += 1
      end
    end
    
    typesig { [IOException] }
    # Attempts to write to stream fatal IOException that has caused
    # serialization to abort.
    def write_fatal_exception(ex)
      # Note: the serialization specification states that if a second
      # IOException occurs while attempting to serialize the original fatal
      # exception to the stream, then a StreamCorruptedException should be
      # thrown (section 2.1).  However, due to a bug in previous
      # implementations of serialization, StreamCorruptedExceptions were
      # rarely (if ever) actually thrown--the "root" exceptions from
      # underlying streams were thrown instead.  This historical behavior is
      # followed here for consistency.
      clear
      old_mode = @bout.set_block_data_mode(false)
      begin
        @bout.write_byte(TC_EXCEPTION)
        write_object0(ex, false)
        clear
      ensure
        @bout.set_block_data_mode(old_mode)
      end
    end
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_ObjectOutputStream_floatsToBytes, [:pointer, :long, :long, :int32, :long, :int32, :int32], :void
      typesig { [Array.typed(::Java::Float), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Converts specified span of float values into byte values.
      # 
      # REMIND: remove once hotspot inlines Float.floatToIntBits
      def floats_to_bytes(src, srcpos, dst, dstpos, nfloats)
        JNI.__send__(:Java_java_io_ObjectOutputStream_floatsToBytes, JNI.env, self.jni_id, src.jni_id, srcpos.to_int, dst.jni_id, dstpos.to_int, nfloats.to_int)
      end
      
      JNI.native_method :Java_java_io_ObjectOutputStream_doublesToBytes, [:pointer, :long, :long, :int32, :long, :int32, :int32], :void
      typesig { [Array.typed(::Java::Double), ::Java::Int, Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
      # Converts specified span of double values into byte values.
      # 
      # REMIND: remove once hotspot inlines Double.doubleToLongBits
      def doubles_to_bytes(src, srcpos, dst, dstpos, ndoubles)
        JNI.__send__(:Java_java_io_ObjectOutputStream_doublesToBytes, JNI.env, self.jni_id, src.jni_id, srcpos.to_int, dst.jni_id, dstpos.to_int, ndoubles.to_int)
      end
      
      # Default PutField implementation.
      const_set_lazy(:PutFieldImpl) { Class.new(PutField) do
        extend LocalClass
        include_class_members ObjectOutputStream
        
        # class descriptor describing serializable fields
        attr_accessor :desc
        alias_method :attr_desc, :desc
        undef_method :desc
        alias_method :attr_desc=, :desc=
        undef_method :desc=
        
        # primitive field values
        attr_accessor :prim_vals
        alias_method :attr_prim_vals, :prim_vals
        undef_method :prim_vals
        alias_method :attr_prim_vals=, :prim_vals=
        undef_method :prim_vals=
        
        # object field values
        attr_accessor :obj_vals
        alias_method :attr_obj_vals, :obj_vals
        undef_method :obj_vals
        alias_method :attr_obj_vals=, :obj_vals=
        undef_method :obj_vals=
        
        typesig { [ObjectStreamClass] }
        # Creates PutFieldImpl object for writing fields defined in given
        # class descriptor.
        def initialize(desc)
          @desc = nil
          @prim_vals = nil
          @obj_vals = nil
          super()
          @desc = desc
          @prim_vals = Array.typed(::Java::Byte).new(desc.get_prim_data_size) { 0 }
          @obj_vals = Array.typed(Object).new(desc.get_num_obj_fields) { nil }
        end
        
        typesig { [String, ::Java::Boolean] }
        def put(name, val)
          Bits.put_boolean(@prim_vals, get_field_offset(name, Boolean::TYPE), val)
        end
        
        typesig { [String, ::Java::Byte] }
        def put(name, val)
          @prim_vals[get_field_offset(name, Byte::TYPE)] = val
        end
        
        typesig { [String, ::Java::Char] }
        def put(name, val)
          Bits.put_char(@prim_vals, get_field_offset(name, Character::TYPE), val)
        end
        
        typesig { [String, ::Java::Short] }
        def put(name, val)
          Bits.put_short(@prim_vals, get_field_offset(name, Short::TYPE), val)
        end
        
        typesig { [String, ::Java::Int] }
        def put(name, val)
          Bits.put_int(@prim_vals, get_field_offset(name, JavaInteger::TYPE), val)
        end
        
        typesig { [String, ::Java::Float] }
        def put(name, val)
          Bits.put_float(@prim_vals, get_field_offset(name, Float::TYPE), val)
        end
        
        typesig { [String, ::Java::Long] }
        def put(name, val)
          Bits.put_long(@prim_vals, get_field_offset(name, Long::TYPE), val)
        end
        
        typesig { [String, ::Java::Double] }
        def put(name, val)
          Bits.put_double(@prim_vals, get_field_offset(name, Double::TYPE), val)
        end
        
        typesig { [String, Object] }
        def put(name, val)
          @obj_vals[get_field_offset(name, Object.class)] = val
        end
        
        typesig { [ObjectOutput] }
        # deprecated in ObjectOutputStream.PutField
        def write(out)
          # Applications should *not* use this method to write PutField
          # data, as it will lead to stream corruption if the PutField
          # object writes any primitive data (since block data mode is not
          # unset/set properly, as is done in OOS.writeFields()).  This
          # broken implementation is being retained solely for behavioral
          # compatibility, in order to support applications which use
          # OOS.PutField.write() for writing only non-primitive data.
          # 
          # Serialization of unshared objects is not implemented here since
          # it is not necessary for backwards compatibility; also, unshared
          # semantics may not be supported by the given ObjectOutput
          # instance.  Applications which write unshared objects using the
          # PutField API must use OOS.writeFields().
          if (!(@local_class_parent).equal?(out))
            raise IllegalArgumentException.new("wrong stream")
          end
          out.write(@prim_vals, 0, @prim_vals.attr_length)
          fields = @desc.get_fields(false)
          num_prim_fields = fields.attr_length - @obj_vals.attr_length
          # REMIND: warn if numPrimFields > 0?
          i = 0
          while i < @obj_vals.attr_length
            if (fields[num_prim_fields + i].is_unshared)
              raise IOException.new("cannot write unshared object")
            end
            out.write_object(@obj_vals[i])
            i += 1
          end
        end
        
        typesig { [] }
        # Writes buffered primitive data and object fields to stream.
        def write_fields
          self.attr_bout.write(@prim_vals, 0, @prim_vals.attr_length, false)
          fields = @desc.get_fields(false)
          num_prim_fields = fields.attr_length - @obj_vals.attr_length
          i = 0
          while i < @obj_vals.attr_length
            if (ExtendedDebugInfo)
              self.attr_debug_info_stack.push("field (class \"" + (@desc.get_name).to_s + "\", name: \"" + (fields[num_prim_fields + i].get_name).to_s + "\", type: \"" + (fields[num_prim_fields + i].get_type).to_s + "\")")
            end
            begin
              write_object0(@obj_vals[i], fields[num_prim_fields + i].is_unshared)
            ensure
              if (ExtendedDebugInfo)
                self.attr_debug_info_stack.pop
              end
            end
            i += 1
          end
        end
        
        typesig { [String, Class] }
        # Returns offset of field with given name and type.  A specified type
        # of null matches all types, Object.class matches all non-primitive
        # types, and any other non-null type matches assignable types only.
        # Throws IllegalArgumentException if no matching field found.
        def get_field_offset(name, type)
          field = @desc.get_field(name, type)
          if ((field).nil?)
            raise IllegalArgumentException.new("no such field " + name + " with type " + (type).to_s)
          end
          return field.get_offset
        end
        
        private
        alias_method :initialize__put_field_impl, :initialize
      end }
      
      # Buffered output stream with two modes: in default mode, outputs data in
      # same format as DataOutputStream; in "block data" mode, outputs data
      # bracketed by block data markers (see object serialization specification
      # for details).
      const_set_lazy(:BlockDataOutputStream) { Class.new(OutputStream) do
        include_class_members ObjectOutputStream
        include DataOutput
        
        class_module.module_eval {
          # maximum data block length
          const_set_lazy(:MAX_BLOCK_SIZE) { 1024 }
          const_attr_reader  :MAX_BLOCK_SIZE
          
          # maximum data block header length
          const_set_lazy(:MAX_HEADER_SIZE) { 5 }
          const_attr_reader  :MAX_HEADER_SIZE
          
          # (tunable) length of char buffer (for writing strings)
          const_set_lazy(:CHAR_BUF_SIZE) { 256 }
          const_attr_reader  :CHAR_BUF_SIZE
        }
        
        # buffer for writing general/block data
        attr_accessor :buf
        alias_method :attr_buf, :buf
        undef_method :buf
        alias_method :attr_buf=, :buf=
        undef_method :buf=
        
        # buffer for writing block data headers
        attr_accessor :hbuf
        alias_method :attr_hbuf, :hbuf
        undef_method :hbuf
        alias_method :attr_hbuf=, :hbuf=
        undef_method :hbuf=
        
        # char buffer for fast string writes
        attr_accessor :cbuf
        alias_method :attr_cbuf, :cbuf
        undef_method :cbuf
        alias_method :attr_cbuf=, :cbuf=
        undef_method :cbuf=
        
        # block data mode
        attr_accessor :blkmode
        alias_method :attr_blkmode, :blkmode
        undef_method :blkmode
        alias_method :attr_blkmode=, :blkmode=
        undef_method :blkmode=
        
        # current offset into buf
        attr_accessor :pos
        alias_method :attr_pos, :pos
        undef_method :pos
        alias_method :attr_pos=, :pos=
        undef_method :pos=
        
        # underlying output stream
        attr_accessor :out
        alias_method :attr_out, :out
        undef_method :out
        alias_method :attr_out=, :out=
        undef_method :out=
        
        # loopback stream (for data writes that span data blocks)
        attr_accessor :dout
        alias_method :attr_dout, :dout
        undef_method :dout
        alias_method :attr_dout=, :dout=
        undef_method :dout=
        
        typesig { [OutputStream] }
        # Creates new BlockDataOutputStream on top of given underlying stream.
        # Block data mode is turned off by default.
        def initialize(out)
          @buf = nil
          @hbuf = nil
          @cbuf = nil
          @blkmode = false
          @pos = 0
          @out = nil
          @dout = nil
          super()
          @buf = Array.typed(::Java::Byte).new(self.class::MAX_BLOCK_SIZE) { 0 }
          @hbuf = Array.typed(::Java::Byte).new(self.class::MAX_HEADER_SIZE) { 0 }
          @cbuf = CharArray.new(self.class::CHAR_BUF_SIZE)
          @blkmode = false
          @pos = 0
          @out = out
          @dout = DataOutputStream.new(self)
        end
        
        typesig { [::Java::Boolean] }
        # Sets block data mode to the given mode (true == on, false == off)
        # and returns the previous mode value.  If the new mode is the same as
        # the old mode, no action is taken.  If the new mode differs from the
        # old mode, any buffered data is flushed before switching to the new
        # mode.
        def set_block_data_mode(mode)
          if ((@blkmode).equal?(mode))
            return @blkmode
          end
          drain
          @blkmode = mode
          return !@blkmode
        end
        
        typesig { [] }
        # Returns true if the stream is currently in block data mode, false
        # otherwise.
        def get_block_data_mode
          return @blkmode
        end
        
        typesig { [::Java::Int] }
        # ----------------- generic output stream methods -----------------
        # 
        # The following methods are equivalent to their counterparts in
        # OutputStream, except that they partition written data into data
        # blocks when in block data mode.
        def write(b)
          if (@pos >= self.class::MAX_BLOCK_SIZE)
            drain
          end
          @buf[((@pos += 1) - 1)] = b
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def write(b)
          write(b, 0, b.attr_length, false)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def write(b, off, len)
          write(b, off, len, false)
        end
        
        typesig { [] }
        def flush
          drain
          @out.flush
        end
        
        typesig { [] }
        def close
          flush
          @out.close
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Boolean] }
        # Writes specified span of byte values from given array.  If copy is
        # true, copies the values to an intermediate buffer before writing
        # them to underlying stream (to avoid exposing a reference to the
        # original byte array).
        def write(b, off, len, copy)
          if (!(copy || @blkmode))
            # write directly
            drain
            @out.write(b, off, len)
            return
          end
          while (len > 0)
            if (@pos >= self.class::MAX_BLOCK_SIZE)
              drain
            end
            if (len >= self.class::MAX_BLOCK_SIZE && !copy && (@pos).equal?(0))
              # avoid unnecessary copy
              write_block_header(self.class::MAX_BLOCK_SIZE)
              @out.write(b, off, self.class::MAX_BLOCK_SIZE)
              off += self.class::MAX_BLOCK_SIZE
              len -= self.class::MAX_BLOCK_SIZE
            else
              wlen = Math.min(len, self.class::MAX_BLOCK_SIZE - @pos)
              System.arraycopy(b, off, @buf, @pos, wlen)
              @pos += wlen
              off += wlen
              len -= wlen
            end
          end
        end
        
        typesig { [] }
        # Writes all buffered data from this stream to the underlying stream,
        # but does not flush underlying stream.
        def drain
          if ((@pos).equal?(0))
            return
          end
          if (@blkmode)
            write_block_header(@pos)
          end
          @out.write(@buf, 0, @pos)
          @pos = 0
        end
        
        typesig { [::Java::Int] }
        # Writes block data header.  Data blocks shorter than 256 bytes are
        # prefixed with a 2-byte header; all others start with a 5-byte
        # header.
        def write_block_header(len)
          if (len <= 0xff)
            @hbuf[0] = TC_BLOCKDATA
            @hbuf[1] = len
            @out.write(@hbuf, 0, 2)
          else
            @hbuf[0] = TC_BLOCKDATALONG
            Bits.put_int(@hbuf, 1, len)
            @out.write(@hbuf, 0, 5)
          end
        end
        
        typesig { [::Java::Boolean] }
        # ----------------- primitive data output methods -----------------
        # 
        # The following methods are equivalent to their counterparts in
        # DataOutputStream, except that they partition written data into data
        # blocks when in block data mode.
        def write_boolean(v)
          if (@pos >= self.class::MAX_BLOCK_SIZE)
            drain
          end
          Bits.put_boolean(@buf, ((@pos += 1) - 1), v)
        end
        
        typesig { [::Java::Int] }
        def write_byte(v)
          if (@pos >= self.class::MAX_BLOCK_SIZE)
            drain
          end
          @buf[((@pos += 1) - 1)] = v
        end
        
        typesig { [::Java::Int] }
        def write_char(v)
          if (@pos + 2 <= self.class::MAX_BLOCK_SIZE)
            Bits.put_char(@buf, @pos, RJava.cast_to_char(v))
            @pos += 2
          else
            @dout.write_char(v)
          end
        end
        
        typesig { [::Java::Int] }
        def write_short(v)
          if (@pos + 2 <= self.class::MAX_BLOCK_SIZE)
            Bits.put_short(@buf, @pos, RJava.cast_to_short(v))
            @pos += 2
          else
            @dout.write_short(v)
          end
        end
        
        typesig { [::Java::Int] }
        def write_int(v)
          if (@pos + 4 <= self.class::MAX_BLOCK_SIZE)
            Bits.put_int(@buf, @pos, v)
            @pos += 4
          else
            @dout.write_int(v)
          end
        end
        
        typesig { [::Java::Float] }
        def write_float(v)
          if (@pos + 4 <= self.class::MAX_BLOCK_SIZE)
            Bits.put_float(@buf, @pos, v)
            @pos += 4
          else
            @dout.write_float(v)
          end
        end
        
        typesig { [::Java::Long] }
        def write_long(v)
          if (@pos + 8 <= self.class::MAX_BLOCK_SIZE)
            Bits.put_long(@buf, @pos, v)
            @pos += 8
          else
            @dout.write_long(v)
          end
        end
        
        typesig { [::Java::Double] }
        def write_double(v)
          if (@pos + 8 <= self.class::MAX_BLOCK_SIZE)
            Bits.put_double(@buf, @pos, v)
            @pos += 8
          else
            @dout.write_double(v)
          end
        end
        
        typesig { [String] }
        def write_bytes(s)
          endoff = s.length
          cpos = 0
          csize = 0
          off = 0
          while off < endoff
            if (cpos >= csize)
              cpos = 0
              csize = Math.min(endoff - off, self.class::CHAR_BUF_SIZE)
              s.get_chars(off, off + csize, @cbuf, 0)
            end
            if (@pos >= self.class::MAX_BLOCK_SIZE)
              drain
            end
            n = Math.min(csize - cpos, self.class::MAX_BLOCK_SIZE - @pos)
            stop = @pos + n
            while (@pos < stop)
              @buf[((@pos += 1) - 1)] = @cbuf[((cpos += 1) - 1)]
            end
            off += n
          end
        end
        
        typesig { [String] }
        def write_chars(s)
          endoff = s.length
          off = 0
          while off < endoff
            csize = Math.min(endoff - off, self.class::CHAR_BUF_SIZE)
            s.get_chars(off, off + csize, @cbuf, 0)
            write_chars(@cbuf, 0, csize)
            off += csize
          end
        end
        
        typesig { [String] }
        def write_utf(s)
          write_utf(s, get_utflength(s))
        end
        
        typesig { [Array.typed(::Java::Boolean), ::Java::Int, ::Java::Int] }
        # -------------- primitive data array output methods --------------
        # 
        # The following methods write out spans of primitive data values.
        # Though equivalent to calling the corresponding primitive write
        # methods repeatedly, these methods are optimized for writing groups
        # of primitive data values more efficiently.
        def write_booleans(v, off, len)
          endoff = off + len
          while (off < endoff)
            if (@pos >= self.class::MAX_BLOCK_SIZE)
              drain
            end
            stop = Math.min(endoff, off + (self.class::MAX_BLOCK_SIZE - @pos))
            while (off < stop)
              Bits.put_boolean(@buf, ((@pos += 1) - 1), v[((off += 1) - 1)])
            end
          end
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
        def write_chars(v, off, len)
          limit = self.class::MAX_BLOCK_SIZE - 2
          endoff = off + len
          while (off < endoff)
            if (@pos <= limit)
              avail = (self.class::MAX_BLOCK_SIZE - @pos) >> 1
              stop = Math.min(endoff, off + avail)
              while (off < stop)
                Bits.put_char(@buf, @pos, v[((off += 1) - 1)])
                @pos += 2
              end
            else
              @dout.write_char(v[((off += 1) - 1)])
            end
          end
        end
        
        typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int] }
        def write_shorts(v, off, len)
          limit = self.class::MAX_BLOCK_SIZE - 2
          endoff = off + len
          while (off < endoff)
            if (@pos <= limit)
              avail = (self.class::MAX_BLOCK_SIZE - @pos) >> 1
              stop = Math.min(endoff, off + avail)
              while (off < stop)
                Bits.put_short(@buf, @pos, v[((off += 1) - 1)])
                @pos += 2
              end
            else
              @dout.write_short(v[((off += 1) - 1)])
            end
          end
        end
        
        typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
        def write_ints(v, off, len)
          limit = self.class::MAX_BLOCK_SIZE - 4
          endoff = off + len
          while (off < endoff)
            if (@pos <= limit)
              avail = (self.class::MAX_BLOCK_SIZE - @pos) >> 2
              stop = Math.min(endoff, off + avail)
              while (off < stop)
                Bits.put_int(@buf, @pos, v[((off += 1) - 1)])
                @pos += 4
              end
            else
              @dout.write_int(v[((off += 1) - 1)])
            end
          end
        end
        
        typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
        def write_floats(v, off, len)
          limit = self.class::MAX_BLOCK_SIZE - 4
          endoff = off + len
          while (off < endoff)
            if (@pos <= limit)
              avail = (self.class::MAX_BLOCK_SIZE - @pos) >> 2
              chunklen = Math.min(endoff - off, avail)
              floats_to_bytes(v, off, @buf, @pos, chunklen)
              off += chunklen
              @pos += chunklen << 2
            else
              @dout.write_float(v[((off += 1) - 1)])
            end
          end
        end
        
        typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
        def write_longs(v, off, len)
          limit = self.class::MAX_BLOCK_SIZE - 8
          endoff = off + len
          while (off < endoff)
            if (@pos <= limit)
              avail = (self.class::MAX_BLOCK_SIZE - @pos) >> 3
              stop = Math.min(endoff, off + avail)
              while (off < stop)
                Bits.put_long(@buf, @pos, v[((off += 1) - 1)])
                @pos += 8
              end
            else
              @dout.write_long(v[((off += 1) - 1)])
            end
          end
        end
        
        typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int] }
        def write_doubles(v, off, len)
          limit = self.class::MAX_BLOCK_SIZE - 8
          endoff = off + len
          while (off < endoff)
            if (@pos <= limit)
              avail = (self.class::MAX_BLOCK_SIZE - @pos) >> 3
              chunklen = Math.min(endoff - off, avail)
              doubles_to_bytes(v, off, @buf, @pos, chunklen)
              off += chunklen
              @pos += chunklen << 3
            else
              @dout.write_double(v[((off += 1) - 1)])
            end
          end
        end
        
        typesig { [String] }
        # Returns the length in bytes of the UTF encoding of the given string.
        def get_utflength(s)
          len = s.length
          utflen = 0
          off = 0
          while off < len
            csize = Math.min(len - off, self.class::CHAR_BUF_SIZE)
            s.get_chars(off, off + csize, @cbuf, 0)
            cpos = 0
            while cpos < csize
              c = @cbuf[cpos]
              if (c >= 0x1 && c <= 0x7f)
                utflen += 1
              else
                if (c > 0x7ff)
                  utflen += 3
                else
                  utflen += 2
                end
              end
              cpos += 1
            end
            off += csize
          end
          return utflen
        end
        
        typesig { [String, ::Java::Long] }
        # Writes the given string in UTF format.  This method is used in
        # situations where the UTF encoding length of the string is already
        # known; specifying it explicitly avoids a prescan of the string to
        # determine its UTF length.
        def write_utf(s, utflen)
          if (utflen > 0xffff)
            raise UTFDataFormatException.new
          end
          write_short(RJava.cast_to_int(utflen))
          if ((utflen).equal?(s.length))
            write_bytes(s)
          else
            write_utfbody(s)
          end
        end
        
        typesig { [String] }
        # Writes given string in "long" UTF format.  "Long" UTF format is
        # identical to standard UTF, except that it uses an 8 byte header
        # (instead of the standard 2 bytes) to convey the UTF encoding length.
        def write_long_utf(s)
          write_long_utf(s, get_utflength(s))
        end
        
        typesig { [String, ::Java::Long] }
        # Writes given string in "long" UTF format, where the UTF encoding
        # length of the string is already known.
        def write_long_utf(s, utflen)
          write_long(utflen)
          if ((utflen).equal?(s.length))
            write_bytes(s)
          else
            write_utfbody(s)
          end
        end
        
        typesig { [String] }
        # Writes the "body" (i.e., the UTF representation minus the 2-byte or
        # 8-byte length header) of the UTF encoding for the given string.
        def write_utfbody(s)
          limit = self.class::MAX_BLOCK_SIZE - 3
          len = s.length
          off = 0
          while off < len
            csize = Math.min(len - off, self.class::CHAR_BUF_SIZE)
            s.get_chars(off, off + csize, @cbuf, 0)
            cpos = 0
            while cpos < csize
              c = @cbuf[cpos]
              if (@pos <= limit)
                if (c <= 0x7f && !(c).equal?(0))
                  @buf[((@pos += 1) - 1)] = c
                else
                  if (c > 0x7ff)
                    @buf[@pos + 2] = (0x80 | ((c >> 0) & 0x3f))
                    @buf[@pos + 1] = (0x80 | ((c >> 6) & 0x3f))
                    @buf[@pos + 0] = (0xe0 | ((c >> 12) & 0xf))
                    @pos += 3
                  else
                    @buf[@pos + 1] = (0x80 | ((c >> 0) & 0x3f))
                    @buf[@pos + 0] = (0xc0 | ((c >> 6) & 0x1f))
                    @pos += 2
                  end
                end
              else
                # write one byte at a time to normalize block
                if (c <= 0x7f && !(c).equal?(0))
                  write(c)
                else
                  if (c > 0x7ff)
                    write(0xe0 | ((c >> 12) & 0xf))
                    write(0x80 | ((c >> 6) & 0x3f))
                    write(0x80 | ((c >> 0) & 0x3f))
                  else
                    write(0xc0 | ((c >> 6) & 0x1f))
                    write(0x80 | ((c >> 0) & 0x3f))
                  end
                end
              end
              cpos += 1
            end
            off += csize
          end
        end
        
        private
        alias_method :initialize__block_data_output_stream, :initialize
      end }
      
      # Lightweight identity hash table which maps objects to integer handles,
      # assigned in ascending order.
      const_set_lazy(:HandleTable) { Class.new do
        include_class_members ObjectOutputStream
        
        # number of mappings in table/next available handle
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        # size threshold determining when to expand hash spine
        attr_accessor :threshold
        alias_method :attr_threshold, :threshold
        undef_method :threshold
        alias_method :attr_threshold=, :threshold=
        undef_method :threshold=
        
        # factor for computing size threshold
        attr_accessor :load_factor
        alias_method :attr_load_factor, :load_factor
        undef_method :load_factor
        alias_method :attr_load_factor=, :load_factor=
        undef_method :load_factor=
        
        # maps hash value -> candidate handle value
        attr_accessor :spine
        alias_method :attr_spine, :spine
        undef_method :spine
        alias_method :attr_spine=, :spine=
        undef_method :spine=
        
        # maps handle value -> next candidate handle value
        attr_accessor :next
        alias_method :attr_next, :next
        undef_method :next
        alias_method :attr_next=, :next=
        undef_method :next=
        
        # maps handle value -> associated object
        attr_accessor :objs
        alias_method :attr_objs, :objs
        undef_method :objs
        alias_method :attr_objs=, :objs=
        undef_method :objs=
        
        typesig { [::Java::Int, ::Java::Float] }
        # Creates new HandleTable with given capacity and load factor.
        def initialize(initial_capacity, load_factor)
          @size = 0
          @threshold = 0
          @load_factor = 0.0
          @spine = nil
          @next = nil
          @objs = nil
          @load_factor = load_factor
          @spine = Array.typed(::Java::Int).new(initial_capacity) { 0 }
          @next = Array.typed(::Java::Int).new(initial_capacity) { 0 }
          @objs = Array.typed(Object).new(initial_capacity) { nil }
          @threshold = RJava.cast_to_int((initial_capacity * load_factor))
          clear
        end
        
        typesig { [Object] }
        # Assigns next available handle to given object, and returns handle
        # value.  Handles are assigned in ascending order starting at 0.
        def assign(obj)
          if (@size >= @next.attr_length)
            grow_entries
          end
          if (@size >= @threshold)
            grow_spine
          end
          insert(obj, @size)
          return ((@size += 1) - 1)
        end
        
        typesig { [Object] }
        # Looks up and returns handle associated with given object, or -1 if
        # no mapping found.
        def lookup(obj)
          if ((@size).equal?(0))
            return -1
          end
          index = hash(obj) % @spine.attr_length
          i = @spine[index]
          while i >= 0
            if ((@objs[i]).equal?(obj))
              return i
            end
            i = @next[i]
          end
          return -1
        end
        
        typesig { [] }
        # Resets table to its initial (empty) state.
        def clear
          Arrays.fill(@spine, -1)
          Arrays.fill(@objs, 0, @size, nil)
          @size = 0
        end
        
        typesig { [] }
        # Returns the number of mappings currently in table.
        def size
          return @size
        end
        
        typesig { [Object, ::Java::Int] }
        # Inserts mapping object -> handle mapping into table.  Assumes table
        # is large enough to accommodate new mapping.
        def insert(obj, handle)
          index = hash(obj) % @spine.attr_length
          @objs[handle] = obj
          @next[handle] = @spine[index]
          @spine[index] = handle
        end
        
        typesig { [] }
        # Expands the hash "spine" -- equivalent to increasing the number of
        # buckets in a conventional hash table.
        def grow_spine
          @spine = Array.typed(::Java::Int).new((@spine.attr_length << 1) + 1) { 0 }
          @threshold = RJava.cast_to_int((@spine.attr_length * @load_factor))
          Arrays.fill(@spine, -1)
          i = 0
          while i < @size
            insert(@objs[i], i)
            i += 1
          end
        end
        
        typesig { [] }
        # Increases hash table capacity by lengthening entry arrays.
        def grow_entries
          new_length = (@next.attr_length << 1) + 1
          new_next = Array.typed(::Java::Int).new(new_length) { 0 }
          System.arraycopy(@next, 0, new_next, 0, @size)
          @next = new_next
          new_objs = Array.typed(Object).new(new_length) { nil }
          System.arraycopy(@objs, 0, new_objs, 0, @size)
          @objs = new_objs
        end
        
        typesig { [Object] }
        # Returns hash value for given object.
        def hash(obj)
          return System.identity_hash_code(obj) & 0x7fffffff
        end
        
        private
        alias_method :initialize__handle_table, :initialize
      end }
      
      # Lightweight identity hash table which maps objects to replacement
      # objects.
      const_set_lazy(:ReplaceTable) { Class.new do
        include_class_members ObjectOutputStream
        
        # maps object -> index
        attr_accessor :htab
        alias_method :attr_htab, :htab
        undef_method :htab
        alias_method :attr_htab=, :htab=
        undef_method :htab=
        
        # maps index -> replacement object
        attr_accessor :reps
        alias_method :attr_reps, :reps
        undef_method :reps
        alias_method :attr_reps=, :reps=
        undef_method :reps=
        
        typesig { [::Java::Int, ::Java::Float] }
        # Creates new ReplaceTable with given capacity and load factor.
        def initialize(initial_capacity, load_factor)
          @htab = nil
          @reps = nil
          @htab = HandleTable.new(initial_capacity, load_factor)
          @reps = Array.typed(Object).new(initial_capacity) { nil }
        end
        
        typesig { [Object, Object] }
        # Enters mapping from object to replacement object.
        def assign(obj, rep)
          index = @htab.assign(obj)
          while (index >= @reps.attr_length)
            grow
          end
          @reps[index] = rep
        end
        
        typesig { [Object] }
        # Looks up and returns replacement for given object.  If no
        # replacement is found, returns the lookup object itself.
        def lookup(obj)
          index = @htab.lookup(obj)
          return (index >= 0) ? @reps[index] : obj
        end
        
        typesig { [] }
        # Resets table to its initial (empty) state.
        def clear
          Arrays.fill(@reps, 0, @htab.size, nil)
          @htab.clear
        end
        
        typesig { [] }
        # Returns the number of mappings currently in table.
        def size
          return @htab.size
        end
        
        typesig { [] }
        # Increases table capacity.
        def grow
          new_reps = Array.typed(Object).new((@reps.attr_length << 1) + 1) { nil }
          System.arraycopy(@reps, 0, new_reps, 0, @reps.attr_length)
          @reps = new_reps
        end
        
        private
        alias_method :initialize__replace_table, :initialize
      end }
      
      # Stack to keep debug information about the state of the
      # serialization process, for embedding in exception messages.
      const_set_lazy(:DebugTraceInfoStack) { Class.new do
        include_class_members ObjectOutputStream
        
        attr_accessor :stack
        alias_method :attr_stack, :stack
        undef_method :stack
        alias_method :attr_stack=, :stack=
        undef_method :stack=
        
        typesig { [] }
        def initialize
          @stack = nil
          @stack = ArrayList.new
        end
        
        typesig { [] }
        # Removes all of the elements from enclosed list.
        def clear
          @stack.clear
        end
        
        typesig { [] }
        # Removes the object at the top of enclosed list.
        def pop
          @stack.remove(@stack.size - 1)
        end
        
        typesig { [String] }
        # Pushes a String onto the top of enclosed list.
        def push(entry)
          @stack.add("\t- " + entry)
        end
        
        typesig { [] }
        # Returns a string representation of this object
        def to_s
          buffer = StringBuilder.new
          if (!@stack.is_empty)
            i = @stack.size
            while i > 0
              buffer.append(@stack.get(i - 1) + ((!(i).equal?(1)) ? "\n" : ""))
              i -= 1
            end
          end
          return buffer.to_s
        end
        
        private
        alias_method :initialize__debug_trace_info_stack, :initialize
      end }
    }
    
    private
    alias_method :initialize__object_output_stream, :initialize
  end
  
end
