import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import allActions from '../../actions';

import './Run.css';

class Run extends Component {
  state = {
    phase1: 'fa fa-refresh fa-spin fa-2x',
    phase2: 'fa fa-times fa-2x',
    phase3: 'fa fa-times fa-2x',
    phase4: 'fa fa-times fa-2x',
    addr: {},
    getResult: false,
    redirect: false,
  };

  componentDidMount() {
    this.generateAddr();
  }

  getResult() {
    return (
      <div className="form-group">
        <button
          id="button"
          className="btn btn-primary btn-lg btn-block login-button"
          onClick={(e) => {
            e.preventDefault();
            this.setState({ redirect: true });
          }}
        >
          Get result
        </button>
      </div>
    );
  }

  generateAddr() {
    const { address, actions } = this.props;
    let addr = {};
    if (!address.userPublicKey) {
      addr = actions.address.generateBitcoinAdress();
      console.log(addr);
    } else {
      addr.userAddr = address.userPublicKey;
    }
    // recuperer public et privateKey
    this.setState({ phase1: 'fa fa-check fa-2x', phase2: 'fa fa-refresh fa-spin fa-2x', addr });
    this.vanityWallet();
  }

  // calculatePrivatePart() {
  //   //call actions qui call web3 qui call vanitygen et return privatePart
  //  this.setState({ phase1: 'fa fa-check fa-2x', phase2: 'fa fa-refresh fa-spin fa-2x', addr });
  //  vanityWallet();
  // }

  vanityWallet() {
    const { actions, address } = this.props;
    const { addr } = this.state;

    if (address.userPublicKey) {
      actions.address.getByteArray(
        addr.userPublicKey,
        'C206014862AAE70B12E9842988C1D8575092A70756A1EA84F291836D6B903DC5',
      );
    } else {
      actions.address.getECKey(
        addr.privateKey,
        'C206014862AAE70B12E9842988C1D8575092A70756A1EA84F291836D6B903DC5',
      );
    }
    this.setState({ phase4: 'fa fa-check fa-2x', getResult: true });
  }

  render() {
    const { phase1, phase2, phase3, phase4, getResult, redirect } = this.state;

    return (
      <div className="address">
        <div className="row main">
          <div className="main-login main-center">
            <form className="form">
              <span className="inline-content">
                <i className={phase1} />
                <h5>Generate your key in the Brother</h5>
              </span>
              <span className="inline-content">
                <i className={phase2} aria-hidden="true" />
                <h5>Generate your key in the Brother</h5>
              </span>
              <span className="inline-content">
                <i className={phase3} aria-hidden="true" />
                <h5>Calculate Private Key Part</h5>
              </span>
              <span className="inline-content">
                <i className={phase4} aria-hidden="true" />
                <h5>Calculate Vanity Wallet</h5>
              </span>
              {getResult && this.getResult()}
              {redirect && <Redirect to="/result" />}
            </form>
          </div>
        </div>
      </div>
    );
  }
}

Run.propTypes = {
  actions: PropTypes.object.isRequired,
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

export default connect(mapStateToProps, mapDispatchToProps)(Run);
