static void putchar(char c) {
    __asm__ volatile (
        "movb $0x0E, %%ah\n\t"
        "int $0x10"
        :
        : "a"(c)
    );
}

void print(const char *str) {
    while (*str) {
        putchar(*str++);
    }
}

void kernel_main() {
    print("Tiny Kernel v0.1");
}
