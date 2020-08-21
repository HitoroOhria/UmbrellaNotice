/** @jsx jsx */
import React, { FC, useEffect } from "react";
import { useDispatch } from "react-redux";
import { css, jsx } from "@emotion/core";

import topViewImage from "../../images/topViewImage.png";
import homeActions from "../../store/home/actions";

const TopView: FC = () => {
  const dispatch = useDispatch();

  useEffect(() => {
    const topViewHeight = document.getElementById("topView")?.clientHeight;
    topViewHeight && dispatch(homeActions.setTopViewHeight(topViewHeight));

    return () => {
      dispatch(homeActions.setTopViewHeight(0));
    };
  });

  return (
    <div
      css={css`
        height: 100vh;
        background-image: url(${topViewImage});
        background-repeat: no-repeat;
        background-size: cover;
      `}
      id="topView"
    >
      <div css={{ paddingTop: "12%", paddingLeft: "50%" }}>
        <h1
          css={{
            fontFamily: "Noto Serif JP",
            fontSize: "4rem",
          }}
        >
          大切な時を守る傘を、
          <br />
          あなたに。
        </h1>
        <div css={{ marginTop: "10%", marginLeft: 20 }}>
          <p>雨が降る日のみ、LINE通知を送信するアプリケーションです。</p>
          <p>もう傘を忘れて雨に濡れることはありません。</p>
          <p>雨を避けるために天気予報をチェックする必要もありません。</p>
          <p>万が一のときでも、雨に濡れないために。</p>
          {/* <p>雨が降る日のみ、通知を送信するアプリケーションです。
          <br />
          もう傘を忘れて雨に濡れることも、そのために天気予報
          <br />
          をチェックする必要もありません。
          <br />
          万が一のときでも、雨に濡れないために。</p> */}
        </div>
      </div>
    </div>
  );
};

export default TopView;
