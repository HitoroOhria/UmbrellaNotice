/** @jsx jsx */
import React, { FC } from "react";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../../domain/entity/rootState";
import { jsx } from "@emotion/core";

import { TextField, Switch, FormControlLabel, Button } from "@material-ui/core";

import weahterActions from "../../store/weather/actions";
import { WeatherState } from "../../domain/entity/weather";
import { WEATHER_LABEL } from "../../domain/services/weather";

const User: FC<{ inputStyle: object, buttonStyle: object}> = ({ inputStyle, buttonStyle }) => {
  const dispatch = useDispatch();
  const weather = useSelector((state: RootState) => state.weather);

  const handleChange = (member: Partial<WeatherState>) =>
    dispatch(weahterActions.setWeatherValue(member));

  const toggleChecked = () => dispatch(weahterActions.toggleSilentNotice({}));

  return (
    <div>
      <TextField
        style={inputStyle}
        fullWidth
        label={WEATHER_LABEL.LOCATION}
        value={weather.location}
        onChange={(event) => handleChange({ location: event.target.value })}
      />
      <TextField
        style={inputStyle}
        fullWidth
        id="time"
        label={WEATHER_LABEL.NOTICE_TIME}
        type="time"
        defaultValue={weather.noticeTime}
        InputLabelProps={{ shrink: true }}
        inputProps={{ step: 300 }} // 5 min
      />
      <FormControlLabel
        style={inputStyle}
        value="start"
        control={
          <Switch
            color="primary"
            checked={weather.silentNotice}
            onChange={toggleChecked}
          />
        }
        label={WEATHER_LABEL.SILENT_NOTICE}
        labelPlacement="start"
      />
      <div css={{ textAlign: "center" }}>
            <Button
              style={buttonStyle}
              // onClick={handleSave}
              variant="outlined"
              color="primary"
            >
              変更する
            </Button>
          </div>
    </div>
  );
};

export default User;
