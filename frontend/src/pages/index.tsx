/** @jsx jsx */
import { FC, useEffect } from "react";
import { useDispatch } from "react-redux";
import { css, jsx } from "@emotion/core";
import _ from "lodash";

import { Button } from "@material-ui/core";

import Layout from "../components/Layout";
import Heading from "../components/Heading";

import homeActions from "../store/home/actions";
import { SPTEP_CONTENTS } from "../domain/services/home";
import { OUTSIDE_URL } from "../domain/services/url";

import topViewImage from "../../public/images/topViewImage.png";

const Home: FC = () => {
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

  return (
    <Layout unHeaderOffset>
      {/* TopView */}
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
          </div>
        </div>
      </div>

      {/* Content */}
      <div
        css={{
          width: "80%",
          margin: "100px auto 0 auto",
        }}
      >
        <div css={{ marginTop: 20, textAlign: "center" }}>
          <Heading>簡単2ステップで開始</Heading>
          <div css={{ marginTop: 40 }}>
            <p>UmbrellaNoticeはLINE公式アカウントから通知を送信します。</p>
            <p>
              面倒なアカウント登録を行う必要はなく、2ステップで利用できます。
            </p>
          </div>
          <ul
            css={{
              marginTop: 10,
              textAlign: "left",
              display: "inline-block",
              listStyleType: "none",
              listStypePosition: "outside",
            }}
          >
            {SPTEP_CONTENTS.map((content, idx) => (
              <li css={{ margin: "0 auto" }} key={content}>
                <span
                  css={{
                    marginRight: 5,
                    fontFamily: "Lemonada",
                    fontSize: "1.5rem",
                  }}
                >
                  {idx + 1}.
                </span>
                {content}
              </li>
            ))}
          </ul>
          <p css={{ marginTop: 20 }}>
            登録した位置情報を元に、雨が降る場合のみ通知を行います。
          </p>
          <div css={{ marginTop: 40 }}>
            <Button
              variant="contained"
              color="primary"
              href={OUTSIDE_URL.LINE.FOLLOW}
              target="_blank"
            >
              LINE 公式アカウントをフォロー
            </Button>
          </div>
        </div>
        <div css={{ marginTop: 70, textAlign: "center" }}>
          <Heading>もう雨に濡れませんように</Heading>
          <div css={{ marginTop: 40, p: { lineHeight: 2.7 } }}>
            <p>
              このアプリケーションは、製作者が出先で雨に濡れたこと経験から作成しました。
            </p>
            <p>
              そのときはコンビニで傘を買って帰りましたが、本来なら必要のない出費です。
            </p>
            <p>
              かといって、雨に濡れながら移動することは、あまり心地よいものではありません。
            </p>
            <p>
              毎日天気予報を確認する方法もありますが、雨は年中降るわけではなく、
            </p>
            <p>
              少ない機会のために毎日コストを割くことは非合理的だと思いました。
            </p>
            <p>
              この問題をシステムで解決するために、UmbrellaNoticeを開発しました。
            </p>
            <p>
              もう雨に濡れないために、毎日天気予報をチェックする必要はなく、
            </p>
            <p>UmbrellaNoticeから 通知が来た日のみ傘を持てば良いのです。</p>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Home;
