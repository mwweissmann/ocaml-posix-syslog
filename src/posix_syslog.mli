module Option : sig
  type t =
    | LOG_PID
    | LOG_CONS
    | LOG_NDELAY
    | LOG_ODELAY
    | LOG_NOWAIT

  val string_of : t -> string
end

module Facility : sig
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

  val string_of : t -> string
end

module Level : sig
  type t =
    | LOG_EMERG
    | LOG_ALERT
    | LOG_CRIT
    | LOG_ERR
    | LOG_WARNING
    | LOG_NOTICE
    | LOG_INFO
    | LOG_DEBUG

  val upto : t -> t list

  val string_of : t -> string
end

val openlog : ?ident:string -> Option.t list -> Facility.t -> unit

val syslog : ?facility:Facility.t -> Level.t -> ('a, unit, string, unit) format4 -> 'a

val closelog : unit -> unit

val setlogmask : Level.t list -> Level.t list

