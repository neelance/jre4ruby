require "rjava"

# Copyright 2003-2005 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Jca
  module ProvidersImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Jca
      include ::Java::Util
      include_const ::Java::Security, :Provider
      include_const ::Java::Security, :Security
    }
  end
  
  # Collection of methods to get and set provider list. Also includes
  # special code for the provider list during JAR verification.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class Providers 
    include_class_members ProvidersImports
    
    class_module.module_eval {
      const_set_lazy(:ThreadLists) { InheritableThreadLocal.new }
      const_attr_reader  :ThreadLists
      
      # number of threads currently using thread-local provider lists
      # tracked to allow an optimization if == 0
      
      def thread_lists_used
        defined?(@@thread_lists_used) ? @@thread_lists_used : @@thread_lists_used= 0
      end
      alias_method :attr_thread_lists_used, :thread_lists_used
      
      def thread_lists_used=(value)
        @@thread_lists_used = value
      end
      alias_method :attr_thread_lists_used=, :thread_lists_used=
      
      # current system-wide provider list
      # Note volatile immutable object, so no synchronization needed.
      
      def provider_list
        defined?(@@provider_list) ? @@provider_list : @@provider_list= nil
      end
      alias_method :attr_provider_list, :provider_list
      
      def provider_list=(value)
        @@provider_list = value
      end
      alias_method :attr_provider_list=, :provider_list=
      
      when_class_loaded do
        # set providerList to empty list first in case initialization somehow
        # triggers a getInstance() call (although that should not happen)
        self.attr_provider_list = ProviderList::EMPTY
        self.attr_provider_list = ProviderList.from_security_properties
      end
    }
    
    typesig { [] }
    def initialize
      # empty
    end
    
    class_module.module_eval {
      # we need special handling to resolve circularities when loading
      # signed JAR files during startup. The code below is part of that.
      # Basically, before we load data from a signed JAR file, we parse
      # the PKCS#7 file and verify the signature. We need a
      # CertificateFactory, Signatures, etc. to do that. We have to make
      # sure that we do not try to load the implementation from the JAR
      # file we are just verifying.
      # 
      # To avoid that, we use different provider settings during JAR
      # verification.  However, we do not want those provider settings to
      # interfere with other parts of the system. Therefore, we make them local
      # to the Thread executing the JAR verification code.
      # 
      # The code here is used by sun.security.util.SignatureFileVerifier.
      # See there for details.
      const_set_lazy(:BACKUP_PROVIDER_CLASSNAME) { "sun.security.provider.VerificationProvider" }
      const_attr_reader  :BACKUP_PROVIDER_CLASSNAME
      
      # Hardcoded classnames of providers to use for JAR verification.
      # MUST NOT be on the bootclasspath and not in signed JAR files.
      const_set_lazy(:JarVerificationProviders) { Array.typed(String).new(["sun.security.provider.Sun", "sun.security.rsa.SunRsaSign", BACKUP_PROVIDER_CLASSNAME, ]) }
      const_attr_reader  :JarVerificationProviders
      
      typesig { [] }
      # Return to Sun provider or its backup.
      # This method should only be called by
      # sun.security.util.ManifestEntryVerifier and java.security.SecureRandom.
      def get_sun_provider
        begin
          clazz = Class.for_name(JarVerificationProviders[0])
          return clazz.new_instance
        rescue Exception => e
          begin
            clazz_ = Class.for_name(BACKUP_PROVIDER_CLASSNAME)
            return clazz_.new_instance
          rescue Exception => ee
            raise RuntimeException.new("Sun provider not found", e)
          end
        end
      end
      
      typesig { [] }
      # Start JAR verification. This sets a special provider list for
      # the current thread. You MUST save the return value from this
      # method and you MUST call stopJarVerification() with that object
      # once you are done.
      def start_jar_verification
        current_list = get_provider_list
        jar_list = current_list.get_jar_list(JarVerificationProviders)
        # return the old thread-local provider list, usually null
        return begin_thread_provider_list(jar_list)
      end
      
      typesig { [Object] }
      # Stop JAR verification. Call once you have completed JAR verification.
      def stop_jar_verification(obj)
        # restore old thread-local provider list
        end_thread_provider_list(obj)
      end
      
      typesig { [] }
      # Return the current ProviderList. If the thread-local list is set,
      # it is returned. Otherwise, the system wide list is returned.
      def get_provider_list
        list = get_thread_provider_list
        if ((list).nil?)
          list = get_system_provider_list
        end
        return list
      end
      
      typesig { [ProviderList] }
      # Set the current ProviderList. Affects the thread-local list if set,
      # otherwise the system wide list.
      def set_provider_list(new_list)
        if ((get_thread_provider_list).nil?)
          set_system_provider_list(new_list)
        else
          change_thread_provider_list(new_list)
        end
      end
      
      typesig { [] }
      # Get the full provider list with invalid providers (those that
      # could not be loaded) removed. This is the list we need to
      # present to applications.
      def get_full_provider_list
        synchronized(self) do
          list = get_thread_provider_list
          if (!(list).nil?)
            new_list = list.remove_invalid
            if (!(new_list).equal?(list))
              change_thread_provider_list(new_list)
              list = new_list
            end
            return list
          end
          list = get_system_provider_list
          new_list = list.remove_invalid
          if (!(new_list).equal?(list))
            set_system_provider_list(new_list)
            list = new_list
          end
          return list
        end
      end
      
      typesig { [] }
      def get_system_provider_list
        return self.attr_provider_list
      end
      
      typesig { [ProviderList] }
      def set_system_provider_list(list)
        self.attr_provider_list = list
      end
      
      typesig { [] }
      def get_thread_provider_list
        # avoid accessing the threadlocal if none are currently in use
        # (first use of ThreadLocal.get() for a Thread allocates a Map)
        if ((self.attr_thread_lists_used).equal?(0))
          return nil
        end
        return ThreadLists.get
      end
      
      typesig { [ProviderList] }
      # Change the thread local provider list. Use only if the current thread
      # is already using a thread local list and you want to change it in place.
      # In other cases, use the begin/endThreadProviderList() methods.
      def change_thread_provider_list(list)
        ThreadLists.set(list)
      end
      
      typesig { [ProviderList] }
      # Methods to manipulate the thread local provider list. It is for use by
      # JAR verification (see above) and the SunJSSE FIPS mode only.
      # 
      # It should be used as follows:
      # 
      # ProviderList list = ...;
      # ProviderList oldList = Providers.beginThreadProviderList(list);
      # try {
      # // code that needs thread local provider list
      # } finally {
      # Providers.endThreadProviderList(oldList);
      # }
      def begin_thread_provider_list(list)
        synchronized(self) do
          if (!(ProviderList.attr_debug).nil?)
            ProviderList.attr_debug.println("ThreadLocal providers: " + (list).to_s)
          end
          old_list = ThreadLists.get
          self.attr_thread_lists_used += 1
          ThreadLists.set(list)
          return old_list
        end
      end
      
      typesig { [ProviderList] }
      def end_thread_provider_list(list)
        synchronized(self) do
          if ((list).nil?)
            if (!(ProviderList.attr_debug).nil?)
              ProviderList.attr_debug.println("Disabling ThreadLocal providers")
            end
            ThreadLists.remove
          else
            if (!(ProviderList.attr_debug).nil?)
              ProviderList.attr_debug.println("Restoring previous ThreadLocal providers: " + (list).to_s)
            end
            ThreadLists.set(list)
          end
          self.attr_thread_lists_used -= 1
        end
      end
    }
    
    private
    alias_method :initialize__providers, :initialize
  end
  
end
