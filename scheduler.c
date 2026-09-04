#include "desc.h"
#include "tcb.h"

#define MAX_TASKS 4
#define STACK_SIZE 2048

TCB task_table[MAX_TASKS];
uint8_t task_stacks[MAX_TASKS][STACK_SIZE];
uint32_t total_tasks = 0;

//Warn
volatile TCB *current_tcb = 0;

extern uint32_t __global_pointer$;

void task_exit(void)
{
	while (1);
}

void task_create(void (*task_code)(void))
{
	if (total_tasks >= MAX_TASKS)
		return;

	uint32_t id = total_tasks;
	TCB *tcb = &task_table[id];

	uint32_t *stk = (uint32_t *)(&task_stacks[id][STACK_SIZE]);

	stk -= 32;

	Context *ctx = (Context *)stk;

	uint32_t *ctx_ptr = (uint32_t *)ctx;
	for (int i = 0; i < 32; i++)
		ctx_ptr[i] = 0;

	ctx->mepc	= (uint32_t)task_code;
	ctx->ra		= (uint32_t)task_exit;
	ctx->gp		= (uint32_t)&__global_pointer$;

	tcb->stack_ptr = (void *)stk;
	tcb->task_id = id;
	tcb->state = 0;

	total_tasks++;
}

volatile uint32_t current_task_index = 0;

void schedule(void) {
    if (total_tasks == 0) return;

    // Ищем следующую задачу по кругу
    uint32_t next_index = (current_task_index + 1) % total_tasks;

    // В простом случае берем ее сразу (все задачи считаем готовыми)
    current_task_index = next_index;

    // Переключаем глобальный указатель! 
    // Наш ассемблерный exception_handler увидит это изменение и восстановит стек новой задачи
    current_tcb = &task_table[current_task_index];
}

