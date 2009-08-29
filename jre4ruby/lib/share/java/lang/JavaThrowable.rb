require "rjava"

# Copyright 1994-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang
  module ThrowableImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Io
    }
  end
  
  # The <code>Throwable</code> class is the superclass of all errors and
  # exceptions in the Java language. Only objects that are instances of this
  # class (or one of its subclasses) are thrown by the Java Virtual Machine or
  # can be thrown by the Java <code>throw</code> statement. Similarly, only
  # this class or one of its subclasses can be the argument type in a
  # <code>catch</code> clause.
  # 
  # <p>Instances of two subclasses, {@link java.lang.Error} and
  # {@link java.lang.Exception}, are conventionally used to indicate
  # that exceptional situations have occurred. Typically, these instances
  # are freshly created in the context of the exceptional situation so
  # as to include relevant information (such as stack trace data).
  # 
  # <p>A throwable contains a snapshot of the execution stack of its thread at
  # the time it was created. It can also contain a message string that gives
  # more information about the error. Finally, it can contain a <i>cause</i>:
  # another throwable that caused this throwable to get thrown.  The cause
  # facility is new in release 1.4.  It is also known as the <i>chained
  # exception</i> facility, as the cause can, itself, have a cause, and so on,
  # leading to a "chain" of exceptions, each caused by another.
  # 
  # <p>One reason that a throwable may have a cause is that the class that
  # throws it is built atop a lower layered abstraction, and an operation on
  # the upper layer fails due to a failure in the lower layer.  It would be bad
  # design to let the throwable thrown by the lower layer propagate outward, as
  # it is generally unrelated to the abstraction provided by the upper layer.
  # Further, doing so would tie the API of the upper layer to the details of
  # its implementation, assuming the lower layer's exception was a checked
  # exception.  Throwing a "wrapped exception" (i.e., an exception containing a
  # cause) allows the upper layer to communicate the details of the failure to
  # its caller without incurring either of these shortcomings.  It preserves
  # the flexibility to change the implementation of the upper layer without
  # changing its API (in particular, the set of exceptions thrown by its
  # methods).
  # 
  # <p>A second reason that a throwable may have a cause is that the method
  # that throws it must conform to a general-purpose interface that does not
  # permit the method to throw the cause directly.  For example, suppose
  # a persistent collection conforms to the {@link java.util.Collection
  # Collection} interface, and that its persistence is implemented atop
  # <tt>java.io</tt>.  Suppose the internals of the <tt>add</tt> method
  # can throw an {@link java.io.IOException IOException}.  The implementation
  # can communicate the details of the <tt>IOException</tt> to its caller
  # while conforming to the <tt>Collection</tt> interface by wrapping the
  # <tt>IOException</tt> in an appropriate unchecked exception.  (The
  # specification for the persistent collection should indicate that it is
  # capable of throwing such exceptions.)
  # 
  # <p>A cause can be associated with a throwable in two ways: via a
  # constructor that takes the cause as an argument, or via the
  # {@link #initCause(Throwable)} method.  New throwable classes that
  # wish to allow causes to be associated with them should provide constructors
  # that take a cause and delegate (perhaps indirectly) to one of the
  # <tt>Throwable</tt> constructors that takes a cause.  For example:
  # <pre>
  # try {
  # lowLevelOp();
  # } catch (LowLevelException le) {
  # throw new HighLevelException(le);  // Chaining-aware constructor
  # }
  # </pre>
  # Because the <tt>initCause</tt> method is public, it allows a cause to be
  # associated with any throwable, even a "legacy throwable" whose
  # implementation predates the addition of the exception chaining mechanism to
  # <tt>Throwable</tt>. For example:
  # <pre>
  # try {
  # lowLevelOp();
  # } catch (LowLevelException le) {
  # throw (HighLevelException)
  # new HighLevelException().initCause(le);  // Legacy constructor
  # }
  # </pre>
  # 
  # <p>Prior to release 1.4, there were many throwables that had their own
  # non-standard exception chaining mechanisms (
  # {@link ExceptionInInitializerError}, {@link ClassNotFoundException},
  # {@link java.lang.reflect.UndeclaredThrowableException},
  # {@link java.lang.reflect.InvocationTargetException},
  # {@link java.io.WriteAbortedException},
  # {@link java.security.PrivilegedActionException},
  # {@link java.awt.print.PrinterIOException},
  # {@link java.rmi.RemoteException} and
  # {@link javax.naming.NamingException}).
  # All of these throwables have been retrofitted to
  # use the standard exception chaining mechanism, while continuing to
  # implement their "legacy" chaining mechanisms for compatibility.
  # 
  # <p>Further, as of release 1.4, many general purpose <tt>Throwable</tt>
  # classes (for example {@link Exception}, {@link RuntimeException},
  # {@link Error}) have been retrofitted with constructors that take
  # a cause.  This was not strictly necessary, due to the existence of the
  # <tt>initCause</tt> method, but it is more convenient and expressive to
  # delegate to a constructor that takes a cause.
  # 
  # <p>By convention, class <code>Throwable</code> and its subclasses have two
  # constructors, one that takes no arguments and one that takes a
  # <code>String</code> argument that can be used to produce a detail message.
  # Further, those subclasses that might likely have a cause associated with
  # them should have two more constructors, one that takes a
  # <code>Throwable</code> (the cause), and one that takes a
  # <code>String</code> (the detail message) and a <code>Throwable</code> (the
  # cause).
  # 
  # <p>Also introduced in release 1.4 is the {@link #getStackTrace()} method,
  # which allows programmatic access to the stack trace information that was
  # previously available only in text form, via the various forms of the
  # {@link #printStackTrace()} method.  This information has been added to the
  # <i>serialized representation</i> of this class so <tt>getStackTrace</tt>
  # and <tt>printStackTrace</tt> will operate properly on a throwable that
  # was obtained by deserialization.
  # 
  # @author  unascribed
  # @author  Josh Bloch (Added exception chaining and programmatic access to
  # stack trace in 1.4.)
  # @since JDK1.0
  class JavaThrowable < Exception
    include_class_members ThrowableImports
    overload_protected {
      include Serializable
    }
    
    class_module.module_eval {
      # use serialVersionUID from JDK 1.0.2 for interoperability
      const_set_lazy(:SerialVersionUID) { -3042686055658047285 }
      const_attr_reader  :SerialVersionUID
    }
    
    # Native code saves some indication of the stack backtrace in this slot.
    attr_accessor :backtrace
    alias_method :attr_backtrace, :backtrace
    undef_method :backtrace
    alias_method :attr_backtrace=, :backtrace=
    undef_method :backtrace=
    
    # Specific details about the Throwable.  For example, for
    # <tt>FileNotFoundException</tt>, this contains the name of
    # the file that could not be found.
    # 
    # @serial
    attr_accessor :detail_message
    alias_method :attr_detail_message, :detail_message
    undef_method :detail_message
    alias_method :attr_detail_message=, :detail_message=
    undef_method :detail_message=
    
    # The throwable that caused this throwable to get thrown, or null if this
    # throwable was not caused by another throwable, or if the causative
    # throwable is unknown.  If this field is equal to this throwable itself,
    # it indicates that the cause of this throwable has not yet been
    # initialized.
    # 
    # @serial
    # @since 1.4
    attr_accessor :cause
    alias_method :attr_cause, :cause
    undef_method :cause
    alias_method :attr_cause=, :cause=
    undef_method :cause=
    
    # The stack trace, as returned by {@link #getStackTrace()}.
    # 
    # @serial
    # @since 1.4
    attr_accessor :stack_trace
    alias_method :attr_stack_trace, :stack_trace
    undef_method :stack_trace
    alias_method :attr_stack_trace=, :stack_trace=
    undef_method :stack_trace=
    
    typesig { [] }
    # This field is lazily initialized on first use or serialization and
    # nulled out when fillInStackTrace is called.
    # 
    # 
    # Constructs a new throwable with <code>null</code> as its detail message.
    # The cause is not initialized, and may subsequently be initialized by a
    # call to {@link #initCause}.
    # 
    # <p>The {@link #fillInStackTrace()} method is called to initialize
    # the stack trace data in the newly created throwable.
    def initialize
      @backtrace = nil
      @detail_message = nil
      @cause = nil
      @stack_trace = nil
      super()
      @cause = self
      fill_in_stack_trace
    end
    
    typesig { [String] }
    # Constructs a new throwable with the specified detail message.  The
    # cause is not initialized, and may subsequently be initialized by
    # a call to {@link #initCause}.
    # 
    # <p>The {@link #fillInStackTrace()} method is called to initialize
    # the stack trace data in the newly created throwable.
    # 
    # @param   message   the detail message. The detail message is saved for
    # later retrieval by the {@link #getMessage()} method.
    def initialize(message)
      @backtrace = nil
      @detail_message = nil
      @cause = nil
      @stack_trace = nil
      super()
      @cause = self
      fill_in_stack_trace
      @detail_message = message
    end
    
    typesig { [String, JavaThrowable] }
    # Constructs a new throwable with the specified detail message and
    # cause.  <p>Note that the detail message associated with
    # <code>cause</code> is <i>not</i> automatically incorporated in
    # this throwable's detail message.
    # 
    # <p>The {@link #fillInStackTrace()} method is called to initialize
    # the stack trace data in the newly created throwable.
    # 
    # @param  message the detail message (which is saved for later retrieval
    # by the {@link #getMessage()} method).
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link #getCause()} method).  (A <tt>null</tt> value is
    # permitted, and indicates that the cause is nonexistent or
    # unknown.)
    # @since  1.4
    def initialize(message, cause)
      @backtrace = nil
      @detail_message = nil
      @cause = nil
      @stack_trace = nil
      super()
      @cause = self
      fill_in_stack_trace
      @detail_message = message
      @cause = cause
    end
    
    typesig { [JavaThrowable] }
    # Constructs a new throwable with the specified cause and a detail
    # message of <tt>(cause==null ? null : cause.toString())</tt> (which
    # typically contains the class and detail message of <tt>cause</tt>).
    # This constructor is useful for throwables that are little more than
    # wrappers for other throwables (for example, {@link
    # java.security.PrivilegedActionException}).
    # 
    # <p>The {@link #fillInStackTrace()} method is called to initialize
    # the stack trace data in the newly created throwable.
    # 
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link #getCause()} method).  (A <tt>null</tt> value is
    # permitted, and indicates that the cause is nonexistent or
    # unknown.)
    # @since  1.4
    def initialize(cause)
      @backtrace = nil
      @detail_message = nil
      @cause = nil
      @stack_trace = nil
      super()
      @cause = self
      fill_in_stack_trace
      @detail_message = RJava.cast_to_string(((cause).nil? ? nil : cause.to_s))
      @cause = cause
    end
    
    typesig { [] }
    # Returns the detail message string of this throwable.
    # 
    # @return  the detail message string of this <tt>Throwable</tt> instance
    # (which may be <tt>null</tt>).
    def get_message
      return @detail_message
    end
    
    typesig { [] }
    # Creates a localized description of this throwable.
    # Subclasses may override this method in order to produce a
    # locale-specific message.  For subclasses that do not override this
    # method, the default implementation returns the same result as
    # <code>getMessage()</code>.
    # 
    # @return  The localized description of this throwable.
    # @since   JDK1.1
    def get_localized_message
      return get_message
    end
    
    typesig { [] }
    # Returns the cause of this throwable or <code>null</code> if the
    # cause is nonexistent or unknown.  (The cause is the throwable that
    # caused this throwable to get thrown.)
    # 
    # <p>This implementation returns the cause that was supplied via one of
    # the constructors requiring a <tt>Throwable</tt>, or that was set after
    # creation with the {@link #initCause(Throwable)} method.  While it is
    # typically unnecessary to override this method, a subclass can override
    # it to return a cause set by some other means.  This is appropriate for
    # a "legacy chained throwable" that predates the addition of chained
    # exceptions to <tt>Throwable</tt>.  Note that it is <i>not</i>
    # necessary to override any of the <tt>PrintStackTrace</tt> methods,
    # all of which invoke the <tt>getCause</tt> method to determine the
    # cause of a throwable.
    # 
    # @return  the cause of this throwable or <code>null</code> if the
    # cause is nonexistent or unknown.
    # @since 1.4
    def get_cause
      return ((@cause).equal?(self) ? nil : @cause)
    end
    
    typesig { [JavaThrowable] }
    # Initializes the <i>cause</i> of this throwable to the specified value.
    # (The cause is the throwable that caused this throwable to get thrown.)
    # 
    # <p>This method can be called at most once.  It is generally called from
    # within the constructor, or immediately after creating the
    # throwable.  If this throwable was created
    # with {@link #Throwable(Throwable)} or
    # {@link #Throwable(String,Throwable)}, this method cannot be called
    # even once.
    # 
    # @param  cause the cause (which is saved for later retrieval by the
    # {@link #getCause()} method).  (A <tt>null</tt> value is
    # permitted, and indicates that the cause is nonexistent or
    # unknown.)
    # @return  a reference to this <code>Throwable</code> instance.
    # @throws IllegalArgumentException if <code>cause</code> is this
    # throwable.  (A throwable cannot be its own cause.)
    # @throws IllegalStateException if this throwable was
    # created with {@link #Throwable(Throwable)} or
    # {@link #Throwable(String,Throwable)}, or this method has already
    # been called on this throwable.
    # @since  1.4
    def init_cause(cause)
      synchronized(self) do
        if (!(@cause).equal?(self))
          raise IllegalStateException.new("Can't overwrite cause")
        end
        if ((cause).equal?(self))
          raise IllegalArgumentException.new("Self-causation not permitted")
        end
        @cause = cause
        return self
      end
    end
    
    typesig { [] }
    # Returns a short description of this throwable.
    # The result is the concatenation of:
    # <ul>
    # <li> the {@linkplain Class#getName() name} of the class of this object
    # <li> ": " (a colon and a space)
    # <li> the result of invoking this object's {@link #getLocalizedMessage}
    # method
    # </ul>
    # If <tt>getLocalizedMessage</tt> returns <tt>null</tt>, then just
    # the class name is returned.
    # 
    # @return a string representation of this throwable.
    def to_s
      s = get_class.get_name
      message = get_localized_message
      return (!(message).nil?) ? (s + ": " + message) : s
    end
    
    typesig { [] }
    # Prints this throwable and its backtrace to the
    # standard error stream. This method prints a stack trace for this
    # <code>Throwable</code> object on the error output stream that is
    # the value of the field <code>System.err</code>. The first line of
    # output contains the result of the {@link #toString()} method for
    # this object.  Remaining lines represent data previously recorded by
    # the method {@link #fillInStackTrace()}. The format of this
    # information depends on the implementation, but the following
    # example may be regarded as typical:
    # <blockquote><pre>
    # java.lang.NullPointerException
    # at MyClass.mash(MyClass.java:9)
    # at MyClass.crunch(MyClass.java:6)
    # at MyClass.main(MyClass.java:3)
    # </pre></blockquote>
    # This example was produced by running the program:
    # <pre>
    # class MyClass {
    # public static void main(String[] args) {
    # crunch(null);
    # }
    # static void crunch(int[] a) {
    # mash(a);
    # }
    # static void mash(int[] b) {
    # System.out.println(b[0]);
    # }
    # }
    # </pre>
    # The backtrace for a throwable with an initialized, non-null cause
    # should generally include the backtrace for the cause.  The format
    # of this information depends on the implementation, but the following
    # example may be regarded as typical:
    # <pre>
    # HighLevelException: MidLevelException: LowLevelException
    # at Junk.a(Junk.java:13)
    # at Junk.main(Junk.java:4)
    # Caused by: MidLevelException: LowLevelException
    # at Junk.c(Junk.java:23)
    # at Junk.b(Junk.java:17)
    # at Junk.a(Junk.java:11)
    # ... 1 more
    # Caused by: LowLevelException
    # at Junk.e(Junk.java:30)
    # at Junk.d(Junk.java:27)
    # at Junk.c(Junk.java:21)
    # ... 3 more
    # </pre>
    # Note the presence of lines containing the characters <tt>"..."</tt>.
    # These lines indicate that the remainder of the stack trace for this
    # exception matches the indicated number of frames from the bottom of the
    # stack trace of the exception that was caused by this exception (the
    # "enclosing" exception).  This shorthand can greatly reduce the length
    # of the output in the common case where a wrapped exception is thrown
    # from same method as the "causative exception" is caught.  The above
    # example was produced by running the program:
    # <pre>
    # public class Junk {
    # public static void main(String args[]) {
    # try {
    # a();
    # } catch(HighLevelException e) {
    # e.printStackTrace();
    # }
    # }
    # static void a() throws HighLevelException {
    # try {
    # b();
    # } catch(MidLevelException e) {
    # throw new HighLevelException(e);
    # }
    # }
    # static void b() throws MidLevelException {
    # c();
    # }
    # static void c() throws MidLevelException {
    # try {
    # d();
    # } catch(LowLevelException e) {
    # throw new MidLevelException(e);
    # }
    # }
    # static void d() throws LowLevelException {
    # e();
    # }
    # static void e() throws LowLevelException {
    # throw new LowLevelException();
    # }
    # }
    # 
    # class HighLevelException extends Exception {
    # HighLevelException(Throwable cause) { super(cause); }
    # }
    # 
    # class MidLevelException extends Exception {
    # MidLevelException(Throwable cause)  { super(cause); }
    # }
    # 
    # class LowLevelException extends Exception {
    # }
    # </pre>
    def print_stack_trace
      print_stack_trace(System.err)
    end
    
    typesig { [PrintStream] }
    # Prints this throwable and its backtrace to the specified print stream.
    # 
    # @param s <code>PrintStream</code> to use for output
    def print_stack_trace(s)
      synchronized((s)) do
        s.println(self)
        trace = get_our_stack_trace
        i = 0
        while i < trace.attr_length
          s.println("\tat " + RJava.cast_to_string(trace[i]))
          i += 1
        end
        our_cause = get_cause
        if (!(our_cause).nil?)
          our_cause.print_stack_trace_as_cause(s, trace)
        end
      end
    end
    
    typesig { [PrintStream, Array.typed(StackTraceElement)] }
    # Print our stack trace as a cause for the specified stack trace.
    def print_stack_trace_as_cause(s, caused_trace)
      # assert Thread.holdsLock(s);
      # Compute number of frames in common between this and caused
      trace = get_our_stack_trace
      m = trace.attr_length - 1
      n = caused_trace.attr_length - 1
      while (m >= 0 && n >= 0 && (trace[m] == caused_trace[n]))
        m -= 1
        n -= 1
      end
      frames_in_common = trace.attr_length - 1 - m
      s.println("Caused by: " + RJava.cast_to_string(self))
      i = 0
      while i <= m
        s.println("\tat " + RJava.cast_to_string(trace[i]))
        i += 1
      end
      if (!(frames_in_common).equal?(0))
        s.println("\t... " + RJava.cast_to_string(frames_in_common) + " more")
      end
      # Recurse if we have a cause
      our_cause = get_cause
      if (!(our_cause).nil?)
        our_cause.print_stack_trace_as_cause(s, trace)
      end
    end
    
    typesig { [PrintWriter] }
    # Prints this throwable and its backtrace to the specified
    # print writer.
    # 
    # @param s <code>PrintWriter</code> to use for output
    # @since   JDK1.1
    def print_stack_trace(s)
      synchronized((s)) do
        s.println(self)
        trace = get_our_stack_trace
        i = 0
        while i < trace.attr_length
          s.println("\tat " + RJava.cast_to_string(trace[i]))
          i += 1
        end
        our_cause = get_cause
        if (!(our_cause).nil?)
          our_cause.print_stack_trace_as_cause(s, trace)
        end
      end
    end
    
    typesig { [PrintWriter, Array.typed(StackTraceElement)] }
    # Print our stack trace as a cause for the specified stack trace.
    def print_stack_trace_as_cause(s, caused_trace)
      # assert Thread.holdsLock(s);
      # Compute number of frames in common between this and caused
      trace = get_our_stack_trace
      m = trace.attr_length - 1
      n = caused_trace.attr_length - 1
      while (m >= 0 && n >= 0 && (trace[m] == caused_trace[n]))
        m -= 1
        n -= 1
      end
      frames_in_common = trace.attr_length - 1 - m
      s.println("Caused by: " + RJava.cast_to_string(self))
      i = 0
      while i <= m
        s.println("\tat " + RJava.cast_to_string(trace[i]))
        i += 1
      end
      if (!(frames_in_common).equal?(0))
        s.println("\t... " + RJava.cast_to_string(frames_in_common) + " more")
      end
      # Recurse if we have a cause
      our_cause = get_cause
      if (!(our_cause).nil?)
        our_cause.print_stack_trace_as_cause(s, trace)
      end
    end
    
    JNI.native_method :Java_java_lang_Throwable_fillInStackTrace, [:pointer, :long], :long
    typesig { [] }
    # Fills in the execution stack trace. This method records within this
    # <code>Throwable</code> object information about the current state of
    # the stack frames for the current thread.
    # 
    # @return  a reference to this <code>Throwable</code> instance.
    # @see     java.lang.Throwable#printStackTrace()
    def fill_in_stack_trace
      JNI.__send__(:Java_java_lang_Throwable_fillInStackTrace, JNI.env, self.jni_id)
    end
    
    typesig { [] }
    # Provides programmatic access to the stack trace information printed by
    # {@link #printStackTrace()}.  Returns an array of stack trace elements,
    # each representing one stack frame.  The zeroth element of the array
    # (assuming the array's length is non-zero) represents the top of the
    # stack, which is the last method invocation in the sequence.  Typically,
    # this is the point at which this throwable was created and thrown.
    # The last element of the array (assuming the array's length is non-zero)
    # represents the bottom of the stack, which is the first method invocation
    # in the sequence.
    # 
    # <p>Some virtual machines may, under some circumstances, omit one
    # or more stack frames from the stack trace.  In the extreme case,
    # a virtual machine that has no stack trace information concerning
    # this throwable is permitted to return a zero-length array from this
    # method.  Generally speaking, the array returned by this method will
    # contain one element for every frame that would be printed by
    # <tt>printStackTrace</tt>.
    # 
    # @return an array of stack trace elements representing the stack trace
    # pertaining to this throwable.
    # @since  1.4
    def get_stack_trace
      return get_our_stack_trace.clone
    end
    
    typesig { [] }
    def get_our_stack_trace
      synchronized(self) do
        # Initialize stack trace if this is the first call to this method
        if ((@stack_trace).nil?)
          depth = get_stack_trace_depth
          @stack_trace = Array.typed(StackTraceElement).new(depth) { nil }
          i = 0
          while i < depth
            @stack_trace[i] = get_stack_trace_element(i)
            i += 1
          end
        end
        return @stack_trace
      end
    end
    
    typesig { [Array.typed(StackTraceElement)] }
    # Sets the stack trace elements that will be returned by
    # {@link #getStackTrace()} and printed by {@link #printStackTrace()}
    # and related methods.
    # 
    # This method, which is designed for use by RPC frameworks and other
    # advanced systems, allows the client to override the default
    # stack trace that is either generated by {@link #fillInStackTrace()}
    # when a throwable is constructed or deserialized when a throwable is
    # read from a serialization stream.
    # 
    # @param   stackTrace the stack trace elements to be associated with
    # this <code>Throwable</code>.  The specified array is copied by this
    # call; changes in the specified array after the method invocation
    # returns will have no affect on this <code>Throwable</code>'s stack
    # trace.
    # 
    # @throws NullPointerException if <code>stackTrace</code> is
    # <code>null</code>, or if any of the elements of
    # <code>stackTrace</code> are <code>null</code>
    # 
    # @since  1.4
    def set_stack_trace(stack_trace)
      defensive_copy = stack_trace.clone
      i = 0
      while i < defensive_copy.attr_length
        if ((defensive_copy[i]).nil?)
          raise NullPointerException.new("stackTrace[" + RJava.cast_to_string(i) + "]")
        end
        i += 1
      end
      @stack_trace = defensive_copy
    end
    
    JNI.native_method :Java_java_lang_Throwable_getStackTraceDepth, [:pointer, :long], :int32
    typesig { [] }
    # Returns the number of elements in the stack trace (or 0 if the stack
    # trace is unavailable).
    def get_stack_trace_depth
      JNI.__send__(:Java_java_lang_Throwable_getStackTraceDepth, JNI.env, self.jni_id)
    end
    
    JNI.native_method :Java_java_lang_Throwable_getStackTraceElement, [:pointer, :long, :int32], :long
    typesig { [::Java::Int] }
    # Returns the specified element of the stack trace.
    # 
    # @param index index of the element to return.
    # @throws IndexOutOfBoundsException if <tt>index &lt; 0 ||
    # index &gt;= getStackTraceDepth() </tt>
    def get_stack_trace_element(index)
      JNI.__send__(:Java_java_lang_Throwable_getStackTraceElement, JNI.env, self.jni_id, index.to_int)
    end
    
    typesig { [Java::Io::ObjectOutputStream] }
    def write_object(s)
      synchronized(self) do
        get_our_stack_trace # Ensure that stackTrace field is initialized.
        s.default_write_object
      end
    end
    
    private
    alias_method :initialize__throwable, :initialize
  end
  
end
