import { FC } from "react";
import { useSelector, useDispatch } from "react-redux";
import MuiAlert from "@material-ui/lab/Alert";
import { Snackbar } from "@material-ui/core";

import { RootState } from "../domain/entity/rootState";
import alertActions from "../store/alert/actions";

const Alert: FC = () => {
  const alert = useSelector((state: RootState) => state.alert);
  const dispatch = useDispatch();

  const handleClose = () => {
    dispatch(alertActions.closeAlert({}));
  };

  return (
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
