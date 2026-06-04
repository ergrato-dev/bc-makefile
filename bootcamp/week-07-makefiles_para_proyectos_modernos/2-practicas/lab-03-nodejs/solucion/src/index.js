function saludar(nombre) {
  return `Hola, ${nombre}!`;
}

function sumar(a, b) {
  return a + b;
}

module.exports = { saludar, sumar };

if (require.main === module) {
  console.log(saludar('mundo'));
  console.log(`2 + 3 = ${sumar(2, 3)}`);
}
