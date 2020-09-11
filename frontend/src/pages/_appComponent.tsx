/** @jsx jsx */
import { FC, ReactNode } from "react";
import { jsx } from "@emotion/core";
import { useDispatch, useSelector } from "react-redux";

import { AuthState } from "@aws-amplify/ui-components";

import alertActions from "store/alert/actions";
import menuDrawerActions from "store/menuDrawer/actions";
import { signOut } from "store/cognito/effects";

import App from "@/pages/AppComponent";

import { MenuIconOnTopView } from "services/header";

import { RootState } from "types/rootState";

const AppComponent: FC<{ children: ReactNode }> = ({ children }) => {
  const dispatch = useDispatch();

  const home = useSelector((state: RootState) => state.home);
  const cognitoAuth = useSelector((state: RootState) => state.cognito.auth);
  const alert = useSelector((state: RootState) => state.alert);
  const menuDrawer = useSelector((state: RootState) => state.menuDrawer);

  const signedIn = cognitoAuth === AuthState.SignedIn;

  const handleLogoClick = () => window.scrollTo(0, 0);

  const handleMenuIconClick = () =>
    dispatch(menuDrawerActions.openMenuDrawer({}));

  const handleSginOutClick = () => dispatch(signOut());

  const handleAlertClose = () => {
    dispatch(alertActions.closeAlert({}));
  };

  const handleMenuLinkClick = () => {
    handleMenuDrawerClose();
    window.scrollTo(0, 0);
  };

  const handleMenuDrawerClose = () =>
    dispatch(menuDrawerActions.closeMenuDrawer({}));

  return (
    <App
      // Header
      signedIn={signedIn}
      menuIconOnTopView={MenuIconOnTopView(home)}
      onLogoClick={handleLogoClick}
      onMenuIconClick={handleMenuIconClick}
      onSginOutClick={handleSginOutClick}
      // Alert
      alert={alert}
      onAlertClose={handleAlertClose}
      // MenuDrawer
      menuDrawer={menuDrawer}
      onMenuLinkClick={handleMenuLinkClick}
      onMenuDrawerClose={handleMenuDrawerClose}
    >
      {children}
    </App>
  );
};

export default AppComponent;
