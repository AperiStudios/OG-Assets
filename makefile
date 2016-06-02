.PHONY: buildmodels models gui jarlist binaries textures shaders input
all: | clean models gui textures binaries jarlist shaders input

clean:
	rm assets.zip

buildmodels: $(addsuffix .dae, $(basename $(wildcard mod/*.blend)))

mod/%.dae: mod/%.blend
	~/blender/blender -b $< -P ~/blender/exportColl.py

models: buildmodels
	ls -l mod
	zip -r assets.zip mod/*.dae

gui: $(shell find gui -name "*.xml")
	zip -r assets.zip gui/*.xml

jarlist:
	zip -r assets.zip jarlist

binaries: $(shell find bin -type f)
	zip -r assets.zip bin

textures: $(shell find tex -name "*.png")
	zip -r assets.zip tex/*.png

shaders: $(shell find sdr -type f)
	zip -r assets.zip sdr

input: $(shell find input -type f)
	zip -r assets.zip input

