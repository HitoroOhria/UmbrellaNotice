/** @jsx jsx */
import { FC, ChangeEvent, MouseEvent } from "react";
import { jsx } from "@emotion/core";

import {
  FormControl,
  Input,
  InputLabel,
  InputAdornment,
  IconButton,
} from "@material-ui/core";
import { Visibility, VisibilityOff } from "@material-ui/icons";

type Props = {
  label: string;
  showPassword: boolean;
  value: string;
  onChange: (event: ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => any;
  onIconClick: () => any;
};

const PsswordInput: FC<Props> = ({
  label,
  showPassword,
  value,
  onChange,
  onIconClick,
}) => {
  const handleMouseDownPassword = (event: MouseEvent) => event.preventDefault();

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
              onMouseDown={(event) => handleMouseDownPassword(event)}
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
