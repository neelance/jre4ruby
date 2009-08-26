require "rjava"

# Copyright 1996-2006 Sun Microsystems, Inc.  All Rights Reserved.
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
# (C) Copyright Taligent, Inc. 1996, 1997 - All Rights Reserved
# (C) Copyright IBM Corp. 1996 - 1998 - All Rights Reserved
# 
# The original version of this source code and documentation
# is copyrighted and owned by Taligent, Inc., a wholly-owned
# subsidiary of IBM. These materials are provided under terms
# of a License Agreement between Taligent and Sun. This technology
# is protected by multiple US and International patents.
# 
# This notice and attribution to Taligent may not be removed.
# Taligent is a registered trademark of Taligent, Inc.
module Java::Text
  module BreakIteratorImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Java::Text
      include_const ::Java::Lang::Ref, :SoftReference
      include_const ::Java::Net, :URL
      include_const ::Java::Io, :InputStream
      include_const ::Java::Io, :IOException
      include_const ::Java::Security, :AccessController
      include_const ::Java::Security, :PrivilegedAction
      include_const ::Java::Text, :CharacterIterator
      include_const ::Java::Text, :StringCharacterIterator
      include_const ::Java::Text::Spi, :BreakIteratorProvider
      include_const ::Java::Util, :Locale
      include_const ::Java::Util, :MissingResourceException
      include_const ::Java::Util, :ResourceBundle
      include_const ::Java::Util::Spi, :LocaleServiceProvider
      include_const ::Sun::Util, :LocaleServiceProviderPool
      include_const ::Sun::Util::Resources, :LocaleData
    }
  end
  
  # The <code>BreakIterator</code> class implements methods for finding
  # the location of boundaries in text. Instances of <code>BreakIterator</code>
  # maintain a current position and scan over text
  # returning the index of characters where boundaries occur.
  # Internally, <code>BreakIterator</code> scans text using a
  # <code>CharacterIterator</code>, and is thus able to scan text held
  # by any object implementing that protocol. A <code>StringCharacterIterator</code>
  # is used to scan <code>String</code> objects passed to <code>setText</code>.
  # 
  # <p>
  # You use the factory methods provided by this class to create
  # instances of various types of break iterators. In particular,
  # use <code>getWordInstance</code>, <code>getLineInstance</code>,
  # <code>getSentenceInstance</code>, and <code>getCharacterInstance</code>
  # to create <code>BreakIterator</code>s that perform
  # word, line, sentence, and character boundary analysis respectively.
  # A single <code>BreakIterator</code> can work only on one unit
  # (word, line, sentence, and so on). You must use a different iterator
  # for each unit boundary analysis you wish to perform.
  # 
  # <p><a name="line"></a>
  # Line boundary analysis determines where a text string can be
  # broken when line-wrapping. The mechanism correctly handles
  # punctuation and hyphenated words. Actual line breaking needs
  # to also consider the available line width and is handled by
  # higher-level software.
  # 
  # <p><a name="sentence"></a>
  # Sentence boundary analysis allows selection with correct interpretation
  # of periods within numbers and abbreviations, and trailing punctuation
  # marks such as quotation marks and parentheses.
  # 
  # <p><a name="word"></a>
  # Word boundary analysis is used by search and replace functions, as
  # well as within text editing applications that allow the user to
  # select words with a double click. Word selection provides correct
  # interpretation of punctuation marks within and following
  # words. Characters that are not part of a word, such as symbols
  # or punctuation marks, have word-breaks on both sides.
  # 
  # <p><a name="character"></a>
  # Character boundary analysis allows users to interact with characters
  # as they expect to, for example, when moving the cursor through a text
  # string. Character boundary analysis provides correct navigation
  # through character strings, regardless of how the character is stored.
  # The boundaries returned may be those of supplementary characters,
  # combining character sequences, or ligature clusters.
  # For example, an accented character might be stored as a base character
  # and a diacritical mark. What users consider to be a character can
  # differ between languages.
  # 
  # <p>
  # The <code>BreakIterator</code> instances returned by the factory methods
  # of this class are intended for use with natural languages only, not for
  # programming language text. It is however possible to define subclasses
  # that tokenize a programming language.
  # 
  # <P>
  # <strong>Examples</strong>:<P>
  # Creating and using text boundaries:
  # <blockquote>
  # <pre>
  # public static void main(String args[]) {
  # if (args.length == 1) {
  # String stringToExamine = args[0];
  # //print each word in order
  # BreakIterator boundary = BreakIterator.getWordInstance();
  # boundary.setText(stringToExamine);
  # printEachForward(boundary, stringToExamine);
  # //print each sentence in reverse order
  # boundary = BreakIterator.getSentenceInstance(Locale.US);
  # boundary.setText(stringToExamine);
  # printEachBackward(boundary, stringToExamine);
  # printFirst(boundary, stringToExamine);
  # printLast(boundary, stringToExamine);
  # }
  # }
  # </pre>
  # </blockquote>
  # 
  # Print each element in order:
  # <blockquote>
  # <pre>
  # public static void printEachForward(BreakIterator boundary, String source) {
  # int start = boundary.first();
  # for (int end = boundary.next();
  # end != BreakIterator.DONE;
  # start = end, end = boundary.next()) {
  # System.out.println(source.substring(start,end));
  # }
  # }
  # </pre>
  # </blockquote>
  # 
  # Print each element in reverse order:
  # <blockquote>
  # <pre>
  # public static void printEachBackward(BreakIterator boundary, String source) {
  # int end = boundary.last();
  # for (int start = boundary.previous();
  # start != BreakIterator.DONE;
  # end = start, start = boundary.previous()) {
  # System.out.println(source.substring(start,end));
  # }
  # }
  # </pre>
  # </blockquote>
  # 
  # Print first element:
  # <blockquote>
  # <pre>
  # public static void printFirst(BreakIterator boundary, String source) {
  # int start = boundary.first();
  # int end = boundary.next();
  # System.out.println(source.substring(start,end));
  # }
  # </pre>
  # </blockquote>
  # 
  # Print last element:
  # <blockquote>
  # <pre>
  # public static void printLast(BreakIterator boundary, String source) {
  # int end = boundary.last();
  # int start = boundary.previous();
  # System.out.println(source.substring(start,end));
  # }
  # </pre>
  # </blockquote>
  # 
  # Print the element at a specified position:
  # <blockquote>
  # <pre>
  # public static void printAt(BreakIterator boundary, int pos, String source) {
  # int end = boundary.following(pos);
  # int start = boundary.previous();
  # System.out.println(source.substring(start,end));
  # }
  # </pre>
  # </blockquote>
  # 
  # Find the next word:
  # <blockquote>
  # <pre>
  # public static int nextWordStartAfter(int pos, String text) {
  # BreakIterator wb = BreakIterator.getWordInstance();
  # wb.setText(text);
  # int last = wb.following(pos);
  # int current = wb.next();
  # while (current != BreakIterator.DONE) {
  # for (int p = last; p < current; p++) {
  # if (Character.isLetter(text.codePointAt(p)))
  # return last;
  # }
  # last = current;
  # current = wb.next();
  # }
  # return BreakIterator.DONE;
  # }
  # </pre>
  # (The iterator returned by BreakIterator.getWordInstance() is unique in that
  # the break positions it returns don't represent both the start and end of the
  # thing being iterated over.  That is, a sentence-break iterator returns breaks
  # that each represent the end of one sentence and the beginning of the next.
  # With the word-break iterator, the characters between two boundaries might be a
  # word, or they might be the punctuation or whitespace between two words.  The
  # above code uses a simple heuristic to determine which boundary is the beginning
  # of a word: If the characters between this boundary and the next boundary
  # include at least one letter (this can be an alphabetical letter, a CJK ideograph,
  # a Hangul syllable, a Kana character, etc.), then the text between this boundary
  # and the next is a word; otherwise, it's the material between words.)
  # </blockquote>
  # 
  # @see CharacterIterator
  class BreakIterator 
    include_class_members BreakIteratorImports
    include Cloneable
    
    typesig { [] }
    # Constructor. BreakIterator is stateless and has no default behavior.
    def initialize
    end
    
    typesig { [] }
    # Create a copy of this iterator
    # @return A copy of this
    def clone
      begin
        return super
      rescue CloneNotSupportedException => e
        raise InternalError.new
      end
    end
    
    class_module.module_eval {
      # DONE is returned by previous(), next(), next(int), preceding(int)
      # and following(int) when either the first or last text boundary has been
      # reached.
      const_set_lazy(:DONE) { -1 }
      const_attr_reader  :DONE
    }
    
    typesig { [] }
    # Returns the first boundary. The iterator's current position is set
    # to the first text boundary.
    # @return The character index of the first text boundary.
    def first
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the last boundary. The iterator's current position is set
    # to the last text boundary.
    # @return The character index of the last text boundary.
    def last
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the nth boundary from the current boundary. If either
    # the first or last text boundary has been reached, it returns
    # <code>BreakIterator.DONE</code> and the current position is set to either
    # the first or last text boundary depending on which one is reached. Otherwise,
    # the iterator's current position is set to the new boundary.
    # For example, if the iterator's current position is the mth text boundary
    # and three more boundaries exist from the current boundary to the last text
    # boundary, the next(2) call will return m + 2. The new text position is set
    # to the (m + 2)th text boundary. A next(4) call would return
    # <code>BreakIterator.DONE</code> and the last text boundary would become the
    # new text position.
    # @param n which boundary to return.  A value of 0
    # does nothing.  Negative values move to previous boundaries
    # and positive values move to later boundaries.
    # @return The character index of the nth boundary from the current position
    # or <code>BreakIterator.DONE</code> if either first or last text boundary
    # has been reached.
    def next_(n)
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the boundary following the current boundary. If the current boundary
    # is the last text boundary, it returns <code>BreakIterator.DONE</code> and
    # the iterator's current position is unchanged. Otherwise, the iterator's
    # current position is set to the boundary following the current boundary.
    # @return The character index of the next text boundary or
    # <code>BreakIterator.DONE</code> if the current boundary is the last text
    # boundary.
    # Equivalent to next(1).
    # @see #next(int)
    def next_
      raise NotImplementedError
    end
    
    typesig { [] }
    # Returns the boundary preceding the current boundary. If the current boundary
    # is the first text boundary, it returns <code>BreakIterator.DONE</code> and
    # the iterator's current position is unchanged. Otherwise, the iterator's
    # current position is set to the boundary preceding the current boundary.
    # @return The character index of the previous text boundary or
    # <code>BreakIterator.DONE</code> if the current boundary is the first text
    # boundary.
    def previous
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the first boundary following the specified character offset. If the
    # specified offset equals to the last text boundary, it returns
    # <code>BreakIterator.DONE</code> and the iterator's current position is unchanged.
    # Otherwise, the iterator's current position is set to the returned boundary.
    # The value returned is always greater than the offset or the value
    # <code>BreakIterator.DONE</code>.
    # @param offset the character offset to begin scanning.
    # @return The first boundary after the specified offset or
    # <code>BreakIterator.DONE</code> if the last text boundary is passed in
    # as the offset.
    # @exception  IllegalArgumentException if the specified offset is less than
    # the first text boundary or greater than the last text boundary.
    def following(offset)
      raise NotImplementedError
    end
    
    typesig { [::Java::Int] }
    # Returns the last boundary preceding the specified character offset. If the
    # specified offset equals to the first text boundary, it returns
    # <code>BreakIterator.DONE</code> and the iterator's current position is unchanged.
    # Otherwise, the iterator's current position is set to the returned boundary.
    # The value returned is always less than the offset or the value
    # <code>BreakIterator.DONE</code>.
    # @param offset the characater offset to begin scanning.
    # @return The last boundary before the specified offset or
    # <code>BreakIterator.DONE</code> if the first text boundary is passed in
    # as the offset.
    # @exception   IllegalArgumentException if the specified offset is less than
    # the first text boundary or greater than the last text boundary.
    # @since 1.2
    def preceding(offset)
      # NOTE:  This implementation is here solely because we can't add new
      # abstract methods to an existing class.  There is almost ALWAYS a
      # better, faster way to do this.
      pos = following(offset)
      while (pos >= offset && !(pos).equal?(DONE))
        pos = previous
      end
      return pos
    end
    
    typesig { [::Java::Int] }
    # Returns true if the specified character offset is a text boundary.
    # @param offset the character offset to check.
    # @return <code>true</code> if "offset" is a boundary position,
    # <code>false</code> otherwise.
    # @since 1.2
    def is_boundary(offset)
      # NOTE: This implementation probably is wrong for most situations
      # because it fails to take into account the possibility that a
      # CharacterIterator passed to setText() may not have a begin offset
      # of 0.  But since the abstract BreakIterator doesn't have that
      # knowledge, it assumes the begin offset is 0.  If you subclass
      # BreakIterator, copy the SimpleTextBoundary implementation of this
      # function into your subclass.  [This should have been abstract at
      # this level, but it's too late to fix that now.]
      if ((offset).equal?(0))
        return true
      else
        return (following(offset - 1)).equal?(offset)
      end
    end
    
    typesig { [] }
    # Returns character index of the text boundary that was most
    # recently returned by next(), next(int), previous(), first(), last(),
    # following(int) or preceding(int). If any of these methods returns
    # <code>BreakIterator.DONE</code> because either first or last text boundary
    # has been reached, it returns the first or last text boundary depending on
    # which one is reached.
    # @return The text boundary returned from the above methods, first or last
    # text boundary.
    # @see #next()
    # @see #next(int)
    # @see #previous()
    # @see #first()
    # @see #last()
    # @see #following(int)
    # @see #preceding(int)
    def current
      raise NotImplementedError
    end
    
    typesig { [] }
    # Get the text being scanned
    # @return the text being scanned
    def get_text
      raise NotImplementedError
    end
    
    typesig { [String] }
    # Set a new text string to be scanned.  The current scan
    # position is reset to first().
    # @param newText new text to scan.
    def set_text(new_text)
      set_text(StringCharacterIterator.new(new_text))
    end
    
    typesig { [CharacterIterator] }
    # Set a new text for scanning.  The current scan
    # position is reset to first().
    # @param newText new text to scan.
    def set_text(new_text)
      raise NotImplementedError
    end
    
    class_module.module_eval {
      const_set_lazy(:CHARACTER_INDEX) { 0 }
      const_attr_reader  :CHARACTER_INDEX
      
      const_set_lazy(:WORD_INDEX) { 1 }
      const_attr_reader  :WORD_INDEX
      
      const_set_lazy(:LINE_INDEX) { 2 }
      const_attr_reader  :LINE_INDEX
      
      const_set_lazy(:SENTENCE_INDEX) { 3 }
      const_attr_reader  :SENTENCE_INDEX
      
      const_set_lazy(:IterCache) { Array.typed(SoftReference).new(4) { nil } }
      const_attr_reader  :IterCache
      
      typesig { [] }
      # Returns a new <code>BreakIterator</code> instance
      # for <a href="#word">word breaks</a>
      # for the {@linkplain Locale#getDefault() default locale}.
      # @return A break iterator for word breaks
      def get_word_instance
        return get_word_instance(Locale.get_default)
      end
      
      typesig { [Locale] }
      # Returns a new <code>BreakIterator</code> instance
      # for <a href="#word">word breaks</a>
      # for the given locale.
      # @param locale the desired locale
      # @return A break iterator for word breaks
      # @exception NullPointerException if <code>locale</code> is null
      def get_word_instance(locale)
        return get_break_instance(locale, WORD_INDEX, "WordData", "WordDictionary")
      end
      
      typesig { [] }
      # Returns a new <code>BreakIterator</code> instance
      # for <a href="#line">line breaks</a>
      # for the {@linkplain Locale#getDefault() default locale}.
      # @return A break iterator for line breaks
      def get_line_instance
        return get_line_instance(Locale.get_default)
      end
      
      typesig { [Locale] }
      # Returns a new <code>BreakIterator</code> instance
      # for <a href="#line">line breaks</a>
      # for the given locale.
      # @param locale the desired locale
      # @return A break iterator for line breaks
      # @exception NullPointerException if <code>locale</code> is null
      def get_line_instance(locale)
        return get_break_instance(locale, LINE_INDEX, "LineData", "LineDictionary")
      end
      
      typesig { [] }
      # Returns a new <code>BreakIterator</code> instance
      # for <a href="#character">character breaks</a>
      # for the {@linkplain Locale#getDefault() default locale}.
      # @return A break iterator for character breaks
      def get_character_instance
        return get_character_instance(Locale.get_default)
      end
      
      typesig { [Locale] }
      # Returns a new <code>BreakIterator</code> instance
      # for <a href="#character">character breaks</a>
      # for the given locale.
      # @param locale the desired locale
      # @return A break iterator for character breaks
      # @exception NullPointerException if <code>locale</code> is null
      def get_character_instance(locale)
        return get_break_instance(locale, CHARACTER_INDEX, "CharacterData", "CharacterDictionary")
      end
      
      typesig { [] }
      # Returns a new <code>BreakIterator</code> instance
      # for <a href="#sentence">sentence breaks</a>
      # for the {@linkplain Locale#getDefault() default locale}.
      # @return A break iterator for sentence breaks
      def get_sentence_instance
        return get_sentence_instance(Locale.get_default)
      end
      
      typesig { [Locale] }
      # Returns a new <code>BreakIterator</code> instance
      # for <a href="#sentence">sentence breaks</a>
      # for the given locale.
      # @param locale the desired locale
      # @return A break iterator for sentence breaks
      # @exception NullPointerException if <code>locale</code> is null
      def get_sentence_instance(locale)
        return get_break_instance(locale, SENTENCE_INDEX, "SentenceData", "SentenceDictionary")
      end
      
      typesig { [Locale, ::Java::Int, String, String] }
      def get_break_instance(locale, type, data_name, dictionary_name)
        if (!(IterCache[type]).nil?)
          cache = IterCache[type].get
          if (!(cache).nil?)
            if ((cache.get_locale == locale))
              return cache.create_break_instance
            end
          end
        end
        result = create_break_instance(locale, type, data_name, dictionary_name)
        cache = BreakIteratorCache.new(locale, result)
        IterCache[type] = SoftReference.new(cache)
        return result
      end
      
      typesig { [String, Locale] }
      def get_bundle(base_name, locale)
        return AccessController.do_privileged(Class.new(PrivilegedAction.class == Class ? PrivilegedAction : Object) do
          extend LocalClass
          include_class_members BreakIterator
          include PrivilegedAction if PrivilegedAction.class == Module
          
          typesig { [] }
          define_method :run do
            return ResourceBundle.get_bundle(base_name, locale)
          end
          
          typesig { [] }
          define_method :initialize do
            super()
          end
          
          private
          alias_method :initialize_anonymous, :initialize
        end.new_local(self))
      end
      
      typesig { [Locale, ::Java::Int, String, String] }
      def create_break_instance(locale, type, data_name, dictionary_name)
        # Check whether a provider can provide an implementation that's closer
        # to the requested locale than what the Java runtime itself can provide.
        pool = LocaleServiceProviderPool.get_pool(BreakIteratorProvider)
        if (pool.has_providers)
          providers_instance = pool.get_localized_object(BreakIteratorGetter::INSTANCE, locale, type)
          if (!(providers_instance).nil?)
            return providers_instance
          end
        end
        bundle = get_bundle("sun.text.resources.BreakIteratorInfo", locale)
        class_names = bundle.get_string_array("BreakIteratorClasses")
        data_file = bundle.get_string(data_name)
        begin
          if ((class_names[type] == "RuleBasedBreakIterator"))
            return RuleBasedBreakIterator.new(data_file)
          else
            if ((class_names[type] == "DictionaryBasedBreakIterator"))
              dictionary_file = bundle.get_string(dictionary_name)
              return DictionaryBasedBreakIterator.new(data_file, dictionary_file)
            else
              raise IllegalArgumentException.new("Invalid break iterator class \"" + RJava.cast_to_string(class_names[type]) + "\"")
            end
          end
        rescue JavaException => e
          raise InternalError.new(e.to_s)
        end
      end
      
      typesig { [] }
      # Returns an array of all locales for which the
      # <code>get*Instance</code> methods of this class can return
      # localized instances.
      # The returned array represents the union of locales supported by the Java
      # runtime and by installed
      # {@link java.text.spi.BreakIteratorProvider BreakIteratorProvider} implementations.
      # It must contain at least a <code>Locale</code>
      # instance equal to {@link java.util.Locale#US Locale.US}.
      # 
      # @return An array of locales for which localized
      # <code>BreakIterator</code> instances are available.
      def get_available_locales
        synchronized(self) do
          pool = LocaleServiceProviderPool.get_pool(BreakIteratorProvider)
          return pool.get_available_locales
        end
      end
      
      const_set_lazy(:BreakIteratorCache) { Class.new do
        include_class_members BreakIterator
        
        attr_accessor :iter
        alias_method :attr_iter, :iter
        undef_method :iter
        alias_method :attr_iter=, :iter=
        undef_method :iter=
        
        attr_accessor :locale
        alias_method :attr_locale, :locale
        undef_method :locale
        alias_method :attr_locale=, :locale=
        undef_method :locale=
        
        typesig { [self::Locale, self::BreakIterator] }
        def initialize(locale, iter)
          @iter = nil
          @locale = nil
          @locale = locale
          @iter = iter.clone
        end
        
        typesig { [] }
        def get_locale
          return @locale
        end
        
        typesig { [] }
        def create_break_instance
          return @iter.clone
        end
        
        private
        alias_method :initialize__break_iterator_cache, :initialize
      end }
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_long(buf, offset)
        num = buf[offset] & 0xff
        i = 1
        while i < 8
          num = num << 8 | (buf[offset + i] & 0xff)
          i += 1
        end
        return num
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_int(buf, offset)
        num = buf[offset] & 0xff
        i = 1
        while i < 4
          num = num << 8 | (buf[offset + i] & 0xff)
          i += 1
        end
        return num
      end
      
      typesig { [Array.typed(::Java::Byte), ::Java::Int] }
      def get_short(buf, offset)
        num = RJava.cast_to_short((buf[offset] & 0xff))
        num = RJava.cast_to_short((num << 8 | (buf[offset + 1] & 0xff)))
        return num
      end
      
      # Obtains a BreakIterator instance from a BreakIteratorProvider
      # implementation.
      const_set_lazy(:BreakIteratorGetter) { Class.new do
        include_class_members BreakIterator
        include LocaleServiceProviderPool::LocalizedObjectGetter
        
        class_module.module_eval {
          const_set_lazy(:INSTANCE) { self.class::BreakIteratorGetter.new }
          const_attr_reader  :INSTANCE
        }
        
        typesig { [self::BreakIteratorProvider, self::Locale, self::String, Object] }
        def get_object(break_iterator_provider, locale, key, *params)
          raise AssertError if not ((params.attr_length).equal?(1))
          case (params[0])
          when CHARACTER_INDEX
            return break_iterator_provider.get_character_instance(locale)
          when WORD_INDEX
            return break_iterator_provider.get_word_instance(locale)
          when LINE_INDEX
            return break_iterator_provider.get_line_instance(locale)
          when SENTENCE_INDEX
            return break_iterator_provider.get_sentence_instance(locale)
          else
            raise AssertError, "should not happen" if not (false)
          end
          return nil
        end
        
        typesig { [] }
        def initialize
        end
        
        private
        alias_method :initialize__break_iterator_getter, :initialize
      end }
    }
    
    private
    alias_method :initialize__break_iterator, :initialize
  end
  
end
