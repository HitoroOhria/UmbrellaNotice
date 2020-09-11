/** @jsx jsx */
import { FC } from "react";
import { jsx } from "@emotion/core";

import Button from "@/atoms/Button";
import Switch from "@/atoms/Switch";
import Input from "@/organisms/Input";
import DateInput from "@/organisms/DateInput";
import Paper from "@/organisms/Paper";

import { WEATHER_LABEL } from "constants/weather";

import { WeatherEditorProps } from "types/components/pages";

const WeatherEditor: FC<WeatherEditorProps> = ({
  lineUser,
  weather,
  onLineUserChange,
  onWeatherChange,
  onSilentNoticeChange,
  onWeatherEditorClick,
}) => {
  return lineUser.relatedUser ? (
    <div>
      <Input
        label={WEATHER_LABEL.LOCATION}
        value={weather.city}
        onChange={(event) => onWeatherChange({ city: event.target.value })}
      />
      <DateInput
        label={WEATHER_LABEL.NOTICE_TIME}
        value={lineUser.noticeTime}
        idPref={"line_user"}
        onChange={(event) =>
          onLineUserChange({ noticeTime: event.target.value })
        }
      />
      <Switch
        label={WEATHER_LABEL.SILENT_NOTICE}
        checked={lineUser.silentNotice}
        onChange={onSilentNoticeChange}
      />
      <Button submitText={"変更する"} onClick={onWeatherEditorClick} />
    </div>
  ) : (
    <div css={{ marginTop: 20 }}>
      <Paper>
        <p>LINEアカウントと連携してください！</p>
      </Paper>
    </div>
  );
};

export default WeatherEditor;
