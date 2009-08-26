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
  module ObjectStreamClassImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
      include_const ::Java::Lang::Ref, :Reference
      include_const ::Java::Lang::Ref, :ReferenceQueue
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Lang::Ref, :WeakReference
      include_const ::Java::Lang::Reflect, :Constructor
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Java::Lang::Reflect, :Member
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Java::Lang::Reflect, :Proxy
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :MessageDigest
      include_const ::Java::Security, :NoSuchAlgorithmException
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :Arrays
      include_const ::Java::Util, :Collections
      include_const ::Java::Util, :Comparator
      include_const ::Java::Util, :HashSet
      include_const ::Java::Util, :JavaSet
      include_const ::Java::Util::Concurrent, :ConcurrentHashMap
      include_const ::Java::Util::Concurrent, :ConcurrentMap
      include_const ::Sun::Misc, :Unsafe
      include_const ::Sun::Reflect, :ReflectionFactory
    }
  end
  
  # Serialization's descriptor for classes.  It contains the name and
  # serialVersionUID of the class.  The ObjectStreamClass for a specific class
  # loaded in this Java VM can be found/created using the lookup method.
  # 
  # <p>The algorithm to compute the SerialVersionUID is described in
  # <a href="../../../platform/serialization/spec/class.html#4100">Object
  # Serialization Specification, Section 4.6, Stream Unique Identifiers</a>.
  # 
  # @author      Mike Warres
  # @author      Roger Riggs
  # @see ObjectStreamField
  # @see <a href="../../../platform/serialization/spec/class.html">Object Serialization Specification, Section 4, Class Descriptors</a>
  # @since   JDK1.1
  class ObjectStreamClass 
    include_class_members ObjectStreamClassImports
    include Serializable
    
    class_module.module_eval {
      # serialPersistentFields value indicating no serializable fields
      const_set_lazy(:NO_FIELDS) { Array.typed(ObjectStreamField).new(0) { nil } }
      const_attr_reader  :NO_FIELDS
      
      const_set_lazy(:SerialVersionUID) { -6120832682080437368 }
      const_attr_reader  :SerialVersionUID
      
      const_set_lazy(:SerialPersistentFields) { NO_FIELDS }
      const_attr_reader  :SerialPersistentFields
      
      # reflection factory for obtaining serialization constructors
      const_set_lazy(:ReflFactory) { AccessController.do_privileged(ReflectionFactory::GetReflectionFactoryAction.new) }
      const_attr_reader  :ReflFactory
      
      const_set_lazy(:Caches) { Class.new do
        include_class_members ObjectStreamClass
        
        class_module.module_eval {
          # cache mapping local classes -> descriptors
          const_set_lazy(:LocalDescs) { class_self::ConcurrentHashMap.new }
          const_attr_reader  :LocalDescs
          
          # cache mapping field group/local desc pairs -> field reflectors
          const_set_lazy(:Reflectors) { class_self::ConcurrentHashMap.new }
          const_attr_reader  :Reflectors
          
          # queue for WeakReferences to local classes
          const_set_lazy(:LocalDescsQueue) { class_self::ReferenceQueue.new }
          const_attr_reader  :LocalDescsQueue
          
          # queue for WeakReferences to field reflectors keys
          const_set_lazy(:ReflectorsQueue) { class_self::ReferenceQueue.new }
          const_attr_reader  :ReflectorsQueue
        }
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__caches, :initialize
      end }
    }
    
    # class associated with this descriptor (if any)
    attr_accessor :cl
    alias_method :attr_cl, :cl
    undef_method :cl
    alias_method :attr_cl=, :cl=
    undef_method :cl=
    
    # name of class represented by this descriptor
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # serialVersionUID of represented class (null if not computed yet)
    attr_accessor :suid
    alias_method :attr_suid, :suid
    undef_method :suid
    alias_method :attr_suid=, :suid=
    undef_method :suid=
    
    # true if represents dynamic proxy class
    attr_accessor :is_proxy
    alias_method :attr_is_proxy, :is_proxy
    undef_method :is_proxy
    alias_method :attr_is_proxy=, :is_proxy=
    undef_method :is_proxy=
    
    # true if represents enum type
    attr_accessor :is_enum
    alias_method :attr_is_enum, :is_enum
    undef_method :is_enum
    alias_method :attr_is_enum=, :is_enum=
    undef_method :is_enum=
    
    # true if represented class implements Serializable
    attr_accessor :serializable
    alias_method :attr_serializable, :serializable
    undef_method :serializable
    alias_method :attr_serializable=, :serializable=
    undef_method :serializable=
    
    # true if represented class implements Externalizable
    attr_accessor :externalizable
    alias_method :attr_externalizable, :externalizable
    undef_method :externalizable
    alias_method :attr_externalizable=, :externalizable=
    undef_method :externalizable=
    
    # true if desc has data written by class-defined writeObject method
    attr_accessor :has_write_object_data
    alias_method :attr_has_write_object_data, :has_write_object_data
    undef_method :has_write_object_data
    alias_method :attr_has_write_object_data=, :has_write_object_data=
    undef_method :has_write_object_data=
    
    # true if desc has externalizable data written in block data format; this
    # must be true by default to accommodate ObjectInputStream subclasses which
    # override readClassDescriptor() to return class descriptors obtained from
    # ObjectStreamClass.lookup() (see 4461737)
    attr_accessor :has_block_external_data
    alias_method :attr_has_block_external_data, :has_block_external_data
    undef_method :has_block_external_data
    alias_method :attr_has_block_external_data=, :has_block_external_data=
    undef_method :has_block_external_data=
    
    # exception (if any) thrown while attempting to resolve class
    attr_accessor :resolve_ex
    alias_method :attr_resolve_ex, :resolve_ex
    undef_method :resolve_ex
    alias_method :attr_resolve_ex=, :resolve_ex=
    undef_method :resolve_ex=
    
    # exception (if any) to throw if non-enum deserialization attempted
    attr_accessor :deserialize_ex
    alias_method :attr_deserialize_ex, :deserialize_ex
    undef_method :deserialize_ex
    alias_method :attr_deserialize_ex=, :deserialize_ex=
    undef_method :deserialize_ex=
    
    # exception (if any) to throw if non-enum serialization attempted
    attr_accessor :serialize_ex
    alias_method :attr_serialize_ex, :serialize_ex
    undef_method :serialize_ex
    alias_method :attr_serialize_ex=, :serialize_ex=
    undef_method :serialize_ex=
    
    # exception (if any) to throw if default serialization attempted
    attr_accessor :default_serialize_ex
    alias_method :attr_default_serialize_ex, :default_serialize_ex
    undef_method :default_serialize_ex
    alias_method :attr_default_serialize_ex=, :default_serialize_ex=
    undef_method :default_serialize_ex=
    
    # serializable fields
    attr_accessor :fields
    alias_method :attr_fields, :fields
    undef_method :fields
    alias_method :attr_fields=, :fields=
    undef_method :fields=
    
    # aggregate marshalled size of primitive fields
    attr_accessor :prim_data_size
    alias_method :attr_prim_data_size, :prim_data_size
    undef_method :prim_data_size
    alias_method :attr_prim_data_size=, :prim_data_size=
    undef_method :prim_data_size=
    
    # number of non-primitive fields
    attr_accessor :num_obj_fields
    alias_method :attr_num_obj_fields, :num_obj_fields
    undef_method :num_obj_fields
    alias_method :attr_num_obj_fields=, :num_obj_fields=
    undef_method :num_obj_fields=
    
    # reflector for setting/getting serializable field values
    attr_accessor :field_refl
    alias_method :attr_field_refl, :field_refl
    undef_method :field_refl
    alias_method :attr_field_refl=, :field_refl=
    undef_method :field_refl=
    
    # data layout of serialized objects described by this class desc
    attr_accessor :data_layout
    alias_method :attr_data_layout, :data_layout
    undef_method :data_layout
    alias_method :attr_data_layout=, :data_layout=
    undef_method :data_layout=
    
    # serialization-appropriate constructor, or null if none
    attr_accessor :cons
    alias_method :attr_cons, :cons
    undef_method :cons
    alias_method :attr_cons=, :cons=
    undef_method :cons=
    
    # class-defined writeObject method, or null if none
    attr_accessor :write_object_method
    alias_method :attr_write_object_method, :write_object_method
    undef_method :write_object_method
    alias_method :attr_write_object_method=, :write_object_method=
    undef_method :write_object_method=
    
    # class-defined readObject method, or null if none
    attr_accessor :read_object_method
    alias_method :attr_read_object_method, :read_object_method
    undef_method :read_object_method
    alias_method :attr_read_object_method=, :read_object_method=
    undef_method :read_object_method=
    
    # class-defined readObjectNoData method, or null if none
    attr_accessor :read_object_no_data_method
    alias_method :attr_read_object_no_data_method, :read_object_no_data_method
    undef_method :read_object_no_data_method
    alias_method :attr_read_object_no_data_method=, :read_object_no_data_method=
    undef_method :read_object_no_data_method=
    
    # class-defined writeReplace method, or null if none
    attr_accessor :write_replace_method
    alias_method :attr_write_replace_method, :write_replace_method
    undef_method :write_replace_method
    alias_method :attr_write_replace_method=, :write_replace_method=
    undef_method :write_replace_method=
    
    # class-defined readResolve method, or null if none
    attr_accessor :read_resolve_method
    alias_method :attr_read_resolve_method, :read_resolve_method
    undef_method :read_resolve_method
    alias_method :attr_read_resolve_method=, :read_resolve_method=
    undef_method :read_resolve_method=
    
    # local class descriptor for represented class (may point to self)
    attr_accessor :local_desc
    alias_method :attr_local_desc, :local_desc
    undef_method :local_desc
    alias_method :attr_local_desc=, :local_desc=
    undef_method :local_desc=
    
    # superclass descriptor appearing in stream
    attr_accessor :super_desc
    alias_method :attr_super_desc, :super_desc
    undef_method :super_desc
    alias_method :attr_super_desc=, :super_desc=
    undef_method :super_desc=
    
    class_module.module_eval {
      JNI.native_method :Java_java_io_ObjectStreamClass_initNative, [:pointer, :long], :void
      typesig { [] }
      # Initializes native code.
      def init_native
        JNI.__send__(:Java_java_io_ObjectStreamClass_initNative, JNI.env, self.jni_id)
      end
      
      when_class_loaded do
        init_native
      end
      
      typesig { [Class] }
      # Find the descriptor for a class that can be serialized.  Creates an
      # ObjectStreamClass instance if one does not exist yet for class. Null is
      # returned if the specified class does not implement java.io.Serializable
      # or java.io.Externalizable.
      # 
      # @param   cl class for which to get the descriptor
      # @return  the class descriptor for the specified class
      def lookup(cl)
        return lookup(cl, false)
      end
      
      typesig { [Class] }
      # Returns the descriptor for any class, regardless of whether it
      # implements {@link Serializable}.
      # 
      # @param        cl class for which to get the descriptor
      # @return       the class descriptor for the specified class
      # @since 1.6
      def lookup_any(cl)
        return lookup(cl, true)
      end
    }
    
    typesig { [] }
    # Returns the name of the class described by this descriptor.
    # This method returns the name of the class in the format that
    # is used by the {@link Class#getName} method.
    # 
    # @return a string representing the name of the class
    def get_name
      return @name
    end
    
    typesig { [] }
    # Return the serialVersionUID for this class.  The serialVersionUID
    # defines a set of classes all with the same name that have evolved from a
    # common root class and agree to be serialized and deserialized using a
    # common format.  NonSerializable classes have a serialVersionUID of 0L.
    # 
    # @return  the SUID of the class described by this descriptor
    def get_serial_version_uid
      # REMIND: synchronize instead of relying on volatile?
      if ((@suid).nil?)
        @suid = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ObjectStreamClass
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return Long.value_of(compute_default_suid(self.attr_cl))
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      return @suid.long_value
    end
    
    typesig { [] }
    # Return the class in the local VM that this version is mapped to.  Null
    # is returned if there is no corresponding local class.
    # 
    # @return  the <code>Class</code> instance that this descriptor represents
    def for_class
      return @cl
    end
    
    typesig { [] }
    # Return an array of the fields of this serializable class.
    # 
    # @return  an array containing an element for each persistent field of
    # this class. Returns an array of length zero if there are no
    # fields.
    # @since 1.2
    def get_fields
      return get_fields(true)
    end
    
    typesig { [String] }
    # Get the field of this class by name.
    # 
    # @param   name the name of the data field to look for
    # @return  The ObjectStreamField object of the named field or null if
    # there is no such named field.
    def get_field(name)
      return get_field(name, nil)
    end
    
    typesig { [] }
    # Return a string describing this ObjectStreamClass.
    def to_s
      return @name + ": static final long serialVersionUID = " + RJava.cast_to_string(get_serial_version_uid) + "L;"
    end
    
    class_module.module_eval {
      typesig { [Class, ::Java::Boolean] }
      # Looks up and returns class descriptor for given class, or null if class
      # is non-serializable and "all" is set to false.
      # 
      # @param   cl class to look up
      # @param   all if true, return descriptors for all classes; if false, only
      # return descriptors for serializable classes
      def lookup(cl, all)
        if (!(all || Serializable.is_assignable_from(cl)))
          return nil
        end
        process_queue(Caches.attr_local_descs_queue, Caches.attr_local_descs)
        key = WeakClassKey.new(cl, Caches.attr_local_descs_queue)
        ref = Caches.attr_local_descs.get(key)
        entry = nil
        if (!(ref).nil?)
          entry = ref.get
        end
        future = nil
        if ((entry).nil?)
          new_entry = EntryFuture.new
          new_ref = SoftReference.new(new_entry)
          begin
            if (!(ref).nil?)
              Caches.attr_local_descs.remove(key, ref)
            end
            ref = Caches.attr_local_descs.put_if_absent(key, new_ref)
            if (!(ref).nil?)
              entry = ref.get
            end
          end while (!(ref).nil? && (entry).nil?)
          if ((entry).nil?)
            future = new_entry
          end
        end
        if (entry.is_a?(ObjectStreamClass))
          # check common case first
          return entry
        end
        if (entry.is_a?(EntryFuture))
          future = entry
          if ((future.get_owner).equal?(JavaThread.current_thread))
            # Handle nested call situation described by 4803747: waiting
            # for future value to be set by a lookup() call further up the
            # stack will result in deadlock, so calculate and set the
            # future value here instead.
            entry = nil
          else
            entry = future.get
          end
        end
        if ((entry).nil?)
          begin
            entry = ObjectStreamClass.new(cl)
          rescue JavaThrowable => th
            entry = th
          end
          if (future.set(entry))
            Caches.attr_local_descs.put(key, SoftReference.new(entry))
          else
            # nested lookup call already set future
            entry = future.get
          end
        end
        if (entry.is_a?(ObjectStreamClass))
          return entry
        else
          if (entry.is_a?(RuntimeException))
            raise entry
          else
            if (entry.is_a?(JavaError))
              raise entry
            else
              raise InternalError.new("unexpected entry: " + RJava.cast_to_string(entry))
            end
          end
        end
      end
      
      # Placeholder used in class descriptor and field reflector lookup tables
      # for an entry in the process of being initialized.  (Internal) callers
      # which receive an EntryFuture belonging to another thread as the result
      # of a lookup should call the get() method of the EntryFuture; this will
      # return the actual entry once it is ready for use and has been set().  To
      # conserve objects, EntryFutures synchronize on themselves.
      const_set_lazy(:EntryFuture) { Class.new do
        include_class_members ObjectStreamClass
        
        class_module.module_eval {
          const_set_lazy(:Unset) { Object.new }
          const_attr_reader  :Unset
        }
        
        attr_accessor :owner
        alias_method :attr_owner, :owner
        undef_method :owner
        alias_method :attr_owner=, :owner=
        undef_method :owner=
        
        attr_accessor :entry
        alias_method :attr_entry, :entry
        undef_method :entry
        alias_method :attr_entry=, :entry=
        undef_method :entry=
        
        typesig { [Object] }
        # Attempts to set the value contained by this EntryFuture.  If the
        # EntryFuture's value has not been set already, then the value is
        # saved, any callers blocked in the get() method are notified, and
        # true is returned.  If the value has already been set, then no saving
        # or notification occurs, and false is returned.
        def set(entry)
          synchronized(self) do
            if (!(@entry).equal?(self.class::Unset))
              return false
            end
            @entry = entry
            notify_all
            return true
          end
        end
        
        typesig { [] }
        # Returns the value contained by this EntryFuture, blocking if
        # necessary until a value is set.
        def get
          synchronized(self) do
            interrupted = false
            while ((@entry).equal?(self.class::Unset))
              begin
                wait
              rescue self.class::InterruptedException => ex
                interrupted = true
              end
            end
            if (interrupted)
              AccessController.do_privileged(Class.new(self.class::PrivilegedAction.class == Class ? self.class::PrivilegedAction : Object) do
                extend LocalClass
                include_class_members EntryFuture
                include class_self::PrivilegedAction if class_self::PrivilegedAction.class == Module
                
                typesig { [] }
                define_method :run do
                  JavaThread.current_thread.interrupt
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
            return @entry
          end
        end
        
        typesig { [] }
        # Returns the thread that created this EntryFuture.
        def get_owner
          return @owner
        end
        
        typesig { [] }
        def initialize
          @owner = JavaThread.current_thread
          @entry = self.class::Unset
        end
        
        private
        alias_method :initialize__entry_future, :initialize
      end }
    }
    
    typesig { [Class] }
    # Creates local class descriptor representing given class.
    def initialize(cl)
      @cl = nil
      @name = nil
      @suid = nil
      @is_proxy = false
      @is_enum = false
      @serializable = false
      @externalizable = false
      @has_write_object_data = false
      @has_block_external_data = true
      @resolve_ex = nil
      @deserialize_ex = nil
      @serialize_ex = nil
      @default_serialize_ex = nil
      @fields = nil
      @prim_data_size = 0
      @num_obj_fields = 0
      @field_refl = nil
      @data_layout = nil
      @cons = nil
      @write_object_method = nil
      @read_object_method = nil
      @read_object_no_data_method = nil
      @write_replace_method = nil
      @read_resolve_method = nil
      @local_desc = nil
      @super_desc = nil
      @cl = cl
      @name = RJava.cast_to_string(cl.get_name)
      @is_proxy = Proxy.is_proxy_class(cl)
      @is_enum = Enum.is_assignable_from(cl)
      @serializable = Serializable.is_assignable_from(cl)
      @externalizable = Externalizable.is_assignable_from(cl)
      super_cl = cl.get_superclass
      @super_desc = (!(super_cl).nil?) ? lookup(super_cl, false) : nil
      @local_desc = self
      if (@serializable)
        AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members ObjectStreamClass
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            if (self.attr_is_enum)
              self.attr_suid = Long.value_of(0)
              self.attr_fields = NO_FIELDS
              return nil
            end
            if (cl.is_array)
              self.attr_fields = NO_FIELDS
              return nil
            end
            self.attr_suid = get_declared_suid(cl)
            begin
              self.attr_fields = get_serial_fields(cl)
              compute_field_offsets
            rescue self.class::InvalidClassException => e
              self.attr_serialize_ex = self.attr_deserialize_ex = e
              self.attr_fields = NO_FIELDS
            end
            if (self.attr_externalizable)
              self.attr_cons = get_externalizable_constructor(cl)
            else
              self.attr_cons = get_serializable_constructor(cl)
              self.attr_write_object_method = get_private_method(cl, "writeObject", Array.typed(self.class::Class).new([ObjectOutputStream]), Void::TYPE)
              self.attr_read_object_method = get_private_method(cl, "readObject", Array.typed(self.class::Class).new([ObjectInputStream]), Void::TYPE)
              self.attr_read_object_no_data_method = get_private_method(cl, "readObjectNoData", nil, Void::TYPE)
              self.attr_has_write_object_data = (!(self.attr_write_object_method).nil?)
            end
            self.attr_write_replace_method = get_inheritable_method(cl, "writeReplace", nil, Object)
            self.attr_read_resolve_method = get_inheritable_method(cl, "readResolve", nil, Object)
            return nil
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      else
        @suid = Long.value_of(0)
        @fields = NO_FIELDS
      end
      begin
        @field_refl = get_reflector(@fields, self)
      rescue InvalidClassException => ex
        # field mismatches impossible when matching local fields vs. self
        raise InternalError.new
      end
      if ((@deserialize_ex).nil?)
        if (@is_enum)
          @deserialize_ex = InvalidClassException.new(@name, "enum type")
        else
          if ((@cons).nil?)
            @deserialize_ex = InvalidClassException.new(@name, "no valid constructor")
          end
        end
      end
      i = 0
      while i < @fields.attr_length
        if ((@fields[i].get_field).nil?)
          @default_serialize_ex = InvalidClassException.new(@name, "unmatched serializable field(s) declared")
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Creates blank class descriptor which should be initialized via a
    # subsequent call to initProxy(), initNonProxy() or readNonProxy().
    def initialize
      @cl = nil
      @name = nil
      @suid = nil
      @is_proxy = false
      @is_enum = false
      @serializable = false
      @externalizable = false
      @has_write_object_data = false
      @has_block_external_data = true
      @resolve_ex = nil
      @deserialize_ex = nil
      @serialize_ex = nil
      @default_serialize_ex = nil
      @fields = nil
      @prim_data_size = 0
      @num_obj_fields = 0
      @field_refl = nil
      @data_layout = nil
      @cons = nil
      @write_object_method = nil
      @read_object_method = nil
      @read_object_no_data_method = nil
      @write_replace_method = nil
      @read_resolve_method = nil
      @local_desc = nil
      @super_desc = nil
    end
    
    typesig { [Class, ClassNotFoundException, ObjectStreamClass] }
    # Initializes class descriptor representing a proxy class.
    def init_proxy(cl, resolve_ex, super_desc)
      @cl = cl
      @resolve_ex = resolve_ex
      @super_desc = super_desc
      @is_proxy = true
      @serializable = true
      @suid = Long.value_of(0)
      @fields = NO_FIELDS
      if (!(cl).nil?)
        @local_desc = lookup(cl, true)
        if (!@local_desc.attr_is_proxy)
          raise InvalidClassException.new("cannot bind proxy descriptor to a non-proxy class")
        end
        @name = RJava.cast_to_string(@local_desc.attr_name)
        @externalizable = @local_desc.attr_externalizable
        @cons = @local_desc.attr_cons
        @write_replace_method = @local_desc.attr_write_replace_method
        @read_resolve_method = @local_desc.attr_read_resolve_method
        @deserialize_ex = @local_desc.attr_deserialize_ex
      end
      @field_refl = get_reflector(@fields, @local_desc)
    end
    
    typesig { [ObjectStreamClass, Class, ClassNotFoundException, ObjectStreamClass] }
    # Initializes class descriptor representing a non-proxy class.
    def init_non_proxy(model, cl, resolve_ex, super_desc)
      @cl = cl
      @resolve_ex = resolve_ex
      @super_desc = super_desc
      @name = RJava.cast_to_string(model.attr_name)
      @suid = Long.value_of(model.get_serial_version_uid)
      @is_proxy = false
      @is_enum = model.attr_is_enum
      @serializable = model.attr_serializable
      @externalizable = model.attr_externalizable
      @has_block_external_data = model.attr_has_block_external_data
      @has_write_object_data = model.attr_has_write_object_data
      @fields = model.attr_fields
      @prim_data_size = model.attr_prim_data_size
      @num_obj_fields = model.attr_num_obj_fields
      if (!(cl).nil?)
        @local_desc = lookup(cl, true)
        if (@local_desc.attr_is_proxy)
          raise InvalidClassException.new("cannot bind non-proxy descriptor to a proxy class")
        end
        if (!(@is_enum).equal?(@local_desc.attr_is_enum))
          raise InvalidClassException.new(@is_enum ? "cannot bind enum descriptor to a non-enum class" : "cannot bind non-enum descriptor to an enum class")
        end
        if ((@serializable).equal?(@local_desc.attr_serializable) && !cl.is_array && !(@suid.long_value).equal?(@local_desc.get_serial_version_uid))
          raise InvalidClassException.new(@local_desc.attr_name, "local class incompatible: " + "stream classdesc serialVersionUID = " + RJava.cast_to_string(@suid) + ", local class serialVersionUID = " + RJava.cast_to_string(@local_desc.get_serial_version_uid))
        end
        if (!class_names_equal(@name, @local_desc.attr_name))
          raise InvalidClassException.new(@local_desc.attr_name, "local class name incompatible with stream class " + "name \"" + @name + "\"")
        end
        if (!@is_enum)
          if (((@serializable).equal?(@local_desc.attr_serializable)) && (!(@externalizable).equal?(@local_desc.attr_externalizable)))
            raise InvalidClassException.new(@local_desc.attr_name, "Serializable incompatible with Externalizable")
          end
          if ((!(@serializable).equal?(@local_desc.attr_serializable)) || (!(@externalizable).equal?(@local_desc.attr_externalizable)) || !(@serializable || @externalizable))
            @deserialize_ex = InvalidClassException.new(@local_desc.attr_name, "class invalid for deserialization")
          end
        end
        @cons = @local_desc.attr_cons
        @write_object_method = @local_desc.attr_write_object_method
        @read_object_method = @local_desc.attr_read_object_method
        @read_object_no_data_method = @local_desc.attr_read_object_no_data_method
        @write_replace_method = @local_desc.attr_write_replace_method
        @read_resolve_method = @local_desc.attr_read_resolve_method
        if ((@deserialize_ex).nil?)
          @deserialize_ex = @local_desc.attr_deserialize_ex
        end
      end
      @field_refl = get_reflector(@fields, @local_desc)
      # reassign to matched fields so as to reflect local unshared settings
      @fields = @field_refl.get_fields
    end
    
    typesig { [ObjectInputStream] }
    # Reads non-proxy class descriptor information from given input stream.
    # The resulting class descriptor is not fully functional; it can only be
    # used as input to the ObjectInputStream.resolveClass() and
    # ObjectStreamClass.initNonProxy() methods.
    def read_non_proxy(in_)
      @name = RJava.cast_to_string(in_.read_utf)
      @suid = Long.value_of(in_.read_long)
      @is_proxy = false
      flags = in_.read_byte
      @has_write_object_data = (!((flags & ObjectStreamConstants::SC_WRITE_METHOD)).equal?(0))
      @has_block_external_data = (!((flags & ObjectStreamConstants::SC_BLOCK_DATA)).equal?(0))
      @externalizable = (!((flags & ObjectStreamConstants::SC_EXTERNALIZABLE)).equal?(0))
      sflag = (!((flags & ObjectStreamConstants::SC_SERIALIZABLE)).equal?(0))
      if (@externalizable && sflag)
        raise InvalidClassException.new(@name, "serializable and externalizable flags conflict")
      end
      @serializable = @externalizable || sflag
      @is_enum = (!((flags & ObjectStreamConstants::SC_ENUM)).equal?(0))
      if (@is_enum && !(@suid.long_value).equal?(0))
        raise InvalidClassException.new(@name, "enum descriptor has non-zero serialVersionUID: " + RJava.cast_to_string(@suid))
      end
      num_fields = in_.read_short
      if (@is_enum && !(num_fields).equal?(0))
        raise InvalidClassException.new(@name, "enum descriptor has non-zero field count: " + RJava.cast_to_string(num_fields))
      end
      @fields = (num_fields > 0) ? Array.typed(ObjectStreamField).new(num_fields) { nil } : NO_FIELDS
      i = 0
      while i < num_fields
        tcode = RJava.cast_to_char(in_.read_byte)
        fname = in_.read_utf
        signature = (((tcode).equal?(Character.new(?L.ord))) || ((tcode).equal?(Character.new(?[.ord)))) ? in_.read_type_string : String.new(Array.typed(::Java::Char).new([tcode]))
        begin
          @fields[i] = ObjectStreamField.new(fname, signature, false)
        rescue RuntimeException => e
          raise InvalidClassException.new(@name, "invalid descriptor for field " + fname).init_cause(e)
        end
        i += 1
      end
      compute_field_offsets
    end
    
    typesig { [ObjectOutputStream] }
    # Writes non-proxy class descriptor information to given output stream.
    def write_non_proxy(out)
      out.write_utf(@name)
      out.write_long(get_serial_version_uid)
      flags = 0
      if (@externalizable)
        flags |= ObjectStreamConstants::SC_EXTERNALIZABLE
        protocol = out.get_protocol_version
        if (!(protocol).equal?(ObjectStreamConstants::PROTOCOL_VERSION_1))
          flags |= ObjectStreamConstants::SC_BLOCK_DATA
        end
      else
        if (@serializable)
          flags |= ObjectStreamConstants::SC_SERIALIZABLE
        end
      end
      if (@has_write_object_data)
        flags |= ObjectStreamConstants::SC_WRITE_METHOD
      end
      if (@is_enum)
        flags |= ObjectStreamConstants::SC_ENUM
      end
      out.write_byte(flags)
      out.write_short(@fields.attr_length)
      i = 0
      while i < @fields.attr_length
        f = @fields[i]
        out.write_byte(f.get_type_code)
        out.write_utf(f.get_name)
        if (!f.is_primitive)
          out.write_type_string(f.get_type_string)
        end
        i += 1
      end
    end
    
    typesig { [] }
    # Returns ClassNotFoundException (if any) thrown while attempting to
    # resolve local class corresponding to this class descriptor.
    def get_resolve_exception
      return @resolve_ex
    end
    
    typesig { [] }
    # Throws an InvalidClassException if object instances referencing this
    # class descriptor should not be allowed to deserialize.  This method does
    # not apply to deserialization of enum constants.
    def check_deserialize
      if (!(@deserialize_ex).nil?)
        ice = InvalidClassException.new(@deserialize_ex.attr_classname, @deserialize_ex.get_message)
        ice.init_cause(@deserialize_ex)
        raise ice
      end
    end
    
    typesig { [] }
    # Throws an InvalidClassException if objects whose class is represented by
    # this descriptor should not be allowed to serialize.  This method does
    # not apply to serialization of enum constants.
    def check_serialize
      if (!(@serialize_ex).nil?)
        ice = InvalidClassException.new(@serialize_ex.attr_classname, @serialize_ex.get_message)
        ice.init_cause(@serialize_ex)
        raise ice
      end
    end
    
    typesig { [] }
    # Throws an InvalidClassException if objects whose class is represented by
    # this descriptor should not be permitted to use default serialization
    # (e.g., if the class declares serializable fields that do not correspond
    # to actual fields, and hence must use the GetField API).  This method
    # does not apply to deserialization of enum constants.
    def check_default_serialize
      if (!(@default_serialize_ex).nil?)
        ice = InvalidClassException.new(@default_serialize_ex.attr_classname, @default_serialize_ex.get_message)
        ice.init_cause(@default_serialize_ex)
        raise ice
      end
    end
    
    typesig { [] }
    # Returns superclass descriptor.  Note that on the receiving side, the
    # superclass descriptor may be bound to a class that is not a superclass
    # of the subclass descriptor's bound class.
    def get_super_desc
      return @super_desc
    end
    
    typesig { [] }
    # Returns the "local" class descriptor for the class associated with this
    # class descriptor (i.e., the result of
    # ObjectStreamClass.lookup(this.forClass())) or null if there is no class
    # associated with this descriptor.
    def get_local_desc
      return @local_desc
    end
    
    typesig { [::Java::Boolean] }
    # Returns arrays of ObjectStreamFields representing the serializable
    # fields of the represented class.  If copy is true, a clone of this class
    # descriptor's field array is returned, otherwise the array itself is
    # returned.
    def get_fields(copy)
      return copy ? @fields.clone : @fields
    end
    
    typesig { [String, Class] }
    # Looks up a serializable field of the represented class by name and type.
    # A specified type of null matches all types, Object.class matches all
    # non-primitive types, and any other non-null type matches assignable
    # types only.  Returns matching field, or null if no match found.
    def get_field(name, type)
      i = 0
      while i < @fields.attr_length
        f = @fields[i]
        if ((f.get_name == name))
          if ((type).nil? || ((type).equal?(Object) && !f.is_primitive))
            return f
          end
          ftype = f.get_type
          if (!(ftype).nil? && type.is_assignable_from(ftype))
            return f
          end
        end
        i += 1
      end
      return nil
    end
    
    typesig { [] }
    # Returns true if class descriptor represents a dynamic proxy class, false
    # otherwise.
    def is_proxy
      return @is_proxy
    end
    
    typesig { [] }
    # Returns true if class descriptor represents an enum type, false
    # otherwise.
    def is_enum
      return @is_enum
    end
    
    typesig { [] }
    # Returns true if represented class implements Externalizable, false
    # otherwise.
    def is_externalizable
      return @externalizable
    end
    
    typesig { [] }
    # Returns true if represented class implements Serializable, false
    # otherwise.
    def is_serializable
      return @serializable
    end
    
    typesig { [] }
    # Returns true if class descriptor represents externalizable class that
    # has written its data in 1.2 (block data) format, false otherwise.
    def has_block_external_data
      return @has_block_external_data
    end
    
    typesig { [] }
    # Returns true if class descriptor represents serializable (but not
    # externalizable) class which has written its data via a custom
    # writeObject() method, false otherwise.
    def has_write_object_data
      return @has_write_object_data
    end
    
    typesig { [] }
    # Returns true if represented class is serializable/externalizable and can
    # be instantiated by the serialization runtime--i.e., if it is
    # externalizable and defines a public no-arg constructor, or if it is
    # non-externalizable and its first non-serializable superclass defines an
    # accessible no-arg constructor.  Otherwise, returns false.
    def is_instantiable
      return (!(@cons).nil?)
    end
    
    typesig { [] }
    # Returns true if represented class is serializable (but not
    # externalizable) and defines a conformant writeObject method.  Otherwise,
    # returns false.
    def has_write_object_method
      return (!(@write_object_method).nil?)
    end
    
    typesig { [] }
    # Returns true if represented class is serializable (but not
    # externalizable) and defines a conformant readObject method.  Otherwise,
    # returns false.
    def has_read_object_method
      return (!(@read_object_method).nil?)
    end
    
    typesig { [] }
    # Returns true if represented class is serializable (but not
    # externalizable) and defines a conformant readObjectNoData method.
    # Otherwise, returns false.
    def has_read_object_no_data_method
      return (!(@read_object_no_data_method).nil?)
    end
    
    typesig { [] }
    # Returns true if represented class is serializable or externalizable and
    # defines a conformant writeReplace method.  Otherwise, returns false.
    def has_write_replace_method
      return (!(@write_replace_method).nil?)
    end
    
    typesig { [] }
    # Returns true if represented class is serializable or externalizable and
    # defines a conformant readResolve method.  Otherwise, returns false.
    def has_read_resolve_method
      return (!(@read_resolve_method).nil?)
    end
    
    typesig { [] }
    # Creates a new instance of the represented class.  If the class is
    # externalizable, invokes its public no-arg constructor; otherwise, if the
    # class is serializable, invokes the no-arg constructor of the first
    # non-serializable superclass.  Throws UnsupportedOperationException if
    # this class descriptor is not associated with a class, if the associated
    # class is non-serializable or if the appropriate no-arg constructor is
    # inaccessible/unavailable.
    def new_instance
      if (!(@cons).nil?)
        begin
          return @cons.new_instance
        rescue IllegalAccessException => ex
          # should not occur, as access checks have been suppressed
          raise InternalError.new
        end
      else
        raise UnsupportedOperationException.new
      end
    end
    
    typesig { [Object, ObjectOutputStream] }
    # Invokes the writeObject method of the represented serializable class.
    # Throws UnsupportedOperationException if this class descriptor is not
    # associated with a class, or if the class is externalizable,
    # non-serializable or does not define writeObject.
    def invoke_write_object(obj, out)
      if (!(@write_object_method).nil?)
        begin
          @write_object_method.invoke(obj, Array.typed(Object).new([out]))
        rescue InvocationTargetException => ex
          th = ex.get_target_exception
          if (th.is_a?(IOException))
            raise th
          else
            throw_misc_exception(th)
          end
        rescue IllegalAccessException => ex
          # should not occur, as access checks have been suppressed
          raise InternalError.new
        end
      else
        raise UnsupportedOperationException.new
      end
    end
    
    typesig { [Object, ObjectInputStream] }
    # Invokes the readObject method of the represented serializable class.
    # Throws UnsupportedOperationException if this class descriptor is not
    # associated with a class, or if the class is externalizable,
    # non-serializable or does not define readObject.
    def invoke_read_object(obj, in_)
      if (!(@read_object_method).nil?)
        begin
          @read_object_method.invoke(obj, Array.typed(Object).new([in_]))
        rescue InvocationTargetException => ex
          th = ex.get_target_exception
          if (th.is_a?(ClassNotFoundException))
            raise th
          else
            if (th.is_a?(IOException))
              raise th
            else
              throw_misc_exception(th)
            end
          end
        rescue IllegalAccessException => ex
          # should not occur, as access checks have been suppressed
          raise InternalError.new
        end
      else
        raise UnsupportedOperationException.new
      end
    end
    
    typesig { [Object] }
    # Invokes the readObjectNoData method of the represented serializable
    # class.  Throws UnsupportedOperationException if this class descriptor is
    # not associated with a class, or if the class is externalizable,
    # non-serializable or does not define readObjectNoData.
    def invoke_read_object_no_data(obj)
      if (!(@read_object_no_data_method).nil?)
        begin
          @read_object_no_data_method.invoke(obj, nil)
        rescue InvocationTargetException => ex
          th = ex.get_target_exception
          if (th.is_a?(ObjectStreamException))
            raise th
          else
            throw_misc_exception(th)
          end
        rescue IllegalAccessException => ex
          # should not occur, as access checks have been suppressed
          raise InternalError.new
        end
      else
        raise UnsupportedOperationException.new
      end
    end
    
    typesig { [Object] }
    # Invokes the writeReplace method of the represented serializable class and
    # returns the result.  Throws UnsupportedOperationException if this class
    # descriptor is not associated with a class, or if the class is
    # non-serializable or does not define writeReplace.
    def invoke_write_replace(obj)
      if (!(@write_replace_method).nil?)
        begin
          return @write_replace_method.invoke(obj, nil)
        rescue InvocationTargetException => ex
          th = ex.get_target_exception
          if (th.is_a?(ObjectStreamException))
            raise th
          else
            throw_misc_exception(th)
            raise InternalError.new # never reached
          end
        rescue IllegalAccessException => ex
          # should not occur, as access checks have been suppressed
          raise InternalError.new
        end
      else
        raise UnsupportedOperationException.new
      end
    end
    
    typesig { [Object] }
    # Invokes the readResolve method of the represented serializable class and
    # returns the result.  Throws UnsupportedOperationException if this class
    # descriptor is not associated with a class, or if the class is
    # non-serializable or does not define readResolve.
    def invoke_read_resolve(obj)
      if (!(@read_resolve_method).nil?)
        begin
          return @read_resolve_method.invoke(obj, nil)
        rescue InvocationTargetException => ex
          th = ex.get_target_exception
          if (th.is_a?(ObjectStreamException))
            raise th
          else
            throw_misc_exception(th)
            raise InternalError.new # never reached
          end
        rescue IllegalAccessException => ex
          # should not occur, as access checks have been suppressed
          raise InternalError.new
        end
      else
        raise UnsupportedOperationException.new
      end
    end
    
    class_module.module_eval {
      # Class representing the portion of an object's serialized form allotted
      # to data described by a given class descriptor.  If "hasData" is false,
      # the object's serialized form does not contain data associated with the
      # class descriptor.
      const_set_lazy(:ClassDataSlot) { Class.new do
        include_class_members ObjectStreamClass
        
        # class descriptor "occupying" this slot
        attr_accessor :desc
        alias_method :attr_desc, :desc
        undef_method :desc
        alias_method :attr_desc=, :desc=
        undef_method :desc=
        
        # true if serialized form includes data for this slot's descriptor
        attr_accessor :has_data
        alias_method :attr_has_data, :has_data
        undef_method :has_data
        alias_method :attr_has_data=, :has_data=
        undef_method :has_data=
        
        typesig { [class_self::ObjectStreamClass, ::Java::Boolean] }
        def initialize(desc, has_data)
          @desc = nil
          @has_data = false
          @desc = desc
          @has_data = has_data
        end
        
        private
        alias_method :initialize__class_data_slot, :initialize
      end }
    }
    
    typesig { [] }
    # Returns array of ClassDataSlot instances representing the data layout
    # (including superclass data) for serialized objects described by this
    # class descriptor.  ClassDataSlots are ordered by inheritance with those
    # containing "higher" superclasses appearing first.  The final
    # ClassDataSlot contains a reference to this descriptor.
    def get_class_data_layout
      # REMIND: synchronize instead of relying on volatile?
      if ((@data_layout).nil?)
        @data_layout = get_class_data_layout0
      end
      return @data_layout
    end
    
    typesig { [] }
    def get_class_data_layout0
      slots = ArrayList.new
      start = @cl
      end_ = @cl
      # locate closest non-serializable superclass
      while (!(end_).nil? && Serializable.is_assignable_from(end_))
        end_ = end_.get_superclass
      end
      d = self
      while !(d).nil?
        # search up inheritance hierarchy for class with matching name
        search_name = (!(d.attr_cl).nil?) ? d.attr_cl.get_name : d.attr_name
        match = nil
        c = start
        while !(c).equal?(end_)
          if ((search_name == c.get_name))
            match = c
            break
          end
          c = c.get_superclass
        end
        # add "no data" slot for each unmatched class below match
        if (!(match).nil?)
          c_ = start
          while !(c_).equal?(match)
            slots.add(ClassDataSlot.new(ObjectStreamClass.lookup(c_, true), false))
            c_ = c_.get_superclass
          end
          start = match.get_superclass
        end
        # record descriptor/class pairing
        slots.add(ClassDataSlot.new(d.get_variant_for(match), true))
        d = d.attr_super_desc
      end
      # add "no data" slot for any leftover unmatched classes
      c = start
      while !(c).equal?(end_)
        slots.add(ClassDataSlot.new(ObjectStreamClass.lookup(c, true), false))
        c = c.get_superclass
      end
      # order slots from superclass -> subclass
      Collections.reverse(slots)
      return slots.to_array(Array.typed(ClassDataSlot).new(slots.size) { nil })
    end
    
    typesig { [] }
    # Returns aggregate size (in bytes) of marshalled primitive field values
    # for represented class.
    def get_prim_data_size
      return @prim_data_size
    end
    
    typesig { [] }
    # Returns number of non-primitive serializable fields of represented
    # class.
    def get_num_obj_fields
      return @num_obj_fields
    end
    
    typesig { [Object, Array.typed(::Java::Byte)] }
    # Fetches the serializable primitive field values of object obj and
    # marshals them into byte array buf starting at offset 0.  It is the
    # responsibility of the caller to ensure that obj is of the proper type if
    # non-null.
    def get_prim_field_values(obj, buf)
      @field_refl.get_prim_field_values(obj, buf)
    end
    
    typesig { [Object, Array.typed(::Java::Byte)] }
    # Sets the serializable primitive fields of object obj using values
    # unmarshalled from byte array buf starting at offset 0.  It is the
    # responsibility of the caller to ensure that obj is of the proper type if
    # non-null.
    def set_prim_field_values(obj, buf)
      @field_refl.set_prim_field_values(obj, buf)
    end
    
    typesig { [Object, Array.typed(Object)] }
    # Fetches the serializable object field values of object obj and stores
    # them in array vals starting at offset 0.  It is the responsibility of
    # the caller to ensure that obj is of the proper type if non-null.
    def get_obj_field_values(obj, vals)
      @field_refl.get_obj_field_values(obj, vals)
    end
    
    typesig { [Object, Array.typed(Object)] }
    # Sets the serializable object fields of object obj using values from
    # array vals starting at offset 0.  It is the responsibility of the caller
    # to ensure that obj is of the proper type if non-null.
    def set_obj_field_values(obj, vals)
      @field_refl.set_obj_field_values(obj, vals)
    end
    
    typesig { [] }
    # Calculates and sets serializable field offsets, as well as primitive
    # data size and object field count totals.  Throws InvalidClassException
    # if fields are illegally ordered.
    def compute_field_offsets
      @prim_data_size = 0
      @num_obj_fields = 0
      first_obj_index = -1
      i = 0
      while i < @fields.attr_length
        f = @fields[i]
        case (f.get_type_code)
        when Character.new(?Z.ord), Character.new(?B.ord)
          f.set_offset(((@prim_data_size += 1) - 1))
        when Character.new(?C.ord), Character.new(?S.ord)
          f.set_offset(@prim_data_size)
          @prim_data_size += 2
        when Character.new(?I.ord), Character.new(?F.ord)
          f.set_offset(@prim_data_size)
          @prim_data_size += 4
        when Character.new(?J.ord), Character.new(?D.ord)
          f.set_offset(@prim_data_size)
          @prim_data_size += 8
        when Character.new(?[.ord), Character.new(?L.ord)
          f.set_offset(((@num_obj_fields += 1) - 1))
          if ((first_obj_index).equal?(-1))
            first_obj_index = i
          end
        else
          raise InternalError.new
        end
        i += 1
      end
      if (!(first_obj_index).equal?(-1) && !(first_obj_index + @num_obj_fields).equal?(@fields.attr_length))
        raise InvalidClassException.new(@name, "illegal field order")
      end
    end
    
    typesig { [Class] }
    # If given class is the same as the class associated with this class
    # descriptor, returns reference to this class descriptor.  Otherwise,
    # returns variant of this class descriptor bound to given class.
    def get_variant_for(cl)
      if ((@cl).equal?(cl))
        return self
      end
      desc = ObjectStreamClass.new
      if (@is_proxy)
        desc.init_proxy(cl, nil, @super_desc)
      else
        desc.init_non_proxy(self, cl, nil, @super_desc)
      end
      return desc
    end
    
    class_module.module_eval {
      typesig { [Class] }
      # Returns public no-arg constructor of given class, or null if none found.
      # Access checks are disabled on the returned constructor (if any), since
      # the defining class may still be non-public.
      def get_externalizable_constructor(cl)
        begin
          cons = cl.get_declared_constructor(nil)
          cons.set_accessible(true)
          return (!((cons.get_modifiers & Modifier::PUBLIC)).equal?(0)) ? cons : nil
        rescue NoSuchMethodException => ex
          return nil
        end
      end
      
      typesig { [Class] }
      # Returns subclass-accessible no-arg constructor of first non-serializable
      # superclass, or null if none found.  Access checks are disabled on the
      # returned constructor (if any).
      def get_serializable_constructor(cl)
        init_cl = cl
        while (Serializable.is_assignable_from(init_cl))
          if (((init_cl = init_cl.get_superclass)).nil?)
            return nil
          end
        end
        begin
          cons = init_cl.get_declared_constructor(nil)
          mods = cons.get_modifiers
          if (!((mods & Modifier::PRIVATE)).equal?(0) || (((mods & (Modifier::PUBLIC | Modifier::PROTECTED))).equal?(0) && !package_equals(cl, init_cl)))
            return nil
          end
          cons = ReflFactory.new_constructor_for_serialization(cl, cons)
          cons.set_accessible(true)
          return cons
        rescue NoSuchMethodException => ex
          return nil
        end
      end
      
      typesig { [Class, String, Array.typed(Class), Class] }
      # Returns non-static, non-abstract method with given signature provided it
      # is defined by or accessible (via inheritance) by the given class, or
      # null if no match found.  Access checks are disabled on the returned
      # method (if any).
      def get_inheritable_method(cl, name, arg_types, return_type)
        meth = nil
        def_cl = cl
        while (!(def_cl).nil?)
          begin
            meth = def_cl.get_declared_method(name, arg_types)
            break
          rescue NoSuchMethodException => ex
            def_cl = def_cl.get_superclass
          end
        end
        if (((meth).nil?) || (!(meth.get_return_type).equal?(return_type)))
          return nil
        end
        meth.set_accessible(true)
        mods = meth.get_modifiers
        if (!((mods & (Modifier::STATIC | Modifier::ABSTRACT))).equal?(0))
          return nil
        else
          if (!((mods & (Modifier::PUBLIC | Modifier::PROTECTED))).equal?(0))
            return meth
          else
            if (!((mods & Modifier::PRIVATE)).equal?(0))
              return ((cl).equal?(def_cl)) ? meth : nil
            else
              return package_equals(cl, def_cl) ? meth : nil
            end
          end
        end
      end
      
      typesig { [Class, String, Array.typed(Class), Class] }
      # Returns non-static private method with given signature defined by given
      # class, or null if none found.  Access checks are disabled on the
      # returned method (if any).
      def get_private_method(cl, name, arg_types, return_type)
        begin
          meth = cl.get_declared_method(name, arg_types)
          meth.set_accessible(true)
          mods = meth.get_modifiers
          return (((meth.get_return_type).equal?(return_type)) && (((mods & Modifier::STATIC)).equal?(0)) && (!((mods & Modifier::PRIVATE)).equal?(0))) ? meth : nil
        rescue NoSuchMethodException => ex
          return nil
        end
      end
      
      typesig { [Class, Class] }
      # Returns true if classes are defined in the same runtime package, false
      # otherwise.
      def package_equals(cl1, cl2)
        return ((cl1.get_class_loader).equal?(cl2.get_class_loader) && (get_package_name(cl1) == get_package_name(cl2)))
      end
      
      typesig { [Class] }
      # Returns package name of given class.
      def get_package_name(cl)
        s = cl.get_name
        i = s.last_index_of(Character.new(?[.ord))
        if (i >= 0)
          s = RJava.cast_to_string(s.substring(i + 2))
        end
        i = s.last_index_of(Character.new(?..ord))
        return (i >= 0) ? s.substring(0, i) : ""
      end
      
      typesig { [String, String] }
      # Compares class names for equality, ignoring package names.  Returns true
      # if class names equal, false otherwise.
      def class_names_equal(name1, name2)
        name1 = RJava.cast_to_string(name1.substring(name1.last_index_of(Character.new(?..ord)) + 1))
        name2 = RJava.cast_to_string(name2.substring(name2.last_index_of(Character.new(?..ord)) + 1))
        return (name1 == name2)
      end
      
      typesig { [Class] }
      # Returns JVM type signature for given class.
      def get_class_signature(cl)
        sbuf = StringBuilder.new
        while (cl.is_array)
          sbuf.append(Character.new(?[.ord))
          cl = cl.get_component_type
        end
        if (cl.is_primitive)
          if ((cl).equal?(JavaInteger::TYPE))
            sbuf.append(Character.new(?I.ord))
          else
            if ((cl).equal?(Byte::TYPE))
              sbuf.append(Character.new(?B.ord))
            else
              if ((cl).equal?(Long::TYPE))
                sbuf.append(Character.new(?J.ord))
              else
                if ((cl).equal?(Float::TYPE))
                  sbuf.append(Character.new(?F.ord))
                else
                  if ((cl).equal?(Double::TYPE))
                    sbuf.append(Character.new(?D.ord))
                  else
                    if ((cl).equal?(Short::TYPE))
                      sbuf.append(Character.new(?S.ord))
                    else
                      if ((cl).equal?(Character::TYPE))
                        sbuf.append(Character.new(?C.ord))
                      else
                        if ((cl).equal?(Boolean::TYPE))
                          sbuf.append(Character.new(?Z.ord))
                        else
                          if ((cl).equal?(Void::TYPE))
                            sbuf.append(Character.new(?V.ord))
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
          end
        else
          sbuf.append(Character.new(?L.ord) + cl.get_name.replace(Character.new(?..ord), Character.new(?/.ord)) + Character.new(?;.ord))
        end
        return sbuf.to_s
      end
      
      typesig { [Array.typed(Class), Class] }
      # Returns JVM type signature for given list of parameters and return type.
      def get_method_signature(param_types, ret_type)
        sbuf = StringBuilder.new
        sbuf.append(Character.new(?(.ord))
        i = 0
        while i < param_types.attr_length
          sbuf.append(get_class_signature(param_types[i]))
          i += 1
        end
        sbuf.append(Character.new(?).ord))
        sbuf.append(get_class_signature(ret_type))
        return sbuf.to_s
      end
      
      typesig { [JavaThrowable] }
      # Convenience method for throwing an exception that is either a
      # RuntimeException, Error, or of some unexpected type (in which case it is
      # wrapped inside an IOException).
      def throw_misc_exception(th)
        if (th.is_a?(RuntimeException))
          raise th
        else
          if (th.is_a?(JavaError))
            raise th
          else
            ex = IOException.new("unexpected exception type")
            ex.init_cause(th)
            raise ex
          end
        end
      end
      
      typesig { [Class] }
      # Returns ObjectStreamField array describing the serializable fields of
      # the given class.  Serializable fields backed by an actual field of the
      # class are represented by ObjectStreamFields with corresponding non-null
      # Field objects.  Throws InvalidClassException if the (explicitly
      # declared) serializable fields are invalid.
      def get_serial_fields(cl)
        fields = nil
        if (Serializable.is_assignable_from(cl) && !Externalizable.is_assignable_from(cl) && !Proxy.is_proxy_class(cl) && !cl.is_interface)
          if (((fields = get_declared_serial_fields(cl))).nil?)
            fields = get_default_serial_fields(cl)
          end
          Arrays.sort(fields)
        else
          fields = NO_FIELDS
        end
        return fields
      end
      
      typesig { [Class] }
      # Returns serializable fields of given class as defined explicitly by a
      # "serialPersistentFields" field, or null if no appropriate
      # "serialPersistentFields" field is defined.  Serializable fields backed
      # by an actual field of the class are represented by ObjectStreamFields
      # with corresponding non-null Field objects.  For compatibility with past
      # releases, a "serialPersistentFields" field with a null value is
      # considered equivalent to not declaring "serialPersistentFields".  Throws
      # InvalidClassException if the declared serializable fields are
      # invalid--e.g., if multiple fields share the same name.
      def get_declared_serial_fields(cl)
        serial_persistent_fields = nil
        begin
          f = cl.get_declared_field("serialPersistentFields")
          mask = Modifier::PRIVATE | Modifier::STATIC | Modifier::FINAL
          if (((f.get_modifiers & mask)).equal?(mask))
            f.set_accessible(true)
            serial_persistent_fields = f.get(nil)
          end
        rescue JavaException => ex
        end
        if ((serial_persistent_fields).nil?)
          return nil
        else
          if ((serial_persistent_fields.attr_length).equal?(0))
            return NO_FIELDS
          end
        end
        bound_fields = Array.typed(ObjectStreamField).new(serial_persistent_fields.attr_length) { nil }
        field_names = HashSet.new(serial_persistent_fields.attr_length)
        i = 0
        while i < serial_persistent_fields.attr_length
          spf = serial_persistent_fields[i]
          fname = spf.get_name
          if (field_names.contains(fname))
            raise InvalidClassException.new("multiple serializable fields named " + fname)
          end
          field_names.add(fname)
          begin
            f_ = cl.get_declared_field(fname)
            if (((f_.get_type).equal?(spf.get_type)) && (((f_.get_modifiers & Modifier::STATIC)).equal?(0)))
              bound_fields[i] = ObjectStreamField.new(f_, spf.is_unshared, true)
            end
          rescue NoSuchFieldException => ex
          end
          if ((bound_fields[i]).nil?)
            bound_fields[i] = ObjectStreamField.new(fname, spf.get_type, spf.is_unshared)
          end
          i += 1
        end
        return bound_fields
      end
      
      typesig { [Class] }
      # Returns array of ObjectStreamFields corresponding to all non-static
      # non-transient fields declared by given class.  Each ObjectStreamField
      # contains a Field object for the field it represents.  If no default
      # serializable fields exist, NO_FIELDS is returned.
      def get_default_serial_fields(cl)
        cl_fields = cl.get_declared_fields
        list = ArrayList.new
        mask = Modifier::STATIC | Modifier::TRANSIENT
        i = 0
        while i < cl_fields.attr_length
          if (((cl_fields[i].get_modifiers & mask)).equal?(0))
            list.add(ObjectStreamField.new(cl_fields[i], false, true))
          end
          i += 1
        end
        size_ = list.size
        return ((size_).equal?(0)) ? NO_FIELDS : list.to_array(Array.typed(ObjectStreamField).new(size_) { nil })
      end
      
      typesig { [Class] }
      # Returns explicit serial version UID value declared by given class, or
      # null if none.
      def get_declared_suid(cl)
        begin
          f = cl.get_declared_field("serialVersionUID")
          mask = Modifier::STATIC | Modifier::FINAL
          if (((f.get_modifiers & mask)).equal?(mask))
            f.set_accessible(true)
            return Long.value_of(f.get_long(nil))
          end
        rescue JavaException => ex
        end
        return nil
      end
      
      typesig { [Class] }
      # Computes the default serial version UID value for the given class.
      def compute_default_suid(cl)
        if (!Serializable.is_assignable_from(cl) || Proxy.is_proxy_class(cl))
          return 0
        end
        begin
          bout = ByteArrayOutputStream.new
          dout = DataOutputStream.new(bout)
          dout.write_utf(cl.get_name)
          class_mods = cl.get_modifiers & (Modifier::PUBLIC | Modifier::FINAL | Modifier::INTERFACE | Modifier::ABSTRACT)
          # compensate for javac bug in which ABSTRACT bit was set for an
          # interface only if the interface declared methods
          methods = cl.get_declared_methods
          if (!((class_mods & Modifier::INTERFACE)).equal?(0))
            class_mods = (methods.attr_length > 0) ? (class_mods | Modifier::ABSTRACT) : (class_mods & ~Modifier::ABSTRACT)
          end
          dout.write_int(class_mods)
          if (!cl.is_array)
            # compensate for change in 1.2FCS in which
            # Class.getInterfaces() was modified to return Cloneable and
            # Serializable for array classes.
            interfaces = cl.get_interfaces
            iface_names = Array.typed(String).new(interfaces.attr_length) { nil }
            i = 0
            while i < interfaces.attr_length
              iface_names[i] = interfaces[i].get_name
              i += 1
            end
            Arrays.sort(iface_names)
            i_ = 0
            while i_ < iface_names.attr_length
              dout.write_utf(iface_names[i_])
              i_ += 1
            end
          end
          fields = cl.get_declared_fields
          field_sigs = Array.typed(MemberSignature).new(fields.attr_length) { nil }
          i = 0
          while i < fields.attr_length
            field_sigs[i] = MemberSignature.new(fields[i])
            i += 1
          end
          Arrays.sort(field_sigs, Class.new(Comparator.class == Class ? Comparator : Object) do
            extend LocalClass
            include_class_members ObjectStreamClass
            include Comparator if Comparator.class == Module
            
            typesig { [Object, Object] }
            define_method :compare do |o1, o2|
              name1 = (o1).attr_name
              name2 = (o2).attr_name
              return (name1 <=> name2)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          i_ = 0
          while i_ < field_sigs.attr_length
            sig = field_sigs[i_]
            mods = sig.attr_member.get_modifiers & (Modifier::PUBLIC | Modifier::PRIVATE | Modifier::PROTECTED | Modifier::STATIC | Modifier::FINAL | Modifier::VOLATILE | Modifier::TRANSIENT)
            if ((((mods & Modifier::PRIVATE)).equal?(0)) || (((mods & (Modifier::STATIC | Modifier::TRANSIENT))).equal?(0)))
              dout.write_utf(sig.attr_name)
              dout.write_int(mods)
              dout.write_utf(sig.attr_signature)
            end
            i_ += 1
          end
          if (has_static_initializer(cl))
            dout.write_utf("<clinit>")
            dout.write_int(Modifier::STATIC)
            dout.write_utf("()V")
          end
          cons = cl.get_declared_constructors
          cons_sigs = Array.typed(MemberSignature).new(cons.attr_length) { nil }
          i__ = 0
          while i__ < cons.attr_length
            cons_sigs[i__] = MemberSignature.new(cons[i__])
            i__ += 1
          end
          Arrays.sort(cons_sigs, Class.new(Comparator.class == Class ? Comparator : Object) do
            extend LocalClass
            include_class_members ObjectStreamClass
            include Comparator if Comparator.class == Module
            
            typesig { [Object, Object] }
            define_method :compare do |o1, o2|
              sig1 = (o1).attr_signature
              sig2 = (o2).attr_signature
              return (sig1 <=> sig2)
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          i___ = 0
          while i___ < cons_sigs.attr_length
            sig = cons_sigs[i___]
            mods = sig.attr_member.get_modifiers & (Modifier::PUBLIC | Modifier::PRIVATE | Modifier::PROTECTED | Modifier::STATIC | Modifier::FINAL | Modifier::SYNCHRONIZED | Modifier::NATIVE | Modifier::ABSTRACT | Modifier::STRICT)
            if (((mods & Modifier::PRIVATE)).equal?(0))
              dout.write_utf("<init>")
              dout.write_int(mods)
              dout.write_utf(sig.attr_signature.replace(Character.new(?/.ord), Character.new(?..ord)))
            end
            i___ += 1
          end
          meth_sigs = Array.typed(MemberSignature).new(methods.attr_length) { nil }
          i____ = 0
          while i____ < methods.attr_length
            meth_sigs[i____] = MemberSignature.new(methods[i____])
            i____ += 1
          end
          Arrays.sort(meth_sigs, Class.new(Comparator.class == Class ? Comparator : Object) do
            extend LocalClass
            include_class_members ObjectStreamClass
            include Comparator if Comparator.class == Module
            
            typesig { [Object, Object] }
            define_method :compare do |o1, o2|
              ms1 = o1
              ms2 = o2
              comp = (ms1.attr_name <=> ms2.attr_name)
              if ((comp).equal?(0))
                comp = (ms1.attr_signature <=> ms2.attr_signature)
              end
              return comp
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
          i_____ = 0
          while i_____ < meth_sigs.attr_length
            sig = meth_sigs[i_____]
            mods = sig.attr_member.get_modifiers & (Modifier::PUBLIC | Modifier::PRIVATE | Modifier::PROTECTED | Modifier::STATIC | Modifier::FINAL | Modifier::SYNCHRONIZED | Modifier::NATIVE | Modifier::ABSTRACT | Modifier::STRICT)
            if (((mods & Modifier::PRIVATE)).equal?(0))
              dout.write_utf(sig.attr_name)
              dout.write_int(mods)
              dout.write_utf(sig.attr_signature.replace(Character.new(?/.ord), Character.new(?..ord)))
            end
            i_____ += 1
          end
          dout.flush
          md = MessageDigest.get_instance("SHA")
          hash_bytes = md.digest(bout.to_byte_array)
          hash = 0
          i______ = Math.min(hash_bytes.attr_length, 8) - 1
          while i______ >= 0
            hash = (hash << 8) | (hash_bytes[i______] & 0xff)
            i______ -= 1
          end
          return hash
        rescue IOException => ex
          raise InternalError.new
        rescue NoSuchAlgorithmException => ex
          raise SecurityException.new(ex.get_message)
        end
      end
      
      JNI.native_method :Java_java_io_ObjectStreamClass_hasStaticInitializer, [:pointer, :long, :long], :int8
      typesig { [Class] }
      # Returns true if the given class defines a static initializer method,
      # false otherwise.
      def has_static_initializer(cl)
        JNI.__send__(:Java_java_io_ObjectStreamClass_hasStaticInitializer, JNI.env, self.jni_id, cl.jni_id) != 0
      end
      
      # Class for computing and caching field/constructor/method signatures
      # during serialVersionUID calculation.
      const_set_lazy(:MemberSignature) { Class.new do
        include_class_members ObjectStreamClass
        
        attr_accessor :member
        alias_method :attr_member, :member
        undef_method :member
        alias_method :attr_member=, :member=
        undef_method :member=
        
        attr_accessor :name
        alias_method :attr_name, :name
        undef_method :name
        alias_method :attr_name=, :name=
        undef_method :name=
        
        attr_accessor :signature
        alias_method :attr_signature, :signature
        undef_method :signature
        alias_method :attr_signature=, :signature=
        undef_method :signature=
        
        typesig { [class_self::Field] }
        def initialize(field)
          @member = nil
          @name = nil
          @signature = nil
          @member = field
          @name = RJava.cast_to_string(field.get_name)
          @signature = RJava.cast_to_string(get_class_signature(field.get_type))
        end
        
        typesig { [class_self::Constructor] }
        def initialize(cons)
          @member = nil
          @name = nil
          @signature = nil
          @member = cons
          @name = RJava.cast_to_string(cons.get_name)
          @signature = RJava.cast_to_string(get_method_signature(cons.get_parameter_types, Void::TYPE))
        end
        
        typesig { [class_self::Method] }
        def initialize(meth)
          @member = nil
          @name = nil
          @signature = nil
          @member = meth
          @name = RJava.cast_to_string(meth.get_name)
          @signature = RJava.cast_to_string(get_method_signature(meth.get_parameter_types, meth.get_return_type))
        end
        
        private
        alias_method :initialize__member_signature, :initialize
      end }
      
      # Class for setting and retrieving serializable field values in batch.
      # 
      # REMIND: dynamically generate these?
      const_set_lazy(:FieldReflector) { Class.new do
        include_class_members ObjectStreamClass
        
        class_module.module_eval {
          # handle for performing unsafe operations
          const_set_lazy(:UnsafeInstance) { Unsafe.get_unsafe }
          const_attr_reader  :UnsafeInstance
        }
        
        # fields to operate on
        attr_accessor :fields
        alias_method :attr_fields, :fields
        undef_method :fields
        alias_method :attr_fields=, :fields=
        undef_method :fields=
        
        # number of primitive fields
        attr_accessor :num_prim_fields
        alias_method :attr_num_prim_fields, :num_prim_fields
        undef_method :num_prim_fields
        alias_method :attr_num_prim_fields=, :num_prim_fields=
        undef_method :num_prim_fields=
        
        # unsafe field keys
        attr_accessor :keys
        alias_method :attr_keys, :keys
        undef_method :keys
        alias_method :attr_keys=, :keys=
        undef_method :keys=
        
        # field data offsets
        attr_accessor :offsets
        alias_method :attr_offsets, :offsets
        undef_method :offsets
        alias_method :attr_offsets=, :offsets=
        undef_method :offsets=
        
        # field type codes
        attr_accessor :type_codes
        alias_method :attr_type_codes, :type_codes
        undef_method :type_codes
        alias_method :attr_type_codes=, :type_codes=
        undef_method :type_codes=
        
        # field types
        attr_accessor :types
        alias_method :attr_types, :types
        undef_method :types
        alias_method :attr_types=, :types=
        undef_method :types=
        
        typesig { [Array.typed(class_self::ObjectStreamField)] }
        # Constructs FieldReflector capable of setting/getting values from the
        # subset of fields whose ObjectStreamFields contain non-null
        # reflective Field objects.  ObjectStreamFields with null Fields are
        # treated as filler, for which get operations return default values
        # and set operations discard given values.
        def initialize(fields)
          @fields = nil
          @num_prim_fields = 0
          @keys = nil
          @offsets = nil
          @type_codes = nil
          @types = nil
          @fields = fields
          nfields = fields.attr_length
          @keys = Array.typed(::Java::Long).new(nfields) { 0 }
          @offsets = Array.typed(::Java::Int).new(nfields) { 0 }
          @type_codes = CharArray.new(nfields)
          type_list = self.class::ArrayList.new
          i = 0
          while i < nfields
            f = fields[i]
            rf = f.get_field
            @keys[i] = (!(rf).nil?) ? self.class::UnsafeInstance.object_field_offset(rf) : Unsafe::INVALID_FIELD_OFFSET
            @offsets[i] = f.get_offset
            @type_codes[i] = f.get_type_code
            if (!f.is_primitive)
              type_list.add((!(rf).nil?) ? rf.get_type : nil)
            end
            i += 1
          end
          @types = type_list.to_array(Array.typed(self.class::Class).new(type_list.size) { nil })
          @num_prim_fields = nfields - @types.attr_length
        end
        
        typesig { [] }
        # Returns list of ObjectStreamFields representing fields operated on
        # by this reflector.  The shared/unshared values and Field objects
        # contained by ObjectStreamFields in the list reflect their bindings
        # to locally defined serializable fields.
        def get_fields
          return @fields
        end
        
        typesig { [Object, Array.typed(::Java::Byte)] }
        # Fetches the serializable primitive field values of object obj and
        # marshals them into byte array buf starting at offset 0.  The caller
        # is responsible for ensuring that obj is of the proper type.
        def get_prim_field_values(obj, buf)
          if ((obj).nil?)
            raise self.class::NullPointerException.new
          end
          # assuming checkDefaultSerialize() has been called on the class
          # descriptor this FieldReflector was obtained from, no field keys
          # in array should be equal to Unsafe.INVALID_FIELD_OFFSET.
          i = 0
          while i < @num_prim_fields
            key = @keys[i]
            off = @offsets[i]
            case (@type_codes[i])
            when Character.new(?Z.ord)
              Bits.put_boolean(buf, off, self.class::UnsafeInstance.get_boolean(obj, key))
            when Character.new(?B.ord)
              buf[off] = self.class::UnsafeInstance.get_byte(obj, key)
            when Character.new(?C.ord)
              Bits.put_char(buf, off, self.class::UnsafeInstance.get_char(obj, key))
            when Character.new(?S.ord)
              Bits.put_short(buf, off, self.class::UnsafeInstance.get_short(obj, key))
            when Character.new(?I.ord)
              Bits.put_int(buf, off, self.class::UnsafeInstance.get_int(obj, key))
            when Character.new(?F.ord)
              Bits.put_float(buf, off, self.class::UnsafeInstance.get_float(obj, key))
            when Character.new(?J.ord)
              Bits.put_long(buf, off, self.class::UnsafeInstance.get_long(obj, key))
            when Character.new(?D.ord)
              Bits.put_double(buf, off, self.class::UnsafeInstance.get_double(obj, key))
            else
              raise self.class::InternalError.new
            end
            i += 1
          end
        end
        
        typesig { [Object, Array.typed(::Java::Byte)] }
        # Sets the serializable primitive fields of object obj using values
        # unmarshalled from byte array buf starting at offset 0.  The caller
        # is responsible for ensuring that obj is of the proper type.
        def set_prim_field_values(obj, buf)
          if ((obj).nil?)
            raise self.class::NullPointerException.new
          end
          i = 0
          while i < @num_prim_fields
            key = @keys[i]
            if ((key).equal?(Unsafe::INVALID_FIELD_OFFSET))
              i += 1
              next # discard value
            end
            off = @offsets[i]
            case (@type_codes[i])
            when Character.new(?Z.ord)
              self.class::UnsafeInstance.put_boolean(obj, key, Bits.get_boolean(buf, off))
            when Character.new(?B.ord)
              self.class::UnsafeInstance.put_byte(obj, key, buf[off])
            when Character.new(?C.ord)
              self.class::UnsafeInstance.put_char(obj, key, Bits.get_char(buf, off))
            when Character.new(?S.ord)
              self.class::UnsafeInstance.put_short(obj, key, Bits.get_short(buf, off))
            when Character.new(?I.ord)
              self.class::UnsafeInstance.put_int(obj, key, Bits.get_int(buf, off))
            when Character.new(?F.ord)
              self.class::UnsafeInstance.put_float(obj, key, Bits.get_float(buf, off))
            when Character.new(?J.ord)
              self.class::UnsafeInstance.put_long(obj, key, Bits.get_long(buf, off))
            when Character.new(?D.ord)
              self.class::UnsafeInstance.put_double(obj, key, Bits.get_double(buf, off))
            else
              raise self.class::InternalError.new
            end
            i += 1
          end
        end
        
        typesig { [Object, Array.typed(Object)] }
        # Fetches the serializable object field values of object obj and
        # stores them in array vals starting at offset 0.  The caller is
        # responsible for ensuring that obj is of the proper type.
        def get_obj_field_values(obj, vals)
          if ((obj).nil?)
            raise self.class::NullPointerException.new
          end
          # assuming checkDefaultSerialize() has been called on the class
          # descriptor this FieldReflector was obtained from, no field keys
          # in array should be equal to Unsafe.INVALID_FIELD_OFFSET.
          i = @num_prim_fields
          while i < @fields.attr_length
            case (@type_codes[i])
            when Character.new(?L.ord), Character.new(?[.ord)
              vals[@offsets[i]] = self.class::UnsafeInstance.get_object(obj, @keys[i])
            else
              raise self.class::InternalError.new
            end
            i += 1
          end
        end
        
        typesig { [Object, Array.typed(Object)] }
        # Sets the serializable object fields of object obj using values from
        # array vals starting at offset 0.  The caller is responsible for
        # ensuring that obj is of the proper type; however, attempts to set a
        # field with a value of the wrong type will trigger an appropriate
        # ClassCastException.
        def set_obj_field_values(obj, vals)
          if ((obj).nil?)
            raise self.class::NullPointerException.new
          end
          i = @num_prim_fields
          while i < @fields.attr_length
            key = @keys[i]
            if ((key).equal?(Unsafe::INVALID_FIELD_OFFSET))
              i += 1
              next # discard value
            end
            case (@type_codes[i])
            when Character.new(?L.ord), Character.new(?[.ord)
              val = vals[@offsets[i]]
              if (!(val).nil? && !@types[i - @num_prim_fields].is_instance(val))
                f = @fields[i].get_field
                raise self.class::ClassCastException.new("cannot assign instance of " + RJava.cast_to_string(val.get_class.get_name) + " to field " + RJava.cast_to_string(f.get_declaring_class.get_name) + "." + RJava.cast_to_string(f.get_name) + " of type " + RJava.cast_to_string(f.get_type.get_name) + " in instance of " + RJava.cast_to_string(obj.get_class.get_name))
              end
              self.class::UnsafeInstance.put_object(obj, key, val)
            else
              raise self.class::InternalError.new
            end
            i += 1
          end
        end
        
        private
        alias_method :initialize__field_reflector, :initialize
      end }
      
      typesig { [Array.typed(ObjectStreamField), ObjectStreamClass] }
      # Matches given set of serializable fields with serializable fields
      # described by the given local class descriptor, and returns a
      # FieldReflector instance capable of setting/getting values from the
      # subset of fields that match (non-matching fields are treated as filler,
      # for which get operations return default values and set operations
      # discard given values).  Throws InvalidClassException if unresolvable
      # type conflicts exist between the two sets of fields.
      def get_reflector(fields, local_desc)
        # class irrelevant if no fields
        cl = (!(local_desc).nil? && fields.attr_length > 0) ? local_desc.attr_cl : nil
        process_queue(Caches.attr_reflectors_queue, Caches.attr_reflectors)
        key = FieldReflectorKey.new(cl, fields, Caches.attr_reflectors_queue)
        ref = Caches.attr_reflectors.get(key)
        entry = nil
        if (!(ref).nil?)
          entry = ref.get
        end
        future = nil
        if ((entry).nil?)
          new_entry = EntryFuture.new
          new_ref = SoftReference.new(new_entry)
          begin
            if (!(ref).nil?)
              Caches.attr_reflectors.remove(key, ref)
            end
            ref = Caches.attr_reflectors.put_if_absent(key, new_ref)
            if (!(ref).nil?)
              entry = ref.get
            end
          end while (!(ref).nil? && (entry).nil?)
          if ((entry).nil?)
            future = new_entry
          end
        end
        if (entry.is_a?(FieldReflector))
          # check common case first
          return entry
        else
          if (entry.is_a?(EntryFuture))
            entry = (entry).get
          else
            if ((entry).nil?)
              begin
                entry = FieldReflector.new(match_fields(fields, local_desc))
              rescue JavaThrowable => th
                entry = th
              end
              future.set(entry)
              Caches.attr_reflectors.put(key, SoftReference.new(entry))
            end
          end
        end
        if (entry.is_a?(FieldReflector))
          return entry
        else
          if (entry.is_a?(InvalidClassException))
            raise entry
          else
            if (entry.is_a?(RuntimeException))
              raise entry
            else
              if (entry.is_a?(JavaError))
                raise entry
              else
                raise InternalError.new("unexpected entry: " + RJava.cast_to_string(entry))
              end
            end
          end
        end
      end
      
      # FieldReflector cache lookup key.  Keys are considered equal if they
      # refer to the same class and equivalent field formats.
      const_set_lazy(:FieldReflectorKey) { Class.new(WeakReference) do
        include_class_members ObjectStreamClass
        
        attr_accessor :sigs
        alias_method :attr_sigs, :sigs
        undef_method :sigs
        alias_method :attr_sigs=, :sigs=
        undef_method :sigs=
        
        attr_accessor :hash
        alias_method :attr_hash, :hash
        undef_method :hash
        alias_method :attr_hash=, :hash=
        undef_method :hash=
        
        attr_accessor :null_class
        alias_method :attr_null_class, :null_class
        undef_method :null_class
        alias_method :attr_null_class=, :null_class=
        undef_method :null_class=
        
        typesig { [class_self::Class, Array.typed(class_self::ObjectStreamField), class_self::ReferenceQueue] }
        def initialize(cl, fields, queue)
          @sigs = nil
          @hash = 0
          @null_class = false
          super(cl, queue)
          @null_class = ((cl).nil?)
          sbuf = self.class::StringBuilder.new
          i = 0
          while i < fields.attr_length
            f = fields[i]
            sbuf.append(f.get_name).append(f.get_signature)
            i += 1
          end
          @sigs = RJava.cast_to_string(sbuf.to_s)
          @hash = System.identity_hash_code(cl) + @sigs.hash_code
        end
        
        typesig { [] }
        def hash_code
          return @hash
        end
        
        typesig { [Object] }
        def ==(obj)
          if ((obj).equal?(self))
            return true
          end
          if (obj.is_a?(self.class::FieldReflectorKey))
            other = obj
            referent = nil
            return (@null_class ? other.attr_null_class : (!((referent = get)).nil?) && ((referent).equal?(other.get))) && (@sigs == other.attr_sigs)
          else
            return false
          end
        end
        
        private
        alias_method :initialize__field_reflector_key, :initialize
      end }
      
      typesig { [Array.typed(ObjectStreamField), ObjectStreamClass] }
      # Matches given set of serializable fields with serializable fields
      # obtained from the given local class descriptor (which contain bindings
      # to reflective Field objects).  Returns list of ObjectStreamFields in
      # which each ObjectStreamField whose signature matches that of a local
      # field contains a Field object for that field; unmatched
      # ObjectStreamFields contain null Field objects.  Shared/unshared settings
      # of the returned ObjectStreamFields also reflect those of matched local
      # ObjectStreamFields.  Throws InvalidClassException if unresolvable type
      # conflicts exist between the two sets of fields.
      def match_fields(fields, local_desc)
        local_fields = (!(local_desc).nil?) ? local_desc.attr_fields : NO_FIELDS
        # Even if fields == localFields, we cannot simply return localFields
        # here.  In previous implementations of serialization,
        # ObjectStreamField.getType() returned Object.class if the
        # ObjectStreamField represented a non-primitive field and belonged to
        # a non-local class descriptor.  To preserve this (questionable)
        # behavior, the ObjectStreamField instances returned by matchFields
        # cannot report non-primitive types other than Object.class; hence
        # localFields cannot be returned directly.
        matches = Array.typed(ObjectStreamField).new(fields.attr_length) { nil }
        i = 0
        while i < fields.attr_length
          f = fields[i]
          m = nil
          j = 0
          while j < local_fields.attr_length
            lf = local_fields[j]
            if ((f.get_name == lf.get_name))
              if ((f.is_primitive || lf.is_primitive) && !(f.get_type_code).equal?(lf.get_type_code))
                raise InvalidClassException.new(local_desc.attr_name, "incompatible types for field " + RJava.cast_to_string(f.get_name))
              end
              if (!(lf.get_field).nil?)
                m = ObjectStreamField.new(lf.get_field, lf.is_unshared, false)
              else
                m = ObjectStreamField.new(lf.get_name, lf.get_signature, lf.is_unshared)
              end
            end
            j += 1
          end
          if ((m).nil?)
            m = ObjectStreamField.new(f.get_name, f.get_signature, false)
          end
          m.set_offset(f.get_offset)
          matches[i] = m
          i += 1
        end
        return matches
      end
      
      typesig { [ReferenceQueue, ConcurrentMap] }
      # Removes from the specified map any keys that have been enqueued
      # on the specified reference queue.
      def process_queue(queue, map)
        ref = nil
        while (!((ref = queue.poll)).nil?)
          map.remove(ref)
        end
      end
      
      # Weak key for Class objects.
      const_set_lazy(:WeakClassKey) { Class.new(WeakReference) do
        include_class_members ObjectStreamClass
        
        # saved value of the referent's identity hash code, to maintain
        # a consistent hash code after the referent has been cleared
        attr_accessor :hash
        alias_method :attr_hash, :hash
        undef_method :hash
        alias_method :attr_hash=, :hash=
        undef_method :hash=
        
        typesig { [class_self::Class, class_self::ReferenceQueue] }
        # Create a new WeakClassKey to the given object, registered
        # with a queue.
        def initialize(cl, ref_queue)
          @hash = 0
          super(cl, ref_queue)
          @hash = System.identity_hash_code(cl)
        end
        
        typesig { [] }
        # Returns the identity hash code of the original referent.
        def hash_code
          return @hash
        end
        
        typesig { [Object] }
        # Returns true if the given object is this identical
        # WeakClassKey instance, or, if this object's referent has not
        # been cleared, if the given object is another WeakClassKey
        # instance with the identical non-null referent as this one.
        def ==(obj)
          if ((obj).equal?(self))
            return true
          end
          if (obj.is_a?(self.class::WeakClassKey))
            referent = get
            return (!(referent).nil?) && ((referent).equal?((obj).get))
          else
            return false
          end
        end
        
        private
        alias_method :initialize__weak_class_key, :initialize
      end }
    }
    
    private
    alias_method :initialize__object_stream_class, :initialize
  end
  
end
