/** @jsx jsx */
import React, { FC } from "react";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../../domain/entity/rootState";
import { jsx } from "@emotion/core";

import lineUserActions from "../../store/lineUser/actions";

import { TextField, Button } from "@material-ui/core";

const LineUser: FC<{ inputStyle: object; buttonStyle: object }> = ({
  inputStyle,
  buttonStyle,
}) => {
  const dispatch = useDispatch();
  const lineUser = useSelector((state: RootState) => state.lineUser);

  const handleChange = (serialNumber: string) => {
    dispatch(lineUserActions.setSerialNumber(serialNumber));
  };

  return lineUser.related ? (
    <div css={{ textAlign: "center" }}>
      <Button style={buttonStyle} fullWidth variant="contained">
        連携済みです！
      </Button>
    </div>
  ) : (
    <div>
      <TextField
        style={inputStyle}
        fullWidth
        label="シリアル番号"
        value={lineUser.serialNumber}
        onChange={(event) => handleChange(event.target.value)}
      />
      <div css={{ textAlign: "center" }}>
        <Button style={buttonStyle} variant="outlined" color="primary">
          連携する
        </Button>
      </div>
    </div>
  );
};

export default LineUser;
