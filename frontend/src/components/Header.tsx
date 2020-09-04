/** @jsx jsx */
import { FC } from "react";
import Link from "next/link";
import { useDispatch, useSelector } from "react-redux";
import { jsx } from "@emotion/core";

import { Button, IconButton } from "@material-ui/core";
import { Menu } from "@material-ui/icons";
import { AuthState } from "@aws-amplify/ui-components";

import menuDrawerActions from "../store/menuDrawer/actions";
import { signOut } from "../store/cognito/effects";
import { RootState } from "../domain/entity/rootState";

const Header: FC = () => {
  const dispatch = useDispatch();
  const home = useSelector((state: RootState) => state.home);
  const cognitoAuth = useSelector((state: RootState) => state.cognito.auth);

  const MenuIconOnTopView =
    home.isHomePage && home.scrollTop < home.topViewHeight - 3;

  const handleLogoClick = () => window.scrollTo(0, 0);

  const handleMenuClick = () => dispatch(menuDrawerActions.openMenuDrawer({}));

  const handleSginOutClick = () => dispatch(signOut());

  return (
    <header
      css={{
        backgroundColor: MenuIconOnTopView ? undefined : "#2B2F4A",
        width: "100%",
        borderBottom: MenuIconOnTopView ? undefined : "4px solid #968166",
        position: "fixed",
        top: 0,
        zIndex: 2,
        padding: "0 20px",
        display: "flex",
        justifyContent: "space-between",
      }}
    >
      {/* APP LOGO */}
      <Link href="/">
        <a
          css={{
            textDecoration: "none",
            display: "flex",
            justifyContent: "space-between",
          }}
          onClick={handleLogoClick}
        >
          {/* APP LOGO Image */}
          <img
            src={
              MenuIconOnTopView
                ? "/images/appLogo.png"
                : "/images/appLogoWhite.png"
            }
            alt="logo"
            css={{
              width: 45,
              height: 40,
              marginTop: 10,
            }}
          />
          {/* APP LOGO Name */}
          <div
            css={{
              marginLeft: 8,
              color: MenuIconOnTopView ? "#000" : "#fff",
              fontSize: 30,
              fontFamily: "Lemonada",
            }}
          >
            Umbrella Notice
          </div>
        </a>
      </Link>
      {/* MENU Icon */}
      <div css={{ display: "flex", justifyContent: "space-between" }}>
        {/* TODO: SignedIn && ブラウザリロード -> SginOutButton is hidden. */}
        {cognitoAuth === AuthState.SignedIn && (
          <Button
            style={{ color: "#fff", margin: "0 15px 0 0" }}
            size="large"
            onClick={handleSginOutClick}
          >
            Sign out
          </Button>
        )}
        <IconButton aria-label="menu" onClick={handleMenuClick}>
          <Menu fontSize="large" style={{ color: "#fff" }} />
        </IconButton>
      </div>
    </header>
  );
};

export default Header;
