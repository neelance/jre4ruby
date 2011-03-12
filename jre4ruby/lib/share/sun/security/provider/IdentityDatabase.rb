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
module Sun::Security::Provider
  module IdentityDatabaseImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Provider
      include ::Java::Io
      include ::Java::Util
      include ::Java::Security
    }
  end
  
  # An implementation of IdentityScope as a persistent identity
  # database.
  # 
  # @see Identity
  # @see Key
  # 
  # @author Benjamin Renaud
  class IdentityDatabase < IdentityDatabaseImports.const_get :IdentityScope
    include_class_members IdentityDatabaseImports
    overload_protected {
      include Serializable
    }
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.1. for interoperability
      const_set_lazy(:SerialVersionUID) { 4923799573357658384 }
      const_attr_reader  :SerialVersionUID
      
      # Are we debugging?
      const_set_lazy(:Debug) { false }
      const_attr_reader  :Debug
      
      # Are we printing out error messages?
      const_set_lazy(:JavaError) { true }
      const_attr_reader  :JavaError
    }
    
    # The source file, if any, for this database.
    attr_accessor :source_file
    alias_method :attr_source_file, :source_file
    undef_method :source_file
    alias_method :attr_source_file=, :source_file=
    undef_method :source_file=
    
    # The private representation of the database.
    attr_accessor :identities
    alias_method :attr_identities, :identities
    undef_method :identities
    alias_method :attr_identities=, :identities=
    undef_method :identities=
    
    typesig { [] }
    def initialize
      initialize__identity_database("restoring...")
    end
    
    typesig { [JavaFile] }
    # Construct a new, empty database with a specified source file.
    # 
    # @param file the source file.
    def initialize(file)
      initialize__identity_database(file.get_name)
      @source_file = file
    end
    
    typesig { [String] }
    # Construct a new, empty database.
    def initialize(name)
      @source_file = nil
      @identities = nil
      super(name)
      @identities = Hashtable.new
    end
    
    class_module.module_eval {
      typesig { [InputStream] }
      # Initialize an identity database from a stream. The stream should
      # contain data to initialized a serialized IdentityDatabase
      # object.
      # 
      # @param is the input stream from which to restore the database.
      # 
      # @exception IOException if a stream IO exception occurs
      def from_stream(is)
        db = nil
        begin
          ois = ObjectInputStream.new(is)
          db = ois.read_object
        rescue ClassNotFoundException => e
          # this can't happen.
          debug("This should not be happening.", e)
          error("The version of the database is obsolete. Cannot initialize.")
        rescue InvalidClassException => e
          # this may happen in developers workspaces happen.
          debug("This should not be happening.", e)
          error("Unable to initialize system identity scope: " + " InvalidClassException. \nThis is most likely due to " + "a serialization versioning problem: a class used in " + "key management was obsoleted")
        rescue StreamCorruptedException => e
          debug("The serialization stream is corrupted. Unable to load.", e)
          error("Unable to initialize system identity scope." + " StreamCorruptedException.")
        end
        if ((db).nil?)
          db = IdentityDatabase.new("uninitialized")
        end
        return db
      end
      
      typesig { [JavaFile] }
      # Initialize an IdentityDatabase from file.
      # 
      # @param f the filename where the identity database is stored.
      # 
      # @exception IOException a file-related exception occurs (e.g.
      # the directory of the file passed does not exists, etc.
      # 
      # @IOException if a file IO exception occurs.
      def from_file(f)
        fis = FileInputStream.new(f)
        edb = from_stream(fis)
        edb.attr_source_file = f
        return edb
      end
    }
    
    typesig { [] }
    # @return the number of identities in the database.
    def size
      return @identities.size
    end
    
    typesig { [String] }
    # @param name the name of the identity to be retrieved.
    # 
    # @return the identity named name, or null if there are
    # no identities named name in the database.
    def get_identity(name)
      id = @identities.get(name)
      if (id.is_a?(Signer))
        local_check("get.signer")
      end
      return id
    end
    
    typesig { [PublicKey] }
    # Get an identity by key.
    # 
    # @param name the key of the identity to be retrieved.
    # 
    # @return the identity with a given key, or null if there are no
    # identities with that key in the database.
    def get_identity(key)
      if ((key).nil?)
        return nil
      end
      e = identities
      while (e.has_more_elements)
        i = e.next_element
        k = i.get_public_key
        if (!(k).nil? && key_equal(k, key))
          if (i.is_a?(Signer))
            local_check("get.signer")
          end
          return i
        end
      end
      return nil
    end
    
    typesig { [Key, Key] }
    def key_equal(key1, key2)
      if ((key1).equal?(key2))
        return true
      else
        return MessageDigest.is_equal(key1.get_encoded, key2.get_encoded)
      end
    end
    
    typesig { [Identity] }
    # Adds an identity to the database.
    # 
    # @param identity the identity to be added.
    # 
    # @exception KeyManagementException if a name or key clash
    # occurs, or if another exception occurs.
    def add_identity(identity)
      local_check("add.identity")
      by_name = get_identity(identity.get_name)
      by_key = get_identity(identity.get_public_key)
      msg = nil
      if (!(by_name).nil?)
        msg = "name conflict"
      end
      if (!(by_key).nil?)
        msg = "key conflict"
      end
      if (!(msg).nil?)
        raise KeyManagementException.new(msg)
      end
      @identities.put(identity.get_name, identity)
    end
    
    typesig { [Identity] }
    # Removes an identity to the database.
    def remove_identity(identity)
      local_check("remove.identity")
      name = identity.get_name
      if ((@identities.get(name)).nil?)
        raise KeyManagementException.new("there is no identity named " + name + " in " + RJava.cast_to_string(self))
      end
      @identities.remove(name)
    end
    
    typesig { [] }
    # @return an enumeration of all identities in the database.
    def identities
      return @identities.elements
    end
    
    typesig { [JavaFile] }
    # Set the source file for this database.
    def set_source_file(f)
      @source_file = f
    end
    
    typesig { [] }
    # @return the source file for this database.
    def get_source_file
      return @source_file
    end
    
    typesig { [OutputStream] }
    # Save the database in its current state to an output stream.
    # 
    # @param os the output stream to which the database should be serialized.
    # 
    # @exception IOException if an IO exception is raised by stream
    # operations.
    def save(os)
      begin
        oos = ObjectOutputStream.new(os)
        oos.write_object(self)
        oos.flush
      rescue InvalidClassException => e
        debug("This should not be happening.", e)
        return
      end
    end
    
    typesig { [JavaFile] }
    # Save the database to a file.
    # 
    # @exception IOException if an IO exception is raised by stream
    # operations.
    def save(f)
      set_source_file(f)
      fos = FileOutputStream.new(f)
      save(fos)
    end
    
    typesig { [] }
    # Saves the database to the default source file.
    # 
    # @exception KeyManagementException when there is no default source
    # file specified for this database.
    def save
      if ((@source_file).nil?)
        raise IOException.new("this database has no source file")
      end
      save(@source_file)
    end
    
    class_module.module_eval {
      typesig { [] }
      # This method returns the file from which to initialize the
      # system database.
      def system_database_file
        # First figure out where the identity database is hiding, if anywhere.
        db_path = Security.get_property("identity.database")
        # if nowhere, it's the canonical place.
        if ((db_path).nil?)
          db_path = RJava.cast_to_string(System.get_property("user.home") + JavaFile.attr_separator_char) + "identitydb.obj"
        end
        return JavaFile.new(db_path)
      end
      
      # This block initializes the system database, if there is one.
      when_class_loaded do
        Java::Security::AccessController.do_privileged(Class.new(Java::Security::PrivilegedAction.class == Class ? Java::Security::PrivilegedAction : Object) do
          local_class_in IdentityDatabase
          include_class_members IdentityDatabase
          include Java::Security::PrivilegedAction if Java::Security::PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            initialize_system
            return nil
          end
          
          typesig { [Vararg.new(Object)] }
          define_method :initialize do |*args|
            super(*args)
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [] }
      # This method initializes the system's identity database. The
      # canonical location is
      # <user.home>/identitydatabase.obj. This is settable through
      # the identity.database property.
      def initialize_system
        system_database = nil
        db_file = system_database_file
        # Second figure out if it's there, and if it isn't, create one.
        begin
          if (db_file.exists)
            debug("loading system database from file: " + RJava.cast_to_string(db_file))
            system_database = from_file(db_file)
          else
            system_database = IdentityDatabase.new(db_file)
          end
          IdentityScope.set_system_scope(system_database)
          debug("System database initialized: " + RJava.cast_to_string(system_database))
        rescue IOException => e
          debug("Error initializing identity database: " + RJava.cast_to_string(db_file), e)
          return
        rescue InvalidParameterException => e
          debug("Error trying to instantiate a system identities db in " + RJava.cast_to_string(db_file), e)
          return
        end
      end
    }
    
    typesig { [] }
    # private static File securityPropFile(String filename) {
    #     // maybe check for a system property which will specify where to
    #     // look.
    #     String sep = File.separator;
    #     return new File(System.getProperty("java.home") +
    #                     sep + "lib" + sep + "security" +
    #                     sep + filename);
    # }
    def to_s
      return "sun.security.provider.IdentityDatabase, source file: " + RJava.cast_to_string(@source_file)
    end
    
    class_module.module_eval {
      typesig { [String] }
      def debug(s)
        if (Debug)
          System.err.println(s)
        end
      end
      
      typesig { [String, JavaThrowable] }
      def debug(s, t)
        if (Debug)
          t.print_stack_trace
          System.err.println(s)
        end
      end
      
      typesig { [String] }
      def error(s)
        if (JavaError)
          System.err.println(s)
        end
      end
    }
    
    typesig { [String] }
    def local_check(directive)
      security = System.get_security_manager
      if (!(security).nil?)
        directive = RJava.cast_to_string(self.get_class.get_name) + "." + directive + "." + RJava.cast_to_string(local_full_name)
        security.check_security_access(directive)
      end
    end
    
    typesig { [] }
    # Returns a parsable name for identity: identityName.scopeName
    def local_full_name
      parsable = get_name
      if (!(get_scope).nil?)
        parsable += "." + RJava.cast_to_string(get_scope.get_name)
      end
      return parsable
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    # Serialization write.
    def write_object(stream)
      synchronized(self) do
        local_check("serialize.identity.database")
        stream.write_object(@identities)
        stream.write_object(@source_file)
      end
    end
    
    private
    alias_method :initialize__identity_database, :initialize
  end
  
end
