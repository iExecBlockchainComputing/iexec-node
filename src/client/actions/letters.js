export const SET_LETTERS = 'SET_LETTERS';

export const setLetters = letters => ({
  type: SET_LETTERS,
  payload: {
    letters,
  },
});
