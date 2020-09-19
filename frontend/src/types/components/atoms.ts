import { CSSProperties, ChangeEvent } from 'react';

export type ButtonProps = {
  submitText: string;
  style?: CSSProperties;
  color?: 'inherit' | 'primary' | 'secondary' | 'default' | undefined;
  contained?: boolean;
  href?: string;
  target?: string;
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
