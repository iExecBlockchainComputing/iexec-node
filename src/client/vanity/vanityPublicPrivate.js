/* global EllipticCurve */
const getByteArrayFromAdding = (pubKeyHex1, pubKeyHex2) => {
  const ecparams = EllipticCurve.getSECCurveByName('secp256k1');
  const curve = ecparams.getCurve();
  const ecPoint1 = curve.decodePointHex(pubKeyHex1);
  const ecPoint2 = curve.decodePointHex(pubKeyHex2);
  // if both points are the same return null
  if (ecPoint1.equals(ecPoint2)) return null;
  const compressed = (ecPoint1.compressed && ecPoint2.compressed);
  const pubKey = ecPoint1.add(ecPoint2).getEncoded(compressed);
  return pubKey;
};

export default getByteArrayFromAdding;
