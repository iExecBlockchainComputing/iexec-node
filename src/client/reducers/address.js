import {
  SET_USER_PUBLIC_KEY,
  GENERATE_BITCOIN_ADDRESS,
  GET_ECKEY,
  GET_ARRAY,
} from '../actions/address';

export default (state = {}, action) => {
  switch (action.type) {
    case SET_USER_PUBLIC_KEY:
      return { ...state, userPublicKey: action.payload.userPublicKey };
    case GENERATE_BITCOIN_ADDRESS:
      return {
        ...state,
        publicKey: action.payload.publicKey,
        privateKey: action.payload.privateKey,
      };
    case GET_ECKEY:
      return {
        ...state,
        bitcoinAddress: action.payload.bitcoinAddress,
        privateKeyWif: action.payload.privateKeyWif,
        publicKeyHex: action.payload.publicKeyHex,
      };
    case GET_ARRAY:
      return {
        ...state,
        bitcoin: action.payload,
      };
    default:
      return state;
  }
};
