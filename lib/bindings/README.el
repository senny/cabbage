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

## How?

### Theme definitions

(e-max-bindings-make-theme
 "my bindings"

 ;; ...definitions...
 )
