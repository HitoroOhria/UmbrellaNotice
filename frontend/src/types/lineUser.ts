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
