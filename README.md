# Evict - Remove dotfiles from your nixos home directory

## Project goals:

Convert the standard file structure:

```
/home/tom/
    - .config/
    - .local/
    - .cache/
    - .mozilla/
    - .bashrc
    - .zprofile
    . .so-many-dotfiles
    - Documents/
    - Music/
    - Projects/
    - Downloads/
```

Into a separation of the files you actually created on your computer from the ones you didn't e.g. with the default settings:

```
/users/tom
    - home/
        - Documents/
        - Music/
        - Projects/
        - Downloads/
    - config/
        - .config/
        - .local/
        - .cache/
        - .mozilla/       
```

When you open programs, terminals etc, it will default to the `/users/tom/home` directory 


## Why?

1. Dotfiles are messy. Backing up the entire home directory can end up backing up 120gb of games that happen to be in `~/.local/share/Steam`, gigabytes of emails from the `.thunderbird` directory or `.cache` that I really don't care about. If your UI has hidden files enabled (for some reason my GTK open dialog often seems to default to this) you have to scroll through dozens of dotfiles.


2. On NixOS these are all generated from the NixOS configuration. I don't ever need to look at, edit or back up the files. I'm using impermenance, they are a bunch of symlinks that get destroyed and recreated every boot, I don't need to know they exist at all.

## Requirements

- NixOS 
- Home Manager

## Usage

### This should be considered somewhat experimental. I have been running this config for over a year without issue but ymmv. It is highly recommended to create a new user for testing before switching your primary user account.

1. Import the module into your flake.nix:

```nix
{
  description = "Your flake.nix";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
        url = "github:nix-community/home-manager/release-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    evict = {
        url = "github:trpb/evict";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      evict,
      ...
    }@inputs:
    {
      nixosConfigurations.yourSystem = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          evict.nixosModules.evict
          ./configuration.nix
        ];
      };
    };
}
```

2. Enable evict for your user somewhere in your nix config:

```nix
evict.users.tom.enable = true;
```

3. Log out and back in

## Available options

```nix
evict.users.<name>.enable  -   boolean - Enable evicting dotfiles for user <name>
evict.users.<name>.rootDir  -   string  - Root directory for your user. Default `/users/<name>`
evict.users.<name>.homeDirName  -   string  - Home directory name, default `home`. Will be placed inside $rootDir
evict.users.<name>.configDirName  -   string  - Config directory name, default `config`. Will be placed inside $rootdir
```

## Limitations

1. Although `HOME` should be set via systemd for display managers you may need to update `HOME` within your desktop environment directly.

e.g. in hyprland you can add 

```
env=HOME,/users/tom/home
```

This can be done either at the display manager or desktop environment level

Please create an issue with your display manager or desktop environement and how this is done and I'll and an option to automate it :) I don't have the resources to go through every possible combination myself and determine how to apply it but I'll update the code with an option for your DE if you tell me how the variable needs to be set.

2. Some packages do not respect XDG paths (the .config directory), these need to be handled on a case by case basis.

The plan is to provide pre-rehomed packages (POC example for Steam and Firefox incoming soon) for those stuborn applications which don't use XDG.

3. Some applications which run before login will write to the root directory (e.g. `/users/tom` instead of being banished to `/users/tom/config`). This may be addressed in future but the primary goal is to keep the files you purposely chose to create isolated from the rest so it's not a huge problem as you'll rarely if ever encounter them.

## Further reading

Take a look at my initial implementation and some discussion on the topic: https://r.je/evict-your-darlings


