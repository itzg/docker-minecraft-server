---
title: With websocket
---

With `WEBSOCKET_CONSOLE` set to `true`, logs can be streamed, and commands sent, over a websocket connection.
The API is available on `/console`.

## Password
A password must be supplied using the `Sec-WebSocket-Protocol` header. This is done by putting `mc-server-runner-ws-v1` in the first slot, and the password in the second. The password can be set with `RCON_PASSWORD` or `WEBSOCKET_PASSWORD`. The latter overwrites the former. Authentication can be disabled with `WEBSOCKET_DISABLE_AUTHENTICATION`.
??? Example "Examples"
    ```js title="JavaScript example"
    let socket = new WebSocket("http://localhost:80/websocket", ["mc-server-runner-ws-v1", "rcon-password"]);
    ```

## Allowed origins
A list of comma-separated allowed origins should be supplied with `WEBSOCKET_ALLOWED_ORIGINS`. Origin checking can be disabled with `WEBSOCKET_DISABLE_ORIGIN_CHECK`.

## Listen address
The listen address and port can be set with `WEBSOCKET_ADDRESS` (defaults to `0.0.0.0:80`), but it's recommended to listen on all interfaces when running in Docker.

## Log history
When a connection is established, the last 50 (by default, configurable with `WEBSOCKET_LOG_BUFFER_SIZE`) log lines are sent with a `logHistory` type message.

??? tip "Tip: Remember to forward the websocket port on the host"

    ```yaml title="compose.yaml"
    services:
      mc:
        ports:
          - '25565:25565'
          - '80:80'
    ```

## Environment variables
| Environment Variable               | Usage                                                      | Default      |
| ---------------------------------- | ---------------------------------------------------------- | ------------ |
| `WEBSOCKET_CONSOLE`                | Allow remote shell over websocket                          | `false`      |
| `WEBSOCKET_ADDRESS`                | Bind address for websocket server                          | `0.0.0.0:80` |
| `WEBSOCKET_DISABLE_ORIGIN_CHECK`   | Disable checking if origin is trusted                      | `false`      |
| `WEBSOCKET_ALLOWED_ORIGINS`        | Comma-separated list of trusted origins                    | ` `          |
| `WEBSOCKET_PASSWORD`               | Password will be the same as RCON_PASSWORD if unset        | ` `          |
| `WEBSOCKET_DISABLE_AUTHENTICATION` | Disable websocket authentication                           | `false`      |
| `WEBSOCKET_LOG_BUFFER_SIZE`        | Number of log lines to save and send to connecting clients | `50`         |

## API Schema
```ts title="API Schema"
interface StdinMessage {
  type: "stdin";
  data: string;
}

interface StdoutMessage {
  type: "stdout";
  data: string;
}

interface StderrMessage {
  type: "stderr";
  data: string;
}

interface LogHistoryMessage {
  type: "logHistory";
  lines: string[];
}

interface AuthFailureMessage {
  type: "authFailure";
  reason: string;
}

// Messages sent from Client -> Server
export type ClientMessage = StdinMessage;

// Messages sent from Server -> Client
export type ServerMessage =
  | StdoutMessage
  | StderrMessage
  | LogHistoryMessage
  | AuthFailureMessage;
```
