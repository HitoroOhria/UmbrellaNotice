import { ReactNode } from "react";

import { ButtonProps, SwitchProps } from "./atoms";
import {
  AlertProps,
  DialogProps,
  HeaderProps,
  MenuDrawerProps,
  PasswordInputProps,
} from "./organisms";

import { UserState, LineUserState, WeatherState } from "types/store";

export type AppProps = HeaderProps &
  Omit<AlertProps, "onClose"> &
  Omit<MenuDrawerProps, "onClose" | "onLinkClick"> & {
    children: ReactNode;
    onAlertClose: AlertProps["onClose"];
    onMenuLinkClick: MenuDrawerProps["onLinkClick"];
    onMenuDrawerClose: MenuDrawerProps["onClose"];
  };

export type PolicyProps = {
  displayArticle: () => string;
};

export type TermsProps = {
  displayArticle: () => string;
};

export type UserProps = UserEditorProps &
  Omit<UserEmailDialogProps, "userEmail"> &
  LineUserRelatorProps &
  WeatherEditorProps & {
    signedIn: boolean;
    onTestLoginClick: () => void;
  };

export type UserEditorProps = {
  user: UserState;
  onUserChange: (member: Partial<UserState>) => any;
  onChangeEmailClick: ButtonProps["onClick"];
  onMouseDownPasswod: PasswordInputProps["onMouseDownPassword"];
  onOldPasswordIconClick: PasswordInputProps["onIconClick"];
  onNewPasswordIconClick: PasswordInputProps["onIconClick"];
  onChangePasswordClick: ButtonProps["onClick"];
};

export type UserEmailDialogProps = {
  userEmail: string;
  userEmailDialogOpen: DialogProps["open"];
  onUserEmailDialogClose: DialogProps["onClose"];
  onUserEmailDialogNoClick: DialogProps["onNoClick"];
  onUserEmailDialogYesClick: DialogProps["onYesClick"];
};

export type LineUserRelatorProps = {
  lineUser: LineUserState;
  onLineUserChange: (member: Partial<LineUserState>) => any;
  onReleaseUserClick: ButtonProps["onClick"];
  onRelateUserClick: ButtonProps["onClick"];
};

export type WeatherEditorProps = {
  lineUser: LineUserState;
  weather: WeatherState;
  onLineUserChange: (member: Pick<LineUserState, "noticeTime">) => any;
  onWeatherChange: (member: Pick<WeatherState, "city">) => any;
  onSilentNoticeChange: SwitchProps["onChange"];
  onWeatherEditorClick: ButtonProps["onClick"];
};
