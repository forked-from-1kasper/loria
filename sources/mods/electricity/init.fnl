(require-macros :useful-macros)

(local ie (minetest.request_insecure_environment))
(when (not ie)
  (error (.. "Electricity mod requires access to insecure functions in order "
             "to work. Please add the electricity mod to your secure.trusted_mods.")))

(local-require ffi)

(local shared-filename
  (match jit.os
    :Windows "ngspice"
    :OSX     "libngspice.0.dylib"
    _        "libngspice.so"))

;; “../../..” is “.minetest/games”
(local libpath (.. (minetest.get_modpath :electricity) "/../../../" shared-filename))
(local ngspice (ffi.load libpath))

;; sharedspice.h
(ffi.cdef "
    struct ngcomplex {
        double cx_real;
        double cx_imag;
    };

    typedef struct ngcomplex ngcomplex_t;

    typedef struct vector_info {
        char *v_name;
        int v_type;
        short v_flags;
        double *v_realdata;
        ngcomplex_t *v_compdata;
        int v_length;
    } vector_info, *pvector_info;

    typedef struct vecvalues {
        char* name;
        double creal;
        double cimag;
        bool is_scale;
        bool is_complex;
    } vecvalues, *pvecvalues;

    typedef struct vecvaluesall {
        int veccount;
        int vecindex;
        pvecvalues *vecsa;
    } vecvaluesall, *pvecvaluesall;

    typedef struct vecinfo
    {
        int number;
        char *vecname;
        bool is_real;
        void *pdvec;
        void *pdvecscale;
    } vecinfo, *pvecinfo;

    typedef struct vecinfoall
    {
        char *name;
        char *title;
        char *date;
        char *type;
        int veccount;
        pvecinfo *vecs;
    
    } vecinfoall, *pvecinfoall;

    typedef int (SendChar)(char*, int, void*);
    typedef int (SendStat)(char*, int, void*);
    typedef int (ControlledExit)(int, bool, bool, int, void*);
    typedef int (SendData)(pvecvaluesall, int, int, void*);
    typedef int (SendInitData)(pvecinfoall, int, void*);
    typedef int (BGThreadRunning)(bool, int, void*);
    typedef int (GetVSRCData)(double*, double, char*, int, void*);
    typedef int (GetISRCData)(double*, double, char*, int, void*);
    typedef int (GetSyncData)(double, double*, double, int, int, int, void*);

    int ngSpice_Init(
        SendChar* printfcn, SendStat* statfcn, ControlledExit* ngexit,
        SendData* sdata, SendInitData* sinitdata, BGThreadRunning* bgtrun,
        void* userData
    );
    int ngSpice_Init_Sync(GetVSRCData *vsrcdat, GetISRCData *isrcdat, GetSyncData *syncdat, int *ident, void *userData);
    int ngSpice_Command(char* command);
    pvector_info ngGet_Vec_Info(char* vecname);
    int ngSpice_Circ(char** circarray);
    char* ngSpice_CurPlot(void);
    char** ngSpice_AllPlots(void);
    char** ngSpice_AllVecs(char* plotname);
    bool ngSpice_running(void);
    bool ngSpice_SetBkpt(double time); ")

(local prefix-length (length "stdXXX "))

(global ngparsed {})

(ffi-proc printfcn "SendChar*" [str id p]
  (let [s (ffi.string str)
        prefix (s:sub 1 prefix-length)
        info (s:sub (+ prefix-length 1))]
    (if (= prefix "stderr ")
        (->> (string.format "ng: SendChar: %s" info) (minetest.log "verbose"))
        (let [(name field value) (info:match "^([^ -]+)-([^ ]+)%s+=%s+([+-]?[^ ]+)")]
          (when (∧ name value)
            (when (∉ name ngparsed)
              (tset ngparsed name {}))
            (tset ngparsed name field (tonumber value)))

          (minetest.log "info" (string.format "ng: SendChar: %s" info))))
    1))

(ffi-proc ngexit "ControlledExit*" [status immediateunload quit id p]
  (minetest.log (string.format "ng: ControlledExit: id = %d" id))
  0)

(ngspice.ngSpice_Init printfcn nil ngexit nil nil nil nil)

(fn c-lit [str]
  (ffi.new "char[?]" (+ (length str) 1) str))

(defun ngspice_circ [circ]
  (foreach (comp (partial minetest.log "info")
                 (partial string.format "ng: User: %s")) circ)
  (var circ (map c-lit circ))
  (table.insert circ (ffi.cast "char*" 0))

  (ngspice.ngSpice_Circ (ffi.new "char*[?]" (length circ) circ)))

(defun ngspice_command [str]
  (ngspice.ngSpice_Command (c-lit str)))

(defun ngflush []
  (ngspice_command "destroy all")
  (ngspice_command "remcirc")
  (each [key _ (pairs ngparsed)]
    (tset ngparsed key nil)))

(defun initdevice [device-name pos]
  (tset ngparsed device-name { :pos pos }))

(ngspice_command "set nomoremode")
(import :electricity
  "ngspice" "functions" "sim"
  "ground" "switch" "battery"
  "transformer" "infinite" "resistor"
  "riteg" "cables" "accumulator"
  "lamp" "multimeter")