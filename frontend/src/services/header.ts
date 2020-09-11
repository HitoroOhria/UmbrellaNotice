import { HomeState } from "types/store";

export const MenuIconOnTopView = (home: HomeState) =>
  home.isHomePage && home.scrollTop < home.topViewHeight - 3;
