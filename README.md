# FortranCodespace
Pre-configured Codespace to work with Fortran codes used by the GTF group at IPQA.

## Motivation
Sometimes getting a proper setup to run Fortran codes for a new learner can be
problematic, here we made a template with the basics things that any new
Modern Fortran project should have (and some extra things that we use on our
research group)

## Setting up the Codespace
To set up the Codespace on your account just click on "Open in a Codespace" from the "Use this template button" 

---
![image](https://github.com/ipqa-research/FortranCodespace/assets/24468661/58ecffc8-d368-47a1-9531-a70c396ea04a)
---

## Running code
Once the Codespace is set up, run:

```
fpm run
```
in the terminal to run the example program defined in [app/main.f90](app/main.f90).

Extra programs can be created on the [app](app) directory and be run like

```
fpm run "your-file-name-here"
```

## Debugging
This Codespace comes with three pre-configured debugging options:

![image](https://github.com/ipqa-research/FortranCodespace/assets/24468661/ab561348-9ae2-4789-bfaa-99e21b7a15a7)


- `(gdb) Launch`: Debugs the [app/main.f90](app/main.f90) program
- `(gdb) Launch Example`: Debugs the [example/example.f90](example/example.f90) program
- `(gdb) Launch Test`: Debugs the currently open test file (that should be on the [test](test) directory)
