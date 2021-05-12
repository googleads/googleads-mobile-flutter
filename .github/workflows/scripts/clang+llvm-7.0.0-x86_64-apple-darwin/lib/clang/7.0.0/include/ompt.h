/*
 * include/50/ompt.h.var
 */

//===----------------------------------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.txt for details.
//
//===----------------------------------------------------------------------===//

#ifndef __OMPT__
#define __OMPT__

/*****************************************************************************
 * system include files
 *****************************************************************************/

#include <stdint.h>
#include <stddef.h>



/*****************************************************************************
 * iteration macros
 *****************************************************************************/

#define FOREACH_OMPT_INQUIRY_FN(macro)      \
    macro (ompt_enumerate_states)           \
    macro (ompt_enumerate_mutex_impls)      \
                                            \
    macro (ompt_set_callback)               \
    macro (ompt_get_callback)               \
                                            \
    macro (ompt_get_state)                  \
                                            \
    macro (ompt_get_parallel_info)          \
    macro (ompt_get_task_info)              \
    macro (ompt_get_thread_data)            \
    macro (ompt_get_unique_id)              \
                                            \
    macro(ompt_get_num_procs)               \
    macro(ompt_get_num_places)              \
    macro(ompt_get_place_proc_ids)          \
    macro(ompt_get_place_num)               \
    macro(ompt_get_partition_place_nums)    \
    macro(ompt_get_proc_id)                 \
                                            \
    macro(ompt_get_target_info)             \
    macro(ompt_get_num_devices)

#define FOREACH_OMP_STATE(macro)                                                                \
                                                                                                \
    /* first available state */                                                                 \
    macro (omp_state_undefined, 0x102)      /* undefined thread state */                        \
                                                                                                \
    /* work states (0..15) */                                                                   \
    macro (omp_state_work_serial, 0x000)    /* working outside parallel */                      \
    macro (omp_state_work_parallel, 0x001)  /* working within parallel */                       \
    macro (omp_state_work_reduction, 0x002) /* performing a reduction */                        \
                                                                                                \
    /* barrier wait states (16..31) */                                                          \
    macro (omp_state_wait_barrier, 0x010)   /* waiting at a barrier */                          \
    macro (omp_state_wait_barrier_implicit_parallel, 0x011)                                     \
                                            /* implicit barrier at the end of parallel region */\
    macro (omp_state_wait_barrier_implicit_workshare, 0x012)                                    \
                                            /* implicit barrier at the end of worksharing */    \
    macro (omp_state_wait_barrier_implicit, 0x013)  /* implicit barrier */                      \
    macro (omp_state_wait_barrier_explicit, 0x014)  /* explicit barrier */                      \
                                                                                                \
    /* task wait states (32..63) */                                                             \
    macro (omp_state_wait_taskwait, 0x020)  /* waiting at a taskwait */                         \
    macro (omp_state_wait_taskgroup, 0x021) /* waiting at a taskgroup */                        \
                                                                                                \
    /* mutex wait states (64..127) */                                                           \
    macro (omp_state_wait_mutex, 0x040)                                                         \
    macro (omp_state_wait_lock, 0x041)      /* waiting for lock */                              \
    macro (omp_state_wait_critical, 0x042)  /* waiting for critical */                          \
    macro (omp_state_wait_atomic, 0x043)    /* waiting for atomic */                            \
    macro (omp_state_wait_ordered, 0x044)   /* waiting for ordered */                           \
                                                                                                \
    /* target wait states (128..255) */                                                         \
    macro (omp_state_wait_target, 0x080)        /* waiting for target region */                 \
    macro (omp_state_wait_target_map, 0x081)    /* waiting for target data mapping operation */ \
    macro (omp_state_wait_target_update, 0x082) /* waiting for target update operation */       \
                                                                                                \
    /* misc (256..511) */                                                                       \
    macro (omp_state_idle, 0x100)           /* waiting for work */                              \
    macro (omp_state_overhead, 0x101)       /* overhead excluding wait states */                \
                                                                                                \
    /* implementation-specific states (512..) */


#define FOREACH_KMP_MUTEX_IMPL(macro)                                                \
    macro (ompt_mutex_impl_unknown, 0)     /* unknown implementation */              \
    macro (kmp_mutex_impl_spin, 1)         /* based on spin */                       \
    macro (kmp_mutex_impl_queuing, 2)      /* based on some fair policy */           \
    macro (kmp_mutex_impl_speculative, 3)  /* based on HW-supported speculation */

