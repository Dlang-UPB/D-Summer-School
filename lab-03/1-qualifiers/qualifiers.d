struct A
{
    int[10] b;
}
void munA(A) {}
void cunA(const A) {}
void iunA(immutable A) {}

struct B
{
    int[] c;
}
void munB(B) {}
void cunB(const B) {}
void iunB(immutable B) {}

class C
{
    int[10] a;
}
void munC(C) {}
void cunC(const C) {}
void iunC(immutable C) {}

class D
{
    int[] a;
}
void munD(D) {}
void cunD(const D) {}
void iunD(immutable D) {}

void main()
{
    /*******************************************
     * value type without indirections is convertible any to any
     */
    A a;
    const A ca;
    immutable A ia;
    munA(a);
    munA(ca);
    munA(ia);

    /******************************************
     * value type with indirections must obey qualifier conversion rules
     */
    B b;
    const B cb;
    immutable B ib;
    munB(b);
    munB(cb);
    munB(ib);

    cunB(b);
    cunB(cb);
    cunB(ib);

    iunB(b);
    iunB(cb);
    iunB(ib);

    /********************************************
     * reference types must obey qualifier conversion rules
     */
    C c;
    const C cc;
    immutable C ic;
    munC(c);
    munC(cc);
    munC(ic);

    cunC(c);
    cunC(cc);
    cunC(ic);

    iunC(c);
    iunC(cc);
    iunC(ic);

    /*******************************************
     * reference types must obey qualifier conversion rules
     */
    D d;
    const D cd;
    immutable D id;
    munD(d);
    munD(cd);
    munD(id);

    cunD(d);
    cunD(cd);
    cunD(id);

    iunD(d);
    iunD(cd);
    iunD(id);
}
