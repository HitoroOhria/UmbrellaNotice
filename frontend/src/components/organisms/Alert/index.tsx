/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import MuiAlert from "@material-ui/lab/Alert";
import { Snackbar, CircularProgress } from "@material-ui/core";

import { AlertProps } from "types/components/organisms";

const Alert: FC<AlertProps> = ({ alert, onClose }) => {
  return alert.isLoading ? (
    <Snackbar open>
      <MuiAlert
        elevation={6}
        severity="info"
        icon={
          <div css={{ marginLeft: 12 }}>
            <CircularProgress />
          </div>
        }
      />
    </Snackbar>
  ) : (
    <Snackbar open={alert.open} onClose={onClose}>
      <MuiAlert elevation={6} variant="filled" severity={alert.severity}>
        {alert.messages.map((message) => (
          <p key={message}>{message}</p>
        ))}
      </MuiAlert>
    </Snackbar>
  );
};

export default Alert;
