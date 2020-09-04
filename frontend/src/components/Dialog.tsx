/** @jsx jsx */
import { FC, ReactNode } from "react";
import { jsx } from "@emotion/core";

import {
    Button,
    Dialog as FDialog,
    DialogTitle,
    DialogActions,
    DialogContent,
    DialogContentText,
  } from "@material-ui/core/";

type Props = {
  open: boolean;
  title: string;
  children: ReactNode;
  onClose: () => any;
  onNoClick: () => any;
  onYesClick: () => any;
};

const Dialog: FC<Props> = ({ open, title, children, onClose, onNoClick, onYesClick }) => {
  return (
    <FDialog
      open={open}
      onClose={onClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogTitle id="alert-dialog-title">
        {title}
      </DialogTitle>
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
