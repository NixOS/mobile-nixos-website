## Mobile NixOS Website

This repository is used to serve the website.

The [main repository](https://github.com/NixOS/mobile-nixos) is where you may want to go.

### Building the website

```
 $ nix-build release.nix
```

Though if you're working on it, you might want to edit `release.nix` to point to
your work-in-progress `mobile-nixos` repository.