#define FOREACH_OMPT_EVENT(macro)                                                                                        \
                                                                                                                         \
    /*--- Mandatory Events ---*/                                                                                         \
    macro (ompt_callback_thread_begin,      ompt_callback_thread_begin_t,       1) /* thread begin                    */ \
    macro (ompt_callback_thread_end,        ompt_callback_thread_end_t,         2) /* thread end                      */ \
                                                                                                                         \
    macro (ompt_callback_parallel_begin,    ompt_callback_parallel_begin_t,     3) /* parallel begin                  */ \
    macro (ompt_callback_parallel_end,      ompt_callback_parallel_end_t,       4) /* parallel end                    */ \
                                                                                                                         \
    macro (ompt_callback_task_create,       ompt_callback_task_create_t,        5) /* task begin                      */ \
    macro (ompt_callback_task_schedule,     ompt_callback_task_schedule_t,      6) /* task schedule                   */ \
    macro (ompt_callback_implicit_task,     ompt_callback_implicit_task_t,      7) /* implicit task                   */ \
                                                                                                                         \
    macro (ompt_callback_target,            ompt_callback_target_t,             8) /* target                          */ \
    macro (ompt_callback_target_data_op,    ompt_callback_target_data_op_t,     9) /* target data op                  */ \
    macro (ompt_callback_target_submit,     ompt_callback_target_submit_t,     10) /* target  submit                  */ \
                                                                                                                         \
    macro (ompt_callback_control_tool,      ompt_callback_control_tool_t,      11) /* control tool                    */ \
                                                                                                                         \
    macro (ompt_callback_device_initialize, ompt_callback_device_initialize_t, 12) /* device initialize               */ \
    macro (ompt_callback_device_finalize,   ompt_callback_device_finalize_t,   13) /* device finalize                 */ \
                                                                                                                         \
    macro (ompt_callback_device_load,       ompt_callback_device_load_t,       14) /* device load                     */ \
    macro (ompt_callback_device_unload,     ompt_callback_device_unload_t,     15) /* device unload                   */ \
                                                                                                                         \
    /* Optional Events */                                                                                                \
    macro (ompt_callback_sync_region_wait,  ompt_callback_sync_region_t,       16) /* sync region wait begin or end   */ \
                                                                                                                         \
    macro (ompt_callback_mutex_released,    ompt_callback_mutex_t,             17) /* mutex released                  */ \
                                                                                                                         \
    macro (ompt_callback_task_dependences,  ompt_callback_task_dependences_t,  18) /* report task dependences         */ \
    macro (ompt_callback_task_dependence,   ompt_callback_task_dependence_t,   19) /* report task dependence          */ \
                                                                                                                         \
    macro (ompt_callback_work,              ompt_callback_work_t,              20) /* task at work begin or end       */ \
                                                                                                                         \
    macro (ompt_callback_master,            ompt_callback_master_t,            21) /* task at master begin or end     */ \
                                                                                                                         \
    macro (ompt_callback_target_map,        ompt_callback_target_map_t,        22) /* target map                      */ \
                                                                                                                         \
    macro (ompt_callback_sync_region,       ompt_callback_sync_region_t,       23) /* sync region begin or end        */ \
                                                                                                                         \
    macro (ompt_callback_lock_init,         ompt_callback_mutex_acquire_t,     24) /* lock init                       */ \
    macro (ompt_callback_lock_destroy,      ompt_callback_mutex_t,             25) /* lock destroy                    */ \
                                                                                                                         \
    macro (ompt_callback_mutex_acquire,     ompt_callback_mutex_acquire_t,     26) /* mutex acquire                   */ \
    macro (ompt_callback_mutex_acquired,    ompt_callback_mutex_t,             27) /* mutex acquired                  */ \
                                                                                                                         \
    macro (ompt_callback_nest_lock,         ompt_callback_nest_lock_t,         28) /* nest lock                       */ \
                                                                                                                         \
    macro (ompt_callback_flush,             ompt_callback_flush_t,             29) /* after executing flush           */ \
                                                                                                                         \
    macro (ompt_callback_cancel,            ompt_callback_cancel_t,            30) /* cancel innermost binding region */ \
    macro (ompt_callback_idle,              ompt_callback_idle_t,              31) /* begin or end idle state         */



