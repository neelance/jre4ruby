require "rjava"

# Copyright 2001-2004 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Reflect
  module UnsafeFieldAccessorFactoryImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Reflect
      include_const ::Java::Lang::Reflect, :Field
      include_const ::Java::Lang::Reflect, :Modifier
    }
  end
  
  class UnsafeFieldAccessorFactory 
    include_class_members UnsafeFieldAccessorFactoryImports
    
    class_module.module_eval {
      typesig { [Field, ::Java::Boolean] }
      def new_field_accessor(field, override)
        type = field.get_type
        is_static_ = Modifier.is_static(field.get_modifiers)
        is_final_ = Modifier.is_final(field.get_modifiers)
        is_volatile_ = Modifier.is_volatile(field.get_modifiers)
        is_qualified = is_final_ || is_volatile_
        is_read_only = is_final_ && (is_static_ || !override)
        if (is_static_)
          # This code path does not guarantee that the field's
          # declaring class has been initialized, but it must be
          # before performing reflective operations.
          UnsafeFieldAccessorImpl.attr_unsafe.ensure_class_initialized(field.get_declaring_class)
          if (!is_qualified)
            if ((type).equal?(Boolean::TYPE))
              return UnsafeStaticBooleanFieldAccessorImpl.new(field)
            else
              if ((type).equal?(Byte::TYPE))
                return UnsafeStaticByteFieldAccessorImpl.new(field)
              else
                if ((type).equal?(Short::TYPE))
                  return UnsafeStaticShortFieldAccessorImpl.new(field)
                else
                  if ((type).equal?(Character::TYPE))
                    return UnsafeStaticCharacterFieldAccessorImpl.new(field)
                  else
                    if ((type).equal?(JavaInteger::TYPE))
                      return UnsafeStaticIntegerFieldAccessorImpl.new(field)
                    else
                      if ((type).equal?(Long::TYPE))
                        return UnsafeStaticLongFieldAccessorImpl.new(field)
                      else
                        if ((type).equal?(Float::TYPE))
                          return UnsafeStaticFloatFieldAccessorImpl.new(field)
                        else
                          if ((type).equal?(Double::TYPE))
                            return UnsafeStaticDoubleFieldAccessorImpl.new(field)
                          else
                            return UnsafeStaticObjectFieldAccessorImpl.new(field)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          else
            if ((type).equal?(Boolean::TYPE))
              return UnsafeQualifiedStaticBooleanFieldAccessorImpl.new(field, is_read_only)
            else
              if ((type).equal?(Byte::TYPE))
                return UnsafeQualifiedStaticByteFieldAccessorImpl.new(field, is_read_only)
              else
                if ((type).equal?(Short::TYPE))
                  return UnsafeQualifiedStaticShortFieldAccessorImpl.new(field, is_read_only)
                else
                  if ((type).equal?(Character::TYPE))
                    return UnsafeQualifiedStaticCharacterFieldAccessorImpl.new(field, is_read_only)
                  else
                    if ((type).equal?(JavaInteger::TYPE))
                      return UnsafeQualifiedStaticIntegerFieldAccessorImpl.new(field, is_read_only)
                    else
                      if ((type).equal?(Long::TYPE))
                        return UnsafeQualifiedStaticLongFieldAccessorImpl.new(field, is_read_only)
                      else
                        if ((type).equal?(Float::TYPE))
                          return UnsafeQualifiedStaticFloatFieldAccessorImpl.new(field, is_read_only)
                        else
                          if ((type).equal?(Double::TYPE))
                            return UnsafeQualifiedStaticDoubleFieldAccessorImpl.new(field, is_read_only)
                          else
                            return UnsafeQualifiedStaticObjectFieldAccessorImpl.new(field, is_read_only)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        else
          if (!is_qualified)
            if ((type).equal?(Boolean::TYPE))
              return UnsafeBooleanFieldAccessorImpl.new(field)
            else
              if ((type).equal?(Byte::TYPE))
                return UnsafeByteFieldAccessorImpl.new(field)
              else
                if ((type).equal?(Short::TYPE))
                  return UnsafeShortFieldAccessorImpl.new(field)
                else
                  if ((type).equal?(Character::TYPE))
                    return UnsafeCharacterFieldAccessorImpl.new(field)
                  else
                    if ((type).equal?(JavaInteger::TYPE))
                      return UnsafeIntegerFieldAccessorImpl.new(field)
                    else
                      if ((type).equal?(Long::TYPE))
                        return UnsafeLongFieldAccessorImpl.new(field)
                      else
                        if ((type).equal?(Float::TYPE))
                          return UnsafeFloatFieldAccessorImpl.new(field)
                        else
                          if ((type).equal?(Double::TYPE))
                            return UnsafeDoubleFieldAccessorImpl.new(field)
                          else
                            return UnsafeObjectFieldAccessorImpl.new(field)
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          else
            if ((type).equal?(Boolean::TYPE))
              return UnsafeQualifiedBooleanFieldAccessorImpl.new(field, is_read_only)
            else
              if ((type).equal?(Byte::TYPE))
                return UnsafeQualifiedByteFieldAccessorImpl.new(field, is_read_only)
              else
                if ((type).equal?(Short::TYPE))
                  return UnsafeQualifiedShortFieldAccessorImpl.new(field, is_read_only)
                else
                  if ((type).equal?(Character::TYPE))
                    return UnsafeQualifiedCharacterFieldAccessorImpl.new(field, is_read_only)
                  else
                    if ((type).equal?(JavaInteger::TYPE))
                      return UnsafeQualifiedIntegerFieldAccessorImpl.new(field, is_read_only)
                    else
                      if ((type).equal?(Long::TYPE))
                        return UnsafeQualifiedLongFieldAccessorImpl.new(field, is_read_only)
                      else
                        if ((type).equal?(Float::TYPE))
                          return UnsafeQualifiedFloatFieldAccessorImpl.new(field, is_read_only)
                        else
                          if ((type).equal?(Double::TYPE))
                            return UnsafeQualifiedDoubleFieldAccessorImpl.new(field, is_read_only)
                          else
                            return UnsafeQualifiedObjectFieldAccessorImpl.new(field, is_read_only)
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
    }
    
    typesig { [] }
    def initialize
    end
    
    private
    alias_method :initialize__unsafe_field_accessor_factory, :initialize
  end
  
end
