module Option = struct
  type t =
    | LOG_PID
    | LOG_CONS
    | LOG_NDELAY
    | LOG_ODELAY
    | LOG_NOWAIT

  let string_of = function
    | LOG_PID -> "LOG_PID"
    | LOG_CONS -> "LOG_CONS"
    | LOG_NDELAY -> "LOG_NDELAY"
    | LOG_ODELAY -> "LOG_ODELAY"
    | LOG_NOWAIT -> "LOG_NOWAIT"
end

module Facility = struct
  type t =
    | LOG_KERN
    | LOG_USER
    | LOG_MAIL
    | LOG_NEWS
    | LOG_UUCP
    | LOG_DAEMON
    | LOG_AUTH
    | LOG_CRON
    | LOG_LPR
    | LOG_LOCAL0
    | LOG_LOCAL1
    | LOG_LOCAL2
    | LOG_LOCAL3
    | LOG_LOCAL4
    | LOG_LOCAL5
    | LOG_LOCAL6
    | LOG_LOCAL7

  let string_of = function
    | LOG_KERN -> "LOG_KERN"
    | LOG_USER -> "LOG_USER"
    | LOG_MAIL -> "LOG_MAIL"
    | LOG_NEWS -> "LOG_NEWS"
    | LOG_UUCP -> "LOG_UUCP"
    | LOG_DAEMON -> "LOG_DAEMON"
    | LOG_AUTH -> "LOG_AUTH"
    | LOG_CRON -> "LOG_CRON"
    | LOG_LPR -> "LOG_LPR"
    | LOG_LOCAL0 -> "LOG_LOCAL0"
    | LOG_LOCAL1 -> "LOG_LOCAL1"
    | LOG_LOCAL2 -> "LOG_LOCAL2"
    | LOG_LOCAL3 -> "LOG_LOCAL3"
    | LOG_LOCAL4 -> "LOG_LOCAL4"
    | LOG_LOCAL5 -> "LOG_LOCAL5"
    | LOG_LOCAL6 -> "LOG_LOCAL6"
    | LOG_LOCAL7 -> "LOG_LOCAL7"
end

module Level = struct
  type t =
    | LOG_EMERG
    | LOG_ALERT
    | LOG_CRIT
    | LOG_ERR
    | LOG_WARNING
    | LOG_NOTICE
    | LOG_INFO
    | LOG_DEBUG

  let rec upto x =
    match x with
    | LOG_EMERG -> x :: upto LOG_ALERT
    | LOG_ALERT -> x :: upto LOG_CRIT
    | LOG_CRIT -> x :: upto LOG_ERR
    | LOG_ERR -> x :: upto LOG_WARNING
    | LOG_WARNING -> x :: upto LOG_NOTICE
    | LOG_NOTICE -> x :: upto LOG_INFO
    | LOG_INFO -> x :: upto LOG_DEBUG
    | LOG_DEBUG -> [x]

  let string_of = function
    | LOG_EMERG -> "emerg"
    | LOG_ALERT -> "alert"
    | LOG_CRIT -> "crit"
    | LOG_ERR -> "err"
    | LOG_WARNING -> "warning"
    | LOG_NOTICE -> "notice"
    | LOG_INFO -> "info"
    | LOG_DEBUG -> "debug"
end

external openlog : ?ident:string -> Option.t list -> Facility.t -> unit = "ocaml_openlog"

external ocaml_syslog : Facility.t option -> Level.t -> string -> unit = "ocaml_syslog"

let syslog ?facility lvl = print_endline "osyslog"; Printf.ksprintf (ocaml_syslog facility lvl)

external closelog : unit -> unit = "ocaml_closelog"

external setlogmask : Level.t list -> Level.t list = "ocaml_setlogmask"