/*****************************************************************************
 * data types
 *****************************************************************************/

/*---------------------
 * identifiers
 *---------------------*/

typedef uint64_t ompt_id_t;
#define ompt_id_none 0

typedef union ompt_data_t {
  uint64_t value; /* data initialized by runtime to unique id */
  void *ptr;      /* pointer under tool control */
} ompt_data_t;

static const ompt_data_t ompt_data_none = {0};

typedef uint64_t omp_wait_id_t;
static const omp_wait_id_t omp_wait_id_none = 0;

typedef void ompt_device_t;

/*---------------------
 * omp_frame_t
 *---------------------*/

typedef struct omp_frame_t {
    void *exit_frame;    /* next frame is user code     */
    void *enter_frame;   /* previous frame is user code */
} omp_frame_t;


/*---------------------
 * dependences types
 *---------------------*/

typedef enum ompt_task_dependence_flag_t {
    // a two bit field for the dependence type
    ompt_task_dependence_type_out   = 1,
    ompt_task_dependence_type_in    = 2,
    ompt_task_dependence_type_inout = 3,
} ompt_task_dependence_flag_t;

typedef struct ompt_task_dependence_t {
    void *variable_addr;
    unsigned int dependence_flags;
} ompt_task_dependence_t;


/*****************************************************************************
 * enumerations for thread states and runtime events
 *****************************************************************************/

/*---------------------
 * runtime states
 *---------------------*/

typedef enum {
#define omp_state_macro(state, code) state = code,
    FOREACH_OMP_STATE(omp_state_macro)
#undef omp_state_macro
} omp_state_t;


/*---------------------
 * runtime events
 *---------------------*/

typedef enum ompt_callbacks_e{
#define ompt_event_macro(event, callback, eventid) event = eventid,
    FOREACH_OMPT_EVENT(ompt_event_macro)
#undef ompt_event_macro
} ompt_callbacks_t;


/*---------------------
 * set callback results
 *---------------------*/
typedef enum ompt_set_result_t {
    ompt_set_error = 0,
    ompt_set_never = 1,
    ompt_set_sometimes = 2,
    ompt_set_sometimes_paired = 3,
    ompt_set_always = 4
} ompt_set_result_t;


/*----------------------
 * mutex implementations
 *----------------------*/
typedef enum kmp_mutex_impl_t {
#define kmp_mutex_impl_macro(impl, code) impl = code,
    FOREACH_KMP_MUTEX_IMPL(kmp_mutex_impl_macro)
#undef kmp_mutex_impl_macro
} kmp_mutex_impl_t;


/*****************************************************************************
 * callback signatures
 *****************************************************************************/

/* initialization */
typedef void (*ompt_interface_fn_t)(void);

typedef ompt_interface_fn_t (*ompt_function_lookup_t)(
    const char *                          /* entry point to look up              */
);

/* threads */
typedef enum ompt_thread_type_t {
    ompt_thread_initial = 1, // start the enumeration at 1
    ompt_thread_worker  = 2,
    ompt_thread_other   = 3,
    ompt_thread_unknown = 4
} ompt_thread_type_t;

typedef enum ompt_invoker_t {
    ompt_invoker_program = 1,             /* program invokes master task         */
    ompt_invoker_runtime = 2              /* runtime invokes master task         */
} ompt_invoker_t;

typedef void (*ompt_callback_thread_begin_t) (
    ompt_thread_type_t thread_type,       /* type of thread                      */
    ompt_data_t *thread_data              /* data of thread                      */
);

typedef void (*ompt_callback_thread_end_t) (
    ompt_data_t *thread_data              /* data of thread                      */
);

typedef void (*ompt_wait_callback_t) (
    omp_wait_id_t wait_id                /* wait data                           */
);

/* parallel and workshares */
typedef enum ompt_scope_endpoint_t {
    ompt_scope_begin = 1,
    ompt_scope_end   = 2
} ompt_scope_endpoint_t;


/* implicit task */
typedef void (*ompt_callback_implicit_task_t) (
    ompt_scope_endpoint_t endpoint,       /* endpoint of implicit task           */
    ompt_data_t *parallel_data,           /* data of parallel region             */
    ompt_data_t *task_data,               /* data of implicit task               */
    unsigned int team_size,               /* team size                           */
    unsigned int thread_num               /* thread number of calling thread     */
);

