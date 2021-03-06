require "rjava"

# Copyright 2001 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Nio::Channels
  module FileLockImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Nio::Channels
      include_const ::Java::Io, :IOException
    }
  end
  
  # A token representing a lock on a region of a file.
  # 
  # <p> A file-lock object is created each time a lock is acquired on a file via
  # one of the {@link FileChannel#lock(long,long,boolean) lock} or {@link
  # FileChannel#tryLock(long,long,boolean) tryLock} methods of the {@link
  # FileChannel} class.
  # 
  # <p> A file-lock object is initially valid.  It remains valid until the lock
  # is released by invoking the {@link #release release} method, by closing the
  # channel that was used to acquire it, or by the termination of the Java
  # virtual machine, whichever comes first.  The validity of a lock may be
  # tested by invoking its {@link #isValid isValid} method.
  # 
  # <p> A file lock is either <i>exclusive</i> or <i>shared</i>.  A shared lock
  # prevents other concurrently-running programs from acquiring an overlapping
  # exclusive lock, but does allow them to acquire overlapping shared locks.  An
  # exclusive lock prevents other programs from acquiring an overlapping lock of
  # either type.  Once it is released, a lock has no further effect on the locks
  # that may be acquired by other programs.
  # 
  # <p> Whether a lock is exclusive or shared may be determined by invoking its
  # {@link #isShared isShared} method.  Some platforms do not support shared
  # locks, in which case a request for a shared lock is automatically converted
  # into a request for an exclusive lock.
  # 
  # <p> The locks held on a particular file by a single Java virtual machine do
  # not overlap.  The {@link #overlaps overlaps} method may be used to test
  # whether a candidate lock range overlaps an existing lock.
  # 
  # <p> A file-lock object records the file channel upon whose file the lock is
  # held, the type and validity of the lock, and the position and size of the
  # locked region.  Only the validity of a lock is subject to change over time;
  # all other aspects of a lock's state are immutable.
  # 
  # <p> File locks are held on behalf of the entire Java virtual machine.
  # They are not suitable for controlling access to a file by multiple
  # threads within the same virtual machine.
  # 
  # <p> File-lock objects are safe for use by multiple concurrent threads.
  # 
  # 
  # <a name="pdep">
  # <h4> Platform dependencies </h4>
  # 
  # <p> This file-locking API is intended to map directly to the native locking
  # facility of the underlying operating system.  Thus the locks held on a file
  # should be visible to all programs that have access to the file, regardless
  # of the language in which those programs are written.
  # 
  # <p> Whether or not a lock actually prevents another program from accessing
  # the content of the locked region is system-dependent and therefore
  # unspecified.  The native file-locking facilities of some systems are merely
  # <i>advisory</i>, meaning that programs must cooperatively observe a known
  # locking protocol in order to guarantee data integrity.  On other systems
  # native file locks are <i>mandatory</i>, meaning that if one program locks a
  # region of a file then other programs are actually prevented from accessing
  # that region in a way that would violate the lock.  On yet other systems,
  # whether native file locks are advisory or mandatory is configurable on a
  # per-file basis.  To ensure consistent and correct behavior across platforms,
  # it is strongly recommended that the locks provided by this API be used as if
  # they were advisory locks.
  # 
  # <p> On some systems, acquiring a mandatory lock on a region of a file
  # prevents that region from being {@link java.nio.channels.FileChannel#map
  # </code>mapped into memory<code>}, and vice versa.  Programs that combine
  # locking and mapping should be prepared for this combination to fail.
  # 
  # <p> On some systems, closing a channel releases all locks held by the Java
  # virtual machine on the underlying file regardless of whether the locks were
  # acquired via that channel or via another channel open on the same file.  It
  # is strongly recommended that, within a program, a unique channel be used to
  # acquire all locks on any given file.
  # 
  # <p> Some network filesystems permit file locking to be used with
  # memory-mapped files only when the locked regions are page-aligned and a
  # whole multiple of the underlying hardware's page size.  Some network
  # filesystems do not implement file locks on regions that extend past a
  # certain position, often 2<sup>30</sup> or 2<sup>31</sup>.  In general, great
  # care should be taken when locking files that reside on network filesystems.
  # 
  # 
  # @author Mark Reinhold
  # @author JSR-51 Expert Group
  # @since 1.4
  class FileLock 
    include_class_members FileLockImports
    
    attr_accessor :channel
    alias_method :attr_channel, :channel
    undef_method :channel
    alias_method :attr_channel=, :channel=
    undef_method :channel=
    
    attr_accessor :position
    alias_method :attr_position, :position
    undef_method :position
    alias_method :attr_position=, :position=
    undef_method :position=
    
    attr_accessor :size
    alias_method :attr_size, :size
    undef_method :size
    alias_method :attr_size=, :size=
    undef_method :size=
    
    attr_accessor :shared
    alias_method :attr_shared, :shared
    undef_method :shared
    alias_method :attr_shared=, :shared=
    undef_method :shared=
    
    typesig { [FileChannel, ::Java::Long, ::Java::Long, ::Java::Boolean] }
    # Initializes a new instance of this class.  </p>
    # 
    # @param  channel
    #         The file channel upon whose file this lock is held
    # 
    # @param  position
    #         The position within the file at which the locked region starts;
    #         must be non-negative
    # 
    # @param  size
    #         The size of the locked region; must be non-negative, and the sum
    #         <tt>position</tt>&nbsp;+&nbsp;<tt>size</tt> must be non-negative
    # 
    # @param  shared
    #         <tt>true</tt> if this lock is shared,
    #         <tt>false</tt> if it is exclusive
    # 
    # @throws IllegalArgumentException
    #         If the preconditions on the parameters do not hold
    def initialize(channel, position, size, shared)
      @channel = nil
      @position = 0
      @size = 0
      @shared = false
      if (position < 0)
        raise IllegalArgumentException.new("Negative position")
      end
      if (size < 0)
        raise IllegalArgumentException.new("Negative size")
      end
      if (position + size < 0)
        raise IllegalArgumentException.new("Negative position + size")
      end
      @channel = channel
      @position = position
      @size = size
      @shared = shared
    end
    
    typesig { [] }
    # Returns the file channel upon whose file this lock is held.  </p>
    # 
    # @return  The file channel
    def channel
      return @channel
    end
    
    typesig { [] }
    # Returns the position within the file of the first byte of the locked
    # region.
    # 
    # <p> A locked region need not be contained within, or even overlap, the
    # actual underlying file, so the value returned by this method may exceed
    # the file's current size.  </p>
    # 
    # @return  The position
    def position
      return @position
    end
    
    typesig { [] }
    # Returns the size of the locked region in bytes.
    # 
    # <p> A locked region need not be contained within, or even overlap, the
    # actual underlying file, so the value returned by this method may exceed
    # the file's current size.  </p>
    # 
    # @return  The size of the locked region
    def size
      return @size
    end
    
    typesig { [] }
    # Tells whether this lock is shared.  </p>
    # 
    # @return <tt>true</tt> if lock is shared,
    #         <tt>false</tt> if it is exclusive
    def is_shared
      return @shared
    end
    
    typesig { [::Java::Long, ::Java::Long] }
    # Tells whether or not this lock overlaps the given lock range.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this lock and the given lock
    #          range overlap by at least one byte
    def overlaps(position, size)
      if (position + size <= @position)
        return false
      end # That is below this
      if (@position + @size <= position)
        return false
      end # This is below that
      return true
    end
    
    typesig { [] }
    # Tells whether or not this lock is valid.
    # 
    # <p> A lock object remains valid until it is released or the associated
    # file channel is closed, whichever comes first.  </p>
    # 
    # @return  <tt>true</tt> if, and only if, this lock is valid
    def is_valid
      raise NotImplementedError
    end
    
    typesig { [] }
    # Releases this lock.
    # 
    # <p> If this lock object is valid then invoking this method releases the
    # lock and renders the object invalid.  If this lock object is invalid
    # then invoking this method has no effect.  </p>
    # 
    # @throws  ClosedChannelException
    #          If the channel that was used to acquire this lock
    #          is no longer open
    # 
    # @throws  IOException
    #          If an I/O error occurs
    def release
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns a string describing the range, type, and validity of this lock.
    # 
    # @return  A descriptive string
    def to_s
      return (RJava.cast_to_string(self.get_class.get_name) + "[" + RJava.cast_to_string(@position) + ":" + RJava.cast_to_string(@size) + " " + RJava.cast_to_string((@shared ? "shared" : "exclusive")) + " " + RJava.cast_to_string((is_valid ? "valid" : "invalid")) + "]")
    end
    
    private
    alias_method :initialize__file_lock, :initialize
  end
  
end
