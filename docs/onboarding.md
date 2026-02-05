# For Developers how to get started

To work on the project you will need to install (Windows links):
- [Godot](https://godotengine.org/download/windows)
- [git](https://git-scm.com/install/windows)
- [git-lfs](https://git-lfs.com/)

## Post-install setup

Create a github account and setup git by running these commands.
For ssh-keygen you can use default values and not use a password. Just check where .pub file is stored.

```
git config --global user.name "myusername123"
git config --global user.email "myemail123@gmail.com"
ssh-keygen -t ed25519 -C "myemail123@gmail.com"
```

Go to `github.com > Settings > SSH and GPG keys > New SSH key > Put some title > paste in key from generated .pub file`

Open git bash terminal, go to project directory and setup your environment:

```bash
cd your-project-dir
git clone https://github.com/BananaTeam-dev/age-of-war
cd age-of-war
git lfs install
```
