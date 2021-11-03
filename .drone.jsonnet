local docker_base = 'registry.oxen.rocks/lokinet-ci-';
local submodule_commands = ['git fetch --tags', 'git submodule update --init --recursive --depth=1 --jobs=4'];
local submodules = {
  name: 'submodules',
  image: 'drone/git',
  commands: submodule_commands,
};

[
  {
    name: 'Debug',
    kind: 'pipeline',
    type: 'docker',
    steps: [
      submodules,
      {
        name: 'Nano S',
        image: docker_base + 'ledger-builder',
        pull: 'always',
        commands: [
          'echo "Building on ${DRONE_STAGE_MACHINE}"',
          'make CLANGPATH=/usr/lib/llvm-12/bin/ DEBUG=1 nanos',
        ],
      },
      {
        name: 'Nano X',
        image: docker_base + 'ledger-builder',
        pull: 'always',
        commands: [
          'echo "Building on ${DRONE_STAGE_MACHINE}"',
          'make CLANGPATH=/usr/lib/llvm-12/bin/ DEBUG=1 nanox',
        ],
      },
      {
        name: 'Upload',
        image: docker_base + 'debian-stable-builder',
        pull: 'always',
        environment: { SSH_KEY: { from_secret: 'SSH_KEY' } },
        commands: [
          './tools/ci/drone-upload.sh debug',
        ],
      },
    ],
  },
  {
    name: 'Non-Debug',
    kind: 'pipeline',
    type: 'docker',
    steps: [
      submodules,
      {
        name: 'Nano S',
        image: docker_base + 'ledger-builder',
        pull: 'always',
        commands: [
          'echo "Building on ${DRONE_STAGE_MACHINE}"',
          'make CLANGPATH=/usr/lib/llvm-12/bin/ nanos',
        ],
      },
      {
        name: 'Nano X',
        image: docker_base + 'ledger-builder',
        pull: 'always',
        commands: [
          'echo "Building on ${DRONE_STAGE_MACHINE}"',
          'make CLANGPATH=/usr/lib/llvm-12/bin/ nanox',
        ],
      },
      {
        name: 'Upload',
        image: docker_base + 'debian-stable-builder',
        pull: 'always',
        environment: { SSH_KEY: { from_secret: 'SSH_KEY' } },
        commands: [
          './tools/ci/drone-upload.sh',
        ],
      },
    ],
  },
]
