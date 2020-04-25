// File: LoginButton.js
// Not my code. From Okta docs.
// https://developer.okta.com/blog/2018/07/10/build-a-basic-crud-app-with-node-and-react
//
// --------------------------------------------------------------
// Programmer: Graham Matthews
// Date created: Oct 29 2019
// Last modified: Nov 7 2019

import React, { Component } from 'react';
import {
  IconButton,
  Menu,
  MenuItem,
  ListItemText,
} from '@material-ui/core';
import { AccountCircle } from '@material-ui/icons';
import { withAuth } from '@okta/okta-react';

class LoginButton extends Component {

  checkingAuth = false

  state = {
    authenticated: null,
    user: null,
    menuAnchorEl: null,
  };

  componentDidMount() {
    this.checkAuthentication();
  }

  componentDidUpdate() {
    if (!this.checkingAuth && this.state.user == null) {
      this.checkAuthentication()
    }
  }

  async checkAuthentication() {
    console.log('called checkAuthentication in LoginButton.js')
    this.checkingAuth = true
    const authenticated = await this.props.auth.isAuthenticated();
    if (authenticated !== this.state.authenticated) {
      const user = await this.props.auth.getUser();
      this.setState({ authenticated, user });
    }
    this.checkingAuth = false
  }

  login = () => this.props.auth.login('/');
  logout = () => {
    this.handleMenuClose();
    this.props.auth.logout('/');
  };

  handleMenuOpen = event => this.setState({ menuAnchorEl: event.currentTarget });
  handleMenuClose = () => this.setState({ menuAnchorEl: null });

  render() {
    const { user, menuAnchorEl } = this.state;

    const menuPosition = {
      vertical: 'top',
      horizontal: 'right',
    };

    return (
      <div>
        <IconButton onClick={this.handleMenuOpen} color="inherit">
          <AccountCircle />
        </IconButton>
        <Menu
          anchorEl={menuAnchorEl}
          anchorOrigin={menuPosition}
          transformOrigin={menuPosition}
          open={!!menuAnchorEl}
          onClose={this.handleMenuClose}
        >
          <MenuItem onClick={this.logout}>
            <ListItemText
              primary="Logout"
              secondary={user && user.name}
            />
          </MenuItem>
        </Menu>
      </div>
    );
  }
}

export default withAuth(LoginButton)