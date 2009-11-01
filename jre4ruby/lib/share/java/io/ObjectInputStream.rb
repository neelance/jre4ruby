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
  module ObjectInputStreamImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Io::ObjectStreamClass, :WeakClassKey
      include_const ::Java::Lang::Ref, :ReferenceQueue
      include_const ::Java::Lang::Reflect, :Array
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Java::Lang::Reflect, :Proxy
      include_const ::Java::Security, :AccessControlContext
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Security, :PrivilegedActionException
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Util::Concurrent, :ConcurrentMap
      include_const ::Java::Util::Concurrent::Atomic, :AtomicBoolean
      include_const ::Java::Io::ObjectStreamClass, :ProcessQueue
    }
  end
  
  # An ObjectInputStream deserializes primitive data and objects previously
  # written using an ObjectOutputStream.
  # 
  # <p>ObjectOutputStream and ObjectInputStream can provide an application with
  # persistent storage for graphs of objects when used with a FileOutputStream
  # and FileInputStream respectively.  ObjectInputStream is used to recover
  # those objects previously serialized. Other uses include passing objects
  # between hosts using a socket stream or for marshaling and unmarshaling
  # arguments and parameters in a remote communication system.
  # 
  # <p>ObjectInputStream ensures that the types of all objects in the graph
  # created from the stream match the classes present in the Java Virtual
  # Machine.  Classes are loaded as required using the standard mechanisms.
  # 
  # <p>Only objects that support the java.io.Serializable or
  # java.io.Externalizable interface can be read from streams.
  # 
  # <p>The method <code>readObject</code> is used to read an object from the
  # stream.  Java's safe casting should be used to get the desired type.  In
  # Java, strings and arrays are objects and are treated as objects during
  # serialization. When read they need to be cast to the expected type.
  # 
  # <p>Primitive data types can be read from the stream using the appropriate
  # method on DataInput.
  # 
  # <p>The default deserialization mechanism for objects restores the contents
  # of each field to the value and type it had when it was written.  Fields
  # declared as transient or static are ignored by the deserialization process.
  # References to other objects cause those objects to be read from the stream
  # as necessary.  Graphs of objects are restored correctly using a reference
  # sharing mechanism.  New objects are always allocated when deserializing,
  # which prevents existing objects from being overwritten.
  # 
  # <p>Reading an object is analogous to running the constructors of a new
  # object.  Memory is allocated for the object and initialized to zero (NULL).
  # No-arg constructors are invoked for the non-serializable classes and then
  # the fields of the serializable classes are restored from the stream starting
  # with the serializable class closest to java.lang.object and finishing with
  # the object's most specific class.
  # 
  # <p>For example to read from a stream as written by the example in
  # ObjectOutputStream:
  # <br>
  # <pre>
  # FileInputStream fis = new FileInputStream("t.tmp");
  # ObjectInputStream ois = new ObjectInputStream(fis);
  # 
  # int i = ois.readInt();
  # String today = (String) ois.readObject();
  # Date date = (Date) ois.readObject();
  # 
  # ois.close();
  # </pre>
  # 
  # <p>Classes control how they are serialized by implementing either the
  # java.io.Serializable or java.io.Externalizable interfaces.
  # 
  # <p>Implementing the Serializable interface allows object serialization to
  # save and restore the entire state of the object and it allows classes to
  # evolve between the time the stream is written and the time it is read.  It
  # automatically traverses references between objects, saving and restoring
  # entire graphs.
  # 
  # <p>Serializable classes that require special handling during the
  # serialization and deserialization process should implement the following
  # methods:<p>
  # 
  # <pre>
  # private void writeObject(java.io.ObjectOutputStream stream)
  # throws IOException;
  # private void readObject(java.io.ObjectInputStream stream)
  # throws IOException, ClassNotFoundException;
  # private void readObjectNoData()
  # throws ObjectStreamException;
  # </pre>
  # 
  # <p>The readObject method is responsible for reading and restoring the state
  # of the object for its particular class using data written to the stream by
  # the corresponding writeObject method.  The method does not need to concern
  # itself with the state belonging to its superclasses or subclasses.  State is
  # restored by reading data from the ObjectInputStream for the individual
  # fields and making assignments to the appropriate fields of the object.
  # Reading primitive data types is supported by DataInput.
  # 
  # <p>Any attempt to read object data which exceeds the boundaries of the
  # custom data written by the corresponding writeObject method will cause an
  # OptionalDataException to be thrown with an eof field value of true.
  # Non-object reads which exceed the end of the allotted data will reflect the
  # end of data in the same way that they would indicate the end of the stream:
  # bytewise reads will return -1 as the byte read or number of bytes read, and
  # primitive reads will throw EOFExceptions.  If there is no corresponding
  # writeObject method, then the end of default serialized data marks the end of
  # the allotted data.
  # 
  # <p>Primitive and object read calls issued from within a readExternal method
  # behave in the same manner--if the stream is already positioned at the end of
  # data written by the corresponding writeExternal method, object reads will
  # throw OptionalDataExceptions with eof set to true, bytewise reads will
  # return -1, and primitive reads will throw EOFExceptions.  Note that this
  # behavior does not hold for streams written with the old
  # <code>ObjectStreamConstants.PROTOCOL_VERSION_1</code> protocol, in which the
  # end of data written by writeExternal methods is not demarcated, and hence
  # cannot be detected.
  # 
  # <p>The readObjectNoData method is responsible for initializing the state of
  # the object for its particular class in the event that the serialization
  # stream does not list the given class as a superclass of the object being
  # deserialized.  This may occur in cases where the receiving party uses a
  # different version of the deserialized instance's class than the sending
  # party, and the receiver's version extends classes that are not extended by
  # the sender's version.  This may also occur if the serialization stream has
  # been tampered; hence, readObjectNoData is useful for initializing
  # deserialized objects properly despite a "hostile" or incomplete source
  # stream.
  # 
  # <p>Serialization does not read or assign values to the fields of any object
  # that does not implement the java.io.Serializable interface.  Subclasses of
  # Objects that are not serializable can be serializable. In this case the
  # non-serializable class must have a no-arg constructor to allow its fields to
  # be initialized.  In this case it is the responsibility of the subclass to
  # save and restore the state of the non-serializable class. It is frequently
  # the case that the fields of that class are accessible (public, package, or
  # protected) or that there are get and set methods that can be used to restore
  # the state.
  # 
  # <p>Any exception that occurs while deserializing an object will be caught by
  # the ObjectInputStream and abort the reading process.
  # 
  # <p>Implementing the Externalizable interface allows the object to assume
  # complete control over the contents and format of the object's serialized
  # form.  The methods of the Externalizable interface, writeExternal and
  # readExternal, are called to save and restore the objects state.  When
  # implemented by a class they can write and read their own state using all of
  # the methods of ObjectOutput and ObjectInput.  It is the responsibility of
  # the objects to handle any versioning that occurs.
  # 
  # <p>Enum constants are deserialized differently than ordinary serializable or
  # externalizable objects.  The serialized form of an enum constant consists
  # solely of its name; field values of the constant are not transmitted.  To
  # deserialize an enum constant, ObjectInputStream reads the constant name from
  # the stream; the deserialized constant is then obtained by calling the static
  # method <code>Enum.valueOf(Class, String)</code> with the enum constant's
  # base type and the received constant name as arguments.  Like other
  # serializable or externalizable objects, enum constants can function as the
  # targets of back references appearing subsequently in the serialization
  # stream.  The process by which enum constants are deserialized cannot be
  # customized: any class-specific readObject, readObjectNoData, and readResolve
  # methods defined by enum types are ignored during deserialization.
  # Similarly, any serialPersistentFields or serialVersionUID field declarations
  # are also ignored--all enum types have a fixed serialVersionUID of 0L.
  # 
  # @author      Mike Warres
  # @author      Roger Riggs
  # @see java.io.DataInput
  # @see java.io.ObjectOutputStream
  # @see java.io.Serializable
  # @see <a href="../../../platform/serialization/spec/input.html"> Object Serialization Specification, Section 3, Object Input Classes</a>
  # @since   JDK1.1
  class ObjectInputStream < ObjectInputStreamImports.const_get :InputStream
    include_class_members ObjectInputStreamImports
    overload_protected {
      include ObjectInput
      include ObjectStreamConstants
    }
    
    class_module.module_eval {
      # handle value representing null
      const_set_lazy(:NULL_HANDLE) { -1 }
      const_attr_reader  :NULL_HANDLE
      
      # marker for unshared objects in internal handle table
      const_set_lazy(:UnsharedMarker) { Object.new }
      const_attr_reader  :UnsharedMarker
      
      # table mapping primitive type names to corresponding class objects
      const_set_lazy(:PrimClasses) { HashMap.new(8, 1.0) }
      const_attr_reader  :PrimClasses
      
      when_class_loaded do
        PrimClasses.put("boolean", Array)
        PrimClasses.put("byte", Array)
        PrimClasses.put("char", Array)
        PrimClasses.put("short", Array)
        PrimClasses.put("int", Array)
        PrimClasses.put("long", Array)
        PrimClasses.put("float", Array)
        PrimClasses.put("double", Array)
        PrimClasses.put("void", self.attr_void.attr_class)
      end
      
      const_set_lazy(:Caches) { Class.new do
        include_class_members ObjectInputStream
        
        class_module.module_eval {
          # cache of subclass security audit results
          const_set_lazy(:SubclassAudits) { class_self::ConcurrentHashMap.new }
          const_attr_reader  :SubclassAudits
          
          # queue for WeakReferences to audited subclasses
          const_set_lazy(:SubclassAuditsQueue) { class_self::ReferenceQueue.new }
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
    attr_accessor :bin
    alias_method :attr_bin, :bin
    undef_method :bin
    alias_method :attr_bin=, :bin=
    undef_method :bin=
    
    # validation callback list
    attr_accessor :vlist
    alias_method :attr_vlist, :vlist
    undef_method :vlist
    alias_method :attr_vlist=, :vlist=
    undef_method :vlist=
    
    # recursion depth
    attr_accessor :depth
    alias_method :attr_depth, :depth
    undef_method :depth
    alias_method :attr_depth=, :depth=
    undef_method :depth=
    
    # whether stream is closed
    attr_accessor :closed
    alias_method :attr_closed, :closed
    undef_method :closed
    alias_method :attr_closed=, :closed=
    undef_method :closed=
    
    # wire handle -> obj/exception map
    attr_accessor :handles
    alias_method :attr_handles, :handles
    undef_method :handles
    alias_method :attr_handles=, :handles=
    undef_method :handles=
    
    # scratch field for passing handle values up/down call stack
    attr_accessor :pass_handle
    alias_method :attr_pass_handle, :pass_handle
    undef_method :pass_handle
    alias_method :attr_pass_handle=, :pass_handle=
    undef_method :pass_handle=
    
    # flag set when at end of field value block with no TC_ENDBLOCKDATA
    attr_accessor :default_data_end
    alias_method :attr_default_data_end, :default_data_end
    undef_method :default_data_end
    alias_method :attr_default_data_end=, :default_data_end=
    undef_method :default_data_end=
    
    # buffer for reading primitive field values
    attr_accessor :prim_vals
    alias_method :attr_prim_vals, :prim_vals
    undef_method :prim_vals
    alias_method :attr_prim_vals=, :prim_vals=
    undef_method :prim_vals=
    
    # if true, invoke readObjectOverride() instead of readObject()
    attr_accessor :enable_override
    alias_method :attr_enable_override, :enable_override
    undef_method :enable_override
    alias_method :attr_enable_override=, :enable_override=
    undef_method :enable_override=
    
    # if true, invoke resolveObject()
    attr_accessor :enable_resolve
    alias_method :attr_enable_resolve, :enable_resolve
    undef_method :enable_resolve
    alias_method :attr_enable_resolve=, :enable_resolve=
    undef_method :enable_resolve=
    
    # Context during upcalls to class-defined readObject methods; holds
    # object currently being deserialized and descriptor for current class.
    # Null when not during readObject upcall.
    attr_accessor :cur_context
    alias_method :attr_cur_context, :cur_context
    undef_method :cur_context
    alias_method :attr_cur_context=, :cur_context=
    undef_method :cur_context=
    
    typesig { [InputStream] }
    # Creates an ObjectInputStream that reads from the specified InputStream.
    # A serialization stream header is read from the stream and verified.
    # This constructor will block until the corresponding ObjectOutputStream
    # has written and flushed the header.
    # 
    # <p>If a security manager is installed, this constructor will check for
    # the "enableSubclassImplementation" SerializablePermission when invoked
    # directly or indirectly by the constructor of a subclass which overrides
    # the ObjectInputStream.readFields or ObjectInputStream.readUnshared
    # methods.
    # 
    # @param   in input stream to read from
    # @throws  StreamCorruptedException if the stream header is incorrect
    # @throws  IOException if an I/O error occurs while reading stream header
    # @throws  SecurityException if untrusted subclass illegally overrides
    # security-sensitive methods
    # @throws  NullPointerException if <code>in</code> is <code>null</code>
    # @see     ObjectInputStream#ObjectInputStream()
    # @see     ObjectInputStream#readFields()
    # @see     ObjectOutputStream#ObjectOutputStream(OutputStream)
    def initialize(in_)
      @bin = nil
      @vlist = nil
      @depth = 0
      @closed = false
      @handles = nil
      @pass_handle = 0
      @default_data_end = false
      @prim_vals = nil
      @enable_override = false
      @enable_resolve = false
      @cur_context = nil
      super()
      @pass_handle = NULL_HANDLE
      @default_data_end = false
      verify_subclass
      @bin = BlockDataInputStream.new_local(self, in_)
      @handles = HandleTable.new(10)
      @vlist = ValidationList.new
      @enable_override = false
      read_stream_header
      @bin.set_block_data_mode(true)
    end
    
    typesig { [] }
    # Provide a way for subclasses that are completely reimplementing
    # ObjectInputStream to not have to allocate private data just used by this
    # implementation of ObjectInputStream.
    # 
    # <p>If there is a security manager installed, this method first calls the
    # security manager's <code>checkPermission</code> method with the
    # <code>SerializablePermission("enableSubclassImplementation")</code>
    # permission to ensure it's ok to enable subclassing.
    # 
    # @throws  SecurityException if a security manager exists and its
    # <code>checkPermission</code> method denies enabling
    # subclassing.
    # @see SecurityManager#checkPermission
    # @see java.io.SerializablePermission
    def initialize
      @bin = nil
      @vlist = nil
      @depth = 0
      @closed = false
      @handles = nil
      @pass_handle = 0
      @default_data_end = false
      @prim_vals = nil
      @enable_override = false
      @enable_resolve = false
      @cur_context = nil
      super()
      @pass_handle = NULL_HANDLE
      @default_data_end = false
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(SUBCLASS_IMPLEMENTATION_PERMISSION)
      end
      @bin = nil
      @handles = nil
      @vlist = nil
      @enable_override = true
    end
    
    typesig { [] }
    # Read an object from the ObjectInputStream.  The class of the object, the
    # signature of the class, and the values of the non-transient and
    # non-static fields of the class and all of its supertypes are read.
    # Default deserializing for a class can be overriden using the writeObject
    # and readObject methods.  Objects referenced by this object are read
    # transitively so that a complete equivalent graph of objects is
    # reconstructed by readObject.
    # 
    # <p>The root object is completely restored when all of its fields and the
    # objects it references are completely restored.  At this point the object
    # validation callbacks are executed in order based on their registered
    # priorities. The callbacks are registered by objects (in the readObject
    # special methods) as they are individually restored.
    # 
    # <p>Exceptions are thrown for problems with the InputStream and for
    # classes that should not be deserialized.  All exceptions are fatal to
    # the InputStream and leave it in an indeterminate state; it is up to the
    # caller to ignore or recover the stream state.
    # 
    # @throws  ClassNotFoundException Class of a serialized object cannot be
    # found.
    # @throws  InvalidClassException Something is wrong with a class used by
    # serialization.
    # @throws  StreamCorruptedException Control information in the
    # stream is inconsistent.
    # @throws  OptionalDataException Primitive data was found in the
    # stream instead of objects.
    # @throws  IOException Any of the usual Input/Output related exceptions.
    def read_object
      if (@enable_override)
        return read_object_override
      end
      # if nested read, passHandle contains handle of enclosing object
      outer_handle = @pass_handle
      begin
        obj = read_object0(false)
        @handles.mark_dependency(outer_handle, @pass_handle)
        ex = @handles.lookup_exception(@pass_handle)
        if (!(ex).nil?)
          raise ex
        end
        if ((@depth).equal?(0))
          @vlist.do_callbacks
        end
        return obj
      ensure
        @pass_handle = outer_handle
        if (@closed && (@depth).equal?(0))
          clear
        end
      end
    end
    
    typesig { [] }
    # This method is called by trusted subclasses of ObjectOutputStream that
    # constructed ObjectOutputStream using the protected no-arg constructor.
    # The subclass is expected to provide an override method with the modifier
    # "final".
    # 
    # @return  the Object read from the stream.
    # @throws  ClassNotFoundException Class definition of a serialized object
    # cannot be found.
    # @throws  OptionalDataException Primitive data was found in the stream
    # instead of objects.
    # @throws  IOException if I/O errors occurred while reading from the
    # underlying stream
    # @see #ObjectInputStream()
    # @see #readObject()
    # @since 1.2
    def read_object_override
      return nil
    end
    
    typesig { [] }
    # Reads an "unshared" object from the ObjectInputStream.  This method is
    # identical to readObject, except that it prevents subsequent calls to
    # readObject and readUnshared from returning additional references to the
    # deserialized instance obtained via this call.  Specifically:
    # <ul>
    # <li>If readUnshared is called to deserialize a back-reference (the
    # stream representation of an object which has been written
    # previously to the stream), an ObjectStreamException will be
    # thrown.
    # 
    # <li>If readUnshared returns successfully, then any subsequent attempts
    # to deserialize back-references to the stream handle deserialized
    # by readUnshared will cause an ObjectStreamException to be thrown.
    # </ul>
    # Deserializing an object via readUnshared invalidates the stream handle
    # associated with the returned object.  Note that this in itself does not
    # always guarantee that the reference returned by readUnshared is unique;
    # the deserialized object may define a readResolve method which returns an
    # object visible to other parties, or readUnshared may return a Class
    # object or enum constant obtainable elsewhere in the stream or through
    # external means. If the deserialized object defines a readResolve method
    # and the invocation of that method returns an array, then readUnshared
    # returns a shallow clone of that array; this guarantees that the returned
    # array object is unique and cannot be obtained a second time from an
    # invocation of readObject or readUnshared on the ObjectInputStream,
    # even if the underlying data stream has been manipulated.
    # 
    # <p>ObjectInputStream subclasses which override this method can only be
    # constructed in security contexts possessing the
    # "enableSubclassImplementation" SerializablePermission; any attempt to
    # instantiate such a subclass without this permission will cause a
    # SecurityException to be thrown.
    # 
    # @return  reference to deserialized object
    # @throws  ClassNotFoundException if class of an object to deserialize
    # cannot be found
    # @throws  StreamCorruptedException if control information in the stream
    # is inconsistent
    # @throws  ObjectStreamException if object to deserialize has already
    # appeared in stream
    # @throws  OptionalDataException if primitive data is next in stream
    # @throws  IOException if an I/O error occurs during deserialization
    # @since   1.4
    def read_unshared
      # if nested read, passHandle contains handle of enclosing object
      outer_handle = @pass_handle
      begin
        obj = read_object0(true)
        @handles.mark_dependency(outer_handle, @pass_handle)
        ex = @handles.lookup_exception(@pass_handle)
        if (!(ex).nil?)
          raise ex
        end
        if ((@depth).equal?(0))
          @vlist.do_callbacks
        end
        return obj
      ensure
        @pass_handle = outer_handle
        if (@closed && (@depth).equal?(0))
          clear
        end
      end
    end
    
    typesig { [] }
    # Read the non-static and non-transient fields of the current class from
    # this stream.  This may only be called from the readObject method of the
    # class being deserialized. It will throw the NotActiveException if it is
    # called otherwise.
    # 
    # @throws  ClassNotFoundException if the class of a serialized object
    # could not be found.
    # @throws  IOException if an I/O error occurs.
    # @throws  NotActiveException if the stream is not currently reading
    # objects.
    def default_read_object
      if ((@cur_context).nil?)
        raise NotActiveException.new("not in call to readObject")
      end
      cur_obj = @cur_context.get_obj
      cur_desc = @cur_context.get_desc
      @bin.set_block_data_mode(false)
      default_read_fields(cur_obj, cur_desc)
      @bin.set_block_data_mode(true)
      if (!cur_desc.has_write_object_data)
        # Fix for 4360508: since stream does not contain terminating
        # TC_ENDBLOCKDATA tag, set flag so that reading code elsewhere
        # knows to simulate end-of-custom-data behavior.
        @default_data_end = true
      end
      ex = @handles.lookup_exception(@pass_handle)
      if (!(ex).nil?)
        raise ex
      end
    end
    
    typesig { [] }
    # Reads the persistent fields from the stream and makes them available by
    # name.
    # 
    # @return  the <code>GetField</code> object representing the persistent
    # fields of the object being deserialized
    # @throws  ClassNotFoundException if the class of a serialized object
    # could not be found.
    # @throws  IOException if an I/O error occurs.
    # @throws  NotActiveException if the stream is not currently reading
    # objects.
    # @since 1.2
    def read_fields
      if ((@cur_context).nil?)
        raise NotActiveException.new("not in call to readObject")
      end
      cur_obj = @cur_context.get_obj
      cur_desc = @cur_context.get_desc
      @bin.set_block_data_mode(false)
      get_field = GetFieldImpl.new_local(self, cur_desc)
      get_field.read_fields
      @bin.set_block_data_mode(true)
      if (!cur_desc.has_write_object_data)
        # Fix for 4360508: since stream does not contain terminating
        # TC_ENDBLOCKDATA tag, set flag so that reading code elsewhere
        # knows to simulate end-of-custom-data behavior.
        @default_data_end = true
      end
      return get_field
    end
    
    typesig { [ObjectInputValidation, ::Java::Int] }
    # Register an object to be validated before the graph is returned.  While
    # similar to resolveObject these validations are called after the entire
    # graph has been reconstituted.  Typically, a readObject method will
    # register the object with the stream so that when all of the objects are
    # restored a final set of validations can be performed.
    # 
    # @param   obj the object to receive the validation callback.
    # @param   prio controls the order of callbacks;zero is a good default.
    # Use higher numbers to be called back earlier, lower numbers for
    # later callbacks. Within a priority, callbacks are processed in
    # no particular order.
    # @throws  NotActiveException The stream is not currently reading objects
    # so it is invalid to register a callback.
    # @throws  InvalidObjectException The validation object is null.
    def register_validation(obj, prio)
      if ((@depth).equal?(0))
        raise NotActiveException.new("stream inactive")
      end
      @vlist.register(obj, prio)
    end
    
    typesig { [ObjectStreamClass] }
    # Load the local class equivalent of the specified stream class
    # description.  Subclasses may implement this method to allow classes to
    # be fetched from an alternate source.
    # 
    # <p>The corresponding method in <code>ObjectOutputStream</code> is
    # <code>annotateClass</code>.  This method will be invoked only once for
    # each unique class in the stream.  This method can be implemented by
    # subclasses to use an alternate loading mechanism but must return a
    # <code>Class</code> object. Once returned, if the class is not an array
    # class, its serialVersionUID is compared to the serialVersionUID of the
    # serialized class, and if there is a mismatch, the deserialization fails
    # and an {@link InvalidClassException} is thrown.
    # 
    # <p>The default implementation of this method in
    # <code>ObjectInputStream</code> returns the result of calling
    # <pre>
    # Class.forName(desc.getName(), false, loader)
    # </pre>
    # where <code>loader</code> is determined as follows: if there is a
    # method on the current thread's stack whose declaring class was
    # defined by a user-defined class loader (and was not a generated to
    # implement reflective invocations), then <code>loader</code> is class
    # loader corresponding to the closest such method to the currently
    # executing frame; otherwise, <code>loader</code> is
    # <code>null</code>. If this call results in a
    # <code>ClassNotFoundException</code> and the name of the passed
    # <code>ObjectStreamClass</code> instance is the Java language keyword
    # for a primitive type or void, then the <code>Class</code> object
    # representing that primitive type or void will be returned
    # (e.g., an <code>ObjectStreamClass</code> with the name
    # <code>"int"</code> will be resolved to <code>Integer.TYPE</code>).
    # Otherwise, the <code>ClassNotFoundException</code> will be thrown to
    # the caller of this method.
    # 
    # @param   desc an instance of class <code>ObjectStreamClass</code>
    # @return  a <code>Class</code> object corresponding to <code>desc</code>
    # @throws  IOException any of the usual Input/Output exceptions.
    # @throws  ClassNotFoundException if class of a serialized object cannot
    # be found.
    def resolve_class(desc)
      name = desc.get_name
      begin
        return Class.for_name(name, false, latest_user_defined_loader)
      rescue ClassNotFoundException => ex
        cl = PrimClasses.get(name)
        if (!(cl).nil?)
          return cl
        else
          raise ex
        end
      end
    end
    
    typesig { [Array.typed(String)] }
    # Returns a proxy class that implements the interfaces named in a proxy
    # class descriptor; subclasses may implement this method to read custom
    # data from the stream along with the descriptors for dynamic proxy
    # classes, allowing them to use an alternate loading mechanism for the
    # interfaces and the proxy class.
    # 
    # <p>This method is called exactly once for each unique proxy class
    # descriptor in the stream.
    # 
    # <p>The corresponding method in <code>ObjectOutputStream</code> is
    # <code>annotateProxyClass</code>.  For a given subclass of
    # <code>ObjectInputStream</code> that overrides this method, the
    # <code>annotateProxyClass</code> method in the corresponding subclass of
    # <code>ObjectOutputStream</code> must write any data or objects read by
    # this method.
    # 
    # <p>The default implementation of this method in
    # <code>ObjectInputStream</code> returns the result of calling
    # <code>Proxy.getProxyClass</code> with the list of <code>Class</code>
    # objects for the interfaces that are named in the <code>interfaces</code>
    # parameter.  The <code>Class</code> object for each interface name
    # <code>i</code> is the value returned by calling
    # <pre>
    # Class.forName(i, false, loader)
    # </pre>
    # where <code>loader</code> is that of the first non-<code>null</code>
    # class loader up the execution stack, or <code>null</code> if no
    # non-<code>null</code> class loaders are on the stack (the same class
    # loader choice used by the <code>resolveClass</code> method).  Unless any
    # of the resolved interfaces are non-public, this same value of
    # <code>loader</code> is also the class loader passed to
    # <code>Proxy.getProxyClass</code>; if non-public interfaces are present,
    # their class loader is passed instead (if more than one non-public
    # interface class loader is encountered, an
    # <code>IllegalAccessError</code> is thrown).
    # If <code>Proxy.getProxyClass</code> throws an
    # <code>IllegalArgumentException</code>, <code>resolveProxyClass</code>
    # will throw a <code>ClassNotFoundException</code> containing the
    # <code>IllegalArgumentException</code>.
    # 
    # @param interfaces the list of interface names that were
    # deserialized in the proxy class descriptor
    # @return  a proxy class for the specified interfaces
    # @throws        IOException any exception thrown by the underlying
    # <code>InputStream</code>
    # @throws        ClassNotFoundException if the proxy class or any of the
    # named interfaces could not be found
    # @see ObjectOutputStream#annotateProxyClass(Class)
    # @since 1.3
    def resolve_proxy_class(interfaces)
      latest_loader = latest_user_defined_loader
      non_public_loader = nil
      has_non_public_interface = false
      # define proxy in class loader of non-public interface(s), if any
      class_objs = Array.typed(Class).new(interfaces.attr_length) { nil }
      i = 0
      while i < interfaces.attr_length
        cl = Class.for_name(interfaces[i], false, latest_loader)
        if (((cl.get_modifiers & Modifier::PUBLIC)).equal?(0))
          if (has_non_public_interface)
            if (!(non_public_loader).equal?(cl.get_class_loader))
              raise IllegalAccessError.new("conflicting non-public interface class loaders")
            end
          else
            non_public_loader = cl.get_class_loader
            has_non_public_interface = true
          end
        end
        class_objs[i] = cl
        i += 1
      end
      begin
        return Proxy.get_proxy_class(has_non_public_interface ? non_public_loader : latest_loader, class_objs)
      rescue IllegalArgumentException => e
        raise ClassNotFoundException.new(nil, e)
      end
    end
    
    typesig { [Object] }
    # This method will allow trusted subclasses of ObjectInputStream to
    # substitute one object for another during deserialization. Replacing
    # objects is disabled until enableResolveObject is called. The
    # enableResolveObject method checks that the stream requesting to resolve
    # object can be trusted. Every reference to serializable objects is passed
    # to resolveObject.  To insure that the private state of objects is not
    # unintentionally exposed only trusted streams may use resolveObject.
    # 
    # <p>This method is called after an object has been read but before it is
    # returned from readObject.  The default resolveObject method just returns
    # the same object.
    # 
    # <p>When a subclass is replacing objects it must insure that the
    # substituted object is compatible with every field where the reference
    # will be stored.  Objects whose type is not a subclass of the type of the
    # field or array element abort the serialization by raising an exception
    # and the object is not be stored.
    # 
    # <p>This method is called only once when each object is first
    # encountered.  All subsequent references to the object will be redirected
    # to the new object.
    # 
    # @param   obj object to be substituted
    # @return  the substituted object
    # @throws  IOException Any of the usual Input/Output exceptions.
    def resolve_object(obj)
      return obj
    end
    
    typesig { [::Java::Boolean] }
    # Enable the stream to allow objects read from the stream to be replaced.
    # When enabled, the resolveObject method is called for every object being
    # deserialized.
    # 
    # <p>If <i>enable</i> is true, and there is a security manager installed,
    # this method first calls the security manager's
    # <code>checkPermission</code> method with the
    # <code>SerializablePermission("enableSubstitution")</code> permission to
    # ensure it's ok to enable the stream to allow objects read from the
    # stream to be replaced.
    # 
    # @param   enable true for enabling use of <code>resolveObject</code> for
    # every object being deserialized
    # @return  the previous setting before this method was invoked
    # @throws  SecurityException if a security manager exists and its
    # <code>checkPermission</code> method denies enabling the stream
    # to allow objects read from the stream to be replaced.
    # @see SecurityManager#checkPermission
    # @see java.io.SerializablePermission
    def enable_resolve_object(enable)
      if ((enable).equal?(@enable_resolve))
        return enable
      end
      if (enable)
        sm = System.get_security_manager
        if (!(sm).nil?)
          sm.check_permission(SUBSTITUTION_PERMISSION)
        end
      end
      @enable_resolve = enable
      return !@enable_resolve
    end
    
    typesig { [] }
    # The readStreamHeader method is provided to allow subclasses to read and
    # verify their own stream headers. It reads and verifies the magic number
    # and version number.
    # 
    # @throws  IOException if there are I/O errors while reading from the
    # underlying <code>InputStream</code>
    # @throws  StreamCorruptedException if control information in the stream
    # is inconsistent
    def read_stream_header
      s0 = @bin.read_short
      s1 = @bin.read_short
      if (!(s0).equal?(STREAM_MAGIC) || !(s1).equal?(STREAM_VERSION))
        raise StreamCorruptedException.new(String.format("invalid stream header: %04X%04X", s0, s1))
      end
    end
    
    typesig { [] }
    # Read a class descriptor from the serialization stream.  This method is
    # called when the ObjectInputStream expects a class descriptor as the next
    # item in the serialization stream.  Subclasses of ObjectInputStream may
    # override this method to read in class descriptors that have been written
    # in non-standard formats (by subclasses of ObjectOutputStream which have
    # overridden the <code>writeClassDescriptor</code> method).  By default,
    # this method reads class descriptors according to the format defined in
    # the Object Serialization specification.
    # 
    # @return  the class descriptor read
    # @throws  IOException If an I/O error has occurred.
    # @throws  ClassNotFoundException If the Class of a serialized object used
    # in the class descriptor representation cannot be found
    # @see java.io.ObjectOutputStream#writeClassDescriptor(java.io.ObjectStreamClass)
    # @since 1.3
    def read_class_descriptor
      desc = ObjectStreamClass.new
      desc.read_non_proxy(self)
      return desc
    end
    
    typesig { [] }
    # Reads a byte of data. This method will block if no input is available.
    # 
    # @return  the byte read, or -1 if the end of the stream is reached.
    # @throws  IOException If an I/O error has occurred.
    def read
      return @bin.read
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads into an array of bytes.  This method will block until some input
    # is available. Consider using java.io.DataInputStream.readFully to read
    # exactly 'length' bytes.
    # 
    # @param   buf the buffer into which the data is read
    # @param   off the start offset of the data
    # @param   len the maximum number of bytes read
    # @return  the actual number of bytes read, -1 is returned when the end of
    # the stream is reached.
    # @throws  IOException If an I/O error has occurred.
    # @see java.io.DataInputStream#readFully(byte[],int,int)
    def read(buf, off, len)
      if ((buf).nil?)
        raise NullPointerException.new
      end
      endoff = off + len
      if (off < 0 || len < 0 || endoff > buf.attr_length || endoff < 0)
        raise IndexOutOfBoundsException.new
      end
      return @bin.read(buf, off, len, false)
    end
    
    typesig { [] }
    # Returns the number of bytes that can be read without blocking.
    # 
    # @return  the number of available bytes.
    # @throws  IOException if there are I/O errors while reading from the
    # underlying <code>InputStream</code>
    def available
      return @bin.available
    end
    
    typesig { [] }
    # Closes the input stream. Must be called to release any resources
    # associated with the stream.
    # 
    # @throws  IOException If an I/O error has occurred.
    def close
      # Even if stream already closed, propagate redundant close to
      # underlying stream to stay consistent with previous implementations.
      @closed = true
      if ((@depth).equal?(0))
        clear
      end
      @bin.close
    end
    
    typesig { [] }
    # Reads in a boolean.
    # 
    # @return  the boolean read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_boolean
      return @bin.read_boolean
    end
    
    typesig { [] }
    # Reads an 8 bit byte.
    # 
    # @return  the 8 bit byte read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_byte
      return @bin.read_byte
    end
    
    typesig { [] }
    # Reads an unsigned 8 bit byte.
    # 
    # @return  the 8 bit byte read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_unsigned_byte
      return @bin.read_unsigned_byte
    end
    
    typesig { [] }
    # Reads a 16 bit char.
    # 
    # @return  the 16 bit char read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_char
      return @bin.read_char
    end
    
    typesig { [] }
    # Reads a 16 bit short.
    # 
    # @return  the 16 bit short read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_short
      return @bin.read_short
    end
    
    typesig { [] }
    # Reads an unsigned 16 bit short.
    # 
    # @return  the 16 bit short read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_unsigned_short
      return @bin.read_unsigned_short
    end
    
    typesig { [] }
    # Reads a 32 bit int.
    # 
    # @return  the 32 bit integer read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_int
      return @bin.read_int
    end
    
    typesig { [] }
    # Reads a 64 bit long.
    # 
    # @return  the read 64 bit long.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_long
      return @bin.read_long
    end
    
    typesig { [] }
    # Reads a 32 bit float.
    # 
    # @return  the 32 bit float read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_float
      return @bin.read_float
    end
    
    typesig { [] }
    # Reads a 64 bit double.
    # 
    # @return  the 64 bit double read.
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_double
      return @bin.read_double
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    # Reads bytes, blocking until all bytes are read.
    # 
    # @param   buf the buffer into which the data is read
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_fully(buf)
      @bin.read_fully(buf, 0, buf.attr_length, false)
    end
    
    typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
    # Reads bytes, blocking until all bytes are read.
    # 
    # @param   buf the buffer into which the data is read
    # @param   off the start offset of the data
    # @param   len the maximum number of bytes to read
    # @throws  EOFException If end of file is reached.
    # @throws  IOException If other I/O error has occurred.
    def read_fully(buf, off, len)
      endoff = off + len
      if (off < 0 || len < 0 || endoff > buf.attr_length || endoff < 0)
        raise IndexOutOfBoundsException.new
      end
      @bin.read_fully(buf, off, len, false)
    end
    
    typesig { [::Java::Int] }
    # Skips bytes.
    # 
    # @param   len the number of bytes to be skipped
    # @return  the actual number of bytes skipped.
    # @throws  IOException If an I/O error has occurred.
    def skip_bytes(len)
      return @bin.skip_bytes(len)
    end
    
    typesig { [] }
    # Reads in a line that has been terminated by a \n, \r, \r\n or EOF.
    # 
    # @return  a String copy of the line.
    # @throws  IOException if there are I/O errors while reading from the
    # underlying <code>InputStream</code>
    # @deprecated This method does not properly convert bytes to characters.
    # see DataInputStream for the details and alternatives.
    def read_line
      return @bin.read_line
    end
    
    typesig { [] }
    # Reads a String in
    # <a href="DataInput.html#modified-utf-8">modified UTF-8</a>
    # format.
    # 
    # @return  the String.
    # @throws  IOException if there are I/O errors while reading from the
    # underlying <code>InputStream</code>
    # @throws  UTFDataFormatException if read bytes do not represent a valid
    # modified UTF-8 encoding of a string
    def read_utf
      return @bin.read_utf
    end
    
    class_module.module_eval {
      # Provide access to the persistent fields read from the input stream.
      const_set_lazy(:GetField) { Class.new do
        include_class_members ObjectInputStream
        
        typesig { [] }
        # Get the ObjectStreamClass that describes the fields in the stream.
        # 
        # @return  the descriptor class that describes the serializable fields
        def get_object_stream_class
          raise NotImplementedError
        end
        
        typesig { [String] }
        # Return true if the named field is defaulted and has no value in this
        # stream.
        # 
        # @param  name the name of the field
        # @return true, if and only if the named field is defaulted
        # @throws IOException if there are I/O errors while reading from
        # the underlying <code>InputStream</code>
        # @throws IllegalArgumentException if <code>name</code> does not
        # correspond to a serializable field
        def defaulted(name)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Boolean] }
        # Get the value of the named boolean field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>boolean</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Byte] }
        # Get the value of the named byte field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>byte</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Char] }
        # Get the value of the named char field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>char</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Short] }
        # Get the value of the named short field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>short</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Int] }
        # Get the value of the named int field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>int</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Long] }
        # Get the value of the named long field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>long</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Float] }
        # Get the value of the named float field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>float</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, ::Java::Double] }
        # Get the value of the named double field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>double</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [String, Object] }
        # Get the value of the named Object field from the persistent field.
        # 
        # @param  name the name of the field
        # @param  val the default value to use if <code>name</code> does not
        # have a value
        # @return the value of the named <code>Object</code> field
        # @throws IOException if there are I/O errors while reading from the
        # underlying <code>InputStream</code>
        # @throws IllegalArgumentException if type of <code>name</code> is
        # not serializable or if the field type is incorrect
        def get(name, val)
          raise NotImplementedError
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__get_field, :initialize
      end }
    }
    
    typesig { [] }
    # Verifies that this (possibly subclass) instance can be constructed
    # without violating security constraints: the subclass must not override
    # security-sensitive non-final methods, or else the
    # "enableSubclassImplementation" SerializablePermission is checked.
    def verify_subclass
      cl = get_class
      if ((cl).equal?(ObjectInputStream))
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
          include_class_members ObjectInputStream
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            cl = subcl
            while !(cl).equal?(ObjectInputStream)
              begin
                cl.get_declared_method("readUnshared", nil)
                return Boolean::FALSE
              rescue self.class::NoSuchMethodException => ex
              end
              begin
                cl.get_declared_method("readFields", nil)
                return Boolean::FALSE
              rescue self.class::NoSuchMethodException => ex
              end
              cl = cl.get_superclass
            end
            return Boolean::TRUE
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
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
      @handles.clear
      @vlist.clear
    end
    
    typesig { [::Java::Boolean] }
    # Underlying readObject implementation.
    def read_object0(unshared)
      old_mode = @bin.get_block_data_mode
      if (old_mode)
        remain = @bin.current_block_remaining
        if (remain > 0)
          raise OptionalDataException.new(remain)
        else
          if (@default_data_end)
            # Fix for 4360508: stream is currently at the end of a field
            # value block written via default serialization; since there
            # is no terminating TC_ENDBLOCKDATA tag, simulate
            # end-of-custom-data behavior explicitly.
            raise OptionalDataException.new(true)
          end
        end
        @bin.set_block_data_mode(false)
      end
      tc = 0
      while (((tc = @bin.peek_byte)).equal?(TC_RESET))
        @bin.read_byte
        handle_reset
      end
      @depth += 1
      begin
        case (tc)
        when TC_NULL
          return read_null
        when TC_REFERENCE
          return read_handle(unshared)
        when TC_CLASS
          return read_class(unshared)
        when TC_CLASSDESC, TC_PROXYCLASSDESC
          return read_class_desc(unshared)
        when TC_STRING, TC_LONGSTRING
          return check_resolve(read_string(unshared))
        when TC_ARRAY
          return check_resolve(read_array(unshared))
        when TC_ENUM
          return check_resolve(read_enum(unshared))
        when TC_OBJECT
          return check_resolve(read_ordinary_object(unshared))
        when TC_EXCEPTION
          ex = read_fatal_exception
          raise WriteAbortedException.new("writing aborted", ex)
        when TC_BLOCKDATA, TC_BLOCKDATALONG
          if (old_mode)
            @bin.set_block_data_mode(true)
            @bin.peek # force header read
            raise OptionalDataException.new(@bin.current_block_remaining)
          else
            raise StreamCorruptedException.new("unexpected block data")
          end
        when TC_ENDBLOCKDATA
          if (old_mode)
            raise OptionalDataException.new(true)
          else
            raise StreamCorruptedException.new("unexpected end of block data")
          end
        else
          raise StreamCorruptedException.new(String.format("invalid type code: %02X", tc))
        end
      ensure
        @depth -= 1
        @bin.set_block_data_mode(old_mode)
      end
    end
    
    typesig { [Object] }
    # If resolveObject has been enabled and given object does not have an
    # exception associated with it, calls resolveObject to determine
    # replacement for object, and updates handle table accordingly.  Returns
    # replacement object, or echoes provided object if no replacement
    # occurred.  Expects that passHandle is set to given object's handle prior
    # to calling this method.
    def check_resolve(obj)
      if (!@enable_resolve || !(@handles.lookup_exception(@pass_handle)).nil?)
        return obj
      end
      rep = resolve_object(obj)
      if (!(rep).equal?(obj))
        @handles.set_object(@pass_handle, rep)
      end
      return rep
    end
    
    typesig { [] }
    # Reads string without allowing it to be replaced in stream.  Called from
    # within ObjectStreamClass.read().
    def read_type_string
      old_handle = @pass_handle
      begin
        tc = @bin.peek_byte
        case (tc)
        when TC_NULL
          return read_null
        when TC_REFERENCE
          return read_handle(false)
        when TC_STRING, TC_LONGSTRING
          return read_string(false)
        else
          raise StreamCorruptedException.new(String.format("invalid type code: %02X", tc))
        end
      ensure
        @pass_handle = old_handle
      end
    end
    
    typesig { [] }
    # Reads in null code, sets passHandle to NULL_HANDLE and returns null.
    def read_null
      if (!(@bin.read_byte).equal?(TC_NULL))
        raise InternalError.new
      end
      @pass_handle = NULL_HANDLE
      return nil
    end
    
    typesig { [::Java::Boolean] }
    # Reads in object handle, sets passHandle to the read handle, and returns
    # object associated with the handle.
    def read_handle(unshared)
      if (!(@bin.read_byte).equal?(TC_REFERENCE))
        raise InternalError.new
      end
      @pass_handle = @bin.read_int - self.attr_base_wire_handle
      if (@pass_handle < 0 || @pass_handle >= @handles.size)
        raise StreamCorruptedException.new(String.format("invalid handle value: %08X", @pass_handle + self.attr_base_wire_handle))
      end
      if (unshared)
        # REMIND: what type of exception to throw here?
        raise InvalidObjectException.new("cannot read back reference as unshared")
      end
      obj = @handles.lookup_object(@pass_handle)
      if ((obj).equal?(UnsharedMarker))
        # REMIND: what type of exception to throw here?
        raise InvalidObjectException.new("cannot read back reference to unshared object")
      end
      return obj
    end
    
    typesig { [::Java::Boolean] }
    # Reads in and returns class object.  Sets passHandle to class object's
    # assigned handle.  Returns null if class is unresolvable (in which case a
    # ClassNotFoundException will be associated with the class' handle in the
    # handle table).
    def read_class(unshared)
      if (!(@bin.read_byte).equal?(TC_CLASS))
        raise InternalError.new
      end
      desc = read_class_desc(false)
      cl = desc.for_class
      @pass_handle = @handles.assign(unshared ? UnsharedMarker : cl)
      resolve_ex = desc.get_resolve_exception
      if (!(resolve_ex).nil?)
        @handles.mark_exception(@pass_handle, resolve_ex)
      end
      @handles.finish(@pass_handle)
      return cl
    end
    
    typesig { [::Java::Boolean] }
    # Reads in and returns (possibly null) class descriptor.  Sets passHandle
    # to class descriptor's assigned handle.  If class descriptor cannot be
    # resolved to a class in the local VM, a ClassNotFoundException is
    # associated with the class descriptor's handle.
    def read_class_desc(unshared)
      tc = @bin.peek_byte
      case (tc)
      when TC_NULL
        return read_null
      when TC_REFERENCE
        return read_handle(unshared)
      when TC_PROXYCLASSDESC
        return read_proxy_desc(unshared)
      when TC_CLASSDESC
        return read_non_proxy_desc(unshared)
      else
        raise StreamCorruptedException.new(String.format("invalid type code: %02X", tc))
      end
    end
    
    typesig { [::Java::Boolean] }
    # Reads in and returns class descriptor for a dynamic proxy class.  Sets
    # passHandle to proxy class descriptor's assigned handle.  If proxy class
    # descriptor cannot be resolved to a class in the local VM, a
    # ClassNotFoundException is associated with the descriptor's handle.
    def read_proxy_desc(unshared)
      if (!(@bin.read_byte).equal?(TC_PROXYCLASSDESC))
        raise InternalError.new
      end
      desc = ObjectStreamClass.new
      desc_handle = @handles.assign(unshared ? UnsharedMarker : desc)
      @pass_handle = NULL_HANDLE
      num_ifaces = @bin.read_int
      ifaces = Array.typed(String).new(num_ifaces) { nil }
      i = 0
      while i < num_ifaces
        ifaces[i] = @bin.read_utf
        i += 1
      end
      cl = nil
      resolve_ex = nil
      @bin.set_block_data_mode(true)
      begin
        if (((cl = resolve_proxy_class(ifaces))).nil?)
          resolve_ex = ClassNotFoundException.new("null class")
        end
      rescue ClassNotFoundException => ex
        resolve_ex = ex
      end
      skip_custom_data
      desc.init_proxy(cl, resolve_ex, read_class_desc(false))
      @handles.finish(desc_handle)
      @pass_handle = desc_handle
      return desc
    end
    
    typesig { [::Java::Boolean] }
    # Reads in and returns class descriptor for a class that is not a dynamic
    # proxy class.  Sets passHandle to class descriptor's assigned handle.  If
    # class descriptor cannot be resolved to a class in the local VM, a
    # ClassNotFoundException is associated with the descriptor's handle.
    def read_non_proxy_desc(unshared)
      if (!(@bin.read_byte).equal?(TC_CLASSDESC))
        raise InternalError.new
      end
      desc = ObjectStreamClass.new
      desc_handle = @handles.assign(unshared ? UnsharedMarker : desc)
      @pass_handle = NULL_HANDLE
      read_desc = nil
      begin
        read_desc = read_class_descriptor
      rescue ClassNotFoundException => ex
        raise InvalidClassException.new("failed to read class descriptor").init_cause(ex)
      end
      cl = nil
      resolve_ex = nil
      @bin.set_block_data_mode(true)
      begin
        if (((cl = resolve_class(read_desc))).nil?)
          resolve_ex = ClassNotFoundException.new("null class")
        end
      rescue ClassNotFoundException => ex
        resolve_ex = ex
      end
      skip_custom_data
      desc.init_non_proxy(read_desc, cl, resolve_ex, read_class_desc(false))
      @handles.finish(desc_handle)
      @pass_handle = desc_handle
      return desc
    end
    
    typesig { [::Java::Boolean] }
    # Reads in and returns new string.  Sets passHandle to new string's
    # assigned handle.
    def read_string(unshared)
      str = nil
      tc = @bin.read_byte
      case (tc)
      when TC_STRING
        str = RJava.cast_to_string(@bin.read_utf)
      when TC_LONGSTRING
        str = RJava.cast_to_string(@bin.read_long_utf)
      else
        raise StreamCorruptedException.new(String.format("invalid type code: %02X", tc))
      end
      @pass_handle = @handles.assign(unshared ? UnsharedMarker : str)
      @handles.finish(@pass_handle)
      return str
    end
    
    typesig { [::Java::Boolean] }
    # Reads in and returns array object, or null if array class is
    # unresolvable.  Sets passHandle to array's assigned handle.
    def read_array(unshared)
      if (!(@bin.read_byte).equal?(TC_ARRAY))
        raise InternalError.new
      end
      desc = read_class_desc(false)
      len = @bin.read_int
      array = nil
      cl = nil
      ccl = nil
      if (!((cl = desc.for_class)).nil?)
        ccl = cl.get_component_type
        array = Array.new_instance(ccl, len)
      end
      array_handle = @handles.assign(unshared ? UnsharedMarker : array)
      resolve_ex = desc.get_resolve_exception
      if (!(resolve_ex).nil?)
        @handles.mark_exception(array_handle, resolve_ex)
      end
      if ((ccl).nil?)
        i = 0
        while i < len
          read_object0(false)
          i += 1
        end
      else
        if (ccl.is_primitive)
          if ((ccl).equal?(JavaInteger::TYPE))
            @bin.read_ints(array, 0, len)
          else
            if ((ccl).equal?(Byte::TYPE))
              @bin.read_fully(array, 0, len, true)
            else
              if ((ccl).equal?(Long::TYPE))
                @bin.read_longs(array, 0, len)
              else
                if ((ccl).equal?(Float::TYPE))
                  @bin.read_floats(array, 0, len)
                else
                  if ((ccl).equal?(Double::TYPE))
                    @bin.read_doubles(array, 0, len)
                  else
                    if ((ccl).equal?(Short::TYPE))
                      @bin.read_shorts(array, 0, len)
                    else
                      if ((ccl).equal?(Character::TYPE))
                        @bin.read_chars(array, 0, len)
                      else
                        if ((ccl).equal?(Boolean::TYPE))
                          @bin.read_booleans(array, 0, len)
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
          oa = array
          i = 0
          while i < len
            oa[i] = read_object0(false)
            @handles.mark_dependency(array_handle, @pass_handle)
            i += 1
          end
        end
      end
      @handles.finish(array_handle)
      @pass_handle = array_handle
      return array
    end
    
    typesig { [::Java::Boolean] }
    # Reads in and returns enum constant, or null if enum type is
    # unresolvable.  Sets passHandle to enum constant's assigned handle.
    def read_enum(unshared)
      if (!(@bin.read_byte).equal?(TC_ENUM))
        raise InternalError.new
      end
      desc = read_class_desc(false)
      if (!desc.is_enum)
        raise InvalidClassException.new("non-enum class: " + RJava.cast_to_string(desc))
      end
      enum_handle = @handles.assign(unshared ? UnsharedMarker : nil)
      resolve_ex = desc.get_resolve_exception
      if (!(resolve_ex).nil?)
        @handles.mark_exception(enum_handle, resolve_ex)
      end
      name = read_string(false)
      en = nil
      cl = desc.for_class
      if (!(cl).nil?)
        begin
          en = Enum.value_of(cl, name)
        rescue IllegalArgumentException => ex
          raise InvalidObjectException.new("enum constant " + name + " does not exist in " + RJava.cast_to_string(cl)).init_cause(ex)
        end
        if (!unshared)
          @handles.set_object(enum_handle, en)
        end
      end
      @handles.finish(enum_handle)
      @pass_handle = enum_handle
      return en
    end
    
    typesig { [::Java::Boolean] }
    # Reads and returns "ordinary" (i.e., not a String, Class,
    # ObjectStreamClass, array, or enum constant) object, or null if object's
    # class is unresolvable (in which case a ClassNotFoundException will be
    # associated with object's handle).  Sets passHandle to object's assigned
    # handle.
    def read_ordinary_object(unshared)
      if (!(@bin.read_byte).equal?(TC_OBJECT))
        raise InternalError.new
      end
      desc = read_class_desc(false)
      desc.check_deserialize
      obj = nil
      begin
        obj = desc.is_instantiable ? desc.new_instance : nil
      rescue JavaException => ex
        raise InvalidClassException.new(desc.for_class.get_name, "unable to create instance").init_cause(ex)
      end
      @pass_handle = @handles.assign(unshared ? UnsharedMarker : obj)
      resolve_ex = desc.get_resolve_exception
      if (!(resolve_ex).nil?)
        @handles.mark_exception(@pass_handle, resolve_ex)
      end
      if (desc.is_externalizable)
        read_external_data(obj, desc)
      else
        read_serial_data(obj, desc)
      end
      @handles.finish(@pass_handle)
      if (!(obj).nil? && (@handles.lookup_exception(@pass_handle)).nil? && desc.has_read_resolve_method)
        rep = desc.invoke_read_resolve(obj)
        if (unshared && rep.get_class.is_array)
          rep = clone_array(rep)
        end
        if (!(rep).equal?(obj))
          @handles.set_object(@pass_handle, obj = rep)
        end
      end
      return obj
    end
    
    typesig { [Externalizable, ObjectStreamClass] }
    # If obj is non-null, reads externalizable data by invoking readExternal()
    # method of obj; otherwise, attempts to skip over externalizable data.
    # Expects that passHandle is set to obj's handle before this method is
    # called.
    def read_external_data(obj, desc)
      old_context = @cur_context
      @cur_context = nil
      begin
        blocked = desc.has_block_external_data
        if (blocked)
          @bin.set_block_data_mode(true)
        end
        if (!(obj).nil?)
          begin
            obj.read_external(self)
          rescue ClassNotFoundException => ex
            # In most cases, the handle table has already propagated
            # a CNFException to passHandle at this point; this mark
            # call is included to address cases where the readExternal
            # method has cons'ed and thrown a new CNFException of its
            # own.
            @handles.mark_exception(@pass_handle, ex)
          end
        end
        if (blocked)
          skip_custom_data
        end
      ensure
        @cur_context = old_context
      end
      # At this point, if the externalizable data was not written in
      # block-data form and either the externalizable class doesn't exist
      # locally (i.e., obj == null) or readExternal() just threw a
      # CNFException, then the stream is probably in an inconsistent state,
      # since some (or all) of the externalizable data may not have been
      # consumed.  Since there's no "correct" action to take in this case,
      # we mimic the behavior of past serialization implementations and
      # blindly hope that the stream is in sync; if it isn't and additional
      # externalizable data remains in the stream, a subsequent read will
      # most likely throw a StreamCorruptedException.
    end
    
    typesig { [Object, ObjectStreamClass] }
    # Reads (or attempts to skip, if obj is null or is tagged with a
    # ClassNotFoundException) instance data for each serializable class of
    # object in stream, from superclass to subclass.  Expects that passHandle
    # is set to obj's handle before this method is called.
    def read_serial_data(obj, desc)
      slots = desc.get_class_data_layout
      i = 0
      while i < slots.attr_length
        slot_desc = slots[i].attr_desc
        if (slots[i].attr_has_data)
          if (!(obj).nil? && slot_desc.has_read_object_method && (@handles.lookup_exception(@pass_handle)).nil?)
            old_context = @cur_context
            begin
              @cur_context = CallbackContext.new(obj, slot_desc)
              @bin.set_block_data_mode(true)
              slot_desc.invoke_read_object(obj, self)
            rescue ClassNotFoundException => ex
              # In most cases, the handle table has already
              # propagated a CNFException to passHandle at this
              # point; this mark call is included to address cases
              # where the custom readObject method has cons'ed and
              # thrown a new CNFException of its own.
              @handles.mark_exception(@pass_handle, ex)
            ensure
              @cur_context.set_used
              @cur_context = old_context
            end
            # defaultDataEnd may have been set indirectly by custom
            # readObject() method when calling defaultReadObject() or
            # readFields(); clear it to restore normal read behavior.
            @default_data_end = false
          else
            default_read_fields(obj, slot_desc)
          end
          if (slot_desc.has_write_object_data)
            skip_custom_data
          else
            @bin.set_block_data_mode(false)
          end
        else
          if (!(obj).nil? && slot_desc.has_read_object_no_data_method && (@handles.lookup_exception(@pass_handle)).nil?)
            slot_desc.invoke_read_object_no_data(obj)
          end
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Skips over all block data and objects until TC_ENDBLOCKDATA is
    # encountered.
    def skip_custom_data
      old_handle = @pass_handle
      loop do
        if (@bin.get_block_data_mode)
          @bin.skip_block_data
          @bin.set_block_data_mode(false)
        end
        case (@bin.peek_byte)
        when TC_BLOCKDATA, TC_BLOCKDATALONG
          @bin.set_block_data_mode(true)
        when TC_ENDBLOCKDATA
          @bin.read_byte
          @pass_handle = old_handle
          return
        else
          read_object0(false)
        end
      end
    end
    
    typesig { [Object, ObjectStreamClass] }
    # Reads in values of serializable fields declared by given class
    # descriptor.  If obj is non-null, sets field values in obj.  Expects that
    # passHandle is set to obj's handle before this method is called.
    def default_read_fields(obj, desc)
      # REMIND: is isInstance check necessary?
      cl = desc.for_class
      if (!(cl).nil? && !(obj).nil? && !cl.is_instance(obj))
        raise ClassCastException.new
      end
      prim_data_size = desc.get_prim_data_size
      if ((@prim_vals).nil? || @prim_vals.attr_length < prim_data_size)
        @prim_vals = Array.typed(::Java::Byte).new(prim_data_size) { 0 }
      end
      @bin.read_fully(@prim_vals, 0, prim_data_size, false)
      if (!(obj).nil?)
        desc.set_prim_field_values(obj, @prim_vals)
      end
      obj_handle = @pass_handle
      fields = desc.get_fields(false)
      obj_vals = Array.typed(Object).new(desc.get_num_obj_fields) { nil }
      num_prim_fields = fields.attr_length - obj_vals.attr_length
      i = 0
      while i < obj_vals.attr_length
        f = fields[num_prim_fields + i]
        obj_vals[i] = read_object0(f.is_unshared)
        if (!(f.get_field).nil?)
          @handles.mark_dependency(obj_handle, @pass_handle)
        end
        i += 1
      end
      if (!(obj).nil?)
        desc.set_obj_field_values(obj, obj_vals)
      end
      @pass_handle = obj_handle
    end
    
    typesig { [] }
    # Reads in and returns IOException that caused serialization to abort.
    # All stream state is discarded prior to reading in fatal exception.  Sets
    # passHandle to fatal exception's handle.
    def read_fatal_exception
      if (!(@bin.read_byte).equal?(TC_EXCEPTION))
        raise InternalError.new
      end
      clear
      return read_object0(false)
    end
    
    typesig { [] }
    # If recursion depth is 0, clears internal data structures; otherwise,
    # throws a StreamCorruptedException.  This method is called when a
    # TC_RESET typecode is encountered.
    def handle_reset
      if (@depth > 0)
        raise StreamCorruptedException.new("unexpected reset; recursion depth: " + RJava.cast_to_string(@depth))
      end
      clear
    end
    
    class_module.module_eval {
      JNI.load_native_method :Java_java_io_ObjectInputStream_bytesToFloats, [:pointer, :long, :long, :int32, :long, :int32, :int32], :void
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
      # Converts specified span of bytes into float values.
      # 
      # REMIND: remove once hotspot inlines Float.intBitsToFloat
      def bytes_to_floats(src, srcpos, dst, dstpos, nfloats)
        JNI.call_native_method(:Java_java_io_ObjectInputStream_bytesToFloats, JNI.env, self.jni_id, src.jni_id, srcpos.to_int, dst.jni_id, dstpos.to_int, nfloats.to_int)
      end
      
      JNI.load_native_method :Java_java_io_ObjectInputStream_bytesToDoubles, [:pointer, :long, :long, :int32, :long, :int32, :int32], :void
      typesig { [Array.typed(::Java::Byte), ::Java::Int, Array.typed(::Java::Double), ::Java::Int, ::Java::Int] }
      # Converts specified span of bytes into double values.
      # 
      # REMIND: remove once hotspot inlines Double.longBitsToDouble
      def bytes_to_doubles(src, srcpos, dst, dstpos, ndoubles)
        JNI.call_native_method(:Java_java_io_ObjectInputStream_bytesToDoubles, JNI.env, self.jni_id, src.jni_id, srcpos.to_int, dst.jni_id, dstpos.to_int, ndoubles.to_int)
      end
      
      JNI.load_native_method :Java_java_io_ObjectInputStream_latestUserDefinedLoader, [:pointer, :long], :long
      typesig { [] }
      # Returns the first non-null class loader (not counting class loaders of
      # generated reflection implementation classes) up the execution stack, or
      # null if only code from the null class loader is on the stack.  This
      # method is also called via reflection by the following RMI-IIOP class:
      # 
      # com.sun.corba.se.internal.util.JDKClassLoader
      # 
      # This method should not be removed or its signature changed without
      # corresponding modifications to the above class.
      # 
      # REMIND: change name to something more accurate?
      def latest_user_defined_loader
        JNI.call_native_method(:Java_java_io_ObjectInputStream_latestUserDefinedLoader, JNI.env, self.jni_id)
      end
      
      # Default GetField implementation.
      const_set_lazy(:GetFieldImpl) { Class.new(GetField) do
        extend LocalClass
        include_class_members ObjectInputStream
        
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
        
        # object field value handles
        attr_accessor :obj_handles
        alias_method :attr_obj_handles, :obj_handles
        undef_method :obj_handles
        alias_method :attr_obj_handles=, :obj_handles=
        undef_method :obj_handles=
        
        typesig { [class_self::ObjectStreamClass] }
        # Creates GetFieldImpl object for reading fields defined in given
        # class descriptor.
        def initialize(desc)
          @desc = nil
          @prim_vals = nil
          @obj_vals = nil
          @obj_handles = nil
          super()
          @desc = desc
          @prim_vals = Array.typed(::Java::Byte).new(desc.get_prim_data_size) { 0 }
          @obj_vals = Array.typed(Object).new(desc.get_num_obj_fields) { nil }
          @obj_handles = Array.typed(::Java::Int).new(@obj_vals.attr_length) { 0 }
        end
        
        typesig { [] }
        def get_object_stream_class
          return @desc
        end
        
        typesig { [String] }
        def defaulted(name)
          return (get_field_offset(name, nil) < 0)
        end
        
        typesig { [String, ::Java::Boolean] }
        def get(name, val)
          off = get_field_offset(name, Boolean::TYPE)
          return (off >= 0) ? Bits.get_boolean(@prim_vals, off) : val
        end
        
        typesig { [String, ::Java::Byte] }
        def get(name, val)
          off = get_field_offset(name, Byte::TYPE)
          return (off >= 0) ? @prim_vals[off] : val
        end
        
        typesig { [String, ::Java::Char] }
        def get(name, val)
          off = get_field_offset(name, Character::TYPE)
          return (off >= 0) ? Bits.get_char(@prim_vals, off) : val
        end
        
        typesig { [String, ::Java::Short] }
        def get(name, val)
          off = get_field_offset(name, Short::TYPE)
          return (off >= 0) ? Bits.get_short(@prim_vals, off) : val
        end
        
        typesig { [String, ::Java::Int] }
        def get(name, val)
          off = get_field_offset(name, JavaInteger::TYPE)
          return (off >= 0) ? Bits.get_int(@prim_vals, off) : val
        end
        
        typesig { [String, ::Java::Float] }
        def get(name, val)
          off = get_field_offset(name, Float::TYPE)
          return (off >= 0) ? Bits.get_float(@prim_vals, off) : val
        end
        
        typesig { [String, ::Java::Long] }
        def get(name, val)
          off = get_field_offset(name, Long::TYPE)
          return (off >= 0) ? Bits.get_long(@prim_vals, off) : val
        end
        
        typesig { [String, ::Java::Double] }
        def get(name, val)
          off = get_field_offset(name, Double::TYPE)
          return (off >= 0) ? Bits.get_double(@prim_vals, off) : val
        end
        
        typesig { [String, Object] }
        def get(name, val)
          off = get_field_offset(name, Object)
          if (off >= 0)
            obj_handle = @obj_handles[off]
            self.attr_handles.mark_dependency(self.attr_pass_handle, obj_handle)
            return ((self.attr_handles.lookup_exception(obj_handle)).nil?) ? @obj_vals[off] : nil
          else
            return val
          end
        end
        
        typesig { [] }
        # Reads primitive and object field values from stream.
        def read_fields
          self.attr_bin.read_fully(@prim_vals, 0, @prim_vals.attr_length, false)
          old_handle = self.attr_pass_handle
          fields = @desc.get_fields(false)
          num_prim_fields = fields.attr_length - @obj_vals.attr_length
          i = 0
          while i < @obj_vals.attr_length
            @obj_vals[i] = read_object0(fields[num_prim_fields + i].is_unshared)
            @obj_handles[i] = self.attr_pass_handle
            i += 1
          end
          self.attr_pass_handle = old_handle
        end
        
        typesig { [String, class_self::Class] }
        # Returns offset of field with given name and type.  A specified type
        # of null matches all types, Object.class matches all non-primitive
        # types, and any other non-null type matches assignable types only.
        # If no matching field is found in the (incoming) class
        # descriptor but a matching field is present in the associated local
        # class descriptor, returns -1.  Throws IllegalArgumentException if
        # neither incoming nor local class descriptor contains a match.
        def get_field_offset(name, type)
          field = @desc.get_field(name, type)
          if (!(field).nil?)
            return field.get_offset
          else
            if (!(@desc.get_local_desc.get_field(name, type)).nil?)
              return -1
            else
              raise self.class::IllegalArgumentException.new("no such field " + name + " with type " + RJava.cast_to_string(type))
            end
          end
        end
        
        private
        alias_method :initialize__get_field_impl, :initialize
      end }
      
      # Prioritized list of callbacks to be performed once object graph has been
      # completely deserialized.
      const_set_lazy(:ValidationList) { Class.new do
        include_class_members ObjectInputStream
        
        class_module.module_eval {
          const_set_lazy(:Callback) { Class.new do
            include_class_members ValidationList
            
            attr_accessor :obj
            alias_method :attr_obj, :obj
            undef_method :obj
            alias_method :attr_obj=, :obj=
            undef_method :obj=
            
            attr_accessor :priority
            alias_method :attr_priority, :priority
            undef_method :priority
            alias_method :attr_priority=, :priority=
            undef_method :priority=
            
            attr_accessor :next
            alias_method :attr_next, :next
            undef_method :next
            alias_method :attr_next=, :next=
            undef_method :next=
            
            attr_accessor :acc
            alias_method :attr_acc, :acc
            undef_method :acc
            alias_method :attr_acc=, :acc=
            undef_method :acc=
            
            typesig { [class_self::ObjectInputValidation, ::Java::Int, class_self::Callback, class_self::AccessControlContext] }
            def initialize(obj, priority, next_, acc)
              @obj = nil
              @priority = 0
              @next = nil
              @acc = nil
              @obj = obj
              @priority = priority
              @next = next_
              @acc = acc
            end
            
            private
            alias_method :initialize__callback, :initialize
          end }
        }
        
        # linked list of callbacks
        attr_accessor :list
        alias_method :attr_list, :list
        undef_method :list
        alias_method :attr_list=, :list=
        undef_method :list=
        
        typesig { [] }
        # Creates new (empty) ValidationList.
        def initialize
          @list = nil
        end
        
        typesig { [class_self::ObjectInputValidation, ::Java::Int] }
        # Registers callback.  Throws InvalidObjectException if callback
        # object is null.
        def register(obj, priority)
          if ((obj).nil?)
            raise self.class::InvalidObjectException.new("null callback")
          end
          prev = nil
          cur = @list
          while (!(cur).nil? && priority < cur.attr_priority)
            prev = cur
            cur = cur.attr_next
          end
          acc = AccessController.get_context
          if (!(prev).nil?)
            prev.attr_next = self.class::Callback.new(obj, priority, cur, acc)
          else
            @list = self.class::Callback.new(obj, priority, @list, acc)
          end
        end
        
        typesig { [] }
        # Invokes all registered callbacks and clears the callback list.
        # Callbacks with higher priorities are called first; those with equal
        # priorities may be called in any order.  If any of the callbacks
        # throws an InvalidObjectException, the callback process is terminated
        # and the exception propagated upwards.
        def do_callbacks
          begin
            while (!(@list).nil?)
              AccessController.do_privileged(Class.new(self.class::PrivilegedExceptionAction.class == Class ? self.class::PrivilegedExceptionAction : Object) do
                extend LocalClass
                include_class_members ValidationList
                include class_self::PrivilegedExceptionAction if class_self::PrivilegedExceptionAction.class == Module
                
                typesig { [] }
                define_method :run do
                  self.attr_list.attr_obj.validate_object
                  return nil
                end
                
                typesig { [Vararg.new(Object)] }
                define_method :initialize do |*args|
                  super(*args)
                end
                
                private
                alias_method :initialize_anonymous, :initialize
              end.new_local(self), @list.attr_acc)
              @list = @list.attr_next
            end
          rescue self.class::PrivilegedActionException => ex
            @list = nil
            raise ex.get_exception
          end
        end
        
        typesig { [] }
        # Resets the callback list to its initial (empty) state.
        def clear
          @list = nil
        end
        
        private
        alias_method :initialize__validation_list, :initialize
      end }
      
      # Input stream supporting single-byte peek operations.
      const_set_lazy(:PeekInputStream) { Class.new(InputStream) do
        include_class_members ObjectInputStream
        
        # underlying stream
        attr_accessor :in
        alias_method :attr_in, :in
        undef_method :in
        alias_method :attr_in=, :in=
        undef_method :in=
        
        # peeked byte
        attr_accessor :peekb
        alias_method :attr_peekb, :peekb
        undef_method :peekb
        alias_method :attr_peekb=, :peekb=
        undef_method :peekb=
        
        typesig { [class_self::InputStream] }
        # Creates new PeekInputStream on top of given underlying stream.
        def initialize(in_)
          @in = nil
          @peekb = 0
          super()
          @peekb = -1
          @in = in_
        end
        
        typesig { [] }
        # Peeks at next byte value in stream.  Similar to read(), except
        # that it does not consume the read value.
        def peek
          return (@peekb >= 0) ? @peekb : (@peekb = @in.read)
        end
        
        typesig { [] }
        def read
          if (@peekb >= 0)
            v = @peekb
            @peekb = -1
            return v
          else
            return @in.read
          end
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, len)
          if ((len).equal?(0))
            return 0
          else
            if (@peekb < 0)
              return @in.read(b, off, len)
            else
              b[((off += 1) - 1)] = @peekb
              len -= 1
              @peekb = -1
              n = @in.read(b, off, len)
              return (n >= 0) ? (n + 1) : 1
            end
          end
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read_fully(b, off, len)
          n = 0
          while (n < len)
            count = read(b, off + n, len - n)
            if (count < 0)
              raise self.class::EOFException.new
            end
            n += count
          end
        end
        
        typesig { [::Java::Long] }
        def skip(n)
          if (n <= 0)
            return 0
          end
          skipped = 0
          if (@peekb >= 0)
            @peekb = -1
            skipped += 1
            n -= 1
          end
          return skipped + skip(n)
        end
        
        typesig { [] }
        def available
          return @in.available + ((@peekb >= 0) ? 1 : 0)
        end
        
        typesig { [] }
        def close
          @in.close
        end
        
        private
        alias_method :initialize__peek_input_stream, :initialize
      end }
      
      # Input stream with two modes: in default mode, inputs data written in the
      # same format as DataOutputStream; in "block data" mode, inputs data
      # bracketed by block data markers (see object serialization specification
      # for details).  Buffering depends on block data mode: when in default
      # mode, no data is buffered in advance; when in block data mode, all data
      # for the current data block is read in at once (and buffered).
      const_set_lazy(:BlockDataInputStream) { Class.new(InputStream) do
        extend LocalClass
        include_class_members ObjectInputStream
        overload_protected {
          include DataInput
        }
        
        class_module.module_eval {
          # maximum data block length
          const_set_lazy(:MAX_BLOCK_SIZE) { 1024 }
          const_attr_reader  :MAX_BLOCK_SIZE
          
          # maximum data block header length
          const_set_lazy(:MAX_HEADER_SIZE) { 5 }
          const_attr_reader  :MAX_HEADER_SIZE
          
          # (tunable) length of char buffer (for reading strings)
          const_set_lazy(:CHAR_BUF_SIZE) { 256 }
          const_attr_reader  :CHAR_BUF_SIZE
          
          # readBlockHeader() return value indicating header read may block
          const_set_lazy(:HEADER_BLOCKED) { -2 }
          const_attr_reader  :HEADER_BLOCKED
        }
        
        # buffer for reading general/block data
        attr_accessor :buf
        alias_method :attr_buf, :buf
        undef_method :buf
        alias_method :attr_buf=, :buf=
        undef_method :buf=
        
        # buffer for reading block data headers
        attr_accessor :hbuf
        alias_method :attr_hbuf, :hbuf
        undef_method :hbuf
        alias_method :attr_hbuf=, :hbuf=
        undef_method :hbuf=
        
        # char buffer for fast string reads
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
        
        # block data state fields; values meaningful only when blkmode true
        # current offset into buf
        attr_accessor :pos
        alias_method :attr_pos, :pos
        undef_method :pos
        alias_method :attr_pos=, :pos=
        undef_method :pos=
        
        # end offset of valid data in buf, or -1 if no more block data
        attr_accessor :end
        alias_method :attr_end, :end
        undef_method :end
        alias_method :attr_end=, :end=
        undef_method :end=
        
        # number of bytes in current block yet to be read from stream
        attr_accessor :unread
        alias_method :attr_unread, :unread
        undef_method :unread
        alias_method :attr_unread=, :unread=
        undef_method :unread=
        
        # underlying stream (wrapped in peekable filter stream)
        attr_accessor :in
        alias_method :attr_in, :in
        undef_method :in
        alias_method :attr_in=, :in=
        undef_method :in=
        
        # loopback stream (for data reads that span data blocks)
        attr_accessor :din
        alias_method :attr_din, :din
        undef_method :din
        alias_method :attr_din=, :din=
        undef_method :din=
        
        typesig { [class_self::InputStream] }
        # Creates new BlockDataInputStream on top of given underlying stream.
        # Block data mode is turned off by default.
        def initialize(in_)
          @buf = nil
          @hbuf = nil
          @cbuf = nil
          @blkmode = false
          @pos = 0
          @end = 0
          @unread = 0
          @in = nil
          @din = nil
          super()
          @buf = Array.typed(::Java::Byte).new(self.class::MAX_BLOCK_SIZE) { 0 }
          @hbuf = Array.typed(::Java::Byte).new(self.class::MAX_HEADER_SIZE) { 0 }
          @cbuf = CharArray.new(self.class::CHAR_BUF_SIZE)
          @blkmode = false
          @pos = 0
          @end = -1
          @unread = 0
          @in = self.class::PeekInputStream.new(in_)
          @din = self.class::DataInputStream.new(self)
        end
        
        typesig { [::Java::Boolean] }
        # Sets block data mode to the given mode (true == on, false == off)
        # and returns the previous mode value.  If the new mode is the same as
        # the old mode, no action is taken.  Throws IllegalStateException if
        # block data mode is being switched from on to off while unconsumed
        # block data is still present in the stream.
        def set_block_data_mode(newmode)
          if ((@blkmode).equal?(newmode))
            return @blkmode
          end
          if (newmode)
            @pos = 0
            @end = 0
            @unread = 0
          else
            if (@pos < @end)
              raise self.class::IllegalStateException.new("unread block data")
            end
          end
          @blkmode = newmode
          return !@blkmode
        end
        
        typesig { [] }
        # Returns true if the stream is currently in block data mode, false
        # otherwise.
        def get_block_data_mode
          return @blkmode
        end
        
        typesig { [] }
        # If in block data mode, skips to the end of the current group of data
        # blocks (but does not unset block data mode).  If not in block data
        # mode, throws an IllegalStateException.
        def skip_block_data
          if (!@blkmode)
            raise self.class::IllegalStateException.new("not in block data mode")
          end
          while (@end >= 0)
            refill
          end
        end
        
        typesig { [::Java::Boolean] }
        # Attempts to read in the next block data header (if any).  If
        # canBlock is false and a full header cannot be read without possibly
        # blocking, returns HEADER_BLOCKED, else if the next element in the
        # stream is a block data header, returns the block data length
        # specified by the header, else returns -1.
        def read_block_header(can_block)
          if (self.attr_default_data_end)
            # Fix for 4360508: stream is currently at the end of a field
            # value block written via default serialization; since there
            # is no terminating TC_ENDBLOCKDATA tag, simulate
            # end-of-custom-data behavior explicitly.
            return -1
          end
          begin
            loop do
              avail = can_block ? JavaInteger::MAX_VALUE : @in.available
              if ((avail).equal?(0))
                return self.class::HEADER_BLOCKED
              end
              tc = @in.peek
              case (tc)
              # TC_RESETs may occur in between data blocks.
              # Unfortunately, this case must be parsed at a lower
              # level than other typecodes, since primitive data
              # reads may span data blocks separated by a TC_RESET.
              when TC_BLOCKDATA
                if (avail < 2)
                  return self.class::HEADER_BLOCKED
                end
                @in.read_fully(@hbuf, 0, 2)
                return @hbuf[1] & 0xff
              when TC_BLOCKDATALONG
                if (avail < 5)
                  return self.class::HEADER_BLOCKED
                end
                @in.read_fully(@hbuf, 0, 5)
                len = Bits.get_int(@hbuf, 1)
                if (len < 0)
                  raise self.class::StreamCorruptedException.new("illegal block data header length: " + RJava.cast_to_string(len))
                end
                return len
              when TC_RESET
                @in.read
                handle_reset
              else
                if (tc >= 0 && (tc < TC_BASE || tc > TC_MAX))
                  raise self.class::StreamCorruptedException.new(String.format("invalid type code: %02X", tc))
                end
                return -1
              end
            end
          rescue self.class::EOFException => ex
            raise self.class::StreamCorruptedException.new("unexpected EOF while reading block data header")
          end
        end
        
        typesig { [] }
        # Refills internal buffer buf with block data.  Any data in buf at the
        # time of the call is considered consumed.  Sets the pos, end, and
        # unread fields to reflect the new amount of available block data; if
        # the next element in the stream is not a data block, sets pos and
        # unread to 0 and end to -1.
        def refill
          begin
            begin
              @pos = 0
              if (@unread > 0)
                n = @in.read(@buf, 0, Math.min(@unread, self.class::MAX_BLOCK_SIZE))
                if (n >= 0)
                  @end = n
                  @unread -= n
                else
                  raise self.class::StreamCorruptedException.new("unexpected EOF in middle of data block")
                end
              else
                n = read_block_header(true)
                if (n >= 0)
                  @end = 0
                  @unread = n
                else
                  @end = -1
                  @unread = 0
                end
              end
            end while ((@pos).equal?(@end))
          rescue self.class::IOException => ex
            @pos = 0
            @end = -1
            @unread = 0
            raise ex
          end
        end
        
        typesig { [] }
        # If in block data mode, returns the number of unconsumed bytes
        # remaining in the current data block.  If not in block data mode,
        # throws an IllegalStateException.
        def current_block_remaining
          if (@blkmode)
            return (@end >= 0) ? (@end - @pos) + @unread : 0
          else
            raise self.class::IllegalStateException.new
          end
        end
        
        typesig { [] }
        # Peeks at (but does not consume) and returns the next byte value in
        # the stream, or -1 if the end of the stream/block data (if in block
        # data mode) has been reached.
        def peek
          if (@blkmode)
            if ((@pos).equal?(@end))
              refill
            end
            return (@end >= 0) ? (@buf[@pos] & 0xff) : -1
          else
            return @in.peek
          end
        end
        
        typesig { [] }
        # Peeks at (but does not consume) and returns the next byte value in
        # the stream, or throws EOFException if end of stream/block data has
        # been reached.
        def peek_byte
          val = peek
          if (val < 0)
            raise self.class::EOFException.new
          end
          return val
        end
        
        typesig { [] }
        # ----------------- generic input stream methods ------------------
        # 
        # The following methods are equivalent to their counterparts in
        # InputStream, except that they interpret data block boundaries and
        # read the requested data from within data blocks when in block data
        # mode.
        def read
          if (@blkmode)
            if ((@pos).equal?(@end))
              refill
            end
            return (@end >= 0) ? (@buf[((@pos += 1) - 1)] & 0xff) : -1
          else
            return @in.read
          end
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read(b, off, len)
          return read(b, off, len, false)
        end
        
        typesig { [::Java::Long] }
        def skip(len)
          remain = len
          while (remain > 0)
            if (@blkmode)
              if ((@pos).equal?(@end))
                refill
              end
              if (@end < 0)
                break
              end
              nread = RJava.cast_to_int(Math.min(remain, @end - @pos))
              remain -= nread
              @pos += nread
            else
              nread = RJava.cast_to_int(Math.min(remain, self.class::MAX_BLOCK_SIZE))
              if ((nread = @in.read(@buf, 0, nread)) < 0)
                break
              end
              remain -= nread
            end
          end
          return len - remain
        end
        
        typesig { [] }
        def available
          if (@blkmode)
            if (((@pos).equal?(@end)) && ((@unread).equal?(0)))
              n = 0
              while (((n = read_block_header(false))).equal?(0))
              end
              case (n)
              when self.class::HEADER_BLOCKED
              when -1
                @pos = 0
                @end = -1
              else
                @pos = 0
                @end = 0
                @unread = n
              end
            end
            # avoid unnecessary call to in.available() if possible
            unread_avail = (@unread > 0) ? Math.min(@in.available, @unread) : 0
            return (@end >= 0) ? (@end - @pos) + unread_avail : 0
          else
            return @in.available
          end
        end
        
        typesig { [] }
        def close
          if (@blkmode)
            @pos = 0
            @end = -1
            @unread = 0
          end
          @in.close
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Boolean] }
        # Attempts to read len bytes into byte array b at offset off.  Returns
        # the number of bytes read, or -1 if the end of stream/block data has
        # been reached.  If copy is true, reads values into an intermediate
        # buffer before copying them to b (to avoid exposing a reference to
        # b).
        def read(b, off, len, copy)
          if ((len).equal?(0))
            return 0
          else
            if (@blkmode)
              if ((@pos).equal?(@end))
                refill
              end
              if (@end < 0)
                return -1
              end
              nread = Math.min(len, @end - @pos)
              System.arraycopy(@buf, @pos, b, off, nread)
              @pos += nread
              return nread
            else
              if (copy)
                nread = @in.read(@buf, 0, Math.min(len, self.class::MAX_BLOCK_SIZE))
                if (nread > 0)
                  System.arraycopy(@buf, 0, b, off, nread)
                end
                return nread
              else
                return @in.read(b, off, len)
              end
            end
          end
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        # ----------------- primitive data input methods ------------------
        # 
        # The following methods are equivalent to their counterparts in
        # DataInputStream, except that they interpret data block boundaries
        # and read the requested data from within data blocks when in block
        # data mode.
        def read_fully(b)
          read_fully(b, 0, b.attr_length, false)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def read_fully(b, off, len)
          read_fully(b, off, len, false)
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int, ::Java::Boolean] }
        def read_fully(b, off, len, copy)
          while (len > 0)
            n = read(b, off, len, copy)
            if (n < 0)
              raise self.class::EOFException.new
            end
            off += n
            len -= n
          end
        end
        
        typesig { [::Java::Int] }
        def skip_bytes(n)
          return @din.skip_bytes(n)
        end
        
        typesig { [] }
        def read_boolean
          v = read
          if (v < 0)
            raise self.class::EOFException.new
          end
          return (!(v).equal?(0))
        end
        
        typesig { [] }
        def read_byte
          v = read
          if (v < 0)
            raise self.class::EOFException.new
          end
          return v
        end
        
        typesig { [] }
        def read_unsigned_byte
          v = read
          if (v < 0)
            raise self.class::EOFException.new
          end
          return v
        end
        
        typesig { [] }
        def read_char
          if (!@blkmode)
            @pos = 0
            @in.read_fully(@buf, 0, 2)
          else
            if (@end - @pos < 2)
              return @din.read_char
            end
          end
          v = Bits.get_char(@buf, @pos)
          @pos += 2
          return v
        end
        
        typesig { [] }
        def read_short
          if (!@blkmode)
            @pos = 0
            @in.read_fully(@buf, 0, 2)
          else
            if (@end - @pos < 2)
              return @din.read_short
            end
          end
          v = Bits.get_short(@buf, @pos)
          @pos += 2
          return v
        end
        
        typesig { [] }
        def read_unsigned_short
          if (!@blkmode)
            @pos = 0
            @in.read_fully(@buf, 0, 2)
          else
            if (@end - @pos < 2)
              return @din.read_unsigned_short
            end
          end
          v = Bits.get_short(@buf, @pos) & 0xffff
          @pos += 2
          return v
        end
        
        typesig { [] }
        def read_int
          if (!@blkmode)
            @pos = 0
            @in.read_fully(@buf, 0, 4)
          else
            if (@end - @pos < 4)
              return @din.read_int
            end
          end
          v = Bits.get_int(@buf, @pos)
          @pos += 4
          return v
        end
        
        typesig { [] }
        def read_float
          if (!@blkmode)
            @pos = 0
            @in.read_fully(@buf, 0, 4)
          else
            if (@end - @pos < 4)
              return @din.read_float
            end
          end
          v = Bits.get_float(@buf, @pos)
          @pos += 4
          return v
        end
        
        typesig { [] }
        def read_long
          if (!@blkmode)
            @pos = 0
            @in.read_fully(@buf, 0, 8)
          else
            if (@end - @pos < 8)
              return @din.read_long
            end
          end
          v = Bits.get_long(@buf, @pos)
          @pos += 8
          return v
        end
        
        typesig { [] }
        def read_double
          if (!@blkmode)
            @pos = 0
            @in.read_fully(@buf, 0, 8)
          else
            if (@end - @pos < 8)
              return @din.read_double
            end
          end
          v = Bits.get_double(@buf, @pos)
          @pos += 8
          return v
        end
        
        typesig { [] }
        def read_utf
          return read_utfbody(read_unsigned_short)
        end
        
        typesig { [] }
        def read_line
          return @din.read_line # deprecated, not worth optimizing
        end
        
        typesig { [Array.typed(::Java::Boolean), ::Java::Int, ::Java::Int] }
        # -------------- primitive data array input methods ---------------
        # 
        # The following methods read in spans of primitive data values.
        # Though equivalent to calling the corresponding primitive read
        # methods repeatedly, these methods are optimized for reading groups
        # of primitive data values more efficiently.
        def read_booleans(v, off, len)
          stop = 0
          endoff = off + len
          while (off < endoff)
            if (!@blkmode)
              span = Math.min(endoff - off, self.class::MAX_BLOCK_SIZE)
              @in.read_fully(@buf, 0, span)
              stop = off + span
              @pos = 0
            else
              if (@end - @pos < 1)
                v[((off += 1) - 1)] = @din.read_boolean
                next
              else
                stop = Math.min(endoff, off + @end - @pos)
              end
            end
            while (off < stop)
              v[((off += 1) - 1)] = Bits.get_boolean(@buf, ((@pos += 1) - 1))
            end
          end
        end
        
        typesig { [Array.typed(::Java::Char), ::Java::Int, ::Java::Int] }
        def read_chars(v, off, len)
          stop = 0
          endoff = off + len
          while (off < endoff)
            if (!@blkmode)
              span = Math.min(endoff - off, self.class::MAX_BLOCK_SIZE >> 1)
              @in.read_fully(@buf, 0, span << 1)
              stop = off + span
              @pos = 0
            else
              if (@end - @pos < 2)
                v[((off += 1) - 1)] = @din.read_char
                next
              else
                stop = Math.min(endoff, off + ((@end - @pos) >> 1))
              end
            end
            while (off < stop)
              v[((off += 1) - 1)] = Bits.get_char(@buf, @pos)
              @pos += 2
            end
          end
        end
        
        typesig { [Array.typed(::Java::Short), ::Java::Int, ::Java::Int] }
        def read_shorts(v, off, len)
          stop = 0
          endoff = off + len
          while (off < endoff)
            if (!@blkmode)
              span = Math.min(endoff - off, self.class::MAX_BLOCK_SIZE >> 1)
              @in.read_fully(@buf, 0, span << 1)
              stop = off + span
              @pos = 0
            else
              if (@end - @pos < 2)
                v[((off += 1) - 1)] = @din.read_short
                next
              else
                stop = Math.min(endoff, off + ((@end - @pos) >> 1))
              end
            end
            while (off < stop)
              v[((off += 1) - 1)] = Bits.get_short(@buf, @pos)
              @pos += 2
            end
          end
        end
        
        typesig { [Array.typed(::Java::Int), ::Java::Int, ::Java::Int] }
        def read_ints(v, off, len)
          stop = 0
          endoff = off + len
          while (off < endoff)
            if (!@blkmode)
              span = Math.min(endoff - off, self.class::MAX_BLOCK_SIZE >> 2)
              @in.read_fully(@buf, 0, span << 2)
              stop = off + span
              @pos = 0
            else
              if (@end - @pos < 4)
                v[((off += 1) - 1)] = @din.read_int
                next
              else
                stop = Math.min(endoff, off + ((@end - @pos) >> 2))
              end
            end
            while (off < stop)
              v[((off += 1) - 1)] = Bits.get_int(@buf, @pos)
              @pos += 4
            end
          end
        end
        
        typesig { [Array.typed(::Java::Float), ::Java::Int, ::Java::Int] }
        def read_floats(v, off, len)
          span = 0
          endoff = off + len
          while (off < endoff)
            if (!@blkmode)
              span = Math.min(endoff - off, self.class::MAX_BLOCK_SIZE >> 2)
              @in.read_fully(@buf, 0, span << 2)
              @pos = 0
            else
              if (@end - @pos < 4)
                v[((off += 1) - 1)] = @din.read_float
                next
              else
                span = Math.min(endoff - off, ((@end - @pos) >> 2))
              end
            end
            bytes_to_floats(@buf, @pos, v, off, span)
            off += span
            @pos += span << 2
          end
        end
        
        typesig { [Array.typed(::Java::Long), ::Java::Int, ::Java::Int] }
        def read_longs(v, off, len)
          stop = 0
          endoff = off + len
          while (off < endoff)
            if (!@blkmode)
              span = Math.min(endoff - off, self.class::MAX_BLOCK_SIZE >> 3)
              @in.read_fully(@buf, 0, span << 3)
              stop = off + span
              @pos = 0
            else
              if (@end - @pos < 8)
                v[((off += 1) - 1)] = @din.read_long
                next
              else
                stop = Math.min(endoff, off + ((@end - @pos) >> 3))
              end
            end
            while (off < stop)
              v[((off += 1) - 1)] = Bits.get_long(@buf, @pos)
              @pos += 8
            end
          end
        end
        
        typesig { [Array.typed(::Java::Double), ::Java::Int, ::Java::Int] }
        def read_doubles(v, off, len)
          span = 0
          endoff = off + len
          while (off < endoff)
            if (!@blkmode)
              span = Math.min(endoff - off, self.class::MAX_BLOCK_SIZE >> 3)
              @in.read_fully(@buf, 0, span << 3)
              @pos = 0
            else
              if (@end - @pos < 8)
                v[((off += 1) - 1)] = @din.read_double
                next
              else
                span = Math.min(endoff - off, ((@end - @pos) >> 3))
              end
            end
            bytes_to_doubles(@buf, @pos, v, off, span)
            off += span
            @pos += span << 3
          end
        end
        
        typesig { [] }
        # Reads in string written in "long" UTF format.  "Long" UTF format is
        # identical to standard UTF, except that it uses an 8 byte header
        # (instead of the standard 2 bytes) to convey the UTF encoding length.
        def read_long_utf
          return read_utfbody(read_long)
        end
        
        typesig { [::Java::Long] }
        # Reads in the "body" (i.e., the UTF representation minus the 2-byte
        # or 8-byte length header) of a UTF encoding, which occupies the next
        # utflen bytes.
        def read_utfbody(utflen)
          sbuf = self.class::StringBuilder.new
          if (!@blkmode)
            @end = @pos = 0
          end
          while (utflen > 0)
            avail = @end - @pos
            if (avail >= 3 || (avail).equal?(utflen))
              utflen -= read_utfspan(sbuf, utflen)
            else
              if (@blkmode)
                # near block boundary, read one byte at a time
                utflen -= read_utfchar(sbuf, utflen)
              else
                # shift and refill buffer manually
                if (avail > 0)
                  System.arraycopy(@buf, @pos, @buf, 0, avail)
                end
                @pos = 0
                @end = RJava.cast_to_int(Math.min(self.class::MAX_BLOCK_SIZE, utflen))
                @in.read_fully(@buf, avail, @end - avail)
              end
            end
          end
          return sbuf.to_s
        end
        
        typesig { [class_self::StringBuilder, ::Java::Long] }
        # Reads span of UTF-encoded characters out of internal buffer
        # (starting at offset pos and ending at or before offset end),
        # consuming no more than utflen bytes.  Appends read characters to
        # sbuf.  Returns the number of bytes consumed.
        def read_utfspan(sbuf, utflen)
          cpos = 0
          start = @pos
          avail = Math.min(@end - @pos, self.class::CHAR_BUF_SIZE)
          # stop short of last char unless all of utf bytes in buffer
          stop = @pos + ((utflen > avail) ? avail - 2 : RJava.cast_to_int(utflen))
          out_of_bounds = false
          begin
            while (@pos < stop)
              b1 = 0
              b2 = 0
              b3 = 0
              b1 = @buf[((@pos += 1) - 1)] & 0xff
              case (b1 >> 4)
              when 0, 1, 2, 3, 4, 5, 6, 7
                # 1 byte format: 0xxxxxxx
                @cbuf[((cpos += 1) - 1)] = RJava.cast_to_char(b1)
              when 12, 13
                # 2 byte format: 110xxxxx 10xxxxxx
                b2 = @buf[((@pos += 1) - 1)]
                if (!((b2 & 0xc0)).equal?(0x80))
                  raise self.class::UTFDataFormatException.new
                end
                @cbuf[((cpos += 1) - 1)] = RJava.cast_to_char((((b1 & 0x1f) << 6) | ((b2 & 0x3f) << 0)))
              when 14
                # 3 byte format: 1110xxxx 10xxxxxx 10xxxxxx
                b3 = @buf[@pos + 1]
                b2 = @buf[@pos + 0]
                @pos += 2
                if (!((b2 & 0xc0)).equal?(0x80) || !((b3 & 0xc0)).equal?(0x80))
                  raise self.class::UTFDataFormatException.new
                end
                @cbuf[((cpos += 1) - 1)] = RJava.cast_to_char((((b1 & 0xf) << 12) | ((b2 & 0x3f) << 6) | ((b3 & 0x3f) << 0)))
              else
                # 10xx xxxx, 1111 xxxx
                raise self.class::UTFDataFormatException.new
              end
            end
          rescue self.class::ArrayIndexOutOfBoundsException => ex
            out_of_bounds = true
          ensure
            if (out_of_bounds || (@pos - start) > utflen)
              # Fix for 4450867: if a malformed utf char causes the
              # conversion loop to scan past the expected end of the utf
              # string, only consume the expected number of utf bytes.
              @pos = start + RJava.cast_to_int(utflen)
              raise self.class::UTFDataFormatException.new
            end
          end
          sbuf.append(@cbuf, 0, cpos)
          return @pos - start
        end
        
        typesig { [class_self::StringBuilder, ::Java::Long] }
        # Reads in single UTF-encoded character one byte at a time, appends
        # the character to sbuf, and returns the number of bytes consumed.
        # This method is used when reading in UTF strings written in block
        # data mode to handle UTF-encoded characters which (potentially)
        # straddle block-data boundaries.
        def read_utfchar(sbuf, utflen)
          b1 = 0
          b2 = 0
          b3 = 0
          b1 = read_byte & 0xff
          case (b1 >> 4)
          when 0, 1, 2, 3, 4, 5, 6, 7
            # 1 byte format: 0xxxxxxx
            sbuf.append(RJava.cast_to_char(b1))
            return 1
          when 12, 13
            # 2 byte format: 110xxxxx 10xxxxxx
            if (utflen < 2)
              raise self.class::UTFDataFormatException.new
            end
            b2 = read_byte
            if (!((b2 & 0xc0)).equal?(0x80))
              raise self.class::UTFDataFormatException.new
            end
            sbuf.append(RJava.cast_to_char((((b1 & 0x1f) << 6) | ((b2 & 0x3f) << 0))))
            return 2
          when 14
            # 3 byte format: 1110xxxx 10xxxxxx 10xxxxxx
            if (utflen < 3)
              if ((utflen).equal?(2))
                read_byte # consume remaining byte
              end
              raise self.class::UTFDataFormatException.new
            end
            b2 = read_byte
            b3 = read_byte
            if (!((b2 & 0xc0)).equal?(0x80) || !((b3 & 0xc0)).equal?(0x80))
              raise self.class::UTFDataFormatException.new
            end
            sbuf.append(RJava.cast_to_char((((b1 & 0xf) << 12) | ((b2 & 0x3f) << 6) | ((b3 & 0x3f) << 0))))
            return 3
          else
            # 10xx xxxx, 1111 xxxx
            raise self.class::UTFDataFormatException.new
          end
        end
        
        private
        alias_method :initialize__block_data_input_stream, :initialize
      end }
      
      # Unsynchronized table which tracks wire handle to object mappings, as
      # well as ClassNotFoundExceptions associated with deserialized objects.
      # This class implements an exception-propagation algorithm for
      # determining which objects should have ClassNotFoundExceptions associated
      # with them, taking into account cycles and discontinuities (e.g., skipped
      # fields) in the object graph.
      # 
      # <p>General use of the table is as follows: during deserialization, a
      # given object is first assigned a handle by calling the assign method.
      # This method leaves the assigned handle in an "open" state, wherein
      # dependencies on the exception status of other handles can be registered
      # by calling the markDependency method, or an exception can be directly
      # associated with the handle by calling markException.  When a handle is
      # tagged with an exception, the HandleTable assumes responsibility for
      # propagating the exception to any other objects which depend
      # (transitively) on the exception-tagged object.
      # 
      # <p>Once all exception information/dependencies for the handle have been
      # registered, the handle should be "closed" by calling the finish method
      # on it.  The act of finishing a handle allows the exception propagation
      # algorithm to aggressively prune dependency links, lessening the
      # performance/memory impact of exception tracking.
      # 
      # <p>Note that the exception propagation algorithm used depends on handles
      # being assigned/finished in LIFO order; however, for simplicity as well
      # as memory conservation, it does not enforce this constraint.
      # 
      # REMIND: add full description of exception propagation algorithm?
      const_set_lazy(:HandleTable) { Class.new do
        include_class_members ObjectInputStream
        
        class_module.module_eval {
          # status codes indicating whether object has associated exception
          const_set_lazy(:STATUS_OK) { 1 }
          const_attr_reader  :STATUS_OK
          
          const_set_lazy(:STATUS_UNKNOWN) { 2 }
          const_attr_reader  :STATUS_UNKNOWN
          
          const_set_lazy(:STATUS_EXCEPTION) { 3 }
          const_attr_reader  :STATUS_EXCEPTION
        }
        
        # array mapping handle -> object status
        attr_accessor :status
        alias_method :attr_status, :status
        undef_method :status
        alias_method :attr_status=, :status=
        undef_method :status=
        
        # array mapping handle -> object/exception (depending on status)
        attr_accessor :entries
        alias_method :attr_entries, :entries
        undef_method :entries
        alias_method :attr_entries=, :entries=
        undef_method :entries=
        
        # array mapping handle -> list of dependent handles (if any)
        attr_accessor :deps
        alias_method :attr_deps, :deps
        undef_method :deps
        alias_method :attr_deps=, :deps=
        undef_method :deps=
        
        # lowest unresolved dependency
        attr_accessor :low_dep
        alias_method :attr_low_dep, :low_dep
        undef_method :low_dep
        alias_method :attr_low_dep=, :low_dep=
        undef_method :low_dep=
        
        # number of handles in table
        attr_accessor :size
        alias_method :attr_size, :size
        undef_method :size
        alias_method :attr_size=, :size=
        undef_method :size=
        
        typesig { [::Java::Int] }
        # Creates handle table with the given initial capacity.
        def initialize(initial_capacity)
          @status = nil
          @entries = nil
          @deps = nil
          @low_dep = -1
          @size = 0
          @status = Array.typed(::Java::Byte).new(initial_capacity) { 0 }
          @entries = Array.typed(Object).new(initial_capacity) { nil }
          @deps = Array.typed(self.class::HandleList).new(initial_capacity) { nil }
        end
        
        typesig { [Object] }
        # Assigns next available handle to given object, and returns assigned
        # handle.  Once object has been completely deserialized (and all
        # dependencies on other objects identified), the handle should be
        # "closed" by passing it to finish().
        def assign(obj)
          if (@size >= @entries.attr_length)
            grow
          end
          @status[@size] = self.class::STATUS_UNKNOWN
          @entries[@size] = obj
          return ((@size += 1) - 1)
        end
        
        typesig { [::Java::Int, ::Java::Int] }
        # Registers a dependency (in exception status) of one handle on
        # another.  The dependent handle must be "open" (i.e., assigned, but
        # not finished yet).  No action is taken if either dependent or target
        # handle is NULL_HANDLE.
        def mark_dependency(dependent, target)
          if ((dependent).equal?(NULL_HANDLE) || (target).equal?(NULL_HANDLE))
            return
          end
          case (@status[dependent])
          when self.class::STATUS_UNKNOWN
            case (@status[target])
            when self.class::STATUS_OK
              # ignore dependencies on objs with no exception
            when self.class::STATUS_EXCEPTION
              # eagerly propagate exception
              mark_exception(dependent, @entries[target])
            when self.class::STATUS_UNKNOWN
              # add to dependency list of target
              if ((@deps[target]).nil?)
                @deps[target] = self.class::HandleList.new
              end
              @deps[target].add(dependent)
              # remember lowest unresolved target seen
              if (@low_dep < 0 || @low_dep > target)
                @low_dep = target
              end
            else
              raise self.class::InternalError.new
            end
          when self.class::STATUS_EXCEPTION
          else
            raise self.class::InternalError.new
          end
        end
        
        typesig { [::Java::Int, class_self::ClassNotFoundException] }
        # Associates a ClassNotFoundException (if one not already associated)
        # with the currently active handle and propagates it to other
        # referencing objects as appropriate.  The specified handle must be
        # "open" (i.e., assigned, but not finished yet).
        def mark_exception(handle, ex)
          case (@status[handle])
          when self.class::STATUS_UNKNOWN
            @status[handle] = self.class::STATUS_EXCEPTION
            @entries[handle] = ex
            # propagate exception to dependents
            dlist = @deps[handle]
            if (!(dlist).nil?)
              ndeps = dlist.size
              i = 0
              while i < ndeps
                mark_exception(dlist.get(i), ex)
                i += 1
              end
              @deps[handle] = nil
            end
          when self.class::STATUS_EXCEPTION
          else
            raise self.class::InternalError.new
          end
        end
        
        typesig { [::Java::Int] }
        # Marks given handle as finished, meaning that no new dependencies
        # will be marked for handle.  Calls to the assign and finish methods
        # must occur in LIFO order.
        def finish(handle)
          end_ = 0
          if (@low_dep < 0)
            # no pending unknowns, only resolve current handle
            end_ = handle + 1
          else
            if (@low_dep >= handle)
              # pending unknowns now clearable, resolve all upward handles
              end_ = @size
              @low_dep = -1
            else
              # unresolved backrefs present, can't resolve anything yet
              return
            end
          end
          # change STATUS_UNKNOWN -> STATUS_OK in selected span of handles
          i = handle
          while i < end_
            case (@status[i])
            when self.class::STATUS_UNKNOWN
              @status[i] = self.class::STATUS_OK
              @deps[i] = nil
            when self.class::STATUS_OK, self.class::STATUS_EXCEPTION
            else
              raise self.class::InternalError.new
            end
            i += 1
          end
        end
        
        typesig { [::Java::Int, Object] }
        # Assigns a new object to the given handle.  The object previously
        # associated with the handle is forgotten.  This method has no effect
        # if the given handle already has an exception associated with it.
        # This method may be called at any time after the handle is assigned.
        def set_object(handle, obj)
          case (@status[handle])
          when self.class::STATUS_UNKNOWN, self.class::STATUS_OK
            @entries[handle] = obj
          when self.class::STATUS_EXCEPTION
          else
            raise self.class::InternalError.new
          end
        end
        
        typesig { [::Java::Int] }
        # Looks up and returns object associated with the given handle.
        # Returns null if the given handle is NULL_HANDLE, or if it has an
        # associated ClassNotFoundException.
        def lookup_object(handle)
          return (!(handle).equal?(NULL_HANDLE) && !(@status[handle]).equal?(self.class::STATUS_EXCEPTION)) ? @entries[handle] : nil
        end
        
        typesig { [::Java::Int] }
        # Looks up and returns ClassNotFoundException associated with the
        # given handle.  Returns null if the given handle is NULL_HANDLE, or
        # if there is no ClassNotFoundException associated with the handle.
        def lookup_exception(handle)
          return (!(handle).equal?(NULL_HANDLE) && (@status[handle]).equal?(self.class::STATUS_EXCEPTION)) ? @entries[handle] : nil
        end
        
        typesig { [] }
        # Resets table to its initial state.
        def clear
          Arrays.fill(@status, 0, @size, 0)
          Arrays.fill(@entries, 0, @size, nil)
          Arrays.fill(@deps, 0, @size, nil)
          @low_dep = -1
          @size = 0
        end
        
        typesig { [] }
        # Returns number of handles registered in table.
        def size
          return @size
        end
        
        typesig { [] }
        # Expands capacity of internal arrays.
        def grow
          new_capacity = (@entries.attr_length << 1) + 1
          new_status = Array.typed(::Java::Byte).new(new_capacity) { 0 }
          new_entries = Array.typed(Object).new(new_capacity) { nil }
          new_deps = Array.typed(self.class::HandleList).new(new_capacity) { nil }
          System.arraycopy(@status, 0, new_status, 0, @size)
          System.arraycopy(@entries, 0, new_entries, 0, @size)
          System.arraycopy(@deps, 0, new_deps, 0, @size)
          @status = new_status
          @entries = new_entries
          @deps = new_deps
        end
        
        class_module.module_eval {
          # Simple growable list of (integer) handles.
          const_set_lazy(:HandleList) { Class.new do
            include_class_members HandleTable
            
            attr_accessor :list
            alias_method :attr_list, :list
            undef_method :list
            alias_method :attr_list=, :list=
            undef_method :list=
            
            attr_accessor :size
            alias_method :attr_size, :size
            undef_method :size
            alias_method :attr_size=, :size=
            undef_method :size=
            
            typesig { [] }
            def initialize
              @list = Array.typed(::Java::Int).new(4) { 0 }
              @size = 0
            end
            
            typesig { [::Java::Int] }
            def add(handle)
              if (@size >= @list.attr_length)
                new_list = Array.typed(::Java::Int).new(@list.attr_length << 1) { 0 }
                System.arraycopy(@list, 0, new_list, 0, @list.attr_length)
                @list = new_list
              end
              @list[((@size += 1) - 1)] = handle
            end
            
            typesig { [::Java::Int] }
            def get(index)
              if (index >= @size)
                raise self.class::ArrayIndexOutOfBoundsException.new
              end
              return @list[index]
            end
            
            typesig { [] }
            def size
              return @size
            end
            
            private
            alias_method :initialize__handle_list, :initialize
          end }
        }
        
        private
        alias_method :initialize__handle_table, :initialize
      end }
      
      typesig { [Object] }
      # Method for cloning arrays in case of using unsharing reading
      def clone_array(array)
        if (array.is_a?(Array.typed(Object)))
          return (array).clone
        else
          if (array.is_a?(Array.typed(::Java::Boolean)))
            return (array).clone
          else
            if (array.is_a?(Array.typed(::Java::Byte)))
              return (array).clone
            else
              if (array.is_a?(Array.typed(::Java::Char)))
                return (array).clone
              else
                if (array.is_a?(Array.typed(::Java::Double)))
                  return (array).clone
                else
                  if (array.is_a?(Array.typed(::Java::Float)))
                    return (array).clone
                  else
                    if (array.is_a?(Array.typed(::Java::Int)))
                      return (array).clone
                    else
                      if (array.is_a?(Array.typed(::Java::Long)))
                        return (array).clone
                      else
                        if (array.is_a?(Array.typed(::Java::Double)))
                          return (array).clone
                        else
                          raise AssertionError.new
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      
      # Context that during upcalls to class-defined readObject methods; holds
      # object currently being deserialized and descriptor for current class.
      # This context keeps a boolean state to indicate that defaultReadObject
      # or readFields has already been invoked with this context or the class's
      # readObject method has returned; if true, the getObj method throws
      # NotActiveException.
      const_set_lazy(:CallbackContext) { Class.new do
        include_class_members ObjectInputStream
        
        attr_accessor :obj
        alias_method :attr_obj, :obj
        undef_method :obj
        alias_method :attr_obj=, :obj=
        undef_method :obj=
        
        attr_accessor :desc
        alias_method :attr_desc, :desc
        undef_method :desc
        alias_method :attr_desc=, :desc=
        undef_method :desc=
        
        attr_accessor :used
        alias_method :attr_used, :used
        undef_method :used
        alias_method :attr_used=, :used=
        undef_method :used=
        
        typesig { [Object, class_self::ObjectStreamClass] }
        def initialize(obj, desc)
          @obj = nil
          @desc = nil
          @used = self.class::AtomicBoolean.new
          @obj = obj
          @desc = desc
        end
        
        typesig { [] }
        def get_obj
          check_and_set_used
          return @obj
        end
        
        typesig { [] }
        def get_desc
          return @desc
        end
        
        typesig { [] }
        def check_and_set_used
          if (!@used.compare_and_set(false, true))
            raise self.class::NotActiveException.new("not in readObject invocation or fields already read")
          end
        end
        
        typesig { [] }
        def set_used
          @used.set(true)
        end
        
        private
        alias_method :initialize__callback_context, :initialize
      end }
    }
    
    private
    alias_method :initialize__object_input_stream, :initialize
  end
  
end
