/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import {
  TextField,
  FormControl,
  Input as FInput,
  InputLabel,
  InputAdornment,
} from "@material-ui/core";

import Information from "@/atoms/information";

import { InputProps } from "types/components/organisms";

const Input: FC<InputProps> = ({ label, value, onChange, info, text }) => {
  return info && text ? (
    <FormControl style={{ margin: "12px 0" }} fullWidth>
      <InputLabel htmlFor="standard-adornment-password">{label}</InputLabel>
      <FInput
        value={value}
        onChange={onChange}
        endAdornment={
          <InputAdornment position="end">
            <Information text={text} />
          </InputAdornment>
        }
      />
    </FormControl>
  ) : (
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
