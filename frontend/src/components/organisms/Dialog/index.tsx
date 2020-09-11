/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import {
  Button,
  Dialog as FDialog,
  DialogTitle,
  DialogActions,
  DialogContent,
  DialogContentText,
} from "@material-ui/core/";

import { DialogProps } from "types/components/organisms";

const Dialog: FC<DialogProps> = ({
  open,
  title,
  children,
  onClose,
  onNoClick,
  onYesClick,
}) => {
  return (
    <FDialog
      open={open}
      onClose={onClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogTitle id="alert-dialog-title">{title}</DialogTitle>
      <DialogContent>
        <DialogContentText id="alert-dialog-description">
          {children}
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={onNoClick} color="primary">
          いいえ
        </Button>
        <Button onClick={onYesClick} color="primary" autoFocus>
          はい
        </Button>
      </DialogActions>
    </FDialog>
  );
};

export default Dialog;
