/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";
import { useSelector, useDispatch } from "react-redux";

import MuiAlert from "@material-ui/lab/Alert";
import { Snackbar, CircularProgress } from "@material-ui/core";

import { RootState } from "../domain/entity/rootState";
import alertActions from "../store/alert/actions";

const Alert: FC = () => {
  const alert = useSelector((state: RootState) => state.alert);
  const dispatch = useDispatch();

  const handleClose = () => {
    dispatch(alertActions.closeAlert({}));
  };

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
    <Snackbar open={alert.open} onClose={handleClose}>
      <MuiAlert elevation={6} variant="filled" severity={alert.severity}>
        {alert.messages.map((message) => (
          <p key={message}>{message}</p>
        ))}
      </MuiAlert>
    </Snackbar>
  );
};

export default Alert;
