/** @jsx jsx */
import { FC, useEffect } from "react";
import { GetServerSideProps } from "next";
import { jsx } from "@emotion/core";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../domain/entity/rootState";

import Amplify, { I18n } from "aws-amplify";
import { onAuthUIStateChange, AuthState } from "@aws-amplify/ui-components";
import {
  AmplifyAuthenticator,
  AmplifySignUp,
  AmplifySignIn,
} from "@aws-amplify/ui-react";
import { CognitoUser } from "amazon-cognito-identity-js";

import Layout from "../components/Layout";
import Heading from "../components/Heading";
import ItemHeading from "../components/ItemHeading";
import Input from "../components/Input";
import DateInput from "../components/DateInput";
import PasswordInput from "../components/PasswordInput";
import Button from "../components/Button";
import Switch from "../components/Switch";
import Dialog from "../components/Dialog";
import Paper from "../components/Paper";

import userActions from "../store/user/actions";
import {
  fetchData,
  changeCognitoUserPassword,
  updateCognitoUser,
} from "../store/user/effects";
import lineUserActions from "../store/lineUser/actions";
import { relateUser, releaseUser } from "../store/lineUser/effects";
import weahterActions from "../store/weather/actions";
import { updateWeather } from "../store/weather/effects";
import dialogActinos from "../store/dialog/actions";
import cognitoActions from "../store/cognito/actions";
import { signIn } from "../store/cognito/effects";

import { UserState } from "../domain/entity/user";
import { LineUserState } from "../domain/entity/lineUser";
import { WeatherState } from "../domain/entity/weather";
import { ExCognitoUser } from "../domain/entity/cognito";

import {
  AMPLIFY_FORM,
  AMPLIFY_DICT,
  AMPLIFY_CONFIGURE,
} from "../domain/services/amplify";
import { USER_LABEL } from "../domain/services/user";
import { WEATHER_LABEL } from "../domain/services/weather";
import { INFO_TEXT } from "../domain/services/information";
import { TEST_USER } from "../domain/services/testUser";
import { openAlert } from "../domain/services/alert";

// Amplify Setting
Amplify.configure(AMPLIFY_CONFIGURE);
I18n.putVocabularies(AMPLIFY_DICT);
I18n.setLanguage("ja");

export const getServerSideProps: GetServerSideProps = async (_context) => {
  return { props: {} };
};

const User: FC = () => {
  const dispatch = useDispatch();

  const dispatchSetCognitoUser = (authData: object) =>
    dispatch(cognitoActions.setCognitoUser(authData as ExCognitoUser));

  useEffect(() => {
    return onAuthUIStateChange((nextAuthState, authData) => {
      dispatch(cognitoActions.setCognitoAuth(nextAuthState));
      authData
        ? dispatchSetCognitoUser(authData)
        : dispatch(cognitoActions.initCognitoUser({}));
    });
  }, []);

  return (
    <Layout title={"Profile"}>
      <AmplifyAuthenticator usernameAlias="email">
        <AmplifySignUp
          slot="sign-up"
          usernameAlias="email"
          formFields={AMPLIFY_FORM.SIGN_UP}
        />
        <AmplifySignIn
          slot="sign-in"
          usernameAlias="email"
          formFields={AMPLIFY_FORM.SIGN_IN}
        />

        {/* Contnet for User Sgined In */}
        <div>
          <Heading>Profile Edit</Heading>
          <div
            css={{
              maxWidth: 400,
              margin: "40px auto 0 auto",
            }}
          >
            <ItemHeading itemName={"ユーザー"} />
            <EditUser />

            <ItemHeading itemName={"LINE アカウント"} />
            <LineUserRelation />

            <ItemHeading itemName={"天気予報"} />
            <EditWeather />
          </div>
        </div>
      </AmplifyAuthenticator>
      <TestLogIn />
    </Layout>
  );
};

export default User;

const TestLogIn: FC = () => {
  const dispatch = useDispatch();
  const cognitoAuth = useSelector((state: RootState) => state.cognito.auth);

  const signedIn = cognitoAuth === AuthState.SignedIn;

  const handleClick = () => {
    dispatch(signIn(TEST_USER.EMAIL, TEST_USER.PASSWORD));
  };

  return (
    <div
      css={{
        margin: "20px auto 0 auto",
        maxWidth: 460,
        display: signedIn ? "none" : "block",
      }}
    >
      <Button
        submitText={"テストユーザーとしてログインする"}
        onClick={handleClick}
        contained
      />
    </div>
  );
};

