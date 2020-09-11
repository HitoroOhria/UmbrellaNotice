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
      signedIn={cognitoAuth === AuthState.SignedIn}
      menuIconOnTopView={MenuIconOnTopView(home)}
      onLogoClick={handleLogoClick}
      onMenuIconClick={handleMenuIconClick}
      onSginOutClick={handleSginOutClick}
      alert={alert}
      onAlertClose={handleAlertClose}
      menuDrawer={menuDrawer}
      onMenuLinkClick={handleMenuLinkClick}
      onMenuDrawerClose={handleMenuDrawerClose}
    >
      {children}
    </App>
  );
};

export default AppComponent;
