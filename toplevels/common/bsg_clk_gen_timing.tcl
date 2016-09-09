
############################################
#
# bsg_clk_gen timing assertions
#
# note: you need to create the BSG_TAG clock first
#
#

proc bsg_clk_gen_clock_create { osc_path clk_name bsg_tag_clk_name clk_gen_period clock_uncertainty_percent } {

    # very little is actually timed with this domain; just the receive
    # side of the bsg_tag_client and the downsampler.
    #
    # Although the fastest target period of the oscillator itself is below
    # this, we don't want this support logic to not be able to keep up
    # in the event that oscillator runs faster than the tools say
    #

    # this is for the output of the downsampler, goes to the clock selection mux
    set clk_gen_period_ds [expr $clk_gen_period * 2]

    set suffix "/clk_gen_osc_inst/fdt/ICLK/Y"

    # this is for the output of the oscillator, which goes to the downsampler
    create_clock -period $clk_gen_period -name ${clk_name}_osc $osc_path$suffix
    set_clock_uncertainty  [expr ($clock_uncertainty_percent * $clk_gen_period) / 100.0] ${clk_name}_osc

    # these are generated clocks; we call them clocks to get preferred shielding and routing
    # nothing is actually timed with these

    create_clock -period $clk_gen_period_ds -name ${clk_name}_ds   [get_pins ${osc_path}/clk_gen_ds_inst/clk_r_o]
    set_clock_uncertainty  [expr ($clock_uncertainty_percent * $clk_gen_period) / 100.0] ${clk_name}_ds

    # the output of the mux is the externally visible bonafide clock
    create_clock -period $clk_gen_period    -name ${clk_name}  [get_pins ${osc_path}/clk_o]
    set_clock_uncertainty  [expr ($clock_uncertainty_percent * $clk_gen_period) / 100.0] ${clk_name}

    # two clock domains being crossed into via bsg_tag
    bsg_tag_add_client_cdc_timing_constraints $bsg_tag_clk_name ${clk_name}_osc
    bsg_tag_add_client_cdc_timing_constraints $bsg_tag_clk_name ${clk_name}_ds
}
