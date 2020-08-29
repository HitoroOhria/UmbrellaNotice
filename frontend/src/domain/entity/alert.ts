export type AlertState = {
  severity: AlertSeverity;
  messages: string[];
  open: boolean;
};

export type AlertSeverity = "error" | "warning" | "info" | "success";
