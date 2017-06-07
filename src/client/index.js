import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import registerServiceWorker from './registerServiceWorker';
import Home from './containers/Home';
import Address from './containers/Address';
import Run from './containers/Run';
import Result from './containers/Result';
import generateStore from './generateStore';
import './styles/index.css';
import Navbar from './components/Navbar';
import Footer from './components/Footer';

const store = generateStore(process.env.NODE_ENV);

render(
  <Provider store={store}>
    <div>
      <Navbar />
      <Router>
        <div>
          <Route exact path="/" component={Home} />
          <Route path="/address" component={Address} />
          <Route path="/run" component={Run} />
          <Route path="/result" component={Result} />
        </div>
      </Router>
      <Footer />
    </div>
  </Provider>,
  document.getElementById('root'),
);

registerServiceWorker();
