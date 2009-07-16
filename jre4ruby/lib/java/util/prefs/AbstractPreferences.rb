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
module Java::Util::Prefs
  module AbstractPreferencesImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Prefs
      include ::Java::Util
      include ::Java::Io
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Lang, :JavaInteger
      include_const ::Java::Lang, :Long
      include_const ::Java::Lang, :Float
      include_const ::Java::Lang, :Double
    }
  end
  
  # These imports needed only as a workaround for a JavaDoc bug
  # 
  # This class provides a skeletal implementation of the {@link Preferences}
  # class, greatly easing the task of implementing it.
  # 
  # <p><strong>This class is for <tt>Preferences</tt> implementers only.
  # Normal users of the <tt>Preferences</tt> facility should have no need to
  # consult this documentation.  The {@link Preferences} documentation
  # should suffice.</strong>
  # 
  # <p>Implementors must override the nine abstract service-provider interface
  # (SPI) methods: {@link #getSpi(String)}, {@link #putSpi(String,String)},
  # {@link #removeSpi(String)}, {@link #childSpi(String)}, {@link
  # #removeNodeSpi()}, {@link #keysSpi()}, {@link #childrenNamesSpi()}, {@link
  # #syncSpi()} and {@link #flushSpi()}.  All of the concrete methods specify
  # precisely how they are implemented atop these SPI methods.  The implementor
  # may, at his discretion, override one or more of the concrete methods if the
  # default implementation is unsatisfactory for any reason, such as
  # performance.
  # 
  # <p>The SPI methods fall into three groups concerning exception
  # behavior. The <tt>getSpi</tt> method should never throw exceptions, but it
  # doesn't really matter, as any exception thrown by this method will be
  # intercepted by {@link #get(String,String)}, which will return the specified
  # default value to the caller.  The <tt>removeNodeSpi, keysSpi,
  # childrenNamesSpi, syncSpi</tt> and <tt>flushSpi</tt> methods are specified
  # to throw {@link BackingStoreException}, and the implementation is required
  # to throw this checked exception if it is unable to perform the operation.
  # The exception propagates outward, causing the corresponding API method
  # to fail.
  # 
  # <p>The remaining SPI methods {@link #putSpi(String,String)}, {@link
  # #removeSpi(String)} and {@link #childSpi(String)} have more complicated
  # exception behavior.  They are not specified to throw
  # <tt>BackingStoreException</tt>, as they can generally obey their contracts
  # even if the backing store is unavailable.  This is true because they return
  # no information and their effects are not required to become permanent until
  # a subsequent call to {@link Preferences#flush()} or
  # {@link Preferences#sync()}. Generally speaking, these SPI methods should not
  # throw exceptions.  In some implementations, there may be circumstances
  # under which these calls cannot even enqueue the requested operation for
  # later processing.  Even under these circumstances it is generally better to
  # simply ignore the invocation and return, rather than throwing an
  # exception.  Under these circumstances, however, all subsequent invocations
  # of <tt>flush()</tt> and <tt>sync</tt> should return <tt>false</tt>, as
  # returning <tt>true</tt> would imply that all previous operations had
  # successfully been made permanent.
  # 
  # <p>There is one circumstance under which <tt>putSpi, removeSpi and
  # childSpi</tt> <i>should</i> throw an exception: if the caller lacks
  # sufficient privileges on the underlying operating system to perform the
  # requested operation.  This will, for instance, occur on most systems
  # if a non-privileged user attempts to modify system preferences.
  # (The required privileges will vary from implementation to
  # implementation.  On some implementations, they are the right to modify the
  # contents of some directory in the file system; on others they are the right
  # to modify contents of some key in a registry.)  Under any of these
  # circumstances, it would generally be undesirable to let the program
  # continue executing as if these operations would become permanent at a later
  # time.  While implementations are not required to throw an exception under
  # these circumstances, they are encouraged to do so.  A {@link
  # SecurityException} would be appropriate.
  # 
  # <p>Most of the SPI methods require the implementation to read or write
  # information at a preferences node.  The implementor should beware of the
  # fact that another VM may have concurrently deleted this node from the
  # backing store.  It is the implementation's responsibility to recreate the
  # node if it has been deleted.
  # 
  # <p>Implementation note: In Sun's default <tt>Preferences</tt>
  # implementations, the user's identity is inherited from the underlying
  # operating system and does not change for the lifetime of the virtual
  # machine.  It is recognized that server-side <tt>Preferences</tt>
  # implementations may have the user identity change from request to request,
  # implicitly passed to <tt>Preferences</tt> methods via the use of a
  # static {@link ThreadLocal} instance.  Authors of such implementations are
  # <i>strongly</i> encouraged to determine the user at the time preferences
  # are accessed (for example by the {@link #get(String,String)} or {@link
  # #put(String,String)} method) rather than permanently associating a user
  # with each <tt>Preferences</tt> instance.  The latter behavior conflicts
  # with normal <tt>Preferences</tt> usage and would lead to great confusion.
  # 
  # @author  Josh Bloch
  # @see     Preferences
  # @since   1.4
  class AbstractPreferences < AbstractPreferencesImports.const_get :Preferences
    include_class_members AbstractPreferencesImports
    
    # 
    # Our name relative to parent.
    attr_accessor :name
    alias_method :attr_name, :name
    undef_method :name
    alias_method :attr_name=, :name=
    undef_method :name=
    
    # 
    # Our absolute path name.
    attr_accessor :absolute_path
    alias_method :attr_absolute_path, :absolute_path
    undef_method :absolute_path
    alias_method :attr_absolute_path=, :absolute_path=
    undef_method :absolute_path=
    
    # 
    # Our parent node.
    attr_accessor :parent
    alias_method :attr_parent, :parent
    undef_method :parent
    alias_method :attr_parent=, :parent=
    undef_method :parent=
    
    # 
    # Our root node.
    attr_accessor :root
    alias_method :attr_root, :root
    undef_method :root
    alias_method :attr_root=, :root=
    undef_method :root=
    
    # Relative to this node
    # 
    # This field should be <tt>true</tt> if this node did not exist in the
    # backing store prior to the creation of this object.  The field
    # is initialized to false, but may be set to true by a subclass
    # constructor (and should not be modified thereafter).  This field
    # indicates whether a node change event should be fired when
    # creation is complete.
    attr_accessor :new_node
    alias_method :attr_new_node, :new_node
    undef_method :new_node
    alias_method :attr_new_node=, :new_node=
    undef_method :new_node=
    
    # 
    # All known unremoved children of this node.  (This "cache" is consulted
    # prior to calling childSpi() or getChild().
    attr_accessor :kid_cache
    alias_method :attr_kid_cache, :kid_cache
    undef_method :kid_cache
    alias_method :attr_kid_cache=, :kid_cache=
    undef_method :kid_cache=
    
    # 
    # This field is used to keep track of whether or not this node has
    # been removed.  Once it's set to true, it will never be reset to false.
    attr_accessor :removed
    alias_method :attr_removed, :removed
    undef_method :removed
    alias_method :attr_removed=, :removed=
    undef_method :removed=
    
    # 
    # Registered preference change listeners.
    attr_accessor :pref_listeners
    alias_method :attr_pref_listeners, :pref_listeners
    undef_method :pref_listeners
    alias_method :attr_pref_listeners=, :pref_listeners=
    undef_method :pref_listeners=
    
    # 
    # Registered node change listeners.
    attr_accessor :node_listeners
    alias_method :attr_node_listeners, :node_listeners
    undef_method :node_listeners
    alias_method :attr_node_listeners=, :node_listeners=
    undef_method :node_listeners=
    
    # 
    # An object whose monitor is used to lock this node.  This object
    # is used in preference to the node itself to reduce the likelihood of
    # intentional or unintentional denial of service due to a locked node.
    # To avoid deadlock, a node is <i>never</i> locked by a thread that
    # holds a lock on a descendant of that node.
    attr_accessor :lock
    alias_method :attr_lock, :lock
    undef_method :lock
    alias_method :attr_lock=, :lock=
    undef_method :lock=
    
    typesig { [AbstractPreferences, String] }
    # 
    # Creates a preference node with the specified parent and the specified
    # name relative to its parent.
    # 
    # @param parent the parent of this preference node, or null if this
    # is the root.
    # @param name the name of this preference node, relative to its parent,
    # or <tt>""</tt> if this is the root.
    # @throws IllegalArgumentException if <tt>name</tt> contains a slash
    # (<tt>'/'</tt>),  or <tt>parent</tt> is <tt>null</tt> and
    # name isn't <tt>""</tt>.
    def initialize(parent, name)
      @name = nil
      @absolute_path = nil
      @parent = nil
      @root = nil
      @new_node = false
      @kid_cache = nil
      @removed = false
      @pref_listeners = nil
      @node_listeners = nil
      @lock = nil
      super()
      @new_node = false
      @kid_cache = HashMap.new
      @removed = false
      @pref_listeners = Array.typed(PreferenceChangeListener).new(0) { nil }
      @node_listeners = Array.typed(NodeChangeListener).new(0) { nil }
      @lock = Object.new
      if ((parent).nil?)
        if (!(name == ""))
          raise IllegalArgumentException.new("Root name '" + name + "' must be \"\"")
        end
        @absolute_path = "/"
        @root = self
      else
        if (!(name.index_of(Character.new(?/.ord))).equal?(-1))
          raise IllegalArgumentException.new("Name '" + name + "' contains '/'")
        end
        if ((name == ""))
          raise IllegalArgumentException.new("Illegal name: empty string")
        end
        @root = parent.attr_root
        @absolute_path = (((parent).equal?(@root) ? "/" + name : (parent.absolute_path).to_s + "/" + name)).to_s
      end
      @name = name
      @parent = parent
    end
    
    typesig { [String, String] }
    # 
    # Implements the <tt>put</tt> method as per the specification in
    # {@link Preferences#put(String,String)}.
    # 
    # <p>This implementation checks that the key and value are legal,
    # obtains this preference node's lock, checks that the node
    # has not been removed, invokes {@link #putSpi(String,String)}, and if
    # there are any preference change listeners, enqueues a notification
    # event for processing by the event dispatch thread.
    # 
    # @param key key with which the specified value is to be associated.
    # @param value value to be associated with the specified key.
    # @throws NullPointerException if key or value is <tt>null</tt>.
    # @throws IllegalArgumentException if <tt>key.length()</tt> exceeds
    # <tt>MAX_KEY_LENGTH</tt> or if <tt>value.length</tt> exceeds
    # <tt>MAX_VALUE_LENGTH</tt>.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def put(key, value)
      if ((key).nil? || (value).nil?)
        raise NullPointerException.new
      end
      if (key.length > MAX_KEY_LENGTH)
        raise IllegalArgumentException.new("Key too long: " + key)
      end
      if (value.length > MAX_VALUE_LENGTH)
        raise IllegalArgumentException.new("Value too long: " + value)
      end
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        put_spi(key, value)
        enqueue_preference_change_event(key, value)
      end
    end
    
    typesig { [String, String] }
    # 
    # Implements the <tt>get</tt> method as per the specification in
    # {@link Preferences#get(String,String)}.
    # 
    # <p>This implementation first checks to see if <tt>key</tt> is
    # <tt>null</tt> throwing a <tt>NullPointerException</tt> if this is
    # the case.  Then it obtains this preference node's lock,
    # checks that the node has not been removed, invokes {@link
    # #getSpi(String)}, and returns the result, unless the <tt>getSpi</tt>
    # invocation returns <tt>null</tt> or throws an exception, in which case
    # this invocation returns <tt>def</tt>.
    # 
    # @param key key whose associated value is to be returned.
    # @param def the value to be returned in the event that this
    # preference node has no value associated with <tt>key</tt>.
    # @return the value associated with <tt>key</tt>, or <tt>def</tt>
    # if no value is associated with <tt>key</tt>.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @throws NullPointerException if key is <tt>null</tt>.  (A
    # <tt>null</tt> default <i>is</i> permitted.)
    def get(key, def_)
      if ((key).nil?)
        raise NullPointerException.new("Null key")
      end
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        result = nil
        begin
          result = (get_spi(key)).to_s
        rescue Exception => e
          # Ignoring exception causes default to be returned
        end
        return ((result).nil? ? def_ : result)
      end
    end
    
    typesig { [String] }
    # 
    # Implements the <tt>remove(String)</tt> method as per the specification
    # in {@link Preferences#remove(String)}.
    # 
    # <p>This implementation obtains this preference node's lock,
    # checks that the node has not been removed, invokes
    # {@link #removeSpi(String)} and if there are any preference
    # change listeners, enqueues a notification event for processing by the
    # event dispatch thread.
    # 
    # @param key key whose mapping is to be removed from the preference node.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def remove(key)
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        remove_spi(key)
        enqueue_preference_change_event(key, nil)
      end
    end
    
    typesig { [] }
    # 
    # Implements the <tt>clear</tt> method as per the specification in
    # {@link Preferences#clear()}.
    # 
    # <p>This implementation obtains this preference node's lock,
    # invokes {@link #keys()} to obtain an array of keys, and
    # iterates over the array invoking {@link #remove(String)} on each key.
    # 
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def clear
      synchronized((@lock)) do
        keys_ = keys
        i = 0
        while i < keys_.attr_length
          remove(keys_[i])
          ((i += 1) - 1)
        end
      end
    end
    
    typesig { [String, ::Java::Int] }
    # 
    # Implements the <tt>putInt</tt> method as per the specification in
    # {@link Preferences#putInt(String,int)}.
    # 
    # <p>This implementation translates <tt>value</tt> to a string with
    # {@link Integer#toString(int)} and invokes {@link #put(String,String)}
    # on the result.
    # 
    # @param key key with which the string form of value is to be associated.
    # @param value value whose string form is to be associated with key.
    # @throws NullPointerException if key is <tt>null</tt>.
    # @throws IllegalArgumentException if <tt>key.length()</tt> exceeds
    # <tt>MAX_KEY_LENGTH</tt>.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def put_int(key, value)
      put(key, JavaInteger.to_s(value))
    end
    
    typesig { [String, ::Java::Int] }
    # 
    # Implements the <tt>getInt</tt> method as per the specification in
    # {@link Preferences#getInt(String,int)}.
    # 
    # <p>This implementation invokes {@link #get(String,String) <tt>get(key,
    # null)</tt>}.  If the return value is non-null, the implementation
    # attempts to translate it to an <tt>int</tt> with
    # {@link Integer#parseInt(String)}.  If the attempt succeeds, the return
    # value is returned by this method.  Otherwise, <tt>def</tt> is returned.
    # 
    # @param key key whose associated value is to be returned as an int.
    # @param def the value to be returned in the event that this
    # preference node has no value associated with <tt>key</tt>
    # or the associated value cannot be interpreted as an int.
    # @return the int value represented by the string associated with
    # <tt>key</tt> in this preference node, or <tt>def</tt> if the
    # associated value does not exist or cannot be interpreted as
    # an int.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @throws NullPointerException if <tt>key</tt> is <tt>null</tt>.
    def get_int(key, def_)
      result = def_
      begin
        value = get(key, nil)
        if (!(value).nil?)
          result = JavaInteger.parse_int(value)
        end
      rescue NumberFormatException => e
        # Ignoring exception causes specified default to be returned
      end
      return result
    end
    
    typesig { [String, ::Java::Long] }
    # 
    # Implements the <tt>putLong</tt> method as per the specification in
    # {@link Preferences#putLong(String,long)}.
    # 
    # <p>This implementation translates <tt>value</tt> to a string with
    # {@link Long#toString(long)} and invokes {@link #put(String,String)}
    # on the result.
    # 
    # @param key key with which the string form of value is to be associated.
    # @param value value whose string form is to be associated with key.
    # @throws NullPointerException if key is <tt>null</tt>.
    # @throws IllegalArgumentException if <tt>key.length()</tt> exceeds
    # <tt>MAX_KEY_LENGTH</tt>.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def put_long(key, value)
      put(key, Long.to_s(value))
    end
    
    typesig { [String, ::Java::Long] }
    # 
    # Implements the <tt>getLong</tt> method as per the specification in
    # {@link Preferences#getLong(String,long)}.
    # 
    # <p>This implementation invokes {@link #get(String,String) <tt>get(key,
    # null)</tt>}.  If the return value is non-null, the implementation
    # attempts to translate it to a <tt>long</tt> with
    # {@link Long#parseLong(String)}.  If the attempt succeeds, the return
    # value is returned by this method.  Otherwise, <tt>def</tt> is returned.
    # 
    # @param key key whose associated value is to be returned as a long.
    # @param def the value to be returned in the event that this
    # preference node has no value associated with <tt>key</tt>
    # or the associated value cannot be interpreted as a long.
    # @return the long value represented by the string associated with
    # <tt>key</tt> in this preference node, or <tt>def</tt> if the
    # associated value does not exist or cannot be interpreted as
    # a long.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @throws NullPointerException if <tt>key</tt> is <tt>null</tt>.
    def get_long(key, def_)
      result = def_
      begin
        value = get(key, nil)
        if (!(value).nil?)
          result = Long.parse_long(value)
        end
      rescue NumberFormatException => e
        # Ignoring exception causes specified default to be returned
      end
      return result
    end
    
    typesig { [String, ::Java::Boolean] }
    # 
    # Implements the <tt>putBoolean</tt> method as per the specification in
    # {@link Preferences#putBoolean(String,boolean)}.
    # 
    # <p>This implementation translates <tt>value</tt> to a string with
    # {@link String#valueOf(boolean)} and invokes {@link #put(String,String)}
    # on the result.
    # 
    # @param key key with which the string form of value is to be associated.
    # @param value value whose string form is to be associated with key.
    # @throws NullPointerException if key is <tt>null</tt>.
    # @throws IllegalArgumentException if <tt>key.length()</tt> exceeds
    # <tt>MAX_KEY_LENGTH</tt>.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def put_boolean(key, value)
      put(key, String.value_of(value))
    end
    
    typesig { [String, ::Java::Boolean] }
    # 
    # Implements the <tt>getBoolean</tt> method as per the specification in
    # {@link Preferences#getBoolean(String,boolean)}.
    # 
    # <p>This implementation invokes {@link #get(String,String) <tt>get(key,
    # null)</tt>}.  If the return value is non-null, it is compared with
    # <tt>"true"</tt> using {@link String#equalsIgnoreCase(String)}.  If the
    # comparison returns <tt>true</tt>, this invocation returns
    # <tt>true</tt>.  Otherwise, the original return value is compared with
    # <tt>"false"</tt>, again using {@link String#equalsIgnoreCase(String)}.
    # If the comparison returns <tt>true</tt>, this invocation returns
    # <tt>false</tt>.  Otherwise, this invocation returns <tt>def</tt>.
    # 
    # @param key key whose associated value is to be returned as a boolean.
    # @param def the value to be returned in the event that this
    # preference node has no value associated with <tt>key</tt>
    # or the associated value cannot be interpreted as a boolean.
    # @return the boolean value represented by the string associated with
    # <tt>key</tt> in this preference node, or <tt>def</tt> if the
    # associated value does not exist or cannot be interpreted as
    # a boolean.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @throws NullPointerException if <tt>key</tt> is <tt>null</tt>.
    def get_boolean(key, def_)
      result = def_
      value = get(key, nil)
      if (!(value).nil?)
        if (value.equals_ignore_case("true"))
          result = true
        else
          if (value.equals_ignore_case("false"))
            result = false
          end
        end
      end
      return result
    end
    
    typesig { [String, ::Java::Float] }
    # 
    # Implements the <tt>putFloat</tt> method as per the specification in
    # {@link Preferences#putFloat(String,float)}.
    # 
    # <p>This implementation translates <tt>value</tt> to a string with
    # {@link Float#toString(float)} and invokes {@link #put(String,String)}
    # on the result.
    # 
    # @param key key with which the string form of value is to be associated.
    # @param value value whose string form is to be associated with key.
    # @throws NullPointerException if key is <tt>null</tt>.
    # @throws IllegalArgumentException if <tt>key.length()</tt> exceeds
    # <tt>MAX_KEY_LENGTH</tt>.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def put_float(key, value)
      put(key, Float.to_s(value))
    end
    
    typesig { [String, ::Java::Float] }
    # 
    # Implements the <tt>getFloat</tt> method as per the specification in
    # {@link Preferences#getFloat(String,float)}.
    # 
    # <p>This implementation invokes {@link #get(String,String) <tt>get(key,
    # null)</tt>}.  If the return value is non-null, the implementation
    # attempts to translate it to an <tt>float</tt> with
    # {@link Float#parseFloat(String)}.  If the attempt succeeds, the return
    # value is returned by this method.  Otherwise, <tt>def</tt> is returned.
    # 
    # @param key key whose associated value is to be returned as a float.
    # @param def the value to be returned in the event that this
    # preference node has no value associated with <tt>key</tt>
    # or the associated value cannot be interpreted as a float.
    # @return the float value represented by the string associated with
    # <tt>key</tt> in this preference node, or <tt>def</tt> if the
    # associated value does not exist or cannot be interpreted as
    # a float.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @throws NullPointerException if <tt>key</tt> is <tt>null</tt>.
    def get_float(key, def_)
      result = def_
      begin
        value = get(key, nil)
        if (!(value).nil?)
          result = Float.parse_float(value)
        end
      rescue NumberFormatException => e
        # Ignoring exception causes specified default to be returned
      end
      return result
    end
    
    typesig { [String, ::Java::Double] }
    # 
    # Implements the <tt>putDouble</tt> method as per the specification in
    # {@link Preferences#putDouble(String,double)}.
    # 
    # <p>This implementation translates <tt>value</tt> to a string with
    # {@link Double#toString(double)} and invokes {@link #put(String,String)}
    # on the result.
    # 
    # @param key key with which the string form of value is to be associated.
    # @param value value whose string form is to be associated with key.
    # @throws NullPointerException if key is <tt>null</tt>.
    # @throws IllegalArgumentException if <tt>key.length()</tt> exceeds
    # <tt>MAX_KEY_LENGTH</tt>.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def put_double(key, value)
      put(key, Double.to_s(value))
    end
    
    typesig { [String, ::Java::Double] }
    # 
    # Implements the <tt>getDouble</tt> method as per the specification in
    # {@link Preferences#getDouble(String,double)}.
    # 
    # <p>This implementation invokes {@link #get(String,String) <tt>get(key,
    # null)</tt>}.  If the return value is non-null, the implementation
    # attempts to translate it to an <tt>double</tt> with
    # {@link Double#parseDouble(String)}.  If the attempt succeeds, the return
    # value is returned by this method.  Otherwise, <tt>def</tt> is returned.
    # 
    # @param key key whose associated value is to be returned as a double.
    # @param def the value to be returned in the event that this
    # preference node has no value associated with <tt>key</tt>
    # or the associated value cannot be interpreted as a double.
    # @return the double value represented by the string associated with
    # <tt>key</tt> in this preference node, or <tt>def</tt> if the
    # associated value does not exist or cannot be interpreted as
    # a double.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @throws NullPointerException if <tt>key</tt> is <tt>null</tt>.
    def get_double(key, def_)
      result = def_
      begin
        value = get(key, nil)
        if (!(value).nil?)
          result = Double.parse_double(value)
        end
      rescue NumberFormatException => e
        # Ignoring exception causes specified default to be returned
      end
      return result
    end
    
    typesig { [String, Array.typed(::Java::Byte)] }
    # 
    # Implements the <tt>putByteArray</tt> method as per the specification in
    # {@link Preferences#putByteArray(String,byte[])}.
    # 
    # @param key key with which the string form of value is to be associated.
    # @param value value whose string form is to be associated with key.
    # @throws NullPointerException if key or value is <tt>null</tt>.
    # @throws IllegalArgumentException if key.length() exceeds MAX_KEY_LENGTH
    # or if value.length exceeds MAX_VALUE_LENGTH*3/4.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def put_byte_array(key, value)
      put(key, Base64.byte_array_to_base64(value))
    end
    
    typesig { [String, Array.typed(::Java::Byte)] }
    # 
    # Implements the <tt>getByteArray</tt> method as per the specification in
    # {@link Preferences#getByteArray(String,byte[])}.
    # 
    # @param key key whose associated value is to be returned as a byte array.
    # @param def the value to be returned in the event that this
    # preference node has no value associated with <tt>key</tt>
    # or the associated value cannot be interpreted as a byte array.
    # @return the byte array value represented by the string associated with
    # <tt>key</tt> in this preference node, or <tt>def</tt> if the
    # associated value does not exist or cannot be interpreted as
    # a byte array.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @throws NullPointerException if <tt>key</tt> is <tt>null</tt>.  (A
    # <tt>null</tt> value for <tt>def</tt> <i>is</i> permitted.)
    def get_byte_array(key, def_)
      result = def_
      value = get(key, nil)
      begin
        if (!(value).nil?)
          result = Base64.base64_to_byte_array(value)
        end
      rescue RuntimeException => e
        # Ignoring exception causes specified default to be returned
      end
      return result
    end
    
    typesig { [] }
    # 
    # Implements the <tt>keys</tt> method as per the specification in
    # {@link Preferences#keys()}.
    # 
    # <p>This implementation obtains this preference node's lock, checks that
    # the node has not been removed and invokes {@link #keysSpi()}.
    # 
    # @return an array of the keys that have an associated value in this
    # preference node.
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def keys
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        return keys_spi
      end
    end
    
    typesig { [] }
    # 
    # Implements the <tt>children</tt> method as per the specification in
    # {@link Preferences#childrenNames()}.
    # 
    # <p>This implementation obtains this preference node's lock, checks that
    # the node has not been removed, constructs a <tt>TreeSet</tt> initialized
    # to the names of children already cached (the children in this node's
    # "child-cache"), invokes {@link #childrenNamesSpi()}, and adds all of the
    # returned child-names into the set.  The elements of the tree set are
    # dumped into a <tt>String</tt> array using the <tt>toArray</tt> method,
    # and this array is returned.
    # 
    # @return the names of the children of this preference node.
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @see #cachedChildren()
    def children_names
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        s = TreeSet.new(@kid_cache.key_set)
        kids = children_names_spi
        i = 0
        while i < kids.attr_length
          s.add(kids[i])
          ((i += 1) - 1)
        end
        return s.to_array(EMPTY_STRING_ARRAY)
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:EMPTY_STRING_ARRAY) { Array.typed(String).new(0) { nil } }
      const_attr_reader  :EMPTY_STRING_ARRAY
    }
    
    typesig { [] }
    # 
    # Returns all known unremoved children of this node.
    # 
    # @return all known unremoved children of this node.
    def cached_children
      return @kid_cache.values.to_array(EMPTY_ABSTRACT_PREFS_ARRAY)
    end
    
    class_module.module_eval {
      const_set_lazy(:EMPTY_ABSTRACT_PREFS_ARRAY) { Array.typed(AbstractPreferences).new(0) { nil } }
      const_attr_reader  :EMPTY_ABSTRACT_PREFS_ARRAY
    }
    
    typesig { [] }
    # 
    # Implements the <tt>parent</tt> method as per the specification in
    # {@link Preferences#parent()}.
    # 
    # <p>This implementation obtains this preference node's lock, checks that
    # the node has not been removed and returns the parent value that was
    # passed to this node's constructor.
    # 
    # @return the parent of this preference node.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def parent
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        return @parent
      end
    end
    
    typesig { [String] }
    # 
    # Implements the <tt>node</tt> method as per the specification in
    # {@link Preferences#node(String)}.
    # 
    # <p>This implementation obtains this preference node's lock and checks
    # that the node has not been removed.  If <tt>path</tt> is <tt>""</tt>,
    # this node is returned; if <tt>path</tt> is <tt>"/"</tt>, this node's
    # root is returned.  If the first character in <tt>path</tt> is
    # not <tt>'/'</tt>, the implementation breaks <tt>path</tt> into
    # tokens and recursively traverses the path from this node to the
    # named node, "consuming" a name and a slash from <tt>path</tt> at
    # each step of the traversal.  At each step, the current node is locked
    # and the node's child-cache is checked for the named node.  If it is
    # not found, the name is checked to make sure its length does not
    # exceed <tt>MAX_NAME_LENGTH</tt>.  Then the {@link #childSpi(String)}
    # method is invoked, and the result stored in this node's child-cache.
    # If the newly created <tt>Preferences</tt> object's {@link #newNode}
    # field is <tt>true</tt> and there are any node change listeners,
    # a notification event is enqueued for processing by the event dispatch
    # thread.
    # 
    # <p>When there are no more tokens, the last value found in the
    # child-cache or returned by <tt>childSpi</tt> is returned by this
    # method.  If during the traversal, two <tt>"/"</tt> tokens occur
    # consecutively, or the final token is <tt>"/"</tt> (rather than a name),
    # an appropriate <tt>IllegalArgumentException</tt> is thrown.
    # 
    # <p> If the first character of <tt>path</tt> is <tt>'/'</tt>
    # (indicating an absolute path name) this preference node's
    # lock is dropped prior to breaking <tt>path</tt> into tokens, and
    # this method recursively traverses the path starting from the root
    # (rather than starting from this node).  The traversal is otherwise
    # identical to the one described for relative path names.  Dropping
    # the lock on this node prior to commencing the traversal at the root
    # node is essential to avoid the possibility of deadlock, as per the
    # {@link #lock locking invariant}.
    # 
    # @param path the path name of the preference node to return.
    # @return the specified preference node.
    # @throws IllegalArgumentException if the path name is invalid (i.e.,
    # it contains multiple consecutive slash characters, or ends
    # with a slash character and is more than one character long).
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def node(path)
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        if ((path == ""))
          return self
        end
        if ((path == "/"))
          return @root
        end
        if (!(path.char_at(0)).equal?(Character.new(?/.ord)))
          return node(StringTokenizer.new(path, "/", true))
        end
      end
      # Absolute path.  Note that we've dropped our lock to avoid deadlock
      return @root.node(StringTokenizer.new(path.substring(1), "/", true))
    end
    
    typesig { [StringTokenizer] }
    # 
    # tokenizer contains <name> {'/' <name>}*
    def node(path)
      token = path.next_token
      if ((token == "/"))
        # Check for consecutive slashes
        raise IllegalArgumentException.new("Consecutive slashes in path")
      end
      synchronized((@lock)) do
        child = @kid_cache.get(token)
        if ((child).nil?)
          if (token.length > MAX_NAME_LENGTH)
            raise IllegalArgumentException.new("Node name " + token + " too long")
          end
          child = child_spi(token)
          if (child.attr_new_node)
            enqueue_node_added_event(child)
          end
          @kid_cache.put(token, child)
        end
        if (!path.has_more_tokens)
          return child
        end
        path.next_token # Consume slash
        if (!path.has_more_tokens)
          raise IllegalArgumentException.new("Path ends with slash")
        end
        return child.node(path)
      end
    end
    
    typesig { [String] }
    # 
    # Implements the <tt>nodeExists</tt> method as per the specification in
    # {@link Preferences#nodeExists(String)}.
    # 
    # <p>This implementation is very similar to {@link #node(String)},
    # except that {@link #getChild(String)} is used instead of {@link
    # #childSpi(String)}.
    # 
    # @param path the path name of the node whose existence is to be checked.
    # @return true if the specified node exists.
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    # @throws IllegalArgumentException if the path name is invalid (i.e.,
    # it contains multiple consecutive slash characters, or ends
    # with a slash character and is more than one character long).
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method and
    # <tt>pathname</tt> is not the empty string (<tt>""</tt>).
    def node_exists(path)
      synchronized((@lock)) do
        if ((path == ""))
          return !@removed
        end
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        if ((path == "/"))
          return true
        end
        if (!(path.char_at(0)).equal?(Character.new(?/.ord)))
          return node_exists(StringTokenizer.new(path, "/", true))
        end
      end
      # Absolute path.  Note that we've dropped our lock to avoid deadlock
      return @root.node_exists(StringTokenizer.new(path.substring(1), "/", true))
    end
    
    typesig { [StringTokenizer] }
    # 
    # tokenizer contains <name> {'/' <name>}*
    def node_exists(path)
      token = path.next_token
      if ((token == "/"))
        # Check for consecutive slashes
        raise IllegalArgumentException.new("Consecutive slashes in path")
      end
      synchronized((@lock)) do
        child = @kid_cache.get(token)
        if ((child).nil?)
          child = get_child(token)
        end
        if ((child).nil?)
          return false
        end
        if (!path.has_more_tokens)
          return true
        end
        path.next_token # Consume slash
        if (!path.has_more_tokens)
          raise IllegalArgumentException.new("Path ends with slash")
        end
        return child.node_exists(path)
      end
    end
    
    typesig { [] }
    # 
    # 
    # Implements the <tt>removeNode()</tt> method as per the specification in
    # {@link Preferences#removeNode()}.
    # 
    # <p>This implementation checks to see that this node is the root; if so,
    # it throws an appropriate exception.  Then, it locks this node's parent,
    # and calls a recursive helper method that traverses the subtree rooted at
    # this node.  The recursive method locks the node on which it was called,
    # checks that it has not already been removed, and then ensures that all
    # of its children are cached: The {@link #childrenNamesSpi()} method is
    # invoked and each returned child name is checked for containment in the
    # child-cache.  If a child is not already cached, the {@link
    # #childSpi(String)} method is invoked to create a <tt>Preferences</tt>
    # instance for it, and this instance is put into the child-cache.  Then
    # the helper method calls itself recursively on each node contained in its
    # child-cache.  Next, it invokes {@link #removeNodeSpi()}, marks itself
    # as removed, and removes itself from its parent's child-cache.  Finally,
    # if there are any node change listeners, it enqueues a notification
    # event for processing by the event dispatch thread.
    # 
    # <p>Note that the helper method is always invoked with all ancestors up
    # to the "closest non-removed ancestor" locked.
    # 
    # @throws IllegalStateException if this node (or an ancestor) has already
    # been removed with the {@link #removeNode()} method.
    # @throws UnsupportedOperationException if this method is invoked on
    # the root node.
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    def remove_node
      if ((self).equal?(@root))
        raise UnsupportedOperationException.new("Can't remove the root!")
      end
      synchronized((@parent.attr_lock)) do
        remove_node2
        @parent.attr_kid_cache.remove(@name)
      end
    end
    
    typesig { [] }
    # 
    # Called with locks on all nodes on path from parent of "removal root"
    # to this (including the former but excluding the latter).
    def remove_node2
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node already removed.")
        end
        # Ensure that all children are cached
        kid_names = children_names_spi
        i = 0
        while i < kid_names.attr_length
          if (!@kid_cache.contains_key(kid_names[i]))
            @kid_cache.put(kid_names[i], child_spi(kid_names[i]))
          end
          ((i += 1) - 1)
        end
        # Recursively remove all cached children
        i_ = @kid_cache.values.iterator
        while i_.has_next
          begin
            (i_.next).remove_node2
            i_.remove
          rescue BackingStoreException => x
          end
        end
        # Now we have no descendants - it's time to die!
        remove_node_spi
        @removed = true
        @parent.enqueue_node_removed_event(self)
      end
    end
    
    typesig { [] }
    # 
    # Implements the <tt>name</tt> method as per the specification in
    # {@link Preferences#name()}.
    # 
    # <p>This implementation merely returns the name that was
    # passed to this node's constructor.
    # 
    # @return this preference node's name, relative to its parent.
    def name
      return @name
    end
    
    typesig { [] }
    # 
    # Implements the <tt>absolutePath</tt> method as per the specification in
    # {@link Preferences#absolutePath()}.
    # 
    # <p>This implementation merely returns the absolute path name that
    # was computed at the time that this node was constructed (based on
    # the name that was passed to this node's constructor, and the names
    # that were passed to this node's ancestors' constructors).
    # 
    # @return this preference node's absolute path name.
    def absolute_path
      return @absolute_path
    end
    
    typesig { [] }
    # 
    # Implements the <tt>isUserNode</tt> method as per the specification in
    # {@link Preferences#isUserNode()}.
    # 
    # <p>This implementation compares this node's root node (which is stored
    # in a private field) with the value returned by
    # {@link Preferences#userRoot()}.  If the two object references are
    # identical, this method returns true.
    # 
    # @return <tt>true</tt> if this preference node is in the user
    # preference tree, <tt>false</tt> if it's in the system
    # preference tree.
    def is_user_node
      result = AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
        extend LocalClass
        include_class_members AbstractPreferences
        include PrivilegedAction if PrivilegedAction.class == Module
        
        typesig { [] }
        define_method :run do
          return Boolean.value_of((self.attr_root).equal?(Preferences.user_root))
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
    
    typesig { [PreferenceChangeListener] }
    def add_preference_change_listener(pcl)
      if ((pcl).nil?)
        raise NullPointerException.new("Change listener is null.")
      end
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        # Copy-on-write
        old = @pref_listeners
        @pref_listeners = Array.typed(PreferenceChangeListener).new(old.attr_length + 1) { nil }
        System.arraycopy(old, 0, @pref_listeners, 0, old.attr_length)
        @pref_listeners[old.attr_length] = pcl
      end
      start_event_dispatch_thread_if_necessary
    end
    
    typesig { [PreferenceChangeListener] }
    def remove_preference_change_listener(pcl)
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        if (((@pref_listeners).nil?) || ((@pref_listeners.attr_length).equal?(0)))
          raise IllegalArgumentException.new("Listener not registered.")
        end
        # Copy-on-write
        new_pl = Array.typed(PreferenceChangeListener).new(@pref_listeners.attr_length - 1) { nil }
        i = 0
        while (i < new_pl.attr_length && !(@pref_listeners[i]).equal?(pcl))
          new_pl[i] = @pref_listeners[((i += 1) - 1)]
        end
        if ((i).equal?(new_pl.attr_length) && !(@pref_listeners[i]).equal?(pcl))
          raise IllegalArgumentException.new("Listener not registered.")
        end
        while (i < new_pl.attr_length)
          new_pl[i] = @pref_listeners[(i += 1)]
        end
        @pref_listeners = new_pl
      end
    end
    
    typesig { [NodeChangeListener] }
    def add_node_change_listener(ncl)
      if ((ncl).nil?)
        raise NullPointerException.new("Change listener is null.")
      end
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        # Copy-on-write
        if ((@node_listeners).nil?)
          @node_listeners = Array.typed(NodeChangeListener).new(1) { nil }
          @node_listeners[0] = ncl
        else
          old = @node_listeners
          @node_listeners = Array.typed(NodeChangeListener).new(old.attr_length + 1) { nil }
          System.arraycopy(old, 0, @node_listeners, 0, old.attr_length)
          @node_listeners[old.attr_length] = ncl
        end
      end
      start_event_dispatch_thread_if_necessary
    end
    
    typesig { [NodeChangeListener] }
    def remove_node_change_listener(ncl)
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed.")
        end
        if (((@node_listeners).nil?) || ((@node_listeners.attr_length).equal?(0)))
          raise IllegalArgumentException.new("Listener not registered.")
        end
        # Copy-on-write
        i = 0
        while (i < @node_listeners.attr_length && !(@node_listeners[i]).equal?(ncl))
          ((i += 1) - 1)
        end
        if ((i).equal?(@node_listeners.attr_length))
          raise IllegalArgumentException.new("Listener not registered.")
        end
        new_nl = Array.typed(NodeChangeListener).new(@node_listeners.attr_length - 1) { nil }
        if (!(i).equal?(0))
          System.arraycopy(@node_listeners, 0, new_nl, 0, i)
        end
        if (!(i).equal?(new_nl.attr_length))
          System.arraycopy(@node_listeners, i + 1, new_nl, i, new_nl.attr_length - i)
        end
        @node_listeners = new_nl
      end
    end
    
    typesig { [String, String] }
    # "SPI" METHODS
    # 
    # Put the given key-value association into this preference node.  It is
    # guaranteed that <tt>key</tt> and <tt>value</tt> are non-null and of
    # legal length.  Also, it is guaranteed that this node has not been
    # removed.  (The implementor needn't check for any of these things.)
    # 
    # <p>This method is invoked with the lock on this node held.
    def put_spi(key, value)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
    # Return the value associated with the specified key at this preference
    # node, or <tt>null</tt> if there is no association for this key, or the
    # association cannot be determined at this time.  It is guaranteed that
    # <tt>key</tt> is non-null.  Also, it is guaranteed that this node has
    # not been removed.  (The implementor needn't check for either of these
    # things.)
    # 
    # <p> Generally speaking, this method should not throw an exception
    # under any circumstances.  If, however, if it does throw an exception,
    # the exception will be intercepted and treated as a <tt>null</tt>
    # return value.
    # 
    # <p>This method is invoked with the lock on this node held.
    # 
    # @return the value associated with the specified key at this preference
    # node, or <tt>null</tt> if there is no association for this
    # key, or the association cannot be determined at this time.
    def get_spi(key)
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
    # Remove the association (if any) for the specified key at this
    # preference node.  It is guaranteed that <tt>key</tt> is non-null.
    # Also, it is guaranteed that this node has not been removed.
    # (The implementor needn't check for either of these things.)
    # 
    # <p>This method is invoked with the lock on this node held.
    def remove_spi(key)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Removes this preference node, invalidating it and any preferences that
    # it contains.  The named child will have no descendants at the time this
    # invocation is made (i.e., the {@link Preferences#removeNode()} method
    # invokes this method repeatedly in a bottom-up fashion, removing each of
    # a node's descendants before removing the node itself).
    # 
    # <p>This method is invoked with the lock held on this node and its
    # parent (and all ancestors that are being removed as a
    # result of a single invocation to {@link Preferences#removeNode()}).
    # 
    # <p>The removal of a node needn't become persistent until the
    # <tt>flush</tt> method is invoked on this node (or an ancestor).
    # 
    # <p>If this node throws a <tt>BackingStoreException</tt>, the exception
    # will propagate out beyond the enclosing {@link #removeNode()}
    # invocation.
    # 
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    def remove_node_spi
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns all of the keys that have an associated value in this
    # preference node.  (The returned array will be of size zero if
    # this node has no preferences.)  It is guaranteed that this node has not
    # been removed.
    # 
    # <p>This method is invoked with the lock on this node held.
    # 
    # <p>If this node throws a <tt>BackingStoreException</tt>, the exception
    # will propagate out beyond the enclosing {@link #keys()} invocation.
    # 
    # @return an array of the keys that have an associated value in this
    # preference node.
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    def keys_spi
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the names of the children of this preference node.  (The
    # returned array will be of size zero if this node has no children.)
    # This method need not return the names of any nodes already cached,
    # but may do so without harm.
    # 
    # <p>This method is invoked with the lock on this node held.
    # 
    # <p>If this node throws a <tt>BackingStoreException</tt>, the exception
    # will propagate out beyond the enclosing {@link #childrenNames()}
    # invocation.
    # 
    # @return an array containing the names of the children of this
    # preference node.
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    def children_names_spi
      raise NotImplementedError
    end
    
    typesig { [String] }
    # 
    # Returns the named child if it exists, or <tt>null</tt> if it does not.
    # It is guaranteed that <tt>nodeName</tt> is non-null, non-empty,
    # does not contain the slash character ('/'), and is no longer than
    # {@link #MAX_NAME_LENGTH} characters.  Also, it is guaranteed
    # that this node has not been removed.  (The implementor needn't check
    # for any of these things if he chooses to override this method.)
    # 
    # <p>Finally, it is guaranteed that the named node has not been returned
    # by a previous invocation of this method or {@link #childSpi} after the
    # last time that it was removed.  In other words, a cached value will
    # always be used in preference to invoking this method.  (The implementor
    # needn't maintain his own cache of previously returned children if he
    # chooses to override this method.)
    # 
    # <p>This implementation obtains this preference node's lock, invokes
    # {@link #childrenNames()} to get an array of the names of this node's
    # children, and iterates over the array comparing the name of each child
    # with the specified node name.  If a child node has the correct name,
    # the {@link #childSpi(String)} method is invoked and the resulting
    # node is returned.  If the iteration completes without finding the
    # specified name, <tt>null</tt> is returned.
    # 
    # @param nodeName name of the child to be searched for.
    # @return the named child if it exists, or null if it does not.
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    def get_child(node_name)
      synchronized((@lock)) do
        # assert kidCache.get(nodeName)==null;
        kid_names = children_names
        i = 0
        while i < kid_names.attr_length
          if ((kid_names[i] == node_name))
            return child_spi(kid_names[i])
          end
          ((i += 1) - 1)
        end
      end
      return nil
    end
    
    typesig { [String] }
    # 
    # Returns the named child of this preference node, creating it if it does
    # not already exist.  It is guaranteed that <tt>name</tt> is non-null,
    # non-empty, does not contain the slash character ('/'), and is no longer
    # than {@link #MAX_NAME_LENGTH} characters.  Also, it is guaranteed that
    # this node has not been removed.  (The implementor needn't check for any
    # of these things.)
    # 
    # <p>Finally, it is guaranteed that the named node has not been returned
    # by a previous invocation of this method or {@link #getChild(String)}
    # after the last time that it was removed.  In other words, a cached
    # value will always be used in preference to invoking this method.
    # Subclasses need not maintain their own cache of previously returned
    # children.
    # 
    # <p>The implementer must ensure that the returned node has not been
    # removed.  If a like-named child of this node was previously removed, the
    # implementer must return a newly constructed <tt>AbstractPreferences</tt>
    # node; once removed, an <tt>AbstractPreferences</tt> node
    # cannot be "resuscitated."
    # 
    # <p>If this method causes a node to be created, this node is not
    # guaranteed to be persistent until the <tt>flush</tt> method is
    # invoked on this node or one of its ancestors (or descendants).
    # 
    # <p>This method is invoked with the lock on this node held.
    # 
    # @param name The name of the child node to return, relative to
    # this preference node.
    # @return The named child node.
    def child_spi(name)
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns the absolute path name of this preferences node.
    def to_s
      return ((self.is_user_node ? "User" : "System")).to_s + " Preference Node: " + (self.absolute_path).to_s
    end
    
    typesig { [] }
    # 
    # Implements the <tt>sync</tt> method as per the specification in
    # {@link Preferences#sync()}.
    # 
    # <p>This implementation calls a recursive helper method that locks this
    # node, invokes syncSpi() on it, unlocks this node, and recursively
    # invokes this method on each "cached child."  A cached child is a child
    # of this node that has been created in this VM and not subsequently
    # removed.  In effect, this method does a depth first traversal of the
    # "cached subtree" rooted at this node, calling syncSpi() on each node in
    # the subTree while only that node is locked. Note that syncSpi() is
    # invoked top-down.
    # 
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    # @throws IllegalStateException if this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    # @see #flush()
    def sync
      sync2
    end
    
    typesig { [] }
    def sync2
      cached_kids = nil
      synchronized((@lock)) do
        if (@removed)
          raise IllegalStateException.new("Node has been removed")
        end
        sync_spi
        cached_kids = cached_children
      end
      i = 0
      while i < cached_kids.attr_length
        cached_kids[i].sync2
        ((i += 1) - 1)
      end
    end
    
    typesig { [] }
    # 
    # This method is invoked with this node locked.  The contract of this
    # method is to synchronize any cached preferences stored at this node
    # with any stored in the backing store.  (It is perfectly possible that
    # this node does not exist on the backing store, either because it has
    # been deleted by another VM, or because it has not yet been created.)
    # Note that this method should <i>not</i> synchronize the preferences in
    # any subnodes of this node.  If the backing store naturally syncs an
    # entire subtree at once, the implementer is encouraged to override
    # sync(), rather than merely overriding this method.
    # 
    # <p>If this node throws a <tt>BackingStoreException</tt>, the exception
    # will propagate out beyond the enclosing {@link #sync()} invocation.
    # 
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    def sync_spi
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Implements the <tt>flush</tt> method as per the specification in
    # {@link Preferences#flush()}.
    # 
    # <p>This implementation calls a recursive helper method that locks this
    # node, invokes flushSpi() on it, unlocks this node, and recursively
    # invokes this method on each "cached child."  A cached child is a child
    # of this node that has been created in this VM and not subsequently
    # removed.  In effect, this method does a depth first traversal of the
    # "cached subtree" rooted at this node, calling flushSpi() on each node in
    # the subTree while only that node is locked. Note that flushSpi() is
    # invoked top-down.
    # 
    # <p> If this method is invoked on a node that has been removed with
    # the {@link #removeNode()} method, flushSpi() is invoked on this node,
    # but not on others.
    # 
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    # @see #flush()
    def flush
      flush2
    end
    
    typesig { [] }
    def flush2
      cached_kids = nil
      synchronized((@lock)) do
        flush_spi
        if (@removed)
          return
        end
        cached_kids = cached_children
      end
      i = 0
      while i < cached_kids.attr_length
        cached_kids[i].flush2
        ((i += 1) - 1)
      end
    end
    
    typesig { [] }
    # 
    # This method is invoked with this node locked.  The contract of this
    # method is to force any cached changes in the contents of this
    # preference node to the backing store, guaranteeing their persistence.
    # (It is perfectly possible that this node does not exist on the backing
    # store, either because it has been deleted by another VM, or because it
    # has not yet been created.)  Note that this method should <i>not</i>
    # flush the preferences in any subnodes of this node.  If the backing
    # store naturally flushes an entire subtree at once, the implementer is
    # encouraged to override flush(), rather than merely overriding this
    # method.
    # 
    # <p>If this node throws a <tt>BackingStoreException</tt>, the exception
    # will propagate out beyond the enclosing {@link #flush()} invocation.
    # 
    # @throws BackingStoreException if this operation cannot be completed
    # due to a failure in the backing store, or inability to
    # communicate with it.
    def flush_spi
      raise NotImplementedError
    end
    
    typesig { [] }
    # 
    # Returns <tt>true</tt> iff this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.  This method
    # locks this node prior to returning the contents of the private
    # field used to track this state.
    # 
    # @return <tt>true</tt> iff this node (or an ancestor) has been
    # removed with the {@link #removeNode()} method.
    def is_removed
      synchronized((@lock)) do
        return @removed
      end
    end
    
    class_module.module_eval {
      # 
      # Queue of pending notification events.  When a preference or node
      # change event for which there are one or more listeners occurs,
      # it is placed on this queue and the queue is notified.  A background
      # thread waits on this queue and delivers the events.  This decouples
      # event delivery from preference activity, greatly simplifying
      # locking and reducing opportunity for deadlock.
      const_set_lazy(:EventQueue) { LinkedList.new }
      const_attr_reader  :EventQueue
      
      # 
      # These two classes are used to distinguish NodeChangeEvents on
      # eventQueue so the event dispatch thread knows whether to call
      # childAdded or childRemoved.
      const_set_lazy(:NodeAddedEvent) { Class.new(NodeChangeEvent) do
        extend LocalClass
        include_class_members AbstractPreferences
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { -6743557530157328528 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [Preferences, Preferences] }
        def initialize(parent, child)
          super(parent, child)
        end
        
        private
        alias_method :initialize__node_added_event, :initialize
      end }
      
      const_set_lazy(:NodeRemovedEvent) { Class.new(NodeChangeEvent) do
        extend LocalClass
        include_class_members AbstractPreferences
        
        class_module.module_eval {
          const_set_lazy(:SerialVersionUID) { 8735497392918824837 }
          const_attr_reader  :SerialVersionUID
        }
        
        typesig { [Preferences, Preferences] }
        def initialize(parent, child)
          super(parent, child)
        end
        
        private
        alias_method :initialize__node_removed_event, :initialize
      end }
      
      # 
      # A single background thread ("the event notification thread") monitors
      # the event queue and delivers events that are placed on the queue.
      const_set_lazy(:EventDispatchThread) { Class.new(JavaThread) do
        include_class_members AbstractPreferences
        
        typesig { [] }
        def run
          while (true)
            # Wait on eventQueue till an event is present
            event = nil
            synchronized((EventQueue)) do
              begin
                while (EventQueue.is_empty)
                  EventQueue.wait
                end
                event = EventQueue.remove(0)
              rescue InterruptedException => e
                # XXX Log "Event dispatch thread interrupted. Exiting"
                return
              end
            end
            # Now we have event & hold no locks; deliver evt to listeners
            src = event.get_source
            if (event.is_a?(PreferenceChangeEvent))
              pce = event
              listeners = src.pref_listeners
              i = 0
              while i < listeners.attr_length
                listeners[i].preference_change(pce)
                ((i += 1) - 1)
              end
            else
              nce = event
              listeners_ = src.node_listeners
              if (nce.is_a?(NodeAddedEvent))
                i_ = 0
                while i_ < listeners_.attr_length
                  listeners_[i_].child_added(nce)
                  ((i_ += 1) - 1)
                end
              else
                # assert nce instanceof NodeRemovedEvent;
                i__ = 0
                while i__ < listeners_.attr_length
                  listeners_[i__].child_removed(nce)
                  ((i__ += 1) - 1)
                end
              end
            end
          end
        end
        
        typesig { [] }
        def initialize
          super()
        end
        
        private
        alias_method :initialize__event_dispatch_thread, :initialize
      end }
      
      
      def event_dispatch_thread
        defined?(@@event_dispatch_thread) ? @@event_dispatch_thread : @@event_dispatch_thread= nil
      end
      alias_method :attr_event_dispatch_thread, :event_dispatch_thread
      
      def event_dispatch_thread=(value)
        @@event_dispatch_thread = value
      end
      alias_method :attr_event_dispatch_thread=, :event_dispatch_thread=
      
      typesig { [] }
      # 
      # This method starts the event dispatch thread the first time it
      # is called.  The event dispatch thread will be started only
      # if someone registers a listener.
      def start_event_dispatch_thread_if_necessary
        synchronized(self) do
          if ((self.attr_event_dispatch_thread).nil?)
            # XXX Log "Starting event dispatch thread"
            self.attr_event_dispatch_thread = EventDispatchThread.new
            self.attr_event_dispatch_thread.set_daemon(true)
            self.attr_event_dispatch_thread.start
          end
        end
      end
    }
    
    typesig { [] }
    # 
    # Return this node's preference/node change listeners.  Even though
    # we're using a copy-on-write lists, we use synchronized accessors to
    # ensure information transmission from the writing thread to the
    # reading thread.
    def pref_listeners
      synchronized((@lock)) do
        return @pref_listeners
      end
    end
    
    typesig { [] }
    def node_listeners
      synchronized((@lock)) do
        return @node_listeners
      end
    end
    
    typesig { [String, String] }
    # 
    # Enqueue a preference change event for delivery to registered
    # preference change listeners unless there are no registered
    # listeners.  Invoked with this.lock held.
    def enqueue_preference_change_event(key, new_value)
      if (!(@pref_listeners.attr_length).equal?(0))
        synchronized((EventQueue)) do
          EventQueue.add(PreferenceChangeEvent.new(self, key, new_value))
          EventQueue.notify
        end
      end
    end
    
    typesig { [Preferences] }
    # 
    # Enqueue a "node added" event for delivery to registered node change
    # listeners unless there are no registered listeners.  Invoked with
    # this.lock held.
    def enqueue_node_added_event(child)
      if (!(@node_listeners.attr_length).equal?(0))
        synchronized((EventQueue)) do
          EventQueue.add(NodeAddedEvent.new_local(self, self, child))
          EventQueue.notify
        end
      end
    end
    
    typesig { [Preferences] }
    # 
    # Enqueue a "node removed" event for delivery to registered node change
    # listeners unless there are no registered listeners.  Invoked with
    # this.lock held.
    def enqueue_node_removed_event(child)
      if (!(@node_listeners.attr_length).equal?(0))
        synchronized((EventQueue)) do
          EventQueue.add(NodeRemovedEvent.new_local(self, self, child))
          EventQueue.notify
        end
      end
    end
    
    typesig { [OutputStream] }
    # 
    # Implements the <tt>exportNode</tt> method as per the specification in
    # {@link Preferences#exportNode(OutputStream)}.
    # 
    # @param os the output stream on which to emit the XML document.
    # @throws IOException if writing to the specified output stream
    # results in an <tt>IOException</tt>.
    # @throws BackingStoreException if preference data cannot be read from
    # backing store.
    def export_node(os)
      XmlSupport.export(os, self, false)
    end
    
    typesig { [OutputStream] }
    # 
    # Implements the <tt>exportSubtree</tt> method as per the specification in
    # {@link Preferences#exportSubtree(OutputStream)}.
    # 
    # @param os the output stream on which to emit the XML document.
    # @throws IOException if writing to the specified output stream
    # results in an <tt>IOException</tt>.
    # @throws BackingStoreException if preference data cannot be read from
    # backing store.
    def export_subtree(os)
      XmlSupport.export(os, self, true)
    end
    
    private
    alias_method :initialize__abstract_preferences, :initialize
  end
  
end
