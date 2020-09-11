/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import {
  FormControl,
  Input,
  InputLabel,
  InputAdornment,
  IconButton,
} from "@material-ui/core";
import { Visibility, VisibilityOff } from "@material-ui/icons";

import { PasswordInputProps } from "types/components/organisms";

const PsswordInput: FC<PasswordInputProps> = ({
  label,
  showPassword,
  value,
  onChange,
  onIconClick,
  onMouseDownPassword,
}) => {
  return (
    <FormControl style={{ margin: "12px 0" }} fullWidth>
      <InputLabel htmlFor="standard-adornment-password">{label}</InputLabel>
      <Input
        id="standard-adornment-password"
        type={showPassword ? "text" : "password"}
        value={value}
        onChange={onChange}
        endAdornment={
          <InputAdornment position="end">
            <IconButton
              aria-label="toggle password visibility"
              onClick={onIconClick}
              onMouseDown={(event) => onMouseDownPassword(event)}
            >
              {showPassword ? <Visibility /> : <VisibilityOff />}
            </IconButton>
          </InputAdornment>
        }
      />
    </FormControl>
  );
};

export default PsswordInput;
