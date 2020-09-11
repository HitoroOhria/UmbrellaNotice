/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { TextField } from "@material-ui/core";

import { DateInputProps } from "types/components/organisms";

const DateInput: FC<DateInputProps> = ({ label, value, idPref, onChange }) => {
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
