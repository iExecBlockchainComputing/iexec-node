import { combineReducers } from 'redux';
import letters from './letters';
import address from './address';
import rlc from './rlc';

const vanityGen = combineReducers({
  letters,
  address,
  rlc,
});

export default vanityGen;
