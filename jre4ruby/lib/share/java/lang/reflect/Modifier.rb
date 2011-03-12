require "rjava"

# Copyright 1996-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Java::Lang::Reflect
  module ModifierImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Lang::Reflect
      include_const ::Java::Security, :AccessController
      include_const ::Sun::Reflect, :LangReflectAccess
      include_const ::Sun::Reflect, :ReflectionFactory
    }
  end
  
  # The Modifier class provides {@code static} methods and
  # constants to decode class and member access modifiers.  The sets of
  # modifiers are represented as integers with distinct bit positions
  # representing different modifiers.  The values for the constants
  # representing the modifiers are taken from <a
  # href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/VMSpecTOC.doc.html"><i>The
  # Java</i><sup><small>TM</small></sup> <i>Virtual Machine Specification, Second
  # edition</i></a> tables
  # <a href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/ClassFile.doc.html#75734">4.1</a>,
  # <a href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/ClassFile.doc.html#88358">4.4</a>,
  # <a href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/ClassFile.doc.html#75568">4.5</a>, and
  # <a href="http://java.sun.com/docs/books/vmspec/2nd-edition/html/ClassFile.doc.html#88478">4.7</a>.
  # 
  # @see Class#getModifiers()
  # @see Member#getModifiers()
  # 
  # @author Nakul Saraiya
  # @author Kenneth Russell
  class Modifier 
    include_class_members ModifierImports
    
    class_module.module_eval {
      # Bootstrapping protocol between java.lang and java.lang.reflect
      #  packages
      when_class_loaded do
        factory = AccessController.do_privileged(ReflectionFactory::GetReflectionFactoryAction.new)
        factory.set_lang_reflect_access(Java::Lang::Reflect::ReflectAccess.new)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code public} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code public} modifier; {@code false} otherwise.
      def is_public(mod)
        return !((mod & PUBLIC)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code private} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code private} modifier; {@code false} otherwise.
      def is_private(mod)
        return !((mod & PRIVATE)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code protected} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code protected} modifier; {@code false} otherwise.
      def is_protected(mod)
        return !((mod & PROTECTED)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code static} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code static} modifier; {@code false} otherwise.
      def is_static(mod)
        return !((mod & STATIC)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code final} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code final} modifier; {@code false} otherwise.
      def is_final(mod)
        return !((mod & FINAL)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code synchronized} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code synchronized} modifier; {@code false} otherwise.
      def is_synchronized(mod)
        return !((mod & SYNCHRONIZED)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code volatile} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code volatile} modifier; {@code false} otherwise.
      def is_volatile(mod)
        return !((mod & VOLATILE)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code transient} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code transient} modifier; {@code false} otherwise.
      def is_transient(mod)
        return !((mod & TRANSIENT)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code native} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code native} modifier; {@code false} otherwise.
      def is_native(mod)
        return !((mod & NATIVE)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code interface} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code interface} modifier; {@code false} otherwise.
      def is_interface(mod)
        return !((mod & INTERFACE)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code abstract} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code abstract} modifier; {@code false} otherwise.
      def is_abstract(mod)
        return !((mod & ABSTRACT)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return {@code true} if the integer argument includes the
      # {@code strictfp} modifier, {@code false} otherwise.
      # 
      # @param   mod a set of modifiers
      # @return {@code true} if {@code mod} includes the
      # {@code strictfp} modifier; {@code false} otherwise.
      def is_strict(mod)
        return !((mod & STRICT)).equal?(0)
      end
      
      typesig { [::Java::Int] }
      # Return a string describing the access modifier flags in
      # the specified modifier. For example:
      # <blockquote><pre>
      #    public final synchronized strictfp
      # </pre></blockquote>
      # The modifier names are returned in an order consistent with the
      # suggested modifier orderings given in <a
      # href="http://java.sun.com/docs/books/jls/second_edition/html/j.title.doc.html"><em>The
      # Java Language Specification, Second Edition</em></a> sections
      # <a href="http://java.sun.com/docs/books/jls/second_edition/html/classes.doc.html#21613">&sect;8.1.1</a>,
      # <a href="http://java.sun.com/docs/books/jls/second_edition/html/classes.doc.html#78091">&sect;8.3.1</a>,
      # <a href="http://java.sun.com/docs/books/jls/second_edition/html/classes.doc.html#78188">&sect;8.4.3</a>,
      # <a href="http://java.sun.com/docs/books/jls/second_edition/html/classes.doc.html#42018">&sect;8.8.3</a>, and
      # <a href="http://java.sun.com/docs/books/jls/second_edition/html/interfaces.doc.html#235947">&sect;9.1.1</a>.
      # The full modifier ordering used by this method is:
      # <blockquote> {@code
      # public protected private abstract static final transient
      # volatile synchronized native strictfp
      # interface } </blockquote>
      # The {@code interface} modifier discussed in this class is
      # not a true modifier in the Java language and it appears after
      # all other modifiers listed by this method.  This method may
      # return a string of modifiers that are not valid modifiers of a
      # Java entity; in other words, no checking is done on the
      # possible validity of the combination of modifiers represented
      # by the input.
      # 
      # @param   mod a set of modifiers
      # @return  a string representation of the set of modifiers
      # represented by {@code mod}
      def to_s(mod)
        sb = StringBuffer.new
        len = 0
        if (!((mod & PUBLIC)).equal?(0))
          sb.append("public ")
        end
        if (!((mod & PROTECTED)).equal?(0))
          sb.append("protected ")
        end
        if (!((mod & PRIVATE)).equal?(0))
          sb.append("private ")
        end
        # Canonical order
        if (!((mod & ABSTRACT)).equal?(0))
          sb.append("abstract ")
        end
        if (!((mod & STATIC)).equal?(0))
          sb.append("static ")
        end
        if (!((mod & FINAL)).equal?(0))
          sb.append("final ")
        end
        if (!((mod & TRANSIENT)).equal?(0))
          sb.append("transient ")
        end
        if (!((mod & VOLATILE)).equal?(0))
          sb.append("volatile ")
        end
        if (!((mod & SYNCHRONIZED)).equal?(0))
          sb.append("synchronized ")
        end
        if (!((mod & NATIVE)).equal?(0))
          sb.append("native ")
        end
        if (!((mod & STRICT)).equal?(0))
          sb.append("strictfp ")
        end
        if (!((mod & INTERFACE)).equal?(0))
          sb.append("interface ")
        end
        if ((len = sb.length) > 0)
          # trim trailing space
          return sb.to_s.substring(0, len - 1)
        end
        return ""
      end
      
      # Access modifier flag constants from <em>The Java Virtual
      # Machine Specification, Second Edition</em>, tables 4.1, 4.4,
      # 4.5, and 4.7.
      # The {@code int} value representing the {@code public}
      # modifier.
      const_set_lazy(:PUBLIC) { 0x1 }
      const_attr_reader  :PUBLIC
      
      # The {@code int} value representing the {@code private}
      # modifier.
      const_set_lazy(:PRIVATE) { 0x2 }
      const_attr_reader  :PRIVATE
      
      # The {@code int} value representing the {@code protected}
      # modifier.
      const_set_lazy(:PROTECTED) { 0x4 }
      const_attr_reader  :PROTECTED
      
      # The {@code int} value representing the {@code static}
      # modifier.
      const_set_lazy(:STATIC) { 0x8 }
      const_attr_reader  :STATIC
      
      # The {@code int} value representing the {@code final}
      # modifier.
      const_set_lazy(:FINAL) { 0x10 }
      const_attr_reader  :FINAL
      
      # The {@code int} value representing the {@code synchronized}
      # modifier.
      const_set_lazy(:SYNCHRONIZED) { 0x20 }
      const_attr_reader  :SYNCHRONIZED
      
      # The {@code int} value representing the {@code volatile}
      # modifier.
      const_set_lazy(:VOLATILE) { 0x40 }
      const_attr_reader  :VOLATILE
      
      # The {@code int} value representing the {@code transient}
      # modifier.
      const_set_lazy(:TRANSIENT) { 0x80 }
      const_attr_reader  :TRANSIENT
      
      # The {@code int} value representing the {@code native}
      # modifier.
      const_set_lazy(:NATIVE) { 0x100 }
      const_attr_reader  :NATIVE
      
      # The {@code int} value representing the {@code interface}
      # modifier.
      const_set_lazy(:INTERFACE) { 0x200 }
      const_attr_reader  :INTERFACE
      
      # The {@code int} value representing the {@code abstract}
      # modifier.
      const_set_lazy(:ABSTRACT) { 0x400 }
      const_attr_reader  :ABSTRACT
      
      # The {@code int} value representing the {@code strictfp}
      # modifier.
      const_set_lazy(:STRICT) { 0x800 }
      const_attr_reader  :STRICT
      
      # Bits not (yet) exposed in the public API either because they
      # have different meanings for fields and methods and there is no
      # way to distinguish between the two in this class, or because
      # they are not Java programming language keywords
      const_set_lazy(:BRIDGE) { 0x40 }
      const_attr_reader  :BRIDGE
      
      const_set_lazy(:VARARGS) { 0x80 }
      const_attr_reader  :VARARGS
      
      const_set_lazy(:SYNTHETIC) { 0x1000 }
      const_attr_reader  :SYNTHETIC
      
      const_set_lazy(:ANNOTATION) { 0x2000 }
      const_attr_reader  :ANNOTATION
      
      const_set_lazy(:ENUM) { 0x4000 }
      const_attr_reader  :ENUM
      
      typesig { [::Java::Int] }
      def is_synthetic(mod)
        return !((mod & SYNTHETIC)).equal?(0)
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__modifier, :initialize
  end
  
end
