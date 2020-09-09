import { ApiResLineUser } from "./lineUser";

export type UserState = {
  id: number;
  email: string;
  oldPassword: string;
  newPassword: string;
  showOldPassword: boolean;
  showNewPassword: boolean;
};

export type ApiResUser = {
  id: number;
  email: string;
  line_user?: ApiResLineUser;
};

export type SerializedUser = Pick<UserState, "id" | "email">;
