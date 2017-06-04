/* global bitcoin ECKey */

import getECKeyFromAdding from '../vanity/vanity';
import getByteArrayFromAdding from '../vanity/vanityPublicPrivate';
import { getBitcoinAddressFromByteArray, getHexFromByteArray } from '../vanity/utils';
import generateVanity from '../vanity/generateVanity';

export const SET_USER_PUBLIC_KEY = 'SET_USER_PUBLIC_KEY';
export const GENERATE_BITCOIN_ADDRESS = 'GENERATE_BITCOIN_ADDRESS';
export const GET_ECKEY = 'GET_ECKEY';
export const LOAD = 'LOAD';

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

export const vanityGen = payload => ({
  type: LOAD,
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
  const eck = new ECKey(input2KeyString).getPubKeyHex();
  const pubKeyCombined = getByteArrayFromAdding(input1KeyString, eck);
  const key = {
    bitcoinAddress: getBitcoinAddressFromByteArray(pubKeyCombined),
    privateKeyWif: 'Only available when combining two private keys',
    publicKeyHex: getHexFromByteArray(pubKeyCombined),
  };
  dispatch(eckey(key));
};

export const vanity = (letter, pubkey) => (dispatch) => {
  generateVanity(letter, pubkey);
  dispatch(vanityGen(true));
};
