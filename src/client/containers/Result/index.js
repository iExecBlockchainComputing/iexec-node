import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import allActions from '../../actions';

import './Result.css';

class Result extends Component {
  state = {};


  render() {
    const { address } = this.props;
    const { email } = this.props;

    return (
      <div className="address">
        { email === '' && <Redirect to="/" /> }
        <div className="row main">
          <div className="main-login main-center">
            <form>
              <div className="form-group marg">
                <h4>Vanity Bitcoin Address:</h4>
                <p>{address.bitcoinAddress}</p>
              </div>
              <div className="form-group marg">
                <h4>Vanity Private Key (HEX):</h4>
                <span>{address.privateKeyWif}</span>
              </div>
              <div className="form-group marg">
                <h4>Vanity Private Key (WIF):</h4>
                <p className="wif">{address.publicKeyHex}</p>
              </div>
              <div className="form-group">
                <button
                  id="button"
                  className="btn btn-primary btn-lg btn-block login-button"
                  onClick={() => window.print()}
                >
                  Print
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }
}

Result.propTypes = {
  // actions: PropTypes.object.isRequired,
  address: PropTypes.object.isRequired,
  email: PropTypes.string,
};

Result.defaultProps = {
  email: '',
};

const mapStateToProps = ({ address, email }) => ({
  address,
  email,
});

const mapDispatchToProps = dispatch => ({
  actions: {
    address: bindActionCreators(allActions.address, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Result);
