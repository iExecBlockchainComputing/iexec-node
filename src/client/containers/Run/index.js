/* global web3 */
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import allActions from '../../actions';
import Vanity from '../../../build/contracts/VanityGen.json';
import './Run.css';

class Run extends Component {

  state = {
    phase1: 'fa fa-refresh fa-spin fa-2x',
    phase2: 'fa fa-times fa-2x',
    phase3: 'fa fa-times fa-2x',
    phase4: 'fa fa-times fa-2x',
    phase5: 'fa fa-times fa-2x',
    phase6: 'fa fa-times fa-2x',
    addr: {},
    getResult: false,
    redirect: false,
    privKey: '',
    event: false,
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

  event() {
    const vanityContract = web3.eth.contract(Vanity.abi);
    const VanityInstance = vanityContract.at('0x8099be7909174ed81980e21bedded95c2f987c0f');

    VanityInstance.Logs({ user: web3.eth.accounts[0] }, (err, result) => {
      if (err) {
        this.setState({ redirect: true });
      } else if (result.args.status === 'Task finish!') {
        this.setState({ phase3: 'fa fa-check fa-2x', phase4: 'fa fa-refresh fa-spin fa-2x' });
        this.vanityWallet();
      } else if (result.args.status === 'Invalid') {
        this.setState({ redirect: true });
      } else if (result.args.status === 'Erreur') {
        this.setState({ redirect: true });
      } else if (result.args.status === 'Running') {
        console.log(result.args.status);
      } else {
        console.log(`http://xw.iex.ec/xwdbviews/works.html?sSearch=${result.args.status}`);
      }
    });
  }

  generateAddr() {
    const { actions } = this.props;
    let addr = {};

    addr = actions.address.generateBitcoinAdress();
    this.setState({ phase1: 'fa fa-check fa-2x', phase2: 'fa fa-refresh fa-spin fa-2x', addr });
    this.calculatePrivatePart(addr);
  }

  calculatePrivatePart(addr) {
    const { actions, letters } = this.props;
    actions.address.vanity(letters, addr.publicKey);
    this.setState({ phase2: 'fa fa-check fa-2x', phase3: 'fa fa-refresh fa-spin fa-2x' });
    this.event();
  }

  vanityWallet() {
    const { actions } = this.props;
    const { addr } = this.state;

    this.setState({ phase4: 'fa fa-check fa-2x', phase5: 'fa fa-refresh fa-spin fa-2x' });

    const vanityContract = web3.eth.contract(Vanity.abi);
    const VanityInstance = vanityContract.at('0x8099be7909174ed81980e21bedded95c2f987c0f');

    VanityInstance.getResult((err, result) => {
      if (err) this.setState({ redirect: true });
      // eslint-disable-next-line
      const url = /,\S*/i;
      const myurl = url.exec(result);
      myurl.toString().replace(',', 'http://xw.iex.ec/xwdbviews/works.html?sSearch=');
     // eslint-disable-next-line
      const rez = /[^PrivkeyPart: ]([\w\d]+?)+/g;
      const privKey = rez.exec(result[0]);
      this.setState({ phase5: 'fa fa-check fa-2x', phase6: 'fa fa-refresh fa-spin fa-2x' });
      actions.address.getECKey(
        addr.privateKey,
        privKey[0],
      );
      this.setState({ phase6: 'fa fa-check fa-2x', getResult: true });
    });
  }

  render() {
    const { phase1, phase2, phase3, phase4, phase5, phase6, getResult, redirect } = this.state;
    const { letters } = this.props;

    return (
      <div className="address">
        { letters === '' && <Redirect to="/" /> }
        <div className="row main">
          <div className="main-login main-center padd">
            <form className="form">
              <span className="inline-content">
                <i className={phase1} />
                <h5>Generate your key in the Browser</h5>
              </span>
              <span className="inline-content">
                <i className={phase2} aria-hidden="true" />
                <h5>Call xTremWeb</h5>
              </span>
              <span className="inline-content">
                <i className={phase3} aria-hidden="true" />
                <h5>Task running</h5>
              </span>
              <span className="inline-content">
                <i className={phase4} aria-hidden="true" />
                <h5>Task finish</h5>
              </span>
              <span className="inline-content">
                <i className={phase5} aria-hidden="true" />
                <h5>Receive address and private key</h5>
              </span>
              <span className="inline-content">
                <i className={phase6} aria-hidden="true" />
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
  letters: PropTypes.string,
};

Run.defaultProps = {
  letters: '',
};

const mapStateToProps = ({ letters }) => ({
  letters,
});

const mapDispatchToProps = dispatch => ({
  actions: {
    address: bindActionCreators(allActions.address, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Run);
