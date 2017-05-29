import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
// import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import allActions from '../../actions';

import './Result.css';

class Result extends Component {
  state = {};

  render() {
    const { address } = this.props;

    return (
      <div className="address">
        <div className="row main">
          <div className="main-login main-center">
            <form>
              <div className="form-group">
                <h4>Vanity Bitcoin Address:</h4>
                <p>{address.bitcoinAddress}</p>
              </div>
              <div className="form-group">
                <h4>Vanity Public Key (HEX):</h4>
                <span>{address.privateKeyWif}</span>
              </div>
              <div className="form-group">
                <h4>Vanity Private Key (WIF):</h4>
                <span>{address.publicKeyHex}</span>
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
};

const mapStateToProps = ({ address }) => ({
  address,
});

const mapDispatchToProps = dispatch => ({
  actions: {
    address: bindActionCreators(allActions.address, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Result);
