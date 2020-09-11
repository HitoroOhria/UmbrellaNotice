import { AlertState } from "./alert";
import { MenuDrawerState } from "./menuDrawer";
import { DialogState } from "./dialog";
import { HomeState } from "./home";
import { UserState } from "./user";
import { WeatherState } from "./weather";
import { LineUserState } from "./lineUser";
import { CognitoState } from "./cognito";

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
