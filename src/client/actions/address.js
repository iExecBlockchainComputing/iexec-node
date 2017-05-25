export const SET_USER_PUBLIC_KEY = 'SET_USER_PUBLIC_KEY';

export const setUserPublicKey = userPublicKey => ({
  type: SET_USER_PUBLIC_KEY,
  payload: {
    userPublicKey,
  },
});
