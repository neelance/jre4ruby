require "rjava"

# Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
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
module Sun::Security::Ec
  module ECParametersImports
    class_module.module_eval {
      include ::Java::Lang
      include ::Sun::Security::Ec
      include_const ::Java::Io, :IOException
      include_const ::Java::Math, :BigInteger
      include ::Java::Security
      include ::Java::Security::Spec
      include ::Sun::Security::Util
    }
  end
  
  # This class implements encoding and decoding of Elliptic Curve parameters
  # as specified in RFC 3279.
  # 
  # However, only named curves are currently supported.
  # 
  # ASN.1 from RFC 3279 follows. Note that X9.62 (2005) has added some additional
  # options.
  # 
  # <pre>
  # EcpkParameters ::= CHOICE {
  # ecParameters  ECParameters,
  # namedCurve    OBJECT IDENTIFIER,
  # implicitlyCA  NULL }
  # 
  # ECParameters ::= SEQUENCE {
  # version   ECPVer,          -- version is always 1
  # fieldID   FieldID,         -- identifies the finite field over
  # -- which the curve is defined
  # curve     Curve,           -- coefficients a and b of the
  # -- elliptic curve
  # base      ECPoint,         -- specifies the base point P
  # -- on the elliptic curve
  # order     INTEGER,         -- the order n of the base point
  # cofactor  INTEGER OPTIONAL -- The integer h = #E(Fq)/n
  # }
  # 
  # ECPVer ::= INTEGER {ecpVer1(1)}
  # 
  # Curve ::= SEQUENCE {
  # a         FieldElement,
  # b         FieldElement,
  # seed      BIT STRING OPTIONAL }
  # 
  # FieldElement ::= OCTET STRING
  # 
  # ECPoint ::= OCTET STRING
  # </pre>
  # 
  # @since   1.6
  # @author  Andreas Sterbenz
  class ECParameters < ECParametersImports.const_get :AlgorithmParametersSpi
    include_class_members ECParametersImports
    
    typesig { [] }
    def initialize
      @param_spec = nil
      super()
      # empty
    end
    
    class_module.module_eval {
      typesig { [Array.typed(::Java::Byte), EllipticCurve] }
      # Used by SunPKCS11 and SunJSSE.
      def decode_point(data, curve)
        if (((data.attr_length).equal?(0)) || (!(data[0]).equal?(4)))
          raise IOException.new("Only uncompressed point format supported")
        end
        n = (curve.get_field.get_field_size + 7) >> 3
        if (!(data.attr_length).equal?((n * 2) + 1))
          raise IOException.new("Point does not match field size")
        end
        xb = Array.typed(::Java::Byte).new(n) { 0 }
        yb = Array.typed(::Java::Byte).new(n) { 0 }
        System.arraycopy(data, 1, xb, 0, n)
        System.arraycopy(data, n + 1, yb, 0, n)
        return ECPoint.new(BigInteger.new(1, xb), BigInteger.new(1, yb))
      end
      
      typesig { [ECPoint, EllipticCurve] }
      # Used by SunPKCS11 and SunJSSE.
      def encode_point(point, curve)
        # get field size in bytes (rounding up)
        n = (curve.get_field.get_field_size + 7) >> 3
        xb = trim_zeroes(point.get_affine_x.to_byte_array)
        yb = trim_zeroes(point.get_affine_y.to_byte_array)
        if ((xb.attr_length > n) || (yb.attr_length > n))
          raise RuntimeException.new("Point coordinates do not match field size")
        end
        b = Array.typed(::Java::Byte).new(1 + (n << 1)) { 0 }
        b[0] = 4 # uncompressed
        System.arraycopy(xb, 0, b, n - xb.attr_length + 1, xb.attr_length)
        System.arraycopy(yb, 0, b, b.attr_length - yb.attr_length, yb.attr_length)
        return b
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Copied from the SunPKCS11 code - should be moved to a common location.
      # trim leading (most significant) zeroes from the result
      def trim_zeroes(b)
        i = 0
        while ((i < b.attr_length - 1) && ((b[i]).equal?(0)))
          i += 1
        end
        if ((i).equal?(0))
          return b
        end
        t = Array.typed(::Java::Byte).new(b.attr_length - i) { 0 }
        System.arraycopy(b, i, t, 0, t.attr_length)
        return t
      end
      
      typesig { [ECParameterSpec] }
      # Convert the given ECParameterSpec object to a NamedCurve object.
      # If params does not represent a known named curve, return null.
      # Used by SunPKCS11.
      def get_named_curve(params)
        if ((params.is_a?(NamedCurve)) || ((params).nil?))
          return params
        end
        # This is a hack to allow SunJSSE to work with 3rd party crypto
        # providers for ECC and not just SunPKCS11.
        # This can go away once we decide how to expose curve names in the
        # public API.
        # Note that it assumes that the 3rd party provider encodes named
        # curves using the short form, not explicitly. If it did that, then
        # the SunJSSE TLS ECC extensions are wrong, which could lead to
        # interoperability problems.
        field_size = params.get_curve.get_field.get_field_size
        NamedCurve.known_ecparameter_specs.each do |namedCurve|
          # ECParameterSpec does not define equals, so check all the
          # components ourselves.
          # Quick field size check first
          if (!(named_curve.get_curve.get_field.get_field_size).equal?(field_size))
            next
          end
          if (((named_curve.get_curve == params.get_curve)).equal?(false))
            next
          end
          if (((named_curve.get_generator == params.get_generator)).equal?(false))
            next
          end
          if (((named_curve.get_order == params.get_order)).equal?(false))
            next
          end
          if (!(named_curve.get_cofactor).equal?(params.get_cofactor))
            next
          end
          # everything matches our named curve, return it
          return named_curve
        end
        # no match found
        return nil
      end
      
      typesig { [ECParameterSpec] }
      # Used by SunJSSE.
      def get_curve_name(params)
        curve = get_named_curve(params)
        return ((curve).nil?) ? nil : curve.get_object_identifier.to_s
      end
      
      typesig { [ECParameterSpec] }
      # Used by SunPKCS11.
      def encode_parameters(params)
        curve = get_named_curve(params)
        if ((curve).nil?)
          raise RuntimeException.new("Not a known named curve: " + RJava.cast_to_string(params))
        end
        return curve.get_encoded
      end
      
      typesig { [Array.typed(::Java::Byte)] }
      # Used by SunPKCS11.
      def decode_parameters(params)
        encoded_params = DerValue.new(params)
        if ((encoded_params.attr_tag).equal?(DerValue.attr_tag_object_id))
          oid = encoded_params.get_oid
          spec = NamedCurve.get_ecparameter_spec(oid)
          if ((spec).nil?)
            raise IOException.new("Unknown named curve: " + RJava.cast_to_string(oid))
          end
          return spec
        end
        raise IOException.new("Only named ECParameters supported")
        # The code below is incomplete.
        # It is left as a starting point for a complete parsing implementation.
        # 
        # if (encodedParams.tag != DerValue.tag_Sequence) {
        # throw new IOException("Unsupported EC parameters, tag: " + encodedParams.tag);
        # }
        # 
        # encodedParams.data.reset();
        # 
        # DerInputStream in = encodedParams.data;
        # 
        # int version = in.getInteger();
        # if (version != 1) {
        # throw new IOException("Unsupported EC parameters version: " + version);
        # }
        # ECField field = parseField(in);
        # EllipticCurve curve = parseCurve(in, field);
        # ECPoint point = parsePoint(in, curve);
        # 
        # BigInteger order = in.getBigInteger();
        # int cofactor = 0;
        # 
        # if (in.available() != 0) {
        # cofactor = in.getInteger();
        # }
        # 
        # // XXX HashAlgorithm optional
        # 
        # if (encodedParams.data.available() != 0) {
        # throw new IOException("encoded params have " +
        # encodedParams.data.available() +
        # " extra bytes");
        # }
        # 
        # return new ECParameterSpec(curve, point, order, cofactor);
      end
      
      typesig { [ECParameterSpec] }
      # private static final ObjectIdentifier fieldTypePrime =
      # ObjectIdentifier.newInternal(new int[] {1, 2, 840, 10045, 1, 1});
      # 
      # private static final ObjectIdentifier fieldTypeChar2 =
      # ObjectIdentifier.newInternal(new int[] {1, 2, 840, 10045, 1, 2});
      # 
      # private static ECField parseField(DerInputStream in) throws IOException {
      # DerValue v = in.getDerValue();
      # ObjectIdentifier oid = v.data.getOID();
      # if (oid.equals(fieldTypePrime) == false) {
      # throw new IOException("Only prime fields supported: " + oid);
      # }
      # BigInteger fieldSize = v.data.getBigInteger();
      # return new ECFieldFp(fieldSize);
      # }
      # 
      # private static EllipticCurve parseCurve(DerInputStream in, ECField field)
      # throws IOException {
      # DerValue v = in.getDerValue();
      # byte[] ab = v.data.getOctetString();
      # byte[] bb = v.data.getOctetString();
      # return new EllipticCurve(field, new BigInteger(1, ab), new BigInteger(1, bb));
      # }
      # 
      # private static ECPoint parsePoint(DerInputStream in, EllipticCurve curve)
      # throws IOException {
      # byte[] data = in.getOctetString();
      # return decodePoint(data, curve);
      # }
      # 
      # used by ECPublicKeyImpl and ECPrivateKeyImpl
      def get_algorithm_parameters(spec)
        begin
          params = AlgorithmParameters.get_instance("EC", ECKeyFactory.attr_ec_internal_provider)
          params.init(spec)
          return params
        rescue GeneralSecurityException => e
          raise InvalidKeyException.new("EC parameters error", e)
        end
      end
    }
    
    # AlgorithmParameterSpi methods
    # The parameters these AlgorithmParameters object represents.
    # Currently, it is always an instance of NamedCurve.
    attr_accessor :param_spec
    alias_method :attr_param_spec, :param_spec
    undef_method :param_spec
    alias_method :attr_param_spec=, :param_spec=
    undef_method :param_spec=
    
    typesig { [AlgorithmParameterSpec] }
    def engine_init(param_spec)
      if (param_spec.is_a?(ECParameterSpec))
        @param_spec = get_named_curve(param_spec)
        if ((@param_spec).nil?)
          raise InvalidParameterSpecException.new("Not a supported named curve: " + RJava.cast_to_string(param_spec))
        end
      else
        if (param_spec.is_a?(ECGenParameterSpec))
          name = (param_spec).get_name
          spec = NamedCurve.get_ecparameter_spec(name)
          if ((spec).nil?)
            raise InvalidParameterSpecException.new("Unknown curve: " + name)
          end
          @param_spec = spec
        else
          if ((param_spec).nil?)
            raise InvalidParameterSpecException.new("paramSpec must not be null")
          else
            raise InvalidParameterSpecException.new("Only ECParameterSpec and ECGenParameterSpec supported")
          end
        end
      end
    end
    
    typesig { [Array.typed(::Java::Byte)] }
    def engine_init(params)
      @param_spec = decode_parameters(params)
    end
    
    typesig { [Array.typed(::Java::Byte), String] }
    def engine_init(params, decoding_method)
      engine_init(params)
    end
    
    typesig { [Class] }
    def engine_get_parameter_spec(spec)
      if (spec.is_assignable_from(ECParameterSpec))
        return @param_spec
      else
        if (spec.is_assignable_from(ECGenParameterSpec))
          return ECGenParameterSpec.new(get_curve_name(@param_spec))
        else
          raise InvalidParameterSpecException.new("Only ECParameterSpec and ECGenParameterSpec supported")
        end
      end
    end
    
    typesig { [] }
    def engine_get_encoded
      return encode_parameters(@param_spec)
    end
    
    typesig { [String] }
    def engine_get_encoded(encoding_method)
      return engine_get_encoded
    end
    
    typesig { [] }
    def engine_to_string
      return @param_spec.to_s
    end
    
    private
    alias_method :initialize__ecparameters, :initialize
  end
  
end
