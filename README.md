# WebStorm Sandbox
Sandboxed and secure WebStorm environment powered by Wayland and Docker

## Motivation
The risk of supply-chain attacks targeting developers has risen sharply in recent years, making it no longer safe to run `npm install` in a local environment.  
npm packages can easily compromise browser cookies and other local sensitive information. This is no longer a theoretical threat, but a real-world phenomenon.  

The goal of this project is to securely sandbox development environments that frequently run potentially untrusted code.  

JetBrains IDEs include built-in container support, but it is resource-intensive and not a security-focused feature.

## Usage
This requires Waypipe and Docker to be installed.  
For better security and to avoid network issues, using Rootless Docker is highly recommended.
```bash
rm /tmp/waypipe-bridge.sock && waypipe --socket /tmp/waypipe-bridge.sock client & sleep 1 && docker run -it --rm -v /tmp/waypipe-bridge.sock:/tmp/waypipe-bridge.sock:rw -v webstorm:/home --device /dev/dri --shm-size=4g ghcr.io/nexryai/webstorm-sandbox:main 
```

## How it Works
Docker is used to isolate the development environment, including the JetBrains IDE, from the host to a certain extent.  
Waypipe is used for seamless integration with the host's windowing system.  

X11 is not supported and will not be supported in the future, as it completely breaks the sandbox security model.

## Security
The goal of this project is to minimize impact on the host when untrusted code is run in the IDE, without sacrificing performance.
However, because Docker was not designed for sandboxing, it may be vulnerable to certain attacks, such as side-channel attacks.  
No security solution is perfect.  

This project has not been audited by security experts.
Running dangerous code even in a sandbox is risky, and developers should install packages with caution.  

If you require advanced security features, we recommend considering other solutions such as virtual machines.

## ToDo
 - [ ] Support for Git authentication/commit signing using SSH Agent Forwarding


## Troubleshooting

### Removing the lock file
If the program fails to start due to an error like the one below, you will need to remove the lock file.
```
Internal error

com.intellij.platform.ide.bootstrap.DirectoryLock$CannotActivateException: Process "/opt/webstorm/bin/webstorm" (15) is still running and does not respond.

If the IDE is starting up or shutting down, please try again later.
If the process seems stuck, please try killing it (WARNING: unsaved data might be lost).
```

```bash
sudo rm ~/.local/share/docker/volumes/webstorm/_data/ubuntu/.config/JetBrains/WebStorm2025.3/.lock
```

## Acknowledgments

- This project would not have been possible without [Waypipe](https://gitlab.freedesktop.org/mstoeckl/waypipe/).
- Thanks to the [Unofficial JetBrains IDE PPA](https://github.com/JonasGroeger/jetbrains-ppa).
