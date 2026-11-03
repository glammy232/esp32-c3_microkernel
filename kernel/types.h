#ifndef TYPES_H
#define TYPES_H

#if defined(__x86_64__) || defined(__LP64__) ||                               \
    (defined(__riscv) && (__riscv_xlen == 64))
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long uint64_t;

typedef signed char int8_t;
typedef signed short int16_t;
typedef signed int int32_t;
typedef signed long int64_t;

typedef unsigned long uintptr_t;
typedef unsigned long size_t;

#elif defined(__i386__) || defined(__ILP32__) ||                              \
    (defined(__riscv) && (__riscv_xlen == 32))
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

typedef signed char int8_t;
typedef signed short int16_t;
typedef signed int int32_t;
typedef signed long long int64_t;

typedef unsigned int uintptr_t;
typedef unsigned int size_t;
#else
#error                                                                        \
    "Unsupported architecture or layout. Please, configure types.h manually."
#endif

#define ASSERT_CONCAT_EXPAND(a, b) a##b
#define ASSERT_CONCAT(a, b)        ASSERT_CONCAT_EXPAND(a, b)

#define STATIC_ASSERT(expr)                                                   \
    struct ASSERT_CONCAT(compile_time_assertion_, __LINE__) {                 \
        char clbk[(expr) ? 1 : -1];                                           \
    }

STATIC_ASSERT(sizeof(uint8_t) == 1);
STATIC_ASSERT(sizeof(uint16_t) == 2);
STATIC_ASSERT(sizeof(uint32_t) == 4);
STATIC_ASSERT(sizeof(uint64_t) == 8);

#undef STATIC_ASSERT
#undef ASSERT_CONCAT
#undef ASSERT_CONCAT_EXPAND

#endif /* KERNEL_TYPES_H */
