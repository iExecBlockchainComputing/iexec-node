// https://raw.github.com/bitcoinjs/bitcoinjs-lib/c952aaeb3ee472e3776655b8ea07299ebed702c7/src/base58.js
(function () {
  Base58 = {
    alphabet: '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz',
    validRegex: /^[1-9A-HJ-NP-Za-km-z]+$/,
    base: BigInteger.valueOf(58),

    encode(input) {
      console.log('2.1');
      let bi = BigInteger.fromByteArrayUnsigned(input);
      const chars = [];

      while (bi.compareTo(B58.base) >= 0) {
        const mod = bi.mod(B58.base);
        chars.unshift(B58.alphabet[mod.intValue()]);
        bi = bi.subtract(mod).divide(B58.base);
      }
      chars.unshift(B58.alphabet[bi.intValue()]);

      // Convert leading zeros too.
      for (let i = 0; i < input.length; i++) {
        if (input[i] == 0x00) {
          chars.unshift(B58.alphabet[0]);
        } else break;
      }

      return chars.join('');
    },

    /**
		* Convert a base58-encoded string to a byte array.
		*
		* Written by Mike Hearn for BitcoinJ.
		*   Copyright (c) 2011 Google Inc.
		*
		* Ported to JavaScript by Stefan Thomas.
		*/
    decode(input) {
      console.log('2.2');

      let bi = BigInteger.valueOf(0);
      let leadingZerosNum = 0;
      for (let i = input.length - 1; i >= 0; i--) {
        const alphaIndex = B58.alphabet.indexOf(input[i]);
        if (alphaIndex < 0) {
          throw 'Invalid character';
        }
        bi = bi.add(BigInteger.valueOf(alphaIndex).multiply(B58.base.pow(input.length - 1 - i)));

        // This counts leading zero bytes
        if (input[i] == '1') leadingZerosNum++;
        else leadingZerosNum = 0;
      }
      const bytes = bi.toByteArrayUnsigned();

      // Add leading zeros
      while (leadingZerosNum-- > 0) {
        bytes.unshift(0);
      }

      return bytes;
    },
  };

  var B58 = Base58;
}());
