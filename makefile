#Build everything
all: fig1 fig2 fig3 fig4 fig5

fig1: fig_1_decay_data.csv fig_1_inset.csv

fig_1_decay_data.csv:
	wolframscript -file swap_decay_rate.wls

fig_1_inset.csv:
	wolframscript -file swap_coefficient.wls

fig2: fig_2a_data.csv fig_2b_data.csv

fig_2a_data.csv:
	wolframscript -file effective_evolution.wls 10 0 /fig_2a

fig_2b_data.csv:
	wolframscript -file effective_evolution.wls 500 0 /fig_2b

fig3: fig_3a_data.csv fig_3b_data.csv

fig_3a_data.csv:
	wolframscript -file effective_evolution.wls 10 1 /fig_3a

fig_3b_data.csv:
	wolframscript -file effective_evolution.wls 500 1 /fig_3b

fig4: fig_4_ising_data.csv

fig_4_ising_data.csv:
	wolframscript -file ising.wls

fig5: fig_5_convergence.csv

fig_5_convergence.csv:
	wolframscript -file ising_convergence.wls


clean:
	rm -f fig_*.csv
