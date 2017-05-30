import BigInteger from './biginteger';

const B58 = {
  alphabet: '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz',
  validRegex: /^[1-9A-HJ-NP-Za-km-z]+$/,
  base: BigInteger.valueOf(58),
};

const Base58 = {
  encode(input) {
    let bi = BigInteger.fromByteArrayUnsigned(input);
    const chars = [];

    while (bi.compareTo(B58.base) >= 0) {
      const mod = bi.mod(B58.base);
      chars.unshift(B58.alphabet[mod.intValue()]);
      bi = bi.subtract(mod).divide(B58.base);
    }
    chars.unshift(B58.alphabet[bi.intValue()]);

    // Convert leading zeros too.
    for (let i = 0; i < input.length; i += 1) {
      if (input[i] === 0x00) {
        chars.unshift(B58.alphabet[0]);
      } else break;
    }

    return chars.join('');
  },

  decode(input) {
    let bi = BigInteger.valueOf(0);
    let leadingZerosNum = 0;
    for (let i = input.length - 1; i >= 0; i -= 1) {
      const alphaIndex = B58.alphabet.indexOf(input[i]);
      if (alphaIndex < 0) return 'Invalid character';
      bi = bi.add(BigInteger.valueOf(alphaIndex).multiply(B58.base.pow(input.length - 1 - i)));

      // This counts leading zero bytes
      if (input[i] === '1') leadingZerosNum += 1;
      else leadingZerosNum = 0;
    }
    const bytes = bi.toByteArrayUnsigned();

    // eslint-disable-next-line
    while ((leadingZerosNum -= 1 > 0)) {
      bytes.unshift(0);
    }
    return bytes;
  },
};

export default Base58;
