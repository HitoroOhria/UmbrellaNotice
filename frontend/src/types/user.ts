import { LineUserState } from "./lineUser";
import { WeatherState } from "./weather";

export type UserState = {
  id: number;
  email: string;
  oldPassword: string;
  newPassword: string;
  showOldPassword: boolean;
  showNewPassword: boolean;
};

export type SerializedUser = Pick<UserState, "id" | "email">;

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
  onChangeEmailClick: () => void;
  onOldPasswordIconClick: () => void;
  onNewPasswordIconClick: () => void;
  onChangePasswordClick: () => void;
};

export type UserEmailDialogProps = {
  userEmail: string;
  userEmailDialogOpen: boolean;
  onUserEmailDialogClose: () => void;
  onUserEmailDialogNoClick: () => void;
  onUserEmailDialogYesClick: () => void;
};

export type LineUserRelatorProps = {
  lineUser: LineUserState;
  onLineUserChange: (member: Partial<LineUserState>) => any;
  onReleaseUserClick: () => void;
  onRelateUserClick: () => void;
};

export type WeatherEditorProps = {
  lineUser: LineUserState;
  weather: WeatherState;
  onLineUserChange: (member: Pick<LineUserState, "noticeTime">) => any;
  onWeatherChange: (member: Pick<WeatherState, "city">) => any;
  onSilentNoticeChange: () => any;
  onWeatherEditorClick: () => any;
};
