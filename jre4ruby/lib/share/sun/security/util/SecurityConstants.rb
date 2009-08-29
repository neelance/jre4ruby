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
module Sun::Security::Util
  module SecurityConstantsImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Util
      include_const ::Java::Io, :FilePermission
      include_const ::Java::Awt, :AWTPermission
      include_const ::Java::Util, :PropertyPermission
      include_const ::Java::Lang, :RuntimePermission
      include_const ::Java::Net, :SocketPermission
      include_const ::Java::Net, :NetPermission
      include_const ::Java::Security, :SecurityPermission
      include_const ::Java::Security, :AllPermission
      include_const ::Javax::Security::Auth, :AuthPermission
    }
  end
  
  # Permission constants and string constants used to create permissions
  # used throughout the JDK.
  class SecurityConstants 
    include_class_members SecurityConstantsImports
    
    typesig { [] }
    # Cannot create one of these
    def initialize
    end
    
    class_module.module_eval {
      # Commonly used string constants for permission actions used by
      # SecurityManager. Declare here for shortcut when checking permissions
      # in FilePermission, SocketPermission, and PropertyPermission.
      const_set_lazy(:FILE_DELETE_ACTION) { "delete" }
      const_attr_reader  :FILE_DELETE_ACTION
      
      const_set_lazy(:FILE_EXECUTE_ACTION) { "execute" }
      const_attr_reader  :FILE_EXECUTE_ACTION
      
      const_set_lazy(:FILE_READ_ACTION) { "read" }
      const_attr_reader  :FILE_READ_ACTION
      
      const_set_lazy(:FILE_WRITE_ACTION) { "write" }
      const_attr_reader  :FILE_WRITE_ACTION
      
      const_set_lazy(:SOCKET_RESOLVE_ACTION) { "resolve" }
      const_attr_reader  :SOCKET_RESOLVE_ACTION
      
      const_set_lazy(:SOCKET_CONNECT_ACTION) { "connect" }
      const_attr_reader  :SOCKET_CONNECT_ACTION
      
      const_set_lazy(:SOCKET_LISTEN_ACTION) { "listen" }
      const_attr_reader  :SOCKET_LISTEN_ACTION
      
      const_set_lazy(:SOCKET_ACCEPT_ACTION) { "accept" }
      const_attr_reader  :SOCKET_ACCEPT_ACTION
      
      const_set_lazy(:SOCKET_CONNECT_ACCEPT_ACTION) { "connect,accept" }
      const_attr_reader  :SOCKET_CONNECT_ACCEPT_ACTION
      
      const_set_lazy(:PROPERTY_RW_ACTION) { "read,write" }
      const_attr_reader  :PROPERTY_RW_ACTION
      
      const_set_lazy(:PROPERTY_READ_ACTION) { "read" }
      const_attr_reader  :PROPERTY_READ_ACTION
      
      const_set_lazy(:PROPERTY_WRITE_ACTION) { "write" }
      const_attr_reader  :PROPERTY_WRITE_ACTION
      
      # Permission constants used in the various checkPermission() calls in JDK.
      # java.lang.Class, java.lang.SecurityManager, java.lang.System,
      # java.net.URLConnection, java.security.AllPermission, java.security.Policy,
      # sun.security.provider.PolicyFile
      const_set_lazy(:ALL_PERMISSION) { AllPermission.new }
      const_attr_reader  :ALL_PERMISSION
      
      # java.lang.SecurityManager
      const_set_lazy(:TOPLEVEL_WINDOW_PERMISSION) { AWTPermission.new("showWindowWithoutWarningBanner") }
      const_attr_reader  :TOPLEVEL_WINDOW_PERMISSION
      
      # java.lang.SecurityManager
      const_set_lazy(:ACCESS_CLIPBOARD_PERMISSION) { AWTPermission.new("accessClipboard") }
      const_attr_reader  :ACCESS_CLIPBOARD_PERMISSION
      
      # java.lang.SecurityManager
      const_set_lazy(:CHECK_AWT_EVENTQUEUE_PERMISSION) { AWTPermission.new("accessEventQueue") }
      const_attr_reader  :CHECK_AWT_EVENTQUEUE_PERMISSION
      
      # java.awt.Dialog
      const_set_lazy(:TOOLKIT_MODALITY_PERMISSION) { AWTPermission.new("toolkitModality") }
      const_attr_reader  :TOOLKIT_MODALITY_PERMISSION
      
      # java.awt.Robot
      const_set_lazy(:READ_DISPLAY_PIXELS_PERMISSION) { AWTPermission.new("readDisplayPixels") }
      const_attr_reader  :READ_DISPLAY_PIXELS_PERMISSION
      
      # java.awt.Robot
      const_set_lazy(:CREATE_ROBOT_PERMISSION) { AWTPermission.new("createRobot") }
      const_attr_reader  :CREATE_ROBOT_PERMISSION
      
      # java.awt.MouseInfo
      const_set_lazy(:WATCH_MOUSE_PERMISSION) { AWTPermission.new("watchMousePointer") }
      const_attr_reader  :WATCH_MOUSE_PERMISSION
      
      # java.awt.Window
      const_set_lazy(:SET_WINDOW_ALWAYS_ON_TOP_PERMISSION) { AWTPermission.new("setWindowAlwaysOnTop") }
      const_attr_reader  :SET_WINDOW_ALWAYS_ON_TOP_PERMISSION
      
      # java.awt.Toolkit
      const_set_lazy(:ALL_AWT_EVENTS_PERMISSION) { AWTPermission.new("listenToAllAWTEvents") }
      const_attr_reader  :ALL_AWT_EVENTS_PERMISSION
      
      # java.awt.SystemTray
      const_set_lazy(:ACCESS_SYSTEM_TRAY_PERMISSION) { AWTPermission.new("accessSystemTray") }
      const_attr_reader  :ACCESS_SYSTEM_TRAY_PERMISSION
      
      # java.net.URL
      const_set_lazy(:SPECIFY_HANDLER_PERMISSION) { NetPermission.new("specifyStreamHandler") }
      const_attr_reader  :SPECIFY_HANDLER_PERMISSION
      
      # java.net.ProxySelector
      const_set_lazy(:SET_PROXYSELECTOR_PERMISSION) { NetPermission.new("setProxySelector") }
      const_attr_reader  :SET_PROXYSELECTOR_PERMISSION
      
      # java.net.ProxySelector
      const_set_lazy(:GET_PROXYSELECTOR_PERMISSION) { NetPermission.new("getProxySelector") }
      const_attr_reader  :GET_PROXYSELECTOR_PERMISSION
      
      # java.net.CookieHandler
      const_set_lazy(:SET_COOKIEHANDLER_PERMISSION) { NetPermission.new("setCookieHandler") }
      const_attr_reader  :SET_COOKIEHANDLER_PERMISSION
      
      # java.net.CookieHandler
      const_set_lazy(:GET_COOKIEHANDLER_PERMISSION) { NetPermission.new("getCookieHandler") }
      const_attr_reader  :GET_COOKIEHANDLER_PERMISSION
      
      # java.net.ResponseCache
      const_set_lazy(:SET_RESPONSECACHE_PERMISSION) { NetPermission.new("setResponseCache") }
      const_attr_reader  :SET_RESPONSECACHE_PERMISSION
      
      # java.net.ResponseCache
      const_set_lazy(:GET_RESPONSECACHE_PERMISSION) { NetPermission.new("getResponseCache") }
      const_attr_reader  :GET_RESPONSECACHE_PERMISSION
      
      # java.lang.SecurityManager, sun.applet.AppletPanel, sun.misc.Launcher
      const_set_lazy(:CREATE_CLASSLOADER_PERMISSION) { RuntimePermission.new("createClassLoader") }
      const_attr_reader  :CREATE_CLASSLOADER_PERMISSION
      
      # java.lang.SecurityManager
      const_set_lazy(:CHECK_MEMBER_ACCESS_PERMISSION) { RuntimePermission.new("accessDeclaredMembers") }
      const_attr_reader  :CHECK_MEMBER_ACCESS_PERMISSION
      
      # java.lang.SecurityManager, sun.applet.AppletSecurity
      const_set_lazy(:MODIFY_THREAD_PERMISSION) { RuntimePermission.new("modifyThread") }
      const_attr_reader  :MODIFY_THREAD_PERMISSION
      
      # java.lang.SecurityManager, sun.applet.AppletSecurity
      const_set_lazy(:MODIFY_THREADGROUP_PERMISSION) { RuntimePermission.new("modifyThreadGroup") }
      const_attr_reader  :MODIFY_THREADGROUP_PERMISSION
      
      # java.lang.Class
      const_set_lazy(:GET_PD_PERMISSION) { RuntimePermission.new("getProtectionDomain") }
      const_attr_reader  :GET_PD_PERMISSION
      
      # java.lang.Class, java.lang.ClassLoader, java.lang.Thread
      const_set_lazy(:GET_CLASSLOADER_PERMISSION) { RuntimePermission.new("getClassLoader") }
      const_attr_reader  :GET_CLASSLOADER_PERMISSION
      
      # java.lang.Thread
      const_set_lazy(:STOP_THREAD_PERMISSION) { RuntimePermission.new("stopThread") }
      const_attr_reader  :STOP_THREAD_PERMISSION
      
      # java.lang.Thread
      const_set_lazy(:GET_STACK_TRACE_PERMISSION) { RuntimePermission.new("getStackTrace") }
      const_attr_reader  :GET_STACK_TRACE_PERMISSION
      
      # java.security.AccessControlContext
      const_set_lazy(:CREATE_ACC_PERMISSION) { SecurityPermission.new("createAccessControlContext") }
      const_attr_reader  :CREATE_ACC_PERMISSION
      
      # java.security.AccessControlContext
      const_set_lazy(:GET_COMBINER_PERMISSION) { SecurityPermission.new("getDomainCombiner") }
      const_attr_reader  :GET_COMBINER_PERMISSION
      
      # java.security.Policy, java.security.ProtectionDomain
      const_set_lazy(:GET_POLICY_PERMISSION) { SecurityPermission.new("getPolicy") }
      const_attr_reader  :GET_POLICY_PERMISSION
      
      # java.lang.SecurityManager
      const_set_lazy(:LOCAL_LISTEN_PERMISSION) { SocketPermission.new("localhost:1024-", SOCKET_LISTEN_ACTION) }
      const_attr_reader  :LOCAL_LISTEN_PERMISSION
      
      # javax.security.auth.Subject
      const_set_lazy(:DO_AS_PERMISSION) { AuthPermission.new("doAs") }
      const_attr_reader  :DO_AS_PERMISSION
      
      # javax.security.auth.Subject
      const_set_lazy(:DO_AS_PRIVILEGED_PERMISSION) { AuthPermission.new("doAsPrivileged") }
      const_attr_reader  :DO_AS_PRIVILEGED_PERMISSION
    }
    
    private
    alias_method :initialize__security_constants, :initialize
  end
  
end
