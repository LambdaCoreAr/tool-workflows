const { test } = require('node:test');
const assert = require('node:assert');
const f = require('./index.js');

test('returns one', () => { assert.strictEqual(f(), 1); });
