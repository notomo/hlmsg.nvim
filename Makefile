PLUGIN_NAME:=$(basename $(notdir $(abspath .)))
SPEC_DIR:=./spec/lua/${PLUGIN_NAME}
HLMSG_TEST_LOG:=${SPEC_DIR}/test.log

test:
	rm -f ${HLMSG_TEST_LOG}
	# hard to test in headless?
	HLMSG_TEST_LOG=${HLMSG_TEST_LOG} VUSTED_ARGS=--clean vusted --shuffle
.PHONY: test

doc:
	rm -f ./doc/${PLUGIN_NAME}.nvim.txt ./README.md
	PLUGIN_NAME=${PLUGIN_NAME} nvim --headless -i NONE -n +"lua dofile('${SPEC_DIR}/doc.lua')" +"quitall!"
	cat ./doc/${PLUGIN_NAME}.nvim.txt ./README.md
.PHONY: doc

vendor:
	nvim --headless -i NONE -n +"lua require('vendorlib').install('${PLUGIN_NAME}', '${SPEC_DIR}/vendorlib.lua')" +"quitall!"
.PHONY: vendor
