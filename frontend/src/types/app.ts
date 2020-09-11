import { ReactNode } from "react";

import { HeaderProps } from "./header";
import { AlertProps } from "./alert";
import { MenuDrawerProps } from "./menuDrawer";

export type AppProps = HeaderProps &
  Omit<AlertProps, "onClose"> &
  Omit<MenuDrawerProps, "onClose" | "onLinkClick"> & {
    children: ReactNode;
    onAlertClose: AlertProps["onClose"];
    onMenuLinkClick: MenuDrawerProps["onLinkClick"];
    onMenuDrawerClose: MenuDrawerProps["onClose"];
  };
