class EmpresaNacional {
	
	method cobroPorDescarga(montoDerechosDeAutor){
		return montoDerechosDeAutor * 0.05
	}
}

class EmpresaExtranjera inherits EmpresaNacional {
	const impuestoDePrestacion
	
	override method cobroPorDescarga(montoDerechosDeAutor){
		return super(montoDerechosDeAutor) + impuestoDePrestacion
	}
}
