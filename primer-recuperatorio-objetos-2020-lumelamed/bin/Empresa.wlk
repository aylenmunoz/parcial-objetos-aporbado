import Usuario.*
import Descarga.*

object empresaDeComerc {
	var usuariosRegistrados = #{}
	
	method calcularPrecio(unProducto, unUsuario){
		const derechosDeAutor = unProducto.montoPorDerechosDeAutor()
		const montoEmpresaDelUsuario = unUsuario.cobroDeSuEmpresaPorDescarga(derechosDeAutor)
		const montoEmpresaDeComerc = self.gananciaPorDescarga(derechosDeAutor)
		
		const precio = derechosDeAutor + montoEmpresaDelUsuario + montoEmpresaDeComerc
		
		const recargo = unUsuario.precioRecargo(precio)
		
		return precio + recargo
	}
	
	method gananciaPorDescarga(montoPorDerechosDeAutor){
		return montoPorDerechosDeAutor * 0.25
	}
	
	method registrarDescarga(unProducto, unUsuario){
		const montoAPagar = self.calcularPrecio(unProducto, unUsuario)
		
		if(!unUsuario.puedeRealizarLaDescarga(montoAPagar)){
			throw new Exception(message = "El usuario no puede pagar la descarga")
		}
		
		const descarga = new Descarga(producto = unProducto, fecha = new Date())
		
		unUsuario.descargarse(descarga, montoAPagar)
	}
	
	method productoMasDescargado(unaFecha){
		const descargasQueOcurrieronEnXFecha = usuariosRegistrados.map { usuario => usuario.descargas() }.filter { descarga => descarga.fecha() == unaFecha }
		
		if(descargasQueOcurrieronEnXFecha.isEmpty()){ // evito un posible error si esta lista esta vacia 
			throw new Exception(message = "No ocurrieron descargas en la fecha indicada")
		}
		
		const productosDeEsasDescargas = descargasQueOcurrieronEnXFecha.map { descarga => descarga.producto() }
		return productosDeEsasDescargas.max { producto => productosDeEsasDescargas.occurrencesOf(producto) }
	}
}


// Productos que ofrece la empresa

class Ringtone {
	const precioPorMinutoDelAutor
	const duracion
	//const autor
	
	method montoPorDerechosDeAutor(){
		return precioPorMinutoDelAutor * duracion
	}
}

class Chiste {
	const elChiste // un string con el chiste en si
	const montoFijo
	
	method montoPorDerechosDeAutor(){
		return elChiste.size() * montoFijo
	}
}

class Juego {
	const monto
	
	method montoPorDerechosDeAutor(){
		return monto
	}
}