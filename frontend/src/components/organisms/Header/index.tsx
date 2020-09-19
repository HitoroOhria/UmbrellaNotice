/** @jsx jsx */
import { FC } from 'react';
import Link from 'next/link';
import { jsx } from '@emotion/core';

import { Button, IconButton } from '@material-ui/core';
import { Menu } from '@material-ui/icons';

import { HeaderProps } from 'types/components/organisms';

import { mediaQuery } from 'services/css';

const Header: FC<HeaderProps> = ({
  signedIn,
  menuIconOnTopView,
  onLogoClick,
  onMenuIconClick,
  onSginOutClick,
}) => {
  return (
    <header
      css={mediaQuery({
        backgroundColor: menuIconOnTopView ? undefined : '#2B2F4A',
        width: '100%',
        borderBottom: menuIconOnTopView ? undefined : '4px solid #968166',
        position: 'fixed',
        top: 0,
        zIndex: 2,
        padding: ['0 0 0 10px', '0 20px'],
        display: 'flex',
        justifyContent: 'space-between',
      })}
    >
      {/* APP LOGO */}
      <Link href='/'>
        <a
          css={{
            textDecoration: 'none',
            display: 'flex',
            justifyContent: 'space-between',
          }}
          onClick={onLogoClick}
        >
          {/* APP LOGO Image */}
          <img
            src={
              menuIconOnTopView
                ? '/images/appLogo.png'
                : '/images/appLogoWhite.png'
            }
            alt='logo'
            css={mediaQuery({
              width: [30, 45],
              height: [26, 40],
              marginTop: [6, 10],
            })}
          />
          {/* APP LOGO Name */}
          <div
            css={mediaQuery({
              margin: ['5px 0 0 8px', '0 0 0 8px'],
              color: menuIconOnTopView ? '#000' : '#fff',
              fontSize: '1.88rem',
              fontFamily: 'Lemonada',
            })}
          >
            Umbrella Notice
          </div>
        </a>
      </Link>
      {/* MENU Icon */}
      <div css={{ display: 'flex', justifyContent: 'space-between' }}>
        {/* TODO: SignedIn && ブラウザリロード -> SginOutButton is hidden. */}
        {signedIn && (
          <Button
            style={{
              color: '#fff',
              margin: '0',
              padding: '0',
            }}
            size='large'
            onClick={onSginOutClick}
          >
            Sign out
          </Button>
        )}
        <IconButton aria-label='menu' onClick={onMenuIconClick}>
          <Menu fontSize='large' style={{ color: '#fff' }} />
        </IconButton>
      </div>
    </header>
  );
};

export default Header;
