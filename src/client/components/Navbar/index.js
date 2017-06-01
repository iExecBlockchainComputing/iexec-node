/* global Faucet */
import React, { Component } from 'react';
import './Navbar.css';

class Navbar extends Component {
  getRlc = () => {
    Faucet.deployed().then((instance) => {
      instance
        .gimmeFive({ gas: 200000 })
        .then((result) => {
          console.log(`result faucet = ${result}`);
        })
        .catch((e) => {
          console.log(`e ${e}`);
        });
    });
  };

  render() {
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
                  <button
                    type="button"
                    className="btn btn-primary"
                    style={{ backgroundColor: 'rgb(36, 85, 128)', borderColor: 'rgb(36, 85, 128)' }}
                    onClick={this.getRlc()}
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

export default Navbar;
