/* global EllipticCurve ECKey */
const getECKeyFromAdding = (privKey1, privKey2) => {
  const n = EllipticCurve.getSECCurveByName('secp256k1').getN();
  const ecKey1 = new ECKey(privKey1);
  const ecKey2 = new ECKey(privKey2);
  // if both keys are the same return null
  if (ecKey1.getBitcoinHexFormat() === ecKey2.getBitcoinHexFormat()) {
    return null;
  }
  if (ecKey1 == null || ecKey2 == null) return null;
  const combinedPrivateKey = new ECKey(ecKey1.priv.add(ecKey2.priv).mod(n));
  // compressed when both keys are compresse
  if (ecKey1.compressed && ecKey2.compressed) {
    combinedPrivateKey.setCompressed(true);
  }
  return combinedPrivateKey;
};

export default getECKeyFromAdding;
