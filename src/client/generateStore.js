import { createStore, applyMiddleware } from 'redux';
import logger from 'redux-logger';
import thunk from 'redux-thunk';
import reducers from './reducers';

const initalState = {
  letters: '',
  address: {},
  rlc: 0,
};

export default mode => createStore(
  reducers,
  initalState,
  applyMiddleware(
    mode === 'development' ? logger : (0),
    thunk,
  ),
);
