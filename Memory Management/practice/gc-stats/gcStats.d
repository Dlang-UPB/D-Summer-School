import std.concurrency;
import core.thread;

void monitor() {
    import std.stdio : writeln, write;
    import core.memory;

    size_t seconds = 0;
    while (true) {
        write(seconds); write(": using "); write(GC.stats().usedSize); writeln(" MB");
        seconds++;
        Thread.sleep(dur!("seconds")(1));
    }
}

void main() {
    spawn(&monitor);

    while (true)
    {
        int[] a = new int[](100);
    }
}
