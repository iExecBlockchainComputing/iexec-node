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
    addr: {},
    getResult: false,
    redirect: false,
    privKey: '',
    event: false,
  };
  componentDidMount() {
    this.generateAddr();
  }
/* global web3 */
// eslint-disable-next-line
  test() {
    const vanityContract = web3.eth.contract(Vanity.abi);
    console.log(vanityContract);
    console.log(Vanity.abi);
    const VanityInstance = vanityContract.at('0x8099be7909174ed81980e21bedded95c2f987c0f');
    // VanityGen.deployed().then((instance) => {
    console.log(VanityInstance);
    const myEvent = VanityInstance.Logs({ user: web3.eth.accounts[0] }, (err, result) => {
      console.log(result);
      if (err) {
        console.log('Erreur event ', err);
        return;
      } else if (result.args.status === 'Task finish!') {
        this.vanityWallet();
        console.log(result.args.status);
      } else if (result.args.status === 'Invalid') {
        console.log('event invalid');
        console.log(result.args.status);
      } else if (result.args.status === 'Erreur') {
        console.log('event erreur');
        console.log(result.args.status);
      } else if (result.args.status === 'Running') {
        console.log(result.args.status);
      } else {
        console.log(`http://xw.iex.ec/xwdbviews/works.html?sSearch=${result.args.status}`);
        console.log('urllli ', result.args.status);
      }
      console.log('Parse ', result.args.status, result.args.user);
      // console.log("Event = ", JSON.parse(result.args.value));
    });
    // });
    console.log(myEvent);
  }

  // componentDidMount() {
    // this.generateAddr();
  // }

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
    this.calculatePrivatePart(addr);
  }

  calculatePrivatePart(addr) {
    const { actions, letters } = this.props;
    console.log(addr);

    actions.address.vanity(letters, addr.publicKey);
    this.test();
  }

  vanityWallet() {
    const { actions, address } = this.props;
    const { addr } = this.state;
    console.log('VANITY WALLET');
    this.setState({ phase2: 'fa fa-check fa-2x', phase4: 'fa fa-refresh fa-spin fa-2x' });
    const vanityContract = web3.eth.contract(Vanity.abi);
    console.log(vanityContract);
    console.log(Vanity.abi);
    const VanityInstance = vanityContract.at('0x8099be7909174ed81980e21bedded95c2f987c0f');
    VanityInstance.getResult((err, result) => {
      console.log(result);
      if (err) console.log(err);
      // eslint-disable-next-line
      const url = /,\S*/i;
      const myurl = url.exec(result);
      myurl.toString().replace(',', 'http://xw.iex.ec/xwdbviews/works.html?sSearch=');
     // eslint-disable-next-line
       const rez = /PrivkeyPart: (.+?) */g;
      const privKey = rez.exec(result[0]);
      console.log(privKey.$1);
      if (address.userPublicKey) {
        actions.address.getByteArray(
          address.userPublicKey,
          privKey,
        );
      } else {
        actions.address.getECKey(
          addr.privateKey,
          privKey,
        );
      }
      this.setState({ phase4: 'fa fa-check fa-2x', getResult: true });
    });
  }

  render() {
    const { phase1, phase2, phase4, getResult, redirect } = this.state;
    const { email } = this.props;

    return (
      <div className="address">
        { email === '' && <Redirect to="/" /> }
        <div className="row main">
          <div className="main-login main-center padd">
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
  email: PropTypes.string,
  letters: PropTypes.string,
};

Run.defaultProps = {
  email: '',
  letters: '',
};

const mapStateToProps = ({ address, email, letters }) => ({
  address,
  email,
  letters,
});

const mapDispatchToProps = dispatch => ({
  actions: {
    address: bindActionCreators(allActions.address, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Run);
