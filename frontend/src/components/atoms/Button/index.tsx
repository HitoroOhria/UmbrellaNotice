/** @jsx jsx */
import { FC } from 'react';
import { jsx } from '@emotion/core';

import { Button as FButton } from '@material-ui/core';

import { ButtonProps } from 'types/components/atoms';

const Button: FC<ButtonProps> = ({
  submitText,
  style,
  color,
  contained,
  href,
  target,
  onClick,
}) => {
  return (
    <div css={{ textAlign: 'center' }}>
      <FButton
        style={{ width: '70%', margin: '32px auto', ...style }}
        onClick={onClick}
        variant={contained ? 'contained' : 'outlined'}
        color={color || 'primary'}
        href={href || ''}
        target={target}
      >
        {submitText}
      </FButton>
    </div>
  );
};

export default Button;