typedef void (*ompt_callback_parallel_begin_t) (
    ompt_data_t *encountering_task_data,         /* data of encountering task           */
    const omp_frame_t *encountering_task_frame,  /* frame data of encountering task     */
    ompt_data_t *parallel_data,                  /* data of parallel region             */
    unsigned int requested_team_size,            /* requested number of threads in team */
    ompt_invoker_t invoker,                      /* invoker of master task              */
    const void *codeptr_ra                       /* return address of runtime call      */
);

typedef void (*ompt_callback_parallel_end_t) (
    ompt_data_t *parallel_data,           /* data of parallel region             */
    ompt_data_t *encountering_task_data,  /* data of encountering task           */
    ompt_invoker_t invoker,               /* invoker of master task              */ 
    const void *codeptr_ra                /* return address of runtime call      */
);

/* tasks */
typedef enum ompt_task_type_t {
    ompt_task_initial    = 0x1,
    ompt_task_implicit   = 0x2,
    ompt_task_explicit   = 0x4,
    ompt_task_target     = 0x8,
    ompt_task_undeferred = 0x8000000,
    ompt_task_untied     = 0x10000000,
    ompt_task_final      = 0x20000000,
    ompt_task_mergeable  = 0x40000000,
    ompt_task_merged     = 0x80000000
} ompt_task_type_t;

typedef enum ompt_task_status_t {
    ompt_task_complete = 1,
    ompt_task_yield    = 2,
    ompt_task_cancel   = 3,
    ompt_task_others   = 4
} ompt_task_status_t;

typedef void (*ompt_callback_task_schedule_t) (
    ompt_data_t *prior_task_data,         /* data of prior task                  */
    ompt_task_status_t prior_task_status, /* status of prior task                */
    ompt_data_t *next_task_data           /* data of next task                   */
);

typedef void (*ompt_callback_task_create_t) (
    ompt_data_t *encountering_task_data,         /* data of parent task                 */
    const omp_frame_t *encountering_task_frame,  /* frame data for parent task          */
    ompt_data_t *new_task_data,                  /* data of created task                */
    int type,                                    /* type of created task                */
    int has_dependences,                         /* created task has dependences        */
    const void *codeptr_ra                       /* return address of runtime call      */
);

/* task dependences */
typedef void (*ompt_callback_task_dependences_t) (
    ompt_data_t *task_data,               /* data of task                        */
    const ompt_task_dependence_t *deps,   /* dependences of task                 */
    int ndeps                             /* dependences count of task           */
);

typedef void (*ompt_callback_task_dependence_t) (
    ompt_data_t *src_task_data,           /* data of source task                 */
    ompt_data_t *sink_task_data           /* data of sink task                   */
);

/* target and device */
typedef enum ompt_target_type_t {
    ompt_target = 1,
    ompt_target_enter_data = 2,
    ompt_target_exit_data = 3,
    ompt_target_update = 4
} ompt_target_type_t;

typedef void (*ompt_callback_target_t) (
    ompt_target_type_t kind,
    ompt_scope_endpoint_t endpoint,
    uint64_t device_num,
    ompt_data_t *task_data,
    ompt_id_t target_id,
    const void *codeptr_ra
);

typedef enum ompt_target_data_op_t {
    ompt_target_data_alloc = 1,
    ompt_target_data_transfer_to_dev = 2,
    ompt_target_data_transfer_from_dev = 3,
    ompt_target_data_delete = 4
} ompt_target_data_op_t;

typedef void (*ompt_callback_target_data_op_t) (
    ompt_id_t target_id,
    ompt_id_t host_op_id,
    ompt_target_data_op_t optype,
    void *host_addr,
    void *device_addr,
    size_t bytes
);

typedef void (*ompt_callback_target_submit_t) (
    ompt_id_t target_id,
    ompt_id_t host_op_id
);

typedef void (*ompt_callback_target_map_t) (
    ompt_id_t target_id,
    unsigned int nitems,
    void **host_addr,
    void **device_addr,
    size_t *bytes,
    unsigned int *mapping_flags
);

typedef void (*ompt_callback_device_initialize_t) (
    uint64_t device_num,
    const char *type,
    ompt_device_t *device,
    ompt_function_lookup_t lookup,
    const char *documentation
);

