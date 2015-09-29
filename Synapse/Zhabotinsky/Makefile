all : simulate plot
	echo "done"

simulate : ./camkii.py ./camkii.yacml
	python camkii.py   | tee __log__.txt

plot :  camkii.yacml.dat  camkii.yacml
	~/Scripts/plot_csv.py -i camkii.yacml.dat -y 1-20 -s -o camkii.yacml.png
