/* global web3 */
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import Web3 from 'web3';
import allActions from '../../actions';
import Input from '../../components/Input';
import * as regex from '../../constants/regex';
import './Home.css';
import Vanity from '../../../build/contracts/VanityGen.json';

class Home extends Component {
  state = {
    address: 'LoBRx5td5344njzVPAVBqR8WQfVTsGwYQ',
    letters: '',
    redirect: false,
  };

  componentWillMount() {
    let provider = null;

    if (typeof web3 !== 'undefined') provider = new Web3(window.web3.currentProvider);
    else provider = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

    const vanityContract = web3.eth.contract(Vanity.abi);
    const VanityInstance = vanityContract.at('0x8099be7909174ed81980e21bedded95c2f987c0f');

    provider.eth.getAccounts((error, accounts) => {
      console.log(accounts);
      const myEvent = VanityInstance.Logs({ user: web3.eth.accounts[0] });
      myEvent.watch((err, result) => {
        if (err) {
          console.log('Erreur event ', err);
          return;
        } else if (result.args.status === 'Task finish!') {
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
      });
    });
  }

  handleChangeLetters = (e) => {
    const addr = 'LoBRx5td5344njzVPAVBqR8WQfVTsGwYQ';

    this.setState({
      letters: e.target.value,
      address: addr.substr(this.state.letters.length),
      email: '',
    });
  };

  handleChangeEmail = e => this.setState({ email: e.target.value });

  submit = (e) => {
    e.preventDefault();

    const { actions } = this.props;
    const { email, letters } = this.state;

    if (letters.length && regex.email(email)) {
      actions.email.setEmail(email);
      actions.letters.setLetters(letters);
      this.setState({ redirect: true });
    }
  };

  render() {
    const { address, letters, email, redirect } = this.state;

    return (
      <div className="home">
        <div className="row main">
          <div className="main-login main-center">
            <form>
              <Input
                placeholder="ex: 'Love' 6 letters max."
                label="Choose your letters"
                type="text"
                logo="fa fa-lock fa-lg"
                length={6}
                value={letters}
                onChange={this.handleChangeLetters}
              />
              <h5 className="title-addr">Example address:</h5>
              <div className="addr">
                1<span className="color">{letters}</span>{address}
              </div>
              <Input
                placeholder="Enter your Email"
                label="Your Email"
                type="email"
                logo="fa fa-envelope fa"
                value={email}
                onChange={this.handleChangeEmail}
              />
              <div className="form-group">
                <button
                  id="button"
                  className="btn btn-primary btn-lg btn-block login-button"
                  onClick={this.submit}
                >
                  Next Step
                </button>
                {redirect && <Redirect to="/address" />}
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }
}

Home.propTypes = {
  actions: PropTypes.object.isRequired,
};

const mapStateToProps = () => ({});

const mapDispatchToProps = dispatch => ({
  actions: {
    email: bindActionCreators(allActions.email, dispatch),
    letters: bindActionCreators(allActions.letters, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Home);
