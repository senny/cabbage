# e-max: Binding API

## Why?

We want to make sure that e-max can be used with the keybindings you prefer.
To achieve this goal we want to provide a framework to define your own set of bindings.

## What?

The following features are provided by the e-max binding API.

* bindings are treated like color-themes. You can choose the "binding-theme" you want.
* bindings are setup at the beginning of the init-process so that you can navigate even when initializing fails.
* It should be possible to switch the binding-theme in a running session (for example when pairing)
* "binding-themes" can be divided into subsets which can be required by other "binding-themes"
* e-max ships with a set of pre-defined "binding-themes". You can put your own themes into (~/.emacs.d/bindings)
* it should be possible to completely deactivate the binding api so that it's easier to switch to e-max with an existing configuration.

## ToDo

* support local-bindings / mode-specific bindings
* allow themes to have dependent-themes to combine or extend existing themes

## How?

;;;; define your color-theme
(e-max-bindings-make-theme
 "my bindings"

 ;; sticky bindings are always active. They can't bi hidden by local-keymaps
 (sticky "M-j" backward-char)

 ;; global bindings are globally defined but can be hidden behind local-keymaps
 (global "TAB" e-max-smart-tab)
 )

;;;; set the color-theme you want
(setq e-max-binding-theme "ergonomic")

;;;; you can also activate any theme with
(e-max-bindings-activate)

;;;; if you don't want to use the bindings API at all
(setq e-max-binding-theme nil)
;;;; you can also disable the bindings-api anytime you want
(e-max-bindings-deactivate)

## Internals

sticky bindings are stored in a separate keymap. They are added to the variable `emulation-mode-map-alists` when activated.
