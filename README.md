## Motivation
The risk of supply-chain attacks targeting developers has risen sharply in recent years, making it no longer safe to run `npm install` in a local environment.
npm packages can easily compromise browser cookies and other local sensitive information. This is no longer a theoretical threat, but a real-world phenomenon.

The goal of this project is to securely sandbox development environments that frequently run potentially untrusted code.

JetBrains IDEs include built-in container support, but it is resource-intensive and not a security-focused feature.

## How it Works
Docker is used to isolate the development environment, including the JetBrains IDE, from the host to a certain extent.
Waypipe is used for seamless integration with the host's windowing system.
X11 is not supported and will not be supported in the future, as it completely breaks the sandbox security model.

## Security
The goal of this project is to minimize impact on the host when untrusted code is run in the IDE, without sacrificing performance.
However, because Docker was not designed for sandboxing, it may be vulnerable to certain attacks, such as side-channel attacks.
No security solution is perfect.
If you require advanced security features, we recommend considering other solutions such as virtual machines.
