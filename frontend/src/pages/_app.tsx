import React from 'react';
import { AppProps } from 'next/app';
import { Provider } from 'react-redux';
import { Global } from '@emotion/core';

import AppComponent from './_appComponent';

import store from 'store/index';

import { mediaQuery } from 'services/css';

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

const globalStyle = mediaQuery({
  html: { fontSize: [10, 16] },
  body: { backgroundColor: '#F0E3D0' },
  p: { lineHeight: 1.7, fontSize: ['1.3rem', '1rem'] },
  li: { lineHeight: 1.7, fontSize: ['1.3rem', '1rem'] },
  a: { span: { fontSize: ['1.3rem', '1rem'] } },
  'amplify-authenticator': {
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1,
    marginTop: 40,
  },
  '.toast': { top: 72 },
});
