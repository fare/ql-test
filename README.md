# ql-test

This library contains various functions I use to test that
my ASDF and UIOP infrastructure changes don't break
too many CL systems in [Quicklisp](https://www.quiclisp.org/).

There isn't much here actually.
Use [cl-test-grid](https://github.com/cl-test-grid/cl-test-grid) instead.

[TOC]

## `load-quicklisp`

The system `load-quicklisp` will load quicklisp while evaluating its `.asd` file,
ensuring that quicklisp is present when examining further dependencies.
You can put it first among your dependencies, and/or
load it before you try to load the rest.

## `ql-test`

The following functions are exported from package `ql-test`
when loading system `ql-test`:

`current-quicklisp-asdf-version` lets me quickly check that Quicklisp
still distributes the antique ASDF 2.26, even though all implementations
now provide ASDF 3, that a growing number of systems depend on.

`install-all-quicklisp-provided-systems` as the name implies installs
all quicklisp provided systems, so you make grep through it when
to make sure no one uses an interface you're modifying or removing.

`test-all-quicklisp-systems` tries to test all these systems.
That will probably not work anymore, now that QL has too many systems
to fit in a single process's memory without stretching your implementation.

`clean-old-quicklisp-systems` cleans up your filesystem from the source code
of old QL systems after you install newer ones.
(NB: it doesn't clear their fasls from the fasl cache.)
