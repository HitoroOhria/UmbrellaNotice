/** @jsx jsx */
import React, { FC, useEffect } from "react";
import { useDispatch } from "react-redux";
import Helmet from "react-helmet";
import { jsx } from "@emotion/core";
import _ from "lodash";

import TopView from "./TopView";
import Content from "./Content";
import homeActions from "../../store/home/actions";

const Home: FC = () => {
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(homeActions.isHomePage({}));
    dispatch(homeActions.setScrollTopValue(0));
    window.addEventListener("scroll", handleScroll);

    return () => {
      dispatch(homeActions.isNotHomePage({}));
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

  return (
    <div>
      <Helmet>
        <title>Home - Umbrella Notice</title>
      </Helmet>

      <TopView />
      <Content />
    </div>
  );
};

export default Home;
