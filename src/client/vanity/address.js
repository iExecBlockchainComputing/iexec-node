import Base58 from './base58';

const Address = (byte) => {
  let bytes = byte;
  if (typeof bytes === 'string') {
    bytes = Address.decodeString(bytes);
  }
  this.hash = bytes;
  this.version = Address.networkVersion;
};

Address.networkVersion = 0x00; // mainnet

Address.prototype.toString = () => {
  // Get a copy of the hash
  const hash = this.hash.slice(0);

  // Version
  hash.unshift(this.version);
  const checksum = Crypto.SHA256(Crypto.SHA256(hash, { asBytes: true }), { asBytes: true });
  const bytes = hash.concat(checksum.slice(0, 4));
  return Base58.encode(bytes);
};

Address.prototype.getHashBase64 = () => Crypto.util.bytesToBase64(this.hash);

/**
* Parse a Bitcoin address contained in a string.
*/
Address.decodeString = (string) => {
  const bytes = Base58.decode(string);
  const hash = bytes.slice(0, 21);
  const checksum = Crypto.SHA256(Crypto.SHA256(hash, { asBytes: true }), { asBytes: true });

  if (
    checksum[0] !== bytes[21] ||
    checksum[1] !== bytes[22] ||
    checksum[2] !== bytes[23] ||
    checksum[3] !== bytes[24]
  ) {
    return 'Checksum validation failed!';
  }

  const version = hash.shift();

  if (version !== 0) return `Version ${version} not supported!`;

  return hash;
};

export default Address;
