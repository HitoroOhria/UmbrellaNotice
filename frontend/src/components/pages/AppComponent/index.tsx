/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import Header from "@/organisms/Header";
import Footer from "@/organisms/Footer";
import Alert from "@/organisms/Alert";
import MenuDrawer from "@/organisms/MenuDrawer";

import { AppProps } from "types/components/pages";

const App: FC<AppProps> = ({
  children,

  // Header
  signedIn,
  menuIconOnTopView,
  onLogoClick,
  onMenuIconClick,
  onSginOutClick,

  // Alert
  alert,
  onAlertClose,

  // MenuDrawer
  menuDrawer,
  onMenuLinkClick,
  onMenuDrawerClose,
}) => {
  return (
    <div>
      <Header
        signedIn={signedIn}
        menuIconOnTopView={menuIconOnTopView}
        onLogoClick={onLogoClick}
        onMenuIconClick={onMenuIconClick}
        onSginOutClick={onSginOutClick}
      />
      {children}
      <Footer />

      <Alert alert={alert} onClose={onAlertClose} />
      <MenuDrawer
        menuDrawer={menuDrawer}
        onClose={onMenuDrawerClose}
        onLinkClick={onMenuLinkClick}
      />
    </div>
  );
};

export default App;
