type MenuDrawerChildItem = {
  NAME: string;
  URL: string;
};

export type MenuDrawerItem = {
  NAME: string;
  ITEMS: MenuDrawerChildItem[];
};
