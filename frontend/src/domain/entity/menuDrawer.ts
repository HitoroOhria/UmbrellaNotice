export type MenuDrawerChildItem = {
  NAME: string;
  URL: string;
};

export type MenuDrawerItem = {
  NAME: string;
  ITEMS: MenuDrawerChildItem[];
};

export type MenuDrawerState = {
  isMenuDrawerOpen: boolean;
};
