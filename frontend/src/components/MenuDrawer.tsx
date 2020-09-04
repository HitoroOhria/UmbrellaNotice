/** @jsx jsx */
import { FC } from "react";
import { useDispatch, useSelector } from "react-redux";
import { jsx } from "@emotion/core";

import Link from "next/link";
import { IconButton, Drawer } from "@material-ui/core";
import { Close } from "@material-ui/icons";

import menuDrawerActions from "../store/menuDrawer/actions";
import { RootState } from "../domain/entity/rootState";
import { MENU_DRAWER_ITEMS } from "../domain/services/menuDrawer";
import { OUTSIDE_URL } from "../domain/services/url";

const MenuDrawer: FC = () => {
  const dispatch = useDispatch();
  const isMenuDrawerOpen = useSelector(
    (state: RootState) => state.menuDrawer.isMenuDrawerOpen
  );

  const handleClose = () => dispatch(menuDrawerActions.closeMenuDrawer({}));

  const handleClick = () => {
    handleClose();
    window.scrollTo(0, 0);
  };

  return (
    <Drawer anchor="right" open={isMenuDrawerOpen} onClose={handleClose}>
      <div css={{ margin: "0 25px" }}>
        {/* Header */}
        <div
          css={{
            padding: "10px 0",
            borderBottom: "4px solid #ccc",
            display: "flex",
            justifyContent: "space-between",
          }}
        >
          {/* APP LOGO */}
          <Link href="/">
            <a>
              <img
                css={{
                  width: 50,
                  height: 45,
                  marginTop: 7,
                }}
                src="/images/appLogo.png"
                alt="logo"
                onClick={handleClick}
              />
            </a>
          </Link>
          {/* Close Icon */}
          <IconButton aria-label="close" onClick={handleClose}>
            <Close fontSize="large" style={{ color: "#000" }} />
          </IconButton>
        </div>
        {/* TODO: signedIn ? Profile : Sign in / Sifgn out  */}
        {/* Menu List */}
        <div css={{ margin: "20px 25px 0 25px" }}>
          <ul css={{ listStyle: "none outside" }}>
            {MENU_DRAWER_ITEMS.map((LIST_ITEM) => (
              // Parent List Item
              <li key={LIST_ITEM.NAME}>
                <h2 css={{ marginTop: 10, color: "mediumaquamarine" }}>
                  {LIST_ITEM.NAME}
                </h2>
                {LIST_ITEM.ITEMS && (
                  <ul
                    css={{
                      paddingLeft: 30,
                      listStyle: "none outside",
                    }}
                  >
                    {LIST_ITEM.ITEMS.map((CHILD_ITEM) => (
                      // Child List Item
                      <li key={CHILD_ITEM.NAME}>
                        <h3
                          css={{
                            marginTop: 10,
                            opacity: 0.5,
                            color: "#ccc",
                            a: {
                              borderBottom: "1px solid #000",
                              textDecoration: "none",
                              ":hover": { color: "#000" },
                            },
                          }}
                        >
                          {CHILD_ITEM.URL === OUTSIDE_URL.LINE.FOLLOW ? (
                            <a
                              href={CHILD_ITEM.URL}
                              target="_blank"
                              onClick={handleClick}
                            >
                              <span>− {CHILD_ITEM.NAME}</span>
                            </a>
                          ) : (
                            <Link href={CHILD_ITEM.URL}>
                              <a onClick={handleClick}>
                                <span>− {CHILD_ITEM.NAME}</span>
                              </a>
                            </Link>
                          )}
                        </h3>
                      </li>
                    ))}
                  </ul>
                )}
              </li>
            ))}
          </ul>
        </div>
      </div>
    </Drawer>
  );
};

export default MenuDrawer;