const EditUser: FC = () => {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);
  const cognitoUser = useSelector((state: RootState) => state.cognito.user);

  useEffect(() => {
    if (cognitoUser) {
      dispatch(fetchData(cognitoUser.attributes.email));
      dispatch(userActions.setUserValue({ email: cognitoUser.attributes.email }));
    }
  }, [cognitoUser?.attributes.email]);

  const handleChange = (member: Partial<UserState>) =>
    dispatch(userActions.setUserValue(member));

  const handleEmailButtonClick = () => {
    if (user.email === cognitoUser?.attributes.email)
      return openAlert(dispatch, "warning", [
        "同じメールアドレスには変更できません。",
      ]);

    dispatch(dialogActinos.openUserEmailDialog({}));
  };

  const toggleOldShowPassword = () =>
    dispatch(userActions.toggleShowOldPassword({}));

  const toggleNewShowPassword = () =>
    dispatch(userActions.toggleShowNewPassword({}));

  const handlePasswordSave = () => {
    dispatch(
      changeCognitoUserPassword(
        cognitoUser as CognitoUser,
        user.oldPassword,
        user.newPassword
      )
    );
  };

  return (
    <div>
      {/* Email */}
      <Input
        label={USER_LABEL.EMAIL}
        value={user.email}
        onChange={(event) => handleChange({ email: event.target.value })}
      />
      <Button submitText={"変更する"} onClick={handleEmailButtonClick} />
      {/* Old Password */}
      <PasswordInput
        label={USER_LABEL.OLD_PASSWORD}
        showPassword={user.showOldPassword}
        value={user.oldPassword}
        onChange={(event) => handleChange({ oldPassword: event.target.value })}
        onIconClick={toggleOldShowPassword}
      />
      {/* New Password */}
      <PasswordInput
        label={USER_LABEL.NEW_PASSWORD}
        showPassword={user.showNewPassword}
        value={user.newPassword}
        onChange={(event) => handleChange({ newPassword: event.target.value })}
        onIconClick={toggleNewShowPassword}
      />
      <Button submitText={"変更する"} onClick={handlePasswordSave} />
      <UerEmailDialog />
    </div>
  );
};

const UerEmailDialog: FC = () => {
  const dispatch = useDispatch();
  const userEmail = useSelector((state: RootState) => state.user.email);
  const cognitoUser = useSelector((state: RootState) => state.cognito.user);
  const dialogOpen = useSelector(
    (state: RootState) => state.dialog.isUserEmailDialogOpen
  );

  const handleClose = () => dispatch(dialogActinos.closeUserEmailDialog({}));

  const handleAgree = () => {
    if (cognitoUser?.attributes.email === TEST_USER.EMAIL) {
      openAlert(dispatch, "error", [
        "テストユーザーのため、メールアドレスの変更はできません。",
      ]);
      return handleClose();
    }

    dispatch(
      updateCognitoUser(cognitoUser as CognitoUser, {
        email: userEmail,
      })
    );
    handleClose();
  };

  return (
    <Dialog
      open={dialogOpen}
      title={"メールアドレスの変更"}
      onClose={handleClose}
      onNoClick={handleClose}
      onYesClick={handleAgree}
    >
      <p>次回のサインイン時にメールアドレスの承認が必要になります。</p>
      <p>打ち間違いがないかご確認下さい。</p>
      <div css={{ marginTop: 30, textAlign: "center" }}>
        <span css={{ borderBottom: "1px solid #ccc" }}>
          メールアドレス: {userEmail}
        </span>
      </div>
    </Dialog>
  );
};

const LineUserRelation: FC = () => {
  const dispatch = useDispatch();
  const lineUser = useSelector((state: RootState) => state.lineUser);

  const cognitoUserEmail = useSelector(
    (state: RootState) => state.cognito.user?.attributes.email
  );

  const handleChange = (serialNumber: string) => {
    dispatch(lineUserActions.setValue({ serialNumber }));
  };

  const handleRelateClick = () => {
    cognitoUserEmail &&
      dispatch(relateUser(cognitoUserEmail, lineUser.serialNumber));
  };

  const handleReleaseClick = () => {
    cognitoUserEmail && dispatch(releaseUser(cognitoUserEmail));
  };

  return lineUser.relatedUser ? (
    <div css={{ marginTop: 20 }}>
      <Paper>
        <p>LINEアカウントと連携済みです！</p>
      </Paper>
      <Button submitText={"連携を解除する"} onClick={handleReleaseClick} />
    </div>
  ) : (
    <div>
      <Input
        label={"シリアル番号"}
        value={lineUser.serialNumber}
        onChange={(event) => handleChange(event.target.value)}
        info
        text={INFO_TEXT.SERIAL_NUMBER}
      />
      <Button submitText={"連携する"} onClick={handleRelateClick} />
    </div>
  );
};

const EditWeather: FC = () => {
  const dispatch = useDispatch();
  const lineUser = useSelector((state: RootState) => state.lineUser);
  const weather = useSelector((state: RootState) => state.weather);

  const handleLineUserChange = (member: Partial<LineUserState>) => {
    dispatch(lineUserActions.setValue(member));
  };

  const handleWeatherChange = (member: Partial<WeatherState>) =>
    dispatch(weahterActions.setValue(member));

  const toggleChecked = () => dispatch(lineUserActions.toggleSilentNotice({}));

  const handleClick = () => {
    dispatch(updateWeather(lineUser, weather));
  };

  return lineUser.relatedUser ? (
    <div>
      <Input
        label={WEATHER_LABEL.LOCATION}
        value={weather.city}
        onChange={(event) => handleWeatherChange({ city: event.target.value })}
      />
      <DateInput
        label={WEATHER_LABEL.NOTICE_TIME}
        value={lineUser.noticeTime}
        idPref={"line_user"}
        onChange={(event) =>
          handleLineUserChange({ noticeTime: event.target.value })
        }
      />
      <Switch
        label={WEATHER_LABEL.SILENT_NOTICE}
        checked={lineUser.silentNotice}
        onChange={toggleChecked}
      />
      <Button submitText={"変更する"} onClick={handleClick} />
    </div>
  ) : (
    <div css={{ marginTop: 20 }}>
      <Paper>
        <p>LINEアカウントと連携してください！</p>
      </Paper>
    </div>
  );
};
