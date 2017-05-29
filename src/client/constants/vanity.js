/* global ECKey EllipticCurve */
const getECKeyFromAdding = (privKey1, privKey2) => {
  const n = EllipticCurve.getSECCurveByName('secp256k1').getN();
  const ecKey1 = new ECKey(privKey1);
  const ecKey2 = new ECKey(privKey2);
  // if both keys are the same return null
  if (ecKey1.getBitcoinHexFormat() === ecKey2.getBitcoinHexFormat()) return null;
  if (ecKey1 == null || ecKey2 == null) return null;
  const combinedPrivateKey = new ECKey(ecKey1.priv.add(ecKey2.priv).mod(n));
  // compressed when both keys are compresse
  if (ecKey1.compressed && ecKey2.compressed) combinedPrivateKey.setCompressed(true);
  return combinedPrivateKey;
};

export default getECKeyFromAdding;
// var keyPair2 = bitcoin.ECPair.makeRandom({compressed: false}) -> creer une adresse btc

// console.log(keyPair2.getPublicKeyBuffer().toString('hex').length) ->
// return address a envoyer a web3 (041e65d926f3bc46d403f0ca02bbd6da981730abe78a34e03
// 9dec3b664ab40f93cae5e69fb1dc0e58005cce17c44217534bed81b4849d253cf77ef825c43d9e233)

// keyPair2.toWIF() -> return private key (5JgQ4jQQVRhCnGMKzZ2jmFZMpMYU3BsPgXqLVat6Rpxwo8166nf)

// getECKeyFromAdding(privateKey, retouWeb3)
//
// Puis on extrait les data
// bitcoinAddress = combinedPrivateKey.getBitcoinAddress();
// privateKeyWif = combinedPrivateKey.getBitcoinWalletImportFormat();
// publicKeyHex = combinedPrivateKey.getPubKeyHex();
