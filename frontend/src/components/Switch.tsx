/** @jsx jsx */
import { FC, ChangeEvent } from "react";
import { jsx } from "@emotion/core";

import { FormControlLabel, Switch as FSwitch } from "@material-ui/core";

type Props = {
  label: string;
  checked: boolean;
  onChange: (event: ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => any;
};

const Switch: FC<Props> = ({label, checked, onChange}) => {
  return (
    <FormControlLabel
        style={{ margin: "12px 0" }}
        value="start"
        control={
          <FSwitch
            color="primary"
            checked={checked}
            onChange={onChange}
          />
        }
        label={label}
        labelPlacement="start"
      />
  );
};

export default Switch;
