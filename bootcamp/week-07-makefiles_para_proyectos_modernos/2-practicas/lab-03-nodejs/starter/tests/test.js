const { saludar, sumar } = require('../src/index');

function assert(condition, mensaje) {
  if (!condition) {
    console.error(`FAIL: ${mensaje}`);
    process.exit(1);
  }
  console.log(`PASS: ${mensaje}`);
}

assert(saludar('mundo') === 'Hola, mundo!', 'saludar retorna saludo correcto');
assert(saludar('Node') === 'Hola, Node!', 'saludar funciona con nombre arbitrario');
assert(sumar(2, 3) === 5, 'sumar 2+3=5');
assert(sumar(-1, 1) === 0, 'sumar con negativos');

console.log('Todos los tests pasaron.');
