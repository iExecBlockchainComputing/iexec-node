import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import allActions from '../../actions';
import './Address.css';

class Address extends Component {
  state = {
    redirect: false,
  };

  submitGenerator = (e) => {
    e.preventDefault();
    this.setState({ redirect: true });
  };

  render() {
    const { redirect } = this.state;
    const { letters } = this.props;

    return (
      <div className="address">
        { letters === '' && <Redirect to="/" /> }
        <div className="row main">
          <div className="main-login main-center">
            <form>
              <h5>Generate your key in the Browser</h5>
              <div className="form-group">
                <button
                  id="button"
                  className="btn btn-primary btn-lg btn-block login-button"
                  onClick={this.submitGenerator}
                >
                  Generate Public and Private Key
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
  letters: PropTypes.string.isRequired,
};

const mapStateToProps = ({ letters }) => ({
  letters,
});

const mapDispatchToProps = dispatch => ({
  actions: {
    address: bindActionCreators(allActions.address, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Address);
