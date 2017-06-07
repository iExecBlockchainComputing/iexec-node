import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import allActions from '../../actions';
import Input from '../../components/Input';
import './Home.css';

class Home extends Component {
  state = {
    address: 'LoBRx5td5344njzVPAVBqR8WQfVTsGwYQ',
    letters: '',
    redirect: false,
  };

  handleChangeLetters = (e) => {
    const addr = 'LoBRx5td5344njzVPAVBqR8WQfVTsGwYQ';

    this.setState({
      letters: e.target.value,
      address: addr.substr(this.state.letters.length),
    });
  };

  submit = (e) => {
    e.preventDefault();

    const { actions } = this.props;
    const { letters } = this.state;

    if (letters.length) {
      actions.letters.setLetters(letters);
      this.setState({ redirect: true });
    }
  };

  render() {
    const { address, letters, redirect } = this.state;

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
    letters: bindActionCreators(allActions.letters, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Home);
