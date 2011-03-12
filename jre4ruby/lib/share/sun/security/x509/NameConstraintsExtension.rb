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
module Sun::Security::X509
  module NameConstraintsExtensionImports #:nodoc:
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::X509
      include_const ::Java::Io, :IOException
      include_const ::Java::Io, :OutputStream
      include_const ::Java::Security, :Principal
      include_const ::Java::Security::Cert, :CertificateEncodingException
      include_const ::Java::Security::Cert, :CertificateException
      include_const ::Java::Security::Cert, :CertificateParsingException
      include_const ::Java::Security::Cert, :X509Certificate
      include ::Java::Util
      include_const ::Javax::Security::Auth::X500, :X500Principal
      include ::Sun::Security::Util
      include_const ::Sun::Security::Pkcs, :PKCS9Attribute
    }
  end
  
  # This class defines the Name Constraints Extension.
  # <p>
  # The name constraints extension provides permitted and excluded
  # subtrees that place restrictions on names that may be included within
  # a certificate issued by a given CA.  Restrictions may apply to the
  # subject distinguished name or subject alternative names.  Any name
  # matching a restriction in the excluded subtrees field is invalid
  # regardless of information appearing in the permitted subtrees.
  # <p>
  # The ASN.1 syntax for this is:
  # <pre>
  # NameConstraints ::= SEQUENCE {
  #    permittedSubtrees [0]  GeneralSubtrees OPTIONAL,
  #    excludedSubtrees  [1]  GeneralSubtrees OPTIONAL
  # }
  # GeneralSubtrees ::= SEQUENCE SIZE (1..MAX) OF GeneralSubtree
  # </pre>
  # 
  # @author Amit Kapoor
  # @author Hemma Prafullchandra
  # @see Extension
  # @see CertAttrSet
  class NameConstraintsExtension < NameConstraintsExtensionImports.const_get :Extension
    include_class_members NameConstraintsExtensionImports
    overload_protected {
      include CertAttrSet
      include Cloneable
    }
    
    class_module.module_eval {
      # Identifier for this attribute, to be used with the
      # get, set, delete methods of Certificate, x509 type.
      const_set_lazy(:IDENT) { "x509.info.extensions.NameConstraints" }
      const_attr_reader  :IDENT
      
      # Attribute names.
      const_set_lazy(:NAME) { "NameConstraints" }
      const_attr_reader  :NAME
      
      const_set_lazy(:PERMITTED_SUBTREES) { "permitted_subtrees" }
      const_attr_reader  :PERMITTED_SUBTREES
      
      const_set_lazy(:EXCLUDED_SUBTREES) { "excluded_subtrees" }
      const_attr_reader  :EXCLUDED_SUBTREES
      
      # Private data members
      const_set_lazy(:TAG_PERMITTED) { 0 }
      const_attr_reader  :TAG_PERMITTED
      
      const_set_lazy(:TAG_EXCLUDED) { 1 }
      const_attr_reader  :TAG_EXCLUDED
    }
    
    attr_accessor :permitted
    alias_method :attr_permitted, :permitted
    undef_method :permitted
    alias_method :attr_permitted=, :permitted=
    undef_method :permitted=
    
    attr_accessor :excluded
    alias_method :attr_excluded, :excluded
    undef_method :excluded
    alias_method :attr_excluded=, :excluded=
    undef_method :excluded=
    
    attr_accessor :has_min
    alias_method :attr_has_min, :has_min
    undef_method :has_min
    alias_method :attr_has_min=, :has_min=
    undef_method :has_min=
    
    attr_accessor :has_max
    alias_method :attr_has_max, :has_max
    undef_method :has_max
    alias_method :attr_has_max=, :has_max=
    undef_method :has_max=
    
    attr_accessor :min_max_valid
    alias_method :attr_min_max_valid, :min_max_valid
    undef_method :min_max_valid
    alias_method :attr_min_max_valid=, :min_max_valid=
    undef_method :min_max_valid=
    
    typesig { [] }
    # Recalculate hasMin and hasMax flags.
    def calc_min_max
      @has_min = false
      @has_max = false
      if (!(@excluded).nil?)
        i = 0
        while i < @excluded.size
          subtree = @excluded.get(i)
          if (!(subtree.get_minimum).equal?(0))
            @has_min = true
          end
          if (!(subtree.get_maximum).equal?(-1))
            @has_max = true
          end
          i += 1
        end
      end
      if (!(@permitted).nil?)
        i = 0
        while i < @permitted.size
          subtree = @permitted.get(i)
          if (!(subtree.get_minimum).equal?(0))
            @has_min = true
          end
          if (!(subtree.get_maximum).equal?(-1))
            @has_max = true
          end
          i += 1
        end
      end
      @min_max_valid = true
    end
    
    typesig { [] }
    # Encode this extension value.
    def encode_this
      @min_max_valid = false
      if ((@permitted).nil? && (@excluded).nil?)
        self.attr_extension_value = nil
        return
      end
      seq = DerOutputStream.new
      tagged = DerOutputStream.new
      if (!(@permitted).nil?)
        tmp = DerOutputStream.new
        @permitted.encode(tmp)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_PERMITTED), tmp)
      end
      if (!(@excluded).nil?)
        tmp = DerOutputStream.new
        @excluded.encode(tmp)
        tagged.write_implicit(DerValue.create_tag(DerValue::TAG_CONTEXT, true, TAG_EXCLUDED), tmp)
      end
      seq.write(DerValue.attr_tag_sequence, tagged)
      self.attr_extension_value = seq.to_byte_array
    end
    
    typesig { [GeneralSubtrees, GeneralSubtrees] }
    # The default constructor for this class. Both parameters
    # are optional and can be set to null.  The extension criticality
    # is set to true.
    # 
    # @param permitted the permitted GeneralSubtrees (null for optional).
    # @param excluded the excluded GeneralSubtrees (null for optional).
    def initialize(permitted, excluded)
      @permitted = nil
      @excluded = nil
      @has_min = false
      @has_max = false
      @min_max_valid = false
      super()
      @permitted = nil
      @excluded = nil
      @min_max_valid = false
      @permitted = permitted
      @excluded = excluded
      self.attr_extension_id = PKIXExtensions::NameConstraints_Id
      self.attr_critical = true
      encode_this
    end
    
    typesig { [Boolean, Object] }
    # Create the extension from the passed DER encoded value.
    # 
    # @param critical true if the extension is to be treated as critical.
    # @param value an array of DER encoded bytes of the actual value.
    # @exception ClassCastException if value is not an array of bytes
    # @exception IOException on error.
    def initialize(critical, value)
      @permitted = nil
      @excluded = nil
      @has_min = false
      @has_max = false
      @min_max_valid = false
      super()
      @permitted = nil
      @excluded = nil
      @min_max_valid = false
      self.attr_extension_id = PKIXExtensions::NameConstraints_Id
      self.attr_critical = critical.boolean_value
      self.attr_extension_value = value
      val = DerValue.new(self.attr_extension_value)
      if (!(val.attr_tag).equal?(DerValue.attr_tag_sequence))
        raise IOException.new("Invalid encoding for" + " NameConstraintsExtension.")
      end
      # NB. this is always encoded with the IMPLICIT tag
      # The checks only make sense if we assume implicit tagging,
      # with explicit tagging the form is always constructed.
      # Note that all the fields in NameConstraints are defined as
      # being OPTIONAL, i.e., there could be an empty SEQUENCE, resulting
      # in val.data being null.
      if ((val.attr_data).nil?)
        return
      end
      while (!(val.attr_data.available).equal?(0))
        opt = val.attr_data.get_der_value
        if (opt.is_context_specific(TAG_PERMITTED) && opt.is_constructed)
          if (!(@permitted).nil?)
            raise IOException.new("Duplicate permitted " + "GeneralSubtrees in NameConstraintsExtension.")
          end
          opt.reset_tag(DerValue.attr_tag_sequence)
          @permitted = GeneralSubtrees.new(opt)
        else
          if (opt.is_context_specific(TAG_EXCLUDED) && opt.is_constructed)
            if (!(@excluded).nil?)
              raise IOException.new("Duplicate excluded " + "GeneralSubtrees in NameConstraintsExtension.")
            end
            opt.reset_tag(DerValue.attr_tag_sequence)
            @excluded = GeneralSubtrees.new(opt)
          else
            raise IOException.new("Invalid encoding of " + "NameConstraintsExtension.")
          end
        end
      end
      @min_max_valid = false
    end
    
    typesig { [] }
    # Return the printable string.
    def to_s
      return (RJava.cast_to_string(super) + "NameConstraints: [" + RJava.cast_to_string((((@permitted).nil?) ? "" : ("\n    Permitted:" + RJava.cast_to_string(@permitted.to_s)))) + RJava.cast_to_string((((@excluded).nil?) ? "" : ("\n    Excluded:" + RJava.cast_to_string(@excluded.to_s)))) + "   ]\n")
    end
    
    typesig { [OutputStream] }
    # Write the extension to the OutputStream.
    # 
    # @param out the OutputStream to write the extension to.
    # @exception IOException on encoding errors.
    def encode(out)
      tmp = DerOutputStream.new
      if ((self.attr_extension_value).nil?)
        self.attr_extension_id = PKIXExtensions::NameConstraints_Id
        self.attr_critical = true
        encode_this
      end
      super(tmp)
      out.write(tmp.to_byte_array)
    end
    
    typesig { [String, Object] }
    # Set the attribute value.
    def set(name, obj)
      if (name.equals_ignore_case(PERMITTED_SUBTREES))
        if (!(obj.is_a?(GeneralSubtrees)))
          raise IOException.new("Attribute value should be" + " of type GeneralSubtrees.")
        end
        @permitted = obj
      else
        if (name.equals_ignore_case(EXCLUDED_SUBTREES))
          if (!(obj.is_a?(GeneralSubtrees)))
            raise IOException.new("Attribute value should be " + "of type GeneralSubtrees.")
          end
          @excluded = obj
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:NameConstraintsExtension.")
        end
      end
      encode_this
    end
    
    typesig { [String] }
    # Get the attribute value.
    def get(name)
      if (name.equals_ignore_case(PERMITTED_SUBTREES))
        return (@permitted)
      else
        if (name.equals_ignore_case(EXCLUDED_SUBTREES))
          return (@excluded)
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:NameConstraintsExtension.")
        end
      end
    end
    
    typesig { [String] }
    # Delete the attribute value.
    def delete(name)
      if (name.equals_ignore_case(PERMITTED_SUBTREES))
        @permitted = nil
      else
        if (name.equals_ignore_case(EXCLUDED_SUBTREES))
          @excluded = nil
        else
          raise IOException.new("Attribute name not recognized by " + "CertAttrSet:NameConstraintsExtension.")
        end
      end
      encode_this
    end
    
    typesig { [] }
    # Return an enumeration of names of attributes existing within this
    # attribute.
    def get_elements
      elements = AttributeNameEnumeration.new
      elements.add_element(PERMITTED_SUBTREES)
      elements.add_element(EXCLUDED_SUBTREES)
      return (elements.elements)
    end
    
    typesig { [] }
    # Return the name of this attribute.
    def get_name
      return (NAME)
    end
    
    typesig { [NameConstraintsExtension] }
    # Merge additional name constraints with existing ones.
    # This function is used in certification path processing
    # to accumulate name constraints from successive certificates
    # in the path.  Note that NameConstraints can never be
    # expanded by a merge, just remain constant or become more
    # limiting.
    # <p>
    # IETF RFC2459 specifies the processing of Name Constraints as
    # follows:
    # <p>
    # (j)  If permittedSubtrees is present in the certificate, set the
    # constrained subtrees state variable to the intersection of its
    # previous value and the value indicated in the extension field.
    # <p>
    # (k)  If excludedSubtrees is present in the certificate, set the
    # excluded subtrees state variable to the union of its previous
    # value and the value indicated in the extension field.
    # <p>
    # @param newConstraints additional NameConstraints to be applied
    # @throws IOException on error
    def merge(new_constraints)
      if ((new_constraints).nil?)
        # absence of any explicit constraints implies unconstrained
        return
      end
      # If excludedSubtrees is present in the certificate, set the
      # excluded subtrees state variable to the union of its previous
      # value and the value indicated in the extension field.
      new_excluded = new_constraints.get(EXCLUDED_SUBTREES)
      if ((@excluded).nil?)
        @excluded = (!(new_excluded).nil?) ? new_excluded.clone : nil
      else
        if (!(new_excluded).nil?)
          # Merge new excluded with current excluded (union)
          @excluded.union(new_excluded)
        end
      end
      # If permittedSubtrees is present in the certificate, set the
      # constrained subtrees state variable to the intersection of its
      # previous value and the value indicated in the extension field.
      new_permitted = new_constraints.get(PERMITTED_SUBTREES)
      if ((@permitted).nil?)
        @permitted = (!(new_permitted).nil?) ? new_permitted.clone : nil
      else
        if (!(new_permitted).nil?)
          # Merge new permitted with current permitted (intersection)
          new_excluded = @permitted.intersect(new_permitted)
          # Merge new excluded subtrees to current excluded (union)
          if (!(new_excluded).nil?)
            if (!(@excluded).nil?)
              @excluded.union(new_excluded)
            else
              @excluded = new_excluded.clone
            end
          end
        end
      end
      # Optional optimization: remove permitted subtrees that are excluded.
      # This is not necessary for algorithm correctness, but it makes
      # subsequent operations on the NameConstraints faster and require
      # less space.
      if (!(@permitted).nil?)
        @permitted.reduce(@excluded)
      end
      # The NameConstraints have been changed, so re-encode them.  Methods in
      # this class assume that the encodings have already been done.
      encode_this
    end
    
    typesig { [X509Certificate] }
    # check whether a certificate conforms to these NameConstraints.
    # This involves verifying that the subject name and subjectAltName
    # extension (critical or noncritical) is consistent with the permitted
    # subtrees state variables.  Also verify that the subject name and
    # subjectAltName extension (critical or noncritical) is consistent with
    # the excluded subtrees state variables.
    # 
    # @param cert X509Certificate to be verified
    # @returns true if certificate verifies successfully
    # @throws IOException on error
    def verify(cert)
      if ((cert).nil?)
        raise IOException.new("Certificate is null")
      end
      # Calculate hasMin and hasMax booleans (if necessary)
      if (!@min_max_valid)
        calc_min_max
      end
      if (@has_min)
        raise IOException.new("Non-zero minimum BaseDistance in" + " name constraints not supported")
      end
      if (@has_max)
        raise IOException.new("Maximum BaseDistance in" + " name constraints not supported")
      end
      subject_principal = cert.get_subject_x500principal
      subject = X500Name.as_x500name(subject_principal)
      if ((subject.is_empty).equal?(false))
        if ((verify(subject)).equal?(false))
          return false
        end
      end
      alt_names = nil
      # extract altNames
      begin
        # extract extensions, if any, from certInfo
        # following returns null if certificate contains no extensions
        cert_impl = X509CertImpl.to_impl(cert)
        alt_name_ext = cert_impl.get_subject_alternative_name_extension
        if (!(alt_name_ext).nil?)
          # extract altNames from extension; this call does not
          # return an IOException on null altnames
          alt_names = (alt_name_ext.get(alt_name_ext.attr_subject_name))
        end
      rescue CertificateException => ce
        raise IOException.new("Unable to extract extensions from " + "certificate: " + RJava.cast_to_string(ce.get_message))
      end
      # If there are no subjectAlternativeNames, perform the special-case
      # check where if the subjectName contains any EMAILADDRESS
      # attributes, they must be checked against RFC822 constraints.
      # If that passes, we're fine.
      if ((alt_names).nil?)
        return verify_rfc822special_case(subject)
      end
      # verify each subjectAltName
      i = 0
      while i < alt_names.size
        alt_gni = alt_names.get(i).get_name
        if (!verify(alt_gni))
          return false
        end
        i += 1
      end
      # All tests passed.
      return true
    end
    
    typesig { [GeneralNameInterface] }
    # check whether a name conforms to these NameConstraints.
    # This involves verifying that the name is consistent with the
    # permitted and excluded subtrees variables.
    # 
    # @param name GeneralNameInterface name to be verified
    # @returns true if certificate verifies successfully
    # @throws IOException on error
    def verify(name)
      if ((name).nil?)
        raise IOException.new("name is null")
      end
      # Verify that the name is consistent with the excluded subtrees
      if (!(@excluded).nil? && @excluded.size > 0)
        i = 0
        while i < @excluded.size
          gs = @excluded.get(i)
          if ((gs).nil?)
            i += 1
            next
          end
          gn = gs.get_name
          if ((gn).nil?)
            i += 1
            next
          end
          ex_name = gn.get_name
          if ((ex_name).nil?)
            i += 1
            next
          end
          # if name matches or narrows any excluded subtree,
          # return false
          case (ex_name.constrains(name))
          when GeneralNameInterface::NAME_DIFF_TYPE, GeneralNameInterface::NAME_WIDENS, GeneralNameInterface::NAME_SAME_TYPE
            # name widens excluded
          when GeneralNameInterface::NAME_MATCH, GeneralNameInterface::NAME_NARROWS
            # subject name excluded
            return false
          end
          i += 1
        end
      end
      # Verify that the name is consistent with the permitted subtrees
      if (!(@permitted).nil? && @permitted.size > 0)
        same_type = false
        i = 0
        while i < @permitted.size
          gs = @permitted.get(i)
          if ((gs).nil?)
            i += 1
            next
          end
          gn = gs.get_name
          if ((gn).nil?)
            i += 1
            next
          end
          per_name = gn.get_name
          if ((per_name).nil?)
            i += 1
            next
          end
          # if Name matches any type in permitted,
          # and Name does not match or narrow some permitted subtree,
          # return false
          case (per_name.constrains(name))
          when GeneralNameInterface::NAME_DIFF_TYPE
            i += 1
            next # continue checking other permitted names # name widens permitted
            same_type = true
            i += 1
            next # continue to look for a match or narrow
            # name narrows permitted
            return true
          when GeneralNameInterface::NAME_WIDENS, GeneralNameInterface::NAME_SAME_TYPE
            # continue checking other permitted names
            # name widens permitted
            same_type = true
            i += 1
            next # continue to look for a match or narrow
            # name narrows permitted
            return true
          when GeneralNameInterface::NAME_MATCH, GeneralNameInterface::NAME_NARROWS
            # continue to look for a match or narrow
            # name narrows permitted
            return true
          # name is definitely OK, so break out of loop
          end
          i += 1
        end
        if (same_type)
          return false
        end
      end
      return true
    end
    
    typesig { [X500Name] }
    # Perform the RFC 822 special case check. We have a certificate
    # that does not contain any subject alternative names. Check that
    # any EMAILADDRESS attributes in its subject name conform to these
    # NameConstraints.
    # 
    # @param subject the certificate's subject name
    # @returns true if certificate verifies successfully
    # @throws IOException on error
    def verify_rfc822special_case(subject)
      t = subject.all_avas.iterator
      while t.has_next
        ava = t.next_
        attr_oid = ava.get_object_identifier
        if ((attr_oid == PKCS9Attribute::EMAIL_ADDRESS_OID))
          attr_value = ava.get_value_string
          if (!(attr_value).nil?)
            email_name = nil
            begin
              email_name = RFC822Name.new(attr_value)
            rescue IOException => ioe
              next
            end
            if (!verify(email_name))
              return (false)
            end
          end
        end
      end
      return true
    end
    
    typesig { [] }
    # Clone all objects that may be modified during certificate validation.
    def clone
      begin
        new_nce = super
        if (!(@permitted).nil?)
          new_nce.attr_permitted = @permitted.clone
        end
        if (!(@excluded).nil?)
          new_nce.attr_excluded = @excluded.clone
        end
        return new_nce
      rescue CloneNotSupportedException => cnsee
        raise RuntimeException.new("CloneNotSupportedException while " + "cloning NameConstraintsException. This should never happen.")
      end
    end
    
    private
    alias_method :initialize__name_constraints_extension, :initialize
  end
  
end
