/** @jsx jsx */
import React, { FC, MouseEvent, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../../domain/entity/rootState";
import { jsx } from "@emotion/core";

import {
  TextField,
  FormControl,
  Input,
  InputLabel,
  InputAdornment,
  IconButton,
  Button,
} from "@material-ui/core";
import { Visibility, VisibilityOff } from "@material-ui/icons";
import { CognitoUser } from "amazon-cognito-identity-js";

import UerEmailDialog from "./UserEmailDialog";
import userActions from "../../store/user/actions";
import dialogActinos from "../../store/dialog/actions";
import { changeCognitoUserPassword } from "../../store/user/effects";
import { UserState } from "../../domain/entity/user";
import { USER_LABEL } from "../../domain/services/user";

const User: FC<{ inputStyle: object; buttonStyle: object }> = ({
  inputStyle,
  buttonStyle,
}) => {
  const dispatch = useDispatch();
  const user = useSelector((state: RootState) => state.user);
  const cognitoUser = useSelector((state: RootState) => state.cognito.user);

  useEffect(() => {
    if (cognitoUser) {
      const user = { email: cognitoUser.attributes.email };
      dispatch(userActions.setUserValue(user));
    }
  }, []);

  const handleChange = (member: Partial<UserState>) =>
    dispatch(userActions.setUserValue(member));

  const handleEmailButtonClick = () =>
    dispatch(dialogActinos.openUserEmailDialog({}));

  const toggleOldShowPassword = () =>
    dispatch(userActions.toggleShowOldPassword({}));

  const toggleNewShowPassword = () =>
    dispatch(userActions.toggleShowNewPassword({}));

  const handleMouseDownPassword = (event: MouseEvent) => event.preventDefault();

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
      <TextField
        style={inputStyle}
        fullWidth
        label={USER_LABEL.EMAIL}
        value={user.email}
        onChange={(event) => handleChange({ email: event.target.value })}
      />
      <div css={{ textAlign: "center" }}>
        <Button
          style={buttonStyle}
          onClick={handleEmailButtonClick}
          variant="outlined"
          color="primary"
        >
          確認
        </Button>
      </div>
      {/* Password */}
      {/* Old Password */}
      <FormControl style={inputStyle} fullWidth>
        <InputLabel htmlFor="standard-adornment-password">
          {USER_LABEL.OLD_PASSWORD}
        </InputLabel>
        <Input
          id="standard-adornment-password"
          type={user.showOldPassword ? "text" : "password"}
          value={user.oldPassword}
          onChange={(event) =>
            handleChange({ oldPassword: event.target.value })
          }
          endAdornment={
            <InputAdornment position="end">
              <IconButton
                aria-label="toggle password visibility"
                onClick={toggleOldShowPassword}
                onMouseDown={(event) => handleMouseDownPassword(event)}
              >
                {user.showOldPassword ? <Visibility /> : <VisibilityOff />}
              </IconButton>
            </InputAdornment>
          }
        />
      </FormControl>
      {/* New Password */}
      <FormControl style={inputStyle} fullWidth>
        <InputLabel htmlFor="standard-adornment-password">
          {USER_LABEL.NEW_PASSWORD}
        </InputLabel>
        <Input
          id="standard-adornment-password"
          type={user.showNewPassword ? "text" : "password"}
          value={user.newPassword}
          onChange={(event) =>
            handleChange({ newPassword: event.target.value })
          }
          endAdornment={
            <InputAdornment position="end">
              <IconButton
                aria-label="toggle password visibility"
                onClick={toggleNewShowPassword}
                onMouseDown={(event) => handleMouseDownPassword(event)}
              >
                {user.showNewPassword ? <Visibility /> : <VisibilityOff />}
              </IconButton>
            </InputAdornment>
          }
        />
      </FormControl>
      <div css={{ textAlign: "center" }}>
        <Button
          style={buttonStyle}
          onClick={handlePasswordSave}
          variant="outlined"
          color="primary"
        >
          変更する
        </Button>
      </div>
      <UerEmailDialog />
    </div>
  );
};

export default User;
