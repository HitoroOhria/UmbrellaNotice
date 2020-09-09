/** @jsx jsx */
import { FC, ChangeEvent } from "react";
import { jsx } from "@emotion/core";

import { TextField } from "@material-ui/core";

type Props = {
  label: string;
  value: string;
  idPref: string;
  onChange: (event: ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => any;
};

const DateInput: FC<Props> = ({ label, value, idPref, onChange }) => {
  return (
    <TextField
      style={{ margin: "12px 0" }}
      fullWidth
      id={`${idPref}-time`}
      label={label}
      type="time"
      value={value}
      onChange={onChange}
      InputLabelProps={{ shrink: true }}
      inputProps={{ step: 300 }} // 5 min
    />
  );
};

export default DateInput;
