if (typeof process.env.ENV === 'undefined') {
  console.error('You need to define $ENV for npm build.');
  process.exit(1);
}

const path = require('path');
const fs = require('fs-extra');
const __root = path.resolve(__dirname, '../');
const buildPath = path.resolve(__root, 'public', process.env.ENV, 'assets');

/* ビルド先のクリーニング */
fs.emptyDirSync(buildPath);
