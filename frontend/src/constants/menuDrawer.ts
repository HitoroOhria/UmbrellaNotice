import { MenuDrawerItem } from "types/constants";
import { PATH_NAME, OUTSIDE_URL } from "constants/url";

export const MENU_DRAWER_ITEMS: MenuDrawerItem[] = [
  {
    NAME: "Application",
    ITEMS: [
      { NAME: "Home", URL: PATH_NAME.HOME },
      { NAME: "LINE officila Account", URL: OUTSIDE_URL.LINE.FOLLOW },
    ],
  },

  {
    NAME: "Account",
    ITEMS: [{ NAME: "Sign in / Sign up", URL: PATH_NAME.USER }],
  },
  {
    NAME: "Agreement",
    ITEMS: [
      { NAME: "Terms of service", URL: PATH_NAME.TERMS },
      { NAME: "Privacy policy", URL: PATH_NAME.POLICY },
    ],
  },
];
