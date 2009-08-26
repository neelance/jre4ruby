require "rjava"

# Copyright 2005-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect::Misc
  module MethodUtilImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Misc
      include_const ::Java::Security, :AllPermission
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PermissionCollection
      include_const ::Java::Security, :SecureClassLoader
      include_const ::Java::Security, :PrivilegedExceptionAction
      include_const ::Java::Security, :CodeSource
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :BufferedInputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Net, :URL
      include_const ::Java::Net, :URLConnection
      include_const ::Java::Net, :HttpURLConnection
      include_const ::Java::Lang::Reflect, :Method
      include_const ::Java::Lang::Reflect, :InvocationTargetException
      include_const ::Java::Lang::Reflect, :AccessibleObject
      include_const ::Java::Lang::Reflect, :Modifier
      include_const ::Java::Util, :Collection
      include_const ::Java::Util, :HashMap
      include_const ::Java::Util, :Map
      include_const ::Sun::Net::Www, :ParseUtil
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  class Trampoline 
    include_class_members MethodUtilImports
    
    class_module.module_eval {
      typesig { [Method, Object, Array.typed(Object)] }
      def invoke(m, obj, params)
        return m.invoke(obj, params)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__trampoline, :initialize
  end
  
  # Create a trampoline class.
  class MethodUtil < MethodUtilImports.const_get :SecureClassLoader
    include_class_members MethodUtilImports
    
    class_module.module_eval {
      
      def misc_pkg
        defined?(@@misc_pkg) ? @@misc_pkg : @@misc_pkg= "sun.reflect.misc."
      end
      alias_method :attr_misc_pkg, :misc_pkg
      
      def misc_pkg=(value)
        @@misc_pkg = value
      end
      alias_method :attr_misc_pkg=, :misc_pkg=
      
      
      def trampoline
        defined?(@@trampoline) ? @@trampoline : @@trampoline= self.attr_misc_pkg + "Trampoline"
      end
      alias_method :attr_trampoline, :trampoline
      
      def trampoline=(value)
        @@trampoline = value
      end
      alias_method :attr_trampoline=, :trampoline=
      
      
      def bounce
        defined?(@@bounce) ? @@bounce : @@bounce= get_trampoline
      end
      alias_method :attr_bounce, :bounce
      
      def bounce=(value)
        @@bounce = value
      end
      alias_method :attr_bounce=, :bounce=
    }
    
    typesig { [] }
    def initialize
      super()
    end
    
    class_module.module_eval {
      typesig { [Class, String, Array.typed(Class)] }
      def get_method(cls, name, args)
        ReflectUtil.check_package_access(cls)
        return cls.get_method(name, args)
      end
      
      typesig { [Class] }
      def get_methods(cls)
        ReflectUtil.check_package_access(cls)
        return cls.get_methods
      end
      
      typesig { [Class] }
      # Discover the public methods on public classes
      # and interfaces accessible to any caller by calling
      # Class.getMethods() and walking towards Object until
      # we're done.
      def get_public_methods(cls)
        # compatibility for update release
        if ((System.get_security_manager).nil?)
          return cls.get_methods
        end
        sigs = HashMap.new
        while (!(cls).nil?)
          done = get_internal_public_methods(cls, sigs)
          if (done)
            break
          end
          get_interface_methods(cls, sigs)
          cls = cls.get_superclass
        end
        c = sigs.values
        return c.to_array(Array.typed(Method).new(c.size) { nil })
      end
      
      typesig { [Class, Map] }
      # Process the immediate interfaces of this class or interface.
      def get_interface_methods(cls, sigs)
        intfs = cls.get_interfaces
        i = 0
        while i < intfs.attr_length
          intf = intfs[i]
          done = get_internal_public_methods(intf, sigs)
          if (!done)
            get_interface_methods(intf, sigs)
          end
          i += 1
        end
      end
      
      typesig { [Class, Map] }
      # Process the methods in this class or interface
      def get_internal_public_methods(cls, sigs)
        methods = nil
        begin
          # This class or interface is non-public so we
          # can't use any of it's methods. Go back and
          # try again with a superclass or superinterface.
          if (!Modifier.is_public(cls.get_modifiers))
            return false
          end
          if (!ReflectUtil.is_package_accessible(cls))
            return false
          end
          methods = cls.get_methods
        rescue SecurityException => se
          return false
        end
        # Check for inherited methods with non-public
        # declaring classes. They might override and hide
        # methods from their superclasses or
        # superinterfaces.
        done = true
        i = 0
        while i < methods.attr_length
          dc = methods[i].get_declaring_class
          if (!Modifier.is_public(dc.get_modifiers))
            done = false
            break
          end
          i += 1
        end
        if (done)
          # We're done. Spray all the methods into
          # the list and then we're out of here.
          i_ = 0
          while i_ < methods.attr_length
            add_method(sigs, methods[i_])
            i_ += 1
          end
        else
          # Simulate cls.getDeclaredMethods() by
          # stripping away inherited methods.
          i_ = 0
          while i_ < methods.attr_length
            dc = methods[i_].get_declaring_class
            if ((cls == dc))
              add_method(sigs, methods[i_])
            end
            i_ += 1
          end
        end
        return done
      end
      
      typesig { [Map, Method] }
      def add_method(sigs, method)
        signature = Signature.new(method)
        if (!sigs.contains_key(signature))
          sigs.put(signature, method)
        else
          if (!method.get_declaring_class.is_interface)
            # Superclasses beat interfaces.
            old = sigs.get(signature)
            if (old.get_declaring_class.is_interface)
              sigs.put(signature, method)
            end
          end
        end
      end
      
      # A class that represents the unique elements of a method that will be a
      # key in the method cache.
      const_set_lazy(:Signature) { Class.new do
        include_class_members MethodUtil
        
        attr_accessor :method_name
        alias_method :attr_method_name, :method_name
        undef_method :method_name
        alias_method :attr_method_name=, :method_name=
        undef_method :method_name=
        
        attr_accessor :arg_classes
        alias_method :attr_arg_classes, :arg_classes
        undef_method :arg_classes
        alias_method :attr_arg_classes=, :arg_classes=
        undef_method :arg_classes=
        
        attr_accessor :hash_code
        alias_method :attr_hash_code, :hash_code
        undef_method :hash_code
        alias_method :attr_hash_code=, :hash_code=
        undef_method :hash_code=
        
        typesig { [self::Method] }
        def initialize(m)
          @method_name = nil
          @arg_classes = nil
          @hash_code = 0
          @method_name = m.get_name
          @arg_classes = m.get_parameter_types
        end
        
        typesig { [self::Object] }
        def ==(o2)
          if ((self).equal?(o2))
            return true
          end
          that = o2
          if (!((@method_name == that.attr_method_name)))
            return false
          end
          if (!(@arg_classes.attr_length).equal?(that.attr_arg_classes.attr_length))
            return false
          end
          i = 0
          while i < @arg_classes.attr_length
            if (!((@arg_classes[i]).equal?(that.attr_arg_classes[i])))
              return false
            end
            i += 1
          end
          return true
        end
        
        typesig { [] }
        # Hash code computed using algorithm suggested in
        # Effective Java, Item 8.
        def hash_code
          if ((@hash_code).equal?(0))
            result = 17
            result = 37 * result + @method_name.hash_code
            if (!(@arg_classes).nil?)
              i = 0
              while i < @arg_classes.attr_length
                result = 37 * result + (((@arg_classes[i]).nil?) ? 0 : @arg_classes[i].hash_code)
                i += 1
              end
            end
            @hash_code = result
          end
          return @hash_code
        end
        
        private
        alias_method :initialize__signature, :initialize
      end }
      
      typesig { [Method, Object, Array.typed(Object)] }
      # Bounce through the trampoline.
      def invoke(m, obj, params)
        if ((m.get_declaring_class == AccessController) || (m.get_declaring_class == Method))
          raise InvocationTargetException.new(UnsupportedOperationException.new("invocation not supported"))
        end
        begin
          return self.attr_bounce.invoke(nil, Array.typed(Object).new([m, obj, params]))
        rescue InvocationTargetException => ie
          t = ie.get_cause
          if (t.is_a?(InvocationTargetException))
            raise t
          else
            if (t.is_a?(IllegalAccessException))
              raise t
            else
              if (t.is_a?(RuntimeException))
                raise t
              else
                if (t.is_a?(JavaError))
                  raise t
                else
                  raise JavaError.new("Unexpected invocation error", t)
                end
              end
            end
          end
        rescue IllegalAccessException => iae
          # this can't happen
          raise JavaError.new("Unexpected invocation error", iae)
        end
      end
      
      typesig { [] }
      def get_trampoline
        tramp = nil
        begin
          tramp = AccessController.do_privileged(Class.new(PrivilegedExceptionAction.class == Class ? PrivilegedExceptionAction : Object) do
            extend LocalClass
            include_class_members MethodUtil
            include PrivilegedExceptionAction if PrivilegedExceptionAction.class == Module
            
            typesig { [] }
            define_method :run do
              types = nil
              t = get_trampoline_class
              b = nil
              types = Array.typed(self.class::Class).new([Method, Object, Array[]])
              b = t.get_declared_method("invoke", types)
              (b).set_accessible(true)
              return b
            end
            
            typesig { [] }
            define_method :initialize do
              super()
            end
            
            private
            alias_method :initialize_anonymous, :initialize
          end.new_local(self))
        rescue JavaException => e
          raise InternalError.new("bouncer cannot be found")
        end
        return tramp
      end
    }
    
    typesig { [String, ::Java::Boolean] }
    def load_class(name, resolve)
      synchronized(self) do
        # First, check if the class has already been loaded
        ReflectUtil.check_package_access(name)
        c = find_loaded_class(name)
        if ((c).nil?)
          begin
            c = find_class(name)
          rescue ClassNotFoundException => e
            # Fall through ...
          end
          if ((c).nil?)
            c = get_parent.load_class(name)
          end
        end
        if (resolve)
          resolve_class(c)
        end
        return c
      end
    end
    
    typesig { [String] }
    def find_class(name)
      if (!name.starts_with(self.attr_misc_pkg))
        raise ClassNotFoundException.new(name)
      end
      path = name.replace(Character.new(?..ord), Character.new(?/.ord)).concat(".class")
      res = get_resource(path)
      if (!(res).nil?)
        begin
          return define_class(name, res)
        rescue IOException => e
          raise ClassNotFoundException.new(name, e)
        end
      else
        raise ClassNotFoundException.new(name)
      end
    end
    
    typesig { [String, URL] }
    # Define the proxy classes
    def define_class(name, url)
      b = get_bytes(url)
      cs = CodeSource.new(nil, nil)
      if (!(name == self.attr_trampoline))
        raise IOException.new("MethodUtil: bad name " + name)
      end
      return define_class(name, b, 0, b.attr_length, cs)
    end
    
    class_module.module_eval {
      typesig { [URL] }
      # Returns the contents of the specified URL as an array of bytes.
      def get_bytes(url)
        uc = url.open_connection
        if (uc.is_a?(Java::Net::HttpURLConnection))
          huc = uc
          code = huc.get_response_code
          if (code >= Java::Net::HttpURLConnection::HTTP_BAD_REQUEST)
            raise IOException.new("open HTTP connection failed.")
          end
        end
        len = uc.get_content_length
        in_ = BufferedInputStream.new(uc.get_input_stream)
        b = nil
        begin
          if (!(len).equal?(-1))
            # Read exactly len bytes from the input stream
            b = Array.typed(::Java::Byte).new(len) { 0 }
            while (len > 0)
              n = in_.read(b, b.attr_length - len, len)
              if ((n).equal?(-1))
                raise IOException.new("unexpected EOF")
              end
              len -= n
            end
          else
            b = Array.typed(::Java::Byte).new(8192) { 0 }
            total = 0
            while (!((len = in_.read(b, total, b.attr_length - total))).equal?(-1))
              total += len
              if (total >= b.attr_length)
                tmp = Array.typed(::Java::Byte).new(total * 2) { 0 }
                System.arraycopy(b, 0, tmp, 0, total)
                b = tmp
              end
            end
            # Trim array to correct size, if necessary
            if (!(total).equal?(b.attr_length))
              tmp = Array.typed(::Java::Byte).new(total) { 0 }
              System.arraycopy(b, 0, tmp, 0, total)
              b = tmp
            end
          end
        ensure
          in_.close
        end
        return b
      end
    }
    
    typesig { [CodeSource] }
    def get_permissions(codesource)
      perms = super(codesource)
      perms.add(AllPermission.new)
      return perms
    end
    
    class_module.module_eval {
      typesig { [] }
      def get_trampoline_class
        begin
          return Class.for_name(self.attr_trampoline, true, MethodUtil.new)
        rescue ClassNotFoundException => e
        end
        return nil
      end
    }
    
    private
    alias_method :initialize__method_util, :initialize
  end
  
end
