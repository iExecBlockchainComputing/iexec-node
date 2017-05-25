import { SET_EMAIL } from '../actions/email';

export default (state = '', action) => {
  switch (action.type) {
    case SET_EMAIL:
      return action.payload.email;
    default:
      return state;
  }
};
