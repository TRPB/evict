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
/users/tom/
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
          evict.homeManagerModules.evict
          ./configuration.nix
        ];
      };
    };
}
```

This adds the `home.evict` option.

2. Enable evict for your user somewhere in your nix config:

```nix
home-manager.users.<name>.home.evict = true;
```
On its own this will split config and your files into, for example:

```
/home/<name>/home 
/home/<name>/config
```

and default your home directory to `/home/<name>/home`

2a. If you don't want `/home/x/home' and want `/users/x/home` or similar, set the default user home directory:

```nix
users.defaultUserHome = "/users";
```

3. After login, you need to set the environment variable `HOME=/users/name/home` inside your desktop environment/login shell.

Currently this is done automatically when:

- You log in via TTY/SSH and start a bash/zsh interactive shell. Requires `home-manager.users.<name>.programs.bash.enable` or `home-manager.users.<name>.programs.zsh.enable` depending on your login shell. This can then still automatically launch a desktop environment via `.bashrc` or equivalent.

- Hyprland when `home-manager.users.<name>.wayland.windowManager.hyprland.enable` is set, regardless of how it is launched

In any other case you will need to look up how to set the `HOME` variable within your desktop environment and set it to `"${config.home-manager.users.<name>.homeDirectory}/${config.home-manager.users.<name>.homeDirectoryName}"` or the hardcoded path to your new reorganised home directory e.g. `/users/tom/home`.

Pull requests are welcome for new automatic configurations!


3. Log out and back in

## Available options

```nix
home-managers.users.<name>.home.evict.enable  -   boolean - Enable evicting dotfiles for user <name>
home-managers.users.<name>.home.homeDirName  -   string  - Home directory name, default `home`. Will be placed inside $rootDir
home-managers.users.<name>.configDirName  -   string  - Config directory name, default `config`. Will be placed inside $rootdir
```


## FAQ

#### Q. Does my terminal and open/save dialogs default to the new home directory `/users/<name>/home`.

A. Yes. But please see limitations section below, you may need to manually set `HOME` for your desktop environment 


## Limitations

1. You will probably need to manually set HOME inside your desktop environment (see above). This can be done either at the display manager or desktop environment level

2. Some packages do not respect XDG paths (the .config directory), these need to be handled on a case by case basis.

The plan is to provide pre-rehomed packages (POC example for Steam and Firefox incoming soon) for those stuborn applications which don't use XDG.

3. Some applications which run before login will write to the root directory (e.g. `/users/tom` instead of being banished to `/users/tom/config`). This may be addressed in future but the primary goal is to keep the files you purposely chose to create isolated from the rest so it's not a huge problem as you'll rarely if ever encounter them.

4. If you use XDG to create directories inside `home` e.g. `Downloads`, `Music`, etc, you will need to specify the new path using `home-manager.users.<name>.xdg.userDirs.downloads = "/users/<name>/home/Downloads"` or similar.

## Further reading

Take a look at my initial implementation and some discussion on the topic: https://r.je/evict-your-darlings

## Known issues

1. home-manager sometimes complains that HOME is not what is expected

Workrounds (pick one):

1. Reboot (sometimes just works)
2. Create a new user and use that going forward
3. Remove all dotfiles and rebuild/reboot 

Issue tracking: https://github.com/TRPB/evict/issues/1


