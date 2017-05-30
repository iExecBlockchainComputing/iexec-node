/* global bitcoin ECKey*/

import getECKeyFromAdding from '../vanity/vanity';
import getByteArrayFromAdding from '../vanity/vanityPublicPrivate';

export const SET_USER_PUBLIC_KEY = 'SET_USER_PUBLIC_KEY';
export const GENERATE_BITCOIN_ADDRESS = 'GENERATE_BITCOIN_ADDRESS';
export const GET_ECKEY = 'GET_ECKEY';
export const GET_ARRAY = 'GET_ARRAY';

export const setUserPublicKey = userPublicKey => ({
  type: SET_USER_PUBLIC_KEY,
  payload: {
    userPublicKey,
  },
});

export const GenerateBitcoinAdress = payload => ({
  type: GENERATE_BITCOIN_ADDRESS,
  payload,
});

export const eckey = payload => ({
  type: GET_ECKEY,
  payload,
});

export const getArray = payload => ({
  type: GET_ARRAY,
  payload,
});

export const generateBitcoinAdress = () => (dispatch) => {
  const keyPair = bitcoin.ECPair.makeRandom({ compressed: false });
  const addr = {
    publicKey: keyPair.getPublicKeyBuffer().toString('hex'),
    privateKey: keyPair.toWIF(),
  };
  dispatch(GenerateBitcoinAdress(addr));
  return addr;
};

export const getECKey = (privKey1, privKey2) => (dispatch) => {
  const combinedPrivateKey = getECKeyFromAdding(privKey1, privKey2);
  const key = {
    bitcoinAddress: combinedPrivateKey.getBitcoinAddress(),
    privateKeyWif: combinedPrivateKey.getBitcoinWalletImportFormat(),
    publicKeyHex: combinedPrivateKey.getPubKeyHex(),
  };
  dispatch(eckey(key));
};

export const getByteArray = (input1KeyString, input2KeyString) => (dispatch) => {
  const pubKeyCombined = getByteArrayFromAdding(input1KeyString, ECKey(input2KeyString));
  dispatch(getArray(pubKeyCombined));
  console.log(pubKeyCombined);
};
