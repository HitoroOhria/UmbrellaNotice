/** @jsx jsx */
import React, { FC } from "react";
import { jsx } from "@emotion/core";

import { Button } from "@material-ui/core";
import { OUTSIDE_URL } from "../../domain/services/url";

const Content: FC = () => {
  const useStepContents = ["LINE公式アカウントをフォロー", "位置情報を設定"];

  return (
    <div
      css={{
        width: "80%",
        margin: "100px auto 0 auto",
      }}
    >
      <div css={{ marginTop: 20, textAlign: "center" }}>
        <h1>
          <span>簡単2ステップで開始</span>
        </h1>
        <div css={{ marginTop: 40 }}>
          <p>UmbrellaNoticeはLINE公式アカウントから通知を送信します。</p>
          <p>面倒なアカウント登録を行う必要はなく、2ステップで利用できます。</p>
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
          {useStepContents.map((content, idx) => (
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
          <Button variant="contained" color="primary" href={OUTSIDE_URL.LINE.FOLLOW} target='_blank'>
            LINE 公式アカウントをフォロー
          </Button>
        </div>
      </div>
      <div css={{ marginTop: 70, textAlign: "center" }}>
        <h1>
          <span>もう雨に濡れませんように</span>
        </h1>
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
          <p>もう雨に濡れないために、毎日天気予報をチェックする必要はなく、</p>
          <p>UmbrellaNoticeから 通知が来た日のみ傘を持てば良いのです。</p>
        </div>
      </div>
    </div>
  );
};

export default Content;
