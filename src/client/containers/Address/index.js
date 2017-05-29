import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import allActions from '../../actions';
import Input from '../../components/Input';
import * as regex from '../../constants/regex';
import './Address.css';

class Address extends Component {
  state = {
    userPublicKey: '',
    redirect: false,
  };

  handleChange = e => this.setState({ userPublicKey: e.target.value });

  submit = (e) => {
    e.preventDefault();

    const { actions } = this.props;
    const { userPublicKey } = this.state;

    if (regex.userPublicKey(userPublicKey)) {
      actions.address.setUserPublicKey(userPublicKey);
      this.setState({ redirect: true });
    }
  };

  submitGenerator = (e) => {
    e.preventDefault();
    this.setState({ redirect: true });
  };

  render() {
    const { userPublicKey, redirect } = this.state;

    return (
      <div className="address">
        <div className="row main">
          <div className="main-login main-center">
            <form>
              <h5>Generate your key in the Brother</h5>
              <div className="form-group">
                <button
                  id="button"
                  className="btn btn-primary btn-lg btn-block login-button"
                  onClick={this.submitGenerator}
                >
                  Generate Public Key
                </button>
                {redirect && <Redirect to="/run" />}
              </div>
            </form>
          </div>
        </div>
        <div className="main-login main-center or">
          OR
        </div>
        <div className="row main">
          <div className="main-login main-center">
            <form>
              <Input
                placeholder="Uncompressed Public Key (130 characters)"
                label="Enter your Public Key"
                type="text"
                logo="fa fa-lock fa-lg"
                length={130}
                value={userPublicKey}
                onChange={this.handleChange}
              />
              <div className="form-group">
                <button
                  id="button"
                  className="btn btn-primary btn-lg btn-block login-button"
                  onClick={this.submit}
                >
                  Generate Vanity Address
                </button>
                {redirect && <Redirect to="/run" />}
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }
}

Address.propTypes = {
  actions: PropTypes.object.isRequired,
};

const mapStateToProps = () => ({});

const mapDispatchToProps = dispatch => ({
  actions: {
    address: bindActionCreators(allActions.address, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Address);
