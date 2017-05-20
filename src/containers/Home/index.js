import React, { Component } from 'react';
import { connect } from 'react-redux';
// import { bindActionCreators } from 'redux';

export class Home extends Component {
  state = {};

  render() {
    return (
      <div>
        Home page
      </div>
    );
  }
}

const mapStateToProps = () => ({});

const mapDispatchToProps = () => ({});

export default connect(mapStateToProps, mapDispatchToProps)(Home);
