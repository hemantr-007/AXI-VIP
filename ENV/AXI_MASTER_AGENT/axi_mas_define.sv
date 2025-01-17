/////////////////////////////////////////////
//Name :- HEMANT RATHOD 
//Project :- AXI_MAS_DEFINE
//Company :- INDEEKSHA 
//Submitted to :- VISHNU SIR
/////////////////////////////////////////////

`ifndef AXI_MAS_DEFINE_SV
`define AXI_MAS_DEFINE_SV 

typedef enum bit [1:0] {SINGLE, INCR, WRAP}burst_type;
typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR, DECERR}wresp_type; //Write/Ready response both working.

`endif