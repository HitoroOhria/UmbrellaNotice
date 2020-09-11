export type MenuDrawerChildItem = {
  NAME: string;
  URL: string;
};

export type MenuDrawerItem = {
  NAME: string;
  ITEMS: MenuDrawerChildItem[];
};

export type MenuDrawerState = {
  isOpen: boolean;
};

export type MenuDrawerProps = {
  menuDrawer: MenuDrawerState
  onClose: () => void
  onLinkClick: () => void
}