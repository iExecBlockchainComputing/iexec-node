import ECKey from './ECKey';

const generateKeyPair = () => {
  const key = new ECKey(false);
  const publicKey = key.getPubKeyHex();
  const privateKey = key.getBitcoinHexFormat;
  console.log('------- generateKeyPair() --------');
  console.log(`key ${key}`);
  console.log(`publickey ${publicKey}`);
  console.log(`privatekey ${privateKey}`);
};

export default { generateKeyPair };
