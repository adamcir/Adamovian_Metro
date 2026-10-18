local ASNP = AdamovskyASNP

function ASNP.BuildLoopline()
    local station = ASNP.GetStationName

    return {
        {
            Name = "Loop Line",
            Loop = true,

            {
                651,
                station(651),
                station(651),

                arr = {
                    {"next_651"},
                    {"next_651"}
                },

                dep = {
                    {"doors_closing", "next_652"},
                    {"doors_closing", "next_656"}
                }
            },

            {
                652,
                station(652),
                station(652),

                arr = {
                    {"next_652"},
                    {"next_652"}
                },

                dep = {
                    {"doors_closing", "next_653"},
                    {"doors_closing", "next_651"}
                }
            },

            {
                653,
                station(653),
                station(653),

                arr = {
                    {"next_653"},
                    {"next_653"}
                },

                dep = {
                    {"doors_closing", "next_654"},
                    {"doors_closing", "next_652"}
                }
            },

            {
                654,
                station(654),
                station(654),

                arr = {
                    {"next_654"},
                    {"next_654"}
                },

                dep = {
                    {"doors_closing", "next_655"},
                    {"doors_closing", "next_653"}
                }
            },

            {
                655,
                station(655),
                station(655),

                arr = {
                    {"next_655"},
                    {"next_655"}
                },

                dep = {
                    {"doors_closing", "next_656"},
                    {"doors_closing", "next_654"}
                }
            },

            {
                656,
                station(656),
                station(656),

                arr = {
                    {"next_656"},
                    {"next_656"}
                },

                dep = {
                    {"doors_closing", "next_651"},
                    {"doors_closing", "next_655"}
                }
            }
        }
    }
end
