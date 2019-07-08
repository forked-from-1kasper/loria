local ie = minetest.request_insecure_environment()
if not ie then
    error("Electricity mod requires access to insecure functions in order "..
          "to work. Please add the electricity mod to your secure.trusted_mods.")
end

local ffi = ie.require("ffi")

local shared_filename
if jit.os == "Windows" then
    shared_filename = "ngspice"
elseif jit.os == "OSX" or jit.os == "Linux" then
    shared_filename = "libngspice"
else
    shared_filename = "ngspice"
end

local ngspice = ffi.load(minetest.get_modpath("electricity").."/" .. shared_filename)

-- sharedspice.h
ffi.cdef[[
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
    bool ngSpice_SetBkpt(double time);
]]

local prefix_length = #"stdXXX "

device_info = { }

local printfcn = ffi.cast("SendChar*",
    function(str, id, p)
        local s = ffi.string(str)
        local prefix = s:sub(1, prefix_length)
        local info = s:sub(prefix_length + 1)

        if prefix == "stderr " then
            minetest.log("verbose", string.format("ng: SendChar: %s", info))
        else
            local name, value = info:match("^([^ ]+)%s+=%s+([+-]?[^ ]+)")
            if name and value then
                if not device_info[name] then
                    device_info[name] = { }
                end
                device_info[name].U = tonumber(value)
            end

            minetest.log("info", string.format("ng: SendChar: %s", info))
        end

        return 1
    end
)

local ngexit = ffi.cast("ControlledExit*",
    function(status, immediateunload, quit, id, p)
        minetest.log(string.format("ng: ControlledExit: id = %d", id))
        return 0
    end
)

ngspice.ngSpice_Init(printfcn, nil, ngexit, nil, nil, nil, nil)

function c_lit(str)
    return ffi.new("char[?]", #str + 1, str)
end

function ngspice_circ(circ)
    local circ = map(c_lit, circ)
    table.insert(circ, ffi.cast("char*", 0))
    local c_circuit = ffi.new("char*[?]", #circ, circ)

    ngspice.ngSpice_Circ(c_circuit)
end

function ngspice_command(str)
    local lit = c_lit(str)
    ngspice.ngSpice_Command(lit)
end

ngspice_command("set nomoremode")

dofile(minetest.get_modpath("electricity").."/ngspice.lua")
dofile(minetest.get_modpath("electricity").."/functions.lua")
dofile(minetest.get_modpath("electricity").."/sim.lua")
dofile(minetest.get_modpath("electricity").."/ground.lua")
dofile(minetest.get_modpath("electricity").."/switch.lua")
dofile(minetest.get_modpath("electricity").."/battery.lua")
dofile(minetest.get_modpath("electricity").."/transformer.lua")
dofile(minetest.get_modpath("electricity").."/infinite.lua")
dofile(minetest.get_modpath("electricity").."/riteg.lua")
dofile(minetest.get_modpath("electricity").."/cables.lua")
dofile(minetest.get_modpath("electricity").."/accumulator.lua")
dofile(minetest.get_modpath("electricity").."/lamp.lua")
dofile(minetest.get_modpath("electricity").."/multimeter.lua")