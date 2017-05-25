import { combineReducers } from 'redux';
import email from './email';
import letters from './letters';
import address from './address';

const vanityGen = combineReducers({
  email,
  letters,
  address,
});

export default vanityGen;
