# Project no longer under active development. 

Use only as a reference / inspiration.

You can find my current personal emacs configuration here:
https://github.com/senny/emacs.d

---

<p align="center">
  <img
  src="https://raw.githubusercontent.com/senny/cabbage/master/misc/logo.png"
  alt="Cabbage Logo"/>
</p>

<p align="center">
  <blockquote>get the maximum out of emacs</blockquote>
</p>

Cabbage helps you to manage your emacs configuration and allows you to stay in sync with other fellow emacs users. It is designed to be a community-driven framework to build your emacs configuration. The ultimate goal of cabbage is to provide a hassle-free, fast and robust emacs setup.

***

- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Automatic installation](#automatic-installation)
  - [Manual installation](#manual-installation)
  - [Microsoft Windows](#microsoft-windows)
- [Bundles](#bundles)
  - [Local bundles](#local-bundles)
  - [Bundle contribution](#bundle-contribution)
- [Google Group](#google-group)
- [Cheat Sheet](#cheat-sheet)
- [Contributions](#contributions)

## Installation

### Prerequisites

We want to get Cabbage working under as many different circumstances as possible.
We are aiming to make the configuration as platform independent as possible.
So all you need to use cabbage is Emacs 24 or later.

### Automatic installation

```shell
$ /usr/bin/env bash -c "$(curl -fsSL https://raw.github.com/senny/cabbage/master/scripts/install.sh)"
```

### Manual installation

```shell
$ git clone https://github.com/senny/cabbage.git
$ cd cabbage
$ ./scripts/install.sh
```

### Microsoft Windows

If youre under Microsoft Windows, please follow the [Windows installation](MICROSOFT_WINDOWS.md) guide.

## Bundles

Cabbage fundamental organization are bundles. You can enable and disable the configuration on a per bundle basis.
The bundles live in `cabbage/bundles`. The active bundles are configured in your `~/.emacs.d/config.el` file in the `cabbage-bundles` variable.
Check out the [bundles directory](https://github.com/senny/cabbage/tree/master/bundles) to see whats currently available.

### Local bundles

It also to create private / local bundles if something does not belong
into the cabbage core. It is quite easy:

- Create a local bundles directory, e.g. `~/.emacs.d/bundles`
- Create your bundle, for example
  `~/.emacs.d/bundles/secret-stuff/bundle.el`
- Register the bundles directory at the top of your `~/.emacs.d/local.el` by adding this line:

```el
(add-to-list 'cabbage-bundle-dirs (expand-file-name "~/.emacs.d/bundles/"))
```

- Add `secret-stuff` to your bundles list in `~/.emacs.d/config.el`
- You can also create a local vendors directory and
  register it with:

```el
(add-to-list 'cabbage-vendor-dirs (expand-file-name "~/.emacs.d/vendor/"))
```

- Take a look on how the [existing](https://github.com/senny/cabbage/tree/master/bundles) bundles work.

### Bundle contribution

If you got a pice of emacs functionality, that you think might be usefull for
other people, please package it up in a bundle and open a
pull-request on the [cabbage-contrib](https://github.com/senny/cabbage-contrib) repository.

## Google Group

There is a Cabbage
[Google Group](https://groups.google.com/forum/#!forum/emacs-cabbage) where you
can find anything related to Cabbage. Ask your questions or bring your ideas
into the Cabbage project.

## Cheat Sheet

There is a [cheat-sheet](misc/cheat-sheet.pdf) available for the default keyboard
shortcuts that come with cabbage.

## Contributions

If you are interested in helping out, please have a look at our [Contribution Guidelines](CONTRIBUTING.md).
