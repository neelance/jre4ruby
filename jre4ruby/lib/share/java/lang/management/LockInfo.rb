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
module Java::Lang::Management
  module LockInfoImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Management
      include_const ::Javax::Management::Openmbean, :CompositeData
      include ::Java::Util::Concurrent::Locks
      include_const ::Java::Beans, :ConstructorProperties
    }
  end
  
  # Information about a <em>lock</em>.  A lock can be a built-in object monitor,
  # an <em>ownable synchronizer</em>, or the {@link Condition Condition}
  # object associated with synchronizers.
  # <p>
  # <a name="OwnableSynchronizer">An ownable synchronizer</a> is
  # a synchronizer that may be exclusively owned by a thread and uses
  # {@link AbstractOwnableSynchronizer AbstractOwnableSynchronizer}
  # (or its subclass) to implement its synchronization property.
  # {@link ReentrantLock ReentrantLock} and
  # {@link ReentrantReadWriteLock ReentrantReadWriteLock} are
  # two examples of ownable synchronizers provided by the platform.
  # 
  # <h4><a name="MappedType">MXBean Mapping</a></h4>
  # <tt>LockInfo</tt> is mapped to a {@link CompositeData CompositeData}
  # as specified in the <a href="../../../javax/management/MXBean.html#mapping-rules">
  # type mapping rules</a> of {@linkplain javax.management.MXBean MXBeans}.
  # 
  # @see java.util.concurrent.locks.AbstractOwnableSynchronizer
  # @see java.util.concurrent.locks.Condition
  # 
  # @author  Mandy Chung
  # @since   1.6
  class LockInfo 
    include_class_members LockInfoImports
    
    attr_accessor :class_name
    alias_method :attr_class_name, :class_name
    undef_method :class_name
    alias_method :attr_class_name=, :class_name=
    undef_method :class_name=
    
    attr_accessor :identity_hash_code
    alias_method :attr_identity_hash_code, :identity_hash_code
    undef_method :identity_hash_code
    alias_method :attr_identity_hash_code=, :identity_hash_code=
    undef_method :identity_hash_code=
    
    typesig { [String, ::Java::Int] }
    # Constructs a <tt>LockInfo</tt> object.
    # 
    # @param className the fully qualified name of the class of the lock object.
    # @param identityHashCode the {@link System#identityHashCode
    # identity hash code} of the lock object.
    def initialize(class_name, identity_hash_code)
      @class_name = nil
      @identity_hash_code = 0
      if ((class_name).nil?)
        raise NullPointerException.new("Parameter className cannot be null")
      end
      @class_name = class_name
      @identity_hash_code = identity_hash_code
    end
    
    typesig { [Object] }
    # package-private constructors
    def initialize(lock)
      @class_name = nil
      @identity_hash_code = 0
      @class_name = lock.get_class.get_name
      @identity_hash_code = System.identity_hash_code(lock)
    end
    
    typesig { [] }
    # Returns the fully qualified name of the class of the lock object.
    # 
    # @return the fully qualified name of the class of the lock object.
    def get_class_name
      return @class_name
    end
    
    typesig { [] }
    # Returns the identity hash code of the lock object
    # returned from the {@link System#identityHashCode} method.
    # 
    # @return the identity hash code of the lock object.
    def get_identity_hash_code
      return @identity_hash_code
    end
    
    typesig { [] }
    # Returns a string representation of a lock.  The returned
    # string representation consists of the name of the class of the
    # lock object, the at-sign character `@', and the unsigned
    # hexadecimal representation of the <em>identity</em> hash code
    # of the object.  This method returns a string equals to the value of:
    # <blockquote>
    # <pre>
    # lock.getClass().getName() + '@' + Integer.toHexString(System.identityHashCode(lock))
    # </pre></blockquote>
    # where <tt>lock</tt> is the lock object.
    # 
    # @return the string representation of a lock.
    def to_s
      return @class_name + RJava.cast_to_string(Character.new(?@.ord)) + RJava.cast_to_string(JavaInteger.to_hex_string(@identity_hash_code))
    end
    
    private
    alias_method :initialize__lock_info, :initialize
  end
  
end
