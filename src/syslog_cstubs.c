#include <assert.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <syslog.h>
#include <limits.h>
#include <errno.h>

#include <caml/alloc.h>
#include <caml/fail.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/unixsupport.h>
#include <caml/threads.h>
#include <caml/signals.h>
#include <caml/custom.h>

#define Val_none Val_int(0)
#define Some_val(v) Field(v,0)

static int options_table[5] = {
  LOG_PID,
  LOG_CONS,
  LOG_NDELAY,
  LOG_ODELAY,
  LOG_NOWAIT
};

static int facility_table[17] = {
  LOG_KERN,
  LOG_USER,
  LOG_MAIL,
  LOG_NEWS,
  LOG_UUCP,
  LOG_DAEMON,
  LOG_AUTH,
  LOG_CRON,
  LOG_LPR,
  LOG_LOCAL0,
  LOG_LOCAL1,
  LOG_LOCAL2,
  LOG_LOCAL3,
  LOG_LOCAL4,
  LOG_LOCAL5,
  LOG_LOCAL6,
  LOG_LOCAL7
};

static int level_table[8] = {
  LOG_EMERG,
  LOG_ALERT,
  LOG_CRIT,
  LOG_ERR,
  LOG_WARNING,
  LOG_NOTICE,
  LOG_INFO,
  LOG_DEBUG
};

static int mask_table[8] = {
  LOG_MASK(LOG_EMERG),
  LOG_MASK(LOG_ALERT),
  LOG_MASK(LOG_CRIT),
  LOG_MASK(LOG_ERR),
  LOG_MASK(LOG_WARNING),
  LOG_MASK(LOG_NOTICE),
  LOG_MASK(LOG_INFO),
  LOG_MASK(LOG_DEBUG)
};

CAMLprim value ocaml_setlogmask(value lvl) {
  CAMLparam1(lvl);
  CAMLlocal2(cli, cons);
  int mask, nmask;
  size_t i;

  mask = caml_convert_flag_list(lvl, mask_table);

  caml_release_runtime_system();
  nmask = setlogmask(mask);
  caml_acquire_runtime_system();

  cli = Val_emptylist;
  for (i = 0; i < (sizeof(mask_table) / sizeof(int)); i++) {
    if ((mask_table[i] & nmask) == mask_table[i]) {
      cons = caml_alloc(2, 0);

      Store_field(cons, 0, Val_int(i));
      Store_field(cons, 1, cli);

      cli = cons;
    }
  }
  
  CAMLreturn(cli);
}

CAMLprim value ocaml_openlog(value string, value options, value facility) {
  CAMLparam3(string, options, facility);
  int voption, vfacility, index_facility;
  char *ident;

  ident = (Val_none == string) ? NULL : String_val(Some_val(string));

  voption = caml_convert_flag_list(options, options_table);
  index_facility = Int_val(facility);
  assert(index_facility < (sizeof(facility_table) / sizeof(int)));
  vfacility = facility_table[index_facility];

  caml_release_runtime_system();
  openlog(ident, voption, vfacility);
  caml_acquire_runtime_system();

  CAMLreturn(Val_unit);
}

CAMLprim value ocaml_closelog(void) {
  CAMLparam0();
  closelog();
  CAMLreturn(Val_unit);
}

CAMLprim value ocaml_syslog(value facility, value lvl, value string) {
  CAMLparam3(facility, lvl, string);
  int vfacility, vlevel;
  int index_lvl, index_facility;

  vfacility = 0;
  if (Val_none != facility) {
    index_facility = Int_val(Some_val(facility));
    assert(index_facility < (sizeof(facility_table) / sizeof(int)));
    vfacility = facility_table[index_facility];
  }

  index_lvl = Int_val(lvl);
  assert(index_lvl < (sizeof(level_table) / sizeof(int)));
  vlevel = level_table[index_lvl];

  syslog(vlevel | vfacility, "%s", String_val(string));

  CAMLreturn(Val_unit);
}

