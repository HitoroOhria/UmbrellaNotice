/** @jsx jsx */
import { FC, useEffect } from "react";
import { useDispatch } from "react-redux";
import { jsx } from "@emotion/core";
import _ from "lodash";

import Home from "@/pages/Home";

import homeActions from "../store/home/actions";

const HomePage: FC = () => {
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(homeActions.isHomePage({}));
    dispatch(homeActions.setScrollTopValue(0));
    window.addEventListener("scroll", handleScroll);

    const topViewHeight = document.getElementById("topView")?.clientHeight;
    topViewHeight && dispatch(homeActions.setTopViewHeight(topViewHeight));

    return () => {
      dispatch(homeActions.isNotHomePage({}));
      dispatch(homeActions.setTopViewHeight(0));
      window.removeEventListener("scroll", handleScroll);
    };
  });

  const handleScroll = _.throttle(() => {
    const scrollTop = Math.max(
      window.pageYOffset,
      document.documentElement.scrollTop,
      document.body.scrollTop
    );

    dispatch(homeActions.setScrollTopValue(scrollTop));
  }, 100);

  return <Home />;
};

export default HomePage;
