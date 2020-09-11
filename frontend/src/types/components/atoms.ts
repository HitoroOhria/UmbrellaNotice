import { ChangeEvent } from "react";

export type ButtonProps = {
  submitText: string;
  contained?: boolean;
  onClick?: () => any;
};

export type InformationProps = {
    text: string;
  };

export type SwitchProps = {
  label: string;
  checked: boolean;
  onChange: (event: ChangeEvent<HTMLTextAreaElement | HTMLInputElement>) => any;
};
