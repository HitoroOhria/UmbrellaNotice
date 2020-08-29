import { MenuDrawerItem } from "../entity/menuDrawer";
import { URL_PATH, OUTSIDE_URL } from "./url";

export const MENU_DRAWER_ITEMS: MenuDrawerItem[] = [
  {
    NAME: "Application",
    ITEMS: [
      { NAME: "Home", URL: URL_PATH.HOME },
      { NAME: "LINE officila Account", URL: OUTSIDE_URL.LINE.FOLLOW },
    ],
  },

  {
    NAME: "Account",
    ITEMS: [{ NAME: "Sign in / Sign up", URL: URL_PATH.USER }],
  },
  {
    NAME: "Agreement",
    ITEMS: [
      { NAME: "Terms of service", URL: URL_PATH.TERMS },
      { NAME: "Privacy policy", URL: URL_PATH.POLICY },
    ],
  },
];
