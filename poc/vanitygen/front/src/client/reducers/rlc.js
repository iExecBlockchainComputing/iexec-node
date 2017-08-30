import { SET_RLC } from '../actions/redux';

export default (state = '', action) => {
  switch (action.type) {
    case SET_RLC:
      return action.payload;
    default:
      return state;
  }
};
