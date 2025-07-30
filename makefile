
fig_4_plot.pdf ::
	wolframscript -file ising_plot.wls

fig_1_decay_data.csv :: 
	wolframscript -file swap_decay_rate.wls
fig_2_and_3_evol_data.csv :: 
	wolframscript -file effective_evolution.wls
fig_1_inset.csv :: 
	wolframscript -file swap_coefficient.wls