typedef void (*ompt_callback_device_finalize_t) (
    uint64_t device_num
);

typedef void (*ompt_callback_device_load_t) (
    uint64_t device_num,
    const char * filename,
    int64_t offset_in_file,
    void * vma_in_file,
    size_t bytes,
    void * host_addr,
    void * device_addr,
    uint64_t module_id
);

#define ompt_addr_unknown ((void *) ~0)

typedef void (*ompt_callback_device_unload_t) (
    uint64_t device_num,
    uint64_t module_id
);

/* control_tool */
typedef int (*ompt_callback_control_tool_t) (
    uint64_t command,                     /* command of control call             */
    uint64_t modifier,                    /* modifier of control call            */
    void *arg,                            /* argument of control call            */
    const void *codeptr_ra                /* return address of runtime call      */
);

typedef enum ompt_mutex_kind_t {
    ompt_mutex           = 0x10,
    ompt_mutex_lock      = 0x11,
    ompt_mutex_nest_lock = 0x12,
    ompt_mutex_critical  = 0x13,
    ompt_mutex_atomic    = 0x14,
    ompt_mutex_ordered   = 0x20
} ompt_mutex_kind_t;

typedef void (*ompt_callback_mutex_acquire_t) (
    ompt_mutex_kind_t kind,               /* mutex kind                          */
    unsigned int hint,                    /* mutex hint                          */
    unsigned int impl,                    /* mutex implementation                */
    omp_wait_id_t wait_id,               /* id of object being awaited          */
    const void *codeptr_ra                /* return address of runtime call      */
);

typedef void (*ompt_callback_mutex_t) (
    ompt_mutex_kind_t kind,               /* mutex kind                          */
    omp_wait_id_t wait_id,               /* id of object being awaited          */
    const void *codeptr_ra                /* return address of runtime call      */
);

typedef void (*ompt_callback_nest_lock_t) (
    ompt_scope_endpoint_t endpoint,       /* endpoint of nested lock             */
    omp_wait_id_t wait_id,               /* id of object being awaited          */
    const void *codeptr_ra                /* return address of runtime call      */
);

typedef void (*ompt_callback_master_t) (
    ompt_scope_endpoint_t endpoint,       /* endpoint of master region           */
    ompt_data_t *parallel_data,           /* data of parallel region             */
    ompt_data_t *task_data,               /* data of task                        */
    const void *codeptr_ra                /* return address of runtime call      */
);

typedef void (*ompt_callback_idle_t) (
    ompt_scope_endpoint_t endpoint        /* endpoint of idle time               */
);

typedef enum ompt_work_type_t {
    ompt_work_loop            = 1,
    ompt_work_sections        = 2,
    ompt_work_single_executor = 3,
    ompt_work_single_other    = 4,
    ompt_work_workshare       = 5,
    ompt_work_distribute      = 6,
    ompt_work_taskloop        = 7
} ompt_work_type_t;

typedef void (*ompt_callback_work_t) (
    ompt_work_type_t wstype,              /* type of work region                 */
    ompt_scope_endpoint_t endpoint,       /* endpoint of work region             */
    ompt_data_t *parallel_data,           /* data of parallel region             */
    ompt_data_t *task_data,               /* data of task                        */
    uint64_t count,                       /* quantity of work                    */
    const void *codeptr_ra                /* return address of runtime call      */
);

typedef enum ompt_sync_region_kind_t {
    ompt_sync_region_barrier   = 1,
    ompt_sync_region_taskwait  = 2,
    ompt_sync_region_taskgroup = 3
} ompt_sync_region_kind_t;

typedef void (*ompt_callback_sync_region_t) (
    ompt_sync_region_kind_t kind,         /* kind of sync region                 */
    ompt_scope_endpoint_t endpoint,       /* endpoint of sync region             */
    ompt_data_t *parallel_data,           /* data of parallel region             */
    ompt_data_t *task_data,               /* data of task                        */
    const void *codeptr_ra                /* return address of runtime call      */
);

typedef enum ompt_cancel_flag_t {
    ompt_cancel_parallel       = 0x1,
    ompt_cancel_sections       = 0x2,
    ompt_cancel_do             = 0x4,
    ompt_cancel_taskgroup      = 0x8,
    ompt_cancel_activated      = 0x10,
    ompt_cancel_detected       = 0x20,
    ompt_cancel_discarded_task = 0x40
} ompt_cancel_flag_t;

