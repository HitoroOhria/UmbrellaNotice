import { ReactNode, ChangeEvent, MouseEvent } from "react";

import { AlertState, MenuDrawerState } from "types/store";

export type AlertProps = {
  alert: AlertState;
  onClose: () => void;
};

export type ArticleLayoutProps = {
  children: ReactNode;
};

export type DateInputProps = {
  label: string;
  value: string;
  idPref: string;
  onChange: (event: ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => any;
};

export type DialogProps = {
  open: boolean;
  title: string;
  children: ReactNode;
  onClose: () => any;
  onNoClick: () => any;
  onYesClick: () => any;
};

export type HeaderProps = {
  signedIn: boolean;
  menuIconOnTopView: boolean;
  onLogoClick: () => void;
  onMenuIconClick: () => any;
  onSginOutClick: () => any;
};

export type HeadingProps = {
  children: ReactNode;
};

export type InputProps = {
  label: string;
  value: string;
  onChange: (event: ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => any;
  info?: boolean;
  text?: string;
};

export type ItemHeadingProps = {
  itemName: string;
};

export type LayoutProps = {
  children?: ReactNode;
  title?: string;
  unHeaderOffset?: boolean;
};

export type MenuDrawerProps = {
  menuDrawer: MenuDrawerState;
  onClose: () => void;
  onLinkClick: () => void;
};

export type PaperProps = {
  children: ReactNode;
};

export type PasswordInputProps = {
  label: string;
  showPassword: boolean;
  value: string;
  onChange: (event: ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => any;
  onIconClick: () => any;
  onMouseDownPassword: (event: MouseEvent) => void;
};
