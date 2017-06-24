import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import './Install.css';

class Install extends Component {

  state = {
    redirect: false,
  }

  render() {
    return (
      <div className="modal-dialog" style={{ marginTop: '110px' }}>
        <div className="modal-content">
          <div className="modal-header" style={{ textAlign: 'center' }}>
            <h4 className="modal-title">No providers detected</h4>
          </div>
          <div className="modal-body">
            <p>
              To be able to use our services please use the
              <a
                href="https://www.google.com/chrome/browser/desktop/"
                target="_blank"
                rel="noopener noreferrer"
              > Chrome browser </a>
              and installed the
              <a
                href="https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=en"
                target="_blank"
                rel="noopener noreferrer"
              > METAMASK </a>
              extension.
            </p>
            <p>
              After installation, please create an ethereum account,
              connect this to metamask and refresh the page.
            </p>
          </div>
          <div className="modal-footer">
            <div className="btn-group">
              <button className="btn btn-primary"><Link to="/">Home</Link></button>
            </div>
            <div className="btn-group">
              <a
                href="https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=en"
                target="_blank"
                rel="noopener noreferrer"
              >
                <button className="btn btn-primary">Download</button>
              </a>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default Install;
