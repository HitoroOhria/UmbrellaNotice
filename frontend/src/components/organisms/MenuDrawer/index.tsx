/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";
import Link from "next/link";

import { IconButton, Drawer } from "@material-ui/core";
import { Close } from "@material-ui/icons";

import { OUTSIDE_URL } from "constants/url";
import { MENU_DRAWER_ITEMS } from "constants/menuDrawer";

import { MenuDrawerProps } from "types/components/organisms";

const MenuDrawer: FC<MenuDrawerProps> = ({
  menuDrawer,
  onClose,
  onLinkClick,
}) => {
  return (
    <Drawer anchor="right" open={menuDrawer.isOpen} onClose={onClose}>
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
                onClick={onLinkClick}
              />
            </a>
          </Link>
          {/* Close Icon */}
          <IconButton aria-label="close" onClick={onClose}>
            <Close fontSize="large" style={{ color: "#000" }} />
          </IconButton>
        </div>
        {/* TODO: signedIn ? Profile : Sign in / Sifgn out  */}
        {/* Menu List */}
        <nav css={{ margin: "20px 25px 0 25px" }}>
          <ul css={{ listStyle: "none outside" }}>
            {/* Parent List Items */}
            {MENU_DRAWER_ITEMS.map((LIST_ITEM) => (
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
                    {/* Child List Items */}
                    {LIST_ITEM.ITEMS.map((CHILD_ITEM) => (
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
                              onClick={onLinkClick}
                            >
                              <span>− {CHILD_ITEM.NAME}</span>
                            </a>
                          ) : (
                            <Link href={CHILD_ITEM.URL}>
                              <a onClick={onLinkClick}>
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
        </nav>
      </div>
    </Drawer>
  );
};

export default MenuDrawer;
