# scientific-env

[TODO] look at the todos
[TODO] fix default template

Setup per project scientific development environments with ease, without dependency conflicts or messing up your global environment, all while preserving whatever sanity you have left!

## Features

- Python - Excellent support for using Python via [uv](https://docs.astral.sh/uv)
- Julia - Just Works™. Support for X11 dependant packages via [xwayland-satellite](https://github.com/Supreeeme/xwayland-satellite) (looking at you `GLMakie`).
- Configure painlessly with a single file `config.nix`. Get messy with nix when you want to!
- Straightforward to extend to a new language, with modules (PRs are welcome!).

## Getting started

0. Install [Nix](https://nixos.org/download/) if you don't have it already. Make sure to enable flakes support by adding the following to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

1. We have two templates, pick your poison:

- Default template: Bare minimum to get you started. Initialize it with:
```bash
nix flake init -t github:Vortriz/scientific-env#default
```

- Opinionated template: Comes with a set of tools that I prefer to use, which includes:
    - [marimo](https://marimo.io) - A Jupyter-like notebook for python which is just plain better. Additional configuration for it is also included.
    - [typst](https://typst.app) - A modern typesetting language with instant preview and intuitive syntax.

    Initialize it with:
    ```bash
    nix flake init -t github:Vortriz/scientific-env#opinionated
    ```

The welcome message will guide you further for setup.

2. After configuring the template, you can run the following command to enter the environment:

```bash
nix develop
```

If you have [direnv](https://direnv.net) installed, then just `direnv allow` the project.

## Configuration

> [!NOTE]
> Run `nix develop` or `direnv allow` after modifying `config.nix` to apply the changes.

The configuration is done in `config.nix`. You can add or remove languages, tools, and other dependencies as needed.

Following is a sample `config.nix` with all the options you can set:

```nix

```

## Suggested workflow

### Python

Initialize a new python project with `uv`:

```bash
uv init --bare
```

Python version can be configured in `config.nix`. Python dependencies can be added via `uv add` command. They can be updated with `uv lock -U`. Python tools should not be installed via `uv tool install` and instead be added to `config.nix` via `lang.python.extraPackages`.

#### Marimo

If you want to use marimo, you can create a new notebook with:

```bash
uv run marimo new
```

The package management for marimo is configured to be done via `uv`, so that your `pyproject.toml` are automatically updated when you add packages in the notebook.

For subsequent runs, you can just use:

```bash
uv run marimo edit
```

### Julia

Add the following to `~/.julia/config/startup.jl`

```julia
using Pkg

if isfile("Project.toml") && isfile("Manifest.toml")
    Pkg.activate(".")
end
```

This will ensure that Julia activates the project environment when you start Julia in the project directory. This way the global environment won't be accidentally polluted with project dependencies.

To use X11 dependent packages like `GLMakie`, run `xwayland-satellite` in a separate terminal.

Then Julia the way you normally would :)

## Why this?
This template is designed for painless setup, allowing you to focus on your necessary things, rather than deal with things like ✨ Dependency Hell ✨. It leverages [Nix](https://nix.dev/manual/nix/2.29) to create reproducible and isolated environments.

If one was to purely use Nix for managing all dependencies, you would never have to hear "but it works on my machine" again! But it has its own cost:

1. [Nixpkgs](https://github.com/NixOS/nixpkgs) (the package repository for nix) does not contain all the packages that would be present on, lets say pypi. Neither does it contain all released versions of them.
2. It can be an absolute pain to package something for Nix, which is especially frustrating when you just want to get something done.

So, we trade some of the "purity" of Nix for sanity. The aim is to enforce the use of better tools and practices that drive you towards a more reproducible environment.

1. For Python, we use [uv](https://docs.astral.sh/uv), which creates a [lockfile](https://docs.astral.sh/uv/concepts/projects/layout/#the-lockfile) (just like Nix) to ensure reproducibility. The python binary itself is patched via [uv2nix](https://pyproject-nix.github.io/uv2nix). This way we can use full range of packages available on pypi. You can go one step ahead and use [marimo](https://marimo.io) for notebooks instead of Jupyter.
2. Julia has a much better package management system out-of-the-box than Python. This template just does minimal work by adding xwayland-satellite and some environment configuration.

Added benefit of this template is that you can have multiple languages in the same project and toggle them at will.
