/** @jsx jsx */
import React, { FC } from "react";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../../domain/entity/rootState";
import { jsx } from "@emotion/core";

import {
  Button,
  Dialog,
  DialogTitle,
  DialogActions,
  DialogContent,
  DialogContentText,
} from "@material-ui/core/";
import { CognitoUser } from "amazon-cognito-identity-js";

import dialogActinos from "../../store/dialog/actions";
import { updateCognitoUser } from "../../store/user/effects";

const UerEmailDialog: FC = () => {
  const dispatch = useDispatch();
  const userEmail = useSelector((state: RootState) => state.user.email);
  const cognitoUser = useSelector((state: RootState) => state.cognito.user);

  const dialogOpen = useSelector(
    (state: RootState) => state.dialog.isUserEmailDialogOpen
  );

  const handleClose = () => dispatch(dialogActinos.closeUserEmailDialog({}));

  const handleAgree = () => {
    // sameEmail ? alertSameEmail : updateEmail
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
      onClose={handleClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogTitle id="alert-dialog-title">
        メールアドレスを変更しますか？
      </DialogTitle>
      <DialogContent>
        <DialogContentText id="alert-dialog-description">
          <p>次回のサインイン時にメールアドレスの承認が必要になります。</p>
          <p>打ち間違いがないかご確認下さい。</p>
          <div css={{ marginTop: 30, textAlign: "center" }}>
            <span css={{ borderBottom: "1px solid #ccc" }}>
              メールアドレス: {userEmail}
            </span>
          </div>
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={handleClose} color="primary">
          いいえ
        </Button>
        <Button onClick={handleAgree} color="primary" autoFocus>
          はい
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default UerEmailDialog;
