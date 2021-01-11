import Descarga.*
import Empresa.*
import EmpresasDeTelecomunicaciones.*

class Usuario {
	const empresaDeTelecomunicaciones // supongo que no se cambia de empresa, por eso const
	var tipoDeUsuario
	var dineroGastado // para "facturado"		// el saldo y el montoGastado son propiedades del plan, no del usuario!
	var saldo // para "prepago"
	var descargas = []

	method descargas(){
		return descargas
	}

	method puedeRealizarLaDescarga(precioDescarga){
		return tipoDeUsuario.puedeRealizarLaDescarga(precioDescarga, saldo)
	}

	method precioRecargo(monto){
		return tipoDeUsuario.precioRecargo(monto)
	}

	method pagarDescarga(precio){
		tipoDeUsuario.pagar(precio, self)
	}

	method actualizarSaldo(monto){
		saldo -= monto
	}

	method acumularDineroGastado(monto){
		dineroGastado += monto
	}

	method cobroDeSuEmpresaPorDescarga(montoDerechosDeAutor){
		return empresaDeTelecomunicaciones.cobroPorDescarga(montoDerechosDeAutor)
	}

	method agregarDescarga(unaDescarga){
		descargas.add(unaDescarga)
	}

	method descargarse(unaDescarga, precio){
		self.agregarDescarga(unaDescarga)
		self.pagarDescarga(precio)
	}

	method cuantoGastoEnDescargasEsteMes(){
		const mesActual = new Date().month()
		const descargasDelMes = descargas.filter { descarga => descarga.fecha().month() == mesActual }
		const gastosDeLasDescargasDelMes = descargasDelMes.map { descarga => empresaDeComerc.calcularPrecio(descarga.producto(), self) }	// estaría bueno delegar el precio sobre la descarga, en vez de meterse con sus atributos (encapsulamiento)
		return gastosDeLasDescargasDelMes.sum()
	}

	method esColgado(){
		const productosDescargados = descargas.map { descarga => descarga.producto() }

		return productosDescargados.any{ producto => productosDescargados.occurrencesof(producto) > 1}
	}
}


// Tipos de Usuario

object prepago {

	method precioRecargo(monto){
		return monto * 0.1
	}

	method puedeRealizarLaDescarga(precioDescarga, saldo){
		return saldo >= precioDescarga
	}

	method pagar(precio, usuario){
		usuario.actualizarSaldo(precio)
	}
}

object facturado {

	method precioRecargo(monto){
		return 0 // no se les cobra recargo
	}

	method puedeRealizarLaDescarga(precioDescarga, saldo){
		return true
	}

	method pagar(precio, usuario){
		usuario.acumularDineroGastado(precio)
	}
}
