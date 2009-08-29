require "rjava"

# Copyright 1997-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Security
  module AccessControlContextImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Security
      include_const ::Java::Util, :ArrayList
      include_const ::Java::Util, :JavaList
      include_const ::Sun::Security::Util, :Debug
      include_const ::Sun::Security::Util, :SecurityConstants
    }
  end
  
  # An AccessControlContext is used to make system resource access decisions
  # based on the context it encapsulates.
  # 
  # <p>More specifically, it encapsulates a context and
  # has a single method, <code>checkPermission</code>,
  # that is equivalent to the <code>checkPermission</code> method
  # in the AccessController class, with one difference: The AccessControlContext
  # <code>checkPermission</code> method makes access decisions based on the
  # context it encapsulates,
  # rather than that of the current execution thread.
  # 
  # <p>Thus, the purpose of AccessControlContext is for those situations where
  # a security check that should be made within a given context
  # actually needs to be done from within a
  # <i>different</i> context (for example, from within a worker thread).
  # 
  # <p> An AccessControlContext is created by calling the
  # <code>AccessController.getContext</code> method.
  # The <code>getContext</code> method takes a "snapshot"
  # of the current calling context, and places
  # it in an AccessControlContext object, which it returns. A sample call is
  # the following:
  # 
  # <pre>
  # AccessControlContext acc = AccessController.getContext()
  # </pre>
  # 
  # <p>
  # Code within a different context can subsequently call the
  # <code>checkPermission</code> method on the
  # previously-saved AccessControlContext object. A sample call is the
  # following:
  # 
  # <pre>
  # acc.checkPermission(permission)
  # </pre>
  # 
  # @see AccessController
  # 
  # @author Roland Schemers
  class AccessControlContext 
    include_class_members AccessControlContextImports
    
    attr_accessor :context
    alias_method :attr_context, :context
    undef_method :context
    alias_method :attr_context=, :context=
    undef_method :context=
    
    attr_accessor :is_privileged
    alias_method :attr_is_privileged, :is_privileged
    undef_method :is_privileged
    alias_method :attr_is_privileged=, :is_privileged=
    undef_method :is_privileged=
    
    # Note: This field is directly used by the virtual machine
    # native codes. Don't touch it.
    attr_accessor :privileged_context
    alias_method :attr_privileged_context, :privileged_context
    undef_method :privileged_context
    alias_method :attr_privileged_context=, :privileged_context=
    undef_method :privileged_context=
    
    attr_accessor :combiner
    alias_method :attr_combiner, :combiner
    undef_method :combiner
    alias_method :attr_combiner=, :combiner=
    undef_method :combiner=
    
    class_module.module_eval {
      
      def debug_init
        defined?(@@debug_init) ? @@debug_init : @@debug_init= false
      end
      alias_method :attr_debug_init, :debug_init
      
      def debug_init=(value)
        @@debug_init = value
      end
      alias_method :attr_debug_init=, :debug_init=
      
      
      def debug
        defined?(@@debug) ? @@debug : @@debug= nil
      end
      alias_method :attr_debug, :debug
      
      def debug=(value)
        @@debug = value
      end
      alias_method :attr_debug=, :debug=
      
      typesig { [] }
      def get_debug
        if (self.attr_debug_init)
          return self.attr_debug
        else
          if (Policy.is_set)
            self.attr_debug = Debug.get_instance("access")
            self.attr_debug_init = true
          end
          return self.attr_debug
        end
      end
    }
    
    typesig { [Array.typed(ProtectionDomain)] }
    # Create an AccessControlContext with the given set of ProtectionDomains.
    # Context must not be null. Duplicate domains will be removed from the
    # context.
    # 
    # @param context the ProtectionDomains associated with this context.
    # The non-duplicate domains are copied from the array. Subsequent
    # changes to the array will not affect this AccessControlContext.
    def initialize(context)
      @context = nil
      @is_privileged = false
      @privileged_context = nil
      @combiner = nil
      if ((context.attr_length).equal?(0))
        @context = nil
      else
        if ((context.attr_length).equal?(1))
          if (!(context[0]).nil?)
            @context = context.clone
          else
            @context = nil
          end
        else
          v = ArrayList.new(context.attr_length)
          i = 0
          while i < context.attr_length
            if ((!(context[i]).nil?) && (!v.contains(context[i])))
              v.add(context[i])
            end
            i += 1
          end
          @context = Array.typed(ProtectionDomain).new(v.size) { nil }
          @context = v.to_array(@context)
        end
      end
    end
    
    typesig { [AccessControlContext, DomainCombiner] }
    # Create a new <code>AccessControlContext</code> with the given
    # <code>AccessControlContext</code> and <code>DomainCombiner</code>.
    # This constructor associates the provided
    # <code>DomainCombiner</code> with the provided
    # <code>AccessControlContext</code>.
    # 
    # <p>
    # 
    # @param acc the <code>AccessControlContext</code> associated
    # with the provided <code>DomainCombiner</code>.
    # 
    # @param combiner the <code>DomainCombiner</code> to be associated
    # with the provided <code>AccessControlContext</code>.
    # 
    # @exception NullPointerException if the provided
    # <code>context</code> is <code>null</code>.
    # 
    # @exception SecurityException if a security manager is installed and the
    # caller does not have the "createAccessControlContext"
    # {@link SecurityPermission}
    # @since 1.3
    def initialize(acc, combiner)
      @context = nil
      @is_privileged = false
      @privileged_context = nil
      @combiner = nil
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(SecurityConstants::CREATE_ACC_PERMISSION)
      end
      @context = acc.attr_context
      # we do not need to run the combine method on the
      # provided ACC.  it was already "combined" when the
      # context was originally retrieved.
      # 
      # at this point in time, we simply throw away the old
      # combiner and use the newly provided one.
      @combiner = combiner
    end
    
    typesig { [Array.typed(ProtectionDomain), DomainCombiner] }
    # package private for AccessController
    def initialize(context, combiner)
      @context = nil
      @is_privileged = false
      @privileged_context = nil
      @combiner = nil
      if (!(context).nil?)
        @context = context.clone
      end
      @combiner = combiner
    end
    
    typesig { [Array.typed(ProtectionDomain), ::Java::Boolean] }
    # package private constructor for AccessController.getContext()
    def initialize(context, is_privileged)
      @context = nil
      @is_privileged = false
      @privileged_context = nil
      @combiner = nil
      @context = context
      @is_privileged = is_privileged
    end
    
    typesig { [] }
    # Returns true if this context is privileged.
    def is_privileged
      return @is_privileged
    end
    
    typesig { [] }
    # get the assigned combiner from the privileged or inherited context
    def get_assigned_combiner
      acc = nil
      if (@is_privileged)
        acc = @privileged_context
      else
        acc = AccessController.get_inherited_access_control_context
      end
      if (!(acc).nil?)
        return acc.attr_combiner
      end
      return nil
    end
    
    typesig { [] }
    # Get the <code>DomainCombiner</code> associated with this
    # <code>AccessControlContext</code>.
    # 
    # <p>
    # 
    # @return the <code>DomainCombiner</code> associated with this
    # <code>AccessControlContext</code>, or <code>null</code>
    # if there is none.
    # 
    # @exception SecurityException if a security manager is installed and
    # the caller does not have the "getDomainCombiner"
    # {@link SecurityPermission}
    # @since 1.3
    def get_domain_combiner
      sm = System.get_security_manager
      if (!(sm).nil?)
        sm.check_permission(SecurityConstants::GET_COMBINER_PERMISSION)
      end
      return @combiner
    end
    
    typesig { [Permission] }
    # Determines whether the access request indicated by the
    # specified permission should be allowed or denied, based on
    # the security policy currently in effect, and the context in
    # this object. The request is allowed only if every ProtectionDomain
    # in the context implies the permission. Otherwise the request is
    # denied.
    # 
    # <p>
    # This method quietly returns if the access request
    # is permitted, or throws a suitable AccessControlException otherwise.
    # 
    # @param perm the requested permission.
    # 
    # @exception AccessControlException if the specified permission
    # is not permitted, based on the current security policy and the
    # context encapsulated by this object.
    # @exception NullPointerException if the permission to check for is null.
    def check_permission(perm)
      dump_debug = false
      if ((perm).nil?)
        raise NullPointerException.new("permission can't be null")
      end
      if (!(get_debug).nil?)
        # If "codebase" is not specified, we dump the info by default.
        dump_debug = !Debug.is_on("codebase=")
        if (!dump_debug)
          # If "codebase" is specified, only dump if the specified code
          # value is in the stack.
          i = 0
          while !(@context).nil? && i < @context.attr_length
            if (!(@context[i].get_code_source).nil? && !(@context[i].get_code_source.get_location).nil? && Debug.is_on("codebase=" + RJava.cast_to_string(@context[i].get_code_source.get_location.to_s)))
              dump_debug = true
              break
            end
            i += 1
          end
        end
        dump_debug &= !Debug.is_on("permission=") || Debug.is_on("permission=" + RJava.cast_to_string(perm.get_class.get_canonical_name))
        if (dump_debug && Debug.is_on("stack"))
          JavaThread.current_thread.dump_stack
        end
        if (dump_debug && Debug.is_on("domain"))
          if ((@context).nil?)
            self.attr_debug.println("domain (context is null)")
          else
            i = 0
            while i < @context.attr_length
              self.attr_debug.println("domain " + RJava.cast_to_string(i) + " " + RJava.cast_to_string(@context[i]))
              i += 1
            end
          end
        end
      end
      # iterate through the ProtectionDomains in the context.
      # Stop at the first one that doesn't allow the
      # requested permission (throwing an exception).
      # 
      # 
      # if ctxt is null, all we had on the stack were system domains,
      # or the first domain was a Privileged system domain. This
      # is to make the common case for system code very fast
      if ((@context).nil?)
        return
      end
      i = 0
      while i < @context.attr_length
        if (!(@context[i]).nil? && !@context[i].implies(perm))
          if (dump_debug)
            self.attr_debug.println("access denied " + RJava.cast_to_string(perm))
          end
          if (Debug.is_on("failure"))
            # Want to make sure this is always displayed for failure,
            # but do not want to display again if already displayed
            # above.
            if (!dump_debug)
              self.attr_debug.println("access denied " + RJava.cast_to_string(perm))
            end
            JavaThread.current_thread.dump_stack
            pd = @context[i]
            db = self.attr_debug
            AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
              extend LocalClass
              include_class_members AccessControlContext
              include PrivilegedAction if PrivilegedAction.class == Module
              
              typesig { [] }
              define_method :run do
                db.println("domain that failed " + RJava.cast_to_string(pd))
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
          raise AccessControlException.new("access denied " + RJava.cast_to_string(perm), perm)
        end
        i += 1
      end
      # allow if all of them allowed access
      if (dump_debug)
        self.attr_debug.println("access allowed " + RJava.cast_to_string(perm))
      end
      return
    end
    
    typesig { [] }
    # Take the stack-based context (this) and combine it with the
    # privileged or inherited context, if need be.
    def optimize
      # the assigned (privileged or inherited) context
      acc = nil
      if (@is_privileged)
        acc = @privileged_context
      else
        acc = AccessController.get_inherited_access_control_context
      end
      # this.context could be null if only system code is on the stack;
      # in that case, ignore the stack context
      skip_stack = ((@context).nil?)
      # acc.context could be null if only system code was involved;
      # in that case, ignore the assigned context
      skip_assigned = ((acc).nil? || (acc.attr_context).nil?)
      if (!(acc).nil? && !(acc.attr_combiner).nil?)
        # let the assigned acc's combiner do its thing
        return go_combiner(@context, acc)
      end
      # optimization: if neither have contexts; return acc if possible
      # rather than this, because acc might have a combiner
      if (skip_assigned && skip_stack)
        return self
      end
      # optimization: if there is no stack context; there is no reason
      # to compress the assigned context, it already is compressed
      if (skip_stack)
        return acc
      end
      slen = @context.attr_length
      # optimization: if there is no assigned context and the stack length
      # is less then or equal to two; there is no reason to compress the
      # stack context, it already is
      if (skip_assigned && slen <= 2)
        return self
      end
      # optimization: if there is a single stack domain and that domain
      # is already in the assigned context; no need to combine
      if (((slen).equal?(1)) && ((@context[0]).equal?(acc.attr_context[0])))
        return acc
      end
      n = (skip_assigned) ? 0 : acc.attr_context.attr_length
      # now we combine both of them, and create a new context
      pd = Array.typed(ProtectionDomain).new(slen + n) { nil }
      # first copy in the assigned context domains, no need to compress
      if (!skip_assigned)
        System.arraycopy(acc.attr_context, 0, pd, 0, n)
      end
      # now add the stack context domains, discarding nulls and duplicates
      i = 0
      while i < @context.attr_length
        catch(:next_outer) do
          sd = @context[i]
          if (!(sd).nil?)
            j = 0
            while j < n
              if ((sd).equal?(pd[j]))
                throw :next_outer, :thrown
              end
              j += 1
            end
            pd[((n += 1) - 1)] = sd
          end
        end
        i += 1
      end
      # if length isn't equal, we need to shorten the array
      if (!(n).equal?(pd.attr_length))
        # optimization: if we didn't really combine anything
        if (!skip_assigned && (n).equal?(acc.attr_context.attr_length))
          return acc
        else
          if (skip_assigned && (n).equal?(slen))
            return self
          end
        end
        tmp = Array.typed(ProtectionDomain).new(n) { nil }
        System.arraycopy(pd, 0, tmp, 0, n)
        pd = tmp
      end
      # return new AccessControlContext(pd, false);
      # Reuse existing ACC
      @context = pd
      @combiner = nil
      @is_privileged = false
      return self
    end
    
    typesig { [Array.typed(ProtectionDomain), AccessControlContext] }
    def go_combiner(current, assigned)
      # the assigned ACC's combiner is not null --
      # let the combiner do its thing
      # XXX we could add optimizations to 'current' here ...
      if (!(get_debug).nil?)
        self.attr_debug.println("AccessControlContext invoking the Combiner")
      end
      # No need to clone current and assigned.context
      # combine() will not update them
      combined_pds = assigned.attr_combiner.combine(current, assigned.attr_context)
      # return new AccessControlContext(combinedPds, assigned.combiner);
      # Reuse existing ACC
      @context = combined_pds
      @combiner = assigned.attr_combiner
      @is_privileged = false
      return self
    end
    
    typesig { [Object] }
    # Checks two AccessControlContext objects for equality.
    # Checks that <i>obj</i> is
    # an AccessControlContext and has the same set of ProtectionDomains
    # as this context.
    # <P>
    # @param obj the object we are testing for equality with this object.
    # @return true if <i>obj</i> is an AccessControlContext, and has the
    # same set of ProtectionDomains as this context, false otherwise.
    def ==(obj)
      if ((obj).equal?(self))
        return true
      end
      if (!(obj.is_a?(AccessControlContext)))
        return false
      end
      that = obj
      if ((@context).nil?)
        return ((that.attr_context).nil?)
      end
      if ((that.attr_context).nil?)
        return false
      end
      if (!(self.contains_all_pds(that) && that.contains_all_pds(self)))
        return false
      end
      if ((@combiner).nil?)
        return ((that.attr_combiner).nil?)
      end
      if ((that.attr_combiner).nil?)
        return false
      end
      if (!(@combiner == that.attr_combiner))
        return false
      end
      return true
    end
    
    typesig { [AccessControlContext] }
    def contains_all_pds(that)
      match = false
      # ProtectionDomains within an ACC currently cannot be null
      # and this is enforced by the constructor and the various
      # optimize methods. However, historically this logic made attempts
      # to support the notion of a null PD and therefore this logic continues
      # to support that notion.
      this_pd = nil
      i = 0
      while i < @context.attr_length
        match = false
        if (((this_pd = @context[i])).nil?)
          j = 0
          while (j < that.attr_context.attr_length) && !match
            match = ((that.attr_context[j]).nil?)
            j += 1
          end
        else
          this_pd_class = this_pd.get_class
          that_pd = nil
          j = 0
          while (j < that.attr_context.attr_length) && !match
            that_pd = that.attr_context[j]
            # Class check required to avoid PD exposure (4285406)
            match = (!(that_pd).nil? && (this_pd_class).equal?(that_pd.get_class) && (this_pd == that_pd))
            j += 1
          end
        end
        if (!match)
          return false
        end
        i += 1
      end
      return match
    end
    
    typesig { [] }
    # Returns the hash code value for this context. The hash code
    # is computed by exclusive or-ing the hash code of all the protection
    # domains in the context together.
    # 
    # @return a hash code value for this context.
    def hash_code
      hash_code = 0
      if ((@context).nil?)
        return hash_code
      end
      i = 0
      while i < @context.attr_length
        if (!(@context[i]).nil?)
          hash_code ^= @context[i].hash_code
        end
        i += 1
      end
      return hash_code
    end
    
    private
    alias_method :initialize__access_control_context, :initialize
  end
  
end
