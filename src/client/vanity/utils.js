/* global Address Util */

export const getBitcoinAddressFromByteArray = (pubKeyByteArray) => {
  const pubKeyHash = Util.sha256ripe160(pubKeyByteArray);
  const addr = new Address(pubKeyHash);
  return addr.toString();
};

export const getHexFromByteArray = pubKeyByteArray =>
(Crypto.util.bytesToHex(pubKeyByteArray).toString().toUpperCase());
