/** @jsx jsx */
import { FC, useEffect } from "react";
import { GetServerSideProps } from "next";
import { jsx } from "@emotion/core";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "types/rootState";

import Amplify, { I18n } from "aws-amplify";
import { onAuthUIStateChange, AuthState } from "@aws-amplify/ui-components";

import { CognitoUser } from "amazon-cognito-identity-js";

import User from "@/pages/User";

import userActions from "store/user/actions";
import {
  fetchData,
  changeCognitoUserPassword,
  updateCognitoUser,
} from "store/user/effects";
import lineUserActions from "store/lineUser/actions";
import { relateUser, releaseUser } from "store/lineUser/effects";
import weahterActions from "store/weather/actions";
import { updateWeather } from "store/weather/effects";
import dialogActinos from "store/dialog/actions";
import cognitoActions from "store/cognito/actions";
import { signIn } from "store/cognito/effects";

import { UserState } from "types/user";
import { LineUserState } from "types/lineUser";
import { WeatherState } from "types/weather";
import { ExCognitoUser } from "types/cognito";

import { AMPLIFY_DICT, AMPLIFY_CONFIGURE } from "constants/amplify";
import { TEST_USER } from "constants/testUser";

import { openAlert } from "services/alert";

Amplify.configure(AMPLIFY_CONFIGURE);
I18n.putVocabularies(AMPLIFY_DICT);
I18n.setLanguage("ja");

export const getServerSideProps: GetServerSideProps = async (_context) => {
  return { props: {} };
};

const UserPage: FC = () => {
  const dispatch = useDispatch();

  const user = useSelector((state: RootState) => state.user);
  const lineUser = useSelector((state: RootState) => state.lineUser);
  const weather = useSelector((state: RootState) => state.weather);
  const cognitoUser = useSelector((state: RootState) => state.cognito.user);
  const cognitoAuth = useSelector((state: RootState) => state.cognito.auth);
  const isUserEmailDialogOpen = useSelector(
    (state: RootState) => state.dialog.isUserEmailDialogOpen
  );

  useEffect(() => {
    return onAuthUIStateChange((nextAuthState, authData) => {
      dispatch(cognitoActions.setCognitoAuth(nextAuthState));
      authData
        ? dispatchSetCognitoUser(authData)
        : dispatch(cognitoActions.initCognitoUser({}));
    });
  }, []);

  useEffect(() => {
    if (cognitoUser) {
      dispatch(fetchData(cognitoUser.attributes.email));
      dispatch(userActions.setValue({ email: cognitoUser.attributes.email }));
    }
  }, [cognitoUser?.attributes.email]);

  const dispatchSetCognitoUser = (authData: object) =>
    dispatch(cognitoActions.setCognitoUser(authData as ExCognitoUser));

  const handleUserChange = (member: Partial<UserState>) =>
    dispatch(userActions.setValue(member));

  const handleLineUserChange = (member: Partial<LineUserState>) =>
    dispatch(lineUserActions.setValue(member));

  const handleWeatherChange = (member: Partial<WeatherState>) =>
    dispatch(weahterActions.setValue(member));

  const handleChangeEmailClick = () => {
    if (user.email === cognitoUser?.attributes.email)
      return openAlert(dispatch, "warning", [
        "同じメールアドレスには変更できません。",
      ]);

    dispatch(dialogActinos.openUserEmailDialog({}));
  };

  const toggleOldShowPasswordIcon = () =>
    dispatch(userActions.toggleShowOldPassword({}));

  const toggleNewShowPasswordIcon = () =>
    dispatch(userActions.toggleShowNewPassword({}));

  const handleChangePassword = () => {
    dispatch(
      changeCognitoUserPassword(
        cognitoUser as CognitoUser,
        user.oldPassword,
        user.newPassword
      )
    );
  };

  const handleUserEmailDialogClose = () =>
    dispatch(dialogActinos.closeUserEmailDialog({}));

  const handleUserEmailDialogYesClick = () => {
    if (cognitoUser?.attributes.email === TEST_USER.EMAIL) {
      openAlert(dispatch, "error", [
        "テストユーザーのため、メールアドレスの変更はできません。",
      ]);
      return handleUserEmailDialogClose();
    }

    dispatch(
      updateCognitoUser(cognitoUser as CognitoUser, {
        email: user.email,
      })
    );
    handleUserEmailDialogClose();
  };

  const handleRelateUserClick = () => {
    cognitoUser &&
      dispatch(relateUser(cognitoUser.attributes.email, lineUser.serialNumber));
  };

  const handleRelaseUserClick = () => {
    cognitoUser && dispatch(releaseUser(cognitoUser.attributes.email));
  };

  const toggleSilentNotice = () =>
    dispatch(lineUserActions.toggleSilentNotice({}));

  const handleUpdateWeather = () => dispatch(updateWeather(lineUser, weather));

  const signedIn = cognitoAuth === AuthState.SignedIn;

  const handleTestLoginClick = () => {
    dispatch(signIn(TEST_USER.EMAIL, TEST_USER.PASSWORD));
  };

  return (
    <User
      user={user}
      lineUser={lineUser}
      weather={weather}
      onUserChange={handleUserChange}
      onLineUserChange={handleLineUserChange}
      onWeatherChange={handleWeatherChange}
      // UserEditor
      onOldPasswordIconClick={toggleOldShowPasswordIcon}
      onNewPasswordIconClick={toggleNewShowPasswordIcon}
      onChangeEmailClick={handleChangeEmailClick}
      onChangePasswordClick={handleChangePassword}
      // UserEmailDialog
      userEmailDialogOpen={isUserEmailDialogOpen}
      onUserEmailDialogClose={handleUserEmailDialogClose}
      onUserEmailDialogNoClick={handleUserEmailDialogClose}
      onUserEmailDialogYesClick={handleUserEmailDialogYesClick}
      // LineUserRelator
      onReleaseUserClick={handleRelaseUserClick}
      onRelateUserClick={handleRelateUserClick}
      // WeatherEditor
      onSilentNoticeChange={toggleSilentNotice}
      onWeatherEditorClick={handleUpdateWeather}
      // TestUserLogIn
      signedIn={signedIn}
      onTestLoginClick={handleTestLoginClick}
    />
  );
};

export default UserPage;
