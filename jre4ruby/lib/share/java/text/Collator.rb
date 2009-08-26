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
# 
# 
# (C) Copyright Taligent, Inc. 1996-1998 -  All Rights Reserved
# (C) Copyright IBM Corp. 1996-1998 - All Rights Reserved
# 
# The original version of this source code and documentation is copyrighted
# and owned by Taligent, Inc., a wholly-owned subsidiary of IBM. These
# materials are provided under terms of a License Agreement between Taligent
# and Sun. This technology is protected by multiple US and International
# patents. This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module CollatorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Text::Spi, :CollatorProvider
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Misc, :SoftCache
      include_const ::Sun::Util::Resources, :LocaleData
      include_const ::Sun::Util, :LocaleServiceProviderPool
    }
  end
  
  # The <code>Collator</code> class performs locale-sensitive
  # <code>String</code> comparison. You use this class to build
  # searching and sorting routines for natural language text.
  # 
  # <p>
  # <code>Collator</code> is an abstract base class. Subclasses
  # implement specific collation strategies. One subclass,
  # <code>RuleBasedCollator</code>, is currently provided with
  # the Java Platform and is applicable to a wide set of languages. Other
  # subclasses may be created to handle more specialized needs.
  # 
  # <p>
  # Like other locale-sensitive classes, you can use the static
  # factory method, <code>getInstance</code>, to obtain the appropriate
  # <code>Collator</code> object for a given locale. You will only need
  # to look at the subclasses of <code>Collator</code> if you need
  # to understand the details of a particular collation strategy or
  # if you need to modify that strategy.
  # 
  # <p>
  # The following example shows how to compare two strings using
  # the <code>Collator</code> for the default locale.
  # <blockquote>
  # <pre>
  # // Compare two strings in the default locale
  # Collator myCollator = Collator.getInstance();
  # if( myCollator.compare("abc", "ABC") < 0 )
  # System.out.println("abc is less than ABC");
  # else
  # System.out.println("abc is greater than or equal to ABC");
  # </pre>
  # </blockquote>
  # 
  # <p>
  # You can set a <code>Collator</code>'s <em>strength</em> property
  # to determine the level of difference considered significant in
  # comparisons. Four strengths are provided: <code>PRIMARY</code>,
  # <code>SECONDARY</code>, <code>TERTIARY</code>, and <code>IDENTICAL</code>.
  # The exact assignment of strengths to language features is
  # locale dependant.  For example, in Czech, "e" and "f" are considered
  # primary differences, while "e" and "&#283;" are secondary differences,
  # "e" and "E" are tertiary differences and "e" and "e" are identical.
  # The following shows how both case and accents could be ignored for
  # US English.
  # <blockquote>
  # <pre>
  # //Get the Collator for US English and set its strength to PRIMARY
  # Collator usCollator = Collator.getInstance(Locale.US);
  # usCollator.setStrength(Collator.PRIMARY);
  # if( usCollator.compare("abc", "ABC") == 0 ) {
  # System.out.println("Strings are equivalent");
  # }
  # </pre>
  # </blockquote>
  # <p>
  # For comparing <code>String</code>s exactly once, the <code>compare</code>
  # method provides the best performance. When sorting a list of
  # <code>String</code>s however, it is generally necessary to compare each
  # <code>String</code> multiple times. In this case, <code>CollationKey</code>s
  # provide better performance. The <code>CollationKey</code> class converts
  # a <code>String</code> to a series of bits that can be compared bitwise
  # against other <code>CollationKey</code>s. A <code>CollationKey</code> is
  # created by a <code>Collator</code> object for a given <code>String</code>.
  # <br>
  # <strong>Note:</strong> <code>CollationKey</code>s from different
  # <code>Collator</code>s can not be compared. See the class description
  # for {@link CollationKey}
  # for an example using <code>CollationKey</code>s.
  # 
  # @see         RuleBasedCollator
  # @see         CollationKey
  # @see         CollationElementIterator
  # @see         Locale
  # @author      Helena Shih, Laura Werner, Richard Gillam
  class Collator 
    include_class_members CollatorImports
    include Java::Util::Comparator
    include Cloneable
    
    class_module.module_eval {
      # Collator strength value.  When set, only PRIMARY differences are
      # considered significant during comparison. The assignment of strengths
      # to language features is locale dependant. A common example is for
      # different base letters ("a" vs "b") to be considered a PRIMARY difference.
      # @see java.text.Collator#setStrength
      # @see java.text.Collator#getStrength
      const_set_lazy(:PRIMARY) { 0 }
      const_attr_reader  :PRIMARY
      
      # Collator strength value.  When set, only SECONDARY and above differences are
      # considered significant during comparison. The assignment of strengths
      # to language features is locale dependant. A common example is for
      # different accented forms of the same base letter ("a" vs "\u00E4") to be
      # considered a SECONDARY difference.
      # @see java.text.Collator#setStrength
      # @see java.text.Collator#getStrength
      const_set_lazy(:SECONDARY) { 1 }
      const_attr_reader  :SECONDARY
      
      # Collator strength value.  When set, only TERTIARY and above differences are
      # considered significant during comparison. The assignment of strengths
      # to language features is locale dependant. A common example is for
      # case differences ("a" vs "A") to be considered a TERTIARY difference.
      # @see java.text.Collator#setStrength
      # @see java.text.Collator#getStrength
      const_set_lazy(:TERTIARY) { 2 }
      const_attr_reader  :TERTIARY
      
      # Collator strength value.  When set, all differences are
      # considered significant during comparison. The assignment of strengths
      # to language features is locale dependant. A common example is for control
      # characters ("&#092;u0001" vs "&#092;u0002") to be considered equal at the
      # PRIMARY, SECONDARY, and TERTIARY levels but different at the IDENTICAL
      # level.  Additionally, differences between pre-composed accents such as
      # "&#092;u00C0" (A-grave) and combining accents such as "A&#092;u0300"
      # (A, combining-grave) will be considered significant at the IDENTICAL
      # level if decomposition is set to NO_DECOMPOSITION.
      const_set_lazy(:IDENTICAL) { 3 }
      const_attr_reader  :IDENTICAL
      
      # Decomposition mode value. With NO_DECOMPOSITION
      # set, accented characters will not be decomposed for collation. This
      # is the default setting and provides the fastest collation but
      # will only produce correct results for languages that do not use accents.
      # @see java.text.Collator#getDecomposition
      # @see java.text.Collator#setDecomposition
      const_set_lazy(:NO_DECOMPOSITION) { 0 }
      const_attr_reader  :NO_DECOMPOSITION
      
      # Decomposition mode value. With CANONICAL_DECOMPOSITION
      # set, characters that are canonical variants according to Unicode
      # standard will be decomposed for collation. This should be used to get
      # correct collation of accented characters.
      # <p>
      # CANONICAL_DECOMPOSITION corresponds to Normalization Form D as
      # described in
      # <a href="http://www.unicode.org/unicode/reports/tr15/tr15-23.html">Unicode
      # Technical Report #15</a>.
      # @see java.text.Collator#getDecomposition
      # @see java.text.Collator#setDecomposition
      const_set_lazy(:CANONICAL_DECOMPOSITION) { 1 }
      const_attr_reader  :CANONICAL_DECOMPOSITION
      
      # Decomposition mode value. With FULL_DECOMPOSITION
      # set, both Unicode canonical variants and Unicode compatibility variants
      # will be decomposed for collation.  This causes not only accented
      # characters to be collated, but also characters that have special formats
      # to be collated with their norminal form. For example, the half-width and
      # full-width ASCII and Katakana characters are then collated together.
      # FULL_DECOMPOSITION is the most complete and therefore the slowest
      # decomposition mode.
      # <p>
      # FULL_DECOMPOSITION corresponds to Normalization Form KD as
      # described in
      # <a href="http://www.unicode.org/unicode/reports/tr15/tr15-23.html">Unicode
      # Technical Report #15</a>.
      # @see java.text.Collator#getDecomposition
      # @see java.text.Collator#setDecomposition
      const_set_lazy(:FULL_DECOMPOSITION) { 2 }
      const_attr_reader  :FULL_DECOMPOSITION
      
      typesig { [] }
      # Gets the Collator for the current default locale.
      # The default locale is determined by java.util.Locale.getDefault.
      # @return the Collator for the default locale.(for example, en_US)
      # @see java.util.Locale#getDefault
      def get_instance
        synchronized(self) do
          return get_instance(Locale.get_default)
        end
      end
      
      typesig { [Locale] }
      # Gets the Collator for the desired locale.
      # @param desiredLocale the desired locale.
      # @return the Collator for the desired locale.
      # @see java.util.Locale
      # @see java.util.ResourceBundle
      def get_instance(desired_locale)
        synchronized(self) do
          result = self.attr_cache.get(desired_locale)
          if (!(result).nil?)
            return result.clone # make the world safe
          end
          # Check whether a provider can provide an implementation that's closer
          # to the requested locale than what the Java runtime itself can provide.
          pool = LocaleServiceProviderPool.get_pool(CollatorProvider)
          if (pool.has_providers)
            providers_instance = pool.get_localized_object(CollatorGetter::INSTANCE, desired_locale, desired_locale)
            if (!(providers_instance).nil?)
              return providers_instance
            end
          end
          # Load the resource of the desired locale from resource
          # manager.
          col_string = ""
          begin
            resource = LocaleData.get_collation_data(desired_locale)
            col_string = RJava.cast_to_string(resource.get_string("Rule"))
          rescue MissingResourceException => e
            # Use default values
          end
          begin
            result = RuleBasedCollator.new(RJava.cast_to_string(CollationRules::DEFAULTRULES) + col_string, CANONICAL_DECOMPOSITION)
          rescue ParseException => foo
            # predefined tables should contain correct grammar
            begin
              result = RuleBasedCollator.new(CollationRules::DEFAULTRULES)
            rescue ParseException => bar
              # do nothing
            end
          end
          # Now that RuleBasedCollator adds expansions for pre-composed characters
          # into their decomposed equivalents, the default collators don't need
          # to have decomposition turned on.  Laura, 5/5/98, bug 4114077
          result.set_decomposition(NO_DECOMPOSITION)
          self.attr_cache.put(desired_locale, result)
          return result.clone
        end
      end
    }
    
    typesig { [String, String] }
    # Compares the source string to the target string according to the
    # collation rules for this Collator.  Returns an integer less than,
    # equal to or greater than zero depending on whether the source String is
    # less than, equal to or greater than the target string.  See the Collator
    # class description for an example of use.
    # <p>
    # For a one time comparison, this method has the best performance. If a
    # given String will be involved in multiple comparisons, CollationKey.compareTo
    # has the best performance. See the Collator class description for an example
    # using CollationKeys.
    # @param source the source string.
    # @param target the target string.
    # @return Returns an integer value. Value is less than zero if source is less than
    # target, value is zero if source and target are equal, value is greater than zero
    # if source is greater than target.
    # @see java.text.CollationKey
    # @see java.text.Collator#getCollationKey
    def compare(source, target)
      raise NotImplementedError
    end
    
    typesig { [Object, Object] }
    # Compares its two arguments for order.  Returns a negative integer,
    # zero, or a positive integer as the first argument is less than, equal
    # to, or greater than the second.
    # <p>
    # This implementation merely returns
    # <code> compare((String)o1, (String)o2) </code>.
    # 
    # @return a negative integer, zero, or a positive integer as the
    # first argument is less than, equal to, or greater than the
    # second.
    # @exception ClassCastException the arguments cannot be cast to Strings.
    # @see java.util.Comparator
    # @since   1.2
    def compare(o1, o2)
      return compare(o1, o2)
    end
    
    typesig { [String] }
    # Transforms the String into a series of bits that can be compared bitwise
    # to other CollationKeys. CollationKeys provide better performance than
    # Collator.compare when Strings are involved in multiple comparisons.
    # See the Collator class description for an example using CollationKeys.
    # @param source the string to be transformed into a collation key.
    # @return the CollationKey for the given String based on this Collator's collation
    # rules. If the source String is null, a null CollationKey is returned.
    # @see java.text.CollationKey
    # @see java.text.Collator#compare
    def get_collation_key(source)
      raise NotImplementedError
    end
    
    typesig { [String, String] }
    # Convenience method for comparing the equality of two strings based on
    # this Collator's collation rules.
    # @param source the source string to be compared with.
    # @param target the target string to be compared with.
    # @return true if the strings are equal according to the collation
    # rules.  false, otherwise.
    # @see java.text.Collator#compare
    def ==(source, target)
      return ((compare(source, target)).equal?(Collator::EQUAL))
    end
    
    typesig { [] }
    # Returns this Collator's strength property.  The strength property determines
    # the minimum level of difference considered significant during comparison.
    # See the Collator class description for an example of use.
    # @return this Collator's current strength property.
    # @see java.text.Collator#setStrength
    # @see java.text.Collator#PRIMARY
    # @see java.text.Collator#SECONDARY
    # @see java.text.Collator#TERTIARY
    # @see java.text.Collator#IDENTICAL
    def get_strength
      synchronized(self) do
        return @strength
      end
    end
    
    typesig { [::Java::Int] }
    # Sets this Collator's strength property.  The strength property determines
    # the minimum level of difference considered significant during comparison.
    # See the Collator class description for an example of use.
    # @param newStrength  the new strength value.
    # @see java.text.Collator#getStrength
    # @see java.text.Collator#PRIMARY
    # @see java.text.Collator#SECONDARY
    # @see java.text.Collator#TERTIARY
    # @see java.text.Collator#IDENTICAL
    # @exception  IllegalArgumentException If the new strength value is not one of
    # PRIMARY, SECONDARY, TERTIARY or IDENTICAL.
    def set_strength(new_strength)
      synchronized(self) do
        if ((!(new_strength).equal?(PRIMARY)) && (!(new_strength).equal?(SECONDARY)) && (!(new_strength).equal?(TERTIARY)) && (!(new_strength).equal?(IDENTICAL)))
          raise IllegalArgumentException.new("Incorrect comparison level.")
        end
        @strength = new_strength
      end
    end
    
    typesig { [] }
    # Get the decomposition mode of this Collator. Decomposition mode
    # determines how Unicode composed characters are handled. Adjusting
    # decomposition mode allows the user to select between faster and more
    # complete collation behavior.
    # <p>The three values for decomposition mode are:
    # <UL>
    # <LI>NO_DECOMPOSITION,
    # <LI>CANONICAL_DECOMPOSITION
    # <LI>FULL_DECOMPOSITION.
    # </UL>
    # See the documentation for these three constants for a description
    # of their meaning.
    # @return the decomposition mode
    # @see java.text.Collator#setDecomposition
    # @see java.text.Collator#NO_DECOMPOSITION
    # @see java.text.Collator#CANONICAL_DECOMPOSITION
    # @see java.text.Collator#FULL_DECOMPOSITION
    def get_decomposition
      synchronized(self) do
        return @decmp
      end
    end
    
    typesig { [::Java::Int] }
    # Set the decomposition mode of this Collator. See getDecomposition
    # for a description of decomposition mode.
    # @param decompositionMode  the new decomposition mode.
    # @see java.text.Collator#getDecomposition
    # @see java.text.Collator#NO_DECOMPOSITION
    # @see java.text.Collator#CANONICAL_DECOMPOSITION
    # @see java.text.Collator#FULL_DECOMPOSITION
    # @exception IllegalArgumentException If the given value is not a valid decomposition
    # mode.
    def set_decomposition(decomposition_mode)
      synchronized(self) do
        if ((!(decomposition_mode).equal?(NO_DECOMPOSITION)) && (!(decomposition_mode).equal?(CANONICAL_DECOMPOSITION)) && (!(decomposition_mode).equal?(FULL_DECOMPOSITION)))
          raise IllegalArgumentException.new("Wrong decomposition mode.")
        end
        @decmp = decomposition_mode
      end
    end
    
    class_module.module_eval {
      typesig { [] }
      # Returns an array of all locales for which the
      # <code>getInstance</code> methods of this class can return
      # localized instances.
      # The returned array represents the union of locales supported
      # by the Java runtime and by installed
      # {@link java.text.spi.CollatorProvider CollatorProvider} implementations.
      # It must contain at least a Locale instance equal to
      # {@link java.util.Locale#US Locale.US}.
      # 
      # @return An array of locales for which localized
      # <code>Collator</code> instances are available.
      def get_available_locales
        synchronized(self) do
          pool = LocaleServiceProviderPool.get_pool(CollatorProvider)
          return pool.get_available_locales
        end
      end
    }
    
    typesig { [] }
    # Overrides Cloneable
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    typesig { [Object] }
    # Compares the equality of two Collators.
    # @param that the Collator to be compared with this.
    # @return true if this Collator is the same as that Collator;
    # false otherwise.
    def ==(that)
      if ((self).equal?(that))
        return true
      end
      if ((that).nil?)
        return false
      end
      if (!(get_class).equal?(that.get_class))
        return false
      end
      other = that
      return (((@strength).equal?(other.attr_strength)) && ((@decmp).equal?(other.attr_decmp)))
    end
    
    typesig { [] }
    # Generates the hash code for this Collator.
    def hash_code
      raise NotImplementedError
    end
    
    typesig { [] }
    # Default constructor.  This constructor is
    # protected so subclasses can get access to it. Users typically create
    # a Collator sub-class by calling the factory method getInstance.
    # @see java.text.Collator#getInstance
    def initialize
      @strength = 0
      @decmp = 0
      @strength = TERTIARY
      @decmp = CANONICAL_DECOMPOSITION
    end
    
    attr_accessor :strength
    alias_method :attr_strength, :strength
    undef_method :strength
    alias_method :attr_strength=, :strength=
    undef_method :strength=
    
    attr_accessor :decmp
    alias_method :attr_decmp, :decmp
    undef_method :decmp
    alias_method :attr_decmp=, :decmp=
    undef_method :decmp=
    
    class_module.module_eval {
      
      def cache
        defined?(@@cache) ? @@cache : @@cache= SoftCache.new
      end
      alias_method :attr_cache, :cache
      
      def cache=(value)
        @@cache = value
      end
      alias_method :attr_cache=, :cache=
      
      # FIXME: These three constants should be removed.
      # 
      # 
      # LESS is returned if source string is compared to be less than target
      # string in the compare() method.
      # @see java.text.Collator#compare
      const_set_lazy(:LESS) { -1 }
      const_attr_reader  :LESS
      
      # EQUAL is returned if source string is compared to be equal to target
      # string in the compare() method.
      # @see java.text.Collator#compare
      const_set_lazy(:EQUAL) { 0 }
      const_attr_reader  :EQUAL
      
      # GREATER is returned if source string is compared to be greater than
      # target string in the compare() method.
      # @see java.text.Collator#compare
      const_set_lazy(:GREATER) { 1 }
      const_attr_reader  :GREATER
      
      # Obtains a Collator instance from a CollatorProvider
      # implementation.
      const_set_lazy(:CollatorGetter) { Class.new do
        include_class_members Collator
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { self::CollatorGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [self::CollatorProvider, self::Locale, String, Object] }
        def get_object(collator_provider, locale, key, *params)
          raise AssertError if not ((params.attr_length).equal?(1))
          result = collator_provider.get_instance(locale)
          if (!(result).nil?)
            # put this Collator instance in the cache for two locales, one
            # is for the desired locale, and the other is for the actual
            # locale where the provider is found, which may be a fall back locale.
            self.attr_cache.put(params[0], result)
            self.attr_cache.put(locale, result)
            return result.clone
          end
          return nil
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__collator_getter, :initialize
      end }
    }
    
    private
    alias_method :initialize__collator, :initialize
  end
  
end
