/** @jsx jsx */
import React, { FC } from "react";
import Helmet from "react-helmet";
import { jsx } from "@emotion/core";

import {
  AmplifyAuthenticator,
  AmplifySignUp,
  AmplifySignIn,
} from "@aws-amplify/ui-react";

const Authentication: FC = () => {
  return (
    <div>
      <Helmet>
        <title>Auhentiacation - Umbrella Notice</title>
      </Helmet>

      <div css={{ marginTop: 152, display: "flex", justifyContent: "center" }}>
        <AmplifyAuthenticator usernameAlias="email">
          <AmplifySignUp
            slot="sign-up"
            usernameAlias="email"
            formFields={[
              {
                type: "email",
                label: "メールアドレス",
                placeholder: "メールアドレスを入力して下さい",
                required: true,
              },
              {
                type: "password",
                label: "パスワード",
                placeholder: "パスワードを入力して下さい",
                required: true,
              },
            ]}
          />
          <AmplifySignIn
            slot="sign-in"
            usernameAlias="email"
            formFields={[
              {
                type: "email",
                label: "メールアドレス",
                placeholder: "メールアドレスを入力して下さい",
                required: true,
              },
              {
                type: "password",
                label: "パスワード",
                placeholder: "パスワードを入力して下さい",
                required: true,
              },
            ]}
          />
        </AmplifyAuthenticator>
      </div>
    </div>
  );
};

export default Authentication;
