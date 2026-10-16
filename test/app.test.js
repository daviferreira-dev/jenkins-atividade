const test = require('node:test');
const assert = require('node:assert');
const { createApp } = require('../src/app');

function get(path) {
  return new Promise((resolve, reject) => {
    const server = createApp().listen(0, () => {
      fetch(`http://127.0.0.1:${server.address().port}${path}`)
        .then(async (r) => resolve({ status: r.status, body: await r.json() }))
        .catch(reject)
        .finally(() => server.close());
    });
  });
}

test('/health responde 200 com status ok', async () => {
  const r = await get('/health');
  assert.strictEqual(r.status, 200);
  assert.strictEqual(r.body.status, 'ok');
});

test('rota desconhecida responde 404', async () => {
  const r = await get('/nada');
  assert.strictEqual(r.status, 404);
});
