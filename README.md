# POSIX syslog bindings for OCaml

The ocaml-posix-syslog library provides bindings to [POSIX syslog](http://pubs.opengroup.org/onlinepubs/009695399/basedefs/syslog.h.html) for OCaml.

This library has been tested on Linux, but QNX, Solaris etc. should work, too.

Here is an example program that opens syslog and sends some messages to it:
```ocaml
open Posix_syslog

let _ =
  openlog ~ident:"test4716" [Option.LOG_CONS] Facility.LOG_USER;
  let old_mask = setlogmask Level.(upto LOG_DEBUG) in
  let rec loop n = function
    | 0 -> print_endline "done"
    | n ->
      syslog Level.LOG_INFO "some new message with a number %d" n;
      loop (n - 1)
  in
  loop 100;
  closelog ()
```

The source code of posix-syslog is available under the MIT license.

This library is originally written by [Markus Weissmann](http://www.mweissmann.de/)
