import { HomeState } from "types/home";

export const MenuIconOnTopView = (home: HomeState) =>
  home.isHomePage && home.scrollTop < home.topViewHeight - 3;
