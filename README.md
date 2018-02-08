# POSIX syslog bindings for OCaml

The ocaml-posix-syslog library provides bindings to [POSIX syslog](http://pubs.opengroup.org/onlinepubs/009695399/basedefs/syslog.h.html) for OCaml.

This library has been tested on Linux, but QNX, Solaris etc. should work, too.

Here is an example program that opens syslog and sends some messages to it:
```ocaml
open Posix_syslog

let _ =
  openlog ~ident:"test4716" [Option.LOG_CONS] Facility.LOG_USER;
  let old_mask = setlogmask Level.(upto LOG_NOTICE) in
  let rec loop n = function
    | 0 -> print_endline "done"
    | n ->
      syslog Level.LOG_INFO "some new message with a number %d" n;
      loop (n - 1)
  in
  loop 100;
  closelog ()
```

## API
```ocaml
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
```

The source code of posix-syslog is available under the MIT license.

This library is originally written by [Markus Weissmann](http://www.mweissmann.de/)

