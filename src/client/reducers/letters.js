import { SET_LETTERS } from '../actions/letters';

export default (state = '', action) => {
  switch (action.type) {
    case SET_LETTERS:
      return action.payload.letters;
    default:
      return state;
  }
};
