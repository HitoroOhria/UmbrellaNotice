/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import Button from "@/atoms/Button";
import Input from "@/organisms/Input";
import PasswordInput from "@/organisms/PasswordInput";

import { USER_LABEL } from "constants/user";

import { UserEditorProps } from "types/components/pages";

const EditUser: FC<UserEditorProps> = ({
  user,
  onUserChange,
  onChangeEmailClick,
  onMouseDownPasswod,
  onOldPasswordIconClick,
  onNewPasswordIconClick,
  onChangePasswordClick,
}) => {
  return (
    <div>
      <Input
        label={USER_LABEL.EMAIL}
        value={user.email}
        onChange={(event) => onUserChange({ email: event.target.value })}
      />
      <Button submitText={"変更する"} onClick={onChangeEmailClick} />
      <PasswordInput
        label={USER_LABEL.OLD_PASSWORD}
        showPassword={user.showOldPassword}
        value={user.oldPassword}
        onChange={(event) => onUserChange({ oldPassword: event.target.value })}
        onIconClick={onOldPasswordIconClick}
        onMouseDownPassword={onMouseDownPasswod}
      />
      <PasswordInput
        label={USER_LABEL.NEW_PASSWORD}
        showPassword={user.showNewPassword}
        value={user.newPassword}
        onChange={(event) => onUserChange({ newPassword: event.target.value })}
        onIconClick={onNewPasswordIconClick}
        onMouseDownPassword={onMouseDownPasswod}
      />
      <Button submitText={"変更する"} onClick={onChangePasswordClick} />
    </div>
  );
};

export default EditUser;
