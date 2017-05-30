// https://raw.github.com/bitcoinjs/bitcoinjs-lib/09e8c6e184d6501a0c2c59d73ca64db5c0d3eb95/src/address.js
const Address = function (bytes) {
  console.log('1.0');
  if (typeof bytes === 'string') {
    bytes = Address.decodeString(bytes);
  }
  this.hash = bytes;
  this.version = Address.networkVersion;
};

Address.networkVersion = 0x00; // mainnet

/**
* Serialize this object as a standard Bitcoin address.
*
* Returns the address as a base58-encoded string in the standardized format.
*/
Address.prototype.toString = function () {
  console.log('1.1');
  // Get a copy of the hash
  const hash = this.hash.slice(0);

  // Version
  hash.unshift(this.version);
  const checksum = Crypto.SHA256(Crypto.SHA256(hash, { asBytes: true }), { asBytes: true });
  const bytes = hash.concat(checksum.slice(0, 4));
  return Base58.encode(bytes);
};

Address.prototype.getHashBase64 = function () {
  console.log('1.2');
  return Crypto.util.bytesToBase64(this.hash);
};

/**
* Parse a Bitcoin address contained in a string.
*/
Address.decodeString = function (string) {
  console.log('1.3');

  const bytes = Base58.decode(string);
  const hash = bytes.slice(0, 21);
  const checksum = Crypto.SHA256(Crypto.SHA256(hash, { asBytes: true }), { asBytes: true });

  if (
    checksum[0] != bytes[21] ||
    checksum[1] != bytes[22] ||
    checksum[2] != bytes[23] ||
    checksum[3] != bytes[24]
  ) {
    throw 'Checksum validation failed!';
  }

  const version = hash.shift();

  if (version != 0) {
    throw `Version ${version} not supported!`;
  }

  return hash;
};
