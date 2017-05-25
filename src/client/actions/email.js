export const SET_EMAIL = 'SET_EMAIL';

export const setEmail = email => ({
  type: SET_EMAIL,
  payload: {
    email,
  },
});
