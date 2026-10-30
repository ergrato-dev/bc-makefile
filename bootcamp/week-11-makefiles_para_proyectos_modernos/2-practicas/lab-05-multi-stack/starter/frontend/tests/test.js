const { saludar } = require('../src/index');

function assert(condition, mensaje) {
  if (!condition) { console.error(`FAIL: ${mensaje}`); process.exit(1); }
  console.log(`PASS: ${mensaje}`);
}

assert(saludar('mundo') === 'Hola desde frontend, mundo!', 'saludar retorna saludo correcto');
console.log('Todos los tests pasaron.');
