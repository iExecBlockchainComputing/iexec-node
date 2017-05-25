import { SET_USER_PUBLIC_KEY } from '../actions/address';

export default (state = '', action) => {
  switch (action.type) {
    case SET_USER_PUBLIC_KEY:
      return { ...state, userPublicKey: action.payload.userPublicKey };
    default:
      return state;
  }
};
