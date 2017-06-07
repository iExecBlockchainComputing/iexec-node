import { combineReducers } from 'redux';
import letters from './letters';
import address from './address';

const vanityGen = combineReducers({
  letters,
  address,
});

export default vanityGen;
