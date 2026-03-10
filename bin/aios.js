#!/usr/bin/env node
// Node CLI wrapper that mirrors the shell script version, providing
// a white-label entry point for the AI OS workspace. Users install this
// package globally (`npm install -g @btslab/ai-os`) and then `aios` will be
// available on the PATH.

const { spawn } = require('child_process');
const cmd = process.env.AIOS_CMD;

if (!cmd) {
  console.error('ERROR: AIOS_CMD environment variable is not set.');
  console.error('Please point it at your underlying AI runtime CLI.');
  process.exit(1);
}

// forward all arguments to the underlying command
const child = spawn(cmd, process.argv.slice(2), { stdio: 'inherit' });

child.on('exit', (code, signal) => {
  if (signal) process.kill(process.pid, signal);
  process.exit(code);
});
