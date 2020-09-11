import { AuthState } from "@aws-amplify/ui-components";
import { CognitoUser } from "amazon-cognito-identity-js";

export type RootState = {
  alert: AlertState;
  menuDrawer: MenuDrawerState;
  dialog: DialogState;
  home: HomeState;
  user: UserState;
  weather: WeatherState;
  lineUser: LineUserState;
  cognito: CognitoState;
};

export type AlertState = {
  isLoading: boolean;
  severity: "error" | "warning" | "info" | "success";
  messages: string[];
  open: boolean;
};

export type ExCognitoUser = CognitoUser & {
  attributes: {
    email: string;
    email_verified: boolean;
    sub: string;
  };
};

export type CognitoState = {
  auth: AuthState;
  user: ExCognitoUser | undefined;
};

export type DialogState = {
  isUserEmailDialogOpen: boolean;
};

export type HomeState = {
  isHomePage: boolean;
  topViewHeight: number;
  scrollTop: number;
};

export type LineUserState = {
  id: number;
  relatedUser: boolean;
  noticeTime: string;
  silentNotice: boolean;
  serialNumber: string;
};

export type RelateUserByLineUserAttr = Omit<
  LineUserState,
  "relatedUser" | "serialNumber"
>;

export type UpdateLineUserAttr = Omit<
  LineUserState,
  "id" | "relatedUser" | "serialNumber"
>;

export type MenuDrawerState = {
  isOpen: boolean;
};

export type UserState = {
  id: number;
  email: string;
  oldPassword: string;
  newPassword: string;
  showOldPassword: boolean;
  showNewPassword: boolean;
};

export type WeatherState = {
  id: number;
  city: string;
  lat: Number | undefined;
  lon: Number | undefined;
};

export type UpdateWatherAttr = Omit<WeatherState, "id">;
