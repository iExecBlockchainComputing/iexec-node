// https://raw.github.com/bitcoinjs/bitcoinjs-lib/e90780d3d3b8fc0d027d2bcb38b80479902f223e/src/ecdsa.js
const ECDSA = (function () {
  const ecparams = EllipticCurve.getSECCurveByName('secp256k1');
  const rng = new SecureRandom();

  let P_OVER_FOUR = null;

  function implShamirsTrick(P, k, Q, l) {
    const m = Math.max(k.bitLength(), l.bitLength());
    const Z = P.add2D(Q);
    let R = P.curve.getInfinity();

    for (let i = m - 1; i >= 0; --i) {
      R = R.twice2D();

      R.z = BigInteger.ONE;

      if (k.testBit(i)) {
        if (l.testBit(i)) {
          R = R.add2D(Z);
        } else {
          R = R.add2D(P);
        }
      } else if (l.testBit(i)) {
        R = R.add2D(Q);
      }
    }

    return R;
  }

  var ECDSA = {
    getBigRandom(limit) {
      return new BigInteger(limit.bitLength(), rng)
        .mod(limit.subtract(BigInteger.ONE))
        .add(BigInteger.ONE);
    },
    sign(hash, priv) {
      const d = priv;
      const n = ecparams.getN();
      const e = BigInteger.fromByteArrayUnsigned(hash);

      do {
        var k = ECDSA.getBigRandom(n);
        const G = ecparams.getG();
        const Q = G.multiply(k);
        var r = Q.getX().toBigInteger().mod(n);
      } while (r.compareTo(BigInteger.ZERO) <= 0);

      const s = k.modInverse(n).multiply(e.add(d.multiply(r))).mod(n);

      return ECDSA.serializeSig(r, s);
    },

    verify(hash, sig, pubkey) {
      let r,
        s;
      if (Bitcoin.Util.isArray(sig)) {
        const obj = ECDSA.parseSig(sig);
        r = obj.r;
        s = obj.s;
      } else if (typeof sig === 'object' && sig.r && sig.s) {
        r = sig.r;
        s = sig.s;
      } else {
        throw 'Invalid value for signature';
      }

      let Q;
      if (pubkey instanceof ec.PointFp) {
        Q = pubkey;
      } else if (Bitcoin.Util.isArray(pubkey)) {
        Q = EllipticCurve.PointFp.decodeFrom(ecparams.getCurve(), pubkey);
      } else {
        throw 'Invalid format for pubkey value, must be byte array or ec.PointFp';
      }
      const e = BigInteger.fromByteArrayUnsigned(hash);

      return ECDSA.verifyRaw(e, r, s, Q);
    },

    verifyRaw(e, r, s, Q) {
      const n = ecparams.getN();
      const G = ecparams.getG();

      if (r.compareTo(BigInteger.ONE) < 0 || r.compareTo(n) >= 0) return false;

      if (s.compareTo(BigInteger.ONE) < 0 || s.compareTo(n) >= 0) return false;

      const c = s.modInverse(n);

      const u1 = e.multiply(c).mod(n);
      const u2 = r.multiply(c).mod(n);

      // TODO(!!!): For some reason Shamir's trick isn't working with
      // signed message verification!? Probably an implementation
      // error!
      // var point = implShamirsTrick(G, u1, Q, u2);
      const point = G.multiply(u1).add(Q.multiply(u2));

      const v = point.getX().toBigInteger().mod(n);

      return v.equals(r);
    },

    /**
		* Serialize a signature into DER format.
		*
		* Takes two BigIntegers representing r and s and returns a byte array.
		*/
    serializeSig(r, s) {
      const rBa = r.toByteArraySigned();
      const sBa = s.toByteArraySigned();

      let sequence = [];
      sequence.push(0x02); // INTEGER
      sequence.push(rBa.length);
      sequence = sequence.concat(rBa);

      sequence.push(0x02); // INTEGER
      sequence.push(sBa.length);
      sequence = sequence.concat(sBa);

      sequence.unshift(sequence.length);
      sequence.unshift(0x30); // SEQUENCE

      return sequence;
    },

    /**
		* Parses a byte array containing a DER-encoded signature.
		*
		* This function will return an object of the form:
		*
		* {
		*   r: BigInteger,
		*   s: BigInteger
		* }
		*/
    parseSig(sig) {
      let cursor;
      if (sig[0] != 0x30) throw new Error('Signature not a valid DERSequence');

      cursor = 2;
      if (sig[cursor] != 0x02) throw new Error('First element in signature must be a DERInteger');
      const rBa = sig.slice(cursor + 2, cursor + 2 + sig[cursor + 1]);

      cursor += 2 + sig[cursor + 1];
      if (sig[cursor] != 0x02) throw new Error('Second element in signature must be a DERInteger');
      const sBa = sig.slice(cursor + 2, cursor + 2 + sig[cursor + 1]);

      cursor += 2 + sig[cursor + 1];

      // if (cursor != sig.length)
      //	throw new Error("Extra bytes in signature");

      const r = BigInteger.fromByteArrayUnsigned(rBa);
      const s = BigInteger.fromByteArrayUnsigned(sBa);

      return { r, s };
    },

    parseSigCompact(sig) {
      if (sig.length !== 65) {
        throw 'Signature has the wrong length';
      }

      // Signature is prefixed with a type byte storing three bits of
      // information.
      const i = sig[0] - 27;
      if (i < 0 || i > 7) {
        throw 'Invalid signature type';
      }

      const n = ecparams.getN();
      const r = BigInteger.fromByteArrayUnsigned(sig.slice(1, 33)).mod(n);
      const s = BigInteger.fromByteArrayUnsigned(sig.slice(33, 65)).mod(n);

      return { r, s, i };
    },

    /**
		* Recover a public key from a signature.
		*
		* See SEC 1: Elliptic Curve Cryptography, section 4.1.6, "Public
		* Key Recovery Operation".
		*
		* http://www.secg.org/download/aid-780/sec1-v2.pdf
		*/
    recoverPubKey(r, s, hash, i) {
      // The recovery parameter i has two bits.
      i &= 3;

      // The less significant bit specifies whether the y coordinate
      // of the compressed point is even or not.
      const isYEven = i & 1;

      // The more significant bit specifies whether we should use the
      // first or second candidate key.
      const isSecondKey = i >> 1;

      const n = ecparams.getN();
      const G = ecparams.getG();
      const curve = ecparams.getCurve();
      const p = curve.getQ();
      const a = curve.getA().toBigInteger();
      const b = curve.getB().toBigInteger();

      // We precalculate (p + 1) / 4 where p is if the field order
      if (!P_OVER_FOUR) {
        P_OVER_FOUR = p.add(BigInteger.ONE).divide(BigInteger.valueOf(4));
      }

      // 1.1 Compute x
      const x = isSecondKey ? r.add(n) : r;

      // 1.3 Convert x to point
      const alpha = x.multiply(x).multiply(x).add(a.multiply(x)).add(b).mod(p);
      const beta = alpha.modPow(P_OVER_FOUR, p);

      const xorOdd = beta.isEven() ? i % 2 : (i + 1) % 2;
      // If beta is even, but y isn't or vice versa, then convert it,
      // otherwise we're done and y == beta.
      const y = (beta.isEven() ? !isYEven : isYEven) ? beta : p.subtract(beta);

      // 1.4 Check that nR is at infinity
      const R = new EllipticCurve.PointFp(curve, curve.fromBigInteger(x), curve.fromBigInteger(y));
      R.validate();

      // 1.5 Compute e from M
      const e = BigInteger.fromByteArrayUnsigned(hash);
      const eNeg = BigInteger.ZERO.subtract(e).mod(n);

      // 1.6 Compute Q = r^-1 (sR - eG)
      const rInv = r.modInverse(n);
      const Q = implShamirsTrick(R, s, G, eNeg).multiply(rInv);

      Q.validate();
      if (!ECDSA.verifyRaw(e, r, s, Q)) {
        throw 'Pubkey recovery unsuccessful';
      }

      const pubKey = new Bitcoin.ECKey();
      pubKey.pub = Q;
      return pubKey;
    },

    /**
		* Calculate pubkey extraction parameter.
		*
		* When extracting a pubkey from a signature, we have to
		* distinguish four different cases. Rather than putting this
		* burden on the verifier, Bitcoin includes a 2-bit value with the
		* signature.
		*
		* This function simply tries all four cases and returns the value
		* that resulted in a successful pubkey recovery.
		*/
    calcPubkeyRecoveryParam(address, r, s, hash) {
      for (let i = 0; i < 4; i++) {
        try {
          const pubkey = Bitcoin.ECDSA.recoverPubKey(r, s, hash, i);
          if (pubkey.getBitcoinAddress().toString() == address) {
            return i;
          }
        } catch (e) {}
      }
      throw 'Unable to find valid recovery factor';
    },
  };

  return ECDSA;
}());
