/** @jsx jsx */
import { FC } from 'react';
import { jsx } from '@emotion/core';

import { Button } from '@material-ui/core';
import topViewImage from 'public/images/topViewImage.png';

import Layout from '@/organisms/Layout';
import Heading from '@/organisms/Heading';

import { mediaQuery } from 'services/css';

import { SPTEP_CONTENTS } from 'constants/home';
import { OUTSIDE_URL } from 'constants/url';

const Home: FC = () => {
  return (
    <Layout unHeaderOffset>
      {/* TopView */}
      <section
        css={{
          height: '100vh',
          backgroundImage: `url(${topViewImage})`,
          backgroundRepeat: 'no-repeat',
          backgroundSize: 'cover',
        }}
        id='topView'
      >
        <div
          css={mediaQuery({
            width: ['80%', '100%'],
            maxWidth: ['318px', '100%'],
            margin: ['0 auto', ''],
            padding: ['72px 0 0 0', '12% 0 0 50%'],
          })}
        >
          <h1
            css={{
              fontFamily: 'Noto Serif JP',
              fontSize: '4rem',
            }}
          >
            大切な時を守る傘を、
            <br />
            あなたに。
          </h1>
          <div css={mediaQuery({ margin: ['10% 0 0 25%', '10% 0 0 20px'] })}>
            <p>雨が降る日のみ、LINE通知を送信するアプリケーションです。</p>
            <p>もう傘を忘れて雨に濡れることはありません。</p>
            <p>雨を避けるために天気予報をチェックする必要もありません。</p>
            <p>万が一のときでも、雨に濡れないために。</p>
          </div>
        </div>
      </section>

      {/* Content */}
      <div
        css={{
          width: '80%',
          margin: '100px auto 0 auto',
        }}
      >
        <section css={mediaQuery({ marginTop: 20, textAlign: ['', 'center'] })}>
          <Heading>簡単2ステップで開始</Heading>
          <div css={{ marginTop: 40 }}>
            <p>UmbrellaNoticeはLINE公式アカウントから通知を送信します。</p>
            <p>
              面倒なアカウント登録を行う必要はなく、2ステップで利用できます。
            </p>
          </div>
          <div css={mediaQuery({textAlign: ['center', '']})}>
          <ul
            css={{
              marginTop: 10,
              textAlign: 'left',
              display: 'inline-block',
              listStyleType: 'none',
              listStypePosition: 'outside',
            }}
          >
            {SPTEP_CONTENTS.map((content, idx) => (
              <li css={{ margin: '0 auto' }} key={content}>
                <span
                  css={{
                    marginRight: 5,
                    fontFamily: 'Lemonada',
                    fontSize: '1.5rem',
                  }}
                >
                  {idx + 1}.
                </span>
                {content}
              </li>
            ))}
          </ul></div>
          <p css={{ marginTop: 20 }}>
            登録した位置情報を元に、雨が降る場合のみ通知を行います。
          </p>
          <div css={mediaQuery({ marginTop: 40, textAlign: ['center', ''] })}>
            <Button
              variant='contained'
              color='primary'
              href={OUTSIDE_URL.LINE.FOLLOW}
              target='_blank'
            >
              LINE 公式アカウントをフォロー
            </Button>
          </div>
        </section>
        <section css={mediaQuery({ marginTop: 70, textAlign: ['', 'center'] })}>
          <Heading>もう雨に濡れませんように</Heading>
          <div css={mediaQuery({ marginTop: 40, p: { lineHeight: ['', 2.7] } })}>
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
        </section>
      </div>
    </Layout>
  );
};

export default Home;