typedef void (*ompt_callback_cancel_t) (
    ompt_data_t *task_data,               /* data of task                        */
    int flags,                            /* cancel flags                        */
    const void *codeptr_ra                /* return address of runtime call      */
);

typedef void (*ompt_callback_flush_t) (
    ompt_data_t *thread_data,             /* data of thread                      */
    const void *codeptr_ra                /* return address of runtime call      */
);

/****************************************************************************
 * ompt API
 ***************************************************************************/

#ifdef  __cplusplus
extern "C" {
#endif

#define OMPT_API_FNTYPE(fn) fn##_t

#define OMPT_API_FUNCTION(return_type, fn, args)  \
    typedef return_type (*OMPT_API_FNTYPE(fn)) args



/****************************************************************************
 * INQUIRY FUNCTIONS
 ***************************************************************************/

/* state */
OMPT_API_FUNCTION(omp_state_t, ompt_get_state, (
    omp_wait_id_t *wait_id
));

/* thread */
OMPT_API_FUNCTION(ompt_data_t*, ompt_get_thread_data, (void));

/* parallel region */
OMPT_API_FUNCTION(int, ompt_get_parallel_info, (
    int ancestor_level,
    ompt_data_t **parallel_data,
    int *team_size
));

/* task */
OMPT_API_FUNCTION(int, ompt_get_task_info, (
    int ancestor_level,
    int *type,
    ompt_data_t **task_data,
    omp_frame_t **task_frame,
    ompt_data_t **parallel_data,
    int *thread_num
));

/* procs */
OMPT_API_FUNCTION(int, ompt_get_num_procs, (void));

/* places */
OMPT_API_FUNCTION(int, ompt_get_num_places, (void));

OMPT_API_FUNCTION(int, ompt_get_place_proc_ids, (
    int place_num,
    int ids_size,
    int *ids
));

OMPT_API_FUNCTION(int, ompt_get_place_num, (void));

OMPT_API_FUNCTION(int, ompt_get_partition_place_nums, (
    int place_nums_size,
    int *place_nums
));

/* proc_id */
OMPT_API_FUNCTION(int, ompt_get_proc_id, (void));


/****************************************************************************
 * INITIALIZATION FUNCTIONS
 ***************************************************************************/

OMPT_API_FUNCTION(int, ompt_initialize, (
    ompt_function_lookup_t ompt_fn_lookup,
    ompt_data_t *tool_data
));

OMPT_API_FUNCTION(void, ompt_finalize, (
    ompt_data_t *tool_data
));

typedef struct ompt_start_tool_result_t {
    ompt_initialize_t initialize;
    ompt_finalize_t finalize;
    ompt_data_t tool_data;
} ompt_start_tool_result_t;

/* initialization interface to be defined by tool */
#ifdef _WIN32
__declspec(dllexport)
#endif
ompt_start_tool_result_t * ompt_start_tool(
    unsigned int omp_version, 
    const char * runtime_version
);

typedef void (*ompt_callback_t)(void);

OMPT_API_FUNCTION(int, ompt_set_callback, (
    ompt_callbacks_t which,
    ompt_callback_t callback
));

OMPT_API_FUNCTION(int, ompt_get_callback, (
    ompt_callbacks_t which,
    ompt_callback_t *callback
));



/****************************************************************************
 * MISCELLANEOUS FUNCTIONS
 ***************************************************************************/

/* state enumeration */
OMPT_API_FUNCTION(int, ompt_enumerate_states, (
    int current_state,
    int *next_state,
    const char **next_state_name
));

/* mutex implementation enumeration */
OMPT_API_FUNCTION(int, ompt_enumerate_mutex_impls, (
    int current_impl,
    int *next_impl,
    const char **next_impl_name
));

/* get_unique_id */
OMPT_API_FUNCTION(uint64_t, ompt_get_unique_id, (void));

#ifdef  __cplusplus
};
#endif

/****************************************************************************
 * TARGET
 ***************************************************************************/

 OMPT_API_FUNCTION(int, ompt_get_target_info, (
    uint64_t *device_num,
    ompt_id_t *target_id,
    ompt_id_t *host_op_id
));

 OMPT_API_FUNCTION(int, ompt_get_num_devices, (void));

#endif /* __OMPT__ */
