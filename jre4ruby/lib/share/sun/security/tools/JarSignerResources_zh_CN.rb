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
module Sun::Security::Tools
  module JarSignerResources_zh_CNImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Tools
    }
  end
  
  # <p> This class represents the <code>ResourceBundle</code>
  # for JarSigner.
  class JarSignerResources_zh_CN < Java::Util::ListResourceBundle
    include_class_members JarSignerResources_zh_CNImports
    
    class_module.module_eval {
      # shared (from jarsigner)
      const_set_lazy(:Contents) { Array.typed(Array.typed(Object)).new([Array.typed(Object).new([" ", " "]), Array.typed(Object).new(["  ", "  "]), Array.typed(Object).new(["      ", "      "]), Array.typed(Object).new([", ", ", "]), Array.typed(Object).new(["provName not a provider", ("{0} ".to_u << 0x4e0d << "".to_u << 0x662f << "".to_u << 0x63d0 << "".to_u << 0x4f9b << "".to_u << 0x8005 << "")]), Array.typed(Object).new(["signerClass is not a signing mechanism", ("{0} ".to_u << 0x4e0d << "".to_u << 0x662f << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x673a << "".to_u << 0x5236 << "")]), Array.typed(Object).new(["jarsigner error: ", ("jarsigner ".to_u << 0x9519 << "".to_u << 0x8bef << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Illegal option: ", ("".to_u << 0x975e << "".to_u << 0x6cd5 << "".to_u << 0x9009 << "".to_u << 0x9879 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["-keystore must be NONE if -storetype is {0}", ("".to_u << 0x5982 << "".to_u << 0x679c << " -storetype ".to_u << 0x4e3a << " {0}".to_u << 0xff0c << "".to_u << 0x5219 << " -keystore ".to_u << 0x5fc5 << "".to_u << 0x987b << "".to_u << 0x4e3a << " NONE")]), Array.typed(Object).new(["-keypass can not be specified if -storetype is {0}", ("".to_u << 0x5982 << "".to_u << 0x679c << " -storetype ".to_u << 0x4e3a << " {0}".to_u << 0xff0c << "".to_u << 0x5219 << "".to_u << 0x4e0d << "".to_u << 0x80fd << "".to_u << 0x6307 << "".to_u << 0x5b9a << " -keypass")]), Array.typed(Object).new(["If -protected is specified, then -storepass and -keypass must not be specified", ("".to_u << 0x5982 << "".to_u << 0x679c << "".to_u << 0x6307 << "".to_u << 0x5b9a << "".to_u << 0x4e86 << " -protected".to_u << 0xff0c << "".to_u << 0x5219 << "".to_u << 0x4e0d << "".to_u << 0x80fd << "".to_u << 0x6307 << "".to_u << 0x5b9a << " -storepass ".to_u << 0x548c << " -keypass")]), Array.typed(Object).new(["If keystore is not password protected, then -storepass and -keypass must not be specified", ("".to_u << 0x5982 << "".to_u << 0x679c << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x672a << "".to_u << 0x53d7 << "".to_u << 0x5bc6 << "".to_u << 0x7801 << "".to_u << 0x4fdd << "".to_u << 0x62a4 << "".to_u << 0xff0c << "".to_u << 0x5219 << "".to_u << 0x8bf7 << "".to_u << 0x52ff << "".to_u << 0x6307 << "".to_u << 0x5b9a << " -storepass ".to_u << 0x548c << " -keypass")]), Array.typed(Object).new(["Usage: jarsigner [options] jar-file alias", ("".to_u << 0x7528 << "".to_u << 0x6cd5 << "".to_u << 0xff1a << "jarsigner [".to_u << 0x9009 << "".to_u << 0x9879 << "] jar ".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x522b << "".to_u << 0x540d << "")]), Array.typed(Object).new(["       jarsigner -verify [options] jar-file", ("       jarsigner -verify [".to_u << 0x9009 << "".to_u << 0x9879 << "] jar ".to_u << 0x6587 << "".to_u << 0x4ef6 << "")]), Array.typed(Object).new(["[-keystore <url>]           keystore location", ("[-keystore <url>]           ".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x4f4d << "".to_u << 0x7f6e << "")]), Array.typed(Object).new(["[-storepass <password>]     password for keystore integrity", ("[-storepass <".to_u << 0x53e3 << "".to_u << 0x4ee4 << ">]         ".to_u << 0x7528 << "".to_u << 0x4e8e << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x5b8c << "".to_u << 0x6574 << "".to_u << 0x6027 << "".to_u << 0x7684 << "".to_u << 0x53e3 << "".to_u << 0x4ee4 << "")]), Array.typed(Object).new(["[-storetype <type>]         keystore type", ("[-storetype <".to_u << 0x7c7b << "".to_u << 0x578b << ">]         ".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x7c7b << "".to_u << 0x578b << "")]), Array.typed(Object).new(["[-keypass <password>]       password for private key (if different)", ("[-keypass <".to_u << 0x53e3 << "".to_u << 0x4ee4 << ">]           ".to_u << 0x4e13 << "".to_u << 0x7528 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x7684 << "".to_u << 0x53e3 << "".to_u << 0x4ee4 << "".to_u << 0xff08 << "".to_u << 0x5982 << "".to_u << 0x679c << "".to_u << 0x4e0d << "".to_u << 0x540c << "".to_u << 0xff09 << "")]), Array.typed(Object).new(["[-sigfile <file>]           name of .SF/.DSA file", ("[-sigfile <".to_u << 0x6587 << "".to_u << 0x4ef6 << ">]           .SF/.DSA ".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x7684 << "".to_u << 0x540d << "".to_u << 0x79f0 << "")]), Array.typed(Object).new(["[-signedjar <file>]         name of signed JAR file", ("[-signedjar <".to_u << 0x6587 << "".to_u << 0x4ef6 << ">]         ".to_u << 0x5df2 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x7684 << " JAR ".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x7684 << "".to_u << 0x540d << "".to_u << 0x79f0 << "")]), Array.typed(Object).new(["[-digestalg <algorithm>]    name of digest algorithm", ("[-digestalg <".to_u << 0x7b97 << "".to_u << 0x6cd5 << ">]    ".to_u << 0x6458 << "".to_u << 0x8981 << "".to_u << 0x7b97 << "".to_u << 0x6cd5 << "".to_u << 0x7684 << "".to_u << 0x540d << "".to_u << 0x79f0 << "")]), Array.typed(Object).new(["[-sigalg <algorithm>]       name of signature algorithm", ("[-sigalg <".to_u << 0x7b97 << "".to_u << 0x6cd5 << ">]       ".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x7b97 << "".to_u << 0x6cd5 << "".to_u << 0x7684 << "".to_u << 0x540d << "".to_u << 0x79f0 << "")]), Array.typed(Object).new(["[-verify]                   verify a signed JAR file", ("[-verify]                   ".to_u << 0x9a8c << "".to_u << 0x8bc1 << "".to_u << 0x5df2 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x7684 << " JAR ".to_u << 0x6587 << "".to_u << 0x4ef6 << "")]), Array.typed(Object).new(["[-verbose]                  verbose output when signing/verifying", ("[-verbose]                  ".to_u << 0x7b7e << "".to_u << 0x540d << "/".to_u << 0x9a8c << "".to_u << 0x8bc1 << "".to_u << 0x65f6 << "".to_u << 0x8f93 << "".to_u << 0x51fa << "".to_u << 0x8be6 << "".to_u << 0x7ec6 << "".to_u << 0x4fe1 << "".to_u << 0x606f << "")]), Array.typed(Object).new(["[-certs]                    display certificates when verbose and verifying", ("[-certs]                    ".to_u << 0x8f93 << "".to_u << 0x51fa << "".to_u << 0x8be6 << "".to_u << 0x7ec6 << "".to_u << 0x4fe1 << "".to_u << 0x606f << "".to_u << 0x548c << "".to_u << 0x9a8c << "".to_u << 0x8bc1 << "".to_u << 0x65f6 << "".to_u << 0x663e << "".to_u << 0x793a << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "")]), Array.typed(Object).new(["[-tsa <url>]                location of the Timestamping Authority", ("[-tsa <url>]                ".to_u << 0x65f6 << "".to_u << 0x95f4 << "".to_u << 0x6233 << "".to_u << 0x673a << "".to_u << 0x6784 << "".to_u << 0x7684 << "".to_u << 0x4f4d << "".to_u << 0x7f6e << "")]), Array.typed(Object).new(["[-tsacert <alias>]          public key certificate for Timestamping Authority", ("[-tsacert <".to_u << 0x522b << "".to_u << 0x540d << ">]           ".to_u << 0x65f6 << "".to_u << 0x95f4 << "".to_u << 0x6233 << "".to_u << 0x673a << "".to_u << 0x6784 << "".to_u << 0x7684 << "".to_u << 0x516c << "".to_u << 0x5171 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "")]), Array.typed(Object).new(["[-altsigner <class>]        class name of an alternative signing mechanism", ("[-altsigner <".to_u << 0x7c7b << ">]           ".to_u << 0x66ff << "".to_u << 0x4ee3 << "".to_u << 0x7684 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x673a << "".to_u << 0x5236 << "".to_u << 0x7684 << "".to_u << 0x7c7b << "".to_u << 0x540d << "")]), Array.typed(Object).new(["[-altsignerpath <pathlist>] location of an alternative signing mechanism", ("[-altsignerpath <".to_u << 0x8def << "".to_u << 0x5f84 << "".to_u << 0x5217 << "".to_u << 0x8868 << ">] ".to_u << 0x66ff << "".to_u << 0x4ee3 << "".to_u << 0x7684 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x673a << "".to_u << 0x5236 << "".to_u << 0x7684 << "".to_u << 0x4f4d << "".to_u << 0x7f6e << "")]), Array.typed(Object).new(["[-internalsf]               include the .SF file inside the signature block", ("[-internalsf]               ".to_u << 0x5728 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x5757 << "".to_u << 0x5185 << "".to_u << 0x5305 << "".to_u << 0x542b << " .SF ".to_u << 0x6587 << "".to_u << 0x4ef6 << "")]), Array.typed(Object).new(["[-sectionsonly]             don't compute hash of entire manifest", ("[-sectionsonly]             ".to_u << 0x4e0d << "".to_u << 0x8ba1 << "".to_u << 0x7b97 << "".to_u << 0x6574 << "".to_u << 0x4e2a << "".to_u << 0x6e05 << "".to_u << 0x5355 << "".to_u << 0x7684 << "".to_u << 0x6563 << "".to_u << 0x5217 << "")]), Array.typed(Object).new(["[-protected]                keystore has protected authentication path", ("[-protected]                ".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x5df2 << "".to_u << 0x4fdd << "".to_u << 0x62a4 << "".to_u << 0x9a8c << "".to_u << 0x8bc1 << "".to_u << 0x8def << "".to_u << 0x5f84 << "")]), Array.typed(Object).new(["[-providerName <name>]      provider name", ("[-providerName <".to_u << 0x540d << "".to_u << 0x79f0 << ">]      ".to_u << 0x63d0 << "".to_u << 0x4f9b << "".to_u << 0x8005 << "".to_u << 0x540d << "".to_u << 0x79f0 << "")]), Array.typed(Object).new(["[-providerClass <class>     name of cryptographic service provider's", ("[-providerClass <".to_u << 0x7c7b << ">        ".to_u << 0x52a0 << "".to_u << 0x5bc6 << "".to_u << 0x670d << "".to_u << 0x52a1 << "".to_u << 0x63d0 << "".to_u << 0x4f9b << "".to_u << 0x8005 << "".to_u << 0x7684 << "".to_u << 0x540d << "".to_u << 0x79f0 << "")]), Array.typed(Object).new(["  [-providerArg <arg>]] ... master class file and constructor argument", ("  [-providerArg <".to_u << 0x53c2 << "".to_u << 0x6570 << ">]] ... ".to_u << 0x4e3b << "".to_u << 0x7c7b << "".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x548c << "".to_u << 0x6784 << "".to_u << 0x9020 << "".to_u << 0x51fd << "".to_u << 0x6570 << "".to_u << 0x53c2 << "".to_u << 0x6570 << "")]), Array.typed(Object).new(["s", "s"]), Array.typed(Object).new(["m", "m"]), Array.typed(Object).new(["k", "k"]), Array.typed(Object).new(["i", "i"]), Array.typed(Object).new(["  s = signature was verified ", ("  s = ".to_u << 0x5df2 << "".to_u << 0x9a8c << "".to_u << 0x8bc1 << "".to_u << 0x7b7e << "".to_u << 0x540d << " ")]), Array.typed(Object).new(["  m = entry is listed in manifest", ("  m = ".to_u << 0x5728 << "".to_u << 0x6e05 << "".to_u << 0x5355 << "".to_u << 0x4e2d << "".to_u << 0x5217 << "".to_u << 0x51fa << "".to_u << 0x6761 << "".to_u << 0x76ee << "")]), Array.typed(Object).new(["  k = at least one certificate was found in keystore", ("  k = ".to_u << 0x5728 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x4e2d << "".to_u << 0x81f3 << "".to_u << 0x5c11 << "".to_u << 0x627e << "".to_u << 0x5230 << "".to_u << 0x4e86 << "".to_u << 0x4e00 << "".to_u << 0x4e2a << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "")]), Array.typed(Object).new(["  i = at least one certificate was found in identity scope", ("  i = ".to_u << 0x5728 << "".to_u << 0x8eab << "".to_u << 0x4efd << "".to_u << 0x4f5c << "".to_u << 0x7528 << "".to_u << 0x57df << "".to_u << 0x5185 << "".to_u << 0x81f3 << "".to_u << 0x5c11 << "".to_u << 0x627e << "".to_u << 0x5230 << "".to_u << 0x4e86 << "".to_u << 0x4e00 << "".to_u << 0x4e2a << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "")]), Array.typed(Object).new(["no manifest.", ("".to_u << 0x6ca1 << "".to_u << 0x6709 << "".to_u << 0x6e05 << "".to_u << 0x5355 << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["jar is unsigned. (signatures missing or not parsable)", ("jar ".to_u << 0x672a << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x3002 << "".to_u << 0xff08 << "".to_u << 0x7f3a << "".to_u << 0x5c11 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x6216 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x89e3 << "".to_u << 0x6790 << "".to_u << 0xff09 << "")]), Array.typed(Object).new(["jar verified.", ("jar ".to_u << 0x5df2 << "".to_u << 0x9a8c << "".to_u << 0x8bc1 << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["jarsigner: ", ("jarsigner".to_u << 0xff1a << " ")]), Array.typed(Object).new(["signature filename must consist of the following characters: A-Z, 0-9, _ or -", ("".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0x540d << "".to_u << 0x5fc5 << "".to_u << 0x987b << "".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x4ee5 << "".to_u << 0x4e0b << "".to_u << 0x5b57 << "".to_u << 0x7b26 << "".to_u << 0xff1a << "A-Z".to_u << 0x3001 << "0-9".to_u << 0x3001 << "_ ".to_u << 0x6216 << " -")]), Array.typed(Object).new(["unable to open jar file: ", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x6253 << "".to_u << 0x5f00 << " jar ".to_u << 0x6587 << "".to_u << 0x4ef6 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["unable to create: ", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x521b << "".to_u << 0x5efa << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["   adding: ", ("   ".to_u << 0x6b63 << "".to_u << 0x5728 << "".to_u << 0x6dfb << "".to_u << 0x52a0 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new([" updating: ", (" ".to_u << 0x6b63 << "".to_u << 0x5728 << "".to_u << 0x66f4 << "".to_u << 0x65b0 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["  signing: ", ("  ".to_u << 0x6b63 << "".to_u << 0x5728 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["attempt to rename signedJarFile to jarFile failed", ("".to_u << 0x5c1d << "".to_u << 0x8bd5 << "".to_u << 0x5c06 << " {0} ".to_u << 0x91cd << "".to_u << 0x547d << "".to_u << 0x540d << "".to_u << 0x4e3a << " {1} ".to_u << 0x5931 << "".to_u << 0x8d25 << "")]), Array.typed(Object).new(["attempt to rename jarFile to origJar failed", ("".to_u << 0x5c1d << "".to_u << 0x8bd5 << "".to_u << 0x5c06 << " {0} ".to_u << 0x91cd << "".to_u << 0x547d << "".to_u << 0x540d << "".to_u << 0x4e3a << " {1} ".to_u << 0x5931 << "".to_u << 0x8d25 << "")]), Array.typed(Object).new(["unable to sign jar: ", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x5bf9 << " jar ".to_u << 0x8fdb << "".to_u << 0x884c << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Enter Passphrase for keystore: ", ("".to_u << 0x8f93 << "".to_u << 0x5165 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x7684 << "".to_u << 0x53e3 << "".to_u << 0x4ee4 << "".to_u << 0x77ed << "".to_u << 0x8bed << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["keystore load: ", ("".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x88c5 << "".to_u << 0x5165 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["certificate exception: ", ("".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x5f02 << "".to_u << 0x5e38 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["unable to instantiate keystore class: ", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x5b9e << "".to_u << 0x4f8b << "".to_u << 0x5316 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x7c7b << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Certificate chain not found for: alias.  alias must reference a valid KeyStore key entry containing a private key and corresponding public key certificate chain.", ("".to_u << 0x627e << "".to_u << 0x4e0d << "".to_u << 0x5230 << " {0} ".to_u << 0x7684 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x94fe << "".to_u << 0x3002 << "{1} ".to_u << 0x5fc5 << "".to_u << 0x987b << "".to_u << 0x5f15 << "".to_u << 0x7528 << "".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x4e13 << "".to_u << 0x7528 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x548c << "".to_u << 0x76f8 << "".to_u << 0x5e94 << "".to_u << 0x7684 << "".to_u << 0x516c << "".to_u << 0x5171 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x94fe << "".to_u << 0x7684 << "".to_u << 0x6709 << "".to_u << 0x6548 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["found non-X.509 certificate in signer's chain", ("".to_u << 0x5728 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x7684 << "".to_u << 0x94fe << "".to_u << 0x4e2d << "".to_u << 0x627e << "".to_u << 0x5230 << "".to_u << 0x975e << " X.509 ".to_u << 0x8bc1 << "".to_u << 0x4e66 << "")]), Array.typed(Object).new(["incomplete certificate chain", ("".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x94fe << "".to_u << 0x4e0d << "".to_u << 0x5b8c << "".to_u << 0x6574 << "")]), Array.typed(Object).new(["Enter key password for alias: ", ("".to_u << 0x8f93 << "".to_u << 0x5165 << " {0} ".to_u << 0x7684 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x53e3 << "".to_u << 0x4ee4 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["unable to recover key from keystore", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x4ece << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x4e2d << "".to_u << 0x6062 << "".to_u << 0x590d << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "")]), Array.typed(Object).new(["key associated with alias not a private key", ("".to_u << 0x4e0e << " {0} ".to_u << 0x76f8 << "".to_u << 0x5173 << "".to_u << 0x7684 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x4e0d << "".to_u << 0x662f << "".to_u << 0x4e13 << "".to_u << 0x7528 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "")]), Array.typed(Object).new(["you must enter key password", ("".to_u << 0x60a8 << "".to_u << 0x5fc5 << "".to_u << 0x987b << "".to_u << 0x8f93 << "".to_u << 0x5165 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x53e3 << "".to_u << 0x4ee4 << "")]), Array.typed(Object).new(["unable to read password: ", ("".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x8bfb << "".to_u << 0x53d6 << "".to_u << 0x53e3 << "".to_u << 0x4ee4 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["certificate is valid from", ("".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x7684 << "".to_u << 0x6709 << "".to_u << 0x6548 << "".to_u << 0x671f << "".to_u << 0x4e3a << " {0} ".to_u << 0x81f3 << " {1}")]), Array.typed(Object).new(["certificate expired on", ("".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x5230 << "".to_u << 0x671f << "".to_u << 0x65e5 << "".to_u << 0x671f << "".to_u << 0x4e3a << " {0}")]), Array.typed(Object).new(["certificate is not valid until", ("".to_u << 0x76f4 << "".to_u << 0x5230 << " {0}".to_u << 0xff0c << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x624d << "".to_u << 0x6709 << "".to_u << 0x6548 << "")]), Array.typed(Object).new(["certificate will expire on", ("".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x5c06 << "".to_u << 0x5728 << " {0} ".to_u << 0x5230 << "".to_u << 0x671f << "")]), Array.typed(Object).new(["requesting a signature timestamp", ("".to_u << 0x6b63 << "".to_u << 0x5728 << "".to_u << 0x8bf7 << "".to_u << 0x6c42 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x65f6 << "".to_u << 0x95f4 << "".to_u << 0x6233 << "")]), Array.typed(Object).new(["TSA location: ", ("TSA ".to_u << 0x4f4d << "".to_u << 0x7f6e << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["TSA certificate: ", ("TSA ".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["no response from the Timestamping Authority. ", ("".to_u << 0x65f6 << "".to_u << 0x95f4 << "".to_u << 0x6233 << "".to_u << 0x673a << "".to_u << 0x6784 << "".to_u << 0x6ca1 << "".to_u << 0x6709 << "".to_u << 0x54cd << "".to_u << 0x5e94 << "".to_u << 0x3002 << " ")]), Array.typed(Object).new(["When connecting from behind a firewall then an HTTP proxy may need to be specified. ", ("".to_u << 0x5982 << "".to_u << 0x679c << "".to_u << 0x8981 << "".to_u << 0x4ece << "".to_u << 0x9632 << "".to_u << 0x706b << "".to_u << 0x5899 << "".to_u << 0x540e << "".to_u << 0x9762 << "".to_u << 0x8fde << "".to_u << 0x63a5 << "".to_u << 0xff0c << "".to_u << 0x5219 << "".to_u << 0x53ef << "".to_u << 0x80fd << "".to_u << 0x9700 << "".to_u << 0x8981 << "".to_u << 0x6307 << "".to_u << 0x5b9a << " HTTP ".to_u << 0x4ee3 << "".to_u << 0x7406 << "".to_u << 0x3002 << " ")]), Array.typed(Object).new(["Supply the following options to jarsigner: ", ("".to_u << 0x8bf7 << "".to_u << 0x4e3a << " jarsigner ".to_u << 0x63d0 << "".to_u << 0x4f9b << "".to_u << 0x4ee5 << "".to_u << 0x4e0b << "".to_u << 0x9009 << "".to_u << 0x9879 << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["Certificate not found for: alias.  alias must reference a valid KeyStore entry containing an X.509 public key certificate for the Timestamping Authority.", ("".to_u << 0x627e << "".to_u << 0x4e0d << "".to_u << 0x5230 << " {0} ".to_u << 0x7684 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x3002 << "{1} ".to_u << 0x5fc5 << "".to_u << 0x987b << "".to_u << 0x5f15 << "".to_u << 0x7528 << "".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x65f6 << "".to_u << 0x95f4 << "".to_u << 0x6233 << "".to_u << 0x673a << "".to_u << 0x6784 << "".to_u << 0x7684 << " X.509 ".to_u << 0x516c << "".to_u << 0x5171 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x7684 << "".to_u << 0x6709 << "".to_u << 0x6548 << "".to_u << 0x5bc6 << "".to_u << 0x94a5 << "".to_u << 0x5e93 << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["using an alternative signing mechanism", ("".to_u << 0x6b63 << "".to_u << 0x5728 << "".to_u << 0x4f7f << "".to_u << 0x7528 << "".to_u << 0x66ff << "".to_u << 0x4ee3 << "".to_u << 0x7684 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x673a << "".to_u << 0x5236 << "")]), Array.typed(Object).new(["entry was signed on", ("".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x7684 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x65e5 << "".to_u << 0x671f << "".to_u << 0x4e3a << " {0}")]), Array.typed(Object).new(["Warning: ", ("".to_u << 0x8b66 << "".to_u << 0x544a << "".to_u << 0xff1a << " ")]), Array.typed(Object).new(["This jar contains unsigned entries which have not been integrity-checked. ", ("".to_u << 0x6b64 << " jar ".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x5c1a << "".to_u << 0x672a << "".to_u << 0x8fdb << "".to_u << 0x884c << "".to_u << 0x5b8c << "".to_u << 0x6574 << "".to_u << 0x6027 << "".to_u << 0x68c0 << "".to_u << 0x67e5 << "".to_u << 0x7684 << "".to_u << 0x672a << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << " ")]), Array.typed(Object).new(["This jar contains entries whose signer certificate has expired. ", ("".to_u << 0x6b64 << " jar ".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x5df2 << "".to_u << 0x8fc7 << "".to_u << 0x671f << "".to_u << 0x7684 << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << " ")]), Array.typed(Object).new(["This jar contains entries whose signer certificate will expire within six months. ", ("".to_u << 0x6b64 << " jar ".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x5c06 << "".to_u << 0x5728 << "".to_u << 0x516d << "".to_u << 0x4e2a << "".to_u << 0x6708 << "".to_u << 0x5185 << "".to_u << 0x8fc7 << "".to_u << 0x671f << "".to_u << 0x7684 << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << " ")]), Array.typed(Object).new(["This jar contains entries whose signer certificate is not yet valid. ", ("".to_u << 0x6b64 << " jar ".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x4ecd << "".to_u << 0x65e0 << "".to_u << 0x6548 << "".to_u << 0x7684 << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << " ")]), Array.typed(Object).new(["Re-run with the -verbose option for more details.", ("".to_u << 0x8981 << "".to_u << 0x4e86 << "".to_u << 0x89e3 << "".to_u << 0x8be6 << "".to_u << 0x7ec6 << "".to_u << 0x4fe1 << "".to_u << 0x606f << "".to_u << 0xff0c << "".to_u << 0x8bf7 << "".to_u << 0x4f7f << "".to_u << 0x7528 << " -verbose ".to_u << 0x9009 << "".to_u << 0x9879 << "".to_u << 0x91cd << "".to_u << 0x65b0 << "".to_u << 0x8fd0 << "".to_u << 0x884c << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["Re-run with the -verbose and -certs options for more details.", ("".to_u << 0x8981 << "".to_u << 0x4e86 << "".to_u << 0x89e3 << "".to_u << 0x8be6 << "".to_u << 0x7ec6 << "".to_u << 0x4fe1 << "".to_u << 0x606f << "".to_u << 0xff0c << "".to_u << 0x8bf7 << "".to_u << 0x4f7f << "".to_u << 0x7528 << " -verbose ".to_u << 0x548c << " -certs ".to_u << 0x9009 << "".to_u << 0x9879 << "".to_u << 0x91cd << "".to_u << 0x65b0 << "".to_u << 0x8fd0 << "".to_u << 0x884c << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["The signer certificate has expired.", ("".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x5df2 << "".to_u << 0x8fc7 << "".to_u << 0x671f << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["The signer certificate will expire within six months.", ("".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x5c06 << "".to_u << 0x5728 << "".to_u << 0x516d << "".to_u << 0x4e2a << "".to_u << 0x6708 << "".to_u << 0x5185 << "".to_u << 0x8fc7 << "".to_u << 0x671f << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["The signer certificate is not yet valid.", ("".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x4ecd << "".to_u << 0x65e0 << "".to_u << 0x6548 << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["The signer certificate's KeyUsage extension doesn't allow code signing.", ("".to_u << 0x7531 << "".to_u << 0x4e8e << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x7684 << " KeyUsage ".to_u << 0x6269 << "".to_u << 0x5c55 << "".to_u << 0x800c << "".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x8fdb << "".to_u << 0x884c << "".to_u << 0x4ee3 << "".to_u << 0x7801 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["The signer certificate's ExtendedKeyUsage extension doesn't allow code signing.", ("".to_u << 0x7531 << "".to_u << 0x4e8e << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x7684 << " ExtendedKeyUsage ".to_u << 0x6269 << "".to_u << 0x5c55 << "".to_u << 0x800c << "".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x8fdb << "".to_u << 0x884c << "".to_u << 0x4ee3 << "".to_u << 0x7801 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["The signer certificate's NetscapeCertType extension doesn't allow code signing.", ("".to_u << 0x7531 << "".to_u << 0x4e8e << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x7684 << " NetscapeCertType ".to_u << 0x6269 << "".to_u << 0x5c55 << "".to_u << 0x800c << "".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x8fdb << "".to_u << 0x884c << "".to_u << 0x4ee3 << "".to_u << 0x7801 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["This jar contains entries whose signer certificate's KeyUsage extension doesn't allow code signing.", ("".to_u << 0x6b64 << " jar ".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x7531 << "".to_u << 0x4e8e << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x7684 << " KeyUsage ".to_u << 0x6269 << "".to_u << 0x5c55 << "".to_u << 0x800c << "".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x8fdb << "".to_u << 0x884c << "".to_u << 0x4ee3 << "".to_u << 0x7801 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x7684 << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["This jar contains entries whose signer certificate's ExtendedKeyUsage extension doesn't allow code signing.", ("".to_u << 0x6b64 << " jar ".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x7531 << "".to_u << 0x4e8e << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x7684 << " ExtendedKeyUsage ".to_u << 0x6269 << "".to_u << 0x5c55 << "".to_u << 0x800c << "".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x8fdb << "".to_u << 0x884c << "".to_u << 0x4ee3 << "".to_u << 0x7801 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x7684 << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["This jar contains entries whose signer certificate's NetscapeCertType extension doesn't allow code signing.", ("".to_u << 0x6b64 << " jar ".to_u << 0x5305 << "".to_u << 0x542b << "".to_u << 0x7531 << "".to_u << 0x4e8e << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x8005 << "".to_u << 0x8bc1 << "".to_u << 0x4e66 << "".to_u << 0x7684 << " NetscapeCertType ".to_u << 0x6269 << "".to_u << 0x5c55 << "".to_u << 0x800c << "".to_u << 0x65e0 << "".to_u << 0x6cd5 << "".to_u << 0x8fdb << "".to_u << 0x884c << "".to_u << 0x4ee3 << "".to_u << 0x7801 << "".to_u << 0x7b7e << "".to_u << 0x540d << "".to_u << 0x7684 << "".to_u << 0x6761 << "".to_u << 0x76ee << "".to_u << 0x3002 << "")]), Array.typed(Object).new(["[{0} extension does not support code signing]", ("[{0} ".to_u << 0x6269 << "".to_u << 0x5c55 << "".to_u << 0x4e0d << "".to_u << 0x652f << "".to_u << 0x6301 << "".to_u << 0x4ee3 << "".to_u << 0x7801 << "".to_u << 0x7b7e << "".to_u << 0x540d << "]")])]) }
      const_attr_reader  :Contents
    }
    
    typesig { [] }
    # Returns the contents of this <code>ResourceBundle</code>.
    # 
    # <p>
    # 
    # @return the contents of this <code>ResourceBundle</code>.
    def get_contents
      return Contents
    end
    
    typesig { [] }
    def initialize
      super()
    end
    
    private
    alias_method :initialize__jar_signer_resources_zh_cn, :initialize
  end
  
end
