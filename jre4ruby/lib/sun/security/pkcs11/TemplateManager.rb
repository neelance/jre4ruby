require "rjava"

# 
# Copyright 2003 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Pkcs11
  module TemplateManagerImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Pkcs11
      include ::Java::Util
      include ::Java::Util::Concurrent
      include ::Sun::Security::Pkcs11::Wrapper
    }
  end
  
  # 
  # TemplateManager class.
  # 
  # Not all PKCS#11 tokens are created equal. One token may require that one
  # value is specified when creating a certain type of object. Another token
  # may require a different value. Yet another token may only work if the
  # attribute is not specified at all.
  # 
  # In order to allow an application to work unmodified with all those
  # different tokens, the SunPKCS11 provider makes the attributes that are
  # specified and their value configurable. Hence, only the SunPKCS11
  # configuration file has to be tweaked at deployment time to allow all
  # existing applications to be used.
  # 
  # The template manager is responsible for reading the attribute configuration
  # information and to make it available to the various internal components
  # of the SunPKCS11 provider.
  # 
  # @author  Andreas Sterbenz
  # @since   1.5
  class TemplateManager 
    include_class_members TemplateManagerImports
    
    class_module.module_eval {
      const_set_lazy(:DEBUG) { false }
      const_attr_reader  :DEBUG
      
      # constant for any operation (either O_IMPORT or O_GENERATE)
      const_set_lazy(:O_ANY) { "*" }
      const_attr_reader  :O_ANY
      
      # constant for operation create ("importing" existing key material)
      const_set_lazy(:O_IMPORT) { "import" }
      const_attr_reader  :O_IMPORT
      
      # constant for operation generate (generating new key material)
      const_set_lazy(:O_GENERATE) { "generate" }
      const_attr_reader  :O_GENERATE
      
      const_set_lazy(:KeyAndTemplate) { Class.new do
        include_class_members TemplateManager
        
        attr_accessor :key
        alias_method :attr_key, :key
        undef_method :key
        alias_method :attr_key=, :key=
        undef_method :key=
        
        attr_accessor :template
        alias_method :attr_template, :template
        undef_method :template
        alias_method :attr_template=, :template=
        undef_method :template=
        
        typesig { [TemplateKey, Template] }
        def initialize(key, template)
          @key = nil
          @template = nil
          @key = key
          @template = template
        end
        
        private
        alias_method :initialize__key_and_template, :initialize
      end }
    }
    
    # primitive templates contains the individual template configuration
    # entries from the configuration file
    attr_accessor :primitive_templates
    alias_method :attr_primitive_templates, :primitive_templates
    undef_method :primitive_templates
    alias_method :attr_primitive_templates=, :primitive_templates=
    undef_method :primitive_templates=
    
    # composite templates is a cache of the exact configuration template for
    # each specific TemplateKey (no wildcards). the entries are created
    # on demand during first use by compositing all applicable
    # primitive template entries. the result is then stored in this map
    # for performance
    attr_accessor :composite_templates
    alias_method :attr_composite_templates, :composite_templates
    undef_method :composite_templates
    alias_method :attr_composite_templates=, :composite_templates=
    undef_method :composite_templates=
    
    typesig { [] }
    def initialize
      @primitive_templates = nil
      @composite_templates = nil
      @primitive_templates = ArrayList.new
      @composite_templates = ConcurrentHashMap.new
    end
    
    typesig { [String, ::Java::Long, ::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    # add a template. Called by Config.
    def add_template(op, object_class, key_algorithm, attrs)
      key = TemplateKey.new(op, object_class, key_algorithm)
      template = Template.new(attrs)
      if (DEBUG)
        System.out.println("Adding " + (key).to_s + " -> " + (template).to_s)
      end
      @primitive_templates.add(KeyAndTemplate.new(key, template))
    end
    
    typesig { [TemplateKey] }
    def get_template(key)
      template = @composite_templates.get(key)
      if ((template).nil?)
        template = build_composite_template(key)
        @composite_templates.put(key, template)
      end
      return template
    end
    
    typesig { [String, ::Java::Long, ::Java::Long, Array.typed(CK_ATTRIBUTE)] }
    # Get the attributes for the requested op and combine them with attrs.
    # This is the method called by the implementation to obtain the
    # attributes.
    def get_attributes(op, type, alg, attrs)
      key = TemplateKey.new(op, type, alg)
      template = get_template(key)
      new_attrs = template.get_attributes(attrs)
      if (DEBUG)
        System.out.println((key).to_s + " -> " + (Arrays.as_list(new_attrs)).to_s)
      end
      return new_attrs
    end
    
    typesig { [TemplateKey] }
    # build a composite template for the given key
    def build_composite_template(key)
      comp = Template.new
      # iterate through primitive templates and add all that apply
      @primitive_templates.each do |entry|
        if (entry.attr_key.applies_to(key))
          comp.add(entry.attr_template)
        end
      end
      return comp
    end
    
    class_module.module_eval {
      # 
      # Nested class representing a template identifier.
      const_set_lazy(:TemplateKey) { Class.new do
        include_class_members TemplateManager
        
        attr_accessor :operation
        alias_method :attr_operation, :operation
        undef_method :operation
        alias_method :attr_operation=, :operation=
        undef_method :operation=
        
        attr_accessor :key_type
        alias_method :attr_key_type, :key_type
        undef_method :key_type
        alias_method :attr_key_type=, :key_type=
        undef_method :key_type=
        
        attr_accessor :key_algorithm
        alias_method :attr_key_algorithm, :key_algorithm
        undef_method :key_algorithm
        alias_method :attr_key_algorithm=, :key_algorithm=
        undef_method :key_algorithm=
        
        typesig { [String, ::Java::Long, ::Java::Long] }
        def initialize(operation, key_type, key_algorithm)
          @operation = nil
          @key_type = 0
          @key_algorithm = 0
          @operation = operation
          @key_type = key_type
          @key_algorithm = key_algorithm
        end
        
        typesig { [Object] }
        def equals(obj)
          if ((self).equal?(obj))
            return true
          end
          if ((obj.is_a?(TemplateKey)).equal?(false))
            return false
          end
          other = obj
          match = (@operation == other.attr_operation) && ((@key_type).equal?(other.attr_key_type)) && ((@key_algorithm).equal?(other.attr_key_algorithm))
          return match
        end
        
        typesig { [] }
        def hash_code
          return @operation.hash_code + RJava.cast_to_int(@key_type) + RJava.cast_to_int(@key_algorithm)
        end
        
        typesig { [TemplateKey] }
        def applies_to(key)
          if ((@operation == O_ANY) || (@operation == key.attr_operation))
            if (((@key_type).equal?(PCKO_ANY)) || ((@key_type).equal?(key.attr_key_type)))
              if (((@key_algorithm).equal?(PCKK_ANY)) || ((@key_algorithm).equal?(key.attr_key_algorithm)))
                return true
              end
            end
          end
          return false
        end
        
        typesig { [] }
        def to_s
          return "(" + @operation + "," + (Functions.get_object_class_name(@key_type)).to_s + "," + (Functions.get_key_name(@key_algorithm)).to_s + ")"
        end
        
        private
        alias_method :initialize__template_key, :initialize
      end }
      
      # 
      # Nested class representing template attributes.
      const_set_lazy(:Template) { Class.new do
        include_class_members TemplateManager
        
        class_module.module_eval {
          const_set_lazy(:A0) { Array.typed(CK_ATTRIBUTE).new(0) { nil } }
          const_attr_reader  :A0
        }
        
        attr_accessor :attributes
        alias_method :attr_attributes, :attributes
        undef_method :attributes
        alias_method :attr_attributes=, :attributes=
        undef_method :attributes=
        
        typesig { [] }
        def initialize
          @attributes = nil
          @attributes = self.class::A0
        end
        
        typesig { [Array.typed(CK_ATTRIBUTE)] }
        def initialize(attributes)
          @attributes = nil
          @attributes = attributes
        end
        
        typesig { [Template] }
        def add(template)
          @attributes = get_attributes(template.attr_attributes)
        end
        
        typesig { [Array.typed(CK_ATTRIBUTE)] }
        def get_attributes(attrs)
          return combine(@attributes, attrs)
        end
        
        class_module.module_eval {
          typesig { [Array.typed(CK_ATTRIBUTE), Array.typed(CK_ATTRIBUTE)] }
          # 
          # Combine two sets of attributes. The second set has precedence
          # over the first and overrides its settings.
          def combine(attrs1, attrs2)
            attrs = ArrayList.new
            attrs1.each do |attr|
              if (!(attr.attr_p_value).nil?)
                attrs.add(attr)
              end
            end
            attrs2.each do |attr2|
              type = attr2.attr_type
              attrs1.each do |attr1|
                if ((attr1.attr_type).equal?(type))
                  attrs.remove(attr1)
                end
              end
              if (!(attr2.attr_p_value).nil?)
                attrs.add(attr2)
              end
            end
            return attrs.to_array(self.class::A0)
          end
        }
        
        typesig { [] }
        def to_s
          return Arrays.as_list(@attributes).to_s
        end
        
        private
        alias_method :initialize__template, :initialize
      end }
    }
    
    private
    alias_method :initialize__template_manager, :initialize
  end
  
end
