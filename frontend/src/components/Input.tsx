/** @jsx jsx */
import { FC, ChangeEvent } from "react";
import { jsx } from "@emotion/core";

import { TextField } from "@material-ui/core";

type Props = {
  label: string;
  value: string;
  onChange: (event: ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => any;
};

const Input: FC<Props> = ({label, value, onChange}) => {
  return (
    <TextField
      style={{ margin: "12px 0" }}
      fullWidth
      label={label}
      value={value}
      onChange={onChange}
    />
  );
};

export default Input;
