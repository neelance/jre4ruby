require "rjava"

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
module Java::Util::Logging
  module FileHandlerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Util::Logging
      include ::Java::Io
      include_const ::Java::Nio::Channels, :FileChannel
      include_const ::Java::Nio::Channels, :FileLock
      include ::Java::Security
    }
  end
  
  # Simple file logging <tt>Handler</tt>.
  # <p>
  # The <tt>FileHandler</tt> can either write to a specified file,
  # or it can write to a rotating set of files.
  # <p>
  # For a rotating set of files, as each file reaches a given size
  # limit, it is closed, rotated out, and a new file opened.
  # Successively older files are named by adding "0", "1", "2",
  # etc into the base filename.
  # <p>
  # By default buffering is enabled in the IO libraries but each log
  # record is flushed out when it is complete.
  # <p>
  # By default the <tt>XMLFormatter</tt> class is used for formatting.
  # <p>
  # <b>Configuration:</b>
  # By default each <tt>FileHandler</tt> is initialized using the following
  # <tt>LogManager</tt> configuration properties.  If properties are not defined
  # (or have invalid values) then the specified default values are used.
  # <ul>
  # <li>   java.util.logging.FileHandler.level
  # specifies the default level for the <tt>Handler</tt>
  # (defaults to <tt>Level.ALL</tt>).
  # <li>   java.util.logging.FileHandler.filter
  # specifies the name of a <tt>Filter</tt> class to use
  # (defaults to no <tt>Filter</tt>).
  # <li>   java.util.logging.FileHandler.formatter
  # specifies the name of a <tt>Formatter</tt> class to use
  # (defaults to <tt>java.util.logging.XMLFormatter</tt>)
  # <li>   java.util.logging.FileHandler.encoding
  # the name of the character set encoding to use (defaults to
  # the default platform encoding).
  # <li>   java.util.logging.FileHandler.limit
  # specifies an approximate maximum amount to write (in bytes)
  # to any one file.  If this is zero, then there is no limit.
  # (Defaults to no limit).
  # <li>   java.util.logging.FileHandler.count
  # specifies how many output files to cycle through (defaults to 1).
  # <li>   java.util.logging.FileHandler.pattern
  # specifies a pattern for generating the output file name.  See
  # below for details. (Defaults to "%h/java%u.log").
  # <li>   java.util.logging.FileHandler.append
  # specifies whether the FileHandler should append onto
  # any existing files (defaults to false).
  # </ul>
  # <p>
  # <p>
  # A pattern consists of a string that includes the following special
  # components that will be replaced at runtime:
  # <ul>
  # <li>    "/"    the local pathname separator
  # <li>     "%t"   the system temporary directory
  # <li>     "%h"   the value of the "user.home" system property
  # <li>     "%g"   the generation number to distinguish rotated logs
  # <li>     "%u"   a unique number to resolve conflicts
  # <li>     "%%"   translates to a single percent sign "%"
  # </ul>
  # If no "%g" field has been specified and the file count is greater
  # than one, then the generation number will be added to the end of
  # the generated filename, after a dot.
  # <p>
  # Thus for example a pattern of "%t/java%g.log" with a count of 2
  # would typically cause log files to be written on Solaris to
  # /var/tmp/java0.log and /var/tmp/java1.log whereas on Windows 95 they
  # would be typically written to C:\TEMP\java0.log and C:\TEMP\java1.log
  # <p>
  # Generation numbers follow the sequence 0, 1, 2, etc.
  # <p>
  # Normally the "%u" unique field is set to 0.  However, if the <tt>FileHandler</tt>
  # tries to open the filename and finds the file is currently in use by
  # another process it will increment the unique number field and try
  # again.  This will be repeated until <tt>FileHandler</tt> finds a file name that
  # is  not currently in use. If there is a conflict and no "%u" field has
  # been specified, it will be added at the end of the filename after a dot.
  # (This will be after any automatically added generation number.)
  # <p>
  # Thus if three processes were all trying to log to fred%u.%g.txt then
  # they  might end up using fred0.0.txt, fred1.0.txt, fred2.0.txt as
  # the first file in their rotating sequences.
  # <p>
  # Note that the use of unique ids to avoid conflicts is only guaranteed
  # to work reliably when using a local disk file system.
  # 
  # @since 1.4
  class FileHandler < FileHandlerImports.const_get :StreamHandler
    include_class_members FileHandlerImports
    
    attr_accessor :meter
    alias_method :attr_meter, :meter
    undef_method :meter
    alias_method :attr_meter=, :meter=
    undef_method :meter=
    
    attr_accessor :append
    alias_method :attr_append, :append
    undef_method :append
    alias_method :attr_append=, :append=
    undef_method :append=
    
    attr_accessor :limit
    alias_method :attr_limit, :limit
    undef_method :limit
    alias_method :attr_limit=, :limit=
    undef_method :limit=
    
    # zero => no limit.
    attr_accessor :count
    alias_method :attr_count, :count
    undef_method :count
    alias_method :attr_count=, :count=
    undef_method :count=
    
    attr_accessor :pattern
    alias_method :attr_pattern, :pattern
    undef_method :pattern
    alias_method :attr_pattern=, :pattern=
    undef_method :pattern=
    
    attr_accessor :lock_file_name
    alias_method :attr_lock_file_name, :lock_file_name
    undef_method :lock_file_name
    alias_method :attr_lock_file_name=, :lock_file_name=
    undef_method :lock_file_name=
    
    attr_accessor :lock_stream
    alias_method :attr_lock_stream, :lock_stream
    undef_method :lock_stream
    alias_method :attr_lock_stream=, :lock_stream=
    undef_method :lock_stream=
    
    attr_accessor :files
    alias_method :attr_files, :files
    undef_method :files
    alias_method :attr_files=, :files=
    undef_method :files=
    
    class_module.module_eval {
      const_set_lazy(:MAX_LOCKS) { 100 }
      const_attr_reader  :MAX_LOCKS
      
      
      def locks
        defined?(@@locks) ? @@locks : @@locks= Java::Util::HashMap.new
      end
      alias_method :attr_locks, :locks
      
      def locks=(value)
        @@locks = value
      end
      alias_method :attr_locks=, :locks=
      
      # A metered stream is a subclass of OutputStream that
      # (a) forwards all its output to a target stream
      # (b) keeps track of how many bytes have been written
      const_set_lazy(:MeteredStream) { Class.new(OutputStream) do
        extend LocalClass
        include_class_members FileHandler
        
        attr_accessor :out
        alias_method :attr_out, :out
        undef_method :out
        alias_method :attr_out=, :out=
        undef_method :out=
        
        attr_accessor :written
        alias_method :attr_written, :written
        undef_method :written
        alias_method :attr_written=, :written=
        undef_method :written=
        
        typesig { [OutputStream, ::Java::Int] }
        def initialize(out, written)
          @out = nil
          @written = 0
          super()
          @out = out
          @written = written
        end
        
        typesig { [::Java::Int] }
        def write(b)
          @out.write(b)
          ((@written += 1) - 1)
        end
        
        typesig { [Array.typed(::Java::Byte)] }
        def write(buff)
          @out.write(buff)
          @written += buff.attr_length
        end
        
        typesig { [Array.typed(::Java::Byte), ::Java::Int, ::Java::Int] }
        def write(buff, off, len)
          @out.write(buff, off, len)
          @written += len
        end
        
        typesig { [] }
        def flush
          @out.flush
        end
        
        typesig { [] }
        def close
          @out.close
        end
        
        private
        alias_method :initialize__metered_stream, :initialize
      end }
    }
    
    typesig { [JavaFile, ::Java::Boolean] }
    def open(fname, append)
      len = 0
      if (append)
        len = RJava.cast_to_int(fname.length)
      end
      fout = FileOutputStream.new(fname.to_s, append)
      bout = BufferedOutputStream.new(fout)
      @meter = MeteredStream.new_local(self, bout, len)
      set_output_stream(@meter)
    end
    
    typesig { [] }
    # Private method to configure a FileHandler from LogManager
    # properties and/or default values as specified in the class
    # javadoc.
    def configure
      manager = LogManager.get_log_manager
      cname = get_class.get_name
      @pattern = (manager.get_string_property(cname + ".pattern", "%h/java%u.log")).to_s
      @limit = manager.get_int_property(cname + ".limit", 0)
      if (@limit < 0)
        @limit = 0
      end
      @count = manager.get_int_property(cname + ".count", 1)
      if (@count <= 0)
        @count = 1
      end
      @append = manager.get_boolean_property(cname + ".append", false)
      set_level(manager.get_level_property(cname + ".level", Level::ALL))
      set_filter(manager.get_filter_property(cname + ".filter", nil))
      set_formatter(manager.get_formatter_property(cname + ".formatter", XMLFormatter.new))
      begin
        set_encoding(manager.get_string_property(cname + ".encoding", nil))
      rescue Exception => ex
        begin
          set_encoding(nil)
        rescue Exception => ex2
          # doing a setEncoding with null should always work.
          # assert false;
        end
      end
    end
    
    typesig { [] }
    # Construct a default <tt>FileHandler</tt>.  This will be configured
    # entirely from <tt>LogManager</tt> properties (or their default values).
    # <p>
    # @exception  IOException if there are IO problems opening the files.
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control"))</tt>.
    # @exception  NullPointerException if pattern property is an empty String.
    def initialize
      @meter = nil
      @append = false
      @limit = 0
      @count = 0
      @pattern = nil
      @lock_file_name = nil
      @lock_stream = nil
      @files = nil
      super()
      check_access
      configure
      open_files
    end
    
    typesig { [String] }
    # Initialize a <tt>FileHandler</tt> to write to the given filename.
    # <p>
    # The <tt>FileHandler</tt> is configured based on <tt>LogManager</tt>
    # properties (or their default values) except that the given pattern
    # argument is used as the filename pattern, the file limit is
    # set to no limit, and the file count is set to one.
    # <p>
    # There is no limit on the amount of data that may be written,
    # so use this with care.
    # 
    # @param pattern  the name of the output file
    # @exception  IOException if there are IO problems opening the files.
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    # @exception  IllegalArgumentException if pattern is an empty string
    def initialize(pattern)
      @meter = nil
      @append = false
      @limit = 0
      @count = 0
      @pattern = nil
      @lock_file_name = nil
      @lock_stream = nil
      @files = nil
      super()
      if (pattern.length < 1)
        raise IllegalArgumentException.new
      end
      check_access
      configure
      @pattern = pattern
      @limit = 0
      @count = 1
      open_files
    end
    
    typesig { [String, ::Java::Boolean] }
    # Initialize a <tt>FileHandler</tt> to write to the given filename,
    # with optional append.
    # <p>
    # The <tt>FileHandler</tt> is configured based on <tt>LogManager</tt>
    # properties (or their default values) except that the given pattern
    # argument is used as the filename pattern, the file limit is
    # set to no limit, the file count is set to one, and the append
    # mode is set to the given <tt>append</tt> argument.
    # <p>
    # There is no limit on the amount of data that may be written,
    # so use this with care.
    # 
    # @param pattern  the name of the output file
    # @param append  specifies append mode
    # @exception  IOException if there are IO problems opening the files.
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    # @exception  IllegalArgumentException if pattern is an empty string
    def initialize(pattern, append)
      @meter = nil
      @append = false
      @limit = 0
      @count = 0
      @pattern = nil
      @lock_file_name = nil
      @lock_stream = nil
      @files = nil
      super()
      if (pattern.length < 1)
        raise IllegalArgumentException.new
      end
      check_access
      configure
      @pattern = pattern
      @limit = 0
      @count = 1
      @append = append
      open_files
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Initialize a <tt>FileHandler</tt> to write to a set of files.  When
    # (approximately) the given limit has been written to one file,
    # another file will be opened.  The output will cycle through a set
    # of count files.
    # <p>
    # The <tt>FileHandler</tt> is configured based on <tt>LogManager</tt>
    # properties (or their default values) except that the given pattern
    # argument is used as the filename pattern, the file limit is
    # set to the limit argument, and the file count is set to the
    # given count argument.
    # <p>
    # The count must be at least 1.
    # 
    # @param pattern  the pattern for naming the output file
    # @param limit  the maximum number of bytes to write to any one file
    # @param count  the number of files to use
    # @exception  IOException if there are IO problems opening the files.
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    # @exception IllegalArgumentException if limit < 0, or count < 1.
    # @exception  IllegalArgumentException if pattern is an empty string
    def initialize(pattern, limit, count)
      @meter = nil
      @append = false
      @limit = 0
      @count = 0
      @pattern = nil
      @lock_file_name = nil
      @lock_stream = nil
      @files = nil
      super()
      if (limit < 0 || count < 1 || pattern.length < 1)
        raise IllegalArgumentException.new
      end
      check_access
      configure
      @pattern = pattern
      @limit = limit
      @count = count
      open_files
    end
    
    typesig { [String, ::Java::Int, ::Java::Int, ::Java::Boolean] }
    # Initialize a <tt>FileHandler</tt> to write to a set of files
    # with optional append.  When (approximately) the given limit has
    # been written to one file, another file will be opened.  The
    # output will cycle through a set of count files.
    # <p>
    # The <tt>FileHandler</tt> is configured based on <tt>LogManager</tt>
    # properties (or their default values) except that the given pattern
    # argument is used as the filename pattern, the file limit is
    # set to the limit argument, and the file count is set to the
    # given count argument, and the append mode is set to the given
    # <tt>append</tt> argument.
    # <p>
    # The count must be at least 1.
    # 
    # @param pattern  the pattern for naming the output file
    # @param limit  the maximum number of bytes to write to any one file
    # @param count  the number of files to use
    # @param append  specifies append mode
    # @exception  IOException if there are IO problems opening the files.
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    # @exception IllegalArgumentException if limit < 0, or count < 1.
    # @exception  IllegalArgumentException if pattern is an empty string
    def initialize(pattern, limit, count, append)
      @meter = nil
      @append = false
      @limit = 0
      @count = 0
      @pattern = nil
      @lock_file_name = nil
      @lock_stream = nil
      @files = nil
      super()
      if (limit < 0 || count < 1 || pattern.length < 1)
        raise IllegalArgumentException.new
      end
      check_access
      configure
      @pattern = pattern
      @limit = limit
      @count = count
      @append = append
      open_files
    end
    
    typesig { [] }
    # Private method to open the set of output files, based on the
    # configured instance variables.
    def open_files
      manager = LogManager.get_log_manager
      manager.check_access
      if (@count < 1)
        raise IllegalArgumentException.new("file count = " + (@count).to_s)
      end
      if (@limit < 0)
        @limit = 0
      end
      # We register our own ErrorManager during initialization
      # so we can record exceptions.
      em = InitializationErrorManager.new
      set_error_manager(em)
      # Create a lock file.  This grants us exclusive access
      # to our set of output files, as long as we are alive.
      unique = -1
      loop do
        ((unique += 1) - 1)
        if (unique > MAX_LOCKS)
          raise IOException.new("Couldn't get lock for " + @pattern)
        end
        # Generate a lock file name from the "unique" int.
        @lock_file_name = (generate(@pattern, 0, unique).to_s).to_s + ".lck"
        # Now try to lock that filename.
        # Because some systems (e.g. Solaris) can only do file locks
        # between processes (and not within a process), we first check
        # if we ourself already have the file locked.
        synchronized((self.attr_locks)) do
          if (!(self.attr_locks.get(@lock_file_name)).nil?)
            # We already own this lock, for a different FileHandler
            # object.  Try again.
            next
          end
          fc = nil
          begin
            @lock_stream = FileOutputStream.new(@lock_file_name)
            fc = @lock_stream.get_channel
          rescue IOException => ix
            # We got an IOException while trying to open the file.
            # Try the next file.
            next
          end
          begin
            fl = fc.try_lock
            if ((fl).nil?)
              # We failed to get the lock.  Try next file.
              next
            end
            # We got the lock OK.
          rescue IOException => ix
            # We got an IOException while trying to get the lock.
            # This normally indicates that locking is not supported
            # on the target directory.  We have to proceed without
            # getting a lock.   Drop through.
          end
          # We got the lock.  Remember it.
          self.attr_locks.put(@lock_file_name, @lock_file_name)
          break
        end
      end
      @files = Array.typed(JavaFile).new(@count) { nil }
      i = 0
      while i < @count
        @files[i] = generate(@pattern, i, unique)
        ((i += 1) - 1)
      end
      # Create the initial log file.
      if (@append)
        open(@files[0], true)
      else
        rotate
      end
      # Did we detect any exceptions during initialization?
      ex = em.attr_last_exception
      if (!(ex).nil?)
        if (ex.is_a?(IOException))
          raise ex
        else
          if (ex.is_a?(SecurityException))
            raise ex
          else
            raise IOException.new("Exception: " + (ex).to_s)
          end
        end
      end
      # Install the normal default ErrorManager.
      set_error_manager(ErrorManager.new)
    end
    
    typesig { [String, ::Java::Int, ::Java::Int] }
    # Generate a filename from a pattern.
    def generate(pattern, generation, unique)
      file = nil
      word = ""
      ix = 0
      sawg = false
      sawu = false
      while (ix < pattern.length)
        ch = pattern.char_at(ix)
        ((ix += 1) - 1)
        ch2 = 0
        if (ix < pattern.length)
          ch2 = Character.to_lower_case(pattern.char_at(ix))
        end
        if ((ch).equal?(Character.new(?/.ord)))
          if ((file).nil?)
            file = JavaFile.new(word)
          else
            file = JavaFile.new(file, word)
          end
          word = ""
          next
        else
          if ((ch).equal?(Character.new(?%.ord)))
            if ((ch2).equal?(Character.new(?t.ord)))
              tmp_dir = System.get_property("java.io.tmpdir")
              if ((tmp_dir).nil?)
                tmp_dir = (System.get_property("user.home")).to_s
              end
              file = JavaFile.new(tmp_dir)
              ((ix += 1) - 1)
              word = ""
              next
            else
              if ((ch2).equal?(Character.new(?h.ord)))
                file = JavaFile.new(System.get_property("user.home"))
                if (is_set_uid)
                  # Ok, we are in a set UID program.  For safety's sake
                  # we disallow attempts to open files relative to %h.
                  raise IOException.new("can't use %h in set UID program")
                end
                ((ix += 1) - 1)
                word = ""
                next
              else
                if ((ch2).equal?(Character.new(?g.ord)))
                  word = word + (generation).to_s
                  sawg = true
                  ((ix += 1) - 1)
                  next
                else
                  if ((ch2).equal?(Character.new(?u.ord)))
                    word = word + (unique).to_s
                    sawu = true
                    ((ix += 1) - 1)
                    next
                  else
                    if ((ch2).equal?(Character.new(?%.ord)))
                      word = word + "%"
                      ((ix += 1) - 1)
                      next
                    end
                  end
                end
              end
            end
          end
        end
        word = word + (ch).to_s
      end
      if (@count > 1 && !sawg)
        word = word + "." + (generation).to_s
      end
      if (unique > 0 && !sawu)
        word = word + "." + (unique).to_s
      end
      if (word.length > 0)
        if ((file).nil?)
          file = JavaFile.new(word)
        else
          file = JavaFile.new(file, word)
        end
      end
      return file
    end
    
    typesig { [] }
    # Rotate the set of output files
    def rotate
      synchronized(self) do
        old_level = get_level
        set_level(Level::OFF)
        StreamHandler.instance_method(:close).bind(self).call
        i = @count - 2
        while i >= 0
          f1 = @files[i]
          f2 = @files[i + 1]
          if (f1.exists)
            if (f2.exists)
              f2.delete
            end
            f1.rename_to(f2)
          end
          ((i -= 1) + 1)
        end
        begin
          open(@files[0], false)
        rescue IOException => ix
          # We don't want to throw an exception here, but we
          # report the exception to any registered ErrorManager.
          report_error(nil, ix, ErrorManager::OPEN_FAILURE)
        end
        set_level(old_level)
      end
    end
    
    typesig { [LogRecord] }
    # Format and publish a <tt>LogRecord</tt>.
    # 
    # @param  record  description of the log event. A null record is
    # silently ignored and is not published
    def publish(record)
      synchronized(self) do
        if (!is_loggable(record))
          return
        end
        super(record)
        flush
        if (@limit > 0 && @meter.attr_written >= @limit)
          AccessController.do_privileged(# We performed access checks in the "init" method to make sure
          # we are only initialized from trusted code.  So we assume
          # it is OK to write the target files, even if we are
          # currently being called from untrusted code.
          # So it is safe to raise privilege here.
          Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
            extend LocalClass
            include_class_members FileHandler
            include PrivilegedAction if PrivilegedAction.class == Module
            
            typesig { [] }
            define_method :run do
              rotate
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
      end
    end
    
    typesig { [] }
    # Close all the files.
    # 
    # @exception  SecurityException  if a security manager exists and if
    # the caller does not have <tt>LoggingPermission("control")</tt>.
    def close
      synchronized(self) do
        super
        # Unlock any lock file.
        if ((@lock_file_name).nil?)
          return
        end
        begin
          # Closing the lock file's FileOutputStream will close
          # the underlying channel and free any locks.
          @lock_stream.close
        rescue Exception => ex
          # Problems closing the stream.  Punt.
        end
        synchronized((self.attr_locks)) do
          self.attr_locks.remove(@lock_file_name)
        end
        JavaFile.new(@lock_file_name).delete
        @lock_file_name = (nil).to_s
        @lock_stream = nil
      end
    end
    
    class_module.module_eval {
      const_set_lazy(:InitializationErrorManager) { Class.new(ErrorManager) do
        include_class_members FileHandler
        
        attr_accessor :last_exception
        alias_method :attr_last_exception, :last_exception
        undef_method :last_exception
        alias_method :attr_last_exception=, :last_exception=
        undef_method :last_exception=
        
        typesig { [String, Exception, ::Java::Int] }
        def error(msg, ex, code)
          @last_exception = ex
        end
        
        typesig { [] }
        def initialize
          @last_exception = nil
          super()
        end
        
        private
        alias_method :initialize__initialization_error_manager, :initialize
      end }
      
      JNI.native_method :Java_java_util_logging_FileHandler_isSetUID, [:pointer, :long], :int8
      typesig { [] }
      # Private native method to check if we are in a set UID program.
      def is_set_uid
        JNI.__send__(:Java_java_util_logging_FileHandler_isSetUID, JNI.env, self.jni_id) != 0
      end
    }
    
    private
    alias_method :initialize__file_handler, :initialize
  end
  
end
