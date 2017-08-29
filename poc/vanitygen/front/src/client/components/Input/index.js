import React from 'react';
import PropTypes from 'prop-types';
import './Input.css';

const Input = ({ placeholder, label, type, logo, length, onChange, value }) => (
  <div className="form-group">
    <label htmlFor={label} className="cols-sm-2 control-label">{label}</label>
    <div className="cols-sm-10">
      <div className="input-group">
        <span className="input-group-addon"><i className={logo} aria-hidden="true" /></span>
        <input
          id={label}
          type={type}
          className="form-control"
          name="name"
          placeholder={placeholder}
          maxLength={length}
          onChange={onChange}
          value={value}
        />
      </div>
    </div>
  </div>
);

Input.propTypes = {
  placeholder: PropTypes.string.isRequired,
  label: PropTypes.string.isRequired,
  type: PropTypes.string.isRequired,
  logo: PropTypes.string.isRequired,
  length: PropTypes.number,
  onChange: PropTypes.func,
  value: PropTypes.string,
};

Input.defaultProps = {
  length: 99,
  onChange: () => {},
  value: '',
};

export default Input;
