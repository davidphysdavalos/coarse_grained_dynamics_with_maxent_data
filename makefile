fig_1_decay_data.csv :: 
	wolframscript -file swap_decay_rate.wls
fig_1_inset.csv :: 
	wolframscript -file swap_coefficient.wls
fig_2_and_3_evol_data.csv :: 
	wolframscript -file effective_evolution.wls
fig_4_ising_data.csv :: 
	wolframscript -file ising.wls
fig_5_convergence.csv ::
	wolframscript -file ising_convergence.wls #Also generates the inset
fig_5_inset_convergence.csv ::
	wolframscript -file ising_convergence.wls #This calls the script above too
