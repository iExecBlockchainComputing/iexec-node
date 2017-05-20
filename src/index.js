import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import registerServiceWorker from './registerServiceWorker';
import Home from './containers/Home';
import generateStore from './generateStore';
import './styles/index.css';

const store = generateStore(process.env.NODE_ENV);

render((
  <Provider store={store}>
    <Router>
      <div>
        <Route exact path="/" component={Home} />
      </div>
    </Router>
  </Provider>
), document.getElementById('root'));

registerServiceWorker();
