import { SET_LETTERS } from './redux';

const setLetters = letters => ({
  type: SET_LETTERS,
  payload: {
    letters,
  },
});

export default setLetters;
