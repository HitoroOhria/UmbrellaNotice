import React from "react";
import { AppProps } from "next/app";
import { Provider } from "react-redux";
import { css, Global } from "@emotion/core";

import AppComponent from "./_appComponent";

import store from "store/index";

const App = ({ Component, pageProps }: AppProps) => {
  return (
    <Provider store={store}>
      <Global styles={globalStyle} />
      <AppComponent>
        <Component {...pageProps} />
      </AppComponent>
    </Provider>
  );
};

export default App;

const globalStyle = css`
  p {
    line-height: 1.7;
  }

  li {
    line-height: 1.7;
  }

  amplify-authenticator {
    display: flex;
    justify-content: center;
    align-items: center;
    flex: 1;
    margin-top: 40px;
  }

  .toast {
    top: 72px;
  }
`;
