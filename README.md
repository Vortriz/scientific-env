# scientific-env

Setup per project scientific development environments with ease, without dependency conflicts or messing up your global environment, all while preserving whatever sanity you have left!

## Table of Contents
- [Features](#features)
- [Getting started](#getting-started)
- [Configuration](#configuration)
- [Usage](#usage)
    - [Python](#python)
    - [Julia](#julia)
    - [Typst](#typst)
- [Why this?](#why-this)
- [FAQs](#faqs)

## Features

- **Python** - Manage with [uv](https://docs.astral.sh/uv) and use [marimo](https://marimo.io) for reactive notebooks. 
- **Julia** - Use [Pluto](https://plutojl.org) for a plug-and-play notebook experience.
- **Typst** - A modern typesetting language with instant preview and intuitive syntax.
- Straightforward to extend to a new language, with modules. (PRs are welcome!)

## Getting started

0. Install [Nix](https://nixos.org/download) if you don't have it already. Make sure to enable flakes support by adding the following to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`:

    ```
    experimental-features = nix-command flakes
    ```

    You can learn more about Nix language [here](https://nix.dev/manual/nix/2.29/language) (by having a quick glance at the table) or [here](https://nix.dev/tutorials/nix-language) (for a more informative guide).

1. To start using the default template:

    ```bash
    nix flake init -t github:Vortriz/scientific-env#default
    ```

2. You can run any given command to enter the respective environment:

    - Python
        ```bash
        nix develop .#python -c setup
        ```
    - Julia
        ```bash
        nix develop .#julia -c update-registry
        ```
    - Typst
        ```bash
        nix develop .#typst
        ```
    - Default
        ```bash
        nix develop
        ```

    (Optional) You can also install [direnv](https://direnv.net) to auto-load the project environment whenever you enter the directory. Then just `direnv allow` the project.

## Configuration

1. Delete `nix/<some-language>` folder if you absolutely don't want to use that language in your project.
2. (Optional) If you use direnv, you can change the default environment to auto-load by modifying the `use flake .#default` line in the `.envrc` file.
    - e.g. change to `use flake .#python` to auto-load python environment
3. The default environment is blank. You can modify the `nix/default/shell.nix` file to configure it to your liking. Refer to [devshell docs](https://numtide.github.io/devshell/modules_schema.html) for more information or look at `nix/<language>/shell.nix` files for examples.

> [!NOTE]
> If you are not using direnv, make sure to run `nix develop` after every change in any file inside `nix/` folder. (or just start using direnv :P)

## Usage

### Python

The following command enters Python environment, sets up uv and marimo:

```bash
nix develop .#python -c setup
```

Create a new notebook with:

```bash
uv run marimo new
```

The package management inside marimo is also handled via `uv`, so that your `pyproject.toml` is automatically updated when you add packages in the notebook. Neat, huh?

For subsequent runs, you can just run:

```bash
uv run marimo edit
```

For more information on using marimo, try the interactive tutorials by running:

```bash
uv run marimo tutorial --help
```

or visit the quickstart guide [here](https://docs.marimo.io/getting_started/quickstart).

Marimo will automatically format the notebooks with [Ruff](https://docs.astral.sh/ruff). Configure the formatters by modifying `nix/python/fmt.nix`. A git pre-commit-hook will handle auto-formatting. You can also manually run the formatter with:

```bash
nix fmt
```

### Julia

The following command enters Julia environment and updates the package registry:

```bash
nix develop .#julia -c update-registry
```

This will take a significant time to run, since Julia is precompiling the necessary packages.

After that, create a new Pluto notebook with:

```bash
pluto
```

Julia code is formatted using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl). Configure it by modifying `nix/julia/fmt.jl`. A git pre-commit-hook will handle auto-formatting. You can also manually run the formatter with:

```bash
nix fmt
```

### Typst

Enter Typst environment with:

```bash
nix develop .#typst
```

Then you can use Typst normally.

Typst code is formatted using [typstyle](https://github.com/typstyle-rs/typstyle). Configure it by modifying `nix/typst/fmt.nix`. A git pre-commit-hook will handle auto-formatting. You can also manually run the formatter with:

```bash
nix fmt
```

## Why this?
This is a very opinionated setup that I have refined over a long time to strike a balance between the reproducibility of pure Nix environments and convenience of language specific tools. This lets me focus on the work rather than deal with ✨ Dependency Hell ✨.

If you were to purely use Nix for managing all dependencies, you would never have to hear "but it works on my machine"! But it has its own cost:

1. [Nixpkgs](https://github.com/NixOS/nixpkgs) (the package repository for nix) does not contain all the packages that would be present on, lets say PyPI. Neither does it contain all released versions of them.
2. It can be an absolute pain to package something for Nix, which is especially frustrating when you just want to get something done.

So, we trade some of the "purity" of Nix for sanity. The aim is to enforce the use of better tools and practices that drive you towards a more reproducible environment.

1. For Python, we use [uv](https://docs.astral.sh/uv), which creates a [lockfile](https://docs.astral.sh/uv/concepts/projects/layout/#the-lockfile) (just like Nix) to ensure reproducibility. We also use [marimo](https://marimo.io) notebooks instead of Jupyter, because [Jupyter is simply not made for reproducibility](https://docs.marimo.io/faq/#what-problems-does-marimo-solve).
2. [Pluto](https://plutojl.org) is to Julia what marimo is to Python - a better notebook experience that is reactive and reproducible.

Added benefit of this template is that you can have multiple languages in the same project and toggle them at will.


## FAQs

### How to change python version?

Change the python version in `nix/python/shell.nix` file. For example, to use python 3.11, change `pythonPkg` value to `pkgs.python311`. Nixpkgs supports python versions from 3.10 to 3.14.

### I dont't understand Nix, how do I configure X thing?

Refer to the [devshell docs](https://numtide.github.io/devshell/modules_schema.html) for more information on how to configure the shell.nix files. You can also look at the existing `nix/<language>/shell.nix` files for examples. Feel free to open a [Github discussion](https://github.com/Vortriz/scientific-env/discussions/categories/q-a) or hit me up on [Matrix](https://matrix.to/#/@vortriz:matrix.org).
