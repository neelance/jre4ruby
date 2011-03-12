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
module Sun::Reflect::Annotation
  module AnnotationParserImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect::Annotation
      include ::Java::Lang::Annotation
      include ::Java::Util
      include_const ::Java::Nio, :ByteBuffer
      include_const ::Java::Nio, :BufferUnderflowException
      include ::Java::Lang::Reflect
      include_const ::Sun::Reflect, :ConstantPool
      include_const ::Sun::Reflect::Generics::Parser, :SignatureParser
      include_const ::Sun::Reflect::Generics::Tree, :TypeSignature
      include_const ::Sun::Reflect::Generics::Factory, :GenericsFactory
      include_const ::Sun::Reflect::Generics::Factory, :CoreReflectionFactory
      include_const ::Sun::Reflect::Generics::Visitor, :Reifier
      include_const ::Sun::Reflect::Generics::Scope, :ClassScope
    }
  end
  
  # Parser for Java programming language annotations.  Translates
  # annotation byte streams emitted by compiler into annotation objects.
  # 
  # @author  Josh Bloch
  # @since   1.5
  class AnnotationParser 
    include_class_members AnnotationParserImports
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), ConstantPool, Class] }
      # Parses the annotations described by the specified byte array.
      # resolving constant references in the specified constant pool.
      # The array must contain an array of annotations as described
      # in the RuntimeVisibleAnnotations_attribute:
      # 
      #   u2 num_annotations;
      #   annotation annotations[num_annotations];
      # 
      # @throws AnnotationFormatError if an annotation is found to be
      #         malformed.
      def parse_annotations(raw_annotations, const_pool, container)
        if ((raw_annotations).nil?)
          return Collections.empty_map
        end
        begin
          return parse_annotations2(raw_annotations, const_pool, container)
        rescue BufferUnderflowException => e
          raise AnnotationFormatError.new("Unexpected end of annotations.")
        rescue IllegalArgumentException => e
          # Type mismatch in constant pool
          raise AnnotationFormatError.new(e)
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ConstantPool, Class] }
      def parse_annotations2(raw_annotations, const_pool, container)
        result = LinkedHashMap.new
        buf = ByteBuffer.wrap(raw_annotations)
        num_annotations = buf.get_short & 0xffff
        i = 0
        while i < num_annotations
          a = parse_annotation(buf, const_pool, container, false)
          if (!(a).nil?)
            klass = a.annotation_type
            type = AnnotationType.get_instance(klass)
            if ((type.retention).equal?(RetentionPolicy::RUNTIME))
              if (!(result.put(klass, a)).nil?)
                raise AnnotationFormatError.new("Duplicate annotation for class: " + RJava.cast_to_string(klass) + ": " + RJava.cast_to_string(a))
              end
            end
          end
          i += 1
        end
        return result
      end
      
      typesig { [Array.typed(::Java::Byte), ConstantPool, Class] }
      # Parses the parameter annotations described by the specified byte array.
      # resolving constant references in the specified constant pool.
      # The array must contain an array of annotations as described
      # in the RuntimeVisibleParameterAnnotations_attribute:
      # 
      #    u1 num_parameters;
      #    {
      #        u2 num_annotations;
      #        annotation annotations[num_annotations];
      #    } parameter_annotations[num_parameters];
      # 
      # Unlike parseAnnotations, rawAnnotations must not be null!
      # A null value must be handled by the caller.  This is so because
      # we cannot determine the number of parameters if rawAnnotations
      # is null.  Also, the caller should check that the number
      # of parameters indicated by the return value of this method
      # matches the actual number of method parameters.  A mismatch
      # indicates that an AnnotationFormatError should be thrown.
      # 
      # @throws AnnotationFormatError if an annotation is found to be
      #         malformed.
      def parse_parameter_annotations(raw_annotations, const_pool, container)
        begin
          return parse_parameter_annotations2(raw_annotations, const_pool, container)
        rescue BufferUnderflowException => e
          raise AnnotationFormatError.new("Unexpected end of parameter annotations.")
        rescue IllegalArgumentException => e
          # Type mismatch in constant pool
          raise AnnotationFormatError.new(e)
        end
      end
      
      typesig { [Array.typed(::Java::Byte), ConstantPool, Class] }
      def parse_parameter_annotations2(raw_annotations, const_pool, container)
        buf = ByteBuffer.wrap(raw_annotations)
        num_parameters = buf.get & 0xff
        result = Array.typed(Array.typed(Annotation)).new(num_parameters) { nil }
        i = 0
        while i < num_parameters
          num_annotations = buf.get_short & 0xffff
          annotations = ArrayList.new(num_annotations)
          j = 0
          while j < num_annotations
            a = parse_annotation(buf, const_pool, container, false)
            if (!(a).nil?)
              type = AnnotationType.get_instance(a.annotation_type)
              if ((type.retention).equal?(RetentionPolicy::RUNTIME))
                annotations.add(a)
              end
            end
            j += 1
          end
          result[i] = annotations.to_array(EMPTY_ANNOTATIONS_ARRAY)
          i += 1
        end
        return result
      end
      
      const_set_lazy(:EMPTY_ANNOTATIONS_ARRAY) { Array.typed(Annotation).new(0) { nil } }
      const_attr_reader  :EMPTY_ANNOTATIONS_ARRAY
      
      typesig { [ByteBuffer, ConstantPool, Class, ::Java::Boolean] }
      # Parses the annotation at the current position in the specified
      # byte buffer, resolving constant references in the specified constant
      # pool.  The cursor of the byte buffer must point to an "annotation
      # structure" as described in the RuntimeVisibleAnnotations_attribute:
      # 
      # annotation {
      #    u2    type_index;
      #       u2    num_member_value_pairs;
      #       {    u2    member_name_index;
      #             member_value value;
      #       }    member_value_pairs[num_member_value_pairs];
      #    }
      # }
      # 
      # Returns the annotation, or null if the annotation's type cannot
      # be found by the VM, or is not a valid annotation type.
      # 
      # @param exceptionOnMissingAnnotationClass if true, throw
      # TypeNotPresentException if a referenced annotation type is not
      # available at runtime
      def parse_annotation(buf, const_pool, container, exception_on_missing_annotation_class)
        type_index = buf.get_short & 0xffff
        annotation_class = nil
        sig = "[unknown]"
        begin
          begin
            sig = RJava.cast_to_string(const_pool.get_utf8at(type_index))
            annotation_class = parse_sig(sig, container)
          rescue IllegalArgumentException => ex
            # support obsolete early jsr175 format class files
            annotation_class = const_pool.get_class_at(type_index)
          end
        rescue NoClassDefFoundError => e
          if (exception_on_missing_annotation_class)
            # note: at this point sig is "[unknown]" or VM-style
            # name instead of a binary name
            raise TypeNotPresentException.new(sig, e)
          end
          skip_annotation(buf, false)
          return nil
        rescue TypeNotPresentException => e
          if (exception_on_missing_annotation_class)
            raise e
          end
          skip_annotation(buf, false)
          return nil
        end
        type = nil
        begin
          type = AnnotationType.get_instance(annotation_class)
        rescue IllegalArgumentException => e
          skip_annotation(buf, false)
          return nil
        end
        member_types_ = type.member_types
        member_values = LinkedHashMap.new(type.member_defaults)
        num_members = buf.get_short & 0xffff
        i = 0
        while i < num_members
          member_name_index = buf.get_short & 0xffff
          member_name = const_pool.get_utf8at(member_name_index)
          member_type = member_types_.get(member_name)
          if ((member_type).nil?)
            # Member is no longer present in annotation type; ignore it
            skip_member_value(buf)
          else
            value = parse_member_value(member_type, buf, const_pool, container)
            if (value.is_a?(AnnotationTypeMismatchExceptionProxy))
              (value).set_member(type.members.get(member_name))
            end
            member_values.put(member_name, value)
          end
          i += 1
        end
        return annotation_for_map(annotation_class, member_values)
      end
      
      typesig { [Class, Map] }
      # Returns an annotation of the given type backed by the given
      # member -> value map.
      def annotation_for_map(type, member_values)
        return Proxy.new_proxy_instance(type.get_class_loader, Array.typed(Class).new([type]), AnnotationInvocationHandler.new(type, member_values))
      end
      
      typesig { [Class, ByteBuffer, ConstantPool, Class] }
      # Parses the annotation member value at the current position in the
      # specified byte buffer, resolving constant references in the specified
      # constant pool.  The cursor of the byte buffer must point to a
      # "member_value structure" as described in the
      # RuntimeVisibleAnnotations_attribute:
      # 
      #  member_value {
      #    u1 tag;
      #    union {
      #       u2   const_value_index;
      #       {
      #           u2   type_name_index;
      #           u2   const_name_index;
      #       } enum_const_value;
      #       u2   class_info_index;
      #       annotation annotation_value;
      #       {
      #           u2    num_values;
      #           member_value values[num_values];
      #       } array_value;
      #    } value;
      # }
      # 
      # The member must be of the indicated type. If it is not, this
      # method returns an AnnotationTypeMismatchExceptionProxy.
      def parse_member_value(member_type, buf, const_pool, container)
        result = nil
        tag = buf.get
        case (tag)
        when Character.new(?e.ord)
          return parse_enum_value(member_type, buf, const_pool, container)
        when Character.new(?c.ord)
          result = parse_class_value(buf, const_pool, container)
        when Character.new(?@.ord)
          result = parse_annotation(buf, const_pool, container, true)
        when Character.new(?[.ord)
          return parse_array(member_type, buf, const_pool, container)
        else
          result = parse_const(tag, buf, const_pool)
        end
        if (!(result.is_a?(ExceptionProxy)) && !member_type.is_instance(result))
          result = AnnotationTypeMismatchExceptionProxy.new(RJava.cast_to_string(result.get_class) + "[" + RJava.cast_to_string(result) + "]")
        end
        return result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      # Parses the primitive or String annotation member value indicated by
      # the specified tag byte at the current position in the specified byte
      # buffer, resolving constant reference in the specified constant pool.
      # The cursor of the byte buffer must point to an annotation member value
      # of the type indicated by the specified tag, as described in the
      # RuntimeVisibleAnnotations_attribute:
      # 
      #       u2   const_value_index;
      def parse_const(tag, buf, const_pool)
        const_index = buf.get_short & 0xffff
        case (tag)
        when Character.new(?B.ord)
          return Byte.value_of(const_pool.get_int_at(const_index))
        when Character.new(?C.ord)
          return Character.value_of(RJava.cast_to_char(const_pool.get_int_at(const_index)))
        when Character.new(?D.ord)
          return Double.value_of(const_pool.get_double_at(const_index))
        when Character.new(?F.ord)
          return Float.value_of(const_pool.get_float_at(const_index))
        when Character.new(?I.ord)
          return JavaInteger.value_of(const_pool.get_int_at(const_index))
        when Character.new(?J.ord)
          return Long.value_of(const_pool.get_long_at(const_index))
        when Character.new(?S.ord)
          return Short.value_of(RJava.cast_to_short(const_pool.get_int_at(const_index)))
        when Character.new(?Z.ord)
          return Boolean.value_of(!(const_pool.get_int_at(const_index)).equal?(0))
        when Character.new(?s.ord)
          return const_pool.get_utf8at(const_index)
        else
          raise AnnotationFormatError.new("Invalid member-value tag in annotation: " + RJava.cast_to_string(tag))
        end
      end
      
      typesig { [ByteBuffer, ConstantPool, Class] }
      # Parses the Class member value at the current position in the
      # specified byte buffer, resolving constant references in the specified
      # constant pool.  The cursor of the byte buffer must point to a "class
      # info index" as described in the RuntimeVisibleAnnotations_attribute:
      # 
      #       u2   class_info_index;
      def parse_class_value(buf, const_pool, container)
        class_index = buf.get_short & 0xffff
        begin
          begin
            sig = const_pool.get_utf8at(class_index)
            return parse_sig(sig, container)
          rescue IllegalArgumentException => ex
            # support obsolete early jsr175 format class files
            return const_pool.get_class_at(class_index)
          end
        rescue NoClassDefFoundError => e
          return TypeNotPresentExceptionProxy.new("[unknown]", e)
        rescue TypeNotPresentException => e
          return TypeNotPresentExceptionProxy.new(e.type_name, e.get_cause)
        end
      end
      
      typesig { [String, Class] }
      def parse_sig(sig, container)
        if ((sig == "V"))
          return self.attr_void.attr_class
        end
        parser = SignatureParser.make
        type_sig = parser.parse_type_sig(sig)
        factory = CoreReflectionFactory.make(container, ClassScope.make(container))
        reify = Reifier.make(factory)
        type_sig.accept(reify)
        result = reify.get_result
        return to_class(result)
      end
      
      typesig { [Type] }
      def to_class(o)
        if (o.is_a?(GenericArrayType))
          return Array.new_instance(to_class((o).get_generic_component_type), 0).get_class
        end
        return o
      end
      
      typesig { [Class, ByteBuffer, ConstantPool, Class] }
      # Parses the enum constant member value at the current position in the
      # specified byte buffer, resolving constant references in the specified
      # constant pool.  The cursor of the byte buffer must point to a
      # "enum_const_value structure" as described in the
      # RuntimeVisibleAnnotations_attribute:
      # 
      #       {
      #           u2   type_name_index;
      #           u2   const_name_index;
      #       } enum_const_value;
      def parse_enum_value(enum_type, buf, const_pool, container)
        type_name_index = buf.get_short & 0xffff
        type_name_ = const_pool.get_utf8at(type_name_index)
        const_name_index = buf.get_short & 0xffff
        const_name = const_pool.get_utf8at(const_name_index)
        if (!type_name_.ends_with(";"))
          # support now-obsolete early jsr175-format class files.
          if (!(enum_type.get_name == type_name_))
            return AnnotationTypeMismatchExceptionProxy.new(type_name_ + "." + const_name)
          end
        else
          if (!(enum_type).equal?(parse_sig(type_name_, container)))
            return AnnotationTypeMismatchExceptionProxy.new(type_name_ + "." + const_name)
          end
        end
        begin
          return Enum.value_of(enum_type, const_name)
        rescue IllegalArgumentException => e
          return EnumConstantNotPresentExceptionProxy.new(enum_type, const_name)
        end
      end
      
      typesig { [Class, ByteBuffer, ConstantPool, Class] }
      # Parses the array value at the current position in the specified byte
      # buffer, resolving constant references in the specified constant pool.
      # The cursor of the byte buffer must point to an array value struct
      # as specified in the RuntimeVisibleAnnotations_attribute:
      # 
      #       {
      #           u2    num_values;
      #           member_value values[num_values];
      #       } array_value;
      # 
      # If the array values do not match arrayType, an
      # AnnotationTypeMismatchExceptionProxy will be returned.
      def parse_array(array_type, buf, const_pool, container)
        length = buf.get_short & 0xffff # Number of array components
        component_type = array_type.get_component_type
        if ((component_type).equal?(Array))
          return parse_byte_array(length, buf, const_pool)
        else
          if ((component_type).equal?(Array))
            return parse_char_array(length, buf, const_pool)
          else
            if ((component_type).equal?(Array))
              return parse_double_array(length, buf, const_pool)
            else
              if ((component_type).equal?(Array))
                return parse_float_array(length, buf, const_pool)
              else
                if ((component_type).equal?(Array))
                  return parse_int_array(length, buf, const_pool)
                else
                  if ((component_type).equal?(Array))
                    return parse_long_array(length, buf, const_pool)
                  else
                    if ((component_type).equal?(Array))
                      return parse_short_array(length, buf, const_pool)
                    else
                      if ((component_type).equal?(Array))
                        return parse_boolean_array(length, buf, const_pool)
                      else
                        if ((component_type).equal?(String))
                          return parse_string_array(length, buf, const_pool)
                        else
                          if ((component_type).equal?(Class))
                            return parse_class_array(length, buf, const_pool, container)
                          else
                            if (component_type.is_enum)
                              return parse_enum_array(length, component_type, buf, const_pool, container)
                            else
                              raise AssertError if not (component_type.is_annotation)
                              return parse_annotation_array(length, component_type, buf, const_pool, container)
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_byte_array(length, buf, const_pool)
        result = Array.typed(::Java::Byte).new(length) { 0 }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?B.ord)))
            index = buf.get_short & 0xffff
            result[i] = const_pool.get_int_at(index)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_char_array(length, buf, const_pool)
        result = CharArray.new(length)
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?C.ord)))
            index = buf.get_short & 0xffff
            result[i] = RJava.cast_to_char(const_pool.get_int_at(index))
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_double_array(length, buf, const_pool)
        result = Array.typed(::Java::Double).new(length) { 0.0 }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?D.ord)))
            index = buf.get_short & 0xffff
            result[i] = const_pool.get_double_at(index)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_float_array(length, buf, const_pool)
        result = Array.typed(::Java::Float).new(length) { 0.0 }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?F.ord)))
            index = buf.get_short & 0xffff
            result[i] = const_pool.get_float_at(index)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_int_array(length, buf, const_pool)
        result = Array.typed(::Java::Int).new(length) { 0 }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?I.ord)))
            index = buf.get_short & 0xffff
            result[i] = const_pool.get_int_at(index)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_long_array(length, buf, const_pool)
        result = Array.typed(::Java::Long).new(length) { 0 }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?J.ord)))
            index = buf.get_short & 0xffff
            result[i] = const_pool.get_long_at(index)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_short_array(length, buf, const_pool)
        result = Array.typed(::Java::Short).new(length) { 0 }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?S.ord)))
            index = buf.get_short & 0xffff
            result[i] = RJava.cast_to_short(const_pool.get_int_at(index))
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_boolean_array(length, buf, const_pool)
        result = Array.typed(::Java::Boolean).new(length) { false }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?Z.ord)))
            index = buf.get_short & 0xffff
            result[i] = (!(const_pool.get_int_at(index)).equal?(0))
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool] }
      def parse_string_array(length, buf, const_pool)
        result = Array.typed(String).new(length) { nil }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?s.ord)))
            index = buf.get_short & 0xffff
            result[i] = const_pool.get_utf8at(index)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, ByteBuffer, ConstantPool, Class] }
      def parse_class_array(length, buf, const_pool, container)
        result = Array.typed(Class).new(length) { nil }
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?c.ord)))
            result[i] = parse_class_value(buf, const_pool, container)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, Class, ByteBuffer, ConstantPool, Class] }
      def parse_enum_array(length, enum_type, buf, const_pool, container)
        result = Array.new_instance(enum_type, length)
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?e.ord)))
            result[i] = parse_enum_value(enum_type, buf, const_pool, container)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int, Class, ByteBuffer, ConstantPool, Class] }
      def parse_annotation_array(length, annotation_type_, buf, const_pool, container)
        result = Array.new_instance(annotation_type_, length)
        type_mismatch = false
        tag = 0
        i = 0
        while i < length
          tag = buf.get
          if ((tag).equal?(Character.new(?@.ord)))
            result[i] = parse_annotation(buf, const_pool, container, true)
          else
            skip_member_value(tag, buf)
            type_mismatch = true
          end
          i += 1
        end
        return type_mismatch ? exception_proxy(tag) : result
      end
      
      typesig { [::Java::Int] }
      # Return an appropriate exception proxy for a mismatching array
      # annotation where the erroneous array has the specified tag.
      def exception_proxy(tag)
        return AnnotationTypeMismatchExceptionProxy.new("Array with component tag: " + RJava.cast_to_string(tag))
      end
      
      typesig { [ByteBuffer, ::Java::Boolean] }
      # Skips the annotation at the current position in the specified
      # byte buffer.  The cursor of the byte buffer must point to
      # an "annotation structure" OR two bytes into an annotation
      # structure (i.e., after the type index).
      # 
      # @parameter complete true if the byte buffer points to the beginning
      #     of an annotation structure (rather than two bytes in).
      def skip_annotation(buf, complete)
        if (complete)
          buf.get_short
        end # Skip type index
        num_members = buf.get_short & 0xffff
        i = 0
        while i < num_members
          buf.get_short # Skip memberNameIndex
          skip_member_value(buf)
          i += 1
        end
      end
      
      typesig { [ByteBuffer] }
      # Skips the annotation member value at the current position in the
      # specified byte buffer.  The cursor of the byte buffer must point to a
      # "member_value structure."
      def skip_member_value(buf)
        tag = buf.get
        skip_member_value(tag, buf)
      end
      
      typesig { [::Java::Int, ByteBuffer] }
      # Skips the annotation member value at the current position in the
      # specified byte buffer.  The cursor of the byte buffer must point
      # immediately after the tag in a "member_value structure."
      def skip_member_value(tag, buf)
        case (tag)
        when Character.new(?e.ord)
          # Enum value
          buf.get_int # (Two shorts, actually.)
        when Character.new(?@.ord)
          skip_annotation(buf, true)
        when Character.new(?[.ord)
          skip_array(buf)
        else
          # Class, primitive, or String
          buf.get_short
        end
      end
      
      typesig { [ByteBuffer] }
      # Skips the array value at the current position in the specified byte
      # buffer.  The cursor of the byte buffer must point to an array value
      # struct.
      def skip_array(buf)
        length = buf.get_short & 0xffff
        i = 0
        while i < length
          skip_member_value(buf)
          i += 1
        end
      end
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__annotation_parser, :initialize
  end
  
end
