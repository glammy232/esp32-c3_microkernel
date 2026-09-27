struct context {
	uint32_t ra;	/* return address */
	uint32_t sp;	/* stack pointer */

	/* callee-saved registers - save when context switch perform */
	uint32_t s0;
	uint32_t s1;
	uint32_t s2;
	uint32_t s3;
	uint32_t s4;
	uint32_t s5;
	uint32_t s6;
	uint32_t s7;
	uint32_t s8;
	uint32_t s9;
	uint32_t s10;
	uint32_t s11;
};

enum proc_state { RUNNING, READY, BLOCKED };

struct proc {
	uint32_t pid;			/* process ID */
	enum proc_state state;	/* process state */
	struct context context;	/* switch() here to run process */
	uint32_t size;			/* size of process memory(bytes) */
};
