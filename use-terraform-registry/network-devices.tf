// 1. Setup : Network Definition
// 1.1 hub_names - add hub name, only one entry supported
// 1.2 leaf_names - upto 16 entires


variable "hub_names" {
  type        = list(string)
  default     = ["xr-regA_H1-Hub"]
  description = "Add hub name, only one entry supported"
}


// Leaf names
variable "leaf_names" {
  type = list(string)
  default = [
  "xr-regA_H1-L1",
  "xr-regA_H1-L2",
  "xr-regA_H1-L3",
  "xr-regA_H1-L4"
]
  description = "Add/Remove - leaf_names - upto 16 entires"
}

// Traffic Mode, L1Mode or  L2Mode
// Hub Bandwidth
// 

variable "hub_bandwidth" {
  type = map(map(object({
    hubdscgid     = string
    leafdscgid    = string
    hubdscidlist  = list(string)
    leafdscidlist = list(string)
    direction     = string // possible values: bidi, us, ds
  })))
  description = "Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the hub dscids to be assigned to the BW, and the hubdscgid and leafdscgid to be use to create the DSCG. Creates Hub and Leaf DSCGs"
  default = {
  xr-regA_H1-Hub = {
    xr-regA_H1-Hub-BW1 = { hubdscgid = "1", leafdscgid = "1", hubdscidlist = ["5", "1", "7", "3"], leafdscidlist = ["1", "2", "3", "4"], direction = "ds" },
    xr-regA_H1-Hub-BW2 = { hubdscgid = "2", leafdscgid = "1", hubdscidlist = ["9", "11", "13", "15"], leafdscidlist = ["1", "2", "3", "4"], direction = "ds" },
    xr-regA_H1-Hub-BW3 = { hubdscgid = "3", leafdscgid = "1", hubdscidlist = ["2", "4", "6", "8"], leafdscidlist = ["1", "2", "3", "4"], direction = "ds" },
    xr-regA_H1-Hub-BW4 = { hubdscgid = "4", leafdscgid = "1", hubdscidlist = ["14", "10", "12", "16"], leafdscidlist = ["1", "2", "3", "4"], direction = "ds" }
  }
}

}

// Leaf Bandwidth
variable "leaf_bandwidth" {
  // type        = map(map(list(string)))
  type = map(map(object({
    hubdscgid     = string
    leafdscgid    = string
    hubdscidlist  = list(string)
    leafdscidlist = list(string)
    direction     = string // possible values: bidi, us, ds
  })))
  description = "Defines the bandwidth to provisioned between Hub and each leaf. For each leaf, define the hub dscids to be assigned to the BW, and the hubdscgid and leafdscgid to be use to create the DSCG. Creates Hub and Leaf DSCGs"
  default = {
  xr-regA_H1-L1 = {
    xr-regA_H1-Hub-BW1 = { hubdscgid = "1", leafdscgid = "1", hubdscidlist = ["5", "1", "7", "3"], leafdscidlist = ["1", "2", "3", "4"], direction = "us" }
  }
  xr-regA_H1-L2 = {
    xr-regA_H1-Hub-BW2 = { hubdscgid = "2", leafdscgid = "1", hubdscidlist = ["9", "11", "13", "15"], leafdscidlist = ["1", "2", "3", "4"], direction = "us" }
  }
  xr-regA_H1-L3 = {
    xr-regA_H1-Hub-BW3 = { hubdscgid = "3", leafdscgid = "1", hubdscidlist = ["2", "4", "6", "8"], leafdscidlist = ["1", "2", "3", "4"], direction = "us" }
  }
  xr-regA_H1-L4 = {
    xr-regA_H1-Hub-BW4 = { hubdscgid = "4", leafdscgid = "1", hubdscidlist = ["14", "10", "12", "16"], leafdscidlist = ["1", "2", "3", "4"], direction = "us" }
  }
}
}


