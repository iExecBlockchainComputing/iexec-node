import React from 'react';
import './Navbar.css';

const Navbar = () => (
  <div className="container-fluid">
    <nav className="navbar navbar-default">
      <div className="container">
        <div className="navbar-header">
          <button type="button" className="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse-1">
            <span className="sr-only" />
            <span className="icon-bar" />
            <span className="icon-bar" />
            <span className="icon-bar" />
          </button>
          <a className="navbar-brand" href="">VanityGen</a>
        </div>

        <div className="collapse navbar-collapse" id="navbar-collapse-1">
          <ul className="nav navbar-nav navbar-right">
            <li><a>Home</a></li>
            <li><a>500 RLC</a></li>
          </ul>
        </div>
      </div>
    </nav>
  </div>
);

export default Navbar;
