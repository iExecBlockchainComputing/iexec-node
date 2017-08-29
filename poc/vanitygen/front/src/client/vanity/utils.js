/* global Address Util */

export const getBitcoinAddressFromByteArray = (pubKeyByteArray) => {
  const pubKeyHash = Util.sha256ripe160(pubKeyByteArray);
  const addr = new Address(pubKeyHash);
  return addr.toString();
};

export const getHexFromByteArray = pubKeyByteArray =>
(Crypto.util.bytesToHex(pubKeyByteArray).toString().toUpperCase());


export const getSmartContractAddressByJsonNetworks = (networks) => {
  let address = '';
  //  local network
  if (Object.prototype.hasOwnProperty.call(networks, '42')) {
    address = networks['42'].address;
    console.log('networks[42].address => local network');
    console.log(networks['42'].address);
  }
  //  ropsten > local network
  if (Object.prototype.hasOwnProperty.call(networks, '3')) {
    address = networks['3'].address;
    console.log('networks[3].address  => ropsten');
    console.log(networks['3'].address);
  }
  //  mainnet > ropsten > local network
  if (Object.prototype.hasOwnProperty.call(networks, '1')) {
    address = networks['1'].address;
    console.log('networks[1].address found => main net ');
    console.log(networks['1'].address);
  }
  console.log('getSmartContractAddressByJsonNetworks : Address is set to :');
  console.log(address);
  return address.toString();
};
