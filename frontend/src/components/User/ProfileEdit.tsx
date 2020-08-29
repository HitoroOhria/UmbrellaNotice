/** @jsx jsx */
import React, { FC } from "react";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../../domain/entity/rootState";
import Helmet from "react-helmet";
import { jsx } from "@emotion/core";

import { Typography, Button } from "@material-ui/core";

import User from "./User";
import Weather from "./Weather";
import LineUser from "./LineUser";

const typographyStyle = { margin: "32px 0 8px 0" };
const inputStyle = { margin: "12px 0" };
const buttonStyle = { width: "70%", margin: "32px auto" };

const ProfileEdit: FC = () => {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);
  const cognitoUser = useSelector((state: RootState) => state.cognito.user);

  return (
    <div>
      <Helmet>
        <title>Profile - Umbrella Notice</title>
      </Helmet>

      <div>
        <h1 css={{ marginTop: 100, textAlign: "center" }}>
          <span>Profile</span>
        </h1>
        <div
          css={{
            width: "50%",
            maxWidth: 400,
            margin: "32px auto 0 auto",
          }}
        >
          <Typography
            style={typographyStyle}
            variant="h4"
            component="h2"
            color="primary"
          >
            ユーザー
          </Typography>
          <User inputStyle={inputStyle} buttonStyle={buttonStyle} />
          <Typography
            style={typographyStyle}
            variant="h4"
            component="h2"
            color="primary"
          >
            天気予報
          </Typography>
          <Weather inputStyle={inputStyle} buttonStyle={buttonStyle} />
          <Typography
            style={typographyStyle}
            variant="h4"
            component="h2"
            color="primary"
          >
            LINE アカウント
          </Typography>
          <LineUser inputStyle={inputStyle} buttonStyle={buttonStyle} />
        </div>
      </div>
    </div>
  );
};

export default ProfileEdit;
