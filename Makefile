PLUGIN_NAME:=$(basename $(notdir $(abspath .)))
SPEC_DIR:=./spec/lua/${PLUGIN_NAME}
HLMSG_TEST_LOG:=${SPEC_DIR}/test.log

test:
	rm -f ${HLMSG_TEST_LOG}
	# hard to test in headless?
	HLMSG_TEST_LOG=${HLMSG_TEST_LOG} VUSTED_ARGS=--clean vusted --shuffle
.PHONY: test

vendor:
	nvim --headless -i NONE -n +"lua require('vendorlib').install('${PLUGIN_NAME}', '${SPEC_DIR}/vendorlib.lua')" +"quitall!"
.PHONY: vendor
