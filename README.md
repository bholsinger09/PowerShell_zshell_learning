# Zshell DevOps Automation for macOS

A comprehensive guide and collection of Zshell scripts for learning DevOps automation on macOS, from startup routines to performance management.

## Project Goals

Learn to write robust Zshell scripts that automate:
- **System Performance Monitoring** - CPU, memory, disk usage checks
- **Application Management** - Launch, close, and manage applications
- **Startup Automation** - Automated tasks on system boot
- **System Health Checks** - Battery, connectivity, storage status
- **Process Management** - Monitor and manage running processes
- **Log Analysis** - Parse and analyze system and application logs

## Project Structure

```
.
├── README.md                          # This file
├── BEST_PRACTICES.md                  # Zshell scripting best practices
├── docs/
│   ├── setup-guide.md                # Initial setup and configuration
│   ├── macos-automation.md           # macOS-specific automation tips
│   └── debugging.md                  # Debugging Zshell scripts
├── scripts/
│   ├── startup/                      # Startup automation scripts
│   ├── monitoring/                   # Performance and health monitoring
│   ├── applications/                 # Application management
│   ├── utilities/                    # General utility scripts
│   └── lib/                          # Shared libraries and functions
├── examples/
│   ├── basic/                        # Basic Zshell concepts
│   ├── intermediate/                 # More complex examples
│   └── advanced/                     # Advanced patterns
└── config/
    ├── .zshrc-additions              # Additions for .zshrc
    └── startup-launchd/              # LaunchD configurations for startup tasks
```

## Quick Start

1. **Review Best Practices**: Read `BEST_PRACTICES.md` first
2. **Setup**: Follow `docs/setup-guide.md`
3. **Learn Examples**: Start with `examples/basic/`
4. **Create Scripts**: Build scripts in appropriate `scripts/` subdirectories

## Requirements

- macOS (10.13+)
- Zshell (zsh) - default on modern macOS
- Basic Unix/Linux knowledge
- Administrator access for some tasks

## Core Concepts

- Error handling and validation
- Logging and output formatting
- Script modularity and reusability
- Safe operations (dry-run modes, backups)
- Performance considerations

## Contributing

As you learn, document your findings and add new scripts to share your knowledge!

---

**Note**: Always test scripts in a safe environment first, especially automation that affects system startup or critical processes.
