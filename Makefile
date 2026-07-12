include spec/.shared/neovim-plugin.mk

spec/.shared/neovim-plugin.mk:
	git clone https://github.com/notomo/workflow.git --depth 1 spec/.shared

HLMSG_TEST_LOG:=${SPEC_DIR}/test.log
test: FORCE deps
	rm -f ${HLMSG_TEST_LOG}
	HLMSG_TEST_LOG=${HLMSG_TEST_LOG} ${NTF} ${SPEC_DIR}