/*
// client-2-dscg defines the local connections:
// Common attributes: Initialize clientid, dscgid and lctype
// L2Mode: rest of the attributes used to create AC 
// Hub device = 
//  local connection id = 
//      client id
//      dscgid 
//Use case - XR VLAN P2P - VLAN Tagged, L2CP Carried, shared downlink capacity
*/
variable "client-2-dscg" {
  type = map(map(object({
    clientid = string
    dscgid   = string    
    lctype = optional(string)
    rate = optional(number)
    imc = optional(string)
    imc_outer_vid = optional(string)
    emc = optional(string)
    emc_outer_vid = optional(string)  
  })))
  description = "Defines the local connections for each node in the network. each conection include the cliend id and dscg id"


  default = {
      xr-regA_H1-Hub = {
      lc-XR-SFO_12-1234-1-ds = { // hub tx -> leaf 1/2/3/4 - 100G Shared downstream
        clientid = "1"        
        dscgid   = "1" 
        lctype = "uniDirDs"
        rate = 100
        imc = "MatchAll"
        imc_outer_vid = ""
        emc = ""
        emc_outer_vid = ""        
        }, 
      lc-XR-SFO_12-1-1-us = { // hub rcv <- leaf 1, 25G US
        clientid = "1"
        dscgid   = "3" // US DSCG ID      
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "100"        
        },
      lc-XR-SFO_12-2-1-us = { // hub rcv -> leaf 2, 25G US
        clientid = "1"
        dscgid   = "4" //DS DSCG ID                 
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "200"        
        },
      lc-XR-SFO_12-3-1-us = { // hub rcv -> leaf 3, 25G US
        clientid = "1"
        dscgid   = "6" //DS DSCG ID               
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "300"        
        },
      lc-XR-SFO_12-4-1-us = { // hub rcv -> leaf 4, 25G US
        clientid = "1"
        dscgid   = "8" //DS DSCG ID               
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "400"        
        },
      lc-XR-SFO_12-5678-1-ds = { // hub tx -> leaf 5/6/7/8 - 100G Shared downstream
        clientid = "2"        
        dscgid   = "2"       
        lctype = "uniDirDs"
        rate = 100
        imc = "MatchAll"
        imc_outer_vid = ""
        emc = ""
        emc_outer_vid = ""        
        }, 
      lc-XR-SFO_12-5-1-us = { // hub rcv <- leaf 5, 25G US
        clientid = "2"
        dscgid   = "10" // US DSCG ID       
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "500"        
        },
      lc-XR-SFO_12-6-1-us = { // hub rcv -> leaf 6, 25G US
        clientid = "2"
        dscgid   = "12" //DS DSCG ID             
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "600"        
        },
      lc-XR-SFO_12-7-1-us = { // hub rcv -> leaf 7, 25G US
        clientid = "2"
        dscgid   = "14" //DS DSCG ID              
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "700"        
        },
      lc-XR-SFO_12-8-1-us = { // hub rcv -> leaf 8, 25G US   
        clientid = "2"
        dscgid   = "16" //DS DSCG ID                
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "800"        
        },       
    }, // end Hub AC/LCs
    XR-SFO_12-1 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 1 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"     
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "100" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 1 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"      
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "100"
        emc = ""
        emc_outer_vid = "" 
      }      
    },
    XR-SFO_12-2 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 2 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"    
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "200" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 2 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"    
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "200"
        emc = ""
        emc_outer_vid = "" 
      }      
    },
    XR-SFO_12-3 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 3 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"     
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "300" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 3 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"
        lctype = "uniDirUs"      
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "300"
        emc = ""
        emc_outer_vid = "" 
      }      
    },  
    XR-SFO_12-4 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 4 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "400" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 4 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"        
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "400"
        emc = ""
        emc_outer_vid = "" 
      }      
    },
    XR-SFO_12-5 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 5 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "500" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 5 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "500"
        emc = ""
        emc_outer_vid = "" 
      }      
    },      
    XR-SFO_12-6 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 6 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "600" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 6 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"        
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "600"
        emc = ""
        emc_outer_vid = "" 
      }      
    }, 
    XR-SFO_12-7 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 7 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "700" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 7 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"       
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "700"
        emc = ""
        emc_outer_vid = "" 
      }      
    }, 
    XR-SFO_12-8 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 8 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "800" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 8 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"     
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "800"
        emc = ""
        emc_outer_vid = "" 
      }      
    } 
    xr-regA_H1-Hub = {
      lc-XR-SFO_12-1234-1-ds = { // hub tx -> leaf 1/2/3/4 - 100G Shared downstream
        clientid = "1"        
        dscgid   = "1" 
        lctype = "uniDirDs"
        rate = 100
        imc = "MatchAll"
        imc_outer_vid = ""
        emc = ""
        emc_outer_vid = ""        
        }, 
      lc-XR-SFO_12-1-1-us = { // hub rcv <- leaf 1, 25G US
        clientid = "1"
        dscgid   = "3" // US DSCG ID      
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "100"        
        },
      lc-XR-SFO_12-2-1-us = { // hub rcv -> leaf 2, 25G US
        clientid = "1"
        dscgid   = "4" //DS DSCG ID                 
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "200"        
        },
      lc-XR-SFO_12-3-1-us = { // hub rcv -> leaf 3, 25G US
        clientid = "1"
        dscgid   = "6" //DS DSCG ID               
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "300"        
        },
      lc-XR-SFO_12-4-1-us = { // hub rcv -> leaf 4, 25G US
        clientid = "1"
        dscgid   = "8" //DS DSCG ID               
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "400"        
        },
      lc-XR-SFO_12-5678-1-ds = { // hub tx -> leaf 5/6/7/8 - 100G Shared downstream
        clientid = "2"        
        dscgid   = "2"       
        lctype = "uniDirDs"
        rate = 100
        imc = "MatchAll"
        imc_outer_vid = ""
        emc = ""
        emc_outer_vid = ""        
        }, 
      lc-XR-SFO_12-5-1-us = { // hub rcv <- leaf 5, 25G US
        clientid = "2"
        dscgid   = "10" // US DSCG ID       
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "500"        
        },
      lc-XR-SFO_12-6-1-us = { // hub rcv -> leaf 6, 25G US
        clientid = "2"
        dscgid   = "12" //DS DSCG ID             
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "600"        
        },
      lc-XR-SFO_12-7-1-us = { // hub rcv -> leaf 7, 25G US
        clientid = "2"
        dscgid   = "14" //DS DSCG ID              
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "700"        
        },
      lc-XR-SFO_12-8-1-us = { // hub rcv -> leaf 8, 25G US   
        clientid = "2"
        dscgid   = "16" //DS DSCG ID                
        lctype = "uniDirUs"
        rate = 25
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "800"        
        },       
    }, // end Hub AC/LCs
    XR-SFO_12-1 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 1 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"     
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "100" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 1 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"      
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "100"
        emc = ""
        emc_outer_vid = "" 
      }      
    },
    XR-SFO_12-2 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 2 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"    
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "200" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 2 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"    
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "200"
        emc = ""
        emc_outer_vid = "" 
      }      
    },
    XR-SFO_12-3 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 3 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"     
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "300" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 3 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"
        lctype = "uniDirUs"      
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "300"
        emc = ""
        emc_outer_vid = "" 
      }      
    },  
    XR-SFO_12-4 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 4 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "400" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 4 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"        
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "400"
        emc = ""
        emc_outer_vid = "" 
      }      
    },
    XR-SFO_12-5 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 5 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "500" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 5 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "500"
        emc = ""
        emc_outer_vid = "" 
      }      
    },      
    XR-SFO_12-6 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 6 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "600" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 6 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"        
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "600"
        emc = ""
        emc_outer_vid = "" 
      }      
    }, 
    XR-SFO_12-7 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 7 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "700" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 7 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"       
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "700"
        emc = ""
        emc_outer_vid = "" 
      }      
    }, 
    XR-SFO_12-8 = {
      lc-xr-regA_H1-Hub-ds-1 = { // leaf 8 rcv <- hub, 100G shared DS 
        clientid = "1"        
        dscgid   = "1"       
        lctype = "uniDirDs"
        rate = 100
        imc = ""
        imc_outer_vid = ""
        emc = "MatchOuterVID"
        emc_outer_vid = "800" 
      },
      lc-xr-regA_H1-Hub-us-1 = { // leaf 8 tx -> hub, 25G shared DS 
        clientid = "1"        
        dscgid   = "2"     
        lctype = "uniDirUs"
        rate = 25
        imc = "MatchOuterVID"
        imc_outer_vid = "800"
        emc = ""
        emc_outer_vid = "" 
      }      
    } 
  }
}


/* Hub
XR-T1 x XR-L1-C1-DSCG1
XR-T2 x XR-L1-C1-DSCG2
XR-T3 x XR-L1-C1-DSCG3

Leaf 1
XR-T1 x XR-L1-C1-DSCG1

Leaf 2
XR-T1 x XR-L1-C1-DSCG1

Leaf 3
XR-T1 x XR-L1-C1-DSCG1

*/
