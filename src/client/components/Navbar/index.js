import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import allActions from '../../actions';
import getRlc from '../../vanity/getRlc';
import './Navbar.css';

class Navbar extends Component {
  getRlc = () => {
    const { actions } = this.props;
    getRlc();
    actions.rlc.setNewRlc();
  };

  render() {
    const { rlc } = this.props;
    return (
      <div className="container-fluid">
        <nav className="navbar navbar-default">
          <div className="container">
            <div className="navbar-header">
              <button
                type="button"
                className="navbar-toggle collapsed"
                data-toggle="collapse"
                data-target="#navbar-collapse-1"
              >
                <span className="sr-only" />
                <span className="icon-bar" />
                <span className="icon-bar" />
                <span className="icon-bar" />
              </button>
              <a className="navbar-brand" href="/">VanityGen</a>
            </div>

            <div className="collapse navbar-collapse" id="navbar-collapse-1">
              <ul className="nav navbar-nav navbar-right">
                <li>
                  <a className="navbar-brand">{rlc} RLC</a>
                </li>
                <li>
                  <button
                    type="button"
                    className="btn btn-primary"
                    style={{ backgroundColor: 'rgb(36, 85, 128)', borderColor: 'rgb(36, 85, 128)' }}
                    onClick={() => this.getRlc()}
                  >
                    GET RLC
                  </button>
                </li>
              </ul>
            </div>
          </div>
        </nav>
      </div>
    );
  }
}

Navbar.propTypes = {
  rlc: PropTypes.number.isRequired,
  actions: PropTypes.object.isRequired,
};

const mapStateToProps = ({ rlc }) => ({
  rlc,
});

const mapDispatchToProps = dispatch => ({
  actions: {
    rlc: bindActionCreators(allActions.rlc, dispatch),
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(Navbar);
