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

struct trapframe {
    uint32_t ra;       /* return address */
    uint32_t sp;       /* stack pointer */
    uint32_t gp;       /* global pointer */
    uint32_t tp;       /* thread pointer */
	/* temporaries */
    uint32_t t0, t1, t2; // Temporaries */
	/* saved registers / frame pointer */
    uint32_t s0, s1;
	/* arguments */
    uint32_t a0;
	uint32_t a1;
	uint32_t a2;
	uint32_t a3;
	uint32_t a4;
	uint32_t a5;
	uint32_t a6;
	uint32_t a7;
	/* saved registers*/
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
	/* temporaries*/
    uint32_t t3;
	uint32_t t4;
	uint32_t t5;
	uint32_t t6;

    uint32_t mepc;    /* machine exception program counter */
    uint32_t mcause;
    uint32_t mstatus;
};

enum proc_state { RUNNING, READY, BLOCKED };

struct proc {
	uint32_t pid;			/* process ID */
	enum proc_state state;	/* process state */
	struct context context;	/* switch() here to run process */
	uint32_t size;			/* size of process memory(bytes) */

};
