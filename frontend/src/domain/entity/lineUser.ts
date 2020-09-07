import { ApiResWeather } from "./weather";

export type LineUserState = {
  id: number;
  relatedUser: boolean;
  noticeTime: string;
  silentNotice: boolean;
  serialNumber: string;
};

export type ApiResLineUser = {
  id: number;
  noticeTime: string;
  silentNotice: boolean;
  weather?: ApiResWeather;
};

export type RelateUserByLineUserAttr = Omit<
  LineUserState,
  "relatedUser" | "serialNumber"
>;

export type UpdateLineUserAttr = Omit<
  LineUserState,
  "id" | "relatedUser" | "serialNumber"
>;
