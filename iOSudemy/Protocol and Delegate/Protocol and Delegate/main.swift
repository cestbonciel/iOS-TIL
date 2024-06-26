protocol AdvancedLifeSupport {
	func perfomeCPR()
}

class EmergencyCallHandler {
	var delegate: AdvancedLifeSupport?
	
	func assessSituation() {
		print("Can you tell me what happened?")
	}
	
	func medicalEmergency() {
		delegate?.perfomeCPR()
	}
}

struct Paramedic: AdvancedLifeSupport {
	init(handler: EmergencyCallHandler) {
		handler.delegate = self
	}
	func perfomeCPR() {
		print("The paramedic does chest compressions, 30 per second.")
	}
}

class Doctor: AdvancedLifeSupport {
	
	init(handler: EmergencyCallHandler) {
		handler.delegate = self
	}
	
	func perfomeCPR() {
		print("The doctor does chest compressions, 30 per second.")
	}
	
	func useStethescope() {
		print("Listening for heart sounds.")
	}
}

class Surgeon: Doctor {
	override func perfomeCPR() {
		super.perfomeCPR()
		print("Sings staying alive by the BeeGees.")
	}
	
	func useElectricDrill() {
		print("Whirr...")
	}
}

let emilio = EmergencyCallHandler()
let angela = Surgeon(handler: emilio)

emilio.assessSituation()
emilio.medicalEmergency()

