#include "desc.h"

#define MAX_TASKS 4

// Структура, описывающая сохраненное состояние процессора RISC-V в стеке
typedef struct {
    uint32_t ra;       // x1  - Адрес возврата из функции
    uint32_t gp;       // x3  - Global Pointer
    uint32_t tp;       // x4  - Thread Pointer
    uint32_t t0;       // x5  - Временный регистр 0
    uint32_t t1;       // x6  - Временный регистр 1
    uint32_t t2;       // x7  - Временный регистр 2
    uint32_t s0;       // x8  - Frame Pointer / Saved register 0
    uint32_t s1;       // x9  - Saved register 1
    uint32_t a0;       // x10 - Аргумент функции 0 / Возвращаемое значение
    uint32_t a1;       // x11 - Аргумент функции 1
    uint32_t a2;       // x12 - Аргумент функции 2
    uint32_t a3;       // x13 - Аргумент функции 3
    uint32_t a4;       // x14 - Аргумент функции 4
    uint32_t a5;       // x15 - Аргумент функции 5
    uint32_t a6;       // x16 - Аргумент функции 6
    uint32_t a7;       // x17 - Аргумент функции 7
    uint32_t s2;       // x18 - Saved register 2
    uint32_t s3;       // x19 - Saved register 3
    uint32_t s4;       // x20 - Saved register 4
    uint32_t s5;       // x21 - Saved register 5
    uint32_t s6;       // x22 - Saved register 6
    uint32_t s7;       // x23 - Saved register 7
    uint32_t s8;       // x24 - Saved register 8
    uint32_t s9;       // x25 - Saved register 9
    uint32_t s10;      // x26 - Saved register 10
    uint32_t s11;      // x27 - Saved register 11
    uint32_t t3;       // x28 - Временный регистр 3
    uint32_t t4;       // x29 - Временный регистр 4
    uint32_t t5;       // x30 - Временный регистр 5
    uint32_t t6;       // x31 - Временный регистр 6
    uint32_t mepc;     // Адрес инструкции, на которой задачу прервали
} Context;

// Блок управления потоком (Task Control Block)
typedef struct TCB {
    void *stack_ptr;         // Текущий указатель стека (ОБЯЗАТЕЛЬНО ПЕРВЫМ ПОЛЕМ!)
    uint32_t task_id;        // Уникальный ID задачи
    uint32_t state;          // Состояние (0 - Ready, 1 - Running, 2 - Blocked)
    // Сюда в будущем можно добавить приоритет, имя задачи и т.д.
} TCB;

extern TCB task_table[MAX_TASKS];

//volatile TCB *current_tcb = 0; // То, что выполняется прямо сейчас

