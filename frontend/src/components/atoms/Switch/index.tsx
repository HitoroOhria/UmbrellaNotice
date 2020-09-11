/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import { FormControlLabel, Switch as FSwitch } from "@material-ui/core";

import { SwitchProps } from "types/components/atoms";

const Switch: FC<SwitchProps> = ({ label, checked, onChange }) => {
  return (
    <FormControlLabel
      style={{ margin: "12px 0" }}
      value="start"
      control={
        <FSwitch color="primary" checked={checked} onChange={onChange} />
      }
      label={label}
      labelPlacement="start"
    />
  );
};

export default Switch;